{**************************************************************************}
{ Библиотека работы с платёжными терминалами пластиковых карт              }
{ в стандарте, предоставляемым ГазПромБанком                               }
{ Free Pascal Compiler версии 2.7.1 и Lazarus 1.2 и выше.                  }
{ Лагунов Алексей (С) 2014  alexs75.at.yandex.ru                           }
{**************************************************************************}

{! Функции для работы с Mifare картами не реализованы !}
unit egate_lib;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, egate_api;

type
  TEGateException = class(Exception)
  private
    //FStatus: CS_RETCODE;
  public
    //constructor Create(AMsg:string; AStatus:CS_RETCODE);
    //property Status:CS_RETCODE read FStatus;
  end;

  TEGateLoadException = class(TEGateException)

  end;

type
  TEGLibStatusRec = record
    TerminalID:string; //1. 8 - Идентификатор терминала
    MerchantID:string; //2. 15 - Идентификатор точки обслуживания
    ECRNumber:string;  //3. …3 - Номер ККМ
    ECRReceiptNumber:string; //4. 10 - Номер чека ККМ
    PAN:string;              //5. 19 - Номер карты (Primary Account number)
    CardExpiryDate:string;   //6. 4 - Срок действия карты в формате MMYY
    TransactionAmount:string; //7. 12 - Сумма транзакции
    TranFee:string; //8. 12 - Скидка
    Total:string; //9. 12 - Итоговая сумма
    Date:string;  //10. 4 - Дата проведения транзакции в формате DDMM
    Time:string;  //11. 4 - Время проведения транзакции в формате HHMM
    InvoiceNumber:string; //12. 6 - Номер чека транзакции
    IssuerName:string;    //13. 8 - Имя эмитента карты
    Curr:string; //14. 3 - Валюта
    ResponseCode:string; //15. …3 - Код ответа от хоста, показывающий статус транзакции.
    VisualResponseCode:string; //16. …40 - Отображаемый код ответа (используется для вывода на экран и печати на чеке)
    AuthorizationID:string; //17. 6 - Код авторизации (назначается хостом, когда транзакция одобрена)
    RRN:string;             //18. 12 - Retrieval Reference Number
    ApplicationID:string;   //19. 16 - Идентификатор приложения чиповой карты.
    TC:string;              //20. 16 - Transaction Certificate (для EMV-приложений)
    AppLab:string;          //21. …32 - Метка приложения для чиповой карты.
    DDMMYY:string;          //22. 6
    hhmmss:string;          //23. 6
    ResCodGcs:string;       //24. 3 - Код ответа в формате GCS.
    VResCodGcs:string;      //25. …3 - Отображаемый код ответа
    AuthResult:string;      //26. 2 - Результат авторизации
    VisHostRes:string;      //27. …40 - Текстовая интерпретация кода ответа хоста.
    ApproveRes:string;      //28. - Признак одобрена транзакция “Y” или не одобрена “N”
    FlagsRes:string;        //29. Байт 0
                            //      Биты:
                            //      0 – последовательное чтение журнала
                            //      1:6 – зарезервированы для будущих применений
                            //      7 – должен быть установлен
                            //    Байты 1-2 зарезервированы для будущих применений. По умолчанию для них должно использоваться значение 0x80.
                            //      1. FlagsRes = "\x80\x80\x80" - без ввода пина
                            //      2. FlagsRes = "\x80\x80\x81" - c вводом оффлайн  пина  (на чеке пишется "ВВЕДЕН ОФФЛАЙН ПИН")
                            //      3. FlagsRes = "\x80\x80\x82" - c вводом онлайн  пина  (на чеке пишется "ВВЕДЕН ОНЛАЙН ПИН")
    Stan:string;            //30. 6 - System Trace Audit Number – уникальный идентификатор операции
    DtTmLocalTrans:string;  //31. 12 - Локальное время выполнения операции в формате ГГMMDDччммсс
    ReqId:string;           //32. 2 - Уникальный идентификатор операции
    Cryptogram:string; //33. 64 - В режиме HRS терминал возвращает 64 символа криптограммы в ASCII формате
  end;

type
  {$IFDEF MSWINDOWS}
  TDLLHandle = THandle;
  {$ELSE}
  TDLLHandle = Pointer;
  {$ENDIF}

type

  { TEGateLibrary }

  TEGateLibrary = class
  private
    //Указатель на библиотеку
    FlibEGate: TDLLHandle;
    //Функции из библиотеки
    FegGetVersion:TegGetVersion;
    FegGetVersionDescription:TegGetVersionDescription;
    FegGetLastError:TegGetLastError;
    FegGetErrorDescription:TegGetErrorDescription;
    FegDlgGetRecNumber:TegDlgGetRecNumber;
    FegInitInstance:TegInitInstance;
    FegReleaseInstance:TegReleaseInstance;
    FegAuthRequest : TegAuthRequest;
    FegAuthRequestAsync : TegAuthRequestAsync;
    FegGetAuthReceipt : TegGetAuthReceipt;
    FegGetAuthResult : TegGetAuthResult;
    FegGetOpStatus : TegGetOpStatus;
  private
    FCfgFileName: string;
    FLibName: string;
    procedure LoadEGate;
    procedure ClearEGate;
    procedure SetCfgFileName(AValue: string);
  public
    constructor Create(ACfgFileName:string);
    destructor Destroy; override;
    function Loaded: Boolean;
    function Unload: Boolean; virtual;
    function Load(const ALibName: string = libEGateName): Boolean;
    property LibName:string read FLibName;
  public
    //Вспомогательные функции API
    function egGetVersion:integer; //Получение идентификатора текущей версии библиотеки
    function egGetVersionDescription:string; //Получение текстового представления  текущей версии библиотеки
    function egGetLastError(AIdInst:integer):integer; //Получение кода последней системной ошибки выполнения функций данного модуля.
    function egGetErrorDescription(nErrCode:integer):string; //Получение текстового описания системной ошибки по ее коду, полученному функцией egGetLastError.
    function egDlgGetRecNumber:string; //Получение номера документа с использованием диалогового окна.
    //Основные функции API
    function egInitInstance:Integer; //Функция инициализации экземпляра библиотеки.
    function egReleaseInstance(AIdInst:integer):Boolean; //Освобождение ресурсов данного экземпляра библиотеки.
    function egAuthRequest(AIdInst:integer; nProtId:Integer; pRequest:string):string; //Запуск на выполнение обработчика авторизационного запроса в синхронном режиме.
    function egAuthRequestAsync(AIdInst:integer; nProtId:Integer; pRequest:string):string; //Запуск на выполнение обработчика авторизационного запроса в асинхронном режиме.
    function egGetAuthReceipt(AIdInst:integer):string;                 //Функция получения форматизированного набора данных, подготовленного для печати чека.
    function egGetAuthResult(AIdInst:integer):string;                  //Функция получения форматированной строки, содержащей результаты авторизации.
    function egGetOpStatus(AIdInst:integer; bIsCansel:Boolean):string;//Функция получения статуса выполнения текущего авторизационного запроса.
    //
//    property nIdInst : Integer read FnIdInst; //уникальный идентификатор сеанса работы модуля авторизации
    property CfgFileName:string read FCfgFileName write SetCfgFileName;
  end;

var
  EGateLibrary:TEGateLibrary = nil;

type
  TLogLoadProc = procedure(const AMsg:string);

const
  LogLoadProc : TLogLoadProc = nil;

procedure InitLibrary;
procedure EgWriteLog(const AMsg:string); inline;
procedure EgWriteLogEx(const AMsg:string; Args:array of const); inline;
procedure DecodeEGLibStatusRec(AStatus:string;var Rec:TEGLibStatusRec);
implementation
uses
{$IFNDEF WINDOWS}
  dl,
{$ELSE}
  windows,
{$ENDIF}
  egate_consts, strutils;

procedure EgWriteLog(const AMsg:string); inline;
begin
  if Assigned(LogLoadProc) then
    LogLoadProc(AMsg);
end;

procedure EgWriteLogEx(const AMsg:string; Args:array of const); inline;
begin
  EgWriteLog(Format(AMsg, Args));
end;

procedure DecodeEGLibStatusRec(AStatus: string; var Rec: TEGLibStatusRec);
begin
  // '00600366,700000,002,0006,548999******0005,1512,110,0,110,2612,1318,4,Mastercard,643,0,0,416649,002506416649,a0000000041010,140158128,MasterCard,261214,131915,000,OK,,,,\x80\x80\x81,,,1,,'
  Rec.TerminalID:=Copy2SymbDel(AStatus, ',');  //1. 8 - Идентификатор терминала
  Rec.MerchantID:=Copy2SymbDel(AStatus, ',');  //2. 15 - Идентификатор точки обслуживания
  Rec.ECRNumber:=Copy2SymbDel(AStatus, ',');  //3. …3 - Номер ККМ
  Rec.ECRReceiptNumber:=Copy2SymbDel(AStatus, ',');  //4. 10 - Номер чека ККМ
  Rec.PAN:=Copy2SymbDel(AStatus, ',');  //5. 19 - Номер карты (Primary Account number)
  Rec.CardExpiryDate:=Copy2SymbDel(AStatus, ',');  //6. 4 - Срок действия карты в формате MMYY
  Rec.TransactionAmount:=Copy2SymbDel(AStatus, ',');  //7. 12 - Сумма транзакции
  Rec.TranFee:=Copy2SymbDel(AStatus, ',');  //8. 12 - Скидка
  Rec.Total:=Copy2SymbDel(AStatus, ',');  //9. 12 - Итоговая сумма
  Rec.Date:=Copy2SymbDel(AStatus, ',');  //10. 4 - Дата проведения транзакции в формате DDMM
  Rec.Time:=Copy2SymbDel(AStatus, ',');  //11. 4 - Время проведения транзакции в формате HHMM
  Rec.InvoiceNumber:=Copy2SymbDel(AStatus, ',');  //12. 6 - Номер чека транзакции
  Rec.IssuerName:=Copy2SymbDel(AStatus, ',');  //13. 8 - Имя эмитента карты
  Rec.Curr:=Copy2SymbDel(AStatus, ',');  //14. 3 - Валюта
  Rec.ResponseCode:=Copy2SymbDel(AStatus, ',');  //15. …3 - Код ответа от хоста, показывающий статус транзакции.
  Rec.VisualResponseCode:=Copy2SymbDel(AStatus, ',');  //16. …40 - Отображаемый код ответа (используется для вывода на экран и печати на чеке)
  Rec.AuthorizationID:=Copy2SymbDel(AStatus, ',');  //17. 6 - Код авторизации (назначается хостом, когда транзакция одобрена)
  Rec.RRN:=Copy2SymbDel(AStatus, ',');  //18. 12 - Retrieval Reference Number
  Rec.ApplicationID:=Copy2SymbDel(AStatus, ',');  //19. 16 - Идентификатор приложения чиповой карты.
  Rec.TC:=Copy2SymbDel(AStatus, ',');  //20. 16 - Transaction Certificate (для EMV-приложений)
  Rec.AppLab:=Copy2SymbDel(AStatus, ',');  //21. …32 - Метка приложения для чиповой карты.
  Rec.DDMMYY:=Copy2SymbDel(AStatus, ',');  //22. 6
  Rec.hhmmss:=Copy2SymbDel(AStatus, ',');  //23. 6
  Rec.ResCodGcs:=Copy2SymbDel(AStatus, ',');  //24. 3 - Код ответа в формате GCS.
  Rec.VResCodGcs:=Copy2SymbDel(AStatus, ',');  //25. …3 - Отображаемый код ответа
  Rec.AuthResult:=Copy2SymbDel(AStatus, ',');  //26. 2 - Результат авторизации
  Rec.VisHostRes:=Copy2SymbDel(AStatus, ',');  //27. …40 - Текстовая интерпретация кода ответа хоста.
  Rec.ApproveRes:=Copy2SymbDel(AStatus, ',');  //28. - Признак одобрена транзакция “Y” или не одобрена “N”
  Rec.FlagsRes:=Copy2SymbDel(AStatus, ',');  //29. Байт
  Rec.Stan:=Copy2SymbDel(AStatus, ',');  //30. 6 - System Trace Audit Number – уникальный идентификатор операции
  Rec.DtTmLocalTrans:=Copy2SymbDel(AStatus, ',');  //31. 12 - Локальное время выполнения операции в формате ГГMMDDччммсс
  Rec.ReqId:=Copy2SymbDel(AStatus, ',');  //32. 2 - Уникальный идентификатор операции
  Rec.Cryptogram:=Copy2SymbDel(AStatus, ',');  //33. 64 - В режиме HRS терминал возвращает 64 символа криптограммы в ASCII формате
end;

function InternalGetProcAddress(Lib: TDLLHandle; Name: PAnsiChar): Pointer;
begin
  Result:=nil;
  {$IFDEF UNIX}
  if Assigned(Lib) then
    Result := dlsym(Lib, Name);
  {$ELSE}
  if Lib <> 0 then
    Result := GetProcAddress(Lib, Name);
  {$ENDIF UNIX}

  if Assigned(Result) then
    EgWriteLogEx(sEGate_load_lib_successfully, [Name])
  else
    EgWriteLogEx(sEGate_load_lib_filed, [Name])
end;

procedure InitLibrary;
begin
  if not Assigned(EGateLibrary) then
    EGateLibrary:=TEGateLibrary.Create('');
end;

{ TEGateLibrary }

procedure TEGateLibrary.LoadEGate;
begin
  Pointer(FegGetVersion):=InternalGetProcAddress(FlibEGate, 'egGetVersion');
  Pointer(FegGetVersionDescription):=InternalGetProcAddress(FlibEGate, 'egGetVersionDescription');
  Pointer(FegGetLastError):=InternalGetProcAddress(FlibEGate, 'egGetLastError');
  Pointer(FegGetErrorDescription):=InternalGetProcAddress(FlibEGate, 'egGetErrorDescription');
  Pointer(FegDlgGetRecNumber):=InternalGetProcAddress(FlibEGate, 'egDlgGetRecNumber');
  Pointer(FegInitInstance):=InternalGetProcAddress(FlibEGate, 'egInitInstance');
  Pointer(FegReleaseInstance):=InternalGetProcAddress(FlibEGate, 'egReleaseInstance');
  Pointer(FegAuthRequest):=InternalGetProcAddress(FlibEGate, 'egAuthRequest');
  Pointer(FegAuthRequestAsync):=InternalGetProcAddress(FlibEGate, 'egAuthRequestAsync');
  Pointer(FegGetAuthReceipt):=InternalGetProcAddress(FlibEGate, 'egGetAuthReceipt');
  Pointer(FegGetAuthResult):=InternalGetProcAddress(FlibEGate, 'egGetAuthResult');
  Pointer(FegGetOpStatus):=InternalGetProcAddress(FlibEGate, 'egGetOpStatus');

  //check loaded
  if not Assigned(FegGetVersion) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egGetVersion']);
  if not Assigned(FegGetVersion) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egGetVersionDescription']);
  if not Assigned(FegGetLastError) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egGetLastError']);
  if not Assigned(FegGetErrorDescription) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egGetErrorDescription']);
  if not Assigned(FegDlgGetRecNumber) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egDlgGetRecNumber']);
  if not Assigned(FegInitInstance) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egInitInstance']);
  if not Assigned(FegReleaseInstance) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egReleaseInstance']);
  if not Assigned(FegAuthRequest) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egAuthRequest']);
  if not Assigned(FegAuthRequestAsync) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egAuthRequestAsync']);
  if not Assigned(FegGetAuthReceipt) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egGetAuthReceipt']);
  if not Assigned(FegGetAuthResult) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egGetAuthResult']);
  if not Assigned(FegGetOpStatus) then
     raise TEGateLoadException.CreateFmt(sEGate_load_proc_filed, [FLibName, 'egGetOpStatus']);
end;

procedure TEGateLibrary.ClearEGate;
begin
  FegGetVersion:=nil;
  FegGetVersionDescription:=nil;
  FegGetLastError:=nil;
  FegGetErrorDescription:=nil;
  FegDlgGetRecNumber:=nil;
  FegAuthRequest :=nil;
  FegAuthRequestAsync :=nil;
  FegGetAuthReceipt:=nil;
  FegGetAuthResult:=nil;
  FegGetOpStatus:=nil;
end;

procedure TEGateLibrary.SetCfgFileName(AValue: string);
begin
  if FCfgFileName=AValue then Exit;
  FCfgFileName:=AValue;
end;

constructor TEGateLibrary.Create(ACfgFileName: string);
begin
  inherited Create;
  FCfgFileName:=ACfgFileName;
end;

destructor TEGateLibrary.Destroy;
begin
  if Loaded then
    Unload;
  inherited Destroy;
end;

function TEGateLibrary.Loaded: Boolean;
begin
  {$IFNDEF WINDOWS}
  Result:=Assigned(FlibEGate);
  {$ELSE}
  Result:=FlibEGate <> 0;
  {$ENDIF}
end;

function TEGateLibrary.Unload: Boolean;
begin
  if not Loaded then exit;
  {$IFNDEF WINDOWS}
  Result := dlclose(FlibEGate) = 0;
  FlibEGate:=nil;
  {$ELSE}
  Result := Boolean(FreeLibrary(FlibEGate));
  FlibEGate := 0;
  {$ENDIF}
  ClearEGate;
end;

function TEGateLibrary.Load(const ALibName: string): Boolean;
var
  S:string;
  SP:PChar;
begin
  {$IFNDEF WINDOWS}
  FlibEGate:=dlopen(PChar(ALibName), RTLD_GLOBAL or RTLD_LAZY);
  {$ELSE}
  FlibEGate:=LoadLibrary(PChar(ALibName));
  {$ENDIF}
  Result:=Loaded;
  if Result then
    LoadEGate
  else
  begin
    {$IFNDEF WINDOWS}
      SP:=dlerror();
      if Assigned(SP) then
      begin
        SetLength(S, strlen(SP));
        Move(SP^, S[1], strlen(SP));
      end;
    {$ELSE}
      S:='';
    {$ENDIF}
    raise TEGateLoadException.CreateFmt(sEGate_load_lib_filed, [ALibName, S]);
  end;
  FLibName:=ALibName;
end;

function TEGateLibrary.egGetVersion: integer;
begin
  Result:=FegGetVersion();
end;

function TEGateLibrary.egGetVersionDescription: string;
var
  P:TemvChar;
begin
  P:=FegGetVersionDescription();
  SetLength(Result, strlen(P));
  Move(P^, Result[1], strlen(P));
  Result:=Cp1251ToUTF8(Result);
end;

function TEGateLibrary.egGetLastError(AIdInst: integer): integer;
begin
  Result:=FegGetLastError(AIdInst);
end;

function TEGateLibrary.egGetErrorDescription(nErrCode: integer): string;
var
  P:TemvChar;
  S:string;
begin
  P:=FegGetErrorDescription(nErrCode);
{  SetLength(Result, strlen(P));
  Move(P^, Result[1], strlen(P));}
  SetLength(S, strlen(P));
  Move(P^, S[1], strlen(P));
  Result:=Cp1251ToUTF8(S);
end;

function TEGateLibrary.egDlgGetRecNumber: string;
var
  P:TemvChar;
begin
  P:=FegDlgGetRecNumber();
  SetLength(Result, strlen(P));
  Move(P^, Result[1], strlen(P));
  Result:=Cp1251ToUTF8(Result);
end;

function TEGateLibrary.egInitInstance: Integer;
var
  S: String;
begin
  S:=UTF8ToCp1251(FCfgFileName);
  Result:=FegInitInstance(PChar(S));
end;

function TEGateLibrary.egReleaseInstance(AIdInst: integer): Boolean;
begin
  Result:=FegReleaseInstance(AIdInst);
end;

function TEGateLibrary.egAuthRequest(AIdInst: integer; nProtId: Integer;
  pRequest: string): string;
var
  S: String;
  P: PChar;
begin
  S:=UTF8ToCp1251(pRequest);
  P:=FegAuthRequest( AIdInst, nProtId, PChar(S));
  SetLength(Result, strlen(P));
  Move(P^, Result[1], strlen(P));
  Result:=Cp1251ToUTF8(Result);
end;

function TEGateLibrary.egAuthRequestAsync(AIdInst: integer; nProtId: Integer;
  pRequest: string): string;
var
  S: String;
  P: PChar;
begin
  S:=UTF8ToCp1251(pRequest);
  P:=FegAuthRequestAsync( AIdInst, nProtId, PChar(S));
  SetLength(Result, strlen(P));
  Move(P^, Result[1], strlen(P));
end;

function TEGateLibrary.egGetAuthReceipt(AIdInst: integer): string;
var
  P: PChar;
begin
  P:=FegGetAuthReceipt( AIdInst);
  SetLength(Result, strlen(P));
  Move(P^, Result[1], strlen(P));
  Result:=Cp1251ToUTF8(Result);
end;

function TEGateLibrary.egGetAuthResult(AIdInst: integer): string;
var
  P: PChar;
begin
  P:=FegGetAuthResult( AIdInst);
  SetLength(Result, strlen(P));
  Move(P^, Result[1], strlen(P));
  Result:=Cp1251ToUTF8(Result);
end;

function TEGateLibrary.egGetOpStatus(AIdInst: integer; bIsCansel: Boolean
  ): string;
var
  P: PChar;
begin
  P:=FegGetOpStatus( AIdInst, bIsCansel);
  SetLength(Result, strlen(P));
  Move(P^, Result[1], strlen(P));
  Result:=Cp1251ToUTF8(Result);
end;

finalization
  if Assigned(EGateLibrary) then
    FreeAndNil(EGateLibrary);
end.

