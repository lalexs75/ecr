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

https://infostart.ru/1c/articles/1192569/
https://docs.google.com/document/d/1m3gHyKvM0gBMPgpzG-1cFsfVDnecouCtzQBJVDooGuM/edit#heading=h.z4tw3du13anc
https://forum.shtrih-m-partners.ru/index.php?topic=33714.0

}
