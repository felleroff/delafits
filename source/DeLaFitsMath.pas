{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{                Mathematics functions                 }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
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

  ERROR_MATH               = 3000;

  ERROR_MATH_NANPICTURE    = 3100;

  ERROR_MATH_MATRIX_SHIFT  = 3200;
  ERROR_MATH_MATRIX_SCALE  = 3201;
  ERROR_MATH_MATRIX_ROTATE = 3202;
  ERROR_MATH_MATRIX_SHEARX = 3203;
  ERROR_MATH_MATRIX_SHEARY = 3204;
  ERROR_MATH_MATRIX_ZTERM  = 3205;
  ERROR_MATH_MATRIX_DET    = 3206;

resourcestring

  { The messages of exceptions }

  SNanPictureIncorrect   = 'Can''t represent NaN as NaN';

  SMatrixPropIncorrect   = 'Incorrect %s value "%.4f" of affine matrix';
  SMatrixZTermIncorrect  = 'Incorrect affine matrix: Z-term not equal to (0, 0, 1)';
  SMatrixDeterminantZero = 'Incorrect affine matrix: determinant is zero';

type

  { Exception classes }

  EFitsMathException = class(EFitsException);

type

  { Swapping interface: swap value of numbers type }

  TSwapper = record
    Swap16u: function (const Value: T16u): T16u;
    Swap16c: function (const Value: T16c): T16c;
    Swap32c: function (const Value: T32c): T32c;
    Swap32f: function (const Value: T32f): T32f;
    Swap64c: function (const Value: T64c): T64c;
    Swap64f: function (const Value: T64f): T64f;
  end;

  function GetSwapper: TSwapper; overload;
  function GetSwapper(AEndianness: TEndianness): TSwapper; overload;

const

  { Min/Max numbers }

  cMin08c: T08c = Low(T08c);
  cMax08c: T08c = High(T08c);
  cMin08u: T08u = Low(T08u);
  cMax08u: T08u = High(T08u);

  cMin16c: T16c = Low(T16c);
  cMax16c: T16c = High(T16c);
  cMin16u: T16u = Low(T16u);
  cMax16u: T16u = High(T16u);

  cMin32c: T32c = Low(T32c);
  cMax32c: T32c = High(T32c);
  cMin32u: T32u = Low(T32u);
  cMax32u: T32u = High(T32u);
  cMin32f: T32f = -Math.MaxSingle;
  cMax32f: T32f =  Math.MaxSingle;

  cMin64c: T64c = Low(T64c);
  cMax64c: T64c = High(T64c);
  cMin64f: T64f = -Math.MaxDouble;
  cMax64f: T64f =  Math.MaxDouble;

  {$IFDEF HAS_EXTENDED_FLOAT}
  {$WARN SYMBOL_PLATFORM OFF}
  cMin80f: T80f = -Math.MaxExtended;
  cMax80f: T80f =  Math.MaxExtended;
  {$WARN SYMBOL_PLATFORM ON}
  {$ELSE}
  cMin80f: T80f = -Math.MaxDouble;
  cMax80f: T80f =  Math.MaxDouble;
  {$ENDIF}

  function RepIsInteger(Rep: TRepNumber): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function GetMinInteger(Rep: TRepNumber): T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function GetMaxInteger(Rep: TRepNumber): T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  function GetMinNumber(Rep: TRepNumber): T80f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function GetMaxNumber(Rep: TRepNumber): T80f; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  {$IFDEF DELA_MATH_NAN}

  // Support math NaN

  const

  cNanInteger: T64c = Low(T64c);

  function GetNanInteger: T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure SetNanInteger(const AValue: T64c);

  const

  cNanPicture: T80f = Math.NegInfinity;

  function GetNanPicture: T80f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure SetNanPicture(const AValue: T80f);

  {$ENDIF}

  // Provide an extremum

  procedure Extrema(var AMin, AMax: T80f); overload; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Extrema(var AMin, AMax: T64c); overload; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  // Ensure a range of numbers

  function Ensure64f(const AValue: T80f): T64f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure32f(const AValue: T80f): T32f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure08c(const AValue: T64c): T08c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure08u(const AValue: T64c): T08u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure16c(const AValue: T64c): T16c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure16u(const AValue: T64c): T16u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure32c(const AValue: T64c): T32c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Ensure32u(const AValue: T64c): T32u; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  // Safe rounding

  function Round08c(const AValue: Extended): T08c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round08u(const AValue: Extended): T08u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round16c(const AValue: Extended): T16c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round16u(const AValue: Extended): T16u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round32c(const AValue: Extended): T32c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round32u(const AValue: Extended): T32u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function Round64c(const AValue: Extended): T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  {$IFDEF DELA_CUSTOM_RANDOM}

  // Support custom interface of the pseudorandom number generator

  type

  IntegerRandom = {$IFDEF FPC}LongInt{$ELSE}Integer{$ENDIF};
  TCustomRandom = function (const ARange: IntegerRandom): IntegerRandom;

  function SysRandom(const ARange: IntegerRandom): IntegerRandom;

  var

  cCustomRandom: TCustomRandom = {$IFDEF FPC}TCustomRandom(@SysRandom){$ELSE}SysRandom{$ENDIF};

  function GetCustomRandom: TCustomRandom; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure SetCustomRandom(const AValue: TCustomRandom);

  {$ENDIF}

  // Shake an array: move R random elements from L to the beginning

  procedure Shake64f(var A: TA64f; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake32f(var A: TA32f; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake08u(var A: TA08u; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake16c(var A: TA16c; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake32c(var A: TA32c; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
  procedure Shake64c(var A: TA64c; const L, R: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}

  // Replace NaN-value with safe cNanPicture

  function UnNan80f(const AValue: T80f): T80f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function UnNan64f(const AValue: T64f): T64f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
  function UnNan32f(const AValue: T32f): T32f; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  // Mathematical rounding with fixed precision "1E-8" a real (R) and integer (Z) numbers

  function Roundar(const Value: Double): Double;
  function Roundaz(const Value: Double): Integer;

  // Reverse real number sign: if Value <> 0 then Value := -Value

  function Negar(const Value: Double): Double;

  // Rounds variables toward negative infinity: (-1 <~ -0.9), (-1 <~ -0.1), (0 <~ +0.1), (0 <~ +0.9)

  function FloorPnt(const P: TPnt): TPix;

  // Rounds variables up toward positive infinity: (-0.9 ~> 0), (-0.1 ~> 0), (+0.1 ~> 1), (+0.9 ~> 1)

  function CeilPnt(const P: TPnt): TPix;

  // Trunc

  function TruncPnt(const P: TPnt): TPix;

  // Mathematical rounding with fixed precision, see Roundar()

  function RoundarPnt(const P: TPnt): TPnt;
  function RoundazPnt(const P: TPnt): TPix;

  function RoundarQuad(const Quad: TQuad): TQuad;

  function RoundarClip(const Clip: TClip): TClip;

  { Affine transformations are to the matrix form in the system of homogeneous coordinates:

    |--------------------------|      X = M[1,1] * X + M[1,2] * Y + M[1,3];
    |     matrix elsemnets     |      Y = M[2,1] * X + M[2,2] * Y + M[2,3];
    |--------------------------|
    |  M[1,1]  M[2,1]  M[3,1]  |  ->  Det = M[1,1] * M[2,2] - M[2,1] * M[1,2]
    |  M[1,2]  M[2,2]  M[3,2]  |
    |  M[1,3]  M[2,3]  M[3,3]  |      Det <> 0;
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
    | T(dX, dY) | S(sX, sY) |      R(A)      |    Shr(A)   |    Shr(A)   |
    |-----------|-----------|----------------|-------------|-------------|
    |  1  0  0  | Sx  0  0  |  cosA sinA  0  |  1    0  0  |  1 tanA  0  |
    |  0  1  0  |  0 Sy  0  | -sinA cosA  0  |  tanA 1  0  |  0    1  0  |
    | dX dY  1  |  0  0  1  |     0    0  1  |  0    0  1  |  0    0  1  |
    |-----------|-----------|----------------|-------------|-------------| }

  function CreateMatrix: TMatrix;

  function CreateMatrixShift(const dX, dY: Double): TMatrix;
  function CreateMatrixScale(const sX, sY: Double): TMatrix;
  function CreateMatrixRotate(const Angle: Double): TMatrix; // clockwise
  function CreateMatrixShearX(const Angle: Double): TMatrix;
  function CreateMatrixShearY(const Angle: Double): TMatrix;

  function InvertMatrix(const Matrix: TMatrix): TMatrix;

  function MultiplyMatrix(const A, B: TMatrix): TMatrix;

  // Affine transformation float point, no check as affinity

  function MapPnt(const Matrix: TMatrix; const Pnt: TPnt): TPnt;

  // Affine transformation pixel: P.(X, Y) := Src.(X, Y) + 0.5 -> MapPnt -> FloorPnt

  function MapPix(const Matrix: TMatrix; const Pix: TPix): TPix;

  // Region include check

  function InRegion(const R: TRegion; const Rsub: TRegion): Boolean; overload;
  function InRegion(const R: TRegion; const Xsub, Ysub: Integer): Boolean; overload;

  function InBound(const B: TBound; const Xsub, Ysub: Double): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}

  // Delineation (contouring) points of the rectangle

  function RectQuad(const Quad: TQuad): TRegion;
  function RectClip(const Clip: TClip): TRegion;

  { Normalization: TopLeft and Clockwise
    P1----P2
     |    |
    P4----P3 }

  function NormQuad(const Quad: TQuad): TQuad;
  function NormClip(const Clip: TClip): TClip;

  { Clipping quadrilaterals (algorithm of Hodzhmen–Sutherland)

    Wnd - quadrangle or isothetic rectangle (defined by two integer coordinates)
    Quad - chopping off rectangle

    Return Clip - area of crossing, i.e. polygon from 1 to 8 points.
    Clip.PN = 0 if crossing is not present.
    Clip a normalization: sort as TopLeft and Clockwise }

  procedure QClip(const Wnd: TQuad; const Quad: TQuad; out Clip: TClip); overload;
  procedure QClip(const Wnd: TRegion; const Quad: TQuad; out Clip: TClip); overload;

  { Crossing of segment and area. A segment is parallel to the axis of X. Crossing
    is have!, need  to define two X-coordinates.
        *----*
        |   /
    ----|--/----- Y
        | /
        |/
        *
    Clip.PN > 0 }

  procedure YCross(const Clip: TClip; const Y: Double; out X1, X2: Double);

  // Check a boundaries of stream content

  function InContent(const Offset, Size: Int64; const SubOffset, SubSize: Int64): Boolean; overload;
  function InContent(const Offset, Size: Int64; const SubOffset: Int64): Boolean; overload;

implementation

{ TSwapper }

function beSwap16u(const Value: T16u): T16u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := Value;
end;

function beSwap16c(const Value: T16c): T16c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := Value;
end;

function beSwap32c(const Value: T32c): T32c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := Value;
end;

function beSwap32f(const Value: T32f): T32f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := Value;
end;

function beSwap64c(const Value: T64c): T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := Value;
end;

function beSwap64f(const Value: T64f): T64f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := Value;
end;

function leSwap16u(const Value: T16u): T16u; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := System.Swap(Value);
end;

function leSwap16c(const Value: T16c): T16c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := T16c(System.Swap(Value));
end;

type

  TRec32 = packed record
    Lo, Hi: T16u;
  end;

function leSwap32c(const Value: T32c): T32c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  R: TRec32;
begin
  R := TRec32(Value);
  TRec32(Result).Hi := Swap(R.Lo);
  TRec32(Result).Lo := Swap(R.Hi);
end;

function leSwap32f(const Value: T32f): T32f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  R: TRec32;
begin
  R := TRec32(Value);
  TRec32(Result).Hi := Swap(R.Lo);
  TRec32(Result).Lo := Swap(R.Hi);
end;

type

  TRec64 = packed record
    Lo, Hi: T32u;
  end;

function leSwap64c(const Value: T64c): T64c; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  with TRec64(Value) do
  begin
    TRec64(Result).Hi := (Lo shr 24) or (Lo shl 24) or ((Lo and $00FF0000) shr 8) or ((Lo and $0000FF00) shl 8);
    TRec64(Result).Lo := (Hi shr 24) or (Hi shl 24) or ((Hi and $00FF0000) shr 8) or ((Hi and $0000FF00) shl 8);
  end;
end;

function leSwap64f(const Value: T64f): T64f; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  with TRec64(Value) do
  begin
    TRec64(Result).Hi := (Lo shr 24) or (Lo shl 24) or ((Lo and $00FF0000) shr 8) or ((Lo and $0000FF00) shl 8);
    TRec64(Result).Lo := (Hi shr 24) or (Hi shl 24) or ((Hi and $00FF0000) shr 8) or ((Hi and $0000FF00) shl 8);
  end;
end;

function GetSwapper: TSwapper; overload;
var
  Endianness: TEndianness;
begin
  Endianness := GetEndianness;
  Result := GetSwapper(Endianness);
end;

function GetSwapper(AEndianness: TEndianness): TSwapper; overload;
begin
  if AEndianness = sysBE then
  begin
    Result.Swap16u := {$IFDEF FPC}@{$ENDIF}beSwap16u;
    Result.Swap16c := {$IFDEF FPC}@{$ENDIF}beSwap16c;
    Result.Swap32c := {$IFDEF FPC}@{$ENDIF}beSwap32c;
    Result.Swap32f := {$IFDEF FPC}@{$ENDIF}beSwap32f;
    Result.Swap64c := {$IFDEF FPC}@{$ENDIF}beSwap64c;
    Result.Swap64f := {$IFDEF FPC}@{$ENDIF}beSwap64f;
  end
  else { sysLE }
  begin
    Result.Swap16u := {$IFDEF FPC}@{$ENDIF}leSwap16u;
    Result.Swap16c := {$IFDEF FPC}@{$ENDIF}leSwap16c;
    Result.Swap32c := {$IFDEF FPC}@{$ENDIF}leSwap32c;
    Result.Swap32f := {$IFDEF FPC}@{$ENDIF}leSwap32f;
    Result.Swap64c := {$IFDEF FPC}@{$ENDIF}leSwap64c;
    Result.Swap64f := {$IFDEF FPC}@{$ENDIF}leSwap64f;
  end;
end;

{ Numbers }

function RepIsInteger(Rep: TRepNumber): Boolean;
begin
  Result := Rep >= rep08c;
end;

function GetMinInteger(Rep: TRepNumber): T64c;
begin
  case Rep of
    rep08c: Result := cMin08c;
    rep08u: Result := cMin08u;
    rep16c: Result := cMin16c;
    rep16u: Result := cMin16u;
    rep32c: Result := cMin32c;
    rep32u: Result := cMin32u;
    else    Result := cMin64c;
  end;
end;

function GetMaxInteger(Rep: TRepNumber): T64c;
begin
   case Rep of
    rep08c: Result := cMax08c;
    rep08u: Result := cMax08u;
    rep16c: Result := cMax16c;
    rep16u: Result := cMax16u;
    rep32c: Result := cMax32c;
    rep32u: Result := cMax32u;
    else    Result := cMax64c;
  end;
end;

function GetMinNumber(Rep: TRepNumber): T80f;
begin
  case Rep of
    repUnknown: Result := Math.NegInfinity;
    rep80f    : Result := cMin80f;
    rep64f    : Result := cMin64f;
    rep32f    : Result := cMin32f;
    else        Result := GetMinInteger(Rep);
  end;
end;

function GetMaxNumber(Rep: TRepNumber): T80f;
begin
  case Rep of
    repUnknown: Result := Math.Infinity;
    rep80f    : Result := cMax80f;
    rep64f    : Result := cMax64f;
    rep32f    : Result := cMax32f;
    else        Result := GetMaxInteger(Rep);
  end;
end;

{$IFDEF DELA_MATH_NAN}

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
    raise EFitsMathException.Create(SNanPictureIncorrect, ERROR_MATH_NANPICTURE);
  P80f(@cNanPicture)^ := AValue;
end;

{$ENDIF}

procedure Extrema(var AMin, AMax: T80f);
var
  Value: T80f;
begin
  if AMin > AMax then
  begin
    Value := AMin;
    AMin  := AMax;
    AMax  := Value;
  end;
end;

procedure Extrema(var AMin, AMax: T64c);
var
  Value: T64c;
begin
  if AMin > AMax then
  begin
    Value := AMin;
    AMin  := AMax;
    AMax  := Value;
  end;
end;

function Ensure64f(const AValue: T80f): T64f;
begin
  {$IFDEF DELA_MATH_NAN}
  if Math.IsNan(AValue) or Math.IsInfinite(AValue) then
  begin
    Result := AValue;
    Exit;
  end;
  {$ENDIF}
  Result := Math.EnsureRange(AValue, cMin64f, cMax64f);
end;

function Ensure32f(const AValue: T80f): T32f;
begin
  {$IFDEF DELA_MATH_NAN}
  if Math.IsNan(AValue) or Math.IsInfinite(AValue) then
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

// Round

function Round08c(const AValue: Extended): T08c;
begin
  {$IFDEF DELA_MATH_NAN}
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
  {$IFDEF DELA_MATH_NAN}
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
  {$IFDEF DELA_MATH_NAN}
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
  {$IFDEF DELA_MATH_NAN}
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
  {$IFDEF DELA_MATH_NAN}
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
  {$IFDEF DELA_MATH_NAN}
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
  {$IFDEF DELA_MATH_NAN}
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

{$IFDEF DELA_CUSTOM_RANDOM}

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

// Shake

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
      J := I + {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
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
      J := I + {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
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
      J := I + {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
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
      J := I + {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
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
      J := I + {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
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
      J := I + {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[I];
      A[I] := A[J];
      A[J] := Temp;
    end
  else
    for I := 0 to (L - R) - 1 do
    begin
      K := (L - 1) - I;
      J := {$IFDEF DELA_CUSTOM_RANDOM}cCustomRandom(K + 1){$ELSE}Random(K + 1){$ENDIF};
      Temp := A[K];
      A[K] := A[J];
      A[J] := Temp;
    end;
end;

// UnNan

function UnNan80f(const AValue: T80f): T80f;
begin
  Result := AValue;
  {$IFDEF DELA_MATH_NAN}
  if Math.IsNan(Result) then
    Result := cNanPicture;
  {$ENDIF}
end;

function UnNan64f(const AValue: T64f): T64f;
begin
  Result := AValue;
  {$IFDEF DELA_MATH_NAN}
  if Math.IsNan(Result) then
    Result := cNanPicture;
  {$ENDIF}
end;

function UnNan32f(const AValue: T32f): T32f;
begin
  Result := AValue;
  {$IFDEF DELA_MATH_NAN}
  if Math.IsNan(Result) then
    Result := cNanPicture;
  {$ENDIF}
end;

{ Mathematical rounding with fixed precision }

function SimpleRoundarTo(const Value: Double; Precision: Integer): Double;
begin
  // Error in Math.SimpleRoundTo of VER150
  Result := Math.SimpleRoundTo(Abs(Value), Precision);
  if Value < 0 then
    Result := Negar(Result);
end;

function Roundar(const Value: Double): Double;
const
  cPrecision = -8;
begin
  Result := SimpleRoundarTo(Value, cPrecision);
end;

function Roundaz(const Value: Double): Integer;
var
  V: Double;
begin
  V := SimpleRoundarTo(Value, 0);
  Result := Trunc(V);
end;

function Negar(const Value: Double): Double;
begin
  if Math.IsZero(Value) then
    Result := 0.0
  else
    Result := -Value;
end;

function FloorPnt(const P: TPnt): TPix;
begin
  Result.X := Math.Floor(P.X);
  Result.Y := Math.Floor(P.Y);
end;

function CeilPnt(const P: TPnt): TPix;
begin
  Result.X := Math.Ceil(P.X);
  Result.Y := Math.Ceil(P.Y);
end;

function TruncPnt(const P: TPnt): TPix;
begin
  Result.X := Trunc(P.X);
  Result.Y := Trunc(P.Y);
end;

function RoundarPnt(const P: TPnt): TPnt;
begin
  Result.X := Roundar(P.X);
  Result.Y := Roundar(P.Y);
end;

function RoundazPnt(const P: TPnt): TPix;
begin
  Result.X := Roundaz(P.X);
  Result.Y := Roundaz(P.Y);
end;

function RoundarQuad(const Quad: TQuad): TQuad;
var
  I: Integer;
begin
  for I := 1 to 4 do
     Result.PA[I] := RoundarPnt(Quad.PA[I]);
end;

function RoundarClip(const Clip: TClip): TClip;
var
  I: Integer;
begin
  Result.PN := Clip.PN;
  for I := 1 to Clip.PN do
    Result.PA[I] := RoundarPnt(Clip.PA[I]);
end;

// SusZero: calculate the expression with suspicion of zero

function SusZero(const Value, Expression: Double): Double; overload;
begin
  if Math.IsZero(Value) then
    Result := 0.0
  else
    Result := Expression;
end;

function SusZero(const Value: Double): Double; overload;
begin
  if Math.IsZero(Value) then
    Result := 0.0
  else
    Result := Value
end;

// Affine transformations

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

function CreateMatrixShift(const dX, dY: Double): TMatrix;
begin
  if Math.IsNan(dX) or Math.IsInfinite(dX) then
    raise EFitsMathException.CreateFmt(SMatrixPropIncorrect, ['shift', dX], ERROR_MATH_MATRIX_SHIFT);
  if Math.IsNan(dY) or Math.IsInfinite(dY) then
    raise EFitsMathException.CreateFmt(SMatrixPropIncorrect, ['shift', dY], ERROR_MATH_MATRIX_SHIFT);
  Result := CreateMatrix;
  Result[1, 3] := dX;
  Result[2, 3] := dY;
end;

function CreateMatrixScale(const sX, sY: Double): TMatrix;
begin
  if Math.IsNan(sX) or Math.IsInfinite(sX) or Math.IsZero(sX) then
    raise EFitsMathException.CreateFmt(SMatrixPropIncorrect, ['scale', sX], ERROR_MATH_MATRIX_SCALE);
  if Math.IsNan(sY) or Math.IsInfinite(sY) or Math.IsZero(sY) then
    raise EFitsMathException.CreateFmt(SMatrixPropIncorrect, ['scale', sY], ERROR_MATH_MATRIX_SCALE);
  Result := CreateMatrix;
  Result[1, 1] := sX;
  Result[2, 2] := sY;
end;

function CreateMatrixRotate(const Angle: Double): TMatrix;
var
  cosA, sinA: Double;
begin
  if Math.IsNan(Angle) or Math.IsInfinite(Angle) then
    raise EFitsMathException.CreateFmt(SMatrixPropIncorrect, ['rotation', Angle], ERROR_MATH_MATRIX_ROTATE);
  Result := CreateMatrix;
  cosA := Roundar(Cos(Angle * PI / 180));
  sinA := Roundar(Sin(Angle * PI / 180));
  Result[1, 1] := cosA;
  Result[2, 1] := sinA;
  Result[2, 2] := cosA;
  Result[1, 2] := Negar(sinA);
end;

function CreateMatrixShearX(const Angle: Double): TMatrix;
var
  tanA: Double;
begin
  if Math.IsNan(Angle) or Math.IsInfinite(Angle) or
     (Angle < -90) or (Angle > 90) or Math.SameValue(Abs(Angle), 90.0) then
       raise EFitsMathException.CreateFmt(SMatrixPropIncorrect, ['X shear', Angle], ERROR_MATH_MATRIX_SHEARX);
  Result := CreateMatrix;
  tanA := Roundar(Tan(Angle * PI / 180));
  Result[1, 2] := tanA;
end;

function CreateMatrixShearY(const Angle: Double): TMatrix;
var
  tanA: Double;
begin
  if Math.IsNan(Angle) or Math.IsInfinite(Angle) or
     (Angle < -90) or (Angle > 90) or Math.SameValue(Abs(Angle), 90.0) then
       raise EFitsMathException.CreateFmt(SMatrixPropIncorrect, ['Y shear', Angle], ERROR_MATH_MATRIX_SHEARY);
  Result := CreateMatrix;
  tanA := Roundar(Tan(Angle * PI / 180));
  Result[2, 1] := tanA;
end;

function GetMatrixDeterminant(const Matrix: TMatrix): Double;
begin
  Result := Matrix[1, 1] * Matrix[2, 2] - Matrix[2, 1] * Matrix[1, 2];
  Result := Roundar(Result);
end;

procedure CheckMatrixAffinity(const Matrix: TMatrix);
var
  ZTerm: Boolean;
  Det: Double;
begin
  ZTerm := (Matrix[3,1] = 0) and (Matrix[3,2] = 0) and (Matrix[3,3] = 1);
  if not zTerm then
    raise EFitsMathException.Create(SMatrixZTermIncorrect, ERROR_MATH_MATRIX_ZTERM);
  Det := GetMatrixDeterminant(Matrix);
  if Det = 0 then
    raise EFitsMathException.Create(SMatrixDeterminantZero, ERROR_MATH_MATRIX_DET);
end;

function InvertMatrix(const Matrix: TMatrix): TMatrix;
var
  Det: Double;
begin
  CheckMatrixAffinity(Matrix);
  Result := CreateMatrix;
  Det := GetMatrixDeterminant(Matrix);
  Result[1, 1] := SusZero(Matrix[2, 2], Matrix[2, 2] / Det);
  Result[1, 2] := SusZero(Matrix[1, 2], -Matrix[1, 2] / Det);
  Result[1, 3] := SusZero((Matrix[1, 2] * Matrix[2, 3] - Matrix[2, 2] * Matrix[1, 3]) / Det);
  Result[2, 1] := SusZero(Matrix[2, 1], -Matrix[2, 1] / Det);
  Result[2, 2] := SusZero(Matrix[1, 1], Matrix[1, 1] / Det);
  Result[2, 3] := SusZero((Matrix[2, 1] * Matrix[1, 3] - Matrix[1, 1] * Matrix[2, 3]) / Det);
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

function MapPnt(const Matrix: TMatrix; const Pnt: TPnt): TPnt;
begin
  with Pnt do
  begin
    Result.X := Matrix[1, 1] * X + Matrix[1, 2] * Y + Matrix[1, 3];
    Result.Y := Matrix[2, 1] * X + Matrix[2, 2] * Y + Matrix[2, 3];
  end;
end;

function MapPix(const Matrix: TMatrix; const Pix: TPix): TPix;
var
  P: TPnt;
begin
  P := ToPnt(Pix.X + 0.5, Pix.Y + 0.5);
  P := MapPnt(Matrix, P);
  Result := FloorPnt(P);
end;

function InRegion(const R, Rsub: TRegion): Boolean; overload;
begin
   Result := (R.X1 <= Rsub.X1) and
             (R.Y1 <= Rsub.Y1) and
             ((R.X1 + R.Width)  >= (Rsub.X1 + Rsub.Width)) and
             ((R.Y1 + R.Height) >= (Rsub.Y1 + Rsub.Height));
end;

function InRegion(const R: TRegion; const Xsub, Ysub: Integer): Boolean; overload;
begin
  Result := (R.X1 <= Xsub) and
            (R.Y1 <= Ysub) and
            ((R.X1 + R.Width) > Xsub) and
            ((R.Y1 + R.Height) > Ysub);
end;

function InBound(const B: TBound; const Xsub, Ysub: Double): Boolean;
begin
  Result := (B.Xmin <= Xsub) and (B.Ymin <= Ysub) and
            (B.Xmax >= Xsub) and (B.Ymax >= Ysub);
end;

procedure ExtremumPnts(const Pnts: array of TPnt; out Xmin, Ymin, Xmax, Ymax: Double);
var
  I, L: Integer;
begin
  L := Length(Pnts);
  if L = 0 then
  begin
    Xmin := NaN;
    Xmax := NaN;
    Ymin := NaN;
    Ymax := NaN;
    Exit;
  end;
  with Pnts[0] do
  begin
    Xmin := X;
    Xmax := X;
    Ymin := Y;
    Ymax := Y;
  end;
  for I := 1 to L - 1 do
  with Pnts[I] do
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

function RectQuad(const Quad: TQuad): TRegion;
var
  Xmin, Ymin, Xmax, Ymax: Double;
begin
  ExtremumPnts(Quad.PA, Xmin, Ymin, Xmax, Ymax);
  Result := ExtremumRegion(Xmin, Ymin, Xmax, Ymax);
end;

function RectClip(const Clip: TClip): TRegion;
var
  I: Integer;
  Pnts: array of TPnt;
  Xmin, Ymin, Xmax, Ymax: Double;
begin
  if Clip.PN <= 2 then
  begin
    Result.X1 := 0;
    Result.Y1 := 0;
    Result.Width := 0;
    Result.Height := 0;
    Exit;
  end;
  Pnts := nil;
  SetLength(Pnts, Clip.PN);
  for I := 0 to Clip.PN - 1 do
    Pnts[I] := Clip.PA[I];
  ExtremumPnts(Pnts, Xmin, Ymin, Xmax, Ymax);
  Pnts := nil;
  Result := ExtremumRegion(Xmin, Ymin, Xmax, Ymax);
end;

procedure SortTopLeftClockwise(var Pnts: array of TPnt; L, R: Integer);
var
  dx, dy: Double;
  function Compare(const P1, P2: TPnt): Double;
  begin
    Result := (P1.Y - dy) * (P2.X - dx) - (P1.X - dx) * (P2.Y - dy);
  end;
var
  I, J: Integer;
  P, T: TPnt;
begin
  dx := Pnts[0].X;
  dy := Pnts[0].Y;
  repeat
    I := L;
    J := R;
    P := Pnts[(L + R) shr 1];
    repeat
      while Compare(Pnts[I], P) < 0 do
        Inc(I);
      while Compare(Pnts[J], P) > 0 do
        Dec(J);
      if I <= J then
      begin
        if I <> J then
        begin
          T := Pnts[I];
          Pnts[I] := Pnts[J];
          Pnts[J] := T;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      SortTopLeftClockwise(Pnts, L, J);
    L := I;
  until I >= R;
end;

function NormQuad(const Quad: TQuad): TQuad;
var
  I, J, I1: Integer;
  P1: TPnt;
begin
  I1 := 1;
  P1 := Quad.PA[1];
  for I := 2 to 4 do
    if (Quad.PA[I].Y < P1.Y) or ((Quad.PA[I].Y = P1.Y) and (Quad.PA[I].X < P1.X)) then
    begin
      I1 := I;
      P1 := Quad.PA[I];
    end;
  J := I1;
  for I := 1 to 4 do
  begin
    Result.PA[I] := Quad.PA[J];
    Inc(J);
    if J > 4 then
      J := 1;
  end;
  SortTopLeftClockwise(Result.PA, 1, 3);
end;

function NormClip(const Clip: TClip): TClip;
var
  I, J, I1, N: Integer;
  P1: TPnt;
begin
  N := Clip.PN;
  Result.PN := N;
  if N = 0 then
    Exit;
  I1 := 1;
  P1 := Clip.PA[1];
  for I := 2 to N do
    if (Clip.PA[I].Y < P1.Y) or ((Clip.PA[I].Y = P1.Y) and (Clip.PA[I].X < P1.X)) then
    begin
      I1 := I;
      P1 := Clip.PA[I];
    end;
  J := I1;
  for I := 1 to N do
  begin
    Result.PA[I] := Clip.PA[J];
    Inc(J);
    if J > N then
      J := 1;
  end;
  if Result.PN > 2 then
    SortTopLeftClockwise(Result.PA, 1, Result.PN - 1);
end;

// Remove the same point

function RemoveSamePnt(const Clip: TClip): TClip;
var
  I, J: Integer;
  P: TPnt;
  IsSame: Boolean;
begin
  Result.PN := Clip.PN;
  if Clip.PN = 0 then
    Exit;
  P := Clip.PA[1];
  Result.PN := 1;
  Result.PA[1] := P;
  for I := 2 to Clip.PN do
  begin
    P := Clip.PA[I];
    IsSame := False;
    for J := 1 to Result.PN do
    begin
      IsSame := (P.X = Result.PA[J].X) and (P.Y = Result.PA[J].Y);
      if IsSame then
        Break;
    end;
    if not IsSame then
    with Result do
    begin
      PN := PN + 1;
      PA[PN] := P;
    end;
  end;
end;

procedure QClip(const Wnd: TQuad; const Quad: TQuad; out Clip: TClip); overload;

  function Location(const P: TPnt; const P1, P2: TPnt): TValueSign;
  var
    R1, R2: Double;
  begin
    R1 := (P.X - P1.X) * (P2.Y - P1.Y);
    R2 := (P.Y - P1.Y) * (P2.X - P1.X);
    Result := Math.Sign(R1 - R2);
  end;

  function IsCross(const P1, P2: TPnt; const W1, W2: TPnt): Boolean;
  var
    L1, L2: TValueSign;
  begin
    L1 := Location(P1, W1, W2);
    L2 := Location(P2, W1, W2);
    //Result := (L1 < 0) and (L2 > 0) or (L1 > 0) and (L2 < 0);
    Result := ((L1 < 0) and (L2 > 0)) or ((L1 > 0) and (L2 < 0));
  end;

  function Cross(const P1, P2: TPnt; const W1, W2: TPnt): TPnt;
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
  //
var
  W, P, Q: TPntsClip;
var
  I, J: Integer;
  NW, NP, NQ: Integer;
  S, F, T: TPnt;
begin
  NW := 5;
  with Wnd do
  begin
    W[1] := P4; // W[1] := P1;
    W[2] := P3; // W[2] := P2;
    W[3] := P2; // W[3] := P3;
    W[4] := P1; // W[4] := P4;
    W[5] := W[1];
  end;
  NP := 4;
  with Quad do
  begin
    P[1] := P4; // P[1] := P1;
    P[2] := P3; // P[2] := P2;
    P[3] := P2; // P[3] := P3;
    P[4] := P1; // P[4] := P4;
  end;
  NQ := 0;
  Q[1].X := 0.0;    // suplress Lazarus Warning: Local variable "Q" does not seem to be initialized
  S := ToPnt(0, 0); // suplress Lazarus Warning: Local variable "S" does not seem to be initialized
  for I := 1 to NW - 1 do
  begin
    NQ := 0;
    for J := 1 to 8 do
      Q[J] := ToPnt(0, 0);
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
  Clip.PN := NQ;
  for I := 1 to NQ do
    Clip.PA[I] := Q[NQ - I + 1];
  Clip := RoundarClip(Clip);
  Clip := RemoveSamePnt(Clip);
  Clip := NormClip(Clip);
end;

procedure QClip(const Wnd: TRegion; const Quad: TQuad; out Clip: TClip); overload;
var
  W: TQuad;
begin
  W := ToQuad(Wnd);
  QClip(W, Quad, Clip);
end;

procedure YCross(const Clip: TClip; const Y: Double; out X1, X2: Double);
var
  I: Integer;
  A, B, C: Double;
  Ymin, Ymax, X: Double;
  P1, P2: TPnt;
  R: Boolean;
begin
  Assert(Clip.PN > 0, SAssertionFailure);
  X1 := Clip.X1;
  X2 := Clip.X1;
  if Clip.PN = 1 then
    Exit;
  R := False;
  for I := 1 to Clip.PN do
  begin
    P1 := Clip.PA[I];
    if I = Clip.PN then
      P2 := Clip.PA[1]
    else
      P2 := Clip.PA[I + 1];
    Ymin := Math.Min(P1.Y, P2.Y);
    Ymax := Math.Max(P1.Y, P2.Y);
    if not Math.InRange(Y, Ymin, Ymax) then
      Continue;
    A := P2.Y - P1.Y;
    if A = 0 then
    begin
      if P1.Y = Y then
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
      X2 := - (B * Y + C) / A;
      // Break; ~ not break!
    end
    else
    begin
      X1 := - (B * Y + C) / A;
      R := True;
    end;
  end;
  if X1 > X2 then
  begin
    X := X1;
    X1 := X2;
    X2 := X;
  end;
end;

function InContent(const Offset, Size: Int64; const SubOffset, SubSize: Int64): Boolean; overload;
var
  A1, A2: Int64;
  B1, B2: Int64;
begin
  A1 := Offset;
  A2 := Math.IfThen(Size = 0, Offset, Offset + Size - 1);
  B1 := SubOffset;
  B2 := Math.IfThen(SubSize = 0, SubOffset, SubOffset + SubSize - 1);
  Result := (A1 >= 0) and (B1 >= 0) and (A1 <= A2) and (B1 <= B2) and (A1 <= B1) and (A2 >= B2);
end;

function InContent(const Offset, Size: Int64; const SubOffset: Int64): Boolean; overload;
var
  A1, A2: Int64;
begin
  A1 := Offset;
  A2 := Math.IfThen(Size = 0, Offset, Offset + Size - 1);
  Result := Math.InRange(SubOffset, A1, A2);
end;

end.
