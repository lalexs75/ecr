{**************************************************************************}
{ Библиотека работы с платёжными терминалами пластиковых карт              }
{ в стандарте, предоставляемым ГазПромБанком                               }
{ Free Pascal Compiler версии 2.7.1 и Lazarus 1.2 и выше.                  }
{ Лагунов Алексей (С) 2014  alexs75.at.yandex.ru                           }
{**************************************************************************}

unit egate_class;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, egate_lib, egate_api, alexs_plastic_cards_abstract;

type
  TEGComponent = class;


  { TEGComponent }

  TEGComponent = class(TPlasticCardAbstract)
  private
    FEGHandle: integer;
    FegStatusVector: string;
    FProtocolID: integer;
    FResultCryptoMsg: string;
    FResultFlags: DWord;
    FWorkKeyPresent: boolean;
    function GetVersion: string;
    procedure DoCheckLoaded;
    procedure DoProcessError;
    function DoCheckResultMessage(S:string):boolean;
    function DoExecOper(ACmdDesc, ACmd:string):Boolean;
    procedure CheckActive;
    procedure DoDecodeFlags(AFlags:string);
  protected
    procedure SetActive(AValue: boolean);override;
    function GetWorkKeyPresent: boolean; override;
    function IsLibFileNameStored: Boolean; override;
    function GetStatusVector: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Pay(APaySum:Currency; ACheckNum:integer; APayTypeMethod:Integer); override;     //Операция № 1
    procedure Revert(ARevertSum:Currency; ACheckNum:string; APayTypeMethod:Integer); override;       //Операция № 3
    procedure Discard(ADiscardSum:Currency; ACheckNum:string; ADocID:string; APayTypeMethod:Integer); override; //Операция № 2
    procedure DiscardLastOper;
    //Отчёты
    procedure ReportOperList;override;                     //Операция № 6
    procedure ReportOperSmall;override;                    //Операция № 33
    procedure ReportItog;override;                         //Операция № 4 - Z отчёт

    //Сервисные функции
    procedure GetWorkKey; override;                        //Операция № 5
    procedure PPLoadConfig;override;                       //Операция № 35
    procedure PPLoadSoftware;override;                     //Операция № 36
    procedure EchoTest;override;                           //Операция № 24
    function PayTypeMethodName(APayTypeMethod:Integer):string; override;

    property EGHandle:integer read FEGHandle;

    property ResultCryptoMsg:string read FResultCryptoMsg;
    property ResultFlags:DWord read FResultFlags;

    property Version:string read GetVersion;
  published
    property ProtocolID:integer read FProtocolID;
  end;

procedure Register;
implementation
uses strutils, egate_consts, LResources;

{$R ../egate_class.res}

procedure Register;
begin
  RegisterComponents('TradeEquipment',[TEGComponent]);
end;

{ TEGComponent }

function TEGComponent.GetVersion: string;
begin
  DoCheckLoaded;
  Result:=EGateLibrary.egGetVersionDescription;
end;

function TEGComponent.IsLibFileNameStored: Boolean;
begin
  Result:=LibFileName = libEGateName;
end;

function TEGComponent.GetStatusVector: string;
begin
  Result:=FegStatusVector;
end;

procedure TEGComponent.SetActive(AValue: boolean);
begin
  if AValue = Active then exit;
  inherited SetActive(AValue);
  if AValue then
    InitLibrary;
end;

function TEGComponent.GetWorkKeyPresent: boolean;
begin
  Result:=FWorkKeyPresent;
end;

procedure TEGComponent.DoCheckLoaded;
begin
  if not Active then
    raise TEGateException.Create(sEGateInactive);

  if not EGateLibrary.Loaded then
  begin
    EGateLibrary.CfgFileName:=CfgFileName;
    EGateLibrary.Load(LibFileName);
  end;
  FErrorCode:=0;
  FErrorMessage:='';
  FEGStatusVector:='';
  FSlipInfo:='';
  FInvoiceNumber:='';
  FRRN:='';
end;

procedure TEGComponent.DoProcessError;
begin
  FErrorCode:=EGateLibrary.egGetLastError(FEGHandle);
  FErrorMessage:=EGateLibrary.egGetErrorDescription(FErrorCode);
  EgWriteLogEx(sEGate_Error, [FErrorCode, FErrorMessage]);
end;

function TEGComponent.DoCheckResultMessage(S: string): boolean;
var
  C: String;
begin
  C:='-1';
  FResultCode:=0;
  FResultMessage:='';
  FResultCryptoMsg:='';

  EgWriteLogEx(sEGate_Answer, [S]);

  if S<>'' then
  begin
    C:=Copy2SpaceDel(S);
    S:=Trim(S);
    if S<>'' then
    begin
      if S[1] = '"' then
      begin
        Delete(S, 1, 1);
        FResultMessage:=Copy2SymbDel(S, '"');
      end;
    end;
    FResultCryptoMsg:=Trim(S);
  end;

  FResultCode:=StrToIntDef(C, -1);
  Result:=FResultCode = 0;
  if (FResultCode<>0) and (FResultCode<>3) and (FResultCode<>20) and (FResultCode<>959) then
  begin
    DoProcessError;
    exit;
  end;
end;

function TEGComponent.DoExecOper(ACmdDesc, ACmd: string): Boolean;
var
  Rec:TEGLibStatusRec;
begin
  EgWriteLog(ACmdDesc +' : '+ACmd);
  Result:=false;
  DoCheckLoaded;
  FEGHandle:=EGateLibrary.egInitInstance;
  if FEGHandle <> 0 then
  begin
    if DoCheckResultMessage(EGateLibrary.egAuthRequest(FEGHandle, FProtocolID, ACmd)) then
    begin
      FEGStatusVector:=EGateLibrary.egGetAuthResult(FEGHandle);
      EgWriteLog('egGetAuthResult ' + FEGStatusVector);
      FSlipInfo:=EGateLibrary.egGetAuthReceipt(FEGHandle);
      EgWriteLog('egGetAuthReceipt ' + FSlipInfo);
      if FEGStatusVector <> '' then
      begin
        DecodeEGLibStatusRec(FEGStatusVector, Rec);
        DoDecodeFlags(Rec.FlagsRes);
        FRRN:=Rec.RRN;
        FInvoiceNumber:=Rec.InvoiceNumber;
      end;
      Result:=true;
    end
    else
    begin
      FEGStatusVector:=EGateLibrary.egGetAuthResult(FEGHandle);
      EgWriteLog('egGetAuthResult ' + FEGStatusVector);
      FSlipInfo:=EGateLibrary.egGetAuthReceipt(FEGHandle);
      EgWriteLog('egGetAuthReceipt ' + FSlipInfo);
      if FEGStatusVector <> '' then
      begin
        DecodeEGLibStatusRec(FEGStatusVector, Rec);
        DoDecodeFlags(Rec.FlagsRes);
        FRRN:=Rec.RRN;
        FInvoiceNumber:=Rec.InvoiceNumber;
      end;
    end;
    EGateLibrary.egReleaseInstance(FEGHandle);
  end
  else
    DoProcessError;
  DoOnStatus;
end;

procedure TEGComponent.CheckActive;
begin
  //
end;

procedure TEGComponent.DoDecodeFlags(AFlags: string);
var
  S: String;
begin
  FResultFlags:=0;
  FPinStatus:=egpsNone;
  if AFlags = '' then exit;
  FResultFlags:=StrToIntDef('$'+StringReplace(AFlags, '\x', '', [rfReplaceAll, rfIgnoreCase]), 0);

  if FResultFlags and $0003 = 0 then
    FPinStatus:=egpsNone
  else
  if FResultFlags and $0003 = 1 then
    FPinStatus:=egpsOffLinePin
  else
  if FResultFlags and $0003 = 2 then
    FPinStatus:=egpsOnlinePin;
end;

constructor TEGComponent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProtocolID:=15;
  LibFileName:=libEGateName;
  FPayTypeMethodCount:=2;
end;

destructor TEGComponent.Destroy;
begin
  inherited Destroy;
end;

procedure TEGComponent.Pay(APaySum: Currency; ACheckNum: integer;
  APayTypeMethod: Integer);
begin
  case APayTypeMethod of
    0:DoExecOper('Оплата', Format('%d 1 %d %d', [FKassaID, trunc(APaySum  * 100), ACheckNum]));
    1:DoExecOper('Оплата', Format('%d 70 %d %d', [FKassaID, trunc(APaySum  * 100), ACheckNum]));
  else
    raise Exception.Create('Не известный тип операции');
  end;
end;

procedure TEGComponent.Revert(ARevertSum: Currency; ACheckNum: string;
  APayTypeMethod: Integer);
var
  S:string;
begin
  case APayTypeMethod of
    0:DoExecOper('Возврат', Format('%d 3 %d %s', [FKassaID, trunc(ARevertSum  * 100), ACheckNum]));
    1:DoExecOper('Возврат', Format('%d 71 %d %s', [FKassaID, trunc(ARevertSum  * 100), ACheckNum]));
  else
    raise Exception.Create('Не известный тип операции');
  end;
end;

procedure TEGComponent.Discard(ADiscardSum: Currency; ACheckNum: string;
  ADocID: string; APayTypeMethod: Integer);
begin
  DoExecOper('Отмена', Format('%d 2 %d %s %s', [FKassaID, trunc(ADiscardSum  * 100), ACheckNum, ADocID]));
end;

procedure TEGComponent.DiscardLastOper;
begin
  abort;
  { TODO : Надо доделать! }
end;

procedure TEGComponent.ReportOperList;
begin
  DoExecOper('Запрос журнала операций', Format('%d 6 %d %d', [FKassaID, 0, 0]));
end;

procedure TEGComponent.ReportOperSmall;
begin
  DoExecOper('Запрос журнала операций', Format('%d 33 %d %d', [FKassaID, 0, 0]));
end;

procedure TEGComponent.ReportItog;
begin
  DoExecOper('Сверка итоговых сумм', Format('%d 4 %d %d', [FKassaID, 0, 0]));
  FWorkKeyPresent:=false;
end;

procedure TEGComponent.GetWorkKey;
begin
  if FWorkKeyPresent then exit;
  if DoExecOper('Запрос рабочего ключа для операций с пин-кодом', Format('%d 5', [FKassaID])) then
    FWorkKeyPresent:=true;
end;

procedure TEGComponent.PPLoadConfig;
begin
  DoExecOper('Загрузка параметров на пинпад Ingenico Telium', Format('%d 35', [FKassaID]));
end;

procedure TEGComponent.PPLoadSoftware;
begin
  DoExecOper('Загрузка ПО на пинпад Ingenico Telium', Format('%d 36', [FKassaID]));
  FWorkKeyPresent:=false;
end;

procedure TEGComponent.EchoTest;
begin
  DoExecOper('Echo test - ЭХО-ТЕСТ', Format('%d 24 1 1', [FKassaID]));
end;

function TEGComponent.PayTypeMethodName(APayTypeMethod: Integer): string;
begin
  case APayTypeMethod of
    0:Result:=sPayTypeMethodBankCard;
    1:Result:=sPayTypeMethodQRCode;
  else
    Result:=sUnknowPayTypeMethod;
  end;
end;

initialization
  RegisterPlasticCardType(TEGComponent, 'Газпромбанк');

  RegisterPropertyToSkip(TEGComponent, 'EGateLibFileName', 'depricated property', '');
end.

