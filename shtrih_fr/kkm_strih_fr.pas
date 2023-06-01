{ Билиотека для работы с ККМ ЩТРИХ-ФР

  Copyright (C) 2013-2023 Лагунов Алексей alexs75@yandex.ru

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}


unit kkm_strih_fr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, CasheRegisterAbstract;

type
  EShtrihFR = class(ECashRegisterAbstract);

  { TShtrihFRKKM }

  TShtrihFRKKM = class(TCashRegisterAbstract)
  private
    FShtrihFR: OleVariant;  //Устройство ККМ ШТРИХ-ФР
  protected
    procedure InternalUserLogin; override;
    procedure InternalOpenKKM; override;
    procedure InternalCloseKKM; override;

    function GetDeviceDateTime: TDateTime; override;
    procedure InternalGetDeviceInfo(var ALineLength, ALineLengthPix: integer); override;
    function GetConnected: boolean; override;
    procedure SetConnected(AValue: boolean); override;

    function GetCheckNumber: integer; override;
    function GetFDNumber: integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetVersionString:string; override;
    procedure GetOFDStatus(out AStatus:TOFDSTatusRecord); override;
    procedure Beep; override;
    function InternalCheckError:Integer; override;
    function ShowProperties:boolean; override;      //Отобразить окно параметров ККМ

    procedure ReportX(AReportType: Byte); override;     //X-отчет
    procedure ReportZ; override;
    procedure PrintReportHours; override;               //Отчет по часам
    procedure PrintReportSection; override;             //Отчет по секциям
    procedure PrintReportCounted; override;             //Отчет количеств
    procedure DemoPrint; override;                      //Демо-печать

  end;

implementation
  {$IFDEF WINDOWS}
uses
  ComObj, ActiveX;
  {$ENDIF}

{ TShtrihFRKKM }

procedure TShtrihFRKKM.InternalUserLogin;
begin

end;

procedure TShtrihFRKKM.InternalOpenKKM;
begin
  FShtrihFR.Connect();
  InternalCheckError;
end;

procedure TShtrihFRKKM.InternalCloseKKM;
begin
  FShtrihFR.Disconnect();
  InternalCheckError;
end;

function TShtrihFRKKM.GetDeviceDateTime: TDateTime;
begin

end;

procedure TShtrihFRKKM.InternalGetDeviceInfo(var ALineLength,
  ALineLengthPix: integer);
begin
  inherited InternalGetDeviceInfo(ALineLength, ALineLengthPix);
end;

function TShtrihFRKKM.GetConnected: boolean;
begin
  FShtrihFR.CheckConnection()
end;

procedure TShtrihFRKKM.SetConnected(AValue: boolean);
begin

end;

function TShtrihFRKKM.GetCheckNumber: integer;
begin

end;

function TShtrihFRKKM.GetFDNumber: integer;
begin

end;

constructor TShtrihFRKKM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF WINDOWS}
  FShtrihFR := CreateOleObject('AddIn.DrvFR');
  {$ELSE}
  FShtrihFR:=null;
  {$ENDIF}
end;

destructor TShtrihFRKKM.Destroy;
begin
  FShtrihFR:=null;
  inherited Destroy;
end;

function TShtrihFRKKM.GetVersionString: string;
begin
  Result:=FShtrihFR.DriverVersion;
  InternalCheckError;
end;

procedure TShtrihFRKKM.GetOFDStatus(out AStatus: TOFDSTatusRecord);
begin
  inherited GetOFDStatus(AStatus);
end;

procedure TShtrihFRKKM.Beep;
begin
  InternalCheckError;
end;

function TShtrihFRKKM.InternalCheckError: Integer;
begin
  Result:=FShtrihFR.ResultCode;
  if Result <> 0 then
    SetError(Result, FShtrihFR.ResultCodeDescription)
  else
    ClearError;
end;

function TShtrihFRKKM.ShowProperties: boolean;
begin
  FShtrihFR.ShowProperties();
  InternalCheckError;
end;

procedure TShtrihFRKKM.ReportX(AReportType: Byte);
begin

end;

procedure TShtrihFRKKM.ReportZ;
begin
  FShtrihFR.Password:=Password;
  FShtrihFR.PrintReportWithCleaning();
  InternalCheckError;
end;

procedure TShtrihFRKKM.PrintReportHours;
begin

end;

procedure TShtrihFRKKM.PrintReportSection;
begin

end;

procedure TShtrihFRKKM.PrintReportCounted;
begin

end;

procedure TShtrihFRKKM.DemoPrint;
begin

end;

end.

