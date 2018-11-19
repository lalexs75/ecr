//Данный пример демонстрируем установку режима, печать Z отчёта и диагностику сообщения об ошибке
begin
  ECRDriver.SetMode(3);
  ECRDriver.ReportZ;
  if ECRDriver.ErrorCode <> 0 then
    MessageDlg('Ошибка','Ошибка печати Z отчёта', mtError, [mbOK], 0);
end