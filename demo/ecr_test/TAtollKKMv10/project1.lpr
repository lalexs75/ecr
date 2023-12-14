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

program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  rxlogging,
  lazcontrols,
  ssl_openssl3,
  ssl_openssl3_lib, ecr_fictive,

  v10MainUnit,
  tv10globalunit,
  v10systemparamsunit,
  v10tradeunit,
  v10CRPTUnit,
  v10SimpleTestUnit,
  v10ReportsUnit,
  v10ServiceUnit,
  v10OtherUnit,
  v10OrgParamsUnit,
  v10MarkingUnit,
  v10RegisterCheckFFD1_2Unit,
  v10RegisterCheckCmpUnit,
  v10OFDUnit,
  clocale;

{$R *.res}

begin
  OnRxLoggerEvent:=@DoDefaultWriteLog;
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

