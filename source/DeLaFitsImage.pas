{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{               Standard IMAGE extension               }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsImage;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Classes, Math, DeLaFitsCommon, DeLaFitsMath, DeLaFitsClasses,
  DeLaFitsNumed;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_IMAGE                        = 5000;

  ERROR_IMAGE_SPEC_INVALID           = 5100;
  ERROR_IMAGE_SPEC_BITBIX            = 5101;
  ERROR_IMAGE_SPEC_AXIS              = 5102;
  ERROR_IMAGE_SPEC_AXES              = 5103;
  ERROR_IMAGE_SPEC_INDEX             = 5104;
  ERROR_IMAGE_SPEC_SCAL              = 5105;
  ERROR_IMAGE_SPEC_ZERO              = 5106;
  ERROR_IMAGE_SPEC_UMIT              = 5107;

  ERROR_IMAGE_HEAD_INCORRECT_NAME    = 5200;
  ERROR_IMAGE_HEAD_INCORRECT_NAXISN  = 5201;

  ERROR_IMAGE_DATA_GETELEMS_INDEX    = 5300;
  ERROR_IMAGE_DATA_SETELEMS_INDEX    = 5301;
  ERROR_IMAGE_DATA_ALLOWREAD_INDEX   = 5302;
  ERROR_IMAGE_DATA_ALLOWREAD_COUNT   = 5303;
  ERROR_IMAGE_DATA_ALLOWREAD_LENGTH  = 5304;
  ERROR_IMAGE_DATA_ALLOWWRITE_INDEX  = 5305;
  ERROR_IMAGE_DATA_ALLOWWRITE_COUNT  = 5306;
  ERROR_IMAGE_DATA_ALLOWWRITE_LENGTH = 5307;

resourcestring

  { The messages of exceptions }

  SImageSpecInvalid         = 'Invalid IMAGE specification';
  SImageSpecIncorrectValue  = 'Incorrect "%s" value of IMAGE specification';

  SImageHeadIncorrectValue  = 'Incorrect "%s" value of IMAGE[%d] header';

  SImageDataIncorrectIndex  = 'Incorrect Index "%d" to IMAGE[%d] data access';
  SImageDataIncorrectCount  = 'Incorrect Count "%d" to IMAGE[%d] data access';
  SImageDataIncorrectLength = 'Incorrect length array of Elements "%d" to IMAGE[%d] data access';

type

  { Exception classes }

  EFitsImageException = class(EFitsClassesException);

type

  { Standard IMAGE extension }

  TFitsImage = class;

  TFitsImageSpec = class(TFitsUmitSpec)
  private
    FBitPix: TBitPix;
    FAxes: array of Integer;
    FScal: Extended;
    FZero: Extended;
    procedure SetBitPix(const Value: TBitPix);
    function GetAxis: Integer;
    procedure SetAxis(const Value: Integer);
    function GetAxes(Index: Integer): Integer;
    procedure SetAxes(Index: Integer; const Value: Integer);
    procedure SetScal(const Value: Extended);
    procedure SetZero(const Value: Extended);
    function GetBSCALE: Extended;
    function GetBZERO: Extended;
    function GetGCOUNT: Integer;
    function GetNAXES(Number: Integer): Integer;
    function GetNAXIS: Integer;
    function GetPCOUNT: Integer;
  public
    constructor Create(ABitPix: TBitPix; const AAxes: array of Integer; const AScal: Extended = 1.0; const AZero: Extended = 0.0); overload;
    constructor Create(AUmit: TFitsImage); overload;
    constructor Create; overload;
    destructor Destroy; override;
    property BitPix: TBitPix read FBitPix write SetBitPix;
    property Axis: Integer read GetAxis write SetAxis;
    property Axes[Index: Integer]: Integer read GetAxes write SetAxes;
    property Scal: Extended read FScal write SetScal;
    property Zero: Extended read FZero write SetZero;
    // keywords terminology
    property NAXIS: Integer read GetNAXIS;
    property NAXES[Number: Integer]: Integer read GetNAXES;
    property GCOUNT: Integer read GetGCOUNT;
    property PCOUNT: Integer read GetPCOUNT;
    property BSCALE: Extended read GetBSCALE;
    property BZERO: Extended read GetBZERO;
  end;

  TFitsImageHead = class(TFitsUmitHead)
  private
    function GetUmit: TFitsImage;
  public
    constructor CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean); override;
    constructor CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec); override;
    property Umit: TFitsImage read GetUmit;
  end;

  TFitsImageData = class(TFitsUmitData)

  private

    function GetUmit: TFitsImage;
    function GetEditor: TEditor;
    function AllowRead(const AIndex, ACount, ACountElems: Int64): Boolean;
    function AllowWrite(const AIndex, ACount, ACountElems: Int64): Boolean;
    function GetElems(Index: Int64): Extended;
    procedure SetElems(Index: Int64; const Value: Extended);
    function GetRepPix: TRepNumber;
    function GetScal: Extended;
    function GetZero: Extended;
    function GetCount: Int64;

  public

    constructor CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean); override;
    constructor CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec); override;

    property Umit: TFitsImage read GetUmit;

    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA80f); overload;
    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA64f); overload;
    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA32f); overload;
    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA08c); overload;
    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA08u); overload;
    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA16c); overload;
    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA16u); overload;
    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA32c); overload;
    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA32u); overload;
    procedure ReadElems(const AIndex, ACount: Int64; var AElems: TA64c); overload;

    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA80f); overload;
    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA64f); overload;
    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA32f); overload;
    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA08c); overload;
    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA08u); overload;
    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA16c); overload;
    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA16u); overload;
    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA32c); overload;
    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA32u); overload;
    procedure WriteElems(const AIndex, ACount: Int64; const AElems: TA64c); overload;

    property Elems[Index: Int64]: Extended read GetElems write SetElems;

    property Count: Int64 read GetCount;

    property RepPix: TRepNumber read GetRepPix;

    property Scal: Extended read GetScal;
    property Zero: Extended read GetZero;

  end;

  TFitsImage = class(TFitsUmit)
  private
    function GetHead: TFitsImageHead;
    function GetData: TFitsImageData;
    function GetBSCALE: Extended;
    function GetBZERO: Extended;
  protected
    function GetHeadClass: TFitsUmitHeadClass; override;
    function GetDataClass: TFitsUmitDataClass; override;
    function GetStateFamily: string; override;
  public
    constructor CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean); override;
    constructor CreateNewcomer(AContainer: TFitsContainer; ASpec: TFitsUmitSpec); override;
    property Head: TFitsImageHead read GetHead;
    property Data: TFitsImageData read GetData;
    property BSCALE: Extended read GetBSCALE;
    property BZERO: Extended read GetBZERO;
  end;

implementation

type

  TScaleNumber = (scOne, scOff, scInt, scExt);

function ScaleNumber(BitPix: TBitPix; const Scal, Zero: Extended): TScaleNumber; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  if (Scal = 1.0) and (Zero = 0.0) then
    Result := scOne
  else if (BitPix = bi08u) and (Scal = 1.0) and (Zero = cZero08c) then
    Result := scOff
  else if (BitPix = bi16c) and (Scal = 1.0) and (Zero = cZero16u) then
    Result := scOff
  else if (BitPix = bi32c) and (Scal = 1.0) and (Zero = cZero32u) then
    Result := scOff
  else if (BitPix >= bi08u) and (Frac(Scal) = 0.0) and (Frac(Zero) = 0.0) then
    Result := scInt
  else
    Result := scExt;
end;

{ TFitsImageSpec }

function TFitsImageSpec.GetAxis: Integer;
begin
  Result := Length(FAxes);
end;

function TFitsImageSpec.GetBSCALE: Extended;
begin
  Result := Self.Scal;
end;

function TFitsImageSpec.GetBZERO: Extended;
begin
  Result := Self.Zero;
end;

function TFitsImageSpec.GetGCOUNT: Integer;
begin
  Result := 1;
end;

function TFitsImageSpec.GetNAXES(Number: Integer): Integer;
begin
  Result := Self.Axes[Number - 1];
end;

function TFitsImageSpec.GetNAXIS: Integer;
begin
  Result := Self.Axis;
end;

function TFitsImageSpec.GetPCOUNT: Integer;
begin
  Result := 0;
end;

procedure TFitsImageSpec.SetAxis(const Value: Integer);
var
  I: Integer;
begin
  if Value > cMaxAxis then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Axis'], ERROR_IMAGE_SPEC_AXIS);
  if Value < 1 then
  begin
    FAxes := nil;
  end
  else
  begin
    SetLength(FAxes, Value);
    for I := 0 to Value - 1 do
      FAxes[I] := 1;
  end;
end;

function TFitsImageSpec.GetAxes(Index: Integer): Integer;
begin
  if (Index < 0) or (Index >= Axis) then
    raise EFitsImageException.CreateFmt(SListIndexOutBounds, [Index], ERROR_IMAGE_SPEC_INDEX);
  Result := FAxes[Index];
end;

procedure TFitsImageSpec.SetAxes(Index: Integer; const Value: Integer);
begin
  if (Index < 0) or (Index >= Axis) then
    raise EFitsImageException.CreateFmt(SListIndexOutBounds, [Index], ERROR_IMAGE_SPEC_INDEX);
  if Value < 1 then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Axes'], ERROR_IMAGE_SPEC_AXES);
  FAxes[Index] := Value;
end;

procedure TFitsImageSpec.SetBitPix(const Value: TBitPix);
begin
  if Value = biUnknown then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['BitPix'], ERROR_IMAGE_SPEC_BITBIX);
  FBitPix := Value;
end;

procedure TFitsImageSpec.SetScal(const Value: Extended);
begin
  if Math.IsNan(Value) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Scal'], ERROR_IMAGE_SPEC_SCAL);
  if Math.IsInfinite(Value) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Scal'], ERROR_IMAGE_SPEC_SCAL);
  if Math.SameValue(Value, 0.0) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Scal'], ERROR_IMAGE_SPEC_SCAL);
  FScal := Value;
end;

procedure TFitsImageSpec.SetZero(const Value: Extended);
begin
  if Math.IsNan(Value) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Zero'], ERROR_IMAGE_SPEC_ZERO);
  if Math.IsInfinite(Value) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Zero'], ERROR_IMAGE_SPEC_ZERO);
  FZero := Value;
end;

constructor TFitsImageSpec.Create(ABitPix: TBitPix; const AAxes: array of Integer; const AScal, AZero: Extended);
var
  I: Integer;
begin
  inherited Create;
  BitPix := ABitPix;
  Axis := Length(AAxes);
  for I := Low(AAxes) to High(AAxes) do
    Axes[I] := AAxes[I];
  Scal := AScal;
  Zero := AZero;
end;

constructor TFitsImageSpec.Create(AUmit: TFitsImage);
var
  I: Integer;
begin
  inherited Create;
  if not Assigned(AUmit) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Umit'], ERROR_IMAGE_SPEC_UMIT);
  BitPix := AUmit.Data.BitPix;
  Axis := AUmit.Data.Axis;
  for I := 0 to Axis - 1 do
    Axes[I] := AUmit.Data.Axes[I];
  Scal := AUmit.Data.Scal;
  Zero := AUmit.Data.Zero;
end;

constructor TFitsImageSpec.Create;
begin
  inherited Create;
  BitPix := bi08u;
  Axis   := 0;
  Scal   := 1.0;
  Zero   := 0.0;
end;

destructor TFitsImageSpec.Destroy;
begin
  FAxes := nil;
  inherited;
end;

{ TFitsImageHead }

constructor TFitsImageHead.CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean);
var
  Number: Integer;
  Keyword: string;
begin
  inherited;

  // check required cards

  if Umit.Family <> Umit.StateFamily then
    raise EFitsImageException.CreateFmt(SImageHeadIncorrectValue, [cXTENSION, Umit.Index], ERROR_IMAGE_HEAD_INCORRECT_NAME);

  for Number := 1 to Umit.NAXIS do
    if Umit.NAXES[Number] <= 0 then
    begin
      Keyword := Format(cNAXISn, [Number]);
      raise EFitsImageException.CreateFmt(SImageHeadIncorrectValue, [Keyword, Umit.Index], ERROR_IMAGE_HEAD_INCORRECT_NAXISN);
    end;
end;

constructor TFitsImageHead.CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec);
var
  Spec: TFitsImageSpec;
  Number, Hop: Integer;
begin
  inherited;

  // add spec fields

  Spec := ASpec as TFitsImageSpec;

  AppendInteger(cBITPIX, BitPixToInt(Spec.BitPix), 'Number of bits per data value');
  Hop := AppendInteger(cNAXIS, Spec.NAXIS, 'Number of axes') + 1;
  for Number := 1 to Spec.NAXIS do
    Hop := AppendInteger(Format(cNAXISn, [Number]), Spec.NAXES[Number], '', Hop) + 1;

  AppendFloat(cBSCALE, Spec.BSCALE, 'Linear factor in scaling equation');
  AppendFloat(cBZERO, Spec.BZERO, 'Zero point in scaling equation');
end;

function TFitsImageHead.GetUmit: TFitsImage;
begin
  Result := inherited Umit as TFitsImage;
end;

{ TFitsImageData }

function TFitsImageData.AllowRead(const AIndex, ACount, ACountElems: Int64): Boolean;
var
  CountPixs: Int64;
begin
  CountPixs := Count;
  if (AIndex < 0) or (AIndex >= CountPixs) then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectIndex, [AIndex, Umit.Index], ERROR_IMAGE_DATA_ALLOWREAD_INDEX);
  if (ACount < 0) or (AIndex + ACount > CountPixs) then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectCount, [ACount, Umit.Index], ERROR_IMAGE_DATA_ALLOWREAD_COUNT);
  if ACountElems < ACount then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectLength, [ACountElems, Umit.Index], ERROR_IMAGE_DATA_ALLOWREAD_LENGTH);
  Result := ACount > 0;
end;

function TFitsImageData.AllowWrite(const AIndex, ACount, ACountElems: Int64): Boolean;
var
  CountPixs: Int64;
begin
  CountPixs := Count;
  if (AIndex < 0) or (AIndex >= CountPixs) then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectIndex, [AIndex, Umit.Index], ERROR_IMAGE_DATA_ALLOWWRITE_INDEX);
  if (ACount < 0) or (AIndex + ACount > CountPixs) then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectCount, [ACount, Umit.Index], ERROR_IMAGE_DATA_ALLOWWRITE_COUNT);
  if ACountElems < ACount then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectLength, [ACountElems, Umit.Index], ERROR_IMAGE_DATA_ALLOWWRITE_LENGTH);
  Result := ACount > 0;
end;

constructor TFitsImageData.CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean);
begin
  inherited;
end;

constructor TFitsImageData.CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec);
var
  lCize, lSize: Int64;
begin

  inherited;

  // set true size

  lCize := Cize;
  lSize := Size;
  if lCize > lSize then
    Add(lCize - lSize)
  else if lCize < lSize then
    Truncate(lSize - lCize);

end;

function TFitsImageData.GetCount: Int64;
var
  Naxis, Number: Integer;
begin
  Naxis := Umit.NAXIS;
  Result := Math.IfThen(Naxis = 0, 0, 1);
  for Number := 1 to Naxis do
    Result := Result * Umit.NAXES[Number];
end;

function TFitsImageData.GetElems(Index: Int64): Extended;
var
  lBitPix: TBitPix;
  lSizPix: Integer;
  Uffset: Int64;
  Swapper: TSwapper;
  v64f: T64f;
  v32f: T32f;
  v08u: T08u;
  v16c: T16c;
  v32c: T32c;
  v64c: T64c;
begin
  if (Index < 0) or (Index >= Count) then
    raise EFitsImageException.CreateFmt(SListIndexOutBounds, [Index], ERROR_IMAGE_DATA_GETELEMS_INDEX);

  lBitPix := BitPix;
  lSizPix := BitPixSize(lBitPix);

  Uffset  := Index * lSizPix;
  Swapper := GetSwapper;
  case lBitPix of
    bi64f:
      begin
        v64f := 0.0;
        Read(Uffset, lSizPix, v64f);
        Result := Swapper.Swap64f(v64f) * Scal + Zero;
      end;
    bi32f:
      begin
        v32f := 0.0;
        Read(Uffset, lSizPix, v32f);
        Result := Swapper.Swap32f(v32f) * Scal + Zero;
      end;
    bi08u:
      begin
        v08u := 0;
        Read(Uffset, lSizPix, v08u);
        Result := v08u * Scal + Zero;
      end;
    bi16c:
      begin
        v16c := 0;
        Read(Uffset, lSizPix, v16c);
        Result := Swapper.Swap16c(v16c) * Scal + Zero;
      end;
    bi32c:
      begin
        v32c := 0;
        Read(Uffset, lSizPix, v32c);
        Result := Swapper.Swap32c(v32c) * Scal + Zero;
      end;
    bi64c:
      begin
        v64c := 0;
        Read(Uffset, lSizPix, v64c);
        Result := Swapper.Swap64c(v64c) * Scal + Zero;
      end;
    else
      Result := NaN;
  end;
end;

function TFitsImageData.GetUmit: TFitsImage;
begin
  Result := inherited Umit as TFitsImage;
end;

function TFitsImageData.GetZero: Extended;
begin
  Result := Umit.BZERO;
end;

function TFitsImageData.GetEditor: TEditor;
begin
  Result.BufferAllocate := {$IFDEF FPC}@{$ENDIF}Umit.Container.Content.Buffer.Allocate;
  Result.BufferRelease  := {$IFDEF FPC}@{$ENDIF}Umit.Container.Content.Buffer.Release;
  Result.DataRead       := {$IFDEF FPC}@{$ENDIF}Self.Read;
  Result.DataWrite      := {$IFDEF FPC}@{$ENDIF}Self.Write;
end;

function TFitsImageData.GetRepPix: TRepNumber;

  function Re(const Vmin, Vmax: Extended; const Reps: array of TRepNumber): TRepNumber;
  var
    I: Integer;
    R: TRepNumber;
  begin
    Result := repUnknown;
    for I := Low(Reps) to High(Reps) do
    begin
      R := Reps[I];
      if (Vmin >= GetMinNumber(R)) and (Vmax <= GetMaxNumber(R)) then
      begin
        Result := R;
        Break;
      end;
    end;
  end;

var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Bone, Boff, Bint: Boolean;
  lRepPix: TRepNumber;
  Vmin, Vmax: Extended;

begin
  lBitPix := Self.BitPix;
  lScal   := Self.Scal;
  lZero   := Self.Zero;

  Scale := ScaleNumber(lBitPix, lScal, lZero);
  Bone := Scale = scOne;
  Boff := Scale = scOff;
  Bint := Scale = scInt;

  lRepPix := BitPixToRep(lBitPix);
  Vmin := GetMinNumber(lRepPix) * lScal + lZero;
  Vmax := GetMaxNumber(lRepPix) * lScal + lZero;
  Extrema(Vmin, Vmax);

  Result := repUnknown;
  case lBitPix of
    bi64f:
      begin
        Result := rep64f;
      end;
    bi32f:
      begin
        if (Result = repUnknown) and Bone then
          Result := rep32f;
        if (Result = repUnknown) then
          Result := rep64f;
      end;
    bi08u:
      begin
        if (Result = repUnknown) and Bone then
          Result := rep08u;
        if (Result = repUnknown) and Boff then
          Result := rep08c;
        if (Result = repUnknown) and Bint then
          Result := Re(Vmin, Vmax, [rep16c, rep16u, rep32c, rep32u, rep64c]);
        if (Result = repUnknown) then
          Result := Re(Vmin, Vmax, [rep32f, rep64f]);
        if (Result = repUnknown) then
          Result := rep80f;
      end;
    bi16c:
      begin
        if (Result = repUnknown) and Bone then
          Result := rep16c;
        if (Result = repUnknown) and Boff then
          Result := rep16u;
        if (Result = repUnknown) and Bint then
          Result := Re(Vmin, Vmax, [rep32c, rep32u, rep64c]);
        if (Result = repUnknown) then
          Result := Re(Vmin, Vmax, [rep32f, rep64f]);
        if (Result = repUnknown) then
          Result := rep80f;
      end;
    bi32c:
      begin
        if (Result = repUnknown) and Bone then
          Result := rep32c;
        if (Result = repUnknown) and Boff then
          Result := rep32u;
        if (Result = repUnknown) and Bint then
          Result := Re(Vmin, Vmax, [rep64c]);
        if (Result = repUnknown) then
          Result := Re(Vmin, Vmax, [rep32f, rep64f]);
        if (Result = repUnknown) then
          Result := rep80f;
      end;
    bi64c:
      begin
        if (Result = repUnknown) and Bone then
          Result := rep64c;
        if (Result = repUnknown) and Bint then
          Result := rep64c;
        if (Result = repUnknown) then
          Result := Re(Vmin, Vmax, [rep32f, rep64f]);
        if (Result = repUnknown) then
          Result := rep80f;
      end;
  end;
end;

function TFitsImageData.GetScal: Extended;
begin
  Result := Umit.BSCALE;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA80f);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_80F(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_80F(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_80F(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_80F(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_80F(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_80F(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA64f);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_64F(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_64F(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_64F(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_64F(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_64F(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_64F(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA32f);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_32F(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_32F(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_32F(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_32F(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_32F(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_32F(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA08c);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_08C(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_08C(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_08C(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_08C(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_08C(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_08C(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA08u);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_08U(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_08U(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_08U(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_08U(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_08U(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_08U(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA16c);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_16C(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_16C(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_16C(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_16C(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_16C(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_16C(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA16u);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_16U(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_16U(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_16U(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_16U(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_16U(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_16U(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA32c);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_32C(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_32C(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_32C(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_32C(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_32C(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_32C(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA32u);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_32U(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_32U(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_32U(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_32U(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_32U(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_32U(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA64c);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_64C(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_64C(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_64C(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_64C(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_64C(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_64C(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.SetElems(Index: Int64; const Value: Extended);
var
  lBitPix: TBitPix;
  lSizPix: Integer;
  Valu: Extended;
  Uffset: Int64;
  Swapper: TSwapper;
  v64f: T64f;
  v32f: T32f;
  v08u: T08u;
  v16c: T16c;
  v32c: T32c;
  v64c: T64c;
begin
  if (Index < 0) or (Index >= Count) then
    raise EFitsImageException.CreateFmt(SListIndexOutBounds, [Index], ERROR_IMAGE_DATA_SETELEMS_INDEX);

  lBitPix := BitPix;
  lSizPix := BitPixSize(lBitPix);

  Valu := (Value - Zero) / Scal;
  Uffset := Index * lSizPix;
  Swapper := GetSwapper;
  case lBitPix of
    bi64f:
      begin
        v64f := Ensure64f(Valu);
        v64f := Swapper.Swap64f(v64f);
        Write(Uffset, lSizPix, v64f);
      end;
    bi32f:
      begin
        v32f := Ensure32f(Valu);
        v32f := Swapper.Swap32f(v32f);
        Write(Uffset, lSizPix, v32f);
      end;
    bi08u:
      begin
        v08u := Round08u(Valu);
        Write(Uffset, lSizPix, v08u);
      end;
    bi16c:
      begin
        v16c := Round16c(Valu);
        v16c := Swapper.Swap16c(v16c);
        Write(Uffset, lSizPix, v16c);
      end;
    bi32c:
      begin
        v32c := Round32c(Valu);
        v32c := Swapper.Swap32c(v32c);
        Write(Uffset, lSizPix, v32c);
      end;
    bi64c:
      begin
        v64c := Round64c(Valu);
        v64c := Swapper.Swap64c(v64c);
        Write(Uffset, lSizPix, v64c);
      end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA80f);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_80F(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_80F(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_80F(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_80F(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_80F(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_80F(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_80F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA64f);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_64F(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_64F(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_64F(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_64F(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_64F(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_64F(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_64F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA32f);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_32F(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_32F(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_32F(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_32F(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_32F(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_32F(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_32F(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA08c);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_08C(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_08C(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_08C(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_08C(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_08C(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_08C(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_08C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA08u);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_08U(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_08U(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_08U(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_08U(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_08U(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_08U(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_08U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA16c);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_16C(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_16C(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_16C(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_16C(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_16C(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_16C(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_16C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA16u);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_16U(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_16U(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_16U(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_16U(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_16U(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_16U(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_16U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA32c);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_32C(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_32C(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_32C(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_32C(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_32C(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_32C(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_32C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA32u);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_32U(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_32U(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_32U(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_32U(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_32U(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_32U(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_32U(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA64c);
var
  lBitPix: TBitPix;
  lScal, lZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;

  lBitPix := BitPix;
  lScal   := Scal;
  lZero   := Zero;

  Scale  := ScaleNumber(lBitPix, lScal, lZero);
  Editor := GetEditor;
  case lBitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_64C(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_64C(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_64C(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_64C(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_64C(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_64C(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_64C(Editor, lScal, lZero, AIndex, ACount, AElems);
    end;
  end;
end;

{ TFitsImage }

constructor TFitsImage.CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean);
begin
  inherited;
end;

constructor TFitsImage.CreateNewcomer(AContainer: TFitsContainer; ASpec: TFitsUmitSpec);
var
  Spec: TFitsImageSpec;
begin

  // set default spec

  if not Assigned(ASpec) then
  begin
    Spec := TFitsImageSpec.Create;
    try
      inherited CreateNewcomer(AContainer, Spec);
    finally
      Spec.Free;
    end
  end

  // check spec class

  else if not (ASpec is TFitsImageSpec) then
    raise EFitsImageException.Create(SImageSpecInvalid, ERROR_IMAGE_SPEC_INVALID)

  else
    inherited;

end;

function TFitsImage.GetBSCALE: Extended;
const
  Key = cBSCALE;
var
  Ind: Integer;
begin
  if not Assigned(Head) then
    raise EFitsImageException.Create(SHeadNotAssign, ERROR_UMIT_GETGCOUNT_NOHEAD);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := 1.0
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsImageException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETGCOUNT_INVALID);
  end;
end;

function TFitsImage.GetBZERO: Extended;
const
  Key = cBZERO;
var
  Ind: Integer;
begin
  if not Assigned(Head) then
    raise EFitsImageException.Create(SHeadNotAssign, ERROR_UMIT_GETGCOUNT_NOHEAD);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := 0.0
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsImageException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETGCOUNT_INVALID);
  end;
end;

function TFitsImage.GetData: TFitsImageData;
begin
  Result := inherited Data as TFitsImageData;
end;

function TFitsImage.GetDataClass: TFitsUmitDataClass;
begin
  Result := TFitsImageData;
end;

function TFitsImage.GetHead: TFitsImageHead;
begin
  Result := inherited Head as TFitsImageHead;
end;

function TFitsImage.GetHeadClass: TFitsUmitHeadClass;
begin
   Result := TFitsImageHead;
end;

function TFitsImage.GetStateFamily: string;
begin
  Result := 'IMAGE';
end;

end.
