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

unit v10OFDUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  tv10globalunit, CasheRegisterAbstract;

type

  { Tv10OFDFrame }

  Tv10OFDFrame = class(TConfigFrame)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public
    procedure UpdateCtrlState; override;
  end;

implementation

uses libfptr10, rxlogging;

{$R *.lfm}

{ Tv10OFDFrame }

procedure Tv10OFDFrame.Button2Click(Sender: TObject);
begin
  FKKM.Open;
  if FKKM.LibraryAtol.Loaded then
  begin
    // Начать запрос ключей
    FKKM.LibraryAtol.UpdateFnmKeys(FKKM.Handle);
    FKKM.InternalCheckError;
    Label1.Caption:='Успешный запрос ключей';
  end
  else
    Label1.Caption:='Ошибка';
  FKKM.Close;
end;

procedure Tv10OFDFrame.UpdateCtrlState;
begin
  Button1.Enabled:=FKKM.Connected;
  Button2.Enabled:=FKKM.Connected;
end;

procedure Tv10OFDFrame.Button1Click(Sender: TObject);
var
  FStatus: TOFDSTatusRecord;
begin
  FKKM.Open;
  if FKKM.LibraryAtol.Loaded then
  begin
    // Начать запрос информации по обемену с ОФД
    FKKM.GetOFDStatus(FStatus);
    Label2.Caption:=Label2.Caption + LineEnding +
      Format('ExchangeStatus =%d, UnsentCount = %d, FirstUnsentNumber = %d, OfdMessageRead = %d, LastSendDate=%s',
      [FStatus.ExchangeStatus, FStatus.UnsentCount, FStatus.FirstUnsentNumber, Ord(FStatus.OfdMessageRead), DateToStr(FStatus.LastSendDocDate)]);
  end
  else
    Label2.Caption:='Ошибка';
  FKKM.Close;
end;

end.

