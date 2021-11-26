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
    Button1: TButton;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    OldFrame:TFrame;

    KKM_Handle:TLibFPtrHandle;

    FAtollKKMv10:TAtollKKMv10;
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

procedure DoDefaultWriteLog( ALogType:TEventType; const ALogMessage:string);
implementation
uses LazFileUtils, Math, rxlogging, v10tradeunit, v10CRPTUnit,
  v10SimpleTestUnit, v10ReportsUnit, v10ServiceUnit, v10OtherUnit,
  v10OrgParamsUnit, v10MarkingUnit, v10RegisterCheckFFD1_2Unit,
  v10RegisterCheckCmpUnit, v10OFDUnit;

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

procedure DoDefaultWriteLog(ALogType: TEventType; const ALogMessage: string);
begin
  RxDefaultWriteLog( ALogType, ALogMessage);
  if Assigned(MainForm) then
  begin
    MainForm.Memo1.Lines.Add(ALogMessage);
    MainForm.Memo1.CaretPos:=Point(1, MainForm.Memo1.Lines.Count);
  end;
end;


{ TMainForm }

procedure TMainForm.FAtollKKMv10Error(Sender: TObject);
var
  FCR: TCashRegisterAbstract;
begin
  FCR:=Sender as TCashRegisterAbstract;
  RxWriteLog(etInfo, '%d - %s', [FCR.ErrorCode, FCR.ErrorDescription]);
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
var
  N: TTreeNode;
begin
  for N in TreeView1.Items do
  begin
    if Assigned(N.Data) then
      TConfigFrame(N.Data).UpdateCtrlState;
  end;
end;

function TMainForm.InternalCheckError: Integer;
var
  S: String;
begin
  Result:=FAtollKKMv10.LibraryAtol.ErrorCode(FAtollKKMv10.Handle);
  if Result <> 0 then
    RxWriteLog(etDebug, 'Error %d - %s', [Result, FAtollKKMv10.LibraryAtol.ErrorDescription(FAtollKKMv10.Handle)]);
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

procedure TMainForm.FormCreate(Sender: TObject);
var
  R: TConfigFrame;
begin
  Memo1.Lines.Clear;

  FAtollKKMv10:=TAtollKKMv10.Create(Self);
  FAtollKKMv10.LibraryFileName:=KKMLibraryFileName;
  FAtollKKMv10.OnError:=@FAtollKKMv10Error;
  InitKassirData;

  R:=AddFrame('Отчёты', 'Стандарные', Tv10ReportsFrame.Create(Self));

  R:=AddFrame('Чек', 'Стандарные', Tv10SimpleTestFrame.Create(Self));
  R:=AddFrame('Чек', 'Регистрация чека', Tv10TradeFrame.Create(Self));
  R:=AddFrame('Чек', 'Маркировка', Tv10MarkingFrame.Create(Self));
  R:=AddFrame('Чек', 'Регистрация позиции с маркировкой ФФД 1.2', Tv10RegisterCheckFFD1_2Frame.Create(Self));

  R:=AddFrame('Взаимодействие с внешними системами', 'ОФД', Tv10OFDFrame.Create(Self));
  R:=AddFrame('Взаимодействие с внешними системами', 'ЦРПТ', Tv10CRPTFrame.Create(Self));
  R:=AddFrame('Сервис', 'Стандарные', Tv10ServiceFrame.Create(Self));
  R:=AddFrame('Прочее', 'Прочее', Tv10OtherFrame.Create(Self));
  R:=AddFrame('Прочее', 'Параметры организации', Tv10OrgParamsFrame.Create(Self));

  R:=AddFrame('Компонента', 'Регистрация чека', Tv10RegisterCheckCmpFrame.Create(Self));

  UpdateCtrlState;
end;

procedure TMainForm.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    FAtollKKMv10.FFD1_2:=true;
    FAtollKKMv10.Connected:=true;
    FAtollKKMv10.Open;
  end
  else
  begin
    FAtollKKMv10.Close;
    FAtollKKMv10.Connected:=true;
  end;

  UpdateCtrlState;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  FAtollKKMv10.ShowProperties;
end;

procedure TMainForm.TreeView1Click(Sender: TObject);
procedure DoSelectFrame(Cfg: TConfigFrame);
begin
  if Assigned(OldFrame) then
    OldFrame.Visible:=false;
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

end.

