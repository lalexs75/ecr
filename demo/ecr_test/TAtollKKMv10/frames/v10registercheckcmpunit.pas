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

unit v10RegisterCheckCmpUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  tv10globalunit;

type

  { Tv10RegisterCheckCmpFrame }

  Tv10RegisterCheckCmpFrame = class(TConfigFrame)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
  private

  public
    procedure UpdateCtrlState; override;
  end;

implementation
uses rxlogging, CasheRegisterAbstract;

{$R *.lfm}

{ Tv10RegisterCheckCmpFrame }

procedure Tv10RegisterCheckCmpFrame.Button1Click(Sender: TObject);
begin
  FKKM.CheckType:=chtSell;
  FKKM.OpenCheck;
  FKKM.FFD1_2:=true;
  FKKM.GoodsInfo.Name:=Edit1.Text;
  FKKM.GoodsInfo.Price:=StrToFloat(Edit2.Text);
  FKKM.GoodsInfo.Quantity:=1; //StrToFloat(Edit2.Text);
  FKKM.GoodsInfo.TaxType:=ttaxVat20;
  FKKM.GoodsInfo.GoodsPayMode:=gpmFullPay;
  FKKM.GoodsInfo.GoodsType:=gtCommodity;
  if Edit4.Text<>'' then
    FKKM.GoodsInfo.GoodsNomenclatureCode.KM:=Edit4.Text;
  FKKM.Registration;
  FKKM.CloseCheck;
end;

procedure Tv10RegisterCheckCmpFrame.UpdateCtrlState;
begin
  inherited UpdateCtrlState;
  Button1.Enabled:=FKKM.Connected;
end;

end.

