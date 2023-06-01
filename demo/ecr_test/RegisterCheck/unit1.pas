unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, AtollKKMv10,
  CasheRegisterAbstract, DividerBevel;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    DividerBevel1: TDividerBevel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    procedure FAtollKKMv10Error(Sender: TObject);
    function KKMLibraryFileName:string;
  public

  end;

var
  Form1: TForm1 = nil;

procedure MyDefaultWriteLog(ALogType: TEventType; const ALogMessage: string);
implementation
uses rxlogging, LazFileUtils, libfptr10;

procedure MyDefaultWriteLog(ALogType: TEventType; const ALogMessage: string);
begin
  RxDefaultWriteLog(ALogType, ALogMessage);
  if Assigned(Form1) then
    Form1.Memo1.Lines.Add(ALogMessage);
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  FKKM: TAtollKKMv10;
  GI: TGoodsInfo;
begin
  FKKM:=TAtollKKMv10.Create(nil);
  FKKM.FFD1_2:=true;
  FKKM.LibraryFileName:=KKMLibraryFileName;
  FKKM.OnError:=@FAtollKKMv10Error;

  FKKM.Connected:=true;
  FKKM.Open;
//  FKKM.Beep;

  FKKM.BeginCheck;
  FKKM.CheckType:=chtSell;
  FKKM.WaitForMarkingValidationResult:=true;


  GI:=FKKM.GoodsList.Add;
  GI.Name:='Шина магнум1';
  GI.Quantity:=1;
  GI.Price:=10;
  GI.TaxType:=ttaxVat20;
  GI.GoodsMeasurementUnit:=muPIECE;
  GI.GoodsPayMode:=gpmFullPay;
  GI.GoodsNomenclatureCode.KM:='010290001747189421<AT_Wfo)72"(k'#$1D'91EE06'#$1D'92hHbux3iApXaD1GttLHe4sdkOJjV09UEyZtc82Yz6+lc=';

  GI:=FKKM.GoodsList.Add;
  GI.Name:='Шина магнум2';
  GI.Quantity:=1;
  GI.Price:=10;
  GI.TaxType:=ttaxVat20;
  GI.GoodsMeasurementUnit:=muPIECE;
  GI.GoodsPayMode:=gpmFullPay;
  GI.GoodsNomenclatureCode.KM:='0102900017471894211,!MbME=BuQ/s'#$1D'91EE06'#$1D'92Askvf5p+EHyaP2GnQfMMt2rbLGfn4v8e8xtArJuejvU=';

  //if FKKM.ValidateGoodsKM then
  FKKM.ValidateGoodsKM;
  begin
    FKKM.OpenCheck;
    FKKM.RegisterGoods;

    for GI in FKKM.GoodsList do
      RxWriteLog(etDebug, '%s = %d (%s)', [GI.Name, GI.GoodsNomenclatureCode.State, KMStatusEx(GI.GoodsNomenclatureCode.State)]);

    FKKM.CloseCheck;
    //FKKM.CancelCheck;
  end
(*  else
  begin
    RxWriteLog(etError, 'Ошибка проверки кодов маркировки');
  end *);


  FKKM.Close;
  FKKM.Connected:=false;
  FKKM.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Form1:=nil;
  CloseAction:=caFree;
end;

procedure TForm1.FAtollKKMv10Error(Sender: TObject);
var
  FCR: TCashRegisterAbstract;
begin
  FCR:=Sender as TCashRegisterAbstract;
  RxWriteLog(etInfo, '%d - %s', [FCR.ErrorCode, FCR.ErrorDescription]);
end;

function TForm1.KKMLibraryFileName: string;
begin
  {$IFDEF WINDOWS}
  Result:=slibFPPtr10FileName;
  {$ENDIF}
  {$IFDEF LINUX}
  Result:='/home/alexs/install/install/atol/v10/10.9.0.0/10.9.0.0/linux-x64/'+ slibFPPtr10FileName;
  {$ENDIF}
end;

end.

