unit v10ReportsUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  tv10globalunit;

type

  { Tv10ReportsFrame }

  Tv10ReportsFrame = class(TConfigFrame)
    Button5: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private

  public

  end;

implementation

{$R *.lfm}

{ Tv10ReportsFrame }

procedure Tv10ReportsFrame.Button5Click(Sender: TObject);
var
  R: Integer;
begin
  FKKM.Connected:=true;
  FKKM.Open;
  FKKM.ReportX(2);
  FKKM.Close;
  FKKM.Connected:=false;
end;

procedure Tv10ReportsFrame.Button6Click(Sender: TObject);
var
  R: Integer;
begin
  FKKM.Connected:=true;
  FKKM.Open;
  FKKM.ReportZ;
  FKKM.Close;
  FKKM.Connected:=false;
end;

end.

