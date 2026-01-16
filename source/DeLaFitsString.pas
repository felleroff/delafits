{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{    String functions for formatting and converting    }
{                  the header records                  }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsString;

{$I DeLaFitsDefine.inc}

interface

uses
{$IFDEF DCC}
  Windows,
{$ENDIF}
  SysUtils, Math, DateUtils, DeLaFitsCommon;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_STRING                      = 3000;

  ERROR_STRING_LINE_LENGTH          = 3100;

  ERROR_STRING_BOOLEAN              = 3200;
  ERROR_STRING_BITPIX               = 3210;
  ERROR_STRING_INT64                = 3220;
  ERROR_STRING_INTEGER              = 3230;
  ERROR_STRING_FLOAT                = 3240;

  ERROR_STRING_DATETIME             = 3250;
  ERROR_STRING_DATETIME_FRAC_SECOND = 3251;
  ERROR_STRING_DATETIME_PREC_SECOND = 3252;

  ERROR_STRING_COORDINATE_LENGTH    = 3260;
  ERROR_STRING_COORDINATE_VALUE     = 3261;
  ERROR_STRING_RA                   = 3262;
  ERROR_STRING_DE                   = 3263;

resourcestring

  { The messages of exceptions }

  SStringLineLength            = 'Incorrect string length "%d" characters. Line object requires 80 characters';

  SStringToBoolean             = 'Failed to convert "%s" to boolean value';
  SStringToBitPix              = 'Failed to convert "%s" to BitPix value';
  SStringToInteger             = 'Failed to convert "%s" to integer number';
  SStringToFloat               = 'Failed to convert "%s" to floating point number';
  SStringToDateTime            = 'Failed to convert "%s" to date and time';
  SStringToDate                = 'Failed to convert "%s" to date value';
  SStringToTime                = 'Failed to convert "%s" to time value';
  SStringToCoordinate          = 'Failed to convert "%s" to an II Equatorial Coordinate System value';

  SStringInvalidTimeFracSecond = '"%d" is an invalid number of atto-seconds for a time value';
  SStringInvalidTimePrecSecond = '"%d" is an invalid seconds precision value in a time value';
  SStringInvalidRa             = '"%g" is an invalid Right Ascension value';
  SStringInvalidDe             = '"%g" is an invalid Declination value';

type

  { Exception classes }

  EFitsStringException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  { Returns a string of the specified length with blank characters }

  function BlankString(AWidth: Integer): string; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function IsBlankString(const AString: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  { Pad a string with blank characters to a specified length:
    F(<text>,     -5) = <text >
    F(<text>, -4..+4) = <text>
    F(<text>,     +5) = < text> }

  function PadString(const AString: string; AWidth: Integer): string;

  { Ensure the specified string length. Pad a string with blank characters or
    truncate it:
    F(<text>, -5) = <text >
    F(<text>, -4) = <text>
    F(<text>, -3) = <tex>
    F(<text>,  0) = <>
    F(<text>, +3) = <tex>
    F(<text>, +4) = <text>
    F(<text>, +5) = < text> }

  function EnsureString(const AString: string; AWidth: Integer): string;

  function PosChar(AChar: Char; const AString: string; AOffset: Integer = 1): Integer;

  { Indicates whether an array of strings contains a case-insensitive match
    to a specified string }

  { Indicates whether the string array contains a match for the specified
    string. MatchString compares case-sensitively. MatchText compares
    case-insensitively }

  function MatchString(const AString: string; const AValues: array of string): Boolean;
  function MatchText(const AString: string; const AValues: array of string): Boolean;

  { QuotedString pads a string with blank characters to a specified length
    and quote it. Quote character inside string will be escaped:
    F(<text>,     -5) = <'text '>
    F(<text>, -4..+4) = <'text'>
    F(<text>,     +5) = <' text'>
    F(<text>,      0) = <'text'>
    F(<t'ext>,     0) = <'t''ext'>

    UnquotedString removes surrounding quotes and removes escaping quotes
    within the string }

  function QuotedString(const AString: string; AWidth: Integer = 0): string;
  function UnquotedString(const AString: string): string;

  { Checks if a string is in quotes (with an ampersand). Nonsignificant space
    characters may occur between the ampersand character and the closing quote
    character. Nonsignificant space characters are ignored }

  function IsQuotedString(const AString: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function IsQuotedAmpersandString(const AString: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  { Converts the Header Line to the Record and back.

    LineToRecord (Header Line parsing) writes the trimmed keyword and note
    components in the Record fields, and the value component is written in
    the Record.Value field as is.

    RecordToLine (composing the Header Line) ensures the size of the keyword
    component from the Record.Keyword field, and for the value component uses
    Record.Value field as is }

  function LineToRecord(const ALine: string): TLineRecord;
  function RecordToLine(const ARecord: TLineRecord): string;

  { Converts string values }

  function TryStringToBool(const AString: string; out AValue: Boolean): Boolean;
  function StringToBool(const AString: string): Boolean;
  function BoolToString(const AValue: Boolean): string;

  function TryStringToBitPix(const AString: string; out AValue: TBitPix): Boolean;
  function StringToBitPix(const AString: string): TBitPix;
  function BitPixToString(const AValue: TBitPix): string; overload;
  function BitPixToString(const AValue: Integer): string; overload;

  function TryStringToInt64(const AString: string; out AValue: Int64): Boolean;
  function StringToInt64(const AString: string): Int64;
  function Int64ToString(const AValue: Int64): string; overload;
  function Int64ToString(const AValue: Int64; ASign: Boolean; const AFmt: string): string; overload;
  function Int64ToString(const AValue: Int64; ASign: Boolean; APrec: Word): string; overload; // ~ '(APrec)d'
  function Int64ToHexString(const AValue: Int64; APrec: Word = 0): string;
  function Int64ToDecString(const AValue: Int64; APrec: Word = 0): string;
  function Int64ToOctString(const AValue: Int64; APrec: Word = 0): string;
  function Int64ToBinString(const AValue: Int64; APrec: Word = 0): string;

  function TryStringToInteger(const AString: string; out AValue: Integer): Boolean;
  function StringToInteger(const AString: string): Integer;
  function IntegerToString(const AValue: Integer): string; overload;
  function IntegerToString(const AValue: Integer; ASign: Boolean; const AFmt: string): string; overload;
  function IntegerToString(const AValue: Integer; ASign: Boolean; APrec: Word): string; overload; // ~ '(APrec)d'

  function DotFormatSettings: TFormatSettings;

  function TryStringToFloat(const AString: string; out AValue: Extended): Boolean;
  function StringToFloat(const AString: string): Extended;
  function FloatToString(const AValue: Extended): string; overload;
  function FloatToString(const AValue: Extended; ASign: Boolean; const AFmt: string): string; overload;
  function FloatToString(const AValue: Extended; ASign: Boolean; APrecInt, APrecFloat: Word): string; overload; // ~ '(APrecInt)d.(APrecFloat)f'

  { Converts a string to a floating-point number and back,
    taking into account the specifics of Fortran notation }

  function FortranStringToFloat(const AString: string): Extended;
  function FloatToFortranExponentString(const AValue: Extended; APrecision, ADigits: Integer;
    AExponentChar: Char; const AFormatSettings: TFormatSettings): string;
  function FloatToFortranGeneralString(const AValue: Extended; APrecision, ADigits: Integer;
    const AFormatSettings: TFormatSettings): string;

  { Text representation of the TVariable type }

  function VariableToPrintString(const AValue: TVariable): string;

  function StringToDateTime(const AString: string; APart: TPartDateTime; ATip: TFmtShortDate = yymmdd): TDateTime;
  function DateTimeToString(const AValue: TDateTime; APart: TPartDateTime; AFracSec: Word = 3): string; // ~ 'YYYY-MM-DDThh:mm:ss.(AFracSec)'

  function StringToPreciseDateTime(const AString: string; APart: TPartDateTime; ATip: TFmtShortDate = yymmdd): TPreciseDateTime;
  function PreciseDateTimeToString(const AValue: TPreciseDateTime; APart: TPartDateTime; AFracSec: Word = 18): string; // ~ 'YYYY-MM-DDThh:mm:ss.(AFracSec)'

  function ExtractFmtRepCoord(const AString: string): TFmtRepCoord;

  { The function returns the Right Ascension in decimal format and
    degrees [0.0..360.0). Valid input value (string) formats are:
    hh(.h), ddd(.d), HH:MM:SS(.s), and DDD:MM:SS(.s). The ATip hint
    disambiguates results less than 24 }

  function StringToRa(const AString: string; ATip: TFmtMeaCoord = coHour): Extended;

  { The function returns the Right Ascension in the format specified by the
    ARep and AMea parameters. The input value (float) is passed in decimal
    format and degrees [0.0..360.0). The APrec parameter specifies the
    conversion precision of the input value:
    F(180.1234, 4, coDecimal, coDegree) = 180.1234
    F(180.1234, 4, coDecimal,   coHour) =  12.00823
    F(180.1234, 4,  coMixed,  coDegree) = 180:07:24.2
    F(180.1234, 4,  coMixed,    coHour) =  12:00:29.62 }

  function RaToString(const AValue: Extended; APrec: Word; ARep: TFmtRepCoord; AMea: TFmtMeaCoord): string;

  { The function returns the Declination in decimal format and
    degrees [-90.0...+90.0]. Valid input value (string) formats
    are: dd(.d) or DD:MM:SS(.s) }

  function StringToDe(const AString: string): Extended;

  { The function returns the Declination in the format specified by the
    ARep parameter. The input value (float) is passed in decimal format
    and degrees [-90.0...+90.0]. The APrec parameter specifies the
    conversion precision of the input value:
    F(45.1234, 4, coDecimal) = +45.1234
    F(45.2096, 4,   coMixed) = +45:12:34.6 }

  function DeToString(const AValue: Extended; APrec: Word; ARep: TFmtRepCoord): string;

implementation

type
  TDelimDateTime = record
    Date, Main, Time: Char;
  end;

  TPreciseDateTimeRec = record
    Year, Month, Day, Hour, Min, Sec: Word;
    AttoSec: Int64;
  end;

  TCoord = record
    Sign: (sPlus, sMinus); // ~ '-00:00:00.01'
    GG: Word;              // Hours or Degrees
    MM: Word;              // Minutes
    SS: Extended;          // Seconds
  end;

const
  cFitsDelimDateTime: TDelimDateTime = (Date: '-'; Main: 'T'; Time: ':');
  cDelimsDateTime = ' -/\T:.,';
  cMinShortYear = 35; // 1935 <= YEAR < 2035
  cMaxAttoSec = 999999999999999999; // 1s = 1E+18as

  cFitsDelimCoord = ':';
  cDelimsCoord = ' :/\';
  cCoordNull = -999.99;

{ EFitsStringException }

function EFitsStringException.GetTopic: string;
begin
  Result := 'STRING';
end;

{ String }

function BlankString(AWidth: Integer): string;
begin
  Result := System.StringOfChar(cChrBlank, AWidth);
end;

function IsBlankString(const AString: string): Boolean;
var
  LIndex: Integer;
begin
  Result := True;
  for LIndex := 1 to Length(AString) do
    if AString[LIndex] <> cChrBlank then
    begin
      Result := False;
      Break;
    end;
end;

function GrowString(const AString: string; AWidth: Integer): string;
var
  LBlank: string;
begin
  Assert(Abs(AWidth) > Length(AString), SAssertionFailure);
  LBlank := BlankString(Abs(AWidth) - Length(AString));
  if AWidth > 0 then
    Result := LBlank + AString
  else
    Result := AString + LBlank;
end;

function PadString(const AString: string; AWidth: Integer): string;
var
  LWidth: Integer;
begin
  LWidth := Abs(AWidth);
  if LWidth <= Length(AString) then
    Result := AString
  else
    Result := GrowString(AString, AWidth);
end;

function EnsureString(const AString: string; AWidth: Integer): string;
var
  LWidth: Integer;
begin
  LWidth := Abs(AWidth);
  if LWidth <= Length(AString) then
    Result := Copy(AString, 1, LWidth)
  else
    Result := GrowString(AString, AWidth);
end;

function PosChar(AChar: Char; const AString: string; AOffset: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  if AOffset > 0 then
    for I := AOffset to Length(AString) do
      if AString[I] = AChar then
      begin
        Result := I;
        Break;
      end;
end;

function MatchString(const AString: string; const AValues: array of string): Boolean;
var
  LIndex: Integer;
begin
  Result := False;
  for LIndex := Low(AValues) to High(AValues) do
    if AnsiSameStr(AString, AValues[LIndex]) then
    begin
      Result := True;
      Break;
    end;
end;

function MatchText(const AString: string; const AValues: array of string): Boolean;
var
  LIndex: Integer;
begin
  Result := False;
  for LIndex := Low(AValues) to High(AValues) do
    if SameText(AString, AValues[LIndex]) then
    begin
      Result := True;
      Break;
    end;
end;

function QuotedString(const AString: string; AWidth: Integer = 0): string;
begin
  Result := StringReplace(AString, cChrQuote, (cChrQuote + cChrQuote), [rfReplaceAll]);
  Result := cChrQuote + PadString(Result, AWidth) + cChrQuote;
end;

function UnquotedString(const AString: string): string;
var
  LLength: Integer;
begin
  Result := Trim(AString);
  LLength := Length(Result);
  if (LLength > 1) and (Result[1] = cChrQuote) and (Result[LLength] = cChrQuote) then
  begin
    Result := Copy(Result, 2, LLength - 2);
    Result := Trim(Result);
    Result := StringReplace(Result, (cChrQuote + cChrQuote), cChrQuote, [rfReplaceAll]);
  end;
end;

function IsQuotedString(const AString: string): Boolean;
var
  LString: string;
  LWidth: Integer;
begin
  LString := Trim(AString);
  LWidth := Length(LString);
  Result := (LWidth > 1) and (LString[1] = cChrQuote) and (LString[LWidth] = cChrQuote);
end;

function IsQuotedAmpersandString(const AString: string): Boolean;
var
  LString: string;
  LWidth, LIndex: Integer;
  LChar: Char;
begin
  Result := False;
  LString := Trim(AString);
  LWidth := Length(LString);
  if (LWidth > 2) and (LString[1] = cChrQuote) and (LString[LWidth] = cChrQuote) then
    for LIndex := LWidth - 1 downto 2 do
    begin
      LChar := LString[LIndex];
      if LChar = cChrAmpersand then
        Result := True;
      if LChar <> cChrBlank then
        Break;
    end;
end;

function IsCommentaryKeyword(const AKeyword: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := MatchString(AKeyword, [cCOMMENT, cHISTORY, cBLANK]);
end;

function IsContinuedKeyword(const AKeyword: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := SameText(AKeyword, cCONTINUE);
end;

function LineToRecord(const ALine: string): TLineRecord;
var
  LChar: Char;
  LIndex, LStartValue, LStopValue, LStartNote, LStopNote: Integer;
begin
  // Check of length line
  if Length(ALine) < cSizeLine then
    raise EFitsStringException.CreateFmt(SStringLineLength,
      [Length(ALine)], ERROR_STRING_LINE_LENGTH);
  // Create blank record
  Result := EmptyLineRecord;
  // Set keyword
  Result.Keyword := Trim(Copy(ALine, 1, cSizeKeyword));
  // Find and set the value-indicator and start/stop value
  // [FITS_STANDARD_4.0, SECT_4.1.2.2] Value indicator (Bytes 9 and 10)
  // [FITS_STANDARD_4.0, SECT_4.1.2.3] Value/comment (Bytes 11 through 80)
  LStartValue := cSizeKeyword + 1;
  LStopValue := cSizeLine;
  if not IsCommentaryKeyword(Result.Keyword) then
  begin
    LChar := ALine[LStartValue];
    if LChar = cChrValueIndicator then
    begin
      Inc(LStartValue);
      if ALine[LStartValue] = cChrBlank then
        Inc(LStartValue);
      Result.ValueIndicate := True;
    end else
    if (LChar = cChrBlank) and (Length(Result.Keyword) = cSizeKeyword) then
    begin
      Inc(LStartValue);
      if ALine[LStartValue] = cChrBlank then
        Inc(LStartValue);
    end;
  end;
  // Find and set the note-indicator, start/stop note and correct the stop value
  // [FITS_STANDARD_4.0, SECT_4.2.1.2] Continued string (long-string) keywords
  LStartNote := cSizeLine + 1;
  LStopNote := cSizeLine;
  if Result.ValueIndicate or IsContinuedKeyword(Result.Keyword) then
  begin
    LIndex := LStartValue;
    while LIndex <= cSizeLine do
    begin
      LChar := ALine[LIndex];
      if LChar = cChrNoteIndicator then
      begin
        LStopValue := LIndex - 1;
        if (LStopValue >= LStartValue) and (ALine[LStopValue] = cChrBlank) then
          Dec(LStopValue);
        LStartNote := LIndex + 1;
        if (LStartNote <= LStopNote) and (ALine[LStartNote] = cChrBlank) then
          Inc(LStartNote);
        Result.NoteIndicate := True;
        Break;
      end;
      if LChar = cChrQuote then
      begin
        Inc(LIndex);
        while LIndex <= cSizeLine do
        begin
          if ALine[LIndex] = cChrQuote then
            if LIndex < cSizeLine then
            begin
              if ALine[LIndex + 1] = cChrQuote then
                Inc(LIndex)
              else
                Break;
            end;
          Inc(LIndex);
        end;
      end;
      Inc(LIndex);
    end;
  end;
  // Set value and note
  if LStartValue <= LStopValue then
    Result.Value := Copy(ALine, LStartValue, LStopValue - LStartValue + 1);
  if LStartNote <= LStopNote then
    Result.Note := Copy(ALine, LStartNote, LStopNote - LStartNote + 1);
end;

function RecordToLine(const ARecord: TLineRecord): string;
var
  LKeyword: string;
begin
  LKeyword := UpperCase(Trim(Copy(ARecord.Keyword, 1, cSizeKeyword)));
  Result := EnsureString(LKeyword, -cSizeKeyword);
  if ARecord.ValueIndicate then
    Result := Result + cChrValueIndicator + cChrBlank
  else if Length(LKeyword) = cSizeKeyword {or IsContinuedKeyword(LKeyword)} then
    Result := Result + cChrBlank + cChrBlank;
  Result := Result + ARecord.Value;
  if ARecord.NoteIndicate then
    Result := Result + cChrBlank + cChrNoteIndicator + cChrBlank + ARecord.Note;
  Result := EnsureString(Result, -cSizeLine);
end;

function TryStringToBool(const AString: string; out AValue: Boolean): Boolean;
var
  LString: string;
begin
  LString := Trim(AString);
  if LString = 'T' then
  begin
    AValue := True;
    Result := True;
  end else
  if LString = 'F' then
  begin
    AValue := False;
    Result := True;
  end else
  begin
    AValue := False;
    Result := False;
  end;
end;

function StringToBool(const AString: string): Boolean;
begin
  if not TryStringToBool(AString, {out} Result) then
    raise EFitsStringException.CreateFmt(SStringToBoolean, [AString],
      ERROR_STRING_BOOLEAN);
end;

function BoolToString(const AValue: Boolean): string;
begin
  if AValue then
    Result := 'T'
  else
    Result := 'F';
end;

function TryStringToBitPix(const AString: string; out AValue: TBitPix): Boolean;
var
  LString: string;
  LInteger, LCode: Integer;
begin
  LString := Trim(AString);
  Val(LString, LInteger, LCode);
  if LCode = 0 then
    AValue := IntToBitPix(LInteger)
  else
    AValue := biUnknown;
  Result := AValue <> biUnknown;
end;

function StringToBitPix(const AString: string): TBitPix;
begin
  if not TryStringToBitPix(AString, {out} Result) then
    raise EFitsStringException.CreateFmt(SStringToBitPix, [AString],
      ERROR_STRING_BITPIX);
end;

function BitPixToString(const AValue: TBitPix): string; overload;
begin
  Result := IntToStr(BitPixToInt(AValue));
end;

function BitPixToString(const AValue: Integer): string; overload;
begin
  Result := IntToStr(AValue);
end;

function TryStringToInt64(const AString: string; out AValue: Int64): Boolean;
var
  LString: string;
  LCode: Integer;
begin
  LString := Trim(AString);
  Val(LString, AValue, LCode);
  Result := LCode = 0;
end;

function StringToInt64(const AString: string): Int64;
begin
  if not TryStringToInt64(AString, {out} Result) then
    raise EFitsStringException.CreateFmt(SStringToInteger, [AString],
      ERROR_STRING_INT64);
end;

function Int64ToString(const AValue: Int64): string; overload;
begin
  Result := IntToStr(AValue);
end;

function Int64ToString(const AValue: Int64; ASign: Boolean; const AFmt: string): string; overload;
begin
  Result := Format(AFmt, [AValue]);
  Result := Trim(Result);
  if ASign and (AValue >= 0) then
    Result := '+' + Result;
end;

function Int64ToString(const AValue: Int64; ASign: Boolean; APrec: Word): string; overload;
begin
  Result := Int64ToString(AValue, ASign, '%.' + IntToStr(APrec) + 'd');
end;

function Int64ToBaseString(const AValue: Int64; ABase, AShear: Byte; APrec: Word): string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
const
  cHexChars: array [0 .. 15] of Char ='0123456789ABCDEF';
var
  LValue: Int64;
  LIndex: Byte;
  LWidth: Word;
  LString: array [1 .. 64] of Char;
begin
  LValue := AValue;
  LIndex := 64;
  repeat
    LString[LIndex] := cHexChars[LValue and ABase];
    LValue := LValue shr AShear;
    Dec(LIndex);
  until (LValue = 0) or (LIndex = 0);
  LWidth := 64 - LIndex;
  Result := Copy(LString, LIndex + 1, LWidth);
  if APrec > LWidth then
    Result := StringOfChar('0', APrec - LWidth) + Result;
end;

function Int64ToHexString(const AValue: Int64; APrec: Word): string;
begin
  Result := Int64ToBaseString(AValue, {ABase:} $0F, {AShear:} $04, APrec);
end;

function Int64ToDecString(const AValue: Int64; APrec: Word): string;
var
  LWidth: Word;
  LIndex: Integer;
begin
  Result := IntToStr(AValue);
  LWidth := Length(Result);
  if APrec > LWidth then
  begin
    if AValue < 0 then
      LIndex := 2
    else
      LIndex := 1;
    Insert(StringOfChar('0', APrec - LWidth), Result, LIndex);
  end;
end;

function Int64ToOctString(const AValue: Int64; APrec: Word): string;
begin
  Result := Int64ToBaseString(AValue, {ABase:} $07, {AShear:} $03, APrec);
end;

function Int64ToBinString(const AValue: Int64; APrec: Word): string;
begin
  Result := Int64ToBaseString(AValue, {ABase:} $01, {AShear:} $01, APrec);
end;

function TryStringToInteger(const AString: string; out AValue: Integer): Boolean;
var
  LString: string;
  LCode: Integer;
begin
  LString := Trim(AString);
  Val(LString, AValue, LCode);
  Result := LCode = 0;
end;

function StringToInteger(const AString: string): Integer;
begin
  if not TryStringToInteger(AString, {out} Result) then
    raise EFitsStringException.CreateFmt(SStringToInteger, [AString],
      ERROR_STRING_INTEGER);
end;

function IntegerToString(const AValue: Integer): string; overload;
begin
  Result := IntToStr(AValue);
end;

function IntegerToString(const AValue: Integer; ASign: Boolean; const AFmt: string): string; overload;
begin
  Result := Format(AFmt, [AValue]);
  Result := Trim(Result);
  if ASign and (AValue >= 0) then
    Result := '+' + Result;
end;

function IntegerToString(const AValue: Integer; ASign: Boolean; APrec: Word): string; overload; // ~ '(APrec)d'
begin
  Result := IntegerToString(AValue, ASign, '%.' + IntToStr(APrec) + 'd');
end;

function TryStringToFloat(const AString: string; out AValue: Extended): Boolean;
var
  LString: string;
  LCode: Integer;
begin
  LString := Trim(AString);
  LString := StringReplace(LString, ',', '.', []);
  Val(LString, AValue, LCode);
  Result := LCode = 0;
end;

function StringToFloat(const AString: string): Extended;
begin
  if not TryStringToFloat(AString, {out} Result) then
    raise EFitsStringException.CreateFmt(SStringToFloat, [AString],
      ERROR_STRING_FLOAT);
end;

function GetFormatSettings: TFormatSettings;
begin
{$IFDEF DCC}
  // http://docwiki.embarcadero.com/RADStudio/Tokyo/en/Legacy_IFEND_(Delphi)
  {$IF CompilerVersion >= 25.0}
    {$DEFINE DELALEGACYIFEND}
    {$LEGACYIFEND ON}
  {$IFEND}
  {$IF CompilerVersion < 22.0}
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, {var} Result);
  {$ELSE}
  Result := TFormatSettings.Create;
  {$IFEND}
  {$IFDEF DELALEGACYIFEND}
    {$LEGACYIFEND OFF}
  {$ENDIF}
{$ENDIF}
{$IFDEF FPC}
  Result := FormatSettings;
{$ENDIF}
end;

function DotFormatSettings: TFormatSettings;
begin
  Result := GetFormatSettings;
  Result.DecimalSeparator := '.';
end;

function FloatToString(const AValue: Extended): string; overload;
begin
  Result := FloatToStr(AValue, DotFormatSettings);
end;

function FloatToString(const AValue: Extended; ASign: Boolean; const AFmt: string): string; overload;
var
  LIndex: Integer;
begin
  Result := Format(AFmt, [AValue], DotFormatSettings);
  Result := Trim(Result);
  // Add a required non-significant fractional part and sign after exponent character
  if AFmt = '%0g' then
  begin
    LIndex := Pos('E', Result);
    if (LIndex > 0) and (LIndex < Length(Result)) and (Result[LIndex + 1] <> '-') then
      Insert('+', Result, LIndex +1);
    if Pos('.', Result) = 0 then
    begin
      if LIndex = 0 then
        LIndex := Length(Result) + 1;
      Insert('.0', Result, LIndex);
    end;
  end;
  // Add a required sign
  if ASign and (AValue >= 0) then
    Result := '+' + Result;
end;

function FloatToString(const AValue: Extended; ASign: Boolean; APrecInt, APrecFloat: Word): string;
var
  LIndex, LWidth: Integer;
  LZero: string;
begin
  Result := FloatToString(AValue, ASign, '%.' + IntToStr(APrecFloat) + 'f');
  // Get the start position of the integer part
  LIndex := 1;
  if (Result[1] = '+') or (Result[1] = '-') then
    Inc(LIndex);
  // Get the length of the integer part
  LWidth := Pos('.', Result);
  if LWidth = 0 then
    LWidth := Length(Result) - LIndex + 1
  else
    LWidth := LWidth - LIndex;
  // Left-pad the integer part with zeros
  if APrecInt > LWidth then
  begin
    LZero := System.StringOfChar('0', APrecInt - LWidth);
    Insert(LZero, Result, LIndex);
  end;
end;

function FortranStringToFloat(const AString: string): Extended;
var
  LString: string;
begin
  LString := StringReplace(AString, 'D', 'E', [rfIgnoreCase]);
  Result := StringToFloat(LString);
end;

function FloatToFortranExponentString(const AValue: Extended; APrecision, ADigits: Integer;
  AExponentChar: Char; const AFormatSettings: TFormatSettings): string;
const
  cBase: Extended = 10.0;
{$IFDEF HAS_EXTENDED_FLOAT}
  cMinPrecision = 1;
  cMaxPrecision = 18;
  cMinExponent = -4932;
  cMaxExponent = +4932;
{$ELSE}
  cMinPrecision = 1;
  cMaxPrecision = 16;
  cMinExponent = -308;
  cMaxExponent = +308;
{$ENDIF}
var
  LMantissa, LPower: Extended;
  LExponent, LPrecision: Integer;
  LMantissaString, LExponentString: string;
begin
  if IsNan(AValue) or (AValue = Infinity) or (AValue = NegInfinity) then
  begin
    Result := FloatToStr(AValue);
    Exit;
  end;
  if AValue = 0.0 then
  begin
    LExponent := 0;
    LMantissa := 0.0;
  end else
  begin
    LExponent := Floor(Log10(Abs(AValue))) + 1;
    if LExponent > cMaxExponent then
      LPower := Infinity
    else if LExponent < cMinExponent then
      LPower := 0.0
    else
      LPower := IntPower(cBase, LExponent);
    if (LPower = Infinity) or (LPower = NegInfinity) then
    begin
      Result := FloatToStr(IfThen(AValue < 0, NegInfinity, Infinity));
      Exit;
    end;
    if LPower = 0.0 then
    begin
      LExponent := 0;
      LMantissa := 0.0;
    end else
    begin
      LMantissa := AValue / LPower;
    end;
  end;
  LPrecision := EnsureRange(APrecision, cMinPrecision, cMaxPrecision);
  LMantissaString := FloatToStrF(LMantissa, ffFixed, LPrecision + 1, LPrecision, AFormatSettings);
  if (LMantissa > 0) and (LMantissaString[1] <> '0') then
  begin
    Delete(LMantissaString, 2, 1);
    LMantissaString := '0.' + Copy(LMantissaString, 1, LPrecision);
    Inc(LExponent);
  end else
  if (LMantissa < 0) and (LMantissaString[2] <> '0') then
  begin
    Delete(LMantissaString, 3, 1);
    LMantissaString := '-0.' + Copy(LMantissaString, 2, LPrecision);
    Inc(LExponent);
  end;
  LExponentString := IntToStr(Abs(LExponent));
  LExponentString := StringOfChar('0', ADigits - Length(LExponentString)) + LExponentString;
  LExponentString := AExponentChar + IfThen(LExponent < 0, '-', '+') + LExponentString;
  // Return
  Result := LMantissaString + LExponentString;
end;

function FloatToFortranGeneralString(const AValue: Extended; APrecision, ADigits: Integer;
  const AFormatSettings: TFormatSettings): string;
var
  LExponentPosition: Integer;
  LExponentString: string;
begin
  if IsNan(AValue) or (AValue = Infinity) or (AValue = NegInfinity) then
  begin
    Result := FloatToStr(AValue);
    Exit;
  end;
  Result := FloatToStrF(AValue, ffGeneral, APrecision, ADigits, AFormatSettings);
  LExponentPosition := Pos('E', Result);
  // Append ".0" to the mantissa
  if Pos('.', Result) = 0 then
  begin
    if LExponentPosition = 0 then
      Result := Result + '.0'
    else
    begin
      Insert('.0', Result, LExponentPosition);
      Inc(LExponentPosition, 2);
    end;
  end;
  // Append "+" and pad the exponent with zeros
  if LExponentPosition > 0 then
  begin
    if (Result[LExponentPosition + 1] <> '-') and (Result[LExponentPosition + 1] <> '+') then
      Insert('+', Result, LExponentPosition + 1);
    LExponentString := Copy(Result, LExponentPosition + 2, Length(Result));
    if Length(LExponentString) < ADigits then
      Result := Copy(Result, 1, LExponentPosition + 1) +
        StringOfChar('0', ADigits - Length(LExponentString)) + LExponentString;
  end;
end;

function VariableToPrintString(const AValue: TVariable): string;
begin
  case AValue.VarType of
    vtBoolean:  Result := BoolToString(AValue.ValueBoolean);
    vtInt64:    Result := Int64ToString(AValue.ValueInt64);
    vtExtended: Result := FloatToString(AValue.ValueExtended);
    vtString:   Result := AValue.ValueString;
  else          Result := '(NONE)';
  end;
end;

{ Splits a string into different parts delimited by the specified delimiter
  characters. The function treats consecutive separators as one, so there
  are no empty elements in the result }

function SplitString(const AString, ADelimiters: string): TAStr;
var
  LIndex, LCount: Integer;
  LFound: Boolean;
  LChar: Char;
begin
  Result := nil;
  LCount := 0;
  LFound := False;
  for LIndex := 1 to Length(AString) do
  begin
    LChar := AString[LIndex];
    if PosChar(LChar, ADelimiters) = 0 then // char is a part value
    begin
      if not LFound then
      begin
        Inc(LCount);
        SetLength(Result, LCount);
      end;
      Result[LCount - 1] := Result[LCount - 1] + LChar;
      LFound := True;
    end else // char is a delimiter
      LFound := False;
  end;
end;

function StringToPreciseDateTimeRec(const AString: string; APart: TPartDateTime; ATip: TFmtShortDate): TPreciseDateTimeRec;

  // Remove time zone designator (letters only)
  function RemoveTZD(const S: string): string;
  var
    LIndex: Integer;
  begin
    LIndex := Length(S);
    while (LIndex > 0) and (AnsiChar(S[LIndex]) in ['A'..'Z', ' ']) do
      Dec(LIndex);
    Result := Copy(S, 1, LIndex);
  end;

  function StrToWord(const S: string): Word;
  begin
    Result := Word(StringToInteger(S));
  end;

  function StrToAttoSec(const S: string): Int64;
  begin
    case Length(S) of
      0:     Result := 0;
      1..18: Result := StringToInt64(S + System.StringOfChar('0', 18 - Length(S)));
    else
      Result := StringToInt64(Copy(S, 1, 18));
      if StringToInt64(S[19]) >= 5 then
        Result := Result + 1;
    end;
  end;

  procedure ExpandYear(var AYear: Word);
  begin
    if AYear < cMinShortYear then
      AYear := 2000 + AYear
    else
      AYear := 1900 + AYear;
  end;

  procedure SwapWord(var V1, V2: Word);
  var
    LTemp: Word;
  begin
    LTemp := V1;
    V1 := V2;
    V2 := LTemp;
  end;

var
  LParts: TAStr; // ['YYYY', 'MM', 'DD', 'HH', 'MM', 'SS', '(sss_sss_sss_sss_sss_sss)']
  LCount: Integer;
  LRate0, LRate2: Word;
begin
  // Init
  Result.Year := 1899;
  Result.Month := 12;
  Result.Day := 30;
  Result.Hour := 0;
  Result.Min := 0;
  Result.Sec := 0;
  Result.AttoSec := 0;
  // Parse the input string
  LParts := SplitString(RemoveTZD(AString), cDelimsDateTime);
  LCount := Length(LParts);
  // 1) Interpret the obvious parts
  if APart = [paDate, paTime] then
  begin
    case LCount of
      6:
        begin
          Result.Month := StrToWord(LParts[1]);
          Result.Hour  := StrToWord(LParts[3]);
          Result.Min   := StrToWord(LParts[4]);
          Result.Sec   := StrToWord(LParts[5]);
        end;
      7:
        begin
          Result.Month   := StrToWord(LParts[1]);
          Result.Hour    := StrToWord(LParts[3]);
          Result.Min     := StrToWord(LParts[4]);
          Result.Sec     := StrToWord(LParts[5]);
          Result.AttoSec := StrToAttoSec(LParts[6]);
        end;
    else
      raise EFitsStringException.CreateFmt(SStringToDateTime,
        [AString], ERROR_STRING_DATETIME);
    end;
  end else
  if APart = [paDate] then
  begin
    case LCount of
      3,6,7: Result.Month := StrToWord(LParts[1]);
    else
      raise EFitsStringException.CreateFmt(SStringToDate,
        [AString], ERROR_STRING_DATETIME);
    end;
  end else
  if APart = [paTime] then
  begin
    case LCount of
      3:
        begin
          Result.Hour := StrToWord(LParts[0]);
          Result.Min  := StrToWord(LParts[1]);
          Result.Sec  := StrToWord(LParts[2]);
        end;
      4:
        begin
          Result.Hour    := StrToWord(LParts[0]);
          Result.Min     := StrToWord(LParts[1]);
          Result.Sec     := StrToWord(LParts[2]);
          Result.AttoSec := StrToAttoSec(LParts[3]);
        end;
      6:
        begin
          Result.Hour := StrToWord(LParts[3]);
          Result.Min  := StrToWord(LParts[4]);
          Result.Sec  := StrToWord(LParts[5]);
        end;
      7:
        begin
          Result.Hour    := StrToWord(LParts[3]);
          Result.Min     := StrToWord(LParts[4]);
          Result.Sec     := StrToWord(LParts[5]);
          Result.AttoSec := StrToAttoSec(LParts[6]);
        end;
    else
      raise EFitsStringException.CreateFmt(SStringToTime,
        [AString], ERROR_STRING_DATETIME);
    end;
  end;
  // 2) Determine the Date: interpret the Year and Day
  if paDate in APart then
  begin
    LRate0 := StrToWord(LParts[0]);
    LRate2 := StrToWord(LParts[2]);
    case Length(LParts[0]) - Length(LParts[2]) of
      +3: { YYYY-MM-D  } ;
      +2: { YYYY-MM-DD } ;
      +1: {   YY-MM-D  } ExpandYear(LRate0);
      00: { uncertainty: YY-MM-DD or DD-MM-YY }
        begin
          if (LRate0 > 31) or (LRate0 = 0) then // (19..|2000)YY-MM-DD
            ExpandYear(LRate0)
          else if (LRate2 > 31) or (LRate2 = 0) then // DD-MM-YY(19..|2000)
          begin
            ExpandYear(LRate2);
            SwapWord(LRate0, LRate2);
          end else
          case ATip of
            yymmdd: ExpandYear(LRate0); // YY-MM-DD ~ Old format FITS
            ddmmyy:
              begin
                ExpandYear(LRate2);
                SwapWord(LRate0, LRate2);
              end;
          end;
        end;
     -1: { D-MM-YY }
       begin
         ExpandYear(LRate2);
         SwapWord(LRate0, LRate2);
       end;
     -2: { DD-MM-YYYY } SwapWord(LRate0, LRate2);
     -3: {  D-MM-YYYY } SwapWord(LRate0, LRate2);
    end;
    Result.Year := LRate0;
    Result.Day := LRate2;
  end;
end;

function PreciseDateTimeRecToString(const AValue: TPreciseDateTimeRec; APart: TPartDateTime; AFracSec: Word): string;

  function IntToString(const AValue: Int64; APrec: Word): string;
  begin
    Result := Format('%.' + IntToStr(APrec) + 'd', [AValue]);
  end;

  function Power10(const APower: Word): Int64;
  var
    I: Integer;
  begin
    Result := 1;
    for I := 1 to APower do
      Result := Result * 10;
  end;

var
  LDateTime: TDateTime;
  LRoundAttoSec: Int64;
  LYear, LMonth, LDay, LHour, LMin, LSec, LMSec: Word;
  LDate, LTime, LAttoSec: string;
begin
  if (AValue.AttoSec < 0) or (AValue.AttoSec > cMaxAttoSec) then
    raise EFitsStringException.CreateFmt(SStringInvalidTimeFracSecond,
      [AValue.AttoSec], ERROR_STRING_DATETIME_FRAC_SECOND);
  if AFracSec > 18 then
    raise EFitsStringException.CreateFmt(SStringInvalidTimePrecSecond,
      [AFracSec], ERROR_STRING_DATETIME_PREC_SECOND);
  LDateTime := EncodeDate(AValue.Year, AValue.Month, AValue.Day) + EncodeTime(AValue.Hour, AValue.Min, AValue.Sec, {MSec} 0);
  LAttoSec := IntToString(AValue.AttoSec, 18);
  // Round
  if (AFracSec < 18) and (StrToInt(LAttoSec[AFracSec + 1]) >= 5) then
  begin
    LRoundAttoSec := StringToInt64((Copy(LAttoSec, 1, AFracSec) + StringOfChar('0', 18 - AFracSec))) + Power10(18 - AFracSec);
    if LRoundAttoSec > cMaxAttoSec then
    begin
      LDateTime := IncSecond(LDateTime);
      LRoundAttoSec := 0;
    end;
    LAttoSec := IntToString(LRoundAttoSec, 18);
  end;
  // [FITS_STANDARD_4.0, SECT_9.1.1]: ISO-8601 datetime strings ... CCYY-MM-DD[Thh:mm:ss[.s...]]
  DecodeDateTime(LDateTime, {out} LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
  LDate := IntToString(LYear, 4) + cFitsDelimDateTime.Date +
           IntToString(LMonth, 2) + cFitsDelimDateTime.Date +
           IntToString(LDay, 2);
  LTime := IntToString(LHour, 2) + cFitsDelimDateTime.Time +
           IntToString(LMin, 2) + cFitsDelimDateTime.Time +
           IntToString(LSec, 2) +
           IfThen(AFracSec > 0, '.' + Copy(LAttoSec, 1, AFracSec), '');
  if APart = [paDate, paTime] then
    Result := LDate + cFitsDelimDateTime.Main + LTime
  else if APart = [paDate] then
    Result := LDate
  else if APart = [paTime] then
    Result := LTime
  else
    Result := '';
end;

function StringToDateTime(const AString: string; APart: TPartDateTime; ATip: TFmtShortDate = yymmdd): TDateTime;
var
  LDateTime: TPreciseDateTimeRec;
  LMsec: Int64;
begin
  LDateTime := StringToPreciseDateTimeRec(AString, APart, ATip);
  Result := EncodeDateTime(LDateTime.Year, LDateTime.Month, LDateTime.Day, LDateTime.Hour, LDateTime.Min, LDateTime.Sec, {MSec} 0);
  LMsec := LDateTime.AttoSec div 1000000000000000;
  if LDateTime.AttoSec mod 1000000000000000 >= 500000000000000 then
    Inc(LMsec);
  Result := IncMilliSecond(Result, LMsec);
end;

function DateTimeToString(const AValue: TDateTime; APart: TPartDateTime; AFracSec: Word): string;
var
  LDateTime: TPreciseDateTimeRec;
  LMSec: Word;
begin
  DecodeDateTime(AValue, {out} LDateTime.Year, LDateTime.Month, LDateTime.Day, LDateTime.Hour, LDateTime.Min, LDateTime.Sec, LMSec);
  LDateTime.AttoSec := LMSec * 1000000000000000;
  Result := PreciseDateTimeRecToString(LDateTime, APart, AFracSec);
end;

function StringToPreciseDateTime(const AString: string; APart: TPartDateTime; ATip: TFmtShortDate = yymmdd): TPreciseDateTime;
var
  LDateTime: TPreciseDateTimeRec;
begin
  LDateTime := StringToPreciseDateTimeRec(AString, APart, ATip);
  Result.DateTime := EncodeDateTime(LDateTime.Year, LDateTime.Month, LDateTime.Day, LDateTime.Hour, LDateTime.Min, LDateTime.Sec, {MSec} 0);
  Result.AttoSec := LDateTime.AttoSec;
  if Result.AttoSec > cMaxAttoSec then
  begin
    Result.DateTime := IncSecond(Result.DateTime);
    Result.AttoSec := 0;
  end;
end;

function PreciseDateTimeToString(const AValue: TPreciseDateTime; APart: TPartDateTime; AFracSec: Word): string;
var
  LDateTime: TPreciseDateTimeRec;
  LMSec: Word;
begin
  DecodeDateTime(AValue.DateTime, {out} LDateTime.Year, LDateTime.Month, LDateTime.Day, LDateTime.Hour, LDateTime.Min, LDateTime.Sec, LMSec);
  LDateTime.AttoSec := AValue.AttoSec;
  Result := PreciseDateTimeRecToString(LDateTime, APart, AFracSec);
end;

function FloatToCoord(const AValue: Extended): TCoord;
var
  LValue: Extended;
  LString: string;
begin
  if AValue < 0 then
    Result.Sign := sMinus
  else
    Result.Sign := sPlus;
  LValue := Abs(AValue);
  Result.GG := Trunc(LValue);
  LValue := (LValue - Result.GG) * 60;
  Result.MM := Trunc(LValue);
  LValue := (LValue - Result.MM) * 60;
  // SS := Value; -> accuracy is lost...
  LString := FloatToString(LValue, False, '%g');
  Result.SS := StringToFloat(LString);
end;

function CoordToFloat(const AValue: TCoord): Extended;
begin
  // Result := AValue.GG + AValue.MM / 60 + AValue.SS / 3600;
  Result := (AValue.GG * 3600 + AValue.MM * 60 + AValue.SS) / 3600;
  if AValue.Sign = sMinus then
    Result := -Result;
end;

function CoordToString(const AValue: TCoord; ASign: Boolean; APrecGG, AMaxGG, AOverflowGG: Word; APrecSS: Word): string;
var
  LValue: TCoord;
  LSecond: string;
begin
  LValue := AValue;
  // Rounding effect
  LSecond := FloatToString(LValue.SS, {ASign:} False, {APrecInt:} 2, APrecSS);
  if Pos('60', LSecond) = 1 then
  begin
    LValue.SS := 0.0;
    Inc(LValue.MM);
    if LValue.MM = 60 then
    begin
      LValue.MM := 0;
      Inc(LValue.GG);
      if LValue.GG >= AMaxGG then
        LValue.GG := AOverflowGG;
    end;
  end;
  // Return
  Result := IntegerToString(LValue.GG, {ASign:} False, APrecGG) + cFitsDelimCoord +
            IntegerToString(LValue.MM, {ASign:} False, {APrecInt:} 2) + cFitsDelimCoord +
            FloatToString(LValue.SS, {ASign:} False, {APrecInt:} 2, APrecSS);
  if LValue.Sign = sMinus then
    Result := '-' + Result
  else if ASign then
    Result := '+' + Result;
end;

function StringToCoord(const AString: string): TCoord;
var
  LParts: TAStr; // ['GG', 'MM', 'SS.sss']
  LGrade, LMinute: Int64;
  LSecond: Extended;
begin
  // Parse the input string
  LParts := SplitString(AString, cDelimsCoord);
  if Length(LParts) <> 3 then
    raise EFitsStringException.CreateFmt(SStringToCoordinate,
      [AString], ERROR_STRING_COORDINATE_LENGTH);
  LGrade := StringToInt64(LParts[0]);
  LMinute := StringToInt64(LParts[1]);
  LSecond := StringToFloat(LParts[2]);
  if (LGrade < -180) or (LGrade >= 360) or
    (LMinute < 0) or (LMinute >= 60) or
    (LSecond < 0) or (LSecond >= 60) then
    raise EFitsStringException.CreateFmt(SStringToCoordinate,
      [AString], ERROR_STRING_COORDINATE_VALUE);
  // Return
  if LParts[0][1] = '-' then
    Result.Sign := sMinus
  else
    Result.Sign := sPlus;
  Result.GG := Word(Abs(LGrade));
  Result.MM := Word(LMinute);
  Result.SS := LSecond;
end;

function ExtractFmtRepCoord(const AString: string): TFmtRepCoord;
var
  LIndex: Integer;
  LString: string;
begin
  Result := coDecimal;
  LString := Trim(AString);
  for LIndex := 1 to Length(cDelimsCoord) do
    if PosChar(cDelimsCoord[LIndex], LString) > 0 then
    begin
      Result := coMixed;
      Break;
    end;
end;

procedure CheckRa(const ARa: Extended);
begin
  if (ARa < 0.0) or (ARa >= 360.0) then
    raise EFitsStringException.CreateFmt(SStringInvalidRa,
      [ARa], ERROR_STRING_RA);
end;

function StringToRa(const AString: string; ATip: TFmtMeaCoord = coHour): Extended;
var
  LCoord: TCoord;
begin
  case ExtractFmtRepCoord(AString) of
    coDecimal:
      Result := StringToFloat(AString);
    coMixed:
      begin
        LCoord := StringToCoord(AString);
        Result := CoordToFloat(LCoord);
      end;
  else
    Result := cCoordNull; // dummy
  end;
  if (Result < 24.0) and (ATip = coHour) then
    Result := Result * 15;
  CheckRa(Result);
end;

function RaToString(const AValue: Extended; APrec: Word; ARep: TFmtRepCoord; AMea: TFmtMeaCoord): string;
var
  LValue: Extended;
  LPrecInt, LPrecFloat: Word;
  LMax, LOverflow: Integer;
  LCoord: TCoord;
begin
  CheckRa(AValue);
  // Set options
  if AMea = coDegree then
  begin
    LValue := AValue;
    LPrecInt := 3;
    LMax := 360;
  end else { if AMea = coHour then }
  begin
    LValue := AValue / 15;
    LPrecInt := 2;
    LMax := 24;
  end;
  LOverflow := 0;
  // Set the precision of the fractional part (or seconds)
  LPrecFloat := APrec;
  if AMea = coHour then
    if LPrecFloat > 0 then
      Inc(LPrecFloat);
  if ARep = coMixed then
    if LPrecFloat > 3 then
      Dec(LPrecFloat, 3)
    else
      LPrecFloat := 0;
  // Return
  case ARep of
    coDecimal:
      begin
        Result := FloatToString(LValue, {ASign:} False, LPrecInt, LPrecFloat);
        if Pos(IntToStr(LMax), Result) = 1 then
          Result := FloatToString(LOverflow, {ASign:} False, LPrecInt, LPrecFloat);
      end;
    coMixed:
      begin
        LCoord := FloatToCoord(LValue);
        Result := CoordToString(LCoord, {ASign:} False, LPrecInt, LMax, LOverflow, LPrecFloat);
      end;
  else
    Result := ''; // dummy
  end;
end;

procedure CheckDe(const ADe: Extended);
begin
  if (ADe < -90) or (ADe > 90) then
    raise EFitsStringException.CreateFmt(SStringInvalidDe,
      [ADe], ERROR_STRING_DE);
end;

function StringToDe(const AString: string): Extended;
var
  LCoord: TCoord;
begin
  case ExtractFmtRepCoord(AString) of
    coDecimal:
      Result := StringToFloat(AString);
    coMixed:
      begin
        LCoord := StringToCoord(AString);
        Result := CoordToFloat(LCoord);
      end;
  else
    Result := cCoordNull; // dummy
  end;
  CheckDe(Result);
end;

function DeToString(const AValue: Extended; APrec: Word; ARep: TFmtRepCoord): string;
var
  LCoord: TCoord;
  LPrecFloat: Word;
begin
  CheckDe(AValue);
  // Set the precision of the fractional part (or seconds)
  LPrecFloat := APrec;
  if ARep = coMixed then
    if LPrecFloat > 3 then
      Dec(LPrecFloat, 3)
    else
      LPrecFloat := 0;
  // Return
  case ARep of
    coDecimal:
      Result := FloatToString(AValue, {ASign:} True, {APrecInt:} 2, LPrecFloat);
    coMixed:
      begin
        LCoord := FloatToCoord(AValue);
        Result := CoordToString(LCoord, {ASign:} True, {APrecGG:} 2, {AMaxGG:} 90, {AOverflowGG:} 90, LPrecFloat);
      end;
  else
    Result := ''; // dummy
  end;
end;

end.
