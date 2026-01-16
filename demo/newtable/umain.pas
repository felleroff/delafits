{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{                  Create a new TABLE                  }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit umain;

interface

  procedure Main;

implementation

uses
  SysUtils, Classes, DeLaFitsCommon, DeLaFitsClasses, DeLaFitsTable;

procedure Print(const AText: string); overload;
begin
  Writeln(AText);
end;

procedure Print(const AText: string; const Args: array of const); overload;
begin
  Writeln(Format(AText, Args));
end;

function FieldTypeToString(AFieldType: TFieldType): string;
begin
  case AFieldType of
    ftString : Result := 'string';
    ftInteger: Result := 'Integer';
    ftFloat  : Result := 'Float';
  else
    Result := '';
  end;
end;

procedure Main;
var
  LFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LTableSpec: TFitsTableSpec;
  LTable: TFitsTable;
  LFieldInfo1, LFieldInfo2, LFieldInfo3, LFieldInfo4: TFieldInfo;
  LField: TFitsField;
  LField1: TFitsStringField;
  LField2: TFitsIntegerField;
  LField3, LField4: TFitsFloatField;
  LNumber, LIndex: Integer;
  LCaption, LString: string;
begin
  Print('DeLaFits Demo "Create a new TABLE"');
  Print('');
  LStream := nil;
  LContainer := nil;
  LTableSpec := nil;
  try
    // Create empty FITS container
    LFileName := ExtractFilePath(ParamStr(0)) + 'output.fits';
    LStream := TFileStream.Create(LFileName, fmCreate);
    LContainer := TFitsContainer.Create(LStream);
    // Create TABLE specification with four fields: string, integer and two floating point
    LFieldInfo1 := CreateStringFieldInfo({AFieldNumber:} 1, {AFieldWidth:} 10,
      {AFieldPosition:} 1, 'COLUMN1');
    LFieldInfo2 := CreateIntegerFieldInfo({AFieldNumber:} 2, {AFieldWidth:} 10,
      {AFieldPosition:} 12, 'COLUMN2');
    LFieldInfo3 := CreateFixedFieldInfo({AFieldNumber:} 3, {AFieldWidth:} 10,
      {AFieldPrecision:} 2, {AFieldPosition:} 23, 'COLUMN3');
    LFieldInfo4 := CreateExponentFieldInfo({AFieldNumber:} 4, {AFieldWidth:} 10,
      {AFieldPrecision:} 2, {AFieldPosition:} 34, 'COLUMN4');
    LTableSpec := TFitsTableSpec.CreateNewFields({ARecordSize:} 43, {ARecordCount:} 5,
      [LFieldInfo1, LFieldInfo2, LFieldInfo3, LFieldInfo4]);
    // Add new TABLE to the FITS container (the container owns the table object)
    LTable := LContainer.Add(TFitsTable, LTableSpec) as TFitsTable;
    // Add comment to new TABLE
    LTable.Head.AddComment('Copyright. This FITS file was created specifically to demonstrate the features of the DeLaFits library');
    // Get TABLE fields
    LField1 := LTable.Data.Fields[1] as TFitsStringField;
    LField2 := LTable.Data.Fields[2] as TFitsIntegerField;
    LField3 := LTable.Data.Fields[3] as TFitsFloatField;
    LField4 := LTable.Data.Fields[4] as TFitsFloatField;
    // Write TABLE records
    for LIndex := 0 to LTable.Data.RecordCount - 1 do
    begin
      LTable.Data.OpenRecord(LIndex);
      LField1.ValueAsString := Format('Text%d', [LIndex]);
      LField2.ValueAsInteger := LIndex;
      LField3.ValueAsDouble := LIndex / 100;
      LField4.ValueAsDouble := LIndex / 1000;
      LTable.Data.PostRecord;
    end;
    // Print log
    Print('# Create empty FITS container "%s"', [ExtractFileName(LFileName)]);
    Print('');
    Print('# Create TABLE specification');
    Print('%-7s %d', ['BITPIX', BitPixToInt(LTableSpec.BITPIX)]);
    Print('%-7s %d', ['NAXIS', LTableSpec.NAXIS]);
    Print('%-7s %d', ['NAXIS1', LTableSpec.NAXES1]);
    Print('%-7s %d', ['NAXIS2', LTableSpec.NAXES2]);
    Print('%-7s %d', ['PCOUNT', LTableSpec.PCOUNT]);
    Print('%-7s %d', ['GCOUNT', LTableSpec.GCOUNT]);
    Print('%-7s %d', ['TFIELDS', LTableSpec.TFIELDS]);
    Print('');
    Print('# Add new TABLE to the FITS container');
    Print('%-9s %s', ['Type', LTable.GetXTENSION]);
    Print('%-9s %d', ['Size', LTable.Size]);
    Print('%-9s %d', ['Head Size', LTable.Head.Size]);
    Print('%-9s %d', ['Data Size', LTable.Data.Size]);
    Print('');
    Print('# TABLE fields');
    Print('%s %d', ['Field Count', LTable.Data.FieldCount]);
    for LNumber := 1 to LTable.Data.FieldCount do
    begin
      LField := LTable.Data.Fields[LNumber];
      LCaption := Format('Field[%d]', [LField.FieldNumber]);
      LString := Format('Number:%d; Position:%2d; Width:%2d; Type:%7s; Name:%s; Form:%5s', [LField.FieldNumber,
        LField.FieldPosition, LField.FieldWidth, FieldTypeToString(LField.FieldType),
        LField.FieldName, LField.FieldFormatStr]);
      Print('%s (%s)', [LCaption, LString]);
    end;
    Print('');
    Print('# TABLE records');
    Print('%-12s %d', ['Record Size', LTable.Data.RecordSize]);
    Print('%-12s %d', ['Record Count', LTable.Data.RecordCount]);
    for LIndex := 0 to LTable.Data.RecordCount - 1 do
    begin
      LTable.Data.OpenRecord(LIndex);
      LCaption := Format('Records[%d]', [LIndex]);
      LString := LTable.Data.RecordBuffer;
      Print('%s "%s"', [LCaption, LString]);
    end;
    Print('');
  finally
    LTableSpec.Free;
    LContainer.Free;
    LStream.Free;
  end;
  Print('DeLaFits Demo successfully completed, see "%s" file', [ExtractFileName(LFileName)]);
end;

end.
