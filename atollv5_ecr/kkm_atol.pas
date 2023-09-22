{ Билиотека для работы с ККМ АТОЛ

  Copyright (C) 2013-2023 Лагунов Алексей alexs75@yandex.ru

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

{******************************************************************************}
{Данный модуль содержит драйвер для работы со следующими типами оборудования:  }
{• Триум-Ф эталонной версии 01, в дальнейшем – Триум-Ф;                        }
{• ФЕЛИКС-Р Ф эталонная версия 02, в дальнейшем – ФЕЛИКС-Р Ф;                  }
{• ФЕЛИКС-02К эталонная версия 01, в дальнейшем – ФЕЛИКС-02К;                  }
{• «Меркурий-140Ф» АТОЛ;                                                       }
{• ТОРНАДО (МЕРКУРИЙ-114.1Ф эталонная версия 04), в дальнейшем – ТОРНАДО;      }
{• Меркурий MS-K эталонная версия 02 – в дальнейшем Меркурий MS-K;             }
{• ФЕЛИКС-Р К эталонной версии 01 – в дальнейшем ФЕЛИКС-Р К;                   }
{• ФЕЛИКС-3СК эталонная версия 01 – в дальнейшем ФЕЛИКС-3СК;                   }
{• FPrint-02K эталонная версия 02 – в дальнейшем FPrint-02K;                   }
{• FPrint-03K эталонная версия 01 – в дальнейшем FPrint-03K;                   }
{• FPrint-88K;                                                                 }
{• FPrint-5200K эталонная версия 01 – в дальнейшем FPrint-5200K;               }
{• PayVKP-80K;                                                                 }
{• PayPPU-700K;                                                                }
{• PayCTS-2000K;                                                               }
{• FPrint-55K;                                                                 }
{• FPrint-22K;                                                                 }
{• FPrint-11ПТК                                                                }
{******************************************************************************}
unit KKM_Atol;

{$mode objfpc}{$H+}
{$DEFINE DEBUG_KKM_DRV}
{.$DEFINE DEBUG_KKM_DRV_READ}
{.$DEFINE DEBUG_KKM_DRV_SYS_MSG}

interface

uses
  Classes, SysUtils, synaser, CasheRegisterAbstract;

const
  tsdReadData = 2000;

  tsdSendACK  = 500;
  tsdSendENQ  = 500;
  //
  tsdReadENQ  = 10000;
  tsdReadEOT  = 10000;

const
  sENQ = #$05; //Запрос
  sACK = #$06; //Подтверждение
  sSTX = #$02; //Начало текста
  sETX = #$03; //Конец текста
  sEOT = #$04; //Конец передачи
  sNAK = #$15; //Отрицание
  sDLE = #$10; //Экранирование управляющих символов

type
  TKKMLocale = (lcCP866_RU, lcCP866_KZ);

type
  TDeviseType = record
    ProtocolVersion:integer;
    ProtocolType:integer;
    KKMModel:integer;
    Mode:integer;
    KKMName:string;
  end;

  TDeviseState = record
    KssNumber:byte;    //<Кассир(1)>
    NumberInHall:byte; //<Номер_в_зале(1)>
    KKMDate:TDateTime; //<Дата_YMD(3)>
    KKMTime:TDateTime; //<Время_HMS(3)>
    Flags:byte;        //<Флаги(1)>
    FabNumber:DWord;   //<Заводской_номер(4)>
    Model:byte;        //<Модель(1)>
    Version:string;   //<Версия_ПО_ККТ(2)>
    Mode:byte;         //<Режим_работы(1)>
    CheckNum:integer;  //<Номер_чека(2)>
    NumSmena:integer;  //<Номер_смены(2)>
    CheckState:byte;   //<Состояние_чека(1)>
    CheckSum:Currency; //<Сумма_чека(5)>
    DecimalSep:byte;   //<Десятичная_точка(1)>
    Port:byte;         //<Порт(1)>
  end;

type

  { TAtollKKM }

  TAtollKKM = class(TCashRegisterAbstract)
  private
    FBufArray:Array [1..1000] of byte;
    FCommandBuf:Array [1..1000] of byte;
    FCurPos:Integer;
    FCommandBufLen:Integer;
    procedure ClearBufArray;
    procedure ValueToBuf(Value:DWord; Digits:integer);
    procedure ByteToBuf(Value:byte);
    procedure MakeCommandBuf;
    procedure SendCommandBuf;
  private
    FAccessPassword: integer;
    FBatteryLow: boolean;
    FBufferPDEmpty: boolean;
    FBufferPDFull: boolean;
    FCaption: string;
    FCheckNumber: integer;
    FCheckState: integer;
    FCheckType: Byte;
    FCount: integer;
    FCoverOpened: boolean;
    FPrinterCutMechanismError: boolean;
    FDepartment: integer;
    FPrinterOverheatError: boolean;
    FECRDateTime: TDateTime;
    FKKMConected: boolean;
    FLocale:TKKMLocale;
    //FName: string;
    FOutOfPaper: boolean;
    FPaperError: boolean;
    FMaxLineWidth:byte;
    FDeviseState: TDeviseState;
    FDeviseType: TDeviseType;
    FPrice: Currency;
    FPrintPurpose: byte;
    FQuantity: Double;
    FRegisterNumber: byte;
    FSerialNumber: string;
    FSerialPort:TBlockSerial;
    FErrorCode:integer;
    FErrorCodeStr:string;
    FMode:Byte;
    FPortName:string;
    FPortSpeed:integer;
    FSessionOpened: boolean;
    FSubMode: byte;
    FSumm: Currency;
    FTestMode: boolean;
    FTypeClose: integer;
    function GetCheckSum: Currency;
    procedure SetAccessPassword(AValue: integer);
    procedure SetCaption(AValue: string);
    procedure SetCheckType(AValue: Byte);
    procedure SetCount(AValue: integer);
    procedure SetDepartment(AValue: integer);
    procedure SetErrorCode(AErrorCode:integer);
    function MakeCommand(AData:RawByteString):RawByteString;
    procedure DumpCmd(S:RawByteString);

    procedure InitKKM;
    procedure DoneKKM;
    procedure SendENQ;
    procedure SendEOT;
    procedure ReadEOT;
    procedure SendACK;
    procedure ReadACK;
    procedure ReadENQ(ATimeOut:integer = tsdReadENQ);
    procedure InternalGetStatus(AHeader:boolean);
    procedure InternalSetMode(AMode:byte);

    function LoadKKMData:RawByteString;
    function LoadKKMData1:TBytes;
    //procedure SetName(AValue: string);
    procedure SetPortName(AValue: string);
    procedure SetPortSpeed(AValue: integer);
    procedure SetPrice(AValue: Currency);
    procedure SetPrintPurpose(AValue: byte);
    procedure SetQuantity(AValue: Double);
    procedure SetRegisterNumber(AValue: byte);
    procedure SetTestMode(AValue: boolean);
    procedure SetTypeClose(AValue: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadParams(ParList:TStrings);
    procedure StoreParams(ParList:TStrings);

    procedure Beep; override;
    procedure CutCheck(APartial:boolean);  override;
    procedure PrintLine(ALine:string); override;           //Печать строки
    procedure PrintClishe; override;
    procedure ReadModel;
    procedure DemoPrint; override;

    //Отчёты
    procedure ReportZ; override;
    procedure ReportX(AReportType:Byte);
    procedure PrintReportSection; override;
    procedure PrintReportHours; override;
    procedure PrintReportCounted; override;
    procedure GetStatus1;

    //Методы совместимые с драйвером ККМ
    function CancelCheck:integer; override;      //Аннулирование всего чека
    function CashIncome:integer;                //Внесение денег
    function CashOutcome:integer;               //Выплата денег
    function CloseCheck:Integer; override;      //Закрыть чек (со сдачей)
    function ShowProperties:boolean; override;  //Отобразить окно параметров ККМ
    function GetRegister:integer;
    function GetStatus:integer;
    function OpenCheck:integer;
    function OpenSession:integer;
    function Payment:integer; override;
    function PrintString:integer;
    function Registration:integer;override;
    function Return:integer;
    function Storno:integer;
    function SetMode(AMode: Byte):integer;
    procedure ResetMode;                   //Выход из текущего режима
    function ResetSummary:integer;         //Общее гашение

    //
    procedure BeginDocument;
    //property Alignment:=0;
    //property FontUnderline:=true;
    //property FontBold:=true;
    procedure EndDocument;


    procedure SetSubMode(AValue: byte);


    //
    property BufferPDEmpty:boolean read FBufferPDEmpty;
    property BufferPDFull:boolean read FBufferPDFull;
    property KKMConected:boolean read FKKMConected;
    property DeviseType:TDeviseType read FDeviseType;
    property DeviseState:TDeviseState read FDeviseState;
    property SubMode:byte read FSubMode write SetSubMode;
    //
    //Свойства - чтение даннных из регистров
    property CheckSum:Currency read GetCheckSum;
    //Свойства, совместимые со штатным свойствами драйвара АТОЛ
    property BatteryLow:boolean read FBatteryLow;
    property Caption:string read FCaption write SetCaption;
    property CheckState:integer read FCheckState;
    property CheckType:Byte read FCheckType write SetCheckType;
    property Count:integer read FCount write SetCount;
    property CoverOpened:boolean read FCoverOpened;
    property Department:integer read FDepartment write SetDepartment;
    property ECRDateTime:TDateTime read FECRDateTime;
    property ErrorCode:integer read FErrorCode;
    property ErrorCodeStr:string read FErrorCodeStr;
    property Mode:byte read FMode;
{    property Name:string read FName write SetName;}

    property OutOfPaper:boolean read FOutOfPaper;
    property PaperError:boolean read FPaperError;
    property Price:Currency read FPrice write SetPrice;
    property PrinterCutMechanismError:boolean read FPrinterCutMechanismError;
    property PrinterOverheatError:boolean read FPrinterOverheatError;
    property PrintPurpose:byte read FPrintPurpose write SetPrintPurpose;
    property Quantity:Double read FQuantity write SetQuantity;
    property RegisterNumber:byte read FRegisterNumber write SetRegisterNumber;
    property SerialNumber:string read FSerialNumber;

    property SessionOpened:boolean read FSessionOpened;
    property Summ:Currency read FSumm write FSumm;
    property TestMode:boolean read FTestMode write SetTestMode;
    property TypeClose:integer read FTypeClose write SetTypeClose;
    property AccessPassword:integer read FAccessPassword write SetAccessPassword;
  published
    property PortName:string read FPortName write SetPortName;
    property PortSpeed:integer read FPortSpeed write SetPortSpeed;
    property Locale:TKKMLocale read FLocale write FLocale default lcCP866_RU; // lcCP866_RU, lcCP866_KZ

    property Password;
  end;

  { EECRAtol }

  EECRAtol = class(ECashRegisterAbstract)
  private
    FDriverStatus:integer;
    FECR: TAtollKKM;
    FECRStatus:integer;
    FMetodName:string;
  public
    constructor Create(AECR: TAtollKKM; ADriverStatus, AECRStatus:integer; AMetodName:string; AMsg:string);
    constructor CreateDrv(AECR: TAtollKKM; ADriverStatus:integer; AMetodName:string; Args:array of const);
    property MetodName:string read FMetodName;
    property DriverStatus:integer read FDriverStatus;
    property ECRStatus:integer read FECRStatus;
    property ECR:TAtollKKM read FECR;
  end;


const
  AtolDeviseCount = 19;
  AtolDeviseNames : array [0..AtolDeviseCount-1] of string =
    ('АТОЛ - общий драйвер',
     'Триум-Ф',
     'ФЕЛИКС-Р Ф',
     'ФЕЛИКС-02К',
     '«Меркурий-140Ф» АТОЛ',
     'ТОРНАДО',
     'Меркурий MS-K',
     'ФЕЛИКС-Р К',
     'ФЕЛИКС-3СК',
     'FPrint-02K',
     'FPrint-03K',
     'FPrint-88K',
     'FPrint-5200K',
     'PayVKP-80K',
     'PayPPU-700K',
     'PayCTS-2000K',
     'FPrint-55K',
     'FPrint-22K',
     'FPrint-11ПТК');

  AtolModeCount = 6;
  AtolModeNames : array [0..AtolModeCount] of string =
      ('Выбор',
       'Режим регистрации',
       'Режим отчетов без гашения',
       'Режим отчетов с гашением',
       'Режим программирования',
       'Режим доступа к ФП',
       'Режим доступа к ЭКЛЗ');

  AtolCheckTypeCount = 6;
  AtolCheckTypeNames : array [1..AtolCheckTypeCount] of string =
    ('чек продажи',
     'чек возврата продажи',
     'чек аннулирования продажи',
     'чек покупки',
     'чек возврата покупки',
     'чек аннулирования покупки');

type
  TLogProc = procedure(const S:string);
var
  FLogProc:TLogProc = nil;

procedure Register;
implementation
uses
{$IFNDEF WINDOWS}
  iconvenc,
{$ELSE}
  rxstrutils,
{$ENDIF}
  LazUTF8, Forms, Controls, KKM_AtolPropsUnit, LResources;

{$R ecr_icon.res}

procedure Register;
begin
  RegisterComponents('TradeEquipment',[TAtollKKM]);
end;

{
ККТ Триум-Ф: X = 0..40;
ККТ ФЕЛИКС-Р Ф: X =0..20;
ККТ ФЕЛИКС-02К: X =0..20;
ККТ «Меркурий-140Ф» АТОЛ: X =0..24;
ККТ ТОРНАДО: X =0..48;
ККТ Меркурий MS-K: X =0..39;
ККТ ФЕЛИКС-Р К: X =0..38;
ККТ ФЕЛИКС-3СК: X =0..38;
ККТ FPrint-02K: X =0..56;
ККТ FPrint-03K: X =0..32;
ККТ FPrint-88K: X =0..56;
ККТ FPrint-5200K: X =0..36;
ККТ PayVKP-80K: X =0..56;
ККТ PayPPU-700K: X=0..56;
ККТ PayCTS-2000K: X =0..72;
ККТ FPrint-55K: X =0..36;
ККТ FPrint-22K: X =0..48;
ККТ FPrint-11ПТК: X =0..32.

}

function ValueToBCD(Value:DWord; Digits:integer):RawByteString;
var
  i, k:integer;
  b:byte;
  P:TBytes;
begin
  SetLength(Result, Digits div 2);
  SetLength(P, Digits div 2);
  SetCodePage(Result, CP_OEMCP, False);
  for i:=(Digits div 2) downto 1 do
  begin
    B:=Value mod 10;
    Value:=Value div 10;
    B:=(Value mod 10)* 16 + B;
    Value:=Value div 10;
    Result[i]:=Char(B);
    P[i-1]:=B;
  end;
end;

{$IFNDEF WINDOWS}
function DosToUTF8(S: string): string;
var
  S1:string;
begin
   if S<>'' then
   begin
     S1:='';
     Iconvert(S, S1, 'CP866', 'UTF8');
//     UTF8FixBroken(PChar(S1));
     Result:=TrimRight(StrPas(PChar(S1)));
   end
   else
     Result:='';
(*
{$ELSE}
   //Result:=AnsiToUtf8(OemToAnsiStr(S));
   Result:=ConsoleToUTF8(S);
*)
end;

function UTF8ToDos(S: string): string;
var
  S1:string;
begin
   if S<>'' then
   begin
     S1:='';
     Iconvert(S, S1, 'UTF8', 'CP866');
//     UTF8FixBroken(PChar(S1));
     Result:=TrimRight(StrPas(PChar(S1)));
   end
   else
     Result:='';
(*{$ELSE}
  //Result:=StrToOem(Utf8ToAnsi(S));
  Result:=UTF8ToConsole(S);
*)
end;
{$endif}

{ TODO : Доработать функцию перевода строки в кодировку KZ }
(*
function UTF8ToKazOEM(const S:string):string;
var
  FSymbol, FSrcString: String;
  i, L: Integer;
  P: PChar;
  FDst: PChar;
begin
  FSrcString := UTF8ToWinCP(s);
  Result:='';
  i:=1;
  while i<=Length(FSrcString) do
  begin
    P:=@FSrcString[i];
    L:=UTF8CharacterLength(P);
    FSymbol:=Copy(FSrcString, i, L);
    i:=i+l;
    if FSymbol=#188 then // ә
      Result:=Result + #177
    else
    if FSymbol=#179 then // і
      Result:=Result + #105
    else
    if FSymbol= #190 then // ң
      Result:=Result + #241
    else
    if FSymbol= #186 then // ғ
      Result:=Result + #220
    else
    if FSymbol= #191 then // ү
      Result:=Result + #248
    else
    if FSymbol= #162 then // ұ
      Result:=Result + #246
    else
    if FSymbol= #157 then // қ
      Result:=Result + #223
    else
    if FSymbol= #180 then // ө
      Result:=Result + #244
    else
    if FSymbol= #158 then // һ
      Result:=Result + #254
    else
    if FSymbol= #163 then // Ә
      Result:=Result + #176
    else
    if FSymbol= #178 then // І
      Result:=Result + #73
    else
    if FSymbol= #189 then // Ң
      Result:=Result + #240
    else
    if FSymbol= #170 then // Ғ
      Result:=Result + #219
    else
    if FSymbol= #175 then // Ү
      Result:=Result + #247
    else
    if FSymbol= #161 then // Ұ
      Result:=Result + #245
    else
    if FSymbol= #141 then // Қ
      Result:=Result + #222
    else
    if FSymbol= #165 then // Ө
      Result:=Result + #243
    else
    if FSymbol= #142 then // Һ
      Result:=Result + #253
    else
    begin
      {$IFNDEF WINDOWS}
      {$ELSE}
      FDst := AllocMem((Length(FSymbol) + 1) * SizeOf(Char));
      if CharToOEM(PChar(FSymbol), FDst) then
        Result := Result + StrPas(FDst);
      FreeMem(FDst);
      {$ENDIF}
    end;
    end;
  end;
  SetCodePage(RawByteString(Result), CP_OEMCP, False);
end;
*)

procedure WriteLog(S:string);
begin
  if Assigned(FLogProc) then
    FLogProc(S);
end;

function DeMask(AData: Ansistring): Ansistring;
var
  i:        Integer;
  B:        Byte;
  DLE_Flag: Boolean;
begin
  Result   := '';
  DLE_Flag := False;
  for i := 1 to length(AData) do
  begin
    if DLE_FLag then
      DLE_Flag := False
    else
    if AData[i] = sDLE then
    begin
      if i < length(AData) Then
        if AData[i + 1] in [sDLE, sETX] then
        begin
          Result   := Result + AData[i + 1];
          DLE_Flag := True;
        end;
    end
    else
      Result := Result + AData[i];
  end;
end;

function KKMErrorToStr(ACode:integer):string;
begin
  case ACode of
    $00:Result:='Ошибок нет';
    $01:Result:='Контрольная лента обработана без ошибок';
    $08:Result:='Неверная цена (сумма)';
    $0A:Result:='Неверное количество';
    $0B:Result:='Переполнение счетчика наличности';
    $0C:Result:='Невозможно сторно последней операции';
    $0D:Result:='Сторно по коду невозможно (в чеке зарегистрировано меньшее количество товаров с указанным кодом)';
    $0E:Result:='Невозможен повтор последней операции';
    $0F:Result:='Повторная скидка на операцию невозможна';
    $10:Result:='Скидка/надбавка на предыдущую операцию невозможна';
    $11:Result:='Неверный код товара';
    $12:Result:='Неверный штрихкод товара';
    $13:Result:='Неверный формат';
    $14:Result:='Неверная длина';
    $15:Result:='ККТ заблокирована в режиме ввода даты';
    $16:Result:='Требуется подтверждение ввода даты';
    $18:Result:='Нет больше данных для передачи ПО ККТ';
    $19:Result:='Нет подтверждения или отмены продажи';
    $1A:Result:='Отчет с гашением прерван. Вход в режим невозможен.';
    $1B:Result:='Отключение контроля наличности невозможно (не настроены необходимые типы оплаты).';
    $1E:Result:='Вход в режим заблокирован';
    $1F:Result:='Проверьте дату и время';
    $20:Result:='Дата и время в ККТ меньше чем в ЭКЛЗ/ФП';
    $21:Result:='Невозможно закрыть архив';
    $3D:Result:='Товар не найден';
    $3E:Result:='Весовой штрихкод с количеством <>1.000';
    $3F:Result:='Переполнение буфера чека';
    $40:Result:='Недостаточное количество товара';
    $41:Result:='Сторнируемое количество больше проданного';
    $42:Result:='Заблокированный товар не найден в буфере чека';
    $43:Result:='Данный товар не продавался в чеке, сторно невозможно';
    $44:Result:='Memo PlusTM 3TM заблокировано с ПК';
    $45:Result:='Ошибка контрольной суммы таблицы настроек Memo PlusTM 3TM';
    $46:Result:='Неверная команда от ККТ';
    $66:Result:='Команда не реализуется в данном режиме ККТ';
    $67:Result:='Нет бумаги';
    $68:Result:='Нет связи с принтером чеков';
    $69:Result:='Механическая ошибка печатающего устройства';
    $6A:Result:='Неверный тип чека';
    $6B:Result:='Нет больше строк картинки';
    $6C:Result:='Неверный номер регистра';
    $6D:Result:='Недопустимое целевое устройство';
    $6E:Result:='Нет места в массиве картинок';
    $6F:Result:='Неверный номер картинки / картинка отсутствует';
    $70:Result:='Сумма сторно больше, чем было получено данным типом оплаты';
    $71:Result:='Сумма не наличных платежей превышает сумму чека';
    $72:Result:='Сумма платежей меньше суммы чека';
    $73:Result:='Накопление меньше суммы возврата или аннулирования';
    $75:Result:='Переполнение суммы платежей';
    $76:Result:='(зарезервировано)';
    $7A:Result:='Данная модель ККТ не может выполнить команду';
    $7B:Result:='Неверная величина скидки / надбавки';
    $7C:Result:='Операция после скидки / надбавки невозможна';
    $7D:Result:='Неверная секция';
    $7E:Result:='Неверный вид оплаты';
    $7F:Result:='Переполнение при умножении';
    $80:Result:='Операция запрещена в таблице настроек';
    $81:Result:='Переполнение итога чека';
    $82:Result:='Открыт чек аннулирования – операция невозможна';
    $84:Result:='Переполнение буфера контрольной ленты';
    $86:Result:='Вносимая клиентом сумма меньше суммы чека';
    $87:Result:='Открыт чек возврата – операция невозможна';
    $88:Result:='Смена превысила 24 часа';
    $89:Result:='Открыт чек продажи – операция невозможна';
    $8A:Result:='Переполнение ФП';
    $8C:Result:='Неверный пароль';
    $8D:Result:='Буфер контрольной ленты не переполнен';
    $8E:Result:='Идет обработка контрольной ленты';
    $8F:Result:='Обнуленная касса (повторное гашение невозможно)';
    $91:Result:='Неверный номер таблицы';
    $92:Result:='Неверный номер ряда';
    $93:Result:='Неверный номер поля';
    $94:Result:='Неверная дата';
    $95:Result:='Неверное время';
    $96:Result:='Сумма чека по секции меньше суммы сторно';
    $97:Result:='Подсчет суммы сдачи невозможен';
    $98:Result:='В ККТ нет денег для выплаты';
    $9A:Result:='Чек закрыт – операция невозможна';
    $9B:Result:='Чек открыт – операция невозможна';
    $9C:Result:='Смена открыта, операция невозможна';
    $9D:Result:='ККТ заблокирована, ждет ввода пароля доступа к ФП';
    $9E:Result:='Заводской номер уже задан';
    $9F:Result:='Исчерпан лимит перерегистраций';
    $A0:Result:='Ошибка ФП';
    $A2:Result:='Неверный номер смены';
    $A3:Result:='Неверный тип отчета';
    $A4:Result:='Недопустимый пароль';
    $A5:Result:='Недопустимый заводской номер ККТ';
    $A6:Result:='Недопустимый РНМ';
    $A7:Result:='Недопустимый ИНН';
    $A8:Result:='ККТ не фискализирована';
    $A9:Result:='Не задан заводской номер';
    $AA:Result:='Нет отчетов';
    $AB:Result:='Режим не активизирован';
    $AC:Result:='Нет указанного чека в КЛ';
    $AD:Result:='Нет больше записей КЛ';
    $AE:Result:='Некорректный код или номер кода защиты ККТ';
    $B0:Result:='Требуется выполнение общего гашения';
    $B1:Result:='Команда не разрешена введенными кодами защиты ККТ';
    $B2:Result:='Невозможна отмена скидки/надбавки';
    $B3:Result:='Невозможно закрыть чек данным типом оплаты (в чеке присутствуют операции без контроля наличных)';
    $B4:Result:='Неверный номер маршрута';
    $B5:Result:='Неверный номер начальной зоны';
    $B6:Result:='Неверный номер конечной зоны';
    $B7:Result:='Неверный тип тарифа';
    $B8:Result:='Неверный тариф';
    $BA:Result:='Ошибка обмена с фискальным модулем';
    $BE:Result:='Необходимо провести профилактические работы';
    $BF:Result:='Неверные номера смен в ККТ и ЭКЛЗ';
    $C8:Result:='Нет устройства, обрабатывающего данную команду';
    $C9:Result:='Нет связи с внешним устройством';
    $CA:Result:='Ошибочное состояние ТРК';
    $CB:Result:='Больше одной регистрации в чеке';
    $CC:Result:='Ошибочный номер ТРК';
    $CD:Result:='Неверный делитель';
    $CF:Result:='Исчерпан лимит активизаций';
    $D0:Result:='Активизация данной ЭКЛЗ в составе данной ККТ невозможна';
    $D1:Result:='Перегрев головки принтера';
    $D2:Result:='Ошибка обмена с ЭКЛЗ на уровне интерфейса I2C';
    $D3:Result:='Ошибка формата передачи ЭКЛЗ';
    $D4:Result:='Неверное состояние ЭКЛЗ';
    $D5:Result:='Неисправимая ошибка ЭКЛЗ';
    $D6:Result:='Авария крипто-процессора ЭКЛЗ';
    $D7:Result:='Исчерпан временной ресурс ЭКЛЗ';
    $D8:Result:='ЭКЛЗ переполнена';
    $D9:Result:='В ЭКЛЗ переданы неверная дата или время';
    $DA:Result:='В ЭКЛЗ нет запрошенных данных';
    $DB:Result:='Переполнение ЭКЛЗ (итог чека)';
    $DC:Result:='Буфер переполнен';
    $DD:Result:='Невозможно напечатать вторую фискальную копию';
    $DE:Result:='Требуется гашение ЭЖ';
    $DF:Result:='Сумма налога больше суммы регистраций по чеку и/или итога или больше суммы регистрации';
    $E0:Result:='Начисление налога на последнюю операцию невозможно';
    $E1:Result:='Неверный номер ЭКЛЗ';
    $E4:Result:='Сумма сторно налога больше суммы зарегистрированного налога данного типа';
    $E5:Result:='Ошибка SD';
    $E6:Result:='Операция невозможна, недостаточно питания';
  else
    Result:='Ошибка не определена';
  end;
end;

function DoDrverMsg(ADriverStatus:integer):string;
begin
  case ADriverStatus of
    0:Result:='Нет ошибок';
    1:Result:='Не допустимый номер режима %d. Допустимые значения %d - %d.';
    2:Result:='Не допустимый тп чека %d. Допустимые значения 1 - 6.';
    3:Result:='Не поддерживаемый номер регистра для чтения %d.';
    4:Result:='Сумма внесения в кассу должна быть больше нуля.';
    5:Result:='Сумма выплаты из кассы должна быть больше нуля.';
  else
    Result:=IntToStr(ADriverStatus) + ' - не определённый статус';
  end;
end;

function BufBCDToInteger(var Buf; Len:integer):integer;
var
  i:integer;
  C:array [1..8] of byte absolute Buf;
  B:QWord;
begin
  B:=0;
  for i:=1 to Len do
  begin
    B:=B * 256;
    B:=B + C[i];
  end;
  Result:=BCDToInt(B);
end;

{ EECRAtol }

constructor EECRAtol.Create(AECR: TAtollKKM; ADriverStatus,
  AECRStatus: integer; AMetodName: string; AMsg: string);
begin
  inherited Create(AMsg);
  FMetodName:=AMetodName;
  FDriverStatus:=ADriverStatus;
  FECRStatus:=AECRStatus;
  FECR:=AECR;
end;

constructor EECRAtol.CreateDrv(AECR: TAtollKKM; ADriverStatus: integer;
  AMetodName: string; Args: array of const);
begin
  inherited Create(Format(DoDrverMsg(ADriverStatus), Args));
  FMetodName:=AMetodName;
  FDriverStatus:=ADriverStatus;
  FECRStatus:=0;
  FECR:=AECR;
end;

{ TAtollKKM }

procedure TAtollKKM.SetErrorCode(AErrorCode: integer);
begin
  FErrorCode:=AErrorCode;
  FErrorCodeStr:=KKMErrorToStr(AErrorCode);
end;

procedure TAtollKKM.SetDepartment(AValue: integer);
begin
  if FDepartment=AValue then Exit;
  if AValue>30 then
    AValue:=30;
  FDepartment:=AValue;
end;

procedure TAtollKKM.SetCheckType(AValue: Byte);
begin
  //1 – чек продажи,
  //2 – чек возврата продажи,
  //3 – чек аннулирования продажи,
  //4 – чек покупки,
  //5 – чек возврата покупки,
  //6 – чек аннулирования покупки
  if FCheckType=AValue then Exit;
  FCheckType:=AValue;
end;

procedure TAtollKKM.SetCount(AValue: integer);
begin
  if FCount=AValue then Exit;
  FCount:=AValue;
end;

procedure TAtollKKM.ClearBufArray;
begin
  FillChar(FBufArray, SizeOf(FBufArray), 0);
  FillChar(FCommandBuf, SizeOf(FCommandBuf), 0);
  FCurPos:=1;
end;

procedure TAtollKKM.ValueToBuf(Value: DWord; Digits: integer);
var
  i, k:integer;
  B:Byte;
begin
  for i:=(Digits div 2) downto 1 do
  begin
    B:=Value mod 10;
    Value:=Value div 10;
    B:=(Value mod 10)* 16 + B;
    Value:=Value div 10;

    FBufArray[FCurPos + i - 1]:=B;
  end;
  FCurPos:=FCurPos + Digits div 2;
end;

procedure TAtollKKM.ByteToBuf(Value: byte);
begin
  FBufArray[FCurPos]:=Value;
  Inc(FCurPos);
end;

procedure TAtollKKM.MakeCommandBuf;
var
  i:integer;
  B:byte;
begin
  //4. Добавляем в начало STX
  FCommandBufLen:=1;
  FCommandBuf[FCommandBufLen]:=byte(sSTX);
  FCommandBufLen:=2;

  //1. Маскируем байты, равные DLE и ETX (10h и 03h):
  for i:=1 to FCurPos - 1 do
  begin
    if FBufArray[i] in [byte(sDLE), byte(sETX)] then
    begin
      FCommandBuf[FCommandBufLen]:=byte(sDLE);
      Inc(FCommandBufLen);
    end;
    FCommandBuf[FCommandBufLen]:=FBufArray[i];
    Inc(FCommandBufLen);
  end;

  //2. Добавляем в конец ETX
  FCommandBuf[FCommandBufLen]:=Byte(sETX);
  Inc(FCommandBufLen);

  //3. Подсчитываем <CRC>
  B:=Byte(FCommandBuf[2]);
  for i:=3 to FCommandBufLen - 1 do
    B:=B xor FCommandBuf[i];


  //5. Добавляем в конец <CRC>
  FCommandBuf[FCommandBufLen]:=b;
  Inc(FCommandBufLen);
(*
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog(AData);
  DumpCmd(Result);
  {$ENDIF}
*)
end;

procedure TAtollKKM.SendCommandBuf;
begin
  FSerialPort.SendBuffer(@FCommandBuf[1], FCommandBufLen - 1);
end;

function TAtollKKM.GetCheckSum: Currency;
var
  S, SR:string;
  B:Char;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('GetCheckSum;');
  {$ENDIF}
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
(*
    //"С"<Регистр (1)> <Параметр1 (1)> <Параметр2 (1)>.
    S:=MakeCommand(#$14+Char(0)+char(0)); //Считать регистр
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($14);
    ByteToBuf(0);
    ByteToBuf(0);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;
    SetErrorCode(Byte(SR[3]));

    SendACK;
    ReadEOT;

  end;
  DoneKKM;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done RecalcCheck;');
  {$ENDIF}
  Result:=FErrorCode;
end;

procedure TAtollKKM.SetAccessPassword(AValue: integer);
begin
  if FAccessPassword=AValue then Exit;
  FAccessPassword:=AValue;
end;

procedure TAtollKKM.SetCaption(AValue: string);
begin
  if FCaption=AValue then Exit;
  FCaption:=AValue;
end;

//function TAtollKKM.MakeCommand(AData: string): string;
function TAtollKKM.MakeCommand(AData: RawByteString): RawByteString;
var
  i:integer;
  B:byte;
begin
  Result:='';
  SetCodePage(Result, CP_OEMCP, False);

  AData:=ValueToBCD(FAccessPassword, 4) + AData;
  //1. Маскируем байты, равные DLE и ETX (10h и 03h):
  for i:=1 to Length(AData) do
  begin
    if AData[i] in [sDLE, sETX] then
      Result:=Result + sDLE;
    Result:=Result + AData[i];
  end;

  //2. Добавляем в конец ETX
  Result:=Result + sETX;

  //3. Подсчитываем <CRC>
  B:=Byte(Result[1]);
  for i:=2 to Length(Result) do
    B:=B xor Byte(Result[i]);


  //4. Добавляем в начало STX
  Result:=sSTX + Result;

  //5. Добавляем в конец <CRC>
  Result:=Result + Char(B);

  {$IFDEF DEBUG_KKM_DRV}
  WriteLog(AData);
  DumpCmd(Result);
  {$ENDIF}
end;


procedure TAtollKKM.DumpCmd(S: RawByteString);
var
  i:integer;
  R:string;
begin
  R:='';
  for i:=1 to Length(S) do
    R:=R+'$'+hexStr(byte(S[i]), 2)+' ';
  WriteLog(R);
end;

procedure TAtollKKM.InitKKM;
var
  S, LEM:string;
  B:Char;
  LE: Integer;
begin
  FErrorCode:=0;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Connect');
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  FSerialPort.Connect(FPortName);
  {$ELSE}
  FSerialPort.Connect('/dev/'+FPortName);
  {$ENDIF}

  {$IFDEF DEBUG_KKM_DRV}
  WriteLog(SysToUTF8(FSerialPort.LastErrorDesc));
  {$ENDIF}

  WriteLog('Set params');
  {$IFNDEF WINDOWS}
  FSerialPort.config(115200,8,'N',1,false,false);
  {$ENDIF}

  {$IFDEF DEBUG_KKM_DRV}
  WriteLog(SysToUTF8(FSerialPort.LastErrorDesc));
  {$ENDIF}

  if FSerialPort.LastError = sOK then
  begin
    SendENQ;
    ReadACK;
  end;

  if (FSerialPort.LastError <> sOK) or (FErrorCode <> 0) then
  begin
    LE:=FSerialPort.LastError;
    LEM:=SysToUTF8(FSerialPort.LastErrorDesc);
    FSerialPort.CloseSocket;
    if (FErrorCode <> 0) then
      raise EECRAtol.Create(Self, 0, $68, 'Internal connect', KKMErrorToStr($68))
    else
      raise EECRAtol.Create(Self, LE, 0, 'Internal connect', LEM);
  end;
end;

procedure TAtollKKM.DoneKKM;
begin
  FSerialPort.CloseSocket;
end;

procedure TAtollKKM.SendENQ;
var
  S:string;
begin
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Send ENQ');
  {$ENDIF}

  S:=sENQ;
  FSerialPort.SendBuffer(@S[1], Length(S));

  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Done send ENQ');
  {$ENDIF}
end;

procedure TAtollKKM.SendEOT;
var
  S:string;
begin
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Send EOT');
  {$ENDIF}
  S:=sEOT;
  FSerialPort.SendBuffer(@S[1], Length(S));
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Done send EOT');
  {$ENDIF}
end;

procedure TAtollKKM.ReadEOT;
var
  B:char;
begin
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Read EOT');
  {$ENDIF}
  if FSerialPort.CanRead(tsdReadEOT) then
    FSerialPort.RecvBuffer(@B, 1)
  else
    FErrorCode:=$FF;
  WriteLog(SysToUTF8(FSerialPort.LastErrorDesc)+' '+IntToStr(Byte(B)));
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Done Read EOT');
  {$ENDIF}
end;

procedure TAtollKKM.SendACK;
var
  S:string;
begin
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Send ACK');
  {$ENDIF}

  S:=sACK;
  FSerialPort.SendBuffer(@S[1], Length(S));

  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Done send ACK');
  {$ENDIF}
end;

procedure TAtollKKM.ReadACK;
var
  B:char;
begin
  { TODO : Необходимо добавить повторы }
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Read ACK');
  {$ENDIF}
  if FSerialPort.CanRead(tsdSendACK) then
    FSerialPort.RecvBuffer(@B, 1)
  else
    FErrorCode:=$FF;
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog(SysToUTF8(FSerialPort.LastErrorDesc)+' '+IntToStr(Byte(B))+' '+BoolToStr(B = sACK));
  WriteLog('Done Read ACK');
  {$ENDIF}
end;

procedure TAtollKKM.ReadENQ(ATimeOut: integer = tsdReadENQ);
var
  B:char;
begin
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog('Read ENQ');
  {$ENDIF}
  if FSerialPort.CanRead(ATimeOut) then
    FSerialPort.RecvBuffer(@B, 1)
  else
    FErrorCode:=$FF;
  {$IFDEF DEBUG_KKM_DRV_SYS_MSG}
  WriteLog(SysToUTF8(FSerialPort.LastErrorDesc)+' '+IntToStr(Byte(B))+' '+BoolToStr(B = sENQ));
  WriteLog('Done read ENQ');
  {$ENDIF}
end;

procedure TAtollKKM.InternalGetStatus(AHeader: boolean);
var
  //S, SR:string;
  FStatus:byte;
  SR: TBytes;
begin
  if AHeader then
  begin
    SendENQ;
    ReadACK;
  end;

  FStatus:=0;
  FMode:=0;
  FSubMode:=0;
(*
  S:=MakeCommand(#$45);
  FSerialPort.SendBuffer(@S[1], Length(S));
*)
  ClearBufArray;
  ValueToBuf(FAccessPassword, 4);
  ByteToBuf($45);
  MakeCommandBuf;
  SendCommandBuf;

  ReadACK;
  SendEOT;

  ReadENQ;
  SendACK;

  SR:=LoadKKMData1;

  SendACK;
  ReadEOT;

  if Length(SR)>3 then
  begin
(*    FStatus:=Byte(SR[4]);
    FMode:=Byte(SR[3]) mod 16;
    FSubMode:=Byte(SR[3]) div 16;*)

    FStatus:=SR[3];
    FMode:=SR[2] mod 16;
    FSubMode:=SR[2] div 16;
  end;

  FOutOfPaper:=(FStatus and $01) <> 0;
  FKKMConected:=(FStatus and $02) = 0;
  FPaperError:=(FStatus and $04) <> 0;
  FPrinterCutMechanismError:=(FStatus and $08) <> 0;
  FPrinterOverheatError:=(FStatus and $10) <> 0;
  FBufferPDEmpty:=(FStatus and $20) <> 0;
  FBufferPDFull:=(FStatus and $40) <> 0;
end;

procedure TAtollKKM.InternalSetMode(AMode: byte);
var
  S, SR:string;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('InternalSetMode');
  {$ENDIF}
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
(*
    S:=MakeCommand(#$56+Char(AMode)+ValueToBCD(StrToInt(FPassword), 8)); //Вход в режим
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($56);
    ByteToBuf(AMode);
    ValueToBuf(StrToInt(Password), 8);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;
    SendACK;
    ReadEOT;

    if Length(SR)>3 then
      SetErrorCode(Byte(SR[3]))
    else
      FErrorCode:=$FF;
  end;
  DoneKKM;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done InternalSetMode');
  {$ENDIF}
end;

function TAtollKKM.LoadKKMData: RawByteString;
var
  PB, B:char;
begin
  Result:='';
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Read data');
  {$ENDIF}
  B:=#0;
  FErrorCode:=0;
  repeat
    PB:=B;

    if FSerialPort.CanRead(tsdReadData) then
      FSerialPort.RecvBuffer(@B, 1)
    else
      FErrorCode:=$FE;
    {$IFDEF DEBUG_KKM_DRV_READ}
    WriteLog(SysToUTF8(FSerialPort.LastErrorDesc)+' '+IntToStr(Byte(B)));
    {$ENDIF}

{    if B = sENQ then
    begin
      SendACK;
    end
    else   }
      Result:=Result + B;
  until ((B = sETX) and (PB<>sDLE)) or (FErrorCode<>0);
  //Read CRC
  if FSerialPort.CanRead(tsdReadData) then
    FSerialPort.RecvBuffer(@B, 1)
  else
    FErrorCode:=$FF;
  Result:=DeMask(Result);
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog(SysToUTF8(FSerialPort.LastErrorDesc)+' CRC = '+IntToStr(Byte(B))+' FErrorCode='+IntToStr(FErrorCode));
  WriteLog('Done read data');
  DumpCmd(Result);
  {$ENDIF}
end;

function TAtollKKM.LoadKKMData1: TBytes;

var
  AAA:array [1..1000] of byte;
  BBB:array [1..1000] of byte;
  L_A, L_B, i:integer;
  PB,B:Byte;

  procedure DeMask;
  var
    i:        Integer;
    B:        Byte;
    DLE_Flag: Boolean;
  begin
    FillChar(BBB, SizeOf(BBB), 0);
    DLE_Flag := False;

    for i := 1 to L_A - 1 do
    begin
      if DLE_FLag then
        DLE_Flag := False
      else
      if AAA[i] = Byte(sDLE) then
      begin
        if i < L_A - 1 Then
          if AAA[i + 1] in [Byte(sDLE), Byte(sETX)] then
          begin
            BBB[L_B]:=AAA[i + 1];
            Inc(L_B);
            DLE_Flag := True;
          end;
      end
      else
      begin
        BBB[L_B]:=AAA[i];
        Inc(L_B);
      end;
      if L_B>SizeOf(BBB) then
        raise Exception.Create('L_B>SizeOf(BBB)');
    end;
  end;

begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Read data');
  {$ENDIF}

  B:=0;
  FErrorCode:=0;
  FillChar(AAA, SizeOf(AAA), 0);
  L_A:=1;
  L_B:=1;

  repeat
    PB:=B;

    if FSerialPort.CanRead(tsdReadData) then
      FSerialPort.RecvBuffer(@B, 1)
    else
      FErrorCode:=$FE;
    {$IFDEF DEBUG_KKM_DRV_READ}
    WriteLog(SysToUTF8(FSerialPort.LastErrorDesc)+' '+IntToStr(Byte(B)));
    {$ENDIF}
    AAA[L_A]:=Byte(B);
    Inc(L_A);
    //Result:=Result + B;
  until ((B = Byte(sETX)) and (PB<>Byte(sDLE))) or (FErrorCode<>0);
  //Read CRC

  if FSerialPort.CanRead(tsdReadData) then
    FSerialPort.RecvBuffer(@B, 1)
  else
    FErrorCode:=$FF;

  DeMask;
  SetLength(Result, L_B-1);
  for i:=1 to L_B-1 do
    Result[i-1]:=BBB[i];
(*
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog(SysToUTF8(FSerialPort.LastErrorDesc)+' CRC = '+IntToStr(Byte(B))+' FErrorCode='+IntToStr(FErrorCode));
  WriteLog('Done read data');
  DumpCmd(Result);
  {$ENDIF}
*)
end;

{procedure TAtollKKM.SetName(AValue: string);
begin
  if FName=AValue then Exit;
  FName:=AValue;
end;
}
function TAtollKKM.SetMode(AMode: Byte): integer;
var
  S, SR:string;
  B:Char;
  OldMode:byte;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('SetMode');
  {$ENDIF}
  FErrorCode:=0;
  FErrorCodeStr:='';
  if AMode in [0..AtolModeCount] then
  begin
    GetStatus1;
    OldMode:=FMode;
    ResetMode;
    GetStatus1;
    if FMode <> 0 then
    begin
      FErrorCode:=$FF;
      FErrorCodeStr:=Format('Ошибка выхода из режима (%d) - %s.', [OldMode, AtolModeNames[OldMode]]);
    end
    else
    if AMode <> 0 then
    begin
      InternalSetMode(AMode);
      if FErrorCode = 0 then
      begin
        //GetStatus1;
        GetStatus;
  {      if FMode <> AMode then
        begin
          FErrorCode:=$FF;
          FErrorCodeStr:=Format('Ошибка входа в режима (%d) - %s.', [AMode, AtolModeNames[AMode]]);
        end;}
      end;
    end;
    Result:=FErrorCode;
  end
  else
    raise EECRAtol.Create(Self, 1, 0, 'SetMode', Format(DoDrverMsg(1), [AMode, 0, AtolModeCount]));
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done SetMode');
  {$ENDIF}
end;

procedure TAtollKKM.ResetMode;
var
  S, SR:string;
  B:Char;
begin
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('ResetMode');
    {$ENDIF}
(*
    S:=MakeCommand(#$48); //Выход из текущего режима
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($48);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;
    SendACK;
    ReadEOT;

    if Length(SR)>3 then
      SetErrorCode(Byte(SR[3]))
    else
      FErrorCode:=$FF;

    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done ResetMode');
    {$ENDIF}
  end;
  DoneKKM;
end;

function TAtollKKM.ResetSummary: integer;
var
  S, SR:string;
  B:Char;
begin
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('ResetSummary');
    {$ENDIF}
(*
    S:=MakeCommand(#$77); //Общее гашение
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($77);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;
    SendACK;
    ReadEOT;

    if Length(SR)>3 then
      SetErrorCode(Byte(SR[3]))
    else
      FErrorCode:=$FF;

    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done ResetSummary');
    {$ENDIF}
  end;
  DoneKKM;
  Result:=FErrorCode;
end;

procedure TAtollKKM.SetPortName(AValue: string);
begin
  if FPortName=AValue then Exit;
  FPortName:=AValue;
end;

procedure TAtollKKM.SetPortSpeed(AValue: integer);
begin
  if FPortSpeed=AValue then Exit;
  FPortSpeed:=AValue;
end;

procedure TAtollKKM.SetPrice(AValue: Currency);
begin
  if FPrice=AValue then Exit;
  FPrice:=AValue;
end;

procedure TAtollKKM.SetPrintPurpose(AValue: byte);
begin
  if FPrintPurpose=AValue then Exit;
  if AValue in [0..3] then
    FPrintPurpose:=AValue
  else
    raise EECRAtol.Create(Self, 0, FErrorCode, 'SetPrintPurpose', 'Тип ленты для печати может быть только 1, 2 или 3');
end;

procedure TAtollKKM.SetQuantity(AValue: Double);
begin
  if FQuantity=AValue then Exit;
  FQuantity:=AValue;
end;

procedure TAtollKKM.SetRegisterNumber(AValue: byte);
begin
  if FRegisterNumber=AValue then Exit;
  FRegisterNumber:=AValue;
end;

procedure TAtollKKM.SetTestMode(AValue: boolean);
begin
  if FTestMode=AValue then Exit;
  FTestMode:=AValue;
end;

procedure TAtollKKM.SetTypeClose(AValue: integer);
begin
  if FTypeClose=AValue then Exit;
  FTypeClose:=AValue;
end;

procedure TAtollKKM.SetSubMode(AValue: byte);
begin
  if FSubMode=AValue then Exit;
  FSubMode:=AValue;
end;

constructor TAtollKKM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLocale:=lcCP866_RU;

  FSerialPort:=TBlockSerial.Create;
  FSerialPort.LinuxLock:=false; //Пока так. Может потом переделаем

  FPortSpeed:=6;
  FAccessPassword:=0;
  FTypeClose:=1;
  FTestMode:=false;
  FCheckType:=1;
  FMaxLineWidth:=20;
end;

destructor TAtollKKM.Destroy;
begin
  FSerialPort.Free;
  inherited Destroy;
end;

procedure TAtollKKM.LoadParams(ParList: TStrings);
begin
  if Assigned(ParList) then
  begin
    if ParList.Values['PortName']<>'' then
      FPortName:=ParList.Values['PortName'];
    if ParList.Values['PortSpeed']<>'' then
      FPortSpeed:=StrToIntDef(ParList.Values['PortSpeed'], FPortSpeed);
  end;
end;

procedure TAtollKKM.StoreParams(ParList: TStrings);
begin
  if Assigned(ParList) then
  begin
    ParList.Values['PortName']:=FPortName;
    ParList.Values['PortSpeed']:=IntToStr(FPortSpeed);
  end;
end;

procedure TAtollKKM.Beep;
var
  S:string;
  B:Char;
begin
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Send BEEP');
    {$ENDIF}
(*
    S:=MakeCommand(#$47);
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($47);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done send BEEP');
    {$ENDIF}
    SetErrorCode(0);
  end;
  DoneKKM;
end;

procedure TAtollKKM.CutCheck(APartial: boolean);
var
  S, SR:string;
  B:Char;
begin
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Send CUT');
    {$ENDIF}
(*
    S:=MakeCommand(#$75#$00);
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($75);
    ByteToBuf(0);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;
    SetErrorCode(Byte(SR[3]));

    SendACK;
    ReadEOT;

    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done send CUT');
    {$ENDIF}
  end;
  DoneKKM;
end;

procedure TAtollKKM.PrintLine(ALine: string);
var
  //S:string;
  S, S1:RawByteString;
  SR:string;
  B:Char;
begin
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
    {$IFDEF WINDOWS}
    S:=UTF8ToConsole(UTF8Copy(ALine, 1, FMaxLineWidth));
    {$ELSE}
    S:=UTF8ToDos(ALine);
    {$ENDIF}
    //S1:=Copy(S, 1, FMaxLineWidth);
    //S1:=MakeCommand(#$4C+Copy(S, 1, FMaxLineWidth));
    S1:=#$4C;
    SetCodePage(S1, CP_OEMCP, False);
    S1:=S1+S;
    S1:=MakeCommand(S1);
    //S1:=MakeCommand(#$4C+S);
    FSerialPort.SendBuffer(@S1[1], Length(S1));
    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;
    SendACK;
    ReadEOT;
    SetErrorCode(Byte(SR[3]));
  end;
  DoneKKM;
end;

procedure TAtollKKM.PrintClishe;
var
  S, SR:string;
  B:Char;
begin
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('PrintClishe');
    {$ENDIF}
(*
    S:=MakeCommand(#$6C); //Команда печати клише чека
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($6C);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;
    SendACK;
    ReadEOT;

    if Length(SR)>3 then
      SetErrorCode(Byte(SR[3]));

    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done PrintClishe');
    {$ENDIF}
  end;
  DoneKKM;
end;

procedure TAtollKKM.ReadModel;
var
  S:string;
  PB, B:Char;
  SR:string;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('ReadModel;');
  {$ENDIF}
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
(*
    S:=MakeCommand(#$A5);
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($A5);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;

    SendACK;
    ReadEOT;

  end;
  DoneKKM;

  if Length(SR)>14 then
  begin
    FDeviseType.ProtocolVersion:=Byte(SR[3]);
    FDeviseType.ProtocolType:=Byte(SR[4]);
    FDeviseType.KKMModel:=Byte(SR[5]);
    FDeviseType.Mode:=Byte(SR[6]) * 256 + Byte(SR[7]);
    {$IFDEF WINDOWS}
    FDeviseType.KKMName:=TrimRight(ConsoleToUTF8(Copy(SR, 14, Length(SR))));
    {$ELSE}
    FDeviseType.KKMName:=TrimRight(DosToUTF8(Copy(SR, 14, Length(SR))));
    {$ENDIF}
    SetErrorCode(Byte(SR[2]));
  end
  else
  begin
    FDeviseType.KKMModel:=0;
    FDeviseType.KKMName:='';
    FDeviseType.Mode:=0;
    FDeviseType.ProtocolType:=0;
    FDeviseType.ProtocolVersion:=0;
  end;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done ReadModel;');
  {$ENDIF}
end;

procedure TAtollKKM.DemoPrint;
var
  S:string;
  SR:string;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('DemoPrint;');
  {$ENDIF}
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
(*
    //"В"<Принтер (1)><Резерв (2)>.
    S:=MakeCommand(#$82+Char(FPrintPurpose)+#00#00);
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($82);
    ByteToBuf(FPrintPurpose);
    ByteToBuf(0);
    ByteToBuf(0);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;

    ReadENQ(40000);
    SendACK;

    SR:=LoadKKMData;

    SendACK;
    ReadEOT;


    SetErrorCode(Byte(SR[3]));

    if FErrorCode = 0 then
    begin
      repeat
        Sleep(500);
        InternalGetStatus(true);
        if (Mode = 7) and (FSubMode = 2) then
        begin
          FMode:=7;

        end;
      until (FMode <> $7) or (FSubMode <> 2);
    end;
  end;
  DoneKKM;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done DemoPrint;');
  {$ENDIF}
end;

procedure TAtollKKM.ReportZ;
var
  S:string;
  SR:string;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('ReportZ;');
  {$ENDIF}
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
(*
    S:=MakeCommand(#$5A);
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($5A);
    MakeCommandBuf;
    SendCommandBuf;

    ReadACK;
    SendEOT;

    ReadENQ(40000);
    SendACK;

    SR:=LoadKKMData;

    SendACK;
    ReadEOT;

    SetErrorCode(Byte(SR[3]));

    { TODO : Необходимо реализовать расширенную обработку ошибок Z отчёта }
    if FErrorCode = 0 then
    begin
      repeat
        Sleep(500);
        InternalGetStatus(true);
        if (Mode = 3) and (FSubMode = 2) then
        begin
          FMode:=3;

        end;
      until (FMode <> $3) or (FSubMode <> 2);
    end;
  end;
  DoneKKM;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done ReportZ;');
  {$ENDIF}
end;

procedure TAtollKKM.ReportX(AReportType: Byte);
var
  S:string;
  SR:string;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('ReportX;');
  {$ENDIF}
  if (AReportType>0) and (AReportType<9) then
  begin
    InitKKM;
    if FSerialPort.LastError = sOK then
    begin
(*
      S:=MakeCommand(#$67+Char(AReportType));
      FSerialPort.SendBuffer(@S[1], Length(S));
*)
      ClearBufArray;
      ValueToBuf(FAccessPassword, 4);
      ByteToBuf($67);
      ByteToBuf(AReportType);
      MakeCommandBuf;
      SendCommandBuf;


      ReadACK;
      SendEOT;

      ReadENQ(40000);
      SendACK;

      SR:=LoadKKMData;

      SendACK;
      ReadEOT;

      SetErrorCode(Byte(SR[3]));

      if FErrorCode = 0 then
      begin
        repeat
          Sleep(500);
          InternalGetStatus(true);

        until (FMode <> 2) or (FSubMode<>2);
      end;
    end;
    DoneKKM;
  end
  else
    SetErrorCode($FF);
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done ReportX;');
  {$ENDIF}
end;

procedure TAtollKKM.PrintReportSection;
begin

end;

procedure TAtollKKM.PrintReportHours;
begin

end;

procedure TAtollKKM.PrintReportCounted;
begin

end;

function TAtollKKM.CancelCheck: integer;
var
  S, SR:string;
  B:Char;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('CancelCheck');
  {$ENDIF}
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
(*    S:=MakeCommand(#$59); //Аннулирование всего чека
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($59);
    MakeCommandBuf;
    SendCommandBuf;


    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;

    SendACK;
    ReadEOT;

    SetErrorCode(Byte(SR[3]));
  end;
  DoneKKM;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done CancelCheck');
  {$ENDIF}
  Result:=FErrorCode;

  inherited CancelCheck;
end;

function TAtollKKM.CloseCheck: Integer;
var
  S, SR:string;
  B:Char;
  FTmp: Integer;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('CloseCheck;');
  {$ENDIF}
  InitKKM;
  FTmp:=0;
  if FSerialPort.LastError = sOK then
  begin
(*
    S:=MakeCommand(#$4A+Char(FTestMode)+char(FTypeClose)+ValueToBCD(trunc(FSumm * 100), 10)); //Закрыть чек (со сдачей)
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
//(*
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($4A);
    ByteToBuf(Ord(FTestMode));
    ByteToBuf(FTypeClose);
    ValueToBuf(trunc(FSumm * 100), 10);
    MakeCommandBuf;
    SendCommandBuf;
//*)
    ReadACK;
    SendEOT;


    ReadENQ(20000); //Таймаут для закрытия чека
    WriteLog('CloseCheck ReadENQ - ErrorCode '+IntToStr(FErrorCode));
    SendACK;

    SR:=LoadKKMData;

    SendACK;
    ReadEOT;
    WriteLog('CloseCheck ReadENQ - ReadEOT '+IntToStr(FErrorCode));


    SetErrorCode(Byte(SR[3]));

    FTmp:=FErrorCode;
    repeat
      Sleep(500);
      WriteLog(Format('11 FErrorCode = %d', [FErrorCode]));
      InternalGetStatus(true);
      WriteLog(Format('InternalGetStatus CloseCheck; = %d.%d', [FMode, FSubMode]));
    until ((FMode = 1) and (FSubMode = 0)) or ((FMode = 1) and (FSubMode = 4)) or (FMode <> 1) or (FErrorCode<>0);

  end;
  DoneKKM;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done CloseCheck;');
  {$ENDIF}

  if FTmp <> 0 then
    Result:=FTmp
  else
    Result:=FErrorCode;

  inherited CloseCheck;
end;

function TAtollKKM.OpenSession: integer;
var
  S, SR:string;
  B:Char;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('OpenSession;');
  {$ENDIF}
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
    S:=MakeCommand(#$9A#00+FCaption); //Открыть сессию
    FSerialPort.SendBuffer(@S[1], Length(S));
    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;

    SendACK;
    ReadEOT;

    SetErrorCode(Byte(SR[3]));
  end;
  DoneKKM;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done OpenSession;');
  {$ENDIF}
end;

function TAtollKKM.OpenCheck: integer;
var
  S, SR:string;
  B:Char;
begin
  inherited OpenCheck;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('OpenCheck;');
  {$ENDIF}
  if FCheckType in [1..6] then
  begin
    InitKKM;
    if FSerialPort.LastError = sOK then
    begin
(*
      //"Т"<Флаги (1)><Тип чека (1)>
      S:=MakeCommand(#$92+Char(FTestMode)+Char(FCheckType)); //Открыть чек
*)
      ClearBufArray;
      ValueToBuf(FAccessPassword, 4);
      ByteToBuf($92);
      ByteToBuf(Ord(FTestMode));
      ByteToBuf(FCheckType);
      MakeCommandBuf;
      SendCommandBuf;


      FSerialPort.SendBuffer(@S[1], Length(S));
      ReadACK;
      SendEOT;

      ReadENQ;
      SendACK;

      SR:=LoadKKMData;

      SendACK;
      ReadEOT;

      SetErrorCode(Byte(SR[3]));
    end;
    DoneKKM;
  end
  else
    raise EECRAtol.CreateDrv(Self, 2,'OpenCheck', [FCheckType]);
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done OpenCheck;');
  {$ENDIF}
end;

procedure TAtollKKM.GetStatus1;
begin
  InitKKM;
  if FSerialPort.LastError = sOK then
    InternalGetStatus(false);
  DoneKKM;
end;

function TAtollKKM.GetStatus: integer;
var
  S{, SR}:RawByteString;
  FStatus:byte;
  y,m,d, h, mm, ss:integer;
  SR: TBytes;
begin
  FSessionOpened:=false;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('GetStatus');
  {$ENDIF}
  //Очистим переменные
  FMode:=0;
  FSubMode:=0;
  FCheckNumber:=0;
  FCheckState:=0;
  FSessionOpened:=false;
  FOutOfPaper:=false;
  FCoverOpened:=false;
  FBatteryLow:=false;

  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
(*
    S:=MakeCommand(#$3F); //Запрос состояния ККТ
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
//(*
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($3F);
    MakeCommandBuf;
    SendCommandBuf;
//*)
    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

//    SR:=LoadKKMData;
//    DumpCmd(SR);
    SR:=LoadKKMData1;

    SendACK;
    ReadEOT;
    WriteLog('Length(SR)='+IntToStr(Length(SR)));

    if Length(SR)>=31 then
    begin
      FDeviseState.KssNumber:=BCDToInt(byte(SR[2])); //<Кассир(1)>
      FDeviseState.NumberInHall:=BCDToInt(byte(SR[3])); //<Номер_в_зале(1)>

      y:=BCDToInt(byte(SR[4])); //<Дата_YMD(3)>
      m:=BCDToInt(byte(SR[5])); //<Дата_YMD(3)>
      d:=BCDToInt(byte(SR[6])); //<Дата_YMD(3)>
      if y<90 then y:=2000+y
      else y:=1900+y;

      h:=BCDToInt(byte(SR[7])); //<Время_HMS(3)>
      mm:=BCDToInt(byte(SR[8])); //<Время_HMS(3)>
      ss:=BCDToInt(byte(SR[9])); //<Время_HMS(3)>
      try
        TryEncodeDate(y, m, d, FDeviseState.KKMDate); //<Дата_YMD(3)>
        TryEncodeTime(h, mm, ss, 0, FDeviseState.KKMTime); //<Время_HMS(3)>
      finally
      end;

      FDeviseState.Flags:=byte(SR[10]);        //<Флаги(1)>
      FDeviseState.FabNumber:=byte(SR[11])*256*256*256 + byte(SR[12])*256*256+byte(SR[13])*256 + byte(SR[14]);   //<Заводской_номер(4)>
      FDeviseState.Model:=byte(SR[15]);// <Модель(1)>
      //FDeviseState.Version:=SR[17]+'.'+SR[18];   //<Версия_ПО_ККТ(2)>
      FDeviseState.Version:=Char(SR[16])+'.'+Char(SR[17]);   //<Версия_ПО_ККТ(2)>
      FDeviseState.Mode:=byte(SR[18]);         //<Режим_работы(1)>
      FDeviseState.CheckNum:=BCDToInt(byte(SR[19])*256 + byte(SR[20]));  //<Номер_чека(2)>
      FDeviseState.NumSmena:=BCDToInt(byte(SR[21])*256 + byte(SR[22]));  //<Номер_смены(2)>
      FDeviseState.CheckState:=byte(SR[23]);   //<Состояние_чека(1)>
//      FDeviseState.CheckSum:Currency; //<Сумма_чека(5)>
      FDeviseState.DecimalSep:=byte(SR[29]);   //<Десятичная_точка(1)>
      FDeviseState.Port:=byte(SR[30]);         //<Порт(1)>

      FSubMode:=FDeviseState.Mode div 16;
      FMode:=FDeviseState.Mode mod 16;
      FCheckNumber:=FDeviseState.CheckNum;
      FCheckState:=FDeviseState.CheckState;

      FSessionOpened:=FDeviseState.Flags and 2 <> 0;
      FOutOfPaper:=FDeviseState.Flags and 8 <> 0;
      FCoverOpened:=FDeviseState.Flags and 32 <> 0;
      FBatteryLow:=FDeviseState.Flags and 128 <> 0;

      FECRDateTime:=FDeviseState.KKMDate + FDeviseState.KKMTime;
      if FDeviseState.FabNumber = $FFFFFFFF then
        FSerialNumber:=IntToHex(FDeviseState.FabNumber, 8)
      else
        FSerialNumber:=format('%-08d', [BCDToInt(FDeviseState.FabNumber)]);
    end;
  end;
(*
    if Length(SR)>=31 then
    begin
      FDeviseState.KssNumber:=BCDToInt(byte(SR[3])); //<Кассир(1)>
      FDeviseState.NumberInHall:=BCDToInt(byte(SR[4])); //<Номер_в_зале(1)>

      y:=BCDToInt(byte(SR[5])); //<Дата_YMD(3)>
      m:=BCDToInt(byte(SR[6])); //<Дата_YMD(3)>
      d:=BCDToInt(byte(SR[7])); //<Дата_YMD(3)>
      if y<90 then y:=2000+y
      else y:=1900+y;

      h:=BCDToInt(byte(SR[8])); //<Время_HMS(3)>
      mm:=BCDToInt(byte(SR[9])); //<Время_HMS(3)>
      ss:=BCDToInt(byte(SR[10])); //<Время_HMS(3)>
      try
        TryEncodeDate(y, m, d, FDeviseState.KKMDate); //<Дата_YMD(3)>
        TryEncodeTime(h, mm, ss, 0, FDeviseState.KKMTime); //<Время_HMS(3)>
      finally
      end;

      FDeviseState.Flags:=byte(SR[11]);        //<Флаги(1)>
      FDeviseState.FabNumber:=byte(SR[12])*256*256*256 + byte(SR[13])*256*256+byte(SR[14])*256 + byte(SR[15]);   //<Заводской_номер(4)>
      FDeviseState.Model:=byte(SR[16]);// <Модель(1)>
      //FDeviseState.Version:=SR[17]+'.'+SR[18];   //<Версия_ПО_ККТ(2)>
      FDeviseState.Version:=SR[17]+'.'+SR[18];   //<Версия_ПО_ККТ(2)>
      FDeviseState.Mode:=byte(SR[19]);         //<Режим_работы(1)>
      FDeviseState.CheckNum:=BCDToInt(byte(SR[20])*256 + byte(SR[21]));  //<Номер_чека(2)>
      FDeviseState.NumSmena:=BCDToInt(byte(SR[22])*256 + byte(SR[23]));  //<Номер_смены(2)>
      FDeviseState.CheckState:=byte(SR[24]);   //<Состояние_чека(1)>
//      FDeviseState.CheckSum:Currency; //<Сумма_чека(5)>
      FDeviseState.DecimalSep:=byte(SR[30]);   //<Десятичная_точка(1)>
      FDeviseState.Port:=byte(SR[31]);         //<Порт(1)>

      FSubMode:=FDeviseState.Mode div 16;
      FMode:=FDeviseState.Mode mod 16;
      FCheckNumber:=FDeviseState.CheckNum;
      FCheckState:=FDeviseState.CheckState;

      FSessionOpened:=FDeviseState.Flags and 2 <> 0;
      FOutOfPaper:=FDeviseState.Flags and 8 <> 0;
      FCoverOpened:=FDeviseState.Flags and 32 <> 0;
      FBatteryLow:=FDeviseState.Flags and 128 <> 0;

      FECRDateTime:=FDeviseState.KKMDate + FDeviseState.KKMTime;
      if FDeviseState.FabNumber = $FFFFFFFF then
        FSerialNumber:=IntToHex(FDeviseState.FabNumber, 8)
      else
        FSerialNumber:=format('%-08d', [BCDToInt(FDeviseState.FabNumber)]);
    end;
  end;
*)
  DoneKKM;
  Result:=FErrorCode;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done GetStatus');
  {$ENDIF}
  SetLength(SR, 0);


{
"D"<Кассир(1)> <Номер_в_зале(1)> <Дата_YMD(3)>
<Время_HMS(3)> <Флаги(1)> <Заводской_номер(4)> <Модель(1)>
<Версия_ПО_ККТ(2)> <Режим_работы(1)> <Номер_чека(2)>
<Номер_смены(2)> <Состояние_чека(1)> <Сумма_чека(5)>
<Десятичная_точка(1)> <Порт(1)>
}
end;

function TAtollKKM.GetRegister: integer;
var
  S, SR:string;
  B, P1, P2:Char;

begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('GetRegister');
  {$ENDIF}
  if (FRegisterNumber in [1 .. 10]) then
  begin
    P1:=#0;
    P2:=#0;
    case FRegisterNumber of
      3:begin
          P1:=Char(FCheckType);
          P2:=Char(FTypeClose);
        end;
      1, 2, 6, 7:P1:=Char(FCheckType);
      //4, 5, 8, 9:
    end;
    InitKKM;
    if FSerialPort.LastError = sOK then
    begin
(*
      //"С"<Регистр (1)> <Параметр1 (1)> <Параметр2 (1)>.
      S:=MakeCommand(#$91+ Char(FRegisterNumber) + P1 + P2); //Считать регистр
      FSerialPort.SendBuffer(@S[1], Length(S));
*)
      ClearBufArray;
      ValueToBuf(FAccessPassword, 4);
      ByteToBuf($91);
      ByteToBuf(FRegisterNumber);
      ByteToBuf(Byte(P1));
      ByteToBuf(Byte(P2));
      MakeCommandBuf;
      SendCommandBuf;

      ReadACK;
      SendEOT;

      ReadENQ(45000);
      SendACK;

      SR:=LoadKKMData;

      SendACK;
      ReadEOT;
    end;
    DoneKKM;
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done GetRegister');
    {$ENDIF}

    if Length(SR)>3 then
    begin
      SetErrorCode(Byte(SR[3]));
      if FErrorCode = 0 then
      begin
        case FRegisterNumber of
          1 .. 5:
            begin
              if Length(SR)>=9 then
                FSumm:=BufBCDToInteger(SR[4], 6) / 100
              else
                FSumm:=0;
            end;
          6..9:
            begin
              if Length(SR)>=5 then
                FCount:=BufBCDToInteger(SR[4], 2)
              else
                FCount:=0;
            end;
          10:
            begin
              if Length(SR)>=10 then
                FSumm:=BufBCDToInteger(SR[4], 7) / 100
              else
                FSumm:=0;
            end;
        end;

      end;
    end
    else
      FErrorCode:=$FF;
    Result:=FErrorCode;
  end
  else
    raise EECRAtol.CreateDrv(Self, 3, 'GetRegister', [FRegisterNumber]);
end;

procedure TAtollKKM.BeginDocument;
begin

end;

function TAtollKKM.PrintString: integer;
begin
  { TODO : Необходимо реализовать поддержку атрибутов протокола 2.0 }
  PrintLine(FCaption);
  Result:=FErrorCode;
end;

procedure TAtollKKM.EndDocument;
begin

end;

function TAtollKKM.Registration: integer;
var
  //S, SR:string;
  S, SR, S1:RawByteString;
  B:Char;
begin
  if (FPrice <> 0) and (FQuantity<>0) then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Registration;');
    {$ENDIF}
    InitKKM;
    if FSerialPort.LastError = sOK then
    begin
      ClearBufArray;
      ValueToBuf(FAccessPassword, 4);
      ByteToBuf($52);
      ByteToBuf(Ord(FTestMode));
      ValueToBuf(trunc(FPrice * 100), 10);
      ValueToBuf(trunc(FQuantity * 1000), 10);
      ValueToBuf(FDepartment, 2);
      MakeCommandBuf;
      SendCommandBuf;

(*
      //"R" <Флаги(1)><Цена(5)><Количество(5)><Секция(1)>.
      //S:=MakeCommand(#$52+Char(FTestMode)+ValueToBCD(trunc(FPrice * 100), 10)+ValueToBCD(trunc(FQuantity * 1000), 10)+ValueToBCD(FDepartment, 2)); //Регистрация
      FSerialPort.SendBuffer(@S[1], Length(S));
*)
      ReadACK;
      SendEOT;

      ReadENQ;
      SendACK;

      SR:=LoadKKMData;

      SendACK;
      ReadEOT;

      SetErrorCode(Byte(SR[3]));
    end;
    DoneKKM;
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done Registration;');
    {$ENDIF}
    Result:=FErrorCode;
  end
  else
    raise EECRAtol.Create(Self, 0, FErrorCode,'Registration', 'Цена или Количество не могут быть нулевыми');
end;

function TAtollKKM.Payment: integer;
var
  S, SR:string;
  B:Char;
begin
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('RecalcCheck;');
  {$ENDIF}
  InitKKM;
  if FSerialPort.LastError = sOK then
  begin
(*
    //"Щ"<Флаги (1)><Тип оплаты (1)><Сумма (5)>
    S:=MakeCommand(#$99+Char(FTestMode)+char(FTypeClose)+ValueToBCD(trunc(FSumm * 100), 10)); //Регистрация
    FSerialPort.SendBuffer(@S[1], Length(S));
*)
    ClearBufArray;
    ValueToBuf(FAccessPassword, 4);
    ByteToBuf($99);
    ByteToBuf(Ord(FTestMode));
    ByteToBuf(FTypeClose);
    ValueToBuf(trunc(FSumm * 100), 10);
    MakeCommandBuf;
    SendCommandBuf;


    ReadACK;
    SendEOT;

    ReadENQ;
    SendACK;

    SR:=LoadKKMData;

    SendACK;
    ReadEOT;

    SetErrorCode(Byte(SR[3]));
  end;
  DoneKKM;
  {$IFDEF DEBUG_KKM_DRV}
  WriteLog('Done RecalcCheck;');
  {$ENDIF}
  Result:=FErrorCode;
end;

function TAtollKKM.Storno: integer;
var
  S, SR:string;
  B:Char;
begin
  if (FPrice <> 0) and (FQuantity<>0) then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Storno;');
    {$ENDIF}
    InitKKM;
    if FSerialPort.LastError = sOK then
    begin
(*
      //"N" <Флаги(1)><Цена(5)><Количество(5)><Секция(1)>.
      S:=MakeCommand(#$4E+Char(FTestMode)+ValueToBCD(trunc(FPrice * 100), 10)+ValueToBCD(trunc(FQuantity * 1000), 10)+ValueToBCD(FDepartment, 2)); //Сторно
      FSerialPort.SendBuffer(@S[1], Length(S));
*)
      ClearBufArray;
      ValueToBuf(FAccessPassword, 4);
      ByteToBuf($4E);
      ByteToBuf(Ord(FTestMode));
      ValueToBuf(trunc(FPrice * 100), 10);
      ValueToBuf(trunc(FQuantity * 1000), 10);
      ValueToBuf(FDepartment, 2);
      MakeCommandBuf;
      SendCommandBuf;

      ReadACK;
      SendEOT;

      ReadENQ;
      SendACK;

      SR:=LoadKKMData;

      SendACK;
      ReadEOT;

      SetErrorCode(Byte(SR[3]));
    end;
    DoneKKM;
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done Storno;');
    {$ENDIF}
    Result:=FErrorCode;
  end
  else
    raise EECRAtol.Create(Self, 0, FErrorCode, 'Storno', 'Цена или Количество не могут быть нулевыми');
end;

function TAtollKKM.Return: integer;
var
  S, SR:string;
  B:Char;
begin
  if (FPrice <> 0) and (FQuantity<>0) then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Return;');
    {$ENDIF}
    InitKKM;
    if FSerialPort.LastError = sOK then
    begin
(*
      //"N" <Флаги(1)><Цена(5)><Количество(5)><Секция(1)>.
      S:=MakeCommand(#$57+Char(FTestMode)+ValueToBCD(trunc(FPrice * 100), 10)+ValueToBCD(trunc(FQuantity * 1000), 10)); //Возврат
      FSerialPort.SendBuffer(@S[1], Length(S));
*)
      ClearBufArray;
      ValueToBuf(FAccessPassword, 4);
      ByteToBuf($57);
      ByteToBuf(Ord(FTestMode));
      ValueToBuf(trunc(FPrice * 100), 10);
      ValueToBuf(trunc(FQuantity * 1000), 10);
      MakeCommandBuf;
      SendCommandBuf;

      ReadACK;
      SendEOT;

      ReadENQ;
      SendACK;

      SR:=LoadKKMData;

      SendACK;
      ReadEOT;

      SetErrorCode(Byte(SR[3]));
    end;
    DoneKKM;
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done Return;');
    {$ENDIF}
    Result:=FErrorCode;
  end
  else
    raise EECRAtol.Create(Self, 0, FErrorCode, 'Return', 'Цена или Количество не могут быть нулевыми');
end;

function TAtollKKM.CashIncome: integer;
var
  S, SR:string;
  B:Char;
begin
  if (FSumm > 0)then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('CashIncome');
    {$ENDIF}
    InitKKM;
    if FSerialPort.LastError = sOK then
    begin
(*
      //"I" <Флаги(1)><Сумма(5)>.
      S:=MakeCommand(#$49+Char(FTestMode)+ValueToBCD(trunc(FSumm * 100), 10)); //Внесение денег
      FSerialPort.SendBuffer(@S[1], Length(S));
*)
      ClearBufArray;
      ValueToBuf(FAccessPassword, 4);
      ByteToBuf($49);
      ByteToBuf(Ord(FTestMode));
      ValueToBuf(trunc(FSumm * 100), 10);
      MakeCommandBuf;
      SendCommandBuf;

      ReadACK;
      SendEOT;

      ReadENQ(20000); //Таймаут для суммы внесения
      SendACK;

      SR:=LoadKKMData;

      SendACK;
      ReadEOT;

      SetErrorCode(Byte(SR[3]));
    end;
    DoneKKM;
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done CashIncome;');
    {$ENDIF}
    Result:=FErrorCode;
  end
  else
    raise EECRAtol.CreateDrv(Self, 4, 'CashIncome', []);
end;

function TAtollKKM.CashOutcome: integer;
var
  S, SR:string;
  B:Char;
begin
  if (FSumm > 0)then
  begin
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('CashOutcome');
    {$ENDIF}
    InitKKM;
    if FSerialPort.LastError = sOK then
    begin
(*
      //"O" <Флаги(1)><Сумма(5)>.
      S:=MakeCommand(#$4F+Char(FTestMode)+ValueToBCD(trunc(FSumm * 100), 10)); //Выплата денег
      FSerialPort.SendBuffer(@S[1], Length(S));
*)
      ClearBufArray;
      ValueToBuf(FAccessPassword, 4);
      ByteToBuf($4F);
      ByteToBuf(Ord(FTestMode));
      ValueToBuf(trunc(FSumm * 100), 10);
      MakeCommandBuf;
      SendCommandBuf;

      ReadACK;
      SendEOT;

      ReadENQ(20000); //Таймаут для суммы выдачи
      SendACK;

      SR:=LoadKKMData;

      SendACK;
      ReadEOT;

      SetErrorCode(Byte(SR[3]));
    end;
    DoneKKM;
    {$IFDEF DEBUG_KKM_DRV}
    WriteLog('Done CashOutcome');
    {$ENDIF}
    Result:=FErrorCode;
  end
  else
    raise EECRAtol.CreateDrv(Self, 5, 'CashOutcome', []);
end;

function TAtollKKM.ShowProperties: boolean;
begin
  kkmAtolPropsForm:=TkkmAtolPropsForm.Create(Application);
  kkmAtolPropsForm.cbPortList.Text:=FPortName;
  kkmAtolPropsForm.rgPortSpeed.ItemIndex:=FPortSpeed;
  kkmAtolPropsForm.ECR:=Self;
  Result:=kkmAtolPropsForm.ShowModal = mrOk;
  if Result then
  begin
    FPortName:=kkmAtolPropsForm.cbPortList.Text;
    FPortSpeed:=kkmAtolPropsForm.rgPortSpeed.ItemIndex;
  end;
  kkmAtolPropsForm.Free;
end;

end.

