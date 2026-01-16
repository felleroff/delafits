{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{            Standard ASCII TABLE extension            }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsTable;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Classes, Math, DeLaFitsCommon, DeLaFitsMath, DeLaFitsString,
  DeLaFitsProp, DeLaFitsClasses;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_TABLE                                = 9000;

  ERROR_TABLESPEC_CHECKITEM_NO_OBJECT        = 9100;
  ERROR_TABLESPEC_CHECKITEM_OBJECT           = 9101;
  ERROR_TABLESPEC_EXTRACTNAXES1_NOT_FOUND    = 9102;
  ERROR_TABLESPEC_EXTRACTNAXES2_NOT_FOUND    = 9103;
  ERROR_TABLESPEC_EXTRACTTFIELDS_NOT_FOUND   = 9104;
  ERROR_TABLESPEC_EXTRACTTBCOL_NOT_FOUND     = 9105;
  ERROR_TABLESPEC_EXTRACTTFORM_NOT_FOUND     = 9106;
  ERROR_TABLESPEC_SETNAXES1_VALUE            = 9107;
  ERROR_TABLESPEC_SETNAXES2_VALUE            = 9108;
  ERROR_TABLESPEC_SETTFIELDS_VALUE           = 9109;
  ERROR_TABLESPEC_CHECKFIELD_FIELDNUMBER     = 9110;
  ERROR_TABLESPEC_CHECKFIELD_FIELDFORM       = 9111;
  ERROR_TABLESPEC_CHECKFIELD_FIELDPOSITION   = 9112;
  ERROR_TABLESPEC_CHECKFIELD_FIELDBOUNDS     = 9113;
  ERROR_TABLESPEC_CHECKFIELD_FIELDSCAL       = 9114;
  ERROR_TABLESPEC_CHECKFIELD_FIELDZERO       = 9115;
  ERROR_TABLESPEC_CHECKFIELD_FIELDNULL       = 9116;
  ERROR_TABLESPEC_CHECKFIELD_FIELDDMIN       = 9117;
  ERROR_TABLESPEC_CHECKFIELD_FIELDDMAX       = 9118;
  ERROR_TABLESPEC_CHECKFIELD_FIELDLMIN       = 9119;
  ERROR_TABLESPEC_CHECKFIELD_FIELDLMAX       = 9120;
  ERROR_TABLESPEC_CHECKFIELD_FIELDDISP       = 9121;
  ERROR_TABLESPEC_CHECKFIELD_UNDISPLAY       = 9122;
  ERROR_TABLESPEC_SORTFIELDS_UNFORM          = 9123;
  ERROR_TABLESPEC_EXCHANGEFIELDS_NUMBER      = 9124;
  ERROR_TABLESPEC_MOVEFIELDS_NUMBER          = 9125;
  ERROR_TABLESPEC_DELETEFIELD_NUMBER         = 9126;
  ERROR_TABLESPEC_INSERTFIELD_NUMBER         = 9127;
  ERROR_TABLESPEC_GETFIELD_NUMBER            = 9128;
  ERROR_TABLESPEC_SETFIELD_NUMBER            = 9129;

  ERROR_TABLEHEAD_CUSTOMIZENEW_NAXES1_VALUE  = 9200;
  ERROR_TABLEHEAD_CUSTOMIZENEW_NAXES2_VALUE  = 9201;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TFIELDS_VALUE = 9202;
  ERROR_TABLEHEAD_CUSTOMIZENEW_FIELDNUMBER   = 9203;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TBCOL_VALUE   = 9204;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TFORM_VALUE   = 9205;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TFORM_BOUNDS  = 9206;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TSCAL_VALUE   = 9207;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TZERO_VALUE   = 9208;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TNULL_VALUE   = 9209;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TDMIN_VALUE   = 9210;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TDMAX_VALUE   = 9211;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TLMIN_VALUE   = 9212;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TLMAX_VALUE   = 9213;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TDISP_VALUE   = 9214;
  ERROR_TABLEHEAD_CUSTOMIZENEW_TDISP_INCOMP  = 9215;

  ERROR_TABLEDATA_READROWS_BOUNDS            = 9300;
  ERROR_TABLEDATA_WRITEROWS_SIZE             = 9301;
  ERROR_TABLEDATA_WRITEROWS_BOUNDS           = 9302;
  ERROR_TABLEDATA_EXCHANGEROWS_INDEX         = 9303;
  ERROR_TABLEDATA_MOVEROWS_INDEX             = 9304;
  ERROR_TABLEDATA_DELETEROWS_BOUNDS          = 9305;
  ERROR_TABLEDATA_INSERTROWS_SIZE            = 9306;
  ERROR_TABLEDATA_INSERTROWS_INDEX           = 9307;
  ERROR_TABLEDATA_GETFIELDINFO_NUMBER        = 9308;
  ERROR_TABLEDATA_MAKEFIELDS_CLASS           = 9309;
  ERROR_TABLEDATA_GETFIELDCLASS_NUMBER       = 9310;
  ERROR_TABLEDATA_SETFIELDCLASS_NUMBER       = 9311;
  ERROR_TABLEDATA_SETFIELDCLASS_CLASS        = 9312;
  ERROR_TABLEDATA_GETFIELD_NUMBER            = 9313;
  ERROR_TABLEDATA_DELETERECORD_STATE         = 9314;
  ERROR_TABLEDATA_INSERTRECORD_INDEX         = 9315;
  ERROR_TABLEDATA_POSTRECORD_STATE           = 9316;
  ERROR_TABLEDATA_SETRECORDBUFFER_SIZE       = 9317;
  ERROR_TABLEDATA_GETRECORDVALUE_STATE       = 9318;
  ERROR_TABLEDATA_SETRECORDVALUE_STATE       = 9319;

  ERROR_TABLE_CREATENEW_NO_SPEC              = 9400;
  ERROR_TABLE_CREATENEW_INVALID_CLASS_SPEC   = 9401;
  ERROR_TABLE_GETBITPIX_VALUE                = 9402;
  ERROR_TABLE_GETNAXIS_VALUE                 = 9403;
  ERROR_TABLE_GETNAXES_VALUE                 = 9404;
  ERROR_TABLE_GETPCOUNT_VALUE                = 9405;
  ERROR_TABLE_GETGCOUNT_VALUE                = 9406;
  ERROR_TABLE_GETTFIELDS_NOT_FOUND           = 9407;
  ERROR_TABLE_GETTFIELDS_VALUE               = 9408;
  ERROR_TABLE_GETTBCOL_NUMBER                = 9409;
  ERROR_TABLE_GETTBCOL_NOT_FOUND             = 9410;
  ERROR_TABLE_GETTBCOL_VALUE                 = 9411;
  ERROR_TABLE_GETTFORM_NUMBER                = 9412;
  ERROR_TABLE_GETTFORM_NOT_FOUND             = 9413;
  ERROR_TABLE_GETTFORM_VALUE                 = 9414;
  ERROR_TABLE_GETTTYPE_NUMBER                = 9415;
  ERROR_TABLE_GETTUNIT_NUMBER                = 9416;
  ERROR_TABLE_GETTSCAL_NUMBER                = 9417;
  ERROR_TABLE_GETTSCAL_VALUE                 = 9418;
  ERROR_TABLE_GETTZERO_NUMBER                = 9419;
  ERROR_TABLE_GETTZERO_VALUE                 = 9420;
  ERROR_TABLE_GETTNULL_NUMBER                = 9421;
  ERROR_TABLE_GETTDISP_NUMBER                = 9422;
  ERROR_TABLE_GETTDISP_VALUE                 = 9423;
  ERROR_TABLE_GETTDISP_INCOMP                = 9424;
  ERROR_TABLE_GETTDMIN_NUMBER                = 9425;
  ERROR_TABLE_GETTDMIN_VALUE                 = 9426;
  ERROR_TABLE_GETTDMAX_NUMBER                = 9427;
  ERROR_TABLE_GETTDMAX_VALUE                 = 9428;
  ERROR_TABLE_GETTLMIN_NUMBER                = 9429;
  ERROR_TABLE_GETTLMIN_VALUE                 = 9430;
  ERROR_TABLE_GETTLMAX_NUMBER                = 9431;
  ERROR_TABLE_GETTLMAX_VALUE                 = 9432;

  ERROR_FIELD_BIND_NO_SOURCE                 = 9500;
  ERROR_FIELD_BIND_NUMBER                    = 9501;
  ERROR_FIELD_SETFIELDSCAL_VALUE             = 9502;
  ERROR_FIELD_SETFIELDZERO_VALUE             = 9503;
  ERROR_FIELD_SETFIELDNULL_VALUE             = 9504;
  ERROR_FIELD_SETFIELDDMIN_VALUE             = 9505;
  ERROR_FIELD_SETFIELDDMAX_VALUE             = 9506;
  ERROR_FIELD_SETFIELDLMIN_VALUE             = 9507;
  ERROR_FIELD_SETFIELDLMAX_VALUE             = 9508;
  ERROR_FIELD_SETDISPLAYFORMAT_VALUE         = 9509;
  ERROR_FIELD_SETDISPLAYFORMAT_INCOMP        = 9510;

resourcestring

  { The messages of exceptions }

  STableDataRowsRangeOutBounds   = 'Range "INDEX=%d;COUNT=%d" is out of the ASCII-table rows list bounds "COUNT=%d"';
  STableDataRowsIndexOutBounds   = 'Index "%d" is out of the ASCII-table rows list bounds "COUNT=%d"';
  STableDataRowsInvalidSize      = '"%d" is an invalid row size. The ASCII-table row size must be a multiple of "%d" characters';
  STableDataFieldNumberOutBounds = 'Number "%d" is out of the ASCII-table field list bounds "COUNT=%d"';
  STableDataFieldClassUndefined  = 'Unable to create an object for the %dth ASCII-table field. Class is undefined';
  STableDataRecordCannotDelete   = 'Cannot delete an inactive ASCII-table record';
  STableDataRecordCannotPost     = 'Cannot post an ASCII-table record that is not in edit or insert mode';
  STableDataRecordIndexOutBounds = 'Index "%d" is out of the ASCII-table record list bounds "COUNT=%d"';
  STableDataRecordInvalidSize    = '"%d" is an invalid record size. The size of an ASCII-table record must be "%d" characters';
  STableDataRecordValueInactive  = 'Cannot access a field value in an inactive ASCII-table record';

  STableNotAssigned              = 'ASCII-table object not assigned';

  SFieldIncorrectValue           = 'Incorrect field value "%s=%s"';
  SFieldIncorrectValueWidth      = 'Incorrect value width for field "%s=%s"';
  SFieldInfoIncorrect            = 'Incorrect field "%s"';
  SFieldInfoIncorrectNumber      = 'Field number "%d" is out of bounds';
  SFieldInfoIncorrectForm        = 'Incorrect field form "%s"';

type

  { TFieldInfo: field description in TABLE extension }

  PFieldInfo = ^TFieldInfo;
  TFieldInfo = record
    FieldNumber: Integer;
    FieldForm: string;
    FieldPosition: Integer;
    FieldName: string;
    FieldUnit: string;
    FieldScal: Extended;
    FieldZero: Extended;
    FieldNull: string;
    FieldDmin: TVariable;
    FieldDmax: TVariable;
    FieldLmin: TVariable;
    FieldLmax: TVariable;
    FieldDisp: string;
  end;

  TFieldInfoDynArray = array of TFieldInfo;

  TFieldInfoList = class(TList)
  private
    function GetItem(AIndex: Integer): TFieldInfo;
    procedure SetItem(AIndex: Integer; const AItem: TFieldInfo);
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    procedure Assign(ASource: TFieldInfoList);
    procedure Insert(AIndex: Integer; const AItem: TFieldInfo);
    function Add(const AItem: TFieldInfo): Integer;
    property Items[Index: Integer]: TFieldInfo read GetItem write SetItem; default;
  end;

  function CreateFieldInfo(AFieldNumber: Integer; const AFieldForm: string;
    AFieldPosition: Integer; const AFieldName, AFieldUnit: string;
    const AFieldScal, AFieldZero: Extended; const AFieldNull: string;
    const AFieldDmin, AFieldDmax, AFieldLmin, AFieldLmax: TVariable;
    const AFieldDisp: string): TFieldInfo;

  function CreateSimpleFieldInfo(AFieldNumber: Integer; const AFieldForm: string;
    AFieldPosition: Integer; const AFieldName: string = '';
    const AFieldDisp: string = ''): TFieldInfo;

  function CreateStringFieldInfo(AFieldNumber, AFieldWidth, AFieldPosition: Integer;
    const AFieldName: string = ''; const AFieldDisp: string = ''): TFieldInfo;

  function CreateIntegerFieldInfo(AFieldNumber, AFieldWidth, AFieldPosition: Integer;
    const AFieldName: string = ''; const AFieldDisp: string = ''): TFieldInfo;

  function CreateFixedFieldInfo(AFieldNumber, AFieldWidth, AFieldPrecision, AFieldPosition: Integer;
    const AFieldName: string = ''; const AFieldDisp: string = ''): TFieldInfo;
  function CreateExponentFieldInfo(AFieldNumber, AFieldWidth, AFieldPrecision, AFieldPosition: Integer;
    const AFieldName: string = ''; const AFieldDisp: string = ''): TFieldInfo;
  function CreateDoubleExponentFieldInfo(AFieldNumber, AFieldWidth, AFieldPrecision, AFieldPosition: Integer;
    const AFieldName: string = ''; const AFieldDisp: string = ''): TFieldInfo;

type

  TFitsTable = class;
  TFitsField = class;

  { TFitsTableSpec: specification to create a new TABLE }

  EFitsTableSpecException = class(EFitsItemSpecException)
  protected
    function GetTopic: string; override;
  end;

  TFitsTableSpec = class(TFitsItemSpec)
  private
    FNAXES1: Integer;
    FNAXES2: Integer;
    FFields: TFieldInfoList;
    FClearRecords: Boolean;
    function GetBITPIX: TBitPix;
    function GetNAXIS: Integer;
    procedure SetNAXES1(AValue: Integer);
    procedure SetNAXES2(AValue: Integer);
    function GetPCOUNT: Integer;
    function GetGCOUNT: Integer;
    function GetTFIELDS: Integer;
    procedure SetTFIELDS(AValue: Integer);
    function GetField(ANumber: Integer): TFieldInfo;
    procedure SetField(ANumber: Integer; const AValue: TFieldInfo);
    procedure FillFields(AItem: TFitsItem); overload;
    procedure FillFields(const ATFORMS: array of string); overload;
    procedure FillFields(const AFieldInfos: array of TFieldInfo); overload;
  protected
    procedure Init; override;
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure CheckItem(AItem: TFitsItem); virtual;
    function ExtractNAXES1(AItem: TFitsItem): Integer; virtual;
    function ExtractNAXES2(AItem: TFitsItem): Integer; virtual;
    function ExtractTFIELDS(AItem: TFitsItem): Integer; virtual;
    function ExtractTBCOL(AItem: TFitsItem; ANumber: Integer): Integer; virtual;
    function ExtractTFORM(AItem: TFitsItem; ANumber: Integer): string; virtual;
    function ExtractTTYPE(AItem: TFitsItem; ANumber: Integer): string; virtual;
    function ExtractTUNIT(AItem: TFitsItem; ANumber: Integer): string; virtual;
    function ExtractTSCAL(AItem: TFitsItem; ANumber: Integer): Extended; virtual;
    function ExtractTZERO(AItem: TFitsItem; ANumber: Integer): Extended; virtual;
    function ExtractTNULL(AItem: TFitsItem; ANumber: Integer): string; virtual;
    function ExtractTDISP(AItem: TFitsItem; ANumber: Integer): string; virtual;
    function ExtractTDMIN(AItem: TFitsItem; ANumber: Integer): TVariable; virtual;
    function ExtractTDMAX(AItem: TFitsItem; ANumber: Integer): TVariable; virtual;
    function ExtractTLMIN(AItem: TFitsItem; ANumber: Integer): TVariable; virtual;
    function ExtractTLMAX(AItem: TFitsItem; ANumber: Integer): TVariable; virtual;
    procedure DoSetNAXES1(AProp: INAXES); virtual;
    procedure DoSetNAXES2(AProp: INAXES); virtual;
    procedure DoSetTFIELDS(AProp: ITFIELDS); virtual;
    procedure CheckNumber(ANumber: Integer; ACodeError: Integer);
    procedure CheckField(const AFieldInfo: TFieldInfo); virtual;
  public
    constructor Create(AItem: TFitsItem);
    constructor CreateNewForms(ANAXES1, ANAXES2: Integer; const ATFORMS: array of string);
    constructor CreateNewFields(ARecordSize, ARecordCount: Integer; const AFieldInfos: array of TFieldInfo);
    destructor Destroy; override;
    // Sort fields by number and adjust their position
    procedure SortFields(APretty: Boolean = True);
    procedure ExchangeFields(ANumber1, ANumber2: Integer);
    procedure MoveFields(ACurNumber, ANewNumber: Integer);
    procedure DeleteField(ANumber: Integer);
    procedure InsertField(ANumber: Integer; const AFieldInfo: TFieldInfo);
    function AddField(const AFieldInfo: TFieldInfo): Integer;
    // Standard properties
    property BITPIX: TBitPix read GetBITPIX;
    property NAXIS: Integer read GetNAXIS;
    property NAXES1: Integer read FNAXES1 write SetNAXES1;
    property NAXES2: Integer read FNAXES2 write SetNAXES2;
    property PCOUNT: Integer read GetPCOUNT;
    property GCOUNT: Integer read GetGCOUNT;
    property TFIELDS: Integer read GetTFIELDS write SetTFIELDS;
    // Synonyms for standard properties
    property FieldInfos[Number: Integer]: TFieldInfo read GetField write SetField;
    property FieldCount: Integer read GetTFIELDS write SetTFIELDS;
    property RecordSize: Integer read FNAXES1 write SetNAXES1;
    property RecordCount: Integer read FNAXES2 write SetNAXES2;
    // Clear all records in the new extension
    property ClearRecords: Boolean read FClearRecords write FClearRecords;
  end;

  { TFitsTableHead: TABLE header section }

  EFitsTableHeadException = class(EFitsItemHeadException)
  protected
    function GetTopic: string; override;
  end;

  TFitsTableHead = class(TFitsItemHead)
  private
    function GetItem: TFitsTable;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure CustomizeNew(ASpec: TFitsItemSpec); override;
  public
    property Item: TFitsTable read GetItem;
  end;

  { TFieldHandle: field pointer in the TABLE }

  TFieldHandle = record
    FieldNumber: Integer;
    FieldSource: TFitsTable;
  end;

  TFitsFieldDynArray = array of TFitsField;

  TFitsFieldClass = class of TFitsField;

  { TTableRecordState: state of the active table record }

  TTableRecordState = (trsInactive, trsBrowse, trsEdit, trsInsert);

  { TFitsTableData: TABLE data section }

  EFitsTableDataException = class(EFitsItemDataException)
  protected
    function GetTopic: string; override;
  end;

  TFitsTableData = class(TFitsItemData)
  private
    FFields: TFitsFieldDynArray;
    FRecordCursor: Integer;
    FRecordState: TTableRecordState;
    FRecordBuffer: string;
    function GetItem: TFitsTable;
    procedure CheckRows(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
    function GetRowSize: Integer;
    function GetRowCount: Integer;
    procedure SetRowCount(AValue: Integer);
    function GetRow(AIndex: Integer): string;
    procedure SetRow(AIndex: Integer; const ARow: string);
    procedure CheckFields(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
    procedure MakeFields(AForce: Boolean = False);
    procedure FreeFields;
    function GetFieldCount: Integer;
    function GetFieldInfo(ANumber: Integer): TFieldInfo;
    function GetFieldHandle(ANumber: Integer): TFieldHandle;
    function GetFieldClass(ANumber: Integer): TFitsFieldClass;
    procedure SetFieldClass(ANumber: Integer; AFieldClass: TFitsFieldClass);
    function GetField(ANumber: Integer): TFitsField;
    procedure RefreshRecord;
    function GetRecordCount: Integer;
    function GetRecordActive: Boolean;
    function GetRecordModified: Boolean;
    function GetRecordValue(AFieldPosition, AFieldWidth: Integer): string;
    procedure SetRecordValue(AFieldPosition, AFieldWidth: Integer; const AValue: string);
    procedure SetRecordBuffer(const ARecordBuffer: string);
  protected
    procedure Init; override;
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure CustomizeNew(ASpec: TFitsItemSpec); override;
    function Filler: Char; override;
    function CalcFieldClass(ANumber: Integer): TFitsFieldClass; virtual;
  public
    destructor Destroy; override;
    // [Row] Access to the table rows as a sequence of ASCII characters
    // of the specified length. The contents of the rows are not checked
    procedure ReadRows(AIndex, ACount: Integer; var ARows: string);
    procedure WriteRows(AIndex: Integer; const ARows: string);
    procedure ExchangeRows(AIndex1, AIndex2: Integer);
    procedure MoveRows(ACurIndex, ANewIndex: Integer);
    procedure DeleteRows(AIndex, ACount: Integer);
    procedure InsertRows(AIndex: Integer; const ARows: string);
    function AddRows(const ARows: string): Integer;
    // [Field] Each row of the table consists of a sequence of fields,
    // with one value (entry) in each field
    procedure RefreshFields;
    function FindField(const AFieldName: string): TFitsField;
    // [Record] The active table row for which the field interface
    // is available. Only one table row can be active at a time
    procedure OpenRecord(AIndex: Integer);
    procedure DeleteRecord;
    procedure InsertRecord(AIndex: Integer);
    procedure AddRecord;
    procedure PostRecord;
    procedure CancelRecord;
    procedure CloseRecord;
    property Item: TFitsTable read GetItem;
    property RowSize: Integer read GetRowSize;
    property RowCount: Integer read GetRowCount;
    property Rows[Index: Integer]: string read GetRow write SetRow;
    property FieldCount: Integer read GetFieldCount;
    property FieldInfos[ANumber: Integer]: TFieldInfo read GetFieldInfo;
    property FieldClasses[ANumber: Integer]: TFitsFieldClass read GetFieldClass write SetFieldClass;
    property Fields[ANumber: Integer]: TFitsField read GetField;
    property RecordSize: Integer read GetRowSize;
    property RecordCount: Integer read GetRecordCount;
    property RecordCursor: Integer read FRecordCursor;
    property RecordState: TTableRecordState read FRecordState;
    property RecordActive: Boolean read GetRecordActive;
    property RecordModified: Boolean read GetRecordModified;
    property RecordBuffer: string read FRecordBuffer write SetRecordBuffer;
  end;

  { TFitsTable: standard TABLE extension }

  EFitsTableException = class(EFitsItemException)
  protected
    function GetTopic: string; override;
  end;

  TFitsTable = class(TFitsItem)
  private
    procedure CheckFieldBounds(AProp: IFitsPropContext; ACodeError: Integer);
    function GetHead: TFitsTableHead;
    function GetData: TFitsTableData;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    function GetHeadClass: TFitsItemHeadClass; override;
    function GetDataClass: TFitsItemDataClass; override;
    procedure DoGetBITPIX(AProp: IBITPIX); override;
    procedure DoGetNAXIS(AProp: INAXIS); override;
    procedure DoGetNAXES(AProp: INAXES); override;
    procedure DoGetPCOUNT(AProp: IPCOUNT); override;
    procedure DoGetGCOUNT(AProp: IGCOUNT); override;
    procedure DoGetTFIELDS(AProp: ITFIELDS); virtual;
    procedure DoGetTBCOL(AProp: ITBCOL); virtual;
    procedure DoGetTFORM(AProp: ITFORM); virtual;
    procedure DoGetTTYPE(AProp: ITTYPE); virtual;
    procedure DoGetTUNIT(AProp: ITUNIT); virtual;
    procedure DoGetTSCAL(AProp: ITSCAL); virtual;
    procedure DoGetTZERO(AProp: ITZERO); virtual;
    procedure DoGetTNULL(AProp: ITNULL); virtual;
    procedure DoGetTDISP(AProp: ITDISP); virtual;
    procedure DoGetTDMIN(AProp: ITDMIN); virtual;
    procedure DoGetTDMAX(AProp: ITDMAX); virtual;
    procedure DoGetTLMIN(AProp: ITLMIN); virtual;
    procedure DoGetTLMAX(AProp: ITLMAX); virtual;
  public
    constructor CreateNew(AContainer: TFitsContainer; ASpec: TFitsItemSpec); override;
    class function ExtensionType: string; override;
    class function ExtensionTypeIs(AItem: TFitsItem): Boolean; override;
    function GetTFIELDS: Integer;
    function GetTBCOL(ANumber: Integer): Integer;
    function GetTFORM(ANumber: Integer): string;
    function GetTTYPE(ANumber: Integer): string;
    function GetTUNIT(ANumber: Integer): string;
    function GetTSCAL(ANumber: Integer): Extended;
    function GetTZERO(ANumber: Integer): Extended;
    function GetTNULL(ANumber: Integer): string;
    function GetTDISP(ANumber: Integer): string;
    function GetTDMIN(ANumber: Integer): TVariable;
    function GetTDMAX(ANumber: Integer): TVariable;
    function GetTLMIN(ANumber: Integer): TVariable;
    function GetTLMAX(ANumber: Integer): TVariable;
    property Head: TFitsTableHead read GetHead;
    property Data: TFitsTableData read GetData;
  end;

  { TFieldFormat: decoded field format in TABLE extensions, defined by
    the TFORMn and TDISPn keyword records }

  TFieldFormat = record
    Code: string;
    w: Integer;
    e: Integer;
  case Integer of
    1: (m: Integer);
    2: (d: Integer);
  end;

  { TFieldType: identifies the value type of a field in TABLE extensions
    according to the code of the TFORMn keyword record }

  TFieldType = (ftString, ftInteger, ftFloat);

  { TFitsField [abstract]: base class of the field in TABLE extensions }

  EFitsFieldException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  TFitsField = class(TFitsObject)
  private
    FTable: TFitsTable;
    FFieldNumber: Integer;
    FFieldFormat: TFieldFormat;
    FFieldPosition: Integer;
    FFieldName: string;
    FFieldUnit: string;
    FFieldScal: Extended;
    FFieldZero: Extended;
    FFieldNull: string;
    FFieldDmin: TVariable;
    FFieldDmax: TVariable;
    FFieldLmin: TVariable;
    FFieldLmax: TVariable;
    FDisplayFormat: TFieldFormat;
    procedure Bind(const AHandle: TFieldHandle);
    procedure DeleteTableHeadProp(AProp: IFitsPropContext);
    procedure UpdateTableHeadProp(AProp: IFitsPropContext);
    procedure AssignTableHeadProp(AProp: IFitsStringPropContext); overload;
    procedure AssignTableHeadProp(AProp: IFitsVariablePropContext); overload;
    procedure CalcFieldFormat;
    procedure CalcFieldPosition;
    procedure CalcFieldName;
    procedure CalcFieldUnit;
    procedure CalcFieldScal;
    procedure CalcFieldZero;
    procedure CalcFieldNull;
    procedure CalcFieldDmin;
    procedure CalcFieldDmax;
    procedure CalcFieldLmin;
    procedure CalcFieldLmax;
    procedure CalcDisplayFormat;
    function GetFieldFormatStr: string;
    function GetFieldType: TFieldType;
    function GetFieldWidth: Integer;
    procedure SetFieldName(const AValue: string);
    procedure SetFieldUnit(const AValue: string);
    procedure SetFieldScal(const AValue: Extended);
    procedure SetFieldZero(const AValue: Extended);
    procedure SetFieldNull(const AValue: string);
    procedure SetFieldDmin(const AValue: TVariable);
    procedure SetFieldDmax(const AValue: TVariable);
    procedure SetFieldLmin(const AValue: TVariable);
    procedure SetFieldLmax(const AValue: TVariable);
    procedure SetDisplayFormatRec(const AValue: TFieldFormat);
    function GetDisplayFormatStr: string;
    procedure SetDisplayFormatStr(const AValue: string);
    function GetDisplayWidth: Integer;
    procedure SetDisplayWidth(AValue: Integer);
    function GetValue: string;
    procedure SetValue(const AValue: string);
    function GetValueIsClear: Boolean;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
    procedure ChangeField; virtual;
    function GetDisplayValue: string; virtual; abstract;
  public
    constructor Create(const AHandle: TFieldHandle); virtual;
    // Set the field's default property and remove it from the table header
    procedure ClearFieldName;
    procedure ClearFieldUnit;
    procedure ClearFieldScal;
    procedure ClearFieldZero;
    procedure ClearFieldNull;
    procedure ClearFieldDmin;
    procedure ClearFieldDmax;
    procedure ClearFieldLmin;
    procedure ClearFieldLmax;
    procedure ClearDisplayFormat;
    // Set the value to null
    procedure ClearValue; virtual;
    // Source and owner
    property Table: TFitsTable read FTable;
    // Field description
    property FieldNumber: Integer read FFieldNumber;
    property FieldFormatRec: TFieldFormat read FFieldFormat;
    property FieldFormatStr: string read GetFieldFormatStr;
    property FieldType: TFieldType read GetFieldType;
    property FieldPosition: Integer read FFieldPosition;
    property FieldWidth: Integer read GetFieldWidth;
    property FieldName: string read FFieldName write SetFieldName;
    property FieldUnit: string read FFieldUnit write SetFieldUnit;
    property FieldScal: Extended read FFieldScal write SetFieldScal;
    property FieldZero: Extended read FFieldZero write SetFieldZero;
    property FieldNull: string read FFieldNull write SetFieldNull;
    property FieldDmin: TVariable read FFieldDmin write SetFieldDmin;
    property FieldDmax: TVariable read FFieldDmax write SetFieldDmax;
    property FieldLmin: TVariable read FFieldLmin write SetFieldLmin;
    property FieldLmax: TVariable read FFieldLmax write SetFieldLmax;
    // Display value
    property DisplayFormatRec: TFieldFormat read FDisplayFormat write SetDisplayFormatRec;
    property DisplayFormatStr: string read GetDisplayFormatStr write SetDisplayFormatStr;
    property DisplayWidth: Integer read GetDisplayWidth write SetDisplayWidth;
    property DisplayValue: string read GetDisplayValue;
    // Raw value
    property Value: string read GetValue write SetValue;
    property ValueIsClear: Boolean read GetValueIsClear;
  end;

  { TFitsStringField: string field in TABLE extensions }

  TFitsStringField = class(TFitsField)
  private
    function GetValueAsString: string;
    procedure SetValueAsString(const AValue: string);
  protected
    function GetDisplayValue: string; override;
  public
    property ValueAsString: string read GetValueAsString write SetValueAsString;
  end;

  { TFitsNumericField [abstract]: numeric field in TABLE extensions }

  TFitsNumericField = class(TFitsField)
  protected
    FFormatSettings: TFormatSettings;
    FFieldIsScaled: Boolean;
    FGetDisplayValuePrecision: Integer;
    FGetDisplayValueDigits: Integer;
    FGetDisplayValueExponentChar: Char;
    FGetDisplayValueFunc: function: string of object;
    procedure CalcFieldScalability;
    function GetDisplayFixedValue: string;
    function GetDisplayFortranExponentValue: string;
    function GetDisplayScientificExponentValue: string;
    function GetDisplayGeneralValue: string;
    procedure CalcGetDisplayValueFunc; virtual;
    procedure ChangeField; override;
    function GetDisplayValue: string; override;
    function GetValueAsExtended: Extended; virtual; abstract;
    procedure SetValueAsExtended(const AValue: Extended); virtual; abstract;
    function GetValueAsDouble: Double; virtual;
    procedure SetValueAsDouble(const AValue: Double); virtual;
    function GetValueAsSingle: Single; virtual;
    procedure SetValueAsSingle(const AValue: Single); virtual;
    function GetValueAsInt64: Int64; virtual; abstract;
    procedure SetValueAsInt64(const AValue: Int64); virtual; abstract;
    function GetValueAsInteger: Integer; virtual;
    procedure SetValueAsInteger(const AValue: Integer); virtual;
    function GetValueAsSmallInt: SmallInt; virtual;
    procedure SetValueAsSmallInt(const AValue: SmallInt); virtual;
  public
    constructor Create(const AHandle: TFieldHandle); override;
    property FieldIsScaled: Boolean read FFieldIsScaled;
    property ValueAsExtended: Extended read GetValueAsExtended write SetValueAsExtended;
    property ValueAsDouble: Double read GetValueAsDouble write SetValueAsDouble;
    property ValueAsSingle: Single read GetValueAsSingle write SetValueAsSingle;
    property ValueAsInt64: Int64 read GetValueAsInt64 write SetValueAsInt64;
    property ValueAsInteger: Integer read GetValueAsInteger write SetValueAsInteger;
    property ValueAsSmallInt: SmallInt read GetValueAsSmallInt write SetValueAsSmallInt;
  end;

  { TFitsIntegerField: integer field in TABLE extensions }

  TFitsIntegerField = class(TFitsNumericField)
  protected
    function GetDisplayHexValue: string;
    function GetDisplayDecValue: string;
    function GetDisplayOctValue: string;
    function GetDisplayBinValue: string;
    procedure CalcGetDisplayValueFunc; override;
    function GetValueAsExtended: Extended; override;
    procedure SetValueAsExtended(const AValue: Extended); override;
    function GetValueAsInt64: Int64; override;
    procedure SetValueAsInt64(const AValue: Int64); override;
  end;

  { TFitsFloatField: floating-point field in TABLE extensions }

  TFitsFloatField = class(TFitsNumericField)
  private
    FSetValuePrecision: Integer;
    FSetValueDigits: Integer;
    FSetValueExponentChar: Char;
    FSetValueProc: procedure (const AValue: Extended) of object;
    procedure SetFixedValue(const AValue: Extended);
    procedure SetExponentValue(const AValue: Extended);
    procedure CalcSetValueProc;
  protected
    function GetValueAsExtended: Extended; override;
    procedure SetValueAsExtended(const AValue: Extended); override;
    function GetValueAsInt64: Int64; override;
    procedure SetValueAsInt64(const AValue: Int64); override;
  public
    constructor Create(const AHandle: TFieldHandle); override;
  end;

implementation

{ Field format }

function DecodeFieldFormat(const AString: string; out AFormat: TFieldFormat): Integer;
var
  LLen, LDot, LExp, LCodeLen: Integer;
  Sw, Sd, Se: string;
begin
  Result := 0;
  LLen := Length(AString);
  LDot := PosChar('.', AString, {AOffset:} 2);
  LExp := PosChar('E', AString, {AOffset:} 2);
  AFormat.Code := '';
  AFormat.w := -1;
  AFormat.d := -1;
  AFormat.e := -1;
  if LLen > 1 then
  begin
    LCodeLen := IfThen((Pos('EN', AString) = 1) or (Pos('ES', AString) = 1), 2, 1);
    AFormat.Code := Copy(AString, 1, LCodeLen);
    // ~ Ew.dEe
    if (LDot > 0) and (LExp > 0) then
    begin
      Sw := Copy(AString, LCodeLen + 1, LDot - LCodeLen - 1);
      Sd := Copy(AString, LDot + 1, LExp - LDot - 1);
      Se := Copy(AString, LExp + 1, LLen - LExp);
      if TryStrToInt(Sw, AFormat.w) and TryStrToInt(Sd, AFormat.d) and TryStrToInt(Se, AFormat.e) then
        Result := 3;
    end else
    // ~ Iw.m or Fw.d
    if LDot > 0 then
    begin
      Sw := Copy(AString, LCodeLen + 1, LDot - LCodeLen - 1);
      Sd := Copy(AString, LDot + 1, LLen - LDot);
      if TryStrToInt(Sw, AFormat.w) and TryStrToInt(Sd, AFormat.d) then
        Result := 2;
    end else
    // ~ Aw
    begin
      Sw := Copy(AString, LCodeLen + 1, LLen - LCodeLen);
      if TryStrToInt(Sw, AFormat.w) then
        Result := 1;
    end;
  end;
end;

function EncodeFieldFormat(const AFormat: TFieldFormat; out AString: string): Integer;
begin
  Result := 0;
  AString := '';
  if Length(AFormat.Code) > 0 then
  begin
    AString := AFormat.Code;
    if AFormat.w > 0 then
    begin
      AString := AString + IntToStr(AFormat.w);
      Inc(Result);
      if AFormat.d >= 0 then
      begin
        AString := AString + '.' + IntToStr(AFormat.d);
        Inc(Result);
        if AFormat.e > 0 then
        begin
          AString := AString + IfThen(AFormat.Code = 'D', 'D', 'E') + IntToStr(AFormat.e);
          Inc(Result);
        end;
      end;
    end;
  end;
end;

function CompatibleFieldFormat(const AForm, ADisp: TFieldFormat): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;
begin
  if AForm.Code = 'A' then
    Result := ADisp.Code = 'A'
  else if AForm.Code = 'I' then
    Result := MatchString(ADisp.Code, ['I', 'B', 'O', 'Z', 'F', 'E', 'EN', 'ES', 'G', 'D'])
  else if MatchString(AForm.Code, ['F', 'E', 'D']) then
    Result := MatchString(ADisp.Code, ['F', 'E', 'EN', 'ES', 'G', 'D'])
  else
    Result := False;
end;

function CompatibleFieldFormat(const AForm, ADisp: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF} overload;
var
  LForm, LDisp: TFieldFormat;
begin
  Result := True;
  Result := Result and (DecodeFieldFormat(AForm, {out} LForm) > 0);
  Result := Result and (DecodeFieldFormat(ADisp, {out} LDisp) > 0);
  Result := Result and CompatibleFieldFormat(LForm, LDisp);
end;

{ Header prop }

function DefaultBITPIX: TBitPix; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_7.2.1] Mandatory keywords ... BITPIX keyword.
  // The value field shall contain the integer 8, denoting that the array
  // contains ASCII characters.
  Result := bi08u;
end;

function CorrectBITPIX(AValue: TBitPix): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue = DefaultBITPIX;
end;

function DefaultNAXIS: Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_7.2.1] Mandatory keywords ... NAXIS keyword.
  // The value field shall contain the integer 2, denoting that the included
  // data array is two-dimensional: rows and columns
  Result := 2;
end;

function CorrectNAXIS(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue = DefaultNAXIS;
end;

type
  TFitsNAXES = class(DeLaFitsProp.TFitsNAXES)
  protected
    function NewLineNote: string; override;
  end;

function TFitsNAXES.NewLineNote: string;
begin
  case FKeywordNumber of
    1: Result := 'Number of characters per row';
    2: Result := 'Number of rows';
  else
    Result := '';
    Assert(False, SAssertionFailure);
  end;
end;

function CorrectNAXES1(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue > 0;
end;

function CorrectNAXES2(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue >= 0;
end;

function DefaultPCOUNT: Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_7.2.1] Mandatory keywords ... PCOUNT keyword.
  // The value field shall contain the integer 0
  Result := 0;
end;

function CorrectPCOUNT(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue = DefaultPCOUNT;
end;

function DefaultGCOUNT: Integer; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_7.2.1] Mandatory keywords ... GCOUNT keyword.
  // The value field shall contain the integer 1; the data blocks contain
  // a single table
  Result := 1;
end;

function CorrectGCOUNT(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := AValue = DefaultGCOUNT;
end;

function CorrectTFIELDS(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
const
  cMinFields = 0;
begin
  Result := InRange(AValue, cMinFields, cMaxFields);
end;

function CorrectTBCOL(AValue: Integer): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_7.2.1] Mandatory keywords ... TBCOLn keyword.
  // The value field of this indexed keyword shall contain an integer
  // specifying the column in which Field n starts. The first column
  // of a row is numbered 1
  Result := AValue > 0;
end;

function CorrectTFORM(const AValue: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  LFormat: TFieldFormat;
  LExtent: Integer;
begin
  // [FITS_STANDARD_4.0, SECT_7.2.1] Mandatory keywords ... TFORMn keyword.
  // See "Table 15: Valid TFORMn format values in TABLE extensions"
  Result := False;
  LExtent := DecodeFieldFormat(AValue, {out} LFormat);
  // Aw, Iw
  if MatchString(LFormat.Code, ['A', 'I']) then
  begin
    Result := (LExtent = 1) and (LFormat.w > 0);
  end else
  // Fw.d, Ew.d, Dw.d
  if MatchString(LFormat.Code, ['F', 'E', 'D']) then
  begin
    Result := (LExtent = 2) and (LFormat.w > 0) and (LFormat.d >= 0) and (LFormat.w > LFormat.d);
  end;
end;

function DefaultTSCAL: Extended; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_7.2.2] Other reserved keywords ... TSCALn keyword.
  // The default value for this keyword is 1.0
  Result := 1.0;
end;

function CorrectTSCAL(const AValue: Extended): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := not (IsNan(AValue) or (AValue = Infinity) or (AValue = NegInfinity) or IsZero(AValue));
end;

function DefaultTZERO: Extended; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  // [FITS_STANDARD_4.0, SECT_7.2.2] Other reserved keywords ... TZEROn keyword.
  // The default value for this keyword is 1.0
  Result := 0.0;
end;

function CorrectTZERO(const AValue: Extended): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  Result := not (IsNan(AValue) or (AValue = Infinity) or (AValue = NegInfinity));
end;

function CorrectTDISP(const AValue: string): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
var
  LFormat: TFieldFormat;
  LExtent: Integer;
begin
  // [FITS_STANDARD_4.0, SECT_7.2.1] Mandatory keywords ... TDISPn keyword.
  // See "Table 16: Valid TDISPn format values in TABLE extensions"
  Result := False;
  LExtent := DecodeFieldFormat(AValue, {out} LFormat);
  // Aw
  if LFormat.Code = 'A' then
  begin
    Result := (LExtent = 1) and (LFormat.w > 0);
  end else
  // Iw.m, Ow.m, Bw.m, Zw.m: ".m" field is optional
  if MatchString(LFormat.Code, ['I', 'B', 'O', 'Z']) then
  begin
    case LExtent of
      1: Result := (LFormat.w > 0);
      2: Result := (LFormat.w > 0) and (LFormat.m > 0) and (LFormat.w >= LFormat.m);
    end;
  end else
  // Fw.d, ENw.d, ESw.d
  if MatchString(LFormat.Code, ['F', 'EN', 'ES']) then
  begin
    Result := (LExtent = 2) and (LFormat.w > 0) and (LFormat.d >= 0) and (LFormat.w > LFormat.d);
  end else
  // Ew.dEe, Gw.dEe, Dw.dEe: "Ee" field is optional
  if MatchString(LFormat.Code, ['E', 'G', 'D']) then
  begin
    case LExtent of
      2: Result := (LFormat.w > 0) and (LFormat.d >= 0) and (LFormat.w > LFormat.d);
      3: Result := (LFormat.w > 0) and (LFormat.d >= 0) and (LFormat.e > 0) and (LFormat.w > (LFormat.d + LFormat.e));
    end;
  end;
end;

function CorrectTDMIN(const AValue: TVariable): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  if AValue.VarType = vtExtended then
    Result := not IsNan(AValue.ValueExtended)
  else
    Result := True;
end;

function CorrectTDMAX(const AValue: TVariable): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  if AValue.VarType = vtExtended then
    Result := not IsNan(AValue.ValueExtended)
  else
    Result := True;
end;

function CorrectTLMIN(const AValue: TVariable): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  if AValue.VarType = vtExtended then
    Result := not IsNan(AValue.ValueExtended)
  else
    Result := True;
end;

function CorrectTLMAX(const AValue: TVariable): Boolean; {$IFDEF HAS_INLINE} inline; {$ENDIF}
begin
  if AValue.VarType = vtExtended then
    Result := not IsNan(AValue.ValueExtended)
  else
    Result := True;
end;

{ TFieldInfo }

function CreateFieldInfo(AFieldNumber: Integer; const AFieldForm: string; AFieldPosition: Integer;
  const AFieldName, AFieldUnit: string; const AFieldScal, AFieldZero: Extended; const AFieldNull: string;
  const AFieldDmin, AFieldDmax, AFieldLmin, AFieldLmax: TVariable; const AFieldDisp: string): TFieldInfo;
begin
  Result.FieldNumber := AFieldNumber;
  Result.FieldForm := AFieldForm;
  Result.FieldPosition := AFieldPosition;
  Result.FieldName := AFieldName;
  Result.FieldUnit := AFieldUnit;
  Result.FieldScal := AFieldScal;
  Result.FieldZero := AFieldZero;
  Result.FieldNull := AFieldNull;
  Result.FieldDmin := AFieldDmin;
  Result.FieldDmax := AFieldDmax;
  Result.FieldLmin := AFieldLmin;
  Result.FieldLmax := AFieldLmax;
  Result.FieldDisp := AFieldDisp;
end;

function CreateSimpleFieldInfo(AFieldNumber: Integer; const AFieldForm: string;
  AFieldPosition: Integer; const AFieldName, AFieldDisp: string): TFieldInfo;
begin
  Result.FieldNumber := AFieldNumber;
  Result.FieldForm := AFieldForm;
  Result.FieldPosition := AFieldPosition;
  Result.FieldName := AFieldName;
  Result.FieldUnit := '';
  Result.FieldScal := DefaultTSCAL;
  Result.FieldZero := DefaultTZERO;
  Result.FieldNull := '';
  Result.FieldDmin := ClearVariable;
  Result.FieldDmax := ClearVariable;
  Result.FieldLmin := ClearVariable;
  Result.FieldLmax := ClearVariable;
  Result.FieldDisp := AFieldDisp;
end;

function CreateStringFieldInfo(AFieldNumber, AFieldWidth, AFieldPosition: Integer;
  const AFieldName, AFieldDisp: string): TFieldInfo;
begin
  Result := CreateSimpleFieldInfo(AFieldNumber, 'A' + IntToStr(AFieldWidth),
    AFieldPosition, AFieldName, AFieldDisp);
end;

function CreateIntegerFieldInfo(AFieldNumber, AFieldWidth, AFieldPosition: Integer;
  const AFieldName, AFieldDisp: string): TFieldInfo;
begin
  Result := CreateSimpleFieldInfo(AFieldNumber, 'I' + IntToStr(AFieldWidth),
    AFieldPosition, AFieldName, AFieldDisp);
end;

function CreateFixedFieldInfo(AFieldNumber, AFieldWidth, AFieldPrecision, AFieldPosition: Integer;
  const AFieldName, AFieldDisp: string): TFieldInfo;
begin
  Result := CreateSimpleFieldInfo(AFieldNumber, 'F' + IntToStr(AFieldWidth) + '.' + IntToStr(AFieldPrecision),
    AFieldPosition, AFieldName, AFieldDisp);
end;

function CreateExponentFieldInfo(AFieldNumber, AFieldWidth, AFieldPrecision, AFieldPosition: Integer;
  const AFieldName, AFieldDisp: string): TFieldInfo;
begin
  Result := CreateSimpleFieldInfo(AFieldNumber, 'E' + IntToStr(AFieldWidth) + '.' + IntToStr(AFieldPrecision),
    AFieldPosition, AFieldName, AFieldDisp);
end;

function CreateDoubleExponentFieldInfo(AFieldNumber, AFieldWidth, AFieldPrecision, AFieldPosition: Integer;
  const AFieldName, AFieldDisp: string): TFieldInfo;
begin
  Result := CreateSimpleFieldInfo(AFieldNumber, 'D' + IntToStr(AFieldWidth) + '.' + IntToStr(AFieldPrecision),
    AFieldPosition, AFieldName, AFieldDisp);
end;

function FieldInfoToString(const AFieldInfo: TFieldInfo): string;
begin
  Result := 'FIELDNUMBER=' + IntegerToString(AFieldInfo.FieldNumber) + ';' +
            'FIELDFORM=' + AFieldInfo.FieldForm + ';' +
            'FIELDPOSITION=' + IntegerToString(AFieldInfo.FieldPosition) + ';' +
            'FIELDNAME=' + AFieldInfo.FieldName + ';' +
            'FIELDUNIT=' + AFieldInfo.FieldUnit + ';' +
            'FIELDSCAL=' + FloatToString(AFieldInfo.FieldScal) + ';' +
            'FIELDZERO=' + FloatToString(AFieldInfo.FieldZero) + ';' +
            'FIELDNULL=' + AFieldInfo.FieldNull + ';' +
            'FIELDDMIN=' + VariableToPrintString(AFieldInfo.FieldDmin) + ';' +
            'FIELDDMAX=' + VariableToPrintString(AFieldInfo.FieldDmax) + ';' +
            'FIELDLMIN=' + VariableToPrintString(AFieldInfo.FieldLmin) + ';' +
            'FIELDLMAX=' + VariableToPrintString(AFieldInfo.FieldLmax) + ';' +
            'FIELDDISP=' + AFieldInfo.FieldDisp;
end;

{ TFieldInfoList }

procedure TFieldInfoList.Notify(Ptr: Pointer; Action: TListNotification);
var
  LItem: PFieldInfo;
begin
  inherited;
  if Action = lnDeleted then
  begin
    LItem := Ptr;
    Dispose(LItem);
  end;
end;

function TFieldInfoList.GetItem(AIndex: Integer): TFieldInfo;
var
  LItem: PFieldInfo;
begin
  LItem := inherited Items[AIndex];
  if Assigned(LItem) then
    Result := LItem^
  else
    Result := CreateSimpleFieldInfo({AFieldNumber:} -1, {AFieldForm:} '', {AFieldPosition:} -1);
end;

procedure TFieldInfoList.SetItem(AIndex: Integer; const AItem: TFieldInfo);
var
  LItem: PFieldInfo;
begin
  New(LItem);
  LItem^ := AItem;
  inherited Items[AIndex] := LItem;
end;

procedure TFieldInfoList.Assign(ASource: TFieldInfoList);
var
  LIndex: Integer;
begin
  if Assigned(ASource) and (ASource <> Self) then
  begin
    Clear;
    for LIndex := 0 to ASource.Count - 1 do
      Add(ASource.Items[LIndex]);
  end;
end;

procedure TFieldInfoList.Insert(AIndex: Integer; const AItem: TFieldInfo);
begin
  inherited Insert(AIndex, nil);
  SetItem(AIndex, AItem);
end;

function TFieldInfoList.Add(const AItem: TFieldInfo): Integer;
begin
  Result := inherited Add(nil);
  SetItem(Result, AItem);
end;

{ EFitsTableSpecException }

function EFitsTableSpecException.GetTopic: string;
begin
  Result := 'TABLESPEC';
end;

{ TFitsTableSpec }

procedure TFitsTableSpec.Init;
begin
  inherited;
  FFields := TFieldInfoList.Create;
end;

function TFitsTableSpec.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsTableSpecException;
end;

procedure TFitsTableSpec.CheckItem(AItem: TFitsItem);
begin
  if not Assigned(AItem) then
    Error(SItemNotAssigned, ERROR_TABLESPEC_CHECKITEM_NO_OBJECT);
  if not TFitsTable.ExtensionTypeIs(AItem) then
    Error(SSpecInvalidItem, ERROR_TABLESPEC_CHECKITEM_OBJECT);
end;

function TFitsTableSpec.GetBITPIX: TBitPix;
begin
  Result := DefaultBITPIX;
end;

function TFitsTableSpec.GetNAXIS: Integer;
begin
  Result := DefaultNAXIS;
end;

function TFitsTableSpec.ExtractNAXES1(AItem: TFitsItem): Integer;
var
  LProp: INAXES;
begin
  LProp := TFitsNAXES.Create({ANumber:} 1);
  if not ExtractProp(AItem, LProp) then
    Error(SHeadLineNotFound, [LProp.Keyword],
      ERROR_TABLESPEC_EXTRACTNAXES1_NOT_FOUND);
  Result := LProp.Value;
end;

procedure TFitsTableSpec.DoSetNAXES1(AProp: INAXES);
begin
  if not CorrectNAXES1(AProp.Value) then
    Error(SSpecIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLESPEC_SETNAXES1_VALUE);
end;

procedure TFitsTableSpec.SetNAXES1(AValue: Integer);
var
  LProp: INAXES;
begin
  LProp := TFitsNAXES.CreateValue({ANumber:} 1, AValue);
  DoSetNAXES1(LProp);
  FNAXES1 := LProp.Value;
end;

function TFitsTableSpec.ExtractNAXES2(AItem: TFitsItem): Integer;
var
  LProp: INAXES;
begin
  LProp := TFitsNAXES.Create({ANumber:} 2);
  if not ExtractProp(AItem, LProp) then
    Error(SHeadLineNotFound, [LProp.Keyword],
      ERROR_TABLESPEC_EXTRACTNAXES2_NOT_FOUND);
  Result := LProp.Value;
end;

procedure TFitsTableSpec.DoSetNAXES2(AProp: INAXES);
begin
  if not CorrectNAXES2(AProp.Value) then
    Error(SSpecIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLESPEC_SETNAXES2_VALUE);
end;

procedure TFitsTableSpec.SetNAXES2(AValue: Integer);
var
  LProp: INAXES;
begin
  LProp := TFitsNAXES.CreateValue({ANumber:} 2, AValue);
  DoSetNAXES2(LProp);
  FNAXES2 := LProp.Value;
end;

function TFitsTableSpec.GetPCOUNT: Integer;
begin
  Result := DefaultPCOUNT;
end;

function TFitsTableSpec.GetGCOUNT: Integer;
begin
  Result := DefaultGCOUNT;
end;

function TFitsTableSpec.ExtractTFIELDS(AItem: TFitsItem): Integer;
var
  LProp: ITFIELDS;
begin
  LProp := TFitsTFIELDS.Create;
  if not ExtractProp(AItem, LProp) then
    Error(SHeadLineNotFound, [LProp.Keyword],
      ERROR_TABLESPEC_EXTRACTTFIELDS_NOT_FOUND);
  Result := LProp.Value;
end;

function TFitsTableSpec.GetTFIELDS: Integer;
begin
  Result := FFields.Count;
end;

procedure TFitsTableSpec.DoSetTFIELDS(AProp: ITFIELDS);
begin
  if not CorrectTFIELDS(AProp.Value) then
    Error(SSpecIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLESPEC_SETTFIELDS_VALUE);
end;

procedure TFitsTableSpec.SetTFIELDS(AValue: Integer);
var
  LProp: ITFIELDS;
begin
  LProp := TFitsTFIELDS.CreateValue(AValue);
  DoSetTFIELDS(LProp);
  FFields.Count := LProp.Value;
end;

function TFitsTableSpec.ExtractTBCOL(AItem: TFitsItem; ANumber: Integer): Integer;
var
  LProp: ITBCOL;
begin
  LProp := TFitsTBCOL.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    Error(SHeadLineNotFound, [LProp.Keyword],
      ERROR_TABLESPEC_EXTRACTTBCOL_NOT_FOUND);
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTFORM(AItem: TFitsItem; ANumber: Integer): string;
var
  LProp: ITFORM;
begin
  LProp := TFitsTFORM.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    Error(SHeadLineNotFound, [LProp.Keyword],
      ERROR_TABLESPEC_EXTRACTTFORM_NOT_FOUND);
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTTYPE(AItem: TFitsItem; ANumber: Integer): string;
var
  LProp: ITTYPE;
begin
  LProp := TFitsTTYPE.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    ;
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTUNIT(AItem: TFitsItem; ANumber: Integer): string;
var
  LProp: ITUNIT;
begin
  LProp := TFitsTUNIT.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    ;
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTSCAL(AItem: TFitsItem; ANumber: Integer): Extended;
var
  LProp: ITSCAL;
begin
  LProp := TFitsTSCAL.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    LProp.Value := DefaultTSCAL;
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTZERO(AItem: TFitsItem; ANumber: Integer): Extended;
var
  LProp: ITZERO;
begin
  LProp := TFitsTZERO.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    LProp.Value := DefaultTZERO;
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTNULL(AItem: TFitsItem; ANumber: Integer): string;
var
  LProp: ITNULL;
begin
  LProp := TFitsTNULL.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    ;
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTDISP(AItem: TFitsItem; ANumber: Integer): string;
var
  LProp: ITDISP;
begin
  LProp := TFitsTDISP.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    ;
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTDMIN(AItem: TFitsItem; ANumber: Integer): TVariable;
var
  LProp: ITDMIN;
begin
  LProp := TFitsTDMIN.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    ;
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTDMAX(AItem: TFitsItem; ANumber: Integer): TVariable;
var
  LProp: ITDMAX;
begin
  LProp := TFitsTDMAX.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    ;
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTLMIN(AItem: TFitsItem; ANumber: Integer): TVariable;
var
  LProp: ITLMIN;
begin
  LProp := TFitsTLMIN.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    ;
  Result := LProp.Value;
end;

function TFitsTableSpec.ExtractTLMAX(AItem: TFitsItem; ANumber: Integer): TVariable;
var
  LProp: ITLMAX;
begin
  LProp := TFitsTLMAX.Create(ANumber);
  if not ExtractProp(AItem, LProp) then
    ;
  Result := LProp.Value;
end;

constructor TFitsTableSpec.Create(AItem: TFitsItem);
begin
  inherited Create;
  CheckItem(AItem);
  NAXES1 := ExtractNAXES1(AItem);
  NAXES2 := ExtractNAXES2(AItem);
  TFIELDS := ExtractTFIELDS(AItem);
  FillFields(AItem);
end;

constructor TFitsTableSpec.CreateNewForms(ANAXES1, ANAXES2: Integer; const ATFORMS: array of string);
begin
  inherited Create;
  NAXES1 := ANAXES1;
  NAXES2 := ANAXES2;
  TFIELDS := Length(ATFORMS);
  FillFields(ATFORMS);
end;

constructor TFitsTableSpec.CreateNewFields(ARecordSize, ARecordCount: Integer; const AFieldInfos: array of TFieldInfo);
begin
  inherited Create;
  RecordSize := ARecordSize;
  RecordCount := ARecordCount;
  FieldCount := Length(AFieldInfos);
  FillFields(AFieldInfos);
end;

destructor TFitsTableSpec.Destroy;
begin
  FFields.Free;
  inherited;
end;

procedure TFitsTableSpec.CheckNumber(ANumber, ACodeError: Integer);
begin
  if not InRange(ANumber, 1, FFields.Count) then
    Error(SFieldInfoIncorrectNumber, [ANumber], ACodeError);
end;

procedure TFitsTableSpec.CheckField(const AFieldInfo: TFieldInfo);

  procedure ErrorField(ACodeError: Integer);
  begin
    Error(SFieldInfoIncorrect, [FieldInfoToString(AFieldInfo)], ACodeError);
  end;

var
  LForm, LDisp: TFieldFormat;
begin
  if not InRange(AFieldInfo.FieldNumber, 1, cMaxFields) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDNUMBER);
  if not InRange(AFieldInfo.FieldPosition, 1, FNAXES1) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDPOSITION);
  if not CorrectTFORM(AFieldInfo.FieldForm) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDFORM);
  DecodeFieldFormat(AFieldInfo.FieldForm, {out} LForm);
  if not InSegmentBound(1, FNAXES1, AFieldInfo.FieldPosition, LForm.w) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDBOUNDS);
  if not CorrectTSCAL(AFieldInfo.FieldScal) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDSCAL);
  if not CorrectTZERO(AFieldInfo.FieldZero) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDZERO);
  if Length(AFieldInfo.FieldNull) > LForm.w then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDNULL);
  if not CorrectTDMIN(AFieldInfo.FieldDmin) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDDMIN);
  if not CorrectTDMAX(AFieldInfo.FieldDmax) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDDMAX);
  if not CorrectTLMIN(AFieldInfo.FieldLmin) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDLMIN);
  if not CorrectTLMAX(AFieldInfo.FieldLmax) then
    ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDLMAX);
  if AFieldInfo.FieldDisp <> '' then
  begin
    if not CorrectTDISP(AFieldInfo.FieldDisp) then
      ErrorField(ERROR_TABLESPEC_CHECKFIELD_FIELDDISP);
    DecodeFieldFormat(AFieldInfo.FieldDisp, {out} LDisp);
    if not CompatibleFieldFormat(LForm, LDisp) then
      ErrorField(ERROR_TABLESPEC_CHECKFIELD_UNDISPLAY);
  end;
end;

function TFitsTableSpec.GetField(ANumber: Integer): TFieldInfo;
begin
  CheckNumber(ANumber, ERROR_TABLESPEC_GETFIELD_NUMBER);
  Result := FFields[ANumber - 1];
end;

procedure TFitsTableSpec.SetField(ANumber: Integer; const AValue: TFieldInfo);
begin
  CheckNumber(ANumber, ERROR_TABLESPEC_SETFIELD_NUMBER);
  CheckField(AValue);
  FFields[ANumber - 1] := AValue;
end;

procedure TFitsTableSpec.FillFields(AItem: TFitsItem);
var
  LNumber: Integer;
  LField: TFieldInfo;
begin
  for LNumber := 1 to FFields.Count do
  begin
    LField.FieldNumber := LNumber;
    LField.FieldForm := ExtractTFORM(AItem, LNumber);
    LField.FieldPosition := ExtractTBCOL(AItem, LNumber);
    LField.FieldName := ExtractTTYPE(AItem, LNumber);
    LField.FieldUnit := ExtractTUNIT(AItem, LNumber);
    LField.FieldScal := ExtractTSCAL(AItem, LNumber);
    LField.FieldZero := ExtractTZERO(AItem, LNumber);
    LField.FieldNull := ExtractTNULL(AItem, LNumber);
    LField.FieldDmin := ExtractTDMIN(AItem, LNumber);
    LField.FieldDmax := ExtractTDMAX(AItem, LNumber);
    LField.FieldLmin := ExtractTLMIN(AItem, LNumber);
    LField.FieldLmax := ExtractTLMAX(AItem, LNumber);
    LField.FieldDisp := ExtractTDISP(AItem, LNumber);
    FieldInfos[LNumber] := LField;
  end;
end;

procedure TFitsTableSpec.FillFields(const ATFORMS: array of string);
var
  LNumber, LPosition: Integer;
  LForm: TFieldFormat;
  LField: TFieldInfo;
begin
  Assert(FFields.Count = Length(ATFORMS), SAssertionFailure);
  LPosition := 1;
  for LNumber := 1 to FFields.Count do
  begin
    LField.FieldNumber := LNumber;
    LField.FieldForm := ATFORMS[LNumber - 1];
    LField.FieldPosition := LPosition;
    LField.FieldName := 'COLUMN' + IntegerToString(LNumber);
    LField.FieldUnit := '';
    LField.FieldScal := DefaultTSCAL;
    LField.FieldZero := DefaultTZERO;
    LField.FieldNull := '';
    LField.FieldDmin := ClearVariable;
    LField.FieldDmax := ClearVariable;
    LField.FieldLmin := ClearVariable;
    LField.FieldLmax := ClearVariable;
    LField.FieldDisp := '';
    FieldInfos[LNumber] := LField;
    DecodeFieldFormat(LField.FieldForm, {out} LForm);
    LPosition := LPosition + LForm.w + 1;
  end;
end;

procedure TFitsTableSpec.FillFields(const AFieldInfos: array of TFieldInfo);
var
  LNumber: Integer;
begin
  Assert(FFields.Count = Length(AFieldInfos), SAssertionFailure);
  for LNumber := 1 to FFields.Count do
    FieldInfos[LNumber] := AFieldInfos[LNumber - 1];
end;

function CompareFieldInfoByNumber(AItem1, AItem2: Pointer): Integer;
var
  LItem1, LItem2: PFieldInfo;
begin
  LItem1 := AItem1;
  LItem2 := AItem2;
  if LItem1 = LItem2 then
    Result := 0
  else if Assigned(LItem1) and (not Assigned(LItem2)) then
    Result := 1
  else if (not Assigned(LItem1)) and Assigned(LItem2) then
    Result := -1
  else
    Result := CompareValue(LItem1^.FieldNumber, LItem2^.FieldNumber);
end;

procedure TFitsTableSpec.SortFields(APretty: Boolean);
var
  LNumber, LPosition, LGap, LNAXES1: Integer;
  LFields: TFieldInfoList;
  LField: TFieldInfo;
  LForm: TFieldFormat;
begin
  LFields := TFieldInfoList.Create;
  try
    LFields.Assign(FFields);
    LFields.Sort(@CompareFieldInfoByNumber);
    LPosition := 1;
    LGap := IfThen(APretty, 1, 0);
    for LNumber := 1 to FFields.Count do
    begin
      LField := LFields[LNumber - 1];
      LField.FieldNumber := LNumber;
      LField.FieldPosition := LPosition;
      LFields[LNumber - 1] := LField;
      if DecodeFieldFormat(LField.FieldForm, {out} LForm) = 0 then
        Error(SFieldInfoIncorrectForm, [LField.FieldForm],
          ERROR_TABLESPEC_SORTFIELDS_UNFORM);
      LPosition := LPosition + LForm.w + LGap;
    end;
    FFields.Assign(LFields);
    // Set the optimal record size
    LNAXES1 := LPosition - LGap - 1;
    if CorrectNAXES1(LNAXES1) then
      FNAXES1 := LNAXES1;
  finally
    LFields.Free;
  end;
end;

procedure TFitsTableSpec.ExchangeFields(ANumber1, ANumber2: Integer);
begin
  CheckNumber(ANumber1, ERROR_TABLESPEC_EXCHANGEFIELDS_NUMBER);
  CheckNumber(ANumber2, ERROR_TABLESPEC_EXCHANGEFIELDS_NUMBER);
  FFields.Exchange(ANumber1 - 1, ANumber2 - 1);
end;

procedure TFitsTableSpec.MoveFields(ACurNumber, ANewNumber: Integer);
begin
  CheckNumber(ACurNumber, ERROR_TABLESPEC_MOVEFIELDS_NUMBER);
  CheckNumber(ANewNumber, ERROR_TABLESPEC_MOVEFIELDS_NUMBER);
  FFields.Move(ACurNumber - 1, ANewNumber - 1);
end;

procedure TFitsTableSpec.DeleteField(ANumber: Integer);
begin
  CheckNumber(ANumber, ERROR_TABLESPEC_DELETEFIELD_NUMBER);
  FFields.Delete(ANumber - 1);
end;

procedure TFitsTableSpec.InsertField(ANumber: Integer; const AFieldInfo: TFieldInfo);
begin
  if not InRange(ANumber, 1, FFields.Count + 1) then
    Error(SFieldInfoIncorrectNumber, [ANumber],
      ERROR_TABLESPEC_INSERTFIELD_NUMBER);
  CheckField(AFieldInfo);
  FFields.Insert(ANumber - 1, AFieldInfo);
end;

function TFitsTableSpec.AddField(const AFieldInfo: TFieldInfo): Integer;
begin
  CheckField(AFieldInfo);
  Result := FFields.Add(AFieldInfo) + 1;
end;

{ EFitsTableHeadException }

function EFitsTableHeadException.GetTopic: string;
begin
  Result := 'TABLEHEAD';
end;

{ TFitsTableHead }

function TFitsTableHead.GetItem: TFitsTable;
begin
  Result := inherited Item as TFitsTable;
end;

function TFitsTableHead.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsTableHeadException;
end;

procedure TFitsTableHead.CustomizeNew(ASpec: TFitsItemSpec);

  procedure ErrorProp(AProp: IFitsPropContext; ACodeError: Integer);
  begin
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue], ACodeError);
  end;

  procedure PushProp(var ALines: string; AProp: IFitsPropContext; AAppend: Boolean = True);
  var
    LIndex: Integer;
  begin
    if AAppend then
      ALines := ALines + AProp.NewLine;
    LIndex := LineIndexOfKeyword(AProp.Keyword);
    if LIndex >= 0 then
      DeleteLines(LIndex, {ACount:} 1);
  end;

var
  LSpec: TFitsTableSpec;
  LLines: string;
  LNumber: Integer;
  LDisplay: Boolean;
  LForm, LDisp: TFieldFormat;
  LFieldInfo: TFieldInfo;
  LBITPIX: IBITPIX;
  LNAXIS: INAXIS;
  LNAXES: INAXES;
  LPCOUNT: IPCOUNT;
  LGCOUNT: IGCOUNT;
  LTFIELDS: ITFIELDS;
  LTBCOL: ITBCOL;
  LTFORM: ITFORM;
  LTTYPE: ITTYPE;
  LTUNIT: ITUNIT;
  LTSCAL: ITSCAL;
  LTZERO: ITZERO;
  LTNULL: ITNULL;
  LTDISP: ITDISP;
  LTDMIN: ITDMIN;
  LTDMAX: ITDMAX;
  LTLMIN: ITLMIN;
  LTLMAX: ITLMAX;
begin
  inherited;
  LSpec := ASpec as TFitsTableSpec;
  LLines := '';
  // BITPIX
  LBITPIX := TFitsBITPIX.CreateValue(LSpec.BITPIX);
  PushProp({var} LLines, LBITPIX);
  // NAXIS
  LNAXIS := TFitsNAXIS.CreateValue(LSpec.NAXIS);
  PushProp({var} LLines, LNAXIS);
  // NAXES1
  LNAXES := TFitsNAXES.CreateValue({AKeywordNumber:} 1, LSpec.NAXES1);
  if not CorrectNAXES1(LNAXES.Value) then
    ErrorProp(LNAXES, ERROR_TABLEHEAD_CUSTOMIZENEW_NAXES1_VALUE);
  PushProp({var} LLines, LNAXES);
  // NAXES2
  LNAXES := TFitsNAXES.CreateValue({AKeywordNumber:} 2, LSpec.NAXES2);
  if not CorrectNAXES2(LNAXES.Value) then
    ErrorProp(LNAXES, ERROR_TABLEHEAD_CUSTOMIZENEW_NAXES2_VALUE);
  PushProp({var} LLines, LNAXES);
  // PCOUNT
  LPCOUNT := TFitsPCOUNT.CreateValue(LSpec.PCOUNT);
  PushProp({var} LLines, LPCOUNT);
  // GCOUNT
  LGCOUNT := TFitsGCOUNT.CreateValue(LSpec.GCOUNT);
  PushProp({var} LLines, LGCOUNT);
  // TFIELDS
  LTFIELDS := TFitsTFIELDS.CreateValue(LSpec.TFIELDS);
  if not CorrectTFIELDS(LTFIELDS.Value) then
    ErrorProp(LTFIELDS, ERROR_TABLEHEAD_CUSTOMIZENEW_TFIELDS_VALUE);
  PushProp({var} LLines, LTFIELDS);
  // Fileds. Preferred keyword order: cTTYPEn, cTBCOLn, cTFORMn, cTUNITn,
  // cTSCALn, cTZEROn, cTNULLn, cTDISPn, cTDMINn, cTDMAXn, cTLMINn, cTLMAXn
  for LNumber := 1 to LSpec.FieldCount do
  begin
    LFieldInfo := LSpec.FieldInfos[LNumber];
    if not InRange(LFieldInfo.FieldNumber, 1, LSpec.FieldCount) then
      Error(SFieldInfoIncorrectNumber, [LFieldInfo.FieldNumber],
        ERROR_TABLEHEAD_CUSTOMIZENEW_FIELDNUMBER);
    // TTYPE
    LTTYPE := TFitsTTYPE.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldName);
    PushProp({var} LLines, LTTYPE, {AAppend:} LTTYPE.Value <> '');
    // TBCOL
    LTBCOL := TFitsTBCOL.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldPosition);
    if not InRange(LTBCOL.Value, 1, LSpec.NAXES1) then
      ErrorProp(LTBCOL, ERROR_TABLEHEAD_CUSTOMIZENEW_TBCOL_VALUE);
    PushProp({var} LLines, LTBCOL);
    // TFORM
    LTFORM := TFitsTFORM.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldForm);
    if not CorrectTFORM(LTFORM.Value) then
      ErrorProp(LTFORM, ERROR_TABLEHEAD_CUSTOMIZENEW_TFORM_VALUE);
    DecodeFieldFormat(LTFORM.Value, {out} LForm);
    if not InSegmentBound(1, LSpec.NAXES1, LTBCOL.Value, LForm.w) then
      ErrorProp(LTFORM, ERROR_TABLEHEAD_CUSTOMIZENEW_TFORM_BOUNDS);
    PushProp({var} LLines, LTFORM);
    // TUNIT
    LTUNIT := TFitsTUNIT.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldUnit);
    PushProp({var} LLines, LTUNIT, {AAppend:} LTUNIT.Value <> '');
    // TSCAL
    LTSCAL := TFitsTSCAL.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldScal);
    if not CorrectTSCAL(LTSCAL.Value) then
      ErrorProp(LTBCOL, ERROR_TABLEHEAD_CUSTOMIZENEW_TSCAL_VALUE);
    PushProp({var} LLines, LTSCAL, {AAppend:} not SameValue(LTSCAL.Value, DefaultTSCAL));
    // TZERO
    LTZERO := TFitsTZERO.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldZero);
    if not CorrectTZERO(LTZERO.Value) then
      ErrorProp(LTZERO, ERROR_TABLEHEAD_CUSTOMIZENEW_TZERO_VALUE);
    PushProp({var} LLines, LTZERO, {AAppend:} not SameValue(LTZERO.Value, DefaultTZERO));
    // TNULL
    LTNULL := TFitsTNULL.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldNull);
    if Length(LTNULL.Value) > LForm.w then
      ErrorProp(LTNULL, ERROR_TABLEHEAD_CUSTOMIZENEW_TNULL_VALUE);
    PushProp({var} LLines, LTNULL, {AAppend:} LTNULL.Value <> '');
    // TDISP
    LTDISP := TFitsTDISP.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldDisp);
    LDisplay := (LTDISP.Value <> '') and (LTDISP.Value <> LTFORM.Value);
    if LDisplay then
    begin
      if not CorrectTDISP(LTDISP.Value) then
        ErrorProp(LTDISP, ERROR_TABLEHEAD_CUSTOMIZENEW_TDISP_VALUE);
      DecodeFieldFormat(LTDISP.Value, {out} LDisp);
      if not CompatibleFieldFormat(LForm, LDisp) then
        ErrorProp(LTDISP, ERROR_TABLEHEAD_CUSTOMIZENEW_TDISP_INCOMP);
    end;
    PushProp({var} LLines, LTDISP, {AAppend:} LDisplay);
    // TDMIN
    LTDMIN := TFitsTDMIN.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldDmin);
    if not CorrectTDMIN(LTDMIN.Value) then
      ErrorProp(LTDMIN, ERROR_TABLEHEAD_CUSTOMIZENEW_TDMIN_VALUE);
    PushProp({var} LLines, LTDMIN, {AAppend:} LTDMIN.Value.VarType > vtNone);
    // TDMAX
    LTDMAX := TFitsTDMAX.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldDmax);
    if not CorrectTDMAX(LTDMAX.Value) then
      ErrorProp(LTDMAX, ERROR_TABLEHEAD_CUSTOMIZENEW_TDMAX_VALUE);
    PushProp({var} LLines, LTDMAX, {AAppend:} LTDMAX.Value.VarType > vtNone);
    // TLMIN
    LTLMIN := TFitsTLMIN.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldLmin);
    if not CorrectTLMIN(LTLMIN.Value) then
      ErrorProp(LTLMIN, ERROR_TABLEHEAD_CUSTOMIZENEW_TLMIN_VALUE);
    PushProp({var} LLines, LTLMIN, {AAppend:} LTLMIN.Value.VarType > vtNone);
    // TLMAX
    LTLMAX := TFitsTLMAX.CreateValue(LFieldInfo.FieldNumber, LFieldInfo.FieldLmax);
    if not CorrectTLMAX(LTLMAX.Value) then
      ErrorProp(LTLMAX, ERROR_TABLEHEAD_CUSTOMIZENEW_TLMAX_VALUE);
    PushProp({var} LLines, LTLMAX, {AAppend:} LTLMAX.Value.VarType > vtNone);
  end;
  // Insert new keyword records
  InsertLines({AIndex:} 1, LLines);
end;

{ EFitsTableDataException }

function EFitsTableDataException.GetTopic: string;
begin
  Result := 'TABLEDATA';
end;

{ TFitsTableData }

procedure TFitsTableData.Init;
begin
  inherited;
  FRecordCursor := cRecordIndexNull;
  FRecordState := trsInactive;
end;

function TFitsTableData.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsTableDataException;
end;

procedure TFitsTableData.CustomizeNew(ASpec: TFitsItemSpec);
var
  LSpec: TFitsTableSpec;
  LIndex, LCount, LRecordSize, LBufferCount: Integer;
  LCleanRecord, LBuffer: string;
begin
  inherited;
  LSpec := ASpec as TFitsTableSpec;
  if LSpec.ClearRecords and (RecordCount > 0) then
  begin
    // Prepare a clean record
    LRecordSize := RecordSize;
    AddRecord;
    LCleanRecord := RecordBuffer;
    CloseRecord;
    // Prepare a rows buffer
    LCount := cMaxSizeBuffer div LRecordSize;
    LCount := EnsureRange(1, RowCount, LCount);
    LBuffer := '';
    for LIndex := 1 to LCount do
      LBuffer := LBuffer + LCleanRecord;
    // Rewrite rows
    LIndex := 0;
    LCount := RowCount;
    while LCount > 0 do
    begin
      LBufferCount := Length(LBuffer) div LRecordSize;
      if LCount < LBufferCount then
      begin
        LBufferCount := LCount;
        LBuffer := Copy(LBuffer, 1, LBufferCount * LRecordSize);
      end;
      WriteRows(LIndex, LBuffer);
      Inc(LIndex, LBufferCount);
      Dec(LCount, LBufferCount);
    end;
  end;
end;

function TFitsTableData.Filler: Char;
begin
  Result := cChrBlank;
end;

destructor TFitsTableData.Destroy;
begin
  FreeFields;
  inherited;
end;

function TFitsTableData.GetItem: TFitsTable;
begin
  Result := inherited Item as TFitsTable;
end;

function TFitsTableData.GetRowSize: Integer;
begin
  Result := Item.GetNAXES(1);
end;

function TFitsTableData.GetRowCount: Integer;
begin
  Result := Item.GetNAXES(2);
end;

procedure TFitsTableData.SetRowCount(AValue: Integer);
var
  LIndex: Integer;
  LProp: INAXES;
begin
  // Set new size of the data content
  Size := Int64(AValue) * GetRowSize;
  // Update the header keyword record about the number of table rows
  LProp := TFitsNAXES.CreateValue({AKeywordNumber:} 2, AValue);
  LIndex := Item.Head.LineIndexOfKeyword(LProp.Keyword);
  Item.Head.Lines[LIndex] := LProp.NewLine;
end;

procedure TFitsTableData.CheckRows(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
var
  LArgIndex, LArgCount, LArgSize, LRowCount, LRowSize: Integer;
begin
  if ACheck = 'bounds' then
  begin
    LArgIndex := AArgs[0].VInteger;
    LArgCount := AArgs[1].VInteger;
    LRowCount := GetRowCount;
    if not InSegmentBound({ASegmentPosition:} 0, LRowCount, LArgIndex, LArgCount) then
      Error(STableDataRowsRangeOutBounds, [LArgIndex, LArgCount, LRowCount], ACodeError);
  end else
  if ACheck = 'index' then
  begin
    LArgIndex := AArgs[0].VInteger;
    LRowCount := GetRowCount;
    if not InSegmentBound({ASegmentPosition:} 0, LRowCount, LArgIndex) then
      Error(STableDataRowsIndexOutBounds, [LArgIndex, LRowCount], ACodeError);
  end else
  if ACheck = 'index.new' then
  begin
    LArgIndex := AArgs[0].VInteger;
    LRowCount := GetRowCount;
    if not InSegmentBound({ASegmentPosition:} 0, LRowCount + Int64(1), LArgIndex) then
      Error(STableDataRowsIndexOutBounds, [LArgIndex, LRowCount], ACodeError);
  end else
  if ACheck = 'size' then
  begin
    LArgSize := AArgs[0].VInteger;
    LRowSize := GetRowSize;
    if (LArgSize < LRowSize) or ((LArgSize mod LRowSize) <> 0) then
      Error(STableDataRowsInvalidSize, [LArgSize, LRowSize], ACodeError);
  end else
    Assert(False, SAssertionFailureArgs(AArgs));
end;

function TFitsTableData.GetRow(AIndex: Integer): string;
begin
  Result := '';
  ReadRows(AIndex, {ACount:} 1, {var} Result);
end;

procedure TFitsTableData.SetRow(AIndex: Integer; const ARow: string);
var
  LRow: string;
begin
  // Only one row can be overwritten
  if Length(ARow) > RowSize then
    LRow := Copy(ARow, 1, RowSize)
  else
    LRow := ARow;
  WriteRows(AIndex, LRow);
end;

procedure TFitsTableData.ReadRows(AIndex, ACount: Integer; var ARows: string);
var
  LOffset, LSize: Int64;
  LBuffer: AnsiString;
begin
  CheckRows('bounds', [AIndex, ACount], ERROR_TABLEDATA_READROWS_BOUNDS);
  LSize := Int64(ACount) * GetRowSize;
  LOffset := Int64(AIndex) * GetRowSize;
  LBuffer := '';
  SetLength(LBuffer, ACount * GetRowSize);
  ReadChunk(LOffset, LSize, {var} LBuffer[1]);
  ARows := string(LBuffer);
end;

procedure TFitsTableData.WriteRows(AIndex: Integer; const ARows: string);
var
  LOffset, LSize: Int64;
  LBuffer: AnsiString;
begin
  CheckRows('size', [Integer(Length(ARows))], ERROR_TABLEDATA_WRITEROWS_SIZE);
  CheckRows('bounds', [AIndex, Integer(Length(ARows) div GetRowSize)], ERROR_TABLEDATA_WRITEROWS_BOUNDS);
  LSize := Length(ARows);
  LOffset := Int64(AIndex) * GetRowSize;
  LBuffer := AnsiString(ARows);
  WriteChunk(LOffset, LSize, LBuffer[1]);
end;

procedure TFitsTableData.ExchangeRows(AIndex1, AIndex2: Integer);
var
  LOffset1, LOffset2, LSize: Int64;
begin
  CheckRows('index', [AIndex1], ERROR_TABLEDATA_EXCHANGEROWS_INDEX);
  CheckRows('index', [AIndex2], ERROR_TABLEDATA_EXCHANGEROWS_INDEX);
  LSize := GetRowSize;
  LOffset1 := Int64(AIndex1) * LSize;
  LOffset2 := Int64(AIndex2) * LSize;
  ExchangeChunk({var} LOffset1, LSize, {var} LOffset2, LSize);
end;

procedure TFitsTableData.MoveRows(ACurIndex, ANewIndex: Integer);
var
  LCurOffset, LNewOffset, LSize: Int64;
begin
  CheckRows('index', [ACurIndex], ERROR_TABLEDATA_MOVEROWS_INDEX);
  CheckRows('index', [ANewIndex], ERROR_TABLEDATA_MOVEROWS_INDEX);
  LSize := GetRowSize;
  LCurOffset := Int64(ACurIndex) * LSize;
  LNewOffset := Int64(ANewIndex) * LSize;
  // Correction for moving the row "down"
  if ACurIndex < ANewIndex then
    LNewOffset := LNewOffset + LSize - 1;
  MoveChunk(LCurOffset, LSize, {var} LNewOffset);
end;

procedure TFitsTableData.DeleteRows(AIndex, ACount: Integer);
var
  LOffset, LNewOffset, LSize: Int64;
begin
  CheckRows('bounds', [AIndex, ACount], ERROR_TABLEDATA_DELETEROWS_BOUNDS);
  // Move up the meaningful data content
  LOffset := (Int64(AIndex) + ACount) * GetRowSize;
  LSize := InternalSize - LOffset;
  if LSize > 0 then
  begin
    LNewOffset := Int64(AIndex) * GetRowSize;
    MoveChunk(LOffset, LSize, {var} LNewOffset);
  end;
  // Resize table
  SetRowCount(RowCount - ACount);
end;

procedure TFitsTableData.InsertRows(AIndex: Integer; const ARows: string);
var
  LOffset, LNewOffset, LSize: Int64;
  LCount: Integer;
  LBuffer: AnsiString;
begin
  CheckRows('size', [Integer(Length(ARows))], ERROR_TABLEDATA_INSERTROWS_SIZE);
  CheckRows('index.new', [AIndex], ERROR_TABLEDATA_INSERTROWS_INDEX);
  LOffset := InternalSize;
  LSize := Length(ARows);
  LNewOffset := Int64(AIndex) * GetRowSize;
  // Resize table
  LCount := Length(ARows) div GetRowSize;
  SetRowCount(RowCount + LCount);
  // Move up the new data content
  if LNewOffset <> LOffset then
    MoveChunk(LOffset, LSize, {var} LNewOffset);
  // Put new data content
  LBuffer := AnsiString(ARows);
  WriteChunk(LNewOffset, LSize, LBuffer[1]);
end;

function TFitsTableData.AddRows(const ARows: string): Integer;
begin
  Result := GetRowCount;
  InsertRows(Result, ARows);
end;

procedure TFitsTableData.CheckFields(const ACheck: string; const AArgs: array of const; ACodeError: Integer);
var
  LArgNumber, LFieldIndex, LFieldCount: Integer;
  LArgClass: TClass;
begin
  if ACheck = 'number' then
  begin
    LArgNumber := AArgs[0].VInteger;
    LFieldIndex := LArgNumber - 1;
    LFieldCount := GetFieldCount;
    if not InSegmentBound({ASegmentPosition:} 0, LFieldCount, LFieldIndex) then
      Error(STableDataFieldNumberOutBounds, [LArgNumber, LFieldCount], ACodeError);
  end else
  if ACheck = 'class' then
  begin
    LArgClass := AArgs[0].VClass;
    LArgNumber := AArgs[1].VInteger;
    if not Assigned(LArgClass) then
      Error(STableDataFieldClassUndefined, [LArgNumber], ACodeError);
  end else
    Assert(False, SAssertionFailureArgs(AArgs));
end;

function TFitsTableData.CalcFieldClass(ANumber: Integer): TFitsFieldClass;
var
  LFieldFormat: string;
  LFieldCode: Char;
begin
  LFieldFormat := Item.GetTFORM(ANumber);
  if LFieldFormat = '' then
    LFieldCode := '?'
  else
    LFieldCode := LFieldFormat[1];
  case LFieldCode of
    'A': Result := TFitsStringField;
    'I': Result := TFitsIntegerField;
    'F', 'E', 'D': Result := TFitsFloatField;
  else
    Result := nil;
  end;
end;

procedure TFitsTableData.MakeFields(AForce: Boolean);
var
  LNumber, LFieldCount: Integer;
  LFieldClass: TFitsFieldClass;
begin
  LFieldCount := GetFieldCount;
  if AForce or (Length(FFields) <> LFieldCount) then
  begin
    FreeFields;
    if Length(FFields) < LFieldCount then
    begin
      SetLength(FFields, LFieldCount);
      for LNumber := 1 to Length(FFields) do
        FFields[LNumber - 1] := nil;
    end;
    for LNumber := 1 to LFieldCount do
    begin
      LFieldClass := CalcFieldClass(LNumber);
      CheckFields('class', [LFieldClass, LNumber],
        ERROR_TABLEDATA_MAKEFIELDS_CLASS);
      FFields[LNumber - 1] := LFieldClass.Create(GetFieldHandle(LNumber));
    end;
  end;
end;

procedure TFitsTableData.FreeFields;
var
  LIndex: Integer;
begin
  for LIndex := Low(FFields) to High(FFields) do
  begin
    FFields[LIndex].Free;
    FFields[LIndex] := nil;
  end;
end;

function TFitsTableData.GetFieldCount: Integer;
begin
  Result := Item.GetTFIELDS;
end;

function TFitsTableData.GetFieldInfo(ANumber: Integer): TFieldInfo;
begin
  CheckFields('number', [ANumber], ERROR_TABLEDATA_GETFIELDINFO_NUMBER);
  Result.FieldNumber := ANumber;
  Result.FieldForm := Item.GetTFORM(ANumber);
  Result.FieldPosition := Item.GetTBCOL(ANumber);
  Result.FieldName := Item.GetTTYPE(ANumber);
  Result.FieldUnit := Item.GetTUNIT(ANumber);
  Result.FieldScal := Item.GetTSCAL(ANumber);
  Result.FieldZero := Item.GetTZERO(ANumber);
  Result.FieldNull := Item.GetTNULL(ANumber);
  Result.FieldDmin := Item.GetTDMIN(ANumber);
  Result.FieldDmax := Item.GetTDMAX(ANumber);
  Result.FieldLmin := Item.GetTLMIN(ANumber);
  Result.FieldLmax := Item.GetTLMAX(ANumber);
  Result.FieldDisp := Item.GetTDISP(ANumber);
end;

function TFitsTableData.GetFieldHandle(ANumber: Integer): TFieldHandle;
begin
  // Internal use method
  Result.FieldNumber := ANumber;
  Result.FieldSource := Item;
end;

function TFitsTableData.GetFieldClass(ANumber: Integer): TFitsFieldClass;
begin
  CheckFields('number', [ANumber], ERROR_TABLEDATA_GETFIELDCLASS_NUMBER);
  MakeFields;
  Result := TFitsFieldClass(FFields[ANumber - 1].ClassType);
end;

procedure TFitsTableData.SetFieldClass(ANumber: Integer; AFieldClass: TFitsFieldClass);
var
  LCurrentField: TFitsField;
begin
  CheckFields('number', [ANumber], ERROR_TABLEDATA_SETFIELDCLASS_NUMBER);
  CheckFields('class', [AFieldClass, ANumber], ERROR_TABLEDATA_SETFIELDCLASS_CLASS);
  MakeFields;
  LCurrentField := FFields[ANumber - 1];
  FFields[ANumber - 1] := AFieldClass.Create(GetFieldHandle(ANumber));
  LCurrentField.Free;
end;

function TFitsTableData.GetField(ANumber: Integer): TFitsField;
begin
  CheckFields('number', [ANumber], ERROR_TABLEDATA_GETFIELD_NUMBER);
  MakeFields;
  Result := FFields[ANumber - 1];
end;

procedure TFitsTableData.RefreshFields;
begin
  MakeFields({AForce:} True);
end;

function TFitsTableData.FindField(const AFieldName: string): TFitsField;
var
  LNumber: Integer;
  LFieldName: string;
begin
  Result := nil;
  LFieldName := Trim(AFieldName);
  if LFieldName <> '' then
    for LNumber := 1 to FieldCount do
      if SameText(LFieldName, Item.GetTTYPE(LNumber)) then
      begin
        Result := GetField(LNumber);
        Break;
      end;
end;

function TFitsTableData.GetRecordCount: Integer;
begin
  Result := GetRowCount;
  if FRecordState = trsInsert then
    Inc(Result);
end;

function TFitsTableData.GetRecordActive: Boolean;
begin
  Result := FRecordState > trsInactive;
end;

function TFitsTableData.GetRecordModified: Boolean;
begin
  Result := FRecordState > trsBrowse;
end;

function TFitsTableData.GetRecordValue(AFieldPosition, AFieldWidth: Integer): string;
begin
  // Method is used by the field object
  if FRecordState = trsInactive then
    Error(STableDataRecordValueInactive, ERROR_TABLEDATA_GETRECORDVALUE_STATE);
  Result := Copy(FRecordBuffer, AFieldPosition, AFieldWidth);
end;

procedure TFitsTableData.SetRecordValue(AFieldPosition, AFieldWidth: Integer; const AValue: string);
begin
  // Method is used by the field object
  if FRecordState = trsInactive then
    Error(STableDataRecordValueInactive, ERROR_TABLEDATA_SETRECORDVALUE_STATE);
  FRecordBuffer := Copy(FRecordBuffer, 1, AFieldPosition - 1) +
    AValue + Copy(FRecordBuffer, AFieldPosition + AFieldWidth,
      Length(FRecordBuffer) - AFieldPosition - AFieldWidth + 1);
  if FRecordState = trsBrowse then
    FRecordState := trsEdit;
end;

procedure TFitsTableData.SetRecordBuffer(const ARecordBuffer: string);
begin
  if Length(ARecordBuffer) <> RecordSize then
    Error(STableDataRecordInvalidSize, [Length(ARecordBuffer), RecordSize],
      ERROR_TABLEDATA_SETRECORDBUFFER_SIZE);
  FRecordBuffer := ARecordBuffer;
  case FRecordState of
    trsInactive:
      begin
        FRecordCursor := RowCount;
        FRecordState := trsInsert;
      end;
    trsBrowse:
      begin
        FRecordState := trsEdit;
      end;
  end;
end;

procedure TFitsTableData.RefreshRecord;
var
  LNewIndex: Integer;
begin
  LNewIndex := Min(FRecordCursor, RowCount - 1);
  if LNewIndex < 0 then
    CloseRecord
  else
    OpenRecord(LNewIndex);
end;

procedure TFitsTableData.OpenRecord(AIndex: Integer);
begin
  // Open (activate) an existing record by index. Current changes will be lost
  FRecordBuffer := GetRow(AIndex);
  FRecordCursor := AIndex;
  FRecordState := trsBrowse;
end;

procedure TFitsTableData.DeleteRecord;
begin
  // Deletes the active record and sets the cursor on the next record
  case FRecordState of
    trsInactive:
      Error(STableDataRecordCannotDelete, ERROR_TABLEDATA_DELETERECORD_STATE);
    trsBrowse, trsEdit:
      DeleteRows(FRecordCursor, {ACount:} 1);
  end;
  RefreshRecord;
end;

procedure TFitsTableData.InsertRecord(AIndex: Integer);
var
  LNumber: Integer;
begin
  // Create and activate a new record. Current changes will be lost
  if not InSegmentBound({ASegmentPosition:} 0, RowCount + Int64(1), AIndex) then
    Error(STableDataRecordIndexOutBounds, [AIndex, RowCount],
      ERROR_TABLEDATA_INSERTRECORD_INDEX);
  FRecordBuffer := BlankString(RowSize);
  FRecordCursor := AIndex;
  FRecordState := trsInsert;
  for LNumber := 1 to FieldCount do
    Fields[LNumber].ClearValue;
end;

procedure TFitsTableData.AddRecord;
begin
  InsertRecord(RowCount);
end;

procedure TFitsTableData.PostRecord;
begin
  case FRecordState of
    trsInactive, trsBrowse:
      Error(STableDataRecordCannotPost, ERROR_TABLEDATA_POSTRECORD_STATE);
    trsEdit:
      Rows[FRecordCursor] := FRecordBuffer;
    trsInsert:
      InsertRows(FRecordCursor, FRecordBuffer);
  end;
  FRecordState := trsBrowse;
end;

procedure TFitsTableData.CancelRecord;
begin
  RefreshRecord;
end;

procedure TFitsTableData.CloseRecord;
begin
  FRecordBuffer := '';
  FRecordCursor := cRecordIndexNull;
  FRecordState := trsInactive;
end;

{ EFitsTableException }

function EFitsTableException.GetTopic: string;
begin
  Result := 'TABLE';
end;

{ TFitsTable }

function TFitsTable.GetHead: TFitsTableHead;
begin
  Result := inherited Head as TFitsTableHead;
end;

function TFitsTable.GetData: TFitsTableData;
begin
  Result := inherited Data as TFitsTableData;
end;

function TFitsTable.GetHeadClass: TFitsItemHeadClass;
begin
  Result := TFitsTableHead;
end;

function TFitsTable.GetDataClass: TFitsItemDataClass;
begin
  Result := TFitsTableData;
end;

function TFitsTable.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsTableException;
end;

constructor TFitsTable.CreateNew(AContainer: TFitsContainer; ASpec: TFitsItemSpec);
begin
  if not Assigned(ASpec) then
    Error(SSpecNotAssigned, ERROR_TABLE_CREATENEW_NO_SPEC);
  if not (ASpec is TFitsTableSpec) then
    Error(SSpecInvalidClass, [ASpec.ClassName],
      ERROR_TABLE_CREATENEW_INVALID_CLASS_SPEC);
  inherited CreateNew(AContainer, ASpec);
end;

class function TFitsTable.ExtensionType: string;
begin
  Result := 'TABLE';
end;

class function TFitsTable.ExtensionTypeIs(AItem: TFitsItem): Boolean;

  function FindItemHeadRecord(const AKeyword: string; var LRecord: TLineRecord): Boolean;
  var
    LIndex: Integer;
  begin
    LIndex := AItem.Head.LineIndexOfKeyword(AKeyword);
    if LIndex >= 0 then
      LRecord := AItem.Head.LineRecords[LIndex];
    Result := LIndex >= 0;
  end;

var
  LRecord: TLineRecord;
  LBITPIX: TBitPix;
  LNAXIS, LNAXES, LPCOUNT, LGCOUNT: Integer;
begin
  Result := inherited ExtensionTypeIs(AItem);
  // Check the mandatory keyword records that define the size of the data section
  LRecord := EmptyLineRecord;
  Result := Result and FindItemHeadRecord(cBITPIX, {var} LRecord) and
    TryStringToBitPix(LRecord.Value, LBITPIX) and CorrectBITPIX(LBITPIX);
  Result := Result and FindItemHeadRecord(cNAXIS, {var} LRecord) and
    TryStringToInteger(LRecord.Value, LNAXIS) and CorrectNAXIS(LNAXIS);
  Result := Result and FindItemHeadRecord(cNAXIS1, {var} LRecord) and
    TryStringToInteger(LRecord.Value, LNAXES) and CorrectNAXES1(LNAXES);
  Result := Result and FindItemHeadRecord(cNAXIS2, {var} LRecord) and
    TryStringToInteger(LRecord.Value, LNAXES) and CorrectNAXES2(LNAXES);
  if Result and FindItemHeadRecord(cPCOUNT, {var} LRecord) then
    Result := TryStringToInteger(LRecord.Value, LPCOUNT) and CorrectPCOUNT(LPCOUNT);
  if Result and FindItemHeadRecord(cGCOUNT, {var} LRecord) then
    Result := TryStringToInteger(LRecord.Value, LGCOUNT) and CorrectGCOUNT(LGCOUNT);
end;

procedure TFitsTable.CheckFieldBounds(AProp: IFitsPropContext; ACodeError: Integer);
var
  LMaxNumber: Integer;
begin
  LMaxNumber := GetTFIELDS;
  if not InRange(AProp.KeywordNumber, 1, LMaxNumber) then
    Error(SPropFieldOutBounds, [AProp.Keyword, LMaxNumber], ACodeError);
end;

procedure TFitsTable.DoGetBITPIX(AProp: IBITPIX);
begin
  inherited;
  if not CorrectBITPIX(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETBITPIX_VALUE);
end;

procedure TFitsTable.DoGetNAXIS(AProp: INAXIS);
begin
  inherited;
  if not CorrectNAXIS(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETNAXIS_VALUE);
end;

procedure TFitsTable.DoGetNAXES(AProp: INAXES);
var
  LCorrect: Boolean;
begin
  inherited;
  case AProp.KeywordNumber of
    1: LCorrect := CorrectNAXES1(AProp.Value);
    2: LCorrect := CorrectNAXES2(AProp.Value);
  else
    LCorrect := False;
  end;
  if not LCorrect then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETNAXES_VALUE);
end;

procedure TFitsTable.DoGetPCOUNT(AProp: IPCOUNT);
begin
  inherited;
  if not CorrectPCOUNT(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETPCOUNT_VALUE);
end;

procedure TFitsTable.DoGetGCOUNT(AProp: IGCOUNT);
begin
  inherited;
  if not CorrectGCOUNT(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETGCOUNT_VALUE);
end;

procedure TFitsTable.DoGetTFIELDS(AProp: ITFIELDS);
begin
  if not ExtractHeadProp(AProp) then
    Error(SHeadLineNotFound, [AProp.Keyword], ERROR_TABLE_GETTFIELDS_NOT_FOUND);
  if not CorrectTFIELDS(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTFIELDS_VALUE);
end;

function TFitsTable.GetTFIELDS: Integer;
var
  LProp: ITFIELDS;
begin
  LProp := TFitsTFIELDS.Create;
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTFIELDS(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTBCOL(AProp: ITBCOL);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTBCOL_NUMBER);
  if not ExtractHeadProp(AProp) then
    Error(SHeadLineNotFound, [AProp.Keyword], ERROR_TABLE_GETTBCOL_NOT_FOUND);
  if not CorrectTBCOL(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTBCOL_VALUE);
end;

function TFitsTable.GetTBCOL(ANumber: Integer): Integer;
var
  LProp: ITBCOL;
begin
  LProp := TFitsTBCOL.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTBCOL(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTFORM(AProp: ITFORM);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTFORM_NUMBER);
  if not ExtractHeadProp(AProp) then
    Error(SHeadLineNotFound, [AProp.Keyword], ERROR_TABLE_GETTFORM_NOT_FOUND);
  if not CorrectTFORM(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTFORM_VALUE);
end;

function TFitsTable.GetTFORM(ANumber: Integer): string;
var
  LProp: ITFORM;
begin
  LProp := TFitsTFORM.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTFORM(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTTYPE(AProp: ITTYPE);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTTYPE_NUMBER);
  ExtractHeadProp(AProp);
end;

function TFitsTable.GetTTYPE(ANumber: Integer): string;
var
  LProp: ITTYPE;
begin
  LProp := TFitsTTYPE.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTTYPE(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTUNIT(AProp: ITUNIT);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTUNIT_NUMBER);
  ExtractHeadProp(AProp);
end;

function TFitsTable.GetTUNIT(ANumber: Integer): string;
var
  LProp: ITUNIT;
begin
  LProp := TFitsTUNIT.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTUNIT(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTSCAL(AProp: ITSCAL);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTSCAL_NUMBER);
  if not ExtractHeadProp(AProp) then
    AProp.Value := DefaultTSCAL
  else if not CorrectTSCAL(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTSCAL_VALUE);
end;

function TFitsTable.GetTSCAL(ANumber: Integer): Extended;
var
  LProp: ITSCAL;
begin
  LProp := TFitsTSCAL.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTSCAL(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTZERO(AProp: ITZERO);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTZERO_NUMBER);
  if not ExtractHeadProp(AProp) then
    AProp.Value := DefaultTZERO
  else if not CorrectTZERO(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTZERO_VALUE);
end;

function TFitsTable.GetTZERO(ANumber: Integer): Extended;
var
  LProp: ITZERO;
begin
  LProp := TFitsTZERO.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTZERO(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTNULL(AProp: ITNULL);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTNULL_NUMBER);
  ExtractHeadProp(AProp);
end;

function TFitsTable.GetTNULL(ANumber: Integer): string;
var
  LProp: ITNULL;
begin
  LProp := TFitsTNULL.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTNULL(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTDISP(AProp: ITDISP);
var
  LTForm: string;
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTDISP_NUMBER);
  LTForm := GetTFORM(AProp.KeywordNumber);
  if not ExtractHeadProp(AProp) then
    AProp.Value := LTForm
  else if not CorrectTDISP(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTDISP_VALUE)
  else if not CompatibleFieldFormat(LTForm, AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTDISP_INCOMP);
end;

function TFitsTable.GetTDISP(ANumber: Integer): string;
var
  LProp: ITDISP;
begin
  LProp := TFitsTDISP.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTDISP(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTDMIN(AProp: ITDMIN);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTDMIN_NUMBER);
  if ExtractHeadProp(AProp) and not CorrectTDMIN(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTDMIN_VALUE);
end;

function TFitsTable.GetTDMIN(ANumber: Integer): TVariable;
var
  LProp: ITDMIN;
begin
  LProp := TFitsTDMIN.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTDMIN(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTDMAX(AProp: ITDMAX);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTDMAX_NUMBER);
  if ExtractHeadProp(AProp) and not CorrectTDMAX(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTDMAX_VALUE);
end;

function TFitsTable.GetTDMAX(ANumber: Integer): TVariable;
var
  LProp: ITDMAX;
begin
  LProp := TFitsTDMAX.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTDMAX(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTLMIN(AProp: ITLMIN);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTLMIN_NUMBER);
  if ExtractHeadProp(AProp) and not CorrectTLMIN(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTLMIN_VALUE);
end;

function TFitsTable.GetTLMIN(ANumber: Integer): TVariable;
var
  LProp: ITLMIN;
begin
  LProp := TFitsTLMIN.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTLMIN(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

procedure TFitsTable.DoGetTLMAX(AProp: ITLMAX);
begin
  CheckFieldBounds(AProp, ERROR_TABLE_GETTLMAX_NUMBER);
  if ExtractHeadProp(AProp) and not CorrectTLMAX(AProp.Value) then
    Error(SPropIncorrectValue, [AProp.Keyword, AProp.PrintValue],
      ERROR_TABLE_GETTLMAX_VALUE);
end;

function TFitsTable.GetTLMAX(ANumber: Integer): TVariable;
var
  LProp: ITLMAX;
begin
  LProp := TFitsTLMAX.Create(ANumber);
  if not ExtractCacheProp(LProp) then
  begin
    DoGetTLMAX(LProp);
    AppendCacheProp(LProp);
  end;
  Result := LProp.Value;
end;

{ EFitsFieldException }

function EFitsFieldException.GetTopic: string;
begin
  Result := 'FIELD';
end;

{ TFitsField }

procedure TFitsField.Bind(const AHandle: TFieldHandle);
var
  LFieldIndex, LFieldCount: Integer;
begin
  if not Assigned(AHandle.FieldSource) then
    Error(STableNotAssigned, ERROR_FIELD_BIND_NO_SOURCE);
  LFieldIndex := AHandle.FieldNumber - 1;
  LFieldCount := AHandle.FieldSource.Data.FieldCount;
  if not InSegmentBound({ASegmentPosition:} 0, LFieldCount, LFieldIndex) then
    Error(STableDataFieldNumberOutBounds, [AHandle.FieldNumber, LFieldCount],
      ERROR_FIELD_BIND_NUMBER);
  FTable := AHandle.FieldSource;
  FFieldNumber := AHandle.FieldNumber;
end;

procedure TFitsField.DeleteTableHeadProp(AProp: IFitsPropContext);
var
  LIndex: Integer;
begin
  LIndex := FTable.Head.LineIndexOfKeyword(AProp.Keyword);
  if LIndex >= 0 then
    FTable.Head.DeleteLines(LIndex, {ACount:} 1);
end;

procedure TFitsField.UpdateTableHeadProp(AProp: IFitsPropContext);
const
  cKeywords: array [0 .. 11] of string = (cTTYPEn, cTBCOLn, cTFORMn, cTUNITn,
    cTSCALn, cTZEROn, cTNULLn, cTDISPn, cTDMINn, cTDMAXn, cTLMINn, cTLMAXn);
var
  LKeywords: array of string;
  LCurIndex, LNewIndex, LIndex, LOrder: Integer;
begin
  LCurIndex := FTable.Head.LineIndexOfKeyword(AProp.Keyword);
  if LCurIndex < 0 then
  begin
    // Prepare a recommended keyword order
    LKeywords := nil;
    SetLength(LKeywords, Length(cKeywords));
    for LIndex := Low(cKeywords) to High(cKeywords) do
      LKeywords[LIndex] := ExpandKeyword(cKeywords[LIndex], FFieldNumber);
    // Find the recommended relative position for the new keyword record
    LOrder := Length(LKeywords);
    for LIndex := Low(LKeywords) to High(LKeywords) do
      if SameText(AProp.Keyword, LKeywords[LIndex]) then
      begin
        LOrder := LIndex;
        Break;
      end;
    // Find the absolute position in the table header for the new keyword record
    LNewIndex := -1;
    LIndex := LOrder + 1;
    while (LNewIndex < 0) and (LIndex < Length(LKeywords)) do
    begin
      LNewIndex := FTable.Head.LineIndexOfKeyword(LKeywords[LIndex]);
      Inc(LIndex);
    end;
    LIndex := LOrder - 1;
    while (LNewIndex < 0) and (LIndex >= 0) do
    begin
      LNewIndex := FTable.Head.LineIndexOfKeyword(LKeywords[LIndex]);
      if LNewIndex >= 0 then
        Inc(LNewIndex);
      Dec(LIndex);
    end;
    // Insert the new keyword record
    if LNewIndex < 0 then
      FTable.Head.AddLines(AProp.NewLine)
    else
      FTable.Head.InsertLines(LNewIndex, AProp.NewLine);
  end else
  // if LCurIndex >= 0 then
  begin
    FTable.Head.Lines[LCurIndex] := AProp.NewLine;
  end;
end;

procedure TFitsField.AssignTableHeadProp(AProp: IFitsStringPropContext);
begin
  if AProp.Value = '' then
    DeleteTableHeadProp(AProp)
  else
    UpdateTableHeadProp(AProp);
end;

procedure TFitsField.AssignTableHeadProp(AProp: IFitsVariablePropContext);
begin
  if AProp.Value.VarType = vtNone then
    DeleteTableHeadProp(AProp)
  else
    UpdateTableHeadProp(AProp);
end;

procedure TFitsField.ChangeField;
begin
  // Do nothing
end;

procedure TFitsField.CalcFieldFormat;
var
  LForm: string;
begin
  LForm := FTable.GetTFORM(FFieldNumber);
  DecodeFieldFormat(LForm, {out} FFieldFormat);
end;

procedure TFitsField.CalcFieldPosition;
begin
  FFieldPosition := FTable.GetTBCOL(FFieldNumber);
end;

procedure TFitsField.CalcFieldName;
begin
  FFieldName := FTable.GetTTYPE(FFieldNumber);
end;

procedure TFitsField.CalcFieldUnit;
begin
  FFieldUnit := FTable.GetTUNIT(FFieldNumber);
end;

procedure TFitsField.CalcFieldScal;
begin
  FFieldScal := FTable.GetTSCAL(FFieldNumber);
end;

procedure TFitsField.CalcFieldZero;
begin
  FFieldZero := FTable.GetTZERO(FFieldNumber);
end;

procedure TFitsField.CalcFieldNull;
begin
  FFieldNull := FTable.GetTNULL(FFieldNumber);
end;

procedure TFitsField.CalcFieldDmin;
begin
  FFieldDmin := FTable.GetTDMIN(FFieldNumber);
end;

procedure TFitsField.CalcFieldDmax;
begin
  FFieldDmax := FTable.GetTDMAX(FFieldNumber);
end;

procedure TFitsField.CalcFieldLmin;
begin
  FFieldLmin := FTable.GetTLMIN(FFieldNumber);
end;

procedure TFitsField.CalcFieldLmax;
begin
  FFieldLmax := FTable.GetTLMAX(FFieldNumber);
end;

procedure TFitsField.CalcDisplayFormat;
var
  LDisp: string;
begin
  LDisp := FTable.GetTDISP(FFieldNumber);
  DecodeFieldFormat(LDisp, {out} FDisplayFormat);
end;

function TFitsField.GetFieldFormatStr: string;
begin
  EncodeFieldFormat(FFieldFormat, {out} Result);
end;

function TFitsField.GetFieldType: TFieldType;
begin
  if FFieldFormat.Code = 'A' then
    Result := ftString
  else if FFieldFormat.Code = 'I' then
    Result := ftInteger
  else { if FFieldFormat.Code = 'F', 'E', 'D' then }
    Result := ftFloat;
end;

function TFitsField.GetFieldWidth: Integer;
begin
  Result := FFieldFormat.w;
end;

procedure TFitsField.SetFieldName(const AValue: string);
var
  LProp: ITTYPE;
begin
  LProp := TFitsTTYPE.CreateValue(FFieldNumber, Trim(AValue));
  AssignTableHeadProp(LProp);
  CalcFieldName;
  ChangeField;
end;

procedure TFitsField.SetFieldUnit(const AValue: string);
var
  LProp: ITUNIT;
begin
  LProp := TFitsTUNIT.CreateValue(FFieldNumber, Trim(AValue));
  AssignTableHeadProp(LProp);
  CalcFieldUnit;
  ChangeField;
end;

procedure TFitsField.SetFieldScal(const AValue: Extended);
var
  LProp: ITSCAL;
begin
  LProp := TFitsTSCAL.CreateValue(FFieldNumber, AValue);
  if not CorrectTSCAL(LProp.Value) then
    Error(SFieldIncorrectValue, [LProp.Keyword, LProp.PrintValue],
      ERROR_FIELD_SETFIELDSCAL_VALUE);
  UpdateTableHeadProp(LProp);
  CalcFieldScal;
  ChangeField;
end;

procedure TFitsField.SetFieldZero(const AValue: Extended);
var
  LProp: ITZERO;
begin
  LProp := TFitsTZERO.CreateValue(FFieldNumber, AValue);
  if not CorrectTZERO(LProp.Value) then
    Error(SFieldIncorrectValue, [LProp.Keyword, LProp.PrintValue],
      ERROR_FIELD_SETFIELDZERO_VALUE);
  UpdateTableHeadProp(LProp);
  CalcFieldZero;
  ChangeField;
end;

procedure TFitsField.SetFieldNull(const AValue: string);
var
  LProp: ITNULL;
begin
  LProp := TFitsTNULL.CreateValue(FFieldNumber, Trim(AValue));
  if Length(LProp.Value) > FFieldFormat.w then
    Error(SFieldIncorrectValueWidth, [LProp.Keyword, LProp.PrintValue],
      ERROR_FIELD_SETFIELDNULL_VALUE);
  AssignTableHeadProp(LProp);
  CalcFieldNull;
  ChangeField;
end;

procedure TFitsField.SetFieldDmin(const AValue: TVariable);
var
  LProp: ITDMIN;
begin
  LProp := TFitsTDMIN.CreateValue(FFieldNumber, AValue);
  if not CorrectTDMIN(LProp.Value) then
    Error(SFieldIncorrectValue, [LProp.Keyword, LProp.PrintValue],
      ERROR_FIELD_SETFIELDDMIN_VALUE);
  AssignTableHeadProp(LProp);
  CalcFieldDmin;
  ChangeField;
end;

procedure TFitsField.SetFieldDmax(const AValue: TVariable);
var
  LProp: ITDMAX;
begin
  LProp := TFitsTDMAX.CreateValue(FFieldNumber, AValue);
  if not CorrectTDMAX(LProp.Value) then
    Error(SFieldIncorrectValue, [LProp.Keyword, LProp.PrintValue],
      ERROR_FIELD_SETFIELDDMAX_VALUE);
  AssignTableHeadProp(LProp);
  CalcFieldDmax;
  ChangeField;
end;

procedure TFitsField.SetFieldLmin(const AValue: TVariable);
var
  LProp: ITLMIN;
begin
  LProp := TFitsTLMIN.CreateValue(FFieldNumber, AValue);
  if not CorrectTLMIN(LProp.Value) then
    Error(SFieldIncorrectValue, [LProp.Keyword, LProp.PrintValue],
      ERROR_FIELD_SETFIELDLMIN_VALUE);
  AssignTableHeadProp(LProp);
  CalcFieldLmin;
  ChangeField;
end;

procedure TFitsField.SetFieldLmax(const AValue: TVariable);
var
  LProp: ITLMAX;
begin
  LProp := TFitsTLMAX.CreateValue(FFieldNumber, AValue);
  if not CorrectTLMAX(LProp.Value) then
    Error(SFieldIncorrectValue, [LProp.Keyword, LProp.PrintValue],
      ERROR_FIELD_SETFIELDLMAX_VALUE);
  AssignTableHeadProp(LProp);
  CalcFieldLmax;
  ChangeField;
end;

procedure TFitsField.SetDisplayFormatRec(const AValue: TFieldFormat);

  function ValueToString: string;
  begin
    Result := Format('(CODE:%s;W:%d;D:%d;E:%d)', [AValue.Code, AValue.w, AValue.d, AValue.e]);
  end;

var
  LProp: ITDISP;
  LExtent: Integer;
  LDisplayForm: string;
begin
  LExtent := EncodeFieldFormat(AValue, {out} LDisplayForm);
  LProp := TFitsTDISP.CreateValue(FFieldNumber, LDisplayForm);
  if (LExtent = 0) or (not CorrectTDISP(LProp.Value)) then
    Error(SFieldIncorrectValue, [LProp.Keyword, ValueToString],
      ERROR_FIELD_SETDISPLAYFORMAT_VALUE);
  if not CompatibleFieldFormat(FFieldFormat, AValue) then
    Error(SFieldIncorrectValue, [LProp.Keyword, ValueToString],
      ERROR_FIELD_SETDISPLAYFORMAT_INCOMP);
  UpdateTableHeadProp(LProp);
  CalcDisplayFormat;
  ChangeField;
end;

function TFitsField.GetDisplayFormatStr: string;
begin
  EncodeFieldFormat(FDisplayFormat, {out} Result);
end;

procedure TFitsField.SetDisplayFormatStr(const AValue: string);
var
  LProp: ITDISP;
  LExtent: Integer;
  LDisplayFormat: TFieldFormat;
begin
  LProp := TFitsTDISP.CreateValue(FFieldNumber, AValue);
  LExtent := DecodeFieldFormat(LProp.Value, {out} LDisplayFormat);
  if (LExtent = 0) or (not CorrectTDISP(LProp.Value)) then
    Error(SFieldIncorrectValue, [LProp.Keyword, LProp.Value],
      ERROR_FIELD_SETDISPLAYFORMAT_VALUE);
  if not CompatibleFieldFormat(FFieldFormat, LDisplayFormat) then
    Error(SFieldIncorrectValue, [LProp.Keyword, LProp.Value],
      ERROR_FIELD_SETDISPLAYFORMAT_INCOMP);
  UpdateTableHeadProp(LProp);
  CalcDisplayFormat;
  ChangeField;
end;

function TFitsField.GetDisplayWidth: Integer;
begin
  Result := FDisplayFormat.w;
end;

procedure TFitsField.SetDisplayWidth(AValue: Integer);
var
  LDisplayFormat: TFieldFormat;
begin
  LDisplayFormat := FDisplayFormat;
  LDisplayFormat.w := AValue;
  SetDisplayFormatRec(LDisplayFormat);
end;

function TFitsField.GetValue: string;
begin
  Result := FTable.Data.GetRecordValue(FFieldPosition, FFieldFormat.w);
end;

procedure TFitsField.SetValue(const AValue: string);
var
  LValue: string;
begin
  LValue := EnsureString(AValue, FFieldFormat.w);
  FTable.Data.SetRecordValue(FFieldPosition, FFieldFormat.w, LValue);
end;

function TFitsField.GetValueIsClear: Boolean;
begin
  Result := SameText(Trim(Value), FFieldNull);
end;

function TFitsField.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsFieldException;
end;

constructor TFitsField.Create(const AHandle: TFieldHandle);
begin
  inherited Create;
  Bind(AHandle);
  CalcFieldFormat;
  CalcFieldPosition;
  CalcFieldName;
  CalcFieldUnit;
  CalcFieldScal;
  CalcFieldZero;
  CalcFieldNull;
  CalcFieldDmin;
  CalcFieldDmax;
  CalcFieldLmin;
  CalcFieldLmax;
  CalcDisplayFormat;
end;

procedure TFitsField.ClearFieldName;
var
  LProp: ITTYPE;
begin
  LProp := TFitsTTYPE.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcFieldName;
  ChangeField;
end;

procedure TFitsField.ClearFieldUnit;
var
  LProp: ITUNIT;
begin
  LProp := TFitsTUNIT.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcFieldUnit;
  ChangeField;
end;

procedure TFitsField.ClearFieldScal;
var
  LProp: ITSCAL;
begin
  LProp := TFitsTSCAL.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcFieldScal;
  ChangeField;
end;

procedure TFitsField.ClearFieldZero;
var
  LProp: ITZERO;
begin
  LProp := TFitsTZERO.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcFieldZero;
  ChangeField;
end;

procedure TFitsField.ClearFieldNull;
var
  LProp: ITNULL;
begin
  LProp := TFitsTNULL.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcFieldNull;
  ChangeField;
end;

procedure TFitsField.ClearFieldDmin;
var
  LProp: ITDMIN;
begin
  LProp := TFitsTDMIN.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcFieldDmin;
  ChangeField;
end;

procedure TFitsField.ClearFieldDmax;
var
  LProp: ITDMAX;
begin
  LProp := TFitsTDMAX.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcFieldDmax;
  ChangeField;
end;

procedure TFitsField.ClearFieldLmin;
var
  LProp: ITLMIN;
begin
  LProp := TFitsTLMIN.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcFieldLmin;
  ChangeField;
end;

procedure TFitsField.ClearFieldLmax;
var
  LProp: ITLMAX;
begin
  LProp := TFitsTLMAX.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcFieldLmax;
  ChangeField;
end;

procedure TFitsField.ClearDisplayFormat;
var
  LProp: ITDISP;
begin
  LProp := TFitsTDISP.Create(FFieldNumber);
  DeleteTableHeadProp(LProp);
  CalcDisplayFormat;
  ChangeField;
end;

procedure TFitsField.ClearValue;
var
  LValue: string;
begin
  LValue := EnsureString(FFieldNull, -FFieldFormat.w);
  SetValue(LValue);
end;

{ TFitsStringField }

function TFitsStringField.GetValueAsString: string;
begin
  if ValueIsClear then
    Result := ''
  else
    Result := Trim(Value);
end;

procedure TFitsStringField.SetValueAsString(const AValue: string);
begin
  Value := AValue;
end;

function TFitsStringField.GetDisplayValue: string;
begin
  Result := EnsureString(Trim(Value), DisplayWidth);
end;

{ TFitsNumericField }

procedure TFitsNumericField.CalcFieldScalability;
begin
  FFieldIsScaled := not (SameValue(FieldScal, DefaultTSCAL) and SameValue(FieldZero, DefaultTZERO));
end;

function TFitsNumericField.GetDisplayFixedValue: string;
begin
  Result := FloatToStrF(ValueAsExtended, ffFixed, FGetDisplayValuePrecision,
    FGetDisplayValueDigits, FFormatSettings);
end;

function TFitsNumericField.GetDisplayFortranExponentValue: string;
begin
  Result := FloatToFortranExponentString(ValueAsExtended, FGetDisplayValuePrecision,
    FGetDisplayValueDigits, FGetDisplayValueExponentChar, FFormatSettings);
end;

function TFitsNumericField.GetDisplayScientificExponentValue: string;
begin
  Result := FloatToStrF(ValueAsExtended, ffExponent, FGetDisplayValuePrecision,
    FGetDisplayValueDigits, FFormatSettings);
end;

function TFitsNumericField.GetDisplayGeneralValue: string;
begin
  Result := FloatToFortranGeneralString(ValueAsExtended, FGetDisplayValuePrecision,
    FGetDisplayValueDigits, DotFormatSettings);
end;

procedure TFitsNumericField.CalcGetDisplayValueFunc;
var
  LDisplayFormat: TFieldFormat;
begin
  // Register the value display function
  LDisplayFormat := DisplayFormatRec;
  // ... fixed decimal format
  if LDisplayFormat.Code = 'F' then
  begin
    FGetDisplayValuePrecision := 18;
    FGetDisplayValueDigits := LDisplayFormat.d;
    FGetDisplayValueExponentChar := 'E';
    FGetDisplayValueFunc := {$IFDEF FPC}@{$ENDIF}GetDisplayFixedValue;
  end else
  // ... exponential format as a single-precision ('E'), engineering ('EN') or scientific ('ES') floating-point
  if MatchString(LDisplayFormat.Code, ['E', 'EN', 'ES']) then
  begin
    FGetDisplayValuePrecision := Max(LDisplayFormat.d, 1);
    FGetDisplayValueDigits := IfThen(LDisplayFormat.e < 0, 2, LDisplayFormat.e);
    FGetDisplayValueExponentChar := 'E';
    if LDisplayFormat.Code = 'E' then
    begin
      FGetDisplayValueFunc := {$IFDEF FPC}@{$ENDIF}GetDisplayFortranExponentValue
    end else
    begin
      Inc(FGetDisplayValuePrecision);
      FGetDisplayValueFunc := {$IFDEF FPC}@{$ENDIF}GetDisplayScientificExponentValue;
    end;
  end else
  // ... general format
  if LDisplayFormat.Code = 'G' then
  begin
    FGetDisplayValuePrecision := LDisplayFormat.d;
    if LDisplayFormat.e < 0 then
      FGetDisplayValueDigits := 2
    else
      FGetDisplayValueDigits := EnsureRange(LDisplayFormat.e, 1, 4);
    FGetDisplayValueExponentChar := 'E';
    FGetDisplayValueFunc := {$IFDEF FPC}@{$ENDIF}GetDisplayGeneralValue;
  end else
  // ... exponential format as a double-precision floating-point
  if LDisplayFormat.Code = 'D' then
  begin
    FGetDisplayValuePrecision := Max(LDisplayFormat.d, 1);
    FGetDisplayValueDigits := IfThen(LDisplayFormat.e < 0, 2, LDisplayFormat.e);
    FGetDisplayValueExponentChar := 'D';
    FGetDisplayValueFunc := {$IFDEF FPC}@{$ENDIF}GetDisplayFortranExponentValue;
  end;
end;

procedure TFitsNumericField.ChangeField;
begin
  CalcFieldScalability;
  CalcGetDisplayValueFunc;
end;

function TFitsNumericField.GetDisplayValue: string;
begin
  if ValueIsClear then
    Result := FieldNull
  else
    Result := FGetDisplayValueFunc();
  // [FITS_STANDARD_4.0, SECT_7.3.4] Data display. Integer data... The output
  // field consists of w characters containing zero-or-more leading spaces
  // followed by a minus sign if the internal datum is negative... If the
  // number of digits required to represent the integer datum exceeds w, then
  // the output field consists of a string of w asterisk (*) characters
  if Length(Result) > DisplayWidth then
    Result := StringOfChar('*', DisplayWidth)
  else
    Result := PadString(Result, DisplayWidth);
end;

function TFitsNumericField.GetValueAsDouble: Double;
begin
  Result := Ensure64f(ValueAsExtended);
end;

procedure TFitsNumericField.SetValueAsDouble(const AValue: Double);
begin
  ValueAsExtended := AValue;
end;

function TFitsNumericField.GetValueAsSingle: Single;
begin
  Result := Ensure32f(ValueAsExtended);
end;

procedure TFitsNumericField.SetValueAsSingle(const AValue: Single);
begin
  ValueAsExtended := AValue;
end;

function TFitsNumericField.GetValueAsInteger: Integer;
begin
  Result := Ensure32c(ValueAsInt64);
end;

procedure TFitsNumericField.SetValueAsInteger(const AValue: Integer);
begin
  ValueAsInt64 := AValue;
end;

function TFitsNumericField.GetValueAsSmallInt: SmallInt;
begin
  Result := Ensure16c(ValueAsInt64);
end;

procedure TFitsNumericField.SetValueAsSmallInt(const AValue: SmallInt);
begin
  ValueAsInt64 := AValue;
end;

constructor TFitsNumericField.Create(const AHandle: TFieldHandle);
begin
  inherited Create(AHandle);
  FFormatSettings := DotFormatSettings;
  CalcFieldScalability;
  CalcGetDisplayValueFunc;
end;

{ TFitsIntegerField }

function TFitsIntegerField.GetDisplayHexValue: string;
begin
  Result := Int64ToHexString(ValueAsInt64, FGetDisplayValueDigits);
end;

function TFitsIntegerField.GetDisplayDecValue: string;
begin
  Result := Int64ToDecString(ValueAsInt64, FGetDisplayValueDigits);
end;

function TFitsIntegerField.GetDisplayOctValue: string;
begin
  Result := Int64ToOctString(ValueAsInt64, FGetDisplayValueDigits);
end;

function TFitsIntegerField.GetDisplayBinValue: string;
begin
  Result := Int64ToBinString(ValueAsInt64, FGetDisplayValueDigits);
end;

procedure TFitsIntegerField.CalcGetDisplayValueFunc;
var
  LDisplayFormat: TFieldFormat;
begin
  // Register a function to display an integer, binary, octal, or hexadecimal value
  LDisplayFormat := DisplayFormatRec;
  if MatchString(LDisplayFormat.Code, ['I', 'B', 'O', 'Z']) then
  begin
    LDisplayFormat.m := Max(LDisplayFormat.m, 0);
    FGetDisplayValueDigits := Word(LDisplayFormat.m);
    if LDisplayFormat.Code = 'I' then
      FGetDisplayValueFunc := {$IFDEF FPC}@{$ENDIF}GetDisplayDecValue
    else if LDisplayFormat.Code = 'B' then
      FGetDisplayValueFunc := {$IFDEF FPC}@{$ENDIF}GetDisplayBinValue
    else if LDisplayFormat.Code = 'O' then
      FGetDisplayValueFunc := {$IFDEF FPC}@{$ENDIF}GetDisplayOctValue
    else if LDisplayFormat.Code = 'Z' then
      FGetDisplayValueFunc := {$IFDEF FPC}@{$ENDIF}GetDisplayHexValue;
  end else
    inherited;
end;

function TFitsIntegerField.GetValueAsExtended: Extended;
var
  LValue: Int64;
begin
  if ValueIsClear then
  begin
    Result := NaN;
  end else
  begin
    LValue := StringToInt64(Value);
    if FieldIsScaled then
      Result := FieldZero + LValue * FieldScal
    else
      Result := LValue;
  end;
end;

procedure TFitsIntegerField.SetValueAsExtended(const AValue: Extended);
var
  LValue: Int64;
begin
  if IsNan(AValue) then
  begin
    ClearValue;
  end else
  begin
    if FieldIsScaled then
      LValue := Round64c((AValue - FieldZero) / FieldScal)
    else
      LValue := Round64c(AValue);
    Value := Int64ToString(LValue);
  end;
end;

function TFitsIntegerField.GetValueAsInt64: Int64;
var
  LValue: Int64;
begin
  if ValueIsClear then
  begin
    Result := 0;
  end else
  begin
    LValue := StringToInt64(Value);
    if FieldIsScaled then
      Result := Round64c(FieldZero + LValue * FieldScal)
    else
      Result := LValue;
  end;
end;

procedure TFitsIntegerField.SetValueAsInt64(const AValue: Int64);
var
  LValue: Int64;
begin
  if FieldIsScaled then
    LValue := Round64c((AValue - FieldZero) / FieldScal)
  else
    LValue := AValue;
  Value := Int64ToString(LValue);
end;

{ TFitsFloatField }

procedure TFitsFloatField.SetFixedValue(const AValue: Extended);
begin
  Value := FloatToStrF(AValue, ffFixed, FSetValuePrecision, FSetValueDigits,
    FFormatSettings);
end;

procedure TFitsFloatField.SetExponentValue(const AValue: Extended);
begin
  Value := FloatToFortranExponentString(AValue, FSetValuePrecision,
    FSetValueDigits, FSetValueExponentChar, FFormatSettings);
end;

procedure TFitsFloatField.CalcSetValueProc;
var
  LFieldFormat: TFieldFormat;
begin
  LFieldFormat := FieldFormatRec;
  if LFieldFormat.Code = 'F' then
  begin
    FSetValuePrecision := 18;
    FSetValueDigits := LFieldFormat.d;
    FSetValueExponentChar := 'E';
    FSetValueProc := {$IFDEF FPC}@{$ENDIF}SetFixedValue;
  end else
  if LFieldFormat.Code = 'E' then
  begin
    FSetValuePrecision := LFieldFormat.d;
    FSetValueDigits := IfThen(LFieldFormat.e < 0, 2, LFieldFormat.e);
    FSetValueExponentChar := 'E';
    FSetValueProc := {$IFDEF FPC}@{$ENDIF}SetExponentValue;
  end else
  if LFieldFormat.Code = 'D' then
  begin
    FSetValuePrecision := LFieldFormat.d;
    FSetValueDigits := IfThen(LFieldFormat.e < 0, 2, LFieldFormat.e);
    FSetValueExponentChar := 'D';
    FSetValueProc := {$IFDEF FPC}@{$ENDIF}SetExponentValue;
  end;
end;

function TFitsFloatField.GetValueAsExtended: Extended;
var
  LValue: Extended;
begin
  if ValueIsClear then
  begin
    Result := NaN;
  end else
  begin
    LValue := FortranStringToFloat(Value);
    if FieldIsScaled then
      Result := FieldZero + LValue * FieldScal
    else
      Result := LValue;
  end;
end;

procedure TFitsFloatField.SetValueAsExtended(const AValue: Extended);
var
  LValue: Extended;
begin
  if IsNan(AValue) or (AValue = Infinity) or (AValue = NegInfinity) then
  begin
    ClearValue;
  end else
  begin
    if FieldIsScaled then
      LValue := (AValue - FieldZero) / FieldScal
    else
      LValue := AValue;
    FSetValueProc(LValue);
  end;
end;

function TFitsFloatField.GetValueAsInt64: Int64;
var
  LValue: Extended;
begin
  LValue := ValueAsExtended;
  if IsNan(LValue) then
    Result := 0
  else
    Result := Round64c(LValue);
end;

procedure TFitsFloatField.SetValueAsInt64(const AValue: Int64);
begin
  ValueAsExtended := AValue;
end;

constructor TFitsFloatField.Create(const AHandle: TFieldHandle);
begin
  inherited Create(AHandle);
  CalcSetValueProc;
end;

end.
