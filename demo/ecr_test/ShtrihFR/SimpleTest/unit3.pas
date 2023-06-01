unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  kkm_strih_fr;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    btnShowProps: TButton;
    btnBeep: TButton;
    btnVersion: TButton;
    Button5: TButton;
    Button6: TButton;
    btnInitKKM: TButton;
    btnDoneKKM: TButton;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    procedure btnBeepClick(Sender: TObject);
    procedure btnShowPropsClick(Sender: TObject);
    procedure btnVersionClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnInitKKMClick(Sender: TObject);
    procedure btnDoneKKMClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FKKM:TShtrihFRKKM;
    procedure UpdateStatus;
    procedure UpdateUICtrlState;
    function AssignedKKM:Boolean; inline;
    procedure OutLine(const S:string);
  public

  end;

var
  Form3: TForm3;

implementation
uses rxlogging;

{$R *.lfm}

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
var
  FTnInfo: String;
begin
  RxWriteLog(etInfo, 'Start simple check');
  FTnInfo:=Format('К УПД %d от %s', [123, '01.01.2023']);

  FKKM.BeginCheck;

{
    if quTbDocsys_client_org_type.AsInteger <> 1 then
    begin
      FE.CounteragentInfo.Name:=quTbDocsys_client_name.AsString;
      FE.CounteragentInfo.INN:=quTbDocsys_client_inn.AsString;
      FE.CounteragentInfo.Email:='';
      FE.CheckInfo.Electronically:=false;
    end
    else
    begin }
    FKKM.CounteragentInfo.Clear;
//      FE.CounteragentInfo.Email:=quTbDoctb_doc_check_contact_info.AsString;
//      FE.CheckInfo.Electronically:=FUseElCheck and (quTbDoctb_doc_check_contact_info.AsString<>'') and (not APrintCheck)
//    end;

   //FCT2:=gpmPartialPayAndKredit
//   FCT2:=gpmFullPay;

{
    RxWriteLog(etInfo, 'tb_doc_pay_id=%d, tb_doc_pay_id_97=%d', [quTbDoctb_doc_pay_id.AsInteger, quTbDoctb_doc_pay_id_97.AsInteger]);

    quTbProvV2.ParamByName('tb_doc_id').AsInteger:=ATbDocID;
    if quTbDoctb_doc_pay_id.IsNull then
      quTbProvV2.ParamByName('tb_doc_pay_id').AsInteger:=quTbDoctb_doc_pay_id_97.AsInteger
    else
      quTbProvV2.ParamByName('tb_doc_pay_id').AsInteger:=quTbDoctb_doc_pay_id.AsInteger;
    quTbProvV2.Open;

    while not quTbProvV2.EOF do
    begin
      if quTbProvV2spr_country_use_gtd.AsBoolean then
      begin
        FCodeCountry:=quTbProvV2spr_country_code.AsInteger;
        FGtdNum:=quTbProvV2tb_tobar_gtd_number.AsString;
      end
      else
      begin
        FCodeCountry:=-1;
        FGtdNum:='';
      end;

      FM:=false;
      if (quTbProvV2spr_3_marks_type.AsInteger=2) then
      begin
        FM:=true;
        if quTbDocexists_kredit_check.AsBoolean then FM:=false
        else
        if quTbDoccnt_doc_pay_1_14.AsInteger > 0 then FM:=false;
      end;
{$IFDEF DEBUG_KKM}
  FM:=false;
{$ENDIF}

(*      if ((quTbProvV2spr_3_marks_type.AsInteger=2) and
           ((not quTbDocexists_kredit_check.AsBoolean) or (quTbDocexists_kredit_check.AsBoolean {and quTbDoctb_doc_pay_id.IsNull})) and
           (quTbDoccnt_doc_pay_1_14.AsInteger = 0)) then *)
      if FM then
      begin
        quTbProvMarked.ParamByName('tb_prov_id').AsInteger:=quTbProvV2tb_prov_id.AsInteger;
        quTbProvMarked.Open;

        FSum2:=quTbProvV2tb_prov_summa.AsCurrency / quTbProvMarked.RecordCount;
        while not quTbProvMarked.EOF do
        begin
          GI:=FE.GoodsList.Add;

          if quTbProvMarkedtb_tobar_marking_real_code.AsString<>'' then
            GI.GoodsNomenclatureCode.KM:=RestoreSpecialCharInCIS(quTbProvMarkedtb_tobar_marking_real_code.AsString)
          else
            GI.GoodsNomenclatureCode.KM:=RestoreSpecialCharInCIS(quTbProvMarkedtb_tobar_marking_code.AsString);
          RxWriteLog(etDebug, 'КИЗ - %s', [GI.GoodsNomenclatureCode.KM]);

          GI.Quantity:=1;
          GI.Price:=FSum2;
          GI.Name:=quTbProvV2spr_3_name.AsString;
          GI.GoodsArticle:=FormatKtl3(quTbProvV2);
          case quTbProvV2nds_type.AsInteger of
            1:GI.TaxType:=ttaxVat0;
            2:GI.TaxType:=ttaxVat10;
            3:GI.TaxType:=ttaxVat18;
            4:GI.TaxType:=ttaxVatNO;
            5:GI.TaxType:=ttaxVat20;
            6:GI.TaxType:=ttaxVat120;
            7:GI.TaxType:=ttaxVatNO;
          else
            raise Exception.CreateFmt('Не известный тип НДС (%d)', [quTbProvV2nds_type.AsInteger]);
          end;
          GI.CountryCode:=FCodeCountry;
          GI.DeclarationNumber:=FGtdNum;
          GI.GoodsType:=gtCommodity;
          GI.GoodsMeasurementUnit:=quTbProvV2spr_ed_izm_code_okei.AsInteger;
          GI.GoodsPayMode:=FCT2;
          FSum3:=FSum3 + GI.Quantity *  GI.Price;
(*
          KKM_Register54FZ(ASectionNo, 1, FSum2, 0, quTbProvV2spr_3_name.AsString, quTbProvV2nds_type.AsInteger, 0,
            FCodeCountry, FGtdNum,
            quTbProvV2spr_tnved_code.AsString,
            FCT2,
            S, //quTbProvMarkedtb_tobar_marking_code.AsString,
            gtCommodity,
            quTbProvV2spr_ed_izm_code_okei.AsInteger); *)
          quTbProvMarked.Next;
        end;
        quTbProvMarked.Close;
      end
      else
      begin
        GI:=FE.GoodsList.Add;
        if (quTbDocexists_kredit_check.AsBoolean) or (quTbDoccnt_doc_pay_1_14.AsInteger>0) then
        begin
          FNdsType:=7;
          FCnt2:=1;

          if quTbProvV2.RecNo = quTbProvV2.RecordCount then
          begin
            FSum2:=FSumPayOst;
            FSumPayOst:=0;
          end
          else
          begin
            FSum2:=RoundTo(quTbProvV2tb_prov_summa.AsCurrency * (ACheckSum / quTbDoctb_doc_summa_itog.AsCurrency), -2);
            FSumPayOst:=FSumPayOst - FSum2;
          end;
          GI.GoodsType:=gtPayment;
        end
        else
        begin
          FNdsType:=quTbProvV2nds_type.AsInteger;
          FSum2:=quTbProvV2tb_prov_summa.AsCurrency;
          FCnt2:=quTbProvV2tb_prov_counted.AsFloat;
          GI.GoodsType:=gtCommodity;
        end;

        case FNdsType of
          1:GI.TaxType:=ttaxVat0;
          2:GI.TaxType:=ttaxVat10;
          3:GI.TaxType:=ttaxVat18;
          4:GI.TaxType:=ttaxVatNO;
          5:GI.TaxType:=ttaxVat20;
          6:GI.TaxType:=ttaxVat120;
          7:GI.TaxType:=ttaxVatNO;
        else
          raise Exception.CreateFmt('Не известный тип НДС (%d)', [quTbProvV2nds_type.AsInteger]);
        end;

        GI.Quantity:=FCnt2;
        GI.Price:=RoundTo(FSum2 / FCnt2, -2);
        GI.Name:=quTbProvV2spr_3_name.AsString;
        GI.CountryCode:=FCodeCountry;
        GI.DeclarationNumber:=FGtdNum;
        GI.GoodsMeasurementUnit:=quTbProvV2spr_ed_izm_code_okei.AsInteger;
        GI.GoodsPayMode:=FCT2;
        FSum3:=FSum3 + GI.Quantity *  GI.Price;

(*
        KKM_Register54FZ(ASectionNo, FCnt2, FSum2 / FCnt2, 0, quTbProvV2spr_3_name.AsString, FNdsType, 0,
            FCodeCountry, FGtdNum,
            quTbProvV2spr_tnved_code.AsString,
            FCT2,
            '',
            GT,
            quTbProvV2spr_ed_izm_code_okei.AsInteger);
*)
      end;

      quTbProvV2.Next;
    end;

    PInf:=FE.PaymentsList.Add;
    PInf.PaymentType:=APaymentType;

    if ACheckSum>FSum3 then
      PInf.PaymentSum:=FSum3
    else
      PInf.PaymentSum:=ACheckSum;

    if FSumPayNext <> 0 then
    begin
      PInf:=FE.PaymentsList.Add;
      //PInf.PaymentType:=TPaymentType(FPayTypeKredit); - !!
      PInf.PaymentSum:=FSumPayNext;
    end;

  finally
    quTbProvV2.Close;
    quTbDoc.Close;
  end;

  if FUseCRPT then
    Result:=FE.ValidateGoodsKM
  else
    Result:=true;

  FE.CheckType:=ACheckType;
  FE.OpenCheck;

  if FTnInfo<>'' then
  begin
    KKM_PrintLine('------------------------------------------------');
    KKM_PrintLine(FTnInfo);
  end;

  //InternalPrintClientMemo;
  FE.RegisterGoods;
  FE.RegisterPayments;
}
  FKKM.CloseCheck;
end;

procedure TForm3.btnShowPropsClick(Sender: TObject);
begin
  FKKM.ShowProperties;
  UpdateStatus;
end;

procedure TForm3.btnVersionClick(Sender: TObject);
begin
//  FKKM.Open;
  FKKM.GetVersionString;
//  FKKM.Close;
  UpdateStatus;
end;

procedure TForm3.btnBeepClick(Sender: TObject);
begin
  FKKM.Open;
  FKKM.Beep;
  FKKM.Close;
  UpdateStatus;
end;

procedure TForm3.btnInitKKMClick(Sender: TObject);
begin
  FKKM:=TShtrihFRKKM.Create(Self);//
  UpdateUICtrlState;
end;

procedure TForm3.btnDoneKKMClick(Sender: TObject);
begin
  FreeAndNil(FKKM);
  UpdateUICtrlState;
end;

procedure TForm3.Button6Click(Sender: TObject);
begin
  //
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Clear;
  UpdateUICtrlState;
end;

procedure TForm3.UpdateStatus;
begin

end;

procedure TForm3.UpdateUICtrlState;
begin
  btnInitKKM.Enabled:=not AssignedKKM;
  btnDoneKKM.Enabled:=AssignedKKM;
  btnShowProps.Enabled:=AssignedKKM;
  btnBeep.Enabled:=AssignedKKM;
  btnVersion.Enabled:=AssignedKKM;
end;

function TForm3.AssignedKKM: Boolean; inline;
begin
  Result:=Assigned(FKKM);
end;

procedure TForm3.OutLine(const S: string);
begin
  Memo1.Lines.Add(S);
end;

end.

