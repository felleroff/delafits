{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{               Standard IMAGE extension               }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsImage;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Classes, Math, DeLaFitsCommon, DeLaFitsMath, DeLaFitsString,
  DeLaFitsProp, DeLaFitsClasses, DeLaFitsSerialize;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_IMAGE                               = 7000;

  ERROR_IMAGESPEC_CHECKITEM_NO_OBJECT       = 7100;
  ERROR_IMAGESPEC_CHECKITEM_OBJECT          = 7101;
  ERROR_IMAGESPEC_SETBITPIX_VALUE           = 7102;
  ERROR_IMAGESPEC_SETNAXIS_VALUE            = 7103;
  ERROR_IMAGESPEC_GETNAXES_INDEX            = 7104;
  ERROR_IMAGESPEC_SETNAXES_INDEX            = 7105;
  ERROR_IMAGESPEC_SETNAXES_VALUE            = 7106;
  ERROR_IMAGESPEC_SETBSCALE_VALUE           = 7107;
  ERROR_IMAGESPEC_SETBZERO_VALUE            = 7108;

  ERROR_IMAGEHEAD_CUSTOMIZENEW_BITPIX_VALUE = 7200;
  ERROR_IMAGEHEAD_CUSTOMIZENEW_NAXIS_VALUE  = 7201;
  ERROR_IMAGEHEAD_CUSTOMIZENEW_NAXES_VALUE  = 7202;
  ERROR_IMAGEHEAD_CUSTOMIZENEW_PCOUNT_VALUE = 7203;
  ERROR_IMAGEHEAD_CUSTOMIZENEW_GCOUNT_VALUE = 7204;
  ERROR_IMAGEHEAD_CUSTOMIZENEW_BSCALE_VALUE = 7205;
  ERROR_IMAGEHEAD_CUSTOMIZENEW_BZERO_VALUE  = 7206;

  ERROR_IMAGEDATA_GETVALUE_INDEX            = 7300;
  ERROR_IMAGEDATA_SETVALUE_INDEX            = 7301;
  ERROR_IMAGEDATA_GETVALUES_BOUNDS          = 7302;
  ERROR_IMAGEDATA_SETVALUES_BOUNDS          = 7303;
  ERROR_IMAGEDATA_SETVALUES_CAPACITY        = 7304;

  ERROR_IMAGE_CREATENEW_INVALID_CLASS_SPEC  = 7400;
  ERROR_IMAGE_GETNAXES_VALUE                = 7401;
  ERROR_IMAGE_GETPCOUNT_VALUE               = 7402;
  ERROR_IMAGE_GETGCOUNT_VALUE               = 7403;
  ERROR_IMAGE_GETBSCALE_VALUE               = 7404;
  ERROR_IMAGE_GETBZERO_VALUE                = 7405;

resourcestring

  { The messages of exceptions }

  SImageDataValuesBlockOutBounds   = 'Block "INDEX=%d;COUNT=%d" is out of physical value array bounds "COUNT=%d"';
  SImageDataValuesIndexOutBounds   = 'Index "%d" is out of physical value array bounds "COUNT=%d"';
  SImageDataValuesLowArrayCapacity = 'The array capacity "%d" is not enough to contain "%d" physical values';

type

  TFitsImage = class;

  { TFitsImageSpec: specification to create a new IMAGE }

  EFitsImageSpecException = class(EFitsItemSpecException)
  protected
    function GetTopic: string; override;
  end;

  TFitsImageSpec = class(TFitsItemSpec)
  private
    procedure SetBITPIX(AValue: TBitPix);
    function GetNAXIS: Integer;
    procedure SetNAXIS(AValue: Integer);
    procedure CheckAxesBounds(AProp: IFitsPropContext; ACodeError: Integer);
    function GetNAXES(ANumber: Integer): Integer;
    procedure SetNAXES(ANumber: Integer; AValue: Integer);
    function GetPCOUNT: Integer;
    function GetGCOUNT: Integer;
    procedure SetBSCALE(const AValue: Extended);
    procedure SetBZERO(const AValue: Extended);
    function GetValueType: TNumberType;
    procedure SetValueType(AValue: TNumberType);
    function GetAxesCount: Integer;
    procedure SetAxesCount(AValue: Integer);
    function GetAxesLength(ANumber: Integer): Integer;
    procedure SetAxesLength(ANumber: Integer; AValue: Integer);
  protected
    FBITPIX: TBitPix;
    FNAXES: array of Integer;
    FBSCALE: Extended;
    FBZERO: Extended;
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure CheckItem(AItem: TFitsItem); virtual;
    function ExtractBITPIX(AItem: TFitsItem): TBitPix; virtual;
    function ExtractNAXIS(AItem: TFitsItem): Integer; virtual;
    function ExtractNAXES(AItem: TFitsItem; ANumber: Integer): Integer; virtual;
    function ExtractBSCALE(AItem: TFitsItem): Extended; virtual;
    function ExtractBZERO(AItem: TFitsItem): Extended; virtual;
    procedure DoSetBITPIX(AProp: IBITPIX); virtual;
    procedure DoSetNAXIS(AProp: INAXIS); virtual;
    procedure DoSetNAXES(AProp: INAXES); virtual;
    procedure DoSetBSCALE(AProp: IBSCALE); virtual;
    procedure DoSetBZERO(AProp: IBZERO); virtual;
  public
    constructor Create(AItem: TFitsItem);
    constructor CreateNew(ABITPIX: TBitPix; const ANAXES: array of Integer; const ABSCALE: Extended = 1.0; const ABZERO: Extended = 0.0); overload;
    constructor CreateNew(AValueType: TNumberType; const AAxesLength: array of Integer); overload;
    // Standard properties
    property BITPIX: TBitPix read FBITPIX write SetBITPIX;
    property NAXIS: Integer read GetNAXIS write SetNAXIS;
    property NAXES[Number: Integer]: Integer read GetNAXES write SetNAXES;
    property PCOUNT: Integer read GetPCOUNT;
    property GCOUNT: Integer read GetGCOUNT;
    property BSCALE: Extended read FBSCALE write SetBSCALE;
    property BZERO: Extended read FBZERO write SetBZERO;
    // Synonyms for standard properties
    property ValueType: TNumberType read GetValueType write SetValueType;
    property AxesCount: Integer read GetAxesCount write SetAxesCount;
    property AxesLength[Number: Integer]: Integer read GetAxesLength write SetAxesLength;
  end;

  { TFitsImageHead: IMAGE header section }

  EFitsImageHeadException = class(EFitsItemHeadException)
  protected
    function GetTopic: string; override;
  end;

  TFitsImageHead = class(TFitsItemHead)
  private
    function GetItem: TFitsImage;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure CustomizeNew(ASpec: TFitsItemSpec); override;
  public
    property Item: TFitsImage read GetItem;
  end;

  { TValueInfo [nested]: IMAGE data value type information }

  TValueInfo = record
    BitPix: TBitPix;
    BScale: Extended;
    BZero: Extended;
  end;

  { TFitsImageData: IAMGE data section }

  EFitsImageDataException = class(EFitsItemDataException)
  protected
    function GetTopic: string; override;
  end;

  TFitsImageData = class(TFitsItemData)
  private
    function GetItem: TFitsImage;
    function GetBScale: Extended;
    function GetBZero: Extended;
    function GetValueInfo: TValueInfo;
    function GetValueType: TNumberType;
    procedure CheckValues(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
    function GetValue(AIndex: Int64): Extended;
    procedure SetValue(AIndex: Int64; const AValue: Extended);
    procedure GetValues(const AIndex, ACount: Int64; var AValues: TSerializeArray; AValuesType: TValuesType);
    procedure SetValues(const AIndex, ACount: Int64; const AValues: TSerializeArray; AValuesType: TValuesType);
    function GetValueCount: Int64;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
  public
    // Read an array of physical values
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA80f); overload;
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA64f); overload;
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA32f); overload;
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA08c); overload;
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA08u); overload;
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA16c); overload;
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA16u); overload;
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA32c); overload;
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA32u); overload;
    procedure ReadValues(const AIndex, ACount: Int64; var AValues: TA64c); overload;
    // Write an array of physical values
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA80f); overload;
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA64f); overload;
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA32f); overload;
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA08c); overload;
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA08u); overload;
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA16c); overload;
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA16u); overload;
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA32c); overload;
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA32u); overload;
    procedure WriteValues(const AIndex, ACount: Int64; const AValues: TA64c); overload;
    property Item: TFitsImage read GetItem;
    property BScale: Extended read GetBScale;
    property BZero: Extended read GetBZero;
    property ValueType: TNumberType read GetValueType;
    property ValueCount: Int64 read GetValueCount;
    property Values[Index: Int64]: Extended read GetValue write SetValue; default;
  end;

  { TFitsImage: standard IMAGE extension }

  EFitsImageException = class(EFitsItemException)
  protected
    function GetTopic: string; override;
  end;

  TFitsImage = class(TFitsItem)
  private
    function GetHead: TFitsImageHead;
    function GetData: TFitsImageData;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    function GetHeadClass: TFitsItemHeadClass; override;
    function GetDataClass: TFitsItemDataClass; override;
    procedure DoGetNAXES(AProp: INAXES); override;
    procedure DoGetPCOUNT(AProp: IPCOUNT); override;
    procedure DoGetGCOUNT(AProp: IGCOUNT); override;
    procedure DoGetBSCALE(AProp: IBSCALE); virtual;
    procedure DoGetBZERO(AProp: IBZERO); virtual;
  public
    constructor CreateNew(AContainer: TFitsContainer; ASpec: TFitsItemSpec); override;
    class function ExtensionTypeIs(AItem: TFitsItem): Boolean; override;
    function GetBSCALE: Extended;
    function GetBZERO: Extended;
    property Head: TFitsImageHead read GetHead;
    property Data: TFitsImageData read GetData;
  end;

implementation

{ Linear scale the array pixel values }

function CalcLinearType(const AValueInfo: TValueInfo): TLinearType; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  if (AValueInfo.BScale = 1.0) and (AValueInfo.BZero = 0.0) then
    Result := linearPlain
  else if (AValueInfo.BitPix = bi08u) and (AValueInfo.BScale = 1.0) and (AValueInfo.BZero = cZero08c) then
    Result := linearShift
  else if (AValueInfo.BitPix = bi16c) and (AValueInfo.BScale = 1.0) and (AValueInfo.BZero = cZero16u) then
    Result := linearShift
  else if (AValueInfo.BitPix = bi32c) and (AValueInfo.BScale = 1.0) and (AValueInfo.BZero = cZero32u) then
    Result := linearShift
  else
    Result := linearScale;
end;

{ Calculate the recommended type of physical values }

function CalcValueType(const AValueInfo: TValueInfo): TNumberType;

  function Choose(const AValueInfo: TValueInfo; const ANumbers: array of TNumberType): TNumberType;
  var
    LMin, LMax: Extended;
    LNumberPix: TNumberType;
    LLinearInteger: Boolean;
    LIndex: Integer;
  begin
    case AValueInfo.BitPix of
      bi64f: LNumberPix := num64f;
      bi32f: LNumberPix := num32f;
      bi08u: LNumberPix := num08u;
      bi16c: LNumberPix := num16c;
      bi32c: LNumberPix := num32c;
      bi64c: LNumberPix := num64c;
    else     LNumberPix := numUnknown;
    end;
    LMin := GetMinNumber(LNumberPix) * AValueInfo.BScale + AValueInfo.BZero;
    LMax := GetMaxNumber(LNumberPix) * AValueInfo.BScale + AValueInfo.BZero;
    Arrange(LMin, LMax);
    LLinearInteger := (AValueInfo.BitPix >= bi08u) and (Frac(AValueInfo.BScale) = 0.0) and (Frac(AValueInfo.BZero) = 0.0);
    Result := numUnknown;
    for LIndex := Low(ANumbers) to High(ANumbers) do
    begin
      Result := ANumbers[LIndex];
      if NumberIsInteger(Result) and not LLinearInteger then
        Continue;
      if (LMin >= GetMinNumber(Result)) and (LMax <= GetMaxNumber(Result)) then
        Break;
    end;
  end;

var
  LLinearType: TLinearType;
begin
  LLinearType := CalcLinearType(AValueInfo);
  Result := numUnknown;
  case AValueInfo.BitPix of
    bi64f:
      case LLinearType of
        linearPlain: Result := num64f;
        linearScale: Result := num80f;
      end;
    bi32f:
      case LLinearType of
        linearPlain: Result := num32f;
        linearScale: Result := Choose(AValueInfo, [num64f, num80f]);
      end;
    bi08u:
      case LLinearType of
        linearPlain: Result := num08u;
        linearShift: Result := num08c;
        linearScale: Result := Choose(AValueInfo, [num08c, num16c, num16u, num32c, num32u, num64c, num32f, num64f, num80f]);
      end;
    bi16c:
      case LLinearType of
        linearPlain: Result := num16c;
        linearShift: Result := num16u;
        linearScale: Result := Choose(AValueInfo, [num16u, num32c, num32u, num64c, num32f, num64f, num80f]);
      end;
    bi32c:
      case LLinearType of
        linearPlain: Result := num32c;
        linearShift: Result := num32u;
        linearScale: Result := Choose(AValueInfo, [num32u, num64c, num32f, num64f, num80f]);
      end;
    bi64c:
      case LLinearType of
        linearPlain: Result := num64c;
        linearScale: Result := Choose(AValueInfo, [num32f, num64f, num80f]);
      end;
  end;
end;

{ Number array }

function GetArrayLength(const AArray: Pointer): Int64; {$IFDEF HAS_INLINE} inline; {$ENDIF}
type
  TArray = array of Byte;
begin
  Result := Length(TArray(AArray));
end;

procedure SetArrayLength(var AArray: Pointer; AType: TNumberType; const ANewLength: Int64); {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  case AType of
    num80f: SetLength(TA80f(AArray), ANewLength);
    num64f: SetLength(TA64f(AArray), ANewLength);
    num32f: SetLength(TA32f(AArray), ANewLength);
    num08c: SetLength(TA08c(AArray), ANewLength);
    num08u: SetLength(TA08u(AArray), ANewLength);
    num16c: SetLength(TA16c(AArray), ANewLength);
    num16u: SetLength(TA16u(AArray), ANewLength);
    num32c: SetLength(TA32c(AArray), ANewLength);
    num32u: SetLength(TA32u(AArray), ANewLength);
    num64c: SetLength(TA64c(AArray), ANewLength);
  end;
end;

{ Header prop }

function CorrectBITPIX(AValue: TBitPix): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := (AValue > Low(TBitPix)) and (AValue <= High(TBitPix));
end;

function CorrectNAXIS(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
const
  cMinAxis = 0;
begin
  Result := InRange(AValue, cMinAxis, cMaxAxis);
end;

type
  TFitsNAXES = class(DeLaFitsProp.TFitsNAXES)
  protected
    function NewLineNote: string; override;
  end;

function TFitsNAXES.NewLineNote: string;
begin
  Result := Format('Number of pixels along axis %d', [FKeywordNumber]);
end;

function DefaultNAXES: Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := 1;
end;

function CorrectNAXES(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue > 0;
end;

function DefaultPCOUNT: Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_7.1.1] Mandatory keywords ... PCOUNT keyword.
  // The value field shall contain the integer 0
  Result := 0;
end;

function CorrectPCOUNT(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue = DefaultPCOUNT;
end;

function DefaultGCOUNT: Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_7.1.1] Mandatory keywords ... GCOUNT keyword.
  // The value field shall contain the integer 1; each IMAGE extension
  // contains a single array
  Result := 1;
end;

function CorrectGCOUNT(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue = DefaultGCOUNT;
end;

function DefaultBSCALE: Extended; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_4.4.2.5] Keywords that describe arrays ...
  // BSCALE keyword. The default value for this keyword is 1.0
  Result := 1.0;
end;

function CorrectBSCALE(const AValue: Extended): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := not (IsNan(AValue) or (AValue = Infinity) or (AValue = NegInfinity) or IsZero(AValue));
end;

function DefaultBZERO: Extended; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_4.4.2.5] Keywords that describe arrays ...
  // BZERO keyword. The default value for this keyword is 0.0
  Result := 0.0;
end;

function CorrectBZERO(const AValue: Extended): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := not (IsNan(AValue) or (AValue = Infinity) or (AValue = NegInfinity));
end;

{ EFitsImageSpecException }

function EFitsImageSpecException.GetTopic: string;
begin
  Result := 'IMAGESPEC';
end;

{ TFitsImageSpec }

function TFitsImageSpec.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsImageSpecException;
end;

procedure TFitsImageSpec.CheckItem(AItem: TFitsItem);
begin
  if not Assigned(AItem) then
    Error(SItemNotAssigned, ERROR_IMAGESPEC_CHECKITEM_NO_OBJECT);
  if not TFitsImage.ExtensionTypeIs(AItem) then
    Error(SSpecInvalidItem, ERROR_IMAGESPEC_CHECKITEM_OBJECT);
end;

function TFitsImageSpec.ExtractBITPIX(AItem: TFitsItem): TBitPix;
begin
  Result := AItem.GetBITPIX;
end;

procedure TFitsImageSpec.DoSetBITPIX(AProp: IBITPIX);
begin
  if not CorrectBITPIX(AProp.Value) then
    Error(SSpecIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGESPEC_SETBITPIX_VALUE);
end;

procedure TFitsImageSpec.SetBITPIX(AValue: TBitPix);
var
  LProp: IBITPIX;
begin
  LProp := TFitsBITPIX.CreateValue(AValue);
  DoSetBITPIX(LProp);
  FBITPIX := LProp.Value;
end;

function TFitsImageSpec.ExtractNAXIS(AItem: TFitsItem): Integer;
begin
  Result := AItem.GetNAXIS;
end;

function TFitsImageSpec.GetNAXIS: Integer;
begin
  Result := Length(FNAXES);
end;

procedure TFitsImageSpec.DoSetNAXIS(AProp: INAXIS);
begin
  if not CorrectNAXIS(AProp.Value) then
    Error(SSpecIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGESPEC_SETNAXIS_VALUE);
end;

procedure TFitsImageSpec.SetNAXIS(AValue: Integer);
var
  LProp: INAXIS;
  LCurValue, LIndex: Integer;
begin
  LCurValue := NAXIS;
  LProp := TFitsNAXIS.CreateValue(AValue);
  DoSetNAXIS(LProp);
  if LProp.Value <> LCurValue then
  begin
    SetLength(FNAXES, LProp.Value);
    for LIndex := LCurValue to LProp.Value - 1 do
      FNAXES[LIndex] := DefaultNAXES;
  end;
end;

procedure TFitsImageSpec.CheckAxesBounds(AProp: IFitsPropContext; ACodeError: Integer);
begin
  if not InRange(AProp.KeywordNumber, 1, NAXIS) then
    Error(SPropAxisOutBounds, [AProp.Keyword, NAXIS], ACodeError);
end;

function TFitsImageSpec.ExtractNAXES(AItem: TFitsItem; ANumber: Integer): Integer;
begin
  Result := AItem.GetNAXES(ANumber);
end;

function TFitsImageSpec.GetNAXES(ANumber: Integer): Integer;
var
  LProp: INAXES;
begin
  LProp := TFitsNAXES.Create(ANumber);
  CheckAxesBounds(LProp, ERROR_IMAGESPEC_GETNAXES_INDEX);
  Result := FNAXES[ANumber - 1];
end;

procedure TFitsImageSpec.DoSetNAXES(AProp: INAXES);
begin
  if not CorrectNAXES(AProp.Value) then
    Error(SSpecIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGESPEC_SETNAXES_VALUE);
end;

procedure TFitsImageSpec.SetNAXES(ANumber: Integer; AValue: Integer);
var
  LProp: INAXES;
begin
  LProp := TFitsNAXES.CreateValue(ANumber, AValue);
  CheckAxesBounds(LProp, ERROR_IMAGESPEC_SETNAXES_INDEX);
  DoSetNAXES(LProp);
  FNAXES[LProp.KeywordNumber - 1] := LProp.Value;
end;

function TFitsImageSpec.GetPCOUNT: Integer;
begin
  Result := DefaultPCOUNT;
end;

function TFitsImageSpec.GetGCOUNT: Integer;
begin
  Result := DefaultGCOUNT;
end;

function TFitsImageSpec.ExtractBSCALE(AItem: TFitsItem): Extended;
var
  LProp: IBSCALE;
begin
  if AItem is TFitsImage then
    Result := (AItem as TFitsImage).GetBSCALE
  else
  begin
    LProp := TFitsBSCALE.Create;
    if ExtractProp(AItem, LProp) then
      Result := LProp.Value
    else
      Result := DefaultBSCALE;
  end;
end;

procedure TFitsImageSpec.DoSetBSCALE(AProp: IBSCALE);
begin
  if not CorrectBSCALE(AProp.Value) then
    Error(SSpecIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGESPEC_SETBSCALE_VALUE);
end;

procedure TFitsImageSpec.SetBSCALE(const AValue: Extended);
var
  LProp: IBSCALE;
begin
  LProp := TFitsBSCALE.CreateValue(AValue);
  DoSetBSCALE(LProp);
  FBSCALE := LProp.Value;
end;

function TFitsImageSpec.ExtractBZERO(AItem: TFitsItem): Extended;
var
  LProp: IBZERO;
begin
  if AItem is TFitsImage then
    Result := (AItem as TFitsImage).GetBZERO
  else
  begin
    LProp := TFitsBZERO.Create;
    if ExtractProp(AItem, LProp) then
      Result := LProp.Value
    else
      Result := DefaultBZERO;
  end;
end;

procedure TFitsImageSpec.DoSetBZERO(AProp: IBZERO);
begin
  if not CorrectBZERO(AProp.Value) then
    Error(SSpecIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGESPEC_SETBZERO_VALUE);
end;

procedure TFitsImageSpec.SetBZERO(const AValue: Extended);
var
  LProp: IBZERO;
begin
  LProp := TFitsBZERO.CreateValue(AValue);
  DoSetBZERO(LProp);
  FBZERO := LProp.Value;
end;

function TFitsImageSpec.GetValueType: TNumberType;
var
  LValueInfo: TValueInfo;
begin
  LValueInfo.BitPix := BITPIX;
  LValueInfo.BScale := BSCALE;
  LValueInfo.BZero := BZERO;
  Result := CalcValueType(LValueInfo);
end;

procedure TFitsImageSpec.SetValueType(AValue: TNumberType);
begin
  BITPIX := NumberTypeToBitPix(AValue);
  BSCALE := DefaultBSCALE;
  BZERO := NumberTypeToTypicalZero(AValue);
end;

function TFitsImageSpec.GetAxesCount: Integer;
begin
  Result := NAXIS;
end;

procedure TFitsImageSpec.SetAxesCount(AValue: Integer);
begin
  NAXIS := AValue;
end;

function TFitsImageSpec.GetAxesLength(ANumber: Integer): Integer;
begin
  Result := NAXES[ANumber];
end;

procedure TFitsImageSpec.SetAxesLength(ANumber: Integer; AValue: Integer);
begin
  NAXES[ANumber] := AValue;
end;

constructor TFitsImageSpec.Create(AItem: TFitsItem);
var
  LNumber: Integer;
begin
  inherited Create;
  CheckItem(AItem);
  BITPIX := ExtractBITPIX(AItem);
  NAXIS := ExtractNAXIS(AItem);
  for LNumber := 1 to NAXIS do
    NAXES[LNumber] := ExtractNAXES(AItem, LNumber);
  BSCALE := ExtractBSCALE(AItem);
  BZERO := ExtractBZERO(AItem);
end;

constructor TFitsImageSpec.CreateNew(ABITPIX: TBitPix; const ANAXES: array of Integer; const ABSCALE, ABZERO: Extended);
var
  LNumber: Integer;
begin
  inherited Create;
  BITPIX := ABITPIX;
  NAXIS := Length(ANAXES);
  for LNumber := 1 to NAXIS do
    NAXES[LNumber] := ANAXES[LNumber - 1];
  BSCALE := ABSCALE;
  BZERO := ABZERO;
end;

constructor TFitsImageSpec.CreateNew(AValueType: TNumberType; const AAxesLength: array of Integer);
var
  LBitPix: TBitPix;
  LBScale, LBZero: Extended;
begin
  LBitPix := NumberTypeToBitPix(AValueType);
  LBScale := DefaultBSCALE;
  LBZero := NumberTypeToTypicalZero(AValueType);
  CreateNew(LBitPix, AAxesLength, LBScale, LBZero);
end;

{ EFitsImageHeadException }

function EFitsImageHeadException.GetTopic: string;
begin
  Result := 'IMAGEHEAD';
end;

{ TFitsImageHead }

function TFitsImageHead.GetItem: TFitsImage;
begin
  Result := inherited Item as TFitsImage;
end;

function TFitsImageHead.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsImageHeadException;
end;

procedure TFitsImageHead.CustomizeNew(ASpec: TFitsItemSpec);

  procedure ErrorProp(AProp: IFitsPropContext; ACodeError: Integer);
  begin
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue], ACodeError);
  end;

  procedure PushProp(var ALines: string; AProp: IFitsPropContext; AAppend: Boolean = True);
  var
    LIndex: Integer;
  begin
    if AAppend then
      ALines := ALines + AProp.NewLine;
    LIndex := LineIndexOfKeyword(AProp.Keyword);
    if LIndex >= 0 then
      DeleteLines(LIndex, {ACount:} 1);
  end;

var
  LSpec: TFitsImageSpec;
  LLines: string;
  LNumber: Integer;
  LBITPIX: IBITPIX;
  LNAXIS: INAXIS;
  LNAXES: INAXES;
  LPCOUNT: IPCOUNT;
  LGCOUNT: IGCOUNT;
  LBSCALE: IBSCALE;
  LBZERO: IBZERO;
begin
  LSpec := ASpec as TFitsImageSpec;
  LLines := '';
  // BITPIX
  LBITPIX := TFitsBITPIX.CreateValue(LSpec.BITPIX);
  if not CorrectBITPIX(LBITPIX.Value) then
    ErrorProp(LBITPIX, ERROR_IMAGEHEAD_CUSTOMIZENEW_BITPIX_VALUE);
  PushProp({var} LLines, LBITPIX);
  // NAXIS
  LNAXIS := TFitsNAXIS.CreateValue(LSpec.NAXIS);
  if not CorrectNAXIS(LNAXIS.Value) then
    ErrorProp(LNAXIS, ERROR_IMAGEHEAD_CUSTOMIZENEW_NAXIS_VALUE);
  PushProp({var} LLines, LNAXIS);
  // NAXES
  for LNumber := 1 to LNAXIS.Value do
  begin
    LNAXES := TFitsNAXES.CreateValue(LNumber, LSpec.NAXES[LNumber]);
    if not CorrectNAXES(LNAXES.Value) then
      ErrorProp(LNAXES, ERROR_IMAGEHEAD_CUSTOMIZENEW_NAXES_VALUE);
    PushProp({var} LLines, LNAXES);
  end;
  // PCOUNT, keyword is not allowed in a primary array
  LPCOUNT := TFitsPCOUNT.CreateValue(LSpec.PCOUNT);
  if not CorrectPCOUNT(LPCOUNT.Value) then
    ErrorProp(LPCOUNT, ERROR_IMAGEHEAD_CUSTOMIZENEW_PCOUNT_VALUE);
  PushProp({var} LLines, LPCOUNT, {AAppend:} Item.Index > 0);
  // GCOUNT, keyword is not allowed in a primary array
  LGCOUNT := TFitsGCOUNT.CreateValue(LSpec.GCOUNT);
  if not CorrectGCOUNT(LGCOUNT.Value) then
    ErrorProp(LGCOUNT, ERROR_IMAGEHEAD_CUSTOMIZENEW_GCOUNT_VALUE);
  PushProp({var} LLines, LGCOUNT, {AAppend:} Item.Index > 0);
  // BSCALE
  LBSCALE := TFitsBSCALE.CreateValue(LSpec.BSCALE);
  if not CorrectBSCALE(LBSCALE.Value) then
    ErrorProp(LBSCALE, ERROR_IMAGEHEAD_CUSTOMIZENEW_BSCALE_VALUE);
  PushProp({var} LLines, LBSCALE);
  // BZERO
  LBZERO := TFitsBZERO.CreateValue(LSpec.BZERO);
  if not CorrectBZERO(LBZERO.Value) then
    ErrorProp(LBZERO, ERROR_IMAGEHEAD_CUSTOMIZENEW_BZERO_VALUE);
  PushProp({var} LLines, LBZERO);
  // Insert new keyword records
  InsertLines({AIndex:} 1, LLines);
end;

{ EFitsImageDataException }

function EFitsImageDataException.GetTopic: string;
begin
  Result := 'IMAGEDATA';
end;

{ TFitsImageData }

function TFitsImageData.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsImageDataException;
end;

function TFitsImageData.GetItem: TFitsImage;
begin
  Result := inherited Item as TFitsImage;
end;

function TFitsImageData.GetBScale: Extended;
begin
  Result := Item.GetBSCALE;
end;

function TFitsImageData.GetBZero: Extended;
begin
  Result := Item.GetBZERO;
end;

function TFitsImageData.GetValueInfo: TValueInfo;
begin
  Result.BitPix := BitPix;
  Result.BScale := BScale;
  Result.BZero := BZero;
end;

function TFitsImageData.GetValueType: TNumberType;
begin
  Result := CalcValueType(GetValueInfo);
end;

procedure TFitsImageData.CheckValues(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
var
  LArgIndex, LArgCapacity, LArgCount, LCount: Int64;
begin
  if ACheck = 'index' then
  begin
    LArgIndex := AArgs[0].VInt64^;
    LCount := GetValueCount;
    if not InSegmentBound({ASegmentPosition:} 0, LCount, LArgIndex) then
      Error(SImageDataValuesIndexOutBounds, [LArgIndex, LCount], ACodeError);
  end else
  if ACheck = 'bounds' then
  begin
    LArgIndex := AArgs[0].VInt64^;
    LArgCount := AArgs[1].VInt64^;
    LCount := GetValueCount;
    if not InSegmentBound({ASegmentPosition:} 0, LCount, LArgIndex, LArgCount) then
      Error(SImageDataValuesBlockOutBounds, [LArgIndex, LArgCount, LCount], ACodeError);
  end else
  if ACheck = 'capacity' then
  begin
    LArgCapacity := GetArrayLength(AArgs[0].VPointer);
    LArgCount := AArgs[1].VInt64^;
    if LArgCapacity < LArgCount then
      Error(SImageDataValuesLowArrayCapacity, [LArgCapacity, LArgCount], ACodeError);
  end else
    Assert(False, SAssertionFailureArgs(AArgs));
end;

function TFitsImageData.GetValue(AIndex: Int64): Extended;
var
  LValueInfo: TValueInfo;
  LInternalOffset, LSize: Int64;
  LSwapper: TSwapper;
  LValue64f: T64f;
  LValue32f: T32f;
  LValue08u: T08u;
  LValue16c: T16c;
  LValue32c: T32c;
  LValue64c: T64c;
begin
  CheckValues('index', [AIndex], ERROR_IMAGEDATA_GETVALUE_INDEX);
  LValueInfo := GetValueInfo;
  LSize := BitPixSize(LValueInfo.BitPix);
  LInternalOffset := AIndex * LSize;
  LSwapper := GetSwapper;
  case LValueInfo.BitPix of
    bi64f:
      begin
        LValue64f := 0.0;
        ReadChunk(LInternalOffset, LSize, {var} LValue64f);
        Result := LSwapper.Swap64f(LValue64f) * LValueInfo.BScale + LValueInfo.BZero;
      end;
    bi32f:
      begin
        LValue32f := 0.0;
        ReadChunk(LInternalOffset, LSize, {var} LValue32f);
        Result := LSwapper.Swap32f(LValue32f) * LValueInfo.BScale + LValueInfo.BZero;
      end;
    bi08u:
      begin
        LValue08u := 0;
        ReadChunk(LInternalOffset, LSize, {var} LValue08u);
        Result := LValue08u * LValueInfo.BScale + LValueInfo.BZero;
      end;
    bi16c:
      begin
        LValue16c := 0;
        ReadChunk(LInternalOffset, LSize, {var} LValue16c);
        Result := LSwapper.Swap16c(LValue16c) * LValueInfo.BScale + LValueInfo.BZero;
      end;
    bi32c:
      begin
        LValue32c := 0;
        ReadChunk(LInternalOffset, LSize, {var} LValue32c);
        Result := LSwapper.Swap32c(LValue32c) * LValueInfo.BScale + LValueInfo.BZero;
      end;
    bi64c:
      begin
        LValue64c := 0;
        ReadChunk(LInternalOffset, LSize, {var} LValue64c);
        Result := LSwapper.Swap64c(LValue64c) * LValueInfo.BScale + LValueInfo.BZero;
      end;
  else
    Result := NaN;
  end;
end;

procedure TFitsImageData.SetValue(AIndex: Int64; const AValue: Extended);
var
  LValueInfo: TValueInfo;
  LInternalOffset, LSize: Int64;
  LSwapper: TSwapper;
  LValue: Extended;
  LValue64f: T64f;
  LValue32f: T32f;
  LValue08u: T08u;
  LValue16c: T16c;
  LValue32c: T32c;
  LValue64c: T64c;
begin
  CheckValues('index', [AIndex], ERROR_IMAGEDATA_SETVALUE_INDEX);
  LValueInfo := GetValueInfo;
  LSize := BitPixSize(LValueInfo.BitPix);
  LInternalOffset := AIndex * LSize;
  LSwapper := GetSwapper;
  LValue := (AValue - LValueInfo.BZero) / LValueInfo.BScale;
  case LValueInfo.BitPix of
    bi64f:
      begin
        LValue64f := Ensure64f(LValue);
        LValue64f := LSwapper.Swap64f(LValue64f);
        WriteChunk(LInternalOffset, LSize, LValue64f);
      end;
    bi32f:
      begin
        LValue32f := Ensure32f(LValue);
        LValue32f := LSwapper.Swap32f(LValue32f);
        WriteChunk(LInternalOffset, LSize, LValue32f);
      end;
    bi08u:
      begin
        LValue08u := Round08u(LValue);
        WriteChunk(LInternalOffset, LSize, LValue08u);
      end;
    bi16c:
      begin
        LValue16c := Round16c(LValue);
        LValue16c := LSwapper.Swap16c(LValue16c);
        WriteChunk(LInternalOffset, LSize, LValue16c);
      end;
    bi32c:
      begin
        LValue32c := Round32c(LValue);
        LValue32c := LSwapper.Swap32c(LValue32c);
        WriteChunk(LInternalOffset, LSize, LValue32c);
      end;
    bi64c:
      begin
        LValue64c := Round64c(LValue);
        LValue64c := LSwapper.Swap64c(LValue64c);
        WriteChunk(LInternalOffset, LSize, LValue64c);
      end;
  end;
end;

function TFitsImageData.GetValueCount: Int64;
var
  LAxesCount, LNumber: Integer;
begin
  LAxesCount := AxesCount;
  Result := IfThen(LAxesCount = 0, 0, 1);
  for LNumber := 1 to LAxesCount do
    Result := Result * AxesLength[LNumber];
end;

procedure TFitsImageData.GetValues(const AIndex, ACount: Int64; var AValues: TSerializeArray; AValuesType: TValuesType);
var
  LValueInfo: TValueInfo;
  LSerializer: TSerializeProc;
  LContext: TSerializeContext;
  LCountBuffer, LPixelSize: Integer;
  LCount: Int64;
  LBuffer: TBuffer;
begin
  CheckValues('bounds', [AIndex, ACount], ERROR_IMAGEDATA_GETVALUES_BOUNDS);
  if ACount > GetArrayLength(AValues) then
    SetArrayLength(AValues, AValuesType, ACount);
  LValueInfo := GetValueInfo;
  LSerializer := GetBufferToValuesProc(LValueInfo.BitPix, AValuesType, CalcLinearType(LValueInfo));
  LPixelSize := BitPixSize(LValueInfo.BitPix);
  LCountBuffer := Max(1, cMaxSizeBuffer div LPixelSize);
  if LCountBuffer > ACount then
    LCountBuffer := Integer(ACount);
  Item.Container.Memory.Allocate({out} LBuffer, LCountBuffer * LPixelSize);
  LContext.Count := LCountBuffer;
  LContext.Start := 0;
  LContext.Scale := LValueInfo.BScale;
  LContext.Zero  := LValueInfo.BZero;
  LCount := ACount;
  while LCount > 0 do
  begin
    if LCountBuffer > LCount then
      LContext.Count := Integer(LCount);
    ReadChunk(Int64(AIndex + LContext.Start) * LPixelSize, Int64(LContext.Count) * LPixelSize, {var} LBuffer[0]);
    LSerializer(TSerializeArray(LBuffer), AValues, LContext);
    Inc(LContext.Start, LContext.Count);
    Dec(LCount, LContext.Count);
  end;
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA80f);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num80f);
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA64f);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num64f);
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA32f);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num32f);
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA08c);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num08c);
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA08u);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num08u);
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA16c);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num16c);
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA16u);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num16u);
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA32c);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num32c);
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA32u);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num32u);
end;

procedure TFitsImageData.ReadValues(const AIndex, ACount: Int64; var AValues: TA64c);
begin
  GetValues(AIndex, ACount, TSerializeArray(AValues), num64c);
end;

procedure TFitsImageData.SetValues(const AIndex, ACount: Int64; const AValues: TSerializeArray; AValuesType: TValuesType);
var
  LValueInfo: TValueInfo;
  LSerializer: TSerializeProc;
  LContext: TSerializeContext;
  LCountBuffer, LCount, LPixelSize: Integer;
  LBuffer: TBuffer;
begin
  CheckValues('bounds', [AIndex, ACount], ERROR_IMAGEDATA_SETVALUES_BOUNDS);
  CheckValues('capacity', [AValues, ACount], ERROR_IMAGEDATA_SETVALUES_CAPACITY);
  LValueInfo := GetValueInfo;
  LSerializer := GetValuesToBufferProc(LValueInfo.BitPix, AValuesType, CalcLinearType(LValueInfo));
  LPixelSize := BitPixSize(LValueInfo.BitPix);
  LCountBuffer := Max(1, cMaxSizeBuffer div LPixelSize);
  if LCountBuffer > ACount then
    LCountBuffer := Integer(ACount);
  Item.Container.Memory.Allocate({out} LBuffer, LCountBuffer * LPixelSize);
  LContext.Count := LCountBuffer;
  LContext.Start := 0;
  LContext.Scale := LValueInfo.BScale;
  LContext.Zero  := LValueInfo.BZero;
  LCount := ACount;
  while LCount > 0 do
  begin
    if LCountBuffer > LCount then
      LContext.Count := Integer(LCount);
    LSerializer(TSerializeArray(LBuffer), AValues, LContext);
    WriteChunk(Int64(AIndex + LContext.Start) * LPixelSize, Int64(LContext.Count) * LPixelSize, LBuffer[0]);
    Inc(LContext.Start, LContext.Count);
    Dec(LCount, LContext.Count);
  end;
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA80f);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num80f);
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA64f);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num64f);
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA32f);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num32f);
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA08c);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num08c);
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA08u);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num08u);
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA16c);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num16c);
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA16u);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num16u);
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA32c);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num32c);
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA32u);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num32u);
end;

procedure TFitsImageData.WriteValues(const AIndex, ACount: Int64; const AValues: TA64c);
begin
  SetValues(AIndex, ACount, TSerializeArray(AValues), num64c);
end;

{ EFitsImageException }

function EFitsImageException.GetTopic: string;
begin
  Result := 'IMAGE';
end;

{ TFitsImage }

function TFitsImage.GetHead: TFitsImageHead;
begin
  Result := inherited Head as TFitsImageHead;
end;

function TFitsImage.GetHeadClass: TFitsItemHeadClass;
begin
  Result := TFitsImageHead;
end;

function TFitsImage.GetDataClass: TFitsItemDataClass;
begin
  Result := TFitsImageData;
end;

function TFitsImage.GetData: TFitsImageData;
begin
  Result := inherited Data as TFitsImageData;
end;

function TFitsImage.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsImageException;
end;

procedure TFitsImage.DoGetNAXES(AProp: INAXES);
begin
  inherited;
  if not CorrectNAXES(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGE_GETNAXES_VALUE);
end;

procedure TFitsImage.DoGetPCOUNT(AProp: IPCOUNT);
begin
  inherited;
  if not CorrectPCOUNT(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGE_GETPCOUNT_VALUE);
end;

procedure TFitsImage.DoGetGCOUNT(AProp: IGCOUNT);
begin
  inherited;
  if not CorrectGCOUNT(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGE_GETGCOUNT_VALUE);
end;

procedure TFitsImage.DoGetBSCALE(AProp: IBSCALE);
begin
  if not ExtractHeadProp(AProp) then
    AProp.Value := DefaultBSCALE
  else if not CorrectBSCALE(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGE_GETBSCALE_VALUE);
end;

function TFitsImage.GetBSCALE: Extended;
var
  LProp: IBSCALE;
begin
  LProp := TFitsBSCALE.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetBSCALE(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsImage.DoGetBZERO(AProp: IBZERO);
begin
  if not ExtractHeadProp(AProp) then
    AProp.Value := DefaultBZERO
  else if not CorrectBZERO(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_IMAGE_GETBZERO_VALUE);
end;

function TFitsImage.GetBZERO: Extended;
var
  LProp: IBZERO;
begin
  LProp := TFitsBZERO.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetBZERO(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

constructor TFitsImage.CreateNew(AContainer: TFitsContainer; ASpec: TFitsItemSpec);
type
  TSpec = TFitsImageSpec;
var
  LMakeSpec: Boolean;
begin
  if Assigned(ASpec) then
  begin
    if not (ASpec is TFitsImageSpec) then
      Error(SSpecInvalidClass, [ASpec.ClassName],
        ERROR_IMAGE_CREATENEW_INVALID_CLASS_SPEC);
    ASpec := ASpec as TSpec;
    LMakeSpec := False;
  end else
  begin
    ASpec := TSpec.CreateNew(num08u, {AAxesLength:} []);
    LMakeSpec := True;
  end;
  try
    inherited CreateNew(AContainer, ASpec);
  finally
    if LMakeSpec then
      ASpec.Free;
  end;
end;

class function TFitsImage.ExtensionTypeIs(AItem: TFitsItem): Boolean;

  function FindItemHeadRecord(const AKeyword: string; var LRecord: TLineRecord): Boolean;
  var
    LIndex: Integer;
  begin
    LIndex := AItem.Head.LineIndexOfKeyword(AKeyword);
    if LIndex >= 0 then
      LRecord := AItem.Head.LineRecords[LIndex];
    Result := LIndex >= 0;
  end;

var
  LNumber: Integer;
  LRecord: TLineRecord;
  LBITPIX: TBitPix;
  LNAXIS, LNAXES, LPCOUNT, LGCOUNT: Integer;
begin
  Result := inherited ExtensionTypeIs(AItem);
  // Check the mandatory keyword records that define the size of the data section
  LRecord := EmptyLineRecord;
  Result := Result and FindItemHeadRecord(cBITPIX, LRecord) and
    TryStringToBitPix(LRecord.Value, LBITPIX);
  Result := Result and FindItemHeadRecord(cNAXIS, LRecord) and
    TryStringToInteger(LRecord.Value, LNAXIS) and CorrectNAXIS(LNAXIS);
  LNumber := 1;
  while Result and (LNumber <= LNAXIS) do
  begin
    Result := FindItemHeadRecord(ExpandKeyword(cNAXISn, LNumber), LRecord) and
      TryStringToInteger(LRecord.Value, LNAXES) and CorrectNAXES(LNAXES);
    Inc(LNumber);
  end;
  if Result and FindItemHeadRecord(cPCOUNT, LRecord) then
    Result := TryStringToInteger(LRecord.Value, LPCOUNT) and CorrectPCOUNT(LPCOUNT);
  if Result and FindItemHeadRecord(cGCOUNT, LRecord) then
    Result := TryStringToInteger(LRecord.Value, LGCOUNT) and CorrectGCOUNT(LGCOUNT);
end;

end.
