{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{     Standard IMAGE extension: data visualization     }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsPicture;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Classes, Math, {$IFDEF DCC} Windows, {$ENDIF} Graphics,
  DeLaFitsCommon, DeLaFitsMath, DeLaFitsClasses, DeLaFitsImage, DeLaFitsPalette;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_PICTURE                           = 6000;

  ERROR_PICTURE_SPEC_INVALID              = 6100;
  ERROR_PICTURE_SPEC_NAXIS                = 6101;

  ERROR_PICTURE_HEAD_INCORRECT_NAXIS      = 6200;

  ERROR_PICTURE_BINDING_BIND_ASSIGN       = 6300;
  ERROR_PICTURE_BINDING_BIND_INSPECT      = 6301;
  ERROR_PICTURE_BINDING_FREE_INSPECT      = 6302;

  ERROR_PICTURE_HISTOGRAM_INCORRECT_RANGE = 6400;
  ERROR_PICTURE_HISTOGRAM_GETBUCKET_INDEX = 6401;

  ERROR_PICTURE_TONE_INCORRECT_BRIGHTNESS = 6500;
  ERROR_PICTURE_TONE_INCORRECT_CONTRAST   = 6501;
  ERROR_PICTURE_TONE_INCORRECT_GAMMA      = 6502;

  ERROR_PICTURE_PALETTE_INVALID_TUPLES    = 6600;

  ERROR_PICTURE_FRAME_BIND_ASSIGN         = 6700;
  ERROR_PICTURE_FRAME_BIND_INSPECT        = 6701;
  ERROR_PICTURE_FRAME_BIND_INDEX          = 6702;
  ERROR_PICTURE_FRAME_FREE_INSPECT        = 6703;
  ERROR_PICTURE_FRAME_INCORRECT_SCENE     = 6704;
  ERROR_PICTURE_FRAME_INCORRECT_PIXMAP    = 6705;
  ERROR_PICTURE_FRAME_INCORRECT_BITMAP    = 6706;

  ERROR_PICTURE_FRAMES_BIND_ASSIGN        = 6800;
  ERROR_PICTURE_FRAMES_BIND_INSPECT       = 6801;
  ERROR_PICTURE_FRAMES_FREE_INSPECT       = 6802;
  ERROR_PICTURE_FRAMES_GETFRAME_INDEX     = 6803;

resourcestring

  { The messages of exceptions }

  SPictureSpecInvalid             = 'Invalid PICTURE specification';
  SPictureSpecIncorrectValue      = 'Incorrect "%s" value of PICTURE specification';

  SPictureFrameInvalidBind        = 'Binding error: incorrect frame index "%d"';
  SPictureFrameIncorrectScene     = 'Incorrect scene region in Frame[%d] of PICTURE[%d]';
  SPictureFrameIncorrectPixmap    = 'Incorrect Pixmap size in Frame[%d] of PICTURE[%d]';
  SPictureFrameIncorrectBitmap    = 'Bitmap pointer not assigned in Frame[%d] of PICTURE[%d]';

  SPicturePropIncorrectValue      = 'Incorrect %s value "%.4f" in Frame[%d] of PICTURE[%d]';
  SPictureHistogramIncorrectRange = 'Incorrect index of histogram dynamic range "%d .. %d" in Frame[%d] of PICTURE[%d]';
  SPicturePaletteInvalidTuples    = 'Tuples pointer of palette can''t be nil in Frame[%d] of PICTURE[%d]';

const

  cPaletteGrayScale: PPaletteTuples = @DeLaFitsPalette.cPalGrayScale;
  cPaletteHot      : PPaletteTuples = @DeLaFitsPalette.cPalHot;
  cPaletteCool     : PPaletteTuples = @DeLaFitsPalette.cPalCool;
  cPaletteBonnet   : PPaletteTuples = @DeLaFitsPalette.cPalBonnet;
  cPaletteJet      : PPaletteTuples = @DeLaFitsPalette.cPalJet;

type

  { Exception classes }

  EFitsPictureException = class(EFitsImageException);

type

  { Data visualization of the standard IMAGE extension }

  TFitsPicture = class;

  TFitsPictureSpec = class(TFitsImageSpec)
  private
    function GetNaxis: Integer;
    procedure VerifyNaxis(const Value: Integer);
    procedure SetNaxis(const Value: Integer);
  public
    constructor Create(ABitPix: TBitPix; const ANaxes: array of Integer; const ABScale: Extended = 1.0; const ABZero: Extended = 0.0); overload;
    constructor Create(AItem: TFitsPicture); overload;
    constructor Create; overload;
    property Naxis: Integer read GetNaxis write SetNaxis;
  end;

  TFitsPictureHead = class(TFitsImageHead)
  private
    function GetItem: TFitsPicture;
  public
    constructor CreateExplorer(AItem: TFitsItem; APioneer: Boolean); override;
    property Item: TFitsPicture read GetItem;
  end;

  TFitsPictureData = class(TFitsImageData)
  private
    function GetItem: TFitsPicture;
  public
    property Item: TFitsPicture read GetItem;
  end;

  TFitsPictureFrame = class;

  TFitsPictureBinding = class(TObject)
  protected
    FFrame: TFitsPictureFrame;
    procedure Init; virtual;
    procedure Bind(AFrame: TFitsPictureFrame);
  public
    constructor Create(AFrame: TFitsPictureFrame); virtual;
    procedure BeforeDestruction; override;
    destructor Destroy; override;
    property Frame: TFitsPictureFrame read FFrame;
  end;

  TFitsPictureHistogram = class(TFitsPictureBinding)
  private
    FGhost: Boolean;
    FEqualized: Boolean;
    FBuckets: THistogramBuckets;
    FCount: Integer;
    FQuota: Integer;
    FIndexModa: Integer;
    FIndexModaSmooth: Integer;
    FIndexMedian: Integer;
    FIndexBlack: Integer;
    FIndexWhite: Integer;
    FIndexBlackDefault: Integer;
    FIndexWhiteDefault: Integer;
    procedure Build;
    procedure Equalize;
    procedure Analyze;
    procedure Appear;
    procedure AddBucket(const AElem: Extended); {$IFDEF HAS_INLINE} inline; {$ENDIF}
    function GetBucket(Index: Integer): THistogramBucket; {$IFDEF HAS_INLINE} inline; {$ENDIF}
    function GetCount: Integer;
    function GetQuota: Integer;
    function GetIndexModa: Integer;
    function GetIndexModaSmooth: Integer;
    function GetIndexMedian: Integer;
    function GetIndexRange: THistogramIndexRange;
    procedure SetIndexRange(const Value: THistogramIndexRange);
    function GetIndexRangeDefault: THistogramIndexRange;
  protected
    procedure Init; override;
  public
    constructor Create(AFrame: TFitsPictureFrame); override;
    destructor Destroy; override;
    procedure Remap;
    procedure SetDefault;
    property Buckets[Index: Integer]: THistogramBucket read GetBucket;
    property Count: Integer read GetCount;
    property Quota: Integer read GetQuota;
    property IndexModa: Integer read GetIndexModa;
    property IndexModaSmooth: Integer read GetIndexModaSmooth;
    property IndexMedian: Integer read GetIndexMedian;
    property IndexRange: THistogramIndexRange read GetIndexRange write SetIndexRange;
    property IndexRangeDefault: THistogramIndexRange read GetIndexRangeDefault;
  end;

  TFitsPictureTone = class(TFitsPictureBinding)
  private
    FBrightness: Double;
    FContrast: Double;
    FGamma: Double;
    procedure SetBrightness(const Value: Double);
    procedure SetContrast(const Value: Double);
    procedure SetGamma(const Value: Double);
  protected
    procedure Init; override;
  public
    procedure SetDefault;
    property Brightness: Double read FBrightness write SetBrightness;
    property Contrast: Double read FContrast write SetContrast;
    property Gamma: Double read FGamma write SetGamma;
  end;

  TFitsPicturePalette = class(TFitsPictureBinding)
  private
    FTuples: PPaletteTuples;
    FReverse: Boolean;
    procedure SetTuples(const Value: PPaletteTuples);
    procedure SetReverse(const Value: Boolean);
  protected
    procedure Init; override;
  public
    destructor Destroy; override;
    procedure SetDefault;
    property Tuples: PPaletteTuples read FTuples write SetTuples;
    property Reverse: Boolean read FReverse write SetReverse;
  end;

  TFitsPictureGeometry = class(TFitsPictureBinding)

  private
    FMatrixLocal: TMatrix; // Local point -> Scene point
    FMatrixScene: TMatrix; // Scene point -> Local point
    procedure GetSceneDesignPoint(APoint: TDesignPoint; out pX, pY: Double);
    procedure GetSceneDesignShift(AShift: TDesignShift; out dX, dY: Double);
  protected
    procedure Init; override;
  public
    procedure SetDefault;
    property MatrixLocal: TMatrix read FMatrixLocal;
    property MatrixScene: TMatrix read FMatrixScene;

  public

    // Local system transform: parameters (points coordinates) must be specified in the Scene system

    function Reset: TFitsPictureGeometry;
    function Multiply(const Matrix: TMatrix): TFitsPictureGeometry;
    function Shift(const dX, dY: Double): TFitsPictureGeometry; overload;
    function Shift(const AShift: TDesignShift): TFitsPictureGeometry; overload;
    function Scale(const sX, sY: Double; const pX, pY: Double): TFitsPictureGeometry; overload;
    function Scale(const sX, sY: Double; const P: TPnt): TFitsPictureGeometry; overload;
    function Scale(const sX, sY: Double; const P: TDesignPoint): TFitsPictureGeometry; overload;
    function Rotate(const Angle: Double; const pX, pY: Double): TFitsPictureGeometry; overload;
    function Rotate(const Angle: Double; const P: TPnt): TFitsPictureGeometry; overload;
    function Rotate(const Angle: Double; const P: TDesignPoint): TFitsPictureGeometry; overload;
    function ShearX(const Angle: Double): TFitsPictureGeometry;
    function ShearY(const Angle: Double): TFitsPictureGeometry;

    // Point transform

    function PntSceneToLocal(const PntScn: TPnt): TPnt;
    function PntLocalToScene(const PntLoc: TPnt): TPnt;
    function PixSceneToLocal(const PixScn: TPix): TPix;
    function PixLocalToScene(const PixLoc: TPix): TPix;

    // Region transform

    function QuadSceneToLocal(const RgnScn: TRegion): TQuad;
    function QuadLocalToScene(const RgnLoc: TRegion): TQuad;

    // Region transform with contouring

    function RectSceneToLocal(const RgnScn: TRegion): TRegion;
    function RectLocalToScene(const RgnLoc: TRegion): TRegion;

    // Intersect the window region and the real frame region

    function ClipRegionToLocal(const WndScn: TRegion): TClip;
    function ClipRegionToScene(const WndScn: TRegion): TClip;

  end;

  TFitsManagerPixmap = class(TObject)
  private
    {$IFDEF DELA_MEMORY_PRIVATE}
    FPixmap: TPixmap;
    {$ENDIF}
    function NeedRealloc(const APixmap: TPixmap; const NewWidth, NewHeight: Integer): Boolean;
    procedure Realloc(var APixmap: TPixmap; const NewWidth, NewHeight: Integer);
  public
    class function NewPixmap: TPixmap;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Allocate(var APixmap: TPixmap; const AWidth, AHeight: Integer);
    procedure Release(var APixmap: TPixmap);
    procedure Reset;
  end;

  TFitsPictureFrame = class(TObject)

  private

    FItem: TFitsPicture;
    FIndexFrame: Integer;
    FHistogram: TFitsPictureHistogram;
    FTone: TFitsPictureTone;
    FPalette: TFitsPicturePalette;
    FGeometry: TFitsPictureGeometry;
    FBand: TFrameBand;
    FBandaged: Boolean;

    procedure Init;
    procedure Bind(AItem: TFitsPicture; AIndexFrame: Integer);
    function GetIndexElems: Int64;
    function GetCountElems: Int64;
    procedure Bandage;
    procedure LazyBandage;
    function GetBand: TFrameBand;
    procedure SetBand(const Value: TFrameBand);
    function GetLocalRegion: TRegion;
    function GetLocalWidth: Integer;
    function GetLocalHeight: Integer;
    function GetLocalPixel(X, Y: Integer): Extended;
    procedure SetLocalPixel(X, Y: Integer; const Value: Extended);
    function GetSceneHeight: Integer;
    function GetScenePixel(X, Y: Integer): Extended;
    function GetSceneRegion: TRegion;
    function GetSceneWidth: Integer;

  public

    constructor Create(AItem: TFitsPicture; AIndexFrame: Integer);
    procedure BeforeDestruction; override;
    destructor Destroy; override;
    procedure Drop;
    procedure Remap;
    property Item: TFitsPicture read FItem;
    property IndexFrame: Integer read FIndexFrame;
    property IndexElems: Int64 read GetIndexElems;
    property CountElems: Int64 read GetCountElems;

  public

    property Histogram: TFitsPictureHistogram read FHistogram;
    property Tone: TFitsPictureTone read FTone;
    property Palette: TFitsPicturePalette read FPalette;
    property Band: TFrameBand read GetBand write SetBand;

  public

    property Geometry: TFitsPictureGeometry read FGeometry;
    property SceneRegion: TRegion read GetSceneRegion;
    property SceneWidth: Integer read GetSceneWidth;
    property SceneHeight: Integer read GetSceneHeight;
    property ScenePixels[X, Y: Integer]: Extended read GetScenePixel;
    property LocalRegion: TRegion read GetLocalRegion;
    property LocalWidth: Integer read GetLocalWidth;
    property LocalHeight: Integer read GetLocalHeight;
    property LocalPixels[X, Y: Integer]: Extended read GetLocalPixel write SetLocalPixel;

  protected
    FPixmap: TFitsManagerPixmap;
  private
    procedure AllowRender(const ASceneRegion: TRegion; const APix: TPaletteIndexs);
    procedure RenderMap(var AMap: TPaletteTuples);
    procedure RenderOff(const ASceneRegion: TRegion; var APix: TPaletteIndexs);
    function BoundRender(const ASceneRegion: TRegion; out ALocalBound, ASceneBound: TBound): Boolean;
    function RenderPix(const ALocalPoint: TPnt; const ALocalBound: TBound; const ALocalRow1, ALocalRow2: TA64f): Byte;
    procedure SetBitmapFormat(ABitmap: TBitmap);
    procedure SetBitmapSize(ABitmap: TBitmap; const AWidth, AHeight: Integer);
    procedure SetBitmapPalette(ABitmap: TBitmap; const AMap: TPaletteTuples);
    procedure SetBitmapPixels(ABitmap: TBitmap; const AMap: TPaletteTuples; const APix: TPaletteIndexs; const AWidth, AHeight: Integer);
  public
    procedure RenderScene(var APixmap: TPixmap; const ASceneRegion: TRegion); overload;
    procedure RenderScene(var ABitmap: TBitmap; const ASceneRegion: TRegion); overload;

  end;

  TFitsPictureFrames = class(TObject)
  private
    FItem: TFitsPicture;
    FFrames: TList;
    procedure Init;
    procedure Bind(AItem: TFitsPicture);
    function GetCount: Integer;
    function GetFrame(Index: Integer): TFitsPictureFrame;
    procedure DropFrame(AFrame: TFitsPictureFrame);
  public
    constructor Create(AItem: TFitsPicture);
    procedure BeforeDestruction; override;
    destructor Destroy; override;
    procedure Drop;
    procedure Remap;
    property Frames[Index: Integer]: TFitsPictureFrame read GetFrame; default;
    property Count: Integer read GetCount;
  end;

  TFitsPicture = class(TFitsImage)
  private
    FInspect: Boolean;
    FFrames: TFitsPictureFrames;
  private
    function GetHead: TFitsPictureHead;
    function GetData: TFitsPictureData;
  protected
    function GetHeadClass: TFitsItemHeadClass; override;
    function GetDataClass: TFitsItemDataClass; override;
  public
    constructor CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean); override;
    constructor CreateNewcomer(AContainer: TFitsContainer; ASpec: TFitsItemSpec); override;
    destructor Destroy; override;
    property Head: TFitsPictureHead read GetHead;
    property Data: TFitsPictureData read GetData;
    property Frames: TFitsPictureFrames read FFrames;
  end;

implementation

{ TFitsPictureSpec }

constructor TFitsPictureSpec.Create(ABitPix: TBitPix; const ANaxes: array of Integer; const ABScale, ABZero: Extended);
begin
  VerifyNaxis(Length(ANaxes));
  inherited Create(ABitPix, ANaxes, ABScale, ABZero);
end;

constructor TFitsPictureSpec.Create(AItem: TFitsPicture);
begin
  inherited Create(AItem);
  VerifyNaxis(Naxis);
end;

constructor TFitsPictureSpec.Create;
begin
  inherited Create;
  Naxis    := 2;
  Naxes[1] := 1;
  Naxes[2] := 1;
end;

function TFitsPictureSpec.GetNaxis: Integer;
begin
  Result := inherited Naxis;
end;

procedure TFitsPictureSpec.VerifyNaxis(const Value: Integer);
begin
  if Value < 2 then
    raise EFitsPictureException.CreateFmt(SPictureSpecIncorrectValue, ['Naxis'], ERROR_PICTURE_SPEC_NAXIS);
end;

procedure TFitsPictureSpec.SetNaxis(const Value: Integer);
begin
  VerifyNaxis(Value);
  inherited Naxis := Value;
end;

{ TFitsPictureHead }

constructor TFitsPictureHead.CreateExplorer(AItem: TFitsItem; APioneer: Boolean);
begin
  inherited;
  // check correct of "NAXIS" value
  if Item.Naxis < 2 then
    raise EFitsPictureException.CreateFmt(SImageHeadIncorrectValue, [cNAXIS, Item.Index], ERROR_PICTURE_HEAD_INCORRECT_NAXIS);
end;

function TFitsPictureHead.GetItem: TFitsPicture;
begin
  Result := inherited Item as TFitsPicture;
end;

{ TFitsPictureData }

function TFitsPictureData.GetItem: TFitsPicture;
begin
  Result := inherited Item as TFitsPicture;
end;

{ TFitsPictureBinding }

procedure TFitsPictureBinding.Init;
begin
  FFrame := nil;
end;

procedure TFitsPictureBinding.Bind(AFrame: TFitsPictureFrame);
begin
  if not Assigned(AFrame) then
    raise EFitsPictureException.Create(SItemNotAssign, ERROR_PICTURE_BINDING_BIND_ASSIGN);
  if not AFrame.FItem.FInspect then
    raise EFitsPictureException.Create(SBindNoInspect, ERROR_PICTURE_BINDING_BIND_INSPECT);
  FFrame := AFrame;
end;

constructor TFitsPictureBinding.Create(AFrame: TFitsPictureFrame);
begin
  inherited Create;
  Init;
  Bind(AFrame);
end;

procedure TFitsPictureBinding.BeforeDestruction;
begin
  if not FFrame.FItem.FInspect then
    raise EFitsPictureException.CreateFmt(SFreeNoInspect, [FFrame.FItem.Index], ERROR_PICTURE_BINDING_FREE_INSPECT);
  inherited;
end;

destructor TFitsPictureBinding.Destroy;
begin
  FFrame := nil;
  inherited;
end;

{ TFitsPictureHistogram }

procedure TFitsPictureHistogram.Init;
begin
  inherited;
  FGhost             := True;
  FEqualized         := False;
  FBuckets           := nil;
  FCount             :=  0;
  FQuota             :=  0;
  FIndexModa         := -1;
  FIndexModaSmooth   := -1;
  FIndexMedian       := -1;
  FIndexBlack        := -1;
  FIndexWhite        := -1;
  FIndexBlackDefault := -1;
  FIndexWhiteDefault := -1;
end;

procedure TFitsPictureHistogram.Build;
var
  BitPix: TBitPix;
  BitSize: Byte;
  BScale, BZero: Extended;
  Swapper: TSwapper;
  CountElems, SizeChunk, UffsetChunk: Int64;
  CountChunk, QuotaElems, QuotaChunk: Integer;
  Chunk: TBuffer;
  Chunk64f: TA64f;
  Chunk32f: TA32f;
  Chunk08u: TA08u;
  Chunk16c: TA16c;
  Chunk32c: TA32c;
  Chunk64c: TA64c;
  I: Integer;
  Elem: Extended;
begin

  BitPix  := FFrame.Item.BitPix;
  BitSize := BitPixSize(BitPix);
  BScale  := FFrame.Item.BScale;
  BZero   := FFrame.Item.BZero;

  Swapper := GetSwapper();

  // count of data elements

  CountElems := Int64(FFrame.Item.Naxes[1]) * FFrame.Item.Naxes[2];

  // count and size read-chunk of data elements

  CountChunk := cMaxSizeBuffer div BitSize;
  if CountChunk > CountElems then
    CountChunk := CountElems;
  SizeChunk := Int64(CountChunk) * BitSize;

  // count of data elements to append in brackets array (simple random sample)

  QuotaElems := cHistogramMaxQuota;
  if QuotaElems > CountElems then
    QuotaElems := CountElems;

  // count of read-chunk data elements to append in brackets array

  QuotaChunk := Round(Int64(CountChunk) * QuotaElems / CountElems);
  if QuotaChunk < 1 then
    QuotaChunk := 1;

  try

    // form a new backets

    FEqualized := False;

    FCount := 0;
    FQuota := 0;

    Randomize;

    Chunk := nil;
    FFrame.Item.Container.Content.Buffer.Allocate(Pointer(Chunk), SizeChunk);

    UffsetChunk := FFrame.IndexElems * BitSize;

    while CountElems > 0 do
    begin

      // last chunk correction

      if CountElems < CountChunk then
      begin
        CountChunk := CountElems;
        SizeChunk  := CountElems * BitSize;
        QuotaChunk := QuotaElems;
        if QuotaChunk < 1 then
          QuotaChunk := 1;
        if QuotaChunk > CountChunk then
          QuotaChunk := CountChunk;
      end;

      // read a chunk of data elements

      FFrame.Item.Data.Read(UffsetChunk, SizeChunk, Chunk[0]);

      // select a random data elements from chunk
      // and insert a selected elements in buckets

      case BitPix of
        bi64f:
          begin
            Chunk64f := TA64f(Chunk);
            Shake64f(Chunk64f, CountChunk, QuotaChunk);
            for I := 0 to QuotaChunk - 1 do
            begin
              Elem := Swapper.Swap64f(Chunk64f[I]);
              Elem := UnNan64f(Elem) * BScale + BZero;
              AddBucket(Elem);
            end;
          end;
        bi32f:
          begin
            Chunk32f := TA32f(Chunk);
            Shake32f(Chunk32f, CountChunk, QuotaChunk);
            for I := 0 to QuotaChunk - 1 do
            begin
              Elem := Swapper.Swap32f(Chunk32f[I]);
              Elem := UnNan64f(Elem) * BScale + BZero;
              AddBucket(Elem);
            end;
          end;
        bi08u:
          begin
            Chunk08u := TA08u(Chunk);
            Shake08u(Chunk08u, CountChunk, QuotaChunk);
            for I := 0 to QuotaChunk - 1 do
            begin
              Elem := Chunk08u[I] * BScale + BZero;
              AddBucket(Elem);
            end;
          end;
        bi16c:
          begin
            Chunk16c := TA16c(Chunk);
            Shake16c(Chunk16c, CountChunk, QuotaChunk);
            for I := 0 to QuotaChunk - 1 do
            begin
              Elem := Swapper.Swap16c(Chunk16c[I]) * BScale + BZero;
              AddBucket(Elem);
            end;
          end;
        bi32c:
          begin
            Chunk32c := TA32c(Chunk);
            Shake32c(Chunk32c, CountChunk, QuotaChunk);
            for I := 0 to QuotaChunk - 1 do
            begin
              Elem := Swapper.Swap32c(Chunk32c[I]) * BScale + BZero;
              AddBucket(Elem);
            end;
          end;
        bi64c:
          begin
            Chunk64c := TA64c(Chunk);
            Shake64c(Chunk64c, CountChunk, QuotaChunk);
            for I := 0 to QuotaChunk - 1 do
            begin
              Elem := Swapper.Swap64c(Chunk64c[I]) * BScale + BZero;
              AddBucket(Elem);
            end;
          end;
      end;

      Inc(UffsetChunk, SizeChunk);
      Dec(CountElems, CountChunk);
      Dec(QuotaElems, QuotaChunk);

    end;

    // complete the equalization

    if FEqualized then
      Equalize;

    // fix buckets size

    SetLength(FBuckets, FCount);

  finally
    Chunk64f := nil;
    Chunk32f := nil;
    Chunk08u := nil;
    Chunk16c := nil;
    Chunk32c := nil;
    Chunk64c := nil;
    FFrame.Item.Container.Content.Buffer.Release(Pointer(Chunk));
    Chunk := nil;
  end;
end;

procedure TFitsPictureHistogram.Equalize;
var
  I, J, K, N: Integer;
  CountBuckets: Integer;
  SumFreq: Integer;
  GapElem, Elem1, Elem2, SumElem: Extended;
  Bucket: PHistogramBucket;
begin

  CountBuckets := FCount;

  // get the average value of the natural buckets interval

  N := 0;
  GapElem := 0.0;
  for I := 0 to CountBuckets - 2 do
  begin
    Elem1 := FBuckets[I]^.Elem;
    Elem2 := FBuckets[I + 1]^.Elem;
    if not (Math.IsInfinite(Elem1) or Math.IsInfinite(Elem2)) then
    begin
      GapElem := GapElem + (Elem2 - Elem1);
      Inc(N);
    end;
  end;
  if N > 0 then
    GapElem := GapElem / N;

  // equalize

  I := 0;
  K := 0;
  while I < CountBuckets do
  begin
    N := 1;
    Elem1 := FBuckets[I]^.Elem;
    if not Math.IsInfinite(Elem1) then
      for J := I + 1 to CountBuckets - 1 do
      begin
        Elem2 := FBuckets[J]^.Elem;
        if Math.IsInfinite(Elem2) then
          Break;
        if Elem2 - Elem1 > GapElem then
          Break;
        Inc(N);
      end;
    Bucket := FBuckets[K];
    SumElem := 0.0;
    SumFreq := 0;
    for J := I to I + (N - 1) do
    begin
      SumElem := SumElem + FBuckets[J]^.Elem;
      SumFreq := SumFreq + FBuckets[J]^.Freq;
    end;
    Bucket^.Elem := SumElem / N;
    Bucket^.Freq := SumFreq;
    Inc(K);
    Dec(FCount, N - 1);
    Inc(I, N);
  end;

  // fix a buckets count

  for I := FCount to CountBuckets - 1 do
  begin
    Bucket := FBuckets[I];
    Dispose(Bucket);
    FBuckets[I] := nil;
  end;

  // fix a equalize fact

  FEqualized := True;

end;

procedure TFitsPictureHistogram.Analyze;
var
  I, J, J1, J2, N, M, S: Integer;
  B: Boolean;
begin

  // moda

  FIndexModa       := 0;
  FIndexModaSmooth := 0;
  for I := 0 to FCount - 1 do
  begin
    N := FBuckets[I]^.Freq;
    // moda
    if N > FBuckets[FIndexModa]^.Freq then
      FIndexModa := I;
    // moda smooth
    if N > FBuckets[FIndexModaSmooth]^.Freq then
    begin
      B := True;
      S := 0;
      J1 := Math.Max(I - 3, 0);
      J2 := Math.Min(I + 3, FCount - 1);
      for J := J1 to J2 do
        if J <> I then
        begin
          M := FBuckets[J]^.Freq;
          if M > N then
          begin
            B := False;
            Break;
          end;
          S := S + M;
        end;
      if B and (N <= S) then
        FIndexModaSmooth := I;
    end;
  end;

  // median

  FIndexMedian := 0;
  N := FQuota div 2;
  S := 0;
  for I := 0 to FCount - 1 do
  begin
    S := S + FBuckets[I]^.Freq;
    if S >= N then
    begin
      FIndexMedian := I;
      Break;
    end;
  end;

  // dynamic range

  FIndexBlack := 0;
  FIndexWhite := 0;
  FIndexBlackDefault := 0;
  FIndexWhiteDefault := 0;
  N := FQuota div 2;
  S := FBuckets[FIndexMedian]^.Freq;
  I := 1;
  J1 := FIndexMedian - 1;
  J2 := FIndexMedian + 1;
  while True do
  begin
    if J1 >= 0 then
      S := S + FBuckets[J1]^.Freq;
    if J2 < FCount then
      S := S + FBuckets[J2]^.Freq;
    if S >= N then
    begin
      FIndexBlack := Math.Max(FIndexMedian - 4 * I, 0);
      FIndexWhite := Math.Min(Integer(Round(FIndexMedian + 7.5 * I)), FCount - 1);
      FIndexBlackDefault := FIndexBlack;
      FIndexWhiteDefault := FIndexWhite;
      Break;
    end;
    Inc(I);
    Dec(J1);
    Inc(J2);
  end;

end;

procedure TFitsPictureHistogram.Appear;
begin
  if FGhost then
  begin
    Build;
    Analyze;
    FGhost := False;
  end;
end;

constructor TFitsPictureHistogram.Create(AFrame: TFitsPictureFrame);
begin
  inherited Create(AFrame);
  // lazy initialization, see Appear() method
end;

destructor TFitsPictureHistogram.Destroy;
var
  I: Integer;
  Bucket: PHistogramBucket;
begin
  for I := Low(FBuckets) to High(FBuckets) do
  begin
    Bucket := FBuckets[I];
    Dispose(Bucket);
    FBuckets[I] := nil;
  end;
  FBuckets := nil;
  inherited;
end;

procedure TFitsPictureHistogram.Remap;
var
  I: Integer;
  Bucket: PHistogramBucket;
begin
  for I := Low(FBuckets) to High(FBuckets) do
  begin
    Bucket := FBuckets[I];
    Dispose(Bucket);
    FBuckets[I] := nil;
  end;
  FEqualized         := False;
  FCount             :=  0;
  FQuota             :=  0;
  FIndexModa         := -1;
  FIndexModaSmooth   := -1;
  FIndexMedian       := -1;
  FIndexBlack        := -1;
  FIndexWhite        := -1;
  FIndexBlackDefault := -1;
  FIndexWhiteDefault := -1;
  FGhost := True;
  Appear;
end;

procedure TFitsPictureHistogram.SetDefault;
begin
  Self.IndexRange := Self.IndexRangeDefault;
end;

procedure TFitsPictureHistogram.AddBucket(const AElem: Extended);
var
  I, I1, I2: Integer;
  Newcomer: Boolean;
  Bucket: PHistogramBucket;
begin

  // register the element

  Inc(FQuota);

  // binary search

  I  := 0;
  I1 := 0;
  I2 := FCount - 1;
  Newcomer := True;
  while I2 >= I1 do
  begin
    I := I1 + (I2 - I1) div 2;
    Bucket := FBuckets[I];
    if AElem < Bucket^.Elem then
    begin
      I2 := I - 1;
      // I := I;
    end
    else if AElem = Bucket^.Elem then
    begin
      Bucket^.Freq := Bucket^.Freq + 1;
      Newcomer := False;
      Break;
    end
    else // if AElem > Bucket^.Elem then
    begin
      I1 := I + 1;
      Inc(I);
    end;
    // ... Math.CompareValue(AElem, Bucket^.Elem)
    // may throw an exception for infinity-values
  end;

  if Newcomer then
  begin

    New(Bucket);
    Bucket^.Elem := AElem;
    Bucket^.Freq := 1;

    // insert new bucket in position I

    if FCount = Length(FBuckets) then
      SetLength(FBuckets, Math.Min(FCount + cHistogramMaxCount div 10, cHistogramMaxCount));
    if I < FCount then
      System.Move(FBuckets[I], FBuckets[I + 1], (FCount - I) * SizeOf(Bucket));
    FBuckets[I] := Bucket;
    Inc(FCount);

    // natural equalize: limiting a buckets count

    if FCount = cHistogramMaxCount then
      Equalize;

  end;

end;

function TFitsPictureHistogram.GetBucket(Index: Integer): THistogramBucket;
begin
  Appear;
  if (Index < 0) or (Index >= FCount) then
    raise EFitsPictureException.CreateFmt(SListIndexOutBounds, [Index], ERROR_PICTURE_HISTOGRAM_GETBUCKET_INDEX);
  Result := FBuckets[Index]^;
end;

function TFitsPictureHistogram.GetCount: Integer;
begin
  Appear;
  Result := FCount;
end;

function TFitsPictureHistogram.GetQuota: Integer;
begin
  Appear;
  Result := FQuota;
end;

function TFitsPictureHistogram.GetIndexModa: Integer;
begin
  Appear;
  Result := FIndexModa;
end;

function TFitsPictureHistogram.GetIndexModaSmooth: Integer;
begin
  Appear;
  Result := FIndexModaSmooth;
end;

function TFitsPictureHistogram.GetIndexMedian: Integer;
begin
  Appear;
  Result := FIndexMedian;
end;

function TFitsPictureHistogram.GetIndexRange: THistogramIndexRange;
begin
  Appear;
  Result.Black := FIndexBlack;
  Result.White := FIndexWhite;
end;

procedure TFitsPictureHistogram.SetIndexRange(const Value: THistogramIndexRange);
begin
  Appear;
  if Value.Black > Value.White then
    raise EFitsPictureException.CreateFmt(SPictureHistogramIncorrectRange,
      [Value.Black, Value.White, FFrame.FIndexFrame, FFrame.FItem.Index],
      ERROR_PICTURE_HISTOGRAM_INCORRECT_RANGE);
  if (Value.Black <> FIndexBlack) or (Value.White <> FIndexWhite) then
  begin
    FIndexBlack := Value.Black;
    FIndexWhite := Value.White;
    FFrame.LazyBandage;
  end;
end;

function TFitsPictureHistogram.GetIndexRangeDefault: THistogramIndexRange;
begin
  Appear;
  Result.Black := FIndexBlackDefault;
  Result.White := FIndexWhiteDefault;
end;

{ TFitsPictureTone }

procedure TFitsPictureTone.Init;
begin
  inherited;
  FBrightness := cBrightnessDef;
  FContrast := cContrastDef;
  FGamma := cGammaDef;
end;

procedure TFitsPictureTone.SetBrightness(const Value: Double);
begin
  if Math.IsNan(Value) or (Value < cBrightnessMin) or (Value > cBrightnessMax) then
    raise EFitsPictureException.CreateFmt(SPicturePropIncorrectValue,
      ['brightness', Value, Frame.FIndexFrame, FFrame.FItem.Index],
      ERROR_PICTURE_TONE_INCORRECT_BRIGHTNESS);
  if FBrightness <> Value then
  begin
    FBrightness := Value;
    FFrame.LazyBandage;
  end;
end;

procedure TFitsPictureTone.SetContrast(const Value: Double);
begin
  if Math.IsNan(Value) or (Value < cContrastMin) or (Value > cContrastMax) then
    raise EFitsPictureException.CreateFmt(SPicturePropIncorrectValue,
      ['contrast', Value, Frame.FIndexFrame, FFrame.FItem.Index],
      ERROR_PICTURE_TONE_INCORRECT_CONTRAST);
  if FContrast <> Value then
  begin
    FContrast := Value;
    FFrame.LazyBandage;
  end;
end;

procedure TFitsPictureTone.SetGamma(const Value: Double);
begin
  if Math.IsNan(Value) or (Value < cGammaMin) or (Value > cGammaMax) then
    raise EFitsPictureException.CreateFmt(SPicturePropIncorrectValue,
      ['gamma', Value, Frame.FIndexFrame, FFrame.FItem.Index],
      ERROR_PICTURE_TONE_INCORRECT_GAMMA);
  if FGamma <> Value then
  begin
    FGamma := Value;
    FFrame.LazyBandage;
  end;
end;

procedure TFitsPictureTone.SetDefault;
begin
  Self.Brightness := cBrightnessDef;
  Self.Contrast := cContrastDef;
  Self.Gamma := cGammaDef;
end;

{ TFitsPicturePalette }

procedure TFitsPicturePalette.Init;
begin
  inherited;
  FTuples := cPaletteGrayScale;
  FReverse := False;
end;

procedure TFitsPicturePalette.SetTuples(const Value: PPaletteTuples);
begin
  if Value = nil then
    raise EFitsPictureException.CreateFmt(SPicturePaletteInvalidTuples,
      [FFrame.FIndexFrame, FFrame.FItem.Index], ERROR_PICTURE_PALETTE_INVALID_TUPLES);
  FTuples := Value;
end;

procedure TFitsPicturePalette.SetDefault;
begin
  Self.Tuples := cPaletteGrayScale;
  Self.Reverse := False;
end;

procedure TFitsPicturePalette.SetReverse(const Value: Boolean);
begin
  FReverse := Value;
end;

destructor TFitsPicturePalette.Destroy;
begin
  FTuples := nil;
  inherited;
end;

{ TFitsPictureGeometry }

procedure TFitsPictureGeometry.GetSceneDesignPoint(APoint: TDesignPoint; out pX, pY: Double);
var
  R: TRegion;
begin
  R := RectLocalToScene(FFrame.LocalRegion);
  case APoint of
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

procedure TFitsPictureGeometry.GetSceneDesignShift(AShift: TDesignShift; out dX, dY: Double);
var
  R: TRegion;
begin
  R := RectLocalToScene(FFrame.LocalRegion);
  case AShift of
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

procedure TFitsPictureGeometry.Init;
begin
  inherited;
  FMatrixLocal := DeLaFitsMath.CreateMatrix;
  FMatrixScene := DeLaFitsMath.CreateMatrix;
end;

procedure TFitsPictureGeometry.SetDefault;
begin
  Reset;
end;

function TFitsPictureGeometry.Reset: TFitsPictureGeometry;
begin
  FMatrixLocal := DeLaFitsMath.CreateMatrix;
  FMatrixScene := DeLaFitsMath.CreateMatrix;
  Result := Self;
end;

function TFitsPictureGeometry.Multiply(const Matrix: TMatrix): TFitsPictureGeometry;
begin
  try
    FMatrixLocal := DeLaFitsMath.MultiplyMatrix(FMatrixLocal, Matrix);
    FMatrixScene := DeLaFitsMath.InvertMatrix(FMatrixLocal);
    Result := Self;
  except
    Reset;
    raise;
  end;
end;

function TFitsPictureGeometry.Shift(const dX, dY: Double): TFitsPictureGeometry;
var
  M: TMatrix;
begin
  if not (Math.IsZero(dX) and Math.IsZero(dY)) then
  begin
    M := DeLaFitsMath.CreateMatrixShift(dX, dY);
    Multiply(M);
  end;
  Result := Self;
end;

function TFitsPictureGeometry.Shift(const AShift: TDesignShift): TFitsPictureGeometry;
var
  dX, dY: Double;
begin
  GetSceneDesignShift(AShift, dX, dY);
  Result := Shift(dX, dY);
end;

function TFitsPictureGeometry.Scale(const sX, sY, pX, pY: Double): TFitsPictureGeometry;
var
  IsTrn: Boolean;
  M: TMatrix;
begin
  if (not Math.SameValue(sX, 1.0)) or (not Math.SameValue(sY, 1.0)) then
  begin
    IsTrn := not (Math.IsZero(pX) and Math.IsZero(pY));
    if IsTrn then
    begin
      M := DeLaFitsMath.CreateMatrixShift(DeLaFitsMath.Negar(pX), DeLaFitsMath.Negar(pY));
      Multiply(M);
    end;
    M := DeLaFitsMath.CreateMatrixScale(sX, sY);
    Multiply(M);
    if IsTrn then
    begin
      M := DeLaFitsMath.CreateMatrixShift(pX, pY);
      Multiply(M);
    end;
  end;
  Result := Self;
end;

function TFitsPictureGeometry.Scale(const sX, sY: Double; const P: TPnt): TFitsPictureGeometry;
begin
  Result := Scale(sX, sY, P.X, P.Y);
end;

function TFitsPictureGeometry.Scale(const sX, sY: Double; const P: TDesignPoint): TFitsPictureGeometry;
var
  pX, pY: Double;
begin
  GetSceneDesignPoint(P, pX, pY);
  Result := Scale(sX, sY, pX, pY);
end;

function TFitsPictureGeometry.Rotate(const Angle, pX, pY: Double): TFitsPictureGeometry;
var
  IsTrn: Boolean;
  M: TMatrix;
begin
  if not Math.IsZero(Angle) then
  begin
    IsTrn := not (Math.IsZero(pX) and Math.IsZero(pY));
    if IsTrn then
    begin
      M := DeLaFitsMath.CreateMatrixShift(DeLaFitsMath.Negar(pX), DeLaFitsMath.Negar(pY));
      Multiply(M);
    end;
    M := CreateMatrixRotate(Angle);
    Multiply(M);
    if IsTrn then
    begin
      M := CreateMatrixShift(pX, pY);
      Multiply(M);
    end;
  end;
  Result := Self;
end;

function TFitsPictureGeometry.Rotate(const Angle: Double; const P: TPnt): TFitsPictureGeometry;
begin
  Result := Rotate(Angle, P.X, P.Y);
end;

function TFitsPictureGeometry.Rotate(const Angle: Double; const P: TDesignPoint): TFitsPictureGeometry;
var
  pX, pY: Double;
begin
  GetSceneDesignPoint(P, pX, pY);
  Result := Rotate(Angle, pX, pY);
end;

function TFitsPictureGeometry.ShearX(const Angle: Double): TFitsPictureGeometry;
var
  M: TMatrix;
begin
  if not Math.IsZero(Angle) then
  begin
    M := CreateMatrixShearX(Angle);
    Multiply(M);
  end;
  Result := Self;
end;

function TFitsPictureGeometry.ShearY(const Angle: Double): TFitsPictureGeometry;
var
  M: TMatrix;
begin
  if not Math.IsZero(Angle) then
  begin
    M := CreateMatrixShearY(Angle);
    Multiply(M);
  end;
  Result := Self;
end;

function TFitsPictureGeometry.PntSceneToLocal(const PntScn: TPnt): TPnt;
begin
  Result := DeLaFitsMath.MapPnt(FMatrixScene, PntScn);
end;

function TFitsPictureGeometry.PntLocalToScene(const PntLoc: TPnt): TPnt;
begin
  Result := DeLaFitsMath.MapPnt(FMatrixLocal, PntLoc);
end;

function TFitsPictureGeometry.PixSceneToLocal(const PixScn: TPix): TPix;
begin
  Result := DeLaFitsMath.MapPix(FMatrixScene, PixScn);
end;

function TFitsPictureGeometry.PixLocalToScene(const PixLoc: TPix): TPix;
begin
  Result := DeLaFitsMath.MapPix(FMatrixLocal, PixLoc);
end;

function TFitsPictureGeometry.QuadSceneToLocal(const RgnScn: TRegion): TQuad;
begin
  // P1----P2
  //  |    |
  // P4----P3
  with RgnScn do
  begin
    Result.P1 := PntSceneToLocal(ToPnt(X1, Y1));
    Result.P2 := PntSceneToLocal(ToPnt(X1 + Width, Y1));
    Result.P3 := PntSceneToLocal(ToPnt(X1 + Width, Y1 + Height));
    Result.P4 := PntSceneToLocal(ToPnt(X1, Y1 + Height));
  end;
  Result := DeLaFitsMath.NormQuad(Result);
end;

function TFitsPictureGeometry.QuadLocalToScene(const RgnLoc: TRegion): TQuad;
begin
  // P1----P2
  //  |    |
  // P4----P3
  with RgnLoc do
  begin
    Result.P1 := PntLocalToScene(ToPnt(X1, Y1));
    Result.P2 := PntLocalToScene(ToPnt(X1 + Width, Y1));
    Result.P3 := PntLocalToScene(ToPnt(X1 + Width, Y1 + Height));
    Result.P4 := PntLocalToScene(ToPnt(X1, Y1 + Height));
  end;
  Result := DeLaFitsMath.NormQuad(Result);
end;

function TFitsPictureGeometry.RectSceneToLocal(const RgnScn: TRegion): TRegion;
var
  Quad: TQuad;
begin
  Quad := QuadSceneToLocal(RgnScn);
  Result := DeLaFitsMath.RectQuad(Quad);
end;

function TFitsPictureGeometry.RectLocalToScene(const RgnLoc: TRegion): TRegion;
var
  Quad: TQuad;
begin
  Quad := QuadLocalToScene(RgnLoc);
  Result := DeLaFitsMath.RectQuad(Quad);
end;

function TFitsPictureGeometry.ClipRegionToLocal(const WndScn: TRegion): TClip;
var
  Wnd: TQuad;
  Quad: TQuad;
begin
  Wnd := QuadSceneToLocal(WndScn);
  Quad := ToQuad(FFrame.LocalRegion);
  DeLaFitsMath.QClip(Wnd, Quad, Result);
end;

function TFitsPictureGeometry.ClipRegionToScene(const WndScn: TRegion): TClip;
var
  Wnd: TRegion;
  Quad: TQuad;
begin
  Wnd := WndScn;
  Quad := QuadLocalToScene(FFrame.LocalRegion);
  DeLaFitsMath.QClip(Wnd, Quad, Result);
end;

{ TFitsManagerPixmap }

{$IFDEF DELA_MEMORY_SHARED}
var
  vPixmap: TPixmap;
{$ENDIF}

function TFitsManagerPixmap.NeedRealloc(const APixmap: TPixmap; const NewWidth, NewHeight: Integer): Boolean;
var
  Width, Height: Integer;
begin
  Width := Length(APixmap.Pix);
  if Width = 0 then
    Height := 0
  else
    Height := Length(APixmap.Pix[0]);
  Result := (Width < NewWidth) or (Height < NewHeight);
end;

procedure TFitsManagerPixmap.Realloc(var APixmap: TPixmap; const NewWidth, NewHeight: Integer);
begin
  SetLength(APixmap.Pix, NewWidth, NewHeight);
end;

class function TFitsManagerPixmap.NewPixmap: TPixmap;
begin
  Result.Pix := nil;
  Result.Map := DeLaFitsPalette.cPalGrayScale;
end;

constructor TFitsManagerPixmap.Create;
begin
  inherited;
  {$IFDEF DELA_MEMORY_PRIVATE}
  FPixmap := InitPixmap;
  {$ENDIF}
end;

destructor TFitsManagerPixmap.Destroy;
begin
  {$IFDEF DELA_MEMORY_PRIVATE}
  FPixmap.Pix := nil;
  {$ENDIF}
  inherited;
end;

procedure TFitsManagerPixmap.Allocate(var APixmap: TPixmap; const AWidth, AHeight: Integer);
begin

  // pix

  {$IF DEFINED(DELA_MEMORY_SHARED)}

  if NeedRealloc(vPixmap, AWidth, AHeight) then
    Realloc(vPixmap, AWidth, AHeight);
  APixmap.Pix := vPixmap.Pix;

  {$ELSEIF DEFINED(DELA_MEMORY_PRIVATE)}

  if NeedRealloc(FPixmap, AWidth, AHeight) then
    Realloc(FPixmap, AWidth, AHeight);
  APixmap.Pix := FPixmap.Pix;

  {$ELSEIF DEFINED(DELA_MEMORY_TEMP)}

  Realloc(APixmap, AWidth, AHeight);

  {$IFEND}

  // map

  APixmap.Map := DeLaFitsPalette.cPalGrayScale;

end;

procedure TFitsManagerPixmap.Release(var APixmap: TPixmap);
begin
  APixmap.Pix := nil;
end;

procedure TFitsManagerPixmap.Reset;
begin
  {$IF DEFINED(DELA_MEMORY_SHARED)}
  vPixmap.Pix := nil;
  {$ELSEIF DEFINED(DELA_MEMORY_PRIVATE)}
  FPixmap.Pix := nil;
  {$ELSEIF DEFINED(DELA_MEMORY_TEMP)}
  {$IFEND}
end;

{ TFitsPictureFrame }

procedure TFitsPictureFrame.Init;
var
  I: Integer;
begin
  FPixmap     := nil;
  FItem       := nil;
  FIndexFrame := -1;
  FHistogram  := nil;
  FTone       := nil;
  FPalette    := nil;
  FGeometry   := nil;
  for I := 0 to cFrameBandCount - 1 do
    FBand[I] := 0.0;
  FBandaged := False;
end;

procedure TFitsPictureFrame.Bind(AItem: TFitsPicture; AIndexFrame: Integer);
begin
  if not Assigned(AItem) then
    raise EFitsPictureException.Create(SItemNotAssign, ERROR_PICTURE_FRAME_BIND_ASSIGN);
  if not AItem.FInspect then
    raise EFitsPictureException.Create(SBindNoInspect, ERROR_PICTURE_FRAME_BIND_INSPECT);
  if AIndexFrame < 0 then
    raise EFitsPictureException.CreateFmt(SPictureFrameInvalidBind, [AIndexFrame], ERROR_PICTURE_FRAME_BIND_INDEX);
  FItem := AItem;
  FIndexFrame := AIndexFrame;
end;

function TFitsPictureFrame.GetIndexElems: Int64;
begin
  Result := Int64(FIndexFrame) * Item.Naxes[1] * Item.Naxes[2];
end;

function TFitsPictureFrame.GetCountElems: Int64;
begin
  Result := Int64(Item.Naxes[1]) * Item.Naxes[2];
end;

procedure TFitsPictureFrame.Bandage;
var
  H1, H2, R1, R2, B, B1, B2: Integer;
  Step: Double;

  function GetBucketsElem(const AIndex: Double): Extended;
  var
    Index: Integer;
  begin
    // get the integer index of bucket: Trunc(+0.9) = 0, Trunc(-0.9) = -1
    Index := Integer(System.Trunc(AIndex));
    if (Index = 0) and (AIndex < 0) then
      Index := -1;
    // get the value of bucket.elem
    Index := Math.EnsureRange(Index, R1, R2);
    if Index < H1 then
      Result := Math.NegInfinity
    else if Index > H2 then
      Result := Math.Infinity
    else
      Result := FHistogram.FBuckets[Index]^.Elem;
  end;

var
  T: Integer;
  index, br, co, ga: Double;
  Tweak: TFrameBand;

begin
  if FBandaged then
    Exit;

  // define the band by histogram

  H1 := 0;
  H2 := FHistogram.Count - 1;
  R1 := FHistogram.IndexRange.Black;
  R2 := FHistogram.IndexRange.White;
  B1 := 0;
  B2 := cFrameBandCount - 1;
  Step := (R2 - R1 + 1) / (B2 - B1 + 1); // ~ (count dynamic range) / (count band)
  FBand[B1] := GetBucketsElem(R1);
  FBand[B2] := GetBucketsElem(R2);
  for B := B1 + 1 to B2 - 1 do
    FBand[B] := GetBucketsElem(R1 + B * Step);
  FBand[B1] := Math.Min(FBand[B1], FBand[B1 + 1]);
  FBand[B2] := Math.Max(FBand[B2], FBand[B2 - 1]);

  // tweak the band by tone:
  // IndexTweak = co * (IndexBand ^ ga - 0.5) + 0.5 + br =>
  // IndexBand  = ((IndexTweak + 0.5 * (co - 1) - br) / co) ^ (1 / ga)

  br := FTone.Brightness;
  co := Math.Max(FTone.Contrast, 0.01);
  ga := Math.Max(FTone.Gamma, 0.01);
  for T := 0 to cFrameBandCount - 1 do
  begin
    index := T / (cFrameBandCount - 1); // norm to 1
    index := index + 0.5 * (co - 1) - br;
    if index >= 0 then
    begin
      index := index / co;
      index := Math.Power(index, 1 / ga);
      index := index * (cFrameBandCount - 1); // denorm to cFrameBandCount
      B := Round32c(index);
    end
    else
    begin
      B := -1;
    end;
    if B < 0 then
      Tweak[T] := Math.NegInfinity
    else if B >= cFrameBandCount then
      Tweak[T] := Math.Infinity
   else
      Tweak[T] := FBand[B];
  end;
  for B := 0 to cFrameBandCount - 1 do
    FBand[B] := Tweak[B];

  // fixed the fact of bandage

  FBandaged := True;
end;

procedure TFitsPictureFrame.LazyBandage;
begin
  // lazy bandage
  FBandaged := False;
end;

function TFitsPictureFrame.GetBand: TFrameBand;
begin
  Bandage;
  Result := FBand;
end;

procedure TFitsPictureFrame.SetBand(const Value: TFrameBand);
var
  I: Integer;
begin
  for I := Low(Value) to High(Value) do
    FBand[I] := UnNan64f(Value[I]);
  FBandaged := True;
end;

function TFitsPictureFrame.GetLocalRegion: TRegion;
begin
  Result.X1     := 0;
  Result.Y1     := 0;
  Result.Width  := Self.LocalWidth;
  Result.Height := Self.LocalHeight;
end;

function TFitsPictureFrame.GetLocalWidth: Integer;
begin
  Result := Item.Naxes[1];
end;

function TFitsPictureFrame.GetLocalHeight: Integer;
begin
  Result := Item.Naxes[2];
end;

function TFitsPictureFrame.GetLocalPixel(X, Y: Integer): Extended;
var
  Index: Int64;
begin
  Index := Self.IndexElems + Int64(Y) * Self.LocalWidth + X;
  Result := Item.Data.Elems[Index];
end;

procedure TFitsPictureFrame.SetLocalPixel(X, Y: Integer; const Value: Extended);
var
  Index: Int64;
begin
  Index := Self.IndexElems + Int64(Y) * Self.LocalWidth + X;
  Item.Data.Elems[Index] := Value;
end;

function TFitsPictureFrame.GetSceneRegion: TRegion;
begin
  Result := FGeometry.RectLocalToScene(LocalRegion);
end;

function TFitsPictureFrame.GetSceneWidth: Integer;
begin
  Result := SceneRegion.Width;
end;

function TFitsPictureFrame.GetSceneHeight: Integer;
begin
  Result := SceneRegion.Height;
end;

function TFitsPictureFrame.GetScenePixel(X, Y: Integer): Extended;
var
  P: TPix;
begin
  P := ToPix(X, Y);
  P := FGeometry.PixSceneToLocal(P);
  if DeLaFitsMath.InRegion(LocalRegion, P.X, P.Y) then
    Result := LocalPixels[P.X, P.Y]
  else
    Result := Math.NaN;
end;

constructor TFitsPictureFrame.Create(AItem: TFitsPicture; AIndexFrame: Integer);
begin
  inherited Create;
  Init;
  FPixmap    := TFitsManagerPixmap.Create;
  Bind(AItem, AIndexFrame);
  FHistogram := TFitsPictureHistogram.Create(Self);
  FTone      := TFitsPictureTone.Create(Self);
  FPalette   := TFitsPicturePalette.Create(Self);
  FGeometry  := TFitsPictureGeometry.Create(Self);
end;

procedure TFitsPictureFrame.BeforeDestruction;
begin
  if not FItem.FInspect then
    raise EFitsPictureException.CreateFmt(SFreeNoInspect, [FItem.Index], ERROR_PICTURE_FRAME_FREE_INSPECT);
  inherited;
end;

destructor TFitsPictureFrame.Destroy;
begin
  if Assigned(FHistogram) then
  begin
    FHistogram.Free;
    FHistogram := nil;
  end;
  if Assigned(FTone) then
  begin
    FTone.Free;
    FTone := nil;
  end;
  if Assigned(FPalette) then
  begin
    FPalette.Free;
    FPalette := nil;
  end;
  if Assigned(FGeometry) then
  begin
    FGeometry.Free;
    FGeometry := nil;
  end;
  FItem := nil;
  if Assigned(FPixmap) then
  begin
    FPixmap.Free;
    FPixmap := nil;
  end;
  inherited;
end;

procedure TFitsPictureFrame.Drop;
begin
  FItem.FFrames.DropFrame(Self);
end;

procedure TFitsPictureFrame.Remap;
begin
  FHistogram.Remap;
end;

procedure TFitsPictureFrame.AllowRender(const ASceneRegion: TRegion; const APix: TPaletteIndexs);
begin
  if (ASceneRegion.Width <= 0) or (ASceneRegion.Height <= 0) then
    raise EFitsPictureException.CreateFmt(SPictureFrameIncorrectScene,
      [FIndexFrame, FItem.Index], ERROR_PICTURE_FRAME_INCORRECT_SCENE);
  if Length(APix) < ASceneRegion.Width then
    raise EFitsPictureException.CreateFmt(SPictureFrameIncorrectPixmap,
      [FIndexFrame, FItem.Index], ERROR_PICTURE_FRAME_INCORRECT_PIXMAP);
  if Length(APix[0]) < ASceneRegion.Height then
    raise EFitsPictureException.CreateFmt(SPictureFrameIncorrectPixmap,
      [FIndexFrame, FItem.Index], ERROR_PICTURE_FRAME_INCORRECT_PIXMAP);
end;

procedure TFitsPictureFrame.RenderMap(var AMap: TPaletteTuples);
var
  I, Imin, Imax: Integer;
begin
  Imin := Low(AMap);
  Imax := High(AMap);
  case FPalette.Reverse of
    True:
      for I := Imin to Imax do
        AMap[Imax - I] := FPalette.Tuples^[I];
    False:
      for I := Imin to Imax do
        AMap[I] := FPalette.Tuples^[I];
  end;
end;

procedure TFitsPictureFrame.RenderOff(const ASceneRegion: TRegion; var APix: TPaletteIndexs);
const
  cPixOff = 0;
var
  X, Y: Integer;
begin
  for X := 0 to ASceneRegion.Width - 1 do
  for Y := 0 to ASceneRegion.Height - 1 do
    APix[X, Y] := cPixOff;
end;

function TFitsPictureFrame.BoundRender(const ASceneRegion: TRegion; out ALocalBound, ASceneBound: TBound): Boolean;
var
  I: Integer;
  Pnt: TPnt;
  Clip: TClip;
  CXmin, CXmax, CYmin, CYmax: Double;
  LocalRealRegion: TRegion;
begin
  Clip := FGeometry.ClipRegionToLocal(ASceneRegion);
  Result := Clip.PN > 0;
  if not Result then
  begin
    ALocalBound.Xcount := 0;
    ASceneBound.Xcount := 0;
    Exit;
  end;
  CXmin := Clip.X1;
  CXmax := Clip.X1;
  CYmin := Clip.Y1;
  CYmax := Clip.Y1;
  for I := 2 to Clip.PN do
  begin
    Pnt := Clip.PA[I];
    if CXmin > Pnt.X then CXmin := Pnt.X;
    if CXmax < Pnt.X then CXmax := Pnt.X;
    if CYmin > Pnt.Y then CYmin := Pnt.Y;
    if CYmax < Pnt.Y then CYmax := Pnt.Y;
  end;
  LocalRealRegion := Self.LocalRegion;
  with ALocalBound do
  begin
    Xmin := Math.EnsureRange(Integer(Trunc(CXmin)) - 1, LocalRealRegion.X1, LocalRealRegion.Width - 1);
    Xmax := Math.EnsureRange(Integer(Trunc(CXmax)) + 1, LocalRealRegion.X1, LocalRealRegion.Width - 1);
    Ymin := Math.EnsureRange(Integer(Trunc(CYmin)) - 1, LocalRealRegion.Y1, LocalRealRegion.Height - 1);
    Ymax := Math.EnsureRange(Integer(Trunc(CYmax)) + 1, LocalRealRegion.Y1, LocalRealRegion.Height - 1);
    Xcount := Xmax - Xmin + 1;
    Ycount := Ymax - Ymin + 1;
  end;
  ASceneBound := ToBound(ASceneRegion);
end;

function TFitsPictureFrame.RenderPix(const ALocalPoint: TPnt; const ALocalBound: TBound; const ALocalRow1, ALocalRow2: TA64f): Byte;
var
  I, I1, I2: Integer;
  X1, X2, Y1, Y2: Integer;
  X, Y: Double;
  V, V1, V2, V3, V4: Double;
  A, A1, A2, A3, A4: Double;
begin

  X := ALocalPoint.X;
  Y := ALocalPoint.Y;

  X1 := Trunc(X);
  Y1 := Trunc(Y);
  X2 := X1 + 1;
  Y2 := Y1 + 1;

  V1 := ALocalRow1[X1 - ALocalBound.Xmin];
  V2 := ALocalRow1[Math.IfThen(X2 <= ALocalBound.Xmax, X2, ALocalBound.Xmax) - ALocalBound.Xmin];
  V3 := ALocalRow2[X1 - ALocalBound.Xmin];
  V4 := ALocalRow2[Math.IfThen(X2 <= ALocalBound.Xmax, X2, ALocalBound.Xmax) - ALocalBound.Xmin];

  if Math.IsInfinite(V1) or Math.IsInfinite(V2) or Math.IsInfinite(V3) or Math.IsInfinite(V4) then
  begin
    // nearest neighbour
    A1 := Sqrt(Sqr(X1 - X) + Sqr(Y1 - X));
    A2 := Sqrt(Sqr(X2 - X) + Sqr(Y1 - X));
    A3 := Sqrt(Sqr(X1 - X) + Sqr(Y2 - X));
    A4 := Sqrt(Sqr(X2 - X) + Sqr(Y2 - X));
    V := V1;
    A := A1;
    if A > A2 then
    begin
      V := V2;
      A := A2;
    end;
    if A > A3 then
    begin
      V := V3;
      A := A3;
    end;
    if A > A4 then
      V := V4;
  end
  else
  begin
    // bilinear interpolation
    A1 := (X2 - X) * (Y2 - Y);
    A2 := (X - X1) * (Y2 - Y);
    A3 := (X2 - X) * (Y - Y1);
    A4 := (X - X1) * (Y - Y1);
    V := V1 * A1 + V2 * A2 + V3 * A3 + V4 * A4;
  end;

  {$IFDEF DELA_ROUND_RENDER}
  if not Math.IsInfinite(V) then
    V := DeLaFitsMath.Roundar(V);
  {$ENDIF}

  Result := 0;

  I1 := 0;
  I2 := cFrameBandCount - 1;
  I  := cFrameBandCount div 2;
  while I > 0 do
  begin
    if (V = FBand[I]) then
    begin
      Result := I;
      Break;
    end;
    if (I2 <= I1) then
    begin
      Result := I1;
      Break;
    end;
    if V < FBand[I] then
      I2 := I - 1
    else
      I1 := I + 1;
    I := (I1 + I2) div 2;
  end;

end;

// Render Math: check if the point is on the line segment

function InSegment(const SegY, SegX1, SegX2: Integer; const Pnt: TPnt): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := (Trunc(Pnt.Y) = SegY) and (Pnt.X >= SegX1) and (Pnt.X <= SegX2);
end;

// Render Math: return Y-coordinate from a cross of lines (P1, P2) and (x = X)

function XCrossLine(const P1, P2: TPnt; const X: Integer): Double; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ((P1.Y - P2.Y) * X + P1.X * P2.Y - P2.X * P1.Y) / (P1.X - P2.X);
end;

// Render Math: return X-coordinate from a cross of lines (P1, P2) and (y = Y)

function YCrossLine(const P1, P2: TPnt; const Y: Integer): Double; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ((P2.X - P1.X) * Y + P1.X * P2.Y - P2.X * P1.Y) / (P2.Y - P1.Y);
end;

procedure TFitsPictureFrame.RenderScene(var APixmap: TPixmap; const ASceneRegion: TRegion);
var
  LocW, LocY, I, ScnX, ScnY, ScnXX, ScnYY, ScnXXmin, ScnXXmax, ScnYYmax: Integer;
  LocBnd, ScnBnd: TBound;
  IndElems: Int64;
  LocRow1, LocRow2: TA64f;
  LocHash: array of Boolean;
  A1, A2, B1, B2, Pnt: TPnt;
  Loop: Boolean;
  V1, V2, V3, V4, Vmin, Vmax: Double;
begin

  // check arguments

  AllowRender(ASceneRegion, APixmap.Pix);

  // render a map by palette

  RenderMap(APixmap.Map);

  // clear pix: set all pixels as if outside the real frame region

  RenderOff(ASceneRegion, APixmap.Pix);

  // get a bound of render clip: (specified scene) * (real local)

  if not BoundRender(ASceneRegion, LocBnd, ScnBnd) then
    Exit;

  // actualize a band

  Bandage;

  try

    // prepare a buffer for local rows

    LocRow1 := nil;
    LocRow2 := nil;
    SetLength(LocRow1, LocBnd.Xcount);
    SetLength(LocRow2, LocBnd.Xcount);

    // prepare a hash (already processed rows) for local rows

    LocHash := nil;
    SetLength(LocHash, LocBnd.Ycount);
    for LocY := 0 to LocBnd.Ycount - 1 do
      LocHash[LocY] := False;

    // cache the index elements for a frame

    IndElems := Self.IndexElems;

    // cache the real local width

    LocW := Self.LocalWidth;

    // loop on a scene pixels, see "resource/renderscene.png" for details

    for ScnY := ScnBnd.Ymin to ScnBnd.Ymax do
    for ScnX := ScnBnd.Xmin to ScnBnd.Xmax do
    begin

      // get local point

      Pnt := FGeometry.PntSceneToLocal(ToPnt(ScnX, ScnY));

      // check if the local point is on the local bound

      if not DeLaFitsMath.InBound(LocBnd, Pnt.X, Pnt.Y) then
        Continue;

      LocY := Trunc(Pnt.Y);

      // hash the fact of processing a local row

      if LocHash[LocY - LocBnd.Ymin] then
        Continue;
      LocHash[LocY - LocBnd.Ymin] := True;

      // read data a local row fragment

      Item.Data.ReadElems(IndElems + Int64(LocW) * LocY + LocBnd.Xmin, LocBnd.Xcount, LocRow1);
      Item.Data.ReadElems(IndElems + Int64(LocW) * Math.Min(LocY + 1, LocBnd.Ymax) + LocBnd.Xmin, LocBnd.Xcount, LocRow2);
      for I := 0 to LocBnd.Xcount - 1 do
      begin
        LocRow1[I] := UnNan64f(LocRow1[I]);
        LocRow2[I] := UnNan64f(LocRow2[I]);
      end;

      // local points to define the orientation of the local coordinates system relative to the scene coordinates system

      A1 := ToPnt(-1.0, LocY + 0);
      A2 := ToPnt(LocW, LocY + 0);
      B1 := ToPnt(-1.0, LocY + 1);
      B2 := ToPnt(LocW, LocY + 1);

      A1 := Geometry.PntLocalToScene(A1);
      A2 := Geometry.PntLocalToScene(A2);
      B1 := Geometry.PntLocalToScene(B1);
      B2 := Geometry.PntLocalToScene(B2);

      // nested loop by a LocY row: Y-axis local parallel a Y-axis scene

      if Math.IsZero(A2.Y - A1.Y) or Math.IsZero(B2.Y - B1.Y) then
      begin
        ScnYY := ScnY;
        while (ScnYY <= ScnBnd.Ymax) do
        begin
          Loop := False;
          ScnXX := ScnX;
          while (ScnXX <= ScnBnd.Xmax) do
          begin
            Pnt := Geometry.PntSceneToLocal(ToPnt(ScnXX, ScnYY));
            if not InSegment(LocY, LocBnd.Xmin, LocBnd.Xmax, Pnt) then
              Break;
            APixmap.Pix[ScnXX - ScnBnd.Xmin, ScnYY - ScnBnd.Ymin] := RenderPix(Pnt, LocBnd, LocRow1, LocRow2);
            Loop := True;
            Inc(ScnXX);
          end;
          if not Loop then
            Break;
          Inc(ScnYY);
        end;
      end

      // nested loop by a LocY row: Y-axis local ortogonal a Y-axis scene

      else if Math.IsZero(A2.X - A1.X) or Math.IsZero(B2.X - B1.X) then
      begin
        ScnXX := ScnX;
        while (ScnXX <= ScnBnd.Xmax) do
        begin
          Loop := False;
          ScnYY := ScnY;
          while (ScnYY <= ScnBnd.Ymax) do
          begin
            Pnt := Geometry.PntSceneToLocal(ToPnt(ScnXX, ScnYY));
            if not InSegment(LocY, LocBnd.Xmin, LocBnd.Xmax, Pnt) then
              Break;
            APixmap.Pix[ScnXX - ScnBnd.Xmin, ScnYY - ScnBnd.Ymin] := RenderPix(Pnt, LocBnd, LocRow1, LocRow2);
            Loop := True;
            Inc(ScnYY);
          end;
          if not Loop then
            Break;
          Inc(ScnXX);
        end;
      end

      // nested loop by a LocY row: Y-axis local tilted a Y-axis scene

      else
      begin
        // correct the nested loop range
        V1 := XCrossLine(A1, A2, (ScnBnd.Xmin - 1));
        V2 := XCrossLine(A1, A2, (ScnBnd.Xmax + 1));
        V3 := XCrossLine(B1, B2, (ScnBnd.Xmin - 1));
        V4 := XCrossLine(B1, B2, (ScnBnd.Xmax + 1));
        // correct ScnBnd.Ymax
        Vmax := Math.MaxValue([V1, V2, V3, V4]) + 1.0;
        ScnYYmax := Math.IfThen(Vmax > ScnBnd.Ymax, ScnBnd.Ymax, Trunc(Vmax));
        ScnYY := ScnY;
        while (ScnYY <= ScnYYmax) do
        begin
          V1 := YCrossLine(A1, A2, (ScnYY - 1));
          V2 := YCrossLine(A1, A2, (ScnYY + 1));
          V3 := YCrossLine(B1, B2, (ScnYY - 1));
          V4 := YCrossLine(B1, B2, (ScnYY + 1));
          // correct ScnBnd.Xmin
          Vmin := Math.MinValue([V1, V2, V3, V4]) + 0.0;
          if Vmin < ScnBnd.Xmin then
            ScnXXmin := ScnBnd.Xmin
          else if Vmin > ScnBnd.Xmax then
            ScnXXmin := ScnBnd.Xmin
          else
            ScnXXmin := Trunc(Vmin);
          // correct ScnBnd.Xmax
          Vmax := Math.MaxValue([V1, V2, V3, V4]) + 1.0;
          if Vmax > ScnBnd.Xmax then
            ScnXXmax := ScnBnd.Xmax
          else if Vmax < ScnBnd.Xmin then
            ScnXXmax := ScnBnd.Xmax
          else
            ScnXXmax := Trunc(Vmax);
          // nested loop
          for ScnXX := ScnXXmin to ScnXXmax do
          begin
            Pnt := Geometry.PntSceneToLocal(ToPnt(ScnXX, ScnYY));
            if InSegment(LocY, LocBnd.Xmin, LocBnd.Xmax, Pnt) then
              APixmap.Pix[ScnXX - ScnBnd.Xmin, ScnYY - ScnBnd.Ymin] := RenderPix(Pnt, LocBnd, LocRow1, LocRow2);
          end;
          Inc(ScnYY);
        end;
      end;

    end; // loop on a scene pixels

  finally
    LocRow1 := nil;
    LocRow2 := nil;
    LocHash := nil;
  end;

end;

procedure TFitsPictureFrame.SetBitmapFormat(ABitmap: TBitmap);
begin
  {$IFDEF DCC}
  // in delphi support 8, 24 or 32 bit
  if ABitmap.PixelFormat = pf8bit then
    Exit;
  if ABitmap.PixelFormat = pf24bit then
    Exit;
  if ABitmap.PixelFormat = pf32bit then
    Exit;
  {$ENDIF}
  // default
  ABitmap.PixelFormat := pf24bit;
end;

procedure TFitsPictureFrame.SetBitmapSize(ABitmap: TBitmap; const AWidth, AHeight: Integer);
begin
  {$IFDEF FPC}
  ABitmap.SetSize(AWidth, AHeight);
  {$ELSE}
  ABitmap.Width := AWidth;
  ABitmap.Height := AHeight;
  {$ENDIF}
end;

procedure TFitsPictureFrame.SetBitmapPalette(ABitmap: TBitmap; const AMap: TPaletteTuples);
{$IFDEF DCC}
const
  cSizeLogPalette = SizeOf(TLogPalette) + SizeOf(TPaletteEntry) * cPaletteCount;
var
  I: Integer;
  LogPalette: PLogPalette;
{$ENDIF}
begin
  {$IFDEF FPC}
  // palette is not supported in lazarus
  // ... supress hint "parameter XXX not used"
  if Assigned(ABitmap) and (Length(AMap) > 0) then
    ;
  {$ENDIF}
  {$IFDEF DCC}
  if ABitmap.PixelFormat <> pf8bit then
    Exit;
  if ABitmap.Palette <> 0 then
    DeleteObject(ABitmap.Palette);
  GetMem(LogPalette, cSizeLogPalette);
  LogPalette^.palNumEntries := cPaletteCount;
  LogPalette^.palVersion := $300;
  {$R-}
  for I := 0 to cPaletteCount - 1 do
    with LogPalette^.palPalEntry[I], AMap[I] do
    begin
      peRed := R;
      peGreen := G;
      peBlue := B;
      peFlags := PC_NOCOLLAPSE;
    end;
  {$IFDEF HAS_RANGE_CHECK}
    {$R+}
  {$ENDIF}
  ABitmap.Palette := CreatePalette(LogPalette^);
  FreeMem(LogPalette, cSizeLogPalette);
  {$ENDIF}
end;

procedure TFitsPictureFrame.SetBitmapPixels(ABitmap: TBitmap; const AMap: TPaletteTuples;
  const APix: TPaletteIndexs; const AWidth, AHeight: Integer);
type
  TLine24Item = packed record
    iB, iG, iR: Byte;
  end;

  {$IFDEF FPC}
  PLine24Item = ^TLine24Item;
  {$ENDIF}

  {$IFDEF DCC}
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
  I, J: Integer;

  {$IFDEF FPC}
  Line24Item: PLine24Item;
  IncPix, IncRow: Integer;
  {$ENDIF}

  {$IFDEF DCC}
  Line08: PLine08;
  Line24: PLine24;
  Line32: PLine32;
  {$ENDIF}

begin

  {$IFDEF FPC}
  {$R-}
  IncPix := ABitmap.RawImage.Description.BitsPerPixel div 8;
  IncRow := ABitmap.RawImage.Description.BytesPerLine;
  for I := 0 to AHeight - 1 do
  begin;
    Line24Item := PLine24Item(ABitmap.RawImage.Data);
    Inc(PByte(Line24Item), IncRow * I);
    for J := 0 to AWidth - 1 do
    begin
      with Line24Item^, AMap[APix[J, I]] do
      begin
        iB := B;
        iG := G;
        iR := R;
      end;
      Inc(PByte(Line24Item), IncPix);
    end;
  end;
  {$IFDEF HAS_RANGE_CHECK}
    {$R+}
  {$ENDIF}
  {$ENDIF}

  {$IFDEF DCC}
  {$R-}
  case ABitmap.PixelFormat of
    pf8bit:
      for I := 0 to AHeight - 1 do
      begin
        Line08 := ABitmap.ScanLine[I];
        for J := 0 to AWidth - 1 do
          Line08^[J] := APix[J, I];
      end;
    pf24bit:
      for I := 0 to AHeight - 1 do
      begin
        Line24 := ABitmap.ScanLine[I];
        for J := 0 to AWidth - 1 do
          with Line24^[J], AMap[APix[J, I]] do
          begin
            iB := B;
            iG := G;
            iR := R;
          end;
      end;
    pf32bit:
      for I := 0 to AHeight - 1 do
      begin
        Line32 := ABitmap.ScanLine[I];
        for J := 0 to AWidth - 1 do
          with Line32^[J], AMap[APix[J, I]] do
          begin
            iB := B;
            iG := G;
            iR := R;
            iReserved := $00;
          end;
      end;
  end;
  {$IFDEF HAS_RANGE_CHECK}
    {$R+}
  {$ENDIF}
  {$ENDIF}

end;

procedure TFitsPictureFrame.RenderScene(var ABitmap: TBitmap; const ASceneRegion: TRegion);
var
  Pixmap: TPixmap;
begin
  if not Assigned(ABitmap) then
    raise EFitsPictureException.CreateFmt(SPictureFrameIncorrectBitmap,
      [FIndexFrame, FItem.Index], ERROR_PICTURE_FRAME_INCORRECT_BITMAP);

  Pixmap.Pix := nil;
  FPixmap.Allocate(Pixmap, ASceneRegion.Width, ASceneRegion.Height);
  try

    RenderScene(Pixmap, ASceneRegion);

    {$IFDEF FPC}
    try
    ABitmap.BeginUpdate();
    {$ENDIF}

    SetBitmapFormat(ABitmap);

    SetBitmapSize(ABitmap, ASceneRegion.Width, ASceneRegion.Height);

    SetBitmapPalette(ABitmap, Pixmap.Map);

    SetBitmapPixels(ABitmap, Pixmap.Map, Pixmap.Pix, ASceneRegion.Width, ASceneRegion.Height);

    {$IFDEF FPC}
    finally
    ABitmap.EndUpdate();
    end;
    {$ENDIF}

  finally
    FPixmap.Release(Pixmap);
  end;

end;

{ TFitsPictureFrames }

procedure TFitsPictureFrames.Init;
begin
  FItem := nil;
  FFrames := TList.Create;
end;

function TFitsPictureFrames.GetCount: Integer;
var
  Number: Integer;
begin
  Result := 1;
  for Number := 3 to FItem.Naxis do
    Result := Result * FItem.Naxes[Number];
end;

function TFitsPictureFrames.GetFrame(Index: Integer): TFitsPictureFrame;
var
  I: Integer;
  Inspect: Boolean;
begin
  if (Index < 0) or (Index >= Count) then
    raise EFitsPictureException.CreateFmt(SListIndexOutBounds, [Index], ERROR_PICTURE_FRAMES_GETFRAME_INDEX);
  Result := nil;
  for I := 0 to FFrames.Count - 1 do
  begin
    Result := TFitsPictureFrame(FFrames[I]);
    if Result.IndexFrame = Index then
      Break
    else
      Result := nil;
  end;
  if not Assigned(Result) then
  begin
    Inspect := FItem.FInspect;
    try
      FItem.FInspect := True;
      Result := TFitsPictureFrame.Create(FItem, Index);
      FFrames.Add(Result);
    finally
      FItem.FInspect := Inspect;
    end;
  end;
end;

procedure TFitsPictureFrames.Bind(AItem: TFitsPicture);
begin
  if not Assigned(AItem) then
    raise EFitsPictureException.Create(SItemNotAssign, ERROR_PICTURE_FRAMES_BIND_ASSIGN);
  if not AItem.FInspect then
    raise EFitsPictureException.Create(SBindNoInspect, ERROR_PICTURE_FRAMES_BIND_INSPECT);
  FItem := AItem;
end;

constructor TFitsPictureFrames.Create(AItem: TFitsPicture);
begin
  inherited Create;
  Init();
  Bind(AItem);
end;

procedure TFitsPictureFrames.BeforeDestruction;
begin
  if not FItem.FInspect then
    raise EFitsPictureException.CreateFmt(SFreeNoInspect, [FItem.Index], ERROR_PICTURE_FRAMES_FREE_INSPECT);
  inherited;
end;

destructor TFitsPictureFrames.Destroy;
var
  I: Integer;
begin
  if Assigned(FFrames) then
  begin
    for I := 0 to FFrames.Count - 1 do
    begin
      TFitsPictureFrame(FFrames[I]).Free;
      FFrames[I] := nil;
    end;
    FFrames.Clear;
    FFrames.Free;
    FFrames := nil;
  end;
  FItem := nil;
  inherited;
end;

procedure TFitsPictureFrames.DropFrame(AFrame: TFitsPictureFrame);
var
  Index: Integer;
  Inspect: Boolean;
begin
  Inspect := FItem.FInspect;
  try
    FItem.FInspect := True;
    // ! because "FFrames.Remove(AFrame)" requires [dcc64 Hint] unit System.Types
    Index := FFrames.IndexOf(AFrame);
    if Index >= 0 then
      FFrames.Delete(Index);
    AFrame.Free;
  finally
    FItem.FInspect := Inspect;
  end;
end;

procedure TFitsPictureFrames.Drop;
var
  I: Integer;
  Inspect: Boolean;
begin
  Inspect := FItem.FInspect;
  try
    FItem.FInspect := True;
    for I := 0 to FFrames.Count - 1 do
    begin
      TFitsPictureFrame(FFrames[I]).Free;
      FFrames[I] := nil;
    end;
    FFrames.Clear;
  finally
    FItem.FInspect := Inspect;
  end;
end;

procedure TFitsPictureFrames.Remap;
var
  I: Integer;
begin
  for I := 0 to FFrames.Count - 1 do
    TFitsPictureFrame(FFrames[I]).Remap;
end;

{ TFitsPictute }

constructor TFitsPicture.CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean);
begin
  inherited;
  // init
  FInspect := False;
  FFrames := nil;
  // create frames
  try
    FInspect := True;
    FFrames := TFitsPictureFrames.Create(Self);
  finally
    FInspect := False;
  end;
end;

constructor TFitsPicture.CreateNewcomer(AContainer: TFitsContainer;  ASpec: TFitsItemSpec);
var
  Spec: TFitsPictureSpec;
begin
  // set default spec
  if not Assigned(ASpec) then
  begin
    Spec := TFitsPictureSpec.Create;
    try
      inherited CreateNewcomer(AContainer, Spec);
    finally
      Spec.Free;
    end
  end
  // check spec class
  else if not (ASpec is TFitsPictureSpec) then
    raise EFitsPictureException.Create(SPictureSpecInvalid, ERROR_PICTURE_SPEC_INVALID)
  else
    inherited;
  // init
  FInspect := False;
  FFrames := nil;
  // create frames
  try
    FInspect := True;
    FFrames := TFitsPictureFrames.Create(Self);
  finally
    FInspect := False;
  end;
end;

destructor TFitsPicture.Destroy;
begin
  if Assigned(FFrames) then
  begin
    FInspect := True;
    FFrames.Free;
    FFrames := nil;
  end;
  inherited;
end;

function TFitsPicture.GetData: TFitsPictureData;
begin
  Result := inherited Data as TFitsPictureData;
end;

function TFitsPicture.GetDataClass: TFitsItemDataClass;
begin
  Result := TFitsPictureData;
end;

function TFitsPicture.GetHead: TFitsPictureHead;
begin
  Result := inherited Head as TFitsPictureHead;
end;

function TFitsPicture.GetHeadClass: TFitsItemHeadClass;
begin
  Result := TFitsPictureHead;
end;

initialization
  {$IFDEF DELA_MEMORY_SHARED}
  vPixmap := TFitsManagerPixmap.NewPixmap;
  {$ENDIF}

end.
