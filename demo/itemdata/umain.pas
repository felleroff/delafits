{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{             Read and write the HDU data              }
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
  SysUtils, Classes, DeLaFitsClasses;

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

procedure ExtractDataInfo(AData: TFitsItemData);
var
  LOffset, LSize, LInternalSize: Int64;
  LIndex, LNumber, LPixelSize: Integer;
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
  LPixelSize := AData.PixelSize;
  // Print data info
  Print('# Extract Data Info');
  Print('%-16s %d', ['Offset', LOffset]);
  Print('%-16s %d', ['Size', LSize]);
  Print('%-16s %d', ['Internal Size', LInternalSize]);
  LString := '';
  for LIndex := Low(LAxes) to High(LAxes) do
    LString := LString + 'x' + IntToStr(LAxes[LIndex]);
  Delete(LString, 1, 1);
  Print('%-16s [%s]', ['Dimension (axes)', LString]);
  Print('%-16s %d', ['Pixel Size', LPixelSize]);
  Print('');
end;

procedure ReadDataChunk(AData: TFitsItemData);
const
  cMaxChunkSize = 10;
var
  LChunk: array of Byte;
  LOffset, LInternalOffset: Int64;
  LIndex, LChunkSize: Integer;
  LString: string;
begin
  // Calc offset and chunk size to read meaningful bytes of the data section
  // Last few significant bytes
  if AData.InternalSize > cMaxChunkSize then
  begin
    LInternalOffset := AData.InternalSize - cMaxChunkSize;
    LChunkSize := cMaxChunkSize;
  end else
  // All significant bytes
  begin
    LInternalOffset := 0;
    LChunkSize := AData.InternalSize;
  end;
  LOffset := AData.Offset + LInternalOffset;
  // Prepare chunk
  LChunk := nil;
  SetLength(LChunk, LChunkSize);
  // Read chunk
  AData.ReadChunk(LInternalOffset, LChunkSize, LChunk[0]);
  // Print chunk info
  Print('# Read Data Chunk');
  Print('%-16s %d', ['Offset', LOffset]);
  Print('%-16s %d', ['Internal Offset', LInternalOffset]);
  Print('%-16s %d', ['Size', LChunkSize]);
  LString := '';
  for LIndex := Low(LChunk) to High(LChunk) do
    LString := LString + IntToHex(LChunk[LIndex]) + ' ';
  Delete(LString, Length(LString), 1);
  Print('%-16s [%s]', ['Chunk', LString]);
  Print('');
end;

procedure WriteDataChunk(AData: TFitsItemData);
const
  cMaxChunkSize = 10;
var
  LChunk: array of Byte;
  LOffset, LInternalOffset: Int64;
  LIndex, LChunkSize: Integer;
  LString: string;
begin
  // Calc offset and chunk size to write meaningful bytes of the data section
  // Last few significant bytes
  if AData.InternalSize > cMaxChunkSize then
  begin
    LInternalOffset := AData.InternalSize - cMaxChunkSize;
    LChunkSize := cMaxChunkSize;
  end else
  // All significant bytes
  begin
    LInternalOffset := 0;
    LChunkSize := AData.InternalSize;
  end;
  LOffset := AData.Offset + LInternalOffset;
  // Prepare chunk
  LChunk := nil;
  SetLength(LChunk, LChunkSize);
  FillChar(LChunk[0], LChunkSize, $FF);
  // Write chunk
  AData.WriteChunk(LInternalOffset, LChunkSize, LChunk[0]);
  // Print chunk info
  Print('# Write Data Chunk');
  Print('%-16s %d', ['Offset', LOffset]);
  Print('%-16s %d', ['Internal Offset', LInternalOffset]);
  Print('%-16s %d', ['Size', LChunkSize]);
  LString := '';
  for LIndex := Low(LChunk) to High(LChunk) do
    LString := LString + IntToHex(LChunk[LIndex]) + ' ';
  Delete(LString, Length(LString), 1);
  Print('%-16s [%s]', ['Chunk', LString]);
  Print('');
end;

procedure Main;
var
  LFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LData: TFitsItemData;
begin
  Print('DeLaFits Demo "Read and write the HDU data"');
  Print('');
  LStream := nil;
  LContainer := nil;
  try
    // Copy the demo FITS file from the "data" directory to the project directory
    LFileName := CopyFile('../../data/demo-item.fits', 'output.fits');
    // Create the stream of FITS file and the FITS container
    LStream := TFileStream.Create(LFileName, fmOpenReadWrite);
    LContainer := TFitsContainer.Create(LStream);
    // Get the data primary HDU
    LData := LContainer.Primary.Data;
    // Read and write data
    ExtractDataInfo(LData);
    ReadDataChunk(LData);
    WriteDataChunk(LData);
  finally
    LContainer.Free;
    LStream.Free;
  end;
  Print('DeLaFits Demo successfully completed, see "%s" file', [ExtractFileName(LFileName)]);
end;

end.
