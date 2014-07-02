unit uRut;

interface

uses StrUtils, SysUtils;

type

  Tfolder = class
    name: string;
    path: string;

  end;

  TDocumento = class
    name: string;
    code: string;
  end;

  TArrayOfAnsiString = array of AnsiString;

function ValidarRUT(const run: AnsiString): boolean;
function NormalizarRUT(const run: AnsiString): AnsiString;
function RutId(Rut: Longint): Char;
function RutValido(Rut: Longint; Digito_Id: Char): Boolean;
//function RutCompletoStr(Rut: Longint): string;
function IsDirectoryEmpty(const directory: string): boolean;
function IsExistsMoreDirectories(const directory: string): boolean;
function NormalizeRut(const rut: AnsiString): AnsiString;
function StripString(const s: AnsiString): AnsiString;
function validarFecha(const f: string): boolean;
procedure SplitString(var result: TArrayOfAnsiString; const str, sep: AnsiString; max_items: Integer = -1);
function LeftPad(S: string; Ch: Char; Len: Integer): string;
function RightPad(S: string; Ch: Char; Len: Integer): string;

implementation

//uses MiscTypes, MiscTools;

function validarFecha(const f: string): boolean;
var date: TDateTime;
   dd,mm,yyyy: integer;
begin
  result := true;
  //31012012
  DateSeparator := '-';
  if TryStrToDate(f,date) then
    result := true
  else
    result := false;
end;

function StripString(const s: AnsiString): AnsiString;
  var n: Integer;
      leftBlanks, rightBlanks: Integer;
      c: Char;
begin
  leftBlanks := 0;
  for n := 1 to Length(s) do begin
    c := s[n];
    case c of
    #9,#10,#13,#32: Inc(leftBlanks);
    else Break;
    end;
  end;
  rightBlanks := 0;
  for n := Length(s) downto 1 do begin
    c := s[n];
    case c of
    #9,#10,#13,#32: Inc(rightBlanks);
    else Break;
    end;
  end;
  Result := Copy(s, 1 + leftBlanks, Length(s) - rightBlanks - leftBlanks);
end;

procedure SplitString(var result: TArrayOfAnsiString; const str, sep: AnsiString; max_items: Integer);

  procedure AddItem(var a: TArrayOfAnsiString; const s: AnsiString);
    var n: Integer;
  begin
    n := Length(a);
    SetLength(a, n+1);
    a[n] := s;
  end;

  var
    startPos, sepPos, sliceEnd: Integer;
begin
  SetLength(result, 0);
  startPos := 1;
  repeat
    if (max_items <> -1) and (Length(result) = (max_items-1))
    then sepPos := 0
    else sepPos := PosEx(sep, str, startPos);
    if sepPos = 0
    then sliceEnd := Length(str) + 1
    else sliceEnd := sepPos;
    AddItem(Result, Copy(str, startPos, sliceEnd-startPos));
    startPos := sepPos + Length(sep);
  until sepPos = 0;
end;


function NormalizeRut(const rut: AnsiString): AnsiString;
  var n: Integer; opos: Integer;
    c: Char;
begin
  SetLength(Result, Length(rut));
  opos := 1;
  for n := 1 to Length(rut) do begin
    c := UpCase(rut[n]);
    case c of
      '0': begin
        if opos > 1
        then begin
          Result[opos] := c;
          Inc(opos);
        end
      end;
      '1'..'9','k','K': begin
        Result[opos] := c;
        Inc(opos);
      end
    end;
  end;
  if (opos < 3)
  then Result := ''
  else begin
    Result[opos] := Result[opos-1];
    Result[opos-1] := '-';
    SetLength(Result, opos);
  end;
end;
  (*
function validarFecha(f: String): boolean;
begin

end;
    *)
function ValidarRUT(const run: AnsiString): boolean;
var
  normalized, integerPart: AnsiString;
  dvPart, calcDv: Char;
  runParts: TArrayOfAnsiString;
  suma, mul, i, dvr: Integer;
begin
  result := false;

  if trim(run)='' then
    exit;

  normalized := NormalizarRUT(run);

  if normalized = '' then
    exit;

  SplitString(runParts, normalized, '-');
  integerPart := runParts[0];
  dvPart := runParts[1][1];

  suma := 0;
  mul := 2;
  for i := Length(integerPart) downto 1 do
  begin
    suma := suma + (ord(integerPart[i]) - ord('0')) * mul;
    if mul = 7 then
      mul := 2
    else
      mul := mul + 1;
  end;

  dvr := 11 - suma mod 11;
  case dvr of
    10: calcDv := 'K';
    11: calcDv := '0';
  else
    calcDv := chr(dvr + ord('0'));
  end;

  Result := dvPart = calcDv;
end;

function NormalizarRUT(const run: AnsiString): AnsiString;
var
  c: Char;
  n: Integer;
  stripped: AnsiString;
begin
  stripped := StripString(run);
  Result := '';
  for n := 1 to Length(stripped) do
  begin
    c := UpCase(stripped[n]);
    if ((c >= '1') and (c <= '9')) or
      ((c = '0') and (n > 1)) or
      ((c = 'K') and (n = Length(stripped))) then
      Result := Result + c;
  end;
  if Length(Result) < 2 then
    Result := '';
  if Result <> '' then
    Insert('-', Result, Length(Result));
end;

function RutId(Rut: Longint): Char;
var
  Suma: Integer;
  RutStr: string;
  NumTemp: Byte;
  Multiplo: Byte;
  i: Integer;
  DigitoTemp: string[2];
begin
  Result := '?';

  if (Rut > 0) then
  begin
    Suma := 0;
    RutStr := IntToStr(Rut);
    Multiplo := 2;
    for i := Length(RutStr) downto 1 do
    begin
      NumTemp := StrToInt(RutStr[i]);
      Suma := Suma + (Multiplo * NumTemp);
      inc(Multiplo);
      if Multiplo > 7 then
        Multiplo := 2;
    end;

    i := 11 - (Suma mod 11);

    case i of
      11: DigitoTemp := '0';
      10: DigitoTemp := 'K';
    else
      DigitoTemp := IntToStr(i);
    end;

    Result := DigitoTemp[1];

  end;
end;

function RutValido(Rut: Longint; Digito_Id: Char): Boolean;
begin
  Result := RutId(Rut) = UpCase(Digito_Id);
end;

function IsDirectoryEmpty(const directory: string): boolean;
var
  searchRec: TSearchRec;
begin
  try
    result := (FindFirst(directory + '\*.*', faAnyFile, searchRec) = 0) and
      (FindNext(searchRec) = 0) and
      (FindNext(searchRec) <> 0);
  finally
    FindClose(searchRec);
  end;
end;

function IsExistsMoreDirectories(const directory: string): boolean;
var
  searchRec: TSearchRec;
begin
  try
    (*
    result := (FindFirst(directory + '\*.*', faAnyFile, searchRec) = 0) and
      (FindNext(searchRec) = 0) and
      (FindNext(searchRec) <> 0); *)

    result := (FindFirst(directory, faDirectory, searchRec) = 0) and
      (FindNext(searchRec) = 0) and
      (FindNext(searchRec) <> 0);

  finally
    FindClose(searchRec);
  end;
end;

function LeftPad(S: string; Ch: Char; Len: Integer): string;
var
  RestLen: Integer;
begin
  Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := S + StringOfChar(Ch, RestLen);
end;

function RightPad(S: string; Ch: Char; Len: Integer): string;
var
  RestLen: Integer;
begin
  Result  := S;
  RestLen := Len - Length(s);
  if RestLen < 1 then Exit;
  Result := StringOfChar(Ch, RestLen) + S;
end;

end.

