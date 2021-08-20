unit v10MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Spin, DB, libfptr10, AtollKKMv10, KKM_Atol, CasheRegisterAbstract,
  rxdbgrid, rxmemds, rxcurredit, tv10globalunit, Types;

type

  { TMainForm }

  TMainForm = class(TForm)
    AtollKKM1: TAtollKKM;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    TreeView1: TTreeView;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    OldFrame:TFrame;

    //FAtollInstance: TAtollLibraryV10;
    KKM_Handle:TLibFPtrHandle;

    FAtollKKMv10:TAtollKKMv10;
    procedure WriteLog(S:string);
//    procedure ShowStatus(ACaption:string);
//    procedure InitAtollInstance;
//    procedure DoneAtollInstance;
    procedure FAtollKKMv10Error(Sender: TObject);

//    procedure QueryCheckData;

    procedure InitKassirData;

    function KKMLibraryFileName:string;
    procedure UpdateCtrlState;
    function InternalCheckError:Integer;

    function AddFrame(const ARootNodeName, APageName:string; AFrame:TConfigFrame):TConfigFrame;
  public

  end;

var
  MainForm: TMainForm;

implementation
uses LazFileUtils, Math, rxlogging, v10tradeunit, v10CRPTUnit,
  v10SimpleTestUnit, v10ReportsUnit, v10ServiceUnit, v10OtherUnit,
  v10OrgParamsUnit;

{$R *.lfm}

type
  TCrpCodeBuffer = array [1..32] of byte;

function MakeCRPTCode(APrefix:Word; AGTIN:string; ASerial:string):TCrpCodeBuffer;
var
  B:TCrpCodeBuffer;
  W2: QWord;
  i: Integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  W2:=StrToQWord(AGTIN);
  Move(APrefix, B, 2);
  for i:=1 to 2 do Result[i]:=B[3-i];
  Move(W2, B, 6);
  for i:=1 to 6 do Result[2+i]:=B[7-i];
  for i:=1 to Min(Length(ASerial), 24) do Result[8 + i]:=Ord(ASerial[i]);
end;


{ TMainForm }

procedure TMainForm.FAtollKKMv10Error(Sender: TObject);
var
  FCR: TCashRegisterAbstract;
  S: String;
begin
  FCR:=Sender as TCashRegisterAbstract;
  S:=Format('%d - %s', [FCR.ErrorCode, FCR.ErrorDescription]);
  Memo1.Lines.Add(S);
end;
(*
procedure TMainForm.QueryCheckData;
var
  CheckType, receiptNumber, documentNumber: Integer;
  sum, remainder, change: Double;
begin
  FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_DATA_TYPE, Ord(LIBFPTR_DT_RECEIPT_STATE));
  FAtollInstance.QueryData(KKM_Handle);
  ShowStatus('FAtollInstance.QueryData');

  CheckType:=FAtollInstance.GetParamInt(KKM_Handle, Ord(LIBFPTR_PARAM_RECEIPT_TYPE));
  receiptNumber:=FAtollInstance.GetParamInt(KKM_Handle, Ord(LIBFPTR_PARAM_RECEIPT_NUMBER));
  documentNumber:=FAtollInstance.GetParamInt(KKM_Handle, Ord(LIBFPTR_PARAM_DOCUMENT_NUMBER));
  sum:=FAtollInstance.GetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_RECEIPT_SUM));
  remainder:=FAtollInstance.GetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_REMAINDER));
  change:=FAtollInstance.GetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_CHANGE));

  WriteLog('CheckType = '  + IntToStr(CheckType));
  WriteLog('receiptNumber = ' + IntToStr(receiptNumber));
  WriteLog('documentNumber = ' + IntToStr(documentNumber));
  WriteLog('sum = ' + FloatToStr(sum));
  WriteLog('remainder = ' + FloatToStr(remainder));
  WriteLog('change = ' + FloatToStr(change));
end;
*)
procedure TMainForm.InitKassirData;
begin
//  FAtollKKMv10.Password:='30';
//  FAtollKKMv10.UserName:=Edit3.Text;
//  FAtollKKMv10.KassaUserINN:=Edit4.Text;
end;

function TMainForm.KKMLibraryFileName: string;
begin
  {$IFDEF WINDOWS}
  Result:=slibFPPtr10FileName;
  {$ENDIF}
  {$IFDEF LINUX}
  Result:=AppendPathDelim(ExtractFileDir(ParamStr(0))) + AppendPathDelim('dll-so');
  {$IFDEF cpux86_64}
  Result:=Result + AppendPathDelim('linux-x64');
  {$ENDIF}
  {$IFDEF CPU386}
  Result:=Result + AppendPathDelim('linux-x86');
  {$ENDIF}
  Result:={Result} '/home/alexs/install/install/atol/v10/10.9.0.0/10.9.0.0/linux-x64/'+ slibFPPtr10FileName;
  //Result:={Result} '/home/alexs/install/install/atol/v10/10.8.1.0/linux-x64/'+ slibFPPtr10FileName;
  {$ENDIF}
end;


procedure TMainForm.UpdateCtrlState;
begin
end;

function TMainForm.InternalCheckError: Integer;
var
  S: String;
begin
  Result:=FAtollKKMv10.LibraryAtol.ErrorCode(FAtollKKMv10.Handle);
  if Result <> 0 then
  begin
    S:=Format('Error %d - %s', [Result, FAtollKKMv10.LibraryAtol.ErrorDescription(FAtollKKMv10.Handle)]);
    RxWriteLog(etDebug, S);
    WriteLog(S);
  end;
end;

function TMainForm.AddFrame(const ARootNodeName, APageName: string;
  AFrame: TConfigFrame): TConfigFrame;

function DoGetRootNode(const ARootNodeName:string):TTreeNode;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to TreeView1.Items.Count-1 do
  begin
    if TreeView1.Items[i].Level = 0 then
    begin
      if TreeView1.Items[i].Text = ARootNodeName then
        Exit(TreeView1.Items[i]);
    end;
  end;
  Result:=TreeView1.Items.AddChild(nil, ARootNodeName);
end;

var
  RN, N: TTreeNode;
begin
  RN:=DoGetRootNode(ARootNodeName);
  N:=TreeView1.Items.AddChild(RN, APageName);
  N.Data:=AFrame;
  Result:=AFrame;
  AFrame.Parent:=Panel1;
  AFrame.Align:=alClient;
  AFrame.InitData(FAtollKKMv10);
  RN.Expanded:=true;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
//  DoneAtollInstance;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  C: TCheckType;
  R: TConfigFrame;
begin


  FAtollKKMv10:=TAtollKKMv10.Create(Self);
  FAtollKKMv10.LibraryFileName:=KKMLibraryFileName;
  FAtollKKMv10.OnError:=@FAtollKKMv10Error;
  InitKassirData;

  R:=AddFrame('Отчёты', 'Стандарные', Tv10ReportsFrame.Create(Self));
  R:=AddFrame('Чек', 'Стандарные', Tv10SimpleTestFrame.Create(Self));
  R:=AddFrame('Чек', 'Регистрация чека', Tv10TradeFrame.Create(Self));
  R:=AddFrame('ЦРПТ', 'Взаимодействие с ЦРПТ', Tv10CRPTFrame.Create(Self));
  R:=AddFrame('Сервис', 'Стандарные', Tv10ServiceFrame.Create(Self));
  R:=AddFrame('Прочее', 'Прочее', Tv10OtherFrame.Create(Self));
  R:=AddFrame('Прочее', 'Параметры организации', Tv10OrgParamsFrame.Create(Self));

  UpdateCtrlState;
end;

procedure TMainForm.TreeView1Click(Sender: TObject);
procedure DoSelectFrame(Cfg: TConfigFrame);
begin
  if Assigned(OldFrame) then
    OldFrame.Visible:=false;
  //OldFrame:=Cfg.GetFrame(Self);
  OldFrame:=Cfg;
  OldFrame.BringToFront;
  OldFrame.Visible:=true;
end;

begin
  if Assigned(TreeView1.Selected) then
  begin
    if Assigned(TreeView1.Selected.Data) then
      DoSelectFrame(TConfigFrame(TreeView1.Selected.Data))
    else
    begin
      if (TreeView1.Selected.Count>0) and Assigned(TreeView1.Selected.GetFirstChild.Data) then
        DoSelectFrame(TConfigFrame(TreeView1.Selected.GetFirstChild.Data))
    end;
  end;
end;

procedure TMainForm.WriteLog(S: string);
begin
  Memo1.Lines.Add(S);
  Memo1.CaretPos:=Point(1, Memo1.Lines.Count);
{  if Assigned(FAtollInstance) and FAtollInstance.Loaded then
    FAtollInstance.LogWrite('TEST', 0, S);}
end;
(*
procedure TMainForm.ShowStatus(ACaption: string);
var
  C: Integer;
  S: String;
begin
  if ACaption <> '' then
    WriteLog('----  '+ACaption+'  ----');
  C:=FAtollInstance.ErrorCode(KKM_Handle);
  S:=FAtollInstance.ErrorDescription(KKM_Handle);
  if C<>0 then
  begin
    WriteLog('Code = '+IntToStr(C));
    WriteLog('ErrorDescription = '+S);
  end;
end;

procedure TMainForm.InitAtollInstance;
var
  S: String;
begin
  Memo1.Lines.Clear;
  if not Assigned(FAtollInstance) then
  begin
    FAtollInstance:=TAtollLibraryV10.Create;
    FAtollInstance.LibraryName:=KKMLibraryFileName;
    FAtollInstance.LoadAtollLibrary;
  end;
end;

procedure TMainForm.DoneAtollInstance;
begin
  if Assigned(FAtollInstance) then
    FreeAndNil(FAtollInstance);
end;
*)
end.

