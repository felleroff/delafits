{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{              Graphic image of the data               }
{                                                      }
{        Copyright(c) 2013-2017, Evgeniy Dikov         }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsGraphics;

interface

{$I DeLaFitsCompiler.inc}

uses
  SysUtils, Classes, {$IFNDEF FPC} Windows, {$ENDIF} Graphics, Math,
  DeLaFitsCommon, DeLaFitsOrderByte, DeLaFitsClasses, DeLaFitsMath,
  DeLaFitsPalettes;

const

  { The error codes }

  ERROR_GRAPHICS = 5000;

  { Error codes for TGraphicGeom }

  ERROR_SCALING_INVALID = 5001;
  ERROR_SHEAR_INVALID   = 5002;

  { Error codes for TGraphicColor }

  ERROR_HISTOGRAMDYNAMICRANGE_INVALID = 5101;
  ERROR_BRIGHTNESS_INVALID            = 5102;
  ERROR_CONTRAST_INVALID              = 5103;
  ERROR_GAMMA_INVALID                 = 5104;
  ERROR_PALETTE_UNKNOWN               = 5105;

  { Error codes for TFitsBitmap }

  ERRROR_BITMAP_NIL = 5201;

  { The error text }

  eScalingInvalid    = 'Invalid value of scaling: [%.2f; %.2f]. A scale can not be equal to the zero';
  eShearInvalid      = 'Invalid value of shear: %.2f. The correct values (-90 .. 90)';
  eBrightnessInvalid = 'Invalid value of brightness: %.2f. The correct values [%.2f .. %.2f]';
  eContrastInvalid   = 'Invalid value of contrast: %.2f. The correct values [%.2f .. %.2f]';
  eGammaInvalid      = 'Invalid value of gamma: %.2f. The correct values [%.2f .. %.2f]';
  ePaletteUnknown    = 'Invalid value of palette. The property should not be set to nil';
  eBitmapUnsigned    = 'Bitmap: not assigned pointer a bitmap';

const

  cPaletteGrayScale: PPalette = @DeLaFitsPalettes.cPalGrayScale;
  cPaletteHot      : PPalette = @DeLaFitsPalettes.cPalHot;
  cPaletteCool     : PPalette = @DeLaFitsPalettes.cPalCool;
  cPaletteBonnet   : PPalette = @DeLaFitsPalettes.cPalBonnet;
  cPaletteJet      : PPalette = @DeLaFitsPalettes.cPalJet;

type

  EFitsGraphicGeomException = class(EFitsException);
  EFitsGraphicColorException = class(EFitsException);
  EFitsGraphicException = class(EFitsException);
  EFitsBitmapException = class(EFitsException);

  TFitsGraphic = class;

  { Consider two coordinate systems: Frame (Frm) and Scene (Scn). Methods
    TGraphicGeom.Mul are intended for transformation coordinate systems Frm }

  TGraphicGeom = class(TObject)
  private
    FFits: TFitsGraphic;
    // Matrix describe coordinate space Frm in coordinate space Scn, transforms
    // a point P(x,y) Frm to point P'(x,y) Scn: P(Frm) -> P(Scn)
    FMatrixFrm: TMatrix;
    // Matrix describe space coordinate Scn in coordinate space Frm, inverse
    // for FMatrixFrm, transforms a point P(x,y) Scn to point P'(x,y) Frm:
    // P(Scn) -> P(Frm)
    FMatrixScn: TMatrix;
  private
    procedure GetDesignShift(Shift: TDesignShift; out dX, dY: Double);
    procedure GetDesignPoint(Point: TDesignPoint; out pX, pY: Double);
  public
    constructor Create(AFits: TFitsGraphic);
    destructor Destroy; override;
    property Fits: TFitsGraphic read FFits;
    property MatrixFrm: TMatrix read FMatrixFrm;
    property MatrixScn: TMatrix read FMatrixScn;
  public
    // Methods are intended for transformation coordinate systems Frm. Coordina-
    // tes a points (~ pX, pY or P: TDesignPoint) are specified in the system of
    // coordinates of Scn
    function Clr: TGraphicGeom;
    function Mul(const Matrix: TMatrix): TGraphicGeom;
    function Trn(const dX, dY: Double): TGraphicGeom; overload;
    function Trn(const Shift: TDesignShift): TGraphicGeom; overload;
    function Scl(const sX, sY: Double; const pX, pY: Double): TGraphicGeom; overload;
    function Scl(const sX, sY: Double; const P: TPnt): TGraphicGeom; overload;
    function Scl(const sX, sY: Double; const P: TDesignPoint): TGraphicGeom; overload;
    function Rot(const Angle: Double; const pX, pY: Double): TGraphicGeom; overload;
    function Rot(const Angle: Double; const P: TPnt): TGraphicGeom; overload;
    function Rot(const Angle: Double; const P: TDesignPoint): TGraphicGeom; overload;
    function Shx(const Angle: Double): TGraphicGeom;
    function Shy(const Angle: Double): TGraphicGeom;
  public
    // The coordinate system transformation for points
    function PntScnToFrm(const PntScn: TPnt): TPnt;
    function PntFrmToScn(const PntFrm: TPnt): TPnt;
    function PixScnToFrm(const PixScn: TPix): TPix;
    function PixFrmToScn(const PixFrm: TPix): TPix;
    // The coordinate system transformation for regions
    function QuadScnToFrm(const RgnScn: TRgn): TQuad;
    function QuadFrmToScn(const RgnFrm: TRgn): TQuad;
    function RectScnToFrm(const RgnScn: TRgn): TRgn;
    function RectFrmToScn(const RgnFrm: TRgn): TRgn;
    // Polygon intersection of window - RgnXxx, and region frame - DataRgn. The
    // result is presented in the specified coordinate system - Scn or Frm
    function ClipScnInScn(const RgnScn: TRgn): TClip;
    function ClipScnInFrm(const RgnScn: TRgn): TClip;
    function ClipFrmInFrm(const RgnFrm: TRgn): TClip;
    function ClipFrmInScn(const RgnFrm: TRgn): TClip;
  end;

  TGraphicColor = class(TObject)
  private
    FFits: TFitsGraphic;
  private // FBand
    FBand: TBand;
    procedure Banding;
  private // Histogram
    FHistogram: TList;
    FHistogramMeasure: THistogramMeasure;
    FHistogramDynamicRange: THistogramDynamicRange;
    procedure HistogramBuild;
    procedure HistogramAnalyze;
    procedure HistogramClear;
    function GetHistogram: PHistogram;
    procedure SetHistogramDynamicRange(const Value: THistogramDynamicRange);
  private // Tone: Y = Co * (X ^ Ga - 0.5) + 0.5 + Br, see Banding
    FBrightness: Double; // [-1.0 ; +1.0], default ~0.0
    FContrast: Double;   // (+0.0 ; +3.0] +nan, default ~1.0
    FGamma: Double;      // (+0.0 ; +3.0] +nan, default ~1.0
    procedure SetBrightness(const Value: Double);
    procedure SetContrast(const Value: Double);
    procedure SetGamma(const Value: Double);
  private // Palette
    FPalette: PPalette;
    FPaletteOrder: TPaletteOrder;
    procedure SetPalette(Value: PPalette);
    procedure SetPaletteOrder(Value: TPaletteOrder);
  public
    constructor Create(AFits: TFitsGraphic);
    destructor Destroy; override;
    property Fits: TFitsGraphic read FFits;
    property Band: TBand read FBand;
  public
    function HistogramIsMake: Boolean;
    procedure HistogramUpdate;
    procedure HistogramDynamicRangeDefault;
    property Histogram: PHistogram read GetHistogram;
    property HistogramMeasure: THistogramMeasure read FHistogramMeasure;
    property HistogramDynamicRange: THistogramDynamicRange read FHistogramDynamicRange write SetHistogramDynamicRange;
  public
    procedure Tone(const ABrightness, AContrast, AGamma: Double);
    procedure ToneDefault;
    property ToneBrightness: Double read FBrightness write SetBrightness;
    property ToneContrast: Double read FContrast write SetContrast;
    property ToneGamma: Double read FGamma write SetGamma;
  public
    property Palette: PPalette read FPalette write SetPalette;
    property PaletteOrder: TPaletteOrder read FPaletteOrder write SetPaletteOrder;
  end;

  { Graphic Fits frame, data array 2D only

  Map stream:

  DataOffset 00 01 02 03 04 05 06 07 08 09 10 11 ~~

  Map Data:

  0-----|-----|-----|-----|--- X (NAXIS1, ColsCount, Width)
  | 0;0 | 1;0 | 2;0 | 3;0 |
  |-----|-----|-----|-----|
  | 0;1 | 1;1 | 2;1 | 3;1 |
  |-----|-----|-----|-----|
  | 0;2 | 1;2 | 2;2 | 3;2 |
  |-----|-----|-----|-----|
  |
  Y (NAXIS2, RowsCount, Height)

  Fits Standard, version 3.0, page 14-15. Data[NAXIS1 - 1, NAXIS2 - 1] }

  TFitsGraphic = class(TFitsFrame)
  private
    FGraphicGeom: TGraphicGeom;
    FGraphicColor: TGraphicColor;
    function GetGraphicRgn: TRgn;
  protected
    procedure Init; override;
  public
    destructor Destroy; override;
  public
    // Affine transformation
    property GraphicGeom: TGraphicGeom read FGraphicGeom;
    // Color correction
    property GraphicColor: TGraphicColor read FGraphicColor;
    // Full graphic region (after affine transformations),
    // for zero affine transformations:
    // ~ NAXIS1, ColCount, Width
    // ~ NAXIS2, RowCount, Height
    property GraphicRgn: TRgn read GetGraphicRgn;
  public
    // Allocate memory for user pixels buffer: SetLength
    procedure GraphicPrepare(var Pixels: TPixels; const Rgn: TRgn);
    // Get a graphic:
    // Palette - GraphicColor.Palette taking into account an GraphicColor.PaletteOrder
    // Pixels - array graphics of set region (affine region), indexes of Palette
    // Width, Height - size of array Pixels, Pixels[Width - 1, Height - 1]
    // Rgn - new (after affine transformations) region of graphic presentation of frame
    procedure GraphicRead(out Palette: TPalette; var Pixels: TPixels; const Rgn: TRgn); virtual;
  end;

  { A class of graphic presentation of frame is in the format of Bitmap, de-facto
    Bitmap 8bit. For TBitmap Delphi (Windows) property of PixelFormat is supported
    pf8bit, pf24bit and pf32bit. For TBitmap in Lazarus support only pf24bit }

  TFitsBitmap = class(TFitsGraphic)
  private
    FPalette: TPalette;
    FPixels: TPixels;
    FBitmap: TBitmap;
    procedure SetPixelFormat;
    procedure SetSize(const Width, Height: Integer);
    procedure SetPalette;
    procedure SetPixels;
  protected
    procedure Init; override;
  public
    destructor Destroy; override;
    // Get a graphic in format BitMap, overloaded methods
    // without using the Rgn ~ Rgn = GraphicRgn
    procedure BitmapRead(Bitmap: TBitmap); overload;
    procedure BitmapRead(Bitmap: TBitmap; const Rgn: TRgn); overload;
    // Pixel array is cached (see FPixels and TFitsGraphic.GraphicRead), method
    // BitmapRelease frees the occupied memory
    procedure BitmapRelease;
  end;

  { Graphic (Bitmap) Fits frame as the file }
  
  TFitsFileBitmap = class(TFitsBitmap)
  private
    FFileName: string;
    function GetFileStream: TFileStream;   
  public
    constructor CreateJoin(const AFileName: string; AFileMode: Word);
    constructor CreateMade(const AFileName: string; const AHduCore: THduCore2d);
    destructor Destroy; override;
    property Stream: TFileStream read GetFileStream;
    property StreamFileName: string read FFileName;
  end;

implementation

{ TGraphicGeom }

constructor TGraphicGeom.Create(AFits: TFitsGraphic);
begin
  inherited Create;
  FFits := AFits;
  Clr;
end;

destructor TGraphicGeom.Destroy;
begin
  FFits := nil;
  inherited;
end;

procedure TGraphicGeom.GetDesignPoint(Point: TDesignPoint; out pX, pY: Double);
var
  R: TRgn; 
begin
  R := RectFrmToScn(FFits.DataRgn);
  case Point of
    xy00:
      begin
        pX := 0;
        pY := 0;
      end;
    xyLT:
      begin
        pX := R.X1;
        pY := R.Y1;
      end;
    xyRT:
      begin
        pX := R.X1 + R.Width;
        pY := R.Y1;
      end;
    xyRB:
      begin
        pX := R.X1 + R.Width;
        pY := R.Y1 + R.Height;
      end;
    xyLB:
      begin
        pX := R.X1;
        pY := R.Y1 + R.Height;
      end;
    else { xyCC: }
      begin
        pX := R.X1 + R.Width / 2;
        pY := R.Y1 + R.Height / 2;
      end;
  end;
end;

procedure TGraphicGeom.GetDesignShift(Shift: TDesignShift; out dX, dY: Double);
var
  R: TRgn;
begin
  R := RectFrmToScn(FFits.DataRgn);
  case Shift of
    xyLTat00:
      begin
        dX := -R.X1;
        dY := -R.Y1;
      end;
    xyRTat00:
      begin
        dX := -(R.X1 + R.Width);
        dY := -R.Y1;
      end;
    xyRBat00:
      begin
        dX := -(R.X1 + R.Width);
        dY := -(R.Y1 + R.Height);
      end;
    xyLBat00:
      begin
        dX := -R.X1;
        dY := -(R.Y1 + R.Height);
      end;
    else { xyCCat00: }
      begin
        dX := -(R.X1 + R.Width / 2);
        dY := -(R.Y1 + R.Height / 2);
      end;
  end;
end;

function TGraphicGeom.Mul(const Matrix: TMatrix): TGraphicGeom;
begin
  try
    FMatrixFrm := MatrixMultiply(FMatrixFrm, Matrix);
    FMatrixScn := MatrixInverse(FMatrixFrm);
    Result := Self;
  except
    Clr;
    raise;
  end;
end;

function TGraphicGeom.ClipFrmInFrm(const RgnFrm: TRgn): TClip;
var
  Wnd: TRgn;
  Quad: TQuad;
begin
  Wnd := RgnFrm;
  Quad := RgnToQuad(FFits.DataRgn);
  Clipping(Wnd, Quad, Result);
end;

function TGraphicGeom.ClipFrmInScn(const RgnFrm: TRgn): TClip;
var
  Wnd: TQuad;
  Quad: TQuad;
begin
  Wnd := QuadFrmToScn(RgnFrm);
  Quad := QuadFrmToScn(FFits.DataRgn);
  Clipping(Wnd, Quad, Result);
end;

function TGraphicGeom.ClipScnInFrm(const RgnScn: TRgn): TClip;
var
  Wnd: TQuad;
  Quad: TQuad;
begin
  Wnd := QuadScnToFrm(RgnScn);
  Quad := RgnToQuad(FFits.DataRgn);
  Clipping(Wnd, Quad, Result);
end;

function TGraphicGeom.ClipScnInScn(const RgnScn: TRgn): TClip;
var
  Wnd: TRgn;
  Quad: TQuad;
begin
  Wnd := RgnScn;
  Quad := QuadFrmToScn(FFits.DataRgn);
  Clipping(Wnd, Quad, Result);
end;

function TGraphicGeom.PixFrmToScn(const PixFrm: TPix): TPix;
begin
  Result := MapPix(FMatrixFrm, PixFrm);
end;

function TGraphicGeom.PixScnToFrm(const PixScn: TPix): TPix;
begin
  Result := MapPix(FMatrixScn, PixScn);
end;

function TGraphicGeom.PntFrmToScn(const PntFrm: TPnt): TPnt;
begin
  Result := MapPnt(FMatrixFrm, PntFrm);
end;

function TGraphicGeom.PntScnToFrm(const PntScn: TPnt): TPnt;
begin
  Result := MapPnt(FMatrixScn, PntScn);
end;

function TGraphicGeom.QuadFrmToScn(const RgnFrm: TRgn): TQuad;
begin
  // P1----P2
  //  |    |
  // P4----P3
  with RgnFrm do
  begin
    Result.P1 := PntFrmToScn(ToPnt(X1, Y1));
    Result.P2 := PntFrmToScn(ToPnt(X1 + Width, Y1));
    Result.P3 := PntFrmToScn(ToPnt(X1 + Width, Y1 + Height));
    Result.P4 := PntFrmToScn(ToPnt(X1, Y1 + Height));
  end;
  Result := NormQuad(Result);
end;

function TGraphicGeom.QuadScnToFrm(const RgnScn: TRgn): TQuad;
begin
  // P1----P2
  //  |    |
  // P4----P3
  with RgnScn do
  begin
    Result.P1 := PntScnToFrm(ToPnt(X1, Y1));
    Result.P2 := PntScnToFrm(ToPnt(X1 + Width, Y1));
    Result.P3 := PntScnToFrm(ToPnt(X1 + Width, Y1 + Height));
    Result.P4 := PntScnToFrm(ToPnt(X1, Y1 + Height));
  end;
  Result := NormQuad(Result);
end;

function TGraphicGeom.Clr: TGraphicGeom;
begin
  FMatrixFrm := MatrixInit;
  FMatrixScn := MatrixInit;
  Result := Self;
end;

function TGraphicGeom.Rot(const Angle: Double; const pX, pY: Double): TGraphicGeom;
var
  IsTrn: Boolean;
  M: TMatrix;
begin
  if (Angle <> 0) then
  begin
    IsTrn := (pX <> 0) or (pY <> 0);
    if IsTrn then
    begin
      M := MatrixMakeAsTrn(MathNeg(pX), MathNeg(pY));
      Mul(M);
    end;
    M := MatrixMakeAsRot(Angle);
    Mul(M);
    if IsTrn then
    begin
      M := MatrixMakeAsTrn(pX, pY);
      Mul(M);
    end;
  end;
  Result := Self;
end;

function TGraphicGeom.Rot(const Angle: Double; const P: TPnt): TGraphicGeom;
begin
  Result := Rot(Angle, P.X, P.Y);
end;

function TGraphicGeom.RectFrmToScn(const RgnFrm: TRgn): TRgn;
var
  Quad: TQuad;
begin
  Quad := QuadFrmToScn(RgnFrm);
  Result := RectQuad(Quad);
end;

function TGraphicGeom.RectScnToFrm(const RgnScn: TRgn): TRgn;
var
  Quad: TQuad;
begin
  Quad := QuadScnToFrm(RgnScn);
  Result := RectQuad(Quad);
end;

function TGraphicGeom.Rot(const Angle: Double; const P: TDesignPoint): TGraphicGeom;
var
  pX, pY: Double;
begin
  GetDesignPoint(P, pX, pY);
  Result := Rot(Angle, pX, pY);
end;

function TGraphicGeom.Scl(const sX, sY: Double; const pX, pY: Double): TGraphicGeom;
var
  IsTrn: Boolean;
  M: TMatrix;
begin
  if (sX = 0) or (sY = 0) then
    raise EFitsGraphicGeomException.CreateFmt(eScalingInvalid, [sX, sY], ERROR_SCALING_INVALID);
  if (sX <> 1) or (sY <> 1) then
  begin  
    IsTrn := (pX <> 0) or (pY <> 0);
    if IsTrn then
    begin
      M := MatrixMakeAsTrn(MathNeg(pX), MathNeg(pY));
      Mul(M);
    end;
    M := MatrixMakeAsScl(sX, sY);
    Mul(M);
    if IsTrn then
    begin
      M := MatrixMakeAsTrn(pX, pY);
      Mul(M);
    end;
  end;
  Result := Self;
end;

function TGraphicGeom.Scl(const sX, sY: Double; const P: TPnt): TGraphicGeom;
begin
  Result := Scl(sX, sY, P.X, P.Y);
end;

function TGraphicGeom.Scl(const sX, sY: Double; const P: TDesignPoint): TGraphicGeom;
var
  pX, pY: Double;
begin
  GetDesignPoint(P, pX, pY);
  Result := Scl(sX, sY, pX, pY);
end;

function TGraphicGeom.Shx(const Angle: Double): TGraphicGeom;
var
  M: TMatrix;
begin
  if (Angle < -90) or (Angle > 90) then
    raise EFitsGraphicGeomException.CreateFmt(eShearInvalid, [Angle], ERROR_SHEAR_INVALID);
  if Angle <> 0 then
  begin
    M := MatrixMakeAsShx(Angle);
    Mul(M);
  end;
  Result := Self;    
end;

function TGraphicGeom.Shy(const Angle: Double): TGraphicGeom;
var
  M: TMatrix;
begin
  if (Angle < -90) or (Angle > 90) then
    raise EFitsGraphicGeomException.CreateFmt(eShearInvalid, [Angle], ERROR_SHEAR_INVALID);
  if Angle <> 0 then
  begin
    M := MatrixMakeAsShy(Angle);
    Mul(M);
  end;
  Result := Self;
end;

function TGraphicGeom.Trn(const dX, dY: Double): TGraphicGeom;
var
  M: TMatrix;
begin
  if (dX <> 0) or (dY <> 0) then
  begin
    M := MatrixMakeAsTrn(dX, dY);
    Mul(M);
  end;
  Result := Self;
end;

function TGraphicGeom.Trn(const Shift: TDesignShift): TGraphicGeom;
var
  dX, dY: Double;
begin
  GetDesignShift(Shift, dX, dY);
  Result := Trn(dX, dY);
end;

{ TGraphicColor }

procedure TGraphicColor.Banding;
{$IFDEF FPC}{$IFNDEF FPC_HAS_TYPE_EXTENDED}
const
  MaxExtended  =  math.MaxDouble;
{$ENDIF}{$ENDIF}
var
  Items: PHistogram;
  H, H1, H2: Integer;
  R1, R2, RCount: Integer;
  B, B1, B2, BCount: Integer;
  Steep, Delta: Double;
  // Trunc(+0.9) =  0
  // Trunc(-0.9) = -1
  function Trunc(X: Extended): Integer;
  begin
    Result := Integer(System.Trunc(X));
    if (Result = 0) and (X < 0) then
      Result := -1;
  end;
  // Get Value of items of histogram
  function ItemsValue(Index: Integer): Extended;
  begin
    // R2, de bene esse...
    if Index > R2 then
      Index := R2;
    if Index < H1 then
      Result := -MaxExtended
    else if Index > H2 then
      Result := +MaxExtended
    else
      Result := Items^[Index]^.Value;
  end; 
var
  TweakBand: TBand;
  T: Integer;
  I, br, co, ga: Double;
  Value: Extended;
begin
  if not HistogramIsMake then
    Exit; 
  Items := Self.Histogram;
  // Define the parameters of
  // ...items of histogram
  H1 := 0;
  H2 := FHistogram.Count - 1;
  // ...items of histogram according to dynamic range
  R1 := FHistogramDynamicRange.Index1;
  R2 := FHistogramDynamicRange.Index2;
  RCount := R2 - R1 + 1;
  // ...band
  B1 := 0;
  B2 := cSizeBand - 1;
  BCount := cSizeBand;
  // Calc band
  Steep := RCount / BCount;
  Delta := Steep;
  if RCount > BCount then
    R1 := Trunc(R1 + Steep);
  FBand[B1] := ItemsValue(R1);
  FBand[B2] := ItemsValue(R2);
  for B := B1 + 1 to B2 - 1 do
  begin
    H := Trunc(R1 + Delta);
    Delta := Delta + Steep;
    FBand[B] := ItemsValue(H);
  end;
  // Correction (tweak) of band:
  // ... get params
  br := FBrightness;
  co := FContrast;
  ga := FGamma;
  // ...correction params for zero
  if co < 0.01 then
    co := 0.01;
  if ga < 0.01 then
    ga := 0.01;
  // ...get a new value for the index
  //    http://www.sati.archaeology.nsc.ru/gr/nstu/03.digital_image_prosessing.pdf,
  //    i.e. for normalize index:
  //    IndexTweakBand = co * (IndexBand ^ ga - 0.5) + 0.5 + br =>
  //    IndexBand = ((IndexTweakBand + 0.5 * (co - 1) - br) / co) ^ (1 / ga);
  BCount := cSizeBand;
  for T := 0 to BCount - 1 do
  begin
    I := T / (BCount - 1);
    I := I + 0.5 * (co - 1) - br;
    if I >= 0 then
    begin
      I := I / co;
      I := Math.Power(I, 1 / ga);
      I := I * (BCount - 1);
      B := Round(I);
    end
    else
    begin
      B := -1;
    end;
    if B > BCount - 1 then
      Value := MaxExtended
    else if B < 0 then
      Value := -MaxExtended
   else
      Value := FBand[B];     
    TweakBand[T] := Value;
  end;
  // ... update band: FBand := TweekBand
  for B := 0 to BCount - 1 do
    FBand[B] := TweakBand[B];
end;

constructor TGraphicColor.Create(AFits: TFitsGraphic);
var
  I: Integer;
begin
  inherited Create;
  FFits := AFits;
  FHistogram := TList.Create;
  with FHistogramMeasure do
  begin
    CountPoints := 0;
    CountItems := 0;
    ItemMedian := 0;
    ItemMax := 0;
    ItemMaxSmooth := 0;
    DynamicRangeDefault.Index1 := 0;
    DynamicRangeDefault.Index2 := 0;
  end;
  FHistogramDynamicRange := FHistogramMeasure.DynamicRangeDefault;
  for I := 0 to  cSizeBand - 1 do
    FBand[I] := 0.0;
  FBrightness := cBrightnessDef;
  FContrast := cContrastDef;
  FGamma := cGammaDef;
  FPalette := cPaletteGrayScale;
  FPaletteOrder := palDirect;
end;

destructor TGraphicColor.Destroy;
begin
  HistogramClear;
  FHistogram.Free;
  FPalette := nil;
  FFits := nil;
  inherited;
end;

function TGraphicColor.GetHistogram: PHistogram;
begin
  Result := PHistogram(FHistogram.List);
end;

function TGraphicColor.HistogramIsMake: Boolean;
begin
  Result := FHistogram.Count > 0;
end;

procedure TGraphicColor.HistogramAnalyze;
var
  I, J, Count, Imax, Imin, I1, I2: Integer;
  B: Boolean;
  Items: PHistogram;
  CountPoints, HalfCountPoints: Int64;
  Max, MaxSmooth, Me, N, M, S, N1, N2: Integer;
  Range: THistogramDynamicRange;
begin
  Items := Self.Histogram;
  Count := FHistogram.Count;
  // Define
  // ... the total number of points of the histogram
  CountPoints := 0;
  // ... index of the maximum element
  Max := 0;
  N1 := 0;
  // ... index of the smooth maximum element
  MaxSmooth := 0;
  N2 := 0;
  Imin := 0;
  Imax := Count - 1;
  //
  for I := 0 to Count - 1 do
  begin
    N := Items^[I]^.Count;
    // Total
    CountPoints := CountPoints + N;
    // Index maximum
    if N > N1 then
    begin
      N1 := N;
      Max := I;
    end;
    // Index smooth maximum
    if N > N2 then
    begin
      I1 := I - 3; if I1 < Imin then I1 := Imin;
      I2 := I + 3; if I2 > Imax then I2 := Imax;
      B := True;
      S := 0;
      for J := I1 to I2 do
      begin
        if J = I then
          Continue;
        M := Items^[J]^.Count;
        S := S + M;
        if M > N then
        begin
          B := False;
          Break;
        end;
      end;
      if B and (N <= S) then
      begin
        N2 := N;
        MaxSmooth := I;
      end;
    end; {if N > N2 then ... Index smooth maximum}
  end;
  HalfCountPoints := CountPoints div 2;
  // Determine the index of the median
  N := 0;
  Me := 0;
  for I := 0 to Count - 1 do
  begin
    N := N + Items^[I]^.Count;
    if N >= HalfCountPoints then
    begin
      Me := I;
      Break;
    end;
  end;
  // Defined dynamic range default
  Imin := 0;
  Imax := Count - 1;
  N := Items^[Me]^.Count;
  I := 1;
  I1 := Me - I;
  I2 := Me + I;
  with Range do
  begin
    Index1 := 0;
    Index2 := 0;
  end;
  while True do
  begin
    if I1 >= Imin then N1 := Items^[I1]^.Count else N1 := 0;
    if I2 <= Imax then N2 := Items^[I2]^.Count else N2 := 0;
    N := N + N1 + N2;
    if N >= HalfCountPoints then
    begin
      with Range do
      begin           
        Index1 := Me - 4 * I;          if Index1 < Imin then Index1 := Imin;
        Index2 := Round(Me + 7.5 * I); if Index2 > Imax then Index2 := Imax;
      end;
      Break;
    end;
    Inc(I);
    Dec(I1);
    Inc(I2);
  end;
  // Fix result
  FHistogramMeasure.CountItems := Count;
  FHistogramMeasure.CountPoints := CountPoints;
  FHistogramMeasure.ItemMedian := Me;
  FHistogramMeasure.ItemMax := Max;
  FHistogramMeasure.ItemMaxSmooth := MaxSmooth;
  FHistogramMeasure.DynamicRangeDefault := Range;
  FHistogramDynamicRange := Range;
end;

procedure TGraphicColor.HistogramBuild;
var
  BitPix: TBitPix;
  BitPixSize: Integer;
  BScale, BZero: Double;
  Offset: Int64;
  ler: Boolean;
var
  Items: PHistogram;
  Item: PHistogramItem;
var
  Buffer: TStreamBuffer;
  Value: Extended;
  ValueIsNew: Boolean;
  CountData, CountPoints, Count, Size: Integer;
  CountBuffersInData: Integer;
  I, J, N, IndexRnd, IndexMax: Integer;
  K1, K2, K: Integer;
  M1, M2, M, MN: Integer;
  {$IFDEF DELABITPIX64F}
  v64f: T64f;
  b64f: TA64f1;
  {$ENDIF}
  {$IFDEF DELABITPIX32F}
  v32f: T32f;
  b32f: TA32f1;
  {$ENDIF}
  {$IFDEF DELABITPIX08U}
  v08u: T08u;
  b08u: TA08u1;
  {$ENDIF}
  {$IFDEF DELABITPIX16C}
  v16c: T16c;
  b16c: TA16c1;
  {$ENDIF}
  {$IFDEF DELABITPIX32C}
  v32c: T32c;
  b32c: TA32c1;
  {$ENDIF}
  {$IFDEF DELABITPIX64C}
  v64c: T64c;
  b64c: TA64c1;
  {$ENDIF}
begin
  // Determine the core and system parameters
  with FFits do
  begin
    BitPix := HduCore.BitPix;
    BScale := HduCore.BScale;
    BZero := HduCore.BZero;
    Offset := DataOffset;
  end;
  BitPixSize := BitPixByteSize(BitPix);
  // Get system order byte
  ler := SysOrderByte = sobLe;
  // Get the number of elements
  CountData := FFits.DataRgn.ColsCount * FFits.DataRgn.RowsCount;
  // Get the number of elements and the size of the buffer
  Count := cSizeStreamBuffer div BitPixByteSize(BitPix);
  if Count > CountData then
    Count := CountData;
  Size := Count * BitPixByteSize(BitPix);
  // Get the number of read operations
  CountBuffersInData := CountData div Count;
  if (CountData mod Count) > 0 then
    Inc(CountBuffersInData);
  // Get the number of points (elements) in the buffer to determine the histogram
  // ... full
  if CountData > cHistogramMaxCountPoints then
    CountPoints := cHistogramMaxCountPoints
  else {DataCount <= cHistogramMaxCountPoints}
    CountPoints := CountData;
  // ... in buffer
  CountPoints := Round((CountPoints / CountData) * Count);
  if CountPoints < 1 then
    CountPoints := 1;
  //  Allocate memory for the buffer
  Buffer := nil;
  FFits.AllocateBuffer(Pointer(Buffer), Size);
  // Define a pointer to a buffer for the corresponding values of BitPix
  {$IFDEF DELABITPIX64F}
  b64f := TA64f1(Buffer);
  {$ENDIF}
  {$IFDEF DELABITPIX32F}
  b32f := TA32f1(Buffer);
  {$ENDIF}
  {$IFDEF DELABITPIX08U}
  b08u := TA08u1(Buffer);
  {$ENDIF}
  {$IFDEF DELABITPIX16C}
  b16c := TA16c1(Buffer);
  {$ENDIF}
  {$IFDEF DELABITPIX32C}
  b32c := TA32c1(Buffer);
  {$ENDIF}
  {$IFDEF DELABITPIX64C}
  b64c := TA64c1(Buffer);
  {$ENDIF}
  // Define the default value (hide Hint)
  Value := 0.0;
  // Initialize random number generator
  Randomize;
  try
    // Sequentially read the data of stream
    for I := 1 to CountBuffersInData do
    begin
      // The amendment to the last block of data to be read
      if I = CountBuffersInData then
        if (CountData mod Count) > 0 then
        begin
          Count := CountData mod Count;
          Size := Count * BitPixSize;
          if CountData > cHistogramMaxCountPoints then
            CountPoints := cHistogramMaxCountPoints
          else {DataCount <= cHistogramMaxCountPoints}
             CountPoints := CountData;
          CountPoints := Round((CountPoints / CountData) * Count);
          if CountPoints < 1 then
            CountPoints := 1;
        end;
      // Read data
      FFits.StreamRead(Offset, Size, Buffer);
      Inc(Offset, Size);
      // Randomly selected points (values) for the histogram.
      // CountPoints - number of points for analysis in the buffer.
      // The elements of buffer after you select are placed in the end of array
      N := Count;
      Items := Self.Histogram;
      for J := 1 to CountPoints do
      begin
        IndexRnd := Random(N);
        IndexMax := (N - 1);
        case BitPix of
          bi64f:
            begin
             {$IFDEF DELABITPIX64F}
              v64f := b64f[IndexMax];
              b64f[IndexMax] := b64f[IndexRnd];
              b64f[IndexRnd] := v64f;
              v64f := b64f[IndexMax];
              if ler then
                v64f := Swap64ff(v64f);
              if IsNan(v64f) then
                Continue;
              Value := v64f;
              {$ENDIF}
            end;
          bi32f:
            begin
              {$IFDEF DELABITPIX32F}
              v32f := b32f[IndexMax];
              b32f[IndexMax] := b32f[IndexRnd];
              b32f[IndexRnd] := v32f;
              v32f := b32f[IndexMax];
              if ler then
                v32f := Swap32ff(v32f);
              if IsNan(v32f) then
                Continue;
              Value := v32f;
              {$ENDIF}
            end;
          bi08u:
            begin
              {$IFDEF DELABITPIX08U}
              v08u := b08u[IndexMax];
              b08u[IndexMax] := b08u[IndexRnd];
              b08u[IndexRnd] := v08u;
              v08u := b08u[IndexMax];
              Value := v08u;
              {$ENDIF}
            end;
          bi16c:
            begin
              {$IFDEF DELABITPIX16C}
              v16c := b16c[IndexMax];
              b16c[IndexMax] := b16c[IndexRnd];
              b16c[IndexRnd] := v16c;
              v16c := b16c[IndexMax];
              if ler then
                v16c := Swap16cc(v16c);
              Value := v16c;
              {$ENDIF}
            end;
          bi32c:
            begin
              {$IFDEF DELABITPIX32C}
              v32c := b32c[IndexMax];
              b32c[IndexMax] := b32c[IndexRnd];
              b32c[IndexRnd] := v32c;
              v32c := b32c[IndexMax];
              if ler then
                v32c := Swap32cc(v32c);
              Value := v32c;
              {$ENDIF}
            end;
          bi64c:
            begin
              {$IFDEF DELABITPIX64C}
              v64c := b64c[IndexMax];
              b64c[IndexMax] := b64c[IndexRnd];
              b64c[IndexRnd] := v64c;
              v64c := b64c[IndexMax];
              if ler then
                v64c := Swap64cc(v64c);
              Value := v64c;
              {$ENDIF}
            end;
        end; {case BitPix of ...}
        // Reduce the lower bound of the array (Buffer)
        Dec(N);
        // Calculated physical value
        Value := Value * BScale + BZero;
        // Orderly (dichotomy) filled histogram. We sorted histogram
        K := 0;
        K1 := 0;
        K2 := FHistogram.Count - 1;
        ValueIsNew := True;
        while K2 >= K1 do
        begin
          K := K1 + (K2 - K1) div 2;          
          Item := Items^[K];
          if Item^.Value > Value then
          begin
            K2 := K - 1;
          end
          else if Item^.Value < Value then
          begin
            K1 := K + 1;
            Inc(K);
          end
          else {if Item^.Value = Value then}
          begin
            Item^.Count := Item^.Count + 1;
            ValueIsNew := False;
            Break;
          end;
        end;
        if ValueIsNew then
        begin
          New(Item);
          Item^.Value := Value;
          Item^.Count := 1;
          FHistogram.Insert(K, Item);
          Items := Self.Histogram;
        end;
        // Histogram equalization: limiting the number of elements
        if ValueIsNew then
        begin
          if FHistogram.Count = cHistogramMaxCountItems then
          begin
            MN := cHistogramMaxCountItems div 2;
            for M := 0 to MN - 1 do
            begin
              M1 := M * 2;
              M2 := M1 + 1;
              Item := FHistogram[M];
              Item^.Value := PHistogramItem(FHistogram[M2])^.Value;
              Item^.Count := PHistogramItem(FHistogram[M1])^.Count + PHistogramItem(FHistogram[M2])^.Count;
            end;
            for M := MN to cHistogramMaxCountItems - 1 do
            begin
              Item := PHistogramItem(FHistogram.Items[M]);
              Dispose(Item);
              FHistogram.Items[M] := nil;
            end;
            FHistogram.Count := MN;
          end;
        end;
      end; {for J := 1 to CountPoints do ...}
    end; {for I := 1 to CountBuffersInData do ...}
    // If the data frame IsNan only
    if FHistogram.Count = 0 then
    begin
      New(Item);
      Item^.Value := 0.0;
      Item^.Count := 1;
      FHistogram.Add(Item);
    end;
  finally
    {$IFDEF DELABITPIX64F}
    b64f := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX32F}
    b32f := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX08U}
    b08u := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX16C}
    b16c := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX32C}
    b32c := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX64C}
    b64c := nil;
    {$ENDIF}
    FFits.ReleaseBuffer(Pointer(Buffer));
  end;
end;

procedure TGraphicColor.HistogramClear;
var
  I: Integer;
  Item: PHistogramItem;
begin
  for I := 0 to FHistogram.Count - 1 do
  begin
    Item := PHistogramItem(FHistogram.Items[I]);
    Dispose(Item);
    FHistogram.Items[I] := nil;
  end;
  FHistogram.Clear;
  with FHistogramMeasure do
  begin
    CountPoints := 0;
    CountItems := 0;
    ItemMedian := 0;
    ItemMax := 0;
    ItemMaxSmooth := 0;
    DynamicRangeDefault.Index1 := 0;
    DynamicRangeDefault.Index2 := 0;
  end;
  FHistogramDynamicRange := FHistogramMeasure.DynamicRangeDefault;
  for I := 0 to  cSizeBand - 1 do
    FBand[I] := 0.0;
end;

procedure TGraphicColor.HistogramUpdate;
begin
  HistogramClear;
  HistogramBuild;
  HistogramAnalyze;
  Banding;
end;

procedure TGraphicColor.SetBrightness(const Value: Double);
begin
  if (Value < cBrightnessMin) or (Value > cBrightnessMax) then
    raise EFitsGraphicColorException.CreateFmt(eBrightnessInvalid, [Value, cBrightnessMin, cBrightnessMax], ERROR_BRIGHTNESS_INVALID);
  if (FBrightness <> Value) then
  begin
    FBrightness := Value;
    Banding;
  end;
end;

procedure TGraphicColor.SetContrast(const Value: Double);
begin
  if (Value < cContrastMin) or (Value > cContrastMax) then
    raise EFitsGraphicColorException.CreateFmt(eContrastInvalid, [Value, cContrastMin, cContrastMax], ERROR_CONTRAST_INVALID);
  if (FContrast <> Value) then
  begin
    FContrast := Value;
    Banding;
  end;
end;

procedure TGraphicColor.SetGamma(const Value: Double);
begin
  if (Value < cGammaMin) or (Value > cGammaMax) then
    raise EFitsGraphicColorException.CreateFmt(eGammaInvalid, [Value, cGammaMin, cGammaMax], ERROR_GAMMA_INVALID);
  if (FGamma <> Value) then
  begin
    FGamma := Value;
    Banding;
  end;
end;

procedure TGraphicColor.SetHistogramDynamicRange(const Value: THistogramDynamicRange);
begin
  with Value do
    if Index1 > Index2 then
      raise EFitsGraphicColorException.CreateFmt(eIndexIncorrect, [Index1, Index2], ERROR_HISTOGRAMDYNAMICRANGE_INVALID);
  if not HistogramIsMake then
  begin
    HistogramBuild;
    HistogramAnalyze;
  end;
  if (FHistogramDynamicRange.Index1 <> Value.Index1) or
     (FHistogramDynamicRange.Index2 <> Value.Index2) then
  begin
    FHistogramDynamicRange := Value;
    Banding;
  end;
end;

procedure TGraphicColor.HistogramDynamicRangeDefault;
begin
  if not HistogramIsMake then
  begin
    HistogramBuild;
    HistogramAnalyze;
  end;
  HistogramDynamicRange := FHistogramMeasure.DynamicRangeDefault;
end;

procedure TGraphicColor.SetPalette(Value: PPalette);
begin
  if Value = nil then
    raise EFitsGraphicColorException.Create(ePaletteUnknown, ERROR_PALETTE_UNKNOWN);
  if FPalette <> Value then
    FPalette := Value;
end;

procedure TGraphicColor.SetPaletteOrder(Value: TPaletteOrder);
begin
  if FPaletteOrder <> Value then
    FPaletteOrder := Value;
end;

procedure TGraphicColor.Tone(const ABrightness, AContrast, AGamma: Double);
begin
  // Check valid value
  if (ABrightness < cBrightnessMin) or (ABrightness > cBrightnessMax) then
    raise EFitsGraphicColorException.CreateFmt(eBrightnessInvalid, [ABrightness, cBrightnessMin, cBrightnessMax], ERROR_BRIGHTNESS_INVALID);
  if (AContrast < cContrastMin) or (AContrast > cContrastMax) then
    raise EFitsGraphicColorException.CreateFmt(eContrastInvalid, [AContrast, cContrastMin, cContrastMax], ERROR_CONTRAST_INVALID);
  if (AGamma < cGammaMin) or (AGamma > cGammaMax) then
    raise EFitsGraphicColorException.CreateFmt(eGammaInvalid, [AGamma, cGammaMin, cGammaMax], ERROR_GAMMA_INVALID);   
  // Set value
  if (FBrightness <> ABrightness) or (FContrast <> AContrast) or (FGamma <> AGamma) then
  begin
    FBrightness := ABrightness;
    FContrast := AContrast;
    FGamma := AGamma;
    Banding;
  end;
end;

procedure TGraphicColor.ToneDefault;
begin
  Tone(cBrightnessDef, cContrastDef, cGammaDef);
end;

{ TFitsPicture }

destructor TFitsGraphic.Destroy;
begin
  FGraphicGeom.Free;
  FGraphicColor.Free;
  inherited;
end;

function TFitsGraphic.GetGraphicRgn: TRgn;
begin
  Result := FGraphicGeom.RectFrmToScn(DataRgn);
end;

procedure TFitsGraphic.GraphicPrepare(var Pixels: TPixels; const Rgn: TRgn);
var
  Wrgn, Hrgn, Wpix, Hpix: Integer;
begin
  Wrgn := Rgn.Width;
  Hrgn := Rgn.Height;
  Wpix := Length(Pixels);
  if Wpix > 0 then
    Hpix := Length(Pixels[0])
  else
    Hpix := 0;
  if (Wpix < Wrgn) or (Hpix < Hrgn) then
    SetLength(Pixels, Wrgn, Hrgn);
end;

procedure TFitsGraphic.GraphicRead(out Palette: TPalette; var Pixels: TPixels; const Rgn: TRgn);

  function PntInFrame(const Pnt: TPnt): Boolean;
  begin
    with Pnt do
      Result := (X >= 0) and (Y >= 0) and (X <= DataRgn.Width - 1) and (Y <= DataRgn.Height - 1);
  end;

  procedure DataRead(Rnum: Integer; Xmin, Xmax: Integer; var Buffer: TStreamBuffer; var Row1, Row2: TA64f1);
  var
    {$IFDEF DELABITPIX64F}
    v64f: T64f;
    b64f: TA64f1;
    {$ENDIF}
    {$IFDEF DELABITPIX32F}
    v32f: T32f;
    b32f: TA32f1;
    {$ENDIF}
    {$IFDEF DELABITPIX08U}
    v08u: T08u;
    b08u: TA08u1;
    {$ENDIF}
    {$IFDEF DELABITPIX16C}
    v16c: T16c;
    b16c: TA16c1;
    {$ENDIF}
    {$IFDEF DELABITPIX32C}
    v32c: T32c;
    b32c: TA32c1;
    {$ENDIF}
    {$IFDEF DELABITPIX64C}
    v64c: T64c;
    b64c: TA64c1;
    {$ENDIF}
  var
    ler: Boolean;
    BitPixSize: Integer;
    BScale, BZero: Double;
    Size, R, R1, R2: Integer;
    Offset: Int64;
  begin
    ler := SysOrderByte = sobLe;
    BitPixSize := BitPixByteSize(HduCore.BitPix);
    BScale := HduCore.BScale;
    BZero := HduCore.BZero;
    {$IFDEF DELABITPIX64F}
    b64f := TA64f1(Buffer);
    {$ENDIF}
    {$IFDEF DELABITPIX32F}
    b32f := TA32f1(Buffer);
    {$ENDIF}
    {$IFDEF DELABITPIX08U}
    b08u := TA08u1(Buffer);
    {$ENDIF}
    {$IFDEF DELABITPIX16C}
    b16c := TA16c1(Buffer);
    {$ENDIF}
    {$IFDEF DELABITPIX32C}
    b32c := TA32c1(Buffer);
    {$ENDIF}
    {$IFDEF DELABITPIX64C}
    b64c := TA64c1(Buffer);
    {$ENDIF}
    // Row1
    R1 := Xmin; // !Xmin >= DataRgn.X1;
    R2 := Xmax; // !Xmax <= DataRgn.ColsCount - 1;
    Size := (R2 - R1 + 1) * BitPixSize;
    Offset := DataOffset + (Int64(HduCore.NAxis1) * Rnum + R1) * BitPixSize;
    StreamRead(Offset, Size, Buffer);
    case HduCore.BitPix of
      bi64f:
        begin
         {$IFDEF DELABITPIX64F}
          for R := R1 to R2 do
          begin
            v64f := b64f[R - R1];
            if ler then
              v64f := Swap64ff(v64f);
            Row1[R] := v64f * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi32f:
        begin
          {$IFDEF DELABITPIX32F}
          for R := R1 to R2 do
          begin
            v32f := b32f[R - R1];
            if ler then
              v32f := Swap32ff(v32f);
            Row1[R] := v32f * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi08u:
        begin
          {$IFDEF DELABITPIX08U}
          for R := R1 to R2 do
          begin
            v08u := b08u[R - R1];
            Row1[R] := v08u * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi16c:
        begin
          {$IFDEF DELABITPIX16C}
          for R := R1 to R2 do
          begin
            v16c := b16c[R - R1];
            if ler then
              v16c := Swap16cc(v16c);
            Row1[R] := v16c * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi32c:
        begin
          {$IFDEF DELABITPIX32C}
          for R := R1 to R2 do
          begin
            v32c := b32c[R - R1];
            if ler then
              v32c := Swap32cc(v32c);
            Row1[R] := v32c * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi64c:
        begin
          {$IFDEF DELABITPIX64C}
          for R := R1 to R2 do
          begin
            v64c := b64c[R - R1];
            if ler then
              v64c := Swap64cc(v64c);
            Row1[R] := v64c * BScale + BZero;
          end;
          {$ENDIF}
        end;
    end; {case BitPix of ...}
    // Row2
    Rnum := Rnum + 1;
    if Rnum > DataRgn.RowsCount - 1 then
      Rnum := DataRgn.RowsCount - 1;
    Offset := DataOffset + (Int64(HduCore.NAxis1) * Rnum + R1) * BitPixSize;
    StreamRead(Offset, Size, Buffer);
    case HduCore.BitPix of
      bi64f:
        begin
         {$IFDEF DELABITPIX64F}
          for R := R1 to R2 do
          begin
            v64f := b64f[R - R1];
            if ler then
              v64f := Swap64ff(v64f);
            Row2[R] := v64f * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi32f:
        begin
          {$IFDEF DELABITPIX32F}
          for R := R1 to R2 do
          begin
            v32f := b32f[R - R1];
            if ler then
              v32f := Swap32ff(v32f);
            Row2[R] := v32f * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi08u:
        begin
          {$IFDEF DELABITPIX08U}
          for R := R1 to R2 do
          begin
            v08u := b08u[R - R1];
            Row2[R] := v08u * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi16c:
        begin
          {$IFDEF DELABITPIX16C}
          for R := R1 to R2 do
          begin
            v16c := b16c[R - R1];
            if ler then
              v16c := Swap16cc(v16c);
            Row2[R] := v16c * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi32c:
        begin
          {$IFDEF DELABITPIX32C}
          for R := R1 to R2 do
          begin
            v32c := b32c[R - R1];
            if ler then
              v32c := Swap32cc(v32c);
            Row2[R] := v32c * BScale + BZero;
          end;
          {$ENDIF}
        end;
      bi64c:
        begin
          {$IFDEF DELABITPIX64C}
          for R := R1 to R2 do
          begin
            v64c := b64c[R - R1];
            if ler then
              v64c := Swap64cc(v64c);
            Row2[R] := v64c * BScale + BZero;
          end;
          {$ENDIF}
        end;
    end; {case BitPix of ...}
    // free local buf
    {$IFDEF DELABITPIX64F}
    b64f := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX32F}
    b32f := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX08U}
    b08u := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX16C}
    b16c := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX32C}
    b32c := nil;
    {$ENDIF}
    {$IFDEF DELABITPIX64C}
    b64c := nil;
    {$ENDIF}
  end;

  procedure PutPixel(const Xfrm, Yfrm: Double; const Row1, Row2: TA64f1; Xscn, Yscn: Integer);
  var
    X1, Y1, X2, Y2: Integer;
    Value, V: Double;
    K, K1, K2, Vpix: Integer;
  begin
    X1 := Trunc(Xfrm);
    X2 := X1 + 1;
    Y1 := Trunc(Yfrm);
    Y2 := Y1 + 1;
    Value := NaN;
    V := Row1[X1];
    if not IsNan(V) then
    begin
      V := V * (X2 - Xfrm) * (Y2 - Yfrm);
      if not IsNan(V) then
      if IsNan(Value) then Value := V else Value := Value + V;
    end;
    if X2 > DataRgn.Width - 1 then
      V := Row1[DataRgn.Width - 1]
    else  
      V := Row1[X2];
    if not IsNan(V) then
    begin
      V := V * (Xfrm - X1) * (Y2 - Yfrm);
      if not IsNan(V) then
      if IsNan(Value) then Value := V else Value := Value + V;
    end;
    V := Row2[X1];
    if not IsNan(V) then
    begin
      V := V * (X2 - Xfrm) * (Yfrm - Y1);
      if not IsNan(V) then
      if IsNan(Value) then Value := V else Value := Value + V;
    end;
    if X2 > DataRgn.Width - 1 then
      V := Row2[DataRgn.Width - 1]
    else
      V := Row2[X2];
    if not IsNan(V) then
    begin
      V := V * (Xfrm - X1) * (Yfrm - Y1);
      if not IsNan(V) then
      if IsNan(Value) then Value := V else Value := Value + V;
    end;    
    if not IsNan(Value) then
    begin
      Vpix := 0;
      K1 := 0;
      K2 := cSizeBand - 1;
      K := cSizeBand div 2;
      while K > 0 do
      begin
        if (Value = FGraphicColor.FBand[K]) then
        begin
          Vpix := K;
          Break;
        end;
        if (K2 <= K1) then
        begin
          Vpix := K1;
          Break;
        end;
        if Value < FGraphicColor.FBand[K] then
          K2 := K - 1
        else
          K1 := K + 1;
        K := (K1 + K2) div 2;
      end;
      Pixels[Xscn - Rgn.X1, Yscn - Rgn.Y1] := Vpix;
    end;
  end;

  procedure PutValue(R: Integer; const Row1, Row2: TA64f1; X0, Y0: Integer);
  var
    A1, A2, B1, B2, P: TPnt;
    Xc: array [1 .. 4] of Double;
    Xcmin, Xcmax, Ycmax: Double;
    Y, X, X1, X2, Y2: Integer;
    Ymax, Xmin, Xmax: Integer;
    Loop: Boolean;
  begin
    //Ymin := Rgn.Y1;
    Ymax := Rgn.Y1 + Rgn.Height - 1;
    Xmin := Rgn.X1;
    Xmax := Rgn.X1 + Rgn.Width - 1;
    // get points row-frame of scene
    A1 := ToPnt(-1, R);
    A2 := ToPnt(DataRgn.Width, R);
    B1 := ToPnt(-1, R + 1);
    B2 := ToPnt(DataRgn.Width, R + 1);
    A1 := GraphicGeom.PntFrmToScn(A1);
    A2 := GraphicGeom.PntFrmToScn(A2);
    B1 := GraphicGeom.PntFrmToScn(B1);
    B2 := GraphicGeom.PntFrmToScn(B2);
    // Y frame parallel a Y scene
    if Math.IsZero(A2.Y - A1.Y) or Math.IsZero(B2.Y - B1.Y) then
    begin
      Y := Y0;
      while True do
      begin
        Loop := False;
        X := X0;
        while True do
        begin
          P := ToPnt(X, Y);
          P := GraphicGeom.PntScnToFrm(P);
          if (Trunc(P.Y) = R) and (P.X >= 0) and (P.X <= DataRgn.Width - 1) then
          begin
            Loop := True;
            PutPixel(P.X, P.Y, Row1, Row2, X, Y);
            Inc(X);
            if X > Xmax then
              Break;
          end
          else
            Break;
        end;
        if not Loop then
          Break;
        Inc(Y);
        if Y > Ymax then
          Break;
      end;
    end
    else
    // Y frame ortogonal a Y scene
    if Math.IsZero(A2.X - A1.X) or Math.IsZero(B2.X - B1.X) then
    begin
      X := X0;
      while True do
      begin
        Loop := False;
        Y := Y0;
        while True do
        begin
          P := ToPnt(X, Y);
          P := GraphicGeom.PntScnToFrm(P);
          if (Trunc(P.Y) = R) and (P.X >= 0) and (P.X <= DataRgn.Width - 1) then
          begin
            Loop := True;
            PutPixel(P.X, P.Y, Row1, Row2, X, Y);
            Inc(Y);
            if Y > Ymax then
              Break;
          end
          else
            Break;
        end;
        if not Loop then
          Break;
        Inc(X);
        if X > Xmax then
          Break;
      end;
    end
    else
    // Y frame tilted a Y scene
    begin
      // get real Ymin for not full frame 
      Xc[1] := ((A1.Y - A2.Y) * (Xmin - 1) + A1.X * A2.Y - A2.X * A1.Y) / (A1.X - A2.X);
      Xc[2] := ((A1.Y - A2.Y) * (Xmax + 1) + A1.X * A2.Y - A2.X * A1.Y) / (A1.X - A2.X);
      Xc[3] := ((B1.Y - B2.Y) * (Xmin - 1) + B1.X * B2.Y - B2.X * B1.Y) / (B1.X - B2.X);
      Xc[4] := ((B1.Y - B2.Y) * (Xmax + 1) + B1.X * B2.Y - B2.X * B1.Y) / (B1.X - B2.X);
      Ycmax := Xc[1];
      for X := 2 to 4 do
        if Xc[X] > Ycmax then Ycmax := Xc[X];
      Ycmax := Ycmax + 1;
      if Ycmax > Ymax then
        Y2 := Ymax
      else
        Y2 := Trunc(Ycmax);
      // loop
      Y := Y0;    
      while True do
      begin
        Xc[1] := ((A2.X - A1.X) * (Y + 0) + A1.X * A2.Y - A2.X * A1.Y) / (A2.Y - A1.Y);
        Xc[2] := ((A2.X - A1.X) * (Y + 1) + A1.X * A2.Y - A2.X * A1.Y) / (A2.Y - A1.Y);
        Xc[3] := ((B2.X - B1.X) * (Y + 0) + B1.X * B2.Y - B2.X * B1.Y) / (B2.Y - B1.Y);
        Xc[4] := ((B2.X - B1.X) * (Y + 1) + B1.X * B2.Y - B2.X * B1.Y) / (B2.Y - B1.Y);
        Xcmin := Xc[1];
        Xcmax := Xc[1];
        for X := 2 to 4 do
        begin
          if Xc[X] > Xcmax then Xcmax := Xc[X];
          if Xc[X] < Xcmin then Xcmin := Xc[X];
        end;
        // WTF: for wery small angle...
        Xc[1] := ((A2.X - A1.X) * (Y - 1) + A1.X * A2.Y - A2.X * A1.Y) / (A2.Y - A1.Y);
        Xc[2] := ((B2.X - B1.X) * (Y - 1) + B1.X * B2.Y - B2.X * B1.Y) / (B2.Y - B1.Y);
        for X := 1 to 2 do
        begin
          if Xc[X] > Xcmax then Xcmax := Xc[X];
          if Xc[X] < Xcmin then Xcmin := Xc[X];
        end;
        Xcmin := Xcmin + 0;
        if Xcmin < Xmin then
          X1 := Xmin
        else if Xcmin > Xmax then
          X1 := Xmin
        else
          X1 := Trunc(Xcmin);
        Xcmax := Xcmax + 1;
        if Xcmax > Xmax then
          X2 := Xmax
        else if Xcmax < Xmin then
          X2 := Xmax
        else
          X2 := Trunc(Xcmax);
        for X := X1 to X2 do
        begin
          P := ToPnt(X, Y);
          P := GraphicGeom.PntScnToFrm(P);
          if (Trunc(P.Y) = R) and (P.X >= 0) and (P.X <= DataRgn.Width - 1) then
            PutPixel(P.X, P.Y, Row1, Row2, X, Y);
        end;
        Inc(Y);
        if Y > Y2 then // or if Y > Ymax then
          Break;
      end; // end loop inc(y)
    end;
  end;

var
  I, J, R, N: Integer;
  Pnt: TPnt;
  Buffer: TStreamBuffer;
  Row1, Row2: TA64f1;
  RowHash: array of Boolean;
  Clip: TClip;
  ClipXmin, ClipXmax: Double;
  ClipXminInt, ClipXmaxInt: Integer;
begin
  // Build Histogram
  if not FGraphicColor.HistogramIsMake then
    FGraphicColor.HistogramUpdate;
  // Build Palette
  case FGraphicColor.PaletteOrder of
    palDirect:
      for I := 0 to cSizePalette - 1 do
        Palette[I] := FGraphicColor.Palette^[I];
    palInverse:
      for I := 0 to cSizePalette - 1 do
        Palette[cSizePalette - 1 - I] := FGraphicColor.Palette^[I];
  end;
  // Clear Pixels
  for J := 0 to Rgn.Width - 1 do
  for I := 0 to Rgn.Height - 1 do
    Pixels[J, I] := 0;
  // Get clip frame in current scene  
  Clip := FGraphicGeom.ClipScnInFrm(Rgn);
  if Clip.PN = 0 then
    Exit;
  ClipXmin := Clip.Y1;
  ClipXmax := Clip.Y1; 
  for I := 2 to Clip.PN do
    with Clip.PA[I] do
    begin
      if ClipXmin > X then ClipXmin := X;
      if ClipXmax < X then ClipXmax := X;
    end;
  ClipXminInt := Trunc(ClipXmin) - 1; if ClipXminInt < DataRgn.X1 then ClipXminInt := DataRgn.X1;
  ClipXmaxInt := Trunc(ClipXmax) + 1; if ClipXmaxInt > DataRgn.Width - 1 then ClipXmaxInt := DataRgn.Width - 1;
  // Prepare buffer, array rows and hash row
  N := DataRgn.ColsCount;
  Buffer := nil;
  AllocateBuffer(Pointer(Buffer), (N + 1) * BitPixByteSize(HduCore.BitPix));
  SetLength(Row1, N);
  SetLength(Row2, N);
  N := DataRgn.RowsCount;
  SetLength(RowHash, N);
  // Init hash row
  for I := 0 to Length(RowHash) - 1 do
    RowHash[I] := False;
  // Loop
  for I := Rgn.Y1 to Rgn.Y1 + Rgn.Height - 1 do
  for J := Rgn.X1 to Rgn.X1 + Rgn.Width - 1 do
  begin
    if Pixels[J - Rgn.X1, I - Rgn.Y1] > 0 then
      Continue;
    Pnt := ToPnt(J, I);
    Pnt := GraphicGeom.PntScnToFrm(Pnt);
    if not PntInFrame(Pnt) then
      Continue;
    R := Trunc(Pnt.Y);
    if RowHash[R] then
      Continue
    else
      RowHash[R] := True;
    DataRead(R, ClipXminInt, ClipXmaxInt, Buffer, Row1, Row2);
    PutValue(R, Row1, Row2, J, I);
  end;
  // Release buffer and rows
  ReleaseBuffer(Pointer(Buffer));
  Row1 := nil;
  Row2 := nil;
end;

procedure TFitsGraphic.Init;
begin
  inherited;
  FGraphicGeom := TGraphicGeom.Create(Self);
  FGraphicColor := TGraphicColor.Create(Self);
end;

{ TFitsBitmap }

procedure TFitsBitmap.BitmapRead(Bitmap: TBitmap; const Rgn: TRgn);
begin
  if not Assigned(Bitmap) then
    raise EFitsBitmapException.Create(eBitmapUnsigned, ERRROR_BITMAP_NIL);
  try
    GraphicPrepare(FPixels, Rgn);
    GraphicRead(FPalette, FPixels, Rgn);
    FBitmap := Bitmap;
    {$IFDEF FPC}
    try
    FBitmap.BeginUpdate();
    {$ENDIF}
    SetPixelFormat;
    SetSize(Rgn.Width, Rgn.Height);
    SetPalette;
    SetPixels;
    {$IFDEF FPC}
    finally
    FBitmap.EndUpdate();
    end;
    {$ENDIF}
  except
    on E: Exception do
    begin
      BitmapRelease;
      raise;
    end;
  end;
end;

procedure TFitsBitmap.BitmapRead(Bitmap: TBitmap);
begin
  BitmapRead(Bitmap, GraphicRgn);
end;

procedure TFitsBitmap.BitmapRelease;
var
  I: Integer;
begin
  for I := 0 to cSizePalette - 1 do
    FPalette[I] := ToPaletteItem($00, $00, $00);
  FPixels := nil;
  FBitmap := nil;
end;

procedure TFitsBitmap.SetPixelFormat;
begin
  {$IFNDEF FPC}
  // In Delphi support 8, 24 or 32 bit
  if FBitMap.PixelFormat = pf8bit then
    Exit;
  if FBitMap.PixelFormat = pf24bit then
    Exit;
  if FBitMap.PixelFormat = pf32bit then
    Exit;
  {$ENDIF}
  // Set PixelFormat Default
  FBitMap.PixelFormat := pf24bit;
end;

destructor TFitsBitmap.Destroy;
begin
  FBitmap := nil;
  FPixels := nil;
  inherited;
end;

procedure TFitsBitmap.Init;
begin
  inherited;
  BitmapRelease;
end;

procedure TFitsBitmap.SetPalette;
{$IFNDEF FPC}
const
  cSizeLogPalette = SizeOf(TLogPalette) + SizeOf(TPaletteEntry) * cSizePalette;
var
  I: Integer;
  LogPalette: PLogPalette;
{$ENDIF}
begin
  {$IFDEF FPC}
  // Palette is not supported in Lazarus
  {$ELSE}
  if FBitmap.PixelFormat <> pf8bit then
    Exit;
  if FBitMap.Palette <> 0 then
    DeleteObject(FBitMap.Palette);
  GetMem(LogPalette, cSizeLogPalette);
  LogPalette^.palNumEntries := cSizePalette;
  LogPalette^.palVersion := $300;
  {$R-}
  for I := 0 to cSizePalette - 1 do
    with LogPalette^.palPalEntry[I], FPalette[I] do
    begin
      peRed := R;
      peGreen := G;
      peBlue := B;
      peFlags := PC_NOCOLLAPSE;
    end;
  {$R+}
  FBitMap.Palette := CreatePalette(LogPalette^);
  FreeMem(LogPalette, cSizeLogPalette);
  {$ENDIF}
end;

procedure TFitsBitmap.SetPixels;
type
  TLine24Item = packed record
    iB, iG, iR: Byte;
  end;
type
  {$IFDEF FPC}
  PLine24Item = ^TLine24Item;
  {$ELSE}
  // pf8bit
  TLine08Item = Byte;
  PLine08 = ^TLine08;
  TLine08 = array [0 .. 0] of TLine08Item;
  // pf24bit
  PLine24 = ^TLine24;
  TLine24 = array [0 .. 0] of TLine24Item;
  // pf32bit
  TLine32Item = packed record
    iB, iG, iR, iReserved: Byte;
  end;
  PLine32 = ^TLine32;
  TLine32 = array [0 .. 0] of TLine32Item;
  {$ENDIF}
var
  I, J, Width, Height: Integer;
  {$IFDEF FPC}
  Line24Item: PLine24Item;
  IncPix, IncRow: Integer;
  {$ELSE}
  Line08: PLine08;
  Line24: PLine24;
  Line32: PLine32;
  {$ENDIF}
begin
  Width := FBitmap.Width;
  Height := FBitmap.Height;
  {$IFDEF FPC}
  {$R-}
  IncPix := FBitMap.RawImage.Description.BitsPerPixel div 8;
  IncRow := FBitMap.RawImage.Description.BytesPerLine;
  for I := 0 to Height - 1 do
  begin;
    Line24Item := PLine24Item(FBitMap.RawImage.Data);
    Inc(PByte(Line24Item), IncRow * I);
    for J := 0 to Width - 1 do
    begin
      with Line24Item^, FPalette[FPixels[J, I]] do
      begin
        iB := B;
        iG := G;
        iR := R;
      end;
      Inc(PByte(Line24Item), IncPix);
    end;
  end;
  {$R+}
  {$ELSE}
  {$R-}
  case FBitMap.PixelFormat of
    pf8bit:
      for I := 0 to Height - 1 do
      begin
        Line08 := FBitMap.ScanLine[I];
        for J := 0 to Width - 1 do
          Line08^[J] := FPixels[J, I];
      end;
    pf24bit:
      for I := 0 to Height - 1 do
      begin
        Line24 := FBitMap.ScanLine[I];
        for J := 0 to Width - 1 do
          with Line24^[J], FPalette[FPixels[J, I]] do
          begin
            iB := B;
            iG := G;
            iR := R;
          end;
      end;
    pf32bit:
      for I := 0 to Height - 1 do
      begin
        Line32 := FBitMap.ScanLine[I];
        for J := 0 to Width - 1 do
          with Line32^[J], FPalette[FPixels[J, I]] do
          begin
            iB := B;
            iG := G;
            iR := R;
            iReserved := $00;
          end;
      end;
  end;
  {$R+}
  {$ENDIF}
end;

procedure TFitsBitmap.SetSize(const Width, Height: Integer);
begin
  {$IFDEF FPC}
  FBitmap.SetSize(Width, Height);
  {$ELSE}
  FBitmap.Width := Width;
  FBitmap.Height := Height;
  {$ENDIF}
end;

{ TFitsFileBitmap }

constructor TFitsFileBitmap.CreateJoin(const AFileName: string; AFileMode: Word);
var
  F: TFileStream;
begin
  if not FileExists(AFileName) then
    raise EFitsException.CreateFmt(eFileNotFound, [AFileName], ERROR_FILE_NOT_FOUND);
  F := TFileStream.Create(AFileName, AFileMode);
  try
    inherited CreateJoin(F);
    FFileName := AFileName;
  except
    FStream := nil;
    F.Free;
    raise;
  end;
end;

constructor TFitsFileBitmap.CreateMade(const AFileName: string; const AHduCore: THduCore2d);
var
  F: TFileStream;
begin
  if not FileExists(AFileName) then
  begin
    F := TFileStream.Create(AFileName, cFileCreate);
    F.Free;
  end;
  F := TFileStream.Create(AFileName, cFileReadWrite);
  try
    inherited CreateMade(F, AHduCore);
    FFileName := AFileName;
  except
    FStream := nil;
    F.Free;
    raise;
  end;
end;

destructor TFitsFileBitmap.Destroy;
begin
  if Assigned(FStream) then
    FreeAndNil(FStream);   
  inherited;
end;

function TFitsFileBitmap.GetFileStream: TFileStream;
begin
  Result := FStream as TFileStream; 
end;

end.

