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

unit AtollKKMv10;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, libfptr10, CasheRegisterAbstract
  {$if FPC_FULLVERSION<30006}
  , dynlibs
  {$endif}
  ;

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

    //ver10.4.5.0
    Flibfptr_reset_error:Tlibfptr_reset_error;
    Flibfptr_download_picture:Tlibfptr_download_picture;
    Flibfptr_util_tag_info:Tlibfptr_util_tag_info;
    Flibfptr_bluetooth_remove_paired_devices:Tlibfptr_bluetooth_remove_paired_devices;
    Flibfptr_util_container_versions:Tlibfptr_util_container_versions;

    //ver 10.5.0.0
    Flibfptr_set_user_param_bool:Tlibfptr_set_user_param_bool;
    Flibfptr_set_user_param_int:Tlibfptr_set_user_param_int;
    Flibfptr_set_user_param_double:Tlibfptr_set_user_param_double;
    Flibfptr_set_user_param_str:Tlibfptr_set_user_param_str;
    Flibfptr_set_user_param_datetime:Tlibfptr_set_user_param_datetime;
    Flibfptr_set_user_param_bytearray:Tlibfptr_set_user_param_bytearray;

    Flibfptr_activate_licenses:Tlibfptr_activate_licenses;
    Flibfptr_remove_licenses:Tlibfptr_remove_licenses;
    Flibfptr_enter_keys:Tlibfptr_enter_keys;
    Flibfptr_validate_keys:Tlibfptr_validate_keys;
    Flibfptr_enter_serial_number:Tlibfptr_enter_serial_number;
    Flibfptr_get_serial_number_request:Tlibfptr_get_serial_number_request;
    Flibfptr_upload_pixel_buffer:Tlibfptr_upload_pixel_buffer;
    Flibfptr_download_pixel_buffer:Tlibfptr_download_pixel_buffer;
    Flibfptr_print_pixel_buffer:Tlibfptr_print_pixel_buffer;
    Flibfptr_util_convert_tag_value:Tlibfptr_util_convert_tag_value;
    Flibfptr_parse_marking_code:Tlibfptr_parse_marking_code;

    //ver 10.5.1.3
    Flibfptr_call_script:Tlibfptr_call_script;
    Flibfptr_set_header_lines:Tlibfptr_set_header_lines;
    Flibfptr_set_footer_lines:Tlibfptr_set_header_lines;

    //ver 10.6.2.0
    Flibfptr_upload_picture_cliche:Tlibfptr_upload_picture_cliche;
    Flibfptr_upload_picture_memory:Tlibfptr_upload_picture_memory;
    Flibfptr_upload_pixel_buffer_cliche:Tlibfptr_upload_pixel_buffer_cliche;
    Flibfptr_upload_pixel_buffer_memory:Tlibfptr_upload_pixel_buffer_memory;
    Flibfptr_exec_driver_script:Tlibfptr_exec_driver_script;
    Flibfptr_upload_driver_script:Tlibfptr_upload_driver_script;
    Flibfptr_exec_driver_script_by_id:Tlibfptr_exec_driver_script_by_id;
    Flibfptr_write_universal_counters_settings:Tlibfptr_write_universal_counters_settings;
    Flibfptr_read_universal_counters_settings:Tlibfptr_read_universal_counters_settings;
    Flibfptr_query_universal_counters_state:Tlibfptr_query_universal_counters_state;
    Flibfptr_reset_universal_counters:Tlibfptr_reset_universal_counters;
    Flibfptr_cache_universal_counters:Tlibfptr_cache_universal_counters;
    Flibfptr_read_universal_counter_sum:Tlibfptr_read_universal_counter_sum;
    Flibfptr_read_universal_counter_quantity:Tlibfptr_read_universal_counter_quantity;
    Flibfptr_clear_universal_counters_cache:Tlibfptr_clear_universal_counters_cache;

    //ver 10.6.3.0
    Flibfptr_disable_ofd_channel:Tlibfptr_disable_ofd_channel;
    Flibfptr_enable_ofd_channel:Tlibfptr_enable_ofd_channel;

    //ver 10.7.0.0
    Flibfptr_create_with_id:Tlibfptr_create_with_id;
    Flibfptr_validate_json:Tlibfptr_validate_json;
    Flibfptr_log_write_ex:Tlibfptr_log_write_ex;

    //10.9.0.0
    Flibfptr_begin_marking_code_validation:Tlibfptr_begin_marking_code_validation;
    Flibfptr_cancel_marking_code_validation:Tlibfptr_cancel_marking_code_validation;
    Flibfptr_get_marking_code_validation_status:Tlibfptr_get_marking_code_validation_status;
    Flibfptr_accept_marking_code:Tlibfptr_accept_marking_code;
    Flibfptr_decline_marking_code:Tlibfptr_decline_marking_code;
    Flibfptr_update_fnm_keys:Tlibfptr_update_fnm_keys;
    Flibfptr_write_sales_notice:Tlibfptr_write_sales_notice;
    Flibfptr_check_marking_code_validations_ready:Tlibfptr_check_marking_code_validations_ready;
    Flibfptr_clear_marking_code_validation_result:Tlibfptr_clear_marking_code_validation_result;
    Flibfptr_ping_marking_server:Tlibfptr_ping_marking_server;
    Flibfptr_get_marking_server_status:Tlibfptr_get_marking_server_status;
    Flibfptr_is_driver_locked:Tlibfptr_is_driver_locked;
    Flibfptr_get_last_document_journal:Tlibfptr_get_last_document_journal;

    function GetLoaded: boolean;
    function IsLibraryNameStored: Boolean;
    procedure InternalClearProcAdress;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadAtollLibrary;
    procedure Unload; virtual;
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

    procedure SetParamBool(Handle: TLibFPtrHandle; ParamId:Tlibfptr_param; Value:Boolean); overload;
    procedure SetParamBool(Handle: TLibFPtrHandle; ParamId:Integer; Value:Boolean); overload; inline;

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

    //ver 10.4.5.0
    procedure ResetError(Handle:TLibFPtrHandle);
    function DownloadPicture(Handle:TLibFPtrHandle):Integer;
    function UtilTagInfo(Handle:TLibFPtrHandle):Integer;
    function BluetoothRemovePairedDevices(Handle:TLibFPtrHandle):Integer;
    function UtilContainerVersions(Handle:TLibFPtrHandle):Integer;

    //ver 10.5.0.0
    procedure SetUserParamBool(Handle:TLibFPtrHandle; ParamId:Integer; value:Integer);
    procedure SetUserParamInt(Handle:TLibFPtrHandle; ParamId:Integer; value:Cardinal);
    procedure SetUserParamDouble(Handle:TLibFPtrHandle; ParamId:Integer; value:Double);
    procedure SetUserParamStr(Handle:TLibFPtrHandle; ParamId:Integer; value:String);
    procedure SetUserParamDateTime(Handle:TLibFPtrHandle; ParamId:Integer; Value:TDateTime);
    procedure SetUserParamByteArray(Handle:TLibFPtrHandle; ParamId:Integer; Value: TBytes);

    function ActivateLicenses(Handle:TLibFPtrHandle):Integer;
    function RemoveLicenses(Handle:TLibFPtrHandle):Integer;
    function EnterKeys(Handle:TLibFPtrHandle):Integer;
    function ValidateKeys(Handle:TLibFPtrHandle):Integer;
    function EnterSerialNumber(Handle:TLibFPtrHandle):Integer;
    function GetSerialNumberRequest(Handle:TLibFPtrHandle):Integer;
    function UploadPixelBuffer(Handle:TLibFPtrHandle):Integer;
    function DownloadPixelBuffer(Handle:TLibFPtrHandle):Integer;
    function PrintPixelBuffer(Handle:TLibFPtrHandle):Integer;
    function UtilConvertTagValue(Handle:TLibFPtrHandle):Integer;
    function ParseMarkingCode(Handle:TLibFPtrHandle):Integer;

    //ver 10.5.1.3
    function CallScript(Handle:TLibFPtrHandle):Integer;
    function SetHeaderLines(Handle:TLibFPtrHandle):Integer;
    function SetFooterLines(Handle:TLibFPtrHandle):Integer;

    //ver 10.6.2.0
    function UploadPictureCliche(Handle:TLibFPtrHandle):Integer;
    function UploadPictureMemory(Handle:TLibFPtrHandle):Integer;
    function UploadPixelBufferCliche(Handle:TLibFPtrHandle):Integer;
    function UploadPixelBufferMemory(Handle:TLibFPtrHandle):Integer;
    function ExecDriverScript(Handle:TLibFPtrHandle):Integer;
    function UploadDriverScript(Handle:TLibFPtrHandle):Integer;
    function ExecDriverScriptById(Handle:TLibFPtrHandle):Integer;
    function WriteUniversalCountersSettings(Handle:TLibFPtrHandle):Integer;
    function ReadUniversalCountersSettings(Handle:TLibFPtrHandle):Integer;
    function QueryUniversalCountersState(Handle:TLibFPtrHandle):Integer;
    function ResetUniversalCounters(Handle:TLibFPtrHandle):Integer;
    function CacheUniversalCounters(Handle:TLibFPtrHandle):Integer;
    function ReadUniversalCounterSum(Handle:TLibFPtrHandle):Integer;
    function ReadUniversalCounterQuantity(Handle:TLibFPtrHandle):Integer;
    function ClearUniversalCountersCache(Handle:TLibFPtrHandle):Integer;

    //ver 10.6.3.0
    function DisableOfdChannel(Handle:TLibFPtrHandle):Integer;
    function EnableOfdChannel(Handle:TLibFPtrHandle):Integer;

    //ver 10.7.0.0
    function CreateWithId(Handle:PLibFPtrHandle; id:string):integer;
    function ValidateJson(Handle:TLibFPtrHandle):Integer;
    function LogWriteEx(Handle:TLibFPtrHandle; Tag:string; Level:Integer; Message:string):Integer;

    //ver 10.9.0.0
    function BeginMarkingCodeValidation(Handle:TLibFPtrHandle):Integer;
    function CancelMarkingCodeValidation(Handle:TLibFPtrHandle):Integer;
    function GetMarkingCodeValidationStatus(Handle:TLibFPtrHandle):Integer;
    function AcceptMarkingCode(Handle:TLibFPtrHandle):Integer;
    function DeclineMarkingCode(Handle:TLibFPtrHandle):Integer;
    function UpdateFnmKeys(Handle:TLibFPtrHandle):Integer;
    function WriteSalesNotice(Handle:TLibFPtrHandle):Integer;
    function CheckMarkingCodeValidationsReady(Handle:TLibFPtrHandle):Integer;
    function ClearMarkingCodeValidationResult(Handle:TLibFPtrHandle):Integer;
    function PingMarkingServer(Handle:TLibFPtrHandle):Integer;
    function GetMarkingServerStatus(Handle:TLibFPtrHandle):Integer;
    function IsDriverLocked(Handle:TLibFPtrHandle):Integer;
    function GetLastDocumentJournal(Handle:TLibFPtrHandle):Integer;
  published
    property LibraryName:string read FLibraryName write FLibraryName stored IsLibraryNameStored;
  end;


  { TAtollKKMv10 }

  TAtollKKMv10 = class(TCashRegisterAbstract)
  private
    FFFD1_2: Boolean;
    FLibrary:TAtollLibraryV10;
    FHandle:TLibFPtrHandle;
    procedure InternalInitLibrary;
    procedure InternalSetCheckType(AValue: TCheckType);
    function InternalRegistration1_05:integer;
    function InternalRegistration1_2(AGI:TGoodsInfo):integer;
    function InternalRegisterBuyer1_2:TBytes;
    procedure InternalSetCorrectionInfo;
  protected
    procedure InternalUserLogin; override;
    procedure InternalOpenKKM; override;
    procedure InternalCloseKKM; override;

    function GetDeviceDateTime: TDateTime; override;
    procedure InternalGetDeviceInfo(var ALineLength, ALineLengthPix: integer); override;
    function GetConnected: boolean; override;
    procedure SetConnected(AValue: boolean); override;

    function GetShiftState: TShiftState; override;
    function GetCheckNumber: integer; override;
    function GetFDNumber: integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;


    function InternalCheckError:Integer; override;
    function GetVersionString:string; override;
    procedure GetOFDStatus(out AStatus:TOFDSTatusRecord); override;
    procedure Beep; override;
    procedure CutCheck(APartial:boolean); override;
    procedure PrintLine(ALine:string); override;        //Печать строки
    procedure PrintClishe; override;

    //Операции со сменой
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
    function RegisterGoods:Integer; override;
    function RegisterPayments:Integer; override;
    function ValidateGoodsKM:Boolean; override;

    procedure RegisterPayment(APaymentType:TPaymentType; APaymentSum:Currency); override;

    procedure SetAttributeInt(AttribNum, AttribValue:Integer); override;
    procedure SetAttributeStr(AttribNum:Integer; AttribValue:string); override;
    procedure SetAttributeBool(AttribNum:Integer; AttribValue:Boolean); override;
    procedure SetAttributeDouble(AttribNum:Integer; AttribValue:Double); override;

    procedure BeginNonfiscalDocument; override;
    procedure EndNonfiscalDocument; override;
    function UpdateFnmKeys:Integer; override;

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

    function NonNullableSum:Currency; override;                  //Не обнуляемая сумма - приход - наличка
    function NonNullableSum(AChekType:Tlibfptr_receipt_type; APaymentType:Tlibfptr_payment_type):Currency;

    function ShowProperties:boolean; override;          //Отобразить окно параметров ККМ

    //Вспомогательное
    procedure OpenDrawer;
  public
    property Handle:TLibFPtrHandle read FHandle;
    property LibraryAtol:TAtollLibraryV10 read FLibrary;
    property FFD1_2:Boolean read FFFD1_2 write FFFD1_2;
  end;

resourcestring
  sCantLoadProc = 'Can''t load procedure "%s"';

function TaxTypeToAtollTT(AValue:TTaxType):Tlibfptr_tax_type;
function muOKEItoAtol(muCode:Integer):Tlibfptr_item_units;
procedure Register;
implementation
uses rxlogging;

procedure Register;
begin
  RegisterComponents('TradeEquipment',[TAtollKKMv10]);
end;

function muOKEItoAtol(muCode:Integer):Tlibfptr_item_units;
begin
  case muCode of
    muPIECE:Result:=LIBFPTR_IU_PIECE; //шт
    muGRAM:Result:=LIBFPTR_IU_GRAM; //Грамм
    muKILOGRAM:Result:=LIBFPTR_IU_KILOGRAM; //Килограмм
    muTON:Result:=LIBFPTR_IU_TON; //Тонна
    muCENTIMETER:Result:=LIBFPTR_IU_CENTIMETER; //Сантиметр
    muDECIMETER:Result:=LIBFPTR_IU_DECIMETER; // Дециметр
    muMETER:Result:=LIBFPTR_IU_METER; // Метр
    muSQUARE_CENTIMETER:Result:=LIBFPTR_IU_SQUARE_CENTIMETER; // Квадратный сантиметр
    muSQUARE_DECIMETER:Result:=LIBFPTR_IU_SQUARE_DECIMETER;//Квадратный дециметр
    muSQUARE_METER:Result:=LIBFPTR_IU_SQUARE_METER; //Квадратный метр
    muMILLILITER:Result:=LIBFPTR_IU_MILLILITER; // Кубический сантиметр; миллилитр
    muLITER:Result:=LIBFPTR_IU_LITER; // Литр; кубический дециметр
    muCUBIC_METER:Result:=LIBFPTR_IU_CUBIC_METER;//Кубический метр
    muKILOWATT_HOUR:Result:=LIBFPTR_IU_KILOWATT_HOUR;//Киловатт-час
    muGKAL:Result:=LIBFPTR_IU_GKAL; // Гигакалория
    muDAY:Result:=LIBFPTR_IU_DAY;//Сутки
    muHOUR:Result:=LIBFPTR_IU_HOUR;//Час
    muMINUTE:Result:=LIBFPTR_IU_MINUTE;//Минута
    muSECOND:Result:=LIBFPTR_IU_SECOND;//Секунда
    muKILOBYTE:Result:=LIBFPTR_IU_KILOBYTE;//Килобайт
    muMEGABYTE:Result:=LIBFPTR_IU_MEGABYTE;//Мегабайт
    muGIGABYTE:Result:=LIBFPTR_IU_GIGABYTE;//Гигабайт
    muTERABYTE:Result:=LIBFPTR_IU_TERABYTE;//Терабайт
  else
    //LIBFPTR_IU_OTHER = 255
    //Result:=LIBFPTR_IU_PIECE;
    Result:=LIBFPTR_IU_OTHER;
  end;
end;

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
    ttaxVat20:Result:=LIBFPTR_TAX_VAT20;
    ttaxVat120:Result:=LIBFPTR_TAX_VAT120;
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
//    InternalCheckError;
{    if Password<>'' then
      FLibrary.SetParamStr(FHandle, 1203, Password);}

    if KassaUserINN <> '' then
    begin
      FLibrary.SetParamStr(FHandle, 1203, KassaUserINN);
//      InternalCheckError;
    end;
    FLibrary.OperatorLogin(FHandle);
    InternalCheckError;
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
  InternalCheckError;
end;

procedure TAtollKKMv10.InternalCloseKKM;
begin
  FLibrary.Close(FHandle);
  //FHandle:=nil;
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

function TAtollKKMv10.InternalRegistration1_05: integer;
var
  FSupInf, FMark: TBytes;
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

  if (GoodsInfo.CountryCode > 0) then
    SetAttributeStr(1230, Format('%0.3d', [GoodsInfo.CountryCode]));


  if (GoodsInfo.DeclarationNumber<> '') then
    SetAttributeStr(1231, GoodsInfo.DeclarationNumber);

  if GoodsInfo.GoodsNomenclatureCode.GroupCode <> 0 then
    FLibrary.SetParamByteArray(FHandle, 1162, GoodsInfo.GoodsNomenclatureCode.Make1162Value)
  else
  begin
    SetLength(FMark, 2);
    FillByte(FMark[0], 2, 0);
    FLibrary.SetParamByteArray(FHandle, 1162, FMark)
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

  if GoodsInfo.GoodsType <> gtNone then
    SetAttributeInt(1212, Ord(GoodsInfo.GoodsType));
  //Сама регистрация
  Result:=FLibrary.Registration(FHandle);
end;

function TAtollKKMv10.InternalRegistration1_2(AGI: TGoodsInfo): integer;
var
  FSupInf, FMark, FIndustryInfo: TBytes;
  FValidationResult, FOfflineValidationErrors,
    FKMOnlineValidationResult: Integer;
  FValidationReady: Boolean;
  FMeasurementUnit: Tlibfptr_item_units;
  FMarkingEstimatedStatus: libfptr_marking_estimated_status;
begin
  FMeasurementUnit:=muOKEItoAtol(AGI.GoodsMeasurementUnit);

  if (AGI.GoodsNomenclatureCode.KM <> '') {and (AGI.GoodsNomenclatureCode.State = 0)} then
  begin
    if CheckType = chtSell then
      FMarkingEstimatedStatus:=LIBFPTR_MES_PIECE_SOLD
    else
      FMarkingEstimatedStatus:=LIBFPTR_MES_PIECE_RETURN; //chtSellReturn

//    if PermissiveModeDoc.UUID <> '' then
    if AGI.GoodsNomenclatureCode.PermissiveModeDoc.UUID <> ''  then
    begin
      //Разрешительный режим
      SetAttributeStr(1262, '030');
      SetAttributeStr(1263, '21.11.2023');
      SetAttributeStr(1264, '1944');
//      SetAttributeStr(1265,  Format('UUID=%s&Time=%s', [PermissiveModeDoc.UUID, PermissiveModeDoc.DocTimeStamp]));
      SetAttributeStr(1265,  Format('UUID=%s&Time=%s', [AGI.GoodsNomenclatureCode.PermissiveModeDoc.UUID, AGI.GoodsNomenclatureCode.PermissiveModeDoc.DocTimeStamp]));

      FLibrary.UtilFormTLV(FHandle);
      FIndustryInfo:=FLibrary.GetParamByteArray(FHandle, Ord(LIBFPTR_PARAM_TAG_VALUE));
//      FLibrary.SetParamByteArray(FHandle, 1260, FIndustryInfo);
//      rxWriteLog(etDebug, 'Заполнили информацию о разрешительном режиме, UUID=%s&Time=%s', [PermissiveModeDoc.UUID, PermissiveModeDoc.DocTimeStamp]);
      rxWriteLog(etDebug, 'Заполнили информацию о разрешительном режиме, UUID=%s&Time=%s', [AGI.GoodsNomenclatureCode.PermissiveModeDoc.UUID, AGI.GoodsNomenclatureCode.PermissiveModeDoc.DocTimeStamp]);
    end;

    SetAttributeInt(Ord(LIBFPTR_PARAM_MARKING_CODE_TYPE), Ord(LIBFPTR_MCT12_AUTO));
    SetAttributeStr(Ord(LIBFPTR_PARAM_MARKING_CODE), AGI.GoodsNomenclatureCode.KM);
    SetAttributeInt(Ord(LIBFPTR_PARAM_MARKING_CODE_STATUS), Ord(FMarkingEstimatedStatus));
//    SetAttributeDouble(Ord(LIBFPTR_PARAM_QUANTITY), AGI.Quantity);
//    SetAttributeInt(Ord(LIBFPTR_PARAM_MEASUREMENT_UNIT), Ord(FMeasurementUnit));
    SetAttributeBool(Ord(LIBFPTR_PARAM_MARKING_WAIT_FOR_VALIDATION_RESULT), WaitForMarkingValidationResult);  //TODO:Добавить поддержку ожидания окончания операции на сервере ОФД
    SetAttributeInt(Ord(LIBFPTR_PARAM_MARKING_PROCESSING_MODE), 0); //TODO:Что это за режим обработки?

    //TODO:Реализовать дробное кол-во товара
    //FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_FRACTIONAL_QUANTITY), Edit3.Text);

    FLibrary.BeginMarkingCodeValidation(Handle);
    InternalCheckError;
    repeat
      FLibrary.GetMarkingCodeValidationStatus(Handle);
      FValidationReady:=FLibrary.GetParamBool(Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_VALIDATION_READY));
      //FValidationReady:=true;
      FValidationResult := FLibrary.GetParamInt(Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT));
    until FValidationReady;

    FValidationResult := FLibrary.GetParamInt(Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT));

    FLibrary.AcceptMarkingCode(Handle);
    AGI.GoodsNomenclatureCode.State:=FLibrary.GetParamInt(Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT));
    InternalCheckError;
  end
  else
  ;

  //Обработаем данные поставщика
  if (AGI.SuplierInfo.Name <> '') and (AGI.SuplierInfo.INN<>'') then
  begin
    if AGI.SuplierInfo.Phone <>'' then
      SetAttributeStr(1171, AGI.SuplierInfo.Phone); //libfptr_set_param_str(fptr, 1171, L"+79113456789");

    SetAttributeStr(1225, AGI.SuplierInfo.Name); //libfptr_set_param_str(fptr, 1225, L"ООО Поставщик");
    FLibrary.UtilFormTLV(FHandle);

    FSupInf:=FLibrary.GetParamByteArray(FHandle, Ord(LIBFPTR_PARAM_TAG_VALUE));

    SetAttributeStr(1226, AGI.SuplierInfo.INN);
    //libfptr_set_param_bytearray(fptr, 1224, &suplierInfo[0]. suplierInfo.size());
    FLibrary.SetParamByteArray(FHandle, 1224, FSupInf);
  end;

  //Регистрируем строку товара
  SetAttributeStr(Ord(LIBFPTR_PARAM_COMMODITY_NAME), AGI.Name);
  SetAttributeDouble(Ord(LIBFPTR_PARAM_PRICE), AGI.Price);
  SetAttributeDouble(Ord(LIBFPTR_PARAM_QUANTITY), AGI.Quantity);
  SetAttributeInt(Ord(LIBFPTR_PARAM_TAX_TYPE), Ord(TaxTypeToAtollTT(AGI.TaxType)));

  if (AGI.CountryCode > 0) then
    SetAttributeStr(1230, Format('%0.3d', [AGI.CountryCode]));


  if (AGI.DeclarationNumber<> '') then
    SetAttributeStr(1231, AGI.DeclarationNumber);


  if AGI.GoodsNomenclatureCode.KM <> '' then
  begin
    //SetAttributeInt(Ord(LIBFPTR_PARAM_MEASUREMENT_UNIT), Ord(LIBFPTR_IU_PIECE));   //TODO:Добавить разные единицы измерения
    SetAttributeInt( 2108 {Ord(LIBFPTR_PARAM_MEASUREMENT_UNIT)}, Ord(LIBFPTR_IU_PIECE));   //TODO:Добавить разные единицы измерения

    //FKKM.LibraryAtol.SetParamStr(FKKM.Handle, LIBFPTR_PARAM_MARKING_FRACTIONAL_QUANTITY, L"1/2");
    SetAttributeStr(Ord(LIBFPTR_PARAM_MARKING_CODE), AGI.GoodsNomenclatureCode.KM);
    SetAttributeInt(Ord(LIBFPTR_PARAM_MARKING_CODE_STATUS), Ord(LIBFPTR_MES_PIECE_SOLD)); //TODO:Добавить продажи/возврат
    SetAttributeInt(Ord(LIBFPTR_PARAM_MARKING_PROCESSING_MODE), 0); //TODO:Что это за режим обработки?
    SetAttributeInt(Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT), AGI.GoodsNomenclatureCode.State);

    //if PermissiveModeDoc.UUID <> '' then
    if AGI.GoodsNomenclatureCode.PermissiveModeDoc.UUID <> '' then
    begin
      FLibrary.SetParamByteArray(FHandle, 1260, FIndustryInfo);
      //rxWriteLog(etDebug, 'Заполнили информацию о разрешительном режиме-2, UUID=%s&Time=%s', [PermissiveModeDoc.UUID, PermissiveModeDoc.DocTimeStamp]);
      rxWriteLog(etDebug, 'Заполнили информацию о разрешительном режиме-2, UUID=%s&Time=%s', [AGI.GoodsNomenclatureCode.PermissiveModeDoc.UUID, AGI.GoodsNomenclatureCode.PermissiveModeDoc.DocTimeStamp]);
    end;
  end
  else
    SetAttributeInt( 2108 {Ord(LIBFPTR_PARAM_MEASUREMENT_UNIT)}, Ord(FMeasurementUnit));   //TODO:Добавить разные единицы измерения


  case AGI.GoodsPayMode of
    //gpmFullPay:SetAttributeInt(1214, 0);
    gpmPrePay100:SetAttributeInt(1214, 1);
    gpmPrePay:SetAttributeInt(1214, 2);
    gpmAvance:SetAttributeInt(1214, 3);
    gpmFullPay2:SetAttributeInt(1214, 4);
    gpmPartialPayAndKredit:SetAttributeInt(1214, 5);
    gpmKredit:SetAttributeInt(1214, 6);
    gpmKreditPay:SetAttributeInt(1214, 7);
  end;

  if AGI.GoodsType <> gtNone then
    SetAttributeInt(1212, Ord(AGI.GoodsType));
  //Сама регистрация
  Result:=FLibrary.Registration(FHandle);
end;

function TAtollKKMv10.InternalRegisterBuyer1_2: TBytes;
var
  FBuyerInf: TBytes;
begin
  Result:=nil;
  if (CounteragentInfo.Name = '') and (CounteragentInfo.INN = '') then Exit;

  if CounteragentInfo.Name <> '' then
    SetAttributeStr(1227, CounteragentInfo.Name);
  if CounteragentInfo.INN<>'' then
    SetAttributeStr(1228, CounteragentInfo.INN);

  FLibrary.UtilFormTLV(FHandle);
  FBuyerInf:=FLibrary.GetParamByteArray(FHandle, Ord(LIBFPTR_PARAM_TAG_VALUE));
  Result:=FBuyerInf;
{
  FLibrary.SetParamByteArray(FHandle, 1256, FBuyerInf);
  InternalCheckError;
}
end;

procedure TAtollKKMv10.InternalSetCorrectionInfo;
var
  FCorrectionInfoBytes: TBytes;
begin
  if CorrectionInfo.CorrectionType = ectNone then
    raise Exception.Create('Unknow correction type');

  if (CorrectionInfo.CorrectionType = ectInstruction) and (CorrectionInfo.CorrectionBaseNumber = '') then
    raise Exception.Create('"CorrectionBaseNumber" not defined');

  //libfptr_set_param_datetime(fptr, 1178, 2018, 1, 2, 0, 0, 0);
  FLibrary.SetParamDateTime(FHandle, 1178, CorrectionInfo.CorrectionDate);
  //libfptr_set_param_str(fptr, 1179, L"№1234");
//  if (CorrectionInfo.CorrectionBaseNumber <> '') and (CorrectionInfo.CorrectionType = ectInstruction) then
    FLibrary.SetParamStr(FHandle, 1179, CorrectionInfo.CorrectionBaseNumber);
  //libfptr_util_form_tlv(fptr);
  FLibrary.UtilFormTLV(FHandle);

  //std::vector<uchar> correctionInfo(128);
  //int size = libfptr_get_param_bytearray(fptr, LIBFPTR_PARAM_TAG_VALUE, &correctionInfo[0], correctionInfo.size());
  //if (size > correctionInfo.size())
  //  {
  //      correctionInfo.resize(size);
  //      libfptr_get_param_bytearray(fptr, LIBFPTR_PARAM_TAG_VALUE, &correctionInfo[0], correctionInfo.size());
  //  }
  //correctionInfo.resize(size);
  FCorrectionInfoBytes:=FLibrary.GetParamByteArray(FHandle, Ord(LIBFPTR_PARAM_TAG_VALUE));
  //libfptr_set_param_int(fptr, LIBFPTR_PARAM_RECEIPT_TYPE, LIBFPTR_RT_SELL_CORRECTION);
  //FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_RECEIPT_TYPE, ) //Это выше по уровню

  //libfptr_set_param_int(fptr, 1173, 1);
  SetAttributeInt(1173, Ord(CorrectionInfo.CorrectionType)-1);
  //libfptr_set_param_bytearray(fptr, 1174, &correctionInfo[0], correctionInfo.size());
  FLibrary.SetParamByteArray(FHandle, 1174, FCorrectionInfoBytes);
end;

procedure TAtollKKMv10.InternalGetDeviceInfo(var ALineLength,
  ALineLengthPix: integer);
begin
  FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_DATA_TYPE, Ord(LIBFPTR_DT_RECEIPT_LINE_LENGTH));
  FLibrary.QueryData(FHandle);
  ALineLength:=FLibrary.GetParamInt(FHandle, Ord(LIBFPTR_PARAM_RECEIPT_LINE_LENGTH));
  ALineLengthPix:=FLibrary.GetParamInt(FHandle, Ord(LIBFPTR_PARAM_RECEIPT_LINE_LENGTH_PIX));
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
      begin
        FLibrary.DestroyHandle(FHandle);
        FHandle:=nil;
      end;
  end;
end;

function TAtollKKMv10.GetShiftState: TShiftState;
var
  C: Tlibfptr_shift_state;
begin
  Result:=ssCLOSED;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_DATA_TYPE, Ord(LIBFPTR_DT_STATUS));
    FLibrary.QueryData(FHandle);
//    InternalCheckError;
    if ErrorCode = 0 then
    begin
      C:=Tlibfptr_shift_state(FLibrary.GetParamInt(FHandle, Ord(LIBFPTR_PARAM_SHIFT_STATE)));
      case C of
        LIBFPTR_SS_CLOSED:Result:=ssCLOSED;
        LIBFPTR_SS_OPENED:Result:=ssOPENED;
        LIBFPTR_SS_EXPIRED:Result:=ssEXPIRED;
      else
        raise Exception.CreateFmt('Не известный статус смены %d', [C]);
      end;
    end;
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
    begin
      Result:=FLibrary.GetParamInt(FHandle, Ord(LIBFPTR_PARAM_RECEIPT_NUMBER));
    end;
  end;
end;

function TAtollKKMv10.GetFDNumber: integer;
begin
  Result:=0;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
     FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_FN_DATA_TYPE, Ord(LIBFPTR_FNDT_LAST_DOCUMENT));
     FLibrary.fnQueryData(FHandle);
     InternalCheckError;
     if ErrorCode = 0 then
     begin
       Result:=FLibrary.GetParamInt(FHandle, Ord(LIBFPTR_PARAM_DOCUMENT_NUMBER));
       InternalCheckError;
     end;
  end;
end;

constructor TAtollKKMv10.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFFD1_2:=false;
  WaitForMarkingValidationResult:=false;
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


function TAtollKKMv10.GetVersionString: string;
begin
  if Assigned(FLibrary) and FLibrary.Loaded and Assigned(FHandle) then
  begin
    Result:=FLibrary.GetVersionString;
    InternalCheckError;
  end
  else
    Result:='';
end;

procedure TAtollKKMv10.GetOFDStatus(out AStatus: TOFDSTatusRecord);
var
  FFirstUnsentDate: TDateTime;
  FOfdMessageRead: Boolean;
  FFirstUnsentNumber, FUnsentCount, FExchangeStatus, C: Integer;
begin
  inherited GetOFDStatus(AStatus);
  if Assigned(FLibrary) and FLibrary.Loaded and Assigned(FHandle) then
  begin
    LibraryAtol.SetParamInt(Handle, LIBFPTR_PARAM_FN_DATA_TYPE, Ord(LIBFPTR_FNDT_OFD_EXCHANGE_STATUS));
    LibraryAtol.fnQueryData(Handle);
    InternalCheckError;
    AStatus.ExchangeStatus:=FLibrary.GetParamInt(Handle, Ord(LIBFPTR_PARAM_OFD_EXCHANGE_STATUS));
    AStatus.UnsentCount:=FLibrary.GetParamInt(Handle, Ord(LIBFPTR_PARAM_DOCUMENTS_COUNT));
    AStatus.FirstUnsentNumber:=FLibrary.GetParamInt(Handle, Ord(LIBFPTR_PARAM_DOCUMENT_NUMBER));
    AStatus.OfdMessageRead:=FLibrary.GetParamBool(Handle, Ord(LIBFPTR_PARAM_OFD_MESSAGE_READ));
    AStatus.LastSendDocDate:=FLibrary.GetParamDateTime(Handle, Ord(LIBFPTR_PARAM_DATE_TIME));
  end;
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

    case TextParams.Align of
      etaLeft:FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_ALIGNMENT, ord(LIBFPTR_ALIGNMENT_LEFT));
      etaCenter:FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_ALIGNMENT,ord(LIBFPTR_ALIGNMENT_CENTER));
      etaRight:FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_ALIGNMENT, ord(LIBFPTR_ALIGNMENT_RIGHT));
    end;

    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_FONT, TextParams.FontNumber);

    FLibrary.SetParamBool(FHandle, LIBFPTR_PARAM_FONT_DOUBLE_WIDTH, TextParams.DoubleWidth);
    FLibrary.SetParamBool(FHandle, LIBFPTR_PARAM_FONT_DOUBLE_HEIGHT, TextParams.DoubleHeight);
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_LINESPACING, TextParams.LineSpacing);
    FLibrary.SetParamInt(FHandle, LIBFPTR_PARAM_BRIGHTNESS, TextParams.Brightness);

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
var
  FBuyerInf: TBytes;
begin
  inherited OpenCheck;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    InternalUserLogin;


    if FFD1_2 then
    begin
      //InternalRegisterBuyer1_2;
      FBuyerInf:=InternalRegisterBuyer1_2;

      if CheckType in [chtSellCorrection, chtSellReturnCorrection, chtBuyCorrection, chtBuyReturnCorrection] then
        InternalSetCorrectionInfo;
      if FBuyerInf<>nil then
        FLibrary.SetParamByteArray(FHandle, 1256, FBuyerInf);
      InternalCheckError;

      InternalSetCheckType(CheckType);
    end
    else
    begin
      if CheckType in [chtSellCorrection, chtSellReturnCorrection, chtBuyCorrection, chtBuyReturnCorrection] then
        InternalSetCorrectionInfo;
      InternalSetCheckType(CheckType);

      if CounteragentInfo.Name <> '' then
        SetAttributeStr(1227, CounteragentInfo.Name);
      if CounteragentInfo.Name <> '' then
        SetAttributeStr(1228, CounteragentInfo.INN);
    end;


    if CounteragentInfo.Email <> '' then
      SetAttributeStr(1008, CounteragentInfo.Email)
    else
    if CounteragentInfo.Phone <> '' then
      SetAttributeStr(1008, CounteragentInfo.Phone);

    if PaymentPlace<>'' then
      SetAttributeStr(1187, PaymentPlace);

    if CheckInfo.Electronically then
      FLibrary.SetParamBool(FHandle, LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY, CheckInfo.Electronically);


    FLibrary.OpenReceipt(FHandle);
    InternalCheckError;
  end;
end;

function TAtollKKMv10.Registration: integer;
begin
  Result:=0;
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    if FFD1_2 then
      Result:=InternalRegistration1_2(GoodsInfo)
    else
      Result:=InternalRegistration1_05;
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

function TAtollKKMv10.RegisterGoods: Integer;
var
  GI: TGoodsInfo;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    for GI in GoodsList do
    begin;
      Result:=InternalRegistration1_2(GI);
      InternalCheckError;
      if ErrorCode <> 0 then
        Exit;
    end;
  end;
end;

function TAtollKKMv10.RegisterPayments: Integer;
var
  FPayInfo: TPaymentInfo;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    for FPayInfo in PaymentsList do
    begin
      RegisterPayment(FPayInfo.PaymentType, FPayInfo.PaymentSum);
      if ErrorCode <> 0 then
        Exit;
    end;
  end;
end;

function TAtollKKMv10.ValidateGoodsKM: Boolean;
var
  GI: TGoodsInfo;
  FMarkingEstimatedStatus: libfptr_marking_estimated_status;
  FMeasurementUnit: Tlibfptr_item_units;
  FValidationReady: Boolean;
begin
  if CheckType = chtSell then
    FMarkingEstimatedStatus:=LIBFPTR_MES_PIECE_SOLD
  else
    FMarkingEstimatedStatus:=LIBFPTR_MES_PIECE_RETURN; //chtSellReturn
  Result:=True;
  for GI in GoodsList do
  begin
    GI.GoodsNomenclatureCode.State:=0;
    if GI.GoodsNomenclatureCode.KM <> '' then
    begin
      FMeasurementUnit:=muOKEItoAtol(GoodsInfo.GoodsMeasurementUnit);

      SetAttributeInt(Ord(LIBFPTR_PARAM_MARKING_CODE_TYPE), Ord(LIBFPTR_MCT12_AUTO));
      SetAttributeStr(Ord(LIBFPTR_PARAM_MARKING_CODE), GI.GoodsNomenclatureCode.KM);
      SetAttributeInt(Ord(LIBFPTR_PARAM_MARKING_CODE_STATUS), Ord(FMarkingEstimatedStatus));
  //    SetAttributeDouble(Ord(LIBFPTR_PARAM_QUANTITY), GoodsInfo.Quantity);
  //    SetAttributeInt(Ord(LIBFPTR_PARAM_MEASUREMENT_UNIT), Ord(FMeasurementUnit));
  //    SetAttributeBool(Ord(LIBFPTR_PARAM_MARKING_WAIT_FOR_VALIDATION_RESULT), WaitForMarkingValidationResult);  //TODO:Добавить поддержку ожидания окончания операции на сервере ОФД
      SetAttributeInt(Ord(LIBFPTR_PARAM_MARKING_PROCESSING_MODE), 0); //TODO:Что это за режим обработки?

      //TODO:Реализовать дробное кол-во товара
      //FKKM.LibraryAtol.SetParamStr(FKKM.Handle, Ord(LIBFPTR_PARAM_MARKING_FRACTIONAL_QUANTITY), Edit3.Text);

      FLibrary.BeginMarkingCodeValidation(Handle);
      InternalCheckError;

      if ErrorCode <> 0 then
      begin
        FLibrary.CancelMarkingCodeValidation(Handle);
        Exit(false);
      end;

      repeat
        FLibrary.GetMarkingCodeValidationStatus(Handle);
        InternalCheckError;
        FValidationReady:=FLibrary.GetParamBool(Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_VALIDATION_READY));
      until FValidationReady;

      FLibrary.AcceptMarkingCode(Handle);
      GI.GoodsNomenclatureCode.State:=FLibrary.GetParamInt(Handle, Ord(LIBFPTR_PARAM_MARKING_CODE_ONLINE_VALIDATION_RESULT));
      if GI.GoodsNomenclatureCode.State <> %00001111 then
        Result:=false;
      InternalCheckError;
    end;
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

procedure TAtollKKMv10.BeginNonfiscalDocument;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.BeginNonfiscalDocument(FHandle);
    InternalCheckError;
  end;
end;

procedure TAtollKKMv10.EndNonfiscalDocument;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.EndNonfiscalDocument(FHandle);
    InternalCheckError;
  end;
end;

function TAtollKKMv10.UpdateFnmKeys: Integer;
begin
  if Assigned(FLibrary) and FLibrary.Loaded then
  begin
    FLibrary.UpdateFnmKeys(Handle);
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

  //ver10.4.5.0
  Flibfptr_reset_error:=nil;
  Flibfptr_download_picture:=nil;
  Flibfptr_util_tag_info:=nil;
  Flibfptr_bluetooth_remove_paired_devices:=nil;
  Flibfptr_util_container_versions:=nil;

  //ver 10.5.0.0
  Flibfptr_set_user_param_bool:=nil;
  Flibfptr_set_user_param_int:=nil;
  Flibfptr_set_user_param_double:=nil;
  Flibfptr_set_user_param_str:=nil;
  Flibfptr_set_user_param_datetime:=nil;
  Flibfptr_set_user_param_bytearray:=nil;

  Flibfptr_activate_licenses:=nil;
  Flibfptr_remove_licenses:=nil;
  Flibfptr_enter_keys:=nil;
  Flibfptr_validate_keys:=nil;
  Flibfptr_enter_serial_number:=nil;
  Flibfptr_get_serial_number_request:=nil;
  Flibfptr_upload_pixel_buffer:=nil;
  Flibfptr_download_pixel_buffer:=nil;
  Flibfptr_print_pixel_buffer:=nil;
  Flibfptr_util_convert_tag_value:=nil;
  Flibfptr_parse_marking_code:=nil;

  //ver 10.5.1.3
  Flibfptr_call_script:=nil;
  Flibfptr_set_header_lines:=nil;
  Flibfptr_set_footer_lines:=nil;

  //ver 10.6.2.0
  Flibfptr_upload_picture_cliche:=nil;
  Flibfptr_upload_picture_memory:=nil;
  Flibfptr_upload_pixel_buffer_cliche:=nil;
  Flibfptr_upload_pixel_buffer_memory:=nil;
  Flibfptr_exec_driver_script:=nil;
  Flibfptr_upload_driver_script:=nil;
  Flibfptr_exec_driver_script_by_id:=nil;
  Flibfptr_write_universal_counters_settings:=nil;
  Flibfptr_read_universal_counters_settings:=nil;
  Flibfptr_query_universal_counters_state:=nil;
  Flibfptr_reset_universal_counters:=nil;
  Flibfptr_cache_universal_counters:=nil;
  Flibfptr_read_universal_counter_sum:=nil;
  Flibfptr_read_universal_counter_quantity:=nil;
  Flibfptr_clear_universal_counters_cache:=nil;

  //ver 10.6.3.0
  Flibfptr_disable_ofd_channel:=nil;
  Flibfptr_enable_ofd_channel:=nil;

  //ver 10.7.0.0
  Flibfptr_create_with_id:=nil;
  Flibfptr_validate_json:=nil;
  Flibfptr_log_write_ex:=nil;

  //
  FAtollLib:=NilHandle;
end;

function TAtollLibraryV10.GetLoaded: boolean;
begin
  Result := FAtollLib <> NilHandle;
end;

constructor TAtollLibraryV10.Create;
begin
  inherited Create;
  InternalClearProcAdress;
  FLibraryName:=slibFPPtr10FileName
end;

destructor TAtollLibraryV10.Destroy;
begin
  Unload;
  inherited Destroy;
end;

procedure TAtollLibraryV10.LoadAtollLibrary;

function DoGetProcAddress(Lib: TLibHandle; Name: string; ARaiseException:Boolean = true): Pointer;
begin
  Result := GetProcedureAddress(Lib, Name);
  if (not Assigned(Result)) and ARaiseException then
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
    //ver10.4.5.0
    Flibfptr_reset_error:=Tlibfptr_reset_error(DoGetProcAddress(FAtollLib, 'libfptr_reset_error'));
    Flibfptr_download_picture:=Tlibfptr_download_picture(DoGetProcAddress(FAtollLib, 'libfptr_download_picture'));
    Flibfptr_util_tag_info:=Tlibfptr_util_tag_info(DoGetProcAddress(FAtollLib, 'libfptr_util_tag_info'));
    Flibfptr_bluetooth_remove_paired_devices:=Tlibfptr_bluetooth_remove_paired_devices(DoGetProcAddress(FAtollLib, 'libfptr_bluetooth_remove_paired_devices'));
    Flibfptr_util_container_versions:=Tlibfptr_util_container_versions(DoGetProcAddress(FAtollLib, 'libfptr_util_container_versions'));

    //ver 10.5.0.0
    Flibfptr_set_user_param_bool:=Tlibfptr_set_user_param_bool(DoGetProcAddress(FAtollLib, 'libfptr_set_user_param_bool'));
    Flibfptr_set_user_param_int:=Tlibfptr_set_user_param_int(DoGetProcAddress(FAtollLib, 'libfptr_set_user_param_int'));
    Flibfptr_set_user_param_double:=Tlibfptr_set_user_param_double(DoGetProcAddress(FAtollLib, 'libfptr_set_user_param_double'));
    Flibfptr_set_user_param_str:=Tlibfptr_set_user_param_str(DoGetProcAddress(FAtollLib, 'libfptr_set_user_param_str'));
    Flibfptr_set_user_param_datetime:=Tlibfptr_set_user_param_datetime(DoGetProcAddress(FAtollLib, 'libfptr_set_user_param_datetime'));
    Flibfptr_set_user_param_bytearray:=Tlibfptr_set_user_param_bytearray(DoGetProcAddress(FAtollLib, 'libfptr_set_user_param_bytearray'));

    Flibfptr_activate_licenses:=Tlibfptr_activate_licenses(DoGetProcAddress(FAtollLib, 'libfptr_activate_licenses'));
    Flibfptr_remove_licenses:=Tlibfptr_remove_licenses(DoGetProcAddress(FAtollLib, 'libfptr_remove_licenses'));
    Flibfptr_enter_keys:=Tlibfptr_enter_keys(DoGetProcAddress(FAtollLib, 'libfptr_enter_keys'));
    Flibfptr_validate_keys:=Tlibfptr_validate_keys(DoGetProcAddress(FAtollLib, 'libfptr_validate_keys'));
    Flibfptr_enter_serial_number:=Tlibfptr_enter_serial_number(DoGetProcAddress(FAtollLib, 'libfptr_enter_serial_number'));
    Flibfptr_get_serial_number_request:=Tlibfptr_get_serial_number_request(DoGetProcAddress(FAtollLib, 'libfptr_get_serial_number_request'));
    Flibfptr_upload_pixel_buffer:=Tlibfptr_upload_pixel_buffer(DoGetProcAddress(FAtollLib, 'libfptr_upload_pixel_buffer'));
    Flibfptr_download_pixel_buffer:=Tlibfptr_download_pixel_buffer(DoGetProcAddress(FAtollLib, 'libfptr_download_pixel_buffer'));
    Flibfptr_print_pixel_buffer:=Tlibfptr_print_pixel_buffer(DoGetProcAddress(FAtollLib, 'libfptr_print_pixel_buffer'));
    Flibfptr_util_convert_tag_value:=Tlibfptr_util_convert_tag_value(DoGetProcAddress(FAtollLib, 'libfptr_util_convert_tag_value'));
    Flibfptr_parse_marking_code:=Tlibfptr_parse_marking_code(DoGetProcAddress(FAtollLib, 'libfptr_parse_marking_code'));

    //ver 10.5.1.3
    Flibfptr_call_script:=Tlibfptr_call_script(DoGetProcAddress(FAtollLib, 'libfptr_call_script'));
    Flibfptr_set_header_lines:=Tlibfptr_set_header_lines(DoGetProcAddress(FAtollLib, 'libfptr_set_header_lines'));
    Flibfptr_set_footer_lines:=Tlibfptr_set_header_lines(DoGetProcAddress(FAtollLib, 'libfptr_set_footer_lines'));

    //ver 10.6.2.0
    Flibfptr_upload_picture_cliche:=Tlibfptr_upload_picture_cliche(DoGetProcAddress(FAtollLib, 'libfptr_upload_picture_cliche'));
    Flibfptr_upload_picture_memory:=Tlibfptr_upload_picture_memory(DoGetProcAddress(FAtollLib, 'libfptr_upload_picture_memory'));
    Flibfptr_upload_pixel_buffer_cliche:=Tlibfptr_upload_pixel_buffer_cliche(DoGetProcAddress(FAtollLib, 'libfptr_upload_pixel_buffer_cliche'));
    Flibfptr_upload_pixel_buffer_memory:=Tlibfptr_upload_pixel_buffer_memory(DoGetProcAddress(FAtollLib, 'libfptr_upload_pixel_buffer_memory'));
    Flibfptr_exec_driver_script:=Tlibfptr_exec_driver_script(DoGetProcAddress(FAtollLib, 'libfptr_exec_driver_script'));
    Flibfptr_upload_driver_script:=Tlibfptr_upload_driver_script(DoGetProcAddress(FAtollLib, 'libfptr_upload_driver_script'));
    Flibfptr_exec_driver_script_by_id:=Tlibfptr_exec_driver_script_by_id(DoGetProcAddress(FAtollLib, 'libfptr_exec_driver_script_by_id'));
    Flibfptr_write_universal_counters_settings:=Tlibfptr_write_universal_counters_settings(DoGetProcAddress(FAtollLib, 'libfptr_write_universal_counters_settings'));
    Flibfptr_read_universal_counters_settings:=Tlibfptr_read_universal_counters_settings(DoGetProcAddress(FAtollLib, 'libfptr_read_universal_counters_settings'));
    Flibfptr_query_universal_counters_state:=Tlibfptr_query_universal_counters_state(DoGetProcAddress(FAtollLib, 'libfptr_query_universal_counters_state'));
    Flibfptr_reset_universal_counters:=Tlibfptr_reset_universal_counters(DoGetProcAddress(FAtollLib, 'libfptr_reset_universal_counters'));
    Flibfptr_cache_universal_counters:=Tlibfptr_cache_universal_counters(DoGetProcAddress(FAtollLib, 'libfptr_cache_universal_counters'));
    Flibfptr_read_universal_counter_sum:=Tlibfptr_read_universal_counter_sum(DoGetProcAddress(FAtollLib, 'libfptr_read_universal_counter_sum'));
    Flibfptr_read_universal_counter_quantity:=Tlibfptr_read_universal_counter_quantity(DoGetProcAddress(FAtollLib, 'libfptr_read_universal_counter_quantity'));
    Flibfptr_clear_universal_counters_cache:=Tlibfptr_clear_universal_counters_cache(DoGetProcAddress(FAtollLib, 'libfptr_clear_universal_counters_cache'));

    //ver 10.6.3.0
    Flibfptr_disable_ofd_channel:=Tlibfptr_disable_ofd_channel(DoGetProcAddress(FAtollLib, 'libfptr_disable_ofd_channel'));
    Flibfptr_enable_ofd_channel:=Tlibfptr_enable_ofd_channel(DoGetProcAddress(FAtollLib, 'libfptr_enable_ofd_channel'));

    //ver 10.7.0.0
    //Flibfptr_create_with_id:=Tlibfptr_create_with_id(DoGetProcAddress(FAtollLib, 'libfptr_create_with_id'));
    //Flibfptr_validate_json:=Tlibfptr_validate_json(DoGetProcAddress(FAtollLib, 'libfptr_validate_json'));
    //Flibfptr_log_write_ex:=Tlibfptr_log_write_ex(DoGetProcAddress(FAtollLib, 'libfptr_log_write_ex'));

    //ver 10.9.0.0
    Flibfptr_begin_marking_code_validation:=Tlibfptr_begin_marking_code_validation(DoGetProcAddress(FAtollLib, 'libfptr_begin_marking_code_validation', false));
    Flibfptr_cancel_marking_code_validation:=Tlibfptr_cancel_marking_code_validation(DoGetProcAddress(FAtollLib, 'libfptr_cancel_marking_code_validation', false));
    Flibfptr_get_marking_code_validation_status:=Tlibfptr_get_marking_code_validation_status(DoGetProcAddress(FAtollLib, 'libfptr_get_marking_code_validation_status', false));
    Flibfptr_accept_marking_code:=Tlibfptr_accept_marking_code(DoGetProcAddress(FAtollLib, 'libfptr_accept_marking_code', false));
    Flibfptr_decline_marking_code:=Tlibfptr_decline_marking_code(DoGetProcAddress(FAtollLib, 'libfptr_decline_marking_code', false));
    Flibfptr_update_fnm_keys:=Tlibfptr_update_fnm_keys(DoGetProcAddress(FAtollLib, 'libfptr_update_fnm_keys', false));
    Flibfptr_write_sales_notice:=Tlibfptr_write_sales_notice(DoGetProcAddress(FAtollLib, 'libfptr_write_sales_notice', false));
    Flibfptr_check_marking_code_validations_ready:=Tlibfptr_check_marking_code_validations_ready(DoGetProcAddress(FAtollLib, 'libfptr_check_marking_code_validations_ready', false));
    Flibfptr_clear_marking_code_validation_result:=Tlibfptr_clear_marking_code_validation_result(DoGetProcAddress(FAtollLib, 'libfptr_clear_marking_code_validation_result', false));
    Flibfptr_ping_marking_server:=Tlibfptr_ping_marking_server(DoGetProcAddress(FAtollLib, 'libfptr_ping_marking_server', false));
    Flibfptr_get_marking_server_status:=Tlibfptr_get_marking_server_status(DoGetProcAddress(FAtollLib, 'libfptr_get_marking_server_status', false));
    Flibfptr_is_driver_locked:=Tlibfptr_is_driver_locked(DoGetProcAddress(FAtollLib, 'libfptr_is_driver_locked', false));
    Flibfptr_get_last_document_journal:=Tlibfptr_get_last_document_journal(DoGetProcAddress(FAtollLib, 'libfptr_get_last_document_journal', false));
  end;
end;

procedure TAtollLibraryV10.Unload;
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
  Result:='';
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

procedure TAtollLibraryV10.SetParamBool(Handle: TLibFPtrHandle;
  ParamId: Tlibfptr_param; Value: Boolean);
begin
  SetParamBool(Handle, Ord(ParamId), Value);
end;

procedure TAtollLibraryV10.SetParamBool(Handle: TLibFPtrHandle; ParamId: Integer; Value: Boolean); inline;
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
var
  L: Integer;
begin
  L:=Length(Value);
  if Assigned(Flibfptr_set_param_bytearray) then
    Flibfptr_set_param_bytearray(Handle, ParamId, @Value[0], L)
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
    Result:=Flibfptr_soft_lock_init(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_soft_lock_init']);
end;

function TAtollLibraryV10.SoftLockQuerySessionCode(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_soft_lock_query_session_code) then
    Result:=Flibfptr_soft_lock_query_session_code(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_soft_lock_query_session_code']);
end;

function TAtollLibraryV10.SoftLockValidate(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_soft_lock_validate) then
    Result:=Flibfptr_soft_lock_validate(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_soft_lock_validate']);
end;

function TAtollLibraryV10.UtilCalcTax(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_util_calc_tax) then
    Result:=Flibfptr_util_calc_tax(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_util_calc_tax']);
end;

procedure TAtollLibraryV10.ResetError(Handle: TLibFPtrHandle);
begin
  if Assigned(Flibfptr_reset_error) then
    Flibfptr_reset_error(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_reset_error']);
end;

function TAtollLibraryV10.DownloadPicture(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_download_picture) then
    Result:=Flibfptr_download_picture(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_download_picture']);
end;

function TAtollLibraryV10.UtilTagInfo(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_util_tag_info) then
    Result:=Flibfptr_util_tag_info(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_util_tag_info']);
end;

function TAtollLibraryV10.BluetoothRemovePairedDevices(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_bluetooth_remove_paired_devices) then
    Result:=Flibfptr_bluetooth_remove_paired_devices(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_bluetooth_remove_paired_devices']);
end;

function TAtollLibraryV10.UtilContainerVersions(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_util_container_versions) then
    Result:=Flibfptr_util_container_versions(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_util_container_versions']);
end;

procedure TAtollLibraryV10.SetUserParamBool(Handle: TLibFPtrHandle;
  ParamId: Integer; value: Integer);
begin
  if Assigned(Flibfptr_set_user_param_bool) then
    Flibfptr_set_user_param_bool(Handle, ParamId, value)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['Flibfptr_set_user_param_bool']);
end;

procedure TAtollLibraryV10.SetUserParamInt(Handle: TLibFPtrHandle;
  ParamId: Integer; value: Cardinal);
begin
  if Assigned(Flibfptr_set_user_param_int) then
    Flibfptr_set_user_param_int(Handle, ParamId, value)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_user_param_int']);
end;

procedure TAtollLibraryV10.SetUserParamDouble(Handle: TLibFPtrHandle;
  ParamId: Integer; value: Double);
begin
  if Assigned(Flibfptr_set_user_param_double) then
    Flibfptr_set_user_param_double(Handle, ParamId, value)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_user_param_double']);
end;

procedure TAtollLibraryV10.SetUserParamStr(Handle: TLibFPtrHandle;
  ParamId: Integer; value: String);
var
  FValueW: TAtollWideString;
begin
  if Assigned(Flibfptr_set_user_param_str) then
  begin
    if Value = '' then
      Value := ' ';
    FValueW:=StringToAtollWideStr(Value);
    Flibfptr_set_user_param_str(Handle, ParamId, @FValueW[aFirstStrChar]);
  end
  else
  raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_user_param_str']);

end;

procedure TAtollLibraryV10.SetUserParamDateTime(Handle: TLibFPtrHandle;
  ParamId: Integer; Value: TDateTime);
var
  Y, M, D, H, N, S, MS: word;
begin
  if Assigned(Flibfptr_set_user_param_datetime) then
  begin
    DecodeDate(Value, Y, M, D);
    DecodeTime(Value, H, N, S, MS);
    Flibfptr_set_user_param_datetime(Handle, ParamId, Y, M, D, H, N, S);
  end
  else
  raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_user_param_datetime']);
end;

procedure TAtollLibraryV10.SetUserParamByteArray(Handle: TLibFPtrHandle;
  ParamId: Integer; Value: TBytes);
begin
  if Assigned(Flibfptr_set_user_param_bytearray) then
    Flibfptr_set_user_param_bytearray(Handle, ParamId, @Value[0], Length(Value))
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_user_param_bytearray']);
end;

function TAtollLibraryV10.ActivateLicenses(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_activate_licenses) then
    Result:=Flibfptr_activate_licenses(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['Flibfptr_activate_licenses']);
end;

function TAtollLibraryV10.RemoveLicenses(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_remove_licenses) then
    Result:=Flibfptr_remove_licenses(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['Flibfptr_remove_licenses']);
end;

function TAtollLibraryV10.EnterKeys(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_enter_keys) then
    Result:=Flibfptr_enter_keys(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_enter_keys']);
end;

function TAtollLibraryV10.ValidateKeys(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_validate_keys) then
    Result:=Flibfptr_validate_keys(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_validate_keys']);
end;

function TAtollLibraryV10.EnterSerialNumber(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_enter_serial_number) then
    Result:=Flibfptr_enter_serial_number(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_enter_serial_number']);
end;

function TAtollLibraryV10.GetSerialNumberRequest(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_get_serial_number_request) then
    Result:=Flibfptr_get_serial_number_request(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_serial_number_request']);
end;

function TAtollLibraryV10.UploadPixelBuffer(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_upload_pixel_buffer) then
    Result:=Flibfptr_upload_pixel_buffer(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_upload_pixel_buffer']);
end;

function TAtollLibraryV10.DownloadPixelBuffer(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_download_pixel_buffer) then
    Result:=Flibfptr_download_pixel_buffer(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_download_pixel_buffer']);
end;

function TAtollLibraryV10.PrintPixelBuffer(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_print_pixel_buffer) then
    Result:=Flibfptr_print_pixel_buffer(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_print_pixel_buffer']);
end;

function TAtollLibraryV10.UtilConvertTagValue(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_util_convert_tag_value) then
    Result:=Flibfptr_util_convert_tag_value(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_util_convert_tag_value']);
end;

function TAtollLibraryV10.ParseMarkingCode(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_parse_marking_code) then
    Result:=Flibfptr_parse_marking_code(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_parse_marking_code']);
end;

function TAtollLibraryV10.CallScript(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_call_script) then
    Result:=Flibfptr_call_script(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_call_script']);
end;

function TAtollLibraryV10.SetHeaderLines(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_set_header_lines) then
    Result:=Flibfptr_set_header_lines(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_header_lines']);
end;

function TAtollLibraryV10.SetFooterLines(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_set_footer_lines) then
    Result:=Flibfptr_set_footer_lines(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_set_footer_lines']);
end;

function TAtollLibraryV10.UploadPictureCliche(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_upload_picture_cliche) then
    Result:=Flibfptr_upload_picture_cliche(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_upload_picture_cliche']);
end;

function TAtollLibraryV10.UploadPictureMemory(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_upload_picture_memory) then
    Result:=Flibfptr_upload_picture_memory(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_upload_picture_memory']);
end;

function TAtollLibraryV10.UploadPixelBufferCliche(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_upload_pixel_buffer_cliche) then
    Result:=Flibfptr_upload_pixel_buffer_cliche(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_upload_pixel_buffer_cliche']);
end;

function TAtollLibraryV10.UploadPixelBufferMemory(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_upload_pixel_buffer_memory) then
    Result:=Flibfptr_upload_pixel_buffer_memory(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_upload_pixel_buffer_memory']);
end;

function TAtollLibraryV10.ExecDriverScript(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_exec_driver_script) then
    Result:=Flibfptr_exec_driver_script(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_exec_driver_script']);
end;

function TAtollLibraryV10.UploadDriverScript(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_upload_driver_script) then
    Result:=Flibfptr_upload_driver_script(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_upload_driver_script']);
end;

function TAtollLibraryV10.ExecDriverScriptById(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_exec_driver_script_by_id) then
    Result:=Flibfptr_exec_driver_script_by_id(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_exec_driver_script_by_id']);
end;

function TAtollLibraryV10.WriteUniversalCountersSettings(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_write_universal_counters_settings) then
    Result:=Flibfptr_write_universal_counters_settings(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_write_universal_counters_settings']);
end;

function TAtollLibraryV10.ReadUniversalCountersSettings(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_read_universal_counters_settings) then
    Result:=Flibfptr_read_universal_counters_settings(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_read_universal_counters_settings']);
end;

function TAtollLibraryV10.QueryUniversalCountersState(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_query_universal_counters_state) then
    Result:=Flibfptr_query_universal_counters_state(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_query_universal_counters_state']);
end;

function TAtollLibraryV10.ResetUniversalCounters(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_reset_universal_counters) then
    Result:=Flibfptr_reset_universal_counters(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_reset_universal_counters']);
end;

function TAtollLibraryV10.CacheUniversalCounters(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_cache_universal_counters) then
    Result:=Flibfptr_cache_universal_counters(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_cache_universal_counters']);
end;

function TAtollLibraryV10.ReadUniversalCounterSum(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_read_universal_counter_sum) then
    Result:=Flibfptr_read_universal_counter_sum(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_read_universal_counter_sum']);
end;

function TAtollLibraryV10.ReadUniversalCounterQuantity(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_read_universal_counter_quantity) then
    Result:=Flibfptr_read_universal_counter_quantity(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_read_universal_counter_quantity']);
end;

function TAtollLibraryV10.ClearUniversalCountersCache(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_clear_universal_counters_cache) then
    Result:=Flibfptr_clear_universal_counters_cache(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_clear_universal_counters_cache']);
end;

function TAtollLibraryV10.DisableOfdChannel(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_disable_ofd_channel) then
    Result:=Flibfptr_disable_ofd_channel(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_disable_ofd_channel']);
end;

function TAtollLibraryV10.EnableOfdChannel(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_enable_ofd_channel) then
    Result:=Flibfptr_enable_ofd_channel(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['Flibfptr_enable_ofd_channel']);
end;

function TAtollLibraryV10.CreateWithId(Handle: PLibFPtrHandle; id: string
  ): integer;
var
  FId: TAtollWideString;
begin
  if Assigned(Flibfptr_create_with_id) then
  begin
    FId:=StringToAtollWideStr(Id);
    Result:=Flibfptr_create_with_id(Handle, @FId[aFirstStrChar])
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['Flibfptr_create_with_id']);
end;

function TAtollLibraryV10.ValidateJson(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_validate_json) then
    Result:=Flibfptr_validate_json(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['Flibfptr_validate_json']);
end;

function TAtollLibraryV10.LogWriteEx(Handle: TLibFPtrHandle; Tag: string;
  Level: Integer; Message: string): Integer;
var
  FTag, FMessage: TAtollWideString;
begin
  if Assigned(Flibfptr_log_write_ex) then
  begin
    FTag:=StringToAtollWideStr(Tag);
    FMessage:=StringToAtollWideStr(Message);
    Result:=Flibfptr_log_write_ex(Handle, @FTag[aFirstStrChar], Level, @FMessage[aFirstStrChar])
  end
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_log_write_ex']);
end;

function TAtollLibraryV10.BeginMarkingCodeValidation(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_begin_marking_code_validation) then
    Result:=Flibfptr_begin_marking_code_validation(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_begin_marking_code_validation']);
end;

function TAtollLibraryV10.CancelMarkingCodeValidation(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_cancel_marking_code_validation) then
    Result:=Flibfptr_cancel_marking_code_validation(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_cancel_marking_code_validation']);
end;

function TAtollLibraryV10.GetMarkingCodeValidationStatus(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_get_marking_code_validation_status) then
    Result:=Flibfptr_get_marking_code_validation_status(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_marking_code_validation_status']);
end;

function TAtollLibraryV10.AcceptMarkingCode(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_accept_marking_code) then
    Result:=Flibfptr_accept_marking_code(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_accept_marking_code']);
end;

function TAtollLibraryV10.DeclineMarkingCode(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_decline_marking_code) then
    Result:=Flibfptr_decline_marking_code(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_decline_marking_code']);
end;

function TAtollLibraryV10.UpdateFnmKeys(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_update_fnm_keys) then
    Result:=Flibfptr_update_fnm_keys(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_update_fnm_keys']);
end;

function TAtollLibraryV10.WriteSalesNotice(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_write_sales_notice) then
    Result:=Flibfptr_write_sales_notice(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_write_sales_notice']);
end;

function TAtollLibraryV10.CheckMarkingCodeValidationsReady(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_check_marking_code_validations_ready) then
    Result:=Flibfptr_check_marking_code_validations_ready(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_check_marking_code_validations_ready']);
end;

function TAtollLibraryV10.ClearMarkingCodeValidationResult(
  Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_clear_marking_code_validation_result) then
    Result:=Flibfptr_clear_marking_code_validation_result(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_clear_marking_code_validation_result']);
end;

function TAtollLibraryV10.PingMarkingServer(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_ping_marking_server) then
    Result:=Flibfptr_ping_marking_server(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_ping_marking_server']);
end;

function TAtollLibraryV10.GetMarkingServerStatus(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_get_marking_server_status) then
    Result:=Flibfptr_get_marking_server_status(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_marking_server_status']);
end;

function TAtollLibraryV10.IsDriverLocked(Handle: TLibFPtrHandle): Integer;
begin
  if Assigned(Flibfptr_is_driver_locked) then
    Result:=Flibfptr_is_driver_locked(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_is_driver_locked']);
end;

function TAtollLibraryV10.GetLastDocumentJournal(Handle: TLibFPtrHandle
  ): Integer;
begin
  if Assigned(Flibfptr_get_last_document_journal) then
    Result:=Flibfptr_get_last_document_journal(Handle)
  else
    raise EAtollLibrary.CreateFmt(sCantLoadProc, ['libfptr_get_last_document_journal']);
end;

end.
