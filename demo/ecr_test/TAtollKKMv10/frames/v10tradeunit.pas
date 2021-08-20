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
begin
  RxWriteLog(etDebug, 'Формируем тестовый чек');
  //InitKassirData;

  FKKM.Connected:=true;

  FKKM.Open;

  if FKKM.CheckType <> chtNone then
  begin
    rxWriteLog(etDebug, 'Открыт превыдущий чек - отменяем');
    FKKM.CancelCheck;
  end;

  FKKM.CheckType:=TCheckType(ComboBox1.ItemIndex+1); //chtSell;
  //Определим параметры покупателя
  FKKM.CounteragentInfo.Name:=edtContragentName.Text;
  FKKM.CounteragentInfo.INN:=edtContragentInn.Text;
  FKKM.CounteragentInfo.Phone:=edtPhone.Text;
  FKKM.CounteragentInfo.Email:=edtEmail.Text;
  FKKM.CheckInfo.Electronically:=CheckBox1.Checked;
(*
  if chPayPlace.Checked then
    FKKM.PaymentPlace:=edtPayPlace.Text
  else
    FKKM.PaymentPlace:='';
*)

  FKKM.OpenCheck;
  if FKKM.ErrorCode <> 0 then
  begin
    ShowMessage(FKKM.ErrorDescription);
    FKKM.Close;
    FKKM.Connected:=false;
    Exit;
  end;

  rxWriteLog(etDebug, 'CheckNumber = ' + IntToStr(FKKM.CheckNumber));

  //Начинаем регистрацию товара к продаже
  rxGoods.First;
  while not rxGoods.EOF do
  begin
    if CheckBox3.Checked then
    begin
      //Укажем данные поставщика
      FKKM.GoodsInfo.SuplierInfo.Name:=edtSuplierName.Text;
      FKKM.GoodsInfo.SuplierInfo.INN:=edtSuplierInn.Text;
      FKKM.GoodsInfo.SuplierInfo.Phone:=edtSuplierPhone.Text;
      FKKM.GoodsInfo.SuplierInfo.Email:=edtSuplierEmail.Text;
    end;


    FKKM.GoodsInfo.Name:=rxGoodsGOODS_NAME.AsString;
    FKKM.GoodsInfo.Price:=rxGoodsPRICE.AsFloat;
    FKKM.GoodsInfo.Quantity:=rxGoodsAMOUNT.AsFloat;
    FKKM.GoodsInfo.TaxType:=TTaxType(rxGoodsTAX_TYPE.AsInteger);

    if (rxGoodsGTD.AsString <> '') and (rxGoodsCOUNTRY_CODE.AsInteger <> 0) then
    begin
      FKKM.GoodsInfo.CountryCode:=rxGoodsCOUNTRY_CODE.AsInteger;
      FKKM.GoodsInfo.DeclarationNumber:=rxGoodsGTD.AsString;
    end;

    FKKM.GoodsInfo.GoodsPayMode:=gpmFullPay;
    FKKM.GoodsInfo.GoodsNomenclatureCode.GroupCode:=rxGoodsMARKS_GROUP.AsInteger;
    FKKM.GoodsInfo.GoodsNomenclatureCode.GTIN:=rxGoodsMARKS_GTIN.AsString;
    FKKM.GoodsInfo.GoodsNomenclatureCode.Serial:=rxGoodsMARKS_SERIAL.AsString;

    FKKM.Registration;
    rxGoods.Next;
  end;

  rxPays.First;
  while not rxPays.EOF do
  begin
    if rxPaysPaySum.AsCurrency > 0 then
      FKKM.RegisterPayment(TPaymentType(rxPaysPayType.AsInteger) , rxPaysPaySum.AsCurrency);
    rxPays.Next;
  end;

  // Закрытие чека
  FKKM.CloseCheck;

  if FKKM.ErrorCode <> 0 then
    ShowMessage(FKKM.ErrorDescription);

  FKKM.Close;
  FKKM.Connected:=false;

  rxGoods.First;
  rxPays.First;
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
begin
  inherited InitData(AKKM);
(*
  ComboBox1.Items.Clear;
  for C:=chtSell to High(TCheckType) do
    ComboBox1.Items.Add(CheckTypeStr(C));
  ComboBox1.ItemIndex:=0; *)
  InitGoodsDataSet;
end;

procedure Tv10TradeFrame.UpdateCtrlState;
begin
  inherited UpdateCtrlState;
//  edtPayPlace.Enabled:=chPayPlace.Checked;

  Label15.Enabled:=CheckBox2.Checked;
  Label16.Enabled:=CheckBox2.Checked;
  Label17.Enabled:=CheckBox2.Checked;
  Label18.Enabled:=CheckBox2.Checked;
  edtContragentName1.Enabled:=CheckBox2.Checked;
  edtContragentInn1.Enabled:=CheckBox2.Checked;
  edtPhone1.Enabled:=CheckBox2.Checked;
  edtEmail1.Enabled:=CheckBox2.Checked;

  Label19.Enabled:=CheckBox3.Checked;
  Label20.Enabled:=CheckBox3.Checked;
  Label21.Enabled:=CheckBox3.Checked;
  Label22.Enabled:=CheckBox3.Checked;
  edtSuplierName.Enabled:=CheckBox3.Checked;
  edtSuplierInn.Enabled:=CheckBox3.Checked;
  edtSuplierPhone.Enabled:=CheckBox3.Checked;
  edtSuplierEmail.Enabled:=CheckBox3.Checked;
end;

end.

