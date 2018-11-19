{**************************************************************************}
{ Библиотека работы с платёжными терминалами пластиковых карт              }
{ в стандарте, предоставляемым Сбербанком                                  }
{ Free Pascal Compiler версии 3.1.1 и Lazarus 1.9 и выше.                  }
{ Лагунов Алексей (С) 2017  alexs75.at.yandex.ru                           }
{**************************************************************************}
unit sprfPaySplashUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TsprfPaySplashForm }

  TsprfPaySplashForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
  private

  public

  end;

var
  sprfPaySplashForm: TsprfPaySplashForm;

implementation

{$R *.lfm}

end.

