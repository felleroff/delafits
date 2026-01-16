{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{             Typed keyword-value property             }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsProp;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Math, DeLaFitsCommon, DeLaFitsString;

{$I DeLaFitsSuppress.inc}

const

  { The codes of exceptions }

  ERROR_PROP               = 4000;

  ERROR_PROPLIST_INDEX     = 4100;
  ERROR_PROPLIST_DUPLICATE = 4101;

resourcestring

  { The messages of exceptions }

  SPropListIndexOutBounds = 'Index "%d" is out of prop list bounds "COUNT=%d"';
  SPropListDuplicate      = 'Prop list does not allow duplicates. Prop "%s" already exists';

  SPropIncorrectValue     = 'Incorrect prop value "%s=%s"';
  SPropAxisOutBounds      = 'Prop "%s" out of bounds "NAXIS=%d"';
  SPropFieldOutBounds     = 'Prop "%s" out of bounds "TFIELDS=%d"';

type

  { Exception classes }

  EFitsPropException = class(EFitsException)
  protected
    function GetTopic: string; override;
  end;

  { TFitsProp: typed keyword-value object }

  TFitsProp = class(TFitsObject)
  private
    FKeyword: string;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
  public
    constructor Create(const AKeyword: string);
    property Keyword: string read FKeyword;
  end;

  TFitsBitPixProp = class(TFitsProp)
  private
    FValue: TBitPix;
  public
    property Value: TBitPix read FValue write FValue;
  end;

  TFitsBooleanProp = class(TFitsProp)
  private
    FValue: Boolean;
  public
    property Value: Boolean read FValue write FValue;
  end;

  TFitsStringProp = class(TFitsProp)
  private
    FValue: string;
  public
    property Value: string read FValue write FValue;
  end;

  TFitsIntegerProp = class(TFitsProp)
  private
    FValue: Integer;
  public
    property Value: Integer read FValue write FValue;
  end;

  TFitsExtendedProp = class(TFitsProp)
  private
    FValue: Extended;
  public
    property Value: Extended read FValue write FValue;
  end;

  TFitsVariableProp = class(TFitsProp)
  private
    FValue: TVariable;
  public
    property Value: TVariable read FValue write FValue;
  end;

  { TFitsPropList: sorted list owns keyword-value objects }

  TFitsPropDynArray = array of TFitsProp;

  TFitsPropList = class(TFitsObject)
  private
    FActive: Boolean;
    FItems: TFitsPropDynArray;
    FCount: Integer;
    procedure FreeItems;
    procedure ResetItems;
    function GetItem(AIndex: Integer): TFitsProp;
    function GetCount: Integer;
  protected
    function GetExceptionClass: EFitsExceptionClass; override;
  public
    destructor Destroy; override;
    function Append(AItem: TFitsProp): Integer;
    function IndexOf(const AKeyword: string): Integer;
    procedure Clear;
    property Items[Index: Integer]: TFitsProp read GetItem; default;
    property Count: Integer read GetCount;
  end;

  { IFitsPropContext: typed keyword-value object with context information }

  IFitsPropContext = interface(IInterface)
    ['{8E3BB9B1-6C3A-47B5-A87F-2F2E12AF0115}']
    // Self
    function GetKeyword: string;
    function GetKeywordNumber: Integer;
    function GetPrintValue: string;
    // Line context
    procedure AssignValue(const ALine: string); overload;
    function NewLine: string;
    function GetLine: string;
    function GetLineRecord: TLineRecord;
    // Prop context
    procedure AssignValue(AProp: TFitsProp); overload;
    function NewProp: TFitsProp;
    function GetProp: TFitsProp;
    // Properties
    property Keyword: string read GetKeyword;
    property KeywordNumber: Integer read GetKeywordNumber;
    property PrintValue: string read GetPrintValue;
    property Line: string read GetLine;
    property LineRecord: TLineRecord read GetLineRecord;
    property Prop: TFitsProp read GetProp;
  end;

  IFitsBitPixPropContext = interface(IFitsPropContext)
    ['{BE02BAC9-E60D-4607-81B1-C47D5507864B}']
    function GetValue: TBitPix;
    procedure SetValue(AValue: TBitPix);
    property Value: TBitPix read GetValue write SetValue;
  end;

  IFitsBooleanPropContext = interface(IFitsPropContext)
    ['{572B6FDF-1ACF-4EC6-A48F-67E98B259B98}']
    function GetValue: Boolean;
    procedure SetValue(AValue: Boolean);
    property Value: Boolean read GetValue write SetValue;
  end;

  IFitsStringPropContext = interface(IFitsPropContext)
    ['{53D7178D-2A79-47E3-BC73-53902CBF9366}']
    function GetValue: string;
    procedure SetValue(const AValue: string);
    property Value: string read GetValue write SetValue;
  end;

  IFitsIntegerPropContext = interface(IFitsPropContext)
    ['{D328C9C7-03ED-4B0F-AA04-06E6ED4E556C}']
    function GetValue: Integer;
    procedure SetValue(AValue: Integer);
    property Value: Integer read GetValue write SetValue;
  end;

  IFitsExtendedPropContext = interface(IFitsPropContext)
    ['{D5684F89-EB0C-4A16-883F-97752E56D20D}']
    function GetValue: Extended;
    procedure SetValue(const AValue: Extended);
    property Value: Extended read GetValue write SetValue;
  end;

  IFitsVariablePropContext = interface(IFitsPropContext)
    ['{F03EE9CA-30E0-4AC1-8E39-A336276C45A5}']
    function GetValue: TVariable;
    procedure SetValue(const AValue: TVariable);
    property Value: TVariable read GetValue write SetValue;
  end;

  { TFitsPropContext [abstract]: implementation of the basic interface of
    a typed keyword-value object with context information }

  TFitsPropContext = class(TFitsInterfacedObject, IFitsPropContext)
  protected
    FKeyword: string;
    FKeywordNumber: Integer;
    FLine: string;
    FLineRecord: TLineRecord;
    FProp: TFitsProp;
    procedure Init; override;
    function GetExceptionClass: EFitsExceptionClass; override;
    function GetKeyword: string;
    function GetKeywordNumber: Integer;
    function GetPrintValue: string;
    procedure DoAssignValueFromLine; virtual; abstract;
    procedure AssignValue(const ALine: string); overload;
    function NewLineValue: string; virtual;
    function NewLineNote: string; virtual;
    function NewLine: string;
    function GetLine: string;
    function GetLineRecord: TLineRecord;
    procedure DoAssignValueFromProp; virtual; abstract;
    procedure AssignValue(AProp: TFitsProp); overload;
    function NewProp: TFitsProp;
    function GetProp: TFitsProp;
  public
    constructor Create(const AKeyword: string; AKeywordNumber: Integer = -1);
  end;

  TFitsBitPixPropContext = class(TFitsPropContext, IFitsPropContext, IFitsBitPixPropContext)
  protected
    FValue: TBitPix;
    procedure Init; override;
    function GetValue: TBitPix;
    procedure SetValue(AValue: TBitPix);
    function GetPrintValue: string;
    procedure DoAssignValueFromLine; override;
    function NewLineValue: string; override;
    procedure DoAssignValueFromProp; override;
    function NewProp: TFitsProp;
  end;

  TFitsBooleanPropContext = class(TFitsPropContext, IFitsPropContext, IFitsBooleanPropContext)
  protected
    FValue: Boolean;
    function GetValue: Boolean;
    procedure SetValue(AValue: Boolean);
    function GetPrintValue: string;
    procedure DoAssignValueFromLine; override;
    function NewLineValue: string; override;
    procedure DoAssignValueFromProp; override;
    function NewProp: TFitsProp;
  end;

  TFitsStringPropContext = class(TFitsPropContext, IFitsPropContext, IFitsStringPropContext)
  protected
    FValue: string;
    function GetValue: string;
    procedure SetValue(const AValue: string);
    function GetPrintValue: string;
    procedure DoAssignValueFromLine; override;
    function NewLineValue: string; override;
    procedure DoAssignValueFromProp; override;
    function NewProp: TFitsProp;
  end;

  TFitsIntegerPropContext = class(TFitsPropContext, IFitsPropContext, IFitsIntegerPropContext)
  protected
    FValue: Integer;
    function GetValue: Integer;
    procedure SetValue(AValue: Integer);
    function GetPrintValue: string;
    procedure DoAssignValueFromLine; override;
    function NewLineValue: string; override;
    procedure DoAssignValueFromProp; override;
    function NewProp: TFitsProp;
  end;

  TFitsExtendedPropContext = class(TFitsPropContext, IFitsPropContext, IFitsExtendedPropContext)
  protected
    FValue: Extended;
    function GetValue: Extended;
    procedure SetValue(const AValue: Extended);
    function GetPrintValue: string;
    procedure DoAssignValueFromLine; override;
    function NewLineValue: string; override;
    procedure DoAssignValueFromProp; override;
    function NewProp: TFitsProp;
  end;

  TFitsVariablePropContext = class(TFitsPropContext, IFitsPropContext, IFitsVariablePropContext)
  protected
    FValue: TVariable;
    procedure Init; override;
    function GetValue: TVariable;
    procedure SetValue(const AValue: TVariable);
    function GetPrintValue: string;
    procedure DoAssignValueFromLine; override;
    function NewLineValue: string; override;
    procedure DoAssignValueFromProp; override;
    function NewProp: TFitsProp;
  end;

  { Mandatory and reserved keyword-value properties }

  ISIMPLE   = IFitsBooleanPropContext;

  IEXTEND   = IFitsBooleanPropContext;

  IXTENSION = IFitsStringPropContext;
  IEXTNAME  = IFitsStringPropContext;
  IEXTVER   = IFitsIntegerPropContext;
  IEXTLEVEL = IFitsIntegerPropContext;

  IBITPIX   = IFitsBitPixPropContext;
  INAXIS    = IFitsIntegerPropContext;
  INAXES    = IFitsIntegerPropContext;
  IPCOUNT   = IFitsIntegerPropContext;
  IGCOUNT   = IFitsIntegerPropContext;

  IBSCALE   = IFitsExtendedPropContext;
  IBZERO    = IFitsExtendedPropContext;

  ITFIELDS  = IFitsIntegerPropContext;
  ITBCOL    = IFitsIntegerPropContext;
  ITFORM    = IFitsStringPropContext;

  ITTYPE    = IFitsStringPropContext;
  ITUNIT    = IFitsStringPropContext;
  ITSCAL    = IFitsExtendedPropContext;
  ITZERO    = IFitsExtendedPropContext;
  ITNULL    = IFitsStringPropContext;
  ITDISP    = IFitsStringPropContext;
  ITDMIN    = IFitsVariablePropContext;
  ITDMAX    = IFitsVariablePropContext;
  ITLMIN    = IFitsVariablePropContext;
  ITLMAX    = IFitsVariablePropContext;

  TFitsSIMPLE = class(TFitsBooleanPropContext)
  protected
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(AValue: Boolean);
  end;

  TFitsEXTEND = class(TFitsBooleanPropContext)
  protected
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(AValue: Boolean);
  end;

  TFitsXTENSION = class(TFitsStringPropContext)
  protected
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(const AValue: string);
  end;

  TFitsEXTNAME = class(TFitsStringPropContext)
  public
    constructor Create;
    constructor CreateValue(const AValue: string);
  end;

  TFitsEXTVER = class(TFitsIntegerPropContext)
  public
    constructor Create;
    constructor CreateValue(AValue: Integer);
  end;

  TFitsEXTLEVEL = class(TFitsIntegerPropContext)
  public
    constructor Create;
    constructor CreateValue(AValue: Integer);
  end;

  TFitsBITPIX = class(TFitsBitPixPropContext)
  protected
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(AValue: TBitPix);
  end;

  TFitsNAXIS = class(TFitsIntegerPropContext)
  protected
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(AValue: Integer);
  end;

  TFitsNAXES = class(TFitsIntegerPropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; AValue: Integer);
  end;

  TFitsPCOUNT = class(TFitsIntegerPropContext)
  protected
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(AValue: Integer);
  end;

  TFitsGCOUNT = class(TFitsIntegerPropContext)
  protected
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(AValue: Integer);
  end;

  TFitsBSCALE = class(TFitsExtendedPropContext)
  protected
    function NewLineValue: string; override;
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(const AValue: Extended);
  end;

  TFitsBZERO = class(TFitsExtendedPropContext)
  protected
    function NewLineValue: string; override;
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(const AValue: Extended);
  end;

  TFitsTFIELDS = class(TFitsIntegerPropContext)
  protected
    function NewLineNote: string; override;
  public
    constructor Create;
    constructor CreateValue(AValue: Integer);
  end;

  TFitsTBCOL = class(TFitsIntegerPropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; AValue: Integer);
  end;

  TFitsTFORM = class(TFitsStringPropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: string);
  end;

  TFitsTTYPE = class(TFitsStringPropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: string);
  end;

  TFitsTUNIT = class(TFitsStringPropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: string);
  end;

  TFitsTSCAL = class(TFitsExtendedPropContext)
  protected
    function NewLineValue: string; override;
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: Extended);
  end;

  TFitsTZERO = class(TFitsExtendedPropContext)
  protected
    function NewLineValue: string; override;
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: Extended);
  end;

  TFitsTNULL = class(TFitsStringPropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: string);
  end;

  TFitsTDISP = class(TFitsStringPropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: string);
  end;

  TFitsTDMIN = class(TFitsVariablePropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: TVariable);
  end;

  TFitsTDMAX = class(TFitsVariablePropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: TVariable);
  end;

  TFitsTLMIN = class(TFitsVariablePropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: TVariable);
  end;

  TFitsTLMAX = class(TFitsVariablePropContext)
  public
    constructor Create(AKeywordNumber: Integer);
    constructor CreateValue(AKeywordNumber: Integer; const AValue: TVariable);
  end;

implementation

{ EFitsPropException }

function EFitsPropException.GetTopic: string;
begin
  Result := 'PROP';
end;

{ TFitsProp }

function TFitsProp.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsPropException;
end;

constructor TFitsProp.Create(const AKeyword: string);
begin
  inherited Create;
  FKeyword := AKeyword;
end;

{ TFitsPropList }

procedure TFitsPropList.FreeItems;
var
  LIndex: Integer;
begin
  for LIndex := 0 to FCount - 1 do
    FItems[LIndex].Free;
end;

procedure TFitsPropList.ResetItems;
begin
  FreeItems;
  FCount := 0;
  FActive := True;
end;

function TFitsPropList.GetItem(AIndex: Integer): TFitsProp;
begin
  if not InRange(AIndex, 0, Count - 1) then
    Error(SPropListIndexOutBounds, [AIndex, Count], ERROR_PROPLIST_INDEX);
  Result := FItems[AIndex];
end;

function TFitsPropList.GetCount: Integer;
begin
  Result := IfThen(FActive, FCount, 0);
end;

function TFitsPropList.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsPropException;
end;

destructor TFitsPropList.Destroy;
begin
  FreeItems;
  inherited;
end;

function TFitsPropList.Append(AItem: TFitsProp): Integer;
const
  cGrow = 10;
var
  LIndex, LIndex1, LIndex2: Integer;
  LCompare: Integer;
begin
  if not FActive then
    ResetItems;
  // Binary search
  LIndex := 0;
  LIndex1 := 0;
  LIndex2 := FCount - 1;
  while LIndex2 >= LIndex1 do
  begin
    LIndex := LIndex1 + (LIndex2 - LIndex1) div 2;
    LCompare := CompareText(AItem.Keyword, FItems[LIndex].Keyword);
    if LCompare < 0 then
      LIndex2 := LIndex - 1
    else if LCompare = 0 then
      Error(SPropListDuplicate, [AItem.Keyword], ERROR_PROPLIST_DUPLICATE)
    else
    // if LCompare > 0 then
    begin
      LIndex1 := LIndex + 1;
      Inc(LIndex);
    end;
  end;
  // Insert new item in position LIndex
  if FCount = Length(FItems) then
    SetLength(FItems, FCount + cGrow);
  if LIndex < FCount then
    System.Move(FItems[LIndex], FItems[LIndex + 1], (FCount - LIndex) * SizeOf(AItem));
  FItems[LIndex] := AItem;
  Inc(FCount);
  // Return
  Result := LIndex;
end;

function TFitsPropList.IndexOf(const AKeyword: string): Integer;
var
  LIndex, LIndex1, LIndex2: Integer;
  LCompare: Integer;
begin
  Result := -1;
  if FActive then
  begin
    LIndex1 := 0;
    LIndex2 := FCount - 1;
    while LIndex2 >= LIndex1 do
    begin
      LIndex := LIndex1 + (LIndex2 - LIndex1) div 2;
      LCompare := CompareText(AKeyword, FItems[LIndex].Keyword);
      if LCompare < 0 then
        LIndex2 := LIndex - 1
      else if LCompare = 0 then
      begin
        Result := LIndex;
        Break;
      end else
      // if LCompare > 0 then
        LIndex1 := LIndex + 1;
    end;
  end;
end;

procedure TFitsPropList.Clear;
begin
  FActive := False;
end;

{ TFitsPropContext }

procedure TFitsPropContext.Init;
begin
  inherited;
  FLineRecord := EmptyLineRecord;
end;

function TFitsPropContext.GetExceptionClass: EFitsExceptionClass;
begin
  Result := EFitsPropException;
end;

function TFitsPropContext.GetKeyword: string;
begin
  Result := FKeyword;
end;

function TFitsPropContext.GetKeywordNumber: Integer;
begin
  Result := FKeywordNumber;
end;

function TFitsPropContext.GetPrintValue: string;
begin
  Result := '';
end;

procedure TFitsPropContext.AssignValue(const ALine: string);
begin
  Assert(ALine <> '', SAssertionFailure);
  FLine := ALine;
  FLineRecord := LineToRecord(ALine);
  DoAssignValueFromLine;
end;

function TFitsPropContext.NewLineValue: string;
begin
  Result := '';
end;

function TFitsPropContext.NewLineNote: string;
begin
  Result := '';
end;

function TFitsPropContext.NewLine: string;
var
  LValue, LNote: string;
  LRecord: TLineRecord;
begin
  LValue := NewLineValue;
  LNote := NewLineNote;
  LRecord := ToLineRecord(FKeyword, True, LValue, LNote <> '', LNote);
  Result := RecordToLine(LRecord);
end;

function TFitsPropContext.GetLine: string;
begin
  Result := FLine;
end;

function TFitsPropContext.GetLineRecord: TLineRecord;
begin
  Result := FLineRecord;
end;

procedure TFitsPropContext.AssignValue(AProp: TFitsProp);
begin
  Assert(Assigned(AProp), SAssertionFailure);
  FProp := AProp;
  DoAssignValueFromProp;
end;

function TFitsPropContext.NewProp: TFitsProp;
begin
  Result := nil;
end;

function TFitsPropContext.GetProp: TFitsProp;
begin
  Result := FProp;
end;

constructor TFitsPropContext.Create(const AKeyword: string; AKeywordNumber: Integer);
begin
  inherited Create;
  FKeyword := AKeyword;
  FKeywordNumber := AKeywordNumber;
end;

{ TFitsBitPixPropContext }

procedure TFitsBitPixPropContext.Init;
begin
  inherited;
  FValue := biUnknown;
end;

function TFitsBitPixPropContext.GetValue: TBitPix;
begin
  Result := FValue;
end;

procedure TFitsBitPixPropContext.SetValue(AValue: TBitPix);
begin
  FValue := AValue;
end;

function TFitsBitPixPropContext.GetPrintValue: string;
begin
  Result := BitPixToString(FValue);
end;

procedure TFitsBitPixPropContext.DoAssignValueFromLine;
begin
  FValue := StringToBitPix(FLineRecord.Value);
end;

function TFitsBitPixPropContext.NewLineValue: string;
begin
  Result := PadString(BitPixToString(FValue), cWidthLineValue);
end;

procedure TFitsBitPixPropContext.DoAssignValueFromProp;
begin
  FValue := (FProp as TFitsBitPixProp).Value;
end;

function TFitsBitPixPropContext.NewProp: TFitsProp;
var
  LProp: TFitsBitPixProp;
begin
  LProp := TFitsBitPixProp.Create(FKeyword);
  LProp.Value := FValue;
  Result := LProp;
end;

{ TFitsBooleanPropContext }

function TFitsBooleanPropContext.GetValue: Boolean;
begin
  Result := FValue;
end;

procedure TFitsBooleanPropContext.SetValue(AValue: Boolean);
begin
  FValue := AValue;
end;

function TFitsBooleanPropContext.GetPrintValue: string;
begin
  Result := BoolToString(FValue);
end;

procedure TFitsBooleanPropContext.DoAssignValueFromLine;
begin
  FValue := StringToBool(FLineRecord.Value);
end;

function TFitsBooleanPropContext.NewLineValue: string;
begin
  Result := PadString(BoolToString(FValue), cWidthLineValue);
end;

procedure TFitsBooleanPropContext.DoAssignValueFromProp;
begin
  FValue := (FProp as TFitsBooleanProp).Value;
end;

function TFitsBooleanPropContext.NewProp: TFitsProp;
var
  LProp: TFitsBooleanProp;
begin
  LProp := TFitsBooleanProp.Create(FKeyword);
  LProp.Value := FValue;
  Result := LProp;
end;

{ TFitsStringPropContext }

function TFitsStringPropContext.GetValue: string;
begin
  Result := FValue;
end;

procedure TFitsStringPropContext.SetValue(const AValue: string);
begin
  FValue := AValue;
end;

function TFitsStringPropContext.GetPrintValue: string;
begin
  Result := FValue;
end;

procedure TFitsStringPropContext.DoAssignValueFromLine;
begin
  FValue := UnquotedString(FLineRecord.Value);
end;

function TFitsStringPropContext.NewLineValue: string;
begin
  Result := PadString(QuotedString(FValue, -cWidthLineValueQuote), -cWidthLineValue);
end;

procedure TFitsStringPropContext.DoAssignValueFromProp;
begin
  FValue := (FProp as TFitsStringProp).Value;
end;

function TFitsStringPropContext.NewProp: TFitsProp;
var
  LProp: TFitsStringProp;
begin
  LProp := TFitsStringProp.Create(FKeyword);
  LProp.Value := FValue;
  Result := LProp;
end;

{ TFitsIntegerPropContext }

function TFitsIntegerPropContext.GetValue: Integer;
begin
  Result := FValue;
end;

procedure TFitsIntegerPropContext.SetValue(AValue: Integer);
begin
  FValue := AValue;
end;

function TFitsIntegerPropContext.GetPrintValue: string;
begin
  Result := IntToStr(FValue);
end;

procedure TFitsIntegerPropContext.DoAssignValueFromLine;
begin
  FValue := StringToInteger(FLineRecord.Value);
end;

function TFitsIntegerPropContext.NewLineValue: string;
begin
  Result := PadString(IntegerToString(FValue), cWidthLineValue);
end;

procedure TFitsIntegerPropContext.DoAssignValueFromProp;
begin
  FValue := (FProp as TFitsIntegerProp).Value;
end;

function TFitsIntegerPropContext.NewProp: TFitsProp;
var
  LProp: TFitsIntegerProp;
begin
  LProp := TFitsIntegerProp.Create(FKeyword);
  LProp.Value := FValue;
  Result := LProp;
end;

{ TFitsExtendedPropContext }

function TFitsExtendedPropContext.GetValue: Extended;
begin
  Result := FValue;
end;

procedure TFitsExtendedPropContext.SetValue(const AValue: Extended);
begin
  FValue := AValue;
end;

function TFitsExtendedPropContext.GetPrintValue: string;
begin
  Result := FloatToString(FValue);
end;

procedure TFitsExtendedPropContext.DoAssignValueFromLine;
begin
  FValue := StringToFloat(FLineRecord.Value);
end;

function TFitsExtendedPropContext.NewLineValue: string;
begin
  Result := PadString(FloatToString(FValue), cWidthLineValue);
end;

procedure TFitsExtendedPropContext.DoAssignValueFromProp;
begin
  FValue := (FProp as TFitsExtendedProp).Value;
end;

function TFitsExtendedPropContext.NewProp: TFitsProp;
var
  LProp: TFitsExtendedProp;
begin
  LProp := TFitsExtendedProp.Create(FKeyword);
  LProp.Value := FValue;
  Result := LProp;
end;

{ TFitsVariablePropContext }

procedure TFitsVariablePropContext.Init;
begin
  inherited;
  FValue := ClearVariable;
end;

function TFitsVariablePropContext.GetValue: TVariable;
begin
  Result := FValue;
end;

procedure TFitsVariablePropContext.SetValue(const AValue: TVariable);
begin
  FValue := AValue;
end;

function TFitsVariablePropContext.GetPrintValue: string;
begin
  Result := VariableToPrintString(FValue);
end;

procedure TFitsVariablePropContext.DoAssignValueFromLine;
begin
  if TryStringToBool(FLineRecord.Value, {out} FValue.ValueBoolean) then
  begin
    FValue.VarType := vtBoolean;
  end else
  if TryStringToInt64(FLineRecord.Value, {out} FValue.ValueInt64) then
  begin
    FValue.VarType := vtInt64;
  end else
  if TryStringToFloat(FLineRecord.Value, {out} FValue.ValueExtended) then
  begin
    FValue.VarType := vtExtended;
  end else
  begin
    FValue.ValueString := UnquotedString(FLineRecord.Value);
    FValue.VarType := vtString;
  end;
end;

function TFitsVariablePropContext.NewLineValue: string;
begin
  case FValue.VarType of
    vtBoolean:  Result := PadString(BoolToString(FValue.ValueBoolean), cWidthLineValue);
    vtInt64:    Result := PadString(Int64ToString(FValue.ValueInt64), cWidthLineValue);
    vtExtended: Result := PadString(FloatToString(FValue.ValueExtended, {ASign:} False, {AFmt:} '%0g'), cWidthLineValue);
    vtString:   Result := PadString(QuotedString(FValue.ValueString, -cWidthLineValueQuote), -cWidthLineValue);
  else          Result := '';
  end;
end;

procedure TFitsVariablePropContext.DoAssignValueFromProp;
begin
  FValue := (FProp as TFitsVariableProp).Value;
end;

function TFitsVariablePropContext.NewProp: TFitsProp;
var
  LProp: TFitsVariableProp;
begin
  LProp := TFitsVariableProp.Create(FKeyword);
  LProp.Value := FValue;
  Result := LProp;
end;

{ TFitsSIMPLE }

function TFitsSIMPLE.NewLineNote: string;
begin
  Result := IfThen(FValue, 'Conforms to FITS standard', 'Does not conforms to FITS standard');
end;

constructor TFitsSIMPLE.Create;
begin
  inherited Create(cSIMPLE);
end;

constructor TFitsSIMPLE.CreateValue(AValue: Boolean);
begin
  inherited Create(cSIMPLE);
  FValue := AValue;
end;

{ TFitsEXTEND }

function TFitsEXTEND.NewLineNote: string;
begin
  Result := IfThen(FValue, 'Extensions are present', 'Extensions are not present');
end;

constructor TFitsEXTEND.Create;
begin
  inherited Create(cEXTEND);
end;

constructor TFitsEXTEND.CreateValue(AValue: Boolean);
begin
  inherited Create(cEXTEND);
  FValue := AValue;
end;

{ TFitsXTENSION }

function TFitsXTENSION.NewLineNote: string;
begin
  Result := 'Name type of extension';
end;

constructor TFitsXTENSION.Create;
begin
  inherited Create(cXTENSION);
end;

constructor TFitsXTENSION.CreateValue(const AValue: string);
begin
  inherited Create(cXTENSION);
  FValue := AValue;
end;

{ TFitsEXTNAME }

constructor TFitsEXTNAME.Create;
begin
  inherited Create(cEXTNAME);
end;

constructor TFitsEXTNAME.CreateValue(const AValue: string);
begin
  inherited Create(cEXTNAME);
  FValue := AValue;
end;

{ TFitsEXTVER }

constructor TFitsEXTVER.Create;
begin
  inherited Create(cEXTVER);
end;

constructor TFitsEXTVER.CreateValue(AValue: Integer);
begin
  inherited Create(cEXTVER);
  FValue := AValue;
end;

{ TFitsEXTLEVEL }

constructor TFitsEXTLEVEL.Create;
begin
  inherited Create(cEXTLEVEL);
end;

constructor TFitsEXTLEVEL.CreateValue(AValue: Integer);
begin
  inherited Create(cEXTLEVEL);
  FValue := AValue;
end;

{ TFitsBITPIX }

function TFitsBITPIX.NewLineNote: string;
begin
  Result := 'Number of bits per data value';
end;

constructor TFitsBITPIX.Create;
begin
  inherited Create(cBITPIX);
end;

constructor TFitsBITPIX.CreateValue(AValue: TBitPix);
begin
  inherited Create(cBITPIX);
  FValue := AValue;
end;

{ TFitsNAXIS }

function TFitsNAXIS.NewLineNote: string;
begin
  Result := 'Number of axes';
end;

constructor TFitsNAXIS.Create;
begin
  inherited Create(cNAXIS);
end;

constructor TFitsNAXIS.CreateValue(AValue: Integer);
begin
  inherited Create(cNAXIS);
  FValue := AValue;
end;

{ TFitsNAXES }

constructor TFitsNAXES.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cNAXISn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsNAXES.CreateValue(AKeywordNumber, AValue: Integer);
begin
  inherited Create(ExpandKeyword(cNAXISn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsPCOUNT }

function TFitsPCOUNT.NewLineNote: string;
begin
  Result := 'Parameter count';
end;

constructor TFitsPCOUNT.Create;
begin
  inherited Create(cPCOUNT);
end;

constructor TFitsPCOUNT.CreateValue(AValue: Integer);
begin
  inherited Create(cPCOUNT);
  FValue := AValue;
end;

{ TFitsGCOUNT }

function TFitsGCOUNT.NewLineNote: string;
begin
  Result := 'Group count';
end;

constructor TFitsGCOUNT.Create;
begin
  inherited Create(cGCOUNT);
end;

constructor TFitsGCOUNT.CreateValue(AValue: Integer);
begin
  inherited Create(cGCOUNT);
  FValue := AValue;
end;

{ TFitsBSCALE }

function TFitsBSCALE.NewLineValue: string;
begin
  Result := PadString(FloatToString(FValue, {ASign:} False, {AFmt:} '%0g'), cWidthLineValue);
end;

function TFitsBSCALE.NewLineNote: string;
begin
  Result := 'Linear factor in scaling equation';
end;

constructor TFitsBSCALE.Create;
begin
  inherited Create(cBSCALE);
end;

constructor TFitsBSCALE.CreateValue(const AValue: Extended);
begin
  inherited Create(cBSCALE);
  FValue := AValue;
end;

{ TFitsBZERO }

function TFitsBZERO.NewLineValue: string;
begin
  Result := PadString(FloatToString(FValue, {ASign:} False, {AFmt:} '%0g'), cWidthLineValue);
end;

function TFitsBZERO.NewLineNote: string;
begin
  Result := 'Zero point in scaling equation';
end;

constructor TFitsBZERO.Create;
begin
  inherited Create(cBZERO);
end;

constructor TFitsBZERO.CreateValue(const AValue: Extended);
begin
  inherited Create(cBZERO);
  FValue := AValue;
end;

{ TFitsTFIELDS }

function TFitsTFIELDS.NewLineNote: string;
begin
  Result := 'Number of fields per row';
end;

constructor TFitsTFIELDS.Create;
begin
  inherited Create(cTFIELDS);
end;

constructor TFitsTFIELDS.CreateValue(AValue: Integer);
begin
  inherited Create(cTFIELDS);
  FValue := AValue;
end;

{ TFitsTBCOL }

constructor TFitsTBCOL.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTBCOLn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTBCOL.CreateValue(AKeywordNumber, AValue: Integer);
begin
  inherited Create(ExpandKeyword(cTBCOLn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTFORM }

constructor TFitsTFORM.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTFORMn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTFORM.CreateValue(AKeywordNumber: Integer; const AValue: string);
begin
  inherited Create(ExpandKeyword(cTFORMn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTTYPE }

constructor TFitsTTYPE.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTTYPEn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTTYPE.CreateValue(AKeywordNumber: Integer; const AValue: string);
begin
  inherited Create(ExpandKeyword(cTTYPEn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTUNIT }

constructor TFitsTUNIT.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTUNITn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTUNIT.CreateValue(AKeywordNumber: Integer; const AValue: string);
begin
  inherited Create(ExpandKeyword(cTUNITn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTSCAL }

function TFitsTSCAL.NewLineValue: string;
begin
  Result := PadString(FloatToString(FValue, {ASign:} False, {AFmt:} '%0g'), cWidthLineValue);
end;

constructor TFitsTSCAL.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTSCALn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTSCAL.CreateValue(AKeywordNumber: Integer; const AValue: Extended);
begin
  inherited Create(ExpandKeyword(cTSCALn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTZERO }

function TFitsTZERO.NewLineValue: string;
begin
  Result := PadString(FloatToString(FValue, {ASign:} False, {AFmt:} '%0g'), cWidthLineValue);
end;

constructor TFitsTZERO.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTZEROn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTZERO.CreateValue(AKeywordNumber: Integer; const AValue: Extended);
begin
  inherited Create(ExpandKeyword(cTZEROn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTNULL }

constructor TFitsTNULL.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTNULLn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTNULL.CreateValue(AKeywordNumber: Integer; const AValue: string);
begin
  inherited Create(ExpandKeyword(cTNULLn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTDISP }

constructor TFitsTDISP.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTDISPn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTDISP.CreateValue(AKeywordNumber: Integer; const AValue: string);
begin
  inherited Create(ExpandKeyword(cTDISPn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTDMIN }

constructor TFitsTDMIN.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTDMINn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTDMIN.CreateValue(AKeywordNumber: Integer; const AValue: TVariable);
begin
  inherited Create(ExpandKeyword(cTDMINn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTDMAX }

constructor TFitsTDMAX.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTDMAXn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTDMAX.CreateValue(AKeywordNumber: Integer; const AValue: TVariable);
begin
  inherited Create(ExpandKeyword(cTDMAXn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTLMIN }

constructor TFitsTLMIN.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTLMINn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTLMIN.CreateValue(AKeywordNumber: Integer; const AValue: TVariable);
begin
  inherited Create(ExpandKeyword(cTLMINn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

{ TFitsTLMAX }

constructor TFitsTLMAX.Create(AKeywordNumber: Integer);
begin
  inherited Create(ExpandKeyword(cTLMAXn, AKeywordNumber), AKeywordNumber);
end;

constructor TFitsTLMAX.CreateValue(AKeywordNumber: Integer; const AValue: TVariable);
begin
  inherited Create(ExpandKeyword(cTLMAXn, AKeywordNumber), AKeywordNumber);
  FValue := AValue;
end;

end.
