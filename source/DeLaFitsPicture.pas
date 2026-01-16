{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{    Standard IMAGE extension: frame data rendering    }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsPicture;

{$I DeLaFitsDefine.inc}

interface

uses
{$IFDEF DCC}
  Windows,
{$ENDIF}
  SysUtils, Classes, Math, Graphics, DeLaFitsCommon, DeLaFitsMath,
  DeLaFitsString, DeLaFitsProp, DeLaFitsClasses, DeLaFitsImage,
  DeLaFitsPalette;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_PICTURE                              = 8000;

  ERROR_PICTURESPEC_CHECKITEM_NO_OBJECT      = 8100;
  ERROR_PICTURESPEC_CHECKITEM_OBJECT         = 8101;
  ERROR_PICTURESPEC_SETNAXIS_VALUE           = 8102;

  ERROR_PICTUREHEAD_CUSTOMIZENEW_NAXIS_VALUE = 8200;

  ERROR_PICTUREDATA_GETFRAMEINFO_INDEX       = 8300;
  ERROR_PICTUREDATA_GETFRAMEHANDLE_INDEX     = 8301;

  ERROR_PICTURE_CREATENEW_NO_SPEC            = 8400;
  ERROR_PICTURE_CREATENEW_INVALID_CLASS_SPEC = 8401;
  ERROR_PICTURE_GETNAXIS_VALUE               = 8402;

  ERROR_FRAMESETUP_BIND_NO_SOURCE            = 8500;
  ERROR_FRAMESETUP_ASSIGN_NO_SOURCE          = 8501;
  ERROR_FRAMESETUP_ASSIGN_SAME_SOURCE        = 8502;
  ERROR_FRAMEHISTOGRAM_GETBUCKET_INDEX       = 8503;
  ERROR_FRAMEHISTOGRAM_SETDYNAMICRANGE_VALUE = 8504;
  ERROR_FRAMEHISTOGRAM_SETINDEXBLACK_VALUE   = 8505;
  ERROR_FRAMEHISTOGRAM_SETINDEXWHITE_VALUE   = 8506;
  ERROR_FRAMETONE_SETBRIGHTNESS_VALUE        = 8507;
  ERROR_FRAMETONE_SETCONTRAST_VALUE          = 8508;
  ERROR_FRAMETONE_SETGAMMA_VALUE             = 8509;
  ERROR_FRAMEPALETTE_SETTUPLES_VALUE         = 8510;

  ERROR_FRAME_BIND_NO_SOURCE                 = 8600;
  ERROR_FRAME_BIND_INDEX                     = 8601;
  ERROR_FRAME_ASSIGNSETUP_NO_SOURCE          = 8602;
  ERROR_FRAME_READCHUNK_BOUNDS               = 8603;
  ERROR_FRAME_WRITECHUNK_BOUNDS              = 8604;
  ERROR_FRAME_EXCHANGECHUNK_BOUNDS           = 8605;
  ERROR_FRAME_MOVECHUNK_BOUNDS               = 8606;
  ERROR_FRAME_MOVECHUNK_OFFSET               = 8607;
  ERROR_FRAME_ERASECHUNK_BOUNDS              = 8608;
  ERROR_FRAME_GETVALUE_POSITION              = 8609;
  ERROR_FRAME_SETVALUE_POSITION              = 8610;
  ERROR_FRAME_GETVALUES_BOUNDS               = 8611;
  ERROR_FRAME_SETVALUES_BOUNDS               = 8612;
  ERROR_FRAME_RENDERSCENE_REGION             = 8613;
  ERROR_FRAME_RENDERSCENE_NO_BITMAP          = 8614;

resourcestring

  { The messages of exceptions }

  SPictureNotAssigned                 = 'HDU:PICTURE object not assigned';

  SFrameNotAssigned                   = 'Frame object not assigned';
  SFrameIndexOutBounds                = 'Index "%d" is out of the frame list bounds "COUNT=%d"';
  SFrameContentChunkOutBounds         = 'Chunk "OFFSET=%d;SIZE=%d" is out of bounds of the frame content "SIZE=%d"';
  SFrameContentOffsetOutBounds        = 'Offset "%d" is out of bounds of the frame content "SIZE=%d"';
  SFrameValuesBlockOutBounds          = 'Block "X=%d;Y=%d;COUNT=%d" is out of physical value array bounds of frame "WIDTH=%d;HEIGHT=%d"';
  SFrameValuesPositionOutBounds       = 'Position "X=%d;Y=%d" is out of physical value array bounds of frame "WIDTH=%d;HEIGHT=%d"';
  SFrameInvalidRenderRegion           = 'Invalid render region "X=%d;Y=%d;WIDTH=%d;HEIGHT=%d"';

  SFrameSetupNotAssigned              = 'Frame setup object not assigned';
  SFrameSetupSameObject               = 'Same frame setup object';
  SFrameHistogramBucketIndexOutBounds = 'Index "%d" is out of the histogram bucket list bounds "COUNT=%d"';
  SFrameHistogramInvalidDynamicRange  = 'Invalid histogram dynamic range "INDEXBLACK=%d;INDEXWHITE=%d"';
  SFrameHistogramIncorrectIndexBlack  = 'The index-black "%d" is greater than the index-white "%d" of the histogram dynamic range';
  SFrameHistogramIncorrectIndexWhite  = 'The index-white "%d" is less than the index-black "%d" of the histogram dynamic range';
  SFrameBrightnessOutRange            = 'Brightness "%.4f" is out of range "MIN=%.4f;MAX=%.4f"';
  SFrameContrastOutRange              = 'Contrast "%.4f" is out of range "MIN=%.4f;MAX=%.4f"';
  SFrameGammaOutRange                 = 'Gamma "%.4f" is out of range "MIN=%.4f;MAX=%.4f"';
  SFramePaletteIncorrectTuples        = 'The value of a palette tuple cannot be "NIL"';

  SBitmapNotAssigned                  = 'Bitmap object not assigned';

const

  cPaletteGrayScale: PPaletteTuples = @DeLaFitsPalette.cPalGrayScale;
  cPaletteHot      : PPaletteTuples = @DeLaFitsPalette.cPalHot;
  cPaletteCool     : PPaletteTuples = @DeLaFitsPalette.cPalCool;
  cPaletteBonnet   : PPaletteTuples = @DeLaFitsPalette.cPalBonnet;
  cPaletteJet      : PPaletteTuples = @DeLaFitsPalette.cPalJet;

type

  TFitsPicture = class;
  TFitsFrame   = class;

  { TFitsPictureSpec: specification to create a new PICTURE }

  EFitsPictureSpecException = class(EFitsImageSpecException)
  protected
    function GetTopic: string; override;
  end;

  TFitsPictureSpec = class(TFitsImageSpec)
  private
    function GetFrameWidth: Integer;
    procedure SetFrameWidth(AValue: Integer);
    function GetFrameHeight: Integer;
    procedure SetFrameHeight(AValue: Integer);
    function GetFrameCount: Integer;
    procedure SetFrameCount(AValue: Integer);
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure CheckItem(AItem: TFitsItem); override;
    procedure DoSetNAXIS(AProp: INAXIS); override;
  public
    constructor CreateNew(AValueType: TNumberType; AFrameWidth, AFrameHeight: Integer; AFrameCount: Integer = 1); overload;
    // Synonyms for standard properties
    property FrameWidth: Integer read GetFrameWidth write SetFrameWidth;
    property FrameHeight: Integer read GetFrameHeight write SetFrameHeight;
    property FrameCount: Integer read GetFrameCount write SetFrameCount;
  end;

  { TFitsPictureHead: PICTURE header section }

  EFitsPictureHeadException = class(EFitsImageHeadException)
  protected
    function GetTopic: string; override;
  end;

  TFitsPictureHead = class(TFitsImageHead)
  private
    function GetItem: TFitsPicture;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure CustomizeNew(ASpec: TFitsItemSpec); override;
  public
    property Item: TFitsPicture read GetItem;
  end;

  { TFrameInfo: value type, size and location of the frame in the PICTURE content }

  TFrameInfo = record
    FrameIndex: Integer;
    FrameOffset: Int64;
    Offset: Int64;
    Size: Int64;
    BitPix: TBitPix;
    BScale: Extended;
    BZero: Extended;
    PixelSize: Byte;
    ValueType: TNumberType;
    ValueStart: Int64;
    ValueCount: Int64;
    Width: Integer;
    Height: Integer;
  end;

  { TFrameHandle: frame pointer in the PICTURE content }

  TFrameHandle = record
    FrameIndex: Integer;
    FrameSource: TFitsPicture;
  end;

  { TFitsPictureData: PICTURE data section }

  EFitsPictureDataException = class(EFitsImageDataException)
  protected
    function GetTopic: string; override;
  end;

  TFitsPictureData = class(TFitsImageData)
  private
    function GetItem: TFitsPicture;
    procedure CheckFrameIndex(AIndex: Integer; ACodeError: Integer);
    function GetFrameCount: Integer;
    function GetFrameInfo(AIndex: Integer): TFrameInfo;
    function GetFrameHandle(AIndex: Integer): TFrameHandle;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
  public
    property Item: TFitsPicture read GetItem;
    property FrameCount: Integer read GetFrameCount;
    property FrameInfos[Index: Integer]: TFrameInfo read GetFrameInfo;
    property FrameHandles[Index: Integer]: TFrameHandle read GetFrameHandle;
  end;

  { TFitsPicture: frame set of IMAGE }

  EFitsPictureException = class(EFitsImageException)
  protected
    function GetTopic: string; override;
  end;

  TFitsPicture = class(TFitsImage)
  private
    function GetHead: TFitsPictureHead;
    function GetData: TFitsPictureData;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    function GetHeadClass: TFitsItemHeadClass; override;
    function GetDataClass: TFitsItemDataClass; override;
    procedure DoGetNAXIS(AProp: INAXIS); override;
  public
    constructor CreateNew(AContainer: TFitsContainer; ASpec: TFitsItemSpec); override;
    class function ExtensionTypeIs(AItem: TFitsItem): Boolean; override;
    property Head: TFitsPictureHead read GetHead;
    property Data: TFitsPictureData read GetData;
  end;

  { TFitsFrameSetup [abstract]: frame rendering setting }

  EFitsFrameSetupException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsFrameSetup = class(TFitsObject)
  private
    procedure Bind(AFrame: TFitsFrame);
  protected
    FFrame: TFitsFrame;
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure Change;
  public
    constructor Create(AFrame: TFitsFrame); virtual;
    procedure Assign(ASource: TFitsFrameSetup); virtual;
    procedure Default; virtual; abstract;
    property Frame: TFitsFrame read FFrame;
  end;

  { TFitsFrameHistogram: dynamic range of frame values }

  TFitsFrameHistogram = class(TFitsFrameSetup)
  private
    FDone: Boolean;
    FEqualized: Boolean;
    FBuckets: THistogramBuckets;
    FBucketCount: Integer;
    FValueCount: Integer;
    FIndexModa: Integer;
    FIndexModaSmooth: Integer;
    FIndexMedian: Integer;
    FIndexBlackDefault: Integer;
    FIndexWhiteDefault: Integer;
    FIndexBlack: Integer;
    FIndexWhite: Integer;
    function Make(AForce: Boolean = False): TFitsFrameHistogram;
    procedure Clean(AStart: Integer = 0);
    procedure Reset;
    procedure Equalize;
    procedure Append(const AValue: Extended); {$IFDEF HAS_INLINE} inline; {$ENDIF}
    procedure Build;
    procedure Shrink;
    procedure CalcModa;
    procedure CalcMedian;
    procedure CalcDynamicRange;
    function GetBucket(AIndex: Integer): THistogramBucket;
    function GetBucketCount: Integer;
    function GetValueCount: Integer;
    function GetIndexModa: Integer;
    function GetIndexModaSmooth: Integer;
    function GetIndexMedian: Integer;
    function GetIndexBlackDefault: Integer;
    function GetIndexWhiteDefault: Integer;
    function GetIndexBlack: Integer;
    procedure SetIndexBlack(AValue: Integer);
    function GetIndexWhite: Integer;
    procedure SetIndexWhite(AValue: Integer);
  public
    destructor Destroy; override;
    procedure Assign(ASource: TFitsFrameSetup); override;
    procedure Default; override;
    procedure Update;
    procedure SetDynamicRange(AIndexBlack, AIndexWhite: Integer);
    property Buckets[Index: Integer]: THistogramBucket read GetBucket;
    property BucketCount: Integer read GetBucketCount;
    property ValueCount: Integer read GetValueCount;
    property IndexModa: Integer read GetIndexModa;
    property IndexModaSmooth: Integer read GetIndexModaSmooth;
    property IndexMedian: Integer read GetIndexMedian;
    property IndexBlackDefault: Integer read GetIndexBlackDefault;
    property IndexWhiteDefault: Integer read GetIndexWhiteDefault;
    property IndexBlack: Integer read GetIndexBlack write SetIndexBlack;
    property IndexWhite: Integer read GetIndexWhite write SetIndexWhite;
  end;

  { TFitsFrameTone: brightness, contrast and gamma ratios }

  TFitsFrameTone = class(TFitsFrameSetup)
  private
    FBrightness: Double;
    FContrast: Double;
    FGamma: Double;
    function InRange(const AValue, AMin, AMax: Double): Boolean;
    procedure SetBrightness(const AValue: Double);
    procedure SetContrast(const AValue: Double);
    procedure SetGamma(const AValue: Double);
  protected
    procedure Init; override;
  public
    procedure Assign(ASource: TFitsFrameSetup); override;
    procedure Default; override;
    property Brightness: Double read FBrightness write SetBrightness;
    property Contrast: Double read FContrast write SetContrast;
    property Gamma: Double read FGamma write SetGamma;
  end;

  { TFitsFramePalette: frame color scheme }

  TFitsFramePalette = class(TFitsFrameSetup)
  private
    FTuples: PPaletteTuples;
    FReverse: Boolean;
    procedure SetTuples(AValue: PPaletteTuples);
    procedure SetReverse(AValue: Boolean);
  protected
    procedure Init; override;
  public
    procedure Assign(ASource: TFitsFrameSetup); override;
    procedure Default; override;
    property Tuples: PPaletteTuples read FTuples write SetTuples;
    property Reverse: Boolean read FReverse write SetReverse;
  end;

  { TFitsFrameGeometry: affine transformation of frame geometry }

  TFitsFrameGeometry = class(TFitsFrameSetup)
  private
    FLocalMatrix: TMatrix; // Local point ~> Scene point
    FSceneMatrix: TMatrix; // Scene point ~> Local point
    procedure DecodeSceneVirtualShift(const AShift: TVirtualShift; out ADX, ADY: Double);
    procedure DecodeSceneVirtualPoint(const APoint: TVirtualPoint; out AX, AY: Double);
    function Merge(const AMatrix: TMatrix; const APoint: TPlanePoint): TFitsFrameGeometry;
  protected
    procedure Init; override;
  public
    procedure Assign(ASource: TFitsFrameSetup); override;
    procedure Default; override;
    // Affine transformation of the Local Coordinate System: input parameters
    // (shift and point values) must be specified in the Scene Coordinate System
    function Reset: TFitsFrameGeometry;
    function Append(const AMatrix: TMatrix): TFitsFrameGeometry;
    function Shift(const ADX, ADY: Double): TFitsFrameGeometry; overload;
    function Shift(const AShift: TVirtualShift): TFitsFrameGeometry; overload;
    function Scale(const ASX, ASY: Double; const APoint: TPlanePoint): TFitsFrameGeometry; overload;
    function Scale(const ASX, ASY: Double; const APoint: TVirtualPoint): TFitsFrameGeometry; overload;
    function Rotate(const AAngle: Double; const APoint: TPlanePoint): TFitsFrameGeometry; overload;
    function Rotate(const AAngle: Double; const APoint: TVirtualPoint): TFitsFrameGeometry; overload;
    function ShearX(const AAngle: Double): TFitsFrameGeometry;
    function ShearY(const AAngle: Double): TFitsFrameGeometry;
    // Point transformation
    function ScenePointToLocalPoint(const AScenePoint: TPlanePoint): TPlanePoint;
    function LocalPointToScenePoint(const ALocalPoint: TPlanePoint): TPlanePoint;
    // Pixel transformation
    function ScenePixelToLocalPixel(const AScenePixel: TPlanePixel): TPlanePixel;
    function LocalPixelToScenePixel(const ALocalPixel: TPlanePixel): TPlanePixel;
    // Strict region transformation: Region ~> Quad
    function SceneRegionToLocalQuad(const ASceneRegion: TRegion): TQuad;
    function LocalRegionToSceneQuad(const ALocalRegion: TRegion): TQuad;
    // Contour region transformation: Region ~> Region
    function SceneRegionToLocalRegion(const ASceneRegion: TRegion): TRegion;
    function LocalRegionToSceneRegion(const ALocalRegion: TRegion): TRegion;
    // Intersection of scene region and real (full) scene/local region of frame
    function ClipRealLocalRegion(const ASceneRegion: TRegion): TClip;
    function ClipRealSceneRegion(const ASceneRegion: TRegion): TClip;
    property LocalMatrix: TMatrix read FLocalMatrix;
    property SceneMatrix: TMatrix read FSceneMatrix;
  end;

  { TRasterContext [nested]: set of parameters during one call to the rendering routine }

  TRasterContext = record
    SceneBound: TBound;
    SceneOrigin: TPlanePixel;
    LocalBound: TBound;
    LocalOrigin: TPlanePixel;
    LocalRow1: TA80f;
    LocalRow2: TA80f;
    LocalBook: TABol;
  end;

  { TFitsFrame: frame as a concept of a two-dimensional image }

  EFitsFrameException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsFrame = class(TFitsObject)
  private
    FPicture: TFitsPicture;
    FFrameIndex: Integer;
    FBandDone: Boolean;
    FBand: TFrameBand;
    FHistogram: TFitsFrameHistogram;
    FTone: TFitsFrameTone;
    FPalette: TFitsFramePalette;
    FGeometry: TFitsFrameGeometry;
    procedure Bind(const AHandle: TFrameHandle);
    function GetFrameOffset: Int64;
    function GetOffset: Int64;
    function GetSize: Int64;
    function GetBitPix: TBitPix;
    function GetBScale: Extended;
    function GetBZero: Extended;
    function GetPixelSize: Byte;
    function GetValueType: TNumberType;
    function GetValueStart: Int64;
    function GetValueCount: Int64;
    function GetValueIndex(AX, AY: Integer): Int64;
    function GetRegion: TRegion;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetSceneRegion: TRegion;
    function GetSceneWidth: Integer;
    function GetSceneHeight: Integer;
    procedure CheckChunk(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
    procedure CheckValues(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
    function GetValue(AX, AY: Integer): Extended;
    procedure SetValue(AX, AY: Integer; const AValue: Extended);
    procedure GetValues(AX, AY: Integer; const ACount: Int64; var AValues: Pointer; AValuesType: TNumberType);
    procedure SetValues(AX, AY: Integer; const ACount: Int64; const AValues: Pointer; AValuesType: TNumberType);
    function GetSceneValue(AX, AY: Integer): Extended;
    procedure MakeSetup;
    procedure FreeSetup;
    procedure ResetBand;
    procedure MakeBand;
    function BandIndexOf(const AValue: Extended): Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
    procedure RenderPalette(var APalette: TPaletteTuples);
    function FindRasterBound(var AContext: TRasterContext; const ASceneRegion: TRegion): Boolean;
    procedure PrepareRasterBuffer(var AContext: TRasterContext);
    function CaptureRasterOrigin(var AContext: TRasterContext; const AScenePixel: TPlanePixel): Boolean;
    procedure ReadRasterValues(var AContext: TRasterContext);
    function CalcRasterValue(const AContext: TRasterContext; const ALocalPoint: TPlanePoint): Extended; {$IFDEF HAS_INLINE} inline; {$ENDIF}
    function CalcRasterCell(const AContext: TRasterContext; const AScenePixel: TPlanePixel): TPaletteRasterCell; {$IFDEF HAS_INLINE} inline; {$ENDIF}
    procedure SetRasterPixels(const AContext: TRasterContext; var ARaster: TPaletteRaster);
    procedure RenderRaster(const ASceneRegion: TRegion; var ARaster: TPaletteRaster);
    procedure SetBitmapFormat(ABitmap: TBitmap);
    procedure SetBitmapSize(ABitmap: TBitmap; const ASceneRegion: TRegion);
    procedure SetBitmapPalette(ABitmap: TBitmap; const APalette: TPaletteTuples);
    procedure SetBitmapRaster(ABitmap: TBitmap; const APalette: TPaletteTuples; const ARaster: TPaletteRaster);
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure ChangeBand(var ABand: TFrameBand); virtual;
    procedure ChangeSetup(Sender: TFitsFrameSetup); virtual;
  public
    constructor Create(const AHandle: TFrameHandle);
    destructor Destroy; override;
    // [Chunk] Read and write content
    procedure ReadChunk(const AInternalOffset, ASize: Int64; var ABuffer);
    procedure WriteChunk(const AInternalOffset, ASize: Int64; const ABuffer);
    procedure ExchangeChunk(var AInternalOffset1: Int64; const ASize1: Int64; var AInternalOffset2: Int64; const ASize2: Int64);
    procedure MoveChunk(const AInternalOffset, ASize: Int64; var ANewInternalOffset: Int64);
    procedure EraseChunk(const AInternalOffset, ASize: Int64);
    // [Values] Read and write an array of physical values
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA80f); overload;
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA64f); overload;
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA32f); overload;
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA08c); overload;
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA08u); overload;
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA16c); overload;
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA16u); overload;
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA32c); overload;
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA32u); overload;
    procedure ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA64c); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA80f); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA64f); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA32f); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA08c); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA08u); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA16c); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA16u); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA32c); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA32u); overload;
    procedure WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA64c); overload;
    // Render
    procedure AssignSetup(ASource: TFitsFrame);
    procedure DefaultSetup;
    procedure RenderScene(const ASceneRegion: TRegion; var APalette: TPaletteTuples; var ARaster: TPaletteRaster); overload;
    procedure RenderScene(const ASceneRegion: TRegion; var ABitmap: TBitmap); overload;
    // Frame source and values info
    property Picture: TFitsPicture read FPicture;
    property FrameIndex: Integer read FFrameIndex;
    property FrameOffset: Int64 read GetFrameOffset;
    property Offset: Int64 read GetOffset;
    property Size: Int64 read GetSize;
    property BitPix: TBitPix read GetBitPix;
    property BScale: Extended read GetBScale;
    property BZero: Extended read GetBZero;
    property PixelSize: Byte read GetPixelSize;
    property ValueType: TNumberType read GetValueType;
    property ValueStart: Int64 read GetValueStart;
    property ValueCount: Int64 read GetValueCount;
    // Render setup
    property Histogram: TFitsFrameHistogram read FHistogram;
    property Tone: TFitsFrameTone read FTone;
    property Palette: TFitsFramePalette read FPalette;
    property Geometry: TFitsFrameGeometry read FGeometry;
    // Local region: frame size in the PICTURE content
    property Region: TRegion read GetRegion;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property Values[X, Y: Integer]: Extended read GetValue write SetValue;
    // Scene region: frame size and position after affine transformation
    property SceneRegion: TRegion read GetSceneRegion;
    property SceneWidth: Integer read GetSceneWidth;
    property SceneHeight: Integer read GetSceneHeight;
    property SceneValues[X, Y: Integer]: Extended read GetSceneValue;
  end;

implementation

{ Header prop }

function CorrectNAXIS(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
const
  cMinAxis = 2;
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
  case FKeywordNumber of
    1: Result := 'Frame width';
    2: Result := 'Frame height';
  else Result := Format('Number of frames along axis %d', [FKeywordNumber]);
  end;
end;

{ Render raster context }

function CreateRasterContext: TRasterContext; {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  LBoundNaN: TBound;
  LPixelNaN: TPlanePixel;
begin
  LBoundNaN.Xmin := -1;
  LBoundNaN.Ymin := -1;
  LBoundNaN.Xmax := -1;
  LBoundNaN.Ymax := -1;
  LBoundNaN.Xcount := -1;
  LBoundNaN.Ycount := -1;
  LPixelNaN.X := -1;
  LPixelNaN.Y := -1;
  // Result
  Result.SceneBound := LBoundNaN;
  Result.SceneOrigin := LPixelNaN;
  Result.LocalBound := LBoundNaN;
  Result.LocalOrigin := LPixelNaN;
  Result.LocalRow1 := nil;
  Result.LocalRow2 := nil;
  Result.LocalBook := nil;
end;

{ Returns the intersection point of the line (P1,P2) with the perpendicular to the x-axis at point X }

function XIntersection(const P1, P2: TPlanePoint; X: Integer): TPlanePoint; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result.X := X;
  Result.Y := ((P1.Y - P2.Y) * X + P1.X * P2.Y - P2.X * P1.Y) / (P1.X - P2.X);
end;

{ Returns the intersection point of the line (P1,P2) with the perpendicular to the y-axis at point Y }

function YIntersection(const P1, P2: TPlanePoint; Y: Integer): TPlanePoint; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result.X := ((P2.X - P1.X) * Y + P1.X * P2.Y - P2.X * P1.Y) / (P2.Y - P1.Y);
  Result.Y := Y;
end;

{ Check if a non-NaN value is Infinity. This function was introduced to support older versions
  of the "Math" unit, which do not have an "IsInfinitie" function for the Extended type }

function IsExtendedInfinite(const AValue: Extended): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := (AValue = Infinity) or (AValue = NegInfinity);
end;

{ EFitsPictureSpecException }

function EFitsPictureSpecException.GetTopic: string;
begin
  Result := 'PICTURESPEC';
end;

{ TFitsPictureSpec }

function TFitsPictureSpec.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsPictureSpecException;
end;

procedure TFitsPictureSpec.CheckItem(AItem: TFitsItem);
begin
  if not Assigned(AItem) then
    Error(SItemNotAssigned, ERROR_PICTURESPEC_CHECKITEM_NO_OBJECT);
  if not TFitsPicture.ExtensionTypeIs(AItem) then
    Error(SSpecInvalidItem, ERROR_PICTURESPEC_CHECKITEM_OBJECT);
end;

procedure TFitsPictureSpec.DoSetNAXIS(AProp: INAXIS);
begin
  if not CorrectNAXIS(AProp.Value) then
    Error(SSpecIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_PICTURESPEC_SETNAXIS_VALUE);
end;

function TFitsPictureSpec.GetFrameWidth: Integer;
begin
  Result := NAXES[1];
end;

procedure TFitsPictureSpec.SetFrameWidth(AValue: Integer);
begin
  NAXES[1] := AValue;
end;

function TFitsPictureSpec.GetFrameHeight: Integer;
begin
  Result := NAXES[2];
end;

procedure TFitsPictureSpec.SetFrameHeight(AValue: Integer);
begin
  NAXES[2] := AValue;
end;

function TFitsPictureSpec.GetFrameCount: Integer;
var
  LNumber: Integer;
begin
  Result := 1;
  for LNumber := 3 to NAXIS do
    Result := Result * NAXES[LNumber];
end;

procedure TFitsPictureSpec.SetFrameCount(AValue: Integer);
begin
  if AValue < 1 then
    NAXIS := 0 // error
  else if AValue = 1 then
    NAXIS := 2
  else
  begin
    NAXIS := 3;
    NAXES[3] := AValue;
  end;
end;

constructor TFitsPictureSpec.CreateNew(AValueType: TNumberType; AFrameWidth, AFrameHeight: Integer; AFrameCount: Integer);
begin
  case AFrameCount of
    1: inherited CreateNew(AValueType, [AFrameWidth, AFrameHeight]);
  else inherited CreateNew(AValueType, [AFrameWidth, AFrameHeight, AFrameCount]);
  end;
end;

{ EFitsPictureHeadException }

function EFitsPictureHeadException.GetTopic: string;
begin
  Result := 'PICTUREHEAD';
end;

{ TFitsPictureHead }

function TFitsPictureHead.GetItem: TFitsPicture;
begin
  Result := inherited Item as TFitsPicture;
end;

function TFitsPictureHead.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsPictureHeadException;
end;

procedure TFitsPictureHead.CustomizeNew(ASpec: TFitsItemSpec);
var
  LSpec: TFitsImageSpec;
  LLines: string;
  LNAXISIndex, LNumber: Integer;
  LNAXIS: INAXIS;
  LNAXES: INAXES;
begin
  inherited;
  LSpec := ASpec as TFitsPictureSpec;
  // Check NAXIS
  LNAXIS := TFitsNAXIS.CreateValue(LSpec.NAXIS);
  if not CorrectNAXIS(LNAXIS.Value) then
    Error(SPropIncorrectValue, [LNAXIS.Keyword, LNAXIS.PrintValue],
      ERROR_PICTUREHEAD_CUSTOMIZENEW_NAXIS_VALUE);
  LNAXISIndex := LineIndexOfKeyword(LNAXIS.Keyword);
  Assert(LNAXISIndex > 0, SAssertionFailure);
  // Rewrite NAXES
  LLines := '';
  for LNumber := 1 to LNAXIS.Value do
  begin
    LNAXES := TFitsNAXES.CreateValue(LNumber, LSpec.NAXES[LNumber]);
    LLines := LLines + LNAXES.NewLine;
  end;
  WriteLines(LNAXISIndex + 1, LLines);
end;

{ EFitsPictureDataException }

function EFitsPictureDataException.GetTopic: string;
begin
  Result := 'PICTUREDATA';
end;

{ TFitsPictureData }

function TFitsPictureData.GetItem: TFitsPicture;
begin
  Result := inherited Item as TFitsPicture;
end;

procedure TFitsPictureData.CheckFrameIndex(AIndex: Integer; ACodeError: Integer);
var
  LFarmeCount: Integer;
begin
  LFarmeCount := GetFrameCount;
  if not InSegmentBound({ASegmentPosition:} 0, LFarmeCount, AIndex) then
    Error(SFrameIndexOutBounds, [AIndex, LFarmeCount], ACodeError);
end;

function TFitsPictureData.GetFrameCount: Integer;
var
  LNumber: Integer;
begin
  Result := 1;
  for LNumber := 3 to AxesCount do
    Result := Result * AxesLength[LNumber];
end;

function TFitsPictureData.GetFrameInfo(AIndex: Integer): TFrameInfo;
var
  LValueCount, LWidth, LHeight: Integer;
  LPixelSize: Byte;
begin
  CheckFrameIndex(AIndex, ERROR_PICTUREDATA_GETFRAMEINFO_INDEX);
  LWidth := AxesLength[1];
  LHeight := AxesLength[2];
  LValueCount := LWidth * LHeight;
  LPixelSize := PixelSize;
  // Return
  Result.FrameIndex := AIndex;
  Result.FrameOffset := Int64(LValueCount) * LPixelSize * AIndex;
  Result.Offset := Offset + Int64(LValueCount) * LPixelSize * AIndex;
  Result.Size := Int64(LValueCount) * LPixelSize;
  Result.BitPix := BitPix;
  Result.BScale := BScale;
  Result.BZero  := BZero;
  Result.PixelSize := LPixelSize;
  Result.ValueType := ValueType;
  Result.ValueStart := Int64(LValueCount) * AIndex;
  Result.ValueCount := LValueCount;
  Result.Width := LWidth;
  Result.Height := LHeight;
end;

function TFitsPictureData.GetFrameHandle(AIndex: Integer): TFrameHandle;
begin
  CheckFrameIndex(AIndex, ERROR_PICTUREDATA_GETFRAMEHANDLE_INDEX);
  Result.FrameIndex := AIndex;
  Result.FrameSource := Item;
end;

function TFitsPictureData.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsPictureDataException;
end;

{ EFitsPictureException }

function EFitsPictureException.GetTopic: string;
begin
  Result := 'PICTURE';
end;

{ TFitsPicture }

function TFitsPicture.GetHead: TFitsPictureHead;
begin
  Result := inherited Head as TFitsPictureHead;
end;

function TFitsPicture.GetData: TFitsPictureData;
begin
  Result := inherited Data as TFitsPictureData;
end;

function TFitsPicture.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsPictureException;
end;

function TFitsPicture.GetHeadClass: TFitsItemHeadClass;
begin
  Result := TFitsPictureHead;
end;

function TFitsPicture.GetDataClass: TFitsItemDataClass;
begin
  Result := TFitsPictureData;
end;

procedure TFitsPicture.DoGetNAXIS(AProp: INAXIS);
begin
  inherited;
  if not CorrectNAXIS(AProp.Value) then
    Error(SHeadLineValueIncorrect, [AProp.PrintValue],
      ERROR_PICTURE_GETNAXIS_VALUE);
end;

constructor TFitsPicture.CreateNew(AContainer: TFitsContainer; ASpec: TFitsItemSpec);
begin
  if not Assigned(ASpec) then
    Error(SSpecNotAssigned, ERROR_PICTURE_CREATENEW_NO_SPEC);
  if not (ASpec is TFitsPictureSpec) then
    Error(SSpecInvalidClass, [ASpec.ClassName],
      ERROR_PICTURE_CREATENEW_INVALID_CLASS_SPEC);
  inherited CreateNew(AContainer, ASpec);
end;

class function TFitsPicture.ExtensionTypeIs(AItem: TFitsItem): Boolean;
var
  LIndex: Integer;
  LRecord: TLineRecord;
  LNAXIS: Integer;
begin
  Result := inherited ExtensionTypeIs(AItem);
  if Result then
  begin
    LIndex := AItem.Head.LineIndexOfKeyword(cNAXIS);
    if LIndex >= 0 then
    begin
      LRecord := AItem.Head.LineRecords[LIndex];
      Result := TryStringToInteger(LRecord.Value, LNAXIS) and CorrectNAXIS(LNAXIS);
    end else
      Result := False;
  end;
end;

{ EFitsFrameSetupException }

function EFitsFrameSetupException.GetTopic: string;
begin
  Result := 'FRAMESETUP';
end;

{ TFitsFrameSetup }

function TFitsFrameSetup.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsFrameSetupException;
end;

procedure TFitsFrameSetup.Bind(AFrame: TFitsFrame);
begin
  if not Assigned(AFrame) then
    Error(SFrameNotAssigned, ERROR_FRAMESETUP_BIND_NO_SOURCE);
  FFrame := AFrame;
end;

procedure TFitsFrameSetup.Change;
begin
  if Assigned(FFrame) then
    FFrame.ChangeSetup(Self);
end;

constructor TFitsFrameSetup.Create(AFrame: TFitsFrame);
begin
  inherited Create;
  Bind(AFrame);
end;

procedure TFitsFrameSetup.Assign(ASource: TFitsFrameSetup);
begin
  if not Assigned(ASource) then
    Error(SFrameSetupNotAssigned, ERROR_FRAMESETUP_ASSIGN_NO_SOURCE);
  if ASource = Self then
    Error(SFrameSetupSameObject, ERROR_FRAMESETUP_ASSIGN_SAME_SOURCE);
end;

{ TFitsFrameHistogram }

function TFitsFrameHistogram.Make(AForce: Boolean): TFitsFrameHistogram;
begin
  if AForce or (not FDone) then
  begin
    Reset;
    Build;
    Shrink;
    CalcModa;
    CalcMedian;
    CalcDynamicRange;
    FDone := True;
  end;
  Result := Self;
end;

procedure TFitsFrameHistogram.Clean(AStart: Integer);
var
  LIndex: Integer;
  LBucket: PHistogramBucket;
begin
  for LIndex := AStart to High(FBuckets) do
  begin
    LBucket := FBuckets[LIndex];
    Dispose(LBucket);
    FBuckets[LIndex] := nil;
  end;
end;

procedure TFitsFrameHistogram.Reset;
begin
  Clean;
  FDone := False;
  FEqualized := False;
  FBuckets := nil;
  FBucketCount := 0;
  FValueCount := 0;
  FIndexModa := -1;
  FIndexModaSmooth := -1;
  FIndexMedian := -1;
  FIndexBlackDefault := -1;
  FIndexWhiteDefault := -1;
  FIndexBlack := -1;
  FIndexWhite := -1;
end;

procedure TFitsFrameHistogram.Equalize;
var
  I, J, K, N: Integer;
  LBucketCount: Integer;
  LGapValue, LValue1, LValue2: Extended;
  LValues: Extended;
  LFrequencies: Integer;
  LBucket: PHistogramBucket;
begin
  LBucketCount := FBucketCount;
  // Get the average value of the natural buckets interval
  N := 0;
  LGapValue := 0.0;
  for I := 0 to LBucketCount - 2 do
  begin
    LValue1 := FBuckets[I + 0]^.Value;
    LValue2 := FBuckets[I + 1]^.Value;
    if not (IsExtendedInfinite(LValue1) or IsExtendedInfinite(LValue2)) then
    begin
      LGapValue := LGapValue + (LValue2 - LValue1);
      Inc(N);
    end;
  end;
  if N > 0 then
    LGapValue := LGapValue / N;
  // Do equalize
  I := 0;
  K := 0;
  while I < LBucketCount do
  begin
    N := 1;
    LValue1 := FBuckets[I]^.Value;
    if not IsExtendedInfinite(LValue1) then
      for J := I + 1 to LBucketCount - 1 do
      begin
        LValue2 := FBuckets[J]^.Value;
        if IsExtendedInfinite(LValue2) then
          Break;
        if LValue2 - LValue1 > LGapValue then
          Break;
        Inc(N);
      end;
    LBucket := FBuckets[K];
    LValues := 0.0;
    LFrequencies := 0;
    for J := I to I + (N - 1) do
    begin
      LValues := LValues + FBuckets[J]^.Value;
      LFrequencies := LFrequencies + FBuckets[J]^.Frequency;
    end;
    LBucket^.Value := LValues / N;
    LBucket^.Frequency := LFrequencies;
    Inc(K);
    Dec(FBucketCount, N - 1);
    Inc(I, N);
  end;
  // Fix the buckets count
  Clean(FBucketCount);
  // Set the equalize fact
  FEqualized := True;
end;

procedure TFitsFrameHistogram.Append(const AValue: Extended);
var
  LIndex, LIndex1, LIndex2: Integer;
  LBucket: PHistogramBucket;
  LNewBucket: Boolean;
begin
  // Register the value
  Inc(FValueCount);
  // Binary search
  LIndex := 0;
  LIndex1 := 0;
  LIndex2 := FBucketCount - 1;
  LNewBucket := True;
  while LIndex2 >= LIndex1 do
  begin
    LIndex := LIndex1 + (LIndex2 - LIndex1) div 2;
    LBucket := FBuckets[LIndex];
    if AValue < LBucket^.Value then
      LIndex2 := LIndex - 1
    else if AValue = LBucket^.Value then
    begin
      LBucket^.Frequency := LBucket^.Frequency + 1;
      LNewBucket := False;
      Break;
    end else
    // if AValue > LBucket^.Value then
    begin
      LIndex1 := LIndex + 1;
      Inc(LIndex);
    end;
    // ... Math.CompareValue(AValue, LBucket^.Value)
    // may throw an exception for infinity-values
  end;
  // Insert new bucket in position LIndex
  if LNewBucket then
  begin
    New(LBucket);
    LBucket^.Value := AValue;
    LBucket^.Frequency := 1;
    if FBucketCount = Length(FBuckets) then
      SetLength(FBuckets, Min(FBucketCount + cHistogramMaxCount div 10, cHistogramMaxCount));
    if LIndex < FBucketCount then
      System.Move(FBuckets[LIndex], FBuckets[LIndex + 1], (FBucketCount - LIndex) * SizeOf(LBucket));
    FBuckets[LIndex] := LBucket;
    Inc(FBucketCount);
    // Natural equalize: limiting the count bucket
    if FBucketCount = cHistogramMaxCount then
      Equalize;
  end;
end;

procedure TFitsFrameHistogram.Build;

  procedure Append64f(const ABuffer: TBuffer; ACount, AQuota: Integer;
    const ASwapper: TSwapper; const ABScale, ABZero: Extended);
  var
    LBuffer: TA64f;
    LValue: Extended;
    LIndex: Integer;
  begin
    LBuffer := TA64f(ABuffer);
    Shake64f(LBuffer, ACount, AQuota);
    for LIndex := 0 to AQuota - 1 do
    begin
      LValue := ASwapper.Swap64f(LBuffer[LIndex]);
      LValue := UnNan80f(LValue) * ABScale + ABZero;
      Append(LValue);
    end;
  end;

  procedure Append32f(const ABuffer: TBuffer; ACount, AQuota: Integer;
    const ASwapper: TSwapper; const ABScale, ABZero: Extended);
  var
    LBuffer: TA32f;
    LValue: Extended;
    LIndex: Integer;
  begin
    LBuffer := TA32f(ABuffer);
    Shake32f(LBuffer, ACount, AQuota);
    for LIndex := 0 to AQuota - 1 do
    begin
      LValue := ASwapper.Swap32f(LBuffer[LIndex]);
      LValue := UnNan80f(LValue) * ABScale + ABZero;
      Append(LValue);
    end;
  end;

  procedure Append08u(const ABuffer: TBuffer; ACount, AQuota: Integer;
    { const ASwapper: TSwapper; } const ABScale, ABZero: Extended);
  var
    LBuffer: TA08u;
    LValue: Extended;
    LIndex: Integer;
  begin
    LBuffer := TA08u(ABuffer);
    Shake08u(LBuffer, ACount, AQuota);
    for LIndex := 0 to AQuota - 1 do
    begin
      LValue := LBuffer[LIndex];
      LValue := LValue * ABScale + ABZero;
      Append(LValue);
    end;
  end;

  procedure Append16c(const ABuffer: TBuffer; ACount, AQuota: Integer;
    const ASwapper: TSwapper; const ABScale, ABZero: Extended);
  var
    LBuffer: TA16c;
    LValue: Extended;
    LIndex: Integer;
  begin
    LBuffer := TA16c(ABuffer);
    Shake16c(LBuffer, ACount, AQuota);
    for LIndex := 0 to AQuota - 1 do
    begin
      LValue := ASwapper.Swap16c(LBuffer[LIndex]);
      LValue := LValue * ABScale + ABZero;
      Append(LValue);
    end;
  end;

  procedure Append32c(const ABuffer: TBuffer; ACount, AQuota: Integer;
    const ASwapper: TSwapper; const ABScale, ABZero: Extended);
  var
    LBuffer: TA32c;
    LValue: Extended;
    LIndex: Integer;
  begin
    LBuffer := TA32c(ABuffer);
    Shake32c(LBuffer, ACount, AQuota);
    for LIndex := 0 to AQuota - 1 do
    begin
      LValue := ASwapper.Swap32c(LBuffer[LIndex]);
      LValue := LValue * ABScale + ABZero;
      Append(LValue);
    end;
  end;

  procedure Append64c(const ABuffer: TBuffer; ACount, AQuota: Integer;
    const ASwapper: TSwapper; const ABScale, ABZero: Extended);
  var
    LBuffer: TA64c;
    LValue: Extended;
    LIndex: Integer;
  begin
    LBuffer := TA64c(ABuffer);
    Shake64c(LBuffer, ACount, AQuota);
    for LIndex := 0 to AQuota - 1 do
    begin
      LValue := ASwapper.Swap64c(LBuffer[LIndex]);
      LValue := LValue * ABScale + ABZero;
      Append(LValue);
    end;
  end;

var
  LTotalCount, LTotalQuota: Int64;
  LCount, LQuota: Integer;
  LOffset, LSize: Int64;
  LBitPix: TBitPix;
  LBScale, LBZero: Extended;
  LPixelSize: Byte;
  LSwapper: TSwapper;
  LBuffer: TBuffer;
begin
  // Get value info
  LBitPix := FFrame.BitPix;
  LBScale := FFrame.BScale;
  LBZero := FFrame.BZero;
  // Get the size of a pixel stored in a frame content
  LPixelSize := BitPixSize(LBitPix);
  // Get the total count of values in the frame and the total
  // quota of values to form a histogram (max buckets volume)
  LTotalCount := FFrame.ValueCount;
  LTotalQuota := Min(LTotalCount, cHistogramMaxVolume);
  // Get size, position, count and quota of values proportional to the chunk
  LCount := cMaxSizeBuffer div LPixelSize;
  if LCount > LTotalCount then
    LCount := LTotalCount;
  LQuota := Max(Round(Int64(LCount) * LTotalQuota / LTotalCount), 1);
  LOffset := FFrame.FrameOffset;
  LSize := Int64(LCount) * LPixelSize;
  // Get swap rules
  LSwapper := GetSwapper;
  // Initialize a random counter to select some
  // chunk values to append to the buckets
  Randomize;
  // Prepare the chunk buffer
  FFrame.Picture.Container.Memory.Allocate({out} LBuffer, LSize);
  // Loop start: evenly read and analyze all frame values
  while LTotalCount > 0 do
  begin
    // Correct the size and position of the last chunk values
    if LTotalCount < LCount then
    begin
      LCount := LTotalCount;
      LQuota := EnsureRange(LTotalQuota, 1, LTotalCount);
      LSize  := Int64(LQuota) * LPixelSize;
    end;
    // Read chunk values
    FFrame.Picture.Data.ReadChunk(LOffset, LSize, {var} LBuffer[0]);
    // Append chunk values to the buckets
    case LBitPix of
      bi64f: Append64f(LBuffer, LCount, LQuota, LSwapper, LBScale, LBZero);
      bi32f: Append32f(LBuffer, LCount, LQuota, LSwapper, LBScale, LBZero);
      bi08u: Append08u(LBuffer, LCount, LQuota, {LSwapper,} LBScale, LBZero);
      bi16c: Append16c(LBuffer, LCount, LQuota, LSwapper, LBScale, LBZero);
      bi32c: Append32c(LBuffer, LCount, LQuota, LSwapper, LBScale, LBZero);
      bi64c: Append64c(LBuffer, LCount, LQuota, LSwapper, LBScale, LBZero);
    end;
    Inc(LOffset, LSize);
    Dec(LTotalCount, LCount);
    Dec(LTotalQuota, LQuota);
  end;
end;

procedure TFitsFrameHistogram.Shrink;
begin
  // Complete the equalization
  if FEqualized then
    Equalize;
  // Fix buckets size
  SetLength(FBuckets, FBucketCount);
end;

procedure TFitsFrameHistogram.CalcModa;
var
  LIndex, LJndex, LFrequency, LFrequencies: Integer;
  LMaxFrequency: Boolean;
begin
  FIndexModa := 0;
  FIndexModaSmooth := 0;
  for LIndex := 0 to FBucketCount - 1 do
  begin
    LFrequency := FBuckets[LIndex]^.Frequency;
    // Get moda
    if LFrequency > FBuckets[FIndexModa]^.Frequency then
      FIndexModa := LIndex;
    // Get moda smooth
    if LFrequency > FBuckets[FIndexModaSmooth]^.Frequency then
    begin
      LMaxFrequency := True;
      LFrequencies := 0;
      for LJndex := Max(LIndex - 3, 0) to Min(LIndex + 3, FBucketCount - 1) do
        if LJndex <> LIndex then
        begin
          if FBuckets[LJndex]^.Frequency > LFrequency then
          begin
            LMaxFrequency := False;
            Break;
          end;
          LFrequencies := LFrequencies + FBuckets[LJndex]^.Frequency;
        end;
      if LMaxFrequency and (LFrequency <= LFrequencies) then
        FIndexModaSmooth := LIndex;
    end;
  end;
end;

procedure TFitsFrameHistogram.CalcMedian;
var
  LIndex, LFrequencies, LHalfValueCount: Integer;
begin
  FIndexMedian := 0;
  LHalfValueCount := FValueCount div 2;
  LFrequencies := 0;
  for LIndex := 0 to FBucketCount - 1 do
  begin
    LFrequencies := LFrequencies + FBuckets[LIndex]^.Frequency;
    if LFrequencies >= LHalfValueCount then
    begin
      FIndexMedian := LIndex;
      Break;
    end;
  end;
end;

procedure TFitsFrameHistogram.CalcDynamicRange;
var
  LHalfValueCount, LFrequencies, LBucketCount, LIndexBlack, LIndexWhite: Integer;
begin
  FIndexBlackDefault := 0;
  FIndexWhiteDefault := 0;
  LHalfValueCount := FValueCount div 2;
  LFrequencies := FBuckets[FIndexMedian]^.Frequency;
  LBucketCount := 1;
  LIndexBlack := FIndexMedian - 1;
  LIndexWhite := FIndexMedian + 1;
  while True do
  begin
    if LIndexBlack >= 0 then
      LFrequencies := LFrequencies + FBuckets[LIndexBlack]^.Frequency;
    if LIndexWhite < FBucketCount then
      LFrequencies := LFrequencies + FBuckets[LIndexWhite]^.Frequency;
    if LFrequencies >= LHalfValueCount then
    begin
      FIndexBlackDefault := Max(FIndexMedian - 4 * LBucketCount, 0);
      FIndexWhiteDefault := Min(Integer(Round(FIndexMedian + 7.5 * LBucketCount)), FBucketCount - 1);
      Break;
    end;
    Inc(LBucketCount);
    Dec(LIndexBlack);
    Inc(LIndexWhite);
  end;
  FIndexBlack := FIndexBlackDefault;
  FIndexWhite := FIndexWhiteDefault;
end;

function TFitsFrameHistogram.GetBucket(AIndex: Integer): THistogramBucket;
begin
  Make;
  if not InSegmentBound({ASegmentPosition:} 0, FBucketCount, AIndex) then
    Error(SFrameHistogramBucketIndexOutBounds, [AIndex, FBucketCount],
      ERROR_FRAMEHISTOGRAM_GETBUCKET_INDEX);
  Result := FBuckets[AIndex]^;
end;

function TFitsFrameHistogram.GetBucketCount: Integer;
begin
  Result := Make.FBucketCount;
end;

function TFitsFrameHistogram.GetValueCount: Integer;
begin
  Result := Make.FValueCount;
end;

function TFitsFrameHistogram.GetIndexModa: Integer;
begin
  Result := Make.FIndexModa;
end;

function TFitsFrameHistogram.GetIndexModaSmooth: Integer;
begin
  Result := Make.FIndexModaSmooth;
end;

function TFitsFrameHistogram.GetIndexMedian: Integer;
begin
  Result := Make.FIndexMedian;
end;

function TFitsFrameHistogram.GetIndexBlackDefault: Integer;
begin
  Result := Make.FIndexBlackDefault;
end;

function TFitsFrameHistogram.GetIndexWhiteDefault: Integer;
begin
  Result := Make.FIndexWhiteDefault;
end;

function TFitsFrameHistogram.GetIndexBlack: Integer;
begin
  Result := Make.FIndexBlack;
end;

procedure TFitsFrameHistogram.SetIndexBlack(AValue: Integer);
begin
  Make;
  if AValue > FIndexWhite then
    Error(SFrameHistogramIncorrectIndexBlack, [AValue, FIndexWhite],
      ERROR_FRAMEHISTOGRAM_SETINDEXBLACK_VALUE);
  if AValue <> FIndexBlack then
  begin
    FIndexBlack := AValue;
    Change;
  end;
end;

function TFitsFrameHistogram.GetIndexWhite: Integer;
begin
  Result := Make.FIndexWhite;
end;

procedure TFitsFrameHistogram.SetIndexWhite(AValue: Integer);
begin
  Make;
  if AValue < FIndexBlack then
    Error(SFrameHistogramIncorrectIndexWhite, [AValue, FIndexBlack],
      ERROR_FRAMEHISTOGRAM_SETINDEXWHITE_VALUE);
  if AValue <> FIndexWhite then
  begin
    FIndexWhite := AValue;
    Change;
  end;
end;

procedure TFitsFrameHistogram.SetDynamicRange(AIndexBlack, AIndexWhite: Integer);
begin
  Make;
  if AIndexBlack > AIndexWhite then
    Error(SFrameHistogramInvalidDynamicRange, [AIndexBlack, AIndexWhite],
      ERROR_FRAMEHISTOGRAM_SETDYNAMICRANGE_VALUE);
  if (AIndexBlack <> FIndexBlack) or (AIndexWhite <> FIndexWhite) then
  begin
    FIndexBlack := AIndexBlack;
    FIndexWhite := AIndexWhite;
    Change;
  end;
end;

destructor TFitsFrameHistogram.Destroy;
begin
  Clean;
  inherited;
end;

procedure TFitsFrameHistogram.Assign(ASource: TFitsFrameSetup);
var
  LSource: TFitsFrameHistogram;
  LIndex: Integer;
  LBucket: PHistogramBucket;
begin
  inherited;
  LSource := (ASource as TFitsFrameHistogram).Make;
  FDone := LSource.FDone;
  FEqualized := LSource.FEqualized;
  Clean;
  SetLength(FBuckets, LSource.FBucketCount);
  for LIndex := 0 to LSource.FBucketCount - 1 do
  begin
    New(LBucket);
    LBucket^ := LSource.FBuckets[LIndex]^;
    FBuckets[LIndex] := LBucket;
  end;
  FBucketCount := LSource.FBucketCount;
  FValueCount := LSource.FValueCount;
  FIndexModa := LSource.FIndexModa;
  FIndexModaSmooth := LSource.FIndexModaSmooth;
  FIndexMedian := LSource.FIndexMedian;
  FIndexBlackDefault := LSource.FIndexBlackDefault;
  FIndexWhiteDefault := LSource.FIndexWhiteDefault;
  FIndexBlack := LSource.FIndexBlack;
  FIndexWhite := LSource.FIndexWhite;
  Change;
end;

procedure TFitsFrameHistogram.Default;
begin
  Make;
  if (FIndexBlack <> FIndexBlackDefault) or (FIndexWhite <> FIndexWhiteDefault) then
  begin
    FIndexBlack := FIndexBlackDefault;
    FIndexWhite := FIndexWhiteDefault;
    Change;
  end;
end;

procedure TFitsFrameHistogram.Update;
begin
  Make({AForce:} True).Change;
end;

{ TFitsFrameTone }

procedure TFitsFrameTone.Init;
begin
  inherited;
  FBrightness := cBrightnessDef;
  FContrast := cContrastDef;
  FGamma := cGammaDef;
end;

function TFitsFrameTone.InRange(const AValue, AMin, AMax: Double): Boolean;
begin
  Result := (not IsNan(AValue)) and Math.InRange(AValue, AMin, AMax);
end;

procedure TFitsFrameTone.SetBrightness(const AValue: Double);
begin
  if not InRange(AValue, cBrightnessMin, cBrightnessMax) then
    Error(SFrameBrightnessOutRange, [AValue, cBrightnessMin, cBrightnessMax],
      ERROR_FRAMETONE_SETBRIGHTNESS_VALUE);
  if not SameValue(FBrightness, AValue) then
  begin
    FBrightness := AValue;
    Change;
  end;
end;

procedure TFitsFrameTone.SetContrast(const AValue: Double);
begin
  if not InRange(AValue, cContrastMin, cContrastMax) then
    Error(SFrameContrastOutRange, [AValue, cContrastMin, cContrastMax],
      ERROR_FRAMETONE_SETCONTRAST_VALUE);
  if not SameValue(FContrast, AValue) then
  begin
    FContrast := AValue;
    Change;
  end;
end;

procedure TFitsFrameTone.SetGamma(const AValue: Double);
begin
  if not InRange(AValue, cGammaMin, cGammaMax) then
    Error(SFrameGammaOutRange, [AValue, cGammaMin, cGammaMax],
      ERROR_FRAMETONE_SETGAMMA_VALUE);
  if not SameValue(FGamma, AValue) then
  begin
    FGamma := AValue;
    Change;
  end;
end;

procedure TFitsFrameTone.Assign(ASource: TFitsFrameSetup);
var
  LSource: TFitsFrameTone;
begin
  inherited;
  LSource := ASource as TFitsFrameTone;
  FBrightness := LSource.FBrightness;
  FContrast := LSource.FContrast;
  FGamma := LSource.FGamma;
  Change;
end;

procedure TFitsFrameTone.Default;
begin
  if (not SameValue(FBrightness, cBrightnessDef)) or
     (not SameValue(FContrast, cContrastDef)) or
     (not SameValue(FGamma, cGammaDef)) then
  begin
    FBrightness := cBrightnessDef;
    FContrast := cContrastDef;
    FGamma := cGammaDef;
    Change;
  end;
end;

{ TFitsFramePalette }

procedure TFitsFramePalette.Init;
begin
  inherited;
  FTuples := cPaletteGrayScale;
  FReverse := False;
end;

procedure TFitsFramePalette.SetTuples(AValue: PPaletteTuples);
begin
  if AValue = nil then
    Error(SFramePaletteIncorrectTuples, ERROR_FRAMEPALETTE_SETTUPLES_VALUE);
  if AValue <> FTuples then
  begin
    FTuples := AValue;
    Change;
  end;
end;

procedure TFitsFramePalette.SetReverse(AValue: Boolean);
begin
  if AValue <> FReverse then
  begin
    FReverse := AValue;
    Change;
  end;
end;

procedure TFitsFramePalette.Assign(ASource: TFitsFrameSetup);
var
  LSource: TFitsFramePalette;
begin
  inherited;
  LSource := ASource as TFitsFramePalette;
  FTuples := LSource.FTuples;
  FReverse := LSource.FReverse;
  Change;
end;

procedure TFitsFramePalette.Default;
begin
  if (FTuples <> cPaletteGrayScale) or (FReverse <> False) then
  begin
    FTuples := cPaletteGrayScale;
    FReverse := False;
    Change;
  end;
end;

{ TFitsFrameGeometry }

procedure TFitsFrameGeometry.Init;
begin
  inherited;
  FLocalMatrix := CreateMatrix;
  FSceneMatrix := CreateMatrix;
end;

procedure TFitsFrameGeometry.Assign(ASource: TFitsFrameSetup);
var
  LSource: TFitsFrameGeometry;
begin
  inherited;
  LSource := ASource as TFitsFrameGeometry;
  FLocalMatrix := LSource.FLocalMatrix;
  FSceneMatrix := LSource.FSceneMatrix;
  Change;
end;

procedure TFitsFrameGeometry.Default;
begin
  Reset;
end;

procedure TFitsFrameGeometry.DecodeSceneVirtualShift(const AShift: TVirtualShift; out ADX, ADY: Double);
var
  LRegion: TRegion;
begin
  LRegion := LocalRegionToSceneRegion(FFrame.Region);
  case AShift of
    xyLTat00:
      begin
        ADX := -LRegion.X1;
        ADY := -LRegion.Y1;
      end;
    xyRTat00:
      begin
        ADX := -(LRegion.X1 + LRegion.Width);
        ADY := -LRegion.Y1;
      end;
    xyRBat00:
      begin
        ADX := -(LRegion.X1 + LRegion.Width);
        ADY := -(LRegion.Y1 + LRegion.Height);
      end;
    xyLBat00:
      begin
        ADX := -LRegion.X1;
        ADY := -(LRegion.Y1 + LRegion.Height);
      end;
    xyCCat00:
      begin
        ADX := -(LRegion.X1 + LRegion.Width / 2);
        ADY := -(LRegion.Y1 + LRegion.Height / 2);
      end;
  else
    ADX := NaN;
    ADY := NaN;
  end;
end;

procedure TFitsFrameGeometry.DecodeSceneVirtualPoint(const APoint: TVirtualPoint; out AX, AY: Double);
var
  LRegion: TRegion;
begin
  LRegion := LocalRegionToSceneRegion(FFrame.Region);
  case APoint of
    xy00:
      begin
        AX := 0;
        AY := 0;
      end;
    xyLT:
      begin
        AX := LRegion.X1;
        AY := LRegion.Y1;
      end;
    xyRT:
      begin
        AX := LRegion.X1 + LRegion.Width;
        AY := LRegion.Y1;
      end;
    xyRB:
      begin
        AX := LRegion.X1 + LRegion.Width;
        AY := LRegion.Y1 + LRegion.Height;
      end;
    xyLB:
      begin
        AX := LRegion.X1;
        AY := LRegion.Y1 + LRegion.Height;
      end;
    xyCC:
      begin
        AX := LRegion.X1 + LRegion.Width / 2;
        AY := LRegion.Y1 + LRegion.Height / 2;
      end;
  else
    AX := NaN;
    AY := NaN;
  end;
end;

function TFitsFrameGeometry.Merge(const AMatrix: TMatrix; const APoint: TPlanePoint): TFitsFrameGeometry;
var
  LShift: Boolean;
  LMatrix, LLocalMatrix, LSceneMatrix: TMatrix;
begin
  LLocalMatrix := FLocalMatrix;
  LShift := (not IsZero(APoint.X)) or (not IsZero(APoint.Y));
  // Move the scene point (APoint) to the local origin (0;0)
  if LShift then
  begin
    LMatrix := CreateMatrixShift(FlipSign(APoint.X), FlipSign(APoint.Y));
    LLocalMatrix := MultiplyMatrix(LLocalMatrix, LMatrix);
  end;
  // Perform transformation
  LLocalMatrix := MultiplyMatrix(LLocalMatrix, AMatrix);
  // Restore the position of the scene point (APoint)
  if LShift then
  begin
    LMatrix := CreateMatrixShift(APoint.X, APoint.Y);
    LLocalMatrix := MultiplyMatrix(LLocalMatrix, LMatrix);
  end;
  // Update scene matrix
  LSceneMatrix := InvertMatrix(LLocalMatrix);
  // Save transformation
  FLocalMatrix := LLocalMatrix;
  FSceneMatrix := LSceneMatrix;
  // Notify Frame object
  Change;
  Result := Self;
end;

function TFitsFrameGeometry.Reset: TFitsFrameGeometry;
begin
  FLocalMatrix := CreateMatrix;
  FSceneMatrix := CreateMatrix;
  Change;
  Result := Self;
end;

function TFitsFrameGeometry.Append(const AMatrix: TMatrix): TFitsFrameGeometry;
begin
  Result := Merge(AMatrix, cPointOrigin);
end;

function TFitsFrameGeometry.Shift(const ADX, ADY: Double): TFitsFrameGeometry;
var
  LMatrix: TMatrix;
begin
  if (not IsZero(ADX)) or (not IsZero(ADY)) then
  begin
    LMatrix := CreateMatrixShift(ADX, ADY);
    Merge(LMatrix, cPointOrigin);
  end;
  Result := Self;
end;

function TFitsFrameGeometry.Shift(const AShift: TVirtualShift): TFitsFrameGeometry;
var
  LDX, LDY: Double;
begin
  DecodeSceneVirtualShift(AShift, {out} LDX, {out} LDY);
  Result := Shift(LDX, LDY);
end;

function TFitsFrameGeometry.Scale(const ASX, ASY: Double; const APoint: TPlanePoint): TFitsFrameGeometry;
var
  LMatrix: TMatrix;
begin
  if (not SameValue(ASX, 1.0)) or (not SameValue(ASY, 1.0)) then
  begin
    LMatrix := CreateMatrixScale(ASX, ASY);
    Merge(LMatrix, APoint);
  end;
  Result := Self;
end;

function TFitsFrameGeometry.Scale(const ASX, ASY: Double; const APoint: TVirtualPoint): TFitsFrameGeometry;
var
  LPoint: TPlanePoint;
begin
  DecodeSceneVirtualPoint(APoint, {out} LPoint.X, {out} LPoint.Y);
  Result := Scale(ASX, ASY, LPoint);
end;

function TFitsFrameGeometry.Rotate(const AAngle: Double; const APoint: TPlanePoint): TFitsFrameGeometry;
var
  LMatrix: TMatrix;
begin
  if not IsZero(AAngle) then
  begin
    LMatrix := CreateMatrixRotate(AAngle);
    Merge(LMatrix, APoint);
  end;
  Result := Self;
end;

function TFitsFrameGeometry.Rotate(const AAngle: Double; const APoint: TVirtualPoint): TFitsFrameGeometry;
var
  LPoint: TPlanePoint;
begin
  DecodeSceneVirtualPoint(APoint, {out} LPoint.X, {out} LPoint.Y);
  Result := Rotate(AAngle, LPoint);
end;

function TFitsFrameGeometry.ShearX(const AAngle: Double): TFitsFrameGeometry;
var
  LMatrix: TMatrix;
begin
  if not IsZero(AAngle) then
  begin
    LMatrix := CreateMatrixShearX(AAngle);
    Merge(LMatrix, cPointOrigin);
  end;
  Result := Self;
end;

function TFitsFrameGeometry.ShearY(const AAngle: Double): TFitsFrameGeometry;
var
  LMatrix: TMatrix;
begin
  if not IsZero(AAngle) then
  begin
    LMatrix := CreateMatrixShearY(AAngle);
    Merge(LMatrix, cPointOrigin);
  end;
  Result := Self;
end;

function TFitsFrameGeometry.ScenePointToLocalPoint(const AScenePoint: TPlanePoint): TPlanePoint;
begin
  Result := MapPoint(FSceneMatrix, AScenePoint);
end;

function TFitsFrameGeometry.LocalPointToScenePoint(const ALocalPoint: TPlanePoint): TPlanePoint;
begin
  Result := MapPoint(FLocalMatrix, ALocalPoint);
end;

function TFitsFrameGeometry.ScenePixelToLocalPixel(const AScenePixel: TPlanePixel): TPlanePixel;
begin
  Result := MapPixel(FSceneMatrix, AScenePixel);
end;

function TFitsFrameGeometry.LocalPixelToScenePixel(const ALocalPixel: TPlanePixel): TPlanePixel;
begin
  Result := MapPixel(FLocalMatrix, ALocalPixel);
end;

function TFitsFrameGeometry.SceneRegionToLocalQuad(const ASceneRegion: TRegion): TQuad;
var
  LQuad: TQuad;
  LIndex: Integer;
begin
  LQuad := ToQuad(ASceneRegion);
  for LIndex := Low(LQuad.Points) to High(LQuad.Points) do
    LQuad.Points[LIndex] := ScenePointToLocalPoint(LQuad.Points[LIndex]);
  Result := NormQuad(LQuad);
end;

function TFitsFrameGeometry.LocalRegionToSceneQuad(const ALocalRegion: TRegion): TQuad;
var
  LQuad: TQuad;
  LIndex: Integer;
begin
  LQuad := ToQuad(ALocalRegion);
  for LIndex := Low(LQuad.Points) to High(LQuad.Points) do
    LQuad.Points[LIndex] := LocalPointToScenePoint(LQuad.Points[LIndex]);
  Result := NormQuad(LQuad);
end;

function TFitsFrameGeometry.SceneRegionToLocalRegion(const ASceneRegion: TRegion): TRegion;
var
  LQuad: TQuad;
begin
  LQuad := SceneRegionToLocalQuad(ASceneRegion);
  Result := RectQuad(LQuad);
end;

function TFitsFrameGeometry.LocalRegionToSceneRegion(const ALocalRegion: TRegion): TRegion;
var
  LQuad: TQuad;
begin
  LQuad := LocalRegionToSceneQuad(ALocalRegion);
  Result := RectQuad(LQuad);
end;

function TFitsFrameGeometry.ClipRealLocalRegion(const ASceneRegion: TRegion): TClip;
var
  LQuad, LRealQuad: TQuad;
begin
  LQuad := SceneRegionToLocalQuad(ASceneRegion);
  LRealQuad := ToQuad(FFrame.Region);
  QClip(LQuad, LRealQuad, {out} Result);
end;

function TFitsFrameGeometry.ClipRealSceneRegion(const ASceneRegion: TRegion): TClip;
var
  LQuad, LRealQuad: TQuad;
begin
  LQuad := ToQuad(ASceneRegion);
  LRealQuad := LocalRegionToSceneQuad(FFrame.Region);
  QClip(LQuad, LRealQuad, {out} Result);
end;

{ EFitsFrameException }

function EFitsFrameException.GetTopic: string;
begin
  Result := 'FRAME';
end;

{ TFitsFrame }

function TFitsFrame.GetFrameOffset: Int64;
begin
  Result := ValueCount * PixelSize * FFrameIndex;
end;

function TFitsFrame.GetOffset: Int64;
begin
  Result := FPicture.Data.Offset + FrameOffset;
end;

function TFitsFrame.GetSize: Int64;
begin
  Result := ValueCount * PixelSize;
end;

function TFitsFrame.GetBitPix: TBitPix;
begin
  Result := FPicture.Data.BitPix;
end;

function TFitsFrame.GetBScale: Extended;
begin
  Result := FPicture.Data.BScale;
end;

function TFitsFrame.GetBZero: Extended;
begin
  Result := FPicture.Data.BZero;
end;

function TFitsFrame.GetPixelSize: Byte;
begin
  Result := FPicture.Data.PixelSize;
end;

function TFitsFrame.GetValueType: TNumberType;
begin
  Result := FPicture.Data.ValueType;
end;

function TFitsFrame.GetValueStart: Int64;
begin
  Result := ValueCount * FFrameIndex;
end;

function TFitsFrame.GetValueIndex(AX, AY: Integer): Int64;
var
  LWidth, LHeight: Integer;
begin
  LWidth := Width;
  LHeight := Height;
  Result := Int64(LWidth) * LHeight * FFrameIndex + Int64(AX) + Int64(AY) * LWidth;
end;

function TFitsFrame.GetValueCount: Int64;
begin
  Result := Int64(Width) * Height;
end;

function TFitsFrame.GetRegion: TRegion;
begin
  Result := ToRegion(0, 0, Width, Height);
end;

function TFitsFrame.GetWidth: Integer;
begin
  Result := FPicture.Data.AxesLength[1];
end;

function TFitsFrame.GetHeight: Integer;
begin
  Result := FPicture.Data.AxesLength[2];
end;

function TFitsFrame.GetSceneRegion: TRegion;
begin
  Result := FGeometry.LocalRegionToSceneRegion(Region);
end;

function TFitsFrame.GetSceneWidth: Integer;
begin
  Result := SceneRegion.Width;
end;

function TFitsFrame.GetSceneHeight: Integer;
begin
  Result := SceneRegion.Height;
end;

procedure TFitsFrame.Bind(const AHandle: TFrameHandle);
var
  LFrameCount: Integer;
begin
  if not Assigned(AHandle.FrameSource) then
    Error(SPictureNotAssigned, ERROR_FRAME_BIND_NO_SOURCE);
  LFrameCount := AHandle.FrameSource.Data.FrameCount;
  if not InSegmentBound({ASegmentPosition:} 0, LFrameCount, AHandle.FrameIndex) then
    Error(SFrameIndexOutBounds, [AHandle.FrameIndex, LFrameCount],
      ERROR_FRAME_BIND_INDEX);
  FPicture := AHandle.FrameSource;
  FFrameIndex := AHandle.FrameIndex;
end;

function TFitsFrame.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsFrameException;
end;

constructor TFitsFrame.Create(const AHandle: TFrameHandle);
begin
  inherited Create;
  Bind(AHandle);
  MakeSetup;
end;

destructor TFitsFrame.Destroy;
begin
  FreeSetup;
  inherited;
end;

procedure TFitsFrame.CheckChunk(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
var
  LArgOffset, LArgSize, LSize: Int64;
begin
  if ACheck = 'bounds' then
  begin
    LArgOffset := AArgs[0].VInt64^;
    LArgSize := AArgs[1].VInt64^;
    LSize := GetSize;
    if not InSegmentBound({ASegmentPosition:} 0, LSize, LArgOffset, LArgSize) then
      Error(SFrameContentChunkOutBounds, [LArgOffset, LArgSize, LSize], ACodeError);
  end else
  if ACheck = 'offset' then
  begin
    LArgOffset := AArgs[0].VInt64^;
    LSize := GetSize;
    if not InSegmentBound({ASegmentPosition:} 0, LSize, LArgOffset) then
      Error(SFrameContentOffsetOutBounds, [LArgOffset, LSize], ACodeError);
  end else
    Assert(False, SAssertionFailureArgs(AArgs));
end;

procedure TFitsFrame.ReadChunk(const AInternalOffset, ASize: Int64; var ABuffer);
begin
  CheckChunk('bounds', [AInternalOffset, ASize], ERROR_FRAME_READCHUNK_BOUNDS);
  FPicture.Data.ReadChunk(GetFrameOffset + AInternalOffset, ASize, {var} ABuffer);
end;

procedure TFitsFrame.WriteChunk(const AInternalOffset, ASize: Int64; const ABuffer);
begin
  CheckChunk('bounds', [AInternalOffset, ASize], ERROR_FRAME_WRITECHUNK_BOUNDS);
  FPicture.Data.WriteChunk(GetFrameOffset + AInternalOffset, ASize, ABuffer);
end;

procedure TFitsFrame.ExchangeChunk(var AInternalOffset1: Int64; const ASize1: Int64; var AInternalOffset2: Int64; const ASize2: Int64);
var
  LFrameOffset, LOffset1, LOffset2: Int64;
begin
  CheckChunk('bounds', [AInternalOffset1, ASize1], ERROR_FRAME_EXCHANGECHUNK_BOUNDS);
  CheckChunk('bounds', [AInternalOffset2, ASize2], ERROR_FRAME_EXCHANGECHUNK_BOUNDS);
  LFrameOffset := GetFrameOffset;
  LOffset1 := AInternalOffset1 + LFrameOffset;
  LOffset2 := AInternalOffset2 + LFrameOffset;
  FPicture.Data.ExchangeChunk({var} LOffset1, ASize1, {var} LOffset2, ASize2);
  AInternalOffset1 := LOffset1 - LFrameOffset;
  AInternalOffset2 := LOffset2 - LFrameOffset;
end;

procedure TFitsFrame.MoveChunk(const AInternalOffset, ASize: Int64; var ANewInternalOffset: Int64);
var
  LFrameOffset, LCurOffset, LNewOffset: Int64;
begin
  CheckChunk('bounds', [AInternalOffset, ASize], ERROR_FRAME_MOVECHUNK_BOUNDS);
  CheckChunk('offset', [ANewInternalOffset], ERROR_FRAME_MOVECHUNK_OFFSET);
  LFrameOffset := GetFrameOffset;
  LCurOffset := AInternalOffset + LFrameOffset;
  LNewOffset := ANewInternalOffset + LFrameOffset;
  FPicture.Data.MoveChunk(LCurOffset, ASize, {var} LNewOffset);
  ANewInternalOffset := LNewOffset - LFrameOffset;
end;

procedure TFitsFrame.EraseChunk(const AInternalOffset, ASize: Int64);
begin
  CheckChunk('bounds', [AInternalOffset, ASize], ERROR_FRAME_ERASECHUNK_BOUNDS);
  FPicture.Data.EraseChunk(GetFrameOffset + AInternalOffset, ASize);
end;

procedure TFitsFrame.CheckValues(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
var
  LArgX, LArgY: Integer;
  LArgCount: Int64;
  LWidth, LHeight: Integer;
  LCount: Int64;
begin
  if ACheck = 'bounds' then
  begin
    LArgX := AArgs[0].VInteger;
    LArgY := AArgs[1].VInteger;
    LArgCount := AArgs[2].VInt64^;
    LWidth := GetWidth;
    LHeight := GetHeight;
    LCount := GetValueCount;
    if (not InSegmentBound({ASegmentPosition:} 0, LWidth, LArgX)) or
       (not InSegmentBound({ASegmentPosition:} 0, LHeight, LArgY)) or
       (not InSegmentBound({ASegmentPosition:} 0, LCount, {AChunkPosition:} Int64(LArgX) + Int64(LArgY) * LWidth, LArgCount)) then
      Error(SFrameValuesBlockOutBounds, [LArgX, LArgY, LArgCount, LWidth, LHeight], ACodeError);
  end else
  if ACheck = 'position' then
  begin
    LArgX := AArgs[0].VInteger;
    LArgY := AArgs[1].VInteger;
    LWidth := GetWidth;
    LHeight := GetHeight;
    if (not InSegmentBound({ASegmentPosition:} 0, LWidth, LArgX)) or
       (not InSegmentBound({ASegmentPosition:} 0, LHeight, LArgY)) then
      Error(SFrameValuesPositionOutBounds, [LArgX, LArgY, LWidth, LHeight], ACodeError);
  end else
    Assert(False, SAssertionFailureArgs(AArgs));
end;

function TFitsFrame.GetValue(AX, AY: Integer): Extended;
begin
  CheckValues('position', [AX, AY], ERROR_FRAME_GETVALUE_POSITION);
  Result := FPicture.Data[GetValueIndex(AX, AY)];
end;

procedure TFitsFrame.SetValue(AX, AY: Integer; const AValue: Extended);
begin
  CheckValues('position', [AX, AY], ERROR_FRAME_SETVALUE_POSITION);
  FPicture.Data[GetValueIndex(AX, AY)] := AValue;
end;

procedure TFitsFrame.GetValues(AX, AY: Integer; const ACount: Int64; var AValues: Pointer; AValuesType: TNumberType);
var
  LIndex: Int64;
begin
  CheckValues('bounds', [AX, AY, ACount], ERROR_FRAME_GETVALUES_BOUNDS);
  LIndex := GetValueIndex(AX, AY);
  case AValuesType of
    num80f: FPicture.Data.ReadValues(LIndex, ACount, {var} TA80f(AValues));
    num64f: FPicture.Data.ReadValues(LIndex, ACount, {var} TA64f(AValues));
    num32f: FPicture.Data.ReadValues(LIndex, ACount, {var} TA32f(AValues));
    num08c: FPicture.Data.ReadValues(LIndex, ACount, {var} TA08c(AValues));
    num08u: FPicture.Data.ReadValues(LIndex, ACount, {var} TA08u(AValues));
    num16c: FPicture.Data.ReadValues(LIndex, ACount, {var} TA16c(AValues));
    num16u: FPicture.Data.ReadValues(LIndex, ACount, {var} TA16u(AValues));
    num32c: FPicture.Data.ReadValues(LIndex, ACount, {var} TA32c(AValues));
    num32u: FPicture.Data.ReadValues(LIndex, ACount, {var} TA32u(AValues));
    num64c: FPicture.Data.ReadValues(LIndex, ACount, {var} TA64c(AValues));
  end;
end;

procedure TFitsFrame.SetValues(AX, AY: Integer; const ACount: Int64; const AValues: Pointer; AValuesType: TNumberType);
var
  LIndex: Int64;
begin
  CheckValues('bounds', [AX, AY, ACount], ERROR_FRAME_SETVALUES_BOUNDS);
  LIndex := GetValueIndex(AX, AY);
  case AValuesType of
    num80f: FPicture.Data.WriteValues(LIndex, ACount, TA80f(AValues));
    num64f: FPicture.Data.WriteValues(LIndex, ACount, TA64f(AValues));
    num32f: FPicture.Data.WriteValues(LIndex, ACount, TA32f(AValues));
    num08c: FPicture.Data.WriteValues(LIndex, ACount, TA08c(AValues));
    num08u: FPicture.Data.WriteValues(LIndex, ACount, TA08u(AValues));
    num16c: FPicture.Data.WriteValues(LIndex, ACount, TA16c(AValues));
    num16u: FPicture.Data.WriteValues(LIndex, ACount, TA16u(AValues));
    num32c: FPicture.Data.WriteValues(LIndex, ACount, TA32c(AValues));
    num32u: FPicture.Data.WriteValues(LIndex, ACount, TA32u(AValues));
    num64c: FPicture.Data.WriteValues(LIndex, ACount, TA64c(AValues));
  end;
end;

function TFitsFrame.GetSceneValue(AX, AY: Integer): Extended;
var
  LPixel: TPlanePixel;
begin
  LPixel := FGeometry.ScenePixelToLocalPixel(ToPixel(AX, AY));
  if InRegion(Region, LPixel.X, LPixel.Y) then
    Result := FPicture.Data[GetValueIndex(LPixel.X, LPixel.Y)]
  else
    Result := NaN;
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA80f);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num80f);
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA64f);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num64f);
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA32f);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num32f);
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA08c);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num08c);
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA08u);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num08u);
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA16c);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num16c);
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA16u);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num16u);
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA32c);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num32c);
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA32u);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num32u);
end;

procedure TFitsFrame.ReadValues(AX, AY: Integer; const ACount: Int64; var AValues: TA64c);
begin
  GetValues(AX, AY, ACount, {var} Pointer(AValues), num64c);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA80f);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num80f);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA64f);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num64f);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA32f);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num32f);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA08c);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num08c);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA08u);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num08u);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA16c);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num16c);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA16u);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num16u);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA32c);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num32c);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA32u);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num32u);
end;

procedure TFitsFrame.WriteValues(AX, AY: Integer; const ACount: Int64; const AValues: TA64c);
begin
  SetValues(AX, AY, ACount, Pointer(AValues), num64c);
end;

procedure TFitsFrame.MakeSetup;
begin
  FHistogram := TFitsFrameHistogram.Create(Self);
  FTone := TFitsFrameTone.Create(Self);
  FPalette := TFitsFramePalette.Create(Self);
  FGeometry := TFitsFrameGeometry.Create(Self);
end;

procedure TFitsFrame.FreeSetup;
begin
  FHistogram.Free;
  FTone.Free;
  FPalette.Free;
  FGeometry.Free;
end;

procedure TFitsFrame.ChangeSetup(Sender: TFitsFrameSetup);
begin
  if (Sender is TFitsFrameHistogram) or (Sender is TFitsFrameTone) then
    ResetBand;
end;

procedure TFitsFrame.AssignSetup(ASource: TFitsFrame);
begin
  if not Assigned(ASource) then
    Error(SFrameNotAssigned, ERROR_FRAME_ASSIGNSETUP_NO_SOURCE);
  FHistogram.Assign(ASource.Histogram);
  FTone.Assign(ASource.Tone);
  FPalette.Assign(ASource.Palette);
  FGeometry.Assign(ASource.Geometry);
end;

procedure TFitsFrame.DefaultSetup;
begin
  FHistogram.Default;
  FTone.Default;
  FPalette.Default;
  FGeometry.Default;
end;

procedure TFitsFrame.ResetBand;
begin
  FBandDone := False;
end;

procedure TFitsFrame.ChangeBand(var ABand: TFrameBand);
begin
  // Do nothing
  if ABand[0] = 0.0 then
    ;
end;

procedure TFitsFrame.MakeBand;

  // Create the new band from the histogram
  function NewBand: TFrameBand;
  var
    I, B, B1, B2, R1, R2: Integer;
    K, LRate, LValue: Double;
  begin
    B1 := 0;
    B2 := cFrameBandCount - 1;
    R1 := FHistogram.IndexBlack;
    R2 := FHistogram.IndexWhite;
    // Get the histogram dynamic range rate: (bucket count in historgam dynamic range) / (band count)
    LRate := (R2 - R1 + 1) / (B2 - B1 + 1);
    for B := B1 to B2 do
    begin
      if B = B1 then
        I := R1
      else if B = B2 then
        I := R2
      else
      begin
        K := R1 + B * LRate;
        I := Integer(System.Trunc(K));
        if (I = 0) and (K < 0) then
          I := -1;
        I := EnsureRange(I, R1, R2);
      end;
      // Get the histogram bucket value
      if I < 0 then
        LValue := NegInfinity
      else if I >= FHistogram.BucketCount then
        LValue := Infinity
      else
        LValue := FHistogram.Buckets[I].Value;
      Result[B] := LValue;
    end;
    Result[B1] := Min(Result[B1], Result[B1 + 1]);
    Result[B2] := Max(Result[B2], Result[B2 - 1]);
  end;

  // Correct the band using tone coefficients
  function TweakBand(const ABand: TFrameBand): TFrameBand;
  var
    I, B, B1, B2: Integer;
    K, LValue, LBrightness, LContrast, LGamma: Double;
  begin
    Result := ABand;
    LBrightness := FTone.Brightness;
    LContrast := FTone.Contrast;
    LGamma := FTone.Gamma;
    if (not SameValue(LBrightness, cBrightnessDef)) or
       (not SameValue(LContrast, cContrastDef)) or
       (not SameValue(LGamma, cGammaDef)) then
    begin
      // IndexTone = Contrast * (IndexBand ^ Gamma - 0.5) + 0.5 + Brightness, ie
      // IndexBand = ((IndexTone + 0.5 * (Contrast - 1) - Brightness) / Contrast) ^ (1 / Gamma)
      B1 := 0;
      B2 := cFrameBandCount - 1;
      LContrast := Max(LContrast, 0.01);
      LGamma := Max(LGamma, 0.01);
      for B := B1 to B2 do
      begin
        K := B / (cFrameBandCount - 1); // norm to 1
        K := K + 0.5 * (LContrast - 1) - LBrightness;
        if K >= 0 then
        begin
          K := K / LContrast;
          K := Power(K, 1 / LGamma);
          K := K * (cFrameBandCount - 1); // denorm to cFrameBandCount
          I := Round32c(K);
        end else
          I := -1;
        if I < B1 then
          LValue := NegInfinity
        else if I > B2 then
          LValue := Infinity
        else
          LValue := ABand[I];
        Result[B] := LValue;
      end;
    end;
  end;

begin
  if not FBandDone then
  begin
    FBand := TweakBand(NewBand);
    ChangeBand({var} FBand);
    FBandDone := True;
  end;
end;

function TFitsFrame.BandIndexOf(const AValue: Extended): Integer;
var
  LIndex, LIndex1, LIndex2: Integer;
begin
  Result := 0;
  LIndex1 := Low(FBand);
  LIndex2 := High(FBand);
  LIndex  := Length(FBand) div 2;
  while LIndex > 0 do
  begin
    if (AValue = FBand[LIndex]) then
    begin
      Result := LIndex;
      Break;
    end;
    if (LIndex2 <= LIndex1) then
    begin
      Result := LIndex1;
      Break;
    end;
    if AValue < FBand[LIndex] then
      LIndex2 := LIndex - 1
    else
      LIndex1 := LIndex + 1;
    LIndex := (LIndex1 + LIndex2) div 2;
  end;
end;

procedure TFitsFrame.RenderPalette(var APalette: TPaletteTuples);
var
  LIndex, LIndexMin, LIndexMax: Integer;
begin
  LIndexMin := Low(APalette);
  LIndexMax := High(APalette);
  case FPalette.Reverse of
    True:
      for LIndex := LIndexMin to LIndexMax do
        APalette[LIndex] := FPalette.Tuples^[LIndexMax - LIndex];
    False:
      for LIndex := LIndexMin to LIndexMax do
        APalette[LIndex] := FPalette.Tuples^[LIndex];
  end;
end;

function TFitsFrame.FindRasterBound(var AContext: TRasterContext; const ASceneRegion: TRegion): Boolean;
var
  LIndex: Integer;
  LClip: TClip;
  LPoint: TPlanePoint;
  LClipXmin, LClipXmax, LClipYmin, LClipYmax: Double;
  LRealLocalRegion: TRegion;
begin
  // Calculate the intersection of the custom scene region and the real region
  LClip := FGeometry.ClipRealLocalRegion(ASceneRegion);
  if LClip.Count = 0 then
  begin
    AContext.LocalBound.Xcount := 0;
    AContext.SceneBound.Xcount := 0;
    Result := False;
  end else
  // if LClip.Count > 0 then
  begin
    LClipXmin := LClip.X1;
    LClipXmax := LClip.X1;
    LClipYmin := LClip.Y1;
    LClipYmax := LClip.Y1;
    for LIndex := 2 to LClip.Count do
    begin
      LPoint := LClip.Points[LIndex];
      LClipXmin := Min(LClipXmin, LPoint.X);
      LClipXmax := Max(LClipXmax, LPoint.X);
      LClipYmin := Min(LClipYmin, LPoint.Y);
      LClipYmax := Max(LClipYmax, LPoint.Y);
    end;
    LRealLocalRegion := GetRegion;
    with AContext.LocalBound do
    begin
      Xmin := EnsureRange(Integer(Trunc(LClipXmin)) - 1, LRealLocalRegion.X1, LRealLocalRegion.Width - 1);
      Xmax := EnsureRange(Integer(Trunc(LClipXmax)) + 1, LRealLocalRegion.X1, LRealLocalRegion.Width - 1);
      Ymin := EnsureRange(Integer(Trunc(LClipYmin)) - 1, LRealLocalRegion.Y1, LRealLocalRegion.Height - 1);
      Ymax := EnsureRange(Integer(Trunc(LClipYmax)) + 1, LRealLocalRegion.Y1, LRealLocalRegion.Height - 1);
      Xcount := Xmax - Xmin + 1;
      Ycount := Ymax - Ymin + 1;
    end;
    AContext.SceneBound := ToBound(ASceneRegion);
    Result := True;
  end;
end;

procedure TFitsFrame.PrepareRasterBuffer(var AContext: TRasterContext);
var
  LIndex: Integer;
begin
  // Prepare the local rows
  AContext.LocalRow1 := nil;
  AContext.LocalRow2 := nil;
  SetLength(AContext.LocalRow1, AContext.LocalBound.Xcount);
  SetLength(AContext.LocalRow2, AContext.LocalBound.Xcount);
  // Prepare the book to account for used and processed local rows
  AContext.LocalBook := nil;
  SetLength(AContext.LocalBook, AContext.LocalBound.Ycount);
  for LIndex := 0 to AContext.LocalBound.Ycount - 1 do
    AContext.LocalBook[LIndex] := False;
end;

function TFitsFrame.CaptureRasterOrigin(var AContext: TRasterContext; const AScenePixel: TPlanePixel): Boolean;
var
  LLocalPoint: TPlanePoint;
  LLocalPixel: TPlanePixel;
  LBookIndex: Integer;
begin
  Result := False;
  // Check if the local point is inside the boundary
  LLocalPoint := FGeometry.ScenePointToLocalPoint(ToPoint(AScenePixel.X, AScenePixel.Y));
  if InBound(AContext.LocalBound, LLocalPoint.X, LLocalPoint.Y) then
  begin
    // Check that this local row has not been processed yet
    LLocalPixel.X := Trunc(LLocalPoint.X);
    LLocalPixel.Y := Trunc(LLocalPoint.Y);
    LBookIndex := LLocalPixel.Y - AContext.LocalBound.Ymin;
    if not AContext.LocalBook[LBookIndex] then
    begin
      AContext.SceneOrigin := AScenePixel;
      AContext.LocalOrigin := LLocalPixel;
      AContext.LocalBook[LBookIndex] := True;
      Result := True;
    end;
  end;
end;

procedure TFitsFrame.ReadRasterValues(var AContext: TRasterContext);
var
  LX, LY1, LY2, LCount, LIndex: Integer;
begin
  // Read the physical values of local rows Y and Y+1 based on the local origin
  LX := AContext.LocalBound.Xmin;
  LY1 := AContext.LocalOrigin.Y;
  LY2 := Min(AContext.LocalOrigin.Y + 1, AContext.LocalBound.Ymax);
  LCount := AContext.LocalBound.Xcount;
  ReadValues(LX, LY1, LCount, {var} AContext.LocaLRow1);
  ReadValues(LX, LY2, LCount, {var} AContext.LocaLRow2);
  for LIndex := 0 to LCount - 1 do
  begin
    AContext.LocalRow1[LIndex] := UnNan64f(AContext.LocalRow1[LIndex]);
    AContext.LocalRow2[LIndex] := UnNan64f(AContext.LocalRow2[LIndex]);
  end;
end;

function TFitsFrame.CalcRasterValue(const AContext: TRasterContext; const ALocalPoint: TPlanePoint): Extended;
var
  X, Y: Double;
  X1, X2, Y1, Y2: Integer;
  V, V1, V2, V3, V4: Extended;
  A, A1, A2, A3, A4: Extended;
begin
  // Get local point coordinates
  X := ALocalPoint.X;
  Y := ALocalPoint.Y;
  // Get coordinates of a 2x2 pixel area with a local point in the top left pixel
  X1 := Trunc(X);
  Y1 := Trunc(Y);
  X2 := X1 + 1;
  Y2 := Y1 + 1;
  // Get values of 2x2 pixel area
  V1 := AContext.LocalRow1[X1 - AContext.LocalBound.Xmin];
  V2 := AContext.LocalRow1[IfThen(X2 <= AContext.LocalBound.Xmax, X2, AContext.LocalBound.Xmax) - AContext.LocalBound.Xmin];
  V3 := AContext.LocalRow2[X1 - AContext.LocalBound.Xmin];
  V4 := AContext.LocalRow2[IfThen(X2 <= AContext.LocalBound.Xmax, X2, AContext.LocalBound.Xmax) - AContext.LocalBound.Xmin];
  // Nearest neighbour of value
  if IsExtendedInfinite(V1) or IsExtendedInfinite(V2) or IsExtendedInfinite(V3) or IsExtendedInfinite(V4) then
  begin
    A1 := Sqrt(Sqr(X1 - X) + Sqr(Y1 - Y));
    A2 := Sqrt(Sqr(X2 - X) + Sqr(Y1 - Y));
    A3 := Sqrt(Sqr(X1 - X) + Sqr(Y2 - Y));
    A4 := Sqrt(Sqr(X2 - X) + Sqr(Y2 - Y));
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
  end else
  // Bilinear interpolation of value
  begin
    A1 := (X2 - X) * (Y2 - Y);
    A2 := (X - X1) * (Y2 - Y);
    A3 := (X2 - X) * (Y - Y1);
    A4 := (X - X1) * (Y - Y1);
    V := V1 * A1 + V2 * A2 + V3 * A3 + V4 * A4;
  end;
{$IFDEF DELAFITS_ROUND_RENDER}
  if not IsExtendedInfinite(V) then
    V := DeLaFitsMath.FixedRound(V);
{$ENDIF}
  Result := V;
end;

function TFitsFrame.CalcRasterCell(const AContext: TRasterContext; const AScenePixel: TPlanePixel): TPaletteRasterCell;
begin
  // Calculate the position of a scene pixel in a raster array
  Result.X := AScenePixel.X - AContext.SceneBound.Xmin;
  Result.Y := AScenePixel.Y - AContext.SceneBound.Ymin;
end;

procedure TFitsFrame.SetRasterPixels(const AContext: TRasterContext; var ARaster: TPaletteRaster);

  function SetRasterPixel(ASceneX, ASceneY: Integer): Boolean;
  var
    LLocalPoint: TPlanePoint;
    LRasterValue: Extended;
    LRasterCell: TPaletteRasterCell;
  begin
    LLocalPoint := FGeometry.ScenePointToLocalPoint(ToPoint(ASceneX, ASceneY));
    // Check if the point is within local rows
    if (Trunc(LLocalPoint.Y) = AContext.LocalOrigin.Y) and
       (LLocalPoint.X >= AContext.LocalBound.Xmin) and
       (LLocalPoint.X <= AContext.LocalBound.Xmax) then
    begin
      LRasterValue := CalcRasterValue(AContext, LLocalPoint);
      LRasterCell := CalcRasterCell(AContext, ToPixel(ASceneX, ASceneY));
      // Set raster pixel
      ARaster[LRasterCell.X, LRasterCell.Y] := BandIndexOf(LRasterValue);
      Result := True;
    end else
      Result := False;
  end;

var
  LSceneX, LSceneY: Integer;
  LSceneLoop: record
    Xmin, Xmax: Integer;
    Ymin, Ymax: Integer;
  end;
  A1, A2, B1, B2: TPlanePoint;
  C, C1, C2, C3, C4: Double;
begin
  // Get range of loop by scene
  LSceneLoop.Xmin := AContext.SceneOrigin.X;
  LSceneLoop.Ymin := AContext.SceneOrigin.Y;
  LSceneLoop.Xmax := AContext.SceneBound.Xmax;
  LSceneLoop.Ymax := AContext.SceneBound.Ymax;
  // Calculate the orientation of the Local Coordinate System relative to
  // the Scene Coordinates System, see "resource/renderscene" for details
  A1 := FGeometry.LocalPointToScenePoint(ToPoint(-1.0,  AContext.LocalOrigin.Y + 0));
  A2 := FGeometry.LocalPointToScenePoint(ToPoint(Width, AContext.LocalOrigin.Y + 0));
  B1 := FGeometry.LocalPointToScenePoint(ToPoint(-1.0,  AContext.LocalOrigin.Y + 1));
  B2 := FGeometry.LocalPointToScenePoint(ToPoint(Width, AContext.LocalOrigin.Y + 1));
  // Local y-axis is parallel to scene y-axis
  if IsZero(A2.Y - A1.Y) or IsZero(B2.Y - B1.Y) then
  begin
    for LSceneY := LSceneLoop.Ymin to LSceneLoop.Ymax do
    for LSceneX := LSceneLoop.Xmin to LSceneLoop.Xmax do
      if not SetRasterPixel(LSceneX, LSceneY) then
        Exit;
  end else
  // Local y-axis is orthogonal to scene y-axis
  if IsZero(A2.X - A1.X) or IsZero(B2.X - B1.X) then
  begin
    for LSceneX := LSceneLoop.Xmin to LSceneLoop.Xmax do
    for LSceneY := LSceneLoop.Ymin to LSceneLoop.Ymax do
      if not SetRasterPixel(LSceneX, LSceneY) then
        Exit;
  end else
  // Local y-axis intersects scene y-axis: fix range of loop by scene
  begin
    C1 := XIntersection(A1, A2, (AContext.SceneBound.Xmin - 1)).Y;
    C2 := XIntersection(A1, A2, (AContext.SceneBound.Xmax + 1)).Y;
    C3 := XIntersection(B1, B2, (AContext.SceneBound.Xmin - 1)).Y;
    C4 := XIntersection(B1, B2, (AContext.SceneBound.Xmax + 1)).Y;
    C := MaxValue([C1, C2, C3, C4]) + 1.0;
    LSceneLoop.Ymax := IfThen(C > AContext.SceneBound.Ymax, AContext.SceneBound.Ymax, Trunc(C));
    for LSceneY := LSceneLoop.Ymin to LSceneLoop.Ymax do
    begin
      C1 := YIntersection(A1, A2, (LSceneY - 1)).X;
      C2 := YIntersection(A1, A2, (LSceneY + 1)).X;
      C3 := YIntersection(B1, B2, (LSceneY - 1)).X;
      C4 := YIntersection(B1, B2, (LSceneY + 1)).X;
      C := MinValue([C1, C2, C3, C4]) + 0.0;
      if C < AContext.SceneBound.Xmin then
        LSceneLoop.Xmin := AContext.SceneBound.Xmin
      else if C > AContext.SceneBound.Xmax then
        LSceneLoop.Xmin := AContext.SceneBound.Xmin
      else
        LSceneLoop.Xmin := Trunc(C);
      C := MaxValue([C1, C2, C3, C4]) + 1.0;
      if C > AContext.SceneBound.Xmax then
        LSceneLoop.Xmax := AContext.SceneBound.Xmax
      else if C < AContext.SceneBound.Xmin then
        LSceneLoop.Xmax := AContext.SceneBound.Xmax
      else
        LSceneLoop.Xmax := Trunc(C);
      for LSceneX := LSceneLoop.Xmin to LSceneLoop.Xmax do
        SetRasterPixel(LSceneX, LSceneY);
    end;
  end;
end;

procedure TFitsFrame.RenderRaster(const ASceneRegion: TRegion; var ARaster: TPaletteRaster);
var
  LContext: TRasterContext;
  LSceneX, LSceneY: Integer;
begin
  // Prepare and fill raster with the zero values, i.e. the value of the index-black
  AllocateRaster({var} ARaster, ASceneRegion.Width, ASceneRegion.Height);
  FillRaster({var} ARaster, ASceneRegion.Width, ASceneRegion.Height, {AValue:} 0);
  // Create the context of the raster rendering. Check the intersection of
  // the custom scene region with the real region. Calculate all pixels of
  // the raster by iterating on the real region of the scene. The method
  // optimizes reading of physical values: if a scene pixel is identified
  // with a real local pixel, then an array of physical values (two local
  // rows) is read and processed based on such a local pixel (local origin)
  LContext := CreateRasterContext;
  if FindRasterBound({var} LContext, ASceneRegion) then
  begin
    MakeBand;
    PrepareRasterBuffer({var} LContext);
    for LSceneY := LContext.SceneBound.Ymin to LContext.SceneBound.Ymax do
    for LSceneX := LContext.SceneBound.Xmin to LContext.SceneBound.Xmax do
      if CaptureRasterOrigin({var} LContext, ToPixel(LSceneX, LSceneY)) then
      begin
        ReadRasterValues({var} LContext);
        SetRasterPixels(LContext, {var} ARaster);
      end;
  end;
end;

procedure TFitsFrame.RenderScene(const ASceneRegion: TRegion; var APalette: TPaletteTuples; var ARaster: TPaletteRaster);
begin
  if (ASceneRegion.Width <= 0) or (ASceneRegion.Height <= 0) then
    Error(SFrameInvalidRenderRegion, [ASceneRegion.X1, ASceneRegion.Y1,
      ASceneRegion.Width, ASceneRegion.Height], ERROR_FRAME_RENDERSCENE_REGION);
  RenderPalette({var} APalette);
  RenderRaster(ASceneRegion, {var} ARaster);
end;

procedure TFitsFrame.SetBitmapFormat(ABitmap: TBitmap);
const
{$IFDEF DCC}
  cSupportPixelFormat: array [1 .. 3] of TPixelFormat = (pf8bit, pf24bit, pf32bit);
{$ENDIF}
{$IFDEF FPC}
  cSupportPixelFormat: array [1 .. 1] of TPixelFormat = (pf24bit);
{$ENDIF}
  cDefaultPixelFormat = pf24bit;
var
  LIndex: Integer;
begin
  for LIndex := Low(cSupportPixelFormat) to High(cSupportPixelFormat) do
    if ABitmap.PixelFormat = cSupportPixelFormat[LIndex] then
      Exit;
  ABitmap.PixelFormat := cDefaultPixelFormat;
end;

procedure TFitsFrame.SetBitmapSize(ABitmap: TBitmap; const ASceneRegion: TRegion);
begin
{$IFDEF DCC}
  ABitmap.Width := ASceneRegion.Width;
  ABitmap.Height := ASceneRegion.Height;
{$ENDIF}
{$IFDEF FPC}
  ABitmap.SetSize(ASceneRegion.Width, ASceneRegion.Height);
{$ENDIF}
end;

procedure TFitsFrame.SetBitmapPalette(ABitmap: TBitmap; const APalette: TPaletteTuples);
{$IFDEF DCC}
const
  cSizePalette = SizeOf(TLogPalette) + SizeOf(TPaletteEntry) * cPaletteCount;
var
  LIndex: Integer;
  LPalette: PLogPalette;
begin
  if ABitmap.PixelFormat = pf8bit then
  begin
    if ABitmap.Palette <> 0 then
      DeleteObject(ABitmap.Palette);
    GetMem(LPalette, cSizePalette);
    LPalette^.palNumEntries := cPaletteCount;
    LPalette^.palVersion := $300;
{$IFDEF HAS_RANGE_CHECK}
  {$R-}
{$ENDIF}
    for LIndex := 0 to cPaletteCount - 1 do
      with LPalette^.palPalEntry[LIndex], APalette[LIndex] do
      begin
        peRed := R;
        peGreen := G;
        peBlue := B;
        peFlags := PC_NOCOLLAPSE;
      end;
{$IFDEF HAS_RANGE_CHECK}
  {$R+}
{$ENDIF}
    ABitmap.Palette := CreatePalette(LPalette^);
    FreeMem(LPalette, cSizePalette);
  end;
end;
{$ENDIF}
{$IFDEF FPC}
begin
  // Palette is not supported in Lazarus
  if Assigned(ABitmap) and (Length(APalette) > 0) then
    ;
end;
{$ENDIF}

procedure TFitsFrame.SetBitmapRaster(ABitmap: TBitmap; const APalette: TPaletteTuples; const ARaster: TPaletteRaster);
{$IFDEF DCC}
type
  TLine08Entry = Byte;
  TLine08 = array [0 .. 0] of TLine08Entry;
  PLine08 = ^TLine08;
  TLine24Entry = packed record
    iB, iG, iR: Byte;
  end;
  TLine24 = array [0 .. 0] of TLine24Entry;
  PLine24 = ^TLine24;
  TLine32Entry = packed record
    iB, iG, iR, iReserved: Byte;
  end;
  TLine32 = array [0 .. 0] of TLine32Entry;
  PLine32 = ^TLine32;
var
  X, Y, LIndex, LWidth, LHeight: Integer;
  LLine08: PLine08;
  LLine24: PLine24;
  LLine32: PLine32;
begin
{$IFDEF HAS_RANGE_CHECK}
  {$R-}
{$ENDIF}
  LWidth := ABitmap.Width;
  LHeight := ABitmap.Height;
  case ABitmap.PixelFormat of
    pf8bit:
      for Y := 0 to LHeight - 1 do
      begin
        LLine08 := ABitmap.ScanLine[Y];
        for X := 0 to LWidth - 1 do
          LLine08^[X] := ARaster[X, Y];
      end;
    pf24bit:
      for Y := 0 to LHeight - 1 do
      begin
        LLine24 := ABitmap.ScanLine[Y];
        for X := 0 to LWidth - 1 do
        begin
          LIndex := ARaster[X, Y];
          with LLine24^[X], APalette[LIndex] do
          begin
            iB := B;
            iG := G;
            iR := R;
          end;
        end;
      end;
    pf32bit:
      for Y := 0 to LHeight - 1 do
      begin
        LLine32 := ABitmap.ScanLine[Y];
        for X := 0 to LWidth - 1 do
        begin
          LIndex := ARaster[X, Y];
          with LLine32^[X], APalette[LIndex] do
          begin
            iB := B;
            iG := G;
            iR := R;
            iReserved := $00;
          end;
        end;
      end;
  end;
{$IFDEF HAS_RANGE_CHECK}
  {$R+}
{$ENDIF}
end;
{$ENDIF}
{$IFDEF FPC}
type
  TLine24Entry = packed record
    iB, iG, iR: Byte;
  end;
  PLine24Entry = ^TLine24Entry;
var
  X, Y, LIndex, LWidth, LHeight: Integer;
  LLine24Entry: PLine24Entry;
  LGrowLine, LGrowPixel: Integer;
begin
{$IFDEF HAS_RANGE_CHECK}
  {$R-}
{$ENDIF}
LWidth := ABitmap.Width;
LHeight := ABitmap.Height;
LGrowLine := ABitmap.RawImage.Description.BytesPerLine;
LGrowPixel := ABitmap.RawImage.Description.BitsPerPixel div 8;
for Y := 0 to LHeight - 1 do
begin;
  LLine24Entry := PLine24Entry(ABitmap.RawImage.Data);
  Inc(PByte(LLine24Entry), LGrowLine * Y);
  for X := 0 to LWidth - 1 do
  begin
    LIndex := ARaster[X, Y];
    with LLine24Entry^, APalette[LIndex] do
    begin
      iB := B;
      iG := G;
      iR := R;
    end;
    Inc(PByte(LLine24Entry), LGrowPixel);
  end;
end;
{$IFDEF HAS_RANGE_CHECK}
  {$R+}
{$ENDIF}
end;
{$ENDIF}

procedure TFitsFrame.RenderScene(const ASceneRegion: TRegion; var ABitmap: TBitmap);
var
  LPalette: TPaletteTuples;
  LRaster: TPaletteRaster;
begin
  if (ASceneRegion.Width <= 0) or (ASceneRegion.Height <= 0) then
    Error(SFrameInvalidRenderRegion, [ASceneRegion.X1, ASceneRegion.Y1,
      ASceneRegion.Width, ASceneRegion.Height], ERROR_FRAME_RENDERSCENE_REGION);
  if not Assigned(ABitmap) then
    Error(SBitmapNotAssigned, ERROR_FRAME_RENDERSCENE_NO_BITMAP);
  LPalette[0].R := 0;
  LPalette[0].G := 0;
  LPalette[0].B := 0;
  Picture.Container.Memory.Allocate({out} LRaster, ASceneRegion.Width, ASceneRegion.Height);
  RenderScene(ASceneRegion, {var} LPalette, {var} LRaster);
{$IFDEF DCC}
  SetBitmapFormat(ABitmap);
  SetBitmapSize(ABitmap, ASceneRegion);
  SetBitmapPalette(ABitmap, LPalette);
  SetBitmapRaster(ABitmap, LPalette, LRaster);
{$ENDIF}
{$IFDEF FPC}
  ABitmap.BeginUpdate();
  try
    SetBitmapFormat(ABitmap);
    SetBitmapSize(ABitmap, ASceneRegion);
    SetBitmapPalette(ABitmap, LPalette);
    SetBitmapRaster(ABitmap, LPalette, LRaster);
  finally
    ABitmap.EndUpdate();
  end;
{$ENDIF}
end;

end.
