{**************************************************************************}
{ Библиотека работы с платёжными терминалами пластиковых карт              }
{ в стандарте, предоставляемым Сбербанком                                  }
{ Free Pascal Compiler версии 3.1.1 и Lazarus 1.9 и выше.                  }
{ Лагунов Алексей (С) 2017  alexs75.at.yandex.ru                           }
{**************************************************************************}
unit sbrf_plastic_console;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTF8Process, alexs_plastic_cards_abstract, Forms;

const
  {$IFDEF LINUX}
  sCommandName = 'sb_pilot';
  sSlipFile = 'p';
  sErrorFile = 'e';
  outSystemCP = 20866;   //KOI-8
  {$ELSE}
  {$IFDEF WINDOWS}
  sCommandName = 'upwin.exe';
  sSlipFile = 'p';
  sErrorFile = 'e';
  outSystemCP = 866; //DOS (OEM)
  {$ELSE}
  sCommandName = '';
  sSlipFile = '';
  sErrorFile = '';
  outSystemCP = 0;
  {$ENDIF}
  {$ENDIF}
type

  { TSBPlasticCardConsole }

  TSBPlasticCardConsole = class(TPlasticCardAbstract)
  private
    FStatusInfo: TStringList;
    FStatusVector:string;

    FErrorFile: string;
    FSlipFile: string;
    FSplashForm:TForm;
    FCmdProcess : TProcessUTF8;
    FCmdLine:string;
    //FCommandName: string;
    FShowSplashWindow: boolean;
    //function IsCommandNameStored: Boolean;
    function IsErrorFileStored: Boolean;
    function IsSlipFileStored: Boolean;
    procedure MakeCommand(ACmd:string);
    procedure LoadSlipFile;
    procedure LoadStatusFile;
    function GetIntFileName(AFileName:string):string;
    procedure AddToStatusVector(AName, AValue:string);
  protected
    procedure Clear; override;
    function GetStatusVector: string; override;
    procedure InitProcess;
    procedure DoRun;
    procedure DoneProcess;
    procedure ProcessStatusVector;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Pay(APaySum:Currency; ACheckNum:integer; APayTypeMethod:Integer); override;      //Оплата
    procedure ReportItog;override;                                     //Z отчёт
    procedure EchoTest;override;                                       //Проверка
    procedure Revert(ARevertSum:Currency; ACheckNum:string; APayTypeMethod:Integer); override; //Возврат
    procedure Discard(ADiscardSum:Currency; ACheckNum:string; ADocID:string; APayTypeMethod:Integer); override; //Отмена
    procedure ReportOperList; override;
    procedure ReportOperSmall; override;
    procedure PPLoadConfig; override;
    procedure PPLoadSoftware; override;

    procedure GetWorkKey; override;
  published
    //property CommandName:string read FCommandName write FCommandName stored IsCommandNameStored;
    property ShowSplashWindow:boolean read FShowSplashWindow write FShowSplashWindow default false;
    property SlipFile:string read FSlipFile write FSlipFile stored IsSlipFileStored;
    property ErrorFile:string read FErrorFile write FErrorFile stored IsErrorFileStored;
  end;

procedure Register;

implementation
uses LazFileUtils, process, strutils, sprfPaySplashUnit;

procedure Register;
begin
  RegisterComponents('TradeEquipment',[TSBPlasticCardConsole]);
end;

{ TSBPlasticCardConsole }
(*
function TSBPlasticCardConsole.IsCommandNameStored: Boolean;
begin
  Result:=FCommandName <> sCommandName;
end;
*)
function TSBPlasticCardConsole.IsErrorFileStored: Boolean;
begin
  Result:=FErrorFile <> sErrorFile;
end;

function TSBPlasticCardConsole.IsSlipFileStored: Boolean;
begin
  Result:=FSlipFile <> sSlipFile;
end;

procedure TSBPlasticCardConsole.MakeCommand(ACmd: string);
begin
  //FCmdProcess.Parameters.Add(ACmd);
  FCmdLine:=ACmd;
end;

procedure TSBPlasticCardConsole.LoadSlipFile;
var
  F:TextFile;
  S: String;
begin
  S:=GetIntFileName(FSlipFile);
  if FileExistsUTF8(S) then
  begin
    AssignFile(F,S);
    TextRec(F).CodePage:=outSystemCP;
    Reset(F);
    while not Eof(F) do
    begin
      ReadLn(F, S);
      FSlipInfo:=FSlipInfo + LineEnding + S;
    end;
    CloseFile(F);
  end;
end;

procedure TSBPlasticCardConsole.LoadStatusFile;
var
  F:TextFile;
  S: String;
begin
  S:=GetIntFileName(FErrorFile);
  if FileExistsUTF8(S) then
  begin
    AssignFile(F,S);
    TextRec(F).CodePage:=outSystemCP;
    Reset(F);
    while not Eof(F) do
    begin
      ReadLn(F, S);
      FStatusInfo.Add(S);
    end;
    CloseFile(F);
  end;
end;

function TSBPlasticCardConsole.GetIntFileName(AFileName: string): string;
var
  S: String;
begin
  Result:='';
  if ExtractFileDir(AFileName) = '' then
  begin
    S:=ExtractFileDir(LibFileName);
//    S:=ExtractFileDir(FCommandName);
    if S<>'' then
      Result:=AppendPathDelim(S);
    Result:=Result + AFileName;
  end
  else
    Result:=AFileName;
end;

procedure TSBPlasticCardConsole.AddToStatusVector(AName, AValue: string);
begin
  if FStatusVector<>'' then
    FStatusVector:=FStatusVector + ';';
  FStatusVector:=FStatusVector + AName+':'+AValue;
end;

procedure TSBPlasticCardConsole.Clear;
begin
  inherited Clear;
  FCmdLine:='';
  FStatusInfo.Clear;
  FStatusVector:='';
end;

function TSBPlasticCardConsole.GetStatusVector: string;
begin
  Result:=FStatusVector;
end;

procedure TSBPlasticCardConsole.InitProcess;
begin
  if FShowSplashWindow then
  begin
    FSplashForm:=TsprfPaySplashForm.Create(Application);
    FSplashForm.Show;
    FSplashForm.Invalidate;
    Application.ProcessMessages;
  end;
end;

procedure TSBPlasticCardConsole.DoRun;
var
  F:TextFile;
  S: String;
  R: Integer;
  L: Int64;
begin
  FCmdProcess.Parameters.Clear;
  //S1:=ExtractFileDir(FCommandName);
  //FCmdProcess.CurrentDirectory:= ExtractFileDir(FCommandName);
  //FCmdProcess.CommandLine:=FCommandName + ' ' + FCmdLine;
  FCmdProcess.CurrentDirectory:= ExtractFileDir(LibFileName);
  FCmdProcess.CommandLine:=LibFileName + ' ' + FCmdLine;
//  FCmdProcess.Parameters.Add(FCmdLine);
  FCmdProcess.Options:=FCmdProcess.Options + [poUsePipes, poWaitOnExit];
  FCmdProcess.Execute;
  R:=FCmdProcess.ExitCode;
  L:=FCmdProcess.Output.NumBytesAvailable;
  if L > 0 then
  begin
    //FCmdProcess.Output.Position:=0;
    SetLength(S, L);
    FCmdProcess.Output.ReadBuffer(S[1], L);
  end;
  //
  LoadStatusFile;
  LoadSlipFile;
  ProcessStatusVector;
  DoOnStatus;
end;

procedure TSBPlasticCardConsole.DoneProcess;
begin
  if Assigned(FSplashForm) then
    FreeAndNil(FSplashForm);
end;

procedure TSBPlasticCardConsole.ProcessStatusVector;
var
  S, S1: String;
begin
  if FStatusInfo.Count>0 then
  begin
    S:=FStatusInfo[0];
    S1:=Copy2SymbDel(S, ',');
    FErrorCode:=StrToIntDef(S1, -1);
    FErrorMessage:=S;
    if (FStatusInfo.Count>1) and (FStatusInfo[1]<>'') then
      AddToStatusVector('НомерКарты', FStatusInfo[1]);

    if (FStatusInfo.Count>2) and (FStatusInfo[2]<>'') then
      AddToStatusVector('ДействуетДо', FStatusInfo[2]);

    if (FStatusInfo.Count>3) and (FStatusInfo[3]<>'') then
      AddToStatusVector('КодАвторизации', FStatusInfo[3]);

    if (FStatusInfo.Count>4) and (FStatusInfo[4]<>'') then
      AddToStatusVector('ВнутреннийНомерОперации', FStatusInfo[4]);

    if (FStatusInfo.Count>5) and (FStatusInfo[5]<>'') then
      AddToStatusVector('ТипКарты', FStatusInfo[5]);

    if (FStatusInfo.Count>6) and (FStatusInfo[6]<>'') then
      AddToStatusVector('КартаСбербанк', FStatusInfo[6]);

    if (FStatusInfo.Count>7) and (FStatusInfo[7]<>'') then
      AddToStatusVector('НомерТерминала', FStatusInfo[7]);

    if (FStatusInfo.Count>8) and (FStatusInfo[8]<>'') then
      AddToStatusVector('ДатаВремяОперации', FStatusInfo[8]);

    if (FStatusInfo.Count>9) and (FStatusInfo[9]<>'') then
      AddToStatusVector('СсылочныйНомерРперации', FStatusInfo[9]);

    if (FStatusInfo.Count>10) and (FStatusInfo[10]<>'') then
      AddToStatusVector('ХешНомераКарты', FStatusInfo[10]);

    if (FStatusInfo.Count>11) and (FStatusInfo[11]<>'') then
      AddToStatusVector('Трек3Карты', FStatusInfo[11]);

    if (FStatusInfo.Count>12) and (FStatusInfo[12]<>'') then //Сумма, оплаченная бонусами «Спасибо», коп
      AddToStatusVector('СуммаСпасибо', FStatusInfo[12]);

    if (FStatusInfo.Count>13) and (FStatusInfo[13]<>'') then
      AddToStatusVector('НомерМерчанта', FStatusInfo[13]);
(*
    15
    00
    Тип сообщения система мониторинга. 0 – обычное, 1 срочное
    16
    00
    Состояние ГПЦ. 0 - работает, 1-возможны сбои, 2-не работает.
    17
    Процессинг Cбербанка работает нормально
    Сообщение системы мониторинга. Если сообщение содержит символы переноса строк, они будут заменены символом '|'
    18
    3
    Номер программы лояльности в который попадает карта. Если программы не настроены на терминале, или карта ни под одну из программ лояльности, возвращается 0
    19
    +1231234567
    или
    sberbank@sberbank.ru
    Ответ пользователя на команду 49
*)
    if (FStatusInfo.Count>19) and (FStatusInfo[19]<>'') then
      AddToStatusVector('УникальныйИдентификаторОперации', FStatusInfo[19]);
  end
  else
    FErrorCode:=-1;
end;

constructor TSBPlasticCardConsole.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //FCommandName:=sCommandName;
  LibFileName:=sCommandName;
  FSlipFile:=sSlipFile;
  FErrorFile:=sErrorFile;
  FStatusInfo:=TStringList.Create;

  FShowSplashWindow:=false;
  FCmdProcess := TProcessUTF8.Create(Self);
end;

destructor TSBPlasticCardConsole.Destroy;
begin
  FreeAndNil(FStatusInfo);
  FreeAndNil(FCmdProcess);
  inherited Destroy;
end;

procedure TSBPlasticCardConsole.Pay(APaySum: Currency; ACheckNum: integer;
  APayTypeMethod: Integer);
var
  R: Int64;
begin
  Clear;
  R:=trunc(APaySum  * 100);
  MakeCommand(Format('1 %d', [R]));
  InitProcess;
  DoRun;
  DoneProcess;
end;

procedure TSBPlasticCardConsole.ReportItog;
begin
  Clear;
  InitProcess;
  MakeCommand('7');
  DoRun;
  DoneProcess;
end;

procedure TSBPlasticCardConsole.EchoTest;
begin
  Clear;
  InitProcess;
  MakeCommand('36');
  DoRun;
  DoneProcess;
end;

procedure TSBPlasticCardConsole.Revert(ARevertSum: Currency; ACheckNum: string;
  APayTypeMethod: Integer);
var
  R: Int64;
begin
  Clear;
  InitProcess;
  R:=trunc(ARevertSum  * 100);
  MakeCommand(Format('3 %d', [R]));
  DoRun;
  DoneProcess;
end;

procedure TSBPlasticCardConsole.Discard(ADiscardSum: Currency;
  ACheckNum: string; ADocID: string; APayTypeMethod: Integer);
var
  R: Int64;
begin
  Clear;
  InitProcess;
  R:=trunc(ADiscardSum  * 100);
  MakeCommand(Format('8 %d', [R]));
  DoRun;
  DoneProcess;
end;

procedure TSBPlasticCardConsole.ReportOperList;
begin
  Clear;
  InitProcess;
  MakeCommand('9 1');
  DoRun;
  DoneProcess;
end;

procedure TSBPlasticCardConsole.ReportOperSmall;
begin
  Clear;
  InitProcess;
  MakeCommand('9 0');
  DoRun;
  DoneProcess;
end;

procedure TSBPlasticCardConsole.PPLoadConfig;
begin
  Clear;
end;

procedure TSBPlasticCardConsole.PPLoadSoftware;
begin
  Clear;
  InitProcess;
  MakeCommand('21');
  DoRun;
  DoneProcess;
end;

procedure TSBPlasticCardConsole.GetWorkKey;
begin
  Clear;
end;

initialization
  RegisterPlasticCardType(TSBPlasticCardConsole, 'Сберегательный банк РФ - внешний запуск');
end.
