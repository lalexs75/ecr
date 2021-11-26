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

const
  //Символьные константы для единиц измерения согласно ОКЕИ
  muPIECE = 796;             //шт
  muGRAM = 163;              //Грамм
  muKILOGRAM = 166;          //Килограмм
  muTON = 168;               //Тонна
  muCENTIMETER = 004;        //Сантиметр
  muDECIMETER = 005;         //Дециметр
  muMETER = 006;             //Метр
  muSQUARE_CENTIMETER = 051; //Квадратный сантиметр
  muSQUARE_DECIMETER = 053;  //Квадратный дециметр
  muSQUARE_METER = 055;      //Квадратный метр
  muMILLILITER = 111;        //Кубический сантиметр; миллилитр
  muLITER = 112;             //Литр; кубический дециметр
  muCUBIC_METER = 113;       //Кубический метр
  muKILOWATT_HOUR = 245;     //Киловатт-час
  muGKAL = 233;              //Гигакалория
  muDAY = 359;               //Сутки
  muHOUR = 356;              //Час
  muMINUTE = 355;            //Минута
  muSECOND = 354;            //Секунда
  muKILOBYTE = 256;          //Килобайт
  muMEGABYTE = 257;          //Мегабайт
  muGIGABYTE = 2553;         //Гигабайт
  muTERABYTE = 2554;         //Терабайт

type
  TCashRegisterAbstract = class;
  TGoodsListEnumerator = class;
  TPaymentsListEnumerator = class;

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

  TGoodsType =
      (gtNone = 0,                            //0 - По умолчанию
       gtCommodity  = 1,                      //1 - товар
       gtExcise = 2,                          //2 - подакцизный товар
       gtJob = 3,                             //3 - работа
       gtService = 4,                         //4 - услуга
       gtGamblingBet = 5,                     //5 - ставка азартной игры
       gtGamblingPrize = 6,                   //6 - выигрыш азартной игры
       gtLottery = 7,                         //7 - лотерейный билет
       gtLotteryPrize = 8,                    //8 - выигрыш лотереи
       gtIntellectualActivity = 9,            //9 - предоставление результатов интерелектуальной деятельности
       gtPayment = 10,                        //или 10 - платеж
       gtAgentCommission = 11,                //или 11 - агентское вознаграждение
       gtComposite = 12,                      //(устаревшее) или pay или 12 - выплата
       gtAnother = 13,                        //или 13 - иной предмет расчета
       gtProprietaryLaw = 14,                 //или 14 - имущественное право
       gtNonOperatingIncome = 15,             //или 15 - внереализационный доход
       gtOtherContributions = 16,
       gtInsuranceContributions = 16,         //(устаревшее) или otherContributions или 16 - иные платежи и взносы
       gtMerchantTax = 17,                    //или 17 - торговый сбор
       gtResortFee = 18,                      //или 18 - курортный сбор
       gtDeposit = 19,                        //или 19 - залог
       gtConsumption = 20,                    //или 20 - расход
       gtSoleProprietorCPIContributions = 21, //или 21 - взносы на ОПС ИП
       gtCpiContributions = 22,               //или 22 - взносы на ОПС
       soleProprietorCMIContributions = 23,   //или 23 - взносы на ОМС ИП
       gtCmiContributions = 24,               //или 24 - взносы на ОМС
       gtCsiContributions = 25,               //или 25 - взносы на ОСС
       gtCasinoPayment = 26                   //или 26 - платеж казино
      );

  TOFDSTatusRecord = record
    ExchangeStatus:Cardinal;
    UnsentCount:Integer;
    FirstUnsentNumber:Integer;
    OfdMessageRead:Boolean;
    LastSendDocDate:TDateTime
  end;

  ECashRegisterAbstract = class(Exception);

  TEcrTextAlign = (etaLeft, etaCenter, etaRight);
  TEcrWordWrap = (ewwNone, ewwWords, ewwChars);
  TCrpCodeBuffer = array [1..32] of byte;

  { TGoodsNomenclatureCode }

  TGoodsNomenclatureCode = class
  private
    FGroupCode: word;
    FGTIN: string;
    FKM: String;
    FSerial: string;
    FState: DWord;
  public
    procedure Clear;
    function Make1162Value:TBytes;
    property GroupCode:word read FGroupCode write FGroupCode;
    property GTIN:string read FGTIN write FGTIN;
    property Serial:string read FSerial write FSerial;
    property KM:String read FKM write FKM;
    property State:DWord read FState write FState;
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
    FGoodsArticle: string;
    FGoodsMeasurementUnit: Integer;
    FGoodsNomenclatureCode: TGoodsNomenclatureCode;
    FGoodsPayMode: TGoodsPayMode;
    FGoodsType: TGoodsType;
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
    property GoodsType:TGoodsType read FGoodsType write FGoodsType;
    property GoodsMeasurementUnit:Integer read FGoodsMeasurementUnit write FGoodsMeasurementUnit;
    property GoodsArticle:string read FGoodsArticle write FGoodsArticle;
  end;

  { TGoodsList }

  TGoodsList = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItems(AIndex: integer): TGoodsInfo;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add:TGoodsInfo;
    function GetEnumerator: TGoodsListEnumerator;

    property Count:integer read GetCount;
    property Items[AIndex:integer]:TGoodsInfo read GetItems; default;
  end;

  { TGoodsListEnumerator }

  TGoodsListEnumerator = class
  private
    FList: TGoodsList;
    FPosition: Integer;
  public
    constructor Create(AList: TGoodsList);
    function GetCurrent: TGoodsInfo;
    function MoveNext: Boolean;
    property Current: TGoodsInfo read GetCurrent;
  end;


  { TPaymentInfo }

  TPaymentInfo = class
  private
    FPaymentSum: Currency;
    FPaymentType: TPaymentType;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    property PaymentType:TPaymentType read FPaymentType write FPaymentType;
    property PaymentSum: Currency read FPaymentSum write FPaymentSum;
  end;

  { TPaymentsList }

  TPaymentsList = class
  private
    FList:TFPList;
    function GetCount: integer;
    function GetItems(AIndex: integer): TPaymentInfo;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add:TPaymentInfo;
    function GetEnumerator: TPaymentsListEnumerator;

    property Count:integer read GetCount;
    property Items[AIndex:integer]:TPaymentInfo read GetItems; default;
  end;

  { TPaymentsListEnumerator }

  TPaymentsListEnumerator = class
  private
    FList: TPaymentsList;
    FPosition: Integer;
  public
    constructor Create(AList: TPaymentsList);
    function GetCurrent: TPaymentInfo;
    function MoveNext: Boolean;
    property Current: TPaymentInfo read GetCurrent;
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
    FGoodsList: TGoodsList;
    FKassaUserINN: string;
    FOnError: TNotifyEvent;
    FPassword: string;
    FPaymentPlace: string;
    FCheckType: TCheckType;
    FPaymentsList: TPaymentsList;
    FTextParams: TTextParams;
    FUserName: string;
    FWaitForMarkingValidationResult: Boolean;
  protected
    FDeviceState: TDeviceState;
    FLibraryFileName: string;
    procedure SetUserName(AValue: string); virtual;
    procedure SetPassword(AValue: string); virtual;
    procedure SetKassaUserINN(AValue: string); virtual;
    function GetConnected: boolean; virtual; abstract;
    procedure SetConnected(AValue: boolean); virtual; abstract;
    function GetCheckNumber: integer; virtual; abstract;
    function GetFDNumber: integer; virtual; abstract;
    function GetCheckType: TCheckType; virtual; abstract;
    procedure SetCheckType(AValue: TCheckType); virtual;
    procedure SetError(AErrorCode:integer; AErrorDescription:string);
    procedure ClearError;
    procedure InternalGetDeviceInfo(var ALineLength, ALineLengthPix: integer); virtual;
    function GetDeviceDateTime: TDateTime; virtual; abstract;
    procedure InternalUserLogin; virtual; abstract;
    procedure InternalOpenKKM; virtual; abstract;
    procedure InternalCloseKKM; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function InternalCheckError:Integer; virtual; abstract;
    procedure Beep; virtual; abstract;
    procedure CutCheck(APartial:boolean); virtual; abstract;
    procedure PrintLine(ALine:string);virtual; abstract;     //Печать строки
    procedure PrintClishe; virtual; abstract;
    procedure DemoPrint; virtual; abstract;
    procedure QueryDeviceParams;
    procedure Open;
    procedure Close;
    function GetVersionString:string; virtual;
    procedure GetOFDStatus(out AStatus:TOFDSTatusRecord); virtual;
    function NonNullableSum:Currency; virtual;                  //Не обнуляемая сумма - приход - наличка


    //Отперации со сменой
    procedure OpenShift; virtual;                            //Открыть смену

    //Операции с чеком
    procedure BeginCheck; virtual;                            //Открыть чек
    procedure OpenCheck; virtual;                            //Открыть чек
    function CloseCheck:Integer; virtual;                    //Закрыть чек (со сдачей)
    function CancelCheck:integer; virtual;                   //Аннулирование всего чека
    function ShowProperties:boolean; virtual; abstract;      //Отобразить окно параметров ККМ

    //Внесения и выплаты
    function CashIncome(APaymentSum:Currency):integer; virtual; abstract;          //Внесение денег
    function CashOutcome(APaymentSum:Currency):integer; virtual; abstract;         //Выплата денег

    function Registration:integer;virtual; deprecated;
    function ReceiptTotal:integer;virtual; abstract;
    function Payment:integer; virtual; abstract;
    procedure RegisterPayment(APaymentType:TPaymentType; APaymentSum:Currency); virtual; abstract; deprecated;
    function RegisterGoods:Integer; virtual; abstract;
    function RegisterPayments:Integer; virtual; abstract;
    function ValidateGoodsKM:Boolean; virtual; abstract;

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
    procedure BeginNonfiscalDocument; virtual; abstract;
    procedure EndNonfiscalDocument; virtual; abstract;
    function UpdateFnmKeys:Integer; virtual; abstract;
    //
    property CheckNumber:integer read GetCheckNumber;
    property FDNumber:integer read GetFDNumber;
    //property CheckMode:integer read FCheckMode write FCheckMode;
    property CheckType:TCheckType read FCheckType write SetCheckType;
    property CheckElectronic:boolean read FCheckElectronic write FCheckElectronic;
  public
    property LibraryFileName:string read FLibraryFileName write FLibraryFileName;
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
    property GoodsInfo:TGoodsInfo read FGoodsInfo; deprecated;
    property GoodsList:TGoodsList read FGoodsList;
    property PaymentsList:TPaymentsList read FPaymentsList;
    property PaymentPlace:string read FPaymentPlace write FPaymentPlace;

    //Статус и информация о аппарате
    property DeviceState:TDeviceState read FDeviceState;
    property DeviceInfo:TDeviceInfo read FDeviceInfo;
    property DeviceDateTime:TDateTime read GetDeviceDateTime;
    property WaitForMarkingValidationResult:Boolean read FWaitForMarkingValidationResult write FWaitForMarkingValidationResult;
    //
    property OnError:TNotifyEvent read FOnError write FOnError;
  end;

function CheckTypeStr(ACheckType:TCheckType):string;
function PaymentTypeStr(APaymentType:TPaymentType):string;
procedure MakeCRPTCode(APrefix:Word; AGTIN:string; ASerial:string; var R:TCrpCodeBuffer);
function MakeCRPTCodeStr(APrefix:Word; AGTIN:string; ASerial:string):string;
function KMStatusEx(AStatus:DWord):string;
implementation
uses Math;

function KMStatusEx(AStatus:DWord):string;
begin
  case AStatus of
    %00000000:Result:='[М] Проверка КП КМ не выполнена, статус товара ОИСМ не проверен';
    %00000001:Result:='[М-] Проверка КП КМ выполнена в ФН с отрицательным результатом, статус товара ОИСМ не проверен';
    %00000011:Result:='[М] Проверка КП КМ выполнена с положительным результатом, статус товара ОИСМ не проверен';
    %00010000:Result:='[М] Проверка КП КМ не выполнена, статус товара ОИСМ не проверен (ККТ функционирует в автономном режиме)';
    %00010001:Result:='[М-] Проверка КП КМ выполнена в ФН с отрицательным результатом, статус товара ОИСМ не проверен (ККТ функционирует в автономном режиме)';
    %00010011:Result:='[М] Проверка КП КМ выполнена в ФН с положительным результатом, статус товара ОИСМ не проверен (ККТ функционирует в автономном режиме)';
    %00000101:Result:='[М-] Проверка КП КМ выполнена с отрицательным результатом, статус товара у ОИСМ некорректен';
    %00000111:Result:='[М-] Проверка КП КМ выполнена с положительным результатом, статус товара у ОИСМ некорректен';
    %00001111:Result:='[М+] Проверка КП КМ выполнена с положительным результатом, статус товара у ОИСМ корректен';
  else
    Result:=Format( 'Статус не определён: %d', [AStatus]);
  end;
end;

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

{ TPaymentsListEnumerator }

constructor TPaymentsListEnumerator.Create(AList: TPaymentsList);
begin
  FList := AList;
  FPosition := -1;
end;

function TPaymentsListEnumerator.GetCurrent: TPaymentInfo;
begin
  Result := FList[FPosition];
end;

function TPaymentsListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TPaymentsList }

function TPaymentsList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TPaymentsList.GetItems(AIndex: integer): TPaymentInfo;
begin
  Result:=TPaymentInfo(FList[AIndex])
end;

constructor TPaymentsList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TPaymentsList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TPaymentsList.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count - 1 do
    TPaymentInfo(FList[i]).Free;
  FList.Clear;
end;

function TPaymentsList.Add: TPaymentInfo;
begin
  Result:=TPaymentInfo.Create;
  FList.Add(Result);
end;

function TPaymentsList.GetEnumerator: TPaymentsListEnumerator;
begin
  Result:=TPaymentsListEnumerator.Create(Self);
end;

{ TPaymentInfo }

constructor TPaymentInfo.Create;
begin
  inherited Create;
end;

destructor TPaymentInfo.Destroy;
begin
  inherited Destroy;
end;

procedure TPaymentInfo.Clear;
begin
  FPaymentSum:=0;
  FPaymentType:=pctCash;
end;

{ TGoodsListEnumerator }

constructor TGoodsListEnumerator.Create(AList: TGoodsList);
begin
  FList := AList;
  FPosition := -1;
end;

function TGoodsListEnumerator.GetCurrent: TGoodsInfo;
begin
  Result := FList[FPosition];
end;

function TGoodsListEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FList.Count;
end;

{ TGoodsList }

function TGoodsList.GetCount: integer;
begin
  Result:=FList.Count;
end;

function TGoodsList.GetItems(AIndex: integer): TGoodsInfo;
begin
  Result:=TGoodsInfo(FList[AIndex]);
end;

constructor TGoodsList.Create;
begin
  inherited Create;
  FList:=TFPList.Create;
end;

destructor TGoodsList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TGoodsList.Clear;
var
  i: Integer;
begin
  for i:=0 to FList.Count - 1 do
    TGoodsInfo(FList[i]).Free;
  FList.Clear;
end;

function TGoodsList.Add: TGoodsInfo;
begin
  Result:=TGoodsInfo.Create;
  FList.Add(Result);
end;

function TGoodsList.GetEnumerator: TGoodsListEnumerator;
begin
  Result:=TGoodsListEnumerator.Create(Self);
end;

{ TGoodsNomenclatureCode }

procedure TGoodsNomenclatureCode.Clear;
begin
  FGroupCode:=0;
  FGTIN:='';
  FSerial:='';
  KM:='';
  State:=0;
end;

function TGoodsNomenclatureCode.Make1162Value: TBytes;
var
  R: TCrpCodeBuffer;
  L: Integer;
begin
  MakeCRPTCode(FGroupCode, FGTIN, FSerial, R);
  //L:=SizeOf(TCrpCodeBuffer);
  L:=21;
  SetLength(Result, L);
  Move(R[1], Result[0], L);
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
  FGoodsType:=gtNone;
  FGoodsArticle:='';
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
  FGoodsList:=TGoodsList.Create;
  FPaymentsList:=TPaymentsList.Create;
end;

destructor TCashRegisterAbstract.Destroy;
begin
  FreeAndNil(FCounteragentInfo);
  FreeAndNil(FCheckInfo);
  FreeAndNil(FGoodsInfo);
  FreeAndNil(FTextParams);
  FreeAndNil(FDeviceInfo);
  FreeAndNil(FGoodsList);
  FreeAndNil(FPaymentsList);
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

procedure TCashRegisterAbstract.Open;
begin
  InternalOpenKKM;
  InternalUserLogin;
  InternalCheckError;
end;

procedure TCashRegisterAbstract.Close;
begin
  InternalCloseKKM;
end;

function TCashRegisterAbstract.GetVersionString: string;
begin
  Result:='';
end;

procedure TCashRegisterAbstract.GetOFDStatus(out AStatus: TOFDSTatusRecord);
begin
  FillChar(AStatus, SizeOf(TOFDSTatusRecord), 0);
end;

function TCashRegisterAbstract.NonNullableSum: Currency;
begin
  Result:=0;
end;

procedure TCashRegisterAbstract.OpenShift;
begin
  //
end;

procedure TCashRegisterAbstract.BeginCheck;
begin
  FGoodsList.Clear;
  FPaymentsList.Clear;
  FCounteragentInfo.Clear;
  FCheckInfo.Clear;
  FAgentInfo.Clear;
  FTextParams.Clear;
  FGoodsInfo.Clear;
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
  FGoodsList.Clear;
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
  FGoodsList.Clear;
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

