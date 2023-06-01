{ Билиотека для работы с ККМ ЩТРИХ-ФР

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


unit kkm_strih_fr;

{$mode objfpc}{$H+}
{$D+}

interface

uses
  Classes, SysUtils, CasheRegisterAbstract;

type
  EShtrihFR = class(ECashRegisterAbstract);

  { TShtrihFRKKM }

  TShtrihFRKKM = class(TCashRegisterAbstract)
  private
    FShtrihFR: OleVariant;  //Устройство ККМ ШТРИХ-ФР
  protected
    procedure InternalUserLogin; override;
    procedure InternalOpenKKM; override;
    procedure InternalCloseKKM; override;

    function GetDeviceDateTime: TDateTime; override;
    procedure InternalGetDeviceInfo(var ALineLength, ALineLengthPix: integer); override;
    function GetConnected: boolean; override;
    procedure SetConnected(AValue: boolean); override;

    function GetCheckNumber: integer; override;
    function GetFDNumber: integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;


    function InternalCheckError:Integer; override;
    function GetVersionString:string; override;
    procedure GetOFDStatus(out AStatus:TOFDSTatusRecord); override;
    procedure Beep; override;
    procedure CutCheck(APartial:boolean); override;
    //procedure PrintLine(ALine:string); override;        //Печать строки
    //procedure PrintClishe; override;

    //Отперации со сменой
    procedure OpenShift; override;                      //Открыть смену

    //Внесения и выплаты
    function CashIncome(APaymentSum:Currency):integer; override;          //Внесение денег
    function CashOutcome(APaymentSum:Currency):integer; override;         //Выплата денег

    //Операции с чеком
    procedure OpenCheck; override;
    //function CloseCheck:Integer; override;              //Закрыть чек (со сдачей)
    //function CancelCheck:integer; override;             //Аннулирование всего чека
    //function Registration:integer; override;
    //function ReceiptTotal:integer; override;
    //function Payment:integer; override;
    //function RegisterGoods:Integer; override;
    //function RegisterPayments:Integer; override;
    //function ValidateGoodsKM:Boolean; override;
    //
    //procedure RegisterPayment(APaymentType:TPaymentType; APaymentSum:Currency); override;
    //
    //procedure SetAttributeInt(AttribNum, AttribValue:Integer); override;
    //procedure SetAttributeStr(AttribNum:Integer; AttribValue:string); override;
    //procedure SetAttributeBool(AttribNum:Integer; AttribValue:Boolean); override;
    //procedure SetAttributeDouble(AttribNum:Integer; AttribValue:Double); override;
    //
    //procedure BeginNonfiscalDocument; override;
    //procedure EndNonfiscalDocument; override;
    //function UpdateFnmKeys:Integer; override;

(*


    Общая информация
    Настройки логирования
    Начало работы с драйвером
    Обработка ошибок
    Соединение с ККТ
    Запрос информации о ККТ
    Регистрация кассира
    Операции со сменой
    Внесения и выплаты
    Запрос информации из ФН
    Регистрация ККТ
    Перерегистрация ККТ
    Замена ФН
    Закрытие архива ФН
    Нефискальная печать
    Чтение данных
    Служебные операции
    Прочие методы
    Программирование ККТ
    JSON-задания
    Приложение
    Настройки ККТ
    Android Service
    Web-сервер*)
    //Отчёты
(*
        Копия последнего документа
        Отчет о состоянии расчетов
        Печать информации о ККТ
        Диагностика соединения с ОФД
        Печать документа из архива ФН
        Отчет по кассирам
        Печать итогов регистрации / перерегистрации
        Счетчики итогов смены
        Счетчики итогов ФН
        Счетчики по непереданным документам
        Отчет по товарам по СНО
        Отчет по товарам по отделам
        Отчет по товарам по суммам
        Начать служебный отчет
*)
    procedure ReportX(AReportType: Byte); override;     //X-отчет
    procedure ReportZ; override;
    procedure PrintReportHours; override;               //Отчет по часам
    procedure PrintReportSection; override;             //Отчет по секциям
    procedure PrintReportCounted; override;             //Отчет количеств
    procedure DemoPrint; override;                      //Демо-печать

    //function NonNullableSum:Currency; override;                  //Не обнуляемая сумма - приход - наличка

    function ShowProperties:boolean; override;          //Отобразить окно параметров ККМ

    //Вспомогательное
    procedure OpenDrawer;

  end;

implementation
  {$IFDEF WINDOWS}
uses
  ComObj, ActiveX;
  {$ENDIF}

{ TShtrihFRKKM }

procedure TShtrihFRKKM.InternalUserLogin;
begin

end;

procedure TShtrihFRKKM.InternalOpenKKM;
begin
  FShtrihFR.Connect();
  InternalCheckError;
end;

procedure TShtrihFRKKM.InternalCloseKKM;
begin
  FShtrihFR.Disconnect();
  InternalCheckError;
end;

function TShtrihFRKKM.GetDeviceDateTime: TDateTime;
begin

end;

procedure TShtrihFRKKM.InternalGetDeviceInfo(var ALineLength,
  ALineLengthPix: integer);
begin
  inherited InternalGetDeviceInfo(ALineLength, ALineLengthPix);
end;

function TShtrihFRKKM.GetConnected: boolean;
begin
  FShtrihFR.CheckConnection()
end;

procedure TShtrihFRKKM.SetConnected(AValue: boolean);
begin

end;

function TShtrihFRKKM.GetCheckNumber: integer;
begin

end;

function TShtrihFRKKM.GetFDNumber: integer;
begin

end;

constructor TShtrihFRKKM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF WINDOWS}
  FShtrihFR := CreateOleObject('AddIn.DrvFR');
  {$ELSE}
  FShtrihFR:=null;
  {$ENDIF}
end;

destructor TShtrihFRKKM.Destroy;
begin
  FShtrihFR:=null;
  inherited Destroy;
end;

function TShtrihFRKKM.GetVersionString: string;
begin
  Result:=FShtrihFR.DriverVersion;
  InternalCheckError;
end;

procedure TShtrihFRKKM.GetOFDStatus(out AStatus: TOFDSTatusRecord);
begin
  inherited GetOFDStatus(AStatus);
end;

procedure TShtrihFRKKM.Beep;
begin
  FShtrihFR.Beep;
  InternalCheckError;
end;

procedure TShtrihFRKKM.CutCheck(APartial: boolean);
begin
  FShtrihFR.Password:=Password;
  FShtrihFR.CutType:=APartial;
  FShtrihFR.CutCheck;
  InternalCheckError;
end;

procedure TShtrihFRKKM.OpenShift;
begin
  FShtrihFR.Password:=Password;
  FShtrihFR.OpenSession;
  InternalCheckError;
end;

function TShtrihFRKKM.CashIncome(APaymentSum: Currency): integer;
begin
  FShtrihFR.Password:=Password;
  FShtrihFR.Summ1:=APaymentSum;
  FShtrihFR.CashIncome;
  InternalCheckError;
end;

function TShtrihFRKKM.CashOutcome(APaymentSum: Currency): integer;
begin
  FShtrihFR.Password:=Password;
  FShtrihFR.Summ1:=APaymentSum;
  FShtrihFR.CashOutcome;
  InternalCheckError;
end;

procedure TShtrihFRKKM.OpenCheck;
begin
  inherited OpenCheck;
end;

function TShtrihFRKKM.InternalCheckError: Integer;
begin
  Result:=FShtrihFR.ResultCode;
  if Result <> 0 then
    SetError(Result, FShtrihFR.ResultCodeDescription)
  else
    ClearError;
end;

function TShtrihFRKKM.ShowProperties: boolean;
begin
  FShtrihFR.ShowProperties();
  InternalCheckError;
end;

procedure TShtrihFRKKM.OpenDrawer;
begin
  FShtrihFR.Password:=Password;
  FShtrihFR.OpenDrawer;
  InternalCheckError;
end;

procedure TShtrihFRKKM.ReportX(AReportType: Byte);
begin

end;

procedure TShtrihFRKKM.ReportZ;
begin
  FShtrihFR.Password:=Password;
  FShtrihFR.PrintReportWithCleaning();
  InternalCheckError;
end;

procedure TShtrihFRKKM.PrintReportHours;
begin

end;

procedure TShtrihFRKKM.PrintReportSection;
begin

end;

procedure TShtrihFRKKM.PrintReportCounted;
begin

end;

procedure TShtrihFRKKM.DemoPrint;
begin

end;

end.

