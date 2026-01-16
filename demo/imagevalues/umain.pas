{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{           Read and write the IMAGE values            }
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
  SysUtils, Classes, DeLaFitsCommon, DeLaFitsClasses, DeLaFitsImage;

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

procedure ExtractDataInfo(AData: TFitsImageData);
var
  LOffset, LSize, LInternalSize, LValueCount: Int64;
  LIndex, LNumber, LPixelSize: Integer;
  LValueType: TNumberType;
  LAxes: array of Integer;
  LString: string;
begin
  // Extract data info
  LOffset := AData.Offset;
  LSize := AData.Size;
  LInternalSize := AData.InternalSize;
  LAxes := nil;
  SetLength(LAxes, AData.AxesCount);
  for LNumber := 1 to AData.AxesCount do
    LAxes[LNumber - 1] := AData.AxesLength[LNumber];
  LValueCount := AData.ValueCount;
  LValueType := AData.ValueType;
  LPixelSize := AData.PixelSize;
  // Print data info
  Print('# Extract Data Info');
  Print('%-15s %d', ['Offset', LOffset]);
  Print('%-15s %d', ['Size', LSize]);
  Print('%-15s %d', ['Internal Size', LInternalSize]);
  LString := '';
  for LIndex := Low(LAxes) to High(LAxes) do
    LString := LString + 'x' + IntToStr(LAxes[LIndex]);
  Delete(LString, 1, 1);
  Print('%-15s [%s]', ['Value Dimension', LString]);
  Print('%-15s %d', ['Value Count', LValueCount]);
  LString := '';
  case LValueType of
    numUnknown: LString := 'Unknown';
    num80f: LString := 'Extended';
    num64f: LString := 'Double';
    num32f: LString := 'Single';
    num08c: LString := 'ShortInt';
    num08u: LString := 'Byte';
    num16c: LString := 'SmallInt';
    num16u: LString := 'Word';
    num32c: LString := 'Integer';
    num32u: LString := 'Cardinal';
    num64c: LString := 'Int64';
  end;
  Print('%-15s %s', ['Value Type', LString]);
  Print('%-15s %d', ['Pixel Size', LPixelSize]);
  Print('');
end;

procedure ReadDataValues(AData: TFitsImageData);
type
  TValueType = (vtUnknown, vtFloat, vtInteger);
var
  LValueType: TValueType;
  LBuffer64f: array of Double;
  LBuffer64c: array of Int64;
  LValueIndex, LValueCount, LBufferCount: Int64;
  LIndex, LCount: Integer;
  LBuffer: string;
begin
  // Calculate the optimal type for the read buffer. The actual value type of the
  // IMAGE extension is specified by the BITPIX, BSCALE, and BZERO keyword records
  case AData.ValueType of
    num80f, num64f, num32f:
      LValueType := vtFloat;
    num08c, num08u, num16c, num16u, num32c, num32u, num64c:
      LValueType := vtInteger;
  else { numUnknown: }
    LValueType := vtUnknown;
    Assert(False, 'Unknown value type');
  end;
  // Prepare a buffer to read values
  LBufferCount := AData.AxesLength[1];
  LBuffer64f := nil;
  LBuffer64c := nil;
  case LValueType of
    vtFloat:   SetLength(LBuffer64f, LBufferCount);
    vtInteger: SetLength(LBuffer64c, LBufferCount);
  end;
  // Read all values in parts
  LValueIndex := 0;
  LValueCount := AData.ValueCount;
  while LValueIndex < LValueCount do
  begin
    case LValueType of
      vtFloat:   AData.ReadValues(LValueIndex, LBufferCount, TA64f(LBuffer64f));
      vtInteger: AData.ReadValues(LValueIndex, LBufferCount, TA64c(LBuffer64c));
    end;
    Inc(LValueIndex, LBufferCount);
  end;
  // Print
  Print('# Read Data Values');
  LCount := 10;
  LBuffer := '...';
  for LIndex := LBufferCount - LCount to LBufferCount - 1 do
    case LValueType of
      vtFloat:   LBuffer := LBuffer + ' ' + FloatToStr(LBuffer64f[LIndex]);
      vtInteger: LBuffer := LBuffer + ' ' + IntToStr(LBuffer64c[LIndex]);
    end;
  Print('Last %d values [%s]', [LCount, LBuffer]);
  Print('');
end;

procedure WriteDataValues(AData: TFitsImageData);
const
  cBufferCount = 10;
var
  LBuffer32c: array of Integer;
  LIndex: Integer;
  LBuffer: string;
begin
  // Prepare a buffer with new values
  LBuffer32c := nil;
  SetLength(LBuffer32c, cBufferCount);
  for LIndex := Low(LBuffer32c) to High(LBuffer32c) do
    LBuffer32c[LIndex] := 1000 + LIndex;
  // Write the last few values in the IMAGE data array
  AData.WriteValues({AIndex:} AData.ValueCount - cBufferCount, cBufferCount, TA32c(LBuffer32c));
  // Print few new values
  Print('# Write Data Values');
  LBuffer := '...';
  for LIndex := Low(LBuffer32c) to High(LBuffer32c) do
    LBuffer := LBuffer + ' ' + IntToStr(LBuffer32c[LIndex]);
  Print('New last %d values [%s]', [cBufferCount, LBuffer]);
  Print('');
end;

procedure Main;
var
  LFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LImage: TFitsImage;
  LData: TFitsImageData;
begin
  Print('DeLaFits Demo "Read and write the IMAGE values"');
  Print('');
  LStream := nil;
  LContainer := nil;
  try
    // Copy the demo FITS file from the "data" directory to the project directory
    LFileName := CopyFile('../../data/demo-image.fits', 'output.fits');
    // Create the stream of FITS file and the FITS container
    LStream := TFileStream.Create(LFileName, fmOpenReadWrite);
    LContainer := TFitsContainer.Create(LStream);
    // Set the class "TFitsImage" for the IMAGE HDU. If this HDU is not IMAGE
    // an exception will be raised. To check the HDU extension, use the
    // "ItemExtensionTypeIs" method
    LContainer.ItemClasses[0] := TFitsImage;
    LImage := LContainer.Items[0] as TFitsImage;
    LData := LImage.Data;
    // Read and write values
    ExtractDataInfo(LData);
    ReadDataValues(LData);
    WriteDataValues(LData);
  finally
    LContainer.Free;
    LStream.Free;
  end;
  Print('DeLaFits Demo successfully completed, see "%s" file', [ExtractFileName(LFileName)]);
end;

end.
