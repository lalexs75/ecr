unit tv10globalunit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, AtollKKMv10;

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

implementation

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

