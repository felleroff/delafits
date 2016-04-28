{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{    Mathematics: affine transformations, matrices,    }
{        direct intersection, clipping regions         }
{                                                      }
{                 System coordinates:                  }
{                          -Y                          }
{                           |                          }
{                           |                          }
{                   -X -----0----- +X                  }
{                           |                          }
{                           |                          }
{                          +Y                          }
{                                                      }
{        Copyright(c) 2013-2016, Evgeniy Dikov         }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsMath;

interface

uses
  Math, DeLaFitsCommon;

const

  ERROR_MATH            = 4000;
  ERROR_MATRIX_ZTERM    = 4001;
  ERROR_MATRIX_DET_ZERO = 4002;

  eMatrixZTerm   = 'Violation of the affine properties of matrix. Z-term different from (0, 0, 1)';
  eMatrixDetZero = 'Violation of the affine properties of matrix. The determinant of matrix is equal to the zero';

type

  EFitsMathException = class(EFitsException);

  // Rounding to a given accuracy, -8
  function MathRoundTo(const Value: Double): Double;

  // Mathematical rounding to the nearest whole
  function MathRound(const Value: Double): Integer;

  // if Value <> 0 then Value := -Value
  function MathNeg(const Value: Double): Double;

  // +0.1 ~  0;
  // -0.1 ~ -1;
  function FloorPnt(const P: TPnt): TPix;
  // +0.1 ~ 1;
  // -0.1 ~ 0;
  function CeilPnt(const P: TPnt): TPix;
  // Mathematical rounding
  function RoundPnt(const P: TPnt): TPix;
  // Trunc
  function TruncPnt(const P: TPnt): TPix;

  // Rounding to a given accuracy, see MathRoundTo
  function RoundToPnt(const P: TPnt): TPnt;
  function RoundToQuad(const Quad: TQuad): TQuad;
  function RoundToClip(const Clip: TClip): TClip;

  { Matrix. Affine transformations are to the matrix form in the system of
    homogeneous coordinates:

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
    |    Trn    |    Scl    |      Rot       |     Shx     |     Shy     |
    | T(dX, dY) | S(sX, sY) |      R(A)      |    Shr(A)   |    Shr(A)   |
    |-----------|-----------|----------------|-------------|-------------|
    |  1  0  0  | Sx  0  0  |  cosA sinA  0  |  1    0  0  |  1 tanA  0  |
    |  0  1  0  |  0 Sy  0  | -sinA cosA  0  |  tanA 1  0  |  0    1  0  |
    | dX dY  1  |  0  0  1  |     0    0  1  |  0    0  1  |  0    0  1  |
    |-----------|-----------|----------------|-------------|-------------| }

  function MatrixInit: TMatrix; overload;

  function MatrixMakeAsTrn(const dX, dY: Double): TMatrix;
  function MatrixMakeAsScl(const sX, sY: Double): TMatrix;
  function MatrixMakeAsRot(const Angle: Double): TMatrix;
  function MatrixMakeAsShx(const Angle: Double): TMatrix;
  function MatrixMakeAsShy(const Angle: Double): TMatrix;

  function MatrixInverse(const Matrix: TMatrix): TMatrix;

  function MatrixMultiply(const A, B: TMatrix): TMatrix;

  // Affine transformation float point, no check as affinity
  function MapPnt(const Matrix: TMatrix; const Pnt: TPnt): TPnt;

  // Affine transformation pixel: P.(X, Y) := Src.(X, Y) + 0.5 -> MapPnt -> FloorPnt
  function MapPix(const Matrix: TMatrix; const Pix: TPix): TPix;

  // Line density of plane
  function LineDensity(const Matrix: TMatrix): TLineDensity;

  // Delineation (contouring) points of the rectangle
  function RectQuad(const Quad: TQuad): TRgn;
  function RectClip(const Clip: TClip): TRgn;

  { Normalization: TopLeft and Clockwise
    P1----P2
     |    |
    P4----P3 }

  function NormQuad(const Quad: TQuad): TQuad;
  function NormClip(const Clip: TClip): TClip;

  { Clipping of rectangles:
    Wnd  - a window is a rectangle:
             1) TQuad;
             2) isothetic, defined by two integer coordinates;
    Quad - chopping off rectangle;
    Clip - result, area of crossing, polygon (from 1 to 8 points). Clip.PN = 0 
           if crossing is not present. Clip a normalization: sort as TopLeft
           and Clockwise;
    The algorithm of Hodzhmen–Sutherland is used }

  procedure Clipping(const Wnd: TQuad; const Quad: TQuad; out Clip: TClip); overload;
  procedure Clipping(const Wnd: TRgn; const Quad: TQuad; out Clip: TClip); overload;

  { Crossing of segment and area. A segment is parallel to the axis of X. Crossing
    is have!, need  to define two X-coordinates.
        *----*
        |   /
    ----|--/----- Y
        | /
        |/
        *
    Clip.PN > 0 }

  procedure YCrossing(const Clip: TClip; const Y: Double; out X1, X2: Double);

implementation

function MathSimpleRoundTo(const Value: Double; Precision: Integer): Double;
begin
  // Error in Math.SimpleRoundTo of VER150
  Result := Math.SimpleRoundTo(Abs(Value), Precision);
  if Value < 0 then
    Result := MathNeg(Result);
end;

function MathRoundTo(const Value: Double): Double;
const
  cPrecision = -8;
begin
  Result := MathSimpleRoundTo(Value, cPrecision);
end;

function MathRound(const Value: Double): Integer;
var
  V: Double;
begin
  V := MathSimpleRoundTo(Value, 0);
  Result := Trunc(V);
end;

function MathNeg(const Value: Double): Double;
begin
  if Math.IsZero(Value) then
    Result := 0
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

function RoundPnt(const P: TPnt): TPix;
begin
  Result.X := MathRound(P.X);
  Result.Y := MathRound(P.Y);
end;

function RoundToPnt(const P: TPnt): TPnt;
begin
  Result.X := MathRoundTo(P.X);
  Result.Y := MathRoundTo(P.Y);
end;

function TruncPnt(const P: TPnt): TPix;
begin
  Result.X := Trunc(P.X);
  Result.Y := Trunc(P.Y);
end;

function RoundToQuad(const Quad: TQuad): TQuad;
var
  I: Integer;
begin
  for I := 1 to 4 do
     Result.PA[I] := RoundToPnt(Quad.PA[I]);
end;

function RoundToClip(const Clip: TClip): TClip;
var
  I: Integer;
begin
  Result.PN := Clip.PN;
  for I := 1 to Clip.PN do
    Result.PA[I] := RoundToPnt(Clip.PA[I]);
end;

// SusZero: calculate the expression with suspicion of zero

function SusZero(const Value, Expression: Double): Double; overload;
begin
  if Math.IsZero(Value) then
    Result := 0
  else
    Result := Expression;
end;

function SusZero(const Value: Double): Double; overload;
begin
  if Math.IsZero(Value) then
    Result := 0
  else
    Result := Value
end;

function MatrixInit: TMatrix; overload;
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

function MatrixMakeAsTrn(const dX, dY: Double): TMatrix;
begin
  Result := MatrixInit;
  Result[1, 3] := dX;
  Result[2, 3] := dY;
end;

function MatrixMakeAsScl(const sX, sY: Double): TMatrix;
begin
  Result := MatrixInit;
  Result[1, 1] := sX;
  Result[2, 2] := sY;
end;

function MatrixMakeAsRot(const Angle: Double): TMatrix;
var
  cosA, sinA: Double;
begin
  Result := MatrixInit;
  cosA := MathRoundTo(Cos(Angle * PI / 180));
  sinA := MathRoundTo(Sin(Angle * PI / 180));
  Result[1, 1] := cosA;
  Result[2, 1] := sinA;
  Result[2, 2] := cosA;
  Result[1, 2] := MathNeg(sinA);
end;

function MatrixMakeAsShx(const Angle: Double): TMatrix;
var
  tanA: Double;
begin
  Result := MatrixInit;
  tanA := MathRoundTo(Tan(Angle * PI / 180));
  Result[1, 2] := tanA;
end;

function MatrixMakeAsShy(const Angle: Double): TMatrix;
var
  tanA: Double;
begin
  Result := MatrixInit;
  tanA := MathRoundTo(Tan(Angle * PI / 180));
  Result[2, 1] := tanA;
end;

function MatrixDeterminant(const Matrix: TMatrix): Double;
begin
  Result := Matrix[1, 1] * Matrix[2, 2] - Matrix[2, 1] * Matrix[1, 2];
  Result := MathRoundTo(Result);
end;

procedure MatrixCheckAffinity(const Matrix: TMatrix);
var
  ZTerm: Boolean;
  Det: Double;
begin
  ZTerm := (Matrix[3,1] = 0) and (Matrix[3,2] = 0) and (Matrix[3,3] = 1);
  if not zTerm then
    raise EFitsMathException.Create(eMatrixZTerm, ERROR_MATRIX_ZTERM);
  Det := MatrixDeterminant(Matrix);
  if Det = 0 then
    raise EFitsMathException.Create(eMatrixDetZero, ERROR_MATRIX_DET_ZERO);
end;

function MatrixInverse(const Matrix: TMatrix): TMatrix;
var
  Det: Double;
begin
  MatrixCheckAffinity(Matrix);
  Result := MatrixInit;
  Det := MatrixDeterminant(Matrix);
  Result[1, 1] := SusZero(Matrix[2, 2], Matrix[2, 2] / Det);
  Result[1, 2] := SusZero(Matrix[1, 2], -Matrix[1, 2] / Det);
  Result[1, 3] := SusZero((Matrix[1, 2] * Matrix[2, 3] - Matrix[2, 2] * Matrix[1, 3]) / Det);
  Result[2, 1] := SusZero(Matrix[2, 1], -Matrix[2, 1] / Det);
  Result[2, 2] := SusZero(Matrix[1, 1], Matrix[1, 1] / Det);
  Result[2, 3] := SusZero((Matrix[2, 1] * Matrix[1, 3] - Matrix[1, 1] * Matrix[2, 3]) / Det);
end;

function MatrixMultiply(const A, B: TMatrix): TMatrix;
begin
  MatrixCheckAffinity(A);
  MatrixCheckAffinity(B);
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

function ExtremumRgn(const Xmin, Ymin, Xmax, Ymax: Double): TRgn;
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

function LineDensity(const Matrix: TMatrix): TLineDensity;
const
  cLen = 1000;
var
  P: TPnt;
  Xmin, Ymin, Xmax, Ymax: Double;
  procedure MinMax;
  begin
    if Xmin > P.X then Xmin := P.X;
    if Xmax < P.X then Xmax := P.X;
    if Ymin > P.Y then Ymin := P.Y;
    if Ymax < P.Y then Ymax := P.Y;
  end;
begin
  // P1
  P := MapPnt(Matrix, ToPnt(0, 0));
  Xmin := P.X;
  Xmax := P.X;
  Ymin := P.Y;
  Ymax := P.Y;
  // P2
  P := MapPnt(Matrix, ToPnt(cLen, 0));
  MinMax;
  // P3
  P := MapPnt(Matrix, ToPnt(cLen, cLen));
  MinMax;
  // P4
  P := MapPnt(Matrix, ToPnt(0, cLen));
  MinMax;
  //
  Result.lx := cLen / (Xmax - Xmin);
  Result.ly := cLen / (Ymax - Ymin);
end;

//function LineDensity(const Matrix: TMatrix): TLineDensity;
//const
//  cLen = 1000;
//var
//  P1, P2, P3, P4: TPnt;
//  Xmin, Ymin, Xmax, Ymax: Double;
//  R: TRgn;
//begin
//  P1 := MapPnt(Matrix, ToPnt(0, 0));
//  P2 := MapPnt(Matrix, ToPnt(cLen, 0));
//  P3 := MapPnt(Matrix, ToPnt(cLen, cLen));
//  P4 := MapPnt(Matrix, ToPnt(0, cLen));
//  ExtremumPnts([P1, P2, P3, P4], Xmin, Ymin, Xmax, Ymax);
//  R := ExtremumRgn(Xmin, Ymin, Xmax, Ymax);
//  Result.lx := cLen / R.Width;
//  Result.ly := cLen / R.Height;
//end;

function RectQuad(const Quad: TQuad): TRgn;
var
  Xmin, Ymin, Xmax, Ymax: Double;
begin
  ExtremumPnts(Quad.PA, Xmin, Ymin, Xmax, Ymax);
  Result := ExtremumRgn(Xmin, Ymin, Xmax, Ymax);
end;

function RectClip(const Clip: TClip): TRgn;
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
  SetLength(Pnts, Clip.PN);
  for I := 0 to Clip.PN - 1 do
    Pnts[I] := Clip.PA[I];
  ExtremumPnts(Pnts, Xmin, Ymin, Xmax, Ymax);
  Pnts := nil;
  Result := ExtremumRgn(Xmin, Ymin, Xmax, Ymax);
end;

//function NormQuad(const Quad: TQuad): TQuad;
//var
//  I, J, I1: Integer;
//  P1: TPnt;
//begin
//  I1 := 1;
//  P1 := Quad.PA[1];
//  for I := 2 to 4 do
//    if (Quad.PA[I].Y < P1.Y) or ((Quad.PA[I].Y = P1.Y) and (Quad.PA[I].X < P1.X)) then
//    begin
//      I1 := I;
//      P1 := Quad.PA[I];
//    end;
//  J := I1;
//  for I := 1 to 4 do
//  begin
//    Result.PA[I] := Quad.PA[J];
//    Inc(J);
//    if J > 4 then
//      J := 1;
//  end;
//end;

//function NormClip(const Clip: TClip): TClip;
//var
//  I, J, I1, N: Integer;
//  P1: TPnt;
//begin
//  N := Clip.PN;
//  Result.PN := N;
//  if N = 0 then
//    Exit;
//  I1 := 1;
//  P1 := Clip.PA[1];
//  for I := 2 to N do
//    if (Clip.PA[I].Y < P1.Y) or ((Clip.PA[I].Y = P1.Y) and (Clip.PA[I].X < P1.X)) then
//    begin
//      I1 := I;
//      P1 := Clip.PA[I];
//    end;
//  J := I1;
//  for I := 1 to N do
//  begin
//    Result.PA[I] := Clip.PA[J];
//    Inc(J);
//    if J > N then
//      J := 1;
//  end;
//end;

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

procedure Clipping(const Wnd: TQuad; const Quad: TQuad; out Clip: TClip); overload;
  //
  function Location(const P: TPnt; const P1, P2: TPnt): TValueSign;
  var
    R1, R2: Double;
  begin
    R1 := (P.X - P1.X) * (P2.Y - P1.Y);
    R2 := (P.Y - P1.Y) * (P2.X - P1.X);
    Result := Math.Sign(R1 - R2);
  end;
  //
  function IsCross(const P1, P2: TPnt; const W1, W2: TPnt): Boolean;
  var
    L1, L2: TValueSign;
  begin
    L1 := Location(P1, W1, W2);
    L2 := Location(P2, W1, W2);
    //Result := (L1 < 0) and (L2 > 0) or (L1 > 0) and (L2 < 0);
    Result := ((L1 < 0) and (L2 > 0)) or ((L1 > 0) and (L2 < 0));
  end;
  //
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
  S := ToPnt(0, 0); // for stub Lazarus Warning: Local variable "S" does not seem to be initialized
  for I := 1 to NW - 1 do
  begin
    NQ := 0;
    for J := 1 to 8 do
      Q[J] := ToPnt(0, 0);
    for J := 1 to NP do
    begin        
      if J = 1 then
        F := P[J]
      else
      begin
        if IsCross(S, P[J], W[I], W[I + 1]) then
        begin
          T := Cross(S, P[J], W[I], W[I + 1]);
          Inc(NQ);
          Q[NQ] := T;
        end;
      end;
      S := P[J];
      if Location(S, W[I], W[I + 1]) >= 0 then
      begin
        Inc(NQ);
        Q[NQ] := S;
      end;
    end; // for J := 1 to NP do
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
  Clip := RoundToClip(Clip);
  Clip := RemoveSamePnt(Clip);
  Clip := NormClip(Clip);
end;

procedure Clipping(const Wnd: TRgn; const Quad: TQuad; out Clip: TClip); overload;
var
  W: TQuad;
begin
  W := RgnToQuad(Wnd);
  Clipping(W, Quad, Clip);
end;

procedure YCrossing(const Clip: TClip; const Y: Double; out X1, X2: Double);
var
  I: Integer;
  A, B, C: Double;
  Ymin, Ymax, X: Double;
  P1, P2: TPnt;
  R: Boolean;
begin
  if Clip.PN = 1 then
  begin
    X1 := Clip.X1;
    X2 := Clip.X1;
    Exit;
  end;
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

end.
