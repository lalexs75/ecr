{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit atol_ecr;

{$warn 5023 off : no warning about unused units}
interface

uses
  KKM_AtolPropsUnit, KKM_Atol, AtollKKMv10, libfptr10, Atollv10_JSON, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('KKM_Atol', @KKM_Atol.Register);
  RegisterUnit('AtollKKMv10', @AtollKKMv10.Register);
  RegisterUnit('Atollv10_JSON', @Atollv10_JSON.Register);
end;

initialization
  RegisterPackage('atol_ecr', @Register);
end.
