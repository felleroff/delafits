{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{         Types, constants, keyword dictionary         }
{                 and simple functions                 }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsCommon;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils;

{$I DeLaFitsSuppress.inc}

const

  cDeLaFits = 'DeLaFits';

  { [FITS_STANDARD_4.0, SECT_3.1] Each FITS structure shall consist of an
    integral number of FITS blocks which are each 2880 bytes (23040 bits)
    in length }

  cSizeBlock = 2880;

  cSizeLine = 80;
  cCountLinesInBlock = cSizeBlock div cSizeLine; // 36

  cSizeKeyword = 08;

  cChrValueIndicator: Char = '=';     // $3D
  cChrNoteIndicator : Char = '/';     // $2F
  cChrBlank         : Char = ' ';     // $20
  cChrNull          : Char = Char(0); // $00
  cChrAmpersand     : Char = '&';     // $26
  cChrQuote         : Char = '''';    // $27

  cWidthLineValue = 20;
  cWidthLineValueQuote = 08;

  { [FITS_STANDARD_4.0, SECT_2.2] Array a sequence of data values. This
    sequence corresponds to the elements in a rectilinear, n-dimension
    matrix (1 <= n <= 999, or n = 0 in the case of a null array) }

  cMaxAxis = 999;

  { [FITS_STANDARD_4.0, SECT_7.2.1] The ASCII-table extension / Binary-table
    extension. TFIELDS keyword. The value field shall contain a non-negative
    integer representing the number of fields in each row. The maximum
    permissible value is 999 }

  cMaxFields = 999;

  { Indication of an undefined value for the internal size of HDU blocks }

  cInternalSizeNull = -1;

const

  { [FITS_STANDARD_4.0] Basic and other commonly used keywords:
    https://heasarc.gsfc.nasa.gov/docs/fcg/standard_dict.html
    https://heasarc.gsfc.nasa.gov/docs/fcg/common_dict.html }

  cSIMPLE   = 'SIMPLE';

  cEXTEND   = 'EXTEND';   // Boolean: may the FITS file contain extensions? optional

  cXTENSION = 'XTENSION'; // String: name of the extension type
  cEXTNAME  = 'EXTNAME';  // String: for distinguish among different extensions of the same type, i.e., with the same value of XTENSION
  cEXTVER   = 'EXTVER';   // Integer: for distinguish among different extensions in a FITS file with the same type and name, i.e., the same values for XTENSION and EXTNAME , default = 1
  cEXTLEVEL = 'EXTLEVEL'; // Integer: specifying the level in a hierarchy of extension levels of the extension header containing it, default = 1

  cBITPIX   = 'BITPIX';
  cNAXIS    = 'NAXIS';
  cNAXISn   = 'NAXIS%d';
  cNAXIS1   = 'NAXIS1';
  cNAXIS2   = 'NAXIS2';
  cNAXIS3   = 'NAXIS3';
  cGCOUNT   = 'GCOUNT';   // Integer: group count, optional, default = 1
  cPCOUNT   = 'PCOUNT';   // Integer: parameter count, optional, default = 0

  cGROUPS   = 'GROUPS';   // Boolean: indicates random groups structure

  cBSCALE   = 'BSCALE';
  cBZERO    = 'BZERO';

  cTFIELDS  = 'TFIELDS';
  cTBCOLn   = 'TBCOL%d';
  cTFORMn   = 'TFORM%d';

  cTTYPEn   = 'TTYPE%d';
  cTUNITn   = 'TUNIT%d';
  cTSCALn   = 'TSCAL%d';
  cTZEROn   = 'TZERO%d';
  cTNULLn   = 'TNULL%d';
  cTDISPn   = 'TDISP%d';
  cTDMINn   = 'TDMIN%d';
  cTDMAXn   = 'TDMAX%d';
  cTLMINn   = 'TLMIN%d';
  cTLMAXn   = 'TLMAX%d';

  cAUTHOR   = 'AUTHOR';
  cBLANK    = '';
  cCONTINUE = 'CONTINUE';
  cCOMMENT  = 'COMMENT';
  cDATAMAX  = 'DATAMAX';  // Double
  cDATAMIN  = 'DATAMIN';  // Double
  cDATE     = 'DATE';     // String: 'yyyy-mm-dd' or 'yyyy-mm-ddTHH:MM:SS[.sss]'
  cDATE_OBS = 'DATE-OBS';
  cEPOCH    = 'EPOCH';
  cEQUINOX  = 'EQUINOX';  // Double: equinox of celestial coordinate system
  cHISTORY  = 'HISTORY';
  cINSTRUME = 'INSTRUME';
  cOBJECT   = 'OBJECT';
  cOBSERVER = 'OBSERVER';
  cORIGIN   = 'ORIGIN';
  cTELESCOP = 'TELESCOP';

  cAPERTURE = 'APERTURE';
  cCREATOR  = 'CREATOR';  // String: name of software that created the file
  cDATE_END = 'DATE-END'; // String: end date of observation
  cDEC      = 'DEC';      // String or Double, 'sdd(.d)' or 'sdd:mm:ss(.sss)'
  cELAPTIME = 'ELAPTIME'; // Double: elapsed time of observation, number of seconds
  cEXPOSURE = 'EXPOSURE'; // Double: excerpt from the observations in units of seconds (exposure). Exact, syn. EXPTIME
  cEXPTIME  = 'EXPTIME';  // Double: exposure time
  cFILTER   = 'FILTER';
  cLATITUDE = 'LATITUDE'; // Double: geographical latitude observations
  cLIVETIME = 'LIVETIME'; // Double: the exposure time after Deadtime correction
  cOBJNAME  = 'OBJNAME';  // String: IUA name of the monitored object
  cOBS_ID   = 'OBS_ID';   // String: unique identifier for of observation
  cORIENTAT = 'ORIENTAT'; // Double: position angle of the image axis Y (deg. E of N)
  cRA       = 'RA';       // String or Double: 'ddd(.d)' or 'ddd:mm:ss(.s)' or 'hh(.h)' or 'hh:mm:ss(.sss)'
  cTIME_OBS = 'TIME-OBS'; // String: start time of observation

  cEND      = 'END';

  function ExpandKeyword(const AKeyword: string; AKeywordNumber: Integer): string; {$IFDEF HAS_INLINE} inline; {$ENDIF}

type

  { Numbers (platform-independent types):
    f ~ floating-point
    c ~ two's complement binary integer
    u ~ unsigned binary integer }

  T08c = ShortInt;
  T08u = Byte;
  T16c = SmallInt;
  T16u = Word;
  T32f = Single;
  T32c = Integer;
  T32u = Cardinal;
  T64f = Double;
  T64c = Int64;
  T80f = Extended;

  { Type numbers: the physical values of the data block }

  TNumberType = (numUnknown, num80f, num64f, num32f, num08c, num08u, num16c,
    num16u, num32c, num32u, num64c);

  { Arrays }

  TA08c = array of T08c;
  TA08u = array of T08u;
  TA16c = array of T16c;
  TA16u = array of T16u;
  TA32f = array of T32f;
  TA32c = array of T32c;
  TA32u = array of T32u;
  TA64f = array of T64f;
  TA64c = array of T64c;
  TA80f = array of T80f;

  TABol = array of Boolean;

  TAStr = array of string;

  { TBytes }

  TBytes1 = array of Byte;
  TBytes2 = array of array of Byte;

type

  { System order bytes: big-endian or little-endian }

  TEndianness = (sysBE, sysLE);

  function GetEndianness: TEndianness;

type

  { The type of data in the temporary buffer when dealing with stream, possible
    need packed }

  TBuffer = TBytes1;

const

  { Max size the temporary buffer for operation with stream }

  cMaxSizeBuffer: Integer = 1024 * 64;

  function GetMaxSizeBuffer: Integer;
  procedure SetMaxSizeBuffer(const AValue: Integer);

type

  { [FITS_STANDARD_4.0, SECT_4.1.1.1] BITPIX (bits per data value) keyword:
    -64 ~ IEEE double precision floating-point
    -32 ~ IEEE single precision floating-point
    +08 ~ Character or unsigned binary integer
    +16 ~ 16-bit two's complement binary integer
    +32 ~ 32-bit two's complement binary integer
    +64 ~ 64-bit two's complement binary integer }

  TBitPix = (biUnknown, bi64f, bi32f, bi08u, bi16c, bi32c, bi64c);

  function BitPixToInt(AValue: TBitPix): Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function IntToBitPix(AValue: Integer): TBitPix; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  { Returns size BitPix in bytes }

  function BitPixSize(AValue: TBitPix): Byte; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;
  function BitPixSize(AValue: Integer): Byte; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;

type

  { TVariable: dynamic value type (a simplified analogue of the Variant type) }

  TVariableType = (vtNone, vtBoolean, vtInt64, vtExtended, vtString);

  TVariable = record
    VarType: TVariableType;
    ValueString: string;
  case Integer of
    1: (ValueBoolean: Boolean);
    2: (ValueInt64: Int64);
    3: (ValueExtended: Extended);
  end;

  function ClearVariable: TVariable; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function NewVariable(const AValue: Boolean): TVariable; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;
  function NewVariable(const AValue: Int64): TVariable; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;
  function NewVariable(const AValue: Extended): TVariable; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;
  function NewVariable(const AValue: string): TVariable; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;

const

  { [FITS_STANDARD_4.0, SECT_4.4.2.5] BZERO keyword: usage of ZERO to represent
    non-default integer data types }

  cZero08c = -$80;
  cZero16u = +$8000;
  cZero32u = +$80000000;

  function NumberTypeToBitPix(AValueType: TNumberType): TBitPix; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function NumberTypeToTypicalZero(AValueType: TNumberType): Int64; {$IFDEF HAS_INLINE} inline; {$ENDIF}

type

  { The type of the coefficients zero and scale in the linear transformation
    equation "values = zero + scale * buffer":
    linearPlain ~ zero=0.0 and scale=1.0
    linearShift ~ zero=cZeroXXX and scale=1.0
    linearScale ~ non-trivial values of zero and scale }

  TLinearType = (linearPlain, linearShift, linearScale);

type

  { [FITS_STANDARD_4.0, SECT_4.1.1] Syntax ... Each 80-character header keyword
    record shall consist of a keyword name, a value indicator (only required if
    a value is present), an optional value, and an optional comment }

  TLineRecord = record
    Keyword: string;
    ValueIndicate: Boolean;
    Value: string;
    NoteIndicate: Boolean;
    Note: string;
  end;

  function ToLineRecord(const AKeyword: string; AValueIndicate: Boolean; const AValue: string;
    ANoteIndicate: Boolean; const ANote: string): TLineRecord; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function EmptyLineRecord: TLineRecord; {$IFDEF HAS_INLINE} inline; {$ENDIF}

type

  { Type of card packaging in FITS header lines:
    cardEmpty     ~ empty single-line
    cardTypical   ~ single-line as "KEYWORD=VALUE/NOTE"
    cardContinued ~ multi-line as a continued string
    cardGrouped   ~ multi-line as a grouping "KEYWORD VALUE" }

  TCardType = (cardUnknown, cardEmpty, cardTypical, cardContinued, cardGrouped);

  { Scope of card search: range and direction }

  TSearchScope = (searchFirstForward, searchLastBackward, searchNextForward, searchPriorBackward);

  { Card location in FITS header lines: index of the starting line and
    number of lines occupied }

  TCardSpot = record
    Start: Integer;
    Count: Integer;
  end;

const

  cCardSpotNull: TCardSpot = (Start: -1; Count: -1);

type

  { Precise DateTime: date and time with a precision of up to a second and
    the number of attoseconds (1s = 1*10^18 = 1_000_000_000_000_000_000 as) }

  TPreciseDateTime = record
    DateTime: TDateTime;
    AttoSec: Int64;
  end;

  TPartDateTime = set of (paDate, paTime); // DateTime, only Date, only Time
  TFmtShortDate = (yymmdd, ddmmyy);        // FITS format short date ~ yymmdd

  { Coordinate format of the II equatorial coordinate system:
    Ra [coDecimal,coDegree] ~   recommended, ddd(.d), [0.0..360.0)
    Ra [  coMixed,  coHour] ~   recommended, HH:MM:SS(.s), [0.0..24.0)
    Ra [coDecimal,  coHour] ~ unrecommended, hh(.h), [0.0..24.0)
    Ra [  coMixed,coDegree] ~ unrecommended, DDD:MM:SS(.s), [0.0..360.0)
    De [coDecimal,coDegree] ~   recommended, dd(.d), [-90.0..+90.0]
    De [  coMixed,coDegree] ~   recommended, DD:MM:SS(.s), [-90.0..+90.0]
    De [coDecimal,  coHour] ~   unsupported
    De [  coMixed,  coHour] ~   unsupported }

  TFmtRepCoord = (coDecimal, coMixed); // G.(g) or GG MM SS.(s)
  TFmtMeaCoord = (coDegree, coHour);   // DDD:MM:SS.(s) or HH:MM:SS.(s)

  { String }

  function IfThen(AValue: Boolean; const ATrue: string; const AFalse: string = ''): string; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;

type

  { Picture frame histogram }

  PHistogramBucket = ^THistogramBucket;
  THistogramBucket = record
    Value: Extended;
    Frequency: Integer;
  end;
  THistogramBuckets = array of PHistogramBucket;

const

  cHistogramMaxVolume = 1024 * 1024; // maximum count of values in all buckets (bins), i.e. the maximum sum of all frequencies
  cHistogramMaxCount  =  50 * 1000;  // maximum count of buckets (bins), eq ~586 kb

const

  { Picture frame tone: Y = Co * (X ^ Ga - 0.5) + 0.5 + Br }

  cBrightnessMax = +1.0;
  cBrightnessMin = -1.0;
  cBrightnessDef =  0.0;

  cContrastMax   =  3.0;
  cContrastMin   =  0.0;
  cContrastDef   =  1.0;

  cGammaMax      =  3.0;
  cGammaMin      =  0.0;
  cGammaDef      =  1.0;

const

  { Picture frame palette }

  cPaletteCount = 256;

type

  TPaletteTuple = record
    R, G, B: Byte;
  end;
  PPaletteTuples = ^TPaletteTuples;
  TPaletteTuples = array [0 .. cPaletteCount - 1] of TPaletteTuple;

  TPaletteRaster = TBytes2;

  TPaletteRasterCell = record
    X, Y: Integer;
  end;

  procedure AllocateRaster(var ARaster: TPaletteRaster; AWidth, AHeight: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure FillRaster(var ARaster: TPaletteRaster; AWidth, AHeight: Integer; AValue: Byte); {$IFDEF HAS_INLINE} inline; {$ENDIF}

const

  { Picture frame band: opeartor "pixel value -> palette index" }

  cFrameBandCount = cPaletteCount;

type

  TFrameBand = array [0 .. cFrameBandCount - 1] of Extended;

type

  { Picture frame geometry }

  TMatrix = array [1 .. 3, 1 .. 3] of Double;

  TPlanePixel = record
    X, Y: Integer;
  end;

  TPlanePoint = record
    X, Y: Double;
  end;

  TVirtualPoint = (xy00, xyLT, xyRT, xyRB, xyLB, xyCC);

  TVirtualShift = (xyLTat00, xyRTat00, xyRBat00, xyLBat00, xyCCat00);

  //  (X1,Y1)-- W --*
  //     |          |
  //     H          |
  //     |          |
  //     *----------*

  TRegion = record
    X1, Y1: Integer;
    Width, Height: Integer;
  end;

  TBound = record
    Xmin: Integer;
    Ymin: Integer;
    Xmax: Integer;
    Ymax: Integer;
    Xcount: Integer;
    Ycount: Integer;
  end;

  // P1----P2
  //  |    |
  // P4----P3

  TQuadPoints = array [1 .. 4] of TPlanePoint;
  TQuad = record
    case Integer of
      0: (X1, Y1, X2, Y2, X3, Y3, X4, Y4: Double);
      1: (P1, P2, P3, P4: TPlanePoint);
      2: (Points: TQuadPoints);
  end;

  TClipPoints = array [1 .. 8] of TPlanePoint;
  TClip = record
    Count: Integer;
    case Integer of
      0: (X1, Y1, X2, Y2, X3, Y3, X4, Y4, X5, Y5, X6, Y6, X7, Y7, X8, Y8: Double);
      1: (P1, P2, P3, P4, P5, P6, P7, P8: TPlanePoint);
      2: (Points: TClipPoints);
  end;

const

  cPointOrigin: TPlanePoint = (X: 0.0; Y: 0.0);

  function ToPixel(const AX, AY: Integer): TPlanePixel; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function ToPoint(const AX, AY: Double): TPlanePoint; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function ToRegion(AX1, AY1, AWidth, AHeight: Integer): TRegion; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function ToBound(const ARegion: TRegion): TBound; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function ToQuad(const AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Double): TQuad; overload; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function ToQuad(const ARegion: TRegion): TQuad; overload; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function ToClip(const AX, AY: array of Double): TClip;

const

  cRecordIndexNull = -1;

const

  { The base class of exceptions and their codes }

  ERROR_FITS    = 1000;
  ERROR_NULL    = 1001;
  ERROR_UNKNOWN = 1002;

resourcestring

  { The messages of exceptions }

  SAssertionFailure = 'DeLaFits assertion failure';

  function SAssertionFailureArgs(const AArgs: array of const): string;

type

  { EFitsException: base exception class }

  EFitsException = class(Exception)
  private
    FCode: Integer;
    function GetCaption: string;
    function FormatMessage(const AMsg: string; const AArgs: array of const): string;
  protected
    function GetTopic: string; virtual;
  public
    constructor Create(const AMsg: string; ACode: Integer);
    constructor CreateFmt(const AMsg: string; const AArgs: array of const; ACode: Integer);
    property Topic: string read GetTopic;
    property Code: Integer read FCode;
  end;

  EFitsExceptionClass = class of EFitsException;

  { TFitsObject [abstract]: base class }

  TFitsObject = class(TObject)
  protected
    procedure Init; virtual;
    function GetExceptionClass: EFitsExceptionClass; virtual; abstract;
    procedure Error(const AMsg: string; ACode: Integer); overload;
    procedure Error(const AMsg: string; const AArgs: array of const; ACode: Integer); overload;
  public
    constructor Create;
  end;

  { TFitsInterfacedObject [abstract]: base interfaced class }

  TFitsInterfacedObject = class(TInterfacedObject)
  protected
    procedure Init; virtual;
    function GetExceptionClass: EFitsExceptionClass; virtual; abstract;
    procedure Error(const AMsg: string; ACode: Integer); overload;
    procedure Error(const AMsg: string; const AArgs: array of const; ACode: Integer); overload;
  public
    constructor Create;
  end;

implementation

{ Keywords }

function ExpandKeyword(const AKeyword: string; AKeywordNumber: Integer): string;
begin
  Result := Format(AKeyword, [AKeywordNumber]);
end;

{ TEndianness }

function GetEndianness: TEndianness;
const
  A: array [0 .. 1] of Byte = ($12, $34);
var
  X: Word;
begin
  X := 0;
  Move(A[0], X, 2);
  if X = $1234 then
    Result := sysBE
  else { X = $3412 }
    Result := sysLE;
end;

{ Temporary buffer }

function GetMaxSizeBuffer: Integer;
begin
  Result := cMaxSizeBuffer;
end;

procedure SetMaxSizeBuffer(const AValue: Integer);
begin
  if AValue > 0 then
    PInteger(@cMaxSizeBuffer)^ := AValue;
end;

{ TBitPix }

function BitPixToInt(AValue: TBitPix): Integer;
begin
  case AValue of
    bi64f: Result := -64;
    bi32f: Result := -32;
    bi08u: Result :=  08;
    bi16c: Result :=  16;
    bi32c: Result :=  32;
    bi64c: Result :=  64;
  else     Result :=  00;
  end;
end;

function IntToBitPix(AValue: Integer): TBitPix;
begin
  case AValue of
    -64: Result := bi64f;
    -32: Result := bi32f;
     08: Result := bi08u;
     16: Result := bi16c;
     32: Result := bi32c;
     64: Result := bi64c;
  else   Result := biUnknown;
  end;
end;

function BitPixSize(AValue: TBitPix): Byte;
begin
  case AValue of
    bi64f: Result := 8;
    bi32f: Result := 4;
    bi08u: Result := 1;
    bi16c: Result := 2;
    bi32c: Result := 4;
    bi64c: Result := 8;
  else     Result := 0;
  end;
end;

function BitPixSize(AValue: Integer): Byte;
var
  LBitPix: TBitPix;
begin
  LBitPix := IntToBitPix(AValue);
  Result := BitPixSize(LBitPix);
end;

{ TVariable }

function ClearVariable: TVariable;
begin
  Result.VarType := vtNone;
  Result.ValueExtended := 0.0;
  Result.ValueString := '';
end;

function NewVariable(const AValue: Boolean): TVariable;
begin
  Result.VarType := vtBoolean;
  Result.ValueBoolean := AValue;
  Result.ValueString := '';
end;

function NewVariable(const AValue: Int64): TVariable;
begin
  Result.VarType := vtInt64;
  Result.ValueInt64 := AValue;
  Result.ValueString := '';
end;

function NewVariable(const AValue: Extended): TVariable;
begin
  Result.VarType := vtExtended;
  Result.ValueExtended := AValue;
  Result.ValueString := '';
end;

function NewVariable(const AValue: string): TVariable;
begin
  Result.VarType := vtString;
  Result.ValueExtended := 0.0;
  Result.ValueString := AValue;
end;

{ TNumberType }

function NumberTypeToBitPix(AValueType: TNumberType): TBitPix;
begin
  case AValueType of
    num80f: Result := bi64f;
    num64f: Result := bi64f;
    num32f: Result := bi32f;
    num08c: Result := bi08u;
    num08u: Result := bi08u;
    num16c: Result := bi16c;
    num16u: Result := bi16c;
    num32c: Result := bi32c;
    num32u: Result := bi32c;
    num64c: Result := bi64c;
  else      Result := biUnknown;
  end;
end;

function NumberTypeToTypicalZero(AValueType: TNumberType): Int64;
begin
  case AValueType of
    num08c: Result := cZero08c;
    num16u: Result := cZero16u;
    num32u: Result := cZero32u;
  else      Result := 0;
  end;
end;

{ TLineRecord }

function ToLineRecord(const AKeyword: string; AValueIndicate: Boolean;
  const AValue: string; ANoteIndicate: Boolean; const ANote: string): TLineRecord;
begin
  Result.Keyword := AKeyword;
  Result.ValueIndicate := AValueIndicate;
  Result.Value := AValue;
  Result.NoteIndicate := ANoteIndicate;
  Result.Note := ANote;
end;

function EmptyLineRecord: TLineRecord;
begin
  Result.Keyword := '';
  Result.ValueIndicate := False;
  Result.Value := '';
  Result.NoteIndicate := False;
  Result.Note := '';
end;

{ String }

function IfThen(AValue: Boolean; const ATrue: string; const AFalse: string = ''): string;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

{ Picture frame palette }

procedure AllocateRaster(var ARaster: TPaletteRaster; AWidth, AHeight: Integer);
var
  LWidth, LHeight: Integer;
begin
  LWidth := Length(ARaster);
  if LWidth > 0 then
    LHeight := Length(ARaster[0])
  else
    LHeight := 0;
  if (LWidth < AWidth) or (LHeight < AHeight) then
    SetLength(ARaster, AWidth, AHeight);
end;

procedure FillRaster(var ARaster: TPaletteRaster; AWidth, AHeight: Integer; AValue: Byte);
var
  X, Y: Integer;
begin
  for X := 0 to AWidth - 1 do
  for Y := 0 to AHeight - 1 do
    ARaster[X, Y] := AValue;
end;

{ Picture frame geometry }

function ToPixel(const AX, AY: Integer): TPlanePixel;
begin
  Result.X := AX;
  Result.Y := AY;
end;

function ToPoint(const AX, AY: Double): TPlanePoint;
begin
  Result.X := AX;
  Result.Y := AY;
end;

function ToRegion(AX1, AY1, AWidth, AHeight: Integer): TRegion;
begin
  Assert((AWidth >= 0) and (AHeight >= 0), SAssertionFailure);
  Result.X1 := AX1;
  Result.Y1 := AY1;
  Result.Width := AWidth;
  Result.Height := AHeight;
end;

function ToBound(const ARegion: TRegion): TBound;
begin
  Assert((ARegion.Width >= 0) and (ARegion.Height >= 0), SAssertionFailure);
  Result.Xmin   := ARegion.X1;
  Result.Ymin   := ARegion.Y1;
  Result.Xmax   := ARegion.X1 + ARegion.Width - 1;
  Result.Ymax   := ARegion.Y1 + ARegion.Height - 1;
  Result.Xcount := ARegion.Width;
  Result.Ycount := ARegion.Height;
end;

function ToQuad(const AX1, AY1, AX2, AY2, AX3, AY3, AX4, AY4: Double): TQuad; overload;
begin
  Result.X1 := AX1;
  Result.Y1 := AY1;
  Result.X2 := AX2;
  Result.Y2 := AY2;
  Result.X3 := AX3;
  Result.Y3 := AY3;
  Result.X4 := AX4;
  Result.Y4 := AY4;
end;

function ToQuad(const ARegion: TRegion): TQuad; overload;
begin
  with ARegion do
  begin
    Result.P1 := ToPoint(X1, Y1);
    Result.P2 := ToPoint(X1 + Width, Y1);
    Result.P3 := ToPoint(X1 + Width, Y1 + Height);
    Result.P4 := ToPoint(X1, Y1 + Height);
  end;
end;

function ToClip(const AX, AY: array of Double): TClip;
var
  LIndex: Integer;
begin
  Assert(Length(AX) = Length(AY), SAssertionFailure);
  Result.Count := Length(AX);
  for LIndex := 1 to Result.Count do
  begin
    Result.Points[LIndex].X := AX[LIndex - 1];
    Result.Points[LIndex].Y := AY[LIndex - 1];
  end;
end;

{ Assert }

function SAssertionFailureArgs(const AArgs: array of const): string;
begin
  Result := SAssertionFailure + Format(' (%d)', [Length(AArgs)]);
end;

{ EFitsException }

function EFitsException.GetTopic: string;
begin
  Result := 'COMMON';
end;

function EFitsException.GetCaption: string;
begin
  Result := Format('$%s-%s-%.4d', [cDeLaFits, GetTopic, FCode]);
  Result := UpperCase(Result);
end;

function EFitsException.FormatMessage(const AMsg: string; const AArgs: array of const): string;
var
  LMsg, LCaption: string;
begin
  if Length(AArgs) = 0 then
    LMsg := AMsg
  else
    LMsg := Format(AMsg, AArgs);
  LCaption := GetCaption;
  // Return
  if LMsg = '' then
    Result := LCaption
  else
    Result := LCaption + ', ' + LMsg;
end;

constructor EFitsException.Create(const AMsg: string; ACode: Integer);
var
  LMessage: string;
begin
  FCode := ACode;
  LMessage := FormatMessage(AMsg, {AArgs:} []);
  inherited Create(LMessage);
end;

constructor EFitsException.CreateFmt(const AMsg: string; const AArgs: array of const; ACode: Integer);
var
  LMessage: string;
begin
  FCode := ACode;
  LMessage := FormatMessage(AMsg, AArgs);
  inherited Create(LMessage);
end;

{ TFitsObject }

procedure TFitsObject.Init;
begin
  // Do nothing: implicit call, custom initialization of class members
end;

procedure TFitsObject.Error(const AMsg: string; ACode: Integer);
begin
  raise GetExceptionClass.Create(AMsg, ACode);
end;

procedure TFitsObject.Error(const AMsg: string; const AArgs: array of const; ACode: Integer);
begin
  raise GetExceptionClass.CreateFmt(AMsg, AArgs, ACode);
end;

constructor TFitsObject.Create;
begin
  inherited Create;
  Init;
end;

{ TFitsInterfacedObject }

procedure TFitsInterfacedObject.Init;
begin
  // Do nothing: implicit call, custom initialization of class members
end;

procedure TFitsInterfacedObject.Error(const AMsg: string; ACode: Integer);
begin
  raise GetExceptionClass.Create(AMsg, ACode);
end;

procedure TFitsInterfacedObject.Error(const AMsg: string; const AArgs: array of const; ACode: Integer);
begin
  raise GetExceptionClass.CreateFmt(AMsg, AArgs, ACode);
end;

constructor TFitsInterfacedObject.Create;
begin
  inherited Create;
  Init;
end;

end.
