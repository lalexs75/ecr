{ Билиотека для работы с ККМ

  Copyright (C) 2013-2023 Лагунов Алексей alexs75@yandex.ru

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
    FConnected:Boolean;
    procedure SetOrgINN(AValue: string);
    procedure SetOrgName(AValue: string);
    procedure DoCheckConnected;
  protected
    procedure InternalUserLogin; override;
    function GetCheckNumber: integer; override;
    function GetCheckOpen: boolean; override;
    function GetConnected: boolean; override;
    procedure SetConnected(AValue: boolean); override;
    procedure InternalOpenKKM; override;
    procedure InternalCloseKKM; override;
    function GetFDNumber: integer; override;
    function GetDeviceDateTime: TDateTime; override;
    function GetShiftState: TShiftState; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function RegisterGoods:Integer; override;
    function RegisterPayments:Integer; override;
    procedure RegisterPayment(APaymentType:TPaymentType; APaymentSum:Currency); override;
    procedure RegisterPayment(APaymentInfo:TPaymentInfo); override;
    procedure OpenCheck; override;
    function CloseCheck:Integer; override;                 //Закрыть чек (со сдачей)
    function CancelCheck:integer; override;                //Аннулирование всего чека
    function ValidateGoodsKM:Boolean; override;
    function GetVersionString:string; override;
    function InternalCheckError:Integer; override;

    procedure ReportZ; override;
    procedure ReportX(AReportType: Byte); override;
    procedure PrintReportSection; override;
    procedure PrintReportHours; override;                  //Отчет по часам
    procedure PrintReportCounted; override;             //Отчет количеств
    procedure DemoPrint; override;                      //Демо-печать

    procedure GetOFDStatus(out AStatus:TOFDSTatusRecord); override;

    //Операции со сменой
    procedure OpenShift; override;                      //Открыть смену

    //Внесения и выплаты
    function CashIncome(APaymentSum:Currency):integer; override;          //Внесение денег
    function CashOutcome(APaymentSum:Currency):integer; override;         //Выплата денег

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

function muOKEItoStr(muCode:Integer):string;
begin
  case muCode of
    muPIECE:Result:='шт';         //шт
    muGRAM:Result:='г';           //Грамм
    muKILOGRAM:Result:='кг';      //Килограмм
    muTON:Result:='т';            //Тонна
    muCENTIMETER:Result:='см';    //Сантиметр
    muDECIMETER:Result:='дм';     //Дециметр
    muMETER:Result:='м';          //Метр
    muSQUARE_CENTIMETER:Result:='кв.см'; //Квадратный сантиметр
    muSQUARE_DECIMETER:Result:='кв.дм';  //Квадратный дециметр
    muSQUARE_METER:Result:='кв.м';       //Квадратный метр
    muMILLILITER:Result:='мл';           //Кубический сантиметр; миллилитр
    muLITER:Result:='л';                 //Литр; кубический дециметр
    muCUBIC_METER:Result:='м3';      //Кубический метр
    muKILOWATT_HOUR:Result:='кВт*ч'; //Киловатт-час
    muGKAL:Result:='Гкал';           //Гигакалория
    muDAY:Result:='сут';             //Сутки
    muHOUR:Result:='ч';              //Час
    muMINUTE:Result:='мин';          //Минута
    muSECOND:Result:='с';            //Секунда
    muKILOBYTE:Result:='кбайт';      //Килобайт
    muMEGABYTE:Result:='Мбайт';      //Мегабайт
    muGIGABYTE:Result:='Гбайт';      //Гигабайт
    muTERABYTE:Result:='Тбайт';      //Терабайт
  else
    //LIBFPTR_IU_OTHER = 255
    //Result:=LIBFPTR_IU_PIECE;
    Result:='ДРУГОЕ';
  end;
end;


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

function ECRTimeZoneToStr(ATimeZone:TEcrTimeZone):string;
begin
  case ATimeZone of
    ecrTimeZoneNone:Result:='TimeZoneNone (-1)';
    ecrTimeZoneDevice:Result:='TimeZoneDevice';
    ecrTimeZone1:Result:='TimeZone 1 (UTC+2)';
    ecrTimeZone2:Result:='TimeZone 2 (UTC+3)';
    ecrTimeZone3:Result:='TimeZone 3 (UTC+4)';
    ecrTimeZone4:Result:='TimeZone 4 (UTC+5)';
    ecrTimeZone5:Result:='TimeZone 5 (UTC+6)';
    ecrTimeZone6:Result:='TimeZone 6 (UTC+7)';
    ecrTimeZone7:Result:='TimeZone 7 (UTC+8)';
    ecrTimeZone8:Result:='TimeZone 8 (UTC+9)';
    ecrTimeZone9:Result:='TimeZone 9 (UTC+10)';
    ecrTimeZone10:Result:='TimeZone 10 (UTC+11)';
    ecrTimeZone11:Result:='TimeZone 11 (UTC+12)';
  else
    Result:=Format('Не известная временная зона (%d)', [Ord(ATimeZone)]);
  end
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

procedure TCashRegisterFictive.DoCheckConnected;
begin
  if not FConnected then
    raise Exception.Create('CashRegisterFictive disconnected');
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

function TCashRegisterFictive.GetConnected: boolean;
begin
  Result:=FConnected;
end;

procedure TCashRegisterFictive.SetConnected(AValue: boolean);
begin
  if AValue then
  begin
    if FConnected then
      raise Exception.Create('CashRegisterFictive already connected')
    else
      FConnected:=true;
  end
  else
  begin
    if not FConnected then
      raise Exception.Create('CashRegisterFictive already disconnected')
    else
      FConnected:=false;
  end;
end;

procedure TCashRegisterFictive.InternalOpenKKM;
begin
  RxWriteLog(etDebug, 'InternalOpenKKM');
end;

procedure TCashRegisterFictive.InternalCloseKKM;
begin
  RxWriteLog(etDebug, 'InternalCloseKKM');
end;

function TCashRegisterFictive.GetFDNumber: integer;
begin
  Result:=FCurCheckNum;
end;

function TCashRegisterFictive.GetDeviceDateTime: TDateTime;
begin
  Result:=Now;
end;

function TCashRegisterFictive.GetShiftState : TShiftState;
begin
  Result:=ssOPENED;
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
  Result:=0;
  DoCheckConnected;
  for GI in GoodsList do
  begin;
    RxWriteLog(etDebug, 'Name=%s, Quantity=%f, Price=%f, TaxType=%d, GoodsMeasurementUnit=%d', [GI.Name, GI.Quantity, GI.Price, Ord(GI.TaxType), GI.GoodsMeasurementUnit]);

    //GI.GoodsPayMode:=gpmAvance;
    //GI.GoodsType:=gtCommodity;
  end;
end;

function TCashRegisterFictive.RegisterPayments: Integer;
var
  FPayInfo: TPaymentInfo;
begin
  Result:=0;
  DoCheckConnected;
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
  DoCheckConnected;
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
  DoCheckConnected;
end;

procedure TCashRegisterFictive.RegisterPayment(APaymentInfo : TPaymentInfo);
begin
  DoCheckConnected;
end;

procedure TCashRegisterFictive.OpenCheck;
begin
  DoCheckConnected;
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
  STechInfo : String;
begin
  DoCheckConnected;
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

  if CheckType in [chtSellCorrection, chtSellReturnCorrection, chtBuyCorrection, chtBuyReturnCorrection] then
  begin
    S:=S + 'Основание для коррекции: ' + DateToStr(CorrectionInfo.CorrectionDate) + LineEnding;
    if CorrectionInfo.CorrectionBaseNumber <> '' then
      S:=S + CorrectionInfo.CorrectionBaseNumber + LineEnding;
    S:=S + 'Тип коррекции: ' + CorrectionTypeStr(CorrectionInfo.CorrectionType) + LineEnding;
  end;


  if FCheckInfoLines.Count>0 then
    S:=S + LineEnding + FCheckInfoLines.Text + LineEnding;


  for GI in GoodsList do
  begin;
    S:=S + LineEnding;

    if GI.GoodsNomenclatureCode.KM<>'' then
      S1:=Trim(UTF8Copy(KMStatusEx(GI.GoodsNomenclatureCode.State), 1, 4))
    else
      S1:='';
    S:=S + UTF8UpperCase(GoodsTypeStr(GI.GoodsType)) + '      ' + UTF8UpperCase(GoodsPayModeStr(GI.GoodsPayMode)) + LineEnding;
    S:=S + UTF8Copy(GI.Name, 1, fcLineWidth) + LineEnding +
      MS(' ', 10) + muOKEItoStr( GI.GoodsMeasurementUnit) + ' ' +
       S1 + ' ' + FloatToStr(GI.Quantity) +' x ' + FloatToStr( GI.Price ) + ' = ' + FloatToStr(GI.Quantity * GI.Price ) + ' ' + CHR(Ord('A') + Ord(GI.TaxType)-1) + LineEnding;
    S:=S + TaxTypeStr(GI.TaxType) + LineEnding;

    FSum:=FSum + GI.Quantity * GI.Price;
    //RxWriteLog(etDebug, 'Name=%s, Quantity=%f, Price=%f, TaxType=%d', [GI.Name, GI.Quantity, GI.Price, Ord(GI.TaxType)]);

    //GI.GoodsPayMode:=gpmAvance;
    //GI.GoodsType:=gtCommodity;

    if GI.GoodsNomenclatureCode.PermissiveModeDoc.UUID <> '' then
    begin
      S:= S + MS('-', fcLineWidth) + LineEnding +
          'Разрешительный режим '+ LineEnding +
           MS(' ', 10) + 'UUID=' + GI.GoodsNomenclatureCode.PermissiveModeDoc.UUID + LineEnding +
           MS(' ', 10) + 'Time=' + GI.GoodsNomenclatureCode.PermissiveModeDoc.DocTimeStamp + LineEnding
           ;
    end;

  end;
  S:=S + MS('-', fcLineWidth) + LineEnding +
    MS(' ', 15) + 'ИТОГ = ' + FloatToStr(FSum) + LineEnding;

  for FPayInfo in PaymentsList do
  begin
    S:=S + MS(' ', 15) + PaymentTypeStr(FPayInfo.PaymentType) + ' = ' + FloatToStr(FPayInfo.PaymentSum) + LineEnding;

    if FPayInfo.PaymentType = pctElectronically then
    begin
      S:=S + MS(' ', 15) + Format('ElectronPaytMethod=%d,  PaymentId=%s, PaymentAddInfo=%s', [Ord(FPayInfo.PaymentType), FPayInfo.PaymentId, FPayInfo.PaymentAddInfo]) +  LineEnding;
    end;
  end;


  STechInfo := '';
  if PermissiveModeDoc.UUID <> '' then
  begin
    STechInfo:= STechInfo + LineEnding +
        'Разрешительный режим '+ LineEnding +
         MS(' ', 10) + 'UUID=' + PermissiveModeDoc.UUID + LineEnding +
         MS(' ', 10) + 'Time=' + PermissiveModeDoc.DocTimeStamp + LineEnding
         ;
  end;

  if TimeZone <> ecrTimeZoneNone then
  begin
    STechInfo:= STechInfo +
        'Временная зона : '+ ECRTimeZoneToStr(TimeZone) + LineEnding;
  end;

  if InternetPayment then
  begin
    STechInfo:= STechInfo +
        'Место расчёта ИНТЕРНЕТ.'+ LineEnding +
        'Адрес сайта ' + InternetPaymentURL + LineEnding;
  end;

  if STechInfo <> '' then
    S:= S + LineEnding + MS('-', fcLineWidth) + LineEnding + STechInfo;

  ShowCheckForm(Self, S);

  Result:=inherited CloseCheck;
  FCheckOpen:=false;
end;

function TCashRegisterFictive.CancelCheck: integer;
var
  S: String;
begin
  DoCheckConnected;
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

function TCashRegisterFictive.InternalCheckError: Integer;
begin
  RxWriteLog(etDebug, 'Test error code');
  ClearError;
end;

procedure TCashRegisterFictive.ReportZ;
var
  S: String;
begin
  DoCheckConnected;
  Inc(FCurCheckNum);
  S:='Z-Отчёт о закрытии смены';
  RxWriteLog(etDebug, S);
  ShowCheckForm(Self, S);
end;

procedure TCashRegisterFictive.ReportX(AReportType: Byte);
var
  S: String;
begin
  DoCheckConnected;
  Inc(FCurCheckNum);
  case AReportType of
     2:S:='X-Отчёт о закрытии смены';
  else
     S:=Format('Отчёт %d', [AReportType]);
  end;
  ShowCheckForm(Self, S);
end;

procedure TCashRegisterFictive.PrintReportSection;
var
  S: String;
begin
  DoCheckConnected;
  S:='Отчёт по секциям';
  RxWriteLog(etDebug, S);
  ShowCheckForm(Self, S);
end;

procedure TCashRegisterFictive.PrintReportHours;
var
  S: String;
begin
  DoCheckConnected;
  S:='Отчёт по часам';
  RxWriteLog(etDebug, S);
  ShowCheckForm(Self, S);
end;

procedure TCashRegisterFictive.PrintReportCounted;
var
  S: String;
begin
  DoCheckConnected;
  S:='Отчёт по количествам';
  RxWriteLog(etDebug, S);
  ShowCheckForm(Self, S);
end;

procedure TCashRegisterFictive.DemoPrint;
var
  S: String;
begin
  DoCheckConnected;
  S:='Demo print' + LineEnding +
     'DEMO PRINT' + LineEnding +
     'ТЕСТОВАЯ ПЕЧАТЬ' + LineEnding +
     'Тестовая печать' + LineEnding;
  RxWriteLog(etDebug, S);
  ShowCheckForm(Self, S);
end;

procedure TCashRegisterFictive.GetOFDStatus(out AStatus: TOFDSTatusRecord);
begin
  DoCheckConnected;
  inherited GetOFDStatus(AStatus);
  AStatus.ExchangeStatus:=0;
  AStatus.UnsentCount:=0;
  AStatus.FirstUnsentNumber:=0;
  AStatus.OfdMessageRead:=true;
  AStatus.LastSendDocDate:=Now;
end;

procedure TCashRegisterFictive.OpenShift;
var
  S: String;
begin
  inherited OpenShift;
  DoCheckConnected;
  S:='Открытие смены' + LineEnding;
  RxWriteLog(etDebug, S);
  ShowCheckForm(Self, S);
end;

function TCashRegisterFictive.CashIncome(APaymentSum: Currency): integer;
var
  S: String;
begin
  Result:=0;
  DoCheckConnected;
  S:='Чек внесения в кассу ' +  LineEnding +
     '   Сумма : ' + FloatToStr(APaymentSum) ;
  RxWriteLog(etDebug, S);
  ShowCheckForm(Self, S);
end;

function TCashRegisterFictive.CashOutcome(APaymentSum: Currency): integer;
var
  S: String;
begin
  Result:=0;
  DoCheckConnected;
  S:='Чек выплаты из кассы ' +  LineEnding +
     '   Сумма : ' + FloatToStr(APaymentSum) ;
  RxWriteLog(etDebug, S);
  ShowCheckForm(Self, S);
end;

procedure TCashRegisterFictive.PrintLine(ALine: string);
begin
  DoCheckConnected;
  FCheckMemo.Add(ALine);
  RxWriteLog(etDebug, 'TCashRegisterFictive.PrintLine: %s', [ALine]);
end;

procedure TCashRegisterFictive.BeginNonfiscalDocument;
begin
  DoCheckConnected;
  RxWriteLog(etDebug, 'TCashRegisterFictive.BeginNonfiscalDocument');
  FCheckMemo.Add('====  BEGIN NONFISCAL DOCUMENT  ====');
end;

procedure TCashRegisterFictive.EndNonfiscalDocument;
begin
  DoCheckConnected;
  RxWriteLog(etDebug, 'TCashRegisterFictive.EndNonfiscalDocument');
  FCheckMemo.Add('====  END NONFISCAL DOCUMENT  ====');
end;

procedure TCashRegisterFictive.PrintNonfiscalDocument(ADoc: TStrings;
  ACutDoc: Boolean; ASkipLine: Integer);
begin
  DoCheckConnected;
  inherited PrintNonfiscalDocument(ADoc, ACutDoc);
  ShowCheckForm(Self, FCheckMemo.Text);
  FCheckOpen:=false;
end;

end.

