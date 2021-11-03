{ **************************************************** }
{                DeLaFits. Demo Program                }
{                                                      }
{     Render the IMAGE extension of the FITS file      }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit umain;

interface

uses
  SysUtils, Classes, Graphics, DeLaFitsCommon, DeLaFitsClasses, DeLaFitsPicture;

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

// Returns the full name of the FITS file with IMAGE extension

function GetImageFileName: string;
var
  Path: string;
begin
  Path := ExtractFilePath(ParamStr(0)) + '../../data/';
  Result := ExpandFileName(Path + 'demo-image.fits');
end;

// Returns the full name of the new BITMAP file

function GetBitmapFileName: string;
var
  Path: string;
begin
  Path := ExtractFilePath(ParamStr(0));
  Result := ExpandFileName(Path + 'demo-image.bmp');
end;

procedure Render(const AImageFileName, ABitmapFileName: string);
var
  Bitmap: TBitmap;
  Stream: TFileStream;
  Container: TFitsContainer;
  Picture: TFitsPicture;
  Frame: TFitsPictureFrame;
  Region: TRegion;
begin

  Stream    := nil;
  Container := nil;
  Bitmap    := nil;

  try

    // Create Stream and Container from original FITS file

    Stream := TFileStream.Create(AImageFileName, fmOpenRead);

    Container := TFitsContainer.Create(Stream);

    // Cast HDU[0] as standard IMAGE extension

    Picture := Container.Reclass(0, TFitsPicture) as TFitsPicture;

    // IMAGE data is conveniently represented as an array of 2D frames -> get
    // the first frame of IMAGE extension

    Frame := Picture.Frames[0];

    // Correct the picture tone

    Frame.Tone.Contrast := 1.2;

    // Correct the scene geometry

    Frame.Geometry.Scale(0.5, 0.5, xy00).Rotate(30.0, xy00);

    // Get the local frame region

    Region := Frame.LocalRegion;
    Log('Local frame region: X1 = %4d, Y1 = %d, Width = %4d, Height = %4d', [Region.X1, Region.Y1, Region.Width, Region.Height]);

    // Get the scene frame region

    Region := Frame.SceneRegion;
    Log('Scene frame region: X1 = %4d, Y1 = %d, Width = %4d, Height = %4d', [Region.X1, Region.Y1, Region.Width, Region.Height]);

    // Set a custom region of the scene to render

    Region := Frame.SceneRegion;
    Region.X1     := Region.X1 + Region.Width  div 4;
    Region.Y1     := Region.Y1 + Region.Height div 4;
    Region.Width  := Region.Width  div 2;
    Region.Height := Region.Height div 2;

    // Render

    Bitmap := TBitmap.Create;
    Frame.RenderScene(Bitmap, Region);
    Bitmap.SaveToFile(ABitmapFileName);

  finally

    Container.Free;
    Stream.Free;
    BitMap.Free;

  end;

end;


procedure Main();
var
  ImageFileName, BitmapFileName: string;
begin

  Log('DeLaFits. Demo Program. Render the standard IMAGE extension of the FITS file');
  Log('');

  ImageFileName  := GetImageFileName();
  BitmapFileName := GetBitmapFileName();

  Render(ImageFileName, BitmapFileName);

  Log('');
  Log('Rendering is successfully, see new BITMAP file "%s"', [BitmapFileName]);

end;

end.
