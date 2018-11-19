{**************************************************************************}
{ Библиотека работы с платёжными терминалами пластиковых карт              }
{ в стандарте, предоставляемым ГазПромБанком                               }
{ Free Pascal Compiler версии 2.7.1 и Lazarus 1.2 и выше.                  }
{ Лагунов Алексей (С) 2014  alexs75.at.yandex.ru                           }
{**************************************************************************}

unit egate_consts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

resourcestring
  sEGate_load_lib_filed  = 'Failed to load library %s - %s';
  sEGate_load_lib_successfully = 'Library %s is successfully loaded';
  sEGate_load_proc_filed = 'Failed to load function %s from library %s';

  sEGate_Error  = 'Error : %d : %s';
  sEGate_Answer = 'Answer : "%s"';
  sEGateInactive  = 'Error operation on inactive EGate component';

implementation

end.

