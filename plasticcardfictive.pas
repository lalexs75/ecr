{**************************************************************************}
{ Библиотека работы с платёжными терминалами пластиковых карт              }
{ в стандарте, предоставляемым Сбербанком                                  }
{ Free Pascal Compiler версии 3.1.1 и Lazarus 1.9 и выше.                  }
{ Лагунов Алексей (С) 2017-2020  alexs75.at.yandex.ru                           }
{**************************************************************************}

unit PlasticCardFictive;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, alexs_plastic_cards_abstract;

type

  { TPlasticCardFictive }

  TPlasticCardFictive = class(TPlasticCardAbstract)
  private

  protected
    procedure Clear; override;
    function GetStatusVector: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function PayTypeMethodName(APayTypeMethod:Integer):string; override;

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

  end;

procedure Register;

implementation
uses Math;

procedure Register;
begin
  RegisterComponents('TradeEquipment',[TPlasticCardFictive]);
end;

{ TPlasticCardFictive }

procedure TPlasticCardFictive.Clear;
begin
  inherited Clear;
end;

function TPlasticCardFictive.GetStatusVector: string;
begin
  Result:='Fictive StatusVector';
end;

constructor TPlasticCardFictive.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPayTypeMethodCount:=2;
end;

destructor TPlasticCardFictive.Destroy;
begin
  inherited Destroy;
end;

function TPlasticCardFictive.PayTypeMethodName(APayTypeMethod: Integer): string;
begin
  case APayTypeMethod of
    0:Result:=sPayTypeMethodBankCard;
    1:Result:=sPayTypeMethodQRCode;
  else
    Result:=sUnknowPayTypeMethod;
  end;
end;

procedure TPlasticCardFictive.Pay(APaySum: Currency; ACheckNum: integer;
  APayTypeMethod: Integer);
begin
  //Фиктивный метод
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Тип оплаты :' + IntToStr(APayTypeMethod) + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' + LineEnding +
  'Адрес организации : XXXXXXXXXX' + LineEnding +
  '      ОПЛАТА' + LineEnding +
  'Cумма : ' +FloatToStr(APaySum)+ LineEnding +
  'Комиссия : ' + FloatToStr(RoundTo(APaySum / 100, -2))+ LineEnding +
  'Дата оплаты ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.ReportItog;
begin
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' + LineEnding +
  'Адрес организации : XXXXXXXXXX' + LineEnding +
  '      ОТЧЁТ' + LineEnding +
  'Итог : ' +FloatToStr(12312)+ LineEnding +
  'Дата отчёта ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.EchoTest;
begin

end;

procedure TPlasticCardFictive.Revert(ARevertSum: Currency; ACheckNum: string;
  APayTypeMethod: Integer; ADocID: string);
begin
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' + LineEnding +
  'Тип оплаты :' + IntToStr(APayTypeMethod) + LineEnding +
  'Адрес организации : XXXXXXXXXX' + LineEnding +
  '      ВОЗВРАТ' + LineEnding +
  'Cумма : ' +FloatToStr(ARevertSum)+ LineEnding +
  'Комиссия : ' + FloatToStr(RoundTo(ARevertSum / 100, -2))+ LineEnding +
  'Дата оплаты ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.Discard(ADiscardSum: Currency; ACheckNum: string;
  ADocID: string; APayTypeMethod: Integer);
begin
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' + LineEnding +
  'Тип оплаты :' + IntToStr(APayTypeMethod) + LineEnding +
  'Адрес организации : XXXXXXXXXX' + LineEnding +
  '      ОТМЕНА' + LineEnding +
  'Cумма : ' +FloatToStr(ADiscardSum)+ LineEnding +
  'Комиссия : ' + FloatToStr(RoundTo(ADiscardSum / 100, -2))+ LineEnding +
  'Дата оплаты ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.ReportOperList;
begin
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' + LineEnding +
  'Адрес организации : XXXXXXXXXX' + LineEnding +
  '      ОТЧЁТ ПО ОПЕРАЦИИЯМ' + LineEnding +
  'Итог : ' +FloatToStr(12312)+ LineEnding +
  'Дата отчёта ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.ReportOperSmall;
begin
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' + LineEnding +
  'Адрес организации : XXXXXXXXXX' + LineEnding +
  '      ОТЧЁТ ПО ОПЕРАЦИИЯМ КРАТКО' + LineEnding +
  'Итог : ' +FloatToStr(12312)+ LineEnding +
  'Дата отчёта ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.PPLoadConfig;
begin

end;

procedure TPlasticCardFictive.PPLoadSoftware;
begin

end;

procedure TPlasticCardFictive.GetWorkKey;
begin

end;

initialization
  RegisterPlasticCardType(TPlasticCardFictive, 'Тестовый фиктивный терминал пластиковых карт - не для работы!!');
end.
