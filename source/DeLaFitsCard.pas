{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{         Structured sequence of header lines:         }
{            Card = (Keyword, Value, Note)             }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsCard;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Math, DeLaFitsCommon, DeLaFitsMath, DeLaFitsString;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_CARD                  = 5000;

  ERROR_CARD_TYPICAL_SIZE     = 5100;
  ERROR_CARD_MULTI_SIZE       = 5101;
  ERROR_CARD_KEYWORD_CONTINUE = 5102;
  ERROR_CARD_KEYWORD_GROUP    = 5103;
  ERROR_CARD_VALUE_INDICATE   = 5104;
  ERROR_CARD_VALUE_QUOTE      = 5105;
  ERROR_CARD_VALUE_AMPERSAND  = 5106;
  ERROR_CARD_VALUE_SIZE       = 5107;

resourcestring

  { The messages of exceptions }

  SCardInvalidTypicalSize      = '"%d" is an invalid card size. Card size should be 80 characters';
  SCardInvalidMultiSize        = '"%d" is an invalid card size. Card size must be a multiple of 80 characters';
  SCardInvalidTypicalValueSize = '"%d" is an invalid value size of the card. The maximum value size for a typical card is 70 characters';
  SCardInvalidContent          = '"%s" is an invalid card content';

type

  { Exception classes }

  EFitsCardException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  { TFitsCard [abstract]: base card class }

  TFitsCard = class(TFitsObject)
  protected
    FCard: string;
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure CheckCard(const ACard: string); virtual; abstract;
    procedure SetCard(const ACard: string); virtual;
    function GetKeyword: string; virtual;
    procedure SetKeyword(const AKeyword: string); virtual;
    function GetValue: string; virtual; abstract;
    procedure SetValue(const AValue: string); virtual; abstract;
  public
    constructor Create; virtual;
    procedure DefaultFormat; virtual;
    procedure Erase; virtual;
    property Card: string read FCard write SetCard;
    property Keyword: string read GetKeyword write SetKeyword;
    property Value: string read GetValue write SetValue;
  end;

  TFitsCardClass = class of TFitsCard;

  { TFitsTypicalCard: single-line card as "KEYWORD=VALUE/NOTE" }

  TFitsTypicalCard = class(TFitsCard)
  protected
    procedure CheckCard(const ACard: string); override;
    procedure SetKeyword(const AKeyword: string); override;
    function GetValue: string; override;
    procedure SetValue(const AValue: string); override;
    function GetNote: string; virtual;
    procedure SetNote(const ANote: string); virtual;
  public
    procedure Decode(out AKeyword, AValue, ANote: string); virtual;
    procedure Encode(const AKeyword, AValue, ANote: string); virtual;
    property Note: string read GetNote write SetNote;
  end;

  { TFitsTypicalSimpleCard: formatted single-line card with a
    simple type value, such as boolean, integer, float etc. }

  TFitsTypicalSimpleCard = class(TFitsTypicalCard)
  protected
    FFmtWidth: ShortInt; // default = +cWidthLineValue ~ < value>
  public
    procedure Encode(const AKeyword, AValue, ANote: string); override;
    procedure DefaultFormat; override;
    property FmtWidth: ShortInt read FFmtWidth write FFmtWidth;
  end;

  { TFitsBitPixCard: bits per data value }

  TFitsBitPixCard = class(TFitsTypicalSimpleCard)
  protected
    function GetValueAsBitPix: TBitPix; virtual;
    procedure SetValueAsBitPix(const AValue: TBitPix); virtual;
  public
    property ValueAsBitPix: TBitPix read GetValueAsBitPix write SetValueAsBitPix;
  end;

  { TFitsBooleanCard: logical value }

  TFitsBooleanCard = class(TFitsTypicalSimpleCard)
  protected
    function GetValueAsBoolean: Boolean; virtual;
    procedure SetValueAsBoolean(const AValue: Boolean); virtual;
  public
    property ValueAsBoolean: Boolean read GetValueAsBoolean write SetValueAsBoolean;
  end;

  { TFitsIntegerCard: integer number }

  TFitsIntegerCard = class(TFitsTypicalSimpleCard)
  protected
    FFmtSign: Boolean; // default = False
    FFmtSpec: string;  // default = '%d'; see Format function
    function GetValueAsInt64: Int64; virtual;
    procedure SetValueAsInt64(const AValue: Int64); virtual;
    function GetValueAsInteger: Integer; virtual;
    procedure SetValueAsInteger(const AValue: Integer); virtual;
    function GetValueAsSmallInt: SmallInt; virtual;
    procedure SetValueAsSmallInt(const AValue: SmallInt); virtual;
  public
    procedure DefaultFormat; override;
    property FmtSign: Boolean read FFmtSign write FFmtSign;
    property FmtSpec: string read FFmtSpec write FFmtSpec;
    property ValueAsInt64: Int64 read GetValueAsInt64 write SetValueAsInt64;
    property ValueAsInteger: Integer read GetValueAsInteger write SetValueAsInteger;
    property ValueAsSmallInt: SmallInt read GetValueAsSmallInt write SetValueAsSmallInt;
  end;

  { TFitsFloatCard: floating point number }

  TFitsFloatCard = class(TFitsTypicalSimpleCard)
  protected
    FFmtSign: Boolean; // default = False
    FFmtSpec: string;  // default = '%0g'; see Format function
    function GetValueAsExtended: Extended; virtual;
    procedure SetValueAsExtended(const AValue: Extended); virtual;
    function GetValueAsDouble: Double; virtual;
    procedure SetValueAsDouble(const AValue: Double); virtual;
    function GetValueAsSingle: Single; virtual;
    procedure SetValueAsSingle(const AValue: Single); virtual;
  public
    procedure DefaultFormat; override;
    property FmtSign: Boolean read FFmtSign write FFmtSign;
    property FmtSpec: string read FFmtSpec write FFmtSpec;
    property ValueAsExtended: Extended read GetValueAsExtended write SetValueAsExtended;
    property ValueAsDouble: Double read GetValueAsDouble write SetValueAsDouble;
    property ValueAsSingle: Single read GetValueAsSingle write SetValueAsSingle;
  end;

  { TFitsEquatorialCoordinateCard [abstract]: coordinate of II equatorial coordinate system }

  TFitsEquatorialCoordinateCard = class(TFitsTypicalCard)
  protected
    FFmtWidthDecimal: ShortInt; // default = +cWidthLineValue ~ < value>
    FFmtWidthMixed: ShortInt;   // default = -cWidthLineValue ~ <value >
    FFmtWidthQuote: ShortInt;   // default = -cWidthLineValueQuote ~ 'value '
    FFmtPrec: Word;             // default = 4 ~ 0.1", ie RA=hh:mm:ss.ss and DE=dd:mm:ss.s; in [degree]; '%.(FFmtPrec)f'
    FFmtRepCoord: TFmtRepCoord; // default = coMixed
    function GetValueAsExtended: Extended; virtual; abstract;
    procedure SetValueAsExtended(const AValue: Extended); virtual; abstract;
    function GetValueAsDouble: Double; virtual;
    procedure SetValueAsDouble(const AValue: Double); virtual;
    function GetValueAsSingle: Single; virtual;
    procedure SetValueAsSingle(const AValue: Single); virtual;
  public
    procedure Decode(out AKeyword, AValue, ANote: string); override;
    procedure Encode(const AKeyword, AValue, ANote: string); override;
    procedure DefaultFormat; override;
    property FmtWidthDecimal: ShortInt read FFmtWidthDecimal write FFmtWidthDecimal;
    property FmtWidthMixed: ShortInt read FFmtWidthMixed write FFmtWidthMixed;
    property FmtWidthQuote: ShortInt read FFmtWidthQuote write FFmtWidthQuote;
    property FmtPrec: Word read FFmtPrec write FFmtPrec;
    property FmtRepCoord: TFmtRepCoord read FFmtRepCoord write FFmtRepCoord;
    property ValueAsExtended: Extended read GetValueAsExtended write SetValueAsExtended;
    property ValueAsDouble: Double read GetValueAsDouble write SetValueAsDouble;
    property ValueAsSingle: Single read GetValueAsSingle write SetValueAsSingle;
  end;

  { TFitsRightAscensionCard: right ascension of II equatorial coordinate system }

  TFitsRightAscensionCard = class(TFitsEquatorialCoordinateCard)
  protected
    function GetValueAsExtended: Extended; override;
    procedure SetValueAsExtended(const AValue: Extended); override;
  end;

  { TFitsDeclinationCard: declination of II equatorial coordinate system }

  TFitsDeclinationCard = class(TFitsEquatorialCoordinateCard)
  protected
    function GetValueAsExtended: Extended; override;
    procedure SetValueAsExtended(const AValue: Extended); override;
  end;

  { TFitsTypicalQuotedCard: formatted single-line card with a custom
    type value in quotes, such as coordinate, date and time etc. }

  TFitsTypicalQuotedCard = class(TFitsTypicalCard)
  protected
    FFmtWidth: ShortInt;      // default = -cWidthLineValue ~ <value >
    FFmtWidthQuote: ShortInt; // default = -cWidthLineValueQuote ~ 'value '
    procedure CheckCard(const ACard: string); override;
  public
    procedure Decode(out AKeyword, AValue, ANote: string); override;
    procedure Encode(const AKeyword, AValue, ANote: string); override;
    procedure DefaultFormat; override;
    property FmtWidth: ShortInt read FFmtWidth write FFmtWidth;
    property FmtWidthQuote: ShortInt read FFmtWidthQuote write FFmtWidthQuote;
  end;

  { TFitsDateTimeCard: date and time }

  TFitsDateTimeCard = class(TFitsTypicalQuotedCard)
  private
    function ExtractPartDateTime(APropIndex: Integer): TPartDateTime;
  protected
    FFmtFracSec: Word;            // default = 9 ~ hh:mm:ss.sssssssss, ie nano-second; in [fraction of a second]; maximum 3 for TDateTime and 18 for TPreciseDateTime
    FFmtShortDate: TFmtShortDate; // default = yymmdd; used as a prompt when reading short date format
    function GetValueAsDateTime(APropIndex: Integer): TDateTime; virtual;
    procedure SetValueAsDateTime(APropIndex: Integer; const AValue: TDateTime); virtual;
    function GetValueAsPreciseDateTime(APropIndex: Integer): TPreciseDateTime; virtual;
    procedure SetValueAsPreciseDateTime(APropIndex: Integer; const AValue: TPreciseDateTime); virtual;
  public
    procedure DefaultFormat; override;
    property FmtFracSec: Word read FFmtFracSec write FFmtFracSec;
    property FmtShortDate: TFmtShortDate read FFmtShortDate write FFmtShortDate;
    property ValueAsDateTime: TDateTime Index 1 read GetValueAsDateTime write SetValueAsDateTime;
    property ValueAsDate: TDateTime Index 2 read GetValueAsDateTime write SetValueAsDateTime;
    property ValueAsTime: TDateTime Index 3 read GetValueAsDateTime write SetValueAsDateTime;
    property ValueAsPreciseDateTime: TPreciseDateTime Index 1 read GetValueAsPreciseDateTime write SetValueAsPreciseDateTime;
    property ValueAsPreciseDate: TPreciseDateTime Index 2 read GetValueAsPreciseDateTime write SetValueAsPreciseDateTime;
    property ValueAsPreciseTime: TPreciseDateTime Index 3 read GetValueAsPreciseDateTime write SetValueAsPreciseDateTime;
  end;

  { TFitsStringCard: multi-line card as a continued string }

  TFitsStringCard = class(TFitsCard)
  protected
    FFmtWidth: ShortInt;      // default = -cWidthLineValue ~ <value >
    FFmtWidthQuote: ShortInt; // default = -cWidthLineValueQuote ~ 'value '
    procedure CheckCard(const ACard: string); override;
    procedure SetKeyword(const AKeyword: string); override;
    function GetValue: string; override;
    procedure SetValue(const AValue: string); override;
    function GetNote: string; virtual;
    procedure SetNote(const ANote: string); virtual;
  public
    procedure Decode(out AKeyword, AValue, ANote: string); virtual;
    procedure Encode(const AKeyword, AValue, ANote: string); virtual;
    procedure DefaultFormat; override;
    property FmtWidth: ShortInt read FFmtWidth write FFmtWidth;
    property FmtWidthQuote: ShortInt read FFmtWidthQuote write FFmtWidthQuote;
    // property ValueAsString: string read GetValue write SetValue; ie property "Value"
    property Note: string read GetNote write SetNote;
  end;

  { TFitsGroupCard: multi-line card as grouping strings "KEYWORD VALUE",
    such as comment, history, blank etc. }

  TValueGroup = TAstr;

  TFitsGroupCard = class(TFitsCard)
  private
    function GetPrefix: string; overload;
    function GetPrefix(const AKeyword: string): string; overload;
    function FixValue(const AValue: string): string;
  protected
    procedure CheckCard(const ACard: string); override;
    procedure SetKeyword(const AKeyword: string); override;
    function GetValue: string; override;
    procedure SetValue(const AValue: string); override;
    function GetValueAsGroup: TValueGroup; virtual;
    procedure SetValueAsGroup(const AValue: TValueGroup); virtual;
  public
    procedure Decode(out AKeyword, AValue: string); virtual;
    procedure Encode(const AKeyword, AValue: string); virtual;
    property ValueAsGroup: TValueGroup read GetValueAsGroup write SetValueAsGroup;
  end;

implementation

{ EFitsCardException }

function EFitsCardException.GetTopic: string;
begin
  Result := 'CARD';
end;

{ Card }

function BlankCard: string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := BlankString(cSizeLine);
end;

function IsBlankCard(const ACard: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ACard = BlankString(cSizeLine);
end;

function TrimValue(const AValue: string; AWidth: Integer): string;
var
  LLack, LLoan, LIndex, LBlank: Integer;
begin
  Assert(AWidth >= 0, SAssertionFailure);
  Result := AValue;
  LLack := Length(Result) - AWidth;
  // Try removing the white spaces on the left
  if LLack > 0 then
  begin
    LBlank := 0;
    for LIndex := 1 to Length(Result) do
      if Result[LIndex] = cChrBlank then
        Inc(LBlank)
      else
        Break;
    LLoan := Min(LBlank, LLack);
    if LLoan > 0 then
    begin
      Result := Copy(Result, LLoan + 1, Length(Result));
      Dec(LLack, LLoan);
    end;
  end;
  // Try removing the white spaces on the right
  if LLack > 0 then
  begin
    LBlank := 0;
    for LIndex := Length(Result) downto 1 do
      if Result[LIndex] = cChrBlank then
        Inc(LBlank)
      else
        Break;
    LLoan := Min(LBlank, LLack);
    if LLoan > 0 then
    begin
      Result := Copy(Result, 1, Length(Result) - LLoan);
      Dec(LLack, LLoan);
    end;
  end;
  // Try removing the white spaces on the left inside the quotes
  if (LLack > 0) and IsQuotedString(Result) then
  begin
    LBlank := 0;
    for LIndex := 2 to Length(Result) - 1 do
      if Result[LIndex] = cChrBlank then
        Inc(LBlank)
      else
        Break;
    LLoan := Min(LBlank, LLack);
    if LLoan > 0 then
    begin
      Result := Copy(Result, 1, 1) + Copy(Result, LLoan + 2, Length(Result));
      Dec(LLack, LLoan);
    end;
  end;
  // Try removing the white spaces on the right inside the quotes
  if (LLack > 0) and IsQuotedString(Result) then
  begin
    LBlank := 0;
    for LIndex := Length(Result) - 1 downto 2 do
      if Result[LIndex] = cChrBlank then
        Inc(LBlank)
      else
        Break;
    LLoan := Min(LBlank, LLack);
    if LLoan > 0 then
    begin
      Result := Copy(Result, 1, Length(Result) - LLoan - 1) + Copy(Result, Length(Result), 1);
      // Dec(LLack, LLoan);
    end;
  end;
end;

{ TFitsCard }

function TFitsCard.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsCardException;
end;

procedure TFitsCard.SetCard(const ACard: string);
begin
  if not IsBlankCard(ACard) then
    CheckCard(ACard);
  FCard := ACard;
end;

function TFitsCard.GetKeyword: string;
begin
  Result := Trim(Copy(FCard, 1, cSizeKeyword));
end;

procedure TFitsCard.SetKeyword(const AKeyword: string);
begin
  FCard := UpperCase(EnsureString(AKeyword, -cSizeKeyword)) +
           Copy(FCard, cSizeKeyword + 1, Length(FCard));
end;

constructor TFitsCard.Create;
begin
  inherited Create;
  DefaultFormat;
  Erase;
end;

procedure TFitsCard.DefaultFormat;
begin
  // Do nothing
end;

procedure TFitsCard.Erase;
begin
  FCard := BlankCard;
end;

{ TFitsTypicalCard }

procedure TFitsTypicalCard.CheckCard(const ACard: string);
var
  LWidth: Integer;
begin
  LWidth := Length(ACard);
  if LWidth <> cSizeLine then
    Error(SCardInvalidTypicalSize, [LWidth], ERROR_CARD_TYPICAL_SIZE);
  if not LineToRecord(ACard).ValueIndicate then
    Error(SCardInvalidContent, [ACard], ERROR_CARD_VALUE_INDICATE);
end;

procedure TFitsTypicalCard.SetKeyword(const AKeyword: string);
begin
  inherited;
  FCard := Copy(FCard, 1, cSizeKeyword) + cChrValueIndicator +
           Copy(FCard, cSizeKeyword + 2, Length(FCard));
end;

function TFitsTypicalCard.GetValue: string;
var
  LKeyword, LValue, LNote: string;
begin
  Decode({out} LKeyword, {out} LValue, {out} LNote);
  Result := LValue;
end;

procedure TFitsTypicalCard.SetValue(const AValue: string);
var
  LKeyword, LValue, LNote: string;
begin
  Decode({out} LKeyword, {out} LValue, {out} LNote);
  Encode(LKeyword, AValue, LNote);
end;

function TFitsTypicalCard.GetNote: string;
var
  LKeyword, LValue, LNote: string;
begin
  Decode({out} LKeyword, {out} LValue, {out} LNote);
  Result := LNote;
end;

procedure TFitsTypicalCard.SetNote(const ANote: string);
var
  LKeyword, LValue, LNote: string;
begin
  Decode({out} LKeyword, {out} LValue, {out} LNote);
  Encode(LKeyword, LValue, ANote);
end;

procedure TFitsTypicalCard.Decode(out AKeyword, AValue, ANote: string);
var
  LRecord: TLineRecord;
begin
  LRecord := LineToRecord(FCard);
  AKeyword := LRecord.Keyword;
  AValue := Trim(LRecord.Value);
  ANote := Trim(LRecord.Note);
end;

procedure TFitsTypicalCard.Encode(const AKeyword, AValue, ANote: string);
var
  LValue, LNote: string;
  LWidth, LVolume: Integer;
  LRecord: TLineRecord;
begin
  LNote := Trim(ANote);
  // Unnecessary white spaces in the value can be removed
  LVolume := cSizeLine - (cSizeKeyword + 2);
  LWidth := Max(0, LVolume - IfThen(LNote = '', 0, 3 + Length(LNote)));
  LValue := TrimValue(AValue, LWidth);
  LWidth := Length(LValue);
  if LWidth > LVolume then
    Error(SCardInvalidTypicalValueSize, [LWidth], ERROR_CARD_VALUE_SIZE);
  // Reject the note if there is not enough space for it
  LVolume := cSizeLine - (cSizeKeyword + 2 + LWidth + 3);
  if LVolume <= 0 then
    LNote := '';
  // Compose
  LRecord.Keyword := AKeyword;
  LRecord.ValueIndicate := True;
  LRecord.Value := LValue;
  LRecord.NoteIndicate := LNote <> '';
  LRecord.Note := LNote;
  FCard := RecordToLine(LRecord);
end;

{ TFitsTypicalSimpleCard }

procedure TFitsTypicalSimpleCard.Encode(const AKeyword, AValue, ANote: string);
var
  LValue: string;
begin
  LValue := PadString(Trim(AValue), FFmtWidth);
  inherited Encode(AKeyword, LValue, ANote);
end;

procedure TFitsTypicalSimpleCard.DefaultFormat;
begin
  inherited;
  FFmtWidth := cWidthLineValue;
end;

{ TFitsBitPixCard }

function TFitsBitPixCard.GetValueAsBitPix: TBitPix;
var
  LValue: string;
begin
  LValue := Value;
  if LValue = '' then
    Result := biUnknown
  else
    Result := IntToBitPix(StringToInteger(LValue));
end;

procedure TFitsBitPixCard.SetValueAsBitPix(const AValue: TBitPix);
begin
  if AValue = biUnknown then
    Value := ''
  else
    Value := BitPixToString(AValue);
end;

{ TFitsBooleanCard }

function TFitsBooleanCard.GetValueAsBoolean: Boolean;
var
  LValue: string;
begin
  LValue := Value;
  if LValue = '' then
    Result := False
  else
    Result := StringToBool(LValue);
end;

procedure TFitsBooleanCard.SetValueAsBoolean(const AValue: Boolean);
begin
  Value := BoolToString(AValue);
end;

{ TFitsIntegerCard }

function TFitsIntegerCard.GetValueAsInt64: Int64;
var
  LValue: string;
begin
  LValue := Value;
  if LValue = '' then
    Result := 0
  else
    Result := StringToInt64(LValue);
end;

procedure TFitsIntegerCard.SetValueAsInt64(const AValue: Int64);
begin
  Value := Int64ToString(AValue, FFmtSign, FFmtSpec);
end;

function TFitsIntegerCard.GetValueAsInteger: Integer;
begin
  Result := Ensure32c(ValueAsInt64);
end;

procedure TFitsIntegerCard.SetValueAsInteger(const AValue: Integer);
begin
  ValueAsInt64 := AValue;
end;

function TFitsIntegerCard.GetValueAsSmallInt: SmallInt;
begin
  Result := Ensure16c(ValueAsInt64);
end;

procedure TFitsIntegerCard.SetValueAsSmallInt(const AValue: SmallInt);
begin
  ValueAsInt64 := AValue;
end;

procedure TFitsIntegerCard.DefaultFormat;
begin
  inherited;
  FFmtSign := False;
  FFmtSpec := '%d';
end;

{ TFitsFloatCard }

function TFitsFloatCard.GetValueAsExtended: Extended;
var
  LValue: string;
begin
  LValue := Value;
  if LValue = '' then
    Result := NaN
  else
    Result := StringToFloat(LValue);
end;

procedure TFitsFloatCard.SetValueAsExtended(const AValue: Extended);
begin
  if IsNan(AValue) then
    Value := ''
  else
    Value := FloatToString(AValue, FFmtSign, FFmtSpec);
end;

function TFitsFloatCard.GetValueAsDouble: Double;
begin
  Result := Ensure64f(ValueAsExtended);
end;

procedure TFitsFloatCard.SetValueAsDouble(const AValue: Double);
begin
  ValueAsExtended := AValue;
end;

function TFitsFloatCard.GetValueAsSingle: Single;
begin
  Result := Ensure32f(ValueAsExtended);
end;

procedure TFitsFloatCard.SetValueAsSingle(const AValue: Single);
begin
  ValueAsExtended := AValue;
end;

procedure TFitsFloatCard.DefaultFormat;
begin
  inherited;
  FFmtSign := False;
  FFmtSpec := '%0g';
end;

{ TFitsEquatorialCoordinateCard }

function TFitsEquatorialCoordinateCard.GetValueAsDouble: Double;
begin
  Result := Ensure64f(ValueAsExtended);
end;

procedure TFitsEquatorialCoordinateCard.SetValueAsDouble(const AValue: Double);
begin
  ValueAsExtended := AValue;
end;

function TFitsEquatorialCoordinateCard.GetValueAsSingle: Single;
begin
  Result := Ensure32f(ValueAsExtended);
end;

procedure TFitsEquatorialCoordinateCard.SetValueAsSingle(const AValue: Single);
begin
  ValueAsExtended := AValue;
end;

procedure TFitsEquatorialCoordinateCard.Decode(out AKeyword, AValue, ANote: string);
begin
  inherited Decode({out} AKeyword, {out} AValue, {out} ANote);
  AValue := UnquotedString(AValue);
end;

procedure TFitsEquatorialCoordinateCard.Encode(const AKeyword, AValue, ANote: string);
var
  LValue: string;
begin
  LValue := Trim(AValue);
  case FFmtRepCoord of
    coDecimal: LValue := PadString(LValue, FFmtWidthDecimal);
    coMixed:   LValue := PadString(QuotedString(LValue, IfThen(LValue = '', 0, FFmtWidthQuote)), FFmtWidthMixed);
  end;
  inherited Encode(AKeyword, LValue, ANote);
end;

procedure TFitsEquatorialCoordinateCard.DefaultFormat;
begin
  inherited;
  FFmtWidthDecimal := cWidthLineValue;
  FFmtWidthMixed := -cWidthLineValue;
  FFmtWidthQuote := -cWidthLineValueQuote;
  FFmtPrec := 4;
  FFmtRepCoord := coMixed;
end;

{ TFitsRightAscensionCard }

function TFitsRightAscensionCard.GetValueAsExtended: Extended;
var
  LValue: string;
begin
  Result := NaN;
  LValue := Value;
  if LValue <> '' then
    case ExtractFmtRepCoord(LValue) of
      coDecimal: Result := StringToRa(LValue, coDegree);
      coMixed  : Result := StringToRa(LValue,   coHour);
    end;
end;

procedure TFitsRightAscensionCard.SetValueAsExtended(const AValue: Extended);
begin
  if IsNan(AValue) then
    Value := ''
  else
    case FFmtRepCoord of
      coDecimal: Value := RaToString(AValue, FFmtPrec, coDecimal, coDegree);
      coMixed:   Value := RaToString(AValue, FFmtPrec,   coMixed,   coHour);
    end;
end;

{ TFitsDeclinationCard }

function TFitsDeclinationCard.GetValueAsExtended: Extended;
var
  LValue: string;
begin
  LValue := Value;
  if LValue = '' then
    Result := NaN
  else
    Result := StringToDe(LValue);
end;

procedure TFitsDeclinationCard.SetValueAsExtended(const AValue: Extended);
begin
  if IsNan(AValue) then
    Value := ''
  else
    Value := DeToString(AValue, FFmtPrec, FFmtRepCoord);
end;

{ TFitsTypicalQuotedCard }

procedure TFitsTypicalQuotedCard.CheckCard(const ACard: string);
var
  LValue: string;
begin
  inherited;
  LValue := LineToRecord(ACard).Value;
  if not (IsBlankString(LValue) or IsQuotedString(LValue)) then
    Error(SCardInvalidContent, [ACard], ERROR_CARD_VALUE_QUOTE);
end;

procedure TFitsTypicalQuotedCard.Decode(out AKeyword, AValue, ANote: string);
begin
  inherited Decode({out} AKeyword, {out} AValue, {out} ANote);
  AValue := UnquotedString(AValue);
end;

procedure TFitsTypicalQuotedCard.Encode(const AKeyword, AValue, ANote: string);
var
  LValue: string;
begin
  LValue := PadString(QuotedString(Trim(AValue), FFmtWidthQuote), FFmtWidth);
  inherited Encode(AKeyword, LValue, ANote);
end;

procedure TFitsTypicalQuotedCard.DefaultFormat;
begin
  inherited;
  FFmtWidth := -cWidthLineValue;
  FFmtWidthQuote := -cWidthLineValueQuote;
end;

{ TFitsDateTimeCard }

function TFitsDateTimeCard.ExtractPartDateTime(APropIndex: Integer): TPartDateTime;
begin
  case APropIndex of
    1: Result := [paDate, paTime];
    2: Result := [paDate];
    3: Result := [paTime];
  else
    Result := [];
  end;
end;

function TFitsDateTimeCard.GetValueAsDateTime(APropIndex: Integer): TDateTime;
var
  LValue: string;
begin
  LValue := Value;
  if LValue = '' then
    Result := 0.0
  else
    Result := StringToDateTime(LValue, ExtractPartDateTime(APropIndex), FFmtShortDate);
end;

procedure TFitsDateTimeCard.SetValueAsDateTime(APropIndex: Integer; const AValue: TDateTime);
begin
  Value := DateTimeToString(AValue, ExtractPartDateTime(APropIndex), Min(FFmtFracSec, 3));
end;

function TFitsDateTimeCard.GetValueAsPreciseDateTime(APropIndex: Integer): TPreciseDateTime;
var
  LValue: string;
begin
  LValue := Value;
  if LValue = '' then
  begin
    Result.DateTime := 0.0;
    Result.AttoSec := 0;
  end else
    Result := StringToPreciseDateTime(LValue, ExtractPartDateTime(APropIndex), FFmtShortDate);
end;

procedure TFitsDateTimeCard.SetValueAsPreciseDateTime(APropIndex: Integer; const AValue: TPreciseDateTime);
begin
  Value := PreciseDateTimeToString(AValue, ExtractPartDateTime(APropIndex), Min(FFmtFracSec, 18));
end;

procedure TFitsDateTimeCard.DefaultFormat;
begin
  inherited;
  FFmtFracSec := 9;
  FFmtShortDate := yymmdd;
end;

{ TFitsStringCard }

procedure TFitsStringCard.CheckCard(const ACard: string);
var
  LWidth, LCount, LIndex: Integer;
  LRecord: TLineRecord;
begin
  LWidth := Length(ACard);
  if (LWidth < cSizeLine) or ((LWidth mod cSizeLine) <> 0) then
    Error(SCardInvalidMultiSize, [LWidth], ERROR_CARD_MULTI_SIZE);
  LCount := LWidth div cSizeLine;
  // Check the first line
  LRecord := LineToRecord(Copy(ACard, 1, cSizeLine));
  if not LRecord.ValueIndicate then
    Error(SCardInvalidContent, [ACard], ERROR_CARD_VALUE_INDICATE);
  // ... of single-line card
  if LCount = 1 then
  begin
    if not (IsBlankString(LRecord.Value) or IsQuotedString(LRecord.Value)) then
      Error(SCardInvalidContent, [ACard], ERROR_CARD_VALUE_QUOTE);
  end else
  // ... of multi-line card
  begin
    if not IsQuotedAmpersandString(LRecord.Value) then
      Error(SCardInvalidContent, [ACard], ERROR_CARD_VALUE_AMPERSAND);
  end;
  // Check the continued lines
  for LIndex := 2 to LCount do
  begin
    LRecord := LineToRecord(Copy(ACard, (LIndex - 1) * cSizeLine + 1, cSizeLine));
    if LRecord.Keyword <> cCONTINUE then
      Error(SCardInvalidContent, [ACard], ERROR_CARD_KEYWORD_CONTINUE);
    if LRecord.ValueIndicate then
      Error(SCardInvalidContent, [ACard], ERROR_CARD_VALUE_INDICATE);
    // ... next line
    if (LIndex < LCount) and (not IsQuotedAmpersandString(LRecord.Value)) then
      Error(SCardInvalidContent, [ACard], ERROR_CARD_VALUE_AMPERSAND);
    // ... last line
    if (LIndex = LCount) and (not IsQuotedString(LRecord.Value)) then
      Error(SCardInvalidContent, [ACard], ERROR_CARD_VALUE_QUOTE);
  end;
end;

procedure TFitsStringCard.SetKeyword(const AKeyword: string);
begin
  inherited;
  FCard := Copy(FCard, 1, cSizeKeyword) + cChrValueIndicator +
           Copy(FCard, cSizeKeyword + 2, Length(FCard));
end;

function TFitsStringCard.GetValue: string;
var
  LKeyword, LValue, LNote: string;
begin
  Decode({out} LKeyword, {out} LValue, {out} LNote);
  Result := LValue;
end;

procedure TFitsStringCard.SetValue(const AValue: string);
var
  LKeyword, LValue, LNote: string;
begin
  Decode({out} LKeyword, {out} LValue, {out} LNote);
  Encode(LKeyword, AValue, LNote);
end;

function TFitsStringCard.GetNote: string;
var
  LKeyword, LValue, LNote: string;
begin
  Decode({out} LKeyword, {out} LValue, {out} LNote);
  Result := LNote;
end;

procedure TFitsStringCard.SetNote(const ANote: string);
var
  LKeyword, LValue, LNote: string;
begin
  Decode({out} LKeyword, {out} LValue, {out} LNote);
  Encode(LKeyword, LValue, ANote);
end;

procedure TFitsStringCard.Decode(out AKeyword, AValue, ANote: string);
var
  LIndex, LCount: Integer;
  LRecord: TLineRecord;
  LString: string;
begin
  LCount := Length(FCard) div cSizeLine;
  if LCount = 1 then
  begin
    LRecord := LineToRecord(FCard);
    AKeyword := LRecord.Keyword;
    AValue := UnquotedString(LRecord.Value);
    ANote := Trim(LRecord.Note);
  end else
  begin
    AKeyword := '';
    AValue := '';
    ANote := '';
    for LIndex := 1 to LCount do
    begin
      LRecord := LineToRecord(Copy(FCard, 1 + (LIndex - 1) * cSizeLine, cSizeLine));
      // Get the keyword from the first line
      if LIndex = 1 then
        AKeyword := LRecord.Keyword;
      // Copy the value without the outer quotes and the continued ampersand of the next line
      LString := Trim(LRecord.Value);
      LString := Copy(LString, 2, Length(LString) - 2);
      LString := TrimRight(LString);
      if LIndex < LCount then
        Delete(LString, Length(LString), 1);
      AValue := AValue + LString;
      // Copy the note replacing all white spaces on the right with one
      LString := TrimRight(LRecord.Note);
      if LString <> LRecord.Note then
        LString := LString + cChrBlank;
      ANote := ANote + LString;
    end;
    // Restore the outer quotes and expand the quoted value
    AValue := UnquotedString(cChrQuote + AValue + cChrQuote);
    // Pack note
    ANote := Trim(ANote);
  end;
end;

procedure TFitsStringCard.Encode(const AKeyword, AValue, ANote: string);
const
  cSingleVolume = cSizeLine - (cSizeKeyword + 2);

  function CutOff(var AValue, ANote: string; out AChunkValue, AChunkNote: string): Boolean;
  var
    LWidthChunkValue, LWidthChunkNote, LQuote, LIndex: Integer;
  begin
    AValue := IfThen(AValue = '', cChrQuote + cChrQuote, AValue);
    LWidthChunkValue := Length(AValue);
    LWidthChunkNote := Length(ANote);
    // Set the value chunk
    if LWidthChunkNote = 0 then
      LWidthChunkValue := Min(LWidthChunkValue, cSingleVolume)
    else if LWidthChunkValue >= cSingleVolume then
      LWidthChunkValue := cSingleVolume - 2
    else if (LWidthChunkValue + 3 + LWidthChunkNote) > cSingleVolume then
      Inc(LWidthChunkValue);
    if LWidthChunkValue < Length(AValue) then
    begin
      // [FITS_STANDARD_4.0, SECT_4.2.1.2] Continued string keywords ... Note that
      // if the string contains any literal single-quote characters, then these
      // must be represented as a pair of singlequote characters in the FITS-keyword
      // value, and these two characters must both be contained within a single
      // substring
      LQuote := 0;
      for LIndex := LWidthChunkValue downto 1 do
        if AValue[LIndex] = cChrQuote then
          Inc(LQuote)
        else
          Break;
      if Odd(LQuote) then
        Dec(LWidthChunkValue);
      Insert(cChrAmpersand + cChrQuote + cChrQuote, AValue, LWidthChunkValue + 1);
      Inc(LWidthChunkValue, 2);
    end else
    if LWidthChunkValue > Length(AValue) then
      Insert(cChrAmpersand, AValue, LWidthChunkValue - 1);
    AChunkValue := Copy(AValue, 1, LWidthChunkValue);
    Delete(AValue, 1, LWidthChunkValue);
    // Set the note chunk
    LWidthChunkNote := EnsureRange(cSingleVolume - LWidthChunkValue - 3, 0, LWidthChunkNote);
    AChunkNote := Copy(ANote, 1, LWidthChunkNote);
    Delete(ANote, 1, LWidthChunkNote);
    // Returns True if the value or note chunks are not empty
    Result := (LWidthChunkValue > 2) or (LWidthChunkNote > 0);
  end;

var
  LCard, LValue, LNote, LChunkValue, LChunkNote: string;
  LVolume: Integer;
  LRecord: TLineRecord;
begin
  LValue := QuotedString(Trim(AValue));
  LNote := Trim(ANote);
  LVolume := IfThen(LNote = '', cSingleVolume, cSingleVolume - 3 - Length(LNote));
  // Single-line card
  if Length(LValue) <= LVolume then
  begin
    LValue := PadString(QuotedString(Trim(AValue), FFmtWidthQuote), FFmtWidth);
    LValue := TrimValue(LValue, LVolume);
    LRecord.Keyword := AKeyword;
    LRecord.ValueIndicate := True;
    LRecord.Value := LValue;
    LRecord.NoteIndicate := LNote <> '';
    LRecord.Note := LNote;
    LCard := RecordToLine(LRecord);
  end else
  // Multi-line card
  begin
    LCard := '';
    LChunkValue := '';
    LChunkNote := '';
    while CutOff({var} LValue, {var} LNote, {out} LChunkValue, {out} LChunkNote) do
      if LCard = '' then
      begin
        LRecord.Keyword := AKeyword;
        LRecord.ValueIndicate := True;
        LRecord.Value := LChunkValue;
        LRecord.NoteIndicate := LChunkNote <> '';
        LRecord.Note := LChunkNote;
        LCard := RecordToLine(LRecord);
      end else
      begin
        LRecord.Keyword := cCONTINUE;
        LRecord.ValueIndicate := False;
        LRecord.Value := LChunkValue;
        LRecord.NoteIndicate := LChunkNote <> '';
        LRecord.Note := LChunkNote;
        LCard := LCard + RecordToLine(LRecord);
      end;
  end;
  FCard := LCard;
end;

procedure TFitsStringCard.DefaultFormat;
begin
  inherited;
  FFmtWidth := -cWidthLineValue;
  FFmtWidthQuote := -cWidthLineValueQuote;
end;

{ TFitsGroupCard }

procedure TFitsGroupCard.CheckCard(const ACard: string);
var
  LWidth, LIndex: Integer;
  LKeyword, LKeywordNext: string;
begin
  LWidth := Length(ACard);
  if (LWidth < cSizeLine) or ((LWidth mod cSizeLine) <> 0) then
    Error(SCardInvalidMultiSize, [LWidth], ERROR_CARD_MULTI_SIZE);
  LKeyword := Copy(ACard, 1, cSizeKeyword);
  LIndex := 1 + cSizeLine;
  while LIndex < Length(ACard) do
  begin
    LKeywordNext := Copy(ACard, LIndex, cSizeKeyword);
    if LKeywordNext <> LKeyword then
      Error(SCardInvalidContent, [ACard], ERROR_CARD_KEYWORD_GROUP);
    Inc(LIndex, cSizeLine);
  end;
end;

function TFitsGroupCard.GetPrefix: string;
var
  LIndex, LBlank: Integer;
begin
  Result := Copy(FCard, 1, cSizeKeyword);
  if Result[Length(Result)] <> cChrBlank then
    for LBlank := 1 to 2 do
    begin
      LIndex := Length(Result) + 1;
      while (LIndex < Length(FCard)) and (FCard[LIndex] = cChrBlank) do
        Inc(LIndex, cSizeLine);
      if LIndex > Length(FCard) then
        Result := Result + cChrBlank
      else
        Break;
    end;
end;

function TFitsGroupCard.GetPrefix(const AKeyword: string): string;
begin
  Result := UpperCase(Trim(Copy(AKeyword, 1, cSizeKeyword)));
  Result := EnsureString(Result, -cSizeKeyword);
  if Result[Length(Result)] <> cChrBlank then
    Result := Result + cChrBlank + cChrBlank;
end;

function TFitsGroupCard.FixValue(const AValue: string): string;
begin
  Result := AValue;
  Result := StringReplace(Result, #13#10, cChrBlank, [rfReplaceAll]);
  Result := StringReplace(Result,    #10, cChrBlank, [rfReplaceAll]);
end;

procedure TFitsGroupCard.SetKeyword(const AKeyword: string);
begin
  Encode(AKeyword, Value);
end;

function TFitsGroupCard.GetValue: string;
var
  LKeyword, LValue: string;
begin
  Decode({out} LKeyword, {out} LValue);
  Result := LValue;
end;

procedure TFitsGroupCard.SetValue(const AValue: string);
begin
  Encode(Keyword, AValue);
end;

function TFitsGroupCard.GetValueAsGroup: TValueGroup;
var
  LPrefix: string;
  LCount, LVolume, LIndex, LStart: Integer;
begin
  LPrefix := GetPrefix;
  LCount := Length(FCard) div cSizeLine;
  LStart := Length(LPrefix) + 1;
  LVolume := cSizeLine - Length(LPrefix);
  Result := nil;
  SetLength(Result, LCount);
  for LIndex := Low(Result) to High(Result) do
    Result[LIndex] := Copy(FCard, LStart + LIndex * cSizeLine, LVolume);
end;

procedure TFitsGroupCard.SetValueAsGroup(const AValue: TValueGroup);
var
  LCard, LValue, LPrefix: string;
  LVolume, LIndex: Integer;
begin
  LPrefix := GetPrefix(Keyword);
  LVolume := cSizeLine - Length(LPrefix);
  LCard := '';
  for LIndex := Low(AValue) to High(AValue) do
  begin
    LValue := FixValue(AValue[LIndex]);
    repeat
      LCard := LCard + EnsureString(LPrefix + LValue, -cSizeLine);
      Delete(LValue, 1, LVolume);
    until LValue = '';
  end;
  if LCard = '' then
    LCard := EnsureString(LPrefix, -cSizeLine);
  FCard := LCard;
end;

procedure TFitsGroupCard.Decode(out AKeyword, AValue: string);
var
  LPrefix: string;
  LVolume, LStart: Integer;
begin
  AKeyword := Keyword;
  AValue := '';
  LPrefix := GetPrefix;
  LStart := Length(LPrefix) + 1;
  LVolume := cSizeLine - Length(LPrefix);
  while LStart < Length(FCard) do
  begin
    AValue := AValue + Copy(FCard, LStart, LVolume);
    Inc(LStart, cSizeLine);
  end;
end;

procedure TFitsGroupCard.Encode(const AKeyword, AValue: string);
var
  LCard, LValue, LPrefix: string;
  LVolume: Integer;
begin
  LPrefix := GetPrefix(AKeyword);
  LVolume := cSizeLine - Length(LPrefix);
  LValue := FixValue(AValue);
  LCard := '';
  repeat
    LCard := LCard + EnsureString(LPrefix + LValue, -cSizeLine);
    Delete(LValue, 1, LVolume);
  until LValue = '';
  FCard := LCard;
end;

end.
