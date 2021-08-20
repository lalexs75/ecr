unit v10OtherUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Spin, tv10globalunit;

type

  { Tv10OtherFrame }

  Tv10OtherFrame = class(TConfigFrame)
    Button13: TButton;
    Button19: TButton;
    Button21: TButton;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit5: TEdit;
    GroupBox1: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label8: TLabel;
    Memo2: TMemo;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    procedure Button13Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
  private

  public

  end;

implementation
uses rxlogging, libfptr10, CasheRegisterAbstract;

{$R *.lfm}

{ Tv10OtherFrame }

procedure Tv10OtherFrame.Button13Click(Sender: TObject);
{var
  T: TEcrTextAlign;}
begin
  FKKM.Connected:=true;
  FKKM.Open;

  case RadioGroup1.ItemIndex of
    0:FKKM.TextParams.Align:=etaLeft;
    1:FKKM.TextParams.Align:=etaCenter;
    2:FKKM.TextParams.Align:=etaRight;
  end;

  case RadioGroup2.ItemIndex of
    0:FKKM.TextParams.WordWrap:=ewwNone;
    1:FKKM.TextParams.WordWrap:=ewwWords;
    2:FKKM.TextParams.WordWrap:=ewwChars;
  end;

  FKKM.TextParams.FontNumber:=SpinEdit2.Value;
  FKKM.TextParams.DoubleWidth:=CheckBox4.Checked;
  FKKM.TextParams.DoubleHeight:=CheckBox5.Checked;
  FKKM.TextParams.LineSpacing:=SpinEdit3.Value;
  FKKM.TextParams.Brightness:=SpinEdit4.Value;

  FKKM.PrintLine(Edit5.Text);

  FKKM.Close;
  FKKM.Connected:=false;
end;

procedure Tv10OtherFrame.Button19Click(Sender: TObject);
begin
  FKKM.Connected:=true;
  FKKM.Open;
  Edit1.Text:=DateTimeToStr(FKKM.DeviceDateTime);
  FKKM.Close;
  FKKM.Connected:=false;
end;

procedure Tv10OtherFrame.Button21Click(Sender: TObject);
begin
  FKKM.Connected:=true;
  FKKM.Open;
  Edit2.Text:=FloatToStr(FKKM.NonNullableSum);
  Memo2.Lines.Clear;

  Memo2.Lines.Add('Наличка : продажа = '+FloatToStr(FKKM.NonNullableSum(LIBFPTR_RT_SELL, LIBFPTR_PT_CASH)));
  Memo2.Lines.Add('Наличка : возврат продажи = '+FloatToStr(FKKM.NonNullableSum(LIBFPTR_RT_SELL_RETURN, LIBFPTR_PT_CASH)));

  Memo2.Lines.Add('Наличка : покупка = '+FloatToStr(FKKM.NonNullableSum(LIBFPTR_RT_BUY, LIBFPTR_PT_CASH)));
  Memo2.Lines.Add('Наличка : возврат покупки = '+FloatToStr(FKKM.NonNullableSum(LIBFPTR_RT_BUY_RETURN, LIBFPTR_PT_CASH)));

  FKKM.Close;
  FKKM.Connected:=false;
end;

end.

