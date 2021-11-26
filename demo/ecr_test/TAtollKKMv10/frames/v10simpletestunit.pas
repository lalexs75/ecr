{
  Test application for atoll cashe register

  Copyright (C) 2021 Lagunov Aleksey alexs75@yandex.ru

  This source is free software; you can redistribute it and/or modify it under the terms of the GNU General Public
  License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later
  version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web at
  <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing to the Free Software Foundation, Inc., 51
  Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.
}

unit v10SimpleTestUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  tv10globalunit;

type

  { Tv10SimpleTestFrame }

  Tv10SimpleTestFrame = class(TConfigFrame)
    Button1: TButton;
    Button10: TButton;
    Button18: TButton;
    Button2: TButton;
    Button23: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit6: TEdit;
    Label26: TLabel;
    SpinEdit1: TSpinEdit;
    procedure Button10Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

implementation

{$R *.lfm}

{ Tv10SimpleTestFrame }

procedure Tv10SimpleTestFrame.Button1Click(Sender: TObject);
var
  R, DocumentNumber: Integer;
  S: UTF8String;
  S1: String;
  D1: TDateTime;
begin
(*  InitAtollInstance;

  if FAtollInstance.Loaded then
  begin
    WriteLog('FAtollInstance.Loaded');
    KKM_Handle:=nil;
    R:=0;
    R:=FAtollInstance.CreateHandle(KKM_Handle);
    if R = 0 then
    begin
      ShowStatus('CreateHandle');
      FAtollInstance.Open(KKM_Handle);
(*
      S:=FAtollInstance.GetSettings(KKM_Handle);
      ShowStatus('GetSettings');
      WriteLog('GetSettings = '+S);

      WriteLog('GetVersionString = '+FAtollInstance.GetVersionString);

      S:=FAtollInstance.GetSingleSetting(KKM_Handle, LIBFPTR_SETTING_IPADDRESS);
      WriteLog('LIBFPTR_SETTING_IPADDRESS = '+S);

      WriteLog('LIBFPTR_SETTING_LIBRARY_PATH = '+FAtollInstance.GetSingleSetting(KKM_Handle, LIBFPTR_SETTING_LIBRARY_PATH));
      WriteLog('LIBFPTR_SETTING_MODEL = '+FAtollInstance.GetSingleSetting(KKM_Handle, LIBFPTR_SETTING_MODEL));

      //LIBFPTR_SETTING_ACCESS_PASSWORD - пароль доступа ККТ. Требуется для взаимодействия с ККТ. Если не указан или пуст, используется стандартный пароль в зависимости от настройки LIBFPTR_SETTING_MODEL.
      WriteLog('LIBFPTR_SETTING_ACCESS_PASSWORD = '+FAtollInstance.GetSingleSetting(KKM_Handle, LIBFPTR_SETTING_ACCESS_PASSWORD));
      //LIBFPTR_SETTING_USER_PASSWORD - пароль пользователя по умолчанию. Требуется для доступа к специфичным командам и режимам ККТ. Если не указан или пуст, используется пароль по умолчанию с максимальными правами в зависимости от настройки LIBFPTR_SETTING_MODEL.
      WriteLog('LIBFPTR_SETTING_USER_PASSWORD = '+FAtollInstance.GetSingleSetting(KKM_Handle, LIBFPTR_SETTING_USER_PASSWORD));
      //LIBFPTR_SETTING_OFD_CHANNEL - канал для обмена с ОФД. По умолчанию - LIBFPTR_OFD_CHANNEL_NONE. Для корректной работы требуется дополнительная настройка ККТ (настройка #276, см. Настройки ККТ). Возможные значения:
      WriteLog('LIBFPTR_SETTING_OFD_CHANNEL = '+FAtollInstance.GetSingleSetting(KKM_Handle, LIBFPTR_SETTING_OFD_CHANNEL));

*)
      //libfptr_set_param_int(fptr, LIBFPTR_PARAM_FN_DATA_TYPE, LIBFPTR_FNDT_LAST_DOCUMENT);
      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_FN_DATA_TYPE, Ord(LIBFPTR_FNDT_LAST_DOCUMENT));
      ///R:=FAtollInstance.ErrorCode(KKM_Handle);
      //S:=FAtollInstance.ErrorDescription(KKM_Handle);
      //WriteLog(S);
      ///libfptr_fn_query_data(fptr);
      R:=FAtollInstance.fnQueryData(KKM_Handle);

//      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_DATA_TYPE, Ord(LIBFPTR_FNDT_TAG_VALUE));
//      R:=FAtollInstance.QueryData(KKM_Handle);
      R:=FAtollInstance.ErrorCode(KKM_Handle);
      S:=FAtollInstance.ErrorDescription(KKM_Handle);
      WriteLog(S);
      //int documentNumber      = libfptr_get_param_int(fptr, LIBFPTR_PARAM_DOCUMENT_NUMBER);
      DocumentNumber:=FAtollInstance.GetParamInt(KKM_Handle, Ord(LIBFPTR_PARAM_DOCUMENT_NUMBER));
      R:=FAtollInstance.ErrorCode(KKM_Handle);
      S:=FAtollInstance.ErrorDescription(KKM_Handle);
      WriteLog(S);
      WriteLog('LIBFPTR_PARAM_DOCUMENT_NUMBER = '+IntToStr(DocumentNumber));


      S1:=FAtollInstance.GetParamStr(KKM_Handle, Ord(LIBFPTR_PARAM_FISCAL_SIGN));
      R:=FAtollInstance.ErrorCode(KKM_Handle);
      S:=FAtollInstance.ErrorDescription(KKM_Handle);
      WriteLog(S);
      WriteLog('LIBFPTR_PARAM_FISCAL_SIGN = '+S1);

      D1:=FAtollInstance.GetParamDateTime(KKM_Handle, Ord(LIBFPTR_PARAM_DATE_TIME));
      R:=FAtollInstance.ErrorCode(KKM_Handle);
      S:=FAtollInstance.ErrorDescription(KKM_Handle);
      WriteLog(S);
      WriteLog('LIBFPTR_PARAM_FISCAL_SIGN = '+DateTimeToStr(D1));


      FAtollInstance.Close(KKM_Handle);
      FAtollInstance.DestroyHandle(KKM_Handle);
      WriteLog('DestroyHandle');
    end
    else
      WriteLog('Error create handle');
  end
  else
    WriteLog('Error load!');
*)
  //DoneAtollInstance;
end;

procedure Tv10SimpleTestFrame.Button10Click(Sender: TObject);
var
  S: String;
  R, FShiftState: Integer;
begin
(*  InitAtollInstance;



  if FAtollInstance.Loaded then
  begin
    WriteLog('Прочие параметры');
    KKM_Handle:=nil;
    R:=FAtollInstance.CreateHandle(KKM_Handle);
    if R = 0 then
    begin

      S:='{'#13+
      '   "AccessPassword" : "",'#13+
      '   "AutoDisableBluetooth" : false,'#13+
      '   "AutoEnableBluetooth" : true,'#13+
      '   "BaudRate" : 115200,'#13+
      '   "Bits" : 8,'#13+
      '   "ComFile" : "1",'#13+
      '   "IPAddress" : "192.168.1.10",'#13+
      '   "IPPort" : 5555,'#13+
      '   "LibraryPath" : "C:/work/demos/Test_Trade/Demo_81_Atoll_Native/dll-so-10.3.1/nt-x86-msvc2015",'#13+
      '   "MACAddress" : "FF:FF:FF:FF:FF:FF",'#13+
      '   "Model" : 63,'#13+
      '   "OfdChannel" : 0,'#13+
      '   "Parity" : 0,'#13+
      '   "Port" : 1,'#13+
      '   "StopBits" : 0,'#13+
      '   "UsbDevicePath" : "auto",'#13+
      '   "UserPassword" : ""'#13+
      '}'#13;
      FAtollInstance.SetSettings(KKM_Handle, S);
      FAtollInstance.SetSingleSetting(KKM_Handle, 'LibraryPath', 'C:/work/demos/Test_Trade/Demo_81_Atoll_Native/dll-so-10.3.1/nt-x86-msvc2015');
      FAtollInstance.ApplySingleSettings(KKM_Handle);
      FAtollInstance.Open(KKM_Handle);

(*      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_DATA_TYPE, ord(LIBFPTR_DT_UNIT_VERSION));
      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_UNIT_TYPE, ord(LIBFPTR_UT_FIRMWARE));
      FAtollInstance.QueryData(KKM_Handle); ShowStatus('QueryData : LIBFPTR_UT_FIRMWARE');
      S:=FAtollInstance.GetParamStr(KKM_Handle, Ord(LIBFPTR_PARAM_UNIT_VERSION));
      WriteLog('LIBFPTR_UT_FIRMWARE = ' + S);*)

      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_DATA_TYPE, ord(LIBFPTR_DT_STATUS));
      FAtollInstance.QueryData(KKM_Handle); ShowStatus('QueryData : LIBFPTR_DT_STATUS');
      FShiftState:=FAtollInstance.GetParamInt(KKM_Handle, Ord(LIBFPTR_PARAM_SHIFT_NUMBER));
      WriteLog('FShiftState = ' + IntToStr(FShiftState));

      FAtollInstance.Close(KKM_Handle);

      FAtollInstance.DestroyHandle(KKM_Handle);
      WriteLog('DestroyHandle');
    end
    else
      WriteLog('Error create handle');
  end
  else
    WriteLog('Error load!');
*)
end;

procedure Tv10SimpleTestFrame.Button18Click(Sender: TObject);
var
  R: Integer;
  FsuplierInfo: TBytes;
begin
(*  InitAtollInstance;

  KKM_Handle:=nil;
  R:=0;
  R:=FAtollInstance.CreateHandle(KKM_Handle);
  if R = 0 then
  begin
    ShowStatus('CreateHandle');
  // Создание и настройка компонента
  //libfptr_handle fptr;
  //libfptr_create(&fptr);

  FAtollInstance.SetSingleSetting(KKM_Handle, LIBFPTR_SETTING_PORT, IntToStr(Ord(LIBFPTR_PORT_USB)));
  ShowStatus('SetSingleSetting');
  FAtollInstance.ApplySingleSettings(KKM_Handle);
  ShowStatus('ApplySingleSettings');

  // Соединение с ККТ
  //libfptr_open(fptr);
  FAtollInstance.Open(KKM_Handle);
  ShowStatus('libfptr_open');

  // Регистрация кассира
  //libfptr_set_param_str(fptr, 1021, L"Иванов И.И.");
  FAtollInstance.SetParamStr(KKM_Handle, 1021, 'Иванов И.И.');
  ShowStatus('SetParamStr');
  //libfptr_set_param_str(fptr, 1203, L"500100732259");
  FAtollInstance.SetParamStr(KKM_Handle, 1203, '500100732259');
  ShowStatus('SetParamStr');
  //libfptr_operator_login(fptr);
  FAtollInstance.OperatorLogin(KKM_Handle);
  ShowStatus('OperatorLogin');


  // Открытие электронного чека (с передачей телефона получателя)
  //libfptr_set_param_int(fptr, LIBFPTR_PARAM_RECEIPT_TYPE, LIBFPTR_RT_SELL);
  FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_RECEIPT_TYPE, Ord(LIBFPTR_RT_SELL));
  ShowStatus('SetParamInt');
  //libfptr_set_param_bool(fptr, LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY, true);
  FAtollInstance.SetParamBool(KKM_Handle, Ord(LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY), true);
  ShowStatus('SetParamBool');
  //libfptr_set_param_str(fptr, 1008, L"+79161234567");
  FAtollInstance.SetParamStr(KKM_Handle, 1008, '+79161234567');
  ShowStatus('SetParamStr');
  //libfptr_open_receipt(fptr);
  FAtollInstance.OpenReceipt(KKM_Handle);
  ShowStatus('libfptr_open_receipt');

  // Регистрация позиции
  FAtollInstance.SetParamStr(KKM_Handle, 1171, '+79113456789'); ShowStatus('SetParamStr(KKM_Handle, 1171, ''+79113456789'')');
  FAtollInstance.SetParamStr(KKM_Handle, 1225, 'ООО Поставщик');
  FAtollInstance.UtilFormTLV(KKM_Handle);

  FsuplierInfo:=FAtollInstance.GetParamByteArray(KKM_Handle, Ord(LIBFPTR_PARAM_TAG_VALUE));
(*
  std::vector<uchar> suplierInfo;
  int size = libfptr_get_param_bytearray(fptr, LIBFPTR_PARAM_TAG_VALUE,
                                         &suplierInfo[0], suplierInfo.size());
  if (size > suplierInfo.size())
  {
      suplierInfo.resize(size);
      libfptr_get_param_bytearray(fptr, LIBFPTR_PARAM_TAG_VALUE,
                                  &suplierInfo[0], suplierInfo.size());
  }
  suplierInfo.resize(size);
*)
  FAtollInstance.SetParamStr(KKM_Handle, Ord(LIBFPTR_PARAM_COMMODITY_NAME), 'Товар');
  FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_PRICE), 100);
  FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_QUANTITY), 5.15);
  FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_TAX_TYPE, Ord(LIBFPTR_TAX_VAT18));

(*  libfptr_set_param_int(fptr, 1222, LIBFPTR_AT_ANOTHER);
  libfptr_set_param_bytearray(fptr, 1223, &agentInfo[0]. agentInfo.size());*)
  FAtollInstance.SetParamStr(KKM_Handle, 1226, '123456789047');
  FAtollInstance.SetParamByteArray(KKM_Handle, 1224, FsuplierInfo);
  FAtollInstance.Registration(KKM_Handle);

  // Регистрация итога (отрасываем копейки)
  //libfptr_set_param_double(fptr, LIBFPTR_PARAM_SUM, 369.0);
  FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_SUM), 369.0);
  ShowStatus('libfptr_set_param_double');
  //libfptr_receipt_total(fptr);
  FAtollInstance.ReceiptTotal(KKM_Handle);
  ShowStatus('libfptr_receipt_total');

  // Оплата наличными
  //libfptr_set_param_int(fptr, LIBFPTR_PARAM_PAYMENT_TYPE, LIBFPTR_PT_CASH);
  FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(LIBFPTR_PT_CASH));
  ShowStatus('libfptr_set_param_int');
  //libfptr_set_param_double(fptr, LIBFPTR_PARAM_PAYMENT_SUM, 1000);
  FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_PAYMENT_SUM), 1000);
  ShowStatus('libfptr_set_param_double');
  //libfptr_payment(fptr);
  FAtollInstance.Payment(KKM_Handle);
  ShowStatus('libfptr_payment');

  // Закрытие чека
  //libfptr_close_receipt(fptr);
  FAtollInstance.CloseReceipt(KKM_Handle);
  ShowStatus('libfptr_close_receipt');

  (*
  libfptr_set_param_str(fptr, 1171, L"+79113456789");
  libfptr_set_param_str(fptr, 1225, L"ООО Поставщик");
  libfptr_util_form_tlv(fptr);

  std::vector<uchar> suplierInfo;
  int size = libfptr_get_param_bytearray(fptr, LIBFPTR_PARAM_TAG_VALUE,
                                         &suplierInfo[0], suplierInfo.size());
  if (size > suplierInfo.size())
  {
      suplierInfo.resize(size);
      libfptr_get_param_bytearray(fptr, LIBFPTR_PARAM_TAG_VALUE,
                                  &suplierInfo[0], suplierInfo.size());
  }
  suplierInfo.resize(size);

  libfptr_set_param_str(fptr, LIBFPTR_PARAM_COMMODITY_NAME, L"Товар");
  libfptr_set_param_double(fptr, LIBFPTR_PARAM_PRICE, 100);
  libfptr_set_param_double(fptr, LIBFPTR_PARAM_QUANTITY, 5.15);
  libfptr_set_param_int(fptr, LIBFPTR_PARAM_TAX_TYPE, LIBFPTR_TAX_VAT18);
  libfptr_set_param_int(fptr, 1222, LIBFPTR_AT_ANOTHER);
  libfptr_set_param_bytearray(fptr, 1223, &agentInfo[0]. agentInfo.size());
  libfptr_set_param_str(fptr, 1226, L"123456789047");
  libfptr_set_param_bytearray(fptr, 1224, &suplierInfo[0]. suplierInfo.size());
  libfptr_registration(fptr);
*)

  // Завершение работы
    //libfptr_close(fptr);
    FAtollInstance.Close(KKM_Handle);
    ShowStatus('libfptr_close');
    //libfptr_destroy(&fptr);
    FAtollInstance.DestroyHandle(KKM_Handle);
    WriteLog('DestroyHandle');
  end;
*)
end;

procedure Tv10SimpleTestFrame.Button23Click(Sender: TObject);
{var
  B, B2: TCrpCodeBuffer;
  B1:TBytes;
  S22, S1, S2: String;
  i, L: Integer;}
begin
(*  WriteLog('Формируем тестовый чек c маркировкой');
  InitKassirData;

  FAtollKKMv10.Connected:=true;
  InternalCheckError;
  FAtollKKMv10.Open;
  InternalCheckError;
(*
  FAtollKKMv10.CheckType:=chtSell;

  FAtollKKMv10.OpenCheck;
  if FAtollKKMv10.ErrorCode <> 0 then
  begin
    ShowMessage(FAtollKKMv10.ErrorDescription);
    FAtollKKMv10.Close;
    FAtollKKMv10.Connected:=false;
    Exit;
  end;

  WriteLog('CheckNumber = ' + IntToStr(FAtollKKMv10.CheckNumber));

  //Начинаем регистрацию товара к продаже

  FAtollKKMv10.GoodsInfo.Name:='Товар № 1';
  FAtollKKMv10.GoodsInfo.Price:=10.10;
  FAtollKKMv10.GoodsInfo.Quantity:=1;
  FAtollKKMv10.GoodsInfo.TaxType:=ttaxVat120;
  FAtollKKMv10.GoodsInfo.GoodsPayMode:=gpmFullPay;
  FAtollKKMv10.GoodsInfo.GoodsNomenclatureCode.GroupCode:=$444D;
  FAtollKKMv10.GoodsInfo.GoodsNomenclatureCode.GTIN:='02900000475830';
  FAtollKKMv10.GoodsInfo.GoodsNomenclatureCode.Serial:='MdEfx:Xp6YFd7';


  FAtollKKMv10.SetAttributeStr(Ord(LIBFPTR_PARAM_COMMODITY_NAME), 'Товар № 1');
  FAtollKKMv10.SetAttributeDouble(Ord(LIBFPTR_PARAM_PRICE), 10.10);
  FAtollKKMv10.SetAttributeDouble(Ord(LIBFPTR_PARAM_QUANTITY), 1);
  FAtollKKMv10.SetAttributeInt(Ord(LIBFPTR_PARAM_TAX_TYPE), Ord(TaxTypeToAtollTT(ttaxVat120)));


  FAtollKKMv10.Registration;

  // Закрытие чека
  FAtollKKMv10.CloseCheck;

  if FAtollKKMv10.ErrorCode <> 0 then
    ShowMessage(FAtollKKMv10.ErrorDescription);
*)
(*

  SetLength(B1, SizeOF(TCrpCodeBuffer));
  FillChar(B1[1], SizeOF(TCrpCodeBuffer), 0);
  B1[0]:=$44;
  B1[1]:=$4D;
  B1[2]:=$02;
  B1[3]:=$A3;
  B1[4]:=$35;
  B1[5]:=$7E;
  B1[6]:=$0A;
  B1[7]:=$EA;
  B1[8]:=$36;
  B1[9]:=$27;
  B1[10]:=$55;
  B1[11]:=$42;
  B1[12]:=$25;
  B1[13]:=$52;
  B1[14]:=$78;
  B1[15]:=$54;
  B1[16]:=$4C;
  B1[17]:=$6D;
  B1[18]:=$68;
  B1[19]:=$4F;
  B1[20]:=$50;

  //B1[0]:=68;
  //B1[1]:=77;
  //B1[2]:=2;
  //B1[3]:=163;
  //B1[4]:=53;
  //B1[5]:=127;
  //B1[6]:=138;
  //B1[7]:=182;
  //B1[8]:=77;
  //B1[9]:=100;
  //B1[10]:=69;
  //B1[11]:=102;
  //B1[12]:=120;
  //B1[13]:=58;
  //B1[14]:=88;
  //B1[15]:=112;
  //B1[16]:=54;
  //B1[17]:=89;
  //B1[18]:=70;
  //B1[19]:=100;
  //B1[20]:=55;
  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, LIBFPTR_PARAM_RECEIPT_TYPE, 1);
  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, libfptr_param(1055), 0);
  FAtollKKMv10.LibraryAtol.OpenReceipt(FAtollKKMv10.Handle);
  FAtollKKMv10.LibraryAtol.SetParamStr(FAtollKKMv10.Handle, Ord(LIBFPTR_PARAM_COMMODITY_NAME), 'Товар');
  FAtollKKMv10.LibraryAtol.SetParamDouble(FAtollKKMv10.Handle, Ord(LIBFPTR_PARAM_PRICE), 100);
  FAtollKKMv10.LibraryAtol.SetParamDouble(FAtollKKMv10.Handle, Ord(LIBFPTR_PARAM_QUANTITY), 1);
  FAtollKKMv10.LibraryAtol.SetParamDouble(FAtollKKMv10.Handle, Ord(LIBFPTR_PARAM_POSITION_SUM), 100);
  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, LIBFPTR_PARAM_TAX_TYPE, 7);
  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, libfptr_param(1212), 1);
  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, libfptr_param(1214), 1);
  FAtollKKMv10.LibraryAtol.SetParamByteArray(FAtollKKMv10.Handle, 1162, B1); //new Uint8Array([68,77,2,163,53,127,138,182,77,100,69,102,120,58,88,112,54,89,70,100,55]));
  FAtollKKMv10.LibraryAtol.Registration(FAtollKKMv10.Handle);
  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, LIBFPTR_PARAM_PAYMENT_TYPE, 0);
  FAtollKKMv10.LibraryAtol.CloseReceipt(FAtollKKMv10.Handle);
*)

  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, LIBFPTR_PARAM_RECEIPT_TYPE, 1);
  FAtollKKMv10.LibraryAtol.OpenReceipt(FAtollKKMv10.Handle);
  FAtollKKMv10.LibraryAtol.SetParamStr(FAtollKKMv10.Handle, Ord(LIBFPTR_PARAM_COMMODITY_NAME), 'Товар');
  FAtollKKMv10.LibraryAtol.SetParamDouble(FAtollKKMv10.Handle, Ord(LIBFPTR_PARAM_PRICE), 100);
  FAtollKKMv10.LibraryAtol.SetParamDouble(FAtollKKMv10.Handle, Ord(LIBFPTR_PARAM_QUANTITY), 1);
  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, LIBFPTR_PARAM_TAX_TYPE, Ord(LIBFPTR_TAX_VAT20));
  //S22:='30 31 30 32 39 30 30 30 30 30 34 37 35 38 33 30 32 31 4D 64 45 66 78 3A 58 70 36 59 46 64 37 1D 39 31 38 30 32 39 1D 39 32 61 51 49 51 6B 49 37 6F 48 58 6D 7A 47 2F 6D 64 4B 78 7A 43 55 43 4B 54 4A 48 58 6F 42 4F 44 64 6D 43 64 4D 35 6B 38 51 6A 37 67 61 5A 56 32 78 62 6E 36 36 78 42 58 47 49 4B 72 74 66 76 71 50 49 4E 41 32 6A 6B 62 6A 79 6A 33 2F 4F 2B 6B 79 36 6F 75 31 4E 41 3D 3D';
  //S22:='30 31 30 32 39 30 30 30 30 30 33 37 37 35 37 38 32 31 36 27 55 42 25 52 78 54 4C 6D 68 4F 50 39 31 30 30 32 41 39 32 62 52 37 57 62 46 38 59 72 4E 69 4A 4B 75 71 51 75 2F 41 71 70 32 6F 4F 41 64 49 48 31 79 6E 51 4F 64 4C 6D 31 45 32 50 62 50 4D 39 63 41 41 62 33 6F 65 75 6D 64 68 78 45 62 4A 69 34 32 54 6D 69 31 74 33 33 72 52 69 2B 75 73 50 45 79 51 63 39 33 69 56 30 51 3D 3D';

  S22:='010290000037757821-tmIXrkglsKfZ91002A92V7pdljhutl5ewpDbkwAE+iw1kCwwDu29SwlNZOOnbhUUZtSx7V/M+6rVowswZn0zADvTNpaEHUrG/T4FB4fJDQ==';
  //S22:=#$44#$4D'010290000047583021MdEfx:Xp6YFd7GS918029GS92aQIQkI7oHXmzG/mdKxzCUCKTJHXoBODdmCdM5k8Qj7gaZV2xbn66xBXGIKrtfvqPINA2jkbjyj3/O+ky6ou1NA==';
  //S22:=#$44#$4D'010290000047583021MdEfx:Xp6YFd7';

  //S22:=#$44#$4D#$02#$A3#$35#$7F#$8A#$B6#$4D#$64#$45#$66#$78#$3A#$58#$70#$36#$59#$46#$64#$37;

  //S22:=#$44#$4D#$02#$A3#$35#$7E#$0A#$EA#$2D#$74#$6D#$49#$58#$72#$6B#$67#$6C#$73#$4B#$66#$5A;
(*
  SetLength(B1, Length(S22));
  for i:=1 to Length(S22) do
    B1[i-1]:=Ord(S22[i]);
*)
  //S22:=Edit6.Text;

  S1:=Copy(S22, 3, 14);
  S2:=Copy(S22, 18, 13);
  B2:=MakeCRPTCode($444D, S1, S2);

  //L:=SizeOf(B2);
  L:=21;
  SetLength(B1, L);
  Move(B2, B1[0], L);
(*
  B1[0]:=$8A;
  B1[1]:=$04;
  B1[2]:=$15;
  B1[3]:=$00;
*)

  //FAtollKKMv10.LibraryAtol.SetParamByteArray(FAtollKKMv10.Handle, Ord(LIBFPTR_PARAM_MARKING_CODE), B1);
  FAtollKKMv10.LibraryAtol.SetParamByteArray(FAtollKKMv10.Handle, 1162, B1);
  InternalCheckError;
  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, libfptr_param(1212), 1);
  InternalCheckError;
  FAtollKKMv10.LibraryAtol.SetParamInt(FAtollKKMv10.Handle, libfptr_param(1214), 1);
  InternalCheckError;

  FAtollKKMv10.LibraryAtol.Registration(FAtollKKMv10.Handle);
  InternalCheckError;
  FAtollKKMv10.LibraryAtol.CloseReceipt(FAtollKKMv10.Handle);

  //FAtollKKMv10.LibraryAtol.ParseMarkingCode();
  //FAtollKKMv10.LibraryAtol.GetParamByteArray();

  InternalCheckError;

  //44 4D 02 A3 35 7F 8A B6 4D 64 45 66 78 3A 58 70 36 59 46 64 37
  WriteLog('FD number = ' + IntToStr(FAtollKKMv10.FDNumber));
  FAtollKKMv10.Close;
  FAtollKKMv10.Connected:=false;
*)
end;

procedure Tv10SimpleTestFrame.Button2Click(Sender: TObject);
var
  R, i: Integer;
begin
(*  InitAtollInstance;

  KKM_Handle:=nil;
  R:=0;
  R:=FAtollInstance.CreateHandle(KKM_Handle);
  if R = 0 then
  begin
    ShowStatus('CreateHandle');
  // Создание и настройка компонента
  //libfptr_handle fptr;
  //libfptr_create(&fptr);

  //libfptr_set_single_setting(fptr, LIBFPTR_SETTING_PORT, std::to_wstring(LIBFPTR_PORT_USB).c_str())
  FAtollInstance.SetSingleSetting(KKM_Handle, LIBFPTR_SETTING_PORT, IntToStr(Ord(LIBFPTR_PORT_USB)));
  ShowStatus('SetSingleSetting');
  //libfptr_apply_single_settings(fptr)
  FAtollInstance.ApplySingleSettings(KKM_Handle);
  ShowStatus('ApplySingleSettings');

  // Соединение с ККТ
  //libfptr_open(fptr);
  FAtollInstance.Open(KKM_Handle);
  ShowStatus('libfptr_open');

  // Регистрация кассира
  //libfptr_set_param_str(fptr, 1021, L"Иванов И.И.");
  FAtollInstance.SetParamStr(KKM_Handle, 1021, 'Иванов И.И.');
  ShowStatus('SetParamStr');
  //libfptr_set_param_str(fptr, 1203, L"500100732259");
  FAtollInstance.SetParamStr(KKM_Handle, 1203, '500100732259');
  ShowStatus('SetParamStr');
  //libfptr_operator_login(fptr);
  FAtollInstance.OperatorLogin(KKM_Handle);
  ShowStatus('OperatorLogin');


  // Открытие электронного чека (с передачей телефона получателя)
  //libfptr_set_param_int(fptr, LIBFPTR_PARAM_RECEIPT_TYPE, LIBFPTR_RT_SELL);
  FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_RECEIPT_TYPE, Ord(LIBFPTR_RT_SELL));
  ShowStatus('SetParamInt');
  //libfptr_set_param_bool(fptr, LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY, true);
  FAtollInstance.SetParamBool(KKM_Handle, Ord(LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY), true);
  ShowStatus('SetParamBool');
  //libfptr_set_param_str(fptr, 1008, L"+79161234567");
  FAtollInstance.SetParamStr(KKM_Handle, 1008, '+79161234567');
  ShowStatus('SetParamStr');
  //libfptr_open_receipt(fptr);
  FAtollInstance.OpenReceipt(KKM_Handle);
  ShowStatus('libfptr_open_receipt');

  // Регистрация позиции
  //libfptr_set_param_str(fptr, LIBFPTR_PARAM_COMMODITY_NAME, L"Чипсы LAYS");

  for i:=0 to 1 do
  begin
    //FAtollInstance.SetParamStr(KKM_Handle, Ord(LIBFPTR_PARAM_TEXT), 'Признак способа расчета : '+IntToStr(i));
    //FAtollInstance.PrintText(KKM_Handle);

    FAtollInstance.SetParamStr(KKM_Handle, Ord(LIBFPTR_PARAM_COMMODITY_NAME), 'Чипсы LAYS');
    ShowStatus('libfptr_open_receipt');
    //libfptr_set_param_double(fptr, LIBFPTR_PARAM_PRICE, 73.99);
    FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_PRICE), 73.99);
    ShowStatus('libfptr_set_param_double');
    //libfptr_set_param_double(fptr, LIBFPTR_PARAM_QUANTITY, 5);
    FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_QUANTITY), 5);
    ShowStatus('libfptr_set_param_double');
    //libfptr_set_param_int(fptr, LIBFPTR_PARAM_TAX_TYPE, LIBFPTR_TAX_VAT18);
    FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_TAX_TYPE, Ord(LIBFPTR_TAX_VAT18));
    ShowStatus('libfptr_set_param_int');
    //libfptr_set_param_int(fptr, 1212, 1);
    FAtollInstance.SetParamInt(KKM_Handle, Tlibfptr_param(1212), 1);
    ShowStatus('libfptr_set_param_int');
    //libfptr_set_param_int(fptr, 1214, 7);
    //FAtollInstance.SetParamInt(KKM_Handle, Tlibfptr_param(1214), i);
    FAtollInstance.SetParamInt(KKM_Handle, Tlibfptr_param(1214), SpinEdit1.Value);
    ShowStatus('libfptr_set_param_int');
    //libfptr_registration(fptr);
    FAtollInstance.Registration(KKM_Handle);
    ShowStatus('libfptr_registration');
  end;

  // Регистрация итога (отрасываем копейки)
  //libfptr_set_param_double(fptr, LIBFPTR_PARAM_SUM, 369.0);
  FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_SUM), 369.0);
  ShowStatus('libfptr_set_param_double');
  //libfptr_receipt_total(fptr);
  FAtollInstance.ReceiptTotal(KKM_Handle);
  ShowStatus('libfptr_receipt_total');

  // Оплата наличными
  //libfptr_set_param_int(fptr, LIBFPTR_PARAM_PAYMENT_TYPE, LIBFPTR_PT_CASH);
  FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(LIBFPTR_PT_CASH));
  ShowStatus('libfptr_set_param_int');
  //libfptr_set_param_double(fptr, LIBFPTR_PARAM_PAYMENT_SUM, 1000);
  FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_PAYMENT_SUM), 1000);
  ShowStatus('libfptr_set_param_double');
  //libfptr_payment(fptr);
  FAtollInstance.Payment(KKM_Handle);
  ShowStatus('libfptr_payment');

  // Закрытие чека
  //libfptr_close_receipt(fptr);
  FAtollInstance.CloseReceipt(KKM_Handle);
  ShowStatus('libfptr_close_receipt');
(*
      while (libfptr_check_document_closed(fptr) < 0) {
        // Не удалось проверить состояние документа. Вывести пользователю текст ошибки, попросить устранить неполадку и повторить запрос
        std::wcout << getErrorDescription(fptr) << std::endl;
        continue;
      }

      if (libfptr_get_param_bool(fptr, LIBFPTR_PARAM_DOCUMENT_CLOSED) == 0) {
        // Документ не закрылся. Требуется его отменить (если это чек) и сформировать заново
        libfptr_cancel_receipt(fptr);
        return;
      }

      if (libfptr_get_param_bool(fptr, LIBFPTR_PARAM_DOCUMENT_PRINTED) == 0) {
        // Можно сразу вызвать метод допечатывания документа, он завершится с ошибкой, если это невозможно
        while (libfptr_continue_print(fptr) < 0) {
          // Если не удалось допечатать документ - показать пользователю ошибку и попробовать еще раз.
          std::wcout << L"Не удалось напечатать документ (Ошибка \""<< getErrorDescription(fptr) << L"\"). Устраните неполадку и повторите.";
          continue;
        }
      }

      // Получение информации о чеке из ФН
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_FN_DATA_TYPE, LIBFPTR_FNDT_LAST_DOCUMENT);
      libfptr_fn_query_data(fptr);
      wchar_t fiscalSign[50] = {0};
      libfptr_get_param_str(fptr, LIBFPTR_PARAM_FISCAL_SIGN, &fiscalSign[0], sizeof(fiscalSign) / sizeof(fiscalSign[0]));
      uint documentNumber = libfptr_get_param_int(fptr, LIBFPTR_PARAM_DOCUMENT_NUMBER);

      // Формирование слипа ЕГАИС
      libfptr_begin_nonfiscal_document(fptr);

      libfptr_set_param_str(fptr, LIBFPTR_PARAM_TEXT, L"ИНН: 111111111111 КПП: 222222222");
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_ALIGNMENT, LIBFPTR_ALIGNMENT_CENTER);
      libfptr_print_text(fptr);

      libfptr_set_param_str(fptr, LIBFPTR_PARAM_TEXT, L"КАССА: 1               СМЕНА: 11");
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_ALIGNMENT, LIBFPTR_ALIGNMENT_CENTER);
      libfptr_print_text(fptr);

      libfptr_set_param_str(fptr, LIBFPTR_PARAM_TEXT, L"ЧЕК: 314  ДАТА: 20.11.2017 15:39");
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_ALIGNMENT, LIBFPTR_ALIGNMENT_CENTER);
      libfptr_print_text(fptr);

      libfptr_set_param_str(fptr, LIBFPTR_PARAM_BARCODE, L"https://check.egais.ru?id=cf1b1096-3cbc-11e7-b3c1-9b018b2ba3f7");
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_BARCODE_TYPE, LIBFPTR_BT_QR);
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_ALIGNMENT, LIBFPTR_ALIGNMENT_CENTER);
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_SCALE, 500);
      libfptr_print_barcode(fptr);

      libfptr_print_text(fptr);

      libfptr_set_param_str(fptr, LIBFPTR_PARAM_TEXT, L"https://check.egais.ru?id=cf1b1096-3cbc-11e7-b3c1-9b018b2ba3f7");
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_ALIGNMENT, LIBFPTR_ALIGNMENT_CENTER);
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_TEXT_WRAP, LIBFPTR_TW_CHARS);
      libfptr_print_text(fptr);

      libfptr_print_text(fptr);

      libfptr_set_param_str(fptr, LIBFPTR_PARAM_TEXT,
                                L"10 58 1c 85 bb 80 99 84 40 b1 4f 35 8a 35 3f 7c "
                                L"78 b0 0a ff cd 37 c1 8e ca 04 1c 7e e7 5d b4 85 "
                                L"ff d2 d6 b2 8d 7f df 48 d2 5d 81 10 de 6a 05 c9 "
                                L"81 74");
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_ALIGNMENT, LIBFPTR_ALIGNMENT_CENTER);
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_TEXT_WRAP, LIBFPTR_TW_WORDS);
      libfptr_print_text(fptr);

      libfptr_end_nonfiscal_document(fptr);

      // Z-отчет
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_REPORT_TYPE, LIBFPTR_RT_CLOSE_SHIFT);
      libfptr_report(fptr);

      // Получение информации о неотправленных документах
      libfptr_set_param_int(fptr, LIBFPTR_PARAM_FN_DATA_TYPE, LIBFPTR_FNDT_OFD_EXCHANGE_STATUS);
      libfptr_fn_query_data(fptr);
      wchar_t unsentDateTime[50] = {0};
      uint unsentCount libfptr_get_param_int(fptr, LIBFPTR_PARAM_DOCUMENTS_COUNT);
      uint unsentFirstNumber = libfptr_get_param_int(fptr, LIBFPTR_PARAM_DOCUMENT_NUMBER);
      libfptr_get_param_str(fptr, LIBFPTR_PARAM_DATE_TIME, &unsentDateTime[0], sizeof(unsentDateTime) / sizeof(unsentDateTime[0]));
  *)
    // Завершение работы
    //libfptr_close(fptr);
    FAtollInstance.Close(KKM_Handle);
    ShowStatus('libfptr_close');
    //libfptr_destroy(&fptr);
    FAtollInstance.DestroyHandle(KKM_Handle);
    WriteLog('DestroyHandle');
  end;
*)
end;

procedure Tv10SimpleTestFrame.Button3Click(Sender: TObject);
var
  R: Integer;
begin
(*  InitAtollInstance;

  KKM_Handle:=nil;
  R:=0;
  R:=FAtollInstance.CreateHandle(KKM_Handle);
  if R = 0 then
  begin
    FAtollInstance.ShowProperties(KKM_Handle, LIBFPTR_GUI_PARENT_NATIVE, nil);
    ShowStatus('ShowProperties');
    FAtollInstance.DestroyHandle(KKM_Handle);
    WriteLog('DestroyHandle');
  end
  else
    WriteLog('Error create handle');*)
end;

procedure Tv10SimpleTestFrame.Button4Click(Sender: TObject);
var
  R, R1: Integer;
begin
(*  InitAtollInstance;

  if FAtollInstance.Loaded then
  begin
    WriteLog('Начата проверка "плохого" чека');
    KKM_Handle:=nil;
    R:=0;
    R:=FAtollInstance.CreateHandle(KKM_Handle);
    if R = 0 then
    begin

      // Соединение с ККТ
      FAtollInstance.Open(KKM_Handle); ShowStatus('libfptr_open');

      // Регистрация кассира
      FAtollInstance.SetParamStr(KKM_Handle, 1021, 'Иванов И.И.');  ShowStatus('SetParamStr 1021, "Иванов И.И."');  //Кассир
      FAtollInstance.SetParamStr(KKM_Handle, 1203, '500100732259'); ShowStatus('SetParamStr 1203, "500100732259"'); //ИНН кассира
      FAtollInstance.OperatorLogin(KKM_Handle);                     ShowStatus('OperatorLogin');

      // Открытие электронного чека (с передачей телефона получателя)
      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_RECEIPT_TYPE, Ord(LIBFPTR_RT_SELL));       ShowStatus('SetParamInt LIBFPTR_PARAM_RECEIPT_TYPE = LIBFPTR_RT_SELL');
      FAtollInstance.SetParamBool(KKM_Handle, Ord(LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY), true); ShowStatus('SetParamBool LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY=true');
      FAtollInstance.SetParamStr(KKM_Handle, 1008, '+79161234567'); ShowStatus('SetParamStr 1008, "+79161234567"');
      FAtollInstance.SetParamStr(KKM_Handle, 1227, 'АОЗТ "Кот и ПЁС"');
      FAtollInstance.SetParamStr(KKM_Handle, 1228, '1831121013');

      FAtollInstance.OpenReceipt(KKM_Handle);                       ShowStatus('libfptr_open_receipt');

      // Регистрация позиции
      //libfptr_set_param_str(fptr, LIBFPTR_PARAM_COMMODITY_NAME, L"Чипсы LAYS");
      FAtollInstance.SetParamStr(KKM_Handle, Ord(LIBFPTR_PARAM_COMMODITY_NAME), 'Чипсы LAYS');   ShowStatus('LIBFPTR_PARAM_COMMODITY_NAME = "Чипсы LAYS"');
      FAtollInstance.SetParamStr(KKM_Handle, 1230, '457');                                       ShowStatus('SetParamStr 1230, "457"');
      FAtollInstance.SetParamStr(KKM_Handle, 1231, '123-AAA-2313414124');                        ShowStatus('SetParamStr 1231, "123-AAA-2313414124"');

      //libfptr_set_param_double(fptr, LIBFPTR_PARAM_PRICE, 73.99);
      FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_PRICE), 114.48);
      ShowStatus('libfptr_set_param_double');
      //libfptr_set_param_double(fptr, LIBFPTR_PARAM_QUANTITY, 5);
      FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_QUANTITY), 31.200);
      ShowStatus('libfptr_set_param_double');
      //libfptr_set_param_int(fptr, LIBFPTR_PARAM_TAX_TYPE, LIBFPTR_TAX_VAT18);
      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_TAX_TYPE, Ord(LIBFPTR_TAX_VAT18));
      ShowStatus('libfptr_set_param_int');
      //libfptr_set_param_int(fptr, 1212, 1);
      FAtollInstance.SetParamInt(KKM_Handle, Tlibfptr_param(1212), 1);
      ShowStatus('libfptr_set_param_int');
      //libfptr_set_param_int(fptr, 1214, 7);
      FAtollInstance.SetParamInt(KKM_Handle, Tlibfptr_param(1214), 7);
      ShowStatus('libfptr_set_param_int');
      //libfptr_registration(fptr);
      FAtollInstance.Registration(KKM_Handle);
      ShowStatus('libfptr_registration');

      // Регистрация итога (отрасываем копейки)
      FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_SUM), 3571.78);      ShowStatus('libfptr_set_param_double - LIBFPTR_PARAM_SUM = 3571.78');
      FAtollInstance.ReceiptTotal(KKM_Handle);                                         ShowStatus('libfptr_receipt_total');

      // Оплата наличными
      (*
FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(LIBFPTR_PT_CASH));   ShowStatus('libfptr_set_param_int - LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_CASH');
FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_PAYMENT_SUM), 3000.78);         ShowStatus('libfptr_set_param_double - LIBFPTR_PARAM_PAYMENT_SUM, 3571.78');
FAtollInstance.Payment(KKM_Handle);                                                         ShowStatus('libfptr_payment');
*)
      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(LIBFPTR_PT_OTHER)); ShowStatus('libfptr_set_param_int - LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_OTHER');
      FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_PAYMENT_SUM), 1000.00);         ShowStatus('libfptr_set_param_double - LIBFPTR_PARAM_PAYMENT_SUM, 1000.00');
      FAtollInstance.Payment(KKM_Handle);                                                         ShowStatus('libfptr_payment');

      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(LIBFPTR_PT_PREPAID)); ShowStatus('libfptr_set_param_int - LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_PREPAID');
      FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_PAYMENT_SUM), 2000.00);         ShowStatus('libfptr_set_param_double - LIBFPTR_PARAM_PAYMENT_SUM, 2000.00');
      FAtollInstance.Payment(KKM_Handle);                                                         ShowStatus('libfptr_payment');

      FAtollInstance.SetParamInt(KKM_Handle, LIBFPTR_PARAM_PAYMENT_TYPE, Ord(LIBFPTR_PT_CASH));   ShowStatus('libfptr_set_param_int - LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_CASH');
      FAtollInstance.SetParamDouble(KKM_Handle, Ord(LIBFPTR_PARAM_PAYMENT_SUM), 571.78);          ShowStatus('libfptr_set_param_double - LIBFPTR_PARAM_PAYMENT_SUM, 571.78');
      FAtollInstance.Payment(KKM_Handle);                                                         ShowStatus('libfptr_payment');


      // Закрытие чека
      FAtollInstance.CloseReceipt(KKM_Handle);                                                    ShowStatus('libfptr_close_receipt');

      QueryCheckData;

      // Завершение работы
      FAtollInstance.Close(KKM_Handle);   ShowStatus('libfptr_close');

      FAtollInstance.DestroyHandle(KKM_Handle);
      WriteLog('DestroyHandle');
    end
    else
      WriteLog('Error create handle');
  end
  else
    WriteLog('Error load!');
*)
end;

end.

