//Функция отображает значение регистров
//Переменная AtolCheckTypeNames объявлена в модуле KKM_Atol
procedure DoPrintRegister(AMsg: string; AChekTypes: TCheckTypes);
var
  i:byte;
begin
  for i:=1 to 6 do
    if i in AChekTypes then
    begin
      ECRDriver.CheckType:=i;
      ECRDriver.GetRegister;
      Memo1.Lines.Add(Format('%s - (%d - %s) = %m', [AMsg, i, AtolCheckTypeNames[i], ECRDriver.Summ]));
    end;
end;


//Данный пример демонстрируем установку номера регистра и последующую печать 
//Значения регистров сумм регистрации по типам чеков
begin
  ECRDriver.RegisterNumber:=1;
  DoPrintRegister('1 -  Сумма регистраций', [1..6]);
end