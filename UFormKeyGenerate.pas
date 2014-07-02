unit UFormKeyGenerate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles;

  function CoCreateGuid(var guid: TGUID): HResult; stdcall; far external 'ole32.dll';
  function Decrypt(const S: AnsiString; Key: Word): AnsiString;
  function Encrypt(const S: AnsiString; Key: Word): AnsiString;

  function getMachineName(): AnsiString;

  function getFirstDriveID: String;

  function getPass():String;

  const
    C1 = 52845;
    C2 = 22719;

type
  TDriveLayoutInformationMbr = record
    Signature: DWORD;
  end;

  TDriveLayoutInformationGpt = record
    DiskId: TGuid;
    StartingUsableOffset: Int64;
    UsableLength: Int64;
    MaxPartitionCount: DWORD;
  end;

  TPartitionInformationMbr = record
    PartitionType: Byte;
    BootIndicator: Boolean;
    RecognizedPartition: Boolean;
    HiddenSectors: DWORD;
  end;

  TPartitionInformationGpt = record
    PartitionType: TGuid;
    PartitionId: TGuid;
    Attributes: Int64;
    Name: array [0..35] of WideChar;
  end;

  TPartitionInformationEx = record
    PartitionStyle: Integer;
    StartingOffset: Int64;
    PartitionLength: Int64;
    PartitionNumber: DWORD;
    RewritePartition: Boolean;
    case Integer of
      0: (Mbr: TPartitionInformationMbr);
      1: (Gpt: TPartitionInformationGpt);
  end;

  TDriveLayoutInformationEx = record
    PartitionStyle: DWORD;
    PartitionCount: DWORD;
    DriveLayoutInformation: record
      case Integer of
      0: (Mbr: TDriveLayoutInformationMbr);
      1: (Gpt: TDriveLayoutInformationGpt);
    end;
    PartitionEntry: array [0..15] of TPartitionInformationGpt;
    //hard-coded maximum of 16 partitions
  end;

const
  PARTITION_STYLE_MBR = 0;
  PARTITION_STYLE_GPT = 1;
  PARTITION_STYLE_RAW = 2;

const
  IOCTL_DISK_GET_DRIVE_LAYOUT_EX = $00070050;  

type
  TFmKeyGenerate = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    procedure writeToConfig;
  public
    { Public declarations }
  end;

var
  FmKeyGenerate: TFmKeyGenerate;

implementation

uses
  DSiWin32, UHDInfo;

{$R *.dfm}

function Decode(const S: AnsiString): AnsiString;
const
  Map: array[Char] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 63, 52, 53,
    54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2,
    3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 0, 0, 0, 0, 0, 0, 26, 27, 28, 29, 30,
    31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
    46, 47, 48, 49, 50, 51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0);
var
  I: LongInt;
begin
  case Length(S) of
    2:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6);
        SetLength(Result, 1);
        Move(I, Result[1], Length(Result))
      end;
    3:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12);
        SetLength(Result, 2);
        Move(I, Result[1], Length(Result))
      end;
    4:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12) +
          (Map[S[4]] shl 18);
        SetLength(Result, 3);
        Move(I, Result[1], Length(Result))
      end
  end
end;

function PreProcess(const S: AnsiString): AnsiString;
var
  SS: AnsiString;
begin
  SS := S;
  Result := '';
  while SS <> '' do
  begin
    Result := Result + Decode(Copy(SS, 1, 4));
    Delete(SS, 1, 4)
  end
end;

function InternalDecrypt(const S: AnsiString; Key: Word): AnsiString;
var
  I: Word;
  Seed: Word;
begin
  Result := S;
  Seed := Key;
  for I := 1 to Length(Result) do
  begin
    Result[I] := Char(Byte(Result[I]) xor (Seed shr 8));
    Seed := (Byte(S[I]) + Seed) * Word(C1) + Word(C2)
  end
end;

function Decrypt(const S: AnsiString; Key: Word): AnsiString;
begin
  Result := InternalDecrypt(PreProcess(S), Key)
end;

function Encode(const S: AnsiString): AnsiString;
const
  Map: array[0..63] of Char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
    'abcdefghijklmnopqrstuvwxyz0123456789+/';
var
  I: LongInt;
begin
  I := 0;
  Move(S[1], I, Length(S));
  case Length(S) of
    1:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64];
    2:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] +
        Map[(I shr 12) mod 64];
    3:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] +
        Map[(I shr 12) mod 64] + Map[(I shr 18) mod 64]
  end
end;

function PostProcess(const S: AnsiString): AnsiString;
var
  SS: AnsiString;
begin
  SS := S;
  Result := '';
  while SS <> '' do
  begin
    Result := Result + Encode(Copy(SS, 1, 3));
    Delete(SS, 1, 3)
  end
end;

function InternalEncrypt(const S: AnsiString; Key: Word): AnsiString;
var
  I: Word;
  Seed: Word;
begin
  Result := S;
  Seed := Key;
  for I := 1 to Length(Result) do
  begin
    Result[I] := Char(Byte(Result[I]) xor (Seed shr 8));
    Seed := (Byte(Result[I]) + Seed) * Word(C1) + Word(C2)
  end
end;

function Encrypt(const S: AnsiString; Key: Word): AnsiString;
begin
  Result := PostProcess(InternalEncrypt(S, Key))
end;

function getMachineName(): AnsiString;
var
  ComputerName: Array [0 .. 256] of char;
  Size: DWORD;
begin
  Size := 256;
  GetComputerName(ComputerName, Size);
  Result := ComputerName;
end;

{ TFmKeyGenerate }

procedure TFmKeyGenerate.Button1Click(Sender: TObject);
const
 my_key = 33189;
var
  aIni : TIniFile;
  sEncrypted, sDecrypted, company, aIniFileName, userSTr :AnsiString;
begin

  aIniFileName := ExtractFilePath(ParamStr(0)) + 'config.ini';
  aIni := TIniFile.Create(aIniFileName);

  company := aIni.ReadString('comm', 'company'  , '');

  userStr := company + '_' + getMachineName;

  if (trim(company)='') then
    userStr := getMachineName;

  aIni.free;

  edit1.Text := Encrypt(userStr , my_key);
  edit2.Text := Encrypt('rubrika.5741',my_key);

  //ShowMessage('drive: ' + getFirstDriveID + #13#10 + Decrypt(edit1.Text,my_key));

  (*
  edit1.Text := Encrypt('xafkinor',my_key);
  edit2.Text := Encrypt('Calfu33.',my_key);
  *)
  (*
  sEncrypted := Encrypt(edit1.Text,my_key);
  // Show encrypted string
  edit2.Text := sEncrypted;
  // Decrypt the string
  sDecrypted := Decrypt(sEncrypted,my_key);
   // Show decrypted string
  ShowMessage(sDecrypted);
  *)

  (*
  // Encrypt a string
  sEncrypted := Encrypt('jcalfucura',my_key);
  // Show encrypted string
  ShowMessage(sEncrypted);
  // Decrypt the string
  sDecrypted := Decrypt(sEncrypted,my_key);
   // Show decrypted string
  ShowMessage(sDecrypted);
  *)
end;

procedure TFmKeyGenerate.writeToConfig;
begin

end;

procedure TFmKeyGenerate.Button3Click(Sender: TObject);
const MAX_IDE_DRIVES = 16;

var
  DriveNumber: Byte;
  HDDInfo: THDDInfo;
begin
  HDDInfo := THDDInfo.Create();
  try
    for DriveNumber := 0 to MAX_IDE_DRIVES - 1 do
    try
      HDDInfo.DriveNumber := DriveNumber;
      if HDDInfo.IsInfoAvailable then
      begin
        ShowMessage('VendorId: ' + HDDInfo.VendorId + #13#10 +
          'ProductId: ' +  HDDInfo.ProductId  + #13#10 +
          'ProductRevision: ' + HDDInfo.ProductRevision + #13#10 +
          'SerialNumber: ' + HDDInfo.SerialNumber  + #13#10 +
          'SerialNumberInt: ' + IntToStr(HDDInfo.SerialNumberInt) + #13#10 +
          'SerialNumberText: ' + HDDInfo.SerialNumberText);
      end;
    except
      on E: Exception do
        Writeln(Format('DriveNumber %d, %s: %s', [DriveNumber, E.ClassName, E.Message]));
    end;
  finally
    HDDInfo.Free;
  end;
end;

function getFirstDriveID: String;
const
  // Max number of drives assuming primary/secondary, master/slave topology
  MAX_IDE_DRIVES = 16;
var
  i: Integer;
  Drive: string;
  hDevice: THandle;
  DriveLayoutInfo: TDriveLayoutInformationEx;
  BytesReturned: DWORD;
begin
  for i := 0 to MAX_IDE_DRIVES - 1 do
  begin
    Drive := '\\.\PHYSICALDRIVE' + IntToStr(i);
    hDevice := CreateFile(PChar(Drive), 0, FILE_SHARE_READ or FILE_SHARE_WRITE,
      nil, OPEN_EXISTING, 0, 0);
    if hDevice <> INVALID_HANDLE_VALUE then
    begin
      if DeviceIoControl(hDevice, IOCTL_DISK_GET_DRIVE_LAYOUT_EX, nil, 0,
        @DriveLayoutInfo, SizeOf(DriveLayoutInfo), BytesReturned, nil) then
      begin
        case DriveLayoutInfo.PartitionStyle of
        PARTITION_STYLE_MBR:
          result := IntToHex(DriveLayoutInfo.DriveLayoutInformation.Mbr.Signature, 8);
        (*
        PARTITION_STYLE_GPT:
          memo1.Lines.Add(Drive + ', GPT, ' +
            GUIDToString(DriveLayoutInfo.DriveLayoutInformation.Gpt.DiskId));
        PARTITION_STYLE_RAW:
          memo1.Lines.Add(Drive + ', RAW');
          *)
        end;
      end;
      CloseHandle(hDevice);
    end;
  end;
end;

function getPass(): String;
var
  aIni : TIniFile;
  sEncrypted, sDecrypted, company, aIniFileName, userSTr :AnsiString;
begin

  aIniFileName := ExtractFilePath(ParamStr(0)) + 'config.ini';
  aIni := TIniFile.Create(aIniFileName);

  company := aIni.ReadString('comm', 'company'  , '');

  userStr := company + '_' + getMachineName;

  if (trim(company)='') then
    userStr := getMachineName;

  aIni.free;

  result := userSTr + getFirstDriveID();
end;


end.


