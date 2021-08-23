program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  rxlogging,

  v10MainUnit,
  tv10globalunit,
  v10systemparamsunit,
  v10tradeunit,
  v10CRPTUnit,
  v10SimpleTestUnit,
  v10ReportsUnit,
  v10ServiceUnit,
  v10OtherUnit,
  v10OrgParamsUnit, v10MarkingUnit, v10RegisterCheckFFD1_2Unit, 
v10RegisterCheckCmpUnit;

{$R *.res}

begin
  OnRxLoggerEvent:=@DoDefaultWriteLog;
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

