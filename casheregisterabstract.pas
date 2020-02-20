{ Билиотека для работы с ККМ АТОЛ

  Copyright (C) 2013-2020 Лагунов Алексей alexs75@yandex.ru

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

unit CasheRegisterAbstract;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TCashRegisterAbstract = class;

  TCheckType =
    (chtNone,
     chtSell, chtSellReturn, chtSellCorrection, chtSellReturnCorrection,
     chtBuy, chtBuyReturn, chtBuyCorrection, chtBuyReturnCorrection);

  TPaymentType =
    (pctCash,           //наличный
     pctElectronically, //электронный
     pctPrePaid,        //предварительная оплата (аванс)
     pctCredit,         //последующая оплата (кредит)
     pctOther,          //иная форма оплаты (встречное предоставление)
     pctOther_6,        //тип оплаты №6
     pctOther_7,        //тип оплаты №7
     pctOther_8,        //тип оплаты №8
     pctOther_9,        //тип оплаты №9
     pctOther_10       //тип оплаты №10

//     pctNone = 99999
  );

  TTaxType = (
    ttaxDefault,
    ttaxVat18,
    ttaxVat10,
    ttaxVat118,
    ttaxVat110,
    ttaxVat0,
    ttaxVatNO,
    ttaxVat20,
    ttaxVat120
  );

  TGoodsPayMode =
    (gpmFullPay,
     gpmPrePay100,
     gpmPrePay,
     gpmAvance,
     gpmFullPay2,
     gpmPartialPayAndKredit,
     gpmKredit,
     gpmKreditPay
    );
  ECashRegisterAbstract = class(Exception);

  TEcrTextAlign = (etaLeft, etaCenter, etaRight);
  TEcrWordWrap = (ewwNone, ewwWords, ewwChars);
  TCrpCodeBuffer = array [1..32] of byte;


  { TGoodsNomenclatureCode }

  TGoodsNomenclatureCode = class
  private
    FGroupCode: word;
    FGTIN: string;
    FSerial: string;
  public
    procedure Clear;
    function Make1162Value:TBytes;
    property GroupCode:word read FGroupCode write FGroupCode;
    property GTIN:string read FGTIN write FGTIN;
    property Serial:string read FSerial write FSerial;
  end;

  { TTextParams }

  TTextParams = class
  private
    FAlign:TEcrTextAlign;
    FBrightness: integer;
    FDoubleHeight: boolean;
    FDoubleWidth: boolean;
    FFontNumber: integer;
    FLineSpacing: integer;
    FWordWrap: TEcrWordWrap;
  public
    constructor Create;
    procedure Clear;
    property Align:TEcrTextAlign read FAlign write FAlign default etaLeft;
    property WordWrap:TEcrWordWrap read FWordWrap write FWordWrap default ewwNone;
    property FontNumber:integer read FFontNumber write FFontNumber;
    property DoubleWidth:boolean read FDoubleWidth write FDoubleWidth;
    property DoubleHeight:boolean read FDoubleHeight write FDoubleHeight;
    property LineSpacing:integer read FLineSpacing write FLineSpacing;
    property Brightness:integer read FBrightness write FBrightness;
  end;

  { TCounteragentInfo }

  TCounteragentInfo = class
  private
    FAdress: string;
    FEmail: string;
    FINN: string;
    FName: string;
    FPhone: string;
  public
    procedure Clear;
    property Name:string read FName write FName;
    property Adress:string read FAdress write FAdress;
    property INN:string read FINN write FINN;
    property Phone:string read FPhone write FPhone;
    property Email:string read FEmail write FEmail;
  end;

  { TCheckInfo }

  TCheckInfo = class
  private
    FElectronically: boolean;
  public
    procedure Clear;
    property Electronically:boolean read FElectronically write FElectronically;
  end;

  { TDeviceState }

  TDeviceState = class
  private
    FDateTime: TDateTime;
  public
    property DateTime:TDateTime read FDateTime;
  end;

  { TCheckPaperInfo }

  TCheckPaperInfo = class
  private
    FLineLength: integer;
    FLineLengthPix: integer;
  protected
    procedure SetLineLength(AValue:Integer);
    procedure SetLineLengthPix(AValue:Integer);
  public
    procedure Clear;
    property LineLength:integer read FLineLength;
    property LineLengthPix:integer read FLineLengthPix;
  end;

  { TDeviceInfo }

  TDeviceInfo = class
  private
    FPaperInfo: TCheckPaperInfo;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    property PaperInfo:TCheckPaperInfo read FPaperInfo;
  end;



  { TGoodsInfo }

  TGoodsInfo = class
  private
    FCountryCode: Integer;
    FDeclarationNumber: String;
    FGoodsNomenclatureCode: TGoodsNomenclatureCode;
    FGoodsPayMode: TGoodsPayMode;
    FName: string;
    FPrice: Currency;
    FQuantity: Double;
    FSuplierInfo: TCounteragentInfo;
    FTaxType: TTaxType;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    property Name:string read FName write FName;
    property Price:Currency read FPrice write FPrice;
    property Quantity:Double read FQuantity write FQuantity;
    property TaxType:TTaxType read FTaxType write FTaxType;
    property CountryCode:Integer read FCountryCode write FCountryCode;
    property DeclarationNumber:String read FDeclarationNumber write FDeclarationNumber;
    property SuplierInfo:TCounteragentInfo read FSuplierInfo;
    property GoodsPayMode:TGoodsPayMode read FGoodsPayMode write FGoodsPayMode;
    property GoodsNomenclatureCode:TGoodsNomenclatureCode read FGoodsNomenclatureCode write FGoodsNomenclatureCode;
  end;

  { TCashRegisterAbstract }

  TCashRegisterAbstract = class(TComponent)
  private
    FAgentInfo: TCounteragentInfo;
    FCheckElectronic: boolean;
    FCheckInfo: TCheckInfo;
    FCounteragentInfo: TCounteragentInfo;
    FDeviceInfo: TDeviceInfo;
    FErrorCode: integer;
    FErrorDescription: string;
    FGoodsInfo: TGoodsInfo;
    FKassaUserINN: string;
    FOnError: TNotifyEvent;
    FPassword: string;
    FPaymentPlace: string;
    FCheckType: TCheckType;
    FTextParams: TTextParams;
    FUserName: string;
  protected
    FDeviceState: TDeviceState;
    procedure SetUserName(AValue: string); virtual;
    procedure SetPassword(AValue: string); virtual;
    procedure SetKassaUserINN(AValue: string); virtual;
    function GetConnected: boolean; virtual; abstract;
    procedure SetConnected(AValue: boolean); virtual; abstract;
    function GetCheckNumber: integer; virtual; abstract;
    function GetCheckType: TCheckType; virtual; abstract;
    procedure SetCheckType(AValue: TCheckType); virtual;
    procedure SetError(AErrorCode:integer; AErrorDescription:string);
    procedure ClearError;
    procedure InternalGetDeviceInfo(var ALineLength, ALineLengthPix: integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Beep; virtual; abstract;
    procedure CutCheck(APartial:boolean); virtual; abstract;
    procedure PrintLine(ALine:string);virtual; abstract;     //Печать строки
    procedure PrintClishe; virtual; abstract;
    procedure DemoPrint; virtual; abstract;
    procedure QueryDeviceParams;


    //Отперации со сменой
    procedure OpenShift; virtual;                            //Открыть смену

    //Операции с чеком
    procedure OpenCheck; virtual;                            //Открыть чек
    function CloseCheck:Integer; virtual;                    //Закрыть чек (со сдачей)
    function CancelCheck:integer; virtual;                   //Аннулирование всего чека
    function ShowProperties:boolean; virtual; abstract;      //Отобразить окно параметров ККМ

    //Внесения и выплаты
    function CashIncome(APaymentSum:Currency):integer; virtual; abstract;          //Внесение денег
    function CashOutcome(APaymentSum:Currency):integer; virtual; abstract;         //Выплата денег

    function Registration:integer;virtual;
    function ReceiptTotal:integer;virtual; abstract;
    function Payment:integer; virtual; abstract;
    procedure RegisterPayment(APaymentType:TPaymentType; APaymentSum:Currency); virtual; abstract;

    procedure SetAttributeInt(AttribNum, AttribValue:Integer); virtual; abstract;
    procedure SetAttributeStr(AttribNum:Integer; AttribValue:string); virtual; abstract;
    procedure SetAttributeBool(AttribNum:Integer; AttribValue:Boolean); virtual; abstract;
    procedure SetAttributeDouble(AttribNum:Integer; AttribValue:Double); virtual; abstract;

    //Отчёты
    procedure ReportX(AReportType: Byte); virtual; abstract;
    procedure ReportZ; virtual; abstract;
    procedure PrintReportHours; virtual; abstract;
    procedure PrintReportSection; virtual; abstract;
    procedure PrintReportCounted; virtual; abstract;
    //
    property CheckNumber:integer read GetCheckNumber;
    //property CheckMode:integer read FCheckMode write FCheckMode;
    property CheckType:TCheckType read FCheckType write SetCheckType;
    property CheckElectronic:boolean read FCheckElectronic write FCheckElectronic;
  public
    property Password:string read FPassword write SetPassword;
    property UserName:string read FUserName write SetUserName;
    property KassaUserINN:string read FKassaUserINN write SetKassaUserINN;
    property Connected:boolean read GetConnected write SetConnected;
    property ErrorCode:integer read FErrorCode;
    property ErrorDescription:string read FErrorDescription;

    //Параметры вывода на печать текста
    property TextParams:TTextParams read FTextParams;
    //Тут будем размещать свойства объектной модели чека
    property CounteragentInfo:TCounteragentInfo read FCounteragentInfo;
    property AgentInfo:TCounteragentInfo read FAgentInfo;
    property CheckInfo:TCheckInfo read FCheckInfo;
    property GoodsInfo:TGoodsInfo read FGoodsInfo;
    property PaymentPlace:string read FPaymentPlace write FPaymentPlace;

    //Статус и информация о аппарате
    property DeviceState:TDeviceState read FDeviceState;
    property DeviceInfo:TDeviceInfo read FDeviceInfo;
    //
    property OnError:TNotifyEvent read FOnError write FOnError;
  end;

function CheckTypeStr(ACheckType:TCheckType):string;
function PaymentTypeStr(APaymentType:TPaymentType):string;
procedure MakeCRPTCode(APrefix:Word; AGTIN:string; ASerial:string; var R:TCrpCodeBuffer);
function MakeCRPTCodeStr(APrefix:Word; AGTIN:string; ASerial:string):string;
implementation
uses Math;

procedure MakeCRPTCode(APrefix:Word; AGTIN:string; ASerial:string; var R:TCrpCodeBuffer);
var
  B:TCrpCodeBuffer;
  W2: QWord;
  i: Integer;
begin
  FillChar(R, SizeOf(R), 0);
  W2:=StrToQWord(AGTIN);
  Move(APrefix, B, 2);
  for i:=1 to 2 do R[i]:=B[3-i];
  Move(W2, B, 6);
  for i:=1 to 6 do R[2+i]:=B[7-i];
  for i:=1 to Min(Length(ASerial), 24) do R[8 + i]:=Ord(ASerial[i]);
end;

function MakeCRPTCodeStr(APrefix:Word; AGTIN:string; ASerial:string):string;
var
  A: TCrpCodeBuffer;
  i: Integer;
begin
  Result:='';
  MakeCRPTCode(APrefix, AGTIN, ASerial, A);
  for i:=1 to Length(ASerial) + 8  do
  begin
    if Result<>'' then Result:=Result + ' ';
    Result:=Result + IntToHex(A[i], 2);
  end;
end;

function CheckTypeStr(ACheckType: TCheckType): string;
begin
  case ACheckType of
    chtNone:Result:='Нет';
    chtSell:Result:='Продажа';
    chtSellReturn:Result:='Возврат продажи';
    chtSellCorrection:Result:='Коррекция продажи';
    chtSellReturnCorrection:Result:='Коррекция возврат продажи';
    chtBuy:Result:='Покупка';
    chtBuyReturn:Result:='Возврат покупки';
    chtBuyCorrection:Result:='Коррекция покупки';
    chtBuyReturnCorrection:Result:='Коррекция возврата покупки';
  else
    Result:='Не известный тип чека';
  end;
end;

function PaymentTypeStr(APaymentType: TPaymentType): string;
begin
  case APaymentType of
    pctCash:Result:='Наличный расчёт';
    pctElectronically:Result:='электронный';
    pctPrePaid:Result:='предварительная оплата (аванс)';
    pctCredit:Result:='последующая оплата (кредит)';
    pctOther:Result:='иная форма оплаты (встречное предоставление)';
    pctOther_6:Result:='тип оплаты №6';
    pctOther_7:Result:='тип оплаты №7';
    pctOther_8:Result:='тип оплаты №8';
    pctOther_9:Result:='тип оплаты №9';
    pctOther_10:Result:='тип оплаты №10';
  else
    Result:='Не известный тип оплаты';
  end;
end;

{ TGoodsNomenclatureCode }

procedure TGoodsNomenclatureCode.Clear;
begin
  FGroupCode:=0;
  FGTIN:='';
  FSerial:='';
end;

function TGoodsNomenclatureCode.Make1162Value: TBytes;
var
  R: TCrpCodeBuffer;
begin
  MakeCRPTCode(FGroupCode, FGTIN, FSerial, R);
  SetLength(Result, SizeOf(TCrpCodeBuffer));
  Move(R[1], Result[0], SizeOf(TCrpCodeBuffer));
end;

{ TDeviceInfo }

constructor TDeviceInfo.Create;
begin
  inherited Create;
  FPaperInfo:=TCheckPaperInfo.Create;
end;

destructor TDeviceInfo.Destroy;
begin
  FreeAndNil(FPaperInfo);
  inherited Destroy;
end;

procedure TDeviceInfo.Clear;
begin
  FPaperInfo.Clear;
end;

{ TCheckPaperInfo }

procedure TCheckPaperInfo.SetLineLength(AValue: Integer);
begin
  FLineLength:=AValue;
end;

procedure TCheckPaperInfo.SetLineLengthPix(AValue: Integer);
begin
  FLineLengthPix:=AValue;
end;

procedure TCheckPaperInfo.Clear;
begin
  FLineLength:=0;
  FLineLengthPix:=0;
end;

{ TTextParams }

constructor TTextParams.Create;
begin
  inherited Create;
  FAlign:=etaLeft;
end;

procedure TTextParams.Clear;
begin
  FAlign:=etaLeft;
  FBrightness:=0;
  FDoubleHeight:=false;
  FDoubleWidth:=false;
  FFontNumber:=0;
  FLineSpacing:=0;
  FWordWrap:=ewwNone;
end;

{ TGoodsInfo }

constructor TGoodsInfo.Create;
begin
  inherited Create;
  FSuplierInfo:=TCounteragentInfo.Create;
  FGoodsNomenclatureCode:=TGoodsNomenclatureCode.Create;
end;

destructor TGoodsInfo.Destroy;
begin
  FreeAndNil(FGoodsNomenclatureCode);
  FreeAndNil(FSuplierInfo);
  inherited Destroy;
end;

procedure TGoodsInfo.Clear;
begin
  FName:='';
  FPrice:=0;
  FQuantity:=0;
  FTaxType:=ttaxDefault;
  FGoodsPayMode:=gpmFullPay;

  FCountryCode:=0;
  FDeclarationNumber:='';
  FGoodsNomenclatureCode.Clear;
  FSuplierInfo.Clear;
end;

{ TCheckInfo }

procedure TCheckInfo.Clear;
begin
  FElectronically:=false;
end;

{ TCounteragentInfo }

procedure TCounteragentInfo.Clear;
begin
  FName:='';
  FAdress:='';
  FPhone:='';
  FINN:='';
  FEmail:='';
end;

{ TCashRegisterAbstract }

procedure TCashRegisterAbstract.SetKassaUserINN(AValue: string);
begin
  if FKassaUserINN=AValue then Exit;
  FKassaUserINN:=AValue;
end;

procedure TCashRegisterAbstract.SetCheckType(AValue: TCheckType);
begin
  FCheckType:=AValue;
end;

procedure TCashRegisterAbstract.SetError(AErrorCode: integer;
  AErrorDescription: string);
begin
  FErrorCode:=AErrorCode;
  FErrorDescription:=AErrorDescription;
  if Assigned(FOnError) then
    FOnError(Self);
end;

procedure TCashRegisterAbstract.ClearError;
begin
  FErrorCode:=0;
  FErrorDescription:='';
end;

procedure TCashRegisterAbstract.InternalGetDeviceInfo(var ALineLength,
  ALineLengthPix: integer);
begin

end;

constructor TCashRegisterAbstract.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCounteragentInfo:=TCounteragentInfo.Create;
  FCheckInfo:=TCheckInfo.Create;
  FGoodsInfo:=TGoodsInfo.Create;
  FAgentInfo:=TCounteragentInfo.Create;
  FTextParams:=TTextParams.Create;
  FDeviceInfo:=TDeviceInfo.Create;
end;

destructor TCashRegisterAbstract.Destroy;
begin
  FreeAndNil(FCounteragentInfo);
  FreeAndNil(FCheckInfo);
  FreeAndNil(FGoodsInfo);
  FreeAndNil(FTextParams);
  FreeAndNil(FDeviceInfo);
  inherited Destroy;
end;

procedure TCashRegisterAbstract.QueryDeviceParams;
var
  FLineLength, FLineLengthPix: integer;
begin
  FDeviceInfo.Clear;
  InternalGetDeviceInfo(FLineLength, FLineLengthPix);
  FDeviceInfo.FPaperInfo.FLineLength:=FLineLength;
  FDeviceInfo.FPaperInfo.FLineLengthPix:=FLineLengthPix;
end;

procedure TCashRegisterAbstract.OpenShift;
begin
  //
end;

procedure TCashRegisterAbstract.OpenCheck;
begin
  FTextParams.Clear;
  FCheckElectronic:=false;
end;

function TCashRegisterAbstract.CloseCheck: Integer;
begin
  Result:=0;
  FCounteragentInfo.Clear;
  FCheckInfo.Clear;
  FGoodsInfo.Clear;
  FAgentInfo.Clear;
  FTextParams.Clear;
  FCheckType:=chtNone;
end;

function TCashRegisterAbstract.CancelCheck: integer;
begin
  Result:=0;
  FCounteragentInfo.Clear;
  FCheckInfo.Clear;
  FGoodsInfo.Clear;
  FAgentInfo.Clear;
  FTextParams.Clear;
  FCheckType:=chtNone;
end;

function TCashRegisterAbstract.Registration: integer;
begin
  FGoodsInfo.Clear;
  FTextParams.Clear;
end;

procedure TCashRegisterAbstract.SetUserName(AValue: string);
begin
  if FUserName=AValue then Exit;
  FUserName:=AValue;
end;

procedure TCashRegisterAbstract.SetPassword(AValue: string);
begin
  if FPassword=AValue then Exit;
  FPassword:=AValue;
end;

end.

