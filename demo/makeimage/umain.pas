{ **************************************************** }
{                DeLaFits. Demo Program                }
{                                                      }
{     Make new FITS file: standard IMAGE extension     }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit umain;

interface

uses
  SysUtils, Classes, Graphics, DeLaFitsCommon, DeLaFitsClasses, DeLaFitsImage;

  // Entry Point

  procedure Main;

implementation

procedure Log(const AText: string); overload;
begin
  Writeln(AText);
end;

procedure Log(const AText: string; const Args: array of const); overload;
var
  Text: string;
begin
  Text := Format(AText, Args);
  Log(Text);
end;

// Returns the full name of new FITS file

function GetNewFileName: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'demo-makeimage.fits';
  if FileExists(Result) then
    DeleteFile(Result);
end;

// Add the copyright of the demo project to the header

procedure AddCopyright(AHead: TFitsUmitHead; const AText: string);
var
  Comment: string;
begin
  Comment := Format('This file was created specifically to demonstrate the features of the DeLaFits library (c) %4d.', [CurrentYear]);
  Comment := Comment + ' ' + AText;
  AHead.AddComment(Comment);
end;

// Convert a bitmap pixel from RGB-color to grayscale-value (linear luminance)
// https://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale

procedure GetGrayscaleDataRow(BitMap: TBitMap; const Row: Integer; var Buffer: TA16u);

type

  PUmit = ^TUmit;
  TUmit = packed record
    B, G, R: Byte;
  end;

{$IFNDEF FPC}
  PLine = ^TLine;
  TLine = array [0 .. 0] of TUmit;
{$ENDIF}

  function Luminance(const Umit: TUmit): T16u;
  var
    Lum: Double;
  begin
    Lum := 0.2126 * Umit.R + 0.7152 * Umit.G + 0.0722 * Umit.B;
    Result := Round(Lum * 100);
  end;

var
  I: Integer;

{$IFDEF FPC}
  BitUmit, BitLine: Integer;
  Umit: PUmit;
{$ELSE}
  Line: PLine;
{$ENDIF}

begin

  Assert((Row >= 0) and (Row < BitMap.Height) and (BitMap.Width = Length(Buffer)));

{$IFDEF FPC}

  BitUmit := BitMap.RawImage.Description.BitsPerPixel div 8;
  BitLine := BitMap.RawImage.Description.BytesPerLine;
  Umit := PUmit(BitMap.RawImage.Data);
  Inc(PByte(Umit), Row * BitLine);
  for I := 0 to BitMap.Width - 1 do
  begin
    Buffer[I] := Luminance(Umit^);
    Inc(PByte(Umit), BitUmit);
  end;

{$ELSE}

  Line := BitMap.ScanLine[Row];
  for I := 0 to BitMap.Width - 1 do
    Buffer[I] := Luminance(Line^[I]);

{$ENDIF}

end;

procedure Make(const ANewFileName: string);
var
  BitMap: TBitMap;
  Stream: TFileStream;
  Container: TFitsContainer;
  Spec: TFitsImageSpec;
  Image: TFitsImage;
  Head: TFitsImageHead;
  Data: TFitsImageData;
  Row, Width, Height: Integer;
  Buffer: TA16u;
begin

  BitMap    := nil;
  Stream    := nil;
  Container := nil;
  Spec      := nil;
  Buffer    := nil;

  try

    // Load original bitmap

    BitMap := TBitmap.Create;
    BitMap.PixelFormat := pf24bit;
    BitMap.LoadFromFile(ChangeFileExt(ANewFileName, '.bmp'));

    Width := BitMap.Height;
    Height := BitMap.Width;

    // Create Stream and Container

    Stream := TFileStream.Create(ANewFileName, fmCreate);

    Container := TFitsContainer.Create(Stream);

    // Prepare the specification of standard IMAGE extension

    Spec := TFitsImageSpec.Create(bi16c, [Width, Height], 1.0, cZero16u);

    // Add standard IMAGE extension

    Image := Container.Add(TFitsImage, Spec) as TFitsImage;

    // Edit IMAGE Head

    Head := Image.Head;

    AddCopyright(Head, 'Make a new FITS file with standard IMAGE extension');

    // Edit IMAGE Data

    Data := Image.Data;

    SetLength(Buffer, Width);

    for Row := 0 to Height - 1 do
    begin
      GetGrayscaleDataRow(BitMap, Row, Buffer);                   // convert a bitmap pixel from RGB-color to grayscale-value
      Data.WriteElems((Height - Row - 1) * Width, Width, Buffer); // write grayscale-value with Y-axis inversion
    end;

  finally

    Buffer := nil;

    if Assigned(Spec) then
      Spec.Free;

    if Assigned(Container) then
      Container.Free;

    if Assigned(Stream) then
      Stream.Free;

    if Assigned(BitMap) then
      BitMap.Free;

  end;

end;


procedure Main();
var
  NewFileName: string;
begin

  Log('DeLaFits. Demo Program. Make new FITS file: standard IMAGE extension');
  Log('');

  NewFileName := GetNewFileName();

  Make(NewFileName);

  Log('New FITS file make successfully, see "%s" file', [NewFileName]);

end;

end.
