unit ecr_CashRegisterFictiveUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, CasheRegisterAbstract;

const
  fcLineWidth = 60;

const
  sFictiveDriverName = 'Тестовый фиктивный драйвер ККМ - только для тестирования!';

type

  { TCashRegisterFictive }

  TCashRegisterFictive = class(TCashRegisterAbstract)
  private
    FCurCheckNum:Integer;
    FCheckOpen:Boolean;
    FCheckMemo:TStringList;
    FOrgINN: string;
    FOrgName: string;
    procedure SetOrgINN(AValue: string);
    procedure SetOrgName(AValue: string);
  protected
    procedure InternalUserLogin; override;
    function GetCheckNumber: integer; override;
    function GetCheckOpen: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function RegisterGoods:Integer; override;
    function RegisterPayments:Integer; override;
    procedure RegisterPayment(APaymentType:TPaymentType; APaymentSum:Currency); override;
    procedure OpenCheck; override;
    function CloseCheck:Integer; override;                   //Закрыть чек (со сдачей)
    function CancelCheck:integer; override;                   //Аннулирование всего чека
    function ValidateGoodsKM:Boolean; override;
    function GetVersionString:string; override;
    procedure ReportZ; override;
    procedure ReportX(AReportType: Byte); override;
    procedure PrintLine(ALine:string);override;    //Печать строки
    procedure BeginNonfiscalDocument; override;
    procedure EndNonfiscalDocument; override;
    procedure PrintNonfiscalDocument(ADoc:TStrings; ACutDoc:Boolean; ASkipLine:Integer = 0); override;

    property OrgName:string read FOrgName write SetOrgName;
    property OrgINN:string read FOrgINN write SetOrgINN;
  end;


procedure Register;
procedure ShowCheckForm(AEcr:TCashRegisterFictive; const AChekStr:string); overload;
procedure ShowCheckForm(AEcr:TCashRegisterFictive; const AChekStr:string; Args:array of const); overload;

implementation
uses rxlogging, rxstrutils, LazUTF8, Forms, ecr_ShowMemoInfoUnit;

function GoodsPayModeStr(AGoodsPayMode:TGoodsPayMode):string;
begin
  case AGoodsPayMode of
    gpmFullPay:Result:='полный расчет';
    gpmPrePay100:Result:='предоплата 100%';
    gpmPrePay:Result:='предоплата';
    gpmAvance:Result:='аванс';
    gpmFullPay2:Result:='полный расчет2';
    gpmPartialPayAndKredit:Result:='частичный расчет и кредит';
    gpmKredit:Result:='передача в кредит';
    gpmKreditPay:Result:='оплата кредита';
  end;
end;


function GoodsTypeStr(AGoodsType:TGoodsType):string;
begin
  case AGoodsType of
    gtNone:Result:='По умолчанию';
    gtCommodity:Result:='товар';
    gtExcise:Result:='подакцизный товар';
    gtJob:Result:='работа';
    gtService:Result:='услуга';
    gtGamblingBet:Result:='ставка азартной игры';
    gtGamblingPrize:Result:='выигрыш азартной игры';
    gtLottery:Result:='лотерейный билет';
    gtLotteryPrize:Result:='выигрыш лотереи';
    gtIntellectualActivity:Result:='предоставление результатов интерелектуальной деятельности';
    gtPayment:Result:='платеж';
    gtAgentCommission:Result:='агентское вознаграждение';
    gtComposite:Result:='выплата';
    gtAnother:Result:='иной предмет расчета';
    gtProprietaryLaw:Result:='имущественное право';
    gtNonOperatingIncome:Result:='внереализационный доход';
    gtInsuranceContributions:Result:='иные платежи и взносы';
    gtMerchantTax:Result:='торговый сбор';
    gtResortFee:Result:='курортный сбор';
    gtDeposit:Result:='залог';
    gtConsumption:Result:='расход';
    gtSoleProprietorCPIContributions:Result:='взносы на ОПС ИП';
    gtCpiContributions:Result:='взносы на ОПС';
    soleProprietorCMIContributions:Result:='взносы на ОМС ИП';
    gtCmiContributions:Result:='взносы на ОМС';
    gtCsiContributions:Result:='взносы на ОСС';
    gtCasinoPayment:Result:='платеж казино';
  else
    Result:='Прочее (' + IntToStr(Ord(AGoodsType))
  end;
end;

procedure ShowCheckForm(AEcr:TCashRegisterFictive; const AChekStr:string); overload;
var
  S: String;
begin
  kssShowPKSlipForm:=TkssShowPKSlipForm.Create(Application);
  kssShowPKSlipForm.Memo1.WordWrap:=false;
  kssShowPKSlipForm.Caption:='Фиктивный чек';
  S:=
  MS('-', fcLineWidth) + LineEnding +
  'Касовый чек (фиктивный)'  + LineEnding +
  AEcr.OrgName + LineEnding +
  'ИНН : ' + AEcr.OrgINN + LineEnding +
  MS('-', fcLineWidth) + LineEnding +
  AChekStr + LineEnding +
  MS('-', fcLineWidth) + LineEnding +
  'Кассир: ' + AEcr.UserName + LineEnding +
  DateTimeToStr(Now) + LineEnding +
  'Чек '+IntToStr(AEcr.FCurCheckNum)
  ;
  kssShowPKSlipForm.Memo1.Text:=S;
  kssShowPKSlipForm.ShowModal;
  kssShowPKSlipForm.Free;
  RxWriteLog(etInfo, 'Фиктивный чек' + LineEnding + S);
end;

procedure ShowCheckForm(AEcr:TCashRegisterFictive; const AChekStr:string; Args:array of const); overload;
begin
  ShowCheckForm(AEcr, Format(AChekStr, Args));
end;

procedure Register;
begin
  RegisterComponents('TradeEquipment',[TCashRegisterFictive]);
end;

{ TCashRegisterFictive }

procedure TCashRegisterFictive.SetOrgName(AValue: string);
begin
  if FOrgName=AValue then Exit;
  FOrgName:=AValue;
end;

procedure TCashRegisterFictive.SetOrgINN(AValue: string);
begin
  if FOrgINN=AValue then Exit;
  FOrgINN:=AValue;
end;

procedure TCashRegisterFictive.InternalUserLogin;
begin
  RxWriteLog(etDebug, 'UserName=%s, Password=%s, KassaUserINN=%s', [UserName, Password, KassaUserINN]);
end;

function TCashRegisterFictive.GetCheckNumber: integer;
begin
  Result:=FCurCheckNum;
end;

function TCashRegisterFictive.GetCheckOpen: boolean;
begin
  Result:=FCheckOpen;
end;

constructor TCashRegisterFictive.Create(AOwner: TComponent);
var
  MS, S, M, H: word;
begin
  inherited Create(AOwner);
  FCheckMemo:=TStringList.Create;
  DecodeTime(Time, H, M, S, MS);
  FCurCheckNum:=H * 60* 60 + M * 60 + S;
  FCheckOpen:=false;
end;

destructor TCashRegisterFictive.Destroy;
begin
  FreeAndNil(FCheckMemo);
  inherited Destroy;
end;

function TCashRegisterFictive.RegisterGoods: Integer;
var
  GI: TGoodsInfo;
begin
  for GI in GoodsList do
  begin;
    RxWriteLog(etDebug, 'Name=%s, Quantity=%f, Price=%f, TaxType=%d', [GI.Name, GI.Quantity, GI.Price, Ord(GI.TaxType)]);

    //GI.GoodsPayMode:=gpmAvance;
    //GI.GoodsType:=gtCommodity;
  end;
end;

function TCashRegisterFictive.RegisterPayments: Integer;
var
  FPayInfo: TPaymentInfo;
begin
  Result:=0;
  for FPayInfo in PaymentsList do
  begin
    RegisterPayment(FPayInfo.PaymentType, FPayInfo.PaymentSum);
    if ErrorCode <> 0 then
      Exit;
  end;
end;

function TCashRegisterFictive.ValidateGoodsKM: Boolean;
var
  GI: TGoodsInfo;
begin
  Result:=True;
  for GI in GoodsList do
  begin
    if GI.GoodsNomenclatureCode.KM <> '' then
      GI.GoodsNomenclatureCode.State:=%00001111
    else
      GI.GoodsNomenclatureCode.State:=0;
  end;
end;

procedure TCashRegisterFictive.RegisterPayment(APaymentType: TPaymentType;
  APaymentSum: Currency);
begin
  //
end;

procedure TCashRegisterFictive.OpenCheck;
begin
  if FCheckOpen then
    raise Exception.Create('Чек уже открыт');

  inherited OpenCheck;
  FCheckMemo.Clear;

  InternalUserLogin;
  Inc(FCurCheckNum);

  RxWriteLog(etDebug, 'CurCheckNum=%d, ', [FCurCheckNum]);
  RxWriteLog(etDebug, 'CheckType=%s, ', [CheckTypeStr(CheckType)]);
  RxWriteLog(etDebug, 'CounteragentInfo.Name=%s, CounteragentInfo.INN=%s, CounteragentInfo.Email=%s, CounteragentInfo.Phone=%s', [CounteragentInfo.Name, CounteragentInfo.INN, CounteragentInfo.Email, CounteragentInfo.Phone]);
  RxWriteLog(etDebug, 'PaymentPlace=%s, ', [PaymentPlace]);
  RxWriteLog(etDebug, 'Electronically=%s', [CheckInfo.Electronically.ToString]);
  FCheckOpen:=true;
end;

function TCashRegisterFictive.CloseCheck: Integer;
var
  S, S1: String;
  GI: TGoodsInfo;
  FPayInfo: TPaymentInfo;
  FSum: Extended;
begin
  if not FCheckOpen then
    raise Exception.Create('Чек не открыт');

  if GoodsList.Count = 0 then
    raise Exception.Create('Нет зарегистрированных строк к оплате');

  S:='';
  FSum:=0.0;


  if CounteragentInfo.Name<>'' then
    S:=S + 'Покупатель: ' + CounteragentInfo.Name + LineEnding +
           'ИНН: ' + CounteragentInfo.INN  + LineEnding
  else
  if CheckInfo.Electronically then
    S:=S + 'Электронны чек' + LineEnding +
           'Адрес:' + CounteragentInfo.Email + LineEnding;


  S:=S + MS('-', fcLineWidth) + LineEnding +
    MS(' ', 10) + 'КАССОВЫЙ ЧЕК / ' + UTF8UpperCase(CheckTypeStr(CheckType)) + LineEnding;

  for GI in GoodsList do
  begin;
    S:=S + LineEnding;

    if GI.GoodsNomenclatureCode.KM<>'' then
      S1:=Trim(UTF8Copy(KMStatusEx(GI.GoodsNomenclatureCode.State), 1, 4))
    else
      S1:='';
    S:=S + UTF8UpperCase(GoodsTypeStr(GI.GoodsType)) + '      ' + UTF8UpperCase(GoodsPayModeStr(GI.GoodsPayMode)) + LineEnding;
    S:=S + UTF8Copy(GI.Name, 1, fcLineWidth) + LineEnding +
      MS(' ', 10) + S1 + ' ' + FloatToStr(GI.Quantity) +' x ' + FloatToStr( GI.Price ) + ' = ' + FloatToStr(GI.Quantity * GI.Price ) + ' ' + CHR(Ord('A') + Ord(GI.TaxType)-1) + LineEnding;
    S:=S + TaxTypeStr(GI.TaxType) + LineEnding;

    FSum:=FSum + GI.Quantity * GI.Price;
    //RxWriteLog(etDebug, 'Name=%s, Quantity=%f, Price=%f, TaxType=%d', [GI.Name, GI.Quantity, GI.Price, Ord(GI.TaxType)]);

    //GI.GoodsPayMode:=gpmAvance;
    //GI.GoodsType:=gtCommodity;
  end;
  S:=S + MS('-', fcLineWidth) + LineEnding +
    MS(' ', 15) + 'ИТОГ = ' + FloatToStr(FSum) + LineEnding;

  for FPayInfo in PaymentsList do
  begin
    S:=S + MS(' ', 15) + PaymentTypeStr(FPayInfo.PaymentType) + ' = ' + FloatToStr(FPayInfo.PaymentSum) + LineEnding;
  end;

  //RxWriteLog(etDebug, 'TFictiveDriverKKM.IsCheckOpen ACloseType:%d', [CloseType]);
  ShowCheckForm(Self, S);

  Result:=inherited CloseCheck;
  FCheckOpen:=false;
end;

function TCashRegisterFictive.CancelCheck: integer;
var
  S: String;
begin
  if not FCheckOpen then
    raise Exception.Create('Чек не открыт');
  S:='Чек отменён';
  ShowCheckForm(Self, S);

  Result:=inherited CancelCheck;
  FCheckOpen:=false;
end;

function TCashRegisterFictive.GetVersionString: string;
begin
  Result:='Фиктивный драйвер 1.0';
end;

procedure TCashRegisterFictive.ReportZ;
var
  S: String;
begin
  Inc(FCurCheckNum);
  S:='Z-Отчёт о закрытии смены';
  ShowCheckForm(Self, S);
end;

procedure TCashRegisterFictive.ReportX(AReportType: Byte);
var
  S: String;
begin
  Inc(FCurCheckNum);
  case AReportType of
     2:S:='X-Отчёт о закрытии смены';
  else
     S:=Format('Отчёт %d', [AReportType]);
  end;
  ShowCheckForm(Self, S);
end;

procedure TCashRegisterFictive.PrintLine(ALine: string);
begin
  FCheckMemo.Add(ALine);
  RxWriteLog(etDebug, 'TCashRegisterFictive.PrintLine: %s', [ALine]);
end;

procedure TCashRegisterFictive.BeginNonfiscalDocument;
begin
  RxWriteLog(etDebug, 'TCashRegisterFictive.BeginNonfiscalDocument');
  FCheckMemo.Add('====  BEGIN NONFISCAL DOCUMENT  ====');
end;

procedure TCashRegisterFictive.EndNonfiscalDocument;
begin
  RxWriteLog(etDebug, 'TCashRegisterFictive.EndNonfiscalDocument');
  FCheckMemo.Add('====  END NONFISCAL DOCUMENT  ====');
end;

procedure TCashRegisterFictive.PrintNonfiscalDocument(ADoc: TStrings;
  ACutDoc: Boolean; ASkipLine: Integer);
begin
  inherited PrintNonfiscalDocument(ADoc, ACutDoc);
  ShowCheckForm(Self, FCheckMemo.Text);
  FCheckOpen:=false;
end;

end.
