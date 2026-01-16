{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{           Read and write the TABLE records           }
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

type
  // Typed value of a demo table record
  TValue = record
    V1: string;  // COLUMN1
    V2: string;  // COLUMN2
    V3: Integer; // COLUMN3
    V4: Double;  // COLUMN4
    V5: Double;  // COLUMN5
    V6: Double;  // COLUMN6
  end;

procedure Print(const AText: string); overload;
begin
  Writeln(AText);
end;

procedure Print(const AText: string; const Args: array of const); overload;
begin
  Writeln(Format(AText, Args));
end;

function CopyFile(const ASourceFileName, ADestFileName: string): string;
var
  LRoot: string;
  LSource, LDest: TFileStream;
begin
  LSource := nil;
  LDest := nil;
  try
    LRoot := ExtractFilePath(ParamStr(0));
    LSource := TFileStream.Create(LRoot + ASourceFileName, fmOpenRead);
    LDest := TFileStream.Create(LRoot + ADestFileName, fmCreate);
    LSource.Position := 0;
    if LDest.CopyFrom(LSource, LSource.Size) <> LSource.Size then
      raise EFilerError.CreateFmt('Error copying file "%s" to "%s"',
        [ASourceFileName, ADestFileName]);
    Result := ExpandFileName(LDest.FileName);
  finally
    LSource.Free;
    LDest.Free;
  end;
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

function VariableToString(const AValue: TVariable): string;
begin
  case AValue.VarType of
    vtBoolean:  Result := IfThen(AValue.ValueBoolean, 'T', 'F');
    vtInt64:    Result := IntToStr(AValue.ValueInt64);
    vtExtended: Result := FloatToStrF(AValue.ValueExtended, ffFixed, 5, 1);
    vtString:   Result := AValue.ValueString;
  else          Result := '';
  end;
end;

function ValueToString(const AValue: TValue): string;
begin
  Result := Format('V1:"%s"; V2:"%s"; V3:%5d; V4:%7.1f; V5:%7.1f; V6:%3.1f',
   [AValue.V1, AValue.V2, AValue.V3, AValue.V4, AValue.V5, AValue.V6]);
end;

procedure ExtractDataInfo(AData: TFitsTableData);
var
  LIndex, LNumber: Integer;
  LField: TFitsField;
begin
  // Print table data section info
  Print('# TABLE data section');
  Print('%-13s %d', ['Offset', AData.Offset]);
  Print('%-13s %d', ['Size', AData.Size]);
  Print('%-13s %d', ['Internal Size', AData.InternalSize]);
  Print('');
  // Print table fields info
  Print('# TABLE fields');
  Print('%s %d', ['Field Count', AData.FieldCount]);
  Print(StringOfChar('-', 115));
  Print(' %s | %5s | %7s | %3s | %5s | %7s | %5s | %5s | %5s | %4s | %5s | %5s | %5s | %5s | %5s',
    ['#', 'Form', 'Type', 'Pos', 'Width', 'Name', 'Unit', 'Scal', 'Zero', 'Null', 'Dmin', 'Dmax', 'Lmin', 'Lmax', 'Disp']);
  Print(StringOfChar('-', 115));
  for LNumber := 1 to AData.FieldCount do
  begin
    LField := AData.Fields[LNumber];
    Print(' %d | %5s | %7s | %3d | %5d | %7s | %5s | %5.1f | %5.1f | %4s | %5s | %5s | %5s | %5s | %5s',
      [LField.FieldNumber, LField.FieldFormatStr, FieldTypeToString(LField.FieldType),
      LField.FieldPosition, LField.FieldWidth, LField.FieldName, LField.FieldUnit,
      LField.FieldScal, LField.FieldZero, LField.FieldNull,
      VariableToString(LField.FieldDmin), VariableToString(LField.FieldDmax),
      VariableToString(LField.FieldLmin), VariableToString(LField.FieldLmax),
      LField.DisplayFormatStr]);
  end;
  Print(StringOfChar('-', 115));
  Print('');
  // Print table records
  Print('# TABLE records');
  Print('%-12s %d', ['Record Size', AData.RecordSize]);
  Print('%-12s %d', ['Record Count', AData.RecordCount]);
  Print(StringOfChar('-', 61));
  Print(' %s | %56s', ['#', 'Record']);
  Print(StringOfChar('-', 61));
  for LIndex := 0 to AData.RecordCount - 1 do
  begin
    AData.OpenRecord(LIndex);
    Print(' %d | %s', [LIndex, AData.RecordBuffer]);
  end;
  Print(StringOfChar('-', 61));
  Print('');
end;

procedure ReadTableRecords(AData: TFitsTableData);
var
  LField1, LField2: TFitsStringField;
  LField3: TFitsIntegerField;
  LField4, LField5, LField6: TFitsFloatField;
  LValue: TValue;
  LValues: array of TValue;
  LIndex: Integer;
begin
  // Prepare a buffer for table records
  LValues := nil;
  SetLength(LValues, AData.RecordCount);
  // Find table fields
  LField1 := AData.FindField('COLUMN1') as TFitsStringField;
  LField2 := AData.FindField('COLUMN2') as TFitsStringField;
  LField3 := AData.FindField('COLUMN3') as TFitsIntegerField;
  LField4 := AData.FindField('COLUMN4') as TFitsFloatField;
  LField5 := AData.FindField('COLUMN5') as TFitsFloatField;
  LField6 := AData.FindField('COLUMN6') as TFitsFloatField;
  // Read all table records and get their values
  for LIndex := 0 to AData.RecordCount - 1 do
  begin
    // Set the table cursor to the record with the given index
    AData.OpenRecord(LIndex);
    // Get the values of the active table record
    LValue.V1 := LField1.ValueAsString;
    LValue.V2 := LField2.ValueAsString;
    LValue.V3 := LField3.ValueAsInteger;
    LValue.V4 := LField4.ValueAsDouble;
    LValue.V5 := LField5.ValueAsDouble;
    LValue.V6 := LField6.ValueAsDouble;
    LValues[LIndex] := LValue;
  end;
  // Print
  Print('# Read table record values');
  for LIndex := Low(LValues) to High(LValues) do
  begin
    LValue := LValues[LIndex];
    Print(' %d | (%s)', [LIndex, ValueToString(LValue)]);
  end;
  Print('');
end;

procedure WriteTableRecords(AData: TFitsTableData);
type
  TIndex = 1..3;
var
  LField1, LField2: TFitsStringField;
  LField3: TFitsIntegerField;
  LField4, LField5, LField6: TFitsFloatField;
  LValue: TValue;
  LValues: array [TIndex] of TValue;
  LIndex: TIndex;
begin
  // Prepare new values for the table records
  for LIndex := Low(TIndex) to High(TIndex) do
  begin
    LValue.V1 := 'WRITE' + IntToStr(LIndex);
    LValue.V2 := 'T';
    LValue.V3 := LIndex * 10000;
    LValue.V4 := LIndex * 10000 / 2;
    LValue.V5 := LIndex * 10000 / 3;
    LValue.V6 := LIndex * 10000 / 4;
    LValues[LIndex] := LValue;
  end;
  // Find table fields
  LField1 := AData.FindField('COLUMN1') as TFitsStringField;
  LField2 := AData.FindField('COLUMN2') as TFitsStringField;
  LField3 := AData.FindField('COLUMN3') as TFitsIntegerField;
  LField4 := AData.FindField('COLUMN4') as TFitsFloatField;
  LField5 := AData.FindField('COLUMN5') as TFitsFloatField;
  LField6 := AData.FindField('COLUMN6') as TFitsFloatField;
  // Write new values for the table records
  for LIndex := Low(TIndex) to High(TIndex) do
  begin
    // Set the table cursor to the record with the given index
    AData.OpenRecord(LIndex);
    // Update the values of the active table record
    LValue := LValues[LIndex];
    LField1.ValueAsString := LValue.V1;
    LField2.ValueAsString:= LValue.V2;
    LField3.ValueAsInteger := LValue.V3;
    LField4.ValueAsDouble := LValue.V4;
    LField5.ValueAsDouble := LValue.V5;
    LField6.ValueAsDouble := LValue.V6;
    // Post the changes
    AData.PostRecord;
  end;
  // Print
  Print('# Write table record values');
  for LIndex := Low(TIndex) to High(TIndex) do
  begin
    LValue := LValues[LIndex];
    Print(' %d | (%s)', [LIndex, ValueToString(LValue)]);
  end;
  Print('');
end;

procedure DeleteTableRecords(AData: TFitsTableData);
type
  TIndex = 4..6;
var
  LField1, LField2: TFitsStringField;
  LField3: TFitsIntegerField;
  LField4, LField5, LField6: TFitsFloatField;
  LValue: TValue;
  LValues: array [TIndex] of TValue;
  LIndex: TIndex;
begin
  // Find table fields
  LField1 := AData.FindField('COLUMN1') as TFitsStringField;
  LField2 := AData.FindField('COLUMN2') as TFitsStringField;
  LField3 := AData.FindField('COLUMN3') as TFitsIntegerField;
  LField4 := AData.FindField('COLUMN4') as TFitsFloatField;
  LField5 := AData.FindField('COLUMN5') as TFitsFloatField;
  LField6 := AData.FindField('COLUMN6') as TFitsFloatField;
  // Delete records from the table
  for LIndex := High(TIndex) downto Low(TIndex) do
  begin
    AData.OpenRecord(LIndex);
    // Remember deleted table record for log
    LValue.V1 := LField1.ValueAsString;
    LValue.V2 := LField2.ValueAsString;
    LValue.V3 := LField3.ValueAsInteger;
    LValue.V4 := LField4.ValueAsDouble;
    LValue.V5 := LField5.ValueAsDouble;
    LValue.V6 := LField6.ValueAsDouble;
    LValues[LIndex] := LValue;
    // Delete a record from a table. Calling the "PostRecord" method is not required
    AData.DeleteRecord;
  end;
  // Print
  Print('# Delete table records');
  for LIndex := Low(TIndex) to High(TIndex) do
  begin
    LValue := LValues[LIndex];
    Print(' %d | (%s)', [LIndex, ValueToString(LValue)]);
  end;
  Print('');
end;

procedure AppendTableRecords(AData: TFitsTableData);
const
  cNewRecordCount = 3;
var
  LField1, LField2: TFitsStringField;
  LField3: TFitsIntegerField;
  LField4, LField5, LField6: TFitsFloatField;
  LValue: TValue;
  LValues: array [1 .. cNewRecordCount] of TValue;
  LIndex, LNewRecordIndex: Integer;
begin
  // Prepare new table records
  for LIndex := Low(LValues) to High(LValues) do
  begin
    LValue.V1 := 'APPEND' + IntToStr(LIndex);
    LValue.V2 := 'F';
    LValue.V3 := LIndex * 30000;
    LValue.V4 := LIndex * 30000 / 2;
    LValue.V5 := LIndex * 30000 / 3;
    LValue.V6 := LIndex * 30000 / 4;
    LValues[LIndex] := LValue;
  end;
  // Find table fields
  LField1 := AData.FindField('COLUMN1') as TFitsStringField;
  LField2 := AData.FindField('COLUMN2') as TFitsStringField;
  LField3 := AData.FindField('COLUMN3') as TFitsIntegerField;
  LField4 := AData.FindField('COLUMN4') as TFitsFloatField;
  LField5 := AData.FindField('COLUMN5') as TFitsFloatField;
  LField6 := AData.FindField('COLUMN6') as TFitsFloatField;
  // Add new records to the table
  for LIndex := Low(LValues) to High(LValues) do
  begin
    // Create a new table record in memory
    AData.AddRecord;
    // Set the values of the new table record
    LValue := LValues[LIndex];
    LField1.ValueAsString := LValue.V1;
    LField2.ValueAsString:= LValue.V2;
    LField3.ValueAsInteger := LValue.V3;
    LField4.ValueAsDouble := LValue.V4;
    LField5.ValueAsDouble := LValue.V5;
    LField6.ValueAsDouble := LValue.V6;
    // Post new table record
    AData.PostRecord;
  end;
  // Print
  Print('# Append data records');
  LNewRecordIndex := AData.RecordCount - cNewRecordCount - 1;
  for LIndex := Low(LValues) to High(LValues) do
  begin
    LNewRecordIndex := LNewRecordIndex + 1;
    LValue := LValues[LIndex];
    Print(' %d | (%s)', [LNewRecordIndex, ValueToString(LValue)]);
  end;
  Print('');
end;

procedure DisplayTableRecords(AData: TFitsTableData);
var
  LRecordIndex, LFieldNumber: Integer;
  LValue: string;
begin
  // ASCII-text representation of the table record values according
  // to the specified field format (keyword "TDISPn")
  Print('# Display table record values');
  Print(StringOfChar('-', 71));
  Print(' %s | %66s', ['#', 'Record values']);
  Print(StringOfChar('-', 71));
  for LRecordIndex := 0 to AData.RecordCount - 1 do
  begin
    AData.OpenRecord(LRecordIndex);
    LValue := ' ' + IntToStr(LRecordIndex);
    for LFieldNumber := 1 to AData.FieldCount do
      LValue := LValue + ' | ' + AData.Fields[LFieldNumber].DisplayValue;
    Print(LValue);
  end;
  Print('');
end;

procedure Main;
var
  LFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LTable: TFitsTable;
  LData: TFitsTableData;
begin
  Print('DeLaFits Demo "Read and write the TABLE records"');
  Print('');
  LStream := nil;
  LContainer := nil;
  try
    // Copy the demo FITS file from the "data" directory to the project directory
    LFileName := CopyFile('../../data/demo-table.fits', 'output.fits');
    // Create the stream of FITS file and the FITS container
    LStream := TFileStream.Create(LFileName, fmOpenReadWrite);
    LContainer := TFitsContainer.Create(LStream);
    // Set the class "TFitsTable" for the TABLE HDU. If this HDU is not TABLE
    // an exception will be raised. To check the HDU extension, use the
    // "ItemExtensionTypeIs" method
    LContainer.ItemClasses[1] := TFitsTable;
    LTable := LContainer.Items[1] as TFitsTable;
    LData := LTable.Data;
    // Read, write and display table records
    ExtractDataInfo(LData);
    ReadTableRecords(LData);
    WriteTableRecords(LData);
    DeleteTableRecords(LData);
    AppendTableRecords(LData);
    DisplayTableRecords(LData);
  finally
    LContainer.Free;
    LStream.Free;
  end;
  Print('DeLaFits Demo successfully completed, see "%s" file', [ExtractFileName(LFileName)]);
end;

end.
