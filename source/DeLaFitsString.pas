{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{    String functions for formatting and converting    }
{                   the header cards                   }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsString;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, {$IFDEF DCC} Windows, {$ENDIF} DateUtils, DeLaFitsCommon;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_STRING          = 2000;

  ERROR_STRING_LENGTH   = 2100;
  ERROR_STRING_BOOLEAN  = 2110;
  ERROR_STRING_BITPIX   = 2120;
  ERROR_STRING_INTEGER  = 2130;
  ERROR_STRING_FLOAT    = 2140;
  ERROR_STRING_PARSE    = 2150;
  ERROR_STRING_DATETIME = 2160;
  ERROR_STRING_COORD    = 2170;
  ERROR_STRING_RA       = 2180;
  ERROR_STRING_DE       = 2190;

resourcestring

  { The messages of exceptions }

  SStringLength  = 'Wrong string length "%s"';
  SStringConvert = 'Error converting string "%s" to %s value';
  SStringParse   = 'Error parse a string on the part: exceeded number of various values "%s"';
  SStringValue   = 'Incorrect value "%g" as %s';

type

  { Exception classes }

  EFitsStringException = class(EFitsException);

  // Return a string of Count blank symbols

  function Blank(Count: Integer): string;

  // Align a string S up to Count symbols:
  // F(<text>,     -5) = <text >
  // F(<text>, -4..+4) = <text>
  // F(<text>,     +5) = < text>

  function Align(const S: string; Count: Integer): string;

  // Strictly align a string S up to Count symbols:
  // F(<text>, -5) = <text >
  // F(<text>, -4) = <text>
  // F(<text>, -3) = <tex>
  // F(<text>,  0) = <>
  // F(<text>, +3) = <tex>
  // F(<text>, +4) = <text>
  // F(<text>, +5) = < text>

  function AlignStrict(const S: string; Count: Integer): string;

  function PosChar(C: Char; const S: string; Start: Integer = 1): Integer;

  function MatchIndex(const S: string; const Values: array of string): Integer;

  // Citation a string S with align up to Count symbols:
  // F(<text>,     -5) = <'text '>
  // F(<text>, -4..+4) = <'text'>
  // F(<text>,     +5) = <' text'>
  // F(<text>,      0) = <'text'>
  // F(<t'ext>,     0) = <'t''ext'>

  function Quoted(const S: string; Count: Integer = 0): string;

  function UnQuoted(const S: string): string;

  // Converts the header Line to card.
  // The value-component is written in Result.Value.Str as is,
  // Result.Keyword and Result.Note with trimming

  function LineToCard(const Line: string): TCard;

  // Converts Card to header line.
  // For compose a value-component used Card.Value.Str as is

  function CardToLine(const Card: TCard): string;

  // Converting string values

  function StriToBol(const Value: string): Boolean;
  function BolToStri(const Value: Boolean): string;

  function StriToBitPix(const Value: string): TBitPix;
  function BitPixToStri(const Value: TBitPix): string; overload;
  function BitPixToStri(const Value: Integer): string; overload;

  function StriToInt(const Value: string): Int64;
  function IntToStri(const Value: Int64): string; overload;
  function IntToStri(const Value: Int64; Sign: Boolean; const Fmt: string): string; overload;

  // Result = '(Prec)d'

  function IntToStri(const Value: Int64; Sign: Boolean; Prec: Word): string; overload;

  function StriToFloat(const Value: string): Extended;
  function FloatToStri(const Value: Extended): string; overload;
  function FloatToStri(const Value: Extended; Sign: Boolean; const Fmt: string): string; overload;

  // Result = '(PrecInt)d.(PrecFloat)f'

  function FloatToStri(const Value: Extended; Sign: Boolean; PrecInt, PrecFloat: Word): string; overload;


  function GetSliceDateTime(const Value: string): TSliceDateTime;

  // Strictly corresponds to parameter Slice

  function StriToDateTime(const Value: string; Slice: TSliceDateTime; Tip: TFmtShortDate = yymmdd): TDateTime;

  function DateTimeToStri(const Value: TDateTime; Slice: TSliceDateTime): string;

  // Result only in coWhole and coDegree ~ ddd.(d);
  // Value ~ hh.(h) or ddd.(d) or HH:MM:SS.(s) or DDD:MM:SS.(s), see Tip

  function StriToRa(const Value: string; Tip: TFmtMeaCoord = coHour): Extended;

  // Result ~ any Ra, see Rep & Mea
  // Value only in degrees ~ ddd.(d)
  // Accuracy <Prec> is always specified with respect to the measure degree:
  // F(180.1234, 4, coWhole, coDegree) = 180.1234
  // F(180.1234, 4, coWhole, coHour  ) =  12.00823
  // F(180.1234, 4, coParts, coDegree) = 180:07:24.2
  // F(180.1234, 4, coParts, coHour  ) =  12:00:29.62

  function RaToStri(Value: Extended; Prec: Word; Rep: TFmtRepCoord; Mea: TFmtMeaCoord): string;

  // Result only in degrees ~ ddd.(d)
  // Value ~ dd.(d) or DD:MM:SS.(s)

  function StriToDe(const Value: string): Extended;

  // Result ~ any De, see Notate
  // Value only in degrees ~ dd.(d)
  // Accuracy <Prec> is always specified with respect to the measure degree:
  // F(45.1234, 4, coWhole) = +45.1234
  // F(45.2096, 4, coParts) = +45:12:34.6

  function DeToStri(const Value: Extended; Prec: Word; Rep: TFmtRepCoord): string;

implementation

type

  TDelimDateTime = record
    deDate, deMain, deTime: Char;
  end;

  TCoord = record
    Sgn: (sPlus, sMinus); // ~ '-00:00:00.01'
    GG: Word;             // Hours or degrees
    MM: Word;             // Minutes
    SS: Extended;         // Seconds
  end;

const

  cFitsDelimDateTime: TDelimDateTime = (deDate: '-'; deMain: 'T'; deTime: ':');
  cDelimsDateTime = ' -/\T:.,';
  cMinShortYear = 35; // 1935 <= YEAR < 2035

  cFitsDelimCoord = ':';
  cDelimsCoord = ' :/\';
  cCoordNull = -999.99;

function Blank(Count: Integer): string;
begin
  Result := System.StringOfChar(cChrBlank, Count);
end;

function Align(const S: string; Count: Integer): string;
var
  Addon: Integer;
begin
  Result := S;
  Addon := Abs(Count) - Length(Result);
  if Addon > 0 then
  begin
    if Count > 0 then
      Result := Blank(Addon) + Result
    else if Count < 0 then
      Result := Result + Blank(Addon);
  end;
end;

function AlignStrict(const S: string; Count: Integer): string;
begin
  if Abs(Count) >= Length(S) then
    Result := Align(S, Count)
  else
    Result := Copy(S, 1, Abs(Count));
end;

function PosChar(C: Char; const S: string; Start: Integer = 1): Integer;
var
  I: Integer;
begin
  Result := 0;
  if Start > 0 then
    for I := Start to Length(S) do
      if S[I] = C then
      begin
        Result := I;
        Break;
      end;
end;

function MatchIndex(const S: string; const Values: array of string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(Values) to High(Values) do
    if AnsiSameText(S, Values[I]) then
    begin
      Result := I;
      Break;
    end;
end;

function Quoted(const S: string; Count: Integer = 0): string;
begin
  Result := StringReplace(S, cChrQuote, (cChrQuote + cChrQuote), [rfReplaceAll]);
  Result := cChrQuote + Align(Result, Count) + cChrQuote;
end;

function UnQuoted(const S: string): string;
var
  Len: Integer;
begin
  Result := Trim(S);
  Len := Length(Result);
  if (Len > 1) and (Result[1] = cChrQuote) and (Result[Len] = cChrQuote) then
  begin
    Result := Copy(Result, 2, Len - 2);
    Result := Trim(Result);
    Result := StringReplace(Result, (cChrQuote + cChrQuote), cChrQuote, [rfReplaceAll]);
  end;
end;

function LineToCard(const Line: string): TCard;
  type
    TModeTrim = (mtNone, mtBoth, mtBothOne, mtLeftOne, mtRightOne);

  function CopyLine(Index1, Index2: Integer; Mode: TModeTrim): string;
  var
    L: Integer;
  begin
    Result := '';
    if (Index1 >= 1) and (Index2 <= cSizeLine) and (Index1 <= Index2) then
      Result := Copy(Line, Index1, Index2 - Index1 + 1);
    L := Length(Result);
    if L > 0 then
      case Mode of
        mtNone:
          ;
        mtBoth:
          Result := Trim(Result);
        mtBothOne:
          begin
            if Result[1] = cChrBlank then
              Delete(Result, 1, 1);
            L := Length(Result);
            if (L > 0) and (Result[L] = cChrBlank) then
              Delete(Result, L, 1);
          end;
        mtLeftOne:
          if Result[1] = cChrBlank then
            Delete(Result, 1, 1);
        mtRightOne:
          if Result[L] = cChrBlank then
            Delete(Result, L, 1);
      end;
  end;

var
  C: Char;
  I, V, N: Integer;
begin
  // Check of length line
  if Length(Line) < cSizeLine then
    raise EFitsStringException.CreateFmt('LineToCard. ' + SStringLength, [Line], ERROR_STRING_LENGTH);
  // Init
  Result := ToCard('', False, '', False, '');
  // Set keyword
  Result.Keyword := CopyLine(1, cSizeKeyword, mtBoth);
  // Detect and set a value indicator
  V := cSizeKeyword + 1;
  C := Line[V];
  if C = cChrValueIndicator then
  begin
    Inc(V);
    Result.ValueIndicate := True;
  end;
  // Detect and set a note indicator
  N := 0;
  if Result.ValueIndicate then
  begin
    I := V;
    while I <= cSizeLine do
    begin
      C := Line[I];
      if C = cChrNoteIndicator then
      begin
        N := I;
        Break;
      end;
      if C = cChrQuote then
      begin
        Inc(I);
        while I <= cSizeLine do
        begin
          if Line[I] = cChrQuote then
            if I < cSizeLine then
            begin
              if Line[I + 1] = cChrQuote then
                Inc(I)
              else
                Break;
            end;
          Inc(I);
        end;
      end;
      Inc(I);
    end;
  end
  else
  begin
    I := V;
    while I <= cSizeLine do
    begin
      C := Line[I];
      if C = cChrNoteIndicator then
      begin
        N := I;
        Break;
      end;
      if C <> cChrBlank then
        Break;
      Inc(I);
    end;
  end;
  Result.NoteIndicate := N > 0;
  // Set value and note
  if Result.NoteIndicate then
  begin
    Result.Value.Str := CopyLine(V, N - 1, mtBothOne);
    Result.Note := CopyLine(N + 1, cSizeLine, mtBoth);
  end
  else
    Result.Value.Str := CopyLine(V, cSizeLine, mtLeftOne);
end;

function CardToLine(const Card: TCard): string;
begin
  Result := AlignStrict(UpperCase(Trim(Card.Keyword)), -cSizeKeyword);
  if Card.ValueIndicate then
    Result := Result + cChrValueIndicator
  else
    Result := Result + cChrBlank;
  Result := Result + cChrBlank;
  Result := Result + Card.Value.Str;
  if Card.NoteIndicate then
    Result := Result + cChrBlank + cChrNoteIndicator + cChrBlank + Card.Note;
  Result := AlignStrict(Result, -cSizeLine);
end;

function StriToBol(const Value: string): Boolean;
var
  S: string;
begin
  S := Trim(Value);
  Result := (S = 'T');
  if not Result and (S <> 'F') then
    raise EFitsStringException.CreateFmt(SStringConvert, [S, 'Boolean'], ERROR_STRING_BOOLEAN);
end;

function BolToStri(const Value: Boolean): string;
begin
  if Value then
    Result := 'T'
  else
    Result := 'F';
end;

function StriToBitPix(const Value: string): TBitPix;
var
  S: string;
  V, Code: Integer;
begin
  S := Trim(Value);
  Val(S, V, Code);
  if Code <> 0 then
    Result := biUnknown
  else
    Result := IntToBitPix(V);
  if Result = biUnknown then
    raise EFitsStringException.CreateFmt(SStringConvert, [S, 'BitPix'], ERROR_STRING_BITPIX);
end;

function BitPixToStri(const Value: TBitPix): string; overload;
begin
  Result := IntToStr(BitPixToInt(Value));
end;

function BitPixToStri(const Value: Integer): string; overload;
begin
  Result := IntToStr(Value);
end;

function StriToInt(const Value: string): Int64;
var
  S: string;
  Code: Integer;
begin
  S := Trim(Value);
  Val(S, Result, Code);
  if Code <> 0 then
    raise EFitsStringException.CreateFmt(SStringConvert, [S, 'Integer'], ERROR_STRING_INTEGER);
end;

function IntToStri(const Value: Int64): string; overload;
begin
  Result := IntToStr(Value);
end;

function IntToStri(const Value: Int64; Sign: Boolean; const Fmt: string): string; overload;
begin
  Result := Format(Fmt, [Value]);
  Result := Trim(Result);
  if Sign and (Value >= 0) then
    Result := '+' + Result;
end;

function IntToStri(const Value: Int64; Sign: Boolean; Prec: Word): string; overload;
begin
  Result := IntToStri(Value, Sign, '%.' + IntToStr(Prec) + 'd');
end;

function StriToFloat(const Value: string): Extended;
var
  S: string;
  Code: Integer;
begin
  S := Trim(Value);
  S := StringReplace(S, ',', '.', []);
  Val(S, Result, Code);
  if Code <> 0 then
    raise EFitsStringException.CreateFmt(SStringConvert, [S, 'Float'], ERROR_STRING_FLOAT);
end;

function GetFormatSettings: TFormatSettings;
begin
  {$IFDEF FPC}
  Result := FormatSettings;
  {$ELSE}
    // http://docwiki.embarcadero.com/RADStudio/Tokyo/en/Legacy_IFEND_(Delphi)
    {$IF CompilerVersion >= 25.0}
      {$DEFINE DELALEGACYIFEND}
      {$LEGACYIFEND ON}
    {$IFEND}
    {$IF CompilerVersion < 22.0}
    GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, Result);
    {$ELSE}
    Result := TFormatSettings.Create;
    {$IFEND}
    {$IFDEF DELALEGACYIFEND}
      {$LEGACYIFEND OFF}
    {$ENDIF}
  {$ENDIF}
end;

function FloatToStri(const Value: Extended): string; overload;
var
  fs: TFormatSettings;
begin
  fs := GetFormatSettings;
  fs.DecimalSeparator := '.';
  Result := FloatToStr(Value, fs);
end;

function FloatToStri(const Value: Extended; Sign: Boolean; const Fmt: string): string; overload;
var
  fs: TFormatSettings;
begin
  fs := GetFormatSettings;
  fs.DecimalSeparator := '.';
  Result := Format(Fmt, [Value], fs);
  Result := Trim(Result);
  if Sign and (Value >= 0) then
    Result := '+' + Result;
end;

function FloatToStri(const Value: Extended; Sign: Boolean; PrecInt, PrecFloat: Word): string;
var
  I, Ind, Len: Integer;
  S: string;
begin
  Result := FloatToStri(Value, Sign, '%.' + IntToStr(PrecFloat) + 'f');
  // index of sign
  I := 1;
  if (Result[1] = '+') or (Result[1] = '-') then
    Inc(I);
  Ind := I;
  // length of int
  I := Pos('.', Result);
  if I = 0 then
    I := Length(Result)
  else
    Dec(I);
  Len := I - Ind + 1;
  // check precision of int part
  if Len < PrecInt then
  begin
    S := '';
    for I := Len to PrecInt - 1 do
      S := S + '0';
    Insert(S, Result, Ind);
  end;
end;

{ Function splits the string <Value> into parts <Parts>, separator is considered
  a symbol of <Delims>. Result - quantity parts found }
function ParseToParts(const Value, Delims: string; var Parts: array of string): Integer;
var
  I, J: Integer;
  C: Char;
  B: Boolean;
begin
  Result := 0;
  for I := Low(Parts) to High(Parts) do
    Parts[I] := '';
  J := Low(Parts) - 1;
  B := False;
  for I := 1 to Length(Value) do
  begin
    C := Value[I];
    if PosChar(C, Delims) > 0 then
    begin
      B := False;
      Continue;
    end;
    if not B then
    begin
      Inc(J);
      if J > High(Parts) then
        raise EFitsStringException.CreateFmt(SStringParse, [Value], ERROR_STRING_PARSE);
      Inc(Result);
    end;
    B := True;
    Parts[J] := Parts[J] + C;
  end;
end;

function GetSliceDateTime(const Value: string): TSliceDateTime;
begin
  if Length(Value) > 13 then
    Result := cCastDateTime
  else if PosChar(cFitsDelimDateTime.deTime, Value) > 0 then
    Result := cCastTime
  else
    Result := cCastDate;
end;

function StriToDateTime(const Value: string; Slice: TSliceDateTime; Tip: TFmtShortDate = yymmdd): TDateTime;
  procedure Exception;
  var
    S: string;
  begin
    case Slice of
      cCastDate: S := 'Date';
      cCastTime: S := 'Time';
      else {cCastDateTime:}
        S := 'DateTime'
    end;
    raise EFitsStringException.CreateFmt(SStringConvert, [Value, S], ERROR_STRING_DATETIME);
  end;

  function StrToWord(S: string): Word;
  begin
    Result := Word(StriToInt(S));
  end;

  function StrToMSec(S: string): Word;
  var
    Len: Integer;
  begin
    Len := Length(S);
    case Len of
      0:    Result := 0;
      1..3: Result := Round(StriToFloat('0.' + S) * 1000);
      else
        begin
          Result := Round(StriToFloat('0.' + Copy(S, 1, 3)) * 1000);
          if StriToInt(S[4]) >= 5 then Result := Result + 1;
        end;
    end;
  end;

  procedure LongYear(var Year: Word);
  begin
    if Year < cMinShortYear then
      Year := 2000 + Year
    else
      Year := 1900 + Year;
  end;

  procedure SwapWord(var V1, V2: Word);
  var
    Tmp: Word;
  begin
    Tmp := V1;
    V1 := V2;
    V2 := Tmp;
  end;

var
  Parts: array [0 .. 6] of string; // ['YYYY', 'MM', 'DD', 'HH', 'MM', 'SS', '(sss)']
  Count, dV02, I: Integer;
  S0, S2: string;
  V0, V2: Word;
  L0, L2: Integer;
  Year, Month, Day, Hour, Min, Sec, MSec, SecAddon: Word;
begin
  // Init
  Year := 1899;
  Month := 12;
  Day := 30;
  Hour := 0;
  Min := 0;
  Sec := 0;
  MSec := 0;
  SecAddon := 0;
  // Parse value
  for I := Low(Parts) to High(Parts) do
    Parts[I] := '';
  Count := ParseToParts(Value, cDelimsDateTime, Parts);
  // Calculating obvious
  case Slice of
    cCastDateTime:
      begin
        if (Count < 6) then Exception;
        Month := StrToWord(Parts[1]);
        Hour  := StrToWord(Parts[3]);
        Min   := StrToWord(Parts[4]);
        Sec   := StrToWord(Parts[5]);
        MSec  := StrToMSec(Parts[6]);
      end;
    cCastDate:
      begin
        if (Count <> 3) then Exception;
        Month := StrToWord(Parts[1]);
      end;
    cCastTime:
      begin
        if (Count < 3) or (Count > 4) then Exception;
        Hour  := StrToWord(Parts[0]);
        Min   := StrToWord(Parts[1]);
        Sec   := StrToWord(Parts[2]);
        MSec  := StrToMSec(Parts[3]);
      end;
  end;
  // Determination of the date: calculating year & day
  if Slice in [cCastDateTime, cCastDate] then
  begin
    S0 := TrimLeft(Parts[0]); V0 := StrToWord(S0); L0 := Length(S0);
    S2 := TrimLeft(Parts[2]); V2 := StrToWord(S2); L2 := Length(S2);
    dV02 := (L0 - L2);
    case dV02 of
     +3:{YYYY-MM-D } ;
     +2:{YYYY-MM-DD} ;
     +1:{  YY-MM-D } LongYear(V0);
     // ?
     00:{YY-MM-DD or DD-MM-YY}
     begin
       // (19..|2000)YY-MM-DD
       if (V0 > 31) or (V0 = 0) then LongYear(V0)
       else
       begin
         // DD-MM-YY(19..|2000)
         if (V2 > 31) or (V2 = 0) then begin LongYear(V2); SwapWord(V0, V2); end
         else
           case Tip of
             yymmdd: LongYear(V0); // YY-MM-DD ~ Old format FITS
             ddmmyy: begin LongYear(V2); SwapWord(V0, V2); end;
           end;
       end;
     end;
     // end ?
     -1:{ D-MM-YY  } begin LongYear(V2); SwapWord(V0, V2); end;
     -2:{DD-MM-YYYY} SwapWord(V0, V2);
     -3:{ D-MM-YYYY} SwapWord(V0, V2);
    end;
    Year := V0;
    Day := V2;
  end;
  // Correction for a time: calculating addon second
  if Slice in [cCastDateTime, cCastTime] then
  begin
    if MSec > 999 then
    begin
      SecAddon := SecAddon + (MSec div 1000);
      MSec := MSec mod 1000;
    end;
    if Sec >= 60 then
    begin
      SecAddon := SecAddon + (Sec div 60) * 60;
      Sec := Sec mod 60;
    end;
  end;
  // Calculating Result
  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Min, Sec, MSec);
  if SecAddon > 0 then Result := IncSecond(Result, SecAddon);
end;

function DateTimeToStri(const Value: TDateTime; Slice: TSliceDateTime): string;
  function vtos(V, Prec: Word): string;
  begin
    Result := Format('%.' + IntToStr(Prec) + 'd', [V]);
  end;

var
  sDate, sTime: string;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  // Fits standart: YYYY-MM-DDTHH:MM:SS.zzz
  DecodeDate(Value, Year, Month, Day);
  DecodeTime(Value, Hour, Min, Sec, MSec);
  with cFitsDelimDateTime do
  begin
    sDate := vtos(Year, 4) + deDate + vtos(Month, 2) + deDate + vtos(Day, 2);
    sTime := vtos(Hour, 2) + deTime + vtos(Min, 2) + deTime + vtos(Sec, 2) + '.' + vtos(MSec, 3);
  end;
  case Slice of
    cCastDate:
      Result := sDate;
    cCastTime:
      Result := sTime;
    else {cCastDateTime}
      Result := sDate + cFitsDelimDateTime.deMain + sTime;
  end;
end;

function FloatToCoord(Value: Extended): TCoord;
var
  St: string;
begin
  with Result do
  begin
    if Value < 0 then Sgn := sMinus else Sgn := sPlus;
    Value := Abs(Value);
    GG := Trunc(Value);
    Value := (Value - GG) * 60;
    MM := Trunc(Value);
    Value := (Value - MM) * 60;
    //SS := Value;// accuracy is lost...
    St := FloatToStri(Value, False, '%g');
    SS := StriToFloat(St);
  end;
end;

function CoordToFloat(Value: TCoord): Extended;
begin
  with Value do
  begin
    Result := (GG * 3600 + MM * 60 + SS) / 3600;
    // Result := Abs(GG) + MM / 60 + SS / 3600;
    if Sgn = sMinus then Result := -Result;
  end;
end;

function CoordToStri(const Value: TCoord; SignGG: Boolean; PrecGG, PrecSS: Word; LimGG, RigGG: Integer): string;
var
  D: Integer;
  F: Extended;
  X: Integer;
  G, M, S: string;
begin
  // sec
  F := Value.SS;
  D := 0;
  S := FloatToStri(F, False, 2, PrecSS);
  if Pos('60', S) = 1 then
  begin
    D := 1;
    F := 0;
  end;
  S := FloatToStri(F, False, 2, PrecSS);
  // min
  X := Value.MM + D;
  D := 0;
  if X = 60 then
  begin
    D := 1;
    X := 0;
  end;
  M := IntToStri(X, False, 2);
  // hour or degree
  X := Value.GG + D;
  if X >= LimGG then
    X := RigGG;
  G := IntToStri(X, False, PrecGG);
  if Value.Sgn = sMinus then
    G := '-' + G
  else if SignGG then
    G := '+' + G;
  // make result
  Result := G + cFitsDelimCoord + M + cFitsDelimCoord + S;
end;

function StriToCoord(Value: string): TCoord;

  procedure Exception;
  begin
    raise EFitsStringException.CreateFmt(SStringConvert, [Value, 'II Equatorial coordinate system'], ERROR_STRING_COORD);
  end;

var
  Parts: array [0 .. 2] of string; // ['GG', 'MM', 'SS.sss']
  I, Count: Integer;
  Int: Int64;
begin
  // Init
  with Result do
  begin
    GG := 0;
    MM := 0;
    SS := 0.0;
  end;
  // Parse Value
  Value := Trim(Value);
  for I := Low(Parts) to High(Parts) do
    Parts[I] := '';
  Count := ParseToParts(Value, cDelimsCoord, Parts);
  if (Count < 3) then
    Exception;
  // Format
  with Result do
  begin
    if (Parts[0][1] = '-') then Sgn := sMinus else Sgn := sPlus;
    Int := StriToInt(Parts[0]);
    GG := Word(Abs(Int));
    Int := StriToInt(Parts[1]);
    if (Int < 0) or (Int > 60) then Exception;
    MM := Word(Int);
    SS := StriToFloat(Parts[2]);
    if (SS < 0) or (SS > 60) then Exception;
  end;
end;

function GetFmtRepCoord(Value: string): TFmtRepCoord;
var
  I: Integer;
begin
  Result := coWhole;
  Value := Trim(Value);
  for I := 1 to Length(cDelimsCoord) do
    if PosChar(cDelimsCoord[I], Value) > 0 then
    begin
      Result := coParts;
      Break;
    end;
end;

// Checking the value or Right Ascension
function InvalidRa(const Ra: Extended): Boolean;
begin
  Result := (Ra < 0.0) or (Ra >= 360.0);
end;

function StriToRa(const Value: string; Tip: TFmtMeaCoord = coHour): Extended;
var
  Coord: TCoord;
begin
  Result := cCoordNull;
  case GetFmtRepCoord(Value) of
    coWhole:
      begin
        Result := StriToFloat(Value);
      end;
    coParts:
      begin
        Coord := StriToCoord(Value);
        Result := CoordToFloat(Coord);
      end;
  end;
  if (Result < 24.0) and (Tip = coHour) then
    Result := Result * 15;
  if InvalidRa(Result) then
    raise EFitsStringException.CreateFmt(SStringValue, [Result, 'Right Ascension'], ERROR_STRING_RA);
end;

function RaToStri(Value: Extended; Prec: Word; Rep: TFmtRepCoord; Mea: TFmtMeaCoord): string;
var
  Coord: TCoord;
  PrecGG: Word;
  LimGG, RigGG: Integer;
begin
  if InvalidRa(Value) then
    raise EFitsStringException.CreateFmt(SStringValue, [Value, 'Right Ascension'], ERROR_STRING_RA);
  Result := '';
  if (Mea = coHour) then Value := Value / 15;
  if (Mea = coHour) then PrecGG := 2 else {Mea = coDegree} PrecGG := 3;
  if (Mea = coHour) and (Prec > 0) then Inc(Prec);
  if (Mea = coHour) then LimGG := 24 else {Mea = coDegree} LimGG := 360;
  RigGG := 0;
  case Rep of
    coWhole:
      begin
        Result := FloatToStri(Value, False, PrecGG, Prec);
        if Pos(IntToStr(LimGG), Result) = 1 then
          Result := FloatToStri(RigGG, False, PrecGG, Prec);
      end;
    coParts:
      begin
        if Prec > 3 then Prec := Prec - 3 else Prec := 0;
        Coord := FloatToCoord(Value);
        Result := CoordToStri(Coord, False, PrecGG, Prec, LimGG, RigGG);
      end;
  end;
end;

// Checking the value or Declination
function InvalidDe(const De: Extended): Boolean;
begin
  Result := (De < -90) or (De > 90);
end;

function StriToDe(const Value: string): Extended;
var
  Coord: TCoord;
begin
  Result := cCoordNull;
  case GeTFmtRepCoord(Value) of
    coWhole:
      begin
        Result := StriToFloat(Value);
      end;
    coParts:
      begin
        Coord := StriToCoord(Value);
        Result := CoordToFloat(Coord);
      end;
  end;
  if InvalidDe(Result) then
    raise EFitsStringException.CreateFmt(SStringValue, [Result, 'Declination'], ERROR_STRING_DE);
end;

function DeToStri(const Value: Extended; Prec: Word; Rep: TFmtRepCoord): string;
var
  Coord: TCoord;
  LimGG, RigGG: Integer;
begin
  if InvalidDe(Value) then
    raise EFitsStringException.CreateFmt(SStringValue, [Value, 'Declination'], ERROR_STRING_DE);
  Result := '';
  LimGG := 90;
  RigGG := 90;
  case Rep of
    coWhole:
      begin
        Result := FloatToStri(Value, True, 2, Prec);
      end;
    coParts:
      begin
        if Prec > 3 then Prec := Prec - 3 else Prec := 0;
        Coord := FloatToCoord(Value);
        Result := CoordToStri(Coord, True, 2, Prec, LimGG, RigGG);
      end;
  end;
end;

end.
