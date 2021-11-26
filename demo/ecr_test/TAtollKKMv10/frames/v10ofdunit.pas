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
  tv10globalunit;

type

  { Tv10OFDFrame }

  Tv10OFDFrame = class(TConfigFrame)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

implementation

{$R *.lfm}

{ Tv10OFDFrame }

procedure Tv10OFDFrame.Button2Click(Sender: TObject);
begin
  FKKM.Open;
  if FKKM.LibraryAtol.Loaded then
  begin
    // Начать проверку связи с сервером ИСМ
    FKKM.LibraryAtol.UpdateFnmKeys(FKKM.Handle);
    FKKM.InternalCheckError;
//    Label27.Caption:=Format('Error code : %d, Error msg : %s', [EC, errorDescription]);
     Label1.Caption:='Успешный запрос ключей';
  end
  else
    Label1.Caption:='Ошибка';
  FKKM.Close;
end;

end.

