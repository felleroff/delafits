{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{         Types, constants, keyword dictionary         }
{                 and simple functions                 }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
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

  { FITS Standard. Each FITS structure shall consist of an integral number
    of FITS blocks which are each 2880 bytes (23040 bits) in length }

  cSizeBlock = 2880;

  cSizeLine = 80;
  cCountLinesInBlock = cSizeBlock div cSizeLine; // 36
  cSizeKeyword = 08;

  cChrValueIndicator: Char = '=';     // $3D
  cChrNoteIndicator : Char = '/';     // $2F
  cChrBlank         : Char = ' ';     // $20
  cChrNull          : Char = Char(0); // $00
  cChrQuote         : Char = '''';    // $27

  cWidthLineValue = 20;
  cWidthLineValueQuote = 08;

  { FITS Standard. A sequence of data values. This sequence corresponds
    to the elements in a rectilinear, n-dimension matrix (1 <= n <= 999,
    or n = 0 in the case of a null array) }

  cMaxAxis = 999;

  { FITS Standard. The ASCII-table extension / Binary-table extension. The value
    field TFIELDS shall contain a non-negative integer representing the number
    of fields in each row. The maximum permissible value is 999 }

  cMaxFields = 999;

const

  { FITS Standard. Basic and other commonly used keywords:
    https://heasarc.gsfc.nasa.gov/docs/fcg/standard_dict.html
    https://heasarc.gsfc.nasa.gov/docs/fcg/common_dict.html }

  cSIMPLE   = 'SIMPLE';

  cEXTEND   = 'EXTEND';   // Boolean: may the FITS file contain extensions? optional

  cXTENSION = 'XTENSION'; // String: name of the extension type
  cEXTNAME  = 'EXTNAME';  // String: for distinguish among different extensions of the same type, i.e., with the same value of XTENSION
  cEXTVER   = 'EXTVER';   // Integer: for distinguish among different extensions in a FITS file with the same type and name, i.e., the same values for XTENSION and EXTNAME , default = 1
  cEXTLEVEL = 'EXTLEVEL'; // Integer: specifying the level in a hierarchy of extension levels of the extension header containing it, default = 1

  cBITPIX   = 'BITPIX';
  cGCOUNT   = 'GCOUNT';   // Integer: group count, optional, default = 1
  cPCOUNT   = 'PCOUNT';   // Integer: parameter count, optional, default = 0
  cNAXIS    = 'NAXIS';
  cNAXISn   = 'NAXIS%d';
  cNAXIS1   = 'NAXIS1';
  cNAXIS2   = 'NAXIS2';
  cNAXIS3   = 'NAXIS3';

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

type

  { Numbers: f ~ floating-point, u ~ unsigned binary integer, c ~ two's
    complement binary integer }

  T08u = Byte;
  T08c = ShortInt;
  T16u = Word;
  T16c = SmallInt;
  T32f = Single;
  T32u = LongWord;
  T32c = LongInt;
  T64f = Double;
  T64c = Int64;
  T80f = Extended;

  { Arrays }

  TA08u = array of T08u;
  TA08c = array of T08c;
  TA16u = array of T16u;
  TA16c = array of T16c;
  TA32f = array of T32f;
  TA32u = array of T32u;
  TA32c = array of T32c;
  TA64f = array of T64f;
  TA64c = array of T64c;
  TA80f = array of T80f;

  TABol = array of Boolean;

  TAStr = array of string;

type

  { System order bytes: big-endian or little-endian }

  TEndianness = (sysBE, sysLE);

  function GetEndianness: TEndianness;

type

  { The type of data in the temporary buffer when dealing with stream, possible
    need packed }

  TBuffer = array of T08u;

const

  { Max size the temporary buffer for operation with stream }

  cMaxSizeBuffer: Integer = 1024 * 64;

  function GetMaxSizeBuffer: Integer;
  procedure SetMaxSizeBuffer(const AValue: Integer);

type

  { Numbers type of the data elements: physical values representation of the
    data block }

  TRepNumber = (repUnknown, rep80f, rep64f, rep32f, rep08c, rep08u, rep16c,
    rep16u, rep32c, rep32u, rep64c);

type

  { Fits Standard. BITPIX (bits per data value):
    -64 ~ IEEE double precision floating-point
    -32 ~ IEEE single precision floating-point
    +08 ~ Character or unsigned binary integer
    +16 ~ 16-bit two's complement binary integer
    +32 ~ 32-bit two's complement binary integer
    +64 ~ 64-bit two's complement binary integer }

  TBitPix = (biUnknown, bi64f, bi32f, bi08u, bi16c, bi32c, bi64c);

  function BitPixToInt(Value: TBitPix): Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function IntToBitPix(Value: Integer): TBitPix; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function BitPixToRep(Value: TBitPix): TRepNumber; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  // Returns size BitPix in bytes
  function BitPixSize(Value: TBitPix): Byte; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;
  function BitPixSize(Value: Integer): Byte; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;

const

  { Usage of BZERO to represent non-default integer data types }

  cZero08c = -$80;
  cZero16u = +$8000;
  cZero32u = +$80000000;

const

  { Constant string values parsing rules }

  cCast = 0;

  cCastChars     = cCast + 1;  // ~ string as is, one line (len ~ 80)
  cCastText      = cCast + 2;  // ~ string as is long
  cCastString    = cCast + 3;  // ~ quoted/unquoted string
  cCastBoolean   = cCast + 4;  // ~ Boolean
  cCastInteger   = cCast + 5;  // ~ Int64
  cCastFloat     = cCast + 6;  // ~ Extended
  cCastRa        = cCast + 7;  // ~ Extended
  cCastDe        = cCast + 8;  // ~ Extended
  cCastDateTime  = cCast + 9;  // ~ TDateTime
  cCastDate      = cCast + 10; // ~ TDateTime, only Date
  cCastTime      = cCast + 11; // ~ TDateTime, only Time

type

  TSliceDateTime = cCastDateTime .. cCastTime; // DateTime, only Date, only Time

  { Fits Standard. Each 80-character header keyword record shall consist of
    a keyword name, a value indicator (only required if a value is present),
    an optional value, and an optional comment.

    Card.Value contains only one! value: string, Boolean, Int64, Extended
    or TDateTime, ie this simple analog of the type Variant }

  TCard = record
    Keyword: string;
    ValueIndicate: Boolean;
    Value: record
      Str: string;
      Bol: Boolean;
      Int: Int64;
      Ext: Extended;
      Dtm: TDateTime;
    end;
    NoteIndicate: Boolean;
    Note: string;
  end;

  // Just a wrapper, no checks

  function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: string;
                  NoteIndicate: Boolean; const Note: string): TCard; overload;
  function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: Boolean;
                  NoteIndicate: Boolean; const Note: string): TCard; overload;
  function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: Int64;
                  NoteIndicate: Boolean; const Note: string): TCard; overload;
  function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: Extended;
                  NoteIndicate: Boolean; const Note: string): TCard; overload;
  function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: TDateTime;
                  NoteIndicate: Boolean; const Note: string): TCard; overload;

type

  TFmtShortDate = (yymmdd, ddmmyy); // Fits format short date ~ yymmdd

  TFmtRepCoord = (coWhole, coParts); // G.(g) or GG MM SS.(s)
  TFmtMeaCoord = (coDegree, coHour); // DDD:MM:SS.(s) or HH:MM:SS.(s)

  { Format equatorial coordinate system (Ra, De). Fits standard:
    Ra in [coHour, coParts], De in [coDegree, coParts]
    |------|------------------------|----------------------------|
    |      |  Ra                    | De                         |
    |------|------------------------|----------------------------|
    | Fits | HH:MM:SS.(s)  | 0..24  | +/-DD:MM:SS.(s) | -90..+90 |
    |  ~   | HH.(h)        | 0..24  | +/-DD.(d)       | -90..+90 |
    |  ~   | DDD:MM:SS.(s) | 0..360 | +/-DD:MM:SS.(s) | -90..+90 |
    |  ~   | DDD.(d)       | 0..360 | +/-DD.(d)       | -90..+90 |
    |------------------------------------------------------------| }

  { Formatting options header lines: additional parameters when parsing
    the header lines }

  PFormatLine = ^TFormatLine;
  TFormatLine = record
    vaStr: record
      wWidth: ShortInt;             // default = -cWidthLineValue ~ <text >
      wWidthQuoteInside: ShortInt;  // default = -cWidthLineValueQuote ~ 'text '
    end;
    vaBol: record
      wWidth: ShortInt;             // default = cWidthLineValue ~ < text>
    end;
    vaInt: record
      wWidth: ShortInt;             // default = cWidthLineValue ~ < text>
      wSign: Boolean;               // default = False
      wFmt: string;                 // see Format function; default = '%d'
    end;
    vaFloat: record
      wWidth: ShortInt;             // default = cWidthLineValue ~ < text>
      wSign: Boolean;               // default = False
      wFmt: string;                 // see Format function; default = '%g'
    end;
    vaDateTime: record
      rFmtShortDate: TFmtShortDate; // used as a prompt when reading short date format; default = yymmdd
      wWidth: ShortInt;             // default = -cWidthLineValue ~ <text >
      wWidthQuoteInside: ShortInt;  // default = -cWidthLineValueQuote ~ <text >
    end;
    vaCoord: record
      rFmtMeaRa: TFmtMeaCoord;     // used as a prompt when reading Ra (Equatorial coordinate system); default = coHour
      wWidth: ShortInt;            // default = -cWidthLineValue ~ <text >, used Abs(cWidthLineValue) for coDec representation
      wWidthQuoteInside: ShortInt; // default = -cWidthLineValueQuote ~ <text >
      wPrecRa: Word;               // in [degree], '%.(wPrecRa)f'; default = 4 ~ hh:mm:ss.ss, ie (0.1")
      wPrecDe: Word;               // in [degree], '%.(wPrecDe)f'; default = 4 ~ dd:mm:ss.s, ie (0.1")
      wFmtMeaRa: TFmtMeaCoord;     // default = coHour
      wFmtRepCoord: TFmtRepCoord;  // default = coParts
    end;
  end;

  function FormatLineDefault: TFormatLine;

  { String }

  function IfThen(AValue: Boolean; const ATrue: string; const AFalse: string = ''): string; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;

type

  { Picture frame histogram }

  PHistogramBucket = ^THistogramBucket;
  THistogramBucket = record
    Elem: Extended;
    Freq: Integer;
  end;
  THistogramBuckets = array of PHistogramBucket;

  THistogramIndexRange = record
    Black: Integer;
    White: Integer;
  end;

const

  cHistogramMaxQuota = 1024 * 1024; // maximum pixel sample size
  cHistogramMaxCount  =  50 * 1000; // maximum bucket size, eq ~586 kb

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

  TPaletteIndexs = array of array of Byte;

type

  { Picture frame pixel map }

  TPixmap = record
    Pix: TPaletteIndexs;
    Map: TPaletteTuples;
  end;

const

  { Picture frame band: opeartor "pixel value -> palette index" }

  cFrameBandCount = cPaletteCount;

type

  TFrameBand = array [0 .. cFrameBandCount - 1] of Extended;

type

  { Picture frame geometry }

  TMatrix = array [1 .. 3, 1 .. 3] of Double;

  TPix = record
    X, Y: Integer;
  end;

  TPnt = record
    X, Y: Double;
  end;

  TDesignPoint = (xy00, xyLT, xyRT, xyRB, xyLB, xyCC);
  TDesignShift = (xyLTat00, xyRTat00, xyRBat00, xyLBat00, xyCCat00);

  function ToPnt(const X, Y: Double): TPnt;
  function ToPix(const X, Y: Integer): TPix;

type

  TRegion = record
    X1, Y1: Integer;
    Width, Height: Integer;
  end;

  function ToRegion(X1, Y1: Integer; Width, Height: Integer): TRegion;

type

  TBound = record
    Xmin: Integer;
    Ymin: Integer;
    Xmax: Integer;
    Ymax: Integer;
    Xcount: Integer;
    Ycount: Integer;
  end;

  function ToBound(const Region: TRegion): TBound;

type

  TPntsQuad = array [1 .. 4] of TPnt;
  TQuad = record
    case Integer of
      0: (X1, Y1, X2, Y2, X3, Y3, X4, Y4: Double);
      1: (P1, P2, P3, P4: TPnt);
      2: (PA: TPntsQuad);
  end;

  function ToQuad(const X1, Y1, X2, Y2, X3, Y3, X4, Y4: Double): TQuad; overload;
  function ToQuad(const Region: TRegion): TQuad; overload;

type

  TPntsClip = array [1 .. 8] of TPnt;
  TClip = record
    PN: Integer;
    case Integer of
      0: (X1, Y1, X2, Y2, X3, Y3, X4, Y4, X5, Y5, X6, Y6, X7, Y7, X8, Y8: Double);
      1: (P1, P2, P3, P4, P5, P6, P7, P8: TPnt);
      2: (PA: TPntsClip);
  end;

  function ToClip(const XA, YA: array of Double): TClip;

const

  { The base class of exceptions and their codes }

  ERROR_FITS    = 1000;
  ERROR_NULL    = 1001;
  ERROR_UNKNOWN = 1002;

resourcestring

  SAssertionFailure = 'DeLaFits assertion failure';

type

  EFitsException = class(Exception)
  private
    FCode: Integer;
  public
    constructor Create(const AMsg: string; ACode: Integer);
    constructor CreateFmt(const AMsg: string; const Args: array of const; ACode: Integer); overload;
    constructor CreateFmt(const AMsg: string; const Args: array of const; const EMsg: string; ACode: Integer); overload;
    property Code: Integer read FCode;
  end;

implementation

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
    Result := sysLE
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

function BitPixToInt(Value: TBitPix): Integer;
begin
  case Value of
    bi64f: Result := -64;
    bi32f: Result := -32;
    bi08u: Result :=  08;
    bi16c: Result :=  16;
    bi32c: Result :=  32;
    bi64c: Result :=  64;
    else   Result :=  00;
  end;
end;

function IntToBitPix(Value: Integer): TBitPix;
begin
  case Value of
    -64: Result := bi64f;
    -32: Result := bi32f;
     08: Result := bi08u;
     16: Result := bi16c;
     32: Result := bi32c;
     64: Result := bi64c;
    else Result := biUnknown;
  end;
end;

function BitPixToRep(Value: TBitPix): TRepNumber;
begin
  case Value of
    bi64f: Result := rep64f;
    bi32f: Result := rep32f;
    bi08u: Result := rep08u;
    bi16c: Result := rep16c;
    bi32c: Result := rep32c;
    bi64c: Result := rep64c;
    else   Result := repUnknown;
  end;
end;

function BitPixSize(Value: TBitPix): Byte;
begin
  case Value of
    bi64f: Result := 8;
    bi32f: Result := 4;
    bi08u: Result := 1;
    bi16c: Result := 2;
    bi32c: Result := 4;
    bi64c: Result := 8;
    else   Result := 0;
  end;
end;

function BitPixSize(Value: Integer): Byte;
var
  BitPix: TBitPix;
begin
  BitPix := IntToBitPix(Value);
  Result := BitPixSize(BitPix);
end;

{ TCard }

function EmptyCard(const Keyword: string; ValueIndicate: Boolean;
  NoteIndicate: Boolean; const Note: string): TCard;
begin
  Result.Keyword := Keyword;
  Result.ValueIndicate := ValueIndicate;
  with Result.Value do
  begin
    Str := '';
    Bol := False;
    Int := 0;
    Ext := 0.0;
    Dtm := Now;
  end;
  Result.NoteIndicate := NoteIndicate;
  Result.Note := Note;
end;

function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: string;
  NoteIndicate: Boolean; const Note: string): TCard; overload;
begin
  Result := EmptyCard(Keyword, ValueIndicate, NoteIndicate, Note);
  Result.Value.Str := Value;
end;

function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: Boolean;
  NoteIndicate: Boolean; const Note: string): TCard; overload;
begin
  Result := EmptyCard(Keyword, ValueIndicate, NoteIndicate, Note);
  Result.Value.Bol := Value;
end;

function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: Int64;
  NoteIndicate: Boolean; const Note: string): TCard; overload;
begin
  Result := EmptyCard(Keyword, ValueIndicate, NoteIndicate, Note);
  Result.Value.Int := Value;
end;

function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: Extended;
  NoteIndicate: Boolean; const Note: string): TCard; overload;
begin
  Result := EmptyCard(Keyword, ValueIndicate, NoteIndicate, Note);
  Result.Value.Ext := Value;
end;

function ToCard(const Keyword: string; ValueIndicate: Boolean; Value: TDateTime;
  NoteIndicate: Boolean; const Note: string): TCard; overload;
begin
  Result := EmptyCard(Keyword, ValueIndicate, NoteIndicate, Note);
  Result.Value.Dtm := Value;
end;

{ TFormatLine }

function FormatLineDefault: TFormatLine;
begin
  with Result do
  begin
    vaStr.wWidth := -cWidthLineValue;
    vaStr.wWidthQuoteInside := -cWidthLineValueQuote;
    vaBol.wWidth := cWidthLineValue;
    vaInt.wWidth := cWidthLineValue;
    vaInt.wSign := False;
    vaInt.wFmt := '%d';
    vaFloat.wWidth := cWidthLineValue;
    vaFloat.wSign := False;
    vaFloat.wFmt := '%g';
    vaDateTime.rFmtShortDate := yymmdd;
    vaDateTime.wWidth := -cWidthLineValue;
    vaDateTime.wWidthQuoteInside := -cWidthLineValueQuote;
    vaCoord.rFmtMeaRa := coHour;
    vaCoord.wWidth := -cWidthLineValue;
    vaCoord.wWidthQuoteInside := -cWidthLineValueQuote;
    vaCoord.wPrecRa := 4;
    vaCoord.wPrecDe := 4;
    vaCoord.wFmtMeaRa := coHour;
    vaCoord.wFmtRepCoord := coParts;
  end;
end;

{ String }

function IfThen(AValue: Boolean; const ATrue: string; const AFalse: string = ''): string; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

{ Picture frame geometry }

function ToPnt(const X, Y: Double): TPnt;
begin
  Result.X := X;
  Result.Y := Y;
end;

function ToPix(const X, Y: Integer): TPix;
begin
  Result.X := X;
  Result.Y := Y;
end;

function ToRegion(X1, Y1: Integer; Width, Height: Integer): TRegion;
begin
  Assert((Width >= 0) and (Height >= 0), SAssertionFailure);
  Result.X1 := X1;
  Result.Y1 := Y1;
  Result.Width := Width;
  Result.Height := Height;
end;

function ToBound(const Region: TRegion): TBound;
begin
  Assert((Region.Width >= 0) and (Region.Height >= 0), SAssertionFailure);
  Result.Xmin   := Region.X1;
  Result.Ymin   := Region.Y1;
  Result.Xmax   := Region.X1 + Region.Width - 1;
  Result.Ymax   := Region.Y1 + Region.Height - 1;
  Result.Xcount := Region.Width;
  Result.Ycount := Region.Height;
end;

function ToQuad(const X1, Y1, X2, Y2, X3, Y3, X4, Y4: Double): TQuad; overload;
begin
  Result.X1 := X1;
  Result.Y1 := Y1;
  Result.X2 := X2;
  Result.Y2 := Y2;
  Result.X3 := X3;
  Result.Y3 := Y3;
  Result.X4 := X4;
  Result.Y4 := Y4;
end;

function ToQuad(const Region: TRegion): TQuad; overload;
var
  dx, dy: Integer;
begin
  dx := Region.Width;
  dy := Region.Height;
  with Region do
  begin
    Result.P1 := ToPnt(X1, Y1);
    Result.P2 := ToPnt(X1 + dx, Y1);
    Result.P3 := ToPnt(X1 + dx, Y1 + dy);
    Result.P4 := ToPnt(X1, Y1 + dy);
  end;
end;

function ToClip(const XA, YA: array of Double): TClip;
var
  I: Integer;
begin
  Assert(Length(XA) = Length(YA), SAssertionFailure);
  Result.PN := Length(XA);
  for I := 1 to Result.PN do
  begin
    Result.PA[I].X := XA[I - 1];
    Result.PA[I].Y := YA[I - 1];
  end;
end;

{ EFitsException }

constructor EFitsException.Create(const AMsg: string; ACode: Integer);
var
  Msg: string;
begin
  FCode := ACode;
  Msg := Format('%s %.4d', [cDeLaFits, FCode]);
  Msg := Msg + IfThen(AMsg = '', '', ', ' + AMsg);
  inherited Create(Msg);
end;

constructor EFitsException.CreateFmt(const AMsg: string; const Args: array of const; ACode: Integer);
var
  Msg: string;
begin
  Msg := Format(AMsg, Args);
  Create(Msg, ACode);
end;

constructor EFitsException.CreateFmt(const AMsg: string; const Args: array of const; const EMsg: string; ACode: Integer);
var
  Msg: string;
begin
  Msg := Format(AMsg, Args);
  Msg := Msg + IfThen(Msg = '', '.', '');
  Msg := Msg + IfThen(Msg[Length(Msg)] = '.', '', '.');
  Msg := Msg + IfThen(EMsg = '', '', sLineBreak + EMsg);
  Create(Msg, ACode);
end;

end.
