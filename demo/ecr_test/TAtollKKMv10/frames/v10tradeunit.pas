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

unit v10tradeunit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, rxmemds,
  RxDBGrid, DB, tv10globalunit, AtollKKMv10;

type

  { Tv10TradeFrame }

  Tv10TradeFrame = class(TConfigFrame)
    Button8: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    dsGoods: TDataSource;
    dsPays: TDataSource;
    edtContragentInn: TEdit;
    edtContragentInn1: TEdit;
    edtContragentName: TEdit;
    edtContragentName1: TEdit;
    edtEmail: TEdit;
    edtEmail1: TEdit;
    edtPhone: TEdit;
    edtPhone1: TEdit;
    edtSuplierEmail: TEdit;
    edtSuplierInn: TEdit;
    edtSuplierName: TEdit;
    edtSuplierPhone: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    RxDBGrid1: TRxDBGrid;
    RxDBGrid2: TRxDBGrid;
    rxGoods: TRxMemoryData;
    rxGoodsAMOUNT: TFloatField;
    rxGoodsCOUNTRY_CODE: TLongintField;
    rxGoodsGOODS_CODE: TStringField;
    rxGoodsGOODS_NAME: TStringField;
    rxGoodsGTD: TStringField;
    rxGoodsMARKS_GROUP: TWordField;
    rxGoodsMARKS_GTIN: TStringField;
    rxGoodsMARKS_SERIAL: TStringField;
    rxGoodsPRICE: TCurrencyField;
    rxGoodsSUM: TCurrencyField;
    rxGoodsTAX_TYPE: TLongintField;
    rxPays: TRxMemoryData;
    rxPaysPaySum: TCurrencyField;
    rxPaysPayType: TLongintField;
    rxPaysPayTypeName: TStringField;
    procedure Button8Click(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure rxGoodsBeforePost(DataSet: TDataSet);
  private
    procedure InitGoodsDataSet;
  public
    procedure InitData(AKKM:TAtollKKMv10); override;
    procedure UpdateCtrlState; override;
  end;

implementation
uses rxlogging, CasheRegisterAbstract;

{$R *.lfm}

{ Tv10TradeFrame }

procedure Tv10TradeFrame.Button8Click(Sender: TObject);
var
  GI: TGoodsInfo;
  PayInfo: TPaymentInfo;
begin
  RxWriteLog(etDebug, 'Формируем тестовый чек');

  if FKKM.CheckType <> chtNone then
  begin
    rxWriteLog(etDebug, 'Открыт превыдущий чек - отменяем');
    FKKM.CancelCheck;
  end;

  FKKM.BeginCheck;
  FKKM.CheckType:=TCheckType(ComboBox1.ItemIndex+1); //chtSell;
  //Определим параметры покупателя
  FKKM.CounteragentInfo.Name:=edtContragentName.Text;
  FKKM.CounteragentInfo.INN:=edtContragentInn.Text;
  FKKM.CounteragentInfo.Phone:=edtPhone.Text;
  FKKM.CounteragentInfo.Email:=edtEmail.Text;
  FKKM.CheckInfo.Electronically:=CheckBox1.Checked;
  FKKM.PaymentPlace:='Место расчёта 1';

  FKKM.OpenCheck;
  if FKKM.ErrorCode <> 0 then
  begin
    ShowMessage(FKKM.ErrorDescription);
    Exit;
  end;

//  rxWriteLog(etDebug, 'CheckNumber = ' + IntToStr(FKKM.CheckNumber));

  //Начинаем регистрацию товара к продаже
  rxGoods.First;
  while not rxGoods.EOF do
  begin
    GI:=FKKM.GoodsList.Add;
    GI.GoodsType:=gtCommodity;
    if CheckBox3.Checked then
    begin
      //Укажем данные поставщика
      GI.SuplierInfo.Name:=edtSuplierName.Text;
      GI.SuplierInfo.INN:=edtSuplierInn.Text;
      GI.SuplierInfo.Phone:=edtSuplierPhone.Text;
      GI.SuplierInfo.Email:=edtSuplierEmail.Text;
    end;


    GI.Name:=rxGoodsGOODS_NAME.AsString;
    GI.Price:=rxGoodsPRICE.AsFloat;
    GI.Quantity:=rxGoodsAMOUNT.AsFloat;
    GI.TaxType:=TTaxType(rxGoodsTAX_TYPE.AsInteger);

    if (rxGoodsGTD.AsString <> '') and (rxGoodsCOUNTRY_CODE.AsInteger <> 0) then
    begin
      GI.CountryCode:=rxGoodsCOUNTRY_CODE.AsInteger;
      GI.DeclarationNumber:=rxGoodsGTD.AsString;
    end;

    GI.GoodsPayMode:=gpmFullPay;

    rxGoods.Next;
  end;

  rxPays.First;
  while not rxPays.EOF do
  begin
    if rxPaysPaySum.AsCurrency > 0 then
    begin
      PayInfo:=FKKM.PaymentsList.Add;
      PayInfo.PaymentType:=TPaymentType(rxPaysPayType.AsInteger);
      PayInfo.PaymentSum:=rxPaysPaySum.AsCurrency;
    end;
    rxPays.Next;
  end;

  FKKM.RegisterGoods;
  FKKM.RegisterPayments;


  // Закрытие чека
  FKKM.CloseCheck;

  if FKKM.ErrorCode <> 0 then
    ShowMessage(FKKM.ErrorDescription);

  rxGoods.First;
  rxPays.First;
end;

procedure Tv10TradeFrame.CheckBox2Change(Sender: TObject);
begin
  UpdateCtrlState;
end;

procedure Tv10TradeFrame.rxGoodsBeforePost(DataSet: TDataSet);
begin
  rxGoodsSUM.AsCurrency:=rxGoodsAMOUNT.AsFloat * rxGoodsPRICE.AsFloat;
end;

procedure Tv10TradeFrame.InitGoodsDataSet;
var
  PT: TPaymentType;
begin
  rxGoods.CloseOpen;
  rxGoods.AppendRecord(['F000-001-25487', 'Чипсы LAYS', 1, 73.99,  null,  null,  null, 7, $444D, '02900000475830', 'MdEfx:Xp6YFd7']);

  rxGoods.AppendRecord(['000.000.001', 'Насос НШ-14М-3 (НШ-14Г-3) правый (Гидросила)', 3, 17.40, null,  null, null, 7]);
//  rxGoods.AppendRecord(['6311', 'СМЕСИТЕЛЬ Д/МОЙКИ 1рук. "Oskar" в/гусак Китай', 954.32, 2, null, 547, '10714040/140917/0090376', 2]);
  rxGoods.First;

  rxPays.CloseOpen;
  for PT in TPaymentType do
    rxPays.AppendRecord([ord(PT), PaymentTypeStr(PT)]);
  rxPays.First;
  rxPays.Edit;
  rxPaysPaySum.AsCurrency:=RxDBGrid1.ColumnByFieldName('SUM').Footer.NumericValue;
  rxPays.Post;
end;

procedure Tv10TradeFrame.InitData(AKKM: TAtollKKMv10);
var
  C: TCheckType;
begin
  inherited InitData(AKKM);

  ComboBox1.Items.Clear;
  for C:=chtSell to High(TCheckType) do
    ComboBox1.Items.Add(CheckTypeStr(C));
  ComboBox1.ItemIndex:=0;
  InitGoodsDataSet;
end;

procedure Tv10TradeFrame.UpdateCtrlState;
begin
  inherited UpdateCtrlState;
//  edtPayPlace.Enabled:=chPayPlace.Checked;
  Label14.Enabled:=FKKM.Connected;
  Label1.Enabled:=FKKM.Connected;
  Label2.Enabled:=FKKM.Connected;
  Label6.Enabled:=FKKM.Connected;
  Label7.Enabled:=FKKM.Connected;

  edtContragentName.Enabled:=FKKM.Connected;
  edtContragentInn.Enabled:=FKKM.Connected;
  edtPhone.Enabled:=FKKM.Connected;
  edtEmail.Enabled:=FKKM.Connected;


  Button8.Enabled:=FKKM.Connected;
  Label15.Enabled:=CheckBox2.Checked and FKKM.Connected;
  Label16.Enabled:=CheckBox2.Checked and FKKM.Connected;
  Label17.Enabled:=CheckBox2.Checked and FKKM.Connected;
  Label18.Enabled:=CheckBox2.Checked and FKKM.Connected;
  edtContragentName1.Enabled:=CheckBox2.Checked and FKKM.Connected;
  edtContragentInn1.Enabled:=CheckBox2.Checked and FKKM.Connected;
  edtPhone1.Enabled:=CheckBox2.Checked and FKKM.Connected;
  edtEmail1.Enabled:=CheckBox2.Checked and FKKM.Connected;

  Label19.Enabled:=CheckBox3.Checked and FKKM.Connected;
  Label20.Enabled:=CheckBox3.Checked and FKKM.Connected;
  Label21.Enabled:=CheckBox3.Checked and FKKM.Connected;
  Label22.Enabled:=CheckBox3.Checked and FKKM.Connected;
  edtSuplierName.Enabled:=CheckBox3.Checked and FKKM.Connected;
  edtSuplierInn.Enabled:=CheckBox3.Checked and FKKM.Connected;
  edtSuplierPhone.Enabled:=CheckBox3.Checked and FKKM.Connected;
  edtSuplierEmail.Enabled:=CheckBox3.Checked and FKKM.Connected;
end;

end.

