unit v10ServiceUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, rxcurredit,
  tv10globalunit;

type

  { Tv10ServiceFrame }

  Tv10ServiceFrame = class(TConfigFrame)
    Button11: TButton;
    Button12: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button20: TButton;
    Button22: TButton;
    Button26: TButton;
    Button7: TButton;
    Button9: TButton;
    CurrencyEdit1: TCurrencyEdit;
    CurrencyEdit2: TCurrencyEdit;
    Label12: TLabel;
    Label13: TLabel;
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private

  public
    procedure UpdateCtrlState; override;
  end;

implementation
uses rxlogging, libfptr10, CasheRegisterAbstract;

{$R *.lfm}

{ Tv10ServiceFrame }

procedure Tv10ServiceFrame.Button7Click(Sender: TObject);
begin
  FKKM.Connected:=true;
  FKKM.ShowProperties;
  FKKM.Connected:=false;
end;

procedure Tv10ServiceFrame.Button9Click(Sender: TObject);
var
  CT: TCheckType;
begin
  CT:=FKKM.CheckType;
  rxWriteLog(etDebug, 'Тип чека - ' + CheckTypeStr(CT));
end;

procedure Tv10ServiceFrame.UpdateCtrlState;
begin
  inherited UpdateCtrlState;
  Button26.Enabled:=FKKM.Connected;
  Button11.Enabled:=FKKM.Connected;
  Button17.Enabled:=FKKM.Connected;
  Button20.Enabled:=FKKM.Connected;
  Button14.Enabled:=FKKM.Connected;
  Button9.Enabled:=FKKM.Connected;
end;

procedure Tv10ServiceFrame.Button11Click(Sender: TObject);
begin
  FKKM.Beep;
end;

procedure Tv10ServiceFrame.Button12Click(Sender: TObject);
begin
  FKKM.Connected:=true;
  FKKM.Open;
  FKKM.CutCheck(false);
  FKKM.Close;
  FKKM.Connected:=false;
end;

procedure Tv10ServiceFrame.Button14Click(Sender: TObject);
begin
  FKKM.OpenShift;
end;

procedure Tv10ServiceFrame.Button15Click(Sender: TObject);
begin
  FKKM.Connected:=true;
  FKKM.Open;
  FKKM.CashIncome(CurrencyEdit1.Value);
  FKKM.Close;
  FKKM.Connected:=false;
end;

procedure Tv10ServiceFrame.Button16Click(Sender: TObject);
begin
  FKKM.Connected:=true;
  FKKM.Open;
  FKKM.CashOutcome(CurrencyEdit2.Value);
  FKKM.Close;
  FKKM.Connected:=false;
end;

procedure Tv10ServiceFrame.Button17Click(Sender: TObject);
begin
  FKKM.CancelCheck;
end;

procedure Tv10ServiceFrame.Button20Click(Sender: TObject);
begin
  FKKM.PrintClishe;
end;

procedure Tv10ServiceFrame.Button22Click(Sender: TObject);
begin
  FKKM.Connected:=true;
  FKKM.Open;
  FKKM.QueryDeviceParams;
  rxWriteLog(etDebug, 'LineLength = '+ IntToStr(FKKM.DeviceInfo.PaperInfo.LineLength));
  rxWriteLog(etDebug, 'LineLengthPix = '+ IntToStr(FKKM.DeviceInfo.PaperInfo.LineLengthPix));
  FKKM.Close;
  FKKM.Connected:=false;
end;

procedure Tv10ServiceFrame.Button26Click(Sender: TObject);
var
  versionKKT, minFfdVersion, maxFfdVersion, ffdVersion,
    deviceFfdVersion, fnFfdVersion, maxFnFfdVersion: Integer;
begin
  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_FN_DATA_TYPE, Ord(LIBFPTR_FNDT_FFD_VERSIONS));
  FKKM.LibraryAtol.fnQueryData(FKKM.Handle);

  deviceFfdVersion := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_DEVICE_FFD_VERSION));
  fnFfdVersion     := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_FN_FFD_VERSION));
  maxFnFfdVersion  := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_FN_MAX_FFD_VERSION));
  ffdVersion       := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_FFD_VERSION));
  maxFfdVersion    := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_DEVICE_MAX_FFD_VERSION));
  minFfdVersion    := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_DEVICE_MIN_FFD_VERSION));
  versionKKT       := FKKM.LibraryAtol.getParamInt(FKKM.Handle, Ord(LIBFPTR_PARAM_VERSION));

  rxWriteLog(etDebug, 'deviceFfdVersion = %d', [deviceFfdVersion]);
  rxWriteLog(etDebug, 'fnFfdVersion     = %d', [fnFfdVersion]);
  rxWriteLog(etDebug, 'maxFnFfdVersion  = %d', [maxFnFfdVersion]);
  rxWriteLog(etDebug, 'ffdVersion       = %d', [ffdVersion]);
  rxWriteLog(etDebug, 'maxFfdVersion    = %d', [maxFfdVersion]);
  rxWriteLog(etDebug, 'minFfdVersion    = %d', [minFfdVersion]);
  rxWriteLog(etDebug, 'versionKKT       = %d', [versionKKT]);

  FKKM.LibraryAtol.SetParamInt(FKKM.Handle, LIBFPTR_PARAM_FN_DATA_TYPE, Ord(LIBFPTR_FNDT_REG_INFO));
  FKKM.LibraryAtol.fnQueryData(FKKM.Handle);
  ffdVersion     :=FKKM.LibraryAtol.GetParamInt(FKKM.Handle, 1209);//    Результат 110, Т.е. ФФД 1.1
  rxWriteLog(etDebug, 'ffdVersion       = %d', [ffdVersion]);
end;

end.

