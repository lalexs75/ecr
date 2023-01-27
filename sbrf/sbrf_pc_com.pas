{**************************************************************************}
{ Библиотека работы с платёжными терминалами пластиковых карт              }
{ в стандарте, предоставляемым Сбербанком                                  }
{ Free Pascal Compiler версии 3.1.1 и Lazarus 1.9 и выше.                  }
{ Лагунов Алексей (С) 2017  alexs75.at.yandex.ru                           }
{**************************************************************************}

unit sbrf_pc_com;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, alexs_plastic_cards_abstract;

const
  sbcmdPay = 4000; //Оплата покупки
//  4001  Выдача наличных
  sbcmdRevert = 4002; //Возврат покупки
  sbcmdCancel = 4003; //Отмена операции
//  4004  Безналичный перевод при наличии карты клиента
//  4005  Безналичный перевод при отсутствии карты клиента
//  4006  Ввод слипа по картам Amex
//  4007  Слип оплаты
//  4008  Слип выдачи наличных
//  4009  Предавторизация. Если задан параметр RRN, выполняется добавочная авторизация
//  4010  Завершение расчета. Если сумма равна 0, выполняется отмена предавторизации.
//  4011  Взнос наличных (предварительное зачисление)
//  4012  Взнос наличных (подтверждение)
//  4013  Погашение кредита
//  4014  Перевод с карты на карту
//  4015  Коммунальный платеж
//  4016  Арест средств
//  4017  Списание по аресту
//  4018  Снятие (отмена) ареста
//  4019  Выдача наличных без карты
//  4020  Списание по требованию
//  4021  Создание ПИН-кода
//  4022  Смена ПИН-кода
//  4023  Оплата услуг банка
//  4024  Запись отпечатков пальцев на карту ПРО100
//  4025  Установка оффлайн-лимита карты ПРО100
//  4026  Распечатка истории операций по карте ПРО100


//  5000  Запрос баланса
//  5001  Разблокировка международных карт с чипом
//  5002  Получение идентификатора карты
//  5003  Блокировка карты
//  5004  Считывание карты и проверка ПИН-кода
//  5005  Ввод экранной подписи на пинпадах Vx820 и iSC250
//  5006  Подтверждение текста клиентом
//  5007  Ввод данных клиентом

  sbcmdReportItog = 6000;//  Итоги дня по картам с магнитной полосой
//  6001  Подтвердить транзакцию (confirm)
  sbcmdReportX = 6002; //  Х-отчет по картам с магнитной полосой
//  6003  Перевести транзакцию в «подвешенное» состояние (suspend)
//  6004  Аварийно отменить транзакцию (rollback)

//  7000  Формирование текущего отчета по всем типам карт
//  7001  Повторное формирование последнего чека
//  7002  Печать старой контрольной ленты из резервной копии
//  7005  Установить дополнительные реквизиты платежа (например, номера авиабилетов)
//  7006  Получить операцию из контрольной ленты

type
  TsbKernelType = (sbComObject, sbConsolePilot);

  { TSBPlasticCardCom }

  TSBPlasticCard = class(TPlasticCardAbstract)
  private
    FKernelType: TsbKernelType;
    FTPK: OleVariant;  //Устройстов терминала пластиковых карт
    FStatusVector:string;

    FAmountClear:Double;
    FAmount:Double;
    FCardName:string;
    FCardType:integer;
    FTrxDate:string;
    FTrxTime:string;
    FTermNum:string;
    FMerchNum:string;
    FAuthCode:string;
    FMerchantTSN:integer;
    FMerchantBatchNum:integer;
    FClientCard:string;
    FClientExpiryDate:string;
    FHash:string;
    FOwnCard:integer;
    FLoyaltyIdentifier:integer;

    procedure InitTPK;
    procedure DoneTPK;
    function DoProcessError(AErrorCode:Integer):boolean;

    procedure SetKernelType(AValue: TsbKernelType);
    function SParamStr(AName, AValue: string): integer;
    function SParamInt(AName: string; AValueInt:Int64): integer;
    function NFun(AFuncNum:Integer):Integer;
    procedure AddToStatusVector(AName, AValue:string);
    procedure MakeInfo6XXX;
    procedure MakeInfo4XXX;
  protected
    procedure Clear; override;
    function GetStatusVector: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Pay(APaySum:Currency; ACheckNum:integer; APayTypeMethod:Integer); override;      //Оплата
    procedure ReportItog;override;                                     //Z отчёт
    procedure EchoTest;override;                                       //Проверка
    procedure Revert(ARevertSum:Currency; ACheckNum:string; APayTypeMethod:Integer; ADocID: string); override; //Возврат
    procedure Discard(ADiscardSum:Currency; ACheckNum:string; ADocID:string; APayTypeMethod:Integer); override; //Отмена
    procedure ReportOperList; override;
    procedure ReportOperSmall; override;
    procedure PPLoadConfig; override;
    procedure PPLoadSoftware; override;

    procedure GetWorkKey; override;
  published
    property KernelType:TsbKernelType read FKernelType write SetKernelType default sbComObject;
  end;

procedure Register;
implementation
uses LCLType, sbrf_pc_consts
{$IFDEF WINDOWS}
  , ComObj, ActiveX
{$ENDIF}
  ;

{$R ../sbrf_plastic_card.res}
procedure Register;
begin
  RegisterComponents('TradeEquipment',[TSBPlasticCard]);
end;

{ TSBPlasticCardCom }

procedure TSBPlasticCard.InitTPK;
begin
{$IFDEF WINDOWS}
  FTPK := CreateOleObject('SBRFSRV.Server');
{$ENDIF}
//  FTPK.Clear;
end;

procedure TSBPlasticCard.DoneTPK;
begin
  FTPK.Clear;
  FTPK:=null;
end;

function TSBPlasticCard.DoProcessError(AErrorCode: Integer): boolean;
begin
  FErrorCode:=AErrorCode;
  FErrorMessage:=sbpcErrorCodeToMsg(AErrorCode);
  Result:=FErrorCode = 0;
  DoOnStatus;
end;

procedure TSBPlasticCard.SetKernelType(AValue: TsbKernelType);
begin
  if FKernelType=AValue then Exit;
  FKernelType:=AValue;
end;

function TSBPlasticCard.SParamStr(AName, AValue: string): integer;
begin
  Result:=FTPK.SParam(AName, AValue);
end;

function TSBPlasticCard.SParamInt(AName: string; AValueInt: Int64): integer;
begin
  Result:=FTPK.SParam(AName, AValueInt);
end;

function TSBPlasticCard.NFun(AFuncNum: Integer): Integer;
begin
  Result:=FTPK.NFun(AFuncNum);
end;

procedure TSBPlasticCard.AddToStatusVector(AName, AValue: string);
begin
  if FStatusVector<>'' then
    FStatusVector:=FStatusVector + ';';
  FStatusVector:=FStatusVector + AName+':'+AValue;
end;

procedure TSBPlasticCard.MakeInfo6XXX;
var
  S:string;
begin
  FSlipInfo:=FTPK.GParamString('Cheque');
  FTrxDate:=FTPK.GParamString('TrxDate');
    AddToStatusVector('TrxDate',FTrxDate);
  FTrxTime:=FTPK.GParamString('TrxTime');
    AddToStatusVector('TrxDate',FTrxTime);
  FTermNum:=FTPK.GParamString('TermNum');
    AddToStatusVector('TermNum',FTermNum);
  FMerchNum:=FTPK.GParamString('MerchNum');
    AddToStatusVector('MerchNum',FMerchNum);
  S:=FTPK.GParamString('MerchantBatchNum');
  FMerchantBatchNum:=StrToIntDef(S, 0);
    AddToStatusVector('MerchantBatchNum',S);
end;

procedure TSBPlasticCard.MakeInfo4XXX;
var
  S:string;
begin
  FSlipInfo:=FTPK.GParamString('Cheque');
  FRRN:='';
  FRRN:=FTPK.GParamString('RRN');
    AddToStatusVector('RRN',FRRN);

  S:=FTPK.GParamString('AmountClear');
  FAmountClear:=StrToFloatDef(S, 0);
    AddToStatusVector('AmountClear',S);

  S:=FTPK.GParamString('Amount');
  FAmount:=StrToFloatDef(S, 0);
    AddToStatusVector('Amount',S);

  FCardName:=FTPK.GParamString('CardName');
    AddToStatusVector('CardName',FCardName);

  S:=FTPK.GParamString('CardType');
  FCardType:=StrToIntDef(S, 0);
    AddToStatusVector('CardType',S);

  FTrxDate:=FTPK.GParamString('TrxDate');
    AddToStatusVector('TrxDate',FTrxDate);
  FTrxTime:=FTPK.GParamString('TrxTime');
    AddToStatusVector('TrxTime',FTrxTime);
  FTermNum:=FTPK.GParamString('TermNum');
    AddToStatusVector('TermNum',FTermNum);
  FMerchNum:=FTPK.GParamString('MerchNum');
    AddToStatusVector('MerchNum',FMerchNum);
  FAuthCode:=FTPK.GParamString('AuthCode');
    AddToStatusVector('AuthCode',FAuthCode);

  S:=FTPK.GParamString('MerchantTSN');
  FMerchantTSN:=StrToIntDef(S, 0);
    AddToStatusVector('MerchantTSN',S);

  S:=FTPK.GParamString('MerchantBatchNum');
  FMerchantBatchNum:=StrToIntDef(S, 0);
  FInvoiceNumber:=IntToStr(FMerchantBatchNum);
    AddToStatusVector('MerchantBatchNum',S);

  FClientCard:=FTPK.GParamString('ClientCard');
    AddToStatusVector('ClientCard',FClientCard);
  FClientExpiryDate:=FTPK.GParamString('ClientExpiryDate');
    AddToStatusVector('ClientExpiryDate',FClientExpiryDate);
  FHash:=FTPK.GParamString('Hash');
    AddToStatusVector('Hash',FHash);

  S:=FTPK.GParamString('OwnCard');
  FOwnCard:=StrToIntDef(S, 0);
    AddToStatusVector('OwnCard',S);

  S:=FTPK.GParamString('LoyaltyIdentifier');
  FLoyaltyIdentifier:=StrToIntDef(S, 0);
    AddToStatusVector('LoyaltyIdentifier',S);
end;

procedure TSBPlasticCard.Clear;
begin
  inherited Clear;
  FTPK.Clear;
  FStatusVector:='';
end;

function TSBPlasticCard.GetStatusVector: string;
begin
  Result:=FStatusVector;
end;

constructor TSBPlasticCard.Create(AOwner: TComponent);
begin
{$IFDEF WINDOWS}
  CoInitializeEx(nil, COINIT_MULTITHREADED);
{$ENDIF}
  inherited Create(AOwner);
  FRRN:='';
end;

destructor TSBPlasticCard.Destroy;
begin
  inherited Destroy;
  {$IFDEF WINDOWS}
  CoUninitialize;
  {$ENDIF}
end;

procedure TSBPlasticCard.Pay(APaySum: Currency; ACheckNum: integer;
  APayTypeMethod: Integer);
var
  R: Int64;
  S:string;
begin
  InitTPK;
  Clear;
//  SParamInt('Amount', trunc(APaySum  * 100));
  R:=trunc(APaySum  * 100);
//  SParamInt('Amount', R);
  FTPK.SParam('Amount', R);
  DoProcessError(NFun(sbcmdPay)); //4000
  MakeInfo4XXX;

(*  if DoProcessError(NFun(sbcmdPay)) then //4000
  begin
    MakeInfo4XXX;
(*
    FSlipInfo:=FTPK.GParamString('Cheque');
    FRRN:=FTPK.GParamString('RRN');
      AddToStatusVector('RRN',FRRN);

    S:=FTPK.GParamString('AmountClear');
    FAmountClear:=StrToFloatDef(S, 0);
      AddToStatusVector('AmountClear',S);

    S:=FTPK.GParamString('Amount');
    FAmount:=StrToFloatDef(S, 0);
      AddToStatusVector('Amount',S);

    FCardName:=FTPK.GParamString('CardName');
      AddToStatusVector('CardName',FCardName);

    S:=FTPK.GParamString('CardType');
    FCardType:=StrToIntDef(S, 0);
      AddToStatusVector('CardType',S);

    FTrxDate:=FTPK.GParamString('TrxDate');
      AddToStatusVector('TrxDate',FTrxDate);
    FTrxTime:=FTPK.GParamString('TrxTime');
      AddToStatusVector('TrxTime',FTrxTime);
    FTermNum:=FTPK.GParamString('TermNum');
      AddToStatusVector('TermNum',FTermNum);
    FMerchNum:=FTPK.GParamString('MerchNum');
      AddToStatusVector('MerchNum',FMerchNum);
    FAuthCode:=FTPK.GParamString('AuthCode');
      AddToStatusVector('AuthCode',FAuthCode);

    S:=FTPK.GParamString('MerchantTSN');
    FMerchantTSN:=StrToIntDef(S, 0);
      AddToStatusVector('MerchantTSN',S);

    S:=FTPK.GParamString('MerchantBatchNum');
    FMerchantBatchNum:=StrToIntDef(S, 0);
      AddToStatusVector('MerchantBatchNum',S);

    FClientCard:=FTPK.GParamString('ClientCard');
      AddToStatusVector('ClientCard',FClientCard);
    FClientExpiryDate:=FTPK.GParamString('ClientExpiryDate');
      AddToStatusVector('ClientExpiryDate',FClientExpiryDate);
    FHash:=FTPK.GParamString('Hash');
      AddToStatusVector('Hash',FHash);

    S:=FTPK.GParamString('OwnCard');
    FOwnCard:=StrToIntDef(S, 0);
      AddToStatusVector('OwnCard',S);

    S:=FTPK.GParamString('LoyaltyIdentifier');
    FLoyaltyIdentifier:=StrToIntDef(S, 0);
      AddToStatusVector('LoyaltyIdentifier',S);
*)
(*

Число   AmountClear  - сумма операции без учета комиссии / скидки
Число   Amount - сумма операции с учетом комиссии / скидки
строка  CardName - название карты (Visa, Maestro и т.д.)
число   CardType - тип карты
строка  TrxDate - дата операции  (ДД.ММ.ГГГГ)
строка  TrxTime - время операции (ЧЧ:ММ:СС)
строка  TermNum - номер терминала
строка  MerchNum - номер мерчанта
строка  AuthCode - код авторизации
строка  RRN -номер ссылки
число   MerchantTSN  - номер транзакции в пакете терминала
число   MerchantBatchNum  - номер пакета терминала по магн.картам
строка  ClientCard - номер карты клиента
строка  ClientExpiryDate  - срок действия карты клиента
строка  Hash     - Хэш­–значение номера карты
число   OwnCard  - признак карты Сбербанка (0 или 1)
число   LoyaltyIdentifier – признак принадлежности карты настроенным в конфигурационном файле программа лояльности*)
  end
  else
    FSlipInfo:=FTPK.GParamString('Cheque');
*)
  DoneTPK;
end;

procedure TSBPlasticCard.ReportItog;
var
  S: String;
begin
  InitTPK;
  Clear;
  if DoProcessError(NFun(sbcmdReportItog)) then //6000
  begin
    MakeInfo6XXX;
{
    FSlipInfo:=FTPK.GParamString('Cheque');
    FTrxDate:=FTPK.GParamString('TrxDate');
      AddToStatusVector('TrxDate',FTrxDate);
    FTrxTime:=FTPK.GParamString('TrxTime');
      AddToStatusVector('TrxDate',FTrxTime);
    FTermNum:=FTPK.GParamString('TermNum');
      AddToStatusVector('TermNum',FTermNum);
    FMerchNum:=FTPK.GParamString('MerchNum');
      AddToStatusVector('MerchNum',FMerchNum);
    S:=FTPK.GParamString('MerchantBatchNum');
    FMerchantBatchNum:=StrToIntDef(S, 0);
      AddToStatusVector('MerchantBatchNum',S);
}
  end;
  DoneTPK;
end;

procedure TSBPlasticCard.EchoTest;
begin
  InitTPK;
  Clear;
  DoProcessError(FTPK.NFun(13));
  DoneTPK;
end;

procedure TSBPlasticCard.Revert(ARevertSum: Currency; ACheckNum: string;
  APayTypeMethod: Integer; ADocID: string);
var
  R: Int64;
begin
  InitTPK;
  Clear;
//  SParamInt('Amount', trunc(APaySum  * 100));
  R:=trunc(ARevertSum  * 100);
//  SParamInt('Amount', R);
  FTPK.SParam('Amount', R);
  if DoProcessError(NFun(sbcmdRevert)) then //4002
  begin
    MakeInfo4XXX;
//    FSlipInfo:=FTPK.GParamString('Cheque');
//    FRRN:=FTPK.GParamString('RRN');

(*

Число   AmountClear  - сумма операции без учета комиссии / скидки
Число   Amount - сумма операции с учетом комиссии / скидки
строка  CardName - название карты (Visa, Maestro и т.д.)
число   CardType - тип карты
строка  TrxDate - дата операции  (ДД.ММ.ГГГГ)
строка  TrxTime - время операции (ЧЧ:ММ:СС)
строка  TermNum - номер терминала
строка  MerchNum - номер мерчанта
строка  AuthCode - код авторизации
строка  RRN -номер ссылки
число   MerchantTSN  - номер транзакции в пакете терминала
число   MerchantBatchNum  - номер пакета терминала по магн.картам
строка  ClientCard - номер карты клиента
строка  ClientExpiryDate  - срок действия карты клиента
строка  Hash     - Хэш­–значение номера карты
число   OwnCard  - признак карты Сбербанка (0 или 1)
число   LoyaltyIdentifier – признак принадлежности карты настроенным в конфигурационном файле программа лояльности*)
  end;
  FSlipInfo:=FTPK.GParamString('Cheque');
  DoneTPK;
end;

procedure TSBPlasticCard.Discard(ADiscardSum: Currency; ACheckNum: string;
  ADocID: string; APayTypeMethod: Integer);
var
  R: Int64;
begin
  InitTPK;
  Clear;
//  SParamInt('Amount', trunc(APaySum  * 100));
  R:=trunc(ADiscardSum  * 100);
//  SParamInt('Amount', R);
  FTPK.SParam('Amount', R);
  if DoProcessError(NFun(sbcmdCancel)) then //4003
  begin
    MakeInfo4XXX;
//    FSlipInfo:=FTPK.GParamString('Cheque');
//    FRRN:=FTPK.GParamString('RRN');

(*

Число   AmountClear  - сумма операции без учета комиссии / скидки
Число   Amount - сумма операции с учетом комиссии / скидки
строка  CardName - название карты (Visa, Maestro и т.д.)
число   CardType - тип карты
строка  TrxDate - дата операции  (ДД.ММ.ГГГГ)
строка  TrxTime - время операции (ЧЧ:ММ:СС)
строка  TermNum - номер терминала
строка  MerchNum - номер мерчанта
строка  AuthCode - код авторизации
строка  RRN -номер ссылки
число   MerchantTSN  - номер транзакции в пакете терминала
число   MerchantBatchNum  - номер пакета терминала по магн.картам
строка  ClientCard - номер карты клиента
строка  ClientExpiryDate  - срок действия карты клиента
строка  Hash     - Хэш­–значение номера карты
число   OwnCard  - признак карты Сбербанка (0 или 1)
число   LoyaltyIdentifier – признак принадлежности карты настроенным в конфигурационном файле программа лояльности*)
  end;
  FSlipInfo:=FTPK.GParamString('Cheque');
  DoneTPK;
end;

procedure TSBPlasticCard.ReportOperList;
var
  S: String;
begin
  InitTPK;
  Clear;
  if DoProcessError(NFun(sbcmdReportX)) then
  begin
    MakeInfo6XXX;
{
    FSlipInfo:=FTPK.GParamString('Cheque');
    FTrxDate:=FTPK.GParamString('TrxDate');
      AddToStatusVector('TrxDate',FTrxDate);
    FTrxTime:=FTPK.GParamString('TrxTime');
      AddToStatusVector('TrxDate',FTrxTime);
    FTermNum:=FTPK.GParamString('TermNum');
      AddToStatusVector('TermNum',FTermNum);
    FMerchNum:=FTPK.GParamString('MerchNum');
      AddToStatusVector('MerchNum',FMerchNum);
    S:=FTPK.GParamString('MerchantBatchNum');
    FMerchantBatchNum:=StrToIntDef(S, 0);
      AddToStatusVector('MerchantBatchNum',S);
}
  end;
  DoneTPK;
end;

procedure TSBPlasticCard.ReportOperSmall;
begin

end;

procedure TSBPlasticCard.PPLoadConfig;
begin

end;

procedure TSBPlasticCard.PPLoadSoftware;
begin

end;

procedure TSBPlasticCard.GetWorkKey;
begin
  //
end;

initialization
  RegisterPlasticCardType(TSBPlasticCard, 'Сберегательный банк РФ');
end.

