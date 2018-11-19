unit kkmTestUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Spin, Menus, DividerBevel, curredit, KKM_Atol;

type
  TCheckTypes = set of byte;
type

  { TKKMTestForm }

  TKKMTestForm = class(TForm)
    btnZReport1: TButton;
    ECRDriver: TAtollKKM;
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    btnZReport: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button2: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    btnStorno: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    CurrencyEdit1: TCurrencyEdit;
    CurrencyEdit2: TCurrencyEdit;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    DividerBevel3: TDividerBevel;
    DividerBevel4: TDividerBevel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    edtPwd: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    PopupMenu1: TPopupMenu;
    SpinEdit2: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure btnZReport1Click(Sender: TObject);
    procedure btnZReportClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure btnStornoClick(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private
    //ECRDriver:TAtollKKM;
    procedure UpdateControlModeState;
    procedure DisplayKKMStatus;
    procedure DoPrintRegister(AMsg:string; AChekTypes:TCheckTypes);
  public
    procedure ShowError;
  end;

var
  KKMTestForm: TKKMTestForm;
  LogFileName:string;

procedure WriteLog(const S: string);
implementation

uses synaser, strutils;

procedure WriteLog(const S: string);
var
  f:text;
begin
  AssignFile(F, LogFileName);
  if FileExists(LogFileName) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, S);
  CloseFile(F);

  if Assigned(KKMTestForm) then
    KKMTestForm.ListBox1.Items.Add(S);
end;

{$R *.lfm}



{ TKKMTestForm }

procedure TKKMTestForm.Button1Click(Sender: TObject);
begin
  ECRDriver.PrintLine(Edit2.Text);
  ShowError;
end;

procedure TKKMTestForm.Button20Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=8;
  ECRDriver.GetRegister;
  Memo1.Lines.Add('8 - Количество Внесений = ' + IntToStr(ECRDriver.Count));
end;

procedure TKKMTestForm.Button21Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=9;
  ECRDriver.GetRegister;
  Memo1.Lines.Add('9 - Количество Выплат = ' + IntToStr(ECRDriver.Count));
end;

procedure TKKMTestForm.Button22Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=7;
  DoPrintRegister('7 - Количество сторно', [1,4]);
end;

procedure TKKMTestForm.Button23Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=1;
  DoPrintRegister('1 -  Сумма регистраций', [1..6]);
end;

procedure TKKMTestForm.Button24Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=2;
  DoPrintRegister('2 - Сумма сторно', [1, 4]);
end;

procedure TKKMTestForm.Button25Click(Sender: TObject);
begin
  ECRDriver.Summ:=CurrencyEdit1.Value;
  ECRDriver.CashIncome;
  //ECRDriver.ResetMode;
  ShowError;
end;

procedure TKKMTestForm.Button26Click(Sender: TObject);
begin
  ECRDriver.Summ:=CurrencyEdit1.Value;
  ECRDriver.CashOutcome;
  ShowError;
end;

procedure TKKMTestForm.Button27Click(Sender: TObject);
begin
end;

procedure TKKMTestForm.Button2Click(Sender: TObject);
var
  C:Currency;
  i:Integer;
begin
  for i:=1 to SpinEdit2.Value do
  begin
    ECRDriver.SetMode(1);

    ECRDriver.CheckType:=1;
    ECRDriver.OpenCheck;

    C:=0;
    //1
    ECRDriver.PrintLine(Edit5.Text);
    ECRDriver.Price:=StrToFloat(Edit6.Text);
    C:=C + ECRDriver.Price;
    ECRDriver.Quantity:=StrToFloat(Edit7.Text);
    ECRDriver.Department:=ComboBox4.ItemIndex;
    ECRDriver.Registration;

    //2
    ECRDriver.PrintLine(Edit5.Text);
    ECRDriver.Price:=StrToFloat(Edit6.Text)+StrToFloat(Edit6.Text);
    C:=C + ECRDriver.Price;
    ECRDriver.Quantity:=StrToFloat(Edit7.Text);
    ECRDriver.Department:=ComboBox4.ItemIndex;
    ECRDriver.Registration;
    //3
    ECRDriver.PrintLine(Edit5.Text);
    ECRDriver.Price:=StrToFloat(Edit6.Text)+StrToFloat(Edit6.Text);
    C:=C + ECRDriver.Price;
    ECRDriver.Quantity:=StrToFloat(Edit7.Text);
    ECRDriver.Department:=ComboBox4.ItemIndex;
    ECRDriver.Registration;

    ECRDriver.Summ:=C;
    ECRDriver.CloseCheck;
    ECRDriver.ResetMode;
  end;

  DisplayKKMStatus;
end;

procedure TKKMTestForm.Button12Click(Sender: TObject);
begin
  ECRDriver.CancelCheck;
  Edit4.Text:=IntToStr(ECRDriver.Mode)+'.'+IntToStr(ECRDriver.SubMode);
  ShowError;
end;

procedure TKKMTestForm.Button13Click(Sender: TObject);
begin
  ECRDriver.Payment;
  ECRDriver.Summ:=0;
  ECRDriver.CloseCheck;

  if ECRDriver.ErrorCode = 0 then
    DisplayKKMStatus
  else
    ShowError;
end;

procedure TKKMTestForm.Button14Click(Sender: TObject);
begin
  //ECRDriver.Name:=Edit5.Text;
  ECRDriver.PrintLine(Edit5.Text);
  ECRDriver.Price:=StrToFloat(Edit6.Text);
  ECRDriver.Quantity:=StrToFloat(Edit7.Text);
  ECRDriver.Department:=ComboBox4.ItemIndex;
  ECRDriver.Registration;
  if ECRDriver.ErrorCode = 0 then
    DisplayKKMStatus
  else
    ShowError;
end;

procedure TKKMTestForm.Button15Click(Sender: TObject);
begin
  ECRDriver.PrintPurpose:=1;
  ECRDriver.DemoPrint;
  DisplayKKMStatus;
end;

procedure TKKMTestForm.Button16Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=4;
  ECRDriver.GetRegister;
  Memo1.Lines.Add('4 - Сумма внесений = ' + CurrToStr(ECRDriver.Summ));
end;

procedure TKKMTestForm.Button17Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=5;
  ECRDriver.GetRegister;
  Memo1.Lines.Add('5 - Сумма выплат = ' + CurrToStr(ECRDriver.Summ));
end;

procedure TKKMTestForm.Button18Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=6;
  DoPrintRegister('6 - Количество регистраций', [1..6]);
end;

procedure TKKMTestForm.Button19Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=10;
  ECRDriver.GetRegister;
  Memo1.Lines.Add('10 - Наличность в кассе = ' + CurrToStr(ECRDriver.Summ));
end;

procedure TKKMTestForm.Button10Click(Sender: TObject);
begin
  ECRDriver.OpenSession;
  if ECRDriver.ErrorCode = 0 then
    DisplayKKMStatus
  else
    ShowError;
end;

procedure TKKMTestForm.btnZReportClick(Sender: TObject);
begin
  ECRDriver.SetMode(3);
  ECRDriver.ReportZ;
  if ECRDriver.ErrorCode = 0 then
    DisplayKKMStatus
  else
    ShowError;
end;

procedure TKKMTestForm.btnZReport1Click(Sender: TObject);
begin
  ECRDriver.ResetSummary;
  if ECRDriver.ErrorCode = 0 then
    DisplayKKMStatus
  else
    ShowError;
end;

procedure TKKMTestForm.Button11Click(Sender: TObject);
begin
  ECRDriver.Department:=ComboBox4.ItemIndex;
  ECRDriver.OpenCheck;
  if ECRDriver.ErrorCode = 0 then
    DisplayKKMStatus
  else
    ShowError;
end;

procedure TKKMTestForm.Button3Click(Sender: TObject);
begin
  DisplayKKMStatus;
end;

procedure TKKMTestForm.Button4Click(Sender: TObject);
begin
  ECRDriver.Beep;
  ShowError;
end;

procedure TKKMTestForm.Button5Click(Sender: TObject);
begin
  ECRDriver.CutCheck;
  ShowError;
end;

procedure TKKMTestForm.Button6Click(Sender: TObject);
begin
  ECRDriver.ReportX(ComboBox3.ItemIndex+1);
  ShowError;
end;

procedure TKKMTestForm.Button7Click(Sender: TObject);
begin
  DisplayKKMStatus
end;

procedure TKKMTestForm.Button8Click(Sender: TObject);
begin
  ECRDriver.PrintClishe;
  ShowError;
end;

procedure TKKMTestForm.btnStornoClick(Sender: TObject);
begin
  ECRDriver.SetMode(1);

  ECRDriver.CheckType:=2;
  ECRDriver.OpenCheck;

  //1
  ECRDriver.Price:=StrToFloat(Edit6.Text);
  ECRDriver.Quantity:=StrToFloat(Edit7.Text);
  ECRDriver.Department:=ComboBox4.ItemIndex;
  ECRDriver.Return;
  ShowError;
  WriteLog(ECRDriver.ErrorCodeStr);

  //N
  ECRDriver.Summ:=0; //StrToFloat(Edit6.Text);
  ECRDriver.CloseCheck;

  ECRDriver.ResetMode;
  //DisplayKKMStatus
end;

procedure TKKMTestForm.Button9Click(Sender: TObject);
begin
  ECRDriver.RegisterNumber:=3;
  ECRDriver.TypeClose:=1;
  DoPrintRegister('3 - Сумма платежей', [1..6]);
end;

procedure TKKMTestForm.CheckBox6Change(Sender: TObject);
begin
  if CheckBox6.Checked then
  begin
    ECRDriver.Password:=edtPwd.Text;
    ECRDriver.PortName:=ComboBox1.Text;
    try
      ECRDriver.GetStatus;
      DisplayKKMStatus;
      ComboBox2.ItemIndex:=ECRDriver.Mode;
    except
      on E:Exception do
      begin
        if E is EECRAtol then
          CheckBox6.Checked:=false;
        ShowMessage( E.Message );
      end;
    end;
    ShowError;
  end;

  Label1.Enabled:=not CheckBox6.Checked;
  Label8.Enabled:=not CheckBox6.Checked;
  ComboBox1.Enabled:=not CheckBox6.Checked;
  edtPwd.Enabled:=not CheckBox6.Checked;

  Button1.Enabled:=CheckBox6.Checked;
  Button3.Enabled:=CheckBox6.Checked;
  Button4.Enabled:=CheckBox6.Checked;
  Button5.Enabled:=CheckBox6.Checked;
  Label3.Enabled:=CheckBox6.Checked;
  Edit2.Enabled:=CheckBox6.Checked;
  ComboBox2.Enabled:=CheckBox6.Checked;
  Label9.Enabled:=CheckBox6.Checked;
  Button7.Enabled:=CheckBox6.Checked;
  Button8.Enabled:=CheckBox6.Checked;
  UpdateControlModeState;
  ComboBox4.ItemIndex:=ECRDriver.Department;
end;

procedure TKKMTestForm.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex<5 then
  begin
    ECRDriver.SetMode(ComboBox2.ItemIndex);
    ShowError;
    UpdateControlModeState;
  end
  else
  begin
    ShowMessage('На время тестирования опасные команды запретим!');
    ComboBox2.ItemIndex:=0;
  end;
end;

procedure TKKMTestForm.FormCreate(Sender: TObject);
var
  S:string;
begin
  ListBox1.Items.Clear;

  //Fill ports
  S:=GetSerialPortNames;
  while Pos(',', S)>0 do
    ComboBox1.Items.Add(Copy2SymbDel(S,','));
  if S<>'' then
    ComboBox1.Items.Add(S);
  if ComboBox1.Items.Count>0 then
    ComboBox1.ItemIndex:=0;

  ShowError;
  CheckBox6Change(nil);
end;

procedure TKKMTestForm.MenuItem1Click(Sender: TObject);
begin
  ListBox1.Items.Clear;
end;

procedure TKKMTestForm.UpdateControlModeState;
begin
  ComboBox3.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 2);
  Button6.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 2);

  Button10.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Button11.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Button12.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Button13.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);

  Label2.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Label10.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Label11.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Edit5.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Edit6.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Edit7.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);

  Label12.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  CurrencyEdit1.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Button25.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);

  Label14.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  CurrencyEdit2.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);
  Button26.Enabled:=CheckBox6.Checked and (ECRDriver.Mode = 1);

  btnZReport.Enabled:=CheckBox6.Checked; // and (ECRDriver.Mode = 3);
end;

procedure TKKMTestForm.DisplayKKMStatus;
begin
  ECRDriver.ReadModel;
  Edit3.Text:=ECRDriver.DeviseType.KKMName;

  ECRDriver.GetStatus1;
  CheckBox1.Checked:=ECRDriver.OutOfPaper;
  CheckBox5.Checked:=ECRDriver.PrinterOverheatError;
  CheckBox4.Checked:=ECRDriver.PrinterCutMechanismError;

  ECRDriver.GetStatus;
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Кассир       : ' + IntToStr(ECRDriver.DeviseState.KssNumber));
  Memo1.Lines.Add('Номер_в_зале : ' + IntToStr(ECRDriver.DeviseState.NumberInHall));
  Memo1.Lines.Add('Дата_YMD : ' + DateToStr(ECRDriver.DeviseState.KKMDate));
  Memo1.Lines.Add('Время_HMS : ' + TimeToStr(ECRDriver.DeviseState.KKMTime));
  Memo1.Lines.Add('Флаги : ' + hexStr(ECRDriver.DeviseState.Flags, 2));
  Memo1.Lines.Add('Заводской_номер : ' + ECRDriver.SerialNumber );
  Memo1.Lines.Add('Версия_ПО_ККТ : ' + ECRDriver.DeviseState.Version);
  Memo1.Lines.Add(Format('Режим_работы : %d.%d', [ECRDriver.Mode, ECRDriver.SubMode]));
  Memo1.Lines.Add('Номер_чека : ' + IntToStr(ECRDriver.DeviseState.CheckNum));
  Memo1.Lines.Add('Номер_смены : ' + IntToStr(ECRDriver.DeviseState.NumSmena));
  Memo1.Lines.Add('Состояние_чека : ' + IntToStr(ECRDriver.DeviseState.CheckState));
  Memo1.Lines.Add('Сумма_чека : ' + FloatToStr(ECRDriver.DeviseState.CheckSum));
  Memo1.Lines.Add('Десятичная_точка : ' + IntToStr(ECRDriver.DeviseState.DecimalSep));
  Memo1.Lines.Add('Порт : ' + IntToStr(ECRDriver.DeviseState.Port));
  Memo1.Lines.Add('Смена открыта : ' + BoolToStr(ECRDriver.SessionOpened, true));

  Memo1.Lines.Add('Нет бумаги : ' + BoolToStr(ECRDriver.OutOfPaper, true));
  Memo1.Lines.Add('Крышка открыта : ' + BoolToStr(ECRDriver.CoverOpened, true));
  Memo1.Lines.Add('Батарейка разряжена : ' + BoolToStr(ECRDriver.BatteryLow, true));

  Edit4.Text:=IntToStr(ECRDriver.Mode);
  Edit4.Text:=IntToStr(ECRDriver.Mode)+'.'+IntToStr(ECRDriver.SubMode);
  ComboBox2.ItemIndex:=ECRDriver.Mode;

  ShowError;
end;

procedure TKKMTestForm.DoPrintRegister(AMsg: string; AChekTypes: TCheckTypes);
var
  i:byte;
begin
  for i:=1 to 6 do
    if i in AChekTypes then
    begin
      ECRDriver.CheckType:=i;
      ECRDriver.GetRegister;
      Memo1.Lines.Add(Format('%s - (%d - %s) = %m', [AMsg, i, AtolCheckTypeNames[i], ECRDriver.Summ]));
    end;
end;

procedure TKKMTestForm.ShowError;
begin
  Edit1.Text:='('+IntToStr(ECRDriver.ErrorCode)+') '+ECRDriver.ErrorCodeStr;
  WriteLog(Edit1.Text);
end;

initialization
  CurrencyString:='р.';
  FLogProc:=@WriteLog;
  LogFileName:=ExtractFileNameWithoutExt(ParamStr(0))+'.log';
end.

