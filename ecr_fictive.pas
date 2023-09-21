{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ECR_Fictive;

{$warn 5023 off : no warning about unused units}
interface

uses
  ecr_CashRegisterFictiveUnit, ecr_ShowMemoInfoUnit, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ecr_CashRegisterFictiveUnit', 
    @ecr_CashRegisterFictiveUnit.Register);
end;

initialization
  RegisterPackage('ECR_Fictive', @Register);
end.
