{
  Test application for atoll cashe register

  Copyright (C) 2021 Lagunov Aleksey alexs75@yandex.ru

  This source is free software; you can redistribute it and/or modify it under the terms of the GNU General Public
  License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later
  version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web at
  <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing to the Free Software Foundation, Inc., 51
  Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.
}

unit v10ReportsUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DividerBevel,
  tv10globalunit;

type

  { Tv10ReportsFrame }

  Tv10ReportsFrame = class(TConfigFrame)
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    DividerBevel1: TDividerBevel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CLabel: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private

  public
    procedure UpdateCtrlState; override;
  end;

implementation
uses libfptr10;
{$R *.lfm}

{ Tv10ReportsFrame }

procedure Tv10ReportsFrame.Button1Click(Sender: TObject);
begin
{  case ComboBox1.ItemIndex of

  end;}
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_REPORT_TYPE, ComboBox1.ItemIndex);
  FKKM.LibraryAtol.Report(FKKM.Handle);
  FKKM.InternalCheckError;
end;

procedure Tv10ReportsFrame.ComboBox1Change(Sender: TObject);
begin
  Edit1.Enabled:=ComboBox1.ItemIndex = 7;
end;

procedure Tv10ReportsFrame.UpdateCtrlState;
begin
  inherited;
  Button1.Enabled:=FKKM.Connected;
end;

end.

