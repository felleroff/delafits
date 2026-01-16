{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{           Container of Head and Data Units           }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsClasses;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Classes, Math, DeLaFitsCommon, DeLaFitsMath, DeLaFitsString,
  DeLaFitsProp, DeLaFitsCard;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_CLASSES                            = 6000;

  ERROR_ITEMHEAD_BIND_NO_ITEM              = 6200;
  ERROR_ITEMHEAD_BIND_NO_INSPECT           = 6201;
  ERROR_ITEMHEAD_MAKE_SIMPLE_NOT_MATCH     = 6202;
  ERROR_ITEMHEAD_MAKE_SIMPLE_VALUE         = 6203;
  ERROR_ITEMHEAD_MAKE_XTENSIONE_NOT_MATCH  = 6204;
  ERROR_ITEMHEAD_MAKE_XTENSION_VALUE       = 6205;
  ERROR_ITEMHEAD_MAKE_KEYWORDEND_NOT_FOUND = 6206;
  ERROR_ITEMHEAD_MAKE_MINIMUM_SIZE         = 6207;
  ERROR_ITEMHEAD_MAKE_RECOGNIZED_SIZE      = 6208;
  ERROR_ITEMHEAD_READLINES_BOUNDS          = 6209;
  ERROR_ITEMHEAD_WRITELINES_BOUNDS         = 6210;
  ERROR_ITEMHEAD_WRITELINES_KEYWORD        = 6211;
  ERROR_ITEMHEAD_EXCHANGELINES_BOUNDS      = 6212;
  ERROR_ITEMHEAD_MOVELINES_BOUNDS          = 6213;
  ERROR_ITEMHEAD_ERASELINES_BOUNDS         = 6214;
  ERROR_ITEMHEAD_DELETELINES_BOUNDS        = 6215;
  ERROR_ITEMHEAD_INSERTLINES_BOUNDS        = 6216;
  ERROR_ITEMHEAD_INSERTLINES_KEYWORD       = 6217;
  ERROR_ITEMHEAD_GETLINEKEYWORD_INDEX      = 6218;
  ERROR_ITEMHEAD_SETLINEKEYWORD_INDEX      = 6219;
  ERROR_ITEMHEAD_SETLINEKEYWORD_KEYWORD    = 6220;
  ERROR_ITEMHEAD_LINEINDEXOFKEYWORDS       = 6221;
  ERROR_ITEMHEAD_LOCATECARDS_NEXT          = 6222;
  ERROR_ITEMHEAD_LOCATECARDS_PRIOR         = 6223;
  ERROR_ITEMHEAD_NEXTCARD                  = 6224;
  ERROR_ITEMHEAD_PRIORCARD                 = 6225;
  ERROR_ITEMHEAD_MOVECARD_CURSPOT          = 6226;
  ERROR_ITEMHEAD_MOVECARD_NEWSPOT          = 6227;
  ERROR_ITEMHEAD_ERASECARD                 = 6228;
  ERROR_ITEMHEAD_DELETECARD                = 6229;
  ERROR_ITEMHEAD_INSERTCARD_CURSOR         = 6230;
  ERROR_ITEMHEAD_INSERTCARD_CONTENT        = 6231;
  ERROR_ITEMHEAD_ADDCARD                   = 6232;
  ERROR_ITEMHEAD_GETCARD                   = 6233;
  ERROR_ITEMHEAD_SETCARD_CURSOR            = 6234;
  ERROR_ITEMHEAD_SETCARD_CONTENT           = 6235;
  ERROR_ITEMHEAD_GETCARDKEYWORD            = 6236;

  ERROR_ITEMDATA_BIND_NO_ITEM              = 6300;
  ERROR_ITEMDATA_BIND_NO_INSPECT           = 6301;
  ERROR_ITEMDATA_BIND_NO_HEAD              = 6302;
  ERROR_ITEMDATA_MAKE_RECOGNIZED_SIZE      = 6303;

  ERROR_ITEM_BIND_NO_CONTAINER             = 6400;
  ERROR_ITEM_BIND_NO_INSPECT               = 6401;
  ERROR_ITEM_GETBITPIX_NOT_FOUND           = 6402;
  ERROR_ITEM_GETNAXIS_NOT_FOUND            = 6403;
  ERROR_ITEM_GETNAXIS_VALUE                = 6404;
  ERROR_ITEM_GETNAXES_NUMBER               = 6405;
  ERROR_ITEM_GETNAXES_NOT_FOUND            = 6406;
  ERROR_ITEM_GETNAXES_VALUE                = 6407;
  ERROR_ITEM_GETPCOUNT_VALUE               = 6408;
  ERROR_ITEM_GETGCOUNT_VALUE               = 6409;
  ERROR_ITEM_READCHUNK_BOUNDS              = 6410;
  ERROR_ITEM_WRITECHUNK_BOUNDS             = 6411;
  ERROR_ITEM_EXCHANGECHUNK_BOUNDS          = 6412;
  ERROR_ITEM_EXCHANGECHUNK_OVERLAP         = 6413;
  ERROR_ITEM_MOVECHUNK_BOUNDS              = 6414;
  ERROR_ITEM_MOVECHUNK_OFFSET              = 6415;
  ERROR_ITEM_MOVECHUNK_OVERLAP             = 6416;
  ERROR_ITEM_ERASECHUNK_BOUNDS             = 6417;
  ERROR_ITEM_DELETECHUNK_BOUNDS            = 6418;
  ERROR_ITEM_INSERTCHUNK_OFFSET            = 6419;
  ERROR_ITEM_INSERTCHUNK_SIZE              = 6420;
  ERROR_ITEM_ADDCHUNK_SIZE                 = 6421;

  ERROR_MEMORY_BIND_NO_CONTAINER           = 6500;

  ERROR_CONTENT_BIND_NO_CONTAINER          = 6600;
  ERROR_CONTENT_BIND_NO_STREAM             = 6601;
  ERROR_CONTENT_READ                       = 6602;
  ERROR_CONTENT_READ_BOUNDS                = 6603;
  ERROR_CONTENT_WRITE                      = 6604;
  ERROR_CONTENT_WRITE_BOUNDS               = 6605;
  ERROR_CONTENT_WRITEBUFFER_SIZE           = 6606;
  ERROR_CONTENT_WRITESTRING_SIZE           = 6607;
  ERROR_CONTENT_FILL_BOUNDS                = 6608;
  ERROR_CONTENT_SHIFT_BOUNDS               = 6609;
  ERROR_CONTENT_ROTATE_BOUNDS              = 6610;
  ERROR_CONTENT_EXCHANGE_BOUNDS            = 6611;
  ERROR_CONTENT_EXCHANGE_OVERLAP           = 6612;
  ERROR_CONTENT_MOVE_BOUNDS                = 6613;
  ERROR_CONTENT_MOVE_OFFSET                = 6614;
  ERROR_CONTENT_MOVE_OVERLAP               = 6615;
  ERROR_CONTENT_RESIZE_BOUNDS              = 6616;
  ERROR_CONTENT_RESIZE_ZERO_SIZE           = 6617;
  ERROR_CONTENT_RESIZE_OFFSET              = 6618;

  ERROR_CONTAINER_GETITEMCLASS_INDEX       = 6700;
  ERROR_CONTAINER_SETITEMCLASS_INDEX       = 6701;
  ERROR_CONTAINER_SETITEMCLASS_EXTENSION   = 6702;
  ERROR_CONTAINER_GETITEM_INDEX            = 6703;
  ERROR_CONTAINER_DELETE_INDEX             = 6704;
  ERROR_CONTAINER_DELETE_ORDER             = 6705;
  ERROR_CONTAINER_EXCHANGE_INDEX           = 6706;
  ERROR_CONTAINER_EXCHANGE_ORDER           = 6707;
  ERROR_CONTAINER_MOVE_INDEX               = 6708;
  ERROR_CONTAINER_MOVE_ORDER               = 6709;
  ERROR_CONTAINER_EXTENSIONTYPEIS_INDEX    = 6710;

resourcestring

  { The messages of exceptions }

  SSpecNotAssigned            = 'Specification object not assigned';
  SSpecInvalidClass           = '"%s" is an invalid specification class';
  SSpecInvalidItem            = 'Invalid HDU object to create specification';
  SSpecIncorrectValue         = 'Incorrect value "%s=%s" in specification';

  SHeadNotAssigned            = 'Header object not assigned';
  SHeadLinesRangeOutBounds    = 'Range "INDEX=%d;COUNT=%d" is out of the lines list bounds "COUNT=%d"';
  SHeadLinesRangeAtLowerBound = 'Range "INDEX=%d;COUNT=%d" matches the lower bound of the lines list "COUNT=%d"';
  SHeadLineIndexOutBounds     = 'Index "%d" is out of the lines list bounds "COUNT=%d"';
  SHeadLineIndexAtLowerBound  = 'Index "%d" matches the lower bound of the lines list "COUNT=%d"';
  SHeadLineCannotChanged      = 'Line with keyword "%s" cannot be changed';
  SHeadLineNotFound           = 'Line with keyword "%s" not found';
  SHeadLineKeywordNotMatch    = 'Keyword in line "%s" does not match "%s"';
  SHeadLineValueIncorrect     = 'Value in line "%s" is incorrect';
  SHeadCardCursorOutBounds    = 'Card cursor "START=%d;COUNT=%d" is out of the lines list bounds "COUNT=%d"';
  SHeadCardCursorAtLowerBound = 'Card cursor "START=%d;COUNT=%d" matches the lower bound of the lines list "COUNT=%d"';

  SItemNotAssigned            = 'HDU object not assigned';
  SItemNotMatchMinimumSize    = 'Upper estimate of HDU[%d] size is "%d" bytes and does not match the minimum size of 2880 bytes';
  SItemNotMatchRecognizedSize = 'Upper estimate of HDU[%d] size is "%d" bytes and does not match the recognized size of "%d" bytes';
  SItemCannotPrimary          = 'HDU[%d] cannot be primary';
  SItemInvalidExtension       = 'Class "%s" cannot work with HDU extension "%s"';
  SItemIndexOutBounds         = 'Index "%d" is out of HDU list bounds "COUNT=%d"';

  SStreamNotAssigned          = 'Stream object not assigned';

  SContentReadError           = 'Content read error';
  SContentWriteError          = 'Content write error';
  SContentWriteLowBufferSize  = 'A "%d"-byte buffer is not enough to write "%d" bytes of content';
  SContentWriteLowStringSize  = 'A "%d"-character string is not enough to write "%d" bytes of content';
  SContentChunkOutBounds      = 'Chunk "OFFSET=%d;SIZE=%d" is out of content bounds "SIZE=%d"';
  SContentChunksOverlap       = 'Chunks "OFFSET=%d;SIZE=%d" and "OFFSET=%d;SIZE=%d" of content overlap each other';
  SContentOffsetOutBounds     = 'Offset "%d" is out of content bounds "SIZE=%d"';
  SContentInvalidSize         = '"%d" bytes is an invalid content size';
  SContentZeroSize            = 'Zero content size';

  SContainerNotAssigned       = 'Container object (owner) not assigned';
  SContainerNotControlBind    = 'Container does not control object binding';

type

  TFitsItemHead  = class;
  TFitsItemData  = class;
  TFitsItem      = class;
  TFitsContainer = class;

  TKeywordDynArray = TAstr;

  { TFitsItemSpec: specification to create a new HDU }

  EFitsItemSpecException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsItemSpec = class(TFitsObject)
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    function ExtractProp(AItem: TFitsItem; AProp: IFitsPropContext): Boolean;
  end;

  { TFitsItemHead: HDU header section }

  EFitsItemHeadException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsItemHead = class(TFitsObject)
  private
    FItem: TFitsItem;
    FInternalSize: Int64;
    FSize: Int64;
    FCardCursor: TCardSpot;
    procedure Bind(AItem: TFitsItem);
    procedure UnBind;
    procedure Make;
    procedure MakeNew;
    function GetOffset: Int64;
    function GetInternalSize: Int64;
    procedure SetSize(const ASize: Int64);
    procedure CheckLines(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
    function GetLineOffset(AIndex: Integer): Int64;
    function GetLineSize(ACount: Integer): Int64;
    function GetLineCapacity: Integer;
    function GetLineCount: Integer;
    procedure ReadLinesBy(AIndex, ACount: Integer; var ALines: string);
    procedure WriteLinesBy(AIndex: Integer; const ALines: string);
    procedure MoveLinesBy(ACurIndex, ACurCount: Integer; var ANewIndex: Integer; ANewCount: Integer);
    procedure EraseLinesBy(AIndex, ACount: Integer);
    procedure DeleteLinesBy(AIndex, ACount: Integer);
    procedure InsertLinesBy(AIndex: Integer; const ALines: string);
    function GetLineBy(AIndex: Integer): string;
    function GetLineKeywordBy(AIndex: Integer): string;
    function GetLine(AIndex: Integer): string;
    procedure SetLine(AIndex: Integer; const ALine: string);
    function GetLineKeyword(AIndex: Integer): string;
    procedure SetLineKeyword(AIndex: Integer; const AKeyword: string);
    function GetLineRecord(AIndex: Integer): TLineRecord;
    procedure SetLineRecord(AIndex: Integer; const ARecord: TLineRecord);
    procedure CheckCard(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
    function LookupCard(ALineSeed: Integer): TCardSpot;
    procedure AddCardBy(const ACard: string); overload;
    procedure AddCardBy(const AKeyword, AValue: string); overload;
    function GetCard: string;
    procedure SetCard(const ACard: string);
    function GetCardType: TCardType;
    function GetCardKeyword: string;
  protected
    procedure Init; override;
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure Customize; virtual;
    procedure CustomizeNew(ASpec: TFitsItemSpec); virtual;
    procedure Invalidate; virtual;
    function ExtractInternalSize: Int64; virtual;
  public
    constructor Create(AItem: TFitsItem); virtual;
    constructor CreateNew(AItem: TFitsItem; ASpec: TFitsItemSpec); virtual;
    destructor Destroy; override;
    // [Chunk] Access to the header section content. The methods do not check
    // keywords. The methods keep the minimum content size at 2880 bytes, and
    // ensure that it is a multiple of 2880 bytes. The methods use an internal
    // offset, i.e. an offset from the beginning of the header section. The
    // internal offset ranges [0..Size-1]
    procedure ReadChunk(const AInternalOffset, ASize: Int64; var ABuffer: string);
    procedure WriteChunk(const AInternalOffset, ASize: Int64; const ABuffer: string);
    procedure ExchangeChunk(var AInternalOffset1: Int64; const ASize1: Int64; var AInternalOffset2: Int64; const ASize2: Int64);
    procedure MoveChunk(const AInternalOffset, ASize: Int64; var ANewInternalOffset: Int64);
    procedure EraseChunk(const AInternalOffset, ASize: Int64);
    procedure DeleteChunk(const AInternalOffset, ASize: Int64);
    procedure InsertChunk(const AInternalOffset, ASize: Int64);
    function AddChunk(const ASize: Int64): Int64;
    // [Line] Access to the header lines: 80-character keyword record. The "end line"
    // is the line with the keyword "END". The methods work with the meaningful
    // lines: from the first line to the end line inclusively. The methods allow
    // editing the first line but prohibit adding or editing the end line. The
    // methods keep at least one line (this is the end line) and ensure that the
    // header size is a multiple of 2880 bytes. The index range [0..LineCount-1]
    procedure ReadLines(AIndex, ACount: Integer; var ALines: string);
    procedure WriteLines(AIndex: Integer; const ALines: string);
    procedure ExchangeLines(AIndex1, AIndex2: Integer);
    procedure MoveLines(ACurIndex, ANewIndex: Integer);
    procedure EraseLines(AIndex, ACount: Integer);
    procedure DeleteLines(AIndex, ACount: Integer);
    procedure InsertLines(AIndex: Integer; const ALines: string);
    function AddLines(const ALines: string): Integer;
    // Search for line index by keyword and access to keywords occurs in the
    // range [0..LineCount-1]. Editing the keyword "END" is prohibited
    function LineIndexOfKeyword(const AKeyword: string; AScope: Integer = 0): Integer;
    function LineIndexOfKeywords(const AKeywords: array of string; AScope: Integer = 0): Integer;
    // Return the max index of the line with the keyword "NAXISXXX"
    function LineIndexOfLastAxis: Integer;
    // Return the array of keywords by line
    function ExtractLineKeywords: TKeywordDynArray;
    // [Card] A card is a high-level entity for accessing header values,
    // consisting of one or more 80-character keyword record (line). The
    // number of cards and their values depend on the position and meaning
    // of the keywords. The keywords are not a dictionary, they can be
    // duplicated. One empty line defines one card
    function LocateCard(const AKeyword: string; AScope: TSearchScope = searchFirstForward): Boolean;
    function LocateCards(const AKeywords: array of string; AScope: TSearchScope = searchFirstForward): Boolean;
    function FirstCard: Boolean;
    function LastCard: Boolean;
    function NextCard: Boolean;
    function PriorCard: Boolean;
    function GotoCard(ALineSeed: Integer): Boolean;
    procedure MoveCard(ADistance: Integer);
    procedure EraseCard;
    procedure DeleteCard;
    procedure InsertCard(const ACard: string);
    procedure AddCard(const ACard: string);
    // Add a COMMENT or HISTORY card of data processing
    procedure AddComment(const AValue: string);
    procedure AddHistory(const AValue: string);
    function ExtractCardKeywords: TKeywordDynArray;
    property Item: TFitsItem read FItem;
    property Offset: Int64 read GetOffset;
    // The minimum content size is 2880 bytes and a multiple of 2880 bytes
    property Size: Int64 read FSize write SetSize;
    // The exact number of meaningful bytes in the header section (exclusive
    // of fill that is needed after the data to complete the last 2880-byte
    // header block). The internal size is less than or equal to the size of
    // the header section
    property InternalSize: Int64 read GetInternalSize;
    // The number of lines in the header, including blank lines
    // after the end line. Equivalent to the header size
    property LineCapacity: Integer read GetLineCapacity;
    // The number of meaningful lines in the header, excluding the blank
    // lines after the end line. Equivalent to the internal header size
    property LineCount: Integer read GetLineCount;
    property Lines[Index: Integer]: string read GetLine write SetLine;
    property LineKeywords[Index: Integer]: string read GetLineKeyword write SetLineKeyword;
    property LineRecords[Index: Integer]: TLineRecord read GetLineRecord write SetLineRecord;
    property Card: string read GetCard write SetCard;
    property CardType: TCardType read GetCardType;
    property CardKeyword: string read GetCardKeyword;
    property CardCursor: TCardSpot read FCardCursor;
  end;

  TFitsItemHeadClass = class of TFitsItemHead;

  { TFitsItemData: HDU data section }

  EFitsItemDataException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsItemData = class(TFitsObject)
  private
    FItem: TFitsItem;
    FInternalSize: Int64;
    FSize: Int64;
    procedure Bind(AItem: TFitsItem);
    procedure UnBind;
    procedure Make;
    procedure MakeNew;
    function GetOffset: Int64;
    function GetInternalSize: Int64;
    procedure SetSize(const ASize: Int64);
    function GetBitPix: TBitPix;
    function GetAxesCount: Integer;
    function GetAxesLength(ANumber: Integer): Integer;
    function GetPCount: Integer;
    function GetGCount: Integer;
    function GetPixelSize: Byte;
  protected
    procedure Init; override;
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure Customize; virtual;
    procedure CustomizeNew(ASpec: TFitsItemSpec); virtual;
    procedure Invalidate; virtual;
    function ExtractInternalSize: Int64; virtual;
    function Filler: Char; virtual;
  public
    constructor Create(AItem: TFitsItem); virtual;
    constructor CreateNew(AItem: TFitsItem; ASpec: TFitsItemSpec); virtual;
    destructor Destroy; override;
    // Access to the data section content. The methods ensure that the content
    // size is a multiple of 2880 bytes. The methods use an internal offset,
    // i.e. an offset from the beginning of the data section. The internal
    // offset ranges [0..Size-1]
    procedure ReadChunk(const AInternalOffset, ASize: Int64; var ABuffer);
    procedure WriteChunk(const AInternalOffset, ASize: Int64; const ABuffer);
    procedure ExchangeChunk(var AInternalOffset1: Int64; const ASize1: Int64; var AInternalOffset2: Int64; const ASize2: Int64);
    procedure MoveChunk(const AInternalOffset, ASize: Int64; var ANewInternalOffset: Int64);
    procedure EraseChunk(const AInternalOffset, ASize: Int64);
    procedure DeleteChunk(const AInternalOffset, ASize: Int64);
    procedure InsertChunk(const AInternalOffset, ASize: Int64);
    function AddChunk(const ASize: Int64): Int64;
    property Item: TFitsItem read FItem;
    property Offset: Int64 read GetOffset;
    // The minimum content size is 0 bytes and a multiple of 2880 bytes
    property Size: Int64 read FSize write SetSize;
    // The exact number of meaningful bytes in the data section (exclusive
    // of fill that is needed after the data to complete the last 2880-byte
    // data block). The internal size is less than or equal to the size of
    // the data section
    property InternalSize: Int64 read GetInternalSize;
    property BitPix: TBitPix read GetBitPix;
    property AxesCount: Integer read GetAxesCount;
    property AxesLength[Number: Integer]: Integer read GetAxesLength;
    property PCount: Integer read GetPCount;
    property GCount: Integer read GetGCount;
    property PixelSize: Byte read GetPixelSize;
  end;

  TFitsItemDataClass = class of TFitsItemData;

  { TFitsItem: Header and Data Unit (HDU) }

  EFitsItemException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsItemOrder = (ioSingle, ioPrimary, ioExtension);

  TFitsItem = class(TFitsObject)
  private
    FContainer: TFitsContainer;
    FHead: TFitsItemHead;
    FData: TFitsItemData;
    FCacheProp: TFitsPropList;
    procedure Bind(AContainer: TFitsContainer);
    function CanPrimary: Boolean;
    procedure SetOrder(AOrder: TFitsItemOrder);
    function GetIndex: Integer;
    function GetOffset: Int64;
    function GetSize: Int64;
    function GetEstimateSize: Int64;
  protected
    procedure Init; override;
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure AppendCacheProp(AProp: IFitsPropContext);
    function ExtractCacheProp(AProp: IFitsPropContext): Boolean;
    function ExtractHeadProp(AProp: IFitsPropContext): Boolean;
    procedure DoGetXTENSION(AProp: IXTENSION); virtual;
    procedure DoGetEXTNAME(AProp: IEXTNAME); virtual;
    procedure DoGetEXTVER(AProp: IEXTVER); virtual;
    procedure DoGetEXTLEVEL(AProp: IEXTLEVEL); virtual;
    procedure DoGetBITPIX(AProp: IBITPIX); virtual;
    procedure DoGetNAXIS(AProp: INAXIS); virtual;
    procedure DoGetNAXES(AProp: INAXES); virtual;
    procedure DoGetPCOUNT(AProp: IPCOUNT); virtual;
    procedure DoGetGCOUNT(AProp: IGCOUNT); virtual;
    procedure ChangeContent(const AOffset, ASize: Int64); virtual;
    function GetHeadClass: TFitsItemHeadClass; virtual;
    function GetDataClass: TFitsItemDataClass; virtual;
  public
    constructor Create(AContainer: TFitsContainer); virtual;
    constructor CreateNew(AContainer: TFitsContainer; ASpec: TFitsItemSpec); virtual;
    destructor Destroy; override;
    class function ExtensionType: string; virtual;
    class function ExtensionTypeIs(AItem: TFitsItem): Boolean; virtual;
    // Extract, set default, calculate and validate the values of mandatory
    // and optional (reserved) keyword records. Methods may throw exceptions
    function GetXTENSION: string;
    function GetEXTNAME: string;
    function GetEXTVER: Integer;
    function GetEXTLEVEL: Integer;
    function GetBITPIX: TBitPix;
    function GetNAXIS: Integer;
    // Dimension of the data section axis, numbering range is [1..NAXIS]
    function GetNAXES(ANumber: Integer): Integer;
    function GetPCOUNT: Integer;
    function GetGCOUNT: Integer;
    property Container: TFitsContainer read FContainer;
    property Index: Integer read GetIndex;
    property Offset: Int64 read GetOffset;
    property Size: Int64 read GetSize;
    property Head: TFitsItemHead read FHead;
    property Data: TFitsItemData read FData;
  end;

  TFitsItemClass = class of TFitsItem;

  { TFitsMemory: memory manager for allocating some buffers. Important!
    The calling procedure must ensure that Allocate() is not called on
    more than one variable at a time }

  EFitsMemoryException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsMemory = class(TFitsObject)
  protected
    FContainer: TFitsContainer;
{$IFDEF DELAFITS_MEMORY_OBJECT}
    FBytes1: TBytes1;
    FBytes2: TBytes2;
{$ENDIF}
    function GetExceptionClass: EFitsExceptionClass; override;
  public
    constructor Create(AContainer: TFitsContainer); virtual;
    procedure Allocate(out ABytes: TBytes1; ASize: Integer); overload; virtual;
    procedure Allocate(out ABytes: TBytes2; ASize1, ASize2: Integer); overload; virtual;
    procedure Reset; virtual;
  end;

  TFitsMemoryClass = class of TFitsMemory;

  { TFitsContent: access to content (raw stream) }

  EFitsContentException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsContent = class(TFitsObject)
  private
    FContainer: TFitsContainer;
    FStream: TStream;
    function GetSize: Int64;
    procedure Change(const AOffset, ASize: Int64);
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
  public
    constructor Create(AContainer: TFitsContainer; AStream: TStream); virtual;
    procedure Read(const AOffset, ASize: Int64; var ABuffer); virtual;
    procedure ReadBuffer(const AOffset, ACount: Int64; var ABuffer: TBuffer);
    procedure ReadString(const AOffset, ACount: Int64; var ABuffer: string);
    procedure Write(const AOffset, ASize: Int64; const ABuffer); virtual;
    procedure WriteBuffer(const AOffset, ACount: Int64; const ABuffer: TBuffer);
    procedure WriteString(const AOffset, ACount: Int64; const ABuffer: string);
    // [Uses TFitsMemory]
    procedure Fill(const AOffset, ASize: Int64; AChar: Char);
    // [Uses TFitsMemory] Rewrite content: AShift > 0 - shift content down, AShift < 0 - shift content up
    procedure Shift(const AOffset, ASize, AShift: Int64);
    // [Uses TFitsMemory]
    procedure Rotate(const AOffset, ASize: Int64);
    // [Uses TFitsMemory]
    procedure Exchange(var AOffset1: Int64; const ASize1: Int64; var AOffset2: Int64; const ASize2: Int64);
    // [Uses TFitsMemory]
    procedure Move(const AOffset, ASize: Int64; var ANewOffset: Int64);
    // [Uses TFitsMemory] Resize content: ASize > 0 - grow size content, ASize < 0 - reduce size content
    procedure Resize(const AOffset, ASize: Int64);
    property Size: Int64 read GetSize;
    property Stream: TStream read FStream;
  end;

  TFitsContentClass = class of TFitsContent;

  { TFitsItemList: list owns TFitsItem instances (HDU) }

  TFitsItemList = class(TList)
  private
    function GetItem(AIndex: Integer): TFitsItem;
    procedure SetItem(AIndex: Integer; AItem: TFitsItem);
  public
    destructor Destroy; override;
    function IndexOf(AItem: TFitsItem): Integer;
    procedure Remove(AIndex: Integer);
    procedure Delete(AIndex: Integer); overload;
    procedure Delete(AItem: TFitsItem); overload;
    property Items[Index: Integer]: TFitsItem read GetItem write SetItem; default;
  end;

  { TFitsContainer: container with a collection of TFitsItem instances (HDU) }

  EFitsContainerException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsContainer = class(TFitsObject)
  private
    FMemory: TFitsMemory;
    FContent: TFitsContent;
    FItems: TFitsItemList;
    FItemsCursor: Integer;
    procedure MakeItems;
    procedure ReorderItems;
    function GetItemClass(AIndex: Integer): TFitsItemClass;
    procedure SetItemClass(AIndex: Integer; AItemClass: TFitsItemClass);
    function GetItem(AIndex: Integer): TFitsItem;
    function GetPrimary: TFitsItem;
    function GetCount: Integer;
    procedure Check(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    function GetMemoryClass: TFitsMemoryClass; virtual;
    function GetContentClass: TFitsContentClass; virtual;
  public
    constructor Create(AStream: TStream);
    destructor Destroy; override;
    function Add(AItemClass: TFitsItemClass; AItemSpec: TFitsItemSpec): TFitsItem;
    procedure Delete(AIndex: Integer);
    procedure Exchange(AIndex1, AIndex2: Integer);
    procedure Move(ACurIndex, ANewIndex: Integer);
    function IndexOf(AItem: TFitsItem): Integer;
    // The method checks whether the specified class can work with this HDU
    function ItemExtensionTypeIs(AIndex: Integer; AItemClass: TFitsItemClass): Boolean;
    property ItemClasses[Index: Integer]: TFitsItemClass read GetItemClass write SetItemClass;
    property Items[Index: Integer]: TFitsItem read GetItem; default;
    property Primary: TFitsItem read GetPrimary;
    property Count: Integer read GetCount;
    // Memory manager for temporary data, internal use object
    property Memory: TFitsMemory read FMemory;
    // Access to stream data
    property Content: TFitsContent read FContent;
  end;

implementation

{ EFitsItemSpecException }

function EFitsItemSpecException.GetTopic: string;
begin
  Result := 'SPEC';
end;

{ TFitsItemSpec }

function TFitsItemSpec.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsItemSpecException;
end;

function TFitsItemSpec.ExtractProp(AItem: TFitsItem; AProp: IFitsPropContext): Boolean;
var
  LIndex: Integer;
begin
  LIndex := AItem.Head.LineIndexOfKeyword(AProp.Keyword);
  if LIndex >= 0 then
    AProp.AssignValue(AItem.Head.Lines[LIndex]);
  Result := LIndex >= 0;
end;

{ Header prop }

function DefaultPCOUNT: Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_4.4.1.2] Conforming extensions ... PCOUNT keyword
  Result := 0;
end;

function CorrectPCOUNT(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue >= 0;
end;

function DefaultGCOUNT: Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_4.4.1.2] Conforming extensions ... PCOUNT keyword
  Result := 1;
end;

function CorrectGCOUNT(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue >= 1;
end;

{ Header line }

type
  TLineType = (lineEmpty, lineTypical, lineContinuedStart, lineContinuedChain, lineContinuedFinal, lineGrouped);

function LineTypeOf(const ALine: string; out LKeyword: string): TLineType;
var
  LRecord: TLineRecord;
begin
  if Trim(ALine) = '' then
  begin
    LKeyword := '';
    Result := lineEmpty;
    Exit;
  end;
  LRecord := LineToRecord(ALine);
  LKeyword := LRecord.Keyword;
  if LRecord.ValueIndicate then
  begin
    Result := lineTypical;
    if IsQuotedAmpersandString(LRecord.Value) then
      Result := lineContinuedStart;
  end else
  begin
    Result := lineGrouped;
    if LKeyword = cCONTINUE then
    begin
      if IsQuotedAmpersandString(LRecord.Value) then
        Result := lineContinuedChain
      else if IsQuotedString(LRecord.Value) then
        Result := lineContinuedFinal;
    end;
  end;
end;

function EnsureLine(const ALine: string): string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := EnsureString(ALine, -cSizeLine);
end;

function NewLineProp(AProp: IFitsPropContext): string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AProp.NewLine;
end;

function NewLineSIMPLE: string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := NewLineProp(TFitsSIMPLE.CreateValue(True));
end;

function NewLineEXTEND: string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := NewLineProp(TFitsEXTEND.CreateValue(True));
end;

function NewLineXTENSION(const AValue: string): string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := NewLineProp(TFitsXTENSION.CreateValue(AValue));
end;

function NewLineBITPIX: string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := NewLineProp(TFitsBITPIX.CreateValue(bi08u));
end;

function NewLineNAXIS: string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := NewLineProp(TFitsNAXIS.CreateValue(0));
end;

function NewLinePCOUNT: string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := NewLineProp(TFitsPCOUNT.CreateValue(DefaultPCOUNT));
end;

function NewLineGCOUNT: string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := NewLineProp(TFitsGCOUNT.CreateValue(DefaultGCOUNT));
end;

function NewLineEND: string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := PadString(cEND, -cSizeLine);
end;

{ Header line keyword }

function ExistsKeyword(const ALines, AKeyword: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  LPosition: Integer;
  LKeyword: string;
begin
  Result := False;
  LPosition := 1;
  while (not Result) and (LPosition <= Length(ALines)) do
  begin
    LKeyword := Trim(Copy(ALines, LPosition, cSizeKeyword));
    Result := SameText(LKeyword, AKeyword);
    Inc(LPosition, cSizeLine);
  end;
end;

function EnsureKeyword(const AKeyword: string): string; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := UpperCase(EnsureString(AKeyword, -cSizeKeyword));
end;

{ Header card }

function CardTypeOf(const ACard: string): TCardType;
var
  LKeyword, LMainKeyword: string;
  LWidth, LPosition: Integer;
begin
  Result := cardUnknown;
  LWidth := Length(ACard);
  LKeyword := '';
  LMainKeyword := '';
  case LineTypeOf(Copy(ACard, 1, cSizeLine), {out} LMainKeyword) of
    lineEmpty:
      begin
        if LWidth = cSizeLine then
          Result := cardEmpty;
      end;
    lineTypical:
      begin
        if LWidth = cSizeLine then
          Result := cardTypical;
      end;
    lineContinuedStart:
      begin
        LPosition := cSizeLine + 1;
        while (LPosition <= (LWidth - 2 * cSizeLine + 1)) and
          (LineTypeOf(Copy(ACard, LPosition, cSizeLine), {out} LKeyword) = lineContinuedChain) do
          Inc(LPosition, cSizeLine);
        if (LPosition = (LWidth - cSizeLine + 1)) and
          (LineTypeOf(Copy(ACard, LPosition, cSizeLine), {out} LKeyword) in [lineContinuedChain, lineContinuedFinal]) then
          Inc(LPosition, cSizeLine);
        if LPosition = (LWidth + 1) then
          Result := cardContinued;
      end;
    lineGrouped:
      begin
        LPosition := cSizeLine + 1;
        while (LPosition <= (LWidth - cSizeLine + 1)) and
          (LineTypeOf(Copy(ACard, LPosition, cSizeLine), {out} LKeyword) = lineGrouped) and SameText(LMainKeyword, LKeyword) do
          Inc(LPosition, cSizeLine);
        if LPosition = (LWidth + 1) then
          Result := cardGrouped;
      end;
  end;
end;

{ Snippet: access to content within specified boundaries }

type
  ISnippet = interface(IInterface)
    ['{13803F6C-1F3D-49E6-953E-C5CCCC9B7416}']
    procedure Read(const AInternalOffset, ASize: Int64; var ABuffer);
    procedure Write(const AInternalOffset, ASize: Int64; const ABuffer);
    procedure ReadString(const AInternalOffset, ASize: Int64; var ABuffer: string);
    procedure WriteString(const AInternalOffset, ASize: Int64; const ABuffer: string);
    procedure Exchange(var AInternalOffset1: Int64; const ASize1: Int64; var AInternalOffset2: Int64; const ASize2: Int64);
    procedure Move(const AInternalOffset, ASize: Int64; var ANewInternalOffset: Int64);
    procedure Erase(const AInternalOffset, ASize: Int64);
    function Ensure(const ASize: Int64): Int64;
    function Delete(const AInternalOffset, ASize: Int64): Int64;
    function Insert(const AInternalOffset, ASize: Int64): Int64;
    function Add(const ASize: Int64; out AInternalOffset: Int64): Int64;
  end;

  TSnippet = class(TFitsInterfacedObject, ISnippet)
  private
    FExceptionClass: EFitsExceptionClass;
    FContent: TFitsContent;
    FOffset: Int64;
    FSize: Int64;
    FMinSize: Int64;
    FFiller: Char;
    procedure Check(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
    // Raw access
    procedure Read(const AInternalOffset, ASize: Int64; var ABuffer);
    procedure Write(const AInternalOffset, ASize: Int64; const ABuffer);
    procedure ReadString(const AInternalOffset, ASize: Int64; var ABuffer: string);
    procedure WriteString(const AInternalOffset, ASize: Int64; const ABuffer: string);
    procedure Exchange(var AInternalOffset1: Int64; const ASize1: Int64; var AInternalOffset2: Int64; const ASize2: Int64);
    procedure Move(const AInternalOffset, ASize: Int64; var ANewInternalOffset: Int64);
    procedure Erase(const AInternalOffset, ASize: Int64);
    // Ensures that size changes are multiples of 2880 bytes
    function Ensure(const ASize: Int64): Int64;
    function Delete(const AInternalOffset, ASize: Int64): Int64;
    function Insert(const AInternalOffset, ASize: Int64): Int64;
    function Add(const ASize: Int64; out AInternalOffset: Int64): Int64;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
  public
    class function Make(AObject: TFitsObject): ISnippet;
  end;

{ TSnippet }

class function TSnippet.Make(AObject: TFitsObject): ISnippet;
var
  LHead: TFitsItemHead;
  LData: TFitsItemData;
  LSnippet: TSnippet;
begin
  LSnippet := TSnippet.Create;
  if AObject is TFitsItemHead then
  begin
    LHead := AObject as TFitsItemHead;
    LSnippet.FExceptionClass := LHead.GetExceptionClass;
    LSnippet.FContent := LHead.Item.Container.Content;
    LSnippet.FOffset := LHead.Offset;
    LSnippet.FSize := LHead.Size;
    LSnippet.FMinSize := cSizeBlock;
    LSnippet.FFiller := cChrBlank;
  end else
  if AObject is TFitsItemData then
  begin
    LData := AObject as TFitsItemData;
    LSnippet.FExceptionClass := LData.GetExceptionClass;
    LSnippet.FContent := LData.Item.Container.Content;
    LSnippet.FOffset := LData.Offset;
    LSnippet.FSize := LData.Size;
    LSnippet.FMinSize := 0;
    LSnippet.FFiller := LData.Filler;
  end else
  begin
    FreeAndNil(LSnippet);
    Assert(False, SAssertionFailure);
  end;
  Result := LSnippet;
end;

function TSnippet.GetExceptionClass: EFitsExceptionClass;
begin
  Result := FExceptionClass;
end;

procedure TSnippet.Check(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
var
  LArgOffset, LArgSize, LArgOffset2, LArgSize2: Int64;
begin
  if ACheck = 'bounds' then
  begin
    LArgOffset := AArgs[0].VInt64^;
    LArgSize := AArgs[1].VInt64^;
    if not InSegmentBound({ASegmentPosition:} 0, FSize, LArgOffset, LArgSize) then
      Error(SContentChunkOutBounds, [LArgOffset, LArgSize, FSize], ACodeError);
  end else
  if ACheck = 'offset' then
  begin
    LArgOffset := AArgs[0].VInt64^;
    if not InSegmentBound({ASegmentPosition:} 0, FSize, LArgOffset) then
      Error(SContentOffsetOutBounds, [LArgOffset, FSize], ACodeError);
  end else
  if ACheck = 'offset.new' then
  begin
    LArgOffset := AArgs[0].VInt64^;
    if not InSegmentBound({ASegmentPosition:} 0, FSize + 1, LArgOffset) then
      Error(SContentOffsetOutBounds, [LArgOffset, FSize], ACodeError);
  end else
  if ACheck = 'size' then
  begin
    LArgSize := AArgs[0].VInt64^;
    if LArgSize <= 0 then
      Error(SContentInvalidSize, [LArgSize], ACodeError);
  end else
  if ACheck = 'overlap' then
  begin
    LArgOffset := AArgs[0].VInt64^;
    LArgSize := AArgs[1].VInt64^;
    LArgOffset2 := AArgs[2].VInt64^;
    LArgSize2 := AArgs[3].VInt64^;
    if InSegmentBound(LArgOffset, LArgSize, LArgOffset2) or
       InSegmentBound(LArgOffset, LArgSize, LArgOffset2 + LArgSize2 - 1) then
      Error(SContentChunksOverlap, [LArgOffset, LArgSize, LArgOffset2, LArgSize2],
        ACodeError);
  end else
    Assert(False, SAssertionFailureArgs(AArgs));
end;

procedure TSnippet.Read(const AInternalOffset, ASize: Int64; var ABuffer);
begin
  Check('bounds', [AInternalOffset, ASize], ERROR_ITEM_READCHUNK_BOUNDS);
  FContent.Read(FOffset + AInternalOffset, ASize, {var} ABuffer);
end;

procedure TSnippet.ReadString(const AInternalOffset, ASize: Int64; var ABuffer: string);
begin
  Check('bounds', [AInternalOffset, ASize], ERROR_ITEM_READCHUNK_BOUNDS);
  FContent.ReadString(FOffset + AInternalOffset, ASize, {var} ABuffer);
end;

procedure TSnippet.Write(const AInternalOffset, ASize: Int64; const ABuffer);
begin
  Check('bounds', [AInternalOffset, ASize], ERROR_ITEM_WRITECHUNK_BOUNDS);
  FContent.Write(FOffset + AInternalOffset, ASize, ABuffer);
end;

procedure TSnippet.WriteString(const AInternalOffset, ASize: Int64; const ABuffer: string);
begin
  Check('bounds', [AInternalOffset, ASize], ERROR_ITEM_WRITECHUNK_BOUNDS);
  FContent.WriteString(FOffset + AInternalOffset, ASize, ABuffer);
end;

procedure TSnippet.Exchange(var AInternalOffset1: Int64; const ASize1: Int64; var AInternalOffset2: Int64; const ASize2: Int64);
var
  LOffset1, LOffset2: Int64;
begin
  Check('bounds', [AInternalOffset1, ASize1], ERROR_ITEM_EXCHANGECHUNK_BOUNDS);
  Check('bounds', [AInternalOffset2, ASize2], ERROR_ITEM_EXCHANGECHUNK_BOUNDS);
  Check('overlap', [AInternalOffset1, ASize1, AInternalOffset2, ASize2], ERROR_ITEM_EXCHANGECHUNK_OVERLAP);
  LOffset1 := FOffset + AInternalOffset1;
  LOffset2 := FOffset + AInternalOffset2;
  FContent.Exchange({var} LOffset1, ASize1, {var} LOffset2, ASize2);
  AInternalOffset1 := LOffset1 - FOffset;
  AInternalOffset2 := LOffset2 - FOffset;
end;

procedure TSnippet.Move(const AInternalOffset, ASize: Int64; var ANewInternalOffset: Int64);
var
  LCurOffset, LNewOffset: Int64;
begin
  Check('bounds', [AInternalOffset, ASize], ERROR_ITEM_MOVECHUNK_BOUNDS);
  Check('offset', [ANewInternalOffset], ERROR_ITEM_MOVECHUNK_OFFSET);
  Check('overlap', [AInternalOffset, ASize, ANewInternalOffset, Int64(1)], ERROR_ITEM_MOVECHUNK_OVERLAP);
  LCurOffset := FOffset + AInternalOffset;
  LNewOffset := FOffset + ANewInternalOffset;
  FContent.Move(LCurOffset, ASize, {var} LNewOffset);
  ANewInternalOffset := LNewOffset - FOffset;
end;

procedure TSnippet.Erase(const AInternalOffset, ASize: Int64);
begin
  Check('bounds', [AInternalOffset, ASize], ERROR_ITEM_ERASECHUNK_BOUNDS);
  FContent.Fill(FOffset + AInternalOffset, ASize, FFiller);
end;

function TSnippet.Ensure(const ASize: Int64): Int64;
var
  LSize, LRank: Int64;
begin
  // Grow or reduce snippet size
  LSize := EnsureMultiply(Math.Max(ASize, 0), cSizeBlock, {ARetainZeroValue:} FMinSize = 0);
  if LSize > FSize then
    FContent.Resize(FOffset + FSize, LSize - FSize);
  if LSize < FSize then
    FContent.Resize(FOffset + LSize, LSize - FSize);
  // Erase meaningless bytes
  LRank := LSize - Math.Max(ASize, 0);
  if LRank > 0 then
    FContent.Fill(FOffset + LSize - LRank, LRank, FFiller);
  // Return new snippet size
  Result := LSize;
end;

function TSnippet.Delete(const AInternalOffset, ASize: Int64): Int64;
var
  LSize, LRank: Int64;
begin
  Check('bounds', [AInternalOffset, ASize], ERROR_ITEM_DELETECHUNK_BOUNDS);
  // Delete custom block
  FContent.Resize(FOffset + AInternalOffset, -ASize);
  LSize := FSize - ASize;
  // Ensure snippet size
  LRank := EnsureMultiply(LSize, cSizeBlock, {ARetainZeroValue:} FMinSize = 0) - LSize;
  if LRank > 0 then
  begin
    FContent.Resize(FOffset + LSize, LRank);
    FContent.Fill(FOffset + LSize, LRank, FFiller);
    LSize := LSize + LRank;
  end;
  // Return new snippet size
  Result := LSize;
end;

function TSnippet.Insert(const AInternalOffset, ASize: Int64): Int64;
var
  LSize, LRank: Int64;
begin
  Check('offset.new', [AInternalOffset], ERROR_ITEM_INSERTCHUNK_OFFSET);
  Check('size', [ASize], ERROR_ITEM_INSERTCHUNK_SIZE);
  // Insert custom block
  FContent.Resize(FOffset + AInternalOffset, ASize);
  LSize := FSize + ASize;
  // Ensure snippet size
  LRank := EnsureMultiply(ASize, cSizeBlock, {ARetainZeroValue:} True) - ASize;
  if LRank > 0 then
  begin
    FContent.Resize(FOffset + LSize, LRank);
    FContent.Fill(FOffset + LSize, LRank, FFiller);
    LSize := LSize + LRank;
  end;
  // Return new snippet size
  Result := LSize;
end;

function TSnippet.Add(const ASize: Int64; out AInternalOffset: Int64): Int64;
var
  LSize, LRank: Int64;
begin
  Check('size', [ASize], ERROR_ITEM_ADDCHUNK_SIZE);
  // Added aligned block
  LSize := EnsureMultiply(ASize, cSizeBlock, {ARetainZeroValue:} True);
  FContent.Resize(FOffset + FSize, LSize);
  // Erase to an aligned block
  LRank := EnsureMultiply(ASize, cSizeBlock, {ARetainZeroValue:} True) - ASize;
  if LRank > 0 then
    FContent.Fill(FOffset + FSize + ASize, LRank, FFiller);
  // Returns the internal offset of the new block and the new snippet size
  AInternalOffset := FSize;
  Result := FSize + LSize;
end;

{ EFitsItemHeadException }

function EFitsItemHeadException.GetTopic: string;
begin
  Result := 'ITEMHEAD';
end;

{ TFitsItemHead }

procedure TFitsItemHead.Init;
begin
  inherited;
  FInternalSize := cInternalSizeNull;
  FCardCursor := cCardSpotNull;
end;

function TFitsItemHead.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsItemHeadException;
end;

procedure TFitsItemHead.Bind(AItem: TFitsItem);
begin
  if not Assigned(AItem) then
    Error(SItemNotAssigned, ERROR_ITEMHEAD_BIND_NO_ITEM);
  if AItem.Container.FItemsCursor < 0 then
    Error(SContainerNotControlBind, ERROR_ITEMHEAD_BIND_NO_INSPECT);
  FItem := AItem;
  FItem.FHead := Self;
end;

procedure TFitsItemHead.UnBind;
begin
  if Assigned(FItem) then
    FItem.FHead := nil;
end;

procedure TFitsItemHead.Make;
var
  LOffset, LEstimateSize, LInternalSize, LSize: Int64;
  LLine, LKeyword, LXtension: string;
  LSimple, LFindEnd: Boolean;
  LRecord: TLineRecord;
begin
  LOffset := GetOffset;
  // Get information (maximum estimate) about the size of the header
  LEstimateSize := FItem.GetEstimateSize;
  if LEstimateSize < cSizeBlock then
    Error(SItemNotMatchMinimumSize, [FItem.Index, LEstimateSize],
      ERROR_ITEMHEAD_MAKE_MINIMUM_SIZE);
  // Check the first line "SIMPLE" or "XTENSION"
  LLine := '';
  FItem.Container.Content.ReadString(LOffset, cSizeLine, {var} LLine);
  LRecord := LineToRecord(LLine);
  if FItem.Index = 0 then
  begin
    if not SameText(LRecord.Keyword, cSIMPLE) then
      Error(SHeadLineKeywordNotMatch, [LLine, cSIMPLE],
        ERROR_ITEMHEAD_MAKE_SIMPLE_NOT_MATCH);
    LSimple := StringToBool(LRecord.Value);
    if LSimple = False then
      Error(SHeadLineValueIncorrect, [LLine], ERROR_ITEMHEAD_MAKE_SIMPLE_VALUE);
  end else
  // if FItem.Index > 0 then
  begin
    if not SameText(LRecord.Keyword, cXTENSION) then
      Error(SHeadLineKeywordNotMatch, [LLine, cXTENSION],
        ERROR_ITEMHEAD_MAKE_XTENSIONE_NOT_MATCH);
    LXtension := UnquotedString(LRecord.Value);
    if LXtension = '' then
      Error(SHeadLineValueIncorrect, [LLine], ERROR_ITEMHEAD_MAKE_XTENSION_VALUE);
  end;
  // Find the keyword "END" and determine the internal size of the header
  LInternalSize := 0;
  LFindEnd := False;
  LKeyword := '';
  while (LInternalSize < LEstimateSize) and (not LFindEnd) do
  begin
    FItem.Container.Content.ReadString(LOffset + LInternalSize, cSizeKeyword, {var} LKeyword);
    LFindEnd := SameText(Trim(LKeyword), cEND);
    Inc(LInternalSize, cSizeLine);
  end;
  if not LFindEnd then
    Error(SHeadLineNotFound, [cEND], ERROR_ITEMHEAD_MAKE_KEYWORDEND_NOT_FOUND);
  // Set size of the header
  LSize := EnsureMultiply(LInternalSize, cSizeBlock, {ARetainZeroValue:} False);
  if LSize > LEstimateSize then
    Error(SItemNotMatchRecognizedSize, [FItem.Index, LEstimateSize, LSize],
      ERROR_ITEMHEAD_MAKE_RECOGNIZED_SIZE);
  FSize := LSize;
end;

procedure TFitsItemHead.MakeNew;
var
  LOffset, LEstimateSize, LSize: Int64;
  LContent: TFitsContent;
begin
  LOffset := GetOffset;
  LContent := FItem.Container.Content;
  // Get the available size for the new header section
  LEstimateSize := FItem.GetEstimateSize;
  // Get the required minimum size (2880 bytes) of the new header section
  LSize := cSizeBlock;
  // Prepare the content of the new header section
  if LEstimateSize < LSize then
    LContent.Resize(LOffset + LEstimateSize, LSize - LEstimateSize);
  LContent.Fill(LOffset, LSize, cChrBlank);
  // Initialize the new header content: add a minimal set of lines
  if FItem.Index = 0 then
  begin
    LContent.WriteString(LOffset + 0 * cSizeLine, cSizeLine, NewLineSIMPLE);
    LContent.WriteString(LOffset + 1 * cSizeLine, cSizeLine, NewLineBITPIX);
    LContent.WriteString(LOffset + 2 * cSizeLine, cSizeLine, NewLineNAXIS);
    LContent.WriteString(LOffset + 3 * cSizeLine, cSizeLine, NewLineEND);
  end else
  // if FItem.Index > 0 then
  begin
    LContent.WriteString(LOffset + 0 * cSizeLine, cSizeLine, NewLineXTENSION(FItem.ExtensionType));
    LContent.WriteString(LOffset + 1 * cSizeLine, cSizeLine, NewLineBITPIX);
    LContent.WriteString(LOffset + 2 * cSizeLine, cSizeLine, NewLineNAXIS);
    LContent.WriteString(LOffset + 3 * cSizeLine, cSizeLine, NewLinePCOUNT);
    LContent.WriteString(LOffset + 4 * cSizeLine, cSizeLine, NewLineGCOUNT);
    LContent.WriteString(LOffset + 5 * cSizeLine, cSizeLine, NewLineEND);
  end;
  // Set size of the new header
  FSize := LSize;
end;

procedure TFitsItemHead.Customize;
begin
  // Do nothing
end;

procedure TFitsItemHead.CustomizeNew(ASpec: TFitsItemSpec);
begin
  // Specification not used
  if Assigned(ASpec) then
    ;
end;

function TFitsItemHead.GetOffset: Int64;
begin
  Result := FItem.Offset;
end;

function TFitsItemHead.ExtractInternalSize: Int64;
var
  LKeyword, LKeywordEnd: string;
begin
  // 0 <= Result <= (FSize - cSizeLine)
  Result := FSize;
  LKeyword := BlankString(cSizeKeyword);
  LKeywordEnd := EnsureKeyword(cEND);
  while Result >= cSizeLine do
  begin
    FItem.Container.Content.ReadString(Offset + Result - cSizeLine, cSizeKeyword, {var} LKeyword);
    if SameText(LKeyword, LKeywordEnd) then
      Break;
    Dec(Result, cSizeLine);
  end;
end;

function TFitsItemHead.GetInternalSize: Int64;
begin
  if FInternalSize = cInternalSizeNull then
    FInternalSize := ExtractInternalSize;
  Result := FInternalSize;
end;

procedure TFitsItemHead.SetSize(const ASize: Int64);
begin
  FSize := TSnippet.Make(Self).Ensure(ASize);
end;

function TFitsItemHead.GetLineOffset(AIndex: Integer): Int64;
begin
  Result := FItem.Offset + Int64(AIndex) * cSizeLine;
end;

function TFitsItemHead.GetLineSize(ACount: Integer): Int64;
begin
  Result := Int64(ACount) * cSizeLine;
end;

function TFitsItemHead.GetLineCapacity: Integer;
begin
  Result := FSize div cSizeLine;
end;

function TFitsItemHead.GetLineCount: Integer;
begin
  Result := GetInternalSize div cSizeLine;
end;

procedure TFitsItemHead.Invalidate;
begin
  FInternalSize := cInternalSizeNull;
end;

constructor TFitsItemHead.Create(AItem: TFitsItem);
begin
  inherited Create;
  Bind(AItem);
  Make;
  Customize;
end;

constructor TFitsItemHead.CreateNew(AItem: TFitsItem; ASpec: TFitsItemSpec);
begin
  inherited Create;
  Bind(AItem);
  MakeNew;
  CustomizeNew(ASpec);
end;

destructor TFitsItemHead.Destroy;
begin
  UnBind;
  inherited;
end;

procedure TFitsItemHead.ReadChunk(const AInternalOffset, ASize: Int64; var ABuffer: string);
begin
  TSnippet.Make(Self).ReadString(AInternalOffset, ASize, {var} ABuffer);
end;

procedure TFitsItemHead.WriteChunk(const AInternalOffset, ASize: Int64; const ABuffer: string);
begin
  TSnippet.Make(Self).WriteString(AInternalOffset, ASize, ABuffer);
end;

procedure TFitsItemHead.ExchangeChunk(var AInternalOffset1: Int64; const ASize1: Int64; var AInternalOffset2: Int64; const ASize2: Int64);
begin
  TSnippet.Make(Self).Exchange({var} AInternalOffset1, ASize1, {var} AInternalOffset2, ASize2);
end;

procedure TFitsItemHead.MoveChunk(const AInternalOffset, ASize: Int64; var ANewInternalOffset: Int64);
begin
  TSnippet.Make(Self).Move(AInternalOffset, ASize, {var} ANewInternalOffset);
end;

procedure TFitsItemHead.EraseChunk(const AInternalOffset, ASize: Int64);
begin
  TSnippet.Make(Self).Erase(AInternalOffset, ASize);
end;

procedure TFitsItemHead.DeleteChunk(const AInternalOffset, ASize: Int64);
begin
  FSize := TSnippet.Make(Self).Delete(AInternalOffset, ASize);
end;

procedure TFitsItemHead.InsertChunk(const AInternalOffset, ASize: Int64);
begin
  FSize := TSnippet.Make(Self).Insert(AInternalOffset, ASize);
end;

function TFitsItemHead.AddChunk(const ASize: Int64): Int64;
begin
  FSize := TSnippet.Make(Self).Add(ASize, {out} Result);
end;

procedure TFitsItemHead.CheckLines(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
var
  LArgIndex, LArgCount, LLineCount: Integer;
  LArgString: string;
begin
  if ACheck = 'bounds' then
  begin
    LArgIndex := AArgs[0].VInteger;
    LArgCount := AArgs[1].VInteger;
    LLineCount := GetLineCount;
    if not InSegmentBound({ASegmentPosition:} 0, LLineCount, LArgIndex, LArgCount) then
      Error(SHeadLinesRangeOutBounds, [LArgIndex, LArgCount, LLineCount], ACodeError);
  end else
  if ACheck = 'bounds.inner' then
  begin
    LArgIndex := AArgs[0].VInteger;
    LArgCount := AArgs[1].VInteger;
    LLineCount := GetLineCount;
    if not InSegmentBound({ASegmentPosition:} 0, LLineCount, LArgIndex, LArgCount) then
      Error(SHeadLinesRangeOutBounds, [LArgIndex, LArgCount, LLineCount], ACodeError);
    if (LArgIndex + LArgCount) = LLineCount then
      Error(SHeadLinesRangeAtLowerBound, [LArgIndex, LArgCount, LLineCount], ACodeError);
  end else
  if ACheck = 'index' then
  begin
    LArgIndex := AArgs[0].VInteger;
    LLineCount := GetLineCount;
    if not InSegmentBound({ASegmentPosition:} 0, LLineCount, LArgIndex) then
      Error(SHeadLineIndexOutBounds, [LArgIndex, LLineCount], ACodeError);
  end else
  if ACheck = 'index.inner' then
  begin
    LArgIndex := AArgs[0].VInteger;
    LLineCount := GetLineCount;
    if not InSegmentBound({ASegmentPosition:} 0, LLineCount, LArgIndex) then
      Error(SHeadLineIndexOutBounds, [LArgIndex, LLineCount], ACodeError);
    if LArgIndex = LLineCount - 1 then
      Error(SHeadLineIndexAtLowerBound, [LArgIndex, LLineCount], ACodeError);
  end else
  if ACheck = 'keyword' then
  begin
    LArgString := string(AArgs[0].VWideString);
    if ExistsKeyword(LArgString, cEND) then
      Error(SHeadLineCannotChanged, [cEND], ACodeError);
  end else
    Assert(False, SAssertionFailureArgs(AArgs));
end;

function TFitsItemHead.GetLineBy(AIndex: Integer): string;
begin
  Result := '';
  FItem.Container.Content.ReadString(GetLineOffset(AIndex), cSizeLine, {var} Result);
end;

function TFitsItemHead.GetLine(AIndex: Integer): string;
begin
  Result := '';
  ReadLines(AIndex, {ACount:} 1, {var} Result);
end;

procedure TFitsItemHead.SetLine(AIndex: Integer; const ALine: string);
var
  LLine: string;
begin
  LLine := EnsureLine(ALine);
  WriteLines(AIndex, LLine);
end;

procedure TFitsItemHead.ReadLinesBy(AIndex, ACount: Integer; var ALines: string);
begin
  FItem.Container.Content.ReadString(GetLineOffset(AIndex), GetLineSize(ACount), {var} ALines);
end;

procedure TFitsItemHead.ReadLines(AIndex, ACount: Integer; var ALines: string);
begin
  // It is allowed to read a line from the end position
  CheckLines('bounds', [AIndex, ACount], ERROR_ITEMHEAD_READLINES_BOUNDS);
  ReadLinesBy(AIndex, ACount, {var} ALines);
end;

procedure TFitsItemHead.WriteLinesBy(AIndex: Integer; const ALines: string);
begin
  FItem.Container.Content.WriteString(GetLineOffset(AIndex), Length(ALines), ALines);
end;

procedure TFitsItemHead.WriteLines(AIndex: Integer; const ALines: string);
var
  LWidth: Integer;
  LLines: string;
begin
  LWidth := Integer(EnsureMultiply(Length(ALines), cSizeLine, {ARetainZeroValue:} False));
  CheckLines('bounds.inner', [AIndex, Integer(LWidth div cSizeLine)], ERROR_ITEMHEAD_WRITELINES_BOUNDS);
  CheckLines('keyword', [ALines], ERROR_ITEMHEAD_WRITELINES_KEYWORD);
  LLines := PadString(ALines, -LWidth);
  WriteLinesBy(AIndex, LLines);
end;

procedure TFitsItemHead.ExchangeLines(AIndex1, AIndex2: Integer);
var
  LOffset1, LOffset2: Int64;
begin
  CheckLines('index.inner', [AIndex1], ERROR_ITEMHEAD_EXCHANGELINES_BOUNDS);
  CheckLines('index.inner', [AIndex2], ERROR_ITEMHEAD_EXCHANGELINES_BOUNDS);
  LOffset1 := GetLineOffset(AIndex1);
  LOffset2 := GetLineOffset(AIndex2);
  FItem.Container.Content.Exchange({var} LOffset1, cSizeLine, {var} LOffset2, cSizeLine);
end;

procedure TFitsItemHead.MoveLinesBy(ACurIndex, ACurCount: Integer; var ANewIndex: Integer; ANewCount: Integer);
var
  LCurOffset, LNewOffset, LCurSize, LNewSize: Int64;
begin
  LCurOffset := GetLineOffset(ACurIndex);
  LNewOffset := GetLineOffset(ANewIndex);
  LCurSize := GetLineSize(ACurCount);
  LNewSize := GetLineSize(ANewCount);
  // Correction for moving the line "down"
  if ACurIndex < ANewIndex then
    LNewOffset := LNewOffset + LNewSize - 1;
  FItem.Container.Content.Move(LCurOffset, LCurSize, {var} LNewOffset);
  ANewIndex := (LNewOffset - FItem.Offset) div cSizeLine;
end;

procedure TFitsItemHead.MoveLines(ACurIndex, ANewIndex: Integer);
var
  LNewIndex: Integer;
begin
  CheckLines('index.inner', [ACurIndex], ERROR_ITEMHEAD_MOVELINES_BOUNDS);
  CheckLines('index.inner', [ANewIndex], ERROR_ITEMHEAD_MOVELINES_BOUNDS);
  LNewIndex := ANewIndex;
  MoveLinesBy(ACurIndex, {ACurCount:} 1, {var} LNewIndex, {ANewCount:} 1);
end;

procedure TFitsItemHead.EraseLinesBy(AIndex, ACount: Integer);
begin
  FItem.Container.Content.Fill(GetLineOffset(AIndex), GetLineSize(ACount), {AChar:} cChrBlank);
end;

procedure TFitsItemHead.EraseLines(AIndex, ACount: Integer);
begin
  CheckLines('bounds.inner', [AIndex, ACount], ERROR_ITEMHEAD_ERASELINES_BOUNDS);
  EraseLinesBy(AIndex, ACount);
end;

procedure TFitsItemHead.DeleteLinesBy(AIndex, ACount: Integer);
var
  LOffset, LInternalSize, LCountSize, LSize, LRank: Int64;
  LContent: TFitsContent;
begin
  // Shift up the meaningful lines (below the deleted lines)
  LContent := FItem.Container.Content;
  LOffset := GetOffset;
  LInternalSize := GetInternalSize;
  LCountSize := GetLineSize(ACount);
  LSize := LInternalSize - GetLineSize(AIndex + ACount); // shift block size
  LContent.Shift(LOffset + GetLineSize(AIndex + ACount), LSize, {AShift:} -LCountSize);
  // Calculate new size
  LInternalSize := LInternalSize - LCountSize; // new internal size
  LSize := EnsureMultiply(LInternalSize, cSizeBlock, {ARetainZeroValue:} False); // new size
  // Delete unnecessary 2880-byte blocks after the end line
  if FSize > LSize then
    LContent.Resize(LOffset + LSize, LSize - FSize);
  // Erase unnecessary lines after the end line
  LRank := Math.IfThen(FSize > LSize, LSize - LInternalSize, LCountSize);
  if LRank > 0 then
    LContent.Fill(LOffset + LInternalSize, LRank, {AChar:} cChrBlank);
  // Set new size
  FSize := LSize;
end;

procedure TFitsItemHead.DeleteLines(AIndex, ACount: Integer);
begin
  CheckLines('bounds.inner', [AIndex, ACount], ERROR_ITEMHEAD_DELETELINES_BOUNDS);
  DeleteLinesBy(AIndex, ACount);
end;

procedure TFitsItemHead.InsertLinesBy(AIndex: Integer; const ALines: string);
var
  LInternalSize, LSize, LOffset, LWidth, LRank: Int64;
  LContent: TFitsContent;
begin
  LWidth := Length(ALines);
  // Determine if there is enough space for new lines after
  // the end line, or if new 2880-byte blocks need to be added
  LContent := FItem.Container.Content;
  LInternalSize := GetInternalSize;
  if LWidth <= (FSize - LInternalSize) then
  begin
    LOffset := GetLineOffset(AIndex);
    LContent.Shift(LOffset, LInternalSize - GetLineSize(AIndex), {AShift:} +LWidth);
    LContent.WriteString(LOffset, LWidth, ALines);
  end else
  // if LWidth > (FSize - LInternalSize) then
  begin
    LOffset := GetOffset;
    LSize := EnsureMultiply(LInternalSize + LWidth, cSizeBlock, {ARetainZeroValue:} False); // new size
    LContent.Resize(LOffset + FSize, LSize - FSize);
    LContent.Shift(LOffset + GetLineSize(AIndex), LInternalSize - GetLineSize(AIndex), {AShift:} +LWidth);
    LContent.WriteString(LOffset + GetLineSize(AIndex), LWidth, ALines);
    LRank := LSize - (LInternalSize + LWidth);
    if LRank > 0 then
      LContent.Fill(LOffset + (LInternalSize + LWidth), LRank, {AChar:} cChrBlank);
    FSize := LSize;
  end;
end;

procedure TFitsItemHead.InsertLines(AIndex: Integer; const ALines: string);
var
  LWidth: Integer;
  LLines: string;
begin
  // It is allowed to insert a new line at the end position
  CheckLines('index', [AIndex], ERROR_ITEMHEAD_INSERTLINES_BOUNDS);
  CheckLines('keyword', [ALines], ERROR_ITEMHEAD_INSERTLINES_KEYWORD);
  LWidth := EnsureMultiply(Length(ALines), cSizeLine, {ARetainZeroValue:} False);
  LLines := PadString(ALines, -Integer(LWidth));
  InsertLinesBy(AIndex, LLines);
end;

function TFitsItemHead.AddLines(const ALines: string): Integer;
begin
  Result := GetLineCount - 1;
  InsertLines(Result, ALines);
end;

function TFitsItemHead.GetLineKeywordBy(AIndex: Integer): string;
begin
  Result := '';
  FItem.Container.Content.ReadString(GetLineOffset(AIndex), cSizeKeyword, {var} Result);
  Result := Trim(Result);
end;

function TFitsItemHead.GetLineKeyword(AIndex: Integer): string;
begin
  // It is allowed to read the keyword "END"
  CheckLines('index', [AIndex], ERROR_ITEMHEAD_GETLINEKEYWORD_INDEX);
  Result := GetLineKeywordBy(AIndex);
end;

procedure TFitsItemHead.SetLineKeyword(AIndex: Integer; const AKeyword: string);
var
  LKeyword: string;
begin
  CheckLines('index.inner', [AIndex], ERROR_ITEMHEAD_SETLINEKEYWORD_INDEX);
  LKeyword := EnsureKeyword(AKeyword);
  CheckLines('keyword', [LKeyword], ERROR_ITEMHEAD_SETLINEKEYWORD_KEYWORD);
  FItem.Container.Content.WriteString(GetLineOffset(AIndex), cSizeKeyword, LKeyword);
end;

function TFitsItemHead.GetLineRecord(AIndex: Integer): TLineRecord;
begin
  Result := LineToRecord(Lines[AIndex]);
end;

procedure TFitsItemHead.SetLineRecord(AIndex: Integer; const ARecord: TLineRecord);
begin
  Lines[AIndex] := RecordToLine(ARecord);
end;

function TFitsItemHead.LineIndexOfKeyword(const AKeyword: string; AScope: Integer): Integer;
begin
  Result := LineIndexOfKeywords([AKeyword], AScope);
end;

function TFitsItemHead.LineIndexOfKeywords(const AKeywords: array of string; AScope: Integer): Integer;
var
  LStart, LIndex: Integer;
begin
  Result := -1;
  LStart := Abs(AScope);
  CheckLines('index', [LStart], ERROR_ITEMHEAD_LINEINDEXOFKEYWORDS);
  if AScope >= 0 then
  begin
    for LIndex := LStart to GetLineCount - 1 do
      if MatchText(GetLineKeywordBy(LIndex), AKeywords) then
      begin
        Result := LIndex;
        Break;
      end;
  end else
  begin
    for LIndex := LStart downto 0 do
      if MatchText(GetLineKeywordBy(LIndex), AKeywords) then
      begin
        Result := LIndex;
        Break;
      end;
  end;
end;

function TFitsItemHead.LineIndexOfLastAxis: Integer;
var
  LAxesCount, LNumber, LIndex: Integer;
  LLine, LKeyword, LAxesKeyword: string;
  LRecord: TLineRecord;
  LContent: TFitsContent;
begin
  Result := LineIndexOfKeyword(cNAXIS);
  if Result >= 0 then
  begin
    LContent := FItem.Container.Content;
    // Get NAXIS value
    LLine := '';
    LContent.ReadString(GetLineOffset(Result), cSizeLine, {var} LLine);
    LRecord := LineToRecord(LLine);
    LAxesCount := StringToInteger(LRecord.Value);
    // Find keyword NAXISn
    LKeyword := '';
    for LIndex := GetLineCount - 1 downto 1 do
    begin
      LKeyword := GetLineKeywordBy(LIndex);
      for LNumber := LAxesCount downto 1 do
      begin
        LAxesKeyword := Format(cNAXISn, [LNumber]);
        if SameText(LKeyword, LAxesKeyword) then
        begin
          Result := LIndex;
          Exit;
        end;
      end;
    end;
  end;
end;

function TFitsItemHead.ExtractLineKeywords: TKeywordDynArray;
var
  LIndex: Integer;
begin
  Result := nil;
  SetLength(Result, GetLineCount);
  for LIndex := 0 to Length(Result) - 1 do
    Result[LIndex] := GetLineKeywordBy(LIndex);
end;

procedure TFitsItemHead.CheckCard(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
var
  LArgStart, LArgCount, LLineCount, LSize: Integer;
  LArgString: string;
begin
  if ACheck = 'cursor' then
  begin
    LArgStart := AArgs[0].VInteger;
    LArgCount := AArgs[1].VInteger;
    LLineCount := GetLineCount;
    if not InSegmentBound({ASegmentPosition:} 0, LLineCount, LArgStart, LArgCount) then
      Error(SHeadCardCursorOutBounds, [LArgStart, LArgCount, LLineCount], ACodeError);
  end else
  if ACheck = 'cursor.inner' then
  begin
    LArgStart := AArgs[0].VInteger;
    LArgCount := AArgs[1].VInteger;
    LLineCount := GetLineCount;
    if not InSegmentBound({ASegmentPosition:} 0, LLineCount, LArgStart, LArgCount) then
      Error(SHeadCardCursorOutBounds, [LArgStart, LArgCount, LLineCount], ACodeError);
    if (LArgStart + LArgCount) = LLineCount then
      Error(SHeadCardCursorAtLowerBound, [LArgStart, LArgCount, LLineCount], ACodeError);
  end else
  if ACheck = 'content' then
  begin
    LArgString := string(AArgs[0].VWideString);
    if ExistsKeyword(LArgString, cEND) then
      Error(SHeadLineCannotChanged, [cEND], ACodeError);
    LSize := Length(LArgString);
    if (LSize < cSizeLine) or ((LSize mod cSizeLine) <> 0) then
      Error(SCardInvalidMultiSize, [LSize], ACodeError);
    if CardTypeOf(LArgString) = cardUnknown then
      Error(SCardInvalidContent, [LArgString], ACodeError);
  end else
    Assert(False, SAssertionFailureArgs(AArgs));
end;

function TFitsItemHead.LookupCard(ALineSeed: Integer): TCardSpot;
{ TODO -cTFitsItemHeader : process the orphaned "CONTINUE" keyword records similar to a "COMMENT" keyword records (as multi-line) }
{ TODO -cTFitsItemHeader : add support for the keyword "INHERIT" }
var
  LKeyword, LMainKeyword: string;
  LIndex, LStart, LCount: Integer;
begin
  LStart := ALineSeed;
  LCount := 1;
  LKeyword := '';
  LMainKeyword := '';
  case LineTypeOf(GetLineBy(ALineSeed), {out} LMainKeyword) of
    lineContinuedStart:
      begin
        for LIndex := ALineSeed + 1 to GetLineCount - 1 do
          case LineTypeOf(GetLineBy(LIndex), {out} LKeyword) of
            lineContinuedChain:
              Inc(LCount);
            lineContinuedFinal:
              begin
                Inc(LCount);
                Break;
              end;
          else
            Break;
          end;
      end;
    lineContinuedChain:
      begin
        for LIndex := ALineSeed - 1 downto 0 do
          case LineTypeOf(GetLineBy(LIndex), {out} LKeyword) of
            lineContinuedStart:
              begin
                Dec(LStart);
                Inc(LCount);
                Break;
              end;
            lineContinuedChain:
              begin
                Dec(LStart);
                Inc(LCount);
                if LIndex = 0 then
                begin
                  LStart := ALineSeed;
                  LCount := 1;
                end;
              end;
          else
            LStart := ALineSeed;
            LCount := 1;
            Break;
          end;
        if LCount > 1 then
          for LIndex := ALineSeed + 1 to GetLineCount - 1 do
            case LineTypeOf(GetLineBy(LIndex), {out} LKeyword) of
              lineContinuedChain:
                Inc(LCount);
              lineContinuedFinal:
                begin
                  Inc(LCount);
                  Break;
                end;
            else
              Break;
            end;
      end;
    lineContinuedFinal:
      begin
        for LIndex := ALineSeed - 1 downto 0 do
          case LineTypeOf(GetLineBy(LIndex), {out} LKeyword) of
            lineContinuedStart:
              begin
                Dec(LStart);
                Inc(LCount);
                Break;
              end;
            lineContinuedChain:
              begin
                Dec(LStart);
                Inc(LCount);
                if LIndex = 0 then
                begin
                  LStart := ALineSeed;
                  LCount := 1;
                end;
              end;
          else
            LStart := ALineSeed;
            LCount := 1;
            Break;
          end;
      end;
    lineGrouped:
      begin
        for LIndex := ALineSeed - 1 downto 0 do
          if (LineTypeOf(GetLineBy(LIndex), {out} LKeyword) = lineGrouped) and SameText(LMainKeyword, LKeyword) then
          begin
            Dec(LStart);
            Inc(LCount);
          end else
            Break;
        for LIndex := ALineSeed + 1 to GetLineCount - 1 do
          if (LineTypeOf(GetLineBy(LIndex), {out} LKeyword) = lineGrouped) and SameText(LMainKeyword, LKeyword) then
            Inc(LCount)
          else
            Break;
      end;
  end;
  Result.Start := LStart;
  Result.Count := LCount;
end;

function TFitsItemHead.GetCardType: TCardType;
begin
  Result := CardTypeOf(GetCard);
end;

function TFitsItemHead.LocateCard(const AKeyword: string; AScope: TSearchScope): Boolean;
begin
  Result := LocateCards([AKeyword], AScope);
end;

function TFitsItemHead.LocateCards(const AKeywords: array of string; AScope: TSearchScope): Boolean;
var
  LLineIndex, LLineStart: Integer;
  LForward: Boolean;
begin
  LLineStart := 0;
  LForward := True;
  case AScope of
    searchFirstForward :
      begin
        LLineStart := 0;
        LForward := True;
      end;
    searchLastBackward:
      begin
        LLineStart := GetLineCount - 1;
        LForward := False;
      end;
    searchNextForward:
      begin
        CheckCard('cursor', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_LOCATECARDS_NEXT);
        LLineStart := FCardCursor.Start + FCardCursor.Count;
        LForward := True;
      end;
    searchPriorBackward:
      begin
        CheckCard('cursor', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_LOCATECARDS_PRIOR);
        LLineStart := FCardCursor.Start - 1;
        LForward := False;
      end;
  end;
  Result := False;
  case LForward of
    True:
      for LLineIndex := LLineStart to GetLineCount - 1 do
        if MatchText(GetLineKeywordBy(LLineIndex), AKeywords) then
        begin
          FCardCursor := LookupCard(LLineIndex);
          Result := True;
          Break;
        end;
    False:
      for LLineIndex := LLineStart downto 0 do
        if MatchText(GetLineKeywordBy(LLineIndex), AKeywords) then
        begin
          FCardCursor := LookupCard(LLineIndex);
          Result := True;
          Break;
        end;
  end;
end;

function TFitsItemHead.FirstCard: Boolean;
begin
  if GetLineCount > 0 then
  begin
    FCardCursor := LookupCard({ALineSeed:} 0);
    Result := True;
  end else
  begin
    FCardCursor := cCardSpotNull;
    Result := False;
  end;
end;

function TFitsItemHead.LastCard: Boolean;
begin
  if GetLineCount > 0 then
  begin
    FCardCursor := LookupCard({ALineSeed:} GetLineCount - 1);
    Result := True;
  end else
  begin
    FCardCursor := cCardSpotNull;
    Result := False;
  end;
end;

function TFitsItemHead.NextCard: Boolean;
var
  LLineSeed: Integer;
begin
  CheckCard('cursor', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_NEXTCARD);
  LLineSeed := FCardCursor.Start + FCardCursor.Count;
  if LLineSeed < GetLineCount then
  begin
    FCardCursor := LookupCard(LLineSeed);
    Result := True;
  end else
    Result := False;
end;

function TFitsItemHead.PriorCard: Boolean;
var
  LLineSeed: Integer;
begin
  CheckCard('cursor', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_PRIORCARD);
  LLineSeed := FCardCursor.Start - 1;
  if LLineSeed >= 0 then
  begin
    FCardCursor := LookupCard(LLineSeed);
    Result := True;
  end else
    Result := False;
end;

function TFitsItemHead.GotoCard(ALineSeed: Integer): Boolean;
var
  LLineSeed, LLineCount: Integer;
begin
  LLineCount := GetLineCount;
  if LLineCount > 0 then
  begin
    LLineSeed := EnsureRange(ALineSeed, 0, LLineCount - 1);
    FCardCursor := LookupCard(LLineSeed);
    Result := True;
  end else
  begin
    FCardCursor := cCardSpotNull;
    Result := False;
  end;
end;

procedure TFitsItemHead.MoveCard(ADistance: Integer);
var
  LLineSeed, LDistance: Integer;
  LNewSpot: TCardSpot;
begin
  CheckCard('cursor.inner', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_MOVECARD_CURSPOT);
  // Get a new position at a distance of "ADistance" cards from the current one
  LNewSpot := FCardCursor;
  if ADistance > 0 then
  begin
    LDistance := ADistance;
    while LDistance > 0 do
    begin
      LLineSeed := LNewSpot.Start + LNewSpot.Count;
      if LLineSeed > (GetLineCount - 1) then
      begin
        LNewSpot.Start := LLineSeed;
        LNewSpot.Count := 0;
        Break;
      end;
      LNewSpot := LookupCard(LLineSeed);
      Dec(LDistance);
    end;
  end else
  if ADistance < 0 then
  begin
    LDistance := abs(ADistance);
    while LDistance > 0 do
    begin
      LLineSeed := LNewSpot.Start - 1;
      if LLineSeed < 0 then
      begin
        LNewSpot.Start := LLineSeed;
        LNewSpot.Count := 0;
        Break;
      end;
      LNewSpot := LookupCard(LLineSeed);
      Dec(LDistance);
    end;
  end;
  CheckCard('cursor.inner', [LNewSpot.Start, LNewSpot.Count], ERROR_ITEMHEAD_MOVECARD_NEWSPOT);
  // Move
  MoveLinesBy(FCardCursor.Start, FCardCursor.Count, {var} LNewSpot.Start, LNewSpot.Count);
  FCardCursor := LookupCard({ALineSeed:} LNewSpot.Start);
end;

procedure TFitsItemHead.EraseCard;
begin
  CheckCard('cursor.inner', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_ERASECARD);
  if FCardCursor.Count > 1 then
    DeleteLinesBy(FCardCursor.Start + 1, FCardCursor.Count - 1);
  EraseLinesBy(FCardCursor.Start, {ACount:} 1);
  FCardCursor := LookupCard(FCardCursor.Start);
end;

procedure TFitsItemHead.DeleteCard;
begin
  CheckCard('cursor.inner', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_DELETECARD);
  DeleteLinesBy(FCardCursor.Start, FCardCursor.Count);
  FCardCursor := LookupCard(FCardCursor.Start);
end;

procedure TFitsItemHead.InsertCard(const ACard: string);
begin
  CheckCard('cursor', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_INSERTCARD_CURSOR);
  CheckCard('content', [ACard], ERROR_ITEMHEAD_INSERTCARD_CONTENT);
  InsertLinesBy(FCardCursor.Start, ACard);
  FCardCursor := LookupCard(FCardCursor.Start);
end;

procedure TFitsItemHead.AddCardBy(const ACard: string);
var
  LLineSeed: Integer;
begin
  LLineSeed := GetLineCount - 1;
  if LLineSeed > 0 then
  begin
    InsertLinesBy(LLineSeed, ACard);
    FCardCursor := LookupCard(LLineSeed);
  end;
end;

procedure TFitsItemHead.AddCardBy(const AKeyword, AValue: string);
var
  LCard: TFitsGroupCard;
begin
  LCard := TFitsGroupCard.Create;
  try
    LCard.Encode(AKeyword, AValue);
    AddCardBy(LCard.Card);
  finally
    LCard.Free;
  end;
end;

procedure TFitsItemHead.AddCard(const ACard: string);
begin
  CheckCard('content', [ACard], ERROR_ITEMHEAD_ADDCARD);
  AddCardBy(ACard);
end;

procedure TFitsItemHead.AddComment(const AValue: string);
begin
  AddCardBy(cCOMMENT, AValue);
end;

procedure TFitsItemHead.AddHistory(const AValue: string);
begin
  AddCardBy(cHISTORY, AValue);
end;

function TFitsItemHead.GetCard: string;
begin
  CheckCard('cursor', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_GETCARD);
  Result := '';
  ReadLinesBy(FCardCursor.Start, FCardCursor.Count, {var} Result);
end;

procedure TFitsItemHead.SetCard(const ACard: string);
var
  LCardCount: Integer;
begin
  CheckCard('cursor.inner', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_SETCARD_CURSOR);
  CheckCard('content', [ACard], ERROR_ITEMHEAD_SETCARD_CONTENT);
  LCardCount := Length(ACard) div cSizeLine;
  if LCardCount > FCardCursor.Count then
    InsertLinesBy(FCardCursor.Start, BlankString((LCardCount - FCardCursor.Count) * cSizeLine));
  if LCardCount < FCardCursor.Count then
    DeleteLinesBy(FCardCursor.Start, FCardCursor.Count - LCardCount);
  WriteLinesBy(FCardCursor.Start, ACard);
  FCardCursor := LookupCard(FCardCursor.Start);
end;

function TFitsItemHead.GetCardKeyword: string;
begin
  CheckCard('cursor', [FCardCursor.Start, FCardCursor.Count], ERROR_ITEMHEAD_GETCARDKEYWORD);
  Result := GetLineKeywordBy(FCardCursor.Start);
end;

function TFitsItemHead.ExtractCardKeywords: TKeywordDynArray;
var
  LCount, LLineSeed, LLineCount: Integer;
  LSpot: TCardSpot;
begin
  LCount := 0;
  LLineSeed := 0;
  LLineCount := GetLineCount;
  Result := nil;
  SetLength(Result, LLineCount);
  while LLineSeed < LLineCount do
  begin
    LSpot := LookupCard(LLineSeed);
    LLineSeed := LSpot.Start + LSpot.Count;
    Result[LCount] := GetLineKeywordBy(LSpot.Start);
    Inc(LCount);
  end;
  SetLength(Result, LCount);
end;

{ EFitsItemDataException }

function EFitsItemDataException.GetTopic: string;
begin
  Result := 'ITEMDATA';
end;

{ TFitsItemData }

procedure TFitsItemData.Init;
begin
  inherited;
  FInternalSize := cInternalSizeNull;
end;

function TFitsItemData.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsItemDataException;
end;

procedure TFitsItemData.Bind(AItem: TFitsItem);
begin
  if not Assigned(AItem) then
    Error(SItemNotAssigned, ERROR_ITEMDATA_BIND_NO_ITEM);
  if AItem.Container.FItemsCursor < 0 then
    Error(SContainerNotControlBind, ERROR_ITEMDATA_BIND_NO_INSPECT);
  if not Assigned(AItem.Head) then
    Error(SHeadNotAssigned, ERROR_ITEMDATA_BIND_NO_HEAD);
  FItem := AItem;
  FItem.FData := Self;
end;

procedure TFitsItemData.UnBind;
begin
  if Assigned(FItem) then
    FItem.FData := nil;
end;

procedure TFitsItemData.Make;
var
  LEstimateSize, LSize: Int64;
  LIsCorrectSize: Boolean;
begin
  // Get the available size for the data section
  LEstimateSize := FItem.GetEstimateSize - FItem.Head.Size;
  // Get the required size of the data section
  LSize := EnsureMultiply(GetInternalSize, cSizeBlock, {ARetainZeroValue:} True);
  // Check content size
  if FItem.Index = (FItem.Container.Count - 1) then
    LIsCorrectSize := LSize <= LEstimateSize // last item
  else
    LIsCorrectSize := LSize = LEstimateSize; // not last item
  if not LIsCorrectSize then
    Error(SItemNotMatchRecognizedSize, [FItem.Index, LEstimateSize, LSize],
      ERROR_ITEMDATA_MAKE_RECOGNIZED_SIZE);
  FSize := LSize;
end;

procedure TFitsItemData.MakeNew;
var
  LOffset, LEstimateSize, LSize: Int64;
  LContent: TFitsContent;
begin
  LOffset := GetOffset;
  LContent := FItem.Container.Content;
  // Get the available size for the new data section
  LEstimateSize := FItem.GetEstimateSize - FItem.Head.Size;
  // Get the required size of the new data section
  LSize := EnsureMultiply(GetInternalSize, cSizeBlock, {ARetainZeroValue:} True);
  // Prepare the content of the new data section
  if LSize > LEstimateSize then
    LContent.Resize(LOffset + LEstimateSize, LSize - LEstimateSize);
  if LSize > 0 then
    LContent.Fill(LOffset, LSize, {AChar:} Filler);
  FSize := LSize;
end;

procedure TFitsItemData.Customize;
begin
  // Do nothing
end;

procedure TFitsItemData.CustomizeNew(ASpec: TFitsItemSpec);
begin
  // Specification not used
  if Assigned(ASpec) then
    ;
end;

function TFitsItemData.GetOffset: Int64;
begin
  Result := FItem.Head.Offset + FItem.Head.Size;
end;

function TFitsItemData.ExtractInternalSize: Int64;
var
  LNumber, LAxesCount: Integer;
begin
  // [FITS_STANDARD_4.0, SECT_4.4.1.1] Primary header ... The total number of
  // bits in the primary data array, exclusive of fill that is needed after the
  // data to complete the last 2880-byte data block, is given by the following
  // expression: Nbits = |BITPIX| * (NAXIS1 * NAXIS2 * ...)
  // +
  // [FITS_STANDARD_4.0, SECT_4.4.1.2] Conforming extensions ... The total number
  // of bits in the extension data array (exclusive of fill that is needed after
  // the data to complete the last 2880-byte data block) is given by the following
  // expression: Nbits = |BITPIX| * GCOUNT * (PCOUNT + NAXIS1 * NAXIS2 * ...)
  // +
  // [FITS_STANDARD_4.0, SECT_6.1.1] Random-groups structure ... The total
  // number of bits in the random-groups records is given by the following
  // expression: Nbits = |BITPIX| * GCOUNT * (PCOUNT + NAXIS2 * NAXIS3 * ...)
  LAxesCount := GetAxesCount;
  if LAxesCount > 0 then
  begin
    // [FITS_STANDARD_4.0, SECT_6.1.1] Random-groups structure ... NAXIS1 keyword.
    // The value field shall contain the integer 0, a signature of random-groups
    // format indicating that there is no primary data array
    Result := AxesLength[1];
    if Result = 0 then
      Result := 1;
    for LNumber := 2 to LAxesCount do
      Result := Result * AxesLength[LNumber];
  end else
  // if LAxesCount = 0 then
    Result := 0;
  Result := Int64(PixelSize) * Int64(GCount) * (Int64(PCount) + Result);
end;

function TFitsItemData.GetInternalSize: Int64;
begin
  if FInternalSize = cInternalSizeNull then
    FInternalSize := ExtractInternalSize;
  Result := FInternalSize;
end;

procedure TFitsItemData.SetSize(const ASize: Int64);
begin
  FSize := TSnippet.Make(Self).Ensure(ASize);
end;

function TFitsItemData.GetBitPix: TBitPix;
begin
  Result := FItem.GetBITPIX;
end;

function TFitsItemData.GetAxesCount: Integer;
begin
  Result := FItem.GetNAXIS;
end;

function TFitsItemData.GetAxesLength(ANumber: Integer): Integer;
begin
  Result := FItem.GetNAXES(ANumber);
end;

function TFitsItemData.GetPCount: Integer;
begin
  Result := FItem.GetPCOUNT;
end;

function TFitsItemData.GetGCount: Integer;
begin
  Result := FItem.GetGCOUNT;
end;

function TFitsItemData.GetPixelSize: Byte;
begin
  Result := BitPixSize(FItem.GetBITPIX);
end;

procedure TFitsItemData.Invalidate;
begin
  FInternalSize := cInternalSizeNull;
end;

function TFitsItemData.Filler: Char;
begin
  Result := cChrNull;
end;

constructor TFitsItemData.Create(AItem: TFitsItem);
begin
  inherited Create;
  Bind(AItem);
  Make;
  Customize;
end;

constructor TFitsItemData.CreateNew(AItem: TFitsItem; ASpec: TFitsItemSpec);
begin
  inherited Create;
  Bind(AItem);
  MakeNew;
  CustomizeNew(ASpec);
end;

destructor TFitsItemData.Destroy;
begin
  UnBind;
  inherited;
end;

procedure TFitsItemData.ReadChunk(const AInternalOffset, ASize: Int64; var ABuffer);
begin
  TSnippet.Make(Self).Read(AInternalOffset, ASize, {var} ABuffer);
end;

procedure TFitsItemData.WriteChunk(const AInternalOffset, ASize: Int64; const ABuffer);
begin
  TSnippet.Make(Self).Write(AInternalOffset, ASize, ABuffer);
end;

procedure TFitsItemData.ExchangeChunk(var AInternalOffset1: Int64; const ASize1: Int64; var AInternalOffset2: Int64; const ASize2: Int64);
begin
  TSnippet.Make(Self).Exchange({var} AInternalOffset1, ASize1, {var} AInternalOffset2, ASize2);
end;

procedure TFitsItemData.MoveChunk(const AInternalOffset, ASize: Int64; var ANewInternalOffset: Int64);
begin
  TSnippet.Make(Self).Move(AInternalOffset, ASize, {var} ANewInternalOffset);
end;

procedure TFitsItemData.EraseChunk(const AInternalOffset, ASize: Int64);
begin
  TSnippet.Make(Self).Erase(AInternalOffset, ASize);
end;

procedure TFitsItemData.DeleteChunk(const AInternalOffset, ASize: Int64);
begin
  FSize := TSnippet.Make(Self).Delete(AInternalOffset, ASize);
end;

procedure TFitsItemData.InsertChunk(const AInternalOffset, ASize: Int64);
begin
  FSize := TSnippet.Make(Self).Insert(AInternalOffset, ASize);
end;

function TFitsItemData.AddChunk(const ASize: Int64): Int64;
begin
  FSize := TSnippet.Make(Self).Add(ASize, {out} Result);
end;

{ EFitsItemException }

function EFitsItemException.GetTopic: string;
begin
  Result := 'ITEM';
end;

{ TFitsItem }

procedure TFitsItem.Init;
begin
  inherited;
  FCacheProp := TFitsPropList.Create;
end;

function TFitsItem.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsItemException;
end;

procedure TFitsItem.Bind(AContainer: TFitsContainer);
begin
  if not Assigned(AContainer) then
    Error(SContainerNotAssigned, ERROR_ITEM_BIND_NO_CONTAINER);
  if AContainer.FItemsCursor < 0 then
    Error(SContainerNotControlBind, ERROR_ITEM_BIND_NO_INSPECT);
  FContainer := AContainer;
  FContainer.FItems[FContainer.FItemsCursor] := Self;
end;

function TFitsItem.CanPrimary: Boolean;
var
  LXtension: string;
begin
  LXtension := GetXTENSION;
  Result := SameText(LXtension, 'IMAGE') or SameText(LXtension, 'RANDOM GROUP');
end;

procedure TFitsItem.SetOrder(AOrder: TFitsItemOrder);
var
  LIndex: Integer;
begin
  Assert(Assigned(FHead), SAssertionFailure);
  case AOrder of
    ioSingle:
      begin
        FHead.Lines[0] := NewLineSIMPLE;
        // Delete "EXTEND" header line
        LIndex := FHead.LineIndexOfKeyword(cEXTEND, {AScope:} 1);
        if LIndex > 0 then
          FHead.DeleteLines(LIndex, {ACount:} 1);
      end;
    ioPrimary:
      begin
        FHead.Lines[0] := NewLineSIMPLE;
        // Append "EXTEND" header line
        LIndex := FHead.LineIndexOfKeyword(cEXTEND, {AScope:} 1);
        if LIndex > 0 then
          FHead.Lines[LIndex] := NewLineEXTEND
        else // if LIndex < 0 then
        begin
          LIndex := FHead.LineIndexOfLastAxis;
          LIndex := IfThen(LIndex > 0, LIndex + 1, FHead.LineCount - 1);
          FHead.InsertLines(LIndex, NewLineEXTEND);
        end;
      end;
    ioExtension:
      begin
        if not SameText(FHead.LineKeywords[0], cXTENSION) then
          FHead.Lines[0] := NewLineXTENSION(ExtensionType);
        // Delete "EXTEND" header line
        LIndex := FHead.LineIndexOfKeyword(cEXTEND, {AScope:} 1);
        if LIndex > 0 then
          FHead.DeleteLines(LIndex, {ACount:} 1);
        // Append "PCOUNT" header line
        LIndex := FHead.LineIndexOfKeyword(cPCOUNT, {AScope:} 1);
        if LIndex < 0 then
        begin
          LIndex := FHead.LineIndexOfLastAxis;
          LIndex := IfThen(LIndex > 0, LIndex + 1, FHead.LineCount - 1);
          FHead.InsertLines(LIndex, NewLinePCOUNT);
        end;
        // Append "GCOUNT" header line
        LIndex := FHead.LineIndexOfKeyword(cGCOUNT, {AScope:} 1);
        if LIndex < 0 then
        begin
          LIndex := FHead.LineIndexOfKeyword(cPCOUNT, {AScope:} 1);
          LIndex := IfThen(LIndex > 0, LIndex + 1, FHead.LineCount - 1);
          FHead.InsertLines(LIndex, NewLineGCOUNT);
        end;
      end;
  end;
end;

function TFitsItem.GetIndex: Integer;
begin
  Result := FContainer.IndexOf(Self);
end;

function TFitsItem.GetOffset: Int64;
var
  LIndex: Integer;
  LPreItem: TFitsItem;
begin
  LIndex := GetIndex;
  if LIndex > 0 then
  begin
    LPreItem := FContainer[LIndex - 1];
    Result := LPreItem.Offset + LPreItem.Size;
  end else
    Result := 0;
end;

function TFitsItem.GetSize: Int64;
begin
  Result := 0;
  if Assigned(FHead) and Assigned(FData) then
    Result := FHead.Size + FData.Size;
end;

function TFitsItem.GetEstimateSize: Int64;
var
  LIndex, LCurIndex: Integer;
begin
  LCurIndex := GetIndex;
  Result := FContainer.Content.Size;
  for LIndex := 0 to FContainer.Count - 1 do
    if LIndex <> LCurIndex then
      Result := Result - FContainer[LIndex].Size;
end;

procedure TFitsItem.AppendCacheProp(AProp: IFitsPropContext);
begin
  FCacheProp.Append(AProp.NewProp);
end;

function TFitsItem.ExtractCacheProp(AProp: IFitsPropContext): Boolean;
var
  LIndex: Integer;
begin
  LIndex := FCacheProp.IndexOf(AProp.Keyword);
  if LIndex >= 0 then
    AProp.AssignValue(FCacheProp[LIndex]);
  Result := LIndex >= 0;
end;

function TFitsItem.ExtractHeadProp(AProp: IFitsPropContext): Boolean;
var
  LIndex: Integer;
begin
  Assert(Assigned(FHead), SAssertionFailure);
  LIndex := FHead.LineIndexOfKeyword(AProp.Keyword);
  if LIndex >= 0 then
    AProp.AssignValue(FHead.Lines[LIndex]);
  Result := LIndex >= 0;
end;

procedure TFitsItem.DoGetXTENSION(AProp: IXTENSION);
begin
  if not ExtractHeadProp(AProp) then
  begin
    if (GetNAXIS > 1) and (GetNAXES(1) = 0) then
      // [FITS_STANDARD_4.0, SECT_6.1.1] Random-groups structure ... NAXIS1 keyword.
      // The value field shall contain the integer 0, a signature of random-groups
      // format indicating that there is no primary data array
      AProp.Value := 'RANDOM GROUP'
    else
      AProp.Value := 'IMAGE';
  end;
end;

function TFitsItem.GetXTENSION: string;
var
  LProp: IXTENSION;
begin
  LProp := TFitsXTENSION.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetXTENSION(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsItem.DoGetEXTNAME(AProp: IEXTNAME);
begin
  ExtractHeadProp(AProp);
end;

function TFitsItem.GetEXTNAME: string;
var
  LProp: IEXTNAME;
begin
  LProp := TFitsEXTNAME.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetEXTNAME(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsItem.DoGetEXTVER(AProp: IEXTVER);
begin
  if not ExtractHeadProp(AProp) then
    // [FITS_STANDARD_4.0, SECT_4.4.2.6] Extension keywords ... If the EXTVER
    // keyword is absent, the file should be treated as if the value were 1
    AProp.Value := 1;
end;

function TFitsItem.GetEXTVER: Integer;
var
  LProp: IEXTVER;
begin
  LProp := TFitsEXTVER.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetEXTVER(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsItem.DoGetEXTLEVEL(AProp: IEXTLEVEL);
begin
  if not ExtractHeadProp(AProp) then
    // [FITS_STANDARD_4.0, SECT_4.4.2.6] Extension keywords ... If the EXTLEVEL
    // keyword isabsent, the file should be treated as if the value were 1
    AProp.Value := 1;
end;

function TFitsItem.GetEXTLEVEL: Integer;
var
  LProp: IEXTLEVEL;
begin
  LProp := TFitsEXTLEVEL.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetEXTLEVEL(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsItem.DoGetBITPIX(AProp: IBITPIX);
begin
  if not ExtractHeadProp(AProp) then
    Error(SHeadLineNotFound, [AProp.Keyword], ERROR_ITEM_GETBITPIX_NOT_FOUND);
  // The function to convert TBitPix from a string ensures that the
  // TBitPix value is valid and belongs to the range [bi64f..bi64c]
end;

function TFitsItem.GetBITPIX: TBitPix;
var
  LProp: IBITPIX;
begin
  LProp := TFitsBITPIX.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetBITPIX(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsItem.DoGetNAXIS(AProp: INAXIS);
begin
  if not ExtractHeadProp(AProp) then
    Error(SHeadLineNotFound, [AProp.Keyword], ERROR_ITEM_GETNAXIS_NOT_FOUND);
  if not InRange(AProp.Value, 0, cMaxAxis) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_ITEM_GETNAXIS_VALUE);
end;

function TFitsItem.GetNAXIS: Integer;
var
  LProp: INAXIS;
begin
  LProp := TFitsNAXIS.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetNAXIS(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsItem.DoGetNAXES(AProp: INAXES);
begin
  if not InRange(AProp.KeywordNumber, 1, GetNAXIS) then
    Error(SPropAxisOutBounds, [AProp.Keyword, GetNAXIS],
      ERROR_ITEM_GETNAXES_NUMBER);
  if not ExtractHeadProp(AProp) then
    Error(SHeadLineNotFound, [AProp.Keyword], ERROR_ITEM_GETNAXES_NOT_FOUND);
  // [FITS_STANDARD_4.0, SECT_4.4.1.1] Primary header ... The value field of
  // this indexed keyword shall contain a non-negative integer representing
  // the number of elements along Axis n of a data array. A value of zero
  // for any of the NAXISn signifies that no data follow the header in the
  // HDU (however, the random-groups structure described in Sect. 6 has
  // NAXIS1 = 0, but will have data following the header if the other NAXISn
  // keywords are non-zero)
  if AProp.Value < 0 then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_ITEM_GETNAXES_VALUE);
end;

function TFitsItem.GetNAXES(ANumber: Integer): Integer;
var
  LProp: INAXES;
begin
  LProp := TFitsNAXES.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetNAXES(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsItem.DoGetPCOUNT(AProp: IPCOUNT);
begin
  if not ExtractHeadProp(AProp) then
    AProp.Value := DefaultPCOUNT
  else if not CorrectPCOUNT(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_ITEM_GETPCOUNT_VALUE);
end;

function TFitsItem.GetPCOUNT: Integer;
var
  LProp: IPCOUNT;
begin
  LProp := TFitsPCOUNT.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetPCOUNT(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsItem.DoGetGCOUNT(AProp: IGCOUNT);
begin
  if not ExtractHeadProp(AProp) then
    AProp.Value := DefaultGCOUNT
  else if not CorrectGCOUNT(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_ITEM_GETGCOUNT_VALUE);
end;

function TFitsItem.GetGCOUNT: Integer;
var
  LProp: IGCOUNT;
begin
  LProp := TFitsGCOUNT.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetGCOUNT(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsItem.ChangeContent(const AOffset, ASize: Int64);
var
  LOffset: Int64;
begin
  if ASize <> 0 then
  begin
    LOffset := GetOffset;
    if Assigned(FHead) and (AOffset < (LOffset + FHead.Size)) then
    begin
      if (AOffset + ASize) > LOffset then
        FCacheProp.Clear;
      FHead.Invalidate;
    end;
    if Assigned(FData) and (AOffset < (LOffset + FHead.Size + FData.Size)) then
    begin
      FData.Invalidate;
    end;
  end;
end;

function TFitsItem.GetHeadClass: TFitsItemHeadClass;
begin
  Result := TFitsItemHead;
end;

function TFitsItem.GetDataClass: TFitsItemDataClass;
begin
  Result := TFitsItemData;
end;

constructor TFitsItem.Create(AContainer: TFitsContainer);
begin
  inherited Create;
  Bind(AContainer);
  FHead := GetHeadClass.Create(Self);
  FData := GetDataClass.Create(Self);
end;

constructor TFitsItem.CreateNew(AContainer: TFitsContainer; ASpec: TFitsItemSpec);
begin
  inherited Create;
  Bind(AContainer);
  FHead := GetHeadClass.CreateNew(Self, ASpec);
  FData := GetDataClass.CreateNew(Self, ASpec);
end;

destructor TFitsItem.Destroy;
begin
  FHead.Free;
  FData.Free;
  FCacheProp.Free;
  inherited;
end;

class function TFitsItem.ExtensionType: string;
begin
  Result := 'IMAGE';
end;

class function TFitsItem.ExtensionTypeIs(AItem: TFitsItem): Boolean;
var
  LIndex: Integer;
  LItemExtensionType: string;
begin
  Result := Self = TFitsItem;
  if not Result then
  begin
    LIndex := AItem.Head.LineIndexOfKeyword(cXTENSION);
    if LIndex >= 0 then
      LItemExtensionType := UnquotedString(AItem.Head.LineRecords[LIndex].Value)
    else
      LItemExtensionType := IfThen(AItem.Index = 0, AItem.ExtensionType, '');
    Result := LItemExtensionType = ExtensionType;
  end;
end;

{ EFitsMemoryException }

function EFitsMemoryException.GetTopic: string;
begin
  Result := 'MEMORY';
end;

{ TFitsMemory }

{$IFDEF DELAFITS_MEMORY_SHARED}
var
  vBytes1: TBytes1 = nil;
  vBytes2: TBytes2 = nil;
{$ENDIF}

function TFitsMemory.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsMemoryException;
end;

constructor TFitsMemory.Create(AContainer: TFitsContainer);
begin
  inherited Create;
  if not Assigned(AContainer) then
    Error(SContainerNotAssigned, ERROR_MEMORY_BIND_NO_CONTAINER);
  FContainer := AContainer;
end;

procedure TFitsMemory.Allocate(out ABytes: TBytes1; ASize: Integer);
begin
  Assert(ASize > 0, SAssertionFailure);
{$IF DEFINED(DELAFITS_MEMORY_SHARED)}
  if Length(vBytes1) < ASize then
    SetLength(vBytes1, ASize);
  ABytes := vBytes1;
{$ELSEIF DEFINED(DELAFITS_MEMORY_OBJECT)}
  if Length(FBytes1) < ASize then
    SetLength(FBytes1, ASize);
  ABytes := FBytes1;
{$ELSEIF DEFINED(DELAFITS_MEMORY_LOCAL)}
  SetLength(ABytes, ASize);
{$IFEND}
end;

procedure TFitsMemory.Allocate(out ABytes: TBytes2; ASize1, ASize2: Integer);
begin
  Assert((ASize1 > 0) and (ASize2 > 0), SAssertionFailure);
{$IF DEFINED(DELAFITS_MEMORY_SHARED)}
  if (Length(vBytes2) < ASize1) or (Length(vBytes2[0]) < ASize2) then
    SetLength(vBytes2, ASize1, ASize2);
  ABytes := vBytes2;
{$ELSEIF DEFINED(DELAFITS_MEMORY_OBJECT)}
  if (Length(FBytes2) < ASize1) or (Length(FBytes2[0]) < ASize2) then
    SetLength(FBytes2, ASize1, ASize2);
  ABytes := FBytes2;
{$ELSEIF DEFINED(DELAFITS_MEMORY_LOCAL)}
  SetLength(ABytes, ASize1, ASize2);
{$IFEND}
end;

procedure TFitsMemory.Reset;
begin
{$IF DEFINED(DELAFITS_MEMORY_SHARED)}
  vBytes1 := nil;
  vBytes2 := nil;
{$ELSEIF DEFINED(DELAFITS_MEMORY_OBJECT)}
  FBytes1 := nil;
  FBytes2 := nil;
{$ELSEIF DEFINED(DELAFITS_MEMORY_LOCAL)}
  // Do nothing
{$IFEND}
end;

{ EFitsContentException }

function EFitsContentException.GetTopic: string;
begin
  Result := 'CONTENT';
end;

{ TFitsContent }

function TFitsContent.GetSize: Int64;
begin
  Result := FStream.Size;
end;

function TFitsContent.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsContentException;
end;

constructor TFitsContent.Create(AContainer: TFitsContainer; AStream: TStream);
begin
  inherited Create;
  if not Assigned(AContainer) then
    Error(SContainerNotAssigned, ERROR_CONTENT_BIND_NO_CONTAINER);
  if not Assigned(AStream) then
    Error(SStreamNotAssigned, ERROR_CONTENT_BIND_NO_STREAM);
  FContainer := AContainer;
  FStream := AStream;
end;

procedure TFitsContent.Read(const AOffset, ASize: Int64; var ABuffer);
begin
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, AOffset, ASize) then
    Error(SContentChunkOutBounds, [AOffset, ASize, FStream.Size],
      ERROR_CONTENT_READ_BOUNDS);
  FStream.Position := AOffset;
  if FStream.Read(ABuffer, ASize) <> ASize then
    Error(SContentReadError, ERROR_CONTENT_READ);
end;

procedure TFitsContent.ReadBuffer(const AOffset, ACount: Int64; var ABuffer: TBuffer);
var
  LCount: Integer;
begin
  LCount := Length(ABuffer);
  if LCount < ACount then
    SetLength(ABuffer, ACount);
  if LCount > 0 then
    Read(AOffset, ACount, ABuffer[0]);
end;

procedure TFitsContent.ReadString(const AOffset, ACount: Int64; var ABuffer: string);
var
  LBuffer: AnsiString;
begin
  LBuffer := '';
  if ACount > 0 then
  begin
    SetLength(LBuffer, ACount);
    Read(AOffset, ACount, LBuffer[1]);
  end;
  ABuffer := string(LBuffer);
end;

procedure TFitsContent.Change(const AOffset, ASize: Int64);
var
  LIndex: Integer;
begin
  for LIndex := 0 to FContainer.FItems.Count - 1 do
    FContainer.FItems[LIndex].ChangeContent(AOffset, ASize);
end;

procedure TFitsContent.Write(const AOffset, ASize: Int64; const ABuffer);
begin
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, AOffset, ASize) then
    Error(SContentChunkOutBounds, [AOffset, ASize, FStream.Size],
      ERROR_CONTENT_WRITE_BOUNDS);
  FStream.Position := AOffset;
  if FStream.Write(ABuffer, ASize) <> ASize then
    Error(SContentWriteError, ERROR_CONTENT_WRITE);
  Change(AOffset, ASize);
end;

procedure TFitsContent.WriteBuffer(const AOffset, ACount: Int64; const ABuffer: TBuffer);
var
  LCount: Integer;
begin
  LCount := Length(ABuffer);
  if LCount < ACount then
    Error(SContentWriteLowBufferSize, [LCount, ACount],
      ERROR_CONTENT_WRITEBUFFER_SIZE);
  if LCount > 0 then
    Write(AOffset, ACount, ABuffer[0]);
end;

procedure TFitsContent.WriteString(const AOffset, ACount: Int64; const ABuffer: string);
var
  LCount: Integer;
  LBuffer: AnsiString;
begin
  LCount := Length(ABuffer);
  if LCount < ACount then
    Error(SContentWriteLowStringSize, [LCount, ACount],
      ERROR_CONTENT_WRITESTRING_SIZE);
  if LCount > 0 then
  begin
    LBuffer := AnsiString(ABuffer);
    Write(AOffset, ACount, LBuffer[1]);
  end;
end;

procedure TFitsContent.Fill(const AOffset, ASize: Int64; AChar: Char);
var
  LSize: Int64;
  LSizeBuffer, LSizeChunk: Integer;
  LBuffer: TBuffer;
begin
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, AOffset, ASize) then
    Error(SContentChunkOutBounds, [AOffset, ASize, FStream.Size],
      ERROR_CONTENT_FILL_BOUNDS);
  LSize := ASize;
  if LSize > cMaxSizeBuffer then
    LSizeBuffer := cMaxSizeBuffer
  else
    LSizeBuffer := ASize;
  FContainer.Memory.Allocate(LBuffer, LSizeBuffer);
  System.FillChar(LBuffer[0], LSizeBuffer, Char(AChar));
  while LSize > 0 do
  begin
    if LSize > LSizeBuffer then
      LSizeChunk := LSizeBuffer
    else
      LSizeChunk := LSize;
    WriteBuffer(AOffset + LSize - LSizeChunk, LSizeChunk, LBuffer);
    Dec(LSize, LSizeChunk);
  end;
end;

procedure TFitsContent.Shift(const AOffset, ASize, AShift: Int64);
var
  LOffset, LSize: Int64;
  LSizeBuffer, LSizeChunk: Integer;
  LBuffer: TBuffer;
begin
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, AOffset, ASize) then
    Error(SContentChunkOutBounds, [AOffset, ASize, FStream.Size],
      ERROR_CONTENT_SHIFT_BOUNDS);
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, AOffset + AShift, ASize) then
    Error(SContentChunkOutBounds, [AOffset + AShift, ASize, FStream.Size],
      ERROR_CONTENT_SHIFT_BOUNDS);
  if AShift = 0 then
    Exit;
  LOffset := AOffset;
  LSize := ASize;
  if LSize > cMaxSizeBuffer then
    LSizeBuffer := cMaxSizeBuffer
  else
    LSizeBuffer := LSize;
  FContainer.Memory.Allocate(LBuffer, LSizeBuffer);
  // Shift content down
  if AShift > 0 then
    while LSize <> 0 do
    begin
      if LSize > LSizeBuffer then
        LSizeChunk := LSizeBuffer
      else
        LSizeChunk := LSize;
      ReadBuffer(LOffset + LSize - LSizeChunk, LSizeChunk, LBuffer);
      WriteBuffer(LOffset + AShift + LSize - LSizeChunk, LSizeChunk, LBuffer);
      Dec(LSize, LSizeChunk);
    end;
  // Shift content up
  if AShift < 0 then
    while LSize <> 0 do
    begin
      if LSize > LSizeBuffer then
        LSizeChunk := LSizeBuffer
      else
        LSizeChunk := LSize;
      ReadBuffer(LOffset, LSizeChunk, LBuffer);
      WriteBuffer(LOffset + AShift, LSizeChunk, LBuffer);
      Inc(LOffset, LSizeChunk);
      Dec(LSize, LSizeChunk);
    end;
end;

procedure TFitsContent.Rotate(const AOffset, ASize: Int64);
var
  LHalfSize, LOffset1, LOffset2: Int64;
  LHalfSizeBuffer, LSizeChunk: Integer;
  LIndex, LIndexMax: Integer;
  LTemp: T08u;
  LBuffer: TBuffer;
begin
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, AOffset, ASize) then
    Error(SContentChunkOutBounds, [AOffset, ASize, FStream.Size],
      ERROR_CONTENT_ROTATE_BOUNDS);
  LHalfSize := ASize div 2;
  LHalfSizeBuffer := Min(LHalfSize, cMaxSizeBuffer) div 2;
  if LHalfSizeBuffer = 0 then
    LHalfSizeBuffer := 1;
  FContainer.Memory.Allocate(LBuffer, LHalfSizeBuffer * 2);
  LOffset1 := AOffset;
  LOffset2 := AOffset + LHalfSize + (ASize mod 2);
  while LHalfSize <> 0 do
  begin
    LSizeChunk := Min(LHalfSize, LHalfSizeBuffer);
    // Read
    Read(LOffset1, LSizeChunk, LBuffer[0]);
    Read(LOffset2 + LHalfSize - LSizeChunk, LSizeChunk, LBuffer[LSizeChunk]);
    // Rotate
    LIndex := 0;
    LIndexMax := LSizeChunk * 2 - 1;
    while LIndex < LSizeChunk do
    begin
      LTemp := LBuffer[LIndex];
      LBuffer[LIndex] := LBuffer[LIndexMax - LIndex];
      LBuffer[LIndexMax - LIndex] := LTemp;
      Inc(LIndex);
    end;
    // Write
    Write(LOffset1, LSizeChunk, LBuffer[0]);
    Write(LOffset2 + LHalfSize - LSizeChunk, LSizeChunk, LBuffer[LSizeChunk]);
    // Iteration
    Inc(LOffset1, LSizeChunk);
    Dec(LHalfSize, LSizeChunk);
  end;
end;

procedure TFitsContent.Exchange(var AOffset1: Int64; const ASize1: Int64; var AOffset2: Int64; const ASize2: Int64);
var
  LSize, LMinSize, LOffset, LNewOffset: Int64;
  LSize1, LSize2, LOffset1, LOffset2: Int64;
  LHalfSizeBuffer, LSizeChunk: Integer;
  LBuffer: TBuffer;
begin
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, AOffset1, ASize1) then
    Error(SContentChunkOutBounds, [AOffset1, ASize1, FStream.Size],
      ERROR_CONTENT_EXCHANGE_BOUNDS);
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, AOffset2, ASize2) then
    Error(SContentChunkOutBounds, [AOffset2, ASize2, FStream.Size],
      ERROR_CONTENT_EXCHANGE_BOUNDS);
  if AOffset1 = AOffset2 then
    Exit;
  if AOffset1 < AOffset2 then
  begin
    LOffset1 := AOffset1;
    LSize1 := ASize1;
    LOffset2 := AOffset2;
    LSize2 := ASize2;
  end else
  // if AOffset1 > AOffset2 then
  begin
    LOffset1 := AOffset2;
    LSize1 := ASize2;
    LOffset2 := AOffset1;
    LSize2 := ASize1;
  end;
  LMinSize := Min(LSize1, LSize2);
  if LOffset2 < (LOffset1 + LSize1) then
    Error(SContentChunksOverlap, [AOffset1, ASize1, AOffset2, ASize2],
      ERROR_CONTENT_EXCHANGE_OVERLAP);
  // Exchange
  LOffset := AOffset1;
  AOffset1 := AOffset2;
  AOffset2 := LOffset;
  LSize := LMinSize;
  LHalfSizeBuffer := Min(LSize, cMaxSizeBuffer) div 2;
  if LHalfSizeBuffer = 0 then
    LHalfSizeBuffer := 1;
  FContainer.Memory.Allocate(LBuffer, LHalfSizeBuffer * 2);
  while LSize <> 0 do
  begin
    LSizeChunk := Min(LSize, LHalfSizeBuffer);
    // Read
    Read(LOffset1, LSizeChunk, LBuffer[0]);
    Read(LOffset2, LSizeChunk, LBuffer[LSizeChunk]);
    // Write
    Write(LOffset1, LSizeChunk, LBuffer[LSizeChunk]);
    Write(LOffset2, LSizeChunk, LBuffer[0]);
    // Iteration
    Inc(LOffset1, LSizeChunk);
    Inc(LOffset2, LSizeChunk);
    Dec(LSize, LSizeChunk);
  end;
  // Move
  if AOffset1 < AOffset2 then
  begin
    LOffset1 := AOffset1;
    LOffset2 := AOffset2;
  end else
  // if AOffset1 > AOffset2 then
  begin
    LOffset1 := AOffset2;
    LOffset2 := AOffset1;
  end;
  LSize := LSize1 - LSize2;
  if LSize <> 0 then
  begin
    if LSize > 0 then
    begin
      LOffset := LOffset1 + LMinSize;
      LNewOffset := LOffset2 + LMinSize - 1;
      Dec(AOffset1, LSize);
    end else
    // if LSize < 0 then
    begin
      LSize := Abs(LSize);
      LOffset := LOffset2 + LMinSize;
      LNewOffset := LOffset1 + LMinSize;
      Inc(AOffset1, LSize);
    end;
    Move(LOffset, LSize, LNewOffset);
  end;
end;

procedure TFitsContent.Move(const AOffset, ASize: Int64; var ANewOffset: Int64);
var
  LOffset1, LOffset2, LSize1, LSize2: Int64;
begin
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, AOffset, ASize) then
    Error(SContentChunkOutBounds, [AOffset, ASize, FStream.Size],
      ERROR_CONTENT_MOVE_BOUNDS);
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size, ANewOffset) then
    Error(SContentOffsetOutBounds, [ANewOffset, FStream.Size],
      ERROR_CONTENT_MOVE_OFFSET);
  if InSegmentBound(AOffset, ASize, ANewOffset) then
    Error(SContentChunksOverlap, [AOffset, ASize, ANewOffset, {ASize2:} 1],
      ERROR_CONTENT_MOVE_OVERLAP);
  // Move content down
  if ANewOffset > AOffset then
  begin
    LOffset1 := AOffset;
    LSize1 := ASize;
    LOffset2 := AOffset + ASize;
    LSize2 := (ANewOffset - AOffset + 1) - ASize;
    ANewOffset := ANewOffset - ASize + 1;
  end else
  // Move content up
  // if ANewOffset < AOffset then
  begin
    LOffset1 := ANewOffset;
    LSize1 := AOffset - ANewOffset;
    LOffset2 := AOffset;
    LSize2 := ASize;
  end;
  Rotate(LOffset1, LSize1);
  Rotate(LOffset2, LSize2);
  Rotate(LOffset1, LSize1 + LSize2);
end;

procedure TFitsContent.Resize(const AOffset, ASize: Int64);
var
  LOffset, LSize, LShift: Int64;
begin
  if not InSegmentBound({ASegmentPosition:} 0, FStream.Size + 1, AOffset) then
    Error(SContentOffsetOutBounds, [AOffset, FStream.Size],
      ERROR_CONTENT_RESIZE_OFFSET);
  if ASize = 0 then
    Error(SContentZeroSize, ERROR_CONTENT_RESIZE_ZERO_SIZE);
  // Grow size stream
  if ASize > 0 then
  begin
    LOffset := AOffset;
    LSize := FStream.Size - LOffset;
    LShift := ASize;
    FStream.Size := FStream.Size + ASize;
    if LSize > 0 then
      Shift(LOffset, LSize, LShift);
  end;
  // Reduce size stream
  if ASize < 0 then
  begin
    LOffset := AOffset + Abs(ASize);
    if LOffset > FStream.Size then
      Error(SContentChunkOutBounds, [AOffset, ASize, FStream.Size],
        ERROR_CONTENT_RESIZE_BOUNDS);
    if LOffset < FStream.Size then
    begin
      LSize := FStream.Size - LOffset;
      LShift := ASize;
      Shift(LOffset, LSize, LShift);
    end;
    FStream.Size := FStream.Size + ASize;
  end;
end;

{ TFitsItemList }

function TFitsItemList.GetItem(AIndex: Integer): TFitsItem;
begin
  Result := TFitsItem(inherited Items[AIndex]);
end;

procedure TFitsItemList.SetItem(AIndex: Integer; AItem: TFitsItem);
begin
  inherited Items[AIndex] := AItem;
end;

destructor TFitsItemList.Destroy;
var
  LIndex: Integer;
begin
  for LIndex := 0 to Count - 1 do
    GetItem(LIndex).Free;
  inherited;
end;

function TFitsItemList.IndexOf(AItem: TFitsItem): Integer;
begin
  Result := Integer(inherited IndexOf(AItem));
end;

procedure TFitsItemList.Remove(AIndex: Integer);
begin
  inherited Items[AIndex] := nil;
  inherited Delete(AIndex);
end;

procedure TFitsItemList.Delete(AIndex: Integer);
begin
  GetItem(AIndex).Free;
  inherited Delete(AIndex);
end;

procedure TFitsItemList.Delete(AItem: TFitsItem);
begin
  if Assigned(AItem) then
    Delete(IndexOf(AItem));
end;

{ EFitsContainerException }

function EFitsContainerException.GetTopic: string;
begin
  Result := 'CONTAINER';
end;

{ TFitsContainer }

function TFitsContainer.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsContainerException;
end;

procedure TFitsContainer.MakeItems;
var
  LItem: TFitsItem;
  LItemsSize: Int64;
begin
  LItemsSize := 0;
  while (FContent.Size - LItemsSize) > 0 do
  try
    FItemsCursor := FItems.Add(nil);
    try
      LItem := TFitsItem.Create(Self);
    except
      FItems.Remove(FItemsCursor);
      raise;
    end;
    LItemsSize := LItem.Offset + LItem.Size;
  finally
    FItemsCursor := -1;
  end;
end;

procedure TFitsContainer.ReorderItems;
var
  LCount, LIndex: Integer;
begin
  LCount := FItems.Count;
  case LCount of
    0: ;
    1: FItems[0].SetOrder(ioSingle);
  else
    FItems[0].SetOrder(ioPrimary);
    for LIndex := 1 to LCount - 1 do
      FItems[LIndex].SetOrder(ioExtension);
  end;
end;

procedure TFitsContainer.Check(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
var
  LArgIndex, LArgIndexNewPimary, LCount: Integer;
begin
  if ACheck = 'index' then
  begin
    LArgIndex := AArgs[0].VInteger;
    LCount := FItems.Count;
    if (LArgIndex < 0) or (LArgIndex >= LCount) then
      Error(SItemIndexOutBounds, [LArgIndex, LCount], ACodeError);
  end else
  if ACheck = 'order' then
  begin
    LArgIndex := AArgs[0].VInteger;
    LArgIndexNewPimary := AArgs[1].VInteger;
    LCount := FItems.Count;
    if (LArgIndex = 0) and (LArgIndexNewPimary < LCount) and (not FItems[LArgIndexNewPimary].CanPrimary) then
      Error(SItemCannotPrimary, [LArgIndexNewPimary], ACodeError);
  end else
    Assert(False, SAssertionFailureArgs(AArgs));
end;

function TFitsContainer.GetItemClass(AIndex: Integer): TFitsItemClass;
var
  LItem: TFitsItem;
begin
  Check('index', [AIndex], ERROR_CONTAINER_GETITEMCLASS_INDEX);
  LItem := FItems[AIndex];
  Result := TFitsItemClass(LItem.ClassType);
end;

procedure TFitsContainer.SetItemClass(AIndex: Integer; AItemClass: TFitsItemClass);
var
  LCurrentItem: TFitsItem;
begin
  Check('index', [AIndex], ERROR_CONTAINER_SETITEMCLASS_INDEX);
  LCurrentItem := FItems[AIndex];
  if not AItemClass.ExtensionTypeIs(LCurrentItem) then
    Error(SItemInvalidExtension, [AItemClass.ClassName, LCurrentItem.GetXTENSION],
      ERROR_CONTAINER_SETITEMCLASS_EXTENSION);
  try
    FItemsCursor := AIndex;
    try
      AItemClass.Create(Self);
    except
      FItems[FItemsCursor] := LCurrentItem;
      raise;
    end;
    LCurrentItem.Free;
  finally
    FItemsCursor := -1;
  end;
end;

function TFitsContainer.GetItem(AIndex: Integer): TFitsItem;
begin
  Check('index', [AIndex], ERROR_CONTAINER_GETITEM_INDEX);
  Result := FItems[AIndex];
end;

function TFitsContainer.GetPrimary: TFitsItem;
begin
  Result := nil;
  if FItems.Count > 0 then
    Result := FItems[0];
end;

function TFitsContainer.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TFitsContainer.GetMemoryClass: TFitsMemoryClass;
begin
  Result := TFitsMemory;
end;

function TFitsContainer.GetContentClass: TFitsContentClass;
begin
  Result := TFitsContent;
end;

constructor TFitsContainer.Create(AStream: TStream);
begin
  inherited Create;
  FMemory := GetMemoryClass.Create(Self);
  FContent := GetContentClass.Create(Self, AStream);
  FItems := TFitsItemList.Create;
  FItemsCursor := -1;
  MakeItems;
end;

destructor TFitsContainer.Destroy;
begin
  FItems.Free;
  FContent.Free;
  FMemory.Free;
  inherited;
end;

function TFitsContainer.Add(AItemClass: TFitsItemClass; AItemSpec: TFitsItemSpec): TFitsItem;
var
  LNewPrimaryItem, LNewItem: TFitsItem;
  LOriginSize: Int64;
begin
  LNewPrimaryItem := nil;
  LNewItem := nil;
  LOriginSize := FContent.Size;
  try
    // Try to add a primary item
    if (FItems.Count = 0) and (AItemClass.ExtensionType <> 'IMAGE') then
    try
      FItemsCursor := FItems.Add(nil);
      try
        LNewPrimaryItem := TFitsItem.CreateNew(Self, {AItemSpec:} nil);
      except
        FItems.Remove(FItemsCursor);
        raise;
      end;
    finally
      FItemsCursor := -1;
    end;
    // Add a new item
    try
      FItemsCursor := FItems.Add(nil);
      try
        LNewItem := AItemClass.CreateNew(Self, AItemSpec);
      except
        FItems.Remove(FItemsCursor);
        raise;
      end;
    finally
      FItemsCursor := -1;
    end;
    // Set items order
    ReorderItems;
    // Return
    Result := LNewItem;
  except
    // If we failed to create new items, we will restore the
    // content size and remove these items from the list
    FContent.Resize({AOffset:} LOriginSize, {ASize:} LOriginSize - FContent.Size);
    FItems.Delete(LNewPrimaryItem);
    FItems.Delete(LNewItem);
    raise;
  end;
end;

procedure TFitsContainer.Delete(AIndex: Integer);
var
  LItem: TFitsItem;
begin
  Check('index', [AIndex], ERROR_CONTAINER_DELETE_INDEX);
  Check('order', [AIndex, {AIndexNewPimary:} Integer(1)], ERROR_CONTAINER_DELETE_ORDER);
  try
    FItemsCursor := AIndex;
    LItem := FItems[FItemsCursor];
    FContent.Resize(LItem.Offset, -LItem.Size);
    FItems.Delete(FItemsCursor);
    ReorderItems;
  finally
    FItemsCursor := -1;
  end;
end;

procedure TFitsContainer.Exchange(AIndex1, AIndex2: Integer);
var
  LItem1, LItem2: TFitsItem;
  LOffset1, LOffset2: Int64;
begin
  Check('index', [AIndex1], ERROR_CONTAINER_EXCHANGE_INDEX);
  Check('index', [AIndex2], ERROR_CONTAINER_EXCHANGE_INDEX);
  if AIndex1 <> AIndex2 then
  begin
    Check('order', [AIndex1, {AIndexNewPimary:} AIndex2], ERROR_CONTAINER_EXCHANGE_ORDER);
    Check('order', [AIndex2, {AIndexNewPimary:} AIndex1], ERROR_CONTAINER_EXCHANGE_ORDER);
    LItem1 := FItems[AIndex1];
    LItem2 := FItems[AIndex2];
    LOffset1 := LItem1.Offset;
    LOffset2 := LItem2.Offset;
    FContent.Exchange({var} LOffset1, LItem1.Size, {var} LOffset2, LItem2.Size);
    FItems.Exchange(AIndex1, AIndex2);
    ReorderItems;
  end;
end;

procedure TFitsContainer.Move(ACurIndex, ANewIndex: Integer);
var
  LCurItem, LNewItem: TFitsItem;
  LNewOffset: Int64;
begin
  Check('index', [ACurIndex], ERROR_CONTAINER_MOVE_INDEX);
  Check('index', [ANewIndex], ERROR_CONTAINER_MOVE_INDEX);
  if ACurIndex <> ANewIndex then
  begin
    Check('order', [ACurIndex, {AIndexNewPimary:} Integer(1)], ERROR_CONTAINER_MOVE_ORDER);
    Check('order', [ANewIndex, {AIndexNewPimary:} ACurIndex], ERROR_CONTAINER_MOVE_ORDER);
    LCurItem := FItems[ACurIndex];
    LNewItem := FItems[ANewIndex];
    LNewOffset := IfThen(ACurIndex > ANewIndex, LNewItem.Offset, LNewItem.Offset + LNewItem.Size - 1);
    FContent.Move(LCurItem.Offset, LCurItem.Size, {var} LNewOffset);
    FItems.Move(ACurIndex, ANewIndex);
    ReorderItems;
  end;
end;

function TFitsContainer.IndexOf(AItem: TFitsItem): Integer;
begin
  Result := FItems.IndexOf(AItem);
end;

function TFitsContainer.ItemExtensionTypeIs(AIndex: Integer; AItemClass: TFitsItemClass): Boolean;
var
  LItem: TFitsItem;
begin
  Check('index', [AIndex], ERROR_CONTAINER_EXTENSIONTYPEIS_INDEX);
  LItem := TFitsItem(FItems[AIndex]);
  Result := AItemClass.ExtensionTypeIs(LItem);
end;

end.
