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

unit tv10globalunit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, libfptr10, AtollKKMv10;

type

  { TConfigFrame }

  TConfigFrame = class(TFrame)
  private
  protected
    FKKM:TAtollKKMv10;
  public
    procedure InitData(AKKM:TAtollKKMv10); virtual;
    procedure UpdateCtrlState; virtual;
  end;

function IndToItemUnits(AIndex:Integer):Tlibfptr_item_units;
function IndToKMStatus(AIndex:Integer):Tlibfptr_marking_estimated_status;
implementation

function IndToItemUnits(AIndex: Integer): Tlibfptr_item_units;
begin
  case AIndex of
    0:Result:=LIBFPTR_IU_PIECE;
    10:Result:=LIBFPTR_IU_GRAM;
    11:Result:=LIBFPTR_IU_KILOGRAM;
    12:Result:=LIBFPTR_IU_TON;
    20:Result:=LIBFPTR_IU_CENTIMETER;
    21:Result:=LIBFPTR_IU_DECIMETER;
    22:Result:=LIBFPTR_IU_METER;
    30:Result:=LIBFPTR_IU_SQUARE_CENTIMETER;
    31:Result:=LIBFPTR_IU_SQUARE_DECIMETER;
    32:Result:=LIBFPTR_IU_SQUARE_METER;
    40:Result:=LIBFPTR_IU_MILLILITER;
    41:Result:=LIBFPTR_IU_LITER;
    42:Result:=LIBFPTR_IU_CUBIC_METER;
    50:Result:=LIBFPTR_IU_KILOWATT_HOUR;
    51:Result:=LIBFPTR_IU_GKAL;
    52:Result:=LIBFPTR_IU_DAY;
    53:Result:=LIBFPTR_IU_HOUR;
    54:Result:=LIBFPTR_IU_MINUTE;
    55:Result:=LIBFPTR_IU_SECOND;
    80:Result:=LIBFPTR_IU_KILOBYTE;
    81:Result:=LIBFPTR_IU_MEGABYTE;
    82:Result:=LIBFPTR_IU_GIGABYTE;
    83:Result:=LIBFPTR_IU_TERABYTE;
  else
    Result:=LIBFPTR_IU_OTHER;
  end;

end;

function IndToKMStatus(AIndex: Integer): Tlibfptr_marking_estimated_status;
begin
  case AIndex of
    0:Result:=LIBFPTR_MES_PIECE_SOLD;
    1:Result:=LIBFPTR_MES_DRY_FOR_SALE;
    2:Result:=LIBFPTR_MES_PIECE_RETURN;
    3:Result:=LIBFPTR_MES_DRY_RETURN;
  else
    Result:=LIBFPTR_MES_UNCHANGED;
  end;
end;

{$R *.lfm}

{ TConfigFrame }

procedure TConfigFrame.InitData(AKKM: TAtollKKMv10);
begin
  FKKM:=AKKM;
end;

procedure TConfigFrame.UpdateCtrlState;
begin

end;

end.

