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

    procedure Pay(APaySum:Currency; ACheckNum:integer); override;      //Оплата
    procedure ReportItog;override;                                     //Z отчёт
    procedure EchoTest;override;                                       //Проверка
    procedure Revert(ARevertSum:Currency; ACheckNum:string); override; //Возврат
    procedure Discard(ADiscardSum:Currency; ACheckNum:string; ADocID:string); override; //Отмена
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
end;

destructor TPlasticCardFictive.Destroy;
begin
  inherited Destroy;
end;

procedure TPlasticCardFictive.Pay(APaySum: Currency; ACheckNum: integer);
begin
  //Фиктивный метод
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' +
  'Адрес организации : XXXXXXXXXX' +
  '      ОПЛАТА' +
  'Cумма : ' +FloatToStr(APaySum)+ LineEnding +
  'Комиссия : ' + FloatToStr(RoundTo(APaySum / 100, -2))+ LineEnding +
  'Дата оплаты ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.ReportItog;
begin
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' +
  'Адрес организации : XXXXXXXXXX' +
  '      ОТЧЁТ' +
  'Итог : ' +FloatToStr(12312)+ LineEnding +
  'Дата отчёта ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.EchoTest;
begin

end;

procedure TPlasticCardFictive.Revert(ARevertSum: Currency; ACheckNum: string);
begin
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' +
  'Адрес организации : XXXXXXXXXX' +
  '      ВОЗВРАТ' +
  'Cумма : ' +FloatToStr(ARevertSum)+ LineEnding +
  'Комиссия : ' + FloatToStr(RoundTo(ARevertSum / 100, -2))+ LineEnding +
  'Дата оплаты ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.Discard(ADiscardSum: Currency; ACheckNum: string;
  ADocID: string);
begin
  FSlipInfo:='Фиктивный СЛИП' + LineEnding +
  'Фиктивный терминал : XXXXXXXXX' +
  'Адрес организации : XXXXXXXXXX' +
  '      ОТМЕНА' +
  'Cумма : ' +FloatToStr(ADiscardSum)+ LineEnding +
  'Комиссия : ' + FloatToStr(RoundTo(ADiscardSum / 100, -2))+ LineEnding +
  'Дата оплаты ' +DateTimeToStr(Now)+ LineEnding +
  'Фиктивный СЛИП' ;
end;

procedure TPlasticCardFictive.ReportOperList;
begin

end;

procedure TPlasticCardFictive.ReportOperSmall;
begin

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
