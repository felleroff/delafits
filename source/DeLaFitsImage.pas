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
  ERROR_IMAGE_SPEC_NAXIS             = 5102;
  ERROR_IMAGE_SPEC_NAXES             = 5103;
  ERROR_IMAGE_SPEC_NUMBER            = 5104;
  ERROR_IMAGE_SPEC_BSCALE            = 5105;
  ERROR_IMAGE_SPEC_BZERO             = 5106;
  ERROR_IMAGE_SPEC_ITEM              = 5107;

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

  TFitsImageSpec = class(TFitsItemSpec)
  private
    FBitPix: TBitPix;
    FNaxes: array of Integer;
    FBScale: Extended;
    FBZero: Extended;
    procedure SetBitPix(const Value: TBitPix);
    function GetNaxis: Integer;
    procedure SetNaxis(const Value: Integer);
    function GetNaxes(Number: Integer): Integer;
    procedure SetNaxes(Number: Integer; const Value: Integer);
    procedure SetBScale(const Value: Extended);
    procedure SetBZero(const Value: Extended);
  public
    constructor Create(ABitPix: TBitPix; const ANaxes: array of Integer; const ABScale: Extended = 1.0; const ABZero: Extended = 0.0); overload;
    constructor Create(AItem: TFitsImage); overload;
    constructor Create; overload;
    destructor Destroy; override;
    property BitPix: TBitPix read FBitPix write SetBitPix;
    property Naxis: Integer read GetNaxis write SetNaxis;
    property Naxes[Number: Integer]: Integer read GetNaxes write SetNaxes;
    property BScale: Extended read FBScale write SetBScale;
    property BZero: Extended read FBZero write SetBZero;
  end;

  TFitsImageHead = class(TFitsItemHead)
  private
    function AppendInteger(Keyword: string; Value: Int64; Note: string): Integer;
    function AppendFloat(Keyword: string; Value: Extended; Note: string): Integer;
    function GetItem: TFitsImage;
  public
    constructor CreateExplorer(AItem: TFitsItem; APioneer: Boolean); override;
    constructor CreateNewcomer(AItem: TFitsItem; ASpec: TFitsItemSpec); override;
    property Item: TFitsImage read GetItem;
  end;

  TFitsImageData = class(TFitsItemData)

  private

    function GetEditor: TEditor;
    function AllowRead(const AIndex, ACount, ACountElems: Int64): Boolean;
    function AllowWrite(const AIndex, ACount, ACountElems: Int64): Boolean;
    function GetElems(Index: Int64): Extended;
    procedure SetElems(Index: Int64; const Value: Extended);
    function GetRep: TRepNumber;
    function GetCount: Int64;
    function GetItem: TFitsImage;

  public

    constructor CreateNewcomer(AItem: TFitsItem; ASpec: TFitsItemSpec); override;

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

    property Rep: TRepNumber read GetRep;
    property Count: Int64 read GetCount;
    property Item: TFitsImage read GetItem;

  end;

  TFitsImage = class(TFitsItem)
  private
    function GetHead: TFitsImageHead;
    function GetData: TFitsImageData;
    function GetBScale: Extended;
    function GetBZero: Extended;
  protected
    function GetHeadClass: TFitsItemHeadClass; override;
    function GetDataClass: TFitsItemDataClass; override;
    function GetNamex: string; override;
  public
    constructor CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean); override;
    constructor CreateNewcomer(AContainer: TFitsContainer; ASpec: TFitsItemSpec); override;
    property Head: TFitsImageHead read GetHead;
    property Data: TFitsImageData read GetData;
    property BScale: Extended read GetBScale;
    property BZero: Extended read GetBZero;
  end;

implementation

type

  TScaleNumber = (scOne, scOff, scInt, scExt);

function ScaleNumber(BitPix: TBitPix; const BScale, BZero: Extended): TScaleNumber; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  if (BScale = 1.0) and (BZero = 0.0) then
    Result := scOne
  else if (BitPix = bi08u) and (BScale = 1.0) and (BZero = cBZero08c) then
    Result := scOff
  else if (BitPix = bi16c) and (BScale = 1.0) and (BZero = cBZero16u) then
    Result := scOff
  else if (BitPix = bi32c) and (BScale = 1.0) and (BZero = cBZero32u) then
    Result := scOff
  else if (BitPix >= bi08u) and (Frac(BScale) = 0.0) and (Frac(BZero) = 0.0) then
    Result := scInt
  else
    Result := scExt;
end;

{ TFitsImageSpec }

function TFitsImageSpec.GetNaxis: Integer;
begin
  Result := Length(FNaxes);
end;

procedure TFitsImageSpec.SetNaxis(const Value: Integer);
var
  I: Integer;
begin
  if Value > cMaxNaxis then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Naxis'], ERROR_IMAGE_SPEC_NAXIS);
  if Value < 1 then
  begin
    FNaxes := nil;
  end
  else
  begin
    SetLength(FNaxes, Value);
    for I := 0 to Value - 1 do
      FNaxes[I] := 1;
  end;
end;

function TFitsImageSpec.GetNaxes(Number: Integer): Integer;
begin
  if (Number < 1) or (Number > Naxis) then
    raise EFitsImageException.CreateFmt(SListIndexOutBounds, [Number], ERROR_IMAGE_SPEC_NUMBER);
  Result := FNaxes[Number - 1];
end;

procedure TFitsImageSpec.SetNaxes(Number: Integer; const Value: Integer);
begin
  if (Number < 1) or (Number > Naxis) then
    raise EFitsImageException.CreateFmt(SListIndexOutBounds, [Number], ERROR_IMAGE_SPEC_NUMBER);
  if Value < 1 then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Naxes'], ERROR_IMAGE_SPEC_NAXES);
  FNaxes[Number - 1] := Value;
end;

procedure TFitsImageSpec.SetBitPix(const Value: TBitPix);
begin
  if Value = biUnknown then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['BitPix'], ERROR_IMAGE_SPEC_BITBIX);
  FBitPix := Value;
end;

procedure TFitsImageSpec.SetBScale(const Value: Extended);
begin
  if Math.IsNan(Value) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['BScale'], ERROR_IMAGE_SPEC_BSCALE);
  if Math.IsInfinite(Value) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['BScale'], ERROR_IMAGE_SPEC_BSCALE);
  if Math.SameValue(Value, 0.0) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['BScale'], ERROR_IMAGE_SPEC_BSCALE);
  FBScale := Value;
end;

procedure TFitsImageSpec.SetBZero(const Value: Extended);
begin
  if Math.IsNan(Value) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['BZero'], ERROR_IMAGE_SPEC_BZERO);
  if Math.IsInfinite(Value) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['BZero'], ERROR_IMAGE_SPEC_BZERO);
  FBZero := Value;
end;

constructor TFitsImageSpec.Create(ABitPix: TBitPix; const ANaxes: array of Integer; const ABScale, ABZero: Extended);
var
  I, J: Integer;
begin
  inherited Create;
  BitPix := ABitPix;
  Naxis := Length(ANaxes);
  J := 1;
  for I := Low(ANaxes) to High(ANaxes) do
  begin
    Naxes[J] := ANaxes[I];
    Inc(J);
  end;
  BScale := ABScale;
  BZero := ABZero;
end;

constructor TFitsImageSpec.Create(AItem: TFitsImage);
var
  I: Integer;
begin
  inherited Create;
  if not Assigned(AItem) then
    raise EFitsImageException.CreateFmt(SImageSpecIncorrectValue, ['Item'], ERROR_IMAGE_SPEC_ITEM);
  BitPix := AItem.BitPix;
  Naxis := AItem.Naxis;
  for I := 1 to AItem.Naxis do
    Naxes[I] := AItem.Naxes[I];
  BScale := AItem.BScale;
  BZero := AItem.BZero;
end;

constructor TFitsImageSpec.Create;
begin
  inherited Create;
  BitPix := bi08u;
  Naxis  := 0;
  BScale := 1.0;
  BZero  := 0.0;
end;

destructor TFitsImageSpec.Destroy;
begin
  FNaxes := nil;
  inherited;
end;

{ TFitsImageHead }

constructor TFitsImageHead.CreateExplorer(AItem: TFitsItem; APioneer: Boolean);
var
  Number: Integer;
  Keyword: string;
begin

  inherited;

  // check required cards

  if Item.Name <> Item.Namex then
    raise EFitsImageException.CreateFmt(SImageHeadIncorrectValue, [cXTENSION, Item.Index], ERROR_IMAGE_HEAD_INCORRECT_NAME);

  for Number := 1 to Item.Naxis do
    if Item.Naxes[Number] <= 0 then
    begin
      Keyword := Format(cNAXISn, [Number]);
      raise EFitsImageException.CreateFmt(SImageHeadIncorrectValue, [Keyword, Item.Index], ERROR_IMAGE_HEAD_INCORRECT_NAXISN);
    end;

end;

constructor TFitsImageHead.CreateNewcomer(AItem: TFitsItem; ASpec: TFitsItemSpec);
var
  Spec: TFitsImageSpec;
  I, J, Number: Integer;
  Keyword: string;
begin

  inherited;

  // add spec fields

  Spec := ASpec as TFitsImageSpec;

  AppendInteger(cBITPIX, BitPixToInt(Spec.BitPix), 'Number of bits per data value');

  I := AppendInteger(cNAXIS, Spec.Naxis, 'Number of axes');
  for Number := 1 to Spec.Naxis do
  begin
    Keyword := Format(cNAXISn, [Number]);
    J := IndexOf(Keyword, I);
    if J < 0 then
    begin
      I := I + 1;
      InsertInteger(I, Keyword, Spec.Naxes[Number], '');
    end
    else
    begin
      ValuesInteger[J] := Spec.Naxes[Number];
      I := J + 1;
    end;
  end;

  AppendFloat(cBSCALE, Spec.BScale, 'Linear factor in scaling equation');
  AppendFloat(cBZERO, Spec.BZero, 'Zero point in scaling equation');

end;

function TFitsImageHead.AppendFloat(Keyword: string; Value: Extended; Note: string): Integer;
var
  wFmt: string;
begin
  Result := IndexOf(Keyword);
  wFmt := FormatLine^.vaFloat.wFmt;
  FormatLine^.vaFloat.wFmt := '%e';
  try
    if Result < 0 then
      Result := AddFloat(Keyword, Value, Note)
    else
      ValuesFloat[Result] := Value;
  finally
     FormatLine^.vaFloat.wFmt := wFmt;
  end;
end;

function TFitsImageHead.AppendInteger(Keyword: string; Value: Int64; Note: string): Integer;
begin
  Result := IndexOf(Keyword);
  if Result < 0 then
    Result := AddInteger(Keyword, Value, Note)
  else
    ValuesInteger[Result] := Value;
end;

function TFitsImageHead.GetItem: TFitsImage;
begin
  Result := inherited Item as TFitsImage;
end;

{ TFitsImageData }

function TFitsImageData.AllowRead(const AIndex, ACount, ACountElems: Int64): Boolean;
var
  CountPixs: Int64;
begin
  CountPixs := Count;
  if (AIndex < 0) or (AIndex >= CountPixs) then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectIndex, [AIndex, Item.Index], ERROR_IMAGE_DATA_ALLOWREAD_INDEX);
  if (ACount < 0) or (AIndex + ACount > CountPixs) then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectCount, [ACount, Item.Index], ERROR_IMAGE_DATA_ALLOWREAD_COUNT);
  if ACountElems < ACount then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectLength, [ACountElems, Item.Index], ERROR_IMAGE_DATA_ALLOWREAD_LENGTH);
  Result := ACount > 0;
end;

function TFitsImageData.AllowWrite(const AIndex, ACount, ACountElems: Int64): Boolean;
var
  CountPixs: Int64;
begin
  CountPixs := Count;
  if (AIndex < 0) or (AIndex >= CountPixs) then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectIndex, [AIndex, Item.Index], ERROR_IMAGE_DATA_ALLOWWRITE_INDEX);
  if (ACount < 0) or (AIndex + ACount > CountPixs) then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectCount, [ACount, Item.Index], ERROR_IMAGE_DATA_ALLOWWRITE_COUNT);
  if ACountElems < ACount then
    raise EFitsImageException.CreateFmt(SImageDataIncorrectLength, [ACountElems, Item.Index], ERROR_IMAGE_DATA_ALLOWWRITE_LENGTH);
  Result := ACount > 0;
end;

constructor TFitsImageData.CreateNewcomer(AItem: TFitsItem; ASpec: TFitsItemSpec);
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
  Naxis := Item.Naxis;
  Result := Math.IfThen(Naxis = 0, 0, 1);
  for Number := 1 to Naxis do
    Result := Result * Item.Naxes[Number];
end;

function TFitsImageData.GetElems(Index: Int64): Extended;
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  SizePix: Integer;
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
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero := Item.BZero;
  SizePix := BitPixSize(BitPix);
  Uffset := Index * SizePix;
  Swapper := GetSwapper;
  case BitPix of
    bi64f:
      begin
        v64f := 0.0;
        Read(Uffset, SizePix, v64f);
        Result := Swapper.Swap64f(v64f) * BScale + BZero;
      end;
    bi32f:
      begin
        v32f := 0.0;
        Read(Uffset, SizePix, v32f);
        Result := Swapper.Swap32f(v32f) * BScale + BZero;
      end;
    bi08u:
      begin
        v08u := 0;
        Read(Uffset, SizePix, v08u);
        Result := v08u * BScale + BZero;
      end;
    bi16c:
      begin
        v16c := 0;
        Read(Uffset, SizePix, v16c);
        Result := Swapper.Swap16c(v16c) * BScale + BZero;
      end;
    bi32c:
      begin
        v32c := 0;
        Read(Uffset, SizePix, v32c);
        Result := Swapper.Swap32c(v32c) * BScale + BZero;
      end;
    bi64c:
      begin
        v64c := 0;
        Read(Uffset, SizePix, v64c);
        Result := Swapper.Swap64c(v64c) * BScale + BZero;
      end;
    else
      Result := NaN;
  end;
end;

function TFitsImageData.GetItem: TFitsImage;
begin
  Result := inherited Item as TFitsImage;
end;

function TFitsImageData.GetEditor: TEditor;
begin
  Result.BufferAllocate := {$IFDEF FPC}@{$ENDIF}Item.Container.Content.Buffer.Allocate;
  Result.BufferRelease  := {$IFDEF FPC}@{$ENDIF}Item.Container.Content.Buffer.Release;
  Result.DataRead       := {$IFDEF FPC}@{$ENDIF}Self.Read;
  Result.DataWrite      := {$IFDEF FPC}@{$ENDIF}Self.Write;
end;

function TFitsImageData.GetRep: TRepNumber;

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
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Bone, Boff, Bint: Boolean;
  RepPix: TRepNumber;
  Vmin, Vmax: Extended;

begin

  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero := Item.BZero;

  Scale := ScaleNumber(BitPix, BScale, BZero);
  Bone := Scale = scOne;
  Boff := Scale = scOff;
  Bint := Scale = scInt;

  RepPix := BitPixToRep(BitPix);
  Vmin := GetMinNumber(RepPix) * BScale + BZero;
  Vmax := GetMaxNumber(RepPix) * BScale + BZero;
  Extrema(Vmin, Vmax);

  Result := repUnknown;
  case BitPix of
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

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA80f);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_80F(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_80F(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_80F(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_80F(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_80F(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_80F(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA64f);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_64F(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_64F(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_64F(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_64F(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_64F(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_64F(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA32f);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_32F(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_32F(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_32F(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_32F(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_32F(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_32F(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA08c);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_08C(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_08C(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_08C(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_08C(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_08C(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_08C(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA08u);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_08U(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_08U(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_08U(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_08U(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_08U(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_08U(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA16c);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_16C(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_16C(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_16C(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_16C(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_16C(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_16C(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA16u);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_16U(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_16U(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_16U(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_16U(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_16U(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_16U(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA32c);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_32C(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_32C(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_32C(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_32C(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_32C(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_32C(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA32u);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_32U(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_32U(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_32U(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_32U(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_32U(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_32U(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.ReadElems(const AIndex, ACount: Int64; var AElems: TA64c);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowRead(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: R_64F_ONE_64C(Editor, AIndex, ACount, AElems);
      else   R_64F_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: R_32F_ONE_64C(Editor, AIndex, ACount, AElems);
      else   R_32F_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: R_08U_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: R_08U_OFF_64C(Editor, AIndex, ACount, AElems);
      else   R_08U_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: R_16C_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: R_16C_OFF_64C(Editor, AIndex, ACount, AElems);
      else   R_16C_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: R_32C_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: R_32C_OFF_64C(Editor, AIndex, ACount, AElems);
      else   R_32C_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: R_64C_ONE_64C(Editor, AIndex, ACount, AElems);
      else   R_64C_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.SetElems(Index: Int64; const Value: Extended);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Valu: Extended;
  SizePix: Integer;
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

  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero := Item.BZero;

  Valu := (Value - BZero) / BScale;

  SizePix := BitPixSize(BitPix);
  Uffset := Index * SizePix;
  Swapper := GetSwapper;

  case BitPix of
    bi64f:
      begin
        v64f := Ensure64f(Valu);
        v64f := Swapper.Swap64f(v64f);
        Write(Uffset, SizePix, v64f);
      end;
    bi32f:
      begin
        v32f := Ensure32f(Valu);
        v32f := Swapper.Swap32f(v32f);
        Write(Uffset, SizePix, v32f);
      end;
    bi08u:
      begin
        v08u := Round08u(Valu);
        Write(Uffset, SizePix, v08u);
      end;
    bi16c:
      begin
        v16c := Round16c(Valu);
        v16c := Swapper.Swap16c(v16c);
        Write(Uffset, SizePix, v16c);
      end;
    bi32c:
      begin
        v32c := Round32c(Valu);
        v32c := Swapper.Swap32c(v32c);
        Write(Uffset, SizePix, v32c);
      end;
    bi64c:
      begin
        v64c := Round64c(Valu);
        v64c := Swapper.Swap64c(v64c);
        Write(Uffset, SizePix, v64c);
      end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA80f);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_80F(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_80F(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_80F(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_80F(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_80F(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_80F(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_80F(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_80F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA64f);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_64F(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_64F(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_64F(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_64F(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_64F(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_64F(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_64F(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_64F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA32f);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_32F(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_32F(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_32F(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_32F(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_32F(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_32F(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_32F(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_32F(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA08c);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_08C(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_08C(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_08C(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_08C(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_08C(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_08C(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_08C(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_08C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA08u);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_08U(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_08U(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_08U(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_08U(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_08U(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_08U(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_08U(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_08U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA16c);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_16C(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_16C(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_16C(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_16C(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_16C(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_16C(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_16C(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_16C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA16u);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_16U(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_16U(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_16U(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_16U(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_16U(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_16U(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_16U(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_16U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA32c);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_32C(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_32C(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_32C(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_32C(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_32C(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_32C(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_32C(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_32C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA32u);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_32U(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_32U(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_32U(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_32U(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_32U(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_32U(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_32U(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_32U(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

procedure TFitsImageData.WriteElems(const AIndex, ACount: Int64; const AElems: TA64c);
var
  BitPix: TBitPix;
  BScale, BZero: Extended;
  Scale: TScaleNumber;
  Editor: TEditor;
begin
  if not AllowWrite(AIndex, ACount, Length(AElems)) then
    Exit;
  BitPix := Item.BitPix;
  BScale := Item.BScale;
  BZero  := Item.BZero;
  Scale  := ScaleNumber(BitPix, BScale, BZero);
  Editor := GetEditor;
  case BitPix of
    bi64f: case Scale of
      scOne: W_64F_ONE_64C(Editor, AIndex, ACount, AElems);
      else   W_64F_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32f: case Scale of
      scOne: W_32F_ONE_64C(Editor, AIndex, ACount, AElems);
      else   W_32F_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi08u: case Scale of
      scOne: W_08U_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: W_08U_OFF_64C(Editor, AIndex, ACount, AElems);
      else   W_08U_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi16c: case Scale of
      scOne: W_16C_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: W_16C_OFF_64C(Editor, AIndex, ACount, AElems);
      else   W_16C_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi32c: case Scale of
      scOne: W_32C_ONE_64C(Editor, AIndex, ACount, AElems);
      scOff: W_32C_OFF_64C(Editor, AIndex, ACount, AElems);
      else   W_32C_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
    bi64c: case Scale of
      scOne: W_64C_ONE_64C(Editor, AIndex, ACount, AElems);
      else   W_64C_EXT_64C(Editor, BScale, BZero, AIndex, ACount, AElems);
    end;
  end;
end;

{ TFitsImage }

constructor TFitsImage.CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean);
begin
  inherited;
end;

constructor TFitsImage.CreateNewcomer(AContainer: TFitsContainer; ASpec: TFitsItemSpec);
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

function TFitsImage.GetBScale: Extended;
const
  Key = cBSCALE;
var
  Ind: Integer;
begin
  if not Assigned(Head) then
    raise EFitsImageException.Create(SHeadNotAssign, ERROR_ITEM_GETGCOUNT_NOHEAD);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := 1.0
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsImageException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ITEM_GETGCOUNT_INVALID);
  end;
end;

function TFitsImage.GetBZero: Extended;
const
  Key = cBZERO;
var
  Ind: Integer;
begin
  if not Assigned(Head) then
    raise EFitsImageException.Create(SHeadNotAssign, ERROR_ITEM_GETGCOUNT_NOHEAD);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := 0.0
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsImageException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ITEM_GETGCOUNT_INVALID);
  end;
end;

function TFitsImage.GetData: TFitsImageData;
begin
  Result := inherited Data as TFitsImageData;
end;

function TFitsImage.GetDataClass: TFitsItemDataClass;
begin
  Result := TFitsImageData;
end;

function TFitsImage.GetHead: TFitsImageHead;
begin
  Result := inherited Head as TFitsImageHead;
end;

function TFitsImage.GetHeadClass: TFitsItemHeadClass;
begin
   Result := TFitsImageHead;
end;

function TFitsImage.GetNamex: string;
begin
  Result := 'IMAGE';
end;

end.
