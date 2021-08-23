unit v10MarkingUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, rxcurredit,
  tv10globalunit;

type

  { Tv10MarkingFrame }

  Tv10MarkingFrame = class(TConfigFrame)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    CurrencyEdit1: TCurrencyEdit;
    Edit1: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private

  public
    procedure UpdateCtrlState; override;
  end;

implementation
uses rxlogging, libfptr10;

{$R *.lfm}

{ Tv10MarkingFrame }

procedure Tv10MarkingFrame.Button5Click(Sender: TObject);
var
  FKMOnlineValidationResult: Integer;
begin
  FKKM.LibraryAtol.AcceptMarkingCode(FKKM.Handle);
  FKKM.InternalCheckError;

  FKMOnlineValidationResult:=FKKM.LibraryAtol.GetParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT));
  RxWriteLog(etInfo, 'Результат проверки сведений о товаре: %d', [FKMOnlineValidationResult]);
end;

procedure Tv10MarkingFrame.Button1Click(Sender: TObject);
var
  FKMType:Tlibfptr_marking_code_type_1_2;
  FStatus:Tlibfptr_marking_estimated_status;
  FItemUnits:Tlibfptr_item_units;
  Mark: string;
  FValidationResult, FOfflineValidationErrors: Integer;
  S: String;
begin
  Mark:=Trim(Memo1.Text);
  case ComboBox1.ItemIndex of
    1:FKMType:=LIBFPTR_MCT12_UNKNOWN;
    2:FKMType:=LIBFPTR_MCT12_SHORT;
    3:FKMType:=LIBFPTR_MCT12_88_CHECK;
    4:FKMType:=LIBFPTR_MCT12_44_NO_CHECK;
    5:FKMType:=LIBFPTR_MCT12_44_CHECK;
    6:FKMType:=LIBFPTR_MCT12_4_NO_CHECK;
  else
    FKMType:=LIBFPTR_MCT12_AUTO;
  end;

  FStatus:=IndToKMStatus(ComboBox2.ItemIndex);
  FItemUnits:=IndToItemUnits(ComboBox3.ItemIndex);

  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_CODE_TYPE, Ord(FKMType));
  FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE), Mark);
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_CODE_STATUS, Ord(FStatus));
  FKKM.LibraryAtol.SetParamDouble(FKKM.Handle, Ord(LIBFPTR_PARAM_QUANTITY), CurrencyEdit1.Value);
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MEASUREMENT_UNIT, Ord(FItemUnits));
  FKKM.LibraryAtol.SetParamBool(FKKM.Handle, LIBFPTR_PARAM_MARKING_WAIT_FOR_VALIDATION_RESULT, CheckBox1.Checked);
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_MARKING_PROCESSING_MODE, StrToInt(Edit1.Text));

  if Edit3.Text<>'' then
    FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_FRACTIONAL_QUANTITY), Edit3.Text);

  FKKM.LibraryAtol.BeginMarkingCodeValidation(FKKM.Handle);
  FKKM.InternalCheckError;

  FValidationResult:=FKKM.LibraryAtol.GetParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_STATUS));
  FOfflineValidationErrors:=FKKM.LibraryAtol.GetParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_OFFLINE_VALIDATION_ERROR));

  RxWriteLog(etInfo, 'Результат локальной проверки: %d', [FValidationResult]);
  RxWriteLog(etInfo, 'Ошибка локальной проверки: %d', [FOfflineValidationErrors]);
end;

procedure Tv10MarkingFrame.Button2Click(Sender: TObject);
begin
  FKKM.LibraryAtol.CancelMarkingCodeValidation(FKKM.Handle);
  FKKM.InternalCheckError;
end;

procedure Tv10MarkingFrame.Button3Click(Sender: TObject);
var
  FReady, FKMSend: Boolean;
  FValidationDesc: String;
  FOnlineValidationErrors, FOnlineValidationResult: Integer;
begin
  FKKM.LibraryAtol.GetMarkingCodeValidationStatus(FKKM.Handle);
  FKKM.InternalCheckError;

  FReady:=FKKM.LibraryAtol.GetParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_VALIDATION_READY));
  FKMSend:=FKKM.LibraryAtol.GetParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_IS_REQUEST_SENT));
  FValidationDesc:=FKKM.LibraryAtol.GetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_ERROR_DESCRIPTION));
  FOnlineValidationErrors:=FKKM.LibraryAtol.GetParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_ERROR));
  FOnlineValidationResult:=FKKM.LibraryAtol.GetParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT));

  if FReady then
    RxWriteLog(etInfo, 'Проверка завершена')
  else
    RxWriteLog(etInfo, 'Проверка не завершена');

  if FKMSend then
    RxWriteLog(etInfo, 'КМ отправлен')
  else
    RxWriteLog(etInfo, 'КМ не был отправлен');

  RxWriteLog(etInfo, 'Статус ошибки : %s', [FValidationDesc]);
  RxWriteLog(etInfo, 'Ошибка онлайн проверки: %d', [FOnlineValidationErrors]);
  RxWriteLog(etInfo, 'Результат проверки сведений о товаре: %d', [FOnlineValidationResult]);


{  Сведения о статусе товара: 0
  Результаты обработки запроса: 0
  Код обработки запроса: 0

  2021.08.23 10:41:25.919 T:5C958640 INFO  [FiscalPrinter] < LIBFPTR_PARAM_TLV_LIST (65858) = ""}

end;

procedure Tv10MarkingFrame.Button4Click(Sender: TObject);
begin
  FKKM.LibraryAtol.ClearMarkingCodeValidationResult(FKKM.Handle);
  FKKM.InternalCheckError;
end;

procedure Tv10MarkingFrame.Button6Click(Sender: TObject);
begin
  FKKM.LibraryAtol.DeclineMarkingCode(FKKM.Handle);
  FKKM.InternalCheckError;
end;

procedure Tv10MarkingFrame.Button7Click(Sender: TObject);
var
  FKMValidationReady: Boolean;
begin
  FKKM.LibraryAtol.CheckMarkingCodeValidationsReady(FKKM.Handle);
  FKKM.InternalCheckError;

  FKMValidationReady:=FKKM.LibraryAtol.GetParamBool(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_VALIDATION_READY));
  if FKMValidationReady then
    RxWriteLog(etInfo, 'Все запросы о КМ отправлены')
  else
    RxWriteLog(etInfo, 'Не все запросы о КМ отправлены');
end;

procedure Tv10MarkingFrame.UpdateCtrlState;
begin
  Button1.Enabled:=FKKM.Connected;
  Button2.Enabled:=FKKM.Connected;
  Button3.Enabled:=FKKM.Connected;
  Button4.Enabled:=FKKM.Connected;
  Button5.Enabled:=FKKM.Connected;
  Button6.Enabled:=FKKM.Connected;
  Button7.Enabled:=FKKM.Connected;
end;

end.

