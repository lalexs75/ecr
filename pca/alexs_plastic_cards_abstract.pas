{**************************************************************************}
{ Абстрактный класс библиотек для работы с платёжными терминалами          }
{ банковских пластиковых карт                                              }
{ Free Pascal Compiler версии 3.0.0 и Lazarus 1.6 и выше.                  }
{ Лагунов Алексей (С) 2017-2020  alexs75.at.yandex.ru                      }
{**************************************************************************}

unit alexs_plastic_cards_abstract;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TPinStatus = (egpsNone,         //Без ввода пина
                 egpsOffLinePin,   //Введён оффлайне пин
                 egpsOnlinePin);   //Введён онлайн пин

  TPlasticCardAbstract = class;
  TPlasticCardOnStatus = procedure(Sender:TPlasticCardAbstract) of object;

  { TPlasticCardAbstract }
  TPlasticCardAbstractClass = class of TPlasticCardAbstract;

  TPlasticCardAbstract = class(TComponent)
  private
    FLibFileName: string;
    FCfgFileName: string;
    FOnStatus: TPlasticCardOnStatus;
    FActive: boolean;
    function IsEGateLibFileNameStored: Boolean;
  protected
    FErrorCode: integer;
    FErrorMessage: string;
    FResultCode: integer;
    FKassaID: integer;
    FSlipInfo: string;
    FRRN: string;
    FInvoiceNumber: string;
    FPinStatus: TPinStatus;
    FResultMessage: string;
    procedure DoOnStatus;
    procedure SetKassaID(AValue: integer);
    procedure Clear; virtual;
    procedure SetActive(AValue: boolean);virtual;
    function GetWorkKeyPresent: boolean; virtual;
    function IsLibFileNameStored: Boolean; virtual;
    function GetStatusVector: string; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Pay(APaySum:Currency; ACheckNum:integer); virtual; abstract;
    procedure Revert(ARevertSum:Currency; ACheckNum:string); virtual; abstract;
    procedure Discard(ADiscardSum:Currency; ACheckNum:string; ADocID:string); virtual; abstract;

    procedure ReportItog; virtual; abstract;
    procedure EchoTest; virtual; abstract;
    procedure GetWorkKey; virtual; abstract;
    procedure ReportOperList;virtual; abstract;
    procedure ReportOperSmall;virtual; abstract;
    procedure PPLoadConfig;virtual; abstract;
    procedure PPLoadSoftware;virtual; abstract;

    property ResultCode:integer read FResultCode;
    property ErrorCode:integer read FErrorCode;
    property ErrorMessage:string read FErrorMessage;
    property SlipInfo:string read FSlipInfo;
    property RRN:string read FRRN;
    property WorkKeyPresent:boolean read GetWorkKeyPresent;
    property StatusVector:string read GetStatusVector;
    property InvoiceNumber:string read FInvoiceNumber;
    property PinStatus:TPinStatus read FPinStatus;
    property ResultMessage:string read FResultMessage;
  published
    property Active:boolean read FActive write SetActive;
    property OnStatus:TPlasticCardOnStatus read FOnStatus write FOnStatus;
    property KassaID:integer read FKassaID write SetKassaID;
    property CfgFileName:string read FCfgFileName write FCfgFileName;
    property LibFileName:string read FLibFileName write FLibFileName stored IsEGateLibFileNameStored;
  end;


procedure RegisterPlasticCardType(AClassRef:TPlasticCardAbstractClass; ADesciption:string);
procedure FillPlasticCardTypeList(AList:TStrings);
function GetPlasticCardObject(APCClassName:string; AOwner:TComponent):TPlasticCardAbstract;

implementation
type
  TPlasticCardRegType = class
    FClassRef:TPlasticCardAbstractClass;
    FDesciption:string
  end;

var
  PlasticCardRegTypeList:TList = nil;

procedure InitCardRegTypeList;
begin
  if not Assigned(PlasticCardRegTypeList) then
    PlasticCardRegTypeList:=TList.Create;
end;

function GetPlasticCardType(APCClassName: string): TPlasticCardAbstractClass;
var
  R: TPlasticCardRegType;
  i: Integer;
begin
  InitCardRegTypeList;
  Result:=nil;
  for i:=0 to PlasticCardRegTypeList.Count-1 do
  begin
    R:=TPlasticCardRegType(PlasticCardRegTypeList[i]);
    if R.FClassRef.ClassName = APCClassName then
    begin
      Result:=R.FClassRef;
      Exit;
    end;
  end;
end;

procedure DoneCardRegTypeList;
var
  R: TPlasticCardRegType;
  i: Integer;
begin
  if Assigned(PlasticCardRegTypeList) then
  begin
    for i:=0 to PlasticCardRegTypeList.Count-1 do
    begin
      R:=TPlasticCardRegType(PlasticCardRegTypeList[i]);
      FreeAndNil(R);
    end;
    FreeAndNil(PlasticCardRegTypeList);
  end;
end;

procedure RegisterPlasticCardType(AClassRef: TPlasticCardAbstractClass; ADesciption: string);
var
  R: TPlasticCardRegType;
begin
  InitCardRegTypeList;
  if not Assigned(GetPlasticCardType(AClassRef.ClassName)) then
  begin
    R:=TPlasticCardRegType.Create;
    R.FClassRef:=AClassRef;
    R.FDesciption:=ADesciption;
    PlasticCardRegTypeList.Add(R);
  end;
end;

procedure FillPlasticCardTypeList(AList: TStrings);
var
  R: TPlasticCardRegType;
  i: Integer;
begin
  if not Assigned(AList) then exit;
  for i:=0 to PlasticCardRegTypeList.Count-1 do
  begin
    R:=TPlasticCardRegType(PlasticCardRegTypeList[i]);
    AList.Add(R.FClassRef.ClassName);
  end;
end;

function GetPlasticCardObject(APCClassName: string; AOwner:TComponent): TPlasticCardAbstract;
var
  R: TPlasticCardAbstractClass;
begin
  Result:=nil;
  R:=GetPlasticCardType(APCClassName);
  if Assigned(R) then
    Result:=R.Create(AOwner);
end;

{ TPlasticCardAbstract }

function TPlasticCardAbstract.GetWorkKeyPresent: boolean;
begin
  Result:=true;
end;

function TPlasticCardAbstract.IsLibFileNameStored: Boolean;
begin

end;

function TPlasticCardAbstract.IsEGateLibFileNameStored: Boolean;
begin
  Result:=false;
end;

function TPlasticCardAbstract.GetStatusVector: string;
begin
  Result:='';
end;

procedure TPlasticCardAbstract.DoOnStatus;
begin
  if Assigned(FOnStatus) then
    FOnStatus(Self);
end;

procedure TPlasticCardAbstract.SetKassaID(AValue: integer);
begin
  if FKassaID=AValue then Exit;
  FKassaID:=AValue;
end;

procedure TPlasticCardAbstract.Clear;
begin
  FSlipInfo:='';
  FErrorCode:=0;
  FErrorMessage:='';
end;

procedure TPlasticCardAbstract.SetActive(AValue: boolean);
begin
  if FActive=AValue then Exit;
  FActive:=AValue;
end;

constructor TPlasticCardAbstract.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCfgFileName:='';
  FPinStatus:=egpsNone;
end;

destructor TPlasticCardAbstract.Destroy;
begin
  inherited Destroy;
end;

finalization
  DoneCardRegTypeList;
end.

