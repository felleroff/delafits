{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{          Read and write IMAGE frame values           }
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
  SysUtils, Classes, DeLaFitsCommon, DeLaFitsClasses, DeLaFitsPicture;

type
  TBufferType = (btUnknown, btFloat, btInteger);
  TFloatBuffer = array of Double;
  TIntegerBuffer = array of Int64;

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

function CalcTBufferType(AFrame: TFitsFrame): TBufferType;
begin
  // Calculate the optimal type for the R/W buffer. The actual value type of the
  // IMAGE extension is specified by the BITPIX, BSCALE, and BZERO keyword records
  case AFrame.ValueType of
    num80f, num64f, num32f:
      Result := btFloat;
    num08c, num08u, num16c, num16u, num32c, num32u, num64c:
      Result := btInteger;
  else { numUnknown: }
    Result := btUnknown;
    Assert(False, 'Unknown value type');
  end;
end;

procedure FillBuffer(var ABuffer: TFloatBuffer; const AStartValue: Double); overload;
var
  LIndex: Integer;
begin
  for LIndex := Low(ABuffer) to High(ABuffer) do
    ABuffer[LIndex] := AStartValue + LIndex;
end;

procedure FillBuffer(var ABuffer: TIntegerBuffer; const AStartValue: Int64); overload;
var
  LIndex: Integer;
begin
  for LIndex := Low(ABuffer) to High(ABuffer) do
    ABuffer[LIndex] := AStartValue + LIndex;
end;

function BufferToString(const ABuffer: TFloatBuffer): string; overload;
var
  LIndex: Integer;
begin
  Result := '';
  for LIndex := 0 to 4 do
    Result := Result + FloatToStr(ABuffer[LIndex]) + ' ';
  Result := Result + '...';
  for LIndex := Length(ABuffer) - 5 to Length(ABuffer) - 1 do
    Result := Result + ' ' + FloatToStr(ABuffer[LIndex]);
end;

function BufferToString(const ABuffer: TIntegerBuffer): string; overload;
var
  LIndex: Integer;
begin
  Result := '';
  for LIndex := 0 to 4 do
    Result := Result + IntToStr(ABuffer[LIndex]) + ' ';
  Result := Result + '...';
  for LIndex := Length(ABuffer) - 5 to Length(ABuffer) - 1 do
    Result := Result + ' ' + IntToStr(ABuffer[LIndex]);
end;

procedure ExtractFrameInfo(AFrame: TFitsFrame);
var
  LValueType: string;
begin
  // Print frame info
  Print('# Frame info');
  Print('%-12s %d', ['Frame Index', AFrame.FrameIndex]);
  Print('%-12s %d', ['Frame Offset', AFrame.FrameOffset]);
  Print('%-12s %d', ['Offset', AFrame.Offset]);
  Print('%-12s %d', ['Size', AFrame.Size]);
  Print('%-12s %d', ['BitPix', BitPixToInt(AFrame.BitPix)]);
  Print('%-12s %.1f', ['BScale', AFrame.BScale]);
  Print('%-12s %.1f', ['BZero', AFrame.BZero]);
  Print('%-12s %d', ['Pixel Size', AFrame.PixelSize]);
  case AFrame.ValueType of
    numUnknown: LValueType := 'Unknown';
    num80f: LValueType := 'Extended';
    num64f: LValueType := 'Double';
    num32f: LValueType := 'Single';
    num08c: LValueType := 'ShortInt';
    num08u: LValueType := 'Byte';
    num16c: LValueType := 'SmallInt';
    num16u: LValueType := 'Word';
    num32c: LValueType := 'Integer';
    num32u: LValueType := 'Cardinal';
    num64c: LValueType := 'Int64';
  else
    LValueType := '';
  end;
  Print('%-12s %s', ['Value Type', LValueType]);
  Print('%-12s %d', ['Value Start', AFrame.ValueStart]);
  Print('%-12s %d', ['Value Count', AFrame.ValueCount]);
  Print('%-12s %d', ['Width', AFrame.Width]);
  Print('%-12s %d', ['Height', AFrame.Height]);
  Print('');
end;

procedure ReadFrameValues(AFrame: TFitsFrame);
var
  LRowIndexes: array [0 .. 5] of Integer;
  LBufferType: TBufferType;
  LBuffer64f: TFloatBuffer;
  LBuffer64c: TIntegerBuffer;
  LBuffer: string;
  LWidth, LHeight, LIndex, LRowIndex: Integer;
begin
  LBufferType := CalcTBufferType(AFrame);
  LWidth := AFrame.Width;
  LHeight := AFrame.Height;
  // Prepare a buffer to read frame values
  LBuffer64f := nil;
  LBuffer64c := nil;
  case LBufferType of
    btFloat:   SetLength(LBuffer64f, LWidth);
    btInteger: SetLength(LBuffer64c, LWidth);
  end;
  // Prepare frame row indexes
  LRowIndexes[0] := 0;
  LRowIndexes[1] := 1;
  LRowIndexes[2] := 2;
  LRowIndexes[3] := LHeight - 3;
  LRowIndexes[4] := LHeight - 2;
  LRowIndexes[5] := LHeight - 1;
  // Read frame values row by row
  Print('# Read frame values');
  case LBufferType of
    btFloat:
      for LIndex := Low(LRowIndexes) to High(LRowIndexes) do
      begin
        LRowIndex := LRowIndexes[LIndex];
        AFrame.ReadValues({AX:} 0, {AY:} LRowIndex, LWidth, {var} TA64f(LBuffer64f));
        LBuffer := BufferToString(LBuffer64f);
        Print('Row[%.3d] [%s]', [LRowIndex, LBuffer]);
      end;
    btInteger:
      for LIndex := Low(LRowIndexes) to High(LRowIndexes) do
      begin
        LRowIndex := LRowIndexes[LIndex];
        AFrame.ReadValues({AX:} 0, {AY:} LRowIndex, LWidth, {var} TA64c(LBuffer64c));
        LBuffer := BufferToString(LBuffer64c);
        Print('Row[%.3d] [%s]', [LRowIndex, LBuffer]);
      end;
  end;
  Print('');
end;

procedure WriteFrameValues(AFrame: TFitsFrame);
var
  LRowIndexes: array [0 .. 5] of Integer;
  LBufferType: TBufferType;
  LBuffer64f: TFloatBuffer;
  LBuffer64c: TIntegerBuffer;
  LBuffer: string;
  LWidth, LHeight, LIndex, LRowIndex: Integer;
begin
  LBufferType := CalcTBufferType(AFrame);
  LWidth := AFrame.Width;
  LHeight := AFrame.Height;
  // Prepare a buffer to write frame values
  LBuffer64f := nil;
  LBuffer64c := nil;
  case LBufferType of
    btFloat:   SetLength(LBuffer64f, LWidth);
    btInteger: SetLength(LBuffer64c, LWidth);
  end;
  // Prepare frame row indexes
  LRowIndexes[0] := 0;
  LRowIndexes[1] := 1;
  LRowIndexes[2] := 2;
  LRowIndexes[3] := LHeight - 3;
  LRowIndexes[4] := LHeight - 2;
  LRowIndexes[5] := LHeight - 1;
  // Write frame values row by row
  Print('# Write frame values');
  case LBufferType of
    btFloat:
      for LIndex := Low(LRowIndexes) to High(LRowIndexes) do
      begin
        LRowIndex := LRowIndexes[LIndex];
        FillBuffer({var} LBuffer64f, (LIndex + 1) * 1000); // new values
        AFrame.WriteValues({AX:} 0, {AY:} LRowIndex, LWidth, TA64f(LBuffer64f));
        LBuffer := BufferToString(LBuffer64f);
        Print('Row[%.3d] [%s]', [LRowIndex, LBuffer]);
      end;
    btInteger:
      for LIndex := Low(LRowIndexes) to High(LRowIndexes) do
      begin
        LRowIndex := LRowIndexes[LIndex];
        FillBuffer({var} LBuffer64c, (LIndex + 1) * 1000); // new values
        AFrame.WriteValues({AX:} 0, {AY:} LRowIndex, LWidth, TA64c(LBuffer64c));
        LBuffer := BufferToString(LBuffer64c);
        Print('Row[%.3d] [%s]', [LRowIndex, LBuffer]);
      end;
  end;
  Print('');
end;

procedure Main;
var
  LFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LPicture: TFitsPicture;
  LFrame: TFitsFrame;
  LHandle: TFrameHandle;
begin
  Print('DeLaFits Demo "Read and write IMAGE frame values"');
  Print('');
  LStream := nil;
  LContainer := nil;
  LFrame := nil;
  try
    // Copy the demo FITS file from the "data" directory to the project directory
    LFileName := CopyFile('../../data/demo-image.fits', 'output.fits');
    // Create the stream of FITS file and the FITS container
    LStream := TFileStream.Create(LFileName, fmOpenReadWrite);
    LContainer := TFitsContainer.Create(LStream);
    // Set the class "TFitsPicture" for the IMAGE HDU. If this HDU is not IMAGE
    // an exception will be raised. To check the HDU extension, use the
    // "ItemExtensionTypeIs" method
    LContainer.ItemClasses[0] := TFitsPicture;
    LPicture := LContainer.Items[0] as TFitsPicture;
    // Create frame - a two-dimensional data fragment HDU
    LHandle := LPicture.Data.FrameHandles[0];
    LFrame := TFitsFrame.Create(LHandle);
    // Read and write values
    ExtractFrameInfo(LFrame);
    ReadFrameValues(LFrame);
    WriteFrameValues(LFrame);
  finally
    LFrame.Free;
    LContainer.Free;
    LStream.Free;
  end;
  Print('DeLaFits Demo successfully completed, see "%s" file', [ExtractFileName(LFileName)]);
end;

end.
