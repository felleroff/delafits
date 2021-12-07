{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{           Container of Head and Data Units           }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsClasses;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Classes, Math, DeLaFitsCommon, DeLaFitsString, DeLaFitsMath;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_CLASSES                        = 4000;

  ERROR_UMIT_HEAD_BIND_ASSIGN          = 4100;
  ERROR_UMIT_HEAD_BIND_INSPECT         = 4101;
  ERROR_UMIT_HEAD_MAKE_SIZE_SMALL      = 4102;
  ERROR_UMIT_HEAD_MAKE_SIZE_MULTIPLE   = 4103;
  ERROR_UMIT_HEAD_MAKE_SIMPLE_PARSE    = 4104;
  ERROR_UMIT_HEAD_MAKE_SIMPLE_KEY      = 4105;
  ERROR_UMIT_HEAD_MAKE_SIMPLE_VALUE    = 4106;
  ERROR_UMIT_HEAD_MAKE_XTENSION_PARSE  = 4107;
  ERROR_UMIT_HEAD_MAKE_XTENSION_KEY    = 4108;
  ERROR_UMIT_HEAD_MAKE_XTENSION_VALUE  = 4109;
  ERROR_UMIT_HEAD_MAKE_KEYEND_NOTFOUND = 4110;
  ERROR_UMIT_HEAD_GET_KEYWORD_INDEX    = 4111;
  ERROR_UMIT_HEAD_SET_KEYWORD_INDEX    = 4112;
  ERROR_UMIT_HEAD_CAST_CARD            = 4113;
  ERROR_UMIT_HEAD_CAST_LINE            = 4114;
  ERROR_UMIT_HEAD_READ_INDEX           = 4115;
  ERROR_UMIT_HEAD_READ_COUNT           = 4116;
  ERROR_UMIT_HEAD_WRITE_INDEX          = 4117;
  ERROR_UMIT_HEAD_WRITE_COUNT          = 4118;
  ERROR_UMIT_HEAD_INSERT_INDEX         = 4119;
  ERROR_UMIT_HEAD_DELETE_INDEX         = 4120;
  ERROR_UMIT_HEAD_DELETE_COUNT         = 4121;
  ERROR_UMIT_HEAD_EXCHANGE_INDEX       = 4122;
  ERROR_UMIT_HEAD_MOVE_INDEX           = 4123;
  ERROR_UMIT_HEAD_FREE_INSPECT         = 4124;

  ERROR_UMIT_DATA_BIND_ASSIGN          = 4200;
  ERROR_UMIT_DATA_BIND_INSPECT         = 4201;
  ERROR_UMIT_DATA_BIND_NOHEAD          = 4202;
  ERROR_UMIT_DATA_MAKE_SIZE            = 4203;
  ERROR_UMIT_DATA_READ_BOUNDS          = 4204;
  ERROR_UMIT_DATA_WRITE_BOUNDS         = 4205;
  ERROR_UMIT_DATA_ERASE_BOUNDS         = 4206;
  ERROR_UMIT_DATA_DELETE_BOUNDS        = 4207;
  ERROR_UMIT_DATA_TRUNCATE_SIZE        = 4208;
  ERROR_UMIT_DATA_ERASE_UFSSET         = 4209;
  ERROR_UMIT_DATA_ERASE_SIZE           = 4210;
  ERROR_UMIT_DATA_ADD_SIZE             = 4211;
  ERROR_UMIT_DATA_FREE_INSPECT         = 4212;

  ERROR_UMIT_BIND_ASSIGN               = 4300;
  ERROR_UMIT_BIND_INSPECT              = 4301;
  ERROR_UMIT_GETEXTNAME_INVALID        = 4302;
  ERROR_UMIT_GETEXTVER_INVALID         = 4303;
  ERROR_UMIT_GETLEVEL_INVALID          = 4304;
  ERROR_UMIT_GETBITPIX_NOHEAD          = 4305;
  ERROR_UMIT_GETBITPIX_NOTFOUND        = 4306;
  ERROR_UMIT_GETBITPIX_INVALID         = 4307;
  ERROR_UMIT_GETBITPIX_INCORRECT       = 4308;
  ERROR_UMIT_GETGCOUNT_NOHEAD          = 4309;
  ERROR_UMIT_GETGCOUNT_INVALID         = 4310;
  ERROR_UMIT_GETGCOUNT_INCORRECT       = 4311;
  ERROR_UMIT_GETPCOUNT_NOHEAD          = 4312;
  ERROR_UMIT_GETPCOUNT_INVALID         = 4313;
  ERROR_UMIT_GETPCOUNT_INCORRECT       = 4314;
  ERROR_UMIT_GETNAXIS_NOHEAD           = 4315;
  ERROR_UMIT_GETNAXIS_NOTFOUND         = 4316;
  ERROR_UMIT_GETNAXIS_INVALID          = 4317;
  ERROR_UMIT_GETNAXIS_INCORRECT        = 4318;
  ERROR_UMIT_GETNAXES_NOHEAD           = 4319;
  ERROR_UMIT_GETNAXES_NUMBER           = 4320;
  ERROR_UMIT_GETNAXES_NOTFOUND         = 4321;
  ERROR_UMIT_GETNAXES_INVALID          = 4322;
  ERROR_UMIT_GETNAXES_INCORRECT        = 4323;
  ERROR_UMIT_FREE_INSPECT              = 4324;

  ERROR_CONTENT_ASSIGN_STREAM          = 4400;
  ERROR_CONTENT_READ                   = 4401;
  ERROR_CONTENT_READ_BUFFER            = 4402;
  ERROR_CONTENT_WRITE                  = 4403;
  ERROR_CONTENT_WRITE_BUFFER           = 4404;
  ERROR_CONTENT_FILL_BOUNDS            = 4405;
  ERROR_CONTENT_SHIFT_BOUNDS           = 4406;
  ERROR_CONTENT_SHIFT_SIZE             = 4407;
  ERROR_CONTENT_ROTATE_BOUNDS          = 4408;
  ERROR_CONTENT_ROTATE_SIZE            = 4409;
  ERROR_CONTENT_EXCHANGE_BOUNDS        = 4410;
  ERROR_CONTENT_EXCHANGE_SIZE          = 4411;
  ERROR_CONTENT_EXCHANGE_INTER         = 4412;
  ERROR_CONTENT_MOVE_BOUNDS            = 4413;
  ERROR_CONTENT_MOVE_SIZE              = 4414;
  ERROR_CONTENT_MOVE_INTER             = 4415;
  ERROR_CONTENT_RESIZE_BOUNDS          = 4416;
  ERROR_CONTENT_RESIZE_SIZE            = 4417;

  ERROR_CONTAINER_GETUMIT_INDEX        = 4500;
  ERROR_CONTAINER_INSERT_INDEX         = 4501;
  ERROR_CONTAINER_RECLASS_INDEX        = 4502;
  ERROR_CONTAINER_COCLASS_INDEX        = 4503;
  ERROR_CONTAINER_DELETE_INDEX         = 4504;
  ERROR_CONTAINER_DELETE_REORDER       = 4505;
  ERROR_CONTAINER_EXCHANGE_INDEX       = 4506;
  ERROR_CONTAINER_EXCHANGE_REORDER     = 4507;
  ERROR_CONTAINER_MOVE_INDEX           = 4508;
  ERROR_CONTAINER_MOVE_REORDER         = 4509;

resourcestring

  { The messages of exceptions }

  SListIndexOutBounds     = 'List index out of bounds "%d"';
  SCountValueOutBounds    = 'Count value out of bounds "%d"';

  SBufferIncorrectSize    = 'Incorrect buffer size "%d"';

  SBindNoInspect          = 'Binding error: no owner inspection';
  SFreeNoInspect          = 'Error destroying HDU[%d]: no owner inspection';

  SKeywordNotFound        = 'Keyword "%s" not found in HDU[%d] header';

  SLineErrorParse         = 'Error parsing of the header line[%d] in HDU[%d]';
  SLineKeywordNotMatch    = 'Keyword[%d] in HDU[%d] header does not match "%s"';
  SLineValueIncorrect     = 'Incorrect value[%d] in HDU[%d] header';

  SUnknownCastCard        = 'Unknown identifier "%d" for header line assembly';
  SUnknownCastLine        = 'Unknown identifier "%d" for header line parse';

  SHeadNotAssign          = 'Header Object is not assigned';
  SHeadMakeSmallSize      = 'Small stream size to identify HDU[%d] header';
  SHeadMakeMultipleSize   = 'Violation of the multiplicity of the stream size in HDU[%d] header';

  SDataIncorrectSize      = 'Incorrect HDU[%d] data size "%d"';
  SDataIncorrectUffset    = 'Incorrect HDU[%d] data uffset "%d"';
  SDataIncorrectBounds    = 'Incorrect HDU[%d] data boundary "[%d, %d)"';

  SUmitNotAssign          = 'Umit of fits-container (owner) is not assigned';
  SUmitCannotPrimary      = 'HDU[%d] cannot be primary';

  SStreamNotAssign        = 'Stream Object is not assigned';

  SContentAccessError     = 'Error accessing to content';
  SContentIncorrectBounds = 'Incorrect content boundary';
  SContentInterBlocks     = 'Intersection of content blocks';
  SContentIncorrectSize   = 'Incorrect content size';

  SContainerNotAssign     = 'Fits-container (owner) is not assigned';

type

  { Exception classes }

  EFitsClassesException = class(EFitsException);

type

  { Type of umit order }

  TOrderType = (otNone, otSing, otPrim, otXten);

  TFitsUmit = class;

  { HDU specification: required parameters to create a new HDU }

  TFitsUmitSpec = class(TObject);

  { Header block of HDU }

  TFitsUmitHead = class(TObject)

  private

    FUmit: TFitsUmit;
    FSize: Int64;
    FFormatLine: TFormatLine;

  protected

    procedure Init; virtual;

  private

    procedure Bind(AUmit: TFitsUmit);
    procedure MakeExplorer(APioneer: Boolean);
    procedure MakeNewcomer(ASpec: TFitsUmitSpec);

    function GetOffset: Int64;
    function GetCize: Int64;

    function GetFormatLine: PFormatLine;

    function GetLine(Index: Integer): string;
    procedure SetLine(Index: Integer; Line: string);

    function GetCard(Index, Cast: Integer): TCard;
    procedure SetCard(Index, Cast: Integer; Card: TCard);

    function GetKeyword(Index: Integer): string;
    procedure SetKeyword(Index: Integer; Keyword: string);

    function GetValueStr(Index: Integer; Cast: Integer): string;
    procedure SetValueStr(Index: Integer; Cast: Integer; Value: string);
    function GetValueBol(Index: Integer; Cast: Integer): Boolean;
    procedure SetValueBol(Index: Integer; Cast: Integer; Value: Boolean);
    function GetValueInt(Index: Integer; Cast: Integer): Int64;
    procedure SetValueInt(Index: Integer; Cast: Integer; Value: Int64);
    function GetValueExt(Index: Integer; Cast: Integer): Extended;
    procedure SetValueExt(Index: Integer; Cast: Integer; Value: Extended);
    function GetValueDtm(Index: Integer; Cast: Integer): TDateTime;
    procedure SetValueDtm(Index: Integer; Cast: Integer; Value: TDateTime);

    function GetNote(Index: Integer): string;
    procedure SetNote(Index: Integer; Note: string);

    function GetText: string;

    function GetCount: Integer;
    function GetCapacity: Integer;

  public

    constructor CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean); virtual;
    constructor CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec); virtual;
    procedure BeforeDestruction; override;
    destructor Destroy; override;

    property Umit: TFitsUmit read FUmit;

    // Cize <= Size

    property Offset: Int64 read GetOffset;
    property Cize: Int64 read GetCize;
    property Size: Int64 read FSize;

  public

    function CardToLine(Card: TCard; Cast: Integer): string; virtual;
    function LineToCard(Line: string; Cast: Integer): TCard; virtual;

    property FormatLine: PFormatLine read GetFormatLine;

  public

    procedure Read(Index: Integer; out Line: string; ACount: Integer); overload;
    procedure Read(Index: Integer; out Card: TCard; Cast: Integer); overload;
    procedure Write(Index: Integer; Line: string); overload;
    procedure Write(Index: Integer; Card: TCard; Cast: Integer); overload;

    function IndexOf(const Keyword: string; StartIndex: Integer = 0): Integer;
    function IndexOfLastNaxes: Integer;

    function Add(const Line: string): Integer; overload;
    function Add(const Card: TCard; Cast: Integer): Integer; overload;
    function AddChars(Keyword: string; Value: string; Note: string): Integer;
    function AddString(Keyword: string; Value: string; Note: string): Integer;
    function AddText(Keyword: string; Value: string): Integer;
    function AddHistory(Value: string): Integer;
    function AddComment(Value: string): Integer;
    function AddBlank: Integer;
    function AddBoolean(Keyword: string; Value: Boolean; Note: string): Integer;
    function AddInteger(Keyword: string; Value: Int64; Note: string): Integer;
    function AddFloat(Keyword: string; Value: Extended; Note: string): Integer;
    function AddRa(Keyword: string; Value: Extended; Note: string): Integer;
    function AddDe(Keyword: string; Value: Extended; Note: string): Integer;
    function AddDateTime(Keyword: string; Value: TDateTime; Note: string): Integer;
    function AddDate(Keyword: string; Value: TDateTime; Note: string): Integer;
    function AddTime(Keyword: string; Value: TDateTime; Note: string): Integer;

    procedure Insert(Index: Integer; Line: string); overload;
    procedure Insert(Index: Integer; const Card: TCard; Cast: Integer); overload;
    procedure InsertChars(Index: Integer; Keyword: string; Value: string; Note: string);
    procedure InsertString(Index: Integer; Keyword: string; Value: string; Note: string);
    procedure InsertText(Index: Integer; Keyword: string; Value: string);
    procedure InsertHistory(Index: Integer; Value: string);
    procedure InsertComment(Index: Integer; Value: string);
    procedure InsertBlank(Index: Integer);
    procedure InsertBoolean(Index: Integer; Keyword: string; Value: Boolean; Note: string);
    procedure InsertInteger(Index: Integer; Keyword: string; Value: Int64; Note: string);
    procedure InsertFloat(Index: Integer; Keyword: string; Value: Extended; Note: string);
    procedure InsertRa(Index: Integer; Keyword: string; Value: Extended; Note: string);
    procedure InsertDe(Index: Integer; Keyword: string; Value: Extended; Note: string);
    procedure InsertDateTime(Index: Integer; Keyword: string; Value: TDateTime; Note: string);
    procedure InsertDate(Index: Integer; Keyword: string; Value: TDateTime; Note: string);
    procedure InsertTime(Index: Integer; Keyword: string; Value: TDateTime; Note: string);

  protected

    function AppendString(Keyword: string; Value: string; Note: string; HopIndex: Integer = -1): Integer;
    function AppendInteger(Keyword: string; Value: Int64; Note: string; HopIndex: Integer = -1): Integer;
    function AppendFloat(Keyword: string; Value: Extended; Note: string; HopIndex: Integer = -1): Integer;

  public

    procedure Delete(AIndex: Integer; ACount: Integer = 1); overload;
    procedure Delete(const Keys: array of string); overload;

    procedure Exchange(Index1, Index2: Integer);
    procedure Move(CurIndex, NewIndex: Integer);

    property Lines[Index: Integer]: string read GetLine write SetLine;

    property Cards[Index, Cast: Integer]: TCard read GetCard write SetCard;

    property Keywords[Index: Integer]: string read GetKeyword write SetKeyword;

    property ValuesChars[Index: Integer]: string Index cCastChars read GetValueStr write SetValueStr;
    property ValuesString[Index: Integer]: string Index cCastString read GetValueStr write SetValueStr;
    property ValuesBoolean[Index: Integer]: Boolean Index cCastBoolean read GetValueBol write SetValueBol;
    property ValuesInteger[Index: Integer]: Int64 Index cCastInteger read GetValueInt write SetValueInt;
    property ValuesFloat[Index: Integer]: Extended Index cCastFloat read GetValueExt write SetValueExt;
    property ValuesRa[Index: Integer]: Extended Index cCastRa read GetValueExt write SetValueExt;
    property ValuesDe[Index: Integer]: Extended Index cCastDe read GetValueExt write SetValueExt;
    property ValuesDateTime[Index: Integer]: TDateTime Index cCastDateTime read GetValueDtm write SetValueDtm;
    property ValuesDate[Index: Integer]: TDateTime Index cCastDate read GetValueDtm write SetValueDtm;
    property ValuesTime[Index: Integer]: TDateTime Index cCastTime read GetValueDtm write SetValueDtm;

    property Notes[Index: Integer]: string read GetNote write SetNote;

    property Text: string read GetText;

    // Count <= Capacity

    property Count: Integer read GetCount;
    property Capacity: Integer read GetCapacity;

  end;

  { Data block of HDU }

  TFitsUmitData = class(TObject)

  private

    FUmit: TFitsUmit;
    FSize: Int64;

  protected

    procedure Init; virtual;

  private

    procedure Bind(AUmit: TFitsUmit);
    procedure MakeExplorer(APioneer: Boolean);
    procedure MakeNewcomer(ASpec: TFitsUmitSpec);

    function GetOffset: Int64;
    function GetCize: Int64;

    function GetBitPix: TBitPix;
    function GetSizPix: Byte;
    function GetGcount: Integer;
    function GetPcount: Integer;
    function GetAxis: Integer;
    function GetAxes(Index: Integer): Integer;

  public

    constructor CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean); virtual;
    constructor CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec); virtual;
    procedure BeforeDestruction; override;
    destructor Destroy; override;

    property Umit: TFitsUmit read FUmit;

    // Cize <= Size

    property Offset: Int64 read GetOffset;
    property Cize: Int64 read GetCize;
    property Size: Int64 read FSize;

  protected

    function Filler: Char; virtual;

  public

    procedure Read(const Uffset, ASize: Int64; var ABuffer);

    procedure Write(const Uffset, ASize: Int64; const ABuffer);
    procedure Erase(const Uffset, ASize: Int64);

    procedure Delete(const Uffset, ASize: Int64);
    procedure Truncate(const ASize: Int64);

    procedure Insert(const Uffset, ASize: Int64);
    procedure Add(const ASize: Int64);

 public

    property BitPix: TBitPix read GetBitPix;
    property SizPix: Byte read GetSizPix;

    property Gcount: Integer read GetGcount;
    property Pcount: Integer read GetPcount;

    property Axis: Integer read GetAxis;
    property Axes[Index: Integer]: Integer read GetAxes;

  end;

  TFitsContainer = class;

  TFitsUmitHeadClass = class of TFitsUmitHead;
  TFitsUmitDataClass = class of TFitsUmitData;

  TFitsUmitClass = class of TFitsUmit;

  { HDU }

  TFitsUmit = class(TObject)

  private

    FContainer: TFitsContainer;
    FHead: TFitsUmitHead;
    FData: TFitsUmitData;

  protected

    procedure Init; virtual;

  private

    procedure Bind(AContainer: TFitsContainer);
    procedure MakeExplorer(APioneer: Boolean);
    procedure MakeNewcomer(ASpec: TFitsUmitSpec);

    function CanPrimary: Boolean;
    procedure Reorder(AType: TOrderType);

    function GetIndex: Integer;

    function GetOffset: Int64;
    function GetSize: Int64;
    function GetEstimateSize: Int64;

    function GetFamily: string;
    function GetName: string;
    function GetVersion: Integer;
    function GetLevel: Integer;

    function GetXTENSION: string;
    function GetEXTNAME: string;
    function GetEXTVER: Integer;
    function GetEXTLEVEL: Integer;
    function GetBITPIX: Integer;
    function GetGCOUNT: Integer;
    function GetPCOUNT: Integer;
    function GetNAXIS: Integer;
    function GetNAXES(Number: Integer): Integer;

  protected

    function GetHeadClass: TFitsUmitHeadClass; virtual;
    function GetDataClass: TFitsUmitDataClass; virtual;

    function GetAlias: string; virtual;

  public

    constructor CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean); virtual;
    constructor CreateNewcomer(AContainer: TFitsContainer; ASpec: TFitsUmitSpec); virtual;
    procedure BeforeDestruction; override;
    destructor Destroy; override;

    function Coclass(UmitClass: TFitsUmitClass): Boolean;
    function Reclass(UmitClass: TFitsUmitClass): TFitsUmit;
    procedure Delete;
    procedure Exchange(Index2: Integer);
    procedure Move(NewIndex: Integer);

    property Container: TFitsContainer read FContainer;
    property Index: Integer read GetIndex;

    property Offset: Int64 read GetOffset;
    property Size: Int64 read GetSize;

    property Head: TFitsUmitHead read FHead;
    property Data: TFitsUmitData read FData;

    property Family: string read GetFamily;

    class function ClassFamily: string; virtual;

    property Alias: string read GetAlias;

    property Name: string read GetName;
    property Version: Integer read GetVersion;
    property Level: Integer read GetLevel;

    property XTENSION: string read GetXTENSION;
    property EXTNAME: string read GetEXTNAME;
    property EXTVER: Integer read GetEXTVER;
    property EXTLEVEL: Integer read GetEXTLEVEL;
    property BITPIX: Integer read GetBITPIX;
    property GCOUNT: Integer read GetGCOUNT;
    property PCOUNT: Integer read GetPCOUNT;
    property NAXIS: Integer read GetNAXIS;
    property NAXES[Number: Integer]: Integer read GetNAXES;

  end;

  { Memory Manager: buffer for operations of reading and writing }

  TFitsManagerBuffer = class(TObject)

  {$IFDEF DELA_MEMORY_PRIVATE}
  private
    FBuffer: TBuffer;
  {$ENDIF}

  public

    constructor Create;
    destructor Destroy; override;

    procedure Allocate(var ABuffer: Pointer; ASizeInBytes: Integer);
    procedure Release(var ABuffer: Pointer);
    procedure Reset;

  end;

  { Content access }

  TFitsContent = class(TObject)

  private

    FStream: TStream;
    FBuffer: TFitsManagerBuffer;

    function GetSize: Int64;

  public

    constructor Create(AStream: TStream);
    destructor Destroy; override;

    procedure Read(const AOffset, ASize: Int64; var ABuffer);
    procedure ReadBuffer(const AOffset, ACount: Int64; var ABuffer: TBuffer);
    procedure ReadString(const AOffset, ACount: Int64; var ABuffer: string);

    procedure Write(const AOffset, ASize: Int64; const ABuffer);
    procedure WriteBuffer(const AOffset, ACount: Int64; const ABuffer: TBuffer);
    procedure WriteString(const AOffset, ACount: Int64; const ABuffer: string);

    procedure Fill(const AOffset, ASize: Int64; AChar: Char);

    // Rewrite content: AShift > 0 - shift content down, AShift < 0 - shift content up

    procedure Shift(const AOffset, ASize, AShift: Int64);

    procedure Rotate(const AOffset, ASize: Int64);
    procedure Exchange(var AOffset1: Int64; const ASize1: Int64; var AOffset2: Int64; const ASize2: Int64);
    procedure Move(const AOffset, ASize: Int64; var ANewOffset: Int64);

    // Resize content: ASize > 0 - grow size content, ASize < 0 - reduce size content

    procedure Resize(const AOffset, ASize: Int64);

    property Size: Int64 read GetSize;

    property Stream: TStream read FStream;
    property Buffer: TFitsManagerBuffer read FBuffer;

  end;

  { Container HDUs }

  TFitsContainer = class(TObject)

  private

    FContent: TFitsContent;
    FUmits: TList;
    FInspect: Boolean;
    FEmbindex: Integer;

    procedure Embed(NewUmit: TFitsUmit);

    function GetCount: Integer;
    function GetUmit(Index: Integer): TFitsUmit;
    function GetPrimary: TFitsUmit;

    procedure Explore;

    procedure Clear;

  public

    constructor Create(AStream: TStream);
    destructor Destroy; override;

    function Coclass(Index: Integer; UmitClass: TFitsUmitClass): Boolean;
    function Reclass(Index: Integer; UmitClass: TFitsUmitClass): TFitsUmit;

    function Add(UmitClass: TFitsUmitClass; UmitSpec: TFitsUmitSpec): TFitsUmit;

    procedure Delete(Index: Integer);

    procedure Exchange(Index1, Index2: Integer);
    procedure Move(CurIndex, NewIndex: Integer);

    function IndexOf(Umit: TFitsUmit): Integer;

    property Umits[Index: Integer]: TFitsUmit read GetUmit; default;
    property Primary: TFitsUmit read GetPrimary;
    property Count: Integer read GetCount;

    property Content: TFitsContent read FContent;

  end;

implementation

function IfThen(AValue: Boolean; const ATrue, AFalse: TOrderType): TOrderType; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

procedure Swap(var V1, V2: Integer); {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  O: Integer;
begin
  O  := V1;
  V1 := V2;
  V2 := O;
end;

function CeilToRank(const Value: Int64; Rank: Integer): Int64; {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  Modulo: Integer;
begin
  if Rank <= 0 then
  begin
    Result := 0;
    Exit;
  end;
  if Value < 0 then
  begin
    Result := 0;
    Exit;
  end;
  if Value = 0 then
  begin
    Result := Rank;
    Exit;
  end;
  Modulo := Value mod Rank;
  if Modulo = 0 then
    Result := Value
  else
    Result := Value + Rank - Modulo;
end;

function ZeroToRank(const Value: Int64; Rank: Integer): Int64; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  if Value = 0 then
    Result := 0
  else
    Result := CeilToRank(Value, Rank);
end;

function CardSimple: TCard; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ToCard(cSIMPLE, True, True, True, 'Conforms to FITS standard');
end;

function CardExtend: TCard; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ToCard(cEXTEND, True, True, True, 'Extensions are present');
end;

function CardXtension(AName: string): TCard; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ToCard(cXTENSION, True, AName, True, 'Name of extension');
end;

function CardBITPIX(ABitBix: TBitPix): TCard; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ToCard(cBITPIX, True, BitPixToInt(ABitBix), True, 'Number of bits per data value');
end;

function CardNAXIS(ANaxis: Integer): TCard; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ToCard(cNAXIS, True, ANaxis, True, 'Number of axes');
end;

function CardPCOUNT(PCount: Integer): TCard; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ToCard(cPCOUNT, True, PCount, True, 'Parameter count');
end;

function CardGCOUNT(GCount: Integer): TCard; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := ToCard(cGCOUNT, True, GCount, True, 'Group count');
end;

{ TFitsUmitHead }

procedure TFitsUmitHead.Bind(AUmit: TFitsUmit);
begin
  if not Assigned(AUmit) then
    raise EFitsClassesException.Create(SUmitNotAssign, ERROR_UMIT_HEAD_BIND_ASSIGN);
  if not AUmit.Container.FInspect then
    raise EFitsClassesException.Create(SBindNoInspect, ERROR_UMIT_HEAD_BIND_INSPECT);
  FUmit := AUmit;
  FUmit.FHead := Self;
end;

procedure TFitsUmitHead.MakeExplorer(APioneer: Boolean);

var
  Key: string;
  Card: TCard;
  lFind: Boolean;
  lSize: Int64;

  function ReadFirstCard(Cast: Integer; Error: Integer): TCard;
  begin
    try
      Read(0, Result, Cast);
    except
      on E: Exception do
        raise EFitsClassesException.CreateFmt(SLineErrorParse, [0, FUmit.Index], E.Message, Error);
    end;
  end;

begin

  // suppress hint

  if APioneer then
    ;

  // presize

  FSize := FUmit.GetEstimateSize;
  if FSize < cSizeBlock then
    raise EFitsClassesException.CreateFmt(SHeadMakeSmallSize, [FUmit.Index], ERROR_UMIT_HEAD_MAKE_SIZE_SMALL);

  // check first card SIMPLE or XTENSION

  if FUmit.Index = 0 then
  begin
    Card := ReadFirstCard(cCastBoolean, ERROR_UMIT_HEAD_MAKE_SIMPLE_PARSE);
    if not SameText(Card.Keyword, cSIMPLE) then
      raise EFitsClassesException.CreateFmt(SLineKeywordNotMatch, [0, FUmit.Index, cSIMPLE], ERROR_UMIT_HEAD_MAKE_SIMPLE_KEY);
    if Card.Value.Bol = False then
      raise EFitsClassesException.CreateFmt(SLineValueIncorrect, [0, FUmit.Index], ERROR_UMIT_HEAD_MAKE_SIMPLE_VALUE);
  end
  else
  begin
    Card := ReadFirstCard(cCastString, ERROR_UMIT_HEAD_MAKE_XTENSION_PARSE);
    if not SameText(Card.Keyword, cXTENSION) then
      raise EFitsClassesException.CreateFmt(SLineKeywordNotMatch, [0, FUmit.Index, cXTENSION], ERROR_UMIT_HEAD_MAKE_XTENSION_KEY);
    if Card.Value.Str = '' then
      raise EFitsClassesException.CreateFmt(SLineValueIncorrect, [0, FUmit.Index], ERROR_UMIT_HEAD_MAKE_XTENSION_VALUE);
  end;

  // search END keyword and set size of header

  Key := DeLaFitsString.Blank(cSizeKeyword);
  lSize := 0;
  lFind := False;
  while (lSize < FSize) and (not lFind) do
  begin
    FUmit.Container.Content.ReadString(Offset + lSize, cSizeKeyword, Key);
    lSize := lSize + cSizeLine;
    lFind := SameText(Trim(Key), cEND);
  end;
  if not lFind then
    raise EFitsClassesException.CreateFmt(SKeywordNotFound, [cEND, FUmit.Index], ERROR_UMIT_HEAD_MAKE_KEYEND_NOTFOUND);
  lSize := CeilToRank(lSize, cSizeBlock);
  if lSize > FSize then
    raise EFitsClassesException.CreateFmt(SHeadMakeMultipleSize, [FUmit.Index], ERROR_UMIT_HEAD_MAKE_SIZE_MULTIPLE);
  FSize := lSize;

end;

procedure TFitsUmitHead.MakeNewcomer(ASpec: TFitsUmitSpec);
begin

  // suppress hint

  if Assigned(ASpec) then
    ;

  // presize

  FSize := FUmit.GetEstimateSize;
  if FSize < cSizeBlock then
    raise EFitsClassesException.CreateFmt(SHeadMakeSmallSize, [FUmit.Index], ERROR_UMIT_HEAD_MAKE_SIZE_SMALL);

  // initialize a header

  if FUmit.Index = 0 then
  begin
    Write(0, CardSimple, cCastBoolean);
    Write(1, CardBITPIX(bi08u), cCastInteger);
    Write(2, CardNAXIS(0), cCastInteger);
    // Write(3, CardExtend, cCastBoolean);
    Write(3, cEND);
  end
  else
  begin
    Write(0, CardXtension(FUmit.ClassFamily), cCastString);
    Write(1, CardBITPIX(bi08u), cCastInteger);
    Write(2, CardNAXIS(0), cCastInteger);
    Write(3, CardPCOUNT(0), cCastInteger);
    Write(4, CardGCOUNT(1), cCastInteger);
    Write(5, cEND);
  end;

end;

function TFitsUmitHead.GetOffset: Int64;
begin
  Result := FUmit.Offset;
end;

function TFitsUmitHead.GetCize: Int64;
var
  Key: string;
begin
  Result := FSize;
  Key := DeLaFitsString.Blank(cSizeKeyword);
  while Result > cSizeLine do
  begin
    FUmit.Container.Content.ReadString(Offset + Result - cSizeLine, cSizeKeyword, Key);
    if SameText(Trim(Key), cEND) then
      Break;
    Dec(Result, cSizeLine);
  end;
end;

function TFitsUmitHead.GetFormatLine: PFormatLine;
begin
  Result := @FFormatLine;
end;

function TFitsUmitHead.GetLine(Index: Integer): string;
begin
  Read(Index, Result, 1);
end;

procedure TFitsUmitHead.SetLine(Index: Integer; Line: string);
begin
  Line := AlignStrict(Line, -cSizeLine);
  Write(Index, Line);
end;

function TFitsUmitHead.GetCard(Index, Cast: Integer): TCard;
begin
  Read(Index, Result, Cast);
end;

procedure TFitsUmitHead.SetCard(Index, Cast: Integer; Card: TCard);
begin
  Write(Index, Card, Cast);
end;

function TFitsUmitHead.GetKeyword(Index: Integer): string;
begin
  if (Index < 0) or (Index >= Capacity) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_UMIT_HEAD_GET_KEYWORD_INDEX);
  Result := DeLaFitsString.Blank(cSizeKeyword);
  FUmit.Container.Content.ReadString(Offset + Int64(Index) * cSizeLine, cSizeKeyword, Result);
  Result := Trim(Result);
end;

procedure TFitsUmitHead.SetKeyword(Index: Integer; Keyword: string);
begin
  if (Index < 0) or (Index >= Capacity) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_UMIT_HEAD_SET_KEYWORD_INDEX);
  Keyword := AlignStrict(Keyword, -cSizeKeyword);
  Keyword := UpperCase(Keyword);
  FUmit.Container.Content.WriteString(Offset + Int64(Index) * cSizeLine, cSizeKeyword, Keyword);
end;

function TFitsUmitHead.GetValueStr(Index: Integer; Cast: Integer): string;
begin
  Result := Cards[Index, Cast].Value.Str;
end;

procedure TFitsUmitHead.SetValueStr(Index: Integer; Cast: Integer; Value: string);
var
  Card: TCard;
begin
  Card := Cards[Index, cCastChars];
  Card.Value.Str := Value;
  Cards[Index, Cast] := Card;
end;

function TFitsUmitHead.GetValueBol(Index: Integer; Cast: Integer): Boolean;
begin
  Result := Cards[Index, Cast].Value.Bol;
end;

procedure TFitsUmitHead.SetValueBol(Index: Integer; Cast: Integer; Value: Boolean);
var
  Card: TCard;
begin
  Card := Cards[Index, cCastChars];
  Card.Value.Bol := Value;
  Cards[Index, Cast] := Card;
end;

function TFitsUmitHead.GetValueInt(Index: Integer; Cast: Integer): Int64;
begin
  Result := Cards[Index, Cast].Value.Int;
end;

procedure TFitsUmitHead.SetValueInt(Index: Integer; Cast: Integer; Value: Int64);
var
  Card: TCard;
begin
  Card := Cards[Index, cCastChars];
  Card.Value.Int := Value;
  Cards[Index, Cast] := Card;
end;

function TFitsUmitHead.GetValueExt(Index: Integer; Cast: Integer): Extended;
begin
  Result := Cards[Index, Cast].Value.Ext;
end;

procedure TFitsUmitHead.SetValueExt(Index: Integer; Cast: Integer; Value: Extended);
var
  Card: TCard;
begin
  Card := Cards[Index, cCastChars];
  Card.Value.Ext := Value;
  Cards[Index, Cast] := Card;
end;

function TFitsUmitHead.GetValueDtm(Index: Integer; Cast: Integer): TDateTime;
begin
  Result := Cards[Index, Cast].Value.Dtm;
end;

procedure TFitsUmitHead.SetValueDtm(Index: Integer; Cast: Integer; Value: TDateTime);
var
  Card: TCard;
begin
  Card := Cards[Index, cCastChars];
  Card.Value.Dtm := Value;
  Cards[Index, Cast] := Card;
end;

function TFitsUmitHead.GetNote(Index: Integer): string;
begin
  Result := Cards[Index, cCastChars].Note;
end;

procedure TFitsUmitHead.SetNote(Index: Integer; Note: string);
var
  Card: TCard;
begin
  Card := Cards[Index, cCastChars];
  Note := Trim(Note);
  Card.Note := Note;
  Card.NoteIndicate := Note <> '';
  Cards[Index, cCastChars] := Card;
end;

function TFitsUmitHead.GetText: string;
begin
  Read(0, Result, Count);
end;

function TFitsUmitHead.GetCount: Integer;
begin
  Result := Cize div cSizeLine;
end;

function TFitsUmitHead.GetCapacity: Integer;
begin
  Result := Size div cSizeLine;
end;

procedure TFitsUmitHead.Init;
begin
  FUmit := nil;
  FSize := 0;
  FFormatLine := FormatLineDefault;
end;

constructor TFitsUmitHead.CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean);
begin
  inherited Create;
  Init;
  Bind(AUmit);
  MakeExplorer(APioneer);
end;

constructor TFitsUmitHead.CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec);
begin
  inherited Create;
  Init;
  Bind(AUmit);
  MakeNewcomer(ASpec);
end;

procedure TFitsUmitHead.BeforeDestruction;
begin
  if not FUmit.Container.FInspect then
    raise EFitsClassesException.CreateFmt(SFreeNoInspect, [FUmit.Index], ERROR_UMIT_HEAD_FREE_INSPECT);
  inherited;
end;

destructor TFitsUmitHead.Destroy;
begin
  FUmit := nil;
  inherited;
end;

function TFitsUmitHead.CardToLine(Card: TCard; Cast: Integer): string;
var
  S: string;
  I, L, N: Integer;
begin
  case Cast of
    cCastChars:
      begin
        S := DeLaFitsString.Align(Card.Value.Str, FFormatLine.vaStr.wWidth);
      end;
    cCastText:
      begin
        S := Card.Value.Str;
        L := Length(S);
        N := cSizeLine - cSizeKeyword - 2;
        I := 1;
        Result := '';
        repeat
          Card.Value.Str := Copy(S, I, N);
          Card.Value.Str := DeLaFitsString.Align(Card.Value.Str, FFormatLine.vaStr.wWidth);
          Result := Result + DeLaFitsString.CardToLine(Card);
          Inc(I, N);
        until I > L;
        Exit;
      end;
    cCastString:
      begin
        S := DeLaFitsString.Quoted(Card.Value.Str, FFormatLine.vaStr.wWidthQuoteInside);
        S := DeLaFitsString.Align(S, FFormatLine.vaStr.wWidth);
      end;
    cCastBoolean:
      begin
        S := DeLaFitsString.BolToStri(Card.Value.Bol);
        S := DeLaFitsString.Align(S, FFormatLine.vaBol.wWidth);
      end;
    cCastInteger:
      begin
        S := DeLaFitsString.IntToStri(Card.Value.Int, FFormatLine.vaInt.wSign, FFormatLine.vaInt.wFmt);
        S := DeLaFitsString.Align(S, FFormatLine.vaInt.wWidth);
      end;
    cCastFloat:
      begin
        S := DeLaFitsString.FloatToStri(Card.Value.Ext, FFormatLine.vaFloat.wSign, FFormatLine.vaFloat.wFmt);
        S := DeLaFitsString.Align(S, FFormatLine.vaFloat.wWidth);
      end;
    cCastRa:
      begin
        S := DeLaFitsString.RaToStri(Card.Value.Ext, FFormatLine.vaCoord.wPrecRa, FFormatLine.vaCoord.wFmtRepCoord, FFormatLine.vaCoord.wFmtMeaRa);
        S := DeLaFitsString.Quoted(S, FFormatLine.vaCoord.wWidthQuoteInside);
        S := DeLaFitsString.Align(S, FFormatLine.vaCoord.wWidth);
      end;
    cCastDe:
      begin
        S := DeLaFitsString.DeToStri(Card.Value.Ext, FFormatLine.vaCoord.wPrecDe, FFormatLine.vaCoord.wFmtRepCoord);
        S := DeLaFitsString.Quoted(S, FFormatLine.vaCoord.wWidthQuoteInside);
        S := DeLaFitsString.Align(S, FFormatLine.vaCoord.wWidth);
      end;
    cCastDateTime, cCastDate, cCastTime:
      begin
        S := DeLaFitsString.DateTimeToStri(Card.Value.Dtm, Cast);
        S := DeLaFitsString.Quoted(S, FFormatLine.vaDateTime.wWidthQuoteInside);
        S := DeLaFitsString.Align(S, FFormatLine.vaDateTime.wWidth);
      end;
    else
      begin
        S := '';
        raise EFitsClassesException.CreateFmt(SUnknownCastCard, [Cast], ERROR_UMIT_HEAD_CAST_CARD);
      end;
  end;
  Card.Value.Str := S;
  Result := DeLaFitsString.CardToLine(Card);
end;

function TFitsUmitHead.LineToCard(Line: string; Cast: Integer): TCard;
var
  S: string;
  I, L, N: Integer;
  IsFirstChrBlank: Boolean;
begin
  Result := DeLaFitsString.LineToCard(Line);
  S := Result.Value.Str;
  Result.Value.Str := '';
  case Cast of
    cCastChars:
      begin
        Result.Value.Str := S;
      end;
    cCastText:
      begin
        L := Length(Line);
        N := cSizeLine;
        I := cSizeLine + 1;
        IsFirstChrBlank := Pos(cChrBlank, S) = 1;
        if IsFirstChrBlank then
          S := Copy(S, 2, Length(S));
        while I <= L do
        begin
          Result := DeLaFitsString.LineToCard(Copy(Line, I, cSizeLine));
          if IsFirstChrBlank and (Pos(cChrBlank, Result.Value.Str) = 1) then
            S := S + Copy(Result.Value.Str, 2, Length(Result.Value.Str))
          else
            S := S + Result.Value.Str;
          Inc(I, N);
        end;
        Result.Value.Str := S;
      end;
    cCastString:
      begin
        Result.Value.Str := DeLaFitsString.UnQuoted(S);
      end;
    cCastBoolean:
      begin
        Result.Value.Bol := DeLaFitsString.StriToBol(S);
      end;
    cCastInteger:
      begin
        Result.Value.Int := DeLaFitsString.StriToInt(S);
      end;
    cCastFloat:
      begin
        Result.Value.Ext := DeLaFitsString.StriToFloat(S);
      end;
    cCastRa:
      begin
        S := DeLaFitsString.UnQuoted(S);
        Result.Value.Ext := DeLaFitsString.StriToRa(S);
      end;
    cCastDe:
      begin
        S := DeLaFitsString.UnQuoted(S);
        Result.Value.Ext := DeLaFitsString.StriToDe(S);
      end;
    cCastDateTime, cCastDate, cCastTime:
      begin
        S := DeLaFitsString.UnQuoted(S);
        Result.Value.Dtm := DeLaFitsString.StriToDateTime(S, Cast, FFormatLine.vaDateTime.rFmtShortDate);
      end;
    else
      begin
        raise EFitsClassesException.CreateFmt(SUnknownCastLine, [Cast], ERROR_UMIT_HEAD_CAST_LINE);
      end;
  end;
end;

procedure TFitsUmitHead.Read(Index: Integer; out Line: string; ACount: Integer);
var
  lOffset, lCount: Int64;
begin
  if (Index < 0) or (Index >= Capacity) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_UMIT_HEAD_READ_INDEX);
  if (ACount < 0) or ((Index + ACount) > Capacity) then
    raise EFitsClassesException.CreateFmt(SCountValueOutBounds, [ACount], ERROR_UMIT_HEAD_READ_COUNT);
  if ACount = 0 then
  begin
    Line := '';
    Exit;
  end;
  lCount := Int64(ACount) * cSizeLine;
  lOffset := Offset + Int64(Index) * cSizeLine;
  Line := DeLaFitsString.Blank(lCount);
  FUmit.Container.Content.ReadString(lOffset, lCount, Line);
end;

procedure TFitsUmitHead.Read(Index: Integer; out Card: TCard; Cast: Integer);
var
  Line, Key, Line1, Key1: string;
  lOffset, lOffsetMax: Int64;
begin
  if (Index < 0) or (Index >= Capacity) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_UMIT_HEAD_READ_INDEX);
  lOffset := Offset +  Int64(Index) * cSizeLine;
  Line := DeLaFitsString.Blank(cSizeLine);
  FUmit.Container.Content.ReadString(lOffset, cSizeLine, Line);
  if Cast = cCastText then
  begin
    Key := Copy(Line, 1, cSizeKeyword);
    lOffset := lOffset + cSizeLine;
    lOffsetMax := Offset + Size;
    Line1 := DeLaFitsString.Blank(cSizeLine);
    while lOffset < lOffsetMax do
    begin
      FUmit.Container.Content.ReadString(lOffset, cSizeLine, Line1);
      Key1 := Copy(Line1, 1, cSizeKeyword);
      if Key <> Key1 then
        Break;
      Line := Line + Line1;
      Inc(lOffset, cSizeLine);
    end;
  end;
  Card := LineToCard(Line, Cast);
end;

procedure TFitsUmitHead.Write(Index: Integer; Line: string);
var
  lOffset, lCount: Int64;
begin
  if (Index < 0) or (Index >= Capacity) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_UMIT_HEAD_WRITE_INDEX);
  if Line = '' then
    Exit;
  lCount := CeilToRank(Length(Line), cSizeLine);
  lOffset := Offset + Int64(Index) * cSizeLine;
  if (lOffset + lCount) > (Offset + Size) then
    raise EFitsClassesException.CreateFmt(SCountValueOutBounds, [lCount], ERROR_UMIT_HEAD_WRITE_COUNT);
  Line := AlignStrict(Line, -lCount);
  FUmit.Container.Content.WriteString(lOffset, lCount, Line);
end;

procedure TFitsUmitHead.Write(Index: Integer; Card: TCard; Cast: Integer);
var
  Line: string;
begin
  if (Index < 0) or (Index >= Capacity) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_UMIT_HEAD_WRITE_INDEX);
  Line := CardToLine(Card, Cast);
  Write(Index, Line);
end;

function TFitsUmitHead.IndexOf(const Keyword: string; StartIndex: Integer = 0): Integer;
var
  I: Integer;
  lOffset: Int64;
  Key: string;
begin
  Result := -1;
  if StartIndex < 0 then
    Exit;
  lOffset := Offset;
  Key := DeLaFitsString.Blank(cSizeKeyword);
  for I := StartIndex to Count - 1 do
  begin
    FUmit.Container.Content.ReadString(lOffset + Int64(I) * cSizeLine, cSizeKeyword, Key);
    if SameText(Trim(Key), Keyword) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TFitsUmitHead.IndexOfLastNaxes: Integer;
var
  I, N, Res: Integer;
  Key: string;
begin
  Result := IndexOf(cNAXIS);
  if Result >= 0 then
  begin
    N := ValuesInteger[Result];
    for I := N downto 1 do
    begin
      Key := Format(cNAXISn, [I]);
      Res := IndexOf(Key);
      if Res >= 0 then
      begin
        Result := Res;
        Break;
      end;
    end;
  end;
end;

function TFitsUmitHead.Add(const Line: string): Integer;
begin
  Result := Count - 1;
  Insert(Result, Line);
end;

function TFitsUmitHead.Add(const Card: TCard; Cast: Integer): Integer;
var
  Line: string;
begin
  Line := CardToLine(Card, Cast);
  Result := Add(Line);
end;

function TFitsUmitHead.AddChars(Keyword, Value, Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastChars);
end;

function TFitsUmitHead.AddString(Keyword, Value, Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastString);
end;

function TFitsUmitHead.AddText(Keyword, Value: string): Integer;
begin
  Result := Add(ToCard(Keyword, False, Value, False, ''), cCastText);
end;

function TFitsUmitHead.AddHistory(Value: string): Integer;
begin
  Result := AddText(cHISTORY, Value);
end;

function TFitsUmitHead.AddComment(Value: string): Integer;
begin
  Result := AddText(cCOMMENT, Value);
end;

function TFitsUmitHead.AddBlank: Integer;
begin
  Result := Add(cChrBlank);
end;

function TFitsUmitHead.AddBoolean(Keyword: string; Value: Boolean; Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastBoolean);
end;

function TFitsUmitHead.AddInteger(Keyword: string; Value: Int64; Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastInteger);
end;

function TFitsUmitHead.AddFloat(Keyword: string; Value: Extended; Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastFloat);
end;

function TFitsUmitHead.AddRa(Keyword: string; Value: Extended; Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastRa);
end;

function TFitsUmitHead.AddDe(Keyword: string; Value: Extended; Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastDe);
end;

function TFitsUmitHead.AddDateTime(Keyword: string; Value: TDateTime; Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastDateTime);
end;

function TFitsUmitHead.AddDate(Keyword: string; Value: TDateTime; Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastDate);
end;

function TFitsUmitHead.AddTime(Keyword: string; Value: TDateTime; Note: string): Integer;
begin
  Result := Add(ToCard(Keyword, True, Value, Note <> '', Note), cCastTime);
end;

procedure TFitsUmitHead.Insert(Index: Integer; Line: string);
var
  lOffset, lCount, lShiftCount: Int64;
  lStock, lGrow: Int64;
begin
  if (Index < 0) or (Index >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_UMIT_HEAD_INSERT_INDEX);
  if Line = '' then
    Exit;
  // get offset and size a new block for write
  lCount := CeilToRank(Length(Line), cSizeLine);
  lOffset := Offset + Int64(Index) * cSizeLine;
  Line := AlignStrict(Line, -lCount);
  // get size a block for shift
  lShiftCount := (Count - Int64(Index)) * cSizeLine;
  // get real stock size after END
  lStock := Size - Cize;
  if lCount > lStock then
  begin
    lGrow := lCount - lStock;
    lGrow := CeilToRank(lGrow, cSizeBlock);
    FUmit.Container.Content.Resize(Offset + Size, lGrow);
    FUmit.Container.Content.Fill(Offset + Size, lGrow, cChrBlank);
    FSize := FSize + lGrow;
  end;
  FUmit.Container.Content.Shift(lOffset, lShiftCount, lCount);
  FUmit.Container.Content.WriteString(lOffset, lCount, Line);
end;

procedure TFitsUmitHead.Insert(Index: Integer; const Card: TCard; Cast: Integer);
var
  Line: string;
begin
  if (Index < 0) or (Index >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_UMIT_HEAD_INSERT_INDEX);
  Line := CardToLine(Card, Cast);
  Insert(Index, Line);
end;

procedure TFitsUmitHead.InsertChars(Index: Integer; Keyword: string; Value: string; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastChars);
end;

procedure TFitsUmitHead.InsertString(Index: Integer; Keyword: string; Value: string; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastString);
end;

procedure TFitsUmitHead.InsertText(Index: Integer; Keyword: string; Value: string);
begin
  Insert(Index, ToCard(Keyword, False, Value, False, ''), cCastText);
end;

procedure TFitsUmitHead.InsertHistory(Index: Integer; Value: string);
begin
  InsertText(Index, cHISTORY, Value);
end;

procedure TFitsUmitHead.InsertComment(Index: Integer; Value: string);
begin
  InsertText(Index, cCOMMENT, Value);
end;

procedure TFitsUmitHead.InsertBlank(Index: Integer);
begin
  Insert(Index, cChrBlank);
end;

procedure TFitsUmitHead.InsertBoolean(Index: Integer; Keyword: string; Value: Boolean; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastBoolean);
end;

procedure TFitsUmitHead.InsertInteger(Index: Integer; Keyword: string; Value: Int64; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastInteger);
end;

procedure TFitsUmitHead.InsertFloat(Index: Integer; Keyword: string; Value: Extended; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastFloat);
end;

procedure TFitsUmitHead.InsertRa(Index: Integer; Keyword: string; Value: Extended; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastRa);
end;

procedure TFitsUmitHead.InsertDe(Index: Integer; Keyword: string; Value: Extended; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastDe);
end;

procedure TFitsUmitHead.InsertDateTime(Index: Integer; Keyword: string; Value: TDateTime; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastDateTime);
end;

procedure TFitsUmitHead.InsertDate(Index: Integer; Keyword: string; Value: TDateTime; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastDate);
end;

procedure TFitsUmitHead.InsertTime(Index: Integer; Keyword: string; Value: TDateTime; Note: string);
begin
  Insert(Index, ToCard(Keyword, True, Value, Note <> '', Note), cCastTime);
end;

function TFitsUmitHead.AppendString(Keyword, Value, Note: string; HopIndex: Integer = -1): Integer;
begin
  Result := IndexOf(Keyword);
  if Result >= 0 then
  begin
    ValuesString[Result] := Value;
    Exit;
  end;
  Result := HopIndex;
  if Result >= 0 then
  begin
    InsertString(Result, Keyword, Value, Note);
    Exit;
  end;
  Result := AddString(Keyword, Value, Note);
end;

function TFitsUmitHead.AppendInteger(Keyword: string; Value: Int64; Note: string; HopIndex: Integer = -1): Integer;
begin
  Result := IndexOf(Keyword);
  if Result >= 0 then
  begin
    ValuesInteger[Result] := Value;
    Exit;
  end;
  Result := HopIndex;
  if Result >= 0 then
  begin
    InsertInteger(Result, Keyword, Value, Note);
    Exit;
  end;
  Result := AddInteger(Keyword, Value, Note);
end;

function TFitsUmitHead.AppendFloat(Keyword: string; Value: Extended; Note: string; HopIndex: Integer = -1): Integer;
var
  wFmt: string;
begin
  wFmt := FormatLine^.vaFloat.wFmt;
  FormatLine^.vaFloat.wFmt := '%e';
  try
    Result := IndexOf(Keyword);
    if Result >= 0 then
    begin
      ValuesFloat[Result] := Value;
      Exit;
    end;
    Result := HopIndex;
    if Result >= 0 then
    begin
      InsertFloat(Result, Keyword, Value, Note);
      Exit;
    end;
    Result := AddFloat(Keyword, Value, Note);
  finally
     FormatLine^.vaFloat.wFmt := wFmt;
  end;
end;

procedure TFitsUmitHead.Delete(AIndex, ACount: Integer);
var
  Offset1, Count1, Offset2, Count2, Offset3, Count3: Int64;
begin
  if (AIndex < 0) or (AIndex >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [AIndex], ERROR_UMIT_HEAD_DELETE_INDEX);
  if (ACount < 0) or ((AIndex + ACount) > Count) then
    raise EFitsClassesException.CreateFmt(SCountValueOutBounds, [ACount], ERROR_UMIT_HEAD_DELETE_COUNT);
  if ACount = 0 then
    Exit;
  // |block1-block2-block3-...|
  // ~ block2 candidate on remove
  Offset1 := Offset;
  Count1  := Int64(AIndex) * cSizeLine;
  Offset2 := Offset1 + Count1;
  Count2  := Int64(ACount) * cSizeLine;
  Offset3 := Offset2 + Count2;
  Count3  := Cize - (Count1 + Count2);
  // shift block3
  FUmit.Container.Content.Shift(Offset3, Count3, -Count2);
  // |block1-block2|
  // ~ block2 ~ candidate on reduction
  Offset1 := Offset;
  Count1  := Count1 + Count3;
  Offset2 := Offset1 + Count1;
  Count2  := Size - Count1;
  // expand block1
  Offset1 := Offset2;
  Count1  := CeilToRank(Count1, cSizeBlock) - Count1;
  FUmit.Container.Content.Fill(Offset1, Count1, cChrBlank);
  // reduction block2
  Offset2 := Offset2 - Count1;
  Count2  := Count2 - Count1;
  if Count2 > 0 then
  begin
    FUmit.Container.Content.Resize(Offset2, -Count2);
    FSize := FSize - Count2;
  end;
end;

procedure TFitsUmitHead.Delete(const Keys: array of string);
var
  I, N, lCount: Integer;
  Key: string;
begin
  I := 0;
  N := Count;
  lCount := 0;
  Key := DeLaFitsString.Blank(cSizeKeyword);
  while I < N do
  begin
    FUmit.Container.Content.ReadString(Offset + Int64(I) * cSizeLine, cSizeKeyword, Key);
    if MatchIndex(Trim(Key), Keys) >= 0 then
    begin
      Inc(lCount);
      Inc(I);
    end
    else if lCount > 0 then
    begin
      Dec(I, lCount);
      Dec(N, lCount);
      Delete(I, lCount);
      lCount := 0;
    end
    else
      Inc(I);
  end;
end;

procedure TFitsUmitHead.Exchange(Index1, Index2: Integer);
var
  lOffset1, lOffset2: Int64;
begin
  if (Index1 < 0) or (Index1 >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index1], ERROR_UMIT_HEAD_EXCHANGE_INDEX);
  if (Index2 < 0) or (Index2 >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index2], ERROR_UMIT_HEAD_EXCHANGE_INDEX);
  if Index1 = Index2 then
    Exit;
  lOffset1 := Offset + Int64(Index1) * cSizeLine;
  lOffset2 := Offset + Int64(Index2) * cSizeLine;
  FUmit.Container.Content.Exchange(lOffset1, cSizeLine, lOffset2, cSizeLine);
end;

procedure TFitsUmitHead.Move(CurIndex, NewIndex: Integer);
var
  lCurOffset, lNewOffset: Int64;
begin
  if (CurIndex < 0) or (CurIndex >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [CurIndex], ERROR_UMIT_HEAD_MOVE_INDEX);
  if (NewIndex < 0) or (NewIndex >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [NewIndex], ERROR_UMIT_HEAD_MOVE_INDEX);
  if CurIndex = NewIndex then
    Exit;
  lCurOffset := Offset + Int64(CurIndex) * cSizeLine;
  lNewOffset := Offset + Int64(NewIndex) * cSizeLine;
  if CurIndex < NewIndex then
    lNewOffset := lNewOffset + cSizeLine - 1;
  FUmit.Container.Content.Move(lCurOffset, cSizeLine, lNewOffset);
end;

{ TFitsUmitData }

procedure TFitsUmitData.Bind(AUmit: TFitsUmit);
begin
  if not Assigned(AUmit) then
    raise EFitsClassesException.Create(SUmitNotAssign, ERROR_UMIT_DATA_BIND_ASSIGN);
  if not AUmit.Container.FInspect then
    raise EFitsClassesException.Create(SBindNoInspect, ERROR_UMIT_DATA_BIND_INSPECT);
  if not Assigned(AUmit.Head) then
    raise EFitsClassesException.Create(SHeadNotAssign, ERROR_UMIT_DATA_BIND_NOHEAD);
  FUmit := AUmit;
  FUmit.FData := Self;
end;

procedure TFitsUmitData.MakeExplorer(APioneer: Boolean);
var
  DeclareSize: Int64;
  EstimateSize: Int64;
  CorrectSize: Boolean;
begin
  // compute and set a data size
  DeclareSize := ZeroToRank(Cize, cSizeBlock);
  EstimateSize := FUmit.GetEstimateSize - FUmit.Head.Size;
  if APioneer then
    CorrectSize := DeclareSize <= EstimateSize
  else
    CorrectSize := DeclareSize = EstimateSize;
  if not CorrectSize then
    raise EFitsClassesException.CreateFmt(SDataIncorrectSize, [FUmit.Index, DeclareSize], ERROR_UMIT_DATA_MAKE_SIZE);
  FSize := DeclareSize;
end;

procedure TFitsUmitData.MakeNewcomer(ASpec: TFitsUmitSpec);
begin
  // suppress hint
  if Assigned(ASpec) then
    ;
  // presize ~ 0
  FSize := FUmit.GetEstimateSize - FUmit.Head.Size;
end;

function TFitsUmitData.GetOffset: Int64;
begin
  Result := FUmit.Head.Offset + FUmit.Head.Size;
end;

function TFitsUmitData.GetPcount: Integer;
begin
  Result := FUmit.PCOUNT;
end;

function TFitsUmitData.GetAxes(Index: Integer): Integer;
begin
  Result := FUmit.NAXES[Index + 1];
end;

function TFitsUmitData.GetAxis: Integer;
begin
  Result := FUmit.NAXIS;
end;

function TFitsUmitData.GetBitPix: TBitPix;
begin
  Result := IntToBitPix(FUmit.BITPIX);
end;

function TFitsUmitData.GetSizPix: Byte;
begin
  Result := BitPixSize(FUmit.BITPIX);
end;

function TFitsUmitData.GetCize: Int64;
var
  I: Integer;
  lAxes: array of Integer;
begin

  if Axis = 0 then
  begin
    Result := 0;
    Exit;
  end;

  lAxes := nil;
  try
    SetLength(lAxes, Axis);
    for I := 0 to Axis - 1 do
      lAxes[I] := Axes[I];
    // NAXIS1 can be zero value for random groups structure
    if lAxes[0] = 0 then
      lAxes[0] := 1;
    // The FITS Standard (version 4.0), 4.4.1.2. "Conforming extensions", page 12
    // Nbits = |BITPIX|  * GCOUNT * (PCOUNT + NAXIS1 * NAXIS2 * ...)
    Result := 1;
    for I := 0 to Axis - 1 do
      Result := Result * Int64(lAxes[I]);
    Result := Int64(SizPix) * Int64(Gcount) * (Int64(Pcount) + Result);
  finally
    lAxes := nil;
  end;

end;

function TFitsUmitData.GetGcount: Integer;
begin
  Result := FUmit.GCOUNT;
end;

procedure TFitsUmitData.Init;
begin
  FUmit := nil;
  FSize := 0;
end;

constructor TFitsUmitData.CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean);
begin
  inherited Create;
  Init;
  Bind(AUmit);
  MakeExplorer(APioneer);
end;

constructor TFitsUmitData.CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec);
begin
  inherited Create;
  Init;
  Bind(AUmit);
  MakeNewcomer(ASpec);
end;

procedure TFitsUmitData.BeforeDestruction;
begin
  if not FUmit.Container.FInspect then
    raise EFitsClassesException.CreateFmt(SFreeNoInspect, [FUmit.Index], ERROR_UMIT_DATA_FREE_INSPECT);
  inherited;
end;

destructor TFitsUmitData.Destroy;
begin
  FUmit := nil;
  inherited;
end;

function TFitsUmitData.Filler: Char;
begin
  Result := cChrNull;
end;

procedure TFitsUmitData.Read(const Uffset, ASize: Int64; var ABuffer);
begin
  if not DeLaFitsMath.InContent(0, Size, Uffset, ASize) then
    raise EFitsClassesException.CreateFmt(SDataIncorrectBounds, [FUmit.Index, Uffset, ASize], ERROR_UMIT_DATA_READ_BOUNDS);
  FUmit.Container.Content.Read(Offset + Uffset, ASize, ABuffer);
end;

procedure TFitsUmitData.Write(const Uffset, ASize: Int64; const ABuffer);
begin
  if not DeLaFitsMath.InContent(0, Size, Uffset, ASize) then
    raise EFitsClassesException.CreateFmt(SDataIncorrectBounds, [FUmit.Index, Uffset, ASize], ERROR_UMIT_DATA_WRITE_BOUNDS);
  FUmit.Container.Content.Write(Offset + Uffset, ASize, ABuffer);
end;

procedure TFitsUmitData.Erase(const Uffset, ASize: Int64);
begin
  if not DeLaFitsMath.InContent(0, Size, Uffset, ASize) then
    raise EFitsClassesException.CreateFmt(SDataIncorrectBounds, [FUmit.Index, Uffset, ASize], ERROR_UMIT_DATA_ERASE_BOUNDS);
  FUmit.Container.Content.Fill(Offset + Uffset, ASize, Filler);
end;

procedure TFitsUmitData.Delete(const Uffset, ASize: Int64);
var
  Rank: Int64;

begin

  if not DeLaFitsMath.InContent(0, Size, Uffset, ASize) then
    raise EFitsClassesException.CreateFmt(SDataIncorrectBounds, [FUmit.Index, Uffset, ASize], ERROR_UMIT_DATA_DELETE_BOUNDS);

  // delete custom block

  FUmit.Container.Content.Resize(Offset + Uffset, -ASize);
  FSize := FSize - ASize;

  // align content size

  Rank := ZeroToRank(FSize, cSizeBlock) - FSize;
  FUmit.Container.Content.Resize(Offset + FSize, Rank);
  FUmit.Container.Content.Fill(Offset + FSize, Rank, Filler);
  FSize := FSize + Rank;

end;

procedure TFitsUmitData.Truncate(const ASize: Int64);
var
  lSize: Int64;
begin

  if not InRange(ASize, 0, Size) then
    raise EFitsClassesException.CreateFmt(SDataIncorrectSize, [FUmit.Index, ASize], ERROR_UMIT_DATA_TRUNCATE_SIZE);

  // truncate an integer number of blocks

  lSize := (ASize div cSizeBlock) * cSizeBlock;
  FUmit.Container.Content.Resize(Offset + (FSize - lSize), -lSize);
  FSize := FSize - lSize;

  // erase to an aligned block
  // mod function behavior: if ASize < cSizeBlock then mod return ASize value

  lSize := ASize mod cSizeBlock;
  FUmit.Container.Content.Fill(Offset + (FSize - lSize), lSize, Filler);

end;

procedure TFitsUmitData.Insert(const Uffset, ASize: Int64);
var
  Rank: Int64;
begin

  if not DeLaFitsMath.InContent(0, Size, Uffset) then
    raise EFitsClassesException.CreateFmt(SDataIncorrectUffset, [FUmit.Index, Uffset], ERROR_UMIT_DATA_ERASE_UFSSET);

  if ASize < 0 then
    raise EFitsClassesException.CreateFmt(SDataIncorrectSize, [FUmit.Index, ASize], ERROR_UMIT_DATA_ERASE_SIZE);

  // insert custom block

  FUmit.Container.Content.Resize(Offset + Uffset, ASize);
  FSize := FSize + ASize;

  // align content size

  Rank := ZeroToRank(FSize, cSizeBlock) - FSize;
  FUmit.Container.Content.Resize(Offset + FSize, Rank);
  FUmit.Container.Content.Fill(Offset + FSize, Rank, Filler);
  FSize := FSize + Rank;

end;

procedure TFitsUmitData.Add(const ASize: Int64);
var
  lSize: Int64;
begin

  if ASize < 0 then
    raise EFitsClassesException.CreateFmt(SDataIncorrectSize, [FUmit.Index, ASize], ERROR_UMIT_DATA_ADD_SIZE);

  // added aligned block

  lSize := ZeroToRank(ASize, cSizeBlock);
  FUmit.Container.Content.Resize(Offset + FSize, lSize);
  FSize := FSize + lSize;

  // erase to an aligned block

  lSize := ZeroToRank(ASize, cSizeBlock) - ASize;
  FUmit.Container.Content.Fill(Offset + (FSize - lSize), lSize, Filler);

end;

{ TFitsUmit }

const
  cImageXtension = 'IMAGE';

procedure TFitsUmit.Bind(AContainer: TFitsContainer);
begin
  if not Assigned(AContainer) then
    raise EFitsClassesException.Create(SContainerNotAssign, ERROR_UMIT_BIND_ASSIGN);
  if not AContainer.FInspect then
    raise EFitsClassesException.Create(SBindNoInspect, ERROR_UMIT_BIND_INSPECT);
  FContainer := AContainer;
  FContainer.Embed(Self);
end;

procedure TFitsUmit.MakeExplorer(APioneer: Boolean);
begin
  // FHead is set in GetHeadClass.Bind() method
  try
    FHead := GetHeadClass.CreateExplorer(Self, APioneer);
  except
    FHead := nil;
    raise;
  end;
  // FData is set in GetDataClass.Bind() method
  try
    FData := GetDataClass.CreateExplorer(Self, APioneer);
  except
    FData := nil;
    raise;
  end;
end;

procedure TFitsUmit.MakeNewcomer(ASpec: TFitsUmitSpec);
begin
  // FHead is set in GetHeadClass.Bind() method
  try
    FHead := GetHeadClass.CreateNewcomer(Self, ASpec);
  except
    FHead := nil;
    raise;
  end;
  // FData is set in GetDataClass.Bind() method
  try
    FData := GetDataClass.CreateNewcomer(Self, ASpec);
  except
    FData := nil;
    raise;
  end;
end;

function TFitsUmit.CanPrimary: Boolean;
begin
  Result := AnsiSameText(Family, cImageXtension);
end;

procedure TFitsUmit.Reorder(AType: TOrderType);

  procedure FHead_Delete(const Keyword: string);
  var
    I: Integer;
  begin
    I := FHead.IndexOf(Keyword, 1);
    if I > 0 then
      FHead.Delete(I);
  end;

var
  I, J: Integer;

begin
  if not Assigned(FHead) then
    Exit;
  case AType of
    otNone:
      ;
    otSing:
      begin
        FHead.Write(0, CardSimple, cCastBoolean);
        FHead_Delete(cEXTEND);
        FHead_Delete(cPCOUNT);
        FHead_Delete(cGCOUNT);
      end;
    otPrim:
      begin
        FHead.Write(0, CardSimple, cCastBoolean);
        FHead_Delete(cPCOUNT);
        FHead_Delete(cGCOUNT);
        // append 'EXTEND' header line
        I := FHead.IndexOf(cEXTEND, 1);
        if I > 0 then
        begin
          FHead.Write(I, CardExtend, cCastBoolean);
        end
        else
        begin
          I := FHead.IndexOfLastNaxes;
          I := Math.IfThen(I > 0, I + 1, FHead.Count - 1);
          FHead.Insert(I, CardExtend, cCastBoolean);
        end;
      end;
    otXten:
      begin
        FHead.Write(0, CardXtension(ClassFamily), cCastString);
        FHead_Delete(cEXTEND);
        // append 'PCOUNT' header line
        I := FHead.IndexOfLastNaxes;
        I := Math.IfThen(I > 0, I + 1, FHead.Count - 1);
        J := FHead.IndexOf(cPCOUNT);
        if J < 0 then
          FHead.Insert(I, CardPCOUNT(0), cCastInteger)
        else
          I := J;
        Inc(I);
        // append 'GCOUNT' header line
        if FHead.IndexOf(cGCOUNT) < 0 then
          FHead.Insert(I, CardGCOUNT(1), cCastInteger);
      end;
  end;
end;

function TFitsUmit.GetIndex: Integer;
begin
  Result := FContainer.IndexOf(Self);
end;

function TFitsUmit.GetOffset: Int64;
var
  Ind: Integer;
  Pre: TFitsUmit;
begin
  Result := 0;
  Ind := Index;
  if Ind > 0 then
  begin
    Pre := FContainer.Umits[Ind - 1];
    Result := Pre.Offset + Pre.Size;
  end;
end;

function TFitsUmit.GetSize: Int64;
begin
  Result := 0;
  if Assigned(FHead) and Assigned(FData) then
    Result := FHead.Size + FData.Size;
end;

function TFitsUmit.GetEstimateSize: Int64;
var
  I, Ind: Integer;
begin
  Ind := Index;
  Result := FContainer.Content.Size;
  for I := 0 to FContainer.Count - 1 do
    if I <> Ind then
      Result := Result - FContainer.Umits[I].Size;
end;

function TFitsUmit.GetFamily: string;
begin
  Result := Self.XTENSION;
end;

function TFitsUmit.GetAlias: string;
begin
  Result := Family;
  // The FITS Standard (version 4.0), 6. "Random groups structure", page 16
  // NAXIS1 can be zero value, other NAXISn shall contain a non-negative integer
  if NAXIS > 1 then
    if NAXES[1] = 0 then
      Result := 'RANDOM GROUP';
end;

class function TFitsUmit.ClassFamily: string;
begin
  Result := cImageXtension;
end;

function TFitsUmit.GetName: string;
begin
  Result := Self.EXTNAME;
end;

function TFitsUmit.GetVersion: Integer;
begin
  Result := Self.EXTVER;
end;

function TFitsUmit.GetLevel: Integer;
begin
  Result := Self.EXTVER;
end;

function TFitsUmit.GetXTENSION: string;
var
  Ind: Integer;
begin
  Result := cImageXtension;
  if Index > 0 then
  begin
    Ind := FHead.IndexOf(cXTENSION);
    if Ind >= 0 then
      try
        Result := FHead.ValuesString[Ind];
      except
        Result := cImageXtension;
      end;
  end;
end;

function TFitsUmit.GetEXTNAME: string;
var
  Ind: Integer;
begin
  Ind := FHead.IndexOf(cEXTNAME);
  try
    if Ind >= 0 then
      Result := FHead.ValuesString[Ind]
    else
      Result := ''
  except
    on E: Exception do
      raise EFitsClassesException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETEXTNAME_INVALID);
  end
end;

function TFitsUmit.GetEXTVER: Integer;
var
  Ind: Integer;
begin
  Ind := FHead.IndexOf(cEXTVER);
  try
    if Ind >= 0 then
      Result := Integer(FHead.ValuesInteger[Ind])
    else
      Result := 1
  except
    on E: Exception do
      raise EFitsClassesException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETEXTVER_INVALID);
  end
end;

function TFitsUmit.GetEXTLEVEL: Integer;
var
  Ind: Integer;
begin
  Ind := FHead.IndexOf(cEXTLEVEL);
  try
    if Ind >= 0 then
      Result := Integer(FHead.ValuesInteger[Ind])
    else
      Result := 1
  except
    on E: Exception do
      raise EFitsClassesException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETLEVEL_INVALID);
  end
end;

function TFitsUmit.GetBITPIX: Integer;
const
  Key = cBITPIX;
var
  Ind: Integer;
begin
  if not Assigned(FHead) then
    raise EFitsClassesException.Create(SHeadNotAssign, ERROR_UMIT_GETBITPIX_NOHEAD);
  Ind := FHead.IndexOf(Key);
  if Ind < 0 then
    raise EFitsClassesException.CreateFmt(SKeywordNotFound, [Key, Self.Index], ERROR_UMIT_GETBITPIX_NOTFOUND);
  try
    Result := Integer(FHead.ValuesInteger[Ind]);
  except
    on E: Exception do
      raise EFitsClassesException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETBITPIX_INVALID);
  end;
  if IntToBitPix(Result) = biUnknown then
    raise EFitsClassesException.CreateFmt(SLineValueIncorrect, [Ind, Self.Index], ERROR_UMIT_GETBITPIX_INCORRECT);
end;

function TFitsUmit.GetGCOUNT: Integer;
const
  Key = cGCOUNT;
var
  Ind: Integer;
begin
  if not Assigned(FHead) then
    raise EFitsClassesException.Create(SHeadNotAssign, ERROR_UMIT_GETGCOUNT_NOHEAD);
  Ind := FHead.IndexOf(Key);
  try
    if Ind < 0 then
      Result := 1
    else
      Result := Integer(FHead.ValuesInteger[Ind]);
  except
    on E: Exception do
      raise EFitsClassesException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETGCOUNT_INVALID);
  end;
  if Result < 1 then
    raise EFitsClassesException.CreateFmt(SLineValueIncorrect, [Ind, Self.Index], ERROR_UMIT_GETGCOUNT_INCORRECT);
end;

function TFitsUmit.GetPCOUNT: Integer;
const
  Key = cPCOUNT;
var
  Ind: Integer;
begin
  if not Assigned(FHead) then
    raise EFitsClassesException.Create(SHeadNotAssign, ERROR_UMIT_GETPCOUNT_NOHEAD);
  Ind := FHead.IndexOf(Key);
  try
    if Ind < 0 then
      Result := 0
    else
      Result := Integer(FHead.ValuesInteger[Ind]);
  except
    on E: Exception do
      raise EFitsClassesException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETPCOUNT_INVALID);
  end;
  if Result < 0 then
    raise EFitsClassesException.CreateFmt(SLineValueIncorrect, [Ind, Self.Index], ERROR_UMIT_GETPCOUNT_INCORRECT);
end;

function TFitsUmit.GetNAXIS: Integer;
const
  Key = cNAXIS;
var
  Ind: Integer;
begin
  if not Assigned(FHead) then
    raise EFitsClassesException.Create(SHeadNotAssign, ERROR_UMIT_GETNAXIS_NOHEAD);
  Ind := FHead.IndexOf(Key);
  if Ind < 0 then
    raise EFitsClassesException.CreateFmt(SKeywordNotFound, [Key, Self.Index], ERROR_UMIT_GETNAXIS_NOTFOUND);
  try
    Result := Integer(FHead.ValuesInteger[Ind]);
  except
    on E: Exception do
      raise EFitsClassesException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETNAXIS_INVALID);
  end;
  if not InRange(Result, 0, cMaxAxis) then
    raise EFitsClassesException.CreateFmt(SLineValueIncorrect, [Ind, Self.Index], ERROR_UMIT_GETNAXIS_INCORRECT);
end;

function TFitsUmit.GetNAXES(Number: Integer): Integer;
var
  Key: string;
  Ind, Count: Integer;
begin
  if not Assigned(FHead) then
    raise EFitsClassesException.Create(SHeadNotAssign, ERROR_UMIT_GETNAXES_NOHEAD);
  Count := NAXIS;
  if (Number < 1) or (Number > Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Number], ERROR_UMIT_GETNAXES_NUMBER);
  Key := Format(cNAXISn, [Number]);
  Ind := FHead.IndexOf(Key);
  if Ind < 0 then
    raise EFitsClassesException.CreateFmt(SKeywordNotFound, [Key, Self.Index], ERROR_UMIT_GETNAXES_NOTFOUND);
  try
    Result := Integer(FHead.ValuesInteger[Ind]);
  except
    on E: Exception do
      raise EFitsClassesException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_UMIT_GETNAXES_INVALID);
  end;
  // The FITS Standard (version 4.0), 4.4.1.1. "Primary header", page 11
  // The value field of this indexed keyword shall contain a non-negative
  // integer, representing the number of elements along Axis n of a data array
  if Result < 0 then
    raise EFitsClassesException.CreateFmt(SLineValueIncorrect, [Ind, Self.Index], ERROR_UMIT_GETNAXES_INCORRECT);
end;

function TFitsUmit.GetHeadClass: TFitsUmitHeadClass;
begin
  Result := TFitsUmitHead;
end;

function TFitsUmit.GetDataClass: TFitsUmitDataClass;
begin
   Result := TFitsUmitData;
end;

procedure TFitsUmit.Init;
begin
  FContainer := nil;
  FHead := nil;
  FData := nil;
end;

constructor TFitsUmit.CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean);
begin
  inherited Create;
  Init();
  Bind(AContainer);
  MakeExplorer(APioneer);
end;

constructor TFitsUmit.CreateNewcomer(AContainer: TFitsContainer; ASpec: TFitsUmitSpec);
begin
  inherited Create;
  Init();
  Bind(AContainer);
  MakeNewcomer(ASpec);
end;

procedure TFitsUmit.BeforeDestruction;
begin
  if not FContainer.FInspect then
    raise EFitsClassesException.CreateFmt(SFreeNoInspect, [Self.Index], ERROR_UMIT_FREE_INSPECT);
  inherited;
end;

destructor TFitsUmit.Destroy;
begin
  if Assigned(FHead) then
  begin
    FHead.Free;
    FHead := nil;
  end;
  if Assigned(FData) then
  begin
    FData.Free;
    FData := nil;
  end;
  FContainer := nil;
  inherited;
end;

function TFitsUmit.Coclass(UmitClass: TFitsUmitClass): Boolean;
begin
  Result := FContainer.Coclass(Index, UmitClass);
end;

function TFitsUmit.Reclass(UmitClass: TFitsUmitClass): TFitsUmit;
begin
  Result := FContainer.Reclass(Index, UmitClass);
end;

procedure TFitsUmit.Delete;
begin
  FContainer.Delete(Index);
end;

procedure TFitsUmit.Exchange(Index2: Integer);
begin
  FContainer.Exchange(Index, Index2);
end;

procedure TFitsUmit.Move(NewIndex: Integer);
begin
  FContainer.Move(Index, NewIndex);
end;

{ TFitsManagerBuffer }

{$IFDEF DELA_MEMORY_SHARED}
var
  vBuffer: TBuffer = nil;
{$ENDIF}

constructor TFitsManagerBuffer.Create;
begin
  inherited;
  {$IFDEF DELA_MEMORY_PRIVATE}
  FBuffer := nil;
  {$ENDIF}
end;

destructor TFitsManagerBuffer.Destroy;
begin
  {$IFDEF DELA_MEMORY_PRIVATE}
  FBuffer := nil;
  {$ENDIF}
  inherited;
end;

procedure TFitsManagerBuffer.Allocate(var ABuffer: Pointer; ASizeInBytes: Integer);
begin
  {$IF DEFINED(DELA_MEMORY_SHARED)}

  if Length(vBuffer) < ASizeInBytes then
    SetLength(vBuffer, ASizeInBytes);
  TBuffer(ABuffer) := vBuffer;

  {$ELSEIF DEFINED(DELA_MEMORY_PRIVATE)}

  if Length(FBuffer) < ASizeInBytes then
    SetLength(FBuffer, ASizeInBytes);
  TBuffer(ABuffer) := FBuffer;

  {$ELSEIF DEFINED(DELA_MEMORY_TEMP)}

  SetLength(TBuffer(ABuffer), ASizeInBytes);

  {$IFEND}
end;

procedure TFitsManagerBuffer.Release(var ABuffer: Pointer);
begin
  TBuffer(ABuffer) := nil;
  ABuffer := nil;
end;

procedure TFitsManagerBuffer.Reset;
begin
  {$IF DEFINED(DELA_MEMORY_SHARED)}
  vBuffer := nil;
  {$ELSEIF DEFINED(DELA_MEMORY_PRIVATE)}
  FBuffer := nil;
  {$ELSEIF DEFINED(DELA_MEMORY_TEMP)}
  {$IFEND}
end;

{ TFitsContent }

function TFitsContent.GetSize: Int64;
begin
  Result := FStream.Size;
end;

constructor TFitsContent.Create(AStream: TStream);
begin
  inherited Create;
  if not Assigned(AStream) then
    raise EFitsClassesException.Create(SStreamNotAssign, ERROR_CONTENT_ASSIGN_STREAM);
  FStream := AStream;
  FBuffer := TFitsManagerBuffer.Create;
end;

destructor TFitsContent.Destroy;
begin
  FStream := nil;
  if Assigned(FBuffer) then
  begin
    FBuffer.Free;
    FBuffer := nil;
  end;
  inherited;
end;

procedure TFitsContent.Read(const AOffset, ASize: Int64; var ABuffer);
begin
  FStream.Position := AOffset;
  if (ASize <> 0) and (FStream.Read(ABuffer, ASize) <> ASize) then
    raise EFitsClassesException.Create(SContentAccessError, ERROR_CONTENT_READ);
end;

procedure TFitsContent.ReadBuffer(const AOffset, ACount: Int64; var ABuffer: TBuffer);
var
  L: Integer;
begin
  L := Length(ABuffer);
  if L < ACount then
    raise EFitsClassesException.CreateFmt(SBufferIncorrectSize, [ACount], ERROR_CONTENT_READ_BUFFER);
  if L > 0 then
    Read(AOffset, ACount, ABuffer[0]);
end;

procedure TFitsContent.ReadString(const AOffset, ACount: Int64; var ABuffer: string);
var
  lBuffer: AnsiString;
begin
  lBuffer := '';
  if ACount > 0 then
  begin
    SetLength(lBuffer, ACount);
    Read(AOffset, ACount, lBuffer[1]);
  end;
  ABuffer := string(lBuffer);
end;

procedure TFitsContent.Write(const AOffset, ASize: Int64; const ABuffer);
begin
  FStream.Position := AOffset;
  if (ASize <> 0) and (FStream.Write(ABuffer, ASize) <> ASize) then
    raise EFitsClassesException.Create(SContentAccessError, ERROR_CONTENT_WRITE);
end;

procedure TFitsContent.WriteBuffer(const AOffset, ACount: Int64; const ABuffer: TBuffer);
var
  L: Integer;
begin
  L := Length(ABuffer);
  if L < ACount then
    raise EFitsClassesException.CreateFmt(SBufferIncorrectSize, [ACount], ERROR_CONTENT_WRITE_BUFFER);
  if L > 0 then
    Write(AOffset, ACount, ABuffer[0]);
end;

procedure TFitsContent.WriteString(const AOffset, ACount: Int64; const ABuffer: string);
var
  L: Integer;
  lBuffer: AnsiString;
begin
  L := Length(ABuffer);
  if L < ACount then
    raise EFitsClassesException.CreateFmt(SBufferIncorrectSize, [ACount], ERROR_CONTENT_WRITE_BUFFER);
  if L > 0 then
  begin
    lBuffer := AnsiString(ABuffer);
    Write(AOffset, ACount, lBuffer[1]);
  end;
end;

procedure TFitsContent.Fill(const AOffset, ASize: Int64; AChar: Char);
var
  lSize: Int64;
  N, L: Integer;
  lBuffer: TBuffer;
begin

  if (AOffset < 0) or (ASize < 0) then
    raise EFitsClassesException.Create(SContentIncorrectBounds, ERROR_CONTENT_FILL_BOUNDS);

  if ASize = 0 then
    Exit;

  try
    if ASize > cMaxSizeBuffer then L := cMaxSizeBuffer else L := ASize;
    lBuffer := nil;
    FBuffer.Allocate(Pointer(lBuffer), L);
    FillChar(lBuffer[0], L, Char(AChar));
    lSize := ASize;
    while lSize > 0 do
    begin
      if lSize > L then N := L else N := lSize;
      WriteBuffer(AOffset + lSize - N, N, lBuffer);
      Dec(lSize, N);
    end;
  finally
    FBuffer.Release(Pointer(lBuffer));
  end;

end;

procedure TFitsContent.Shift(const AOffset, ASize, AShift: Int64);
var
  lSize, lOffset: Int64;
  N, L: Integer;
  lBuffer: TBuffer;
begin

  if (AOffset < 0) or (ASize < 0) then
    raise EFitsClassesException.Create(SContentIncorrectBounds, ERROR_CONTENT_SHIFT_BOUNDS);

  if (AOffset + ASize) > Size then
    raise EFitsClassesException.Create(SContentIncorrectSize, ERROR_CONTENT_SHIFT_SIZE);

  lSize := ASize;
  lOffset := AOffset;
  try
    if lSize > cMaxSizeBuffer then L := cMaxSizeBuffer else L := lSize;
    lBuffer := nil;
    FBuffer.Allocate(Pointer(lBuffer), L);
    // Shift content down
    if AShift > 0 then
      while lSize <> 0 do
      begin
        if lSize > L then N := L else N := lSize;
        ReadBuffer(lOffset + lSize - N, N, lBuffer);
        WriteBuffer(lOffset + AShift + lSize - N, N, lBuffer);
        Dec(lSize, N);
      end
    // Shift content up
    else { AShift < 0 }
      while lSize <> 0 do
      begin
        if lSize > L then N := L else N := lSize;
        ReadBuffer(lOffset, N, lBuffer);
        WriteBuffer(lOffset + AShift, N, lBuffer);
        Inc(lOffset, N);
        Dec(lSize, N);
      end;
  finally
    FBuffer.Release(Pointer(lBuffer));
  end;

end;

procedure TFitsContent.Rotate(const AOffset, ASize: Int64);
var
  lSize, lOffset1, lOffset2: Int64;
  N, L, I, Imax: Integer;
  lUmit: T08u;
  lBuffer: TBuffer;
begin

  if (AOffset < 0) or (ASize < 0) then
    raise EFitsClassesException.Create(SContentIncorrectBounds, ERROR_CONTENT_ROTATE_BOUNDS);

  if (AOffset + ASize) > Size then
    raise EFitsClassesException.Create(SContentIncorrectSize, ERROR_CONTENT_ROTATE_SIZE);

  try
    lSize := ASize div 2;
    L := Min(lSize, cMaxSizeBuffer) div 2;
    if L = 0 then
      L := 1;
    lBuffer := nil;
    FBuffer.Allocate(Pointer(lBuffer), L * 2);
    lOffset1 := AOffset;
    lOffset2 := AOffset + lSize + (ASize mod 2);
    while lSize <> 0 do
    begin
      N := Min(lSize, L);
      // read
      FStream.Position := lOffset1;
      FStream.Read(lBuffer[0], N);
      FStream.Position := lOffset2 + lSize - N;
      FStream.Read(lBuffer[N], N);
      // rotation
      Imax := N * 2 - 1;
      I := 0;
      while I < N do
      begin
        lUmit := lBuffer[I];
        lBuffer[I] := lBuffer[Imax - I];
        lBuffer[Imax - I] := lUmit;
        Inc(I);
      end;
      // write
      FStream.Position := lOffset1;
      FStream.Write(lBuffer[0], N);
      FStream.Position := lOffset2 + lSize - N;
      FStream.Write(lBuffer[N], N);
      // iteration
      Inc(lOffset1, N);
      Dec(lSize, N);
    end;
  finally
    FBuffer.Release(Pointer(lBuffer));
  end;

end;

procedure TFitsContent.Exchange(var AOffset1: Int64; const ASize1: Int64; var AOffset2: Int64; const ASize2: Int64);
var
  lSizeSame, lSize, lOffset, lNewOffset: Int64;
  lOffset1, lSize1, lOffset2, lSize2: Int64;
  N, L: Integer;
  lBuffer: TBuffer;
begin

  if (AOffset1 < 0) or (ASize1 < 0) or (AOffset2 < 0) or (ASize2 < 0) then
    raise EFitsClassesException.Create(SContentIncorrectBounds, ERROR_CONTENT_EXCHANGE_BOUNDS);

  if ((AOffset1 + ASize1) > Size) or ((AOffset2 + ASize2) > Size) then
    raise EFitsClassesException.Create(SContentIncorrectSize, ERROR_CONTENT_EXCHANGE_SIZE);

  if (AOffset1 = AOffset2) or (ASize1 = 0) or (ASize2 = 0) then
    Exit;

  if AOffset1 < AOffset2 then
  begin
    lOffset1 := AOffset1;
    lSize1  := ASize1;
    lOffset2 := AOffset2;
    lSize2  := ASize2;
  end
  else
  begin
    lOffset1 := AOffset2;
    lSize1  := ASize2;
    lOffset2 := AOffset1;
    lSize2  := ASize1;
  end;
  lSizeSame := Min(lSize1, lSize2);
  if lOffset2 < (lOffset1 + lSize1) then
    raise EFitsClassesException.Create(SContentInterBlocks, ERROR_CONTENT_EXCHANGE_INTER);

  // exchange

  lOffset  := AOffset1;
  AOffset1 := AOffset2;
  AOffset2 := lOffset;
  try
    lSize := lSizeSame;
    L := Min(lSize, cMaxSizeBuffer) div 2;
    if L = 0 then
      L := 1;
    lBuffer := nil;
    FBuffer.Allocate(Pointer(lBuffer), L * 2);
    while lSize <> 0 do
    begin
      N := Min(lSize, L);
      // read
      FStream.Position := lOffset1;
      FStream.Read(lBuffer[0], N);
      FStream.Position := lOffset2;
      FStream.Read(lBuffer[N], N);
      // write
      FStream.Position := lOffset1;
      FStream.Write(lBuffer[N], N);
      FStream.Position := lOffset2;
      FStream.Write(lBuffer[0], N);
      // iteration
      Inc(lOffset1, N);
      Inc(lOffset2, N);
      Dec(lSize, N);
    end;
  finally
    FBuffer.Release(Pointer(lBuffer));
  end;

  // move

  if AOffset1 < AOffset2 then
  begin
    lOffset1 := AOffset1;
    lOffset2 := AOffset2;
  end
  else
  begin
    lOffset1 := AOffset2;
    lOffset2 := AOffset1;
  end;
  lSize := lSize1 - lSize2;
  if lSize <> 0 then
  begin
    if lSize > 0 then
    begin
      lOffset := lOffset1 + lSizeSame;
      lNewOffset := lOffset2 + lSizeSame - 1;
      Dec(AOffset1, lSize);
    end
    else if lSize < 0 then
    begin
      lSize := Abs(lSize);
      lOffset := lOffset2 + lSizeSame;
      lNewOffset := lOffset1 + lSizeSame;
      Inc(AOffset1, lSize);
    end;
    Move(lOffset, lSize, lNewOffset);
  end;

end;

procedure TFitsContent.Move(const AOffset, ASize: Int64; var ANewOffset: Int64);
var
  lOffset1, lSize1, lOffset2, lSize2: Int64;
begin

  if (AOffset < 0) or (ASize < 0) or (ANewOffset < 0) then
    raise EFitsClassesException.Create(SContentIncorrectBounds, ERROR_CONTENT_MOVE_BOUNDS);

  if (AOffset + ASize) > Size then
    raise EFitsClassesException.Create(SContentIncorrectSize, ERROR_CONTENT_MOVE_SIZE);

  if (AOffset = ANewOffset) or (ASize = 0) then
    Exit;

  if (ANewOffset > AOffset) and (ANewOffset < AOffset + ASize) then
    raise EFitsClassesException.Create(SContentInterBlocks, ERROR_CONTENT_MOVE_INTER);

  // Move content down

  if (ANewOffset > AOffset) then
  begin
    lOffset1 := AOffset;
    lSize1  := ASize;
    lOffset2 := AOffset + ASize;
    lSize2  := (ANewOffset - AOffset + 1) - ASize;
    ANewOffset := ANewOffset - ASize + 1;
  end

  else

  // Move content up

  begin
    lOffset1 := ANewOffset;
    lSize1  := AOffset - ANewOffset;
    lOffset2 := AOffset;
    lSize2  := ASize;
  end;

  Rotate(lOffset1, lSize1);
  Rotate(lOffset2, lSize2);
  Rotate(lOffset1, lSize1 + lSize2);
end;

procedure TFitsContent.Resize(const AOffset, ASize: Int64);
var
  lOffset, lSize, lShift: Int64;
begin

  if AOffset < 0 then
    raise EFitsClassesException.Create(SContentIncorrectBounds, ERROR_CONTENT_RESIZE_BOUNDS);

  if ASize = 0 then
    Exit;

  // Grow size stream

  if ASize > 0 then
  begin
    lOffset := AOffset;
    lSize := FStream.Size - lOffset;
    lShift := ASize;
    FStream.Size := FStream.Size + ASize;
    Shift(lOffset, lSize, lShift);
  end

  else { ASize < 0 }

  // Reduce size stream

  begin
    if (AOffset + Abs(ASize)) > Size then
      raise EFitsClassesException.Create(SContentIncorrectSize, ERROR_CONTENT_RESIZE_SIZE);
    lOffset := AOffset + Abs(ASize);
    lSize := FStream.Size - lOffset;
    lShift := ASize;
    Shift(lOffset, lSize, lShift);
    FStream.Size := FStream.Size + ASize;
  end;

end;

{ TFits }

procedure TFitsContainer.Embed(NewUmit: TFitsUmit);
begin
  FUmits[FEmbindex] := NewUmit;
end;

function TFitsContainer.GetCount: Integer;
begin
  Result := FUmits.Count;
end;

function TFitsContainer.GetUmit(Index: Integer): TFitsUmit;
begin
  if (Index < 0) or (Index >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_CONTAINER_GETUMIT_INDEX);
  Result := TFitsUmit(FUmits[Index]);
end;

function TFitsContainer.GetPrimary: TFitsUmit;
begin
  Result := nil;
  if Count > 0 then
    Result := Umits[0];
end;

constructor TFitsContainer.Create(AStream: TStream);
begin
  inherited Create;
  FContent := TFitsContent.Create(AStream);
  FUmits := TList.Create;
  FInspect := False;
  FEmbindex := -1;
  Explore;
end;

destructor TFitsContainer.Destroy;
begin
  if Assigned(FUmits) then
  begin
    Clear;
    FUmits.Free;
    FUmits := nil;
  end;
  if Assigned(FContent) then
  begin
    FContent.Free;
    FContent := nil;
  end;
  inherited;
end;

procedure TFitsContainer.Explore;
var
  Umit: TFitsUmit;
begin
  if FContent.Size > 0 then
    while True do
    try
      try
        FInspect := True;
        FEmbindex := FUmits.Add(nil);
        Umit := TFitsUmit.CreateExplorer(Self, True);
      finally
        FInspect := False;
      end;
      if FContent.Size - (Umit.Offset + Umit.Size) <= 0 then
        Break;
    except
      FUmits.Delete(FEmbindex);
      raise;
    end;
end;

function TFitsContainer.Coclass(Index: Integer; UmitClass: TFitsUmitClass): Boolean;
begin
  if (Index < 0) or (Index >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_CONTAINER_COCLASS_INDEX);
  Result := (UmitClass = TFitsUmit) or SameText(Umits[Index].Family, UmitClass.ClassFamily);
end;

function TFitsContainer.Reclass(Index: Integer; UmitClass: TFitsUmitClass): TFitsUmit;
var
  Prev: TFitsUmit;
begin

  if (Index < 0) or (Index >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_CONTAINER_RECLASS_INDEX);

  Prev := nil;

  try
    try
      FInspect := True;
      FEmbindex := Index;
      Prev := Umits[FEmbindex];
      Result := UmitClass.CreateExplorer(Self, False);
      Prev.Free;
    finally
      FInspect := False;
    end;
  except
    FUmits[FEmbindex] := Prev;
    raise;
  end;

end;

function TFitsContainer.Add(UmitClass: TFitsUmitClass; UmitSpec: TFitsUmitSpec): TFitsUmit;
var
  RemOffset, RemSize: Int64;
begin

  // remember a current content size

  RemOffset := FContent.Size;
  RemSize := FContent.Size;

  // add a new content block and embed a new umit

  try
    try
      FInspect := True;
      FEmbindex := Count;
      FUmits.Insert(FEmbindex, nil);
      FContent.Resize(RemOffset, cSizeBlock);
      FContent.Fill(RemOffset, cSizeBlock, cChrBlank);
      Result := UmitClass.CreateNewcomer(Self, UmitSpec);
      // reorder first umit
      if Count = 2 then
        Umits[0].Reorder(otPrim);
    finally
      FInspect := False;
    end;
  except
    FUmits.Delete(FEmbindex);
    FContent.Resize(RemOffset, RemSize - FContent.Size);
    raise;
  end;

end;

procedure TFitsContainer.Delete(Index: Integer);
var
  Umit, Vary: TFitsUmit;
  Order: TOrderType;
begin

  if (Index < 0) or (Index >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index], ERROR_CONTAINER_DELETE_INDEX);

  Umit := Umits[Index];

  // prepare a new order of umits

  Vary := nil;
  Order := otNone;
  if (Index = 0) and (Count > 1) then
  begin
    Vary := Umits[1];
    if not Vary.CanPrimary then
      raise EFitsClassesException.CreateFmt(SUmitCannotPrimary, [Vary.Index], ERROR_CONTAINER_DELETE_REORDER);
    Vary.Reorder(IfThen(Count = 2, otSing, otPrim));
    Order := otXten;
  end;
  if (Index = 1) and (Count = 2) then
  begin
    Vary := Umits[0];
    if not Vary.CanPrimary then
      raise EFitsClassesException.CreateFmt(SUmitCannotPrimary, [Vary.Index], ERROR_CONTAINER_DELETE_REORDER);
    Vary.Reorder(otSing);
    Order := otPrim;
  end;

  // remove umit and block of stream !-> restore umits order

  try
    try
      FInspect := True;
      FContent.Resize(Umit.Offset, -Umit.Size);
      Umit.Free;
      FUmits.Delete(Index);
    finally
      FInspect := False;
    end;
  except
    if Assigned(Vary) then
      Vary.Reorder(Order);
    raise;
  end;

end;

procedure TFitsContainer.Clear;
var
  I: Integer;
begin
  try
    FInspect := True;
    for I := 0 to Count - 1 do
    begin
      Umits[I].Free;
      FUmits[I] := nil;
    end;
    FUmits.Clear;
  finally
    FInspect := False;
  end;
end;

procedure TFitsContainer.Exchange(Index1, Index2: Integer);
var
  Umit1, Umit2: TFitsUmit;
  Offset1, Offset2: Int64;
begin
  if (Index1 < 0) or (Index1 >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index1], ERROR_CONTAINER_EXCHANGE_INDEX);
  if (Index2 < 0) or (Index2 >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [Index2], ERROR_CONTAINER_EXCHANGE_INDEX);
  if Index1 = Index2 then
    Exit;
  // prepare a new order of umits
  Umit1 := Umits[Index1];
  Umit2 := Umits[Index2];
  if Index1 = 0 then
  begin
    if not Umit2.CanPrimary then
      raise EFitsClassesException.CreateFmt(SUmitCannotPrimary, [Index2], ERROR_CONTAINER_EXCHANGE_REORDER);
    Umit1.Reorder(otXten);
    Umit2.Reorder(otPrim);
  end;
  if Index2 = 0 then
  begin
    if not Umit1.CanPrimary then
      raise EFitsClassesException.CreateFmt(SUmitCannotPrimary, [Index1], ERROR_CONTAINER_EXCHANGE_REORDER);
    Umit1.Reorder(otPrim);
    Umit2.Reorder(otXten);
  end;
  // exchange blocks of stream and umits
  Offset1 := Umit1.Offset;
  Offset2 := Umit2.Offset;
  FContent.Exchange(Offset1, Umit1.Size, Offset2, Umit2.Size);
  FUmits.Exchange(Index1, Index2);
end;

procedure TFitsContainer.Move(CurIndex, NewIndex: Integer);
var
  NewPrim, NewXten: TFitsUmit;
  NewOffset: Int64;
begin
  if (CurIndex < 0) or (CurIndex >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [CurIndex], ERROR_CONTAINER_MOVE_INDEX);
  if (NewIndex < 0) or (NewIndex >= Count) then
    raise EFitsClassesException.CreateFmt(SListIndexOutBounds, [NewIndex], ERROR_CONTAINER_MOVE_INDEX);
  if CurIndex = NewIndex then
    Exit;
  // prepare a new order of umits
  if (CurIndex = 0) or (NewIndex = 0) then
  begin
    if CurIndex = 0 then
    begin
      NewPrim := Umits[1];
      NewXten := Umits[0];
    end
    else // if NewIndex = 0 then
    begin
      NewPrim := Umits[CurIndex];
      NewXten := Umits[0];
    end;
    if not NewPrim.CanPrimary then
      raise EFitsClassesException.CreateFmt(SUmitCannotPrimary, [NewPrim.Index], ERROR_CONTAINER_MOVE_REORDER);
    NewPrim.Reorder(otPrim);
    NewXten.Reorder(otXten);
  end;
  // move blocks of stream and umits
  NewOffset := Umits[NewIndex].Offset;
  if CurIndex < NewIndex then
    NewOffset := NewOffset + Umits[NewIndex].Size - 1;
  FContent.Move(Umits[CurIndex].Offset, Umits[CurIndex].Size, NewOffset);
  FUmits.Move(CurIndex, NewIndex);
end;

function TFitsContainer.IndexOf(Umit: TFitsUmit): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if Umits[I] = Umit then
    begin
      Result := I;
      Break;
    end;
end;

end.
