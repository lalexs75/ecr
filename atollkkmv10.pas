unit AtollKKMv10;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, libfptr10, CasheRegisterAbstract;

type

  EAtollLibrary = class(ECashRegisterAbstract);

  { TAtollLibraryV10 }

  TAtollLibraryV10 = class
  private
    FAtollLib: TLibHandle;
    FLibraryName: string;
    //
    Flibfptr_create:Tlibfptr_create;
    Flibfptr_destroy:Tlibfptr_destroy;
    Flibfptr_error_code:Tlibfptr_error_code;
    Flibfptr_error_description:Tlibfptr_error_description;

    Flibfptr_open:Tlibfptr_open;
    Flibfptr_close:Tlibfptr_close;
    Flibfptr_is_opened:Tlibfptr_is_opened;
    Flibfptr_beep:Tlibfptr_beep;
    Flibfptr_get_version_string:Tlibfptr_get_version_string;

    Flibfptr_open_drawer:Tlibfptr_open_drawer;

    //get
    Flibfptr_get_param_bool:Tlibfptr_get_param_bool;
    Flibfptr_get_param_int:Tlibfptr_get_param_int;
    Flibfptr_get_settings:Tlibfptr_get_settings;
    Flibfptr_get_single_setting:Tlibfptr_get_single_setting;
    Flibfptr_get_param_double:Tlibfptr_get_param_double;
    Flibfptr_get_param_str:Tlibfptr_get_param_str;
    Flibfptr_get_param_datetime:Tlibfptr_get_param_datetime;
    Flibfptr_get_param_bytearray:Tlibfptr_get_param_bytearray;

    //set
    Flibfptr_set_param_bool:Tlibfptr_set_param_bool;
    Flibfptr_set_settings:Tlibfptr_set_settings;
    Flibfptr_set_param_int:Tlibfptr_set_param_int;
    Flibfptr_set_param_double:Tlibfptr_set_param_double;
    Flibfptr_set_param_str:Tlibfptr_set_param_str;
    Flibfptr_set_param_datetime:Tlibfptr_set_param_datetime;
    Flibfptr_set_param_bytearray:Tlibfptr_set_param_bytearray;

    Flibfptr_set_single_setting:Tlibfptr_set_single_setting;
    Flibfptr_apply_single_settings:Tlibfptr_apply_single_settings;
    Flibfptr_reset_params:Tlibfptr_reset_params;
    Flibfptr_run_command:Tlibfptr_run_command;
    Flibfptr_cut:Tlibfptr_cut;
    Flibfptr_device_poweroff:Tlibfptr_device_poweroff;
    Flibfptr_device_reboot:Tlibfptr_device_reboot;
    Flibfptr_open_shift:Tlibfptr_open_shift;
    Flibfptr_reset_summary:Tlibfptr_reset_summary;

    Flibfptr_init_device:Tlibfptr_init_device;
    Flibfptr_query_data:Tlibfptr_query_data;
    Flibfptr_cash_income:Tlibfptr_cash_income;
    Flibfptr_cash_outcome:Tlibfptr_cash_outcome;

    Flibfptr_open_receipt:Tlibfptr_open_receipt;
    Flibfptr_cancel_receipt:Tlibfptr_cancel_receipt;
    Flibfptr_close_receipt:Tlibfptr_close_receipt;
    Flibfptr_check_document_closed:Tlibfptr_check_document_closed;
    Flibfptr_receipt_total:Tlibfptr_receipt_total;
    Flibfptr_receipt_tax:Tlibfptr_receipt_tax;
    Flibfptr_registration:Tlibfptr_registration;
    Flibfptr_payment:Tlibfptr_payment;
    Flibfptr_report:Tlibfptr_report;
    Flibfptr_print_text:Tlibfptr_print_text;
    Flibfptr_print_cliche:Tlibfptr_print_cliche;
    Flibfptr_begin_nonfiscal_document:Tlibfptr_begin_nonfiscal_document;
    Flibfptr_end_nonfiscal_document:Tlibfptr_end_nonfiscal_document;
    Flibfptr_print_barcode:Tlibfptr_print_barcode;
    Flibfptr_print_picture:Tlibfptr_print_picture;
    Flibfptr_print_picture_by_number:Tlibfptr_print_picture_by_number;
    Flibfptr_upload_picture_from_file:Tlibfptr_upload_picture_from_file;
    Flibfptr_clear_pictures:Tlibfptr_clear_pictures;
    Flibfptr_write_device_setting_raw:Tlibfptr_write_device_setting_raw;
    Flibfptr_read_device_setting_raw:Tlibfptr_read_device_setting_raw;
    Flibfptr_commit_settings:Tlibfptr_commit_settings;
    Flibfptr_init_settings:Tlibfptr_init_settings;
    Flibfptr_reset_settings:Tlibfptr_reset_settings;
    Flibfptr_write_date_time:Tlibfptr_write_date_time;
    Flibfptr_write_license:Tlibfptr_write_license;
    Flibfptr_fn_operation:Tlibfptr_fn_operation;

    //
    Flibfptr_fn_query_data:Tlibfptr_fn_query_data;
    Flibfptr_fn_write_attributes:Tlibfptr_fn_write_attributes;
    Flibfptr_external_device_power_on:Tlibfptr_external_device_power_on;
    Flibfptr_external_device_power_off:Tlibfptr_external_device_power_off;
    Flibfptr_external_device_write_data:Tlibfptr_external_device_write_data;
    Flibfptr_external_device_read_data:Tlibfptr_external_device_read_data;
    Flibfptr_operator_login:Tlibfptr_operator_login;
    Flibfptr_process_json:Tlibfptr_process_json;
    Flibfptr_read_device_setting:Tlibfptr_read_device_setting;
    Flibfptr_write_device_setting:Tlibfptr_write_device_setting;
    Flibfptr_begin_read_records:Tlibfptr_begin_read_records;
    Flibfptr_read_next_record:Tlibfptr_read_next_record;
    Flibfptr_end_read_records:Tlibfptr_end_read_records;
    Flibfptr_user_memory_operation:Tlibfptr_user_memory_operation;
    Flibfptr_continue_print:Tlibfptr_continue_print;
    Flibfptr_init_mgm:Tlibfptr_init_mgm;
    Flibfptr_util_form_tlv:Tlibfptr_util_form_tlv;
    Flibfptr_util_mapping:Tlibfptr_util_mapping;
    Flibfptr_util_form_nomenclature:Tlibfptr_util_form_nomenclature;
    Flibfptr_log_write:Tlibfptr_log_write;
    //v10.3.1
    Flibfptr_show_properties:Tlibfptr_show_properties;
    Flibfptr_read_model_flags:Tlibfptr_read_model_flags;
    //v10.4.0
    Flibfptr_line_feed:Tlibfptr_line_feed;
    Flibfptr_flash_firmware:Tlibfptr_flash_firmware;

    //v10.4.1
    Flibfptr_set_non_printable_param_bool:Tlibfptr_set_non_printable_param_bool;
    Flibfptr_set_non_printable_param_int:Tlibfptr_set_non_printable_param_int;
    Flibfptr_set_non_printable_param_double:Tlibfptr_set_non_printable_param_double;
    Flibfptr_set_non_printable_param_str:Tlibfptr_set_non_printable_param_str;
    Flibfptr_set_non_printable_param_datetime:Tlibfptr_set_non_printable_param_datetime;
    Flibfptr_set_non_printable_param_bytearray:Tlibfptr_set_non_printable_param_bytearray;

    //v10.4.2
    Flibfptr_soft_lock_init:Tlibfptr_soft_lock_init;
    Flibfptr_soft_lock_query_session_code:Tlibfptr_soft_lock_query_session_code;
    Flibfptr_soft_lock_validate:Tlibfptr_soft_lock_validate;
    Flibfptr_util_calc_tax:Tlibfptr_util_calc_tax;

    function GetLoaded: boolean;
    function IsLibraryNameStored: Boolean;
    procedure InternalClearProcAdress;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadAtollLibrary;
    function Unload: Boolean; virtual;
    property Loaded:boolean read GetLoaded;

    function CreateHandle(var Handle:TLibFPtrHandle):Integer;
    procedure DestroyHandle(var Handle:TLibFPtrHandle);
    function ErrorCode(Handle:TLibFPtrHandle):Integer;
    function ErrorDescription(Handle: TLibFPtrHandle): UTF8String;

    function OpenDrawer(Handle: TLibFPtrHandle):Integer;

    function Open(Handle: TLibFPtrHandle):Integer;
    function Close(Handle: TLibFPtrHandle):Integer;
    function IsOpened(Handle: TLibFPtrHandle):Integer;
    function Beep(Handle: TLibFPtrHandle):Integer;
    function GetVersionString:string;
    function RunCommand(Handle:TLibFPtrHandle):Integer;
    function Cut(Handle:TLibFPtrHandle):Integer;
    function DevicePowerOff(Handle:TLibFPtrHandle):Integer;
    function DeviceReboot(Handle:TLibFPtrHandle):Integer;
    function OpenShift(Handle:TLibFPtrHandle):Integer;
    function ResetSummary(Handle:TLibFPtrHandle):Integer;
    function InitDevice(Handle:TLibFPtrHandle):Integer;
    function QueryData(Handle:TLibFPtrHandle):Integer;
    function CashIncome(Handle:TLibFPtrHandle):Integer;
    function CashOutcome(Handle:TLibFPtrHandle):Integer;

    function OpenReceipt(Handle:TLibFPtrHandle):Integer;
    function CancelReceipt(Handle:TLibFPtrHandle):Integer;
    function CloseReceipt(Handle:TLibFPtrHandle):Integer;
    function CheckCocumentClosed(Handle:TLibFPtrHandle):Integer;
    function ReceiptTotal(Handle:TLibFPtrHandle):Integer;
    function ReceiptTax(Handle:TLibFPtrHandle):Integer;
    function Registration(Handle:TLibFPtrHandle):Integer;
    function Payment(Handle:TLibFPtrHandle):Integer;
    function Report(Handle:TLibFPtrHandle):Integer;
    function PrintText(Handle:TLibFPtrHandle):Integer;
    function PrintCliche(Handle:TLibFPtrHandle):Integer;
    function BeginNonfiscalDocument(Handle:TLibFPtrHandle):Integer;
    function EndNonfiscalDocument(Handle:TLibFPtrHandle):Integer;
    function PrintBarcode(Handle:TLibFPtrHandle):Integer;
    function PrintPicture(Handle:TLibFPtrHandle):Integer;
    function PrintPictureByNumber(Handle:TLibFPtrHandle):Integer;
    function UploadPictureFromFile(Handle:TLibFPtrHandle):Integer;
    function ClearPictures(Handle:TLibFPtrHandle):Integer;
    function WriteDeviceSettingRaw(Handle:TLibFPtrHandle):Integer;
    function ReadDeviceSettingRaw(Handle:TLibFPtrHandle):Integer;
    function CommitSettings(Handle:TLibFPtrHandle):Integer;
    function InitSettings(Handle:TLibFPtrHandle):Integer;
    function ResetSettings(Handle:TLibFPtrHandle):Integer;
    function WriteDateTime(Handle:TLibFPtrHandle):Integer;
    function WriteLicense(Handle:TLibFPtrHandle):Integer;

    function fnOperation(Handle:TLibFPtrHandle):Integer;
    function fnQueryData(Handle:TLibFPtrHandle):Integer;
    function fnWriteAttributes(Handle:TLibFPtrHandle):Integer;
    function ExternalDevicePowerOn(Handle:TLibFPtrHandle):Integer;
    function ExternalDevicePowerOff(Handle:TLibFPtrHandle):Integer;
    function ExternalDeviceWriteData(Handle:TLibFPtrHandle):Integer;
    function ExternalDeviceReadData(Handle:TLibFPtrHandle):Integer;
    function OperatorLogin(Handle:TLibFPtrHandle):Integer;
    function ProcessJSON(Handle:TLibFPtrHandle):Integer;
    function ReadDeviceSetting(Handle:TLibFPtrHandle):Integer;
    function WriteDeviceSetting(Handle:TLibFPtrHandle):Integer;
    function BeginReadRecords(Handle:TLibFPtrHandle):Integer;
    function ReadNextRecord(Handle:TLibFPtrHandle):Integer;
    function EndReadRecords(Handle:TLibFPtrHandle):Integer;
    function UserMemoryOperation(Handle:TLibFPtrHandle):Integer;
    function ContinuePrint(Handle:TLibFPtrHandle):Integer;
    function InitMGM(Handle:TLibFPtrHandle):Integer;
    function UtilFormTLV(Handle:TLibFPtrHandle):Integer;
    function UtilMapping(Handle:TLibFPtrHandle):Integer;
    function UtilFormNomenclature(Handle:TLibFPtrHandle):Integer;

    function GetSettings(Handle: TLibFPtrHandle):UTF8String;
    function GetSingleSetting(Handle: TLibFPtrHandle; Key:string):string;

    function GetParamBool(Handle: TLibFPtrHandle; Param_id: integer): Boolean;
    function GetParamInt(Handle:TLibFPtrHandle; Param_id:integer):integer;
    function GetParamDouble(Handle:TLibFPtrHandle; Param_id:integer):Double;
    function GetParamStr(Handle:TLibFPtrHandle; Param_id:integer):string;
    function GetParamDateTime(Handle:TLibFPtrHandle; Param_id:integer):TDateTime;
    function GetParamByteArray(Handle: TLibFPtrHandle; Param_id: integer): TBytes;

    procedure SetSingleSetting(Handle:PLibFPtrHandle; Key, Value:string);
    function  ApplySingleSettings(Handle:PLibFPtrHandle):Integer;

    procedure SetParamBool(Handle: TLibFPtrHandle; ParamId:Integer; Value:Boolean);
    procedure SetParamInt(Handle: TLibFPtrHandle; ParamId:Tlibfptr_param; Value:Integer);
    procedure SetParamDouble(Handle: TLibFPtrHandle; ParamId:Integer; Value:Double);
    procedure SetParamStr(Handle: TLibFPtrHandle; ParamId:Integer; Value:string);
    procedure SetParamDateTime(Handle: TLibFPtrHandle; ParamId:Integer; Value:TDateTime);
    procedure SetParamByteArray(Handle: TLibFPtrHandle; ParamId: Integer; const Value: TBytes);
    function SetSettings(Handle:TLibFPtrHandle; Settings:string):Integer;
    function ResetParams(Handle:TLibFPtrHandle):Integer;
    function LogWrite(Tag:string; Level:Integer; Message:string):Integer;
    //ver 10.3.1
    function ReadModelFlags(Handle:TLibFPtrHandle):Integer;
    function ShowProperties(Handle:TLibFPtrHandle; ParentType:Tlibfptr_gui_parent; Parent:Pointer):Integer;
    //ver 10.4.0
    function LineFeed(Handle:TLibFPtrHandle):Integer;
    function FlashFirmware(Handle:TLibFPtrHandle):Integer;
    //ver 10.4.1
    procedure SetNonPrintableParamBool(Handle:TLibFPtrHandle; ParamId:Integer; Value:Boolean);
    procedure SetNonPrintableParamInt(Handle:TLibFPtrHandle; ParamId:Integer; Value:Cardinal);
    procedure SetNonPrintableParamDouble(Handle:TLibFPtrHandle; ParamId:Integer; Value:Double);
    procedure SetNonPrintableParamStr(Handle:TLibFPtrHandle; ParamId:Integer; Value:string);
    procedure SetNonPrintableParamDateTime(Handle: TLibFPtrHandle; ParamId:Integer; Value:TDateTime);
    procedure SetNonPrintableParamByteArray(Handle: TLibFPtrHandle; ParamId: Integer; const Value: TBytes);

    //ver 10.4.2
    function SoftLockInit(Handle:TLibFPtrHandle):Integer;
    function SoftLockQuerySessionCode(Handle:TLibFPtrHandle):Integer;
    function SoftLockValidate(Handle:TLibFPtrHandle):Integer;
    function UtilCalcTax(Handle:TLibFPtrHandle):Integer;
  published
    property LibraryName:string read FLibraryName write FLibraryName stored IsLibraryNameStored;
  end;


  { TAtollKKMv10 }

  TAtollKKMv10 = class(TCashRegisterAbstract)
  private
    FLibrary:TAtollLibraryV10;
    FHandle:TLibFPtrHandle;
    FLibraryFileName: string;
    function GetDeviceDateTime: TDateTime;
    procedure InternalUserLogin;
    procedure InternalInitLibrary;
    procedure InternalOpenKKM;
    procedure InternalCloseKKM;
    function InternalCheckError:Integer;
    procedure InternalSetCheckType(AValue: TCheckType);
  protected
    function GetConnected: boolean; override;
    procedure SetConnected(AValue: boolean); override;

    function GetCheckNumber: integer; override;
    //function GetCheckType: TCheckType; override;
    //procedure SetCheckType(AValue: TCheckType); override;
  public
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    procedure Beep; override;
    procedure CutCheck(APartial:boolean); override;
    procedure PrintLine(ALine:string); override;        //Печать строки
    procedure PrintClishe; override;

    //Отперации со сменой
    procedure OpenShift; override;                      //Открыть смену

    //Внесения и выплаты
    function CashIncome(APaymentSum:Currency):integer; override;          //Внесение денег
    function CashOutcome(APaymentSum:Currency):integer; override;         //Выплата денег

    //Операции с чеком
    procedure OpenCheck; override;
    function CloseCheck:Integer; override;              //Закрыть чек (со сдачей)
    function CancelCheck:integer; override;             //Аннулирование всего чека
    function Registration:integer; override;
    function ReceiptTotal:integer; override;
    function Payment:integer; override;

    procedure RegisterPayment(APaymentType:TPaymentType; APaymentSum:Currency); override;

    procedure SetAttributeInt(AttribNum, AttribValue:Integer); override;
    procedure SetAttributeStr(AttribNum:Integer; AttribValue:string); override;
    procedure SetAttributeBool(AttribNum:Integer; AttribValue:Boolean); override;
    procedure SetAttributeDouble(AttribNum:Integer; AttribValue:Double); override;

(*


    Общая информация
    Настройки логирования
    Начало работы с драйвером
    Обработка ошибок
    Соединение с ККТ
    Запрос информации о ККТ
    Регистрация кассира
    Операции со сменой
    Внесения и выплаты
    Запрос информации из ФН
    Регистрация ККТ
    Перерегистрация ККТ
    Замена ФН
    Закрытие архива ФН
    Нефискальная печать
    Чтение данных
    Служебные операции
    Прочие методы
    Программирование ККТ
    JSON-задания
    Приложение
    Настройки ККТ
    Android Service
    Web-сервер*)
    //Отчёты
(*
        Копия последнего документа
        Отчет о состоянии расчетов
        Печать информации о ККТ
        Диагностика соединения с ОФД
        Печать документа из архива ФН
        Отчет по кассирам
        Печать итогов регистрации / перерегистрации
        Счетчики итогов смены
        Счетчики итогов ФН
        Счетчики по непереданным документам
        Отчет по товарам по СНО
        Отчет по товарам по отделам
        Отчет по товарам по суммам
        Начать служебный отчет
*)
    procedure ReportX(AReportType: Byte); override;     //X-отчет
    procedure ReportZ; override;
    procedure PrintReportHours; override;               //Отчет по часам
    procedure PrintReportSection; override;             //Отчет по секциям
    procedure PrintReportCounted; override;             //Отчет количеств
    procedure DemoPrint; override;                      //Демо-печать

    function NonNullableSum:Currency;                   //Не обнуляемая сумма - приход - наличка
    function NonNullableSum(AChekType:Tlibfptr_receipt_type; APaymentType:Tlibfptr_payment_type):Currency;

    function ShowProperties:boolean; override;          //Отобразить окно параметров ККМ

    //Вспомогательное
    procedure OpenDrawer;
  public
    property Handle:TLibFPtrHandle read FHandle;
    property LibraryFileName:string read FLibraryFileName write FLibraryFileName;
    property DeviceDateTime:TDateTime read GetDeviceDateTime;
  end;

resourcestring
  sCantLoadProc = 'Can''t load procedure "%s"';

function TaxTypeToAtollTT(AValue:TTaxType):Tlibfptr_tax_type;
implementation

function TaxTypeToAtollTT(AValue: TTaxType): Tlibfptr_tax_type;
begin
  case AValue of
    ttaxDefault:Result:=LIBFPTR_TAX_DEPARTMENT;
    ttaxVat18:Result:=LIBFPTR_TAX_VAT18;
    ttaxVat10:Result:=LIBFPTR_TAX_VAT10;
    ttaxVat118:Result:=LIBFPTR_TAX_VAT118;
    ttaxVat110:Result:=LIBFPTR_TAX_VAT110;
    ttaxVat0:Result:=LIBFPTR_TAX_VAT0;
    ttaxVatNO:Result:=LIBFPTR_TAX_NO;
  else
    raise EAtollLibrary.Create('Не известный тип налога');
  end;
end;

{ TAtollKKMv10 }

procedure TAtollKKMv10.InternalUserLogin;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamStr(FHandle, 1021, UserName);
{    if Password<>'' then
      FLibrary.SetParamStr(FHandle, 1203, Password);}

    if KassaUserINN <> '' then
      FLibrary.SetParamStr(FHandle, 1203, KassaUserINN);
    FLibrary.OperatorLogin(FHandle);
    //todo: do check error
  end;
end;

function TAtollKKMv10.GetDeviceDateTime: TDateTime;
begin
  if Assigned(FLibrary) and FLibrary.Loaded and Assigned(FHandle) then
  begin
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_DATA_TYPE, Ord(LIBFPTR_DT_STATUS));
    FLibrary.QueryData(FHandle);
    Result:=FLibrary.GetParamDateTime(FHandle, Ord(LIBFPTR_PARAM_DATE_TIME));
  end
  else
    raise EAtollLibrary.Create('Необходимо активировать подключение к ККМ');
end;

procedure TAtollKKMv10.InternalInitLibrary;
begin
  if Assigned(FLibrary) then Exit;
  FLibrary:=TAtollLibraryV10.Create;
  if FLibraryFileName <> '' then
    FLibrary.LibraryName:=FLibraryFileName;
  FLibrary.LoadAtollLibrary;
end;

procedure TAtollKKMv10.InternalOpenKKM;
begin
  FLibrary.Open(FHandle);
end;

procedure TAtollKKMv10.InternalCloseKKM;
begin
  FLibrary.Close(FHandle);
  FHandle:=nil;
end;

function TAtollKKMv10.InternalCheckError: Integer;
begin
  Result:=FLibrary.ErrorCode(Handle);
  if Result <> 0 then
    SetError(Result, FLibrary.ErrorDescription(Handle))
  else
    ClearError;
end;

procedure TAtollKKMv10.InternalSetCheckType(AValue: TCheckType);
var
  CT: Tlibfptr_receipt_type;
  FE: Integer;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    case AValue of
      chtSell:CT:=LIBFPTR_RT_SELL;
      chtSellReturn:CT:=LIBFPTR_RT_SELL_RETURN;
      chtSellCorrection:CT:=LIBFPTR_RT_SELL_CORRECTION;
      chtSellReturnCorrection:CT:=LIBFPTR_RT_SELL_RETURN_CORRECTION;
      chtBuy:CT:=LIBFPTR_RT_BUY;
      chtBuyReturn:CT:=LIBFPTR_RT_BUY_RETURN;
      chtBuyCorrection:CT:=LIBFPTR_RT_BUY_CORRECTION;
      chtBuyReturnCorrection:CT:=LIBFPTR_RT_BUY_RETURN_CORRECTION;
    else
      raise EAtollLibrary.Create('Не изестный тип чека');
    end;
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_RECEIPT_TYPE, Ord(CT));
    InternalCheckError;
  end;
end;

function TAtollKKMv10.GetConnected: boolean;
begin
  Result:=Assigned(FHandle);
end;

procedure TAtollKKMv10.SetConnected(AValue: boolean);
var
  R: Integer;
begin
  if AValue = GetConnected then Exit;
  if AValue then
  begin
    if not Assigned(FLibrary) then
      InternalInitLibrary;
    R:=FLibrary.CreateHandle(FHandle);
    if R <> 0 then
      raise EAtollLibrary.Create('Error create handle');
  end
  else
  begin
    if Assigned(FLibrary) then
      if Assigned(FHandle) then
        FLibrary.DestroyHandle(FHandle);
  end;
end;

function TAtollKKMv10.GetCheckNumber: integer;
begin
  Result:=0;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_DATA_TYPE, Ord(LIBFPTR_DT_RECEIPT_STATE));
    FLibrary.QueryData(FHandle);
    InternalCheckError;
    if ErrorCode = 0 then
      Result:=FLibrary.GetParamInt(FHandle, Ord(LIBFPTR_PARAM_RECEIPT_NUMBER));
  end;
end;
(*
function TAtollKKMv10.GetCheckType: TCheckType;
var
  FT: Tlibfptr_receipt_type;
begin
  Result:=chtNone;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_DATA_TYPE, Ord(LIBFPTR_DT_RECEIPT_STATE));
    FLibrary.QueryData(FHandle);
    FT:=Tlibfptr_receipt_type(FLibrary.GetParamInt(FHandle, Ord(LIBFPTR_PARAM_RECEIPT_TYPE)));

    case FT of
      LIBFPTR_RT_SELL:Result:=chtSell;
      LIBFPTR_RT_SELL_RETURN:Result:=chtSellReturn;
      LIBFPTR_RT_SELL_CORRECTION:Result:=chtSellCorrection;
      LIBFPTR_RT_SELL_RETURN_CORRECTION:Result:=chtSellReturnCorrection;
      LIBFPTR_RT_BUY:Result:=chtBuy;
      LIBFPTR_RT_BUY_RETURN:Result:=chtBuyReturn;
      LIBFPTR_RT_BUY_CORRECTION:Result:=chtBuyCorrection;
      LIBFPTR_RT_BUY_RETURN_CORRECTION:Result:=chtBuyReturnCorrection;
    else
      //LIBFPTR_RT_CLOSED = 0,
      Result:=chtNone;
    end;
  end;
end;

procedure TAtollKKMv10.SetCheckType(AValue: TCheckType);
var
  CT: Tlibfptr_receipt_type;
  FE: Integer;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    case AValue of
      chtSell:CT:=LIBFPTR_RT_SELL;
      chtSellReturn:CT:=LIBFPTR_RT_SELL_RETURN;
      chtSellCorrection:CT:=LIBFPTR_RT_SELL_CORRECTION;
      chtSellReturnCorrection:CT:=LIBFPTR_RT_SELL_RETURN_CORRECTION;
      chtBuy:CT:=LIBFPTR_RT_BUY;
      chtBuyReturn:CT:=LIBFPTR_RT_BUY_RETURN;
      chtBuyCorrection:CT:=LIBFPTR_RT_BUY_CORRECTION;
      chtBuyReturnCorrection:CT:=LIBFPTR_RT_BUY_RETURN_CORRECTION;
    else
      raise EAtollLibrary.Create('Не изестный тип чека');
    end;
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_RECEIPT_TYPE, Ord(CT));
    InternalCheckError;
  end;
  FCheckType:=AValue;
end;
*)
destructor TAtollKKMv10.Destroy;
begin
  Connected:=false;
  if Assigned(FLibrary) then
    FreeAndNil(FLibrary);
  inherited Destroy;
end;

procedure TAtollKKMv10.Open;
begin
  InternalOpenKKM;
  InternalUserLogin;
end;

procedure TAtollKKMv10.Close;
begin
  InternalCloseKKM;
end;

procedure TAtollKKMv10.Beep;
begin
  if Assigned(FLibrary) and FLibrary.Loaded and Assigned(FHandle) then
  begin
    FLibrary.Beep(FHandle);
    InternalCheckError;
  end
  else
    raise EAtollLibrary.Create('Необходимо активировать подключение к ККМ');
end;

procedure TAtollKKMv10.CutCheck(APartial: boolean);
begin
  if Assigned(FLibrary) and FLibrary.Loaded and Assigned(FHandle) then
  begin
(*
    Для отрезки чековой ленты необходимо вызвать метод cut(). Дополнительно можно указать тип отрезки в параметре LIBFPTR_PARAM_CUT_TYPE. Если параметр не указан, драйвер сам определит способ отрезки.

    Выравнивание LIBFPTR_PARAM_CUT_TYPE может принимать следующие значения:

        LIBFPTR_CT_FULL - полная отрезка
        LIBFPTR_CT_PART - частичная отрезка
*)
    if APartial then
      FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_CUT_TYPE, Ord(LIBFPTR_CT_PART))
    else
      FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_CUT_TYPE, Ord(LIBFPTR_CT_FULL));
    FLibrary.Cut(FHandle);
    InternalCheckError;
  end
  else
    raise EAtollLibrary.Create('Необходимо активировать подключение к ККМ');
end;

procedure TAtollKKMv10.PrintLine(ALine: string);
begin
  if Assigned(FLibrary) and FLibrary.Loaded and Assigned(FHandle) then
  begin
    FLibrary.SetParamStr(FHandle, Ord(LIBFPTR_PARAM_TEXT), ALine);
    //FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_ALIGNMENT, LIBFPTR_ALIGNMENT_CENTER);
    FLibrary.PrintText(FHandle);
    InternalCheckError;
  end
  else
    raise EAtollLibrary.Create('Необходимо активировать подключение к ККМ');
end;

procedure TAtollKKMv10.PrintClishe;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.PrintCliche(FHandle);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.OpenShift;
begin
  inherited OpenShift;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    InternalUserLogin;
{  libfptr_set_param_str(fptr, 1021, L"Кассир Иванов И.");
  libfptr_set_param_str(fptr, 1203, L"123456789047");
  libfptr_operator_login(fptr);}

    FLibrary.OpenShift(FHandle);

    //libfptr_check_document_closed();
    InternalCheckError;
  end;
end;

function TAtollKKMv10.CashIncome(APaymentSum: Currency): integer;
begin
  Result:=0;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    InternalUserLogin;
    SetAttributeDouble(Ord(LIBFPTR_PARAM_SUM), APaymentSum);
    Result:=FLibrary.CashIncome(FHandle);
    InternalCheckError;
  end;
end;

function TAtollKKMv10.CashOutcome(APaymentSum: Currency): integer;
begin
  Result:=0;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    InternalUserLogin;
    SetAttributeDouble(Ord(LIBFPTR_PARAM_SUM), APaymentSum);
    Result:=FLibrary.CashOutcome(FHandle);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.OpenCheck;
begin
  inherited OpenCheck;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    InternalUserLogin;

    InternalSetCheckType(CheckType);

    if CounteragentInfo.Name <> '' then
      SetAttributeStr(1227, CounteragentInfo.Name);
    if CounteragentInfo.Name <> '' then
      SetAttributeStr(1228, CounteragentInfo.INN);

    if CounteragentInfo.Email <> '' then
      SetAttributeStr(1008, CounteragentInfo.Email)
    else
    if CounteragentInfo.Phone <> '' then
      SetAttributeStr(1008, CounteragentInfo.Phone);

    if PaymentPlace<>'' then
      SetAttributeStr(1187, PaymentPlace);

    if CheckInfo.Electronically then
      FLibrary.SetParamBool(FHandle, Ord(LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY), CheckInfo.Electronically);

    FLibrary.OpenReceipt(FHandle);
    InternalCheckError;
  end;
end;

function TAtollKKMv10.Registration: integer;
var
  FSupInf: TBytes;
begin
  Result:=0;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    //Обработаем данные поставщика
    if (GoodsInfo.SuplierInfo.Name <> '') and (GoodsInfo.SuplierInfo.INN<>'') then
    begin
      if GoodsInfo.SuplierInfo.Phone <>'' then
        SetAttributeStr(1171, GoodsInfo.SuplierInfo.Phone); //libfptr_set_param_str(fptr, 1171, L"+79113456789");

      SetAttributeStr(1225, GoodsInfo.SuplierInfo.Name); //libfptr_set_param_str(fptr, 1225, L"ООО Поставщик");
      FLibrary.UtilFormTLV(FHandle);

(*      std::vector<uchar> suplierInfo;
      int size = libfptr_get_param_bytearray(fptr, LIBFPTR_PARAM_TAG_VALUE,
                                             &suplierInfo[0], suplierInfo.size());
      if (size > suplierInfo.size())
      {
          suplierInfo.resize(size);
          libfptr_get_param_bytearray(fptr, LIBFPTR_PARAM_TAG_VALUE,
                                      &suplierInfo[0], suplierInfo.size());
      }
      suplierInfo.resize(size); *)
      FSupInf:=FLibrary.GetParamByteArray(FHandle, Ord(LIBFPTR_PARAM_TAG_VALUE));

      SetAttributeStr(1226, GoodsInfo.SuplierInfo.INN);
      //libfptr_set_param_bytearray(fptr, 1224, &suplierInfo[0]. suplierInfo.size());
      FLibrary.SetParamByteArray(FHandle, 1224, FSupInf);
    end;

    //Регистрируем строку товара
    SetAttributeStr(Ord(LIBFPTR_PARAM_COMMODITY_NAME), GoodsInfo.Name);
    SetAttributeDouble(Ord(LIBFPTR_PARAM_PRICE), GoodsInfo.Price);
    SetAttributeDouble(Ord(LIBFPTR_PARAM_QUANTITY), GoodsInfo.Quantity);
    SetAttributeInt(Ord(LIBFPTR_PARAM_TAX_TYPE), Ord(TaxTypeToAtollTT(GoodsInfo.TaxType)));

    if (GoodsInfo.DeclarationNumber<> '') and (GoodsInfo.CountryCode > 0) then
    begin
      SetAttributeStr(1230, IntToStr(GoodsInfo.CountryCode));
      SetAttributeStr(1231, GoodsInfo.DeclarationNumber);
    end;

    if GoodsInfo.GoodsNomenclatureCode <> '' then
    begin
      //SetAttributeStr(1162, GoodsInfo.GoodsNomenclatureCode);
    end;

    case GoodsInfo.GoodsPayMode of
      //gpmFullPay:SetAttributeInt(1214, 0);
      gpmPrePay100:SetAttributeInt(1214, 1);
      gpmPrePay:SetAttributeInt(1214, 2);
      gpmAvance:SetAttributeInt(1214, 3);
      gpmFullPay2:SetAttributeInt(1214, 4);
      gpmPartialPayAndKredit:SetAttributeInt(1214, 5);
      gpmKredit:SetAttributeInt(1214, 6);
      gpmKreditPay:SetAttributeInt(1214, 7);
    end;
    //Сама регистрация
    Result:=FLibrary.Registration(FHandle);
    InternalCheckError;
  end;
  inherited Registration;
end;

function TAtollKKMv10.ReceiptTotal: integer;
begin
  Result:=0;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    Result:=FLibrary.ReceiptTotal(FHandle);
    InternalCheckError;
  end;
end;

function TAtollKKMv10.Payment: integer;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.Payment(FHandle);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.RegisterPayment(APaymentType: TPaymentType;
  APaymentSum: Currency);
var
  FPT: Tlibfptr_payment_type;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    case APaymentType of
      pctCash:FPT:=LIBFPTR_PT_CASH;                     //наличный
      pctElectronically:FPT:=LIBFPTR_PT_ELECTRONICALLY; //электронный
      pctPrePaid:FPT:=LIBFPTR_PT_PREPAID;               //предварительная оплата (аванс)
      pctCredit:FPT:=LIBFPTR_PT_CREDIT;                 //последующая оплата (кредит)
      pctOther:FPT:=LIBFPTR_PT_OTHER;                   //иная форма оплаты (встречное предоставление)
      pctOther_6:FPT:=LIBFPTR_PT_6;                     //тип оплаты №6
      pctOther_7:FPT:=LIBFPTR_PT_7;                     //тип оплаты №7
      pctOther_8:FPT:=LIBFPTR_PT_8;                     //тип оплаты №8
      pctOther_9:FPT:=LIBFPTR_PT_9;                     //тип оплаты №9
      pctOther_10:FPT:=LIBFPTR_PT_10;                   //тип оплаты №10
    else
      raise EAtollLibrary.Create('Не известный тип оплаты');
    end;

    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(FPT));
    FLibrary.SetParamDouble(FHandle, Ord(LIBFPTR_PARAM_PAYMENT_SUM), APaymentSum);
    FLibrary.Payment(FHandle);
  end;
end;

procedure TAtollKKMv10.SetAttributeInt(AttribNum, AttribValue: Integer);
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamInt(FHandle, Tlibfptr_param(AttribNum), AttribValue);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.SetAttributeStr(AttribNum: Integer; AttribValue: string);
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamStr(FHandle, AttribNum, AttribValue);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.SetAttributeBool(AttribNum: Integer; AttribValue: Boolean
  );
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamBool(FHandle, AttribNum, AttribValue);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.SetAttributeDouble(AttribNum: Integer;
  AttribValue: Double);
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamDouble(FHandle, AttribNum, AttribValue);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.DemoPrint;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_REPORT_TYPE, ord(LIBFPTR_RT_KKT_DEMO));
    FLibrary.Report(FHandle);
    InternalCheckError;
  end;
end;

function TAtollKKMv10.NonNullableSum: Currency;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_DATA_TYPE, Ord(LIBFPTR_DT_NON_NULLABLE_SUM_BY_PAYMENTS));
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_RECEIPT_TYPE, Ord(LIBFPTR_RT_SELL));
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(LIBFPTR_PT_CASH));
    FLibrary.QueryData(FHandle);
    Result:=FLibrary.GetParamDouble(FHandle, Ord(LIBFPTR_PARAM_SUM));
    InternalCheckError;
  end;
end;

function TAtollKKMv10.NonNullableSum(AChekType: Tlibfptr_receipt_type;
  APaymentType: Tlibfptr_payment_type): Currency;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_DATA_TYPE, Ord(LIBFPTR_DT_NON_NULLABLE_SUM_BY_PAYMENTS));
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_RECEIPT_TYPE, Ord(AChekType));
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(APaymentType));
    FLibrary.QueryData(FHandle);
    Result:=FLibrary.GetParamDouble(FHandle, Ord(LIBFPTR_PARAM_SUM));
    InternalCheckError;
  end;
end;

function TAtollKKMv10.CloseCheck: Integer;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.CloseReceipt(FHandle);
    InternalCheckError;
  end;
  inherited CloseCheck;
end;

function TAtollKKMv10.CancelCheck: integer;
begin
  Result:=0;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.CancelReceipt(FHandle);
    InternalCheckError;
  end;
  inherited CancelCheck;
end;

function TAtollKKMv10.ShowProperties: boolean;
var
  FL: Boolean;
begin
  Result:=false;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FL:=Assigned(FHandle);
    if not FL then
      InternalOpenKKM;
    FLibrary.ShowProperties(FHandle, LIBFPTR_GUI_PARENT_NATIVE, nil);
    InternalCheckError;
    if not FL then
      InternalCloseKKM;
    Result:=true;
  end;
end;

procedure TAtollKKMv10.OpenDrawer;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
    FLibrary.OpenDrawer(FHandle);
end;

procedure TAtollKKMv10.ReportZ;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    //DoUserLogin;
    InternalUserLogin;
    //todo: печатать если логин успешеy - обработка ошибок нужна
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_REPORT_TYPE, Ord(LIBFPTR_RT_CLOSE_SHIFT));
    FLibrary.Report(FHandle);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.ReportX(AReportType: Byte);
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    //InternalOpenKKM;
    //DoUserLogin;
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_REPORT_TYPE, Ord(LIBFPTR_RT_X));
    FLibrary.Report(FHandle);
    InternalCheckError;
    //InternalCloseKKM;
  end;
end;

procedure TAtollKKMv10.PrintReportHours;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    InternalOpenKKM;
    InternalUserLogin;
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_REPORT_TYPE, Ord(LIBFPTR_RT_HOURS));
    FLibrary.Report(FHandle);
    InternalCheckError;
    InternalCloseKKM;
  end;
end;

procedure TAtollKKMv10.PrintReportSection;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    InternalUserLogin;
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_REPORT_TYPE, Ord(LIBFPTR_RT_DEPARTMENTS));
    FLibrary.Report(FHandle);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.PrintReportCounted;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    InternalUserLogin;
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_REPORT_TYPE, Ord(LIBFPTR_RT_QUANTITY));
    FLibrary.Report(FHandle);
    InternalCheckError;
  end;
end;

{ TAtollLibraryV10 }

function TAtollLibraryV10.IsLibraryNameStored: Boolean;
begin
  Result:=FLibraryName = slibFPPtr10FileName;
end;

procedure TAtollLibraryV10.InternalClearProcAdress;
begin
  Flibfptr_create:=nil;
  Flibfptr_destroy:=nil;
  Flibfptr_error_code:=nil;
  Flibfptr_error_description:=nil;
  Flibfptr_open_drawer:=nil;

  Flibfptr_open:=nil;
  Flibfptr_close:=nil;
  Flibfptr_is_opened:=nil;
  Flibfptr_beep:=nil;
  Flibfptr_get_version_string:=nil;
  Flibfptr_run_command:=nil;
  Flibfptr_cut:=nil;
  Flibfptr_device_poweroff:=nil;
  Flibfptr_device_reboot:=nil;
  Flibfptr_open_shift:=nil;
  Flibfptr_reset_summary:=nil;

  Flibfptr_init_device:=nil;
  Flibfptr_query_data:=nil;
  Flibfptr_cash_income:=nil;
  Flibfptr_cash_outcome:=nil;

  Flibfptr_open_receipt:=nil;
  Flibfptr_cancel_receipt:=nil;
  Flibfptr_close_receipt:=nil;
  Flibfptr_check_document_closed:=nil;
  Flibfptr_receipt_total:=nil;
  Flibfptr_receipt_tax:=nil;
  Flibfptr_registration:=nil;
  Flibfptr_payment:=nil;
  Flibfptr_report:=nil;
  Flibfptr_print_text:=nil;
  Flibfptr_print_cliche:=nil;
  Flibfptr_begin_nonfiscal_document:=nil;
  Flibfptr_end_nonfiscal_document:=nil;
  Flibfptr_print_barcode:=nil;
  Flibfptr_print_picture:=nil;
  Flibfptr_print_picture_by_number:=nil;
  Flibfptr_upload_picture_from_file:=nil;
  Flibfptr_clear_pictures:=nil;
  Flibfptr_write_device_setting_raw:=nil;
  Flibfptr_read_device_setting_raw:=nil;
  Flibfptr_commit_settings:=nil;
  Flibfptr_init_settings:=nil;
  Flibfptr_reset_settings:=nil;
  Flibfptr_write_date_time:=nil;
  Flibfptr_write_license:=nil;
  Flibfptr_fn_operation:=nil;

  Flibfptr_fn_query_data:=nil;
  Flibfptr_fn_write_attributes:=nil;
  Flibfptr_external_device_power_on:=nil;
  Flibfptr_external_device_power_off:=nil;
  Flibfptr_external_device_write_data:=nil;
  Flibfptr_external_device_read_data:=nil;
  Flibfptr_operator_login:=nil;
  Flibfptr_process_json:=nil;
  Flibfptr_read_device_setting:=nil;
  Flibfptr_write_device_setting:=nil;
  Flibfptr_begin_read_records:=nil;
  Flibfptr_read_next_record:=nil;
  Flibfptr_end_read_records:=nil;
  Flibfptr_user_memory_operation:=nil;
  Flibfptr_continue_print:=nil;
  Flibfptr_init_mgm:=nil;
  Flibfptr_util_form_tlv:=nil;
  Flibfptr_util_mapping:=nil;
  Flibfptr_util_form_nomenclature:=nil;

  //get
  Flibfptr_get_settings:=nil;
  Flibfptr_get_single_setting:=nil;

  Flibfptr_get_param_bool:=nil;
  Flibfptr_get_param_int:=nil;
  Flibfptr_get_param_double:=nil;
  Flibfptr_get_param_str:=nil;
  Flibfptr_get_param_datetime:=nil;
  Flibfptr_get_param_bytearray:=nil;

  //set
  Flibfptr_set_single_setting:=nil;
  Flibfptr_apply_single_settings:=nil;
  Flibfptr_reset_params:=nil;

  Flibfptr_set_param_bool:=nil;
  Flibfptr_set_param_int:=nil;
  Flibfptr_set_settings:=nil;
  Flibfptr_set_param_double:=nil;
  Flibfptr_set_param_str:=nil;
  Flibfptr_set_param_datetime:=nil;
  Flibfptr_set_param_bytearray:=nil;

  //
  Flibfptr_log_write:=nil;
  //ver 10.3.1
  Flibfptr_show_properties:=nil;
  Flibfptr_read_model_flags:=nil;

  //ver 10.4.0
  Flibfptr_line_feed:=nil;
  Flibfptr_flash_firmware:=nil;

  //ver 10.4.1
  Flibfptr_set_non_printable_param_bool:=nil;
  Flibfptr_set_non_printable_param_int:=nil;
  Flibfptr_set_non_printable_param_double:=nil;
  Flibfptr_set_non_printable_param_str:=nil;
  Flibfptr_set_non_printable_param_datetime:=nil;
  Flibfptr_set_non_printable_param_bytearray:=nil;
  //ver 10.4.2
  Flibfptr_soft_lock_init:=nil;
  Flibfptr_soft_lock_query_session_code:=nil;
  Flibfptr_soft_lock_validate:=nil;
  Flibfptr_util_calc_tax:=nil;

  //
  FAtollLib:=NilHandle;
end;

function TAtollLibraryV10.GetLoaded: boolean;
begin
  Result := FAtollLib <> NilHandle;
end;

constructor TAtollLibraryV10.Create;
begin
  InternalClearProcAdress;
  FLibraryName:=slibFPPtr10FileName
end;

destructor TAtollLibraryV10.Destroy;
begin
  Unload;
  inherited Destroy;
end;

procedure TAtollLibraryV10.LoadAtollLibrary;

function DoGetProcAddress(Lib: TLibHandle; Name: string): Pointer;
begin
  Result := GetProcedureAddress(Lib, Name);
  if not Assigned(Result) then
    raise EAtollLibrary.CreateFmt(sCantLoadProc, [Name]);
end;
begin
  FAtollLib := LoadLibrary(PChar(FLibraryName));

  if Loaded then
  begin
    Flibfptr_create := Tlibfptr_create(DoGetProcAddress(FAtollLib, 'libfptr_create'));
    Flibfptr_destroy := Tlibfptr_destroy(DoGetProcAddress(FAtollLib, 'libfptr_destroy'));
    Flibfptr_error_code:=Tlibfptr_error_code(DoGetProcAddress(FAtollLib, 'libfptr_error_code'));
    Flibfptr_error_description:=Tlibfptr_error_description(DoGetProcAddress(FAtollLib, 'libfptr_error_description'));
    Flibfptr_open_drawer:=Tlibfptr_open_drawer(DoGetProcAddress(FAtollLib, 'libfptr_open_drawer'));

    Flibfptr_open:=Tlibfptr_open(DoGetProcAddress(FAtollLib, 'libfptr_open'));
    Flibfptr_close:=Tlibfptr_close(DoGetProcAddress(FAtollLib, 'libfptr_close'));
    Flibfptr_is_opened:=Tlibfptr_is_opened(DoGetProcAddress(FAtollLib, 'libfptr_is_opened'));
    Flibfptr_beep:=Tlibfptr_beep(DoGetProcAddress(FAtollLib, 'libfptr_beep'));
    Flibfptr_get_version_string:=Tlibfptr_get_version_string(DoGetProcAddress(FAtollLib, 'libfptr_get_version_string'));
    Flibfptr_run_command:=Tlibfptr_run_command(DoGetProcAddress(FAtollLib, 'libfptr_run_command'));
    Flibfptr_cut:=Tlibfptr_cut(DoGetProcAddress(FAtollLib, 'libfptr_cut'));
    Flibfptr_device_poweroff:=Tlibfptr_device_poweroff(DoGetProcAddress(FAtollLib, 'libfptr_device_poweroff'));
    Flibfptr_device_reboot:=Tlibfptr_device_reboot(DoGetProcAddress(FAtollLib, 'libfptr_device_reboot'));
    Flibfptr_open_shift:=Tlibfptr_open_shift(DoGetProcAddress(FAtollLib, 'libfptr_open_shift'));
    Flibfptr_reset_summary:=Tlibfptr_reset_summary(DoGetProcAddress(FAtollLib, 'libfptr_reset_summary'));

    Flibfptr_init_device:=Tlibfptr_init_device(DoGetProcAddress(FAtollLib, 'libfptr_init_device'));
    Flibfptr_query_data:=Tlibfptr_query_data(DoGetProcAddress(FAtollLib, 'libfptr_query_data'));
    Flibfptr_cash_income:=Tlibfptr_cash_income(DoGetProcAddress(FAtollLib, 'libfptr_cash_income'));
    Flibfptr_cash_outcome:=Tlibfptr_cash_outcome(DoGetProcAddress(FAtollLib, 'libfptr_cash_outcome'));

    Flibfptr_open_receipt:=Tlibfptr_open_receipt(DoGetProcAddress(FAtollLib, 'libfptr_open_receipt'));
    Flibfptr_cancel_receipt:=Tlibfptr_cancel_receipt(DoGetProcAddress(FAtollLib, 'libfptr_cancel_receipt'));
    Flibfptr_close_receipt:=Tlibfptr_close_receipt(DoGetProcAddress(FAtollLib, 'libfptr_close_receipt'));
    Flibfptr_check_document_closed:=Tlibfptr_check_document_closed(DoGetProcAddress(FAtollLib, 'libfptr_check_document_closed'));
    Flibfptr_receipt_total:=Tlibfptr_receipt_total(DoGetProcAddress(FAtollLib, 'libfptr_receipt_total'));
    Flibfptr_receipt_tax:=Tlibfptr_receipt_tax(DoGetProcAddress(FAtollLib, 'libfptr_receipt_tax'));
    Flibfptr_registration:=Tlibfptr_registration(DoGetProcAddress(FAtollLib, 'libfptr_registration'));
    Flibfptr_payment:=Tlibfptr_payment(DoGetProcAddress(FAtollLib, 'libfptr_payment'));
    Flibfptr_report:=Tlibfptr_report(DoGetProcAddress(FAtollLib, 'libfptr_report'));
    Flibfptr_print_text:=Tlibfptr_print_text(DoGetProcAddress(FAtollLib, 'libfptr_print_text'));
    Flibfptr_print_cliche:=Tlibfptr_print_cliche(DoGetProcAddress(FAtollLib, 'libfptr_print_cliche'));
    Flibfptr_begin_nonfiscal_document:=Tlibfptr_begin_nonfiscal_document(DoGetProcAddress(FAtollLib, 'libfptr_begin_nonfiscal_document'));
    Flibfptr_end_nonfiscal_document:=Tlibfptr_end_nonfiscal_document(DoGetProcAddress(FAtollLib, 'libfptr_end_nonfiscal_document'));
    Flibfptr_print_barcode:=Tlibfptr_print_barcode(DoGetProcAddress(FAtollLib, 'libfptr_print_barcode'));
    Flibfptr_print_picture:=Tlibfptr_print_picture(DoGetProcAddress(FAtollLib, 'libfptr_print_picture'));
    Flibfptr_print_picture_by_number:=Tlibfptr_print_picture_by_number(DoGetProcAddress(FAtollLib, 'libfptr_print_picture_by_number'));
    Flibfptr_upload_picture_from_file:=Tlibfptr_upload_picture_from_file(DoGetProcAddress(FAtollLib, 'libfptr_upload_picture_from_file'));
    Flibfptr_clear_pictures:=Tlibfptr_clear_pictures(DoGetProcAddress(FAtollLib, 'libfptr_clear_pictures'));
    Flibfptr_write_device_setting_raw:=Tlibfptr_write_device_setting_raw(DoGetProcAddress(FAtollLib, 'libfptr_write_device_setting_raw'));
    Flibfptr_read_device_setting_raw:=Tlibfptr_read_device_setting_raw(DoGetProcAddress(FAtollLib, 'libfptr_read_device_setting_raw'));
    Flibfptr_commit_settings:=Tlibfptr_commit_settings(DoGetProcAddress(FAtollLib, 'libfptr_commit_settings'));
    Flibfptr_init_settings:=Tlibfptr_init_settings(DoGetProcAddress(FAtollLib, 'libfptr_init_settings'));
    Flibfptr_reset_settings:=Tlibfptr_reset_settings(DoGetProcAddress(FAtollLib, 'libfptr_reset_settings'));
    Flibfptr_write_date_time:=Tlibfptr_write_date_time(DoGetProcAddress(FAtollLib, 'libfptr_write_date_time'));
    Flibfptr_write_license:=Tlibfptr_write_license(DoGetProcAddress(FAtollLib, 'libfptr_write_license'));
    Flibfptr_fn_operation:=Tlibfptr_fn_operation(DoGetProcAddress(FAtollLib, 'libfptr_fn_operation'));

    Flibfptr_fn_query_data:=Tlibfptr_fn_query_data(DoGetProcAddress(FAtollLib, 'libfptr_fn_query_data'));
    Flibfptr_fn_write_attributes:=Tlibfptr_fn_write_attributes(DoGetProcAddress(FAtollLib, 'libfptr_fn_write_attributes'));
    Flibfptr_external_device_power_on:=Tlibfptr_external_device_power_on(DoGetProcAddress(FAtollLib, 'libfptr_external_device_power_on'));
    Flibfptr_external_device_power_off:=Tlibfptr_external_device_power_off(DoGetProcAddress(FAtollLib, 'libfptr_external_device_power_off'));
    Flibfptr_external_device_write_data:=Tlibfptr_external_device_write_data(DoGetProcAddress(FAtollLib, 'libfptr_external_device_write_data'));
    Flibfptr_external_device_read_data:=Tlibfptr_external_device_read_data(DoGetProcAddress(FAtollLib, 'libfptr_external_device_read_data'));
    Flibfptr_operator_login:=Tlibfptr_operator_login(DoGetProcAddress(FAtollLib, 'libfptr_operator_login'));
    Flibfptr_process_json:=Tlibfptr_process_json(DoGetProcAddress(FAtollLib, 'libfptr_process_json'));
    Flibfptr_read_device_setting:=Tlibfptr_read_device_setting(DoGetProcAddress(FAtollLib, 'libfptr_read_device_setting'));
    Flibfptr_write_device_setting:=Tlibfptr_write_device_setting(DoGetProcAddress(FAtollLib, 'libfptr_write_device_setting'));
    Flibfptr_begin_read_records:=Tlibfptr_begin_read_records(DoGetProcAddress(FAtollLib, 'libfptr_begin_read_records'));
    Flibfptr_read_next_record:=Tlibfptr_read_next_record(DoGetProcAddress(FAtollLib, 'libfptr_read_next_record'));
    Flibfptr_end_read_records:=Tlibfptr_end_read_records(DoGetProcAddress(FAtollLib, 'libfptr_end_read_records'));
    Flibfptr_user_memory_operation:=Tlibfptr_user_memory_operation(DoGetProcAddress(FAtollLib, 'libfptr_user_memory_operation'));
    Flibfptr_continue_print:=Tlibfptr_continue_print(DoGetProcAddress(FAtollLib, 'libfptr_continue_print'));
    Flibfptr_init_mgm:=Tlibfptr_init_mgm(DoGetProcAddress(FAtollLib, 'libfptr_init_mgm'));
    Flibfptr_util_form_tlv:=Tlibfptr_util_form_tlv(DoGetProcAddress(FAtollLib, 'libfptr_util_form_tlv'));
    Flibfptr_util_mapping:=Tlibfptr_util_mapping(DoGetProcAddress(FAtollLib, 'libfptr_util_mapping'));
    Flibfptr_util_form_nomenclature:=Tlibfptr_util_form_nomenclature(DoGetProcAddress(FAtollLib, 'libfptr_util_form_nomenclature'));

    //get
    Flibfptr_get_settings:=Tlibfptr_get_settings(DoGetProcAddress(FAtollLib, 'libfptr_get_settings'));
    Flibfptr_get_single_setting:=Tlibfptr_get_single_setting(DoGetProcAddress(FAtollLib, 'libfptr_get_single_setting'));
    Flibfptr_get_param_bool:=Tlibfptr_get_param_bool(DoGetProcAddress(FAtollLib, 'libfptr_get_param_bool'));
    Flibfptr_get_param_int:=Tlibfptr_get_param_int(DoGetProcAddress(FAtollLib, 'libfptr_get_param_int'));
    Flibfptr_get_param_double:=Tlibfptr_get_param_double(DoGetProcAddress(FAtollLib, 'libfptr_get_param_double'));
    Flibfptr_get_param_str:=Tlibfptr_get_param_str(DoGetProcAddress(FAtollLib, 'libfptr_get_param_str'));
    Flibfptr_get_param_datetime:=Tlibfptr_get_param_datetime(DoGetProcAddress(FAtollLib, 'libfptr_get_param_datetime'));
    Flibfptr_get_param_bytearray:=Tlibfptr_get_param_bytearray(DoGetProcAddress(FAtollLib, 'libfptr_get_param_bytearray'));

    //set
    Flibfptr_set_single_setting:=Tlibfptr_set_single_setting(DoGetProcAddress(FAtollLib, 'libfptr_set_single_setting'));
    Flibfptr_apply_single_settings:=Tlibfptr_apply_single_settings(DoGetProcAddress(FAtollLib, 'libfptr_apply_single_settings'));
    Flibfptr_set_settings:=Tlibfptr_set_settings(DoGetProcAddress(FAtollLib, 'libfptr_set_settings'));
    Flibfptr_reset_params:=Tlibfptr_reset_params(DoGetProcAddress(FAtollLib, 'libfptr_reset_params'));

    Flibfptr_set_param_bool:=Tlibfptr_set_param_bool(DoGetProcAddress(FAtollLib, 'libfptr_set_param_bool'));
    Flibfptr_set_param_int:=Tlibfptr_set_param_int(DoGetProcAddress(FAtollLib, 'libfptr_set_param_int'));
    Flibfptr_set_param_double:=Tlibfptr_set_param_double(DoGetProcAddress(FAtollLib, 'libfptr_set_param_double'));
    Flibfptr_set_param_str:=Tlibfptr_set_param_str(DoGetProcAddress(FAtollLib, 'libfptr_set_param_str'));
    Flibfptr_set_param_datetime:=Tlibfptr_set_param_datetime(DoGetProcAddress(FAtollLib, 'libfptr_set_param_datetime'));
    Flibfptr_set_param_bytearray:=Tlibfptr_set_param_bytearray(DoGetProcAddress(FAtollLib, 'libfptr_set_param_bytearray'));

    Flibfptr_log_write:=Tlibfptr_log_write(DoGetProcAddress(FAtollLib, 'libfptr_log_write'));

    //ver 10.3.1
    Flibfptr_show_properties:=Tlibfptr_show_properties(DoGetProcAddress(FAtollLib, 'libfptr_show_properties'));
    Flibfptr_read_model_flags:=Tlibfptr_read_model_flags(DoGetProcAddress(FAtollLib, 'libfptr_read_model_flags'));

    //ver 10.4.0
    Flibfptr_line_feed:=Tlibfptr_line_feed(DoGetProcAddress(FAtollLib, 'libfptr_line_feed'));
    Flibfptr_flash_firmware:=Tlibfptr_flash_firmware(DoGetProcAddress(FAtollLib, 'libfptr_flash_firmware'));

    //ver 10.4.1
    Flibfptr_set_non_printable_param_bool:=Tlibfptr_set_non_printable_param_bool(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_bool'));
    Flibfptr_set_non_printable_param_int:=Tlibfptr_set_non_printable_param_int(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_int'));
    Flibfptr_set_non_printable_param_double:=Tlibfptr_set_non_printable_param_double(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_double'));
    Flibfptr_set_non_printable_param_str:=Tlibfptr_set_non_printable_param_str(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_str'));
    Flibfptr_set_non_printable_param_datetime:=Tlibfptr_set_non_printable_param_datetime(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_datetime'));
    Flibfptr_set_non_printable_param_bytearray:=Tlibfptr_set_non_printable_param_bytearray(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_bytearray'));
    //ver 10.4.2
    Flibfptr_soft_lock_init:=Tlibfptr_soft_lock_init(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_bytearray'));
    Flibfptr_soft_lock_query_session_code:=Tlibfptr_soft_lock_query_session_code(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_bytearray'));
    Flibfptr_soft_lock_validate:=Tlibfptr_soft_lock_validate(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_bytearray'));
    Flibfptr_util_calc_tax:=Tlibfptr_util_calc_tax(DoGetProcAddress(FAtollLib, 'libfptr_set_non_printable_param_bytearray'));
  end;
end;

function TAtollLibraryV10.Unload: Boolean;
begin
  if Loaded then
  begin
    UnloadLibrary(FAtollLib);
    FAtollLib:=NilHandle;
  end;
  InternalClearProcAdress;
end;

function TAtollLibraryV10.CreateHandle(var Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_create) then
    Result:=Flibfptr_create(@Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_create']);
end;

procedure TAtollLibraryV10.DestroyHandle(var Handle: TLibFPtrHandle);
begin
  if Assigned(Flibfptr_destroy) then
  begin
    Flibfptr_destroy(@Handle);
    Handle:=nil;
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_destroy']);
end;

function TAtollLibraryV10.ErrorCode(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_error_code) then
    Result:=Flibfptr_error_code(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_error_code']);
end;


function TAtollLibraryV10.ErrorDescription(Handle: TLibFPtrHandle): UTF8String;
var
  L, FLen : Integer;
  S:TAtollWideString;
begin
  Result:='';
  if Assigned(Flibfptr_error_description) then
  begin
    L:=1024;
    SetLength(S, L);
    FLen:=Flibfptr_error_description(Handle, @S[aFirstStrChar], L);
    if L<FLen then
    begin
      SetLength(S, FLen);
      FLen:=Flibfptr_error_description(Handle, @S[aFirstStrChar], FLen);
    end;
    Result:=AtollWideStrToString(S);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_error_description']);
end;

function TAtollLibraryV10.OpenDrawer(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_open_drawer) then
    Result:=Flibfptr_open_drawer(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_open_drawer']);
end;

function TAtollLibraryV10.Open(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_open) then
    Result:=Flibfptr_open(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_open']);
end;

function TAtollLibraryV10.Close(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_close) then
    Result:=Flibfptr_close(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_close']);
end;

function TAtollLibraryV10.IsOpened(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_is_opened) then
    Result:=Flibfptr_is_opened(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_is_opened']);
end;

function TAtollLibraryV10.Beep(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_beep) then
    Result:=Flibfptr_beep(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_beep']);
end;

function TAtollLibraryV10.GetVersionString: string;
var
  P: PChar;
begin
  if Assigned(Flibfptr_get_version_string) then
  begin
    P:=Flibfptr_get_version_string();
    Result:=P;
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_version_string']);
end;

function TAtollLibraryV10.RunCommand(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_run_command) then
    Result:=Flibfptr_run_command(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_run_command']);
end;

function TAtollLibraryV10.Cut(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_cut) then
    Result:=Flibfptr_cut(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_cut']);
end;

function TAtollLibraryV10.DevicePowerOff(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_device_poweroff) then
    Result:=Flibfptr_device_poweroff(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_device_poweroff']);
end;

function TAtollLibraryV10.DeviceReboot(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_device_reboot) then
    Result:=Flibfptr_device_reboot(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_device_reboot']);
end;

function TAtollLibraryV10.OpenShift(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_open_shift) then
    Result:=Flibfptr_open_shift(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_open_shift']);
end;

function TAtollLibraryV10.ResetSummary(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_reset_summary) then
    Result:=Flibfptr_reset_summary(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_reset_summary']);
end;

function TAtollLibraryV10.InitDevice(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_init_device) then
    Result:=Flibfptr_init_device(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_init_device']);
end;

function TAtollLibraryV10.QueryData(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_query_data) then
    Result:=Flibfptr_query_data(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_query_data']);
end;

function TAtollLibraryV10.CashIncome(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_cash_income) then
    Result:=Flibfptr_cash_income(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_cash_income']);
end;

function TAtollLibraryV10.CashOutcome(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_cash_outcome) then
    Result:=Flibfptr_cash_outcome(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_cash_outcome']);
end;

function TAtollLibraryV10.OpenReceipt(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_open_receipt) then
    Result:=Flibfptr_open_receipt(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_open_receipt']);
end;

function TAtollLibraryV10.CancelReceipt(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_cancel_receipt) then
    Result:=Flibfptr_cancel_receipt(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_cancel_receipt']);
end;

function TAtollLibraryV10.CloseReceipt(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_close_receipt) then
    Result:=Flibfptr_close_receipt(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_close_receipt']);
end;

function TAtollLibraryV10.CheckCocumentClosed(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_check_document_closed) then
    Result:=Flibfptr_check_document_closed(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_check_document_closed']);
end;

function TAtollLibraryV10.ReceiptTotal(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_receipt_total) then
    Result:=Flibfptr_receipt_total(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_receipt_total']);
end;

function TAtollLibraryV10.ReceiptTax(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_receipt_tax) then
    Result:=Flibfptr_receipt_tax(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_receipt_tax']);
end;

function TAtollLibraryV10.Registration(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_registration) then
    Result:=Flibfptr_registration(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_registration']);
end;

function TAtollLibraryV10.Payment(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_payment) then
    Result:=Flibfptr_payment(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_payment']);
end;

function TAtollLibraryV10.Report(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_report) then
    Result:=Flibfptr_report(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_report']);
end;

function TAtollLibraryV10.PrintText(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_print_text) then
    Result:=Flibfptr_print_text(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_print_text']);
end;

function TAtollLibraryV10.PrintCliche(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_print_cliche) then
    Result:=Flibfptr_print_cliche(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_print_cliche']);
end;

function TAtollLibraryV10.BeginNonfiscalDocument(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_begin_nonfiscal_document) then
    Result:=Flibfptr_begin_nonfiscal_document(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_begin_nonfiscal_document']);
end;

function TAtollLibraryV10.EndNonfiscalDocument(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_end_nonfiscal_document) then
    Result:=Flibfptr_end_nonfiscal_document(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_end_nonfiscal_document']);
end;

function TAtollLibraryV10.PrintBarcode(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_print_barcode) then
    Result:=Flibfptr_print_barcode(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_print_barcode']);
end;

function TAtollLibraryV10.PrintPicture(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_print_picture) then
    Result:=Flibfptr_print_picture(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_print_picture']);
end;

function TAtollLibraryV10.PrintPictureByNumber(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_print_picture_by_number) then
    Result:=Flibfptr_print_picture_by_number(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_print_picture_by_number']);
end;

function TAtollLibraryV10.UploadPictureFromFile(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_upload_picture_from_file) then
    Result:=Flibfptr_upload_picture_from_file(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_upload_picture_from_file']);
end;

function TAtollLibraryV10.ClearPictures(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_clear_pictures) then
    Result:=Flibfptr_clear_pictures(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_clear_pictures']);
end;

function TAtollLibraryV10.WriteDeviceSettingRaw(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_write_device_setting_raw) then
    Result:=Flibfptr_write_device_setting_raw(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_write_device_setting_raw']);
end;

function TAtollLibraryV10.ReadDeviceSettingRaw(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_read_device_setting_raw) then
    Result:=Flibfptr_read_device_setting_raw(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_read_device_setting_raw']);
end;

function TAtollLibraryV10.CommitSettings(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_commit_settings) then
    Result:=Flibfptr_commit_settings(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_commit_settings']);
end;

function TAtollLibraryV10.InitSettings(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_init_settings) then
    Result:=Flibfptr_init_settings(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_init_settings']);
end;

function TAtollLibraryV10.ResetSettings(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_reset_settings) then
    Result:=Flibfptr_reset_settings(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_reset_settings']);
end;

function TAtollLibraryV10.WriteDateTime(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_write_date_time) then
    Result:=Flibfptr_write_date_time(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_write_date_time']);
end;

function TAtollLibraryV10.WriteLicense(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_write_license) then
    Result:=Flibfptr_write_license(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_write_license']);
end;

function TAtollLibraryV10.fnOperation(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_fn_operation) then
    Result:=Flibfptr_fn_operation(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_fn_operation']);
end;

function TAtollLibraryV10.fnQueryData(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_fn_query_data) then
    Result:=Flibfptr_fn_query_data(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_fn_query_data']);
end;

function TAtollLibraryV10.fnWriteAttributes(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_fn_write_attributes) then
    Result:=Flibfptr_fn_write_attributes(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_fn_write_attributes']);
end;

function TAtollLibraryV10.ExternalDevicePowerOn(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_external_device_power_on) then
    Result:=Flibfptr_external_device_power_on(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_external_device_power_on']);
end;

function TAtollLibraryV10.ExternalDevicePowerOff(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_external_device_power_off) then
    Result:=Flibfptr_external_device_power_off(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_external_device_power_off']);
end;

function TAtollLibraryV10.ExternalDeviceWriteData(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_external_device_write_data) then
    Result:=Flibfptr_external_device_write_data(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_external_device_write_data']);
end;

function TAtollLibraryV10.ExternalDeviceReadData(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_external_device_read_data) then
    Result:=Flibfptr_external_device_read_data(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_external_device_read_data']);
end;

function TAtollLibraryV10.OperatorLogin(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_operator_login) then
    Result:=Flibfptr_operator_login(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_operator_login']);
end;

function TAtollLibraryV10.ProcessJSON(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_process_json) then
    Result:=Flibfptr_process_json(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_process_json']);
end;

function TAtollLibraryV10.ReadDeviceSetting(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_read_device_setting) then
    Result:=Flibfptr_read_device_setting(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_read_device_setting']);
end;

function TAtollLibraryV10.WriteDeviceSetting(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_write_device_setting) then
    Result:=Flibfptr_write_device_setting(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_write_device_setting']);
end;

function TAtollLibraryV10.BeginReadRecords(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_begin_read_records) then
    Result:=Flibfptr_begin_read_records(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_begin_read_records']);
end;

function TAtollLibraryV10.ReadNextRecord(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_read_next_record) then
    Result:=Flibfptr_read_next_record(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_read_next_record']);
end;

function TAtollLibraryV10.EndReadRecords(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_end_read_records) then
    Result:=Flibfptr_end_read_records(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_end_read_records']);
end;

function TAtollLibraryV10.UserMemoryOperation(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_user_memory_operation) then
    Result:=Flibfptr_user_memory_operation(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_user_memory_operation']);
end;

function TAtollLibraryV10.ContinuePrint(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_continue_print) then
    Result:=Flibfptr_continue_print(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_continue_print']);
end;

function TAtollLibraryV10.InitMGM(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_init_mgm) then
    Result:=Flibfptr_init_mgm(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_init_mgm']);
end;

function TAtollLibraryV10.UtilFormTLV(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_util_form_tlv) then
    Result:=Flibfptr_util_form_tlv(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_util_form_tlv']);
end;

function TAtollLibraryV10.UtilMapping(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_util_mapping) then
    Result:=Flibfptr_util_mapping(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_util_mapping']);
end;

function TAtollLibraryV10.UtilFormNomenclature(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_util_form_nomenclature) then
    Result:=Flibfptr_util_form_nomenclature(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_util_form_nomenclature']);
end;

function TAtollLibraryV10.GetSettings(Handle: TLibFPtrHandle): UTF8String;
var
  S:TAtollWideString;
  FSize, L: Integer;
begin
  Result:='';
  if Assigned(Flibfptr_get_settings) then
  begin
    L:=1024;
    SetLength(S, L);
    FSize:=Flibfptr_get_settings(Handle, @S[aFirstStrChar], L);
    if (FSize > L) then
    begin
      SetLength(S, FSize);
      FSize:=Flibfptr_get_settings(Handle, @S[aFirstStrChar], FSize)
    end
    else
    if (FSize < L) then
      SetLength(S, FSize);
    Result:=AtollWideStrToString(S);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_settings']);
end;

function TAtollLibraryV10.GetSingleSetting(Handle: TLibFPtrHandle; Key: string
  ): string;
var
  FKeyW, S: TAtollWideString;
  L, FSize: Integer;
begin
  Result:='';
  if Assigned(Flibfptr_get_single_setting) then
  begin
    L:=1024;
    FKeyW:=StringToAtollWideStr(Key);
    SetLength(S, L);
    FSize:=Flibfptr_get_single_setting(Handle, @FKeyW[aFirstStrChar], @S[aFirstStrChar], L);
    if (FSize > L) then
    begin
      SetLength(S, FSize+1);
      FSize:=Flibfptr_get_single_setting(Handle, @FKeyW[aFirstStrChar], @S[aFirstStrChar], FSize)
    end;
    Result:=AtollWideStrToString(S);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_single_setting']);
end;

function TAtollLibraryV10.GetParamBool(Handle: TLibFPtrHandle; Param_id: integer
  ): Boolean;
begin
  if Assigned(Flibfptr_get_param_bool) then
    Result:=Flibfptr_get_param_bool(Handle, Param_id) <> 0
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_param_bool']);
end;

function TAtollLibraryV10.GetParamInt(Handle: TLibFPtrHandle; Param_id: integer
  ): integer;
begin
  if Assigned(Flibfptr_get_param_int) then
    Result:=Flibfptr_get_param_int(Handle, Param_id)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_param_int']);
end;

function TAtollLibraryV10.GetParamDouble(Handle: TLibFPtrHandle; Param_id: integer
  ): Double;
begin
  if Assigned(Flibfptr_get_param_double) then
    Result:=Flibfptr_get_param_double(Handle, Param_id)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_param_double']);
end;

function TAtollLibraryV10.GetParamStr(Handle: TLibFPtrHandle; Param_id: integer
  ): string;
var
  L, FLen: Integer;
  S:TAtollWideString;
begin
  Result:='';
  if Assigned(Flibfptr_get_param_str) then
  begin
    L:=1024;
    SetLength(S, L);
    FLen:=Flibfptr_get_param_str(Handle, Param_id, @S[aFirstStrChar], L);
    if L<FLen then
    begin
      SetLength(S, FLen);
      FLen:=Flibfptr_get_param_str(Handle, Param_id, @S[aFirstStrChar], FLen);
    end;
    Result:=AtollWideStrToString(S);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_param_str']);
end;

function TAtollLibraryV10.GetParamDateTime(Handle: TLibFPtrHandle;
  Param_id: integer): TDateTime;
var
  FYear, FMonth, FDay, FHour, FMinute, FSecond:integer;
begin
  if Assigned(Flibfptr_get_param_datetime) then
  begin
    Flibfptr_get_param_datetime(Handle, Param_id, @FYear, @FMonth, @FDay, @FHour, @FMinute, @FSecond);
    Result:=EncodeDate(FYear, FMonth, FDay) + EncodeTime(FHour, FMinute, FSecond, 0);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_param_datetime']);
end;

function TAtollLibraryV10.GetParamByteArray(Handle: TLibFPtrHandle;
  Param_id: integer): TBytes;
var
  L, FLen: Integer;
begin
  if Assigned(Flibfptr_get_param_bytearray) then
  begin
    L:=1024;
    SetLength(Result, L);
    FLen:=Flibfptr_get_param_bytearray(Handle, Param_id, @Result[0], L);
    if L<FLen then
    begin
      SetLength(Result, FLen);
      FLen:=Flibfptr_get_param_bytearray(Handle, Param_id, @Result[0], FLen);
    end
    else
    if L>FLen then
      SetLength(Result, FLen);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_param_bytearray']);
end;

procedure TAtollLibraryV10.SetSingleSetting(Handle: PLibFPtrHandle; Key,
  Value: string);
var
  FKeyW, FValueW: TAtollWideString;
begin
  if Assigned(Flibfptr_set_single_setting) then
  begin
    FKeyW:=StringToAtollWideStr(Key);
    FValueW:=StringToAtollWideStr(Value);
    Flibfptr_set_single_setting(Handle, @FKeyW[aFirstStrChar], @FValueW[aFirstStrChar])
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_single_setting']);
end;

function TAtollLibraryV10.ApplySingleSettings(Handle: PLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_apply_single_settings) then
    Result:=Flibfptr_apply_single_settings(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_apply_single_settings']);
end;

procedure TAtollLibraryV10.SetParamBool(Handle: TLibFPtrHandle; ParamId: Integer;
  Value: Boolean);
begin
  if Assigned(Flibfptr_set_param_bool) then
    Flibfptr_set_param_bool(Handle, ParamId, Ord(Value))
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_param_bool']);
end;

procedure TAtollLibraryV10.SetParamInt(Handle: TLibFPtrHandle;
  ParamId: Tlibfptr_param; Value: Integer);
begin
  if Assigned(Flibfptr_set_param_int) then
    Flibfptr_set_param_int(Handle, Ord(ParamId), Value)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_param_int']);
end;

procedure TAtollLibraryV10.SetParamDouble(Handle: TLibFPtrHandle;
  ParamId: Integer; Value: Double);
begin
  if Assigned(Flibfptr_set_param_double) then
    Flibfptr_set_param_double(Handle, ParamId, Value)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_param_double']);
end;

procedure TAtollLibraryV10.SetParamStr(Handle: TLibFPtrHandle; ParamId: Integer;
  Value: string);
var
  FValueW: TAtollWideString;
begin
  if Assigned(Flibfptr_set_param_str) then
  begin
    if Value = '' then
      Value := ' ';
    FValueW:=StringToAtollWideStr(Value);
    Flibfptr_set_param_str(Handle, ParamId, @FValueW[aFirstStrChar]);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_param_str']);
end;

procedure TAtollLibraryV10.SetParamDateTime(Handle: TLibFPtrHandle;
  ParamId: Integer; Value: TDateTime);
var
  Y, M, D, MS, H, N, S: word;
begin
  if Assigned(Flibfptr_set_param_datetime) then
  begin
    DecodeDate(Value, Y, M, D);
    DecodeTime(Value, H, N, S, MS);
    Flibfptr_set_param_datetime(Handle, ParamId, Y, M, D, H, N, S)
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_param_datetime']);
end;

procedure TAtollLibraryV10.SetParamByteArray(Handle: TLibFPtrHandle;
  ParamId: Integer; const Value: TBytes);
begin
  if Assigned(Flibfptr_set_param_bytearray) then
    Flibfptr_set_param_bytearray(Handle, ParamId, @Value[0], Length(Value))
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_param_bytearray']);
end;

function TAtollLibraryV10.SetSettings(Handle: TLibFPtrHandle; Settings: string
  ): Integer;
var
  FSettingsW: TAtollWideString;
begin
  if Assigned(Flibfptr_set_settings) then
  begin
    FSettingsW:=StringToAtollWideStr(Settings);
    Result:=Flibfptr_set_settings(Handle, @FSettingsW[aFirstStrChar])
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_settings']);
end;

function TAtollLibraryV10.ResetParams(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_reset_params) then
    Result:=Flibfptr_reset_params(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_reset_params']);
end;

function TAtollLibraryV10.LogWrite(Tag: string; Level: Integer; Message: string
  ): Integer;
var
  FTagW, FMessageW: TAtollWideString;
begin
  if Assigned(Flibfptr_log_write) then
  begin
    FTagW:=StringToAtollWideStr(Tag);
    FMessageW:=StringToAtollWideStr(Message);
    Result:=Flibfptr_log_write(@FTagW[aFirstStrChar], Level, @FMessageW[aFirstStrChar]);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_log_write']);
end;

function TAtollLibraryV10.ShowProperties(Handle: TLibFPtrHandle;
  ParentType: Tlibfptr_gui_parent; Parent: Pointer): Integer;
begin
  if Assigned(Flibfptr_show_properties) then
    Result:=Flibfptr_show_properties(Handle, Ord(ParentType), Parent)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_show_properties']);
end;

function TAtollLibraryV10.ReadModelFlags(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_read_model_flags) then
    Result:=Flibfptr_read_model_flags(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_read_model_flags']);
end;

function TAtollLibraryV10.LineFeed(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_line_feed) then
    Result:=Flibfptr_line_feed(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_line_feed']);
end;

function TAtollLibraryV10.FlashFirmware(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_flash_firmware) then
    Result:=Flibfptr_flash_firmware(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_flash_firmware']);
end;

procedure TAtollLibraryV10.SetNonPrintableParamBool(Handle: TLibFPtrHandle;
  ParamId: Integer; Value: Boolean);
begin
  if Assigned(Flibfptr_set_non_printable_param_bool) then
    Flibfptr_set_non_printable_param_bool(Handle, ParamId, Ord(Value))
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_non_printable_param_bool']);
end;

procedure TAtollLibraryV10.SetNonPrintableParamInt(Handle: TLibFPtrHandle;
  ParamId: Integer; Value: Cardinal);
begin
  if Assigned(Flibfptr_set_non_printable_param_int) then
    Flibfptr_set_non_printable_param_int(Handle, ParamId, Value)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_non_printable_param_int']);
end;

procedure TAtollLibraryV10.SetNonPrintableParamDouble(Handle: TLibFPtrHandle;
  ParamId: Integer; Value: Double);
begin
  if Assigned(Flibfptr_set_non_printable_param_double) then
    Flibfptr_set_non_printable_param_double(Handle, ParamId, Value)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_non_printable_param_double']);
end;

procedure TAtollLibraryV10.SetNonPrintableParamStr(Handle: TLibFPtrHandle;
  ParamId: Integer; Value: string);
var
  FValueW: TAtollWideString;
begin
  if Assigned(Flibfptr_set_non_printable_param_str) then
  begin
    if Value = '' then
      Value := ' ';
    FValueW:=StringToAtollWideStr(Value);
    Flibfptr_set_non_printable_param_str(Handle, ParamId, @FValueW[aFirstStrChar]);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_non_printable_param_str']);
end;

procedure TAtollLibraryV10.SetNonPrintableParamDateTime(Handle: TLibFPtrHandle;
  ParamId: Integer; Value: TDateTime);
var
  Y, M, D, H, N, S, MS: word;
begin
  if Assigned(Flibfptr_set_non_printable_param_datetime) then
  begin
    DecodeDate(Value, Y, M, D);
    DecodeTime(Value, H, N, S, MS);
    Flibfptr_set_non_printable_param_datetime(Handle, ParamId, Y, M, D, H, N, S);
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_non_printable_param_datetime']);
end;

procedure TAtollLibraryV10.SetNonPrintableParamByteArray(
  Handle: TLibFPtrHandle; ParamId: Integer; const Value: TBytes);
begin
  if Assigned(Flibfptr_set_non_printable_param_bytearray) then
    Flibfptr_set_non_printable_param_bytearray(Handle, ParamId, @Value[0], Length(Value))
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_non_printable_param_bytearray']);
end;

function TAtollLibraryV10.SoftLockInit(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_soft_lock_init) then
    Flibfptr_soft_lock_init(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_soft_lock_init']);
end;

function TAtollLibraryV10.SoftLockQuerySessionCode(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_soft_lock_query_session_code) then
    Flibfptr_soft_lock_query_session_code(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_soft_lock_query_session_code']);
end;

function TAtollLibraryV10.SoftLockValidate(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_soft_lock_validate) then
    Flibfptr_soft_lock_validate(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_soft_lock_validate']);
end;

function TAtollLibraryV10.UtilCalcTax(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_util_calc_tax) then
    Flibfptr_util_calc_tax(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_util_calc_tax']);
end;

end.
