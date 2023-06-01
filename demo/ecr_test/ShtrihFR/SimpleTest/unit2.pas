unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Buttons, Atollv10_JSON, DividerBevel;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    btnCreateKKM: TButton;
    btnFreeKKM: TButton;
    btnShowProps: TButton;
    btnDriverVers: TButton;
    btnBeep: TButton;
    btnCutChek: TButton;
    btnSimpleCheck: TButton;
    Button1: TButton;
    btnCloseCheck: TButton;
    btnCancelCheck: TButton;
    btnReportZ: TButton;
    cbConnect: TCheckBox;
    cbPartialCut: TCheckBox;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    StatusBar1: TStatusBar;
    procedure btnBeepClick(Sender: TObject);
    procedure btnCancelCheckClick(Sender: TObject);
    procedure btnCreateKKMClick(Sender: TObject);
    procedure btnCutChekClick(Sender: TObject);
    procedure btnFreeKKMClick(Sender: TObject);
    procedure btnShowPropsClick(Sender: TObject);
    procedure btnDriverVersClick(Sender: TObject);
    procedure btnSimpleCheckClick(Sender: TObject);
    procedure btnReportZClick(Sender: TObject);
    procedure btnCloseCheckClick(Sender: TObject);
    procedure cbConnectChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FShtrihFR: OleVariant;  //Устройство ККМ ШТРИХ-ФР
    FConnected:Boolean;
    procedure UpdateStatus;
    procedure UpdateUICtrlState;
    function AssignedKKMHandle:Boolean;
    procedure InternalConnect;
    procedure InternalDisConnect;
  public

  end;

var
  Form2: TForm2;

implementation
uses
  ComObj, ActiveX,
  LazUTF8
  ;

{$R *.lfm}

function StringToAtollWideStr(const AValue: string): WideString;
begin
  Result:=AValue;
end;

{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
begin
  FShtrihFR:=null;
  FConnected:=false;
  UpdateUICtrlState;
end;

procedure TForm2.btnCreateKKMClick(Sender: TObject);
begin
  FShtrihFR := CreateOleObject('AddIn.DrvFR');
  UpdateUICtrlState;
end;

procedure TForm2.btnCutChekClick(Sender: TObject);
begin
  //FShtrihFR.Password:=Password;
  FShtrihFR.CutType:=cbPartialCut.Checked;
  FShtrihFR.CutCheck;
  UpdateStatus;
end;

procedure TForm2.btnBeepClick(Sender: TObject);
begin
  FShtrihFR.Beep;
  UpdateStatus;
end;

procedure TForm2.btnCancelCheckClick(Sender: TObject);
begin
  FShtrihFR.CancelCheck;
  UpdateStatus;
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

procedure TForm2.btnSimpleCheckClick(Sender: TObject);
var
  W:WideString;
  S:String;
begin
  FShtrihFR.OpenCheck;
  FShtrihFR.CheckType:=1;

  //Первая строка
  FShtrihFR.Quantity := 1;
  FShtrihFR.Price := 5;
  FShtrihFR.Summ1Enabled := false;
  FShtrihFR.Tax1 := 1;
  FShtrihFR.Department := 1;
  FShtrihFR.PaymentTypeSign := 4; //Признак способа расчета для ФФД 1.05: "Полный расчет"
  FShtrihFR.PaymentItemSign := 1; //Признак предмета расчета: "Подакцизный товар"

  //организация передачи наименования товарной позиции. Мах длинна не более 128 сим.
  S:='БАД ''Букет цветов'' упаковка №1';
  FShtrihFR.StringForPrinting := StringToAtollWideStr(S);
  FShtrihFR.FNOperation();

  FShtrihFR.BarCode := '010173456789433921GPiOI99wtmAtM91002492/r+UHmeqRXXfjCTLC2j8MauSavTwXGF/kkzKpaKQ50ZNvoLatTkTeHfGO6vLvGtTlQP0c5MOk0X15Wp3JYp6KA==';
  FShtrihFR.FNSendItemBarcode();

  //Вторая строка
  FShtrihFR.Quantity := 1;
  FShtrihFR.Price := 15;
  FShtrihFR.Summ1Enabled := false;
  FShtrihFR.Tax1 := 1;
  FShtrihFR.Department := 1;
  FShtrihFR.PaymentTypeSign := 4; //Признак способа расчета для ФФД 1.05: "Полный расчет"
  FShtrihFR.PaymentItemSign := 1; //Признак предмета расчета: "Подакцизный товар"

  FShtrihFR.StringForPrinting := StringToAtollWideStr('Пюре картофельное');
  FShtrihFR.FNOperation();

             //Закрываем чек
  FShtrihFR.Summ1 := 20;
  FShtrihFR.Summ2 := 0;
  FShtrihFR.Summ3 := 0;
  FShtrihFR.Summ4 := 0;
  FShtrihFR.Summ5 := 0;
  FShtrihFR.Summ6 := 0;
  FShtrihFR.Summ7 := 0;
  FShtrihFR.Summ8 := 0;
  FShtrihFR.Summ9 := 0;
  FShtrihFR.Summ10 := 0;
  FShtrihFR.Summ11 := 0;
  FShtrihFR.Summ12 := 0;
  FShtrihFR.Summ13 := 0;
  FShtrihFR.Summ14 := 0;
  FShtrihFR.Summ15 := 0;
  FShtrihFR.Summ16 := 0;
  FShtrihFR.RoundingSumm := 0;
  FShtrihFR.TaxType := 1;
  FShtrihFR.StringForPrinting := '====================================================';
  FShtrihFR.FNCloseCheckEx();

  UpdateStatus;
end;

procedure TForm2.btnReportZClick(Sender: TObject);
begin
  FShtrihFR.Password:=30;
  FShtrihFR.PrintReportWithCleaning;
  UpdateStatus;
end;

procedure TForm2.btnCloseCheckClick(Sender: TObject);
begin
  //Закрываем чек
  FShtrihFR.Summ1 := 20;
  FShtrihFR.Summ2 := 0;
  FShtrihFR.Summ3 := 0;
  FShtrihFR.Summ4 := 0;
  FShtrihFR.Summ5 := 0;
  FShtrihFR.Summ6 := 0;
  FShtrihFR.Summ7 := 0;
  FShtrihFR.Summ8 := 0;
  FShtrihFR.Summ9 := 0;
  FShtrihFR.Summ10 := 0;
  FShtrihFR.Summ11 := 0;
  FShtrihFR.Summ12 := 0;
  FShtrihFR.Summ13 := 0;
  FShtrihFR.Summ14 := 0;
  FShtrihFR.Summ15 := 0;
  FShtrihFR.Summ16 := 0;
  FShtrihFR.RoundingSumm := 0;
  FShtrihFR.TaxType := 1;
  FShtrihFR.StringForPrinting := '====================================================';
  FShtrihFR.FNCloseCheckEx();

  UpdateStatus;
end;

procedure TForm2.cbConnectChange(Sender: TObject);
begin
  if cbConnect.Checked and not FConnected then
  begin
    InternalConnect;
    if not FConnected then
      cbConnect.Checked:=false;
  end
  else
  if not cbConnect.Checked and FConnected then
  begin
    InternalDisConnect;
  end;

  UpdateUICtrlState;
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
  cbConnect.Enabled:=FEnbl;
  btnDriverVers.Enabled:=FEnbl;

  if FEnbl then
  begin
    btnBeep.Enabled:=FConnected;
    btnCutChek.Enabled:=FConnected;
    cbPartialCut.Enabled:=FConnected;

    btnSimpleCheck.Enabled:=FConnected;
    btnCancelCheck.Enabled:=FConnected;
    btnCloseCheck.Enabled:=FConnected;

    btnReportZ.Enabled:=FConnected;
  end
  else
  begin
    btnBeep.Enabled:=false;
    btnCutChek.Enabled:=false;
    cbPartialCut.Enabled:=false;

    btnSimpleCheck.Enabled:=false;
    btnCancelCheck.Enabled:=false;
    btnCloseCheck.Enabled:=false;

    btnReportZ.Enabled:=false;
  end;

  UpdateStatus;
end;

function TForm2.AssignedKKMHandle: Boolean;
begin
  Result:=not(FShtrihFR=null);
end;

procedure TForm2.InternalConnect;
begin
  FShtrihFR.Connect();
  FConnected:=FShtrihFR.ResultCode = 0;
end;

procedure TForm2.InternalDisConnect;
begin
  FShtrihFR.Disconnect();
  FConnected:=false;
end;

end.

