unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, UTF8Process, egate_class, KKM_Atol, rxcurredit,
  sbrf_pc_com, sbrf_plastic_console, Forms, Controls, Graphics, Dialogs,
  StdCtrls, LCLType, Spin, alexs_plastic_cards_abstract, DividerBevel;

const
  {$IFDEF LINUX}
  CmdName = '/home/SC552/sb_pilot';
  CmdErrorFile = '/home/SC552/e';
  CmdSlipFile = '/home/SC552/p';
  {$ELSE}
  CmdName = 'C:\SC552\upwin.exe';
  CmdErrorFile = 'C:\SC552\e';
  CmdSlipFile = 'C:\SC552\p';
  {$ENDIF}
type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CurrencyEdit1: TCurrencyEdit;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    ProcessUTF8_1: TProcessUTF8;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SBPlasticCard1: TSBPlasticCard;
    SBPlasticCardConsole1: TSBPlasticCardConsole;
    SpinEdit1: TSpinEdit;
    SpinEdit3: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SBPlasticCard1Status(Sender: TPlasticCardAbstract);
  private
    function CurPinpad:TPlasticCardAbstract;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  C: TPlasticCardAbstract;
begin
  C:=CurPinpad;
  C.KassaID:=SpinEdit1.Value;
  C.Pay(CurrencyEdit1.Value, SpinEdit3.Value);
  if C.ErrorCode <> 0 then
    ShowMessageFmt('Ошибка %d (%s)', [C.ErrorCode, C.ErrorMessage])
  else
    ShowMessage('Успех!');
  Memo1.Text:=C.SlipInfo;
  Edit2.Text:=C.StatusVector;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  C: TPlasticCardAbstract;
begin
  C:=CurPinpad;
  C.EchoTest;
  if C.ErrorCode <> 0 then
    ShowMessageFmt('Ошибка %d (%s)', [C.ErrorCode, C.ErrorMessage])
  else
    ShowMessage('Успех!');
  Edit2.Text:=C.StatusVector;
  Memo1.Text:=C.SlipInfo;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  C: TPlasticCardAbstract;
begin
  C:=CurPinpad;
  C.ReportItog;
  if C.ErrorCode <> 0 then
    ShowMessageFmt('Ошибка %d (%s)', [C.ErrorCode, C.ErrorMessage])
  else
    ShowMessage('Успех!');

  Memo1.Text:=C.SlipInfo;
  Edit2.Text:=C.StatusVector;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  C: TPlasticCardAbstract;
begin
  C:=CurPinpad;
  C.KassaID:=SpinEdit1.Value;
  C.Discard(CurrencyEdit1.Value, '', '');
  if C.ErrorCode <> 0 then
    ShowMessageFmt('Ошибка %d (%s)', [C.ErrorCode, C.ErrorMessage])
  else
    ShowMessage('Успех!');

  Memo1.Text:=C.SlipInfo;
  Edit2.Text:=C.StatusVector;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  C: TPlasticCardAbstract;
begin
  C:=CurPinpad;
  C.KassaID:=SpinEdit1.Value;
  C.Revert(CurrencyEdit1.Value, '');
  if C.ErrorCode <> 0 then
    ShowMessageFmt('Ошибка %d (%s)', [C.ErrorCode, C.ErrorMessage])
  else
    ShowMessage('Успех!');

  Memo1.Text:=C.SlipInfo;
  Edit2.Text:=C.StatusVector;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  C: TPlasticCardAbstract;
begin
  C:=CurPinpad;
  C.ReportOperList;
  if C.ErrorCode <> 0 then
    ShowMessageFmt('Ошибка %d (%s)', [C.ErrorCode, C.ErrorMessage])
  else
    ShowMessage('Успех!');

  Memo1.Text:=C.SlipInfo;
  Edit2.Text:=C.StatusVector;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SBPlasticCardConsole1.CommandName:=CmdName;
  SBPlasticCardConsole1.ErrorFile:=CmdErrorFile;
  SBPlasticCardConsole1.SlipFile:=CmdSlipFile;
end;

procedure TForm1.SBPlasticCard1Status(Sender: TPlasticCardAbstract);
begin
  Edit1.Text:=Format('%d (%s)', [Sender.ErrorCode, Sender.ErrorMessage]);
end;

function TForm1.CurPinpad: TPlasticCardAbstract;
begin
  if RadioButton1.Checked then
    Result:=SBPlasticCard1
  else
    Result:=SBPlasticCardConsole1
    ;
end;

end.

