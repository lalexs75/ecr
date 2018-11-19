//Пример демонстрирует регистрацию продажи товара
var
  C:Currency;
begin
  //Входим в режим регистрации
  ECRDriver.SetMode(1);
  //Тип чепка - продажи
  ECRDriver.CheckType:=1;
  //Откроем чек
  ECRDriver.OpenCheck;

  C:=0;
  //Регистрируем первую позицию
  ECRDriver.PrintLine('Мороженное');
  ECRDriver.Price:=12.1;
  C:=C + ECRDriver.Price;
  ECRDriver.Quantity:=2;
  ECRDriver.Department:=1;
  ECRDriver.Registration;

  //Регистрируем вторую позицию
  ECRDriver.PrintLine('Пироженное');
  ECRDriver.Price:=10.50;
  C:=C + ECRDriver.Price;
  ECRDriver.Quantity:=2;
  ECRDriver.Department:=1;
  ECRDriver.Registration;

  //Регистрируем 3-ю позицию
  ECRDriver.PrintLine('Мармелад');
  ECRDriver.Price:=21.5;
  C:=C + ECRDriver.Price;
  ECRDriver.Quantity:=2;
  ECRDriver.Department:=1;
  ECRDriver.Registration;

  //Укажем общую сумму покупки
  ECRDriver.Summ:=C;
  //Закроем чек
  ECRDriver.CloseCheck;
  //Вернёмся в режим выбора
  ECRDriver.ResetMode;
end