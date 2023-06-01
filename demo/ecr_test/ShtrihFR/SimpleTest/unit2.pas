unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Buttons, Atollv10_JSON;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    btnCreateKKM: TButton;
    btnFreeKKM: TButton;
    btnShowProps: TButton;
    btnConnect: TButton;
    btnDiconect: TButton;
    btnDriverVers: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    StatusBar1: TStatusBar;
    procedure btnCreateKKMClick(Sender: TObject);
    procedure btnFreeKKMClick(Sender: TObject);
    procedure btnShowPropsClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDriverVersClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FShtrihFR: OleVariant;  //Устройство ККМ ШТРИХ-ФР
    procedure UpdateStatus;
    procedure UpdateUICtrlState;
    function AssignedKKMHandle:Boolean;
  public

  end;

var
  Form2: TForm2;

implementation
uses
  ComObj, ActiveX
  ;

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
begin
  FShtrihFR:=null;
  UpdateUICtrlState;
end;

procedure TForm2.btnCreateKKMClick(Sender: TObject);
begin
  FShtrihFR := CreateOleObject('AddIn.DrvFR');
  UpdateUICtrlState;
end;

procedure TForm2.btnFreeKKMClick(Sender: TObject);
begin
  FShtrihFR:=null;
  UpdateUICtrlState;
end;

procedure TForm2.btnShowPropsClick(Sender: TObject);
begin
  FShtrihFR.ShowProperties();
  UpdateUICtrlState;
end;

procedure TForm2.btnConnectClick(Sender: TObject);
begin
  FShtrihFR.ConnectionType:=5;
  FShtrihFR.Connect();
  UpdateStatus;
end;

procedure TForm2.btnDriverVersClick(Sender: TObject);
var
  S:string;
begin
  S:=FShtrihFR.DriverVersion;
  UpdateStatus;
  if S<>'' then
    ShowMessage(S)
  else
    ShowMessage('<empty>');
end;

procedure TForm2.CheckBox1Change(Sender: TObject);
begin
  FShtrihFR.CheckConnection();
  UpdateStatus;
end;

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if AssignedKKMHandle then
    btnFreeKKMClick(nil);
end;

procedure TForm2.UpdateStatus;
var
  EC:Integer;
  S:string;
begin
  if FShtrihFR = null then
    StatusBar1.SimpleText:='Не подключено'
  else
  begin
    EC:=FShtrihFR.ResultCode;
    S:=FShtrihFR.ResultCodeDescription;
    StatusBar1.SimpleText:=Format('%d : %s', [EC, S]);
  end;
end;

procedure TForm2.UpdateUICtrlState;
var
  FEnbl:Boolean;
begin
  FEnbl:=AssignedKKMHandle;
  btnCreateKKM.Enabled:=not FEnbl;
  btnFreeKKM.Enabled:=FEnbl;
  btnShowProps.Enabled:=FEnbl;
  btnConnect.Enabled:=FEnbl;
  btnDiconect.Enabled:=FEnbl;
  btnDriverVers.Enabled:=FEnbl;

  UpdateStatus;
end;

function TForm2.AssignedKKMHandle: Boolean;
begin
  Result:=not(FShtrihFR=null);
end;

end.

