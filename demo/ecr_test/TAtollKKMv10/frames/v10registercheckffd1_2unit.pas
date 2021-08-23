unit v10RegisterCheckFFD1_2Unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  tv10globalunit;

type

  { Tv10RegisterCheckFFD1_2Frame }

  Tv10RegisterCheckFFD1_2Frame = class(TConfigFrame)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
  private

  public
    procedure UpdateCtrlState; override;
  end;

implementation
uses rxlogging, libfptr10;

{$R *.lfm}

{ Tv10RegisterCheckFFD1_2Frame }

procedure Tv10RegisterCheckFFD1_2Frame.Button1Click(Sender: TObject);
begin
  // Формируем чек
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_RECEIPT_TYPE, Ord(LIBFPTR_RT_SELL));
  FKKM.LibraryAtol.OpenReceipt(FKKM.Handle);
  FKKM.InternalCheckError;
end;

procedure Tv10RegisterCheckFFD1_2Frame.Button2Click(Sender: TObject);
var
  FItemUnits: Tlibfptr_item_units;
  Mark: String;
  FStatus: Tlibfptr_marking_estimated_status;
begin
  FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_COMMODITY_NAME), Edit1.Text);
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_PRICE, 80);
  FKKM.LibraryAtol.SetParamDouble(FKKM.Handle, Ord(LIBFPTR_PARAM_QUANTITY), 1.000);
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, Tlibfptr_param(1212), 1);
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, Tlibfptr_param(1214), 7);
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_TAX_TYPE, Ord(LIBFPTR_TAX_VAT20));

  if CheckBox1.Checked then
  begin
    FItemUnits:=IndToItemUnits(ComboBox3.ItemIndex);
    FStatus:=IndToKMStatus(ComboBox2.ItemIndex);
    Mark:=Trim(Edit2.Text);

    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MEASUREMENT_UNIT, Ord(FItemUnits));
    //FKKM.LibraryAtol.SetParamStr(FKKM.Handle, LIBFPTR_PARAM_MARKING_FRACTIONAL_QUANTITY, L"1/2");
    FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE), Mark);
    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_CODE_STATUS, Ord(FStatus));
    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_PROCESSING_MODE, StrToInt(Edit3.Text));

    FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT, StrToInt(Edit4.Text));
  end;

  FKKM.LibraryAtol.Registration(FKKM.Handle);
  FKKM.InternalCheckError;
end;

procedure Tv10RegisterCheckFFD1_2Frame.Button3Click(Sender: TObject);
var
  B: Boolean;
begin
  if CheckBox1.Checked then
  begin
    (*
    // Перед закрытием проверяем, что все КМ отправились (на случай, если были проверки КМ без ожидания результата
    while (true) {
        libfptr_check_marking_code_validations_ready(fptr);
        if (libfptr_get_param_bool(fptr, LIBFPTR_PARAM_MARKING_CODE_VALIDATION_READY))
            break;
    }
    *)
    FKKM.LibraryAtol.CheckMarkingCodeValidationsReady(FKKM.Handle);
    B:=FKKM.LibraryAtol.GetParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_VALIDATION_READY));
  end;

  FKKM.LibraryAtol.CloseReceipt(FKKM.Handle);
  FKKM.InternalCheckError;
end;

procedure Tv10RegisterCheckFFD1_2Frame.Button4Click(Sender: TObject);
begin
  FKKM.LibraryAtol.CancelReceipt(FKKM.LibraryAtol);
  FKKM.InternalCheckError;
end;

procedure Tv10RegisterCheckFFD1_2Frame.Button6Click(Sender: TObject);
begin
  FKKM.LibraryAtol.SetParamInt(FKKM.LibraryAtol, LIBFPTR_PARAM_SUM, 80);
  FKKM.LibraryAtol.ReceiptTotal(FKKM.LibraryAtol);
  FKKM.InternalCheckError;

  FKKM.LibraryAtol.SetParamInt(FKKM.LibraryAtol, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(LIBFPTR_PT_CASH));
  FKKM.LibraryAtol.SetParamInt(FKKM.LibraryAtol, LIBFPTR_PARAM_PAYMENT_SUM, 80);
  FKKM.LibraryAtol.Payment(FKKM.LibraryAtol);
  FKKM.InternalCheckError;
end;

procedure Tv10RegisterCheckFFD1_2Frame.CheckBox1Change(Sender: TObject);
begin
  ComboBox2.Enabled:=CheckBox1.Checked;
  ComboBox3.Enabled:=CheckBox1.Checked;

  Edit2.Enabled:=CheckBox1.Checked;
  Edit3.Enabled:=CheckBox1.Checked;
  Edit4.Enabled:=CheckBox1.Checked;

end;

procedure Tv10RegisterCheckFFD1_2Frame.UpdateCtrlState;
begin
  inherited UpdateCtrlState;
  Button1.Enabled:=FKKM.Connected;
  Button2.Enabled:=FKKM.Connected;
  Button3.Enabled:=FKKM.Connected;
  Button4.Enabled:=FKKM.Connected;
  Button5.Enabled:=FKKM.Connected;
  Button6.Enabled:=FKKM.Connected;
  CheckBox1Change(nil);
end;

end.

