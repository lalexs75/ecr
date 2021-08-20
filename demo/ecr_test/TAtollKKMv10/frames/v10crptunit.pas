unit v10CRPTUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  tv10globalunit;

type

  { Tv10CRPTFrame }

  Tv10CRPTFrame = class(TConfigFrame)
    Button24: TButton;
    Button25: TButton;
    Label27: TLabel;
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
  private

  public

  end;

implementation
uses libfptr10, rxlogging, CasheRegisterAbstract;

{$R *.lfm}

{ Tv10CRPTFrame }

procedure Tv10CRPTFrame.Button25Click(Sender: TObject);
var
    mark: String;
    status: Integer;
    validationResult, CS: Integer;
begin
  FKKM.Connected:=true;
  if FKKM.LibraryAtol.Loaded then
  begin

    mark := '014494550435306821QXYXSALGLMYQQ\u001D91EE06\u001D92YWCXbmK6SN8vvwoxZFk7WAY8WoJNMGGr6Cgtiuja04c=';
    status := 2;

    // Запускаем проверку КМ
    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_CODE_TYPE, Ord(LIBFPTR_MCT12_AUTO));
    FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE), mark);
    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_CODE_STATUS, status);
    FKKM.LibraryAtol.SetParamDouble(FKKM.Handle, Ord(LIBFPTR_PARAM_QUANTITY), 1.000);
    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MEASUREMENT_UNIT, 0);
    FKKM.LibraryAtol.SetParamBool(FKKM.Handle, LIBFPTR_PARAM_MARKING_WAIT_FOR_VALIDATION_RESULT, True);
    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_PROCESSING_MODE, 0);
    FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_FRACTIONAL_QUANTITY), '1/2');
    FKKM.LibraryAtol.beginMarkingCodeValidation(FKKM.Handle);

    // Дожидаемся окончания проверки и запоминаем результат
    while True do
    begin
       CS:=FKKM.LibraryAtol.getMarkingCodeValidationStatus(FKKM.Handle);
        if FKKM.LibraryAtol.getParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_VALIDATION_READY)) then
            break;
    end;
    validationResult := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT));
(*
    // Подтверждаем реализацию товара с указанным КМ
    fptr.acceptMarkingCode();

    // ... Проверяем остальные КМ

    // Формируем чек
    fptr.setParam(fptr.LIBFPTR_PARAM_RECEIPT_TYPE, fptr.LIBFPTR_RT_SELL);
    fptr.openReceipt();

    fptr.setParam(fptr.LIBFPTR_PARAM_COMMODITY_NAME, 'Молоко');
    fptr.setParam(fptr.LIBFPTR_PARAM_PRICE, 80);
    fptr.setParam(fptr.LIBFPTR_PARAM_QUANTITY, 1.000);
    fptr.setParam(fptr.LIBFPTR_PARAM_MEASUREMENT_UNIT, 0);
    fptr.setParam(fptr.LIBFPTR_PARAM_MARKING_FRACTIONAL_QUANTITY, '1/2');
    fptr.setParam(fptr.LIBFPTR_PARAM_TAX_TYPE, fptr.LIBFPTR_TAX_VAT10);
    fptr.setParam(1212, 1);
    fptr.setParam(1214, 7);
    fptr.setParam(fptr.LIBFPTR_PARAM_MARKING_CODE, mark);
    fptr.setParam(fptr.LIBFPTR_PARAM_MARKING_CODE_STATUS, status);
    fptr.setParam(fptr.LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT, validationResult);
    fptr.setParam(fptr.LIBFPTR_PARAM_MARKING_PROCESSING_MODE, 0);
    fptr.registration();

    // ... Регистрируем остальные позиции

    fptr.setParam(fptr.LIBFPTR_PARAM_SUM, 120);
    fptr.receiptTotal();

    fptr.setParam(fptr.LIBFPTR_PARAM_PAYMENT_TYPE, fptr.LIBFPTR_PT_CASH);
    fptr.setParam(fptr.LIBFPTR_PARAM_PAYMENT_SUM, 1000);
    fptr.payment();

    // Перед закрытием проверяем, что все КМ отправились (на случай, если были проверки КМ без ожидания результата
    while True do
    begin
        fptr.checkMarkingCodeValidationsReady();
        if fptr.getParamBool(fptr.LIBFPTR_PARAM_MARKING_CODE_VALIDATION_READY) then
            break;
    end;

    fptr.closeReceipt();
*)
  end;
  FKKM.Connected:=false;
end;

procedure Tv10CRPTFrame.Button24Click(Sender: TObject);
var
  errorDescription: String;
  responseTime, EC: Integer;
  B: Boolean;
begin
  FKKM.Connected:=true;
  if FKKM.LibraryAtol.Loaded then
  begin
    // Начать проверку связи с сервером ИСМ
    FKKM.LibraryAtol.PingMarkingServer(FKKM.Handle);

    // Ожидание результатов проверки связи с сервером ИСМ
{    while True do
    begin
        FKKM.LibraryAtol.getMarkingServerStatus(FKKM.Handle);
        if FKKM.LibraryAtol.getParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_CHECK_MARKING_SERVER_READY)) then
            break;
    end; }

    EC:=FKKM.LibraryAtol.getMarkingServerStatus(FKKM.Handle);
    B:=FKKM.LibraryAtol.getParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_CHECK_MARKING_SERVER_READY));

    EC := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_SERVER_ERROR_CODE));
    errorDescription := FKKM.LibraryAtol.GetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_SERVER_ERROR_DESCRIPTION));
    responseTime := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_SERVER_RESPONSE_TIME));
    Label27.Caption:=Format('Error code : %d, Error msg : %s', [EC, errorDescription]);
  end
  else
    Label27.Caption:='Ошибка';
  FKKM.Connected:=false;
end;

end.

