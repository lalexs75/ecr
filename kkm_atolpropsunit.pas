{ Билиотека для работы с ККМ АТОЛ

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

unit KKM_AtolPropsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, KKM_Atol, ButtonPanel;

type

  { TkkmAtolPropsForm }

  TkkmAtolPropsForm = class(TForm)
    Button1: TButton;
    ButtonPanel1: TButtonPanel;
    cbPortList: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    rgPortSpeed: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadPortList;
  public
    ECR:TAtollKKM;
  end;

var
  kkmAtolPropsForm: TkkmAtolPropsForm;

implementation
uses synaser, strutils;

{$R *.lfm}

{ TkkmAtolPropsForm }

procedure TkkmAtolPropsForm.FormCreate(Sender: TObject);
begin
  LoadPortList;
end;

procedure TkkmAtolPropsForm.Button1Click(Sender: TObject);
var
  FPort:string;
  FSpeed:integer;
begin
  if Assigned(ECR) then
  begin
    FPort:=ECR.PortName;
    FSpeed:=ECR.PortSpeed;
    try
      ECR.PortName:=cbPortList.Text;
      ECR.PortSpeed:=rgPortSpeed.ItemIndex;
      ECR.Beep;
    except
      on E:Exception do
        ShowMessageFmt('Ошибка - %s.', [E.Message]);
    end;
    if ECR.ErrorCode<>0 then
      ShowMessageFmt('Ошибка %d (%s).', [ECR.ErrorCode, ECR.ErrorCodeStr]);
    ECR.PortName:=FPort;
    ECR.PortSpeed:=FSpeed;
  end;
end;

procedure TkkmAtolPropsForm.LoadPortList;
var
  S:string;
begin
  S:=GetSerialPortNames;
  cbPortList.Items.Clear;
  while Pos(',', S)>0 do
    cbPortList.Items.Add(Copy2SymbDel(S, ','));
  if S<>'' then
    cbPortList.Items.Add(S);
end;

end.

