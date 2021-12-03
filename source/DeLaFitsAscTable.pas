{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{            Standard ASCII TABLE extension            }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsAscTable;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Classes, Math, DeLaFitsCommon, DeLaFitsString, DeLaFitsMath,
  DeLaFitsClasses;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_ASCTABLE                        = 7000;

  ERROR_ASCCOLUMN_POSITION              = 7100;
  ERROR_ASCCOLUMN_FORM                  = 7101;
  ERROR_ASCCOLUMN_NAME                  = 7102;
  ERROR_ASCCOLUMN_UMIT                  = 7103;
  ERROR_ASCCOLUMN_NULL                  = 7104;
  ERROR_ASCCOLUMN_DISP                  = 7105;

  ERROR_ASCTABLE_SPEC_INVALID           = 7200;
  ERROR_ASCTABLE_SPEC_UMIT              = 7201;
  ERROR_ASCTABLE_SPEC_COLUMN            = 7202;
  ERROR_ASCTABLE_SPEC_COLCOUNT          = 7203;
  ERROR_ASCTABLE_SPEC_ROWCOUNT          = 7204;
  ERROR_ASCTABLE_SPEC_ROWSIZE           = 7205;

  ERROR_ASCTABLE_HEAD_INCORRECT_NAME    = 7300;
  ERROR_ASCTABLE_HEAD_INCORRECT_BITPIX  = 7301;
  ERROR_ASCTABLE_HEAD_INCORRECT_NAXIS   = 7302;
  ERROR_ASCTABLE_HEAD_INCORRECT_NAXIS1  = 7303;

  ERROR_ASCTABLE_DATA_GETROW_INDEX      = 7400;
  ERROR_ASCTABLE_DATA_ALLOWREAD_COL     = 7401;
  ERROR_ASCTABLE_DATA_ALLOWREAD_ROW     = 7402;
  ERROR_ASCTABLE_DATA_ALLOWREAD_NATURE  = 7403;
  ERROR_ASCTABLE_DATA_ALLOWREAD_COUNT   = 7404;
  ERROR_ASCTABLE_DATA_ALLOWREAD_LENGTH  = 7405;
  ERROR_ASCTABLE_DATA_ALLOWWRITE_COL    = 7406;
  ERROR_ASCTABLE_DATA_ALLOWWRITE_ROW    = 7407;
  ERROR_ASCTABLE_DATA_ALLOWWRITE_NATURE = 7408;
  ERROR_ASCTABLE_DATA_ALLOWWRITE_COUNT  = 7409;
  ERROR_ASCTABLE_DATA_ALLOWWRITE_LENGTH = 7410;

  ERROR_ASCTABLE_GETFIELDS_NOTFOUND     = 7500;
  ERROR_ASCTABLE_GETFIELDS_INVALID      = 7501;
  ERROR_ASCTABLE_GETFIELDS_INCORRECT    = 7502;
  ERROR_ASCTABLE_GETTBCOL_NUMBER        = 7503;
  ERROR_ASCTABLE_GETTBCOL_NOTFOUND      = 7504;
  ERROR_ASCTABLE_GETTBCOL_INVALID       = 7505;
  ERROR_ASCTABLE_GETTBCOL_INCORRECT     = 7506;
  ERROR_ASCTABLE_GETTFORM_NUMBER        = 7507;
  ERROR_ASCTABLE_GETTFORM_NOTFOUND      = 7508;
  ERROR_ASCTABLE_GETTFORM_INVALID       = 7509;
  ERROR_ASCTABLE_GETTFORM_INCORRECT     = 7510;
  ERROR_ASCTABLE_GETTTYPE_NUMBER        = 7511;
  ERROR_ASCTABLE_GETTTYPE_INVALID       = 7512;
  ERROR_ASCTABLE_GETTUNIT_NUMBER        = 7513;
  ERROR_ASCTABLE_GETTUNIT_INVALID       = 7514;
  ERROR_ASCTABLE_GETTSCAL_NUMBER        = 7515;
  ERROR_ASCTABLE_GETTSCAL_INVALID       = 7516;
  ERROR_ASCTABLE_GETTZERO_NUMBER        = 7517;
  ERROR_ASCTABLE_GETTZERO_INVALID       = 7518;
  ERROR_ASCTABLE_GETTNULL_NUMBER        = 7519;
  ERROR_ASCTABLE_GETTNULL_INVALID       = 7520;
  ERROR_ASCTABLE_GETTDISP_NUMBER        = 7521;
  ERROR_ASCTABLE_GETTDISP_INVALID       = 7522;
  ERROR_ASCTABLE_GETTDMIN_NUMBER        = 7523;
  ERROR_ASCTABLE_GETTDMIN_INVALID       = 7524;
  ERROR_ASCTABLE_GETTDMAX_NUMBER        = 7525;
  ERROR_ASCTABLE_GETTDMAX_INVALID       = 7526;
  ERROR_ASCTABLE_GETTLMIN_NUMBER        = 7527;
  ERROR_ASCTABLE_GETTLMIN_INVALID       = 7528;
  ERROR_ASCTABLE_GETTLMAX_NUMBER        = 7529;
  ERROR_ASCTABLE_GETTLMAX_INVALID       = 7530;

resourcestring

  { The messages of exceptions }

  SAscColumnIncorrectProp           = 'Incorrect property "%s" in ASCII-TABLE column';

  SAscTableSpecInvalid              = 'Invalid ASCII-TABLE specification';
  SAscTableSpecIncorrectUmit        = 'Cannot create the ASCII-TABLE specification from undefined HDU';
  SAscTableSpecIncorrectProp        = 'Incorrect property "%s" in ASCII-TABLE specification';
  SAscTableSpecIncorrectColumn      = 'Incorrect Column in ASCII-TABLE specification';

  SAscTableHeadIncorrectValue       = 'Incorrect "%s" value of ASCII-TABLE[%d] header';

  SAscTableDataIncorrectColIndex    = 'Incorrect col-index "%d" to ASCII-TABLE[%d] data access';
  SAscTableDataIncorrectColNature   = 'Incorrect col-nature "%s" to ASCII-TABLE[%d] data access';
  SAscTableDataIncorrectRowIndex    = 'Incorrect row-index "%d" to ASCII-TABLE[%d] data access';
  SAscTableDataIncorrectCellsCount  = 'Incorrect cells-count "%d" to ASCII-TABLE[%d] data access';
  SAscTableDataIncorrectCellsLength = 'Incorrect cells-length "%d" to ASCII-TABLE[%d] data access';

type

  { Exception classes }

  EFitsAscTableException = class(EFitsClassesException);

type

  { Standard ASCII TABLE extension }

  PAscColumn = ^TAscColumn;
  TAscColumn = record
    // mandatory
    Position: Integer;
    Form: string;
    // reserved
    Name: string;
    Umit: string;
    Scal: Extended;
    Zero: Extended;
    Null: string;
    Disp: string;
    Dmin: Extended;
    Dmax: Extended;
    Lmin: Extended;
    Lmax: Extended;
  end;

  TAscNature = (anString, anInteger, anFloat);

  procedure AscColumnVerify(const AColumn: TAscColumn);

  function AscColumnCreate(const APosition: Integer; const AForm: string; const AName: string = ''): TAscColumn;
  function AscColumnCreateString(const APosition: Integer; const AWidth: Integer; const AName: string = ''): TAscColumn;
  function AscColumnCreateNumber(const APosition: Integer; const ARep: TRepNumber; const AName: string = ''): TAscColumn;

  procedure AscColumnDeform(const AColumn: TAscColumn; out C: Char; out W, D: Integer);
  procedure AscColumnDedisp(const AColumn: TAscColumn; out C: Char; out W, D: Integer);

  function AscColumnCapacity(const AColumn: TAscColumn): Integer;

  function AscColumnNature(const AColumn: TAscColumn): TAscNature;
  function AscColumnMakeup(const AColumn: TAscColumn): TAscNature;

  function AscColumnNatureFormat(const AColumn: TAscColumn): string;
  function AscColumnMakeupFormat(const AColumn: TAscColumn): string;

type

  TAscCellEnsure = procedure (var AValue: Extended; const ACol, ARow: Integer; const AColumn: TAscColumn);

  procedure AscCellEnsureDefault(var AValue: Extended; const ACol, ARow: Integer; const AColumn: TAscColumn);

type

  TFitsAscTable = class;

  TFitsAscTableSpec = class(TFitsUmitSpec)
  private
    FPretty: Boolean;
    FCols: TList;
    FRowSize: Integer;
    FRowCount: Integer;
    procedure SetPretty(const Value: Boolean);
    procedure DoPretty;
    procedure VerifyCol(const NewColumn: TAscColumn);
    procedure ReleaseCol(Index: Integer);
    function GetCol(Index: Integer): TAscColumn;
    procedure SetCol(Index: Integer; const Value: TAscColumn);
    function GetColCount: Integer;
    procedure OrderCols;
    function GetAutoRowSize: Integer;
    procedure SetRowSize(const Value: Integer);
    procedure SetRowCount(const Value: Integer);
    function GetBITPIX: TBitPix;
    function GetNAXIS: Integer;
    function GetNAXIS1: Integer;
    function GetNAXIS2: Integer;
    function GetGCOUNT: Integer;
    function GetPCOUNT: Integer;
    function GetTFIELDS: Integer;
  public
    constructor Create(const AColumns: array of TAscColumn; const ARowCount: Integer; APretty: Boolean = True); overload;
    constructor Create(AUmit: TFitsAscTable; APretty: Boolean = True); overload;
    constructor Create; overload;
    destructor Destroy; override;
    property Pretty: Boolean read FPretty write SetPretty;
  public
    function InsertCol(Index: Integer; const AColumn: TAscColumn): Integer;
    function AddCol(const AColumn: TAscColumn): Integer;
    procedure DeleteCol(Index: Integer);
    property Cols[Index: Integer]: TAscColumn read GetCol write SetCol;
    property ColCount: Integer read GetColCount;
    property RowSize: Integer read FRowSize write SetRowSize;
    property RowCount: Integer read FRowCount write SetRowCount;
    // keywords terminology
    property BITPIX: TBitPix read GetBITPIX;
    property NAXIS: Integer read GetNAXIS;
    property NAXIS1: Integer read GetNAXIS1;
    property NAXIS2: Integer read GetNAXIS2;
    property GCOUNT: Integer read GetGCOUNT;
    property PCOUNT: Integer read GetPCOUNT;
    property TFIELDS: Integer read GetTFIELDS;
  end;

  TFitsAscTableHead = class(TFitsUmitHead)
  private
    function GetUmit: TFitsAscTable;
  public
    constructor CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean); override;
    constructor CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec); override;
    property Umit: TFitsAscTable read GetUmit;
  end;

  TFitsAscTableData = class(TFitsUmitData)

  private

    FCellEnsure: TAscCellEnsure;

    function GetUmit: TFitsAscTable;

    function GetColName(Index: Integer): string;
    function GetColNature(Index: Integer): TAscNature;
    function GetCol(Index: Integer): TAscColumn;
    function GetColCount: Integer;
    function GetRowCount: Integer;
    function GetRowSize: Integer;
    function GetRow(Index: Integer): string;

    function AllowRead(const ACol, ARow, ACount, ALengthCells: Integer): Boolean;
    function AllowWrite(const ACol, ARow, ACount, ALengthCells: Integer): Boolean;
    function CharsToFloat(const AValue: string; const ACol, ARow: Integer; const AColumn: TAscColumn): Extended;
    function FloatToChars(const AValue: Extended; const ACapacity: Integer; ANature: TAscNature; const ANatureFormat: string; const AColumn: TAscColumn): string;
    procedure ReadCells(const ACol, ARow, ACount: Integer; ACells: Pointer; AType: TRepNumber); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; ACells: Pointer; AType: TRepNumber); overload;

    function GetCellsString(ACol, ARow: Integer): string;
    function GetCellsBoolean(ACol, ARow: Integer): Boolean;
    function GetCellsInteger(ACol, ARow: Integer): Int64;
    function GetCellsFloat(ACol, ARow: Integer): Extended;

    procedure SetCellsString(ACol, ARow: Integer; const Value: string);
    procedure SetCellsBoolean(ACol, ARow: Integer; const Value: Boolean);
    procedure SetCellsInteger(ACol, ARow: Integer; const Value: Int64);
    procedure SetCellsFloat(ACol, ARow: Integer; const Value: Extended);

  protected

    procedure Init; override;
    function Filler: Char; override;

  public

    constructor CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean); override;
    constructor CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec); override;

    property Umit: TFitsAscTable read GetUmit;

    { TODO  -cTFitsAscTableData : add methods to insert and delete cols }

    // function InsertCol(Index: Integer; const AColumn: TAscColumn): Integer;
    // function AddCol(const AColumn: TAscColumn): Integer;
    // procedure DeleteCol(Index: Integer);

    function IndexCol(const AName: string): Integer;
    property Cols[Index: Integer]: TAscColumn read GetCol;
    property ColsNature[Index: Integer]: TAscNature read GetColNature;
    property ColsName[Index: Integer]: string read GetColName;
    property ColCount: Integer read GetColCount;

    { TODO  -cTFitsAscTableData : add methods to insert and delete rows }

    // function InsertRow(Index: Integer; ACount: Integer = 1): Integer;
    // function AddRow(ACount: Integer = 1): Integer;
    // procedure DeleteRow(Index: Integer; ACount: Integer = 1);

    property Rows[Index: Integer]: string read GetRow;
    property RowSize: Integer read GetRowSize;
    property RowCount: Integer read GetRowCount;

    property CellEnsure: TAscCellEnsure read FCellEnsure write FCellEnsure;

    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TAStr); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TABol); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA80f); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA64f); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA32f); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA08c); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA08u); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA16c); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA16u); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA32c); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA32u); overload;
    procedure ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA64c); overload;

    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TAStr); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TABol); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA80f); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA64f); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA32f); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA08c); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA08u); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA16c); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA16u); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA32c); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA32u); overload;
    procedure WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA64c); overload;

    property CellsString[ACol, ARow: Integer]: string read GetCellsString write SetCellsString;
    property CellsBoolean[ACol, ARow: Integer]: Boolean read GetCellsBoolean write SetCellsBoolean;
    property CellsInteger[ACol, ARow: Integer]: Int64 read GetCellsInteger write SetCellsInteger;
    property CellsFloat[ACol, ARow: Integer]: Extended read GetCellsFloat write SetCellsFloat;

  end;

  TFitsAscTable = class(TFitsUmit)

  private

    function GetHead: TFitsAscTableHead;
    function GetData: TFitsAscTableData;

    function GetTFIELDS: Integer;
    function GetTBCOL(Number: Integer): Integer;
    function GetTFORM(Number: Integer): string;
    function GetTTYPE(Number: Integer): string;
    function GetTUNIT(Number: Integer): string;
    function GetTSCAL(Number: Integer): Extended;
    function GetTZERO(Number: Integer): Extended;
    function GetTNULL(Number: Integer): string;
    function GetTDISP(Number: Integer): string;
    function GetTDMIN(Number: Integer): Extended;
    function GetTDMAX(Number: Integer): Extended;
    function GetTLMIN(Number: Integer): Extended;
    function GetTLMAX(Number: Integer): Extended;

  protected

    function GetHeadClass: TFitsUmitHeadClass; override;
    function GetDataClass: TFitsUmitDataClass; override;
    function GetStateFamily: string; override;

  public

    constructor CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean); override;
    constructor CreateNewcomer(AContainer: TFitsContainer; ASpec: TFitsUmitSpec); override;
    property Head: TFitsAscTableHead read GetHead;
    property Data: TFitsAscTableData read GetData;

    property TFIELDS: Integer read GetTFIELDS;
    property TBCOLS[Number: Integer]: Integer read GetTBCOL;
    property TFORMS[Number: Integer]: string read GetTFORM;
    property TTYPES[Number: Integer]: string read GetTTYPE;
    property TUNITS[Number: Integer]: string read GetTUNIT;
    property TSCALS[Number: Integer]: Extended read GetTSCAL;
    property TZEROS[Number: Integer]: Extended read GetTZERO;
    property TNULLS[Number: Integer]: string read GetTNULL;
    property TDISPS[Number: Integer]: string read GetTDISP;
    property TDMINS[Number: Integer]: Extended read GetTDMIN;
    property TDMAXS[Number: Integer]: Extended read GetTDMAX;
    property TLMINS[Number: Integer]: Extended read GetTLMIN;
    property TLMAXS[Number: Integer]: Extended read GetTLMAX;

  end;

implementation

{ TAscColumn }

procedure AscColumnVerify(const AColumn: TAscColumn);
const
  MaxLenString = 66;
var
  C: Char;
  W, D: Integer;
begin
  if AColumn.Position <= 0 then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Position'], ERROR_ASCCOLUMN_POSITION);
  AscColumnDeform(AColumn, C, W, D);
  if Length(AColumn.Name) > MaxLenString then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Name'], ERROR_ASCCOLUMN_NAME);
  if Length(AColumn.Umit) > MaxLenString then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Ynit'], ERROR_ASCCOLUMN_UMIT);
  if Length(AColumn.Null) > MaxLenString then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Null'], ERROR_ASCCOLUMN_NULL);
  if Length(AColumn.Disp) > MaxLenString then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Disp'], ERROR_ASCCOLUMN_DISP);
end;

function AscColumnCreate(const APosition: Integer; const AForm: string; const AName: string = ''): TAscColumn;
begin
  Result.Position:= APosition;
  Result.Form := AForm;
  Result.Name := AName;
  Result.Umit := '';
  Result.Scal := Math.NaN;
  Result.Zero := Math.NaN;
  Result.Null := '';
  Result.Disp := '';
  Result.Dmin := Math.NaN;
  Result.Dmax := Math.NaN;
  Result.Lmin := Math.NaN;
  Result.Lmax := Math.NaN;
  AscColumnVerify(Result);
end;

function AscColumnCreateString(const APosition: Integer; const AWidth: Integer; const AName: string = ''): TAscColumn;
var
  Form: string;
begin
  Form := Format('A%d', [AWidth]);
  Result := AscColumnCreate(APosition, Form, AName);
end;

function AscColumnCreateNumber(const APosition: Integer; const ARep: TRepNumber; const AName: string = ''): TAscColumn;
var
  W, D: Integer;
  Form: string;
begin
  if ARep = repUnknown then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Form'], ERROR_ASCCOLUMN_FORM);
  if RepIsInteger(ARep) then
  begin
    case ARep of
      rep08c, rep08u: W := 1 + 3;
      rep16c, rep16u: W := 1 + 5;
      rep32c, rep32u: W := 1 + 10;
      else {rep64c}   W := 1 + 19;
    end;
    Form := Format('I%d', [W]);
    Result := AscColumnCreate(APosition, Form, AName);
    Result.Scal := 1.0;
    case ARep of
      rep08c: Result.Zero := cZero08c;
      rep16u: Result.Zero := cZero16u;
      rep32u: Result.Zero := cZero32u;
      else    Result.Zero := 0.0;
    end;
  end
  else
  begin
    {$IFDEF FPC}
    case ARep of
      rep80f: D := 14;
      rep64f: D := 14;
      else {rep32f} D := 8;
    end;
    {$ENDIF}
    {$IFDEF DCC}
    case ARep of
      rep80f: {$IFDEF HAS_EXTENDED_FLOAT} D := 20 {$ELSE} D := 16 {$ENDIF};
      rep64f: D := 16;
      else {rep32f} D := 8;
    end;
    {$ENDIF}
    W := 1 + 2 + D + 5;
    Form := Format('E%d.%d', [W, D]);
    Result := AscColumnCreate(APosition, Form, AName);
    Result.Scal := 1.0;
    Result.Zero := 0.0;
    Result.Null := 'Nan';
  end;
end;

procedure AscColumnDeform(const AColumn: TAscColumn; out C: Char; out W, D: Integer);
var
  S, Form: string;
  P, L: Integer;
begin
  Form := AColumn.Form;
  if Form = '' then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Form'], ERROR_ASCCOLUMN_FORM);
  C := Form[1];
  if Pos(C, 'AIFED') = 0 then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Form'], ERROR_ASCCOLUMN_FORM);
  P := Pos('.', Form);
  if (Pos(C, 'FED') > 0) and (P = 0) then
      raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Form'], ERROR_ASCCOLUMN_FORM);
  if Pos(C, 'AI') > 0 then
  begin
    L := Length(Form) - 1;
    S := Copy(Form, 2, L);
  end
  else
  begin
    L := P - 2;
    S := Copy(Form, 2, L);
  end;
  if not (TryStrToInt(S, W) and (W > 0)) then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Form'], ERROR_ASCCOLUMN_FORM);
  D := 0;
  if Pos(C, 'FED') > 0 then
  begin
    L := Length(Form) - P;
    S := Copy(Form, P + 1, L);
    if not (TryStrToInt(S, D) and (D > 0)) then
      raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Form'], ERROR_ASCCOLUMN_FORM);
  end;
  if W < D then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Form'], ERROR_ASCCOLUMN_FORM);
end;

procedure AscColumnDedisp(const AColumn: TAscColumn; out C: Char; out W, D: Integer);
var
  S, Disp: string;
  P: Integer;
begin
  Disp := IfThen(AColumn.Disp = '', AColumn.Form, AColumn.Disp);
  if Disp = '' then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Disp'], ERROR_ASCCOLUMN_DISP);
  // nature
  C := Disp[1];
  if Pos(C, 'AIBOZFEGD') = 0 then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Disp'], ERROR_ASCCOLUMN_DISP);
  // normalize
  if (Pos('EN', Disp) = 1) or (Pos('ES', Disp) = 1) then
    Delete(Disp, 2, 1);
  if (Pos('EN', Disp) = 1) or (Pos('ES', Disp) = 1) then
    Delete(Disp, 2, 1);
  P := DeLaFitsString.PosChar('E', Disp, 2);
  if P > 0 then
    Delete(Disp, P, Length(Disp));
  // width
  P := Pos('.', Disp);
  if P = 0 then
    P := Length(Disp) + 1;
  S := Copy(Disp, 2, P - 2);
  if not (TryStrToInt(S, W) and (W > 0)) then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Disp'], ERROR_ASCCOLUMN_DISP);
  // prec
  S := Copy(Disp, P + 1, Length(Disp));
  if S = '' then
    S := '0';
  if not (TryStrToInt(S, D) and (D >= 0)) then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Disp'], ERROR_ASCCOLUMN_DISP);
  // check
  if W < D then
    raise EFitsAscTableException.CreateFmt(SAscColumnIncorrectProp, ['Disp'], ERROR_ASCCOLUMN_DISP);
end;

function AscColumnCapacity(const AColumn: TAscColumn): Integer;
var
  C: Char;
  W, D: Integer;
begin
  AscColumnDeform(AColumn, C, W, D);
  Result := W;
end;

function AscColumnNature(const AColumn: TAscColumn): TAscNature;
var
  C: Char;
  W, D: Integer;
begin
  AscColumnDeform(AColumn, C, W, D);
  case C of
    'A': Result := anString;
    'I': Result := anInteger;
    else // if Pos(C, 'FED') > 0 then
         Result := anFloat;
  end;
end;

function AscColumnMakeup(const AColumn: TAscColumn): TAscNature;
var
  C: Char;
  W, D: Integer;
begin
  AscColumnDedisp(AColumn, C, W, D);
  if C = 'A' then
    Result := anString
  else if Pos(C, 'IBOZ') > 0 then
    Result := anInteger
  else // if Pos(C, 'FEGD') > 0 then
    Result := anFloat;
end;

function AscColumnNatureFormat(const AColumn: TAscColumn): string;
var
  C: Char;
  W, D: Integer;
begin
  AscColumnDeform(AColumn, C, W, D);
  case C of
    'A': Result := '%' + IntToStr(W) + 's';
    'I': Result := '%' + IntToStr(W) + '.' + IntToStr(D) + 'd';
    'F': Result := '%' + IntToStr(W) + '.' + IntToStr(D) + 'f';
    else // if Pos(C, 'ED') > 0 then
         Result := '%' + IntToStr(W) + '.' + IntToStr(D + 1) + 'e';
  end;
end;

function AscColumnMakeupFormat(const AColumn: TAscColumn): string;
var
  C: Char;
  W, D: Integer;
begin
  AscColumnDedisp(AColumn, C, W, D);
  if C = 'A' then
  begin
    Result := '%' + IntToStr(W) + 's';
    Exit;
  end;
  if Pos(C, 'IBO') > 0 then
  begin
    Result := '%' + IntToStr(W) + '.' + IntToStr(D) + 'd';
    Exit;
  end;
  if C = 'Z' then
  begin
    Result := '%' + IntToStr(W) + '.' + IntToStr(D) + 'x';
    Exit;
  end;
  if C = 'F' then
  begin
    Result := '%' + IntToStr(W) + '.' + IntToStr(D) + 'f';
    Exit;
  end;
  if Pos(C, 'ED') > 0 then
  begin
    Result := '%' + IntToStr(W) + '.' + IntToStr(D + 1) + 'e';
    Exit;
  end;
  // if C = 'G' then
  Result := '%' + IntToStr(W) + '.' + IntToStr(D) + 'g';
end;

{ TAscCell }

procedure AscCellEnsureDefault(var AValue: Extended; const ACol, ARow: Integer; const AColumn: TAscColumn);
var
  Lmin, Lmax: Extended;
begin
  Assert((ACol >= 0) and (ARow >= 0), SAssertionFailure);
  if not Math.IsNan(AValue) then
  begin
    Lmin := Math.IfThen(Math.IsNan(AColumn.Lmin), Math.NegInfinity, AColumn.Lmin);
    Lmax := Math.IfThen(Math.IsNan(AColumn.Lmax), Math.Infinity, AColumn.Lmax);
    AValue := Math.EnsureRange(AValue, Lmin, Lmax);
  end;
end;

{ TFitsAscTableSpec }

procedure TFitsAscTableSpec.SetPretty(const Value: Boolean);
begin
  if FPretty <> Value then
  begin
    FPretty := Value;
    DoPretty;
  end;
end;

procedure TFitsAscTableSpec.DoPretty;
begin
  if FPretty then
  begin
    OrderCols;
    FRowSize := GetAutoRowSize;
  end;
end;

procedure TFitsAscTableSpec.VerifyCol(const NewColumn: TAscColumn);
var
  R: Integer;
begin
  AscColumnVerify(NewColumn);
  if not FPretty then
  begin
    R := NewColumn.Position + AscColumnCapacity(NewColumn);
    if R > FRowSize then
      raise EFitsAscTableException.Create(SAscTableSpecIncorrectColumn, ERROR_ASCTABLE_SPEC_COLUMN);
  end;
end;

procedure TFitsAscTableSpec.ReleaseCol(Index: Integer);
var
  P: PAscColumn;
begin
  P := FCols[Index];
  Dispose(P);
  FCols[Index] := nil;
end;

function TFitsAscTableSpec.GetCol(Index: Integer): TAscColumn;
var
  P: PAscColumn;
begin
  P := FCols[Index];
  Result := P^;
end;

procedure TFitsAscTableSpec.SetCol(Index: Integer; const Value: TAscColumn);
var
  P: PAscColumn;
begin
  VerifyCol(Value);
  P  := FCols[Index];
  P^ := Value;
end;

procedure TFitsAscTableSpec.OrderCols;
var
  I, X: Integer;
  P: PAscColumn;
begin
  X := 1;
  for I := 0 to FCols.Count - 1 do
  begin
    P := FCols[I];
    P^.Position := X;
    X := X + AscColumnCapacity(P^) + 1; // ~ space character between fields
  end;
end;

function TFitsAscTableSpec.GetColCount: Integer;
begin
  Result := FCols.Count;
end;

function TFitsAscTableSpec.GetAutoRowSize: Integer;
var
  I, X: Integer;
  C: TAscColumn;
begin
  Result := 0;
  for I := 0 to ColCount - 1 do
  begin
    C := Cols[I];
    X := C.Position + AscColumnCapacity(C) - 1;
    Result := Math.Max(Result, X);
  end;
end;

procedure TFitsAscTableSpec.SetRowSize(const Value: Integer);
var
  R: Integer;
begin
  if FPretty then
    raise EFitsAscTableException.CreateFmt(SAscTableSpecIncorrectProp, ['RowSize'], ERROR_ASCTABLE_SPEC_ROWSIZE);
  R := GetAutoRowSize;
  if Value < R then
    raise EFitsAscTableException.CreateFmt(SAscTableSpecIncorrectProp, ['RowSize'], ERROR_ASCTABLE_SPEC_ROWSIZE);
  FRowSize := Value;
end;

procedure TFitsAscTableSpec.SetRowCount(const Value: Integer);
begin
  if Value < 0 then
    raise EFitsAscTableException.CreateFmt(SAscTableSpecIncorrectProp, ['RowCount'], ERROR_ASCTABLE_SPEC_ROWCOUNT);
  FRowCount := Value;
end;

constructor TFitsAscTableSpec.Create;
begin
  inherited Create;
  FPretty := True;
  FCols := TList.Create;
  FRowCount := 0;
  FRowSize := 0;
end;

constructor TFitsAscTableSpec.Create(const AColumns: array of TAscColumn; const ARowCount: Integer; APretty: Boolean);
var
  I: Integer;
begin
  inherited Create;
  FPretty := APretty;
  FCols := TList.Create;
  FRowCount := 0;
  FRowSize := 0;
  for I := Low(AColumns) to High(AColumns) do
    AddCol(AColumns[I]);
  RowCount := ARowCount;
end;

constructor TFitsAscTableSpec.Create(AUmit: TFitsAscTable; APretty: Boolean);
var
  I: Integer;
  C: TAscColumn;
  P: PAscColumn;
begin
  inherited Create;
  // init
  FPretty := APretty;
  FCols := TList.Create;
  FRowCount := 0;
  FRowSize := 0;
  // check
  if not Assigned(AUmit) then
    raise EFitsAscTableException.Create(SAscTableSpecIncorrectUmit, ERROR_ASCTABLE_SPEC_UMIT);
  Assert(Assigned(AUmit.Data), SHeadNotAssign);
  // setup
  for I := 0 to AUmit.Data.ColCount - 1 do
  begin
    C := AUmit.Data.Cols[I];
    New(P);
    P^ := C;
    FCols.Add(P);
  end;
  DoPretty;
  if not FPretty then
    RowSize := AUmit.Data.RowSize;
  RowCount := AUmit.Data.RowCount;
end;

destructor TFitsAscTableSpec.Destroy;
var
  I: Integer;
begin
  for I := 0 to FCols.Count - 1 do
    ReleaseCol(I);
  FCols.Free;
  inherited;
end;

function TFitsAscTableSpec.InsertCol(Index: Integer; const AColumn: TAscColumn): Integer;
var
  P: PAscColumn;
begin
  if ColCount = cMaxFields then
    raise EFitsAscTableException.CreateFmt(SAscTableSpecIncorrectProp, ['ColCount'], ERROR_ASCTABLE_SPEC_COLCOUNT);
  VerifyCol(AColumn);
  New(P);
  P^ := AColumn;
  FCols.Insert(Index, P);
  Result := Index;
  DoPretty;
end;

function TFitsAscTableSpec.AddCol(const AColumn: TAscColumn): Integer;
begin
  Result := InsertCol(ColCount, AColumn);
end;

procedure TFitsAscTableSpec.DeleteCol(Index: Integer);
begin
  ReleaseCol(Index);
  FCols.Delete(Index);
  DoPretty;
end;

function TFitsAscTableSpec.GetBITPIX: TBitPix;
begin
  Result := bi08u;
end;

function TFitsAscTableSpec.GetNAXIS: Integer;
begin
  Result := 2;
end;

function TFitsAscTableSpec.GetNAXIS1: Integer;
begin
  Result := Self.RowSize;
end;

function TFitsAscTableSpec.GetNAXIS2: Integer;
begin
  Result := Self.RowCount;
end;

function TFitsAscTableSpec.GetGCOUNT: Integer;
begin
  Result := 1;
end;

function TFitsAscTableSpec.GetPCOUNT: Integer;
begin
  Result := 0;
end;

function TFitsAscTableSpec.GetTFIELDS: Integer;
begin
  Result := Self.ColCount;
end;

{ TFitsAscTableHead }

constructor TFitsAscTableHead.CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean);
var
  Number, Capacities: Integer;
  Column: TAscColumn;
begin

  inherited;

  // check required cards

  if Umit.Family <> Umit.StateFamily then
    raise EFitsAscTableException.CreateFmt(SAscTableHeadIncorrectValue, [cXTENSION, Umit.Index], ERROR_ASCTABLE_HEAD_INCORRECT_NAME);

  if Umit.BITPIX <> 8 then
    raise EFitsAscTableException.CreateFmt(SAscTableHeadIncorrectValue, [cBITPIX, Umit.Index], ERROR_ASCTABLE_HEAD_INCORRECT_BITPIX);

  if Umit.NAXIS <> 2 then
    raise EFitsAscTableException.CreateFmt(SAscTableHeadIncorrectValue, [cNAXIS, Umit.Index], ERROR_ASCTABLE_HEAD_INCORRECT_NAXIS);

  Capacities := 0;
  Column := AscColumnCreate(1, 'A1');
  for Number := 1 to Umit.TFIELDS do
  begin
    Column.Position := Umit.TBCOLS[Number];
    Column.Form := Umit.TFORMS[Number];
    Capacities := Math.Max(Capacities, Column.Position + AscColumnCapacity(Column) - 1);
  end;
  if Umit.NAXES[1] < Capacities then
    raise EFitsAscTableException.CreateFmt(SAscTableHeadIncorrectValue, [cNAXIS1, Umit.Index], ERROR_ASCTABLE_HEAD_INCORRECT_NAXIS1);

end;

constructor TFitsAscTableHead.CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec);
var
  Spec: TFitsAscTableSpec;
  Column: TAscColumn;
  I, Hop, Num: Integer;
begin
  inherited;

  // add spec fields

  Spec := ASpec as TFitsAscTableSpec;

  AppendInteger(cBITPIX, BitPixToInt(Spec.BITPIX), 'Number of bits per data value');

  Hop := AppendInteger(cNAXIS, Spec.NAXIS, 'Number of axes') + 1;
  Hop := AppendInteger(cNAXIS1, Spec.NAXIS1, '', Hop) + 1;
  Hop := AppendInteger(cNAXIS2, Spec.NAXIS2, '', Hop) + 1;
  Hop := AppendInteger(cPCOUNT, Spec.PCOUNT, 'Parameter count', Hop) + 1;
  Hop := AppendInteger(cGCOUNT, Spec.GCOUNT, 'Group count', Hop) + 1;

  Hop := AppendInteger(cTFIELDS, Spec.TFIELDS, 'Number of fields', Hop) + 1;
  for I := 0 to Spec.ColCount - 1 do
  begin
    Column := Spec.Cols[I];
    Num := I + 1;
    Hop := AppendInteger(Format(cTBCOLn, [Num]), Column.Position, '', Hop) + 1;
    Hop := AppendString(Format(cTFORMn, [Num]), Column.Form, '', Hop) + 1;
    if Trim(Column.Name) <> ''     then Hop := AppendString(Format(cTTYPEn, [Num]), Trim(Column.Name), '', Hop) + 1;
    if Trim(Column.Umit) <> ''     then Hop := AppendString(Format(cTUNITn, [Num]), Trim(Column.Umit), '', Hop) + 1;
    if not Math.IsNan(Column.Scal) then Hop := AppendFloat(Format(cTSCALn, [Num]), Column.Scal, '', Hop) + 1;
    if not Math.IsNan(Column.Zero) then Hop := AppendFloat(Format(cTZEROn, [Num]), Column.Zero, '', Hop) + 1;
    if Trim(Column.Null) <> ''     then Hop := AppendString(Format(cTNULLn, [Num]), Trim(Column.Null), '', Hop) + 1;
    if Trim(Column.Disp) <> ''     then Hop := AppendString(Format(cTDISPn, [Num]), Trim(Column.Disp), '', Hop) + 1;
    if not Math.IsNan(Column.Dmin) then Hop := AppendFloat(Format(cTDMINn, [Num]), Column.Dmin, '', Hop) + 1;
    if not Math.IsNan(Column.Dmax) then Hop := AppendFloat(Format(cTDMAXn, [Num]), Column.Dmax, '', Hop) + 1;
    if not Math.IsNan(Column.Lmin) then Hop := AppendFloat(Format(cTLMINn, [Num]), Column.Lmin, '', Hop) + 1;
    if not Math.IsNan(Column.Lmax) then Hop := AppendFloat(Format(cTLMAXn, [Num]), Column.Lmax, '', Hop) + 1;
  end;
end;

function TFitsAscTableHead.GetUmit: TFitsAscTable;
begin
  Result := inherited Umit as TFitsAscTable;
end;

{ TFitsAscTableData }

function TFitsAscTableData.GetUmit: TFitsAscTable;
begin
  Result := inherited Umit as TFitsAscTable;
end;

function TFitsAscTableData.GetRow(Index: Integer): string;
var
  lRowSize: Int64;
begin
  if (Index < 0) or (Index >= RowCount) then
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectRowIndex, [Index, Umit.Index], ERROR_ASCTABLE_DATA_GETROW_INDEX);
  lRowSize := RowSize;
  Result := '';
  Umit.Container.Content.ReadString(Offset + lRowSize * Index, lRowSize, Result);
end;

function TFitsAscTableData.GetRowCount: Integer;
begin
  Result := Umit.NAXES[2];
end;

function TFitsAscTableData.GetRowSize: Integer;
begin
  Result := Umit.NAXES[1];
end;

function TFitsAscTableData.IndexCol(const AName: string): Integer;
var
  I: Integer;
  lName1, lName2: string;
begin
  Result := -1;
  lName1 := Trim(AName);
  for I := 0 to ColCount - 1 do
  begin
    lName2 := ColsName[I];
    if SameText(lName1, lName2) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TFitsAscTableData.AllowRead(const ACol, ARow, ACount, ALengthCells: Integer): Boolean;
begin
  if not Math.InRange(ACol, 0, ColCount - 1) then
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectColIndex, [ACol, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWREAD_COL);
  if not Math.InRange(ARow, 0, RowCount - 1) then
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectRowIndex, [ARow, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWREAD_ROW);
  if (ACount < 0) or (ARow + ACount > RowCount) then
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectCellsCount, [ACount, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWREAD_COUNT);
  if ACount > ALengthCells then
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectCellsLength, [ALengthCells, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWREAD_LENGTH);
  Result := ACount > 0;
end;

function TFitsAscTableData.AllowWrite(const ACol, ARow, ACount, ALengthCells: Integer): Boolean;
begin
  if not Math.InRange(ACol, 0, ColCount - 1) then
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectColIndex, [ACol, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWWRITE_COL);
  if not Math.InRange(ARow, 0, RowCount - 1) then
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectRowIndex, [ARow, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWWRITE_ROW);
  if (ACount < 0) or (ARow + ACount > RowCount) then
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectCellsCount, [ACount, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWWRITE_COUNT);
  if ACount > ALengthCells then
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectCellsLength, [ALengthCells, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWWRITE_LENGTH);
  Result := ACount > 0;
end;

function TFitsAscTableData.CharsToFloat(const AValue: string;
  const ACol, ARow: Integer; const AColumn: TAscColumn): Extended;
var
  S: string;
  Scal, Zero: Extended;
begin
  S := Trim(AValue);
  // convert
  if S = '' then
    Result := 0.0
  else if SameText(S, AColumn.Null) then
    Result := Math.NaN
  else
    Result := DeLaFitsString.StriToFloat(S);
  // scale
  if not Math.IsNan(Result) then
  begin
    Scal := Math.IfThen(Math.IsNan(AColumn.Scal), 1.0, AColumn.Scal);
    Zero := Math.IfThen(Math.IsNan(AColumn.Zero), 0.0, AColumn.Zero);
    Result := Result * Scal + Zero;
  end;
  // ensure range
  if Assigned(@FCellEnsure) then
    FCellEnsure(Result, ACol, ARow, AColumn);
end;

function TFitsAscTableData.FloatToChars(const AValue: Extended;
  const ACapacity: Integer; ANature: TAscNature; const ANatureFormat: string;
  const AColumn: TAscColumn): string;
var
  Valu: Extended;
  Scal, Zero: Extended;
begin
  Valu := AValue;
  // scale
  if not Math.IsNan(Valu) then
  begin
    Scal := Math.IfThen(Math.IsNan(AColumn.Scal), 1.0, AColumn.Scal);
    Zero := Math.IfThen(Math.IsNan(AColumn.Zero), 0.0, AColumn.Zero);
    Valu := (Valu - Zero) / Scal;
  end;
  // covert and align
  if Math.IsNan(Valu) and (AColumn.Null <> '') then
  begin
    Result := AColumn.Null;
    Result := DeLaFitsString.AlignStrict(Result, -ACapacity);
  end
  else
  begin
    case ANature of
      anString: Result := DeLaFitsString.FloatToStri(Valu);
      anInteger: Result := DeLaFitsString.IntToStri(DeLaFitsMath.Round64c(Valu), False, ANatureFormat);
      else { anFloat:} Result := DeLaFitsString.FloatToStri(Valu, False, ANatureFormat);
    end;
    if Length(Result) > ACapacity then
      Result := Trim(Result);
    Result := DeLaFitsString.AlignStrict(Result, ACapacity);
  end;
end;

function TFitsAscTableData.GetCellsString(ACol, ARow: Integer): string;
var
  A: TAStr;
begin
  try
    A := nil;
    SetLength(A, 1);
    ReadCells(ACol, ARow, 1, A);
    Result := A[0];
  finally
    A := nil;
  end;
end;

function TFitsAscTableData.GetCellsBoolean(ACol, ARow: Integer): Boolean;
var
  A: TABol;
begin
  try
    A := nil;
    SetLength(A, 1);
    ReadCells(ACol, ARow, 1, A);
    Result := A[0];
  finally
    A := nil;
  end;
end;

function TFitsAscTableData.GetCellsInteger(ACol, ARow: Integer): Int64;
var
  A: TA64c;
begin
  try
    A := nil;
    SetLength(A, 1);
    ReadCells(ACol, ARow, 1, A);
    Result := A[0];
  finally
    A := nil;
  end;
end;

function TFitsAscTableData.GetCellsFloat(ACol, ARow: Integer): Extended;
var
  A: TA80f;
begin
  try
    A := nil;
    SetLength(A, 1);
    ReadCells(ACol, ARow, 1, A);
    Result := A[0];
  finally
    A := nil;
  end;
end;

procedure TFitsAscTableData.SetCellsString(ACol, ARow: Integer; const Value: string);
var
  A: TAStr;
begin
  try
    A := nil;
    SetLength(A, 1);
    A[0] := Value;
    WriteCells(ACol, ARow, 1, A);
  finally
    A := nil;
  end;
end;

procedure TFitsAscTableData.SetCellsBoolean(ACol, ARow: Integer; const Value: Boolean);
var
  A: TABol;
begin
  try
    A := nil;
    SetLength(A, 1);
    A[0] := Value;
    WriteCells(ACol, ARow, 1, A);
  finally
    A := nil;
  end;
end;

procedure TFitsAscTableData.SetCellsInteger(ACol, ARow: Integer; const Value: Int64);
var
  A: TA64c;
begin
  try
    A := nil;
    SetLength(A, 1);
    A[0] := Value;
    WriteCells(ACol, ARow, 1, A);
  finally
    A := nil;
  end;
end;

procedure TFitsAscTableData.SetCellsFloat(ACol, ARow: Integer; const Value: Extended);
var
  A: TA80f;
begin
  try
    A := nil;
    SetLength(A, 1);
    A[0] := Value;
    WriteCells(ACol, ARow, 1, A);
  finally
    A := nil;
  end;
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TAStr);
var
  I: Integer;
  MakeupFormat, S: string;
  LC, LR, P0: Int64;
  Value: Extended;
  Nature, Makeup: TAscNature;
  Column: TAscColumn;
begin
  if not AllowRead(ACol, ARow, ACount, Length(ACells)) then
    Exit;
  Column := Self.Cols[ACol];
  Nature := AscColumnNature(Column);
  Makeup := AscColumnMakeup(Column);
  MakeupFormat := AscColumnMakeupFormat(Column);
  LC := AscColumnCapacity(Column);
  LR := Self.RowSize;
  P0 := Self.Offset + ARow * LR + Int64(Column.Position) - 1;
  S := '';
  for I := 0 to ACount - 1 do
  begin
    Umit.Container.Content.ReadString(P0 + I * LR, LC, S);
    if Nature > anString then
    begin
      Value := CharsToFloat(S, ACol, ARow + I, Column);
      case Makeup of
        anString:  S := DeLaFitsString.FloatToStri(Value);
        anInteger: S := DeLaFitsString.IntToStri(DeLaFitsMath.Round64c(Value), False, MakeupFormat);
        anFloat:   S := DeLaFitsString.FloatToStri(Value, False, MakeupFormat);
      end;
    end;
    ACells[I] := Trim(S);
  end;
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TABol);
var
  I: Integer;
  S: string;
  LC, LR, P0: Int64;
  Nature: TAscNature;
  Column: TAscColumn;
begin
  if not AllowRead(ACol, ARow, ACount, Length(ACells)) then
    Exit;
  Column := Self.Cols[ACol];
  Nature := AscColumnNature(Column);
  if (Nature <> anString) then
  begin
    S := DeLaFitsCommon.IfThen(Nature = anInteger, 'Integer', 'Float');
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectColNature, [S, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWREAD_NATURE);
  end;
  LC := AscColumnCapacity(Column);
  LR := Self.RowSize;
  P0 := Self.Offset + ARow * LR + Int64(Column.Position) - 1;
  S := '';
  for I := 0 to ACount - 1 do
  begin
    Umit.Container.Content.ReadString(P0 + I * LR, LC, S);
    ACells[I] := DeLaFitsString.StriToBol(S);
  end;
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; ACells: Pointer; AType: TRepNumber);
var
  I: Integer;
  S: string;
  LC, LR, P0: Int64;
  Value: Extended;
  Column: TAscColumn;
begin
  Assert(AType > repUnknown, SAssertionFailure);
  if not AllowRead(ACol, ARow, ACount, Length(TA08u(ACells))) then
    Exit;
  Column := Self.Cols[ACol];
  LC := AscColumnCapacity(Column);
  LR := Self.RowSize;
  P0 := Self.Offset + ARow * LR + Int64(Column.Position) - 1;
  S := '';
  for I := 0 to ACount - 1 do
  begin
    Umit.Container.Content.ReadString(P0 + I * LR, LC, S);
    Value := CharsToFloat(S, ACol, ARow + I, Column);
    case AType of
      rep80f: TA80f(ACells)[I] := Value;
      rep64f: TA64f(ACells)[I] := DeLaFitsMath.Ensure64f(Value);
      rep32f: TA32f(ACells)[I] := DeLaFitsMath.Ensure32f(Value);
      rep08c: TA08c(ACells)[I] := DeLaFitsMath.Round08c(Value);
      rep08u: TA08u(ACells)[I] := DeLaFitsMath.Round08u(Value);
      rep16c: TA16c(ACells)[I] := DeLaFitsMath.Round16c(Value);
      rep16u: TA16u(ACells)[I] := DeLaFitsMath.Round16u(Value);
      rep32c: TA32c(ACells)[I] := DeLaFitsMath.Round32c(Value);
      rep32u: TA32u(ACells)[I] := DeLaFitsMath.Round32u(Value);
      rep64c: TA64c(ACells)[I] := DeLaFitsMath.Round64c(Value);
    end;
  end;
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA80f);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep80f);
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA64f);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep64f);
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA32f);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep32f);
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA08c);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep08c);
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA08u);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep08u);
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA16c);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep16c);
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA16u);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep16u);
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA32c);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep32c);
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA32u);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep32u);
end;

procedure TFitsAscTableData.ReadCells(const ACol, ARow, ACount: Integer; var ACells: TA64c);
begin
  ReadCells(ACol, ARow, ACount, Pointer(ACells), rep64c);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TAStr);
var
  I, Capacity: Integer;
  NatureFormat, S: string;
  lRowSize, P0: Int64;
  Value: T80f;
  Nature, Makeup: TAscNature;
  Column: TAscColumn;
begin
  if not AllowWrite(ACol, ARow, ACount, Length(TA08u(ACells))) then
    Exit;
  Column := Self.Cols[ACol];
  Nature := AscColumnNature(Column);
  Makeup := AscColumnMakeup(Column);
  NatureFormat := AscColumnNatureFormat(Column);
  Capacity := AscColumnCapacity(Column);
  lRowSize := Self.RowSize;
  P0 := Self.Offset + ARow * lRowSize + Int64(Column.Position) - 1;
  for I := 0 to ACount - 1 do
  begin
    if Makeup = anString then
    begin
      S := ACells[I];
      if Length(S) > Capacity then
        S := Trim(S);
      S := DeLaFitsString.AlignStrict(S, Capacity);
    end
    else
    begin
      Value := DeLaFitsString.StriToFloat(ACells[I]);
      S := FloatToChars(Value, Capacity, Nature, NatureFormat, Column);
    end;
    Umit.Container.Content.WriteString(P0 + I * lRowSize, Capacity, S);
  end;
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TABol);
var
  I, Capacity: Integer;
  S: string;
  lRowSize, P0: Int64;
  Nature: TAscNature;
  Column: TAscColumn;
begin
  if not AllowWrite(ACol, ARow, ACount, Length(ACells)) then
    Exit;
  Column := Self.Cols[ACol];
  Nature := AscColumnNature(Column);
  if (Nature <> anString) then
  begin
    S := DeLaFitsCommon.IfThen(Nature = anInteger, 'Integer', 'Float');
    raise EFitsAscTableException.CreateFmt(SAscTableDataIncorrectColNature, [S, Umit.Index], ERROR_ASCTABLE_DATA_ALLOWWRITE_NATURE);
  end;
  Capacity := AscColumnCapacity(Column);
  lRowSize := Self.RowSize;
  P0 := Self.Offset + ARow * lRowSize + Int64(Column.Position) - 1;
  for I := 0 to ACount - 1 do
  begin
    S := DeLaFitsString.BolToStri(ACells[I]);
    S := DeLaFitsString.AlignStrict(S, Capacity);
    Umit.Container.Content.WriteString(P0 + I * lRowSize, Capacity, S);
  end;
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; ACells: Pointer; AType: TRepNumber);
var
  I, Capacity: Integer;
  NatureFormat, S: string;
  lRowSize, P0: Int64;
  Value: Extended;
  Nature: TAscNature;
  Column: TAscColumn;
begin
  Assert(AType > repUnknown, SAssertionFailure);
  if not AllowWrite(ACol, ARow, ACount, Length(TA08u(ACells))) then
    Exit;
  Column := Self.Cols[ACol];
  Nature := AscColumnNature(Column);
  NatureFormat := AscColumnNatureFormat(Column);
  Capacity := AscColumnCapacity(Column);
  lRowSize := Self.RowSize;
  P0 := Self.Offset + ARow * lRowSize + Int64(Column.Position) - 1;
  for I := 0 to ACount - 1 do
  begin
    case AType of
      rep80f: Value := TA80f(ACells)[I];
      rep64f: Value := TA64f(ACells)[I];
      rep32f: Value := TA32f(ACells)[I];
      rep08c: Value := TA08c(ACells)[I];
      rep08u: Value := TA08u(ACells)[I];
      rep16c: Value := TA16c(ACells)[I];
      rep16u: Value := TA16u(ACells)[I];
      rep32c: Value := TA32u(ACells)[I];
      rep32u: Value := TA32c(ACells)[I];
      else // rep64c:
              Value := TA64c(ACells)[I];
    end;
    S := FloatToChars(Value, Capacity, Nature, NatureFormat, Column);
    Umit.Container.Content.WriteString(P0 + I * lRowSize, Capacity, S);
  end;
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA80f);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep80f);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA64f);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep64f);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA32f);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep32f);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA08c);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep08c);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA08u);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep08u);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA16c);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep16c);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA16u);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep16u);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA32c);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep32c);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA32u);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep32u);
end;

procedure TFitsAscTableData.WriteCells(const ACol, ARow, ACount: Integer; const ACells: TA64c);
begin
  WriteCells(ACol, ARow, ACount, Pointer(ACells), rep64c);
end;

function TFitsAscTableData.GetColName(Index: Integer): string;
begin
  Result := Umit.TTYPES[Index + 1];
end;

function TFitsAscTableData.GetColNature(Index: Integer): TAscNature;
var
  Form: string;
  Column: TAscColumn;
begin
  Form := Umit.TFORMS[Index + 1];
  Column := AscColumnCreate(1, Form);
  Result := AscColumnNature(Column);
end;

function TFitsAscTableData.GetCol(Index: Integer): TAscColumn;
var
  Number: Integer;
begin
  Number := Index + 1;
  Result.Position := Umit.TBCOLS[Number];
  Result.Form := Umit.TFORMS[Number];
  Result.Name := Umit.TTYPES[Number];
  Result.Umit := Umit.TUNITS[Number];
  Result.Scal := Umit.TSCALS[Number];
  Result.Zero := Umit.TZEROS[Number];
  Result.Null := Umit.TNULLS[Number];
  Result.Disp := Umit.TDISPS[Number];
  Result.Dmin := Umit.TDMINS[Number];
  Result.Dmax := Umit.TDMAXS[Number];
  Result.Lmin := Umit.TLMINS[Number];
  Result.Lmax := Umit.TLMAXS[Number];
  AscColumnVerify(Result);
end;

function TFitsAscTableData.GetColCount: Integer;
begin
  Result := Umit.TFIELDS;
end;

procedure TFitsAscTableData.Init;
begin
  inherited;
  FCellEnsure := @AscCellEnsureDefault;
end;

function TFitsAscTableData.Filler: Char;
begin
  Result := cChrBlank;
end;

constructor TFitsAscTableData.CreateExplorer(AUmit: TFitsUmit; APioneer: Boolean);
begin
  inherited;
end;

constructor TFitsAscTableData.CreateNewcomer(AUmit: TFitsUmit; ASpec: TFitsUmitSpec);
var
  lCize, lSize: Int64;
begin

  inherited;

  // set true size

  lCize := Cize;
  lSize := Size;
  if lCize > lSize then
  begin
    Add(lCize - lSize);
    Erase(0, lCize - lSize);
  end
  else if lCize < lSize then
    Truncate(lSize - lCize);

end;

{ TFitsAscTable }

constructor TFitsAscTable.CreateExplorer(AContainer: TFitsContainer; APioneer: Boolean);
begin
  inherited;
end;

constructor TFitsAscTable.CreateNewcomer(AContainer: TFitsContainer; ASpec: TFitsUmitSpec);
var
  Spec: TFitsAscTableSpec;
begin

  // set default spec

  if not Assigned(ASpec) then
  begin
    Spec := TFitsAscTableSpec.Create;
    try
      inherited CreateNewcomer(AContainer, Spec);
    finally
      Spec.Free;
    end
  end

  // check spec class

  else if not (ASpec is TFitsAscTableSpec) then
    raise EFitsAscTableException.Create(SAscTableSpecInvalid, ERROR_ASCTABLE_SPEC_INVALID)

  else
    inherited;

end;

function TFitsAscTable.GetData: TFitsAscTableData;
begin
  Result := inherited Data as TFitsAscTableData;
end;

function TFitsAscTable.GetDataClass: TFitsUmitDataClass;
begin
  Result := TFitsAscTableData;
end;

function TFitsAscTable.GetHead: TFitsAscTableHead;
begin
  Result := inherited Head as TFitsAscTableHead;
end;

function TFitsAscTable.GetHeadClass: TFitsUmitHeadClass;
begin
  Result := TFitsAscTableHead;
end;

function TFitsAscTable.GetStateFamily: string;
begin
  Result := 'TABLE';
end;

function TFitsAscTable.GetTFIELDS: Integer;
const
  Key = cTFIELDS;
var
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  Ind := Head.IndexOf(Key);
  if Ind < 0 then
    raise EFitsAscTableException.CreateFmt(SKeywordNotFound, [Key, Self.Index], ERROR_ASCTABLE_GETFIELDS_NOTFOUND);
  try
    Result := Integer(Head.ValuesInteger[Ind]);
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETFIELDS_INVALID);
  end;
  if not InRange(Result, 0, cMaxFields) then
    raise EFitsAscTableException.CreateFmt(SLineValueIncorrect, [Ind, Self.Index], ERROR_ASCTABLE_GETFIELDS_INCORRECT);
end;

function TFitsAscTable.GetTBCOL(Number: Integer): Integer;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTBCOL_NUMBER);
  Key := Format(cTBCOLn, [Number]);
  Ind := Head.IndexOf(Key);
  if Ind < 0 then
    raise EFitsAscTableException.CreateFmt(SKeywordNotFound, [Key, Self.Index], ERROR_ASCTABLE_GETTBCOL_NOTFOUND);
  try
    Result := Integer(Head.ValuesInteger[Ind]);
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTBCOL_INVALID);
  end;
  if Result < 1 then
    raise EFitsAscTableException.CreateFmt(SLineValueIncorrect, [Ind, Self.Index], ERROR_ASCTABLE_GETTBCOL_INCORRECT);
end;

function TFitsAscTable.GetTFORM(Number: Integer): string;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTFORM_NUMBER);
  Key := Format(cTFORMn, [Number]);
  Ind := Head.IndexOf(Key);
  if Ind < 0 then
    raise EFitsAscTableException.CreateFmt(SKeywordNotFound, [Key, Self.Index], ERROR_ASCTABLE_GETTFORM_NOTFOUND);
  try
    Result := Head.ValuesString[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTFORM_INVALID);
  end;
  try
    AscColumnCreate(1, Result);
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTFORM_INCORRECT);
  end;
end;

function TFitsAscTable.GetTTYPE(Number: Integer): string;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTTYPE_NUMBER);
  Key := Format(cTTYPEn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := ''
    else
      Result := Head.ValuesString[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTTYPE_INVALID);
  end;
end;

function TFitsAscTable.GetTUNIT(Number: Integer): string;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTUNIT_NUMBER);
  Key := Format(cTUNITn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := ''
    else
      Result := Head.ValuesString[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTUNIT_INVALID);
  end;
end;

function TFitsAscTable.GetTSCAL(Number: Integer): Extended;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTSCAL_NUMBER);
  Key := Format(cTSCALn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := 1.0
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTSCAL_INVALID);
  end;
end;

function TFitsAscTable.GetTZERO(Number: Integer): Extended;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTZERO_NUMBER);
  Key := Format(cTZEROn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := 0.0
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTZERO_INVALID);
  end;
end;

function TFitsAscTable.GetTNULL(Number: Integer): string;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTNULL_NUMBER);
  Key := Format(cTNULLn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := ''
    else
      Result := Head.ValuesString[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTNULL_INVALID);
  end;
end;

function TFitsAscTable.GetTDISP(Number: Integer): string;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTDISP_NUMBER);
  Key := Format(cTDISPn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := Self.TFORMS[Number]
    else
      Result := Head.ValuesString[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTDISP_INVALID);
  end;
end;

function TFitsAscTable.GetTDMIN(Number: Integer): Extended;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTDMIN_NUMBER);
  Key := Format(cTDMINn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := Math.NaN
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTDMIN_INVALID);
  end;
end;

function TFitsAscTable.GetTDMAX(Number: Integer): Extended;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTDMAX_NUMBER);
  Key := Format(cTDMAXn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := Math.NaN
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTDMAX_INVALID);
  end;
end;

function TFitsAscTable.GetTLMIN(Number: Integer): Extended;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTLMIN_NUMBER);
  Key := Format(cTLMINn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := Math.NaN
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTLMIN_INVALID);
  end;
end;

function TFitsAscTable.GetTLMAX(Number: Integer): Extended;
var
  Key: string;
  Ind: Integer;
begin
  Assert(Assigned(Head), SHeadNotAssign);
  if not Math.InRange(Number, 1, Self.TFIELDS) then
    raise EFitsAscTableException.CreateFmt(SListIndexOutBounds, [Number], ERROR_ASCTABLE_GETTLMAX_NUMBER);
  Key := Format(cTLMAXn, [Number]);
  Ind := Head.IndexOf(Key);
  try
    if Ind < 0 then
      Result := Math.NaN
    else
      Result := Head.ValuesFloat[Ind];
  except
    on E: Exception do
      raise EFitsAscTableException.CreateFmt(SLineErrorParse, [Ind, Self.Index], E.Message, ERROR_ASCTABLE_GETTLMAX_INVALID);
  end;
end;

end.
