{
  Test application for atoll cashe register

  Copyright (C) 2021 Lagunov Aleksey alexs75@yandex.ru

  This source is free software; you can redistribute it and/or modify it under the terms of the GNU General Public
  License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later
  version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web at
  <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing to the Free Software Foundation, Inc., 51
  Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.
}

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
    procedure UpdateCtrlState; override;
  end;

implementation
uses libfptr10, rxlogging, CasheRegisterAbstract;

{$R *.lfm}

{ Tv10CRPTFrame }

procedure Tv10CRPTFrame.Button25Click(Sender: TObject);
var
    mark: String;
    validationResult, CS: Integer;
    FStatus: libfptr_marking_estimated_status;
    FValidationReady: Boolean;
begin
  FKKM.LibraryAtol.CancelMarkingCodeValidation(FKKM.Handle);

    mark := '010463003022541621Yu7t_HclAYqqD'#$1D'91006A'#$1D'92lYF//jixJXUlaO7WTSPELeZj20OiWEYGcF2HCN8/cUN6f+atR6qDTy2Rw6q6ZSC9TFScVroPNfCL8N8gjgKH1g==';

    FStatus := LIBFPTR_MES_PIECE_SOLD;

    // Запускаем проверку КМ
    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_CODE_TYPE, Ord(LIBFPTR_MCT12_AUTO));
    FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE), mark);
    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_CODE_STATUS, Ord(FStatus));
    //FKKM.LibraryAtol.SetParamDouble(FKKM.Handle, Ord(LIBFPTR_PARAM_QUANTITY), 1.000);
    //FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MEASUREMENT_UNIT, 0);
    FKKM.LibraryAtol.SetParamBool(FKKM.Handle, LIBFPTR_PARAM_MARKING_WAIT_FOR_VALIDATION_RESULT, True);
    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_PROCESSING_MODE, 0);
    //FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_FRACTIONAL_QUANTITY), '1/2');

    FKKM.LibraryAtol.beginMarkingCodeValidation(FKKM.Handle);
    FKKM.InternalCheckError;
    // Дожидаемся окончания проверки и запоминаем результат
    repeat
       CS:=FKKM.LibraryAtol.getMarkingCodeValidationStatus(FKKM.Handle);
       FKKM.InternalCheckError;
       FValidationReady:=FKKM.LibraryAtol.GetParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_VALIDATION_READY));
    until FValidationReady;
    validationResult := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT));
    FKKM.InternalCheckError;
    RxWriteLog(etInfo, 'ValidationResult = %d', [validationResult]);

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

procedure Tv10CRPTFrame.UpdateCtrlState;
begin
  inherited UpdateCtrlState;
  Button24.Enabled:=FKKM.Connected;
  Button25.Enabled:=FKKM.Connected;
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
    while True do
    begin
        FKKM.LibraryAtol.getMarkingServerStatus(FKKM.Handle);
        if FKKM.LibraryAtol.getParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_CHECK_MARKING_SERVER_READY)) then
            break;
    end;

    //EC:=FKKM.LibraryAtol.getMarkingServerStatus(FKKM.Handle);
    //B:=FKKM.LibraryAtol.getParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_CHECK_MARKING_SERVER_READY));

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

