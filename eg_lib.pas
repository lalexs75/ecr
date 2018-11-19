{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit eg_lib;

{$warn 5023 off : no warning about unused units}
interface

uses
  egate_api, egate_class, egate_consts, egate_lib, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('egate_class', @egate_class.Register);
end;

initialization
  RegisterPackage('eg_lib', @Register);
end.
