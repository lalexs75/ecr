unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form2:=TForm2.Create(Application);
  Form2.ShowModal;
  Form2.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form3:=TForm3.Create(Application);
  Form3.ShowModal;
  Form3.Free;
end;

end.
{

  ' Точная продажа
  Driver.StringForPrinting = "Тестовая строка"
  Driver.Price = 100
  Driver.Quantity = 200
  Driver.Department = 1
  Driver.Tax1 = 0
  Driver.Tax2 = 0
  Driver.Tax3 = 0
  Driver.Tax4 = 0
  Driver.SaleEx()
  ' Просто продажа
  Driver.StringForPrinting = "Тестовая строка"
  Driver.Price = 100
  Driver.Quantity = 200
  Driver.Department = 1
  Driver.Tax1 = 0
  Driver.Tax2 = 0
  Driver.Tax3 = 0
  Driver.Tax4 = 0
  Driver.Sale() }
{
  R:=FShtrihFR.Beep();
  EC:=FShtrihFR.ResultCode;
  S:=FShtrihFR.ResultCodeDescription;

  FShtrihFR.OpenCheck();
  EC:=FShtrihFR.ResultCode;
  S:=FShtrihFR.ResultCodeDescription;
  // Обращение к свойству
//  if R<0 then
//  FShtrihFR.Clear;
}

