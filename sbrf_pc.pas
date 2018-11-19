{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit sbrf_pc;

{$warn 5023 off : no warning about unused units}
interface

uses
  sbrf_pc_com, sbrf_pc_consts, sbrf_plastic_console, sprfPaySplashUnit, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('sbrf_pc_com', @sbrf_pc_com.Register);
  RegisterUnit('sbrf_plastic_console', @sbrf_plastic_console.Register);
end;

initialization
  RegisterPackage('sbrf_pc', @Register);
end.
