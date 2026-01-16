{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{                Mathematics functions                 }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsMath;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Math, DeLaFitsCommon;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_MATH               = 2000;

  ERROR_MATH_NAN_PICTURE   = 2100;

  ERROR_MATH_MATRIX_SHIFT  = 2200;
  ERROR_MATH_MATRIX_SCALE  = 2201;
  ERROR_MATH_MATRIX_ROTATE = 2202;
  ERROR_MATH_MATRIX_SHEARX = 2203;
  ERROR_MATH_MATRIX_SHEARY = 2204;
  ERROR_MATH_MATRIX_ZTERM  = 2205;
  ERROR_MATH_MATRIX_DET    = 2206;

resourcestring

  { The messages of exceptions }

  SNanPictureIncorrect   = 'Cannot represent NaN as NaN';
  SMatrixPropIncorrect   = 'Incorrect %s value "%.4f" for affine matrix';
  SMatrixZTermIncorrect  = 'Incorrect affine matrix: Z-term not equal to (0, 0, 1)';
  SMatrixDeterminantZero = 'Incorrect affine matrix: determinant is zero';

type

  { Exception classes }

  EFitsMathException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  { TSwapper: exchanges the byte order of a number }

  TSwapper = record
    Swap16u: function (const AValue: T16u): T16u;
    Swap16c: function (const AValue: T16c): T16c;
    Swap32c: function (const AValue: T32c): T32c;
    Swap32f: function (const AValue: T32f): T32f;
    Swap64c: function (const AValue: T64c): T64c;
    Swap64f: function (const AValue: T64f): T64f;
  end;

  function GetSwapper: TSwapper; overload;
  function GetSwapper(AEndianness: TEndianness): TSwapper; overload;

  { Range [min..max] of number values }

const
  // 08
  cMin08c: T08c = Low(T08c);
  cMax08c: T08c = High(T08c);
  cMin08u: T08u = Low(T08u);
  cMax08u: T08u = High(T08u);
  // 16
  cMin16c: T16c = Low(T16c);
  cMax16c: T16c = High(T16c);
  cMin16u: T16u = Low(T16u);
  cMax16u: T16u = High(T16u);
  // 32
  cMin32c: T32c = Low(T32c);
  cMax32c: T32c = High(T32c);
  cMin32u: T32u = Low(T32u);
  cMax32u: T32u = High(T32u);
  cMin32f: T32f = -Math.MaxSingle;
  cMax32f: T32f =  Math.MaxSingle;
  // 64
  cMin64c: T64c = Low(T64c);
  cMax64c: T64c = High(T64c);
  cMin64f: T64f = -Math.MaxDouble;
  cMax64f: T64f =  Math.MaxDouble;
  // 80
{$IFDEF HAS_EXTENDED_FLOAT}
{$WARN SYMBOL_PLATFORM OFF}
  cMin80f: T80f = -Math.MaxExtended;
  cMax80f: T80f =  Math.MaxExtended;
{$WARN SYMBOL_PLATFORM ON}
{$ELSE}
  cMin80f: T80f = -Math.MaxDouble;
  cMax80f: T80f =  Math.MaxDouble;
{$ENDIF}

  function NumberIsInteger(ANumber: TNumberType): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function GetMinNumber(ANumber: TNumberType): T80f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function GetMaxNumber(ANumber: TNumberType): T80f; {$IFDEF HAS_INLINE} inline; {$ENDIF}

{$IFDEF DELAFITS_MATH_NAN}

  { Support for NaN values }

const
  cNanInteger: T64c = Low(T64c);

  function GetNanInteger: T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure SetNanInteger(const AValue: T64c);

const
  cNanPicture: T80f = Math.NegInfinity;

  function GetNanPicture: T80f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure SetNanPicture(const AValue: T80f);

{$ENDIF}

  { Arrange numbers }

  procedure Arrange(var AMin, AMax: T80f); overload; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Arrange(var AMin, AMax: T64c); overload; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  { Ensure a range of numbers }

  function Ensure64f(const AValue: T80f): T64f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure32f(const AValue: T80f): T32f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure08c(const AValue: T64c): T08c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure08u(const AValue: T64c): T08u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure16c(const AValue: T64c): T16c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure16u(const AValue: T64c): T16u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure32c(const AValue: T64c): T32c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure32u(const AValue: T64c): T32u; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  { Safe rounding }

  function Round08c(const AValue: Extended): T08c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round08u(const AValue: Extended): T08u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round16c(const AValue: Extended): T16c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round16u(const AValue: Extended): T16u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round32c(const AValue: Extended): T32c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round32u(const AValue: Extended): T32u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round64c(const AValue: Extended): T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}

{$IFDEF DELAFITS_CUSTOM_RANDOM}

  { Support for customizing the pseudo-random number generator }

type
  IntegerRandom = {$IFDEF FPC}LongInt{$ELSE}Integer{$ENDIF};
  TCustomRandom = function (const ARange: IntegerRandom): IntegerRandom;

  function SysRandom(const ARange: IntegerRandom): IntegerRandom;

var
  cCustomRandom: TCustomRandom = {$IFDEF FPC}TCustomRandom(@SysRandom){$ELSE}SysRandom{$ENDIF};

  function GetCustomRandom: TCustomRandom; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure SetCustomRandom(const AValue: TCustomRandom);

{$ENDIF}

  { Shake the array: from L elements, randomly select R and move them to the beginning of array A }

  procedure Shake64f(var A: TA64f; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake32f(var A: TA32f; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake08u(var A: TA08u; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake16c(var A: TA16c; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake32c(var A: TA32c; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake64c(var A: TA64c; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}

  { Replace NaN-value with safe cNanPicture }

  function UnNan80f(const AValue: T80f): T80f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function UnNan64f(const AValue: T64f): T64f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function UnNan32f(const AValue: T32f): T32f; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  { Change to the opposite sign of a real number (with check for zero value) }

  function FlipSign(const AValue: Double): Double;

  { Mathematical rounding with fixed precision to 1E-08 }

  function FixedRound(const AValue: Double): Double;

  function FixedRoundPoint(const APoint: TPlanePoint): TPlanePoint;
  function FixedRoundQuad(const AQuad: TQuad): TQuad;
  function FixedRoundClip(const AClip: TClip): TClip;

  { Rounds variables toward negative infinity: (-1 <~ -0.9), (-1 <~ -0.1), (0 <~ +0.1), (0 <~ +0.9) }

  function FloorPoint(const APoint: TPlanePoint): TPlanePixel;

  { Rounds variables up toward positive infinity: (-0.9 ~> 0), (-0.1 ~> 0), (+0.1 ~> 1), (+0.9 ~> 1) }

  function CeilPoint(const APoint: TPlanePoint): TPlanePixel;

  { Affine transformations are to the matrix form in the system of homogeneous coordinates:

    |--------------------------|      X = M[1,1] * X + M[1,2] * Y + M[1,3]
    |     matrix elsemnets     |      Y = M[2,1] * X + M[2,2] * Y + M[2,3]
    |--------------------------|
    |  M[1,1]  M[2,1]  M[3,1]  |  ->  Determinant = M[1,1] * M[2,2] - M[2,1] * M[1,2]
    |  M[1,2]  M[2,2]  M[3,2]  |
    |  M[1,3]  M[2,3]  M[3,3]  |      Determinant <> 0
    |--------------------------|      Z-term: M[3,1] = 0; M[3,2] = 0; M[3,3] = 1;

    |-----------|   |--------------------------|
    | Identity  |   |          Point           |
    |  matrix   |   | P0(X0, Y0) = T(±X0, ±Y0) |
    |-----------|   |--------------------------|
    |  1  0  0  |   |          1   0  0        |
    |  0  1  0  |   |          0   1  0        |
    |  0  0  1  |   |        ±X0 ±Y0  1        |
    |-----------|   |--------------------------|

    |-----------|-----------|----------------|-------------|-------------|
    |   Shift   |   Scale   |     Rotate     |    ShearX   |    ShearY   |
    | T(Dx, Dy) | S(Sx, Sy) |      R(A)      |    Shr(A)   |    Shr(A)   |
    |-----------|-----------|----------------|-------------|-------------|
    |  1  0  0  | Sx  0  0  |  cosA sinA  0  |  1    0  0  |  1 tanA  0  |
    |  0  1  0  |  0 Sy  0  | -sinA cosA  0  |  tanA 1  0  |  0    1  0  |
    | Dx Dy  1  |  0  0  1  |     0    0  1  |  0    0  1  |  0    0  1  |
    |-----------|-----------|----------------|-------------|-------------| }

  function CreateMatrix: TMatrix;

  function CreateMatrixShift(const ADX, ADY: Double): TMatrix;
  function CreateMatrixScale(const ASX, ASY: Double): TMatrix;
  function CreateMatrixRotate(const AAngle: Double): TMatrix; // clockwise
  function CreateMatrixShearX(const AAngle: Double): TMatrix;
  function CreateMatrixShearY(const AAngle: Double): TMatrix;

  function InvertMatrix(const AMatrix: TMatrix): TMatrix;

  function MultiplyMatrix(const A, B: TMatrix): TMatrix;

  { Affine transformation point, no check as affinity }

  function MapPoint(const AMatrix: TMatrix; const APoint: TPlanePoint): TPlanePoint;

  { Affine transformation pixel: P.(X, Y) := Src.(X, Y) + 0.5 -> MapPnt -> FloorPnt }

  function MapPixel(const AMatrix: TMatrix; const APixel: TPlanePixel): TPlanePixel;

  { Check if an object (point or region) is inside a geometric shape }

  function InRegion(const ARegion: TRegion; const AR: TRegion): Boolean; overload;
  function InRegion(const ARegion: TRegion; const AX, AY: Integer): Boolean; overload;

  function InBound(const ABound: TBound; const AX, AY: Double): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  { Delineation (contouring) points of the rectangle }

  function RectQuad(const AQuad: TQuad): TRegion;
  function RectClip(const AClip: TClip): TRegion;

  { Normalization: TopLeft and Clockwise
    P1----P2
     |    |
    P4----P3 }

  function NormQuad(const AQuad: TQuad): TQuad;
  function NormClip(const AClip: TClip): TClip;

  { Clipping quadrilaterals (algorithm of Hodzhmen–Sutherland)

    AWnd - quadrangle or isothetic rectangle (defined by two integer coordinates)
    AQuad - chopping off rectangle

    Return:
    AClip - geometric shape of crossing, i.e. polygon from 1 to 8 points.
    AClip.PN = 0 if crossing is not present. AClip a normalization: sort
    as TopLeft and Clockwise }

  procedure QClip(const AWnd: TQuad; const AQuad: TQuad; out AClip: TClip); overload;
  procedure QClip(const AWnd: TRegion; const AQuad: TQuad; out AClip: TClip); overload;

  { Crossing of segment and geometric shape. A segment is parallel to
    the axis of X. Crossing is have!, need to define two X-coordinates.
        *----*
        |   /
    ----|--/----- Y
        | /
        |/
        *
    Clip.PN > 0 }

  procedure YCross(const AClip: TClip; const AY: Double; out X1, X2: Double);

  { Check if chunk is within segment boundaries }

  function InSegmentBound(const ASegmentPosition, ASegmentLength: Int64;
    const AChunkPosition: Int64): Boolean; overload; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function InSegmentBound(const ASegmentPosition, ASegmentLength: Int64;
    const AChunkPosition, AChunkLength: Int64): Boolean; overload; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  { Ensure the number is a multiple, i.e. AValue:ARank=N }

  function EnsureMultiply(const AValue: Int64; ARank: Integer;
    ARetainZeroValue: Boolean): Int64; {$IFDEF HAS_INLINE} inline; {$ENDIF}

implementation

{ EFitsMathException }

function EFitsMathException.GetTopic: string;
begin
  Result := 'MATH';
end;

{ TSwapper }

function beSwap16u(const AValue: T16u): T16u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue;
end;

function beSwap16c(const AValue: T16c): T16c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue;
end;

function beSwap32c(const AValue: T32c): T32c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue;
end;

function beSwap32f(const AValue: T32f): T32f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue;
end;

function beSwap64c(const AValue: T64c): T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue;
end;

function beSwap64f(const AValue: T64f): T64f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue;
end;

function leSwap16u(const AValue: T16u): T16u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := System.Swap(AValue);
end;

function leSwap16c(const AValue: T16c): T16c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := T16c(System.Swap(AValue));
end;

type
  TRec32 = packed record
    Lo, Hi: T16u;
  end;

function leSwap32c(const AValue: T32c): T32c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  LValue: TRec32;
begin
  LValue := TRec32(AValue);
  TRec32(Result).Hi := Swap(LValue.Lo);
  TRec32(Result).Lo := Swap(LValue.Hi);
end;

function leSwap32f(const AValue: T32f): T32f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  LValue: TRec32;
begin
  LValue := TRec32(AValue);
  TRec32(Result).Hi := Swap(LValue.Lo);
  TRec32(Result).Lo := Swap(LValue.Hi);
end;

type
  TRec64 = packed record
    Lo, Hi: T32u;
  end;

function leSwap64c(const AValue: T64c): T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  with TRec64(AValue) do
  begin
    TRec64(Result).Hi := (Lo shr 24) or (Lo shl 24) or ((Lo and $00FF0000) shr 8) or ((Lo and $0000FF00) shl 8);
    TRec64(Result).Lo := (Hi shr 24) or (Hi shl 24) or ((Hi and $00FF0000) shr 8) or ((Hi and $0000FF00) shl 8);
  end;
end;

function leSwap64f(const AValue: T64f): T64f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  with TRec64(AValue) do
  begin
    TRec64(Result).Hi := (Lo shr 24) or (Lo shl 24) or ((Lo and $00FF0000) shr 8) or ((Lo and $0000FF00) shl 8);
    TRec64(Result).Lo := (Hi shr 24) or (Hi shl 24) or ((Hi and $00FF0000) shr 8) or ((Hi and $0000FF00) shl 8);
  end;
end;

function GetSwapper: TSwapper; overload;
var
  LEndianness: TEndianness;
begin
  LEndianness := GetEndianness;
  Result := GetSwapper(LEndianness);
end;

function GetSwapper(AEndianness: TEndianness): TSwapper; overload;
begin
  if AEndianness = sysBE then
  begin
    Result.Swap16u := @beSwap16u;
    Result.Swap16c := @beSwap16c;
    Result.Swap32c := @beSwap32c;
    Result.Swap32f := @beSwap32f;
    Result.Swap64c := @beSwap64c;
    Result.Swap64f := @beSwap64f;
  end else { if AEndianness = sysLE then }
  begin
    Result.Swap16u := @leSwap16u;
    Result.Swap16c := @leSwap16c;
    Result.Swap32c := @leSwap32c;
    Result.Swap32f := @leSwap32f;
    Result.Swap64c := @leSwap64c;
    Result.Swap64f := @leSwap64f;
  end;
end;

{ Range [min..max] of number values }

function NumberIsInteger(ANumber: TNumberType): Boolean;
begin
  Result := ANumber >= num08c;
end;

function GetMinNumber(ANumber: TNumberType): T80f;
begin
  case ANumber of
    num80f: Result := cMin80f;
    num64f: Result := cMin64f;
    num32f: Result := cMin32f;
    num08c: Result := cMin08c;
    num08u: Result := cMin08u;
    num16c: Result := cMin16c;
    num16u: Result := cMin16u;
    num32c: Result := cMin32c;
    num32u: Result := cMin32u;
    num64c: Result := cMin64c;
  else      Result := Math.NegInfinity;
  end;
end;

function GetMaxNumber(ANumber: TNumberType): T80f;
begin
  case ANumber of
    num80f: Result := cMax80f;
    num64f: Result := cMax64f;
    num32f: Result := cMax32f;
    num08c: Result := cMax08c;
    num08u: Result := cMax08u;
    num16c: Result := cMax16c;
    num16u: Result := cMax16u;
    num32c: Result := cMax32c;
    num32u: Result := cMax32u;
    num64c: Result := cMax64c;
  else      Result := Math.Infinity;
  end;
end;

{$IFDEF DELAFITS_MATH_NAN}

{ Support for NaN values }

function GetNanInteger: T64c;
begin
  Result := cNanInteger;
end;

procedure SetNanInteger(const AValue: T64c);
type
  P64c = ^T64c;
begin
  P64c(@cNanInteger)^ := AValue;
end;

function GetNanPicture: T80f;
begin
  Result := cNanPicture;
end;

procedure SetNanPicture(const AValue: T80f);
type
  P80f = ^T80f;
begin
  if Math.IsNan(AValue) then
    raise EFitsMathException.Create(SNanPictureIncorrect, ERROR_MATH_NAN_PICTURE);
  P80f(@cNanPicture)^ := AValue;
end;

{$ENDIF}

{ Arrange numbers }

procedure Arrange(var AMin, AMax: T80f);
var
  LTemp: T80f;
begin
  if AMin > AMax then
  begin
    LTemp := AMin;
    AMin  := AMax;
    AMax  := LTemp;
  end;
end;

procedure Arrange(var AMin, AMax: T64c);
var
  LTemp: T64c;
begin
  if AMin > AMax then
  begin
    LTemp := AMin;
    AMin  := AMax;
    AMax  := LTemp;
  end;
end;

{ Ensure a range of numbers }

function Ensure64f(const AValue: T80f): T64f;
begin
{$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(AValue) or (AValue = Infinity) or (AValue = NegInfinity) then
  begin
    Result := AValue;
    Exit;
  end;
{$ENDIF}
  Result := Math.EnsureRange(AValue, cMin64f, cMax64f);
end;

function Ensure32f(const AValue: T80f): T32f;
begin
{$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(AValue) or (AValue = Infinity) or (AValue = NegInfinity) then
  begin
    Result := AValue;
    Exit;
  end;
{$ENDIF}
  Result := Math.EnsureRange(AValue, cMin32f, cMax32f);
end;

function Ensure08c(const AValue: T64c): T08c;
begin
  Result := Math.EnsureRange(AValue, cMin08c, cMax08c);
end;

function Ensure08u(const AValue: T64c): T08u;
begin
  Result := Math.EnsureRange(AValue, cMin08u, cMax08u);
end;

function Ensure16c(const AValue: T64c): T16c;
begin
  Result := Math.EnsureRange(AValue, cMin16c, cMax16c);
end;

function Ensure16u(const AValue: T64c): T16u;
begin
  Result := Math.EnsureRange(AValue, cMin16u, cMax16u);
end;

function Ensure32c(const AValue: T64c): T32c;
begin
  Result := Math.EnsureRange(AValue, cMin32c, cMax32c);
end;

function Ensure32u(const AValue: T64c): T32u;
begin
  Result := Math.EnsureRange(AValue, cMin32u, cMax32u);
end;

{ Safe rounding }

function Round08c(const AValue: Extended): T08c;
begin
{$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(AValue) then
  begin
    Result := Math.EnsureRange(cNanInteger, cMin08c, cMax08c);
    Exit;
  end;
{$ENDIF}
  if AValue <= cMin08c then
    Result := cMin08c
  else if AValue >= cMax08c then
    Result := cMax08c
  else
    Result := Round(AValue);
end;

function Round08u(const AValue: Extended): T08u;
begin
{$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(AValue) then
  begin
    Result := Math.EnsureRange(cNanInteger, cMin08u, cMax08u);
    Exit;
  end;
{$ENDIF}
  if AValue <= cMin08u then
    Result := cMin08u
  else if AValue >= cMax08u then
    Result := cMax08u
  else
    Result := Round(AValue);
end;

function Round16c(const AValue: Extended): T16c;
begin
{$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(AValue) then
  begin
    Result := Math.EnsureRange(cNanInteger, cMin16c, cMax16c);
    Exit;
  end;
{$ENDIF}
  if AValue <= cMin16c then
    Result := cMin16c
  else if AValue >= cMax16c then
    Result := cMax16c
  else
    Result := Round(AValue);
end;

function Round16u(const AValue: Extended): T16u;
begin
{$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(AValue) then
  begin
    Result := Math.EnsureRange(cNanInteger, cMin16u, cMax16u);
    Exit;
  end;
{$ENDIF}
  if AValue <= cMin16u then
    Result := cMin16u
  else if AValue >= cMax16u then
    Result := cMax16u
  else
    Result := Round(AValue);
end;

function Round32c(const AValue: Extended): T32c;
begin
{$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(AValue) then
  begin
    Result := Math.EnsureRange(cNanInteger, cMin32c, cMax32c);
    Exit;
  end;
{$ENDIF}
  if AValue <= cMin32c then
    Result := cMin32c
  else if AValue >= cMax32c then
    Result := cMax32c
  else
    Result := Round(AValue);
end;

function Round32u(const AValue: Extended): T32u;
begin
{$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(AValue) then
  begin
    Result := Math.EnsureRange(cNanInteger, cMin32u, cMax32u);
    Exit;
  end;
{$ENDIF}
  if AValue <= cMin32u then
    Result := cMin32u
  else if AValue >= cMax32u then
    Result := cMax32u
  else
    Result := Round(AValue);
end;

function Round64c(const AValue: Extended): T64c;
begin
{$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(AValue) then
  begin
    Result := cNanInteger;
    Exit;
  end;
{$ENDIF}
  if AValue <= cMin64c then
    Result := cMin64c
  else if AValue >= cMax64c then
    Result := cMax64c
  else
    Result := Round(AValue);
end;

{$IFDEF DELAFITS_CUSTOM_RANDOM}

{ Support for customizing the pseudo-random number generator }

function SysRandom(const ARange: IntegerRandom): IntegerRandom;
begin
  // in VER150 Random is an intrinsic routine
  Result := Random(ARange);
end;

function GetCustomRandom: TCustomRandom;
begin
  Result := cCustomRandom;
end;

procedure SetCustomRandom(const AValue: TCustomRandom);
begin
  cCustomRandom := AValue;
end;

{$ENDIF}

{ Shake the array }

procedure Shake64f(var A: TA64f; const L, R: Integer);
var
  Temp: T64f;
  I, J, K: Integer;
begin
  Assert((L > 0) and (R > 0), SAssertionFailure);
  if R >= L then
    Exit;
  if R < (L - R) then
    for I := 0 to R - 1 do
    begin
      K := (L - 1) - I;
      J := I + {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[K];
      A[K] := A[J];
      A[J] := Temp;
    end;
end;

procedure Shake32f(var A: TA32f; const L, R: Integer);
var
  Temp: T32f;
  I, J, K: Integer;
begin
  Assert((L > 0) and (R > 0), SAssertionFailure);
  if R >= L then
    Exit;
  if R < (L - R) then
    for I := 0 to R - 1 do
    begin
      K := (L - 1) - I;
      J := I + {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[K];
      A[K] := A[J];
      A[J] := Temp;
    end;
end;

procedure Shake08u(var A: TA08u; const L, R: Integer);
var
  Temp: T08u;
  I, J, K: Integer;
begin
  Assert((L > 0) and (R > 0), SAssertionFailure);
  if R >= L then
    Exit;
  if R < (L - R) then
    for I := 0 to R - 1 do
    begin
      K := (L - 1) - I;
      J := I + {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[K];
      A[K] := A[J];
      A[J] := Temp;
    end;
end;

procedure Shake16c(var A: TA16c; const L, R: Integer);
var
  Temp: T16c;
  I, J, K: Integer;
begin
  Assert((L > 0) and (R > 0), SAssertionFailure);
  if R >= L then
    Exit;
  if R < (L - R) then
    for I := 0 to R - 1 do
    begin
      K := (L - 1) - I;
      J := I + {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[K];
      A[K] := A[J];
      A[J] := Temp;
    end;
end;

procedure Shake32c(var A: TA32c; const L, R: Integer);
var
  Temp: T32c;
  I, J, K: Integer;
begin
  Assert((L > 0) and (R > 0), SAssertionFailure);
  if R >= L then
    Exit;
  if R < (L - R) then
    for I := 0 to R - 1 do
    begin
      K := (L - 1) - I;
      J := I + {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[K];
      A[K] := A[J];
      A[J] := Temp;
    end;
end;

procedure Shake64c(var A: TA64c; const L, R: Integer);
var
  Temp: T64c;
  I, J, K: Integer;
begin
  Assert((L > 0) and (R > 0), SAssertionFailure);
  if R >= L then
    Exit;
  if R < (L - R) then
    for I := 0 to R - 1 do
    begin
      K := (L - 1) - I;
      J := I + {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELAFITS_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[K];
      A[K] := A[J];
      A[J] := Temp;
    end;
end;

{ Replace NaN-value with safe cNanPicture }

function UnNan80f(const AValue: T80f): T80f;
begin
  Result := AValue;
  {$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(Result) then
    Result := cNanPicture;
  {$ENDIF}
end;

function UnNan64f(const AValue: T64f): T64f;
begin
  Result := AValue;
  {$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(Result) then
    Result := cNanPicture;
  {$ENDIF}
end;

function UnNan32f(const AValue: T32f): T32f;
begin
  Result := AValue;
  {$IFDEF DELAFITS_MATH_NAN}
  if Math.IsNan(Result) then
    Result := cNanPicture;
  {$ENDIF}
end;

{ Change to the opposite sign of a real number }

function FlipSign(const AValue: Double): Double;
begin
  if Math.IsZero(AValue) then
    Result := 0.0
  else
    Result := -AValue;
end;

{ Mathematical rounding with fixed precision }

function FixedRoundTo(const AValue: Double; APrecision: Integer): Double;
begin
  // Error in Math.SimpleRoundTo of VER150
  Result := Math.SimpleRoundTo(Abs(AValue), APrecision);
  if AValue < 0 then
    Result := FlipSign(Result);
end;

function FixedRound(const AValue: Double): Double;
const
  cPrecision = -8;
begin
  Result := FixedRoundTo(AValue, cPrecision);
end;

function FixedRoundPoint(const APoint: TPlanePoint): TPlanePoint;
begin
  Result.X := FixedRound(APoint.X);
  Result.Y := FixedRound(APoint.Y);
end;

function FixedRoundQuad(const AQuad: TQuad): TQuad;
var
  I: Integer;
begin
  for I := 1 to 4 do
    Result.Points[I] := FixedRoundPoint(AQuad.Points[I]);
end;

function FixedRoundClip(const AClip: TClip): TClip;
var
  I: Integer;
begin
  Result.Count := AClip.Count;
  for I := 1 to AClip.Count do
    Result.Points[I] := FixedRoundPoint(AClip.Points[I]);
end;

{ Round point values }

function FloorPoint(const APoint: TPlanePoint): TPlanePixel;
begin
  Result.X := Math.Floor(APoint.X);
  Result.Y := Math.Floor(APoint.Y);
end;

function CeilPoint(const APoint: TPlanePoint): TPlanePixel;
begin
  Result.X := Math.Ceil(APoint.X);
  Result.Y := Math.Ceil(APoint.Y);
end;

{ Check value for zero }

function SafeZero(const AValue, AExpression: Double): Double; overload;
begin
  if Math.IsZero(AValue) then
    Result := 0.0
  else
    Result := AExpression;
end;

function SafeZero(const AValue: Double): Double; overload;
begin
  if Math.IsZero(AValue) then
    Result := 0.0
  else
    Result := AValue
end;

{ Affine transformations }

function CreateMatrix: TMatrix;
begin
  Result[1, 1] := 1.0;
  Result[1, 2] := 0.0;
  Result[1, 3] := 0.0;
  Result[2, 1] := 0.0;
  Result[2, 2] := 1.0;
  Result[2, 3] := 0.0;
  Result[3, 1] := 0.0;
  Result[3, 2] := 0.0;
  Result[3, 3] := 1.0;
end;

function CreateMatrixShift(const ADX, ADY: Double): TMatrix;

  procedure Check(const AValue: Double);
  begin
    if Math.IsNan(AValue) or Math.IsInfinite(AValue) then
      raise EFitsMathException.CreateFmt(SMatrixPropIncorrect,
        ['shift', AValue], ERROR_MATH_MATRIX_SHIFT);
  end;

begin
  Check(ADX);
  Check(ADY);
  Result := CreateMatrix;
  Result[1, 3] := ADX;
  Result[2, 3] := ADY;
end;

function CreateMatrixScale(const ASX, ASY: Double): TMatrix;

  procedure Check(const AValue: Double);
  begin
    if Math.IsNan(AValue) or Math.IsInfinite(AValue) or Math.IsZero(AValue) then
      raise EFitsMathException.CreateFmt(SMatrixPropIncorrect,
        ['scale', AValue], ERROR_MATH_MATRIX_SCALE);
  end;

begin
  Check(ASX);
  Check(ASY);
  Result := CreateMatrix;
  Result[1, 1] := ASX;
  Result[2, 2] := ASY;
end;

function CreateMatrixRotate(const AAngle: Double): TMatrix;
var
  LCosAngle, LSinAngle: Double;
begin
  if Math.IsNan(AAngle) or Math.IsInfinite(AAngle) then
    raise EFitsMathException.CreateFmt(SMatrixPropIncorrect,
      ['rotation', AAngle], ERROR_MATH_MATRIX_ROTATE);
  Result := CreateMatrix;
  LCosAngle := FixedRound(Cos(AAngle * PI / 180));
  LSinAngle := FixedRound(Sin(AAngle * PI / 180));
  Result[1, 1] := LCosAngle;
  Result[2, 1] := LSinAngle;
  Result[2, 2] := LCosAngle;
  Result[1, 2] := FlipSign(LSinAngle);
end;

function CreateMatrixShearX(const AAngle: Double): TMatrix;
var
  LTanAngle: Double;
begin
  if Math.IsNan(AAngle) or Math.IsInfinite(AAngle) or
    (AAngle < -90) or (AAngle > 90) or Math.SameValue(Abs(AAngle), 90.0) then
      raise EFitsMathException.CreateFmt(SMatrixPropIncorrect,
        ['X shear', AAngle], ERROR_MATH_MATRIX_SHEARX);
  Result := CreateMatrix;
  LTanAngle := FixedRound(Tan(AAngle * PI / 180));
  Result[1, 2] := LTanAngle;
end;

function CreateMatrixShearY(const AAngle: Double): TMatrix;
var
  LTanAngle: Double;
begin
  if Math.IsNan(AAngle) or Math.IsInfinite(AAngle) or
    (AAngle < -90) or (AAngle > 90) or Math.SameValue(Abs(AAngle), 90.0) then
      raise EFitsMathException.CreateFmt(SMatrixPropIncorrect,
        ['Y shear', AAngle], ERROR_MATH_MATRIX_SHEARY);
  Result := CreateMatrix;
  LTanAngle := FixedRound(Tan(AAngle * PI / 180));
  Result[2, 1] := LTanAngle;
end;

function GetMatrixDeterminant(const AMatrix: TMatrix): Double;
begin
  Result := AMatrix[1, 1] * AMatrix[2, 2] - AMatrix[2, 1] * AMatrix[1, 2];
  Result := FixedRound(Result);
end;

procedure CheckMatrixAffinity(const AMatrix: TMatrix);
var
  LCheckZTerm: Boolean;
  LCheckDeterminant: Boolean;
begin
  LCheckZTerm := (AMatrix[3, 1] = 0) and (AMatrix[3, 2] = 0) and (AMatrix[3, 3] = 1);
  if not LCheckZTerm then
    raise EFitsMathException.Create(SMatrixZTermIncorrect, ERROR_MATH_MATRIX_ZTERM);
  LCheckDeterminant := GetMatrixDeterminant(AMatrix) <> 0;
  if not LCheckDeterminant then
    raise EFitsMathException.Create(SMatrixDeterminantZero, ERROR_MATH_MATRIX_DET);
end;

function InvertMatrix(const AMatrix: TMatrix): TMatrix;
var
  LDeterminant: Double;
begin
  CheckMatrixAffinity(AMatrix);
  Result := CreateMatrix;
  LDeterminant := GetMatrixDeterminant(AMatrix);
  Result[1, 1] := SafeZero(AMatrix[2, 2], AMatrix[2, 2] / LDeterminant);
  Result[1, 2] := SafeZero(AMatrix[1, 2], -AMatrix[1, 2] / LDeterminant);
  Result[1, 3] := SafeZero((AMatrix[1, 2] * AMatrix[2, 3] - AMatrix[2, 2] * AMatrix[1, 3]) / LDeterminant);
  Result[2, 1] := SafeZero(AMatrix[2, 1], -AMatrix[2, 1] / LDeterminant);
  Result[2, 2] := SafeZero(AMatrix[1, 1], AMatrix[1, 1] / LDeterminant);
  Result[2, 3] := SafeZero((AMatrix[2, 1] * AMatrix[1, 3] - AMatrix[1, 1] * AMatrix[2, 3]) / LDeterminant);
end;

function MultiplyMatrix(const A, B: TMatrix): TMatrix;
begin
  CheckMatrixAffinity(A);
  CheckMatrixAffinity(B);
  Result[1, 1] := A[1, 1] * B[1, 1] + A[2, 1] * B[1, 2] + A[3, 1] * B[1, 3];
  Result[1, 2] := A[1, 2] * B[1, 1] + A[2, 2] * B[1, 2] + A[3, 2] * B[1, 3];
  Result[1, 3] := A[1, 3] * B[1, 1] + A[2, 3] * B[1, 2] + A[3, 3] * B[1, 3];
  Result[2, 1] := A[1, 1] * B[2, 1] + A[2, 1] * B[2, 2] + A[3, 1] * B[2, 3];
  Result[2, 2] := A[1, 2] * B[2, 1] + A[2, 2] * B[2, 2] + A[3, 2] * B[2, 3];
  Result[2, 3] := A[1, 3] * B[2, 1] + A[2, 3] * B[2, 2] + A[3, 3] * B[2, 3];
  Result[3, 1] := A[1, 1] * B[3, 1] + A[2, 1] * B[3, 2] + A[3, 1] * B[3, 3];
  Result[3, 2] := A[1, 2] * B[3, 1] + A[2, 2] * B[3, 2] + A[3, 2] * B[3, 3];
  Result[3, 3] := A[1, 3] * B[3, 1] + A[2, 3] * B[3, 2] + A[3, 3] * B[3, 3];
end;

function MapPoint(const AMatrix: TMatrix; const APoint: TPlanePoint): TPlanePoint;
begin
  with APoint do
  begin
    Result.X := AMatrix[1, 1] * X + AMatrix[1, 2] * Y + AMatrix[1, 3];
    Result.Y := AMatrix[2, 1] * X + AMatrix[2, 2] * Y + AMatrix[2, 3];
  end;
end;

function MapPixel(const AMatrix: TMatrix; const APixel: TPlanePixel): TPlanePixel;
var
  LPoint: TPlanePoint;
begin
  LPoint := ToPoint(APixel.X + 0.5, APixel.Y + 0.5);
  LPoint := MapPoint(AMatrix, LPoint);
  Result := FloorPoint(LPoint);
end;

{ Check if an object is inside a geometric shape }

function InRegion(const ARegion, AR: TRegion): Boolean; overload;
begin
   Result := (ARegion.X1 <= AR.X1) and
             (ARegion.Y1 <= AR.Y1) and
             ((ARegion.X1 + ARegion.Width)  >= (AR.X1 + AR.Width)) and
             ((ARegion.Y1 + ARegion.Height) >= (AR.Y1 + AR.Height));
end;

function InRegion(const ARegion: TRegion; const AX, AY: Integer): Boolean; overload;
begin
  Result := (ARegion.X1 <= AX) and
            (ARegion.Y1 <= AY) and
            ((ARegion.X1 + ARegion.Width) > AX) and
            ((ARegion.Y1 + ARegion.Height) > AY);
end;

function InBound(const ABound: TBound; const AX, AY: Double): Boolean;
begin
  Result := (ABound.Xmin <= AX) and (ABound.Ymin <= AY) and
            (ABound.Xmax >= AX) and (ABound.Ymax >= AY);
end;

{ Circumscribed contour }

procedure ExtremumPoints(const APoints: array of TPlanePoint; out Xmin, Ymin, Xmax, Ymax: Double);
var
  I, L: Integer;
begin
  L := Length(APoints);
  if L = 0 then
  begin
    Xmin := NaN;
    Xmax := NaN;
    Ymin := NaN;
    Ymax := NaN;
    Exit;
  end;
  with APoints[0] do
  begin
    Xmin := X;
    Xmax := X;
    Ymin := Y;
    Ymax := Y;
  end;
  for I := 1 to L - 1 do
    with APoints[I] do
    begin
      if Xmin > X then Xmin := X;
      if Xmax < X then Xmax := X;
      if Ymin > Y then Ymin := Y;
      if Ymax < Y then Ymax := Y;
    end;
end;

function ExtremumRegion(const Xmin, Ymin, Xmax, Ymax: Double): TRegion;
begin
  with Result do
  begin
    X1 := Math.Floor(Xmin);
    Y1 := Math.Floor(Ymin);
    Width := Math.Ceil(Xmax) - Math.Floor(Xmin);
    if Width = 0 then
      Width := 1;
    Height := Math.Ceil(Ymax) - Math.Floor(Ymin);
    if Height = 0 then
      Height := 1;
    { alternative:
      X1 := Math.Floor(Xmin);
      Y1 := Math.Floor(Ymin);
      Width := Trunc(Xmax - Xmin);
      if Width = 0 then
        Width := 1;
      Height := Trunc(Ymax - Ymin);
      if Height = 0 then
        Height := 1; }
  end;
end;

{ Delineation (contouring) points of the rectangle }

function RectQuad(const AQuad: TQuad): TRegion;
var
  Xmin, Ymin, Xmax, Ymax: Double;
begin
  ExtremumPoints(AQuad.Points, {out} Xmin, {out} Ymin, {out} Xmax, {out} Ymax);
  Result := ExtremumRegion(Xmin, Ymin, Xmax, Ymax);
end;

function RectClip(const AClip: TClip): TRegion;
var
  LIndex: Integer;
  LPoints: array of TPlanePoint;
  Xmin, Ymin, Xmax, Ymax: Double;
begin
  if AClip.Count <= 2 then
  begin
    Result.X1 := 0;
    Result.Y1 := 0;
    Result.Width := 0;
    Result.Height := 0;
  end else { if AClip.Count > 2 then }
  begin
    LPoints := nil;
    SetLength(LPoints, AClip.Count);
    for LIndex := 0 to AClip.Count - 1 do
      LPoints[LIndex] := AClip.Points[LIndex];
    ExtremumPoints(LPoints, {out} Xmin, {out} Ymin, {out} Xmax, {out} Ymax);
    Result := ExtremumRegion(Xmin, Ymin, Xmax, Ymax);
  end;
end;

{ Normalization: TopLeft and Clockwise }

procedure SortTopLeftClockwise(var APoints: array of TPlanePoint; L, R: Integer);
var
  dx, dy: Double;

  function Compare(const P1, P2: TPlanePoint): Double;
  begin
    Result := (P1.Y - dy) * (P2.X - dx) - (P1.X - dx) * (P2.Y - dy);
  end;

var
  I, J: Integer;
  P, T: TPlanePoint;
begin
  dx := APoints[0].X;
  dy := APoints[0].Y;
  repeat
    I := L;
    J := R;
    P := APoints[(L + R) shr 1];
    repeat
      while Compare(APoints[I], P) < 0 do
        Inc(I);
      while Compare(APoints[J], P) > 0 do
        Dec(J);
      if I <= J then
      begin
        if I <> J then
        begin
          T := APoints[I];
          APoints[I] := APoints[J];
          APoints[J] := T;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      SortTopLeftClockwise(APoints, L, J);
    L := I;
  until I >= R;
end;

function NormQuad(const AQuad: TQuad): TQuad;
var
  I, J, I1: Integer;
  P1: TPlanePoint;
begin
  I1 := 1;
  P1 := AQuad.Points[1];
  for I := 2 to 4 do
    if (AQuad.Points[I].Y < P1.Y) or ((AQuad.Points[I].Y = P1.Y) and (AQuad.Points[I].X < P1.X)) then
    begin
      I1 := I;
      P1 := AQuad.Points[I];
    end;
  J := I1;
  for I := 1 to 4 do
  begin
    Result.Points[I] := AQuad.Points[J];
    Inc(J);
    if J > 4 then
      J := 1;
  end;
  SortTopLeftClockwise(Result.Points, 1, 3);
end;

function NormClip(const AClip: TClip): TClip;
var
  I, J, I1, N: Integer;
  P1: TPlanePoint;
begin
  N := AClip.Count;
  Result.Count := N;
  if N = 0 then
    Exit;
  I1 := 1;
  P1 := AClip.Points[1];
  for I := 2 to N do
    if (AClip.Points[I].Y < P1.Y) or ((AClip.Points[I].Y = P1.Y) and (AClip.Points[I].X < P1.X)) then
    begin
      I1 := I;
      P1 := AClip.Points[I];
    end;
  J := I1;
  for I := 1 to N do
  begin
    Result.Points[I] := AClip.Points[J];
    Inc(J);
    if J > N then
      J := 1;
  end;
  if Result.Count > 2 then
    SortTopLeftClockwise(Result.Points, 1, Result.Count - 1);
end;

{ Remove the same point }

function RemoveSamePnt(const Clip: TClip): TClip;
var
  I, J: Integer;
  P: TPlanePoint;
  IsSame: Boolean;
begin
  Result.Count := Clip.Count;
  if Clip.Count = 0 then
    Exit;
  P := Clip.Points[1];
  Result.Count := 1;
  Result.Points[1] := P;
  for I := 2 to Clip.Count do
  begin
    P := Clip.Points[I];
    IsSame := False;
    for J := 1 to Result.Count do
    begin
      IsSame := (P.X = Result.Points[J].X) and (P.Y = Result.Points[J].Y);
      if IsSame then
        Break;
    end;
    if not IsSame then
    with Result do
    begin
      Count := Count + 1;
      Points[Count] := P;
    end;
  end;
end;

{ Clipping quadrilaterals }

procedure QClip(const AWnd: TQuad; const AQuad: TQuad; out AClip: TClip); overload;

  function Location(const P: TPlanePoint; const P1, P2: TPlanePoint): TValueSign;
  var
    R1, R2: Double;
  begin
    R1 := (P.X - P1.X) * (P2.Y - P1.Y);
    R2 := (P.Y - P1.Y) * (P2.X - P1.X);
    Result := Math.Sign(R1 - R2);
  end;

  function IsCross(const P1, P2: TPlanePoint; const W1, W2: TPlanePoint): Boolean;
  var
    L1, L2: TValueSign;
  begin
    L1 := Location(P1, W1, W2);
    L2 := Location(P2, W1, W2);
    // Result := (L1 < 0) and (L2 > 0) or (L1 > 0) and (L2 < 0);
    Result := ((L1 < 0) and (L2 > 0)) or ((L1 > 0) and (L2 < 0));
  end;

  function Cross(const P1, P2: TPlanePoint; const W1, W2: TPlanePoint): TPlanePoint;
  var
    M: array [1 .. 2, 1 .. 2] of Double;
    Det, Par: Double;
  begin
    M[1, 1] := P2.X - P1.X;
    M[1, 2] := W1.X - W2.X;
    M[2, 1] := P2.Y - P1.Y;
    M[2, 2] := W1.Y - W2.Y;
    Det := M[1, 1] * M[2, 2] - M[1, 2] * M[2, 1];
    Par := (M[2, 2] * (W1.X - P1.X) - M[1, 2] * (W1.Y - P1.Y)) / Det;
    with Result do
    begin
      X := P1.X + (P2.X - P1.X) * Par;
      Y := P1.Y + (P2.Y - P1.Y) * Par;
    end;
  end;

var
  W, P, Q: TClipPoints;
  I, J: Integer;
  NW, NP, NQ: Integer;
  S, F, T: TPlanePoint;
begin
  NW := 5;
  with AWnd do
  begin
    W[1] := P4; // W[1] := P1;
    W[2] := P3; // W[2] := P2;
    W[3] := P2; // W[3] := P3;
    W[4] := P1; // W[4] := P4;
    W[5] := W[1];
  end;
  NP := 4;
  with AQuad do
  begin
    P[1] := P4; // P[1] := P1;
    P[2] := P3; // P[2] := P2;
    P[3] := P2; // P[3] := P3;
    P[4] := P1; // P[4] := P4;
  end;
  NQ := 0;
  Q[1].X := 0.0; // suplress Lazarus Warning: Local variable "Q" does not seem to be initialized
  S := ToPoint(0, 0); // suplress Lazarus Warning: Local variable "S" does not seem to be initialized
  for I := 1 to NW - 1 do
  begin
    NQ := 0;
    for J := 1 to 8 do
      Q[J] := ToPoint(0, 0);
    for J := 1 to NP do
    begin
      if (J > 1) and IsCross(S, P[J], W[I], W[I + 1]) then
      begin
        T := Cross(S, P[J], W[I], W[I + 1]);
        Inc(NQ);
        Q[NQ] := T;
      end;
      S := P[J];
      if Location(S, W[I], W[I + 1]) >= 0 then
      begin
        Inc(NQ);
        Q[NQ] := S;
      end;
    end; // for J := 1 to NP do
    F := P[1];
    if NQ <> 0 then
      if IsCross(S, F, W[I], W[I + 1]) then
      begin
        T := Cross(S, F, W[I], W[I + 1]);
        Inc(NQ);
        Q[NQ] := T;
      end;
    for J := 1 to 8 do
      P[J] := Q[J];
    NP := NQ;
  end; // for I := 1 to NW - 1 do
  // Result out: count points in Q and array points
  AClip.Count := NQ;
  for I := 1 to NQ do
    AClip.Points[I] := Q[NQ - I + 1];
  AClip := FixedRoundClip(AClip);
  AClip := RemoveSamePnt(AClip);
  AClip := NormClip(AClip);
end;

procedure QClip(const AWnd: TRegion; const AQuad: TQuad; out AClip: TClip); overload;
var
  LWnd: TQuad;
begin
  LWnd := ToQuad(AWnd);
  QClip(LWnd, AQuad, {out} AClip);
end;

{ Crossing of segment and geometric shape }

procedure YCross(const AClip: TClip; const AY: Double; out X1, X2: Double);
var
  I: Integer;
  A, B, C: Double;
  Ymin, Ymax: Double;
  LTemp: Double;
  P1, P2: TPlanePoint;
  R: Boolean;
begin
  Assert(AClip.Count > 0, SAssertionFailure);
  X1 := AClip.X1;
  X2 := AClip.X1;
  if AClip.Count = 1 then
    Exit;
  R := False;
  for I := 1 to AClip.Count do
  begin
    P1 := AClip.Points[I];
    if I = AClip.Count then
      P2 := AClip.Points[1]
    else
      P2 := AClip.Points[I + 1];
    Ymin := Math.Min(P1.Y, P2.Y);
    Ymax := Math.Max(P1.Y, P2.Y);
    if not Math.InRange(AY, Ymin, Ymax) then
      Continue;
    A := P2.Y - P1.Y;
    if A = 0 then
    begin
      if P1.Y = AY then
      begin
        X1 := P1.X;
        X2 := P2.X;
        Break;
      end
      else
        Continue;
    end;
    B := P1.X - P2.X;
    C := P2.X * P1.Y - P1.X * P2.Y;
    if R then
    begin
      X2 := - (B * AY + C) / A;
      // Break; ~ not break!
    end
    else
    begin
      X1 := - (B * AY + C) / A;
      R := True;
    end;
  end;
  if X1 > X2 then
  begin
    LTemp := X1;
    X1 := X2;
    X2 := LTemp;
  end;
end;

{ Check if chunk is within segment boundaries }

function InSegmentBound(const ASegmentPosition, ASegmentLength: Int64; const AChunkPosition: Int64): Boolean;
var
  A1, A2, B1: Int64;
begin
  A1 := ASegmentPosition;
  A2 := ASegmentLength;
  B1 := AChunkPosition;
  // Valid and Bound
  Result := (A1 >= 0) and (A2 > 0) and (B1 >= 0) and
    (A1 <= B1) and ((A1 + A2) > B1);
end;

function InSegmentBound(const ASegmentPosition, ASegmentLength: Int64; const AChunkPosition, AChunkLength: Int64): Boolean;
var
  A1, A2, B1, B2: Int64;
begin
  A1 := ASegmentPosition;
  A2 := ASegmentLength;
  B1 := AChunkPosition;
  B2 := AChunkLength;
  // Valid and Bound
  Result := (A1 >= 0) and (A2 > 0) and (B1 >= 0) and (B2 > 0) and
    (A1 <= B1) and ((A1 + A2) > B1) and (A1 <= (B1 + B2)) and ((A1 + A2) >= (B1 + B2));
end;

{ Ensure the number is a multiple, i.e. AValue:ARank=N }

function EnsureMultiply(const AValue: Int64; ARank: Integer; ARetainZeroValue: Boolean): Int64;
var
  LRemainder: Int64;
begin
  if (AValue < 0) or (ARank <= 0) then
  begin
    Result := 0;
  end else
  if AValue = 0 then
  begin
    if ARetainZeroValue then
      Result := 0
    else
      Result := ARank;
  end else
  // if (AValue > 0) and (ARank > 0) then
  begin
    LRemainder := AValue mod ARank;
    if LRemainder = 0 then
      Result := AValue
    else
      Result := AValue + (ARank - LRemainder);
  end;
end;

end.
