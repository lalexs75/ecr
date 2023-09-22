{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit alexs_trade_abstract;

{$warn 5023 off : no warning about unused units}
interface

uses
  alexs_plastic_cards_abstract, PlasticCardFictive, CasheRegisterAbstract, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('PlasticCardFictive', @PlasticCardFictive.Register);
end;

initialization
  RegisterPackage('alexs_trade_abstract', @Register);
end.
