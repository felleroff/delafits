{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{       Create a new IMAGE from the BITMAP file        }
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
  SysUtils, Classes, Graphics, DeLaFitsCommon, DeLaFitsClasses, DeLaFitsPicture;

type
  TWordDynArray = array of Word;

procedure Print(const AText: string); overload;
begin
  Writeln(AText);
end;

procedure Print(const AText: string; const Args: array of const); overload;
begin
  Writeln(Format(AText, Args));
end;

procedure BitmapPixelsToGrayscale(ABitMap: TBitMap; ARowIndex: Integer; var ABuffer: TWordDynArray);
type
  PPixel = ^TPixel;
  TPixel = packed record
    B, G, R: Byte;
  end;

  function Luminance(const APixel: TPixel): T16u;
  var
    LLumin: Double;
  begin
    // https://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
    LLumin := 0.2126 * APixel.R + 0.7152 * APixel.G + 0.0722 * APixel.B;
    Result := Round(LLumin * 100);
  end;

{$IFDEF FPC}
var
  LIndex, LBitPixel, LBitLine: Integer;
  LPixel: PPixel;
begin
  Assert((ARowIndex >= 0) and (ARowIndex < ABitMap.Height) and (ABitMap.Width = Length(ABuffer)));
  LBitPixel := ABitMap.RawImage.Description.BitsPerPixel div 8;
  LBitLine := ABitMap.RawImage.Description.BytesPerLine;
  LPixel := PPixel(ABitMap.RawImage.Data);
  Inc(PByte(LPixel), ARowIndex * LBitLine);
  for LIndex := 0 to ABitMap.Width - 1 do
  begin
    ABuffer[LIndex] := Luminance(LPixel^);
    Inc(PByte(LPixel), LBitPixel);
  end;
end;
{$ELSE}
type
  PLine = ^TLine;
  TLine = array [0 .. 0] of TPixel;
var
  LIndex: Integer;
  LLine: PLine;
begin
  Assert((ARowIndex >= 0) and (ARowIndex < ABitMap.Height) and (ABitMap.Width = Length(ABuffer)));
  LLine := ABitMap.ScanLine[ARowIndex];
  for LIndex := 0 to ABitMap.Width - 1 do
    ABuffer[LIndex] := Luminance(LLine^[LIndex]);
end;
{$ENDIF}

function GetFileSize(const AFileName: string): Integer;
var
  LStream: TFileStream;
begin
  LStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := Integer(LStream.Size);
  finally
    LStream.Free;
  end;
end;

function PixelFormatToString(APixelFormat: TPixelFormat): string;
begin
  case APixelFormat of
    pfDevice: Result := 'Device';
    pf1bit: Result := '1';
    pf4bit: Result := '4';
    pf8bit: Result := '8';
    pf15bit: Result := '15';
    pf16bit: Result := '16';
    pf24bit: Result := '24';
    pf32bit: Result := '32';
    pfCustom: Result := 'Custom';
  else
    Result := '';
  end;
end;

function NumberTypeToString(ANumberType: TNumberType): string;
begin
  case ANumberType of
    numUnknown: Result := 'Unknown';
    num80f: Result := 'Extended';
    num64f: Result := 'Double';
    num32f: Result := 'Single';
    num08c: Result := 'ShortInt';
    num08u: Result := 'Byte';
    num16c: Result := 'SmallInt';
    num16u: Result := 'Word';
    num32c: Result := 'Integer';
    num32u: Result := 'Cardinal';
    num64c: Result := 'Int64';
  else
    Result := '';
  end;
end;

procedure Main;
var
  LBitmapFileName, LFitsFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LBitmap: TBitmap;
  LPictureSpec: TFitsPictureSpec;
  LPicture: TFitsPicture;
  LHandle: TFrameHandle;
  LFrame: TFitsFrame;
  LBuffer: TWordDynArray;
  LRowIndex: Integer;
begin
  Print('DeLaFits Demo "Create a new IMAGE from the BITMAP file"');
  Print('');
  LBitmap := nil;
  LStream := nil;
  LContainer := nil;
  LPictureSpec := nil;
  LFrame := nil;
  try
    LBitmapFileName := ExtractFilePath(ParamStr(0)) + 'input.bmp';
    LFitsFileName := ExtractFilePath(ParamStr(0)) + 'output.fits';
    // Load BITMAP from a file
    LBitmap := TBitmap.Create;
    LBitmap.LoadFromFile(LBitmapFileName);
    // Create empty FITS container
    LStream := TFileStream.Create(LFitsFileName, fmCreate);
    LContainer := TFitsContainer.Create(LStream);
    // Create IMAGE specification: one 16-bit frame of the same size as the BITMAP
    LPictureSpec := TFitsPictureSpec.CreateNew(num16u, LBitmap.Width, LBitmap.Height);
    // Add new IMAGE to the FITS container (the container owns the picture object)
    LPicture := LContainer.Add(TFitsPicture, LPictureSpec) as TFitsPicture;
    // Add comment to new IMAGE
    LPicture.Head.AddComment('Copyright. This FITS file was created specifically to demonstrate the features of the DeLaFits library');
    // Get the FRAME object from new IMAGE
    LHandle := LPicture.Data.FrameHandles[0];
    LFrame := TFitsFrame.Create(LHandle);
    // Prepare buffer
    LBuffer := nil;
    SetLength(LBuffer, LFrame.Width);
    // Convert the pixel values of the BITMAP to 16-bit grayscale values (word type) and write them to the FRAME row by row
    for LRowIndex := 0 to LFrame.Width - 1 do
    begin
      BitmapPixelsToGrayscale(LBitmap, LRowIndex, {var} LBuffer);
      LFrame.WriteValues({AX:} 0, {AY:} LRowIndex, LFrame.Width, TA16u(LBuffer));
    end;
    // Print log
    Print('# Load BITMAP from file "%s"', [ExtractFileName(LBitmapFileName)]);
    Print('%-10s %s', ['Bit depth', PixelFormatToString(LBitmap.PixelFormat)]);
    Print('%-10s %d', ['Width', LBitmap.Width]);
    Print('%-10s %d', ['Height', LBitmap.Height]);
    Print('%-10s %d', ['File size', GetFileSize(LBitmapFileName)]);
    Print('');
    Print('# Create empty FITS container "%s"', [ExtractFileName(LFitsFileName)]);
    Print('');
    Print('# Create IMAGE specification');
    Print('%-10s %d', ['BITPIX', BitPixToInt(LPictureSpec.BITPIX)]);
    Print('%-10s %d', ['NAXIS', LPictureSpec.NAXIS]);
    Print('%-10s %d', ['NAXIS1', LPictureSpec.NAXES[1]]);
    Print('%-10s %d', ['NAXIS2', LPictureSpec.NAXES[2]]);
    Print('%-10s %d', ['PCOUNT', LPictureSpec.PCOUNT]);
    Print('%-10s %d', ['GCOUNT', LPictureSpec.GCOUNT]);
    Print('%-10s %.1f', ['BSCALE', LPictureSpec.BSCALE]);
    Print('%-10s %.1f', ['BZERO', LPictureSpec.BZERO]);
    Print('');
    Print('# Add new IMAGE to the FITS container');
    Print('%-10s %s', ['Type', LPicture.GetXTENSION]);
    Print('%-10s %d', ['Size', LPicture.Size]);
    Print('');
    Print('# Get FRAME from new IMAGE');
    Print('%-10s %d', ['Pixel Size', LFrame.PixelSize]);
    Print('%-10s %s', ['Value Type', NumberTypeToString(LFrame.ValueType)]);
    Print('%-10s %d', ['Width', LFrame.Width]);
    Print('%-10s %d', ['Height', LFrame.Height]);
    Print('');
    Print('# Convert BITMAP pixels and write them to the FRAME');
    Print('');
  finally
    LFrame.Free;
    LPictureSpec.Free;
    LContainer.Free;
    LStream.Free;
    LBitmap.Free;
  end;
  Print('DeLaFits Demo successfully completed, see "%s" file', [ExtractFileName(LFitsFileName)]);
end;

end.
