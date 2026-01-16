{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{           Render a frame from HDU:PICTURE            }
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

procedure Print(const AText: string); overload;
begin
  Writeln(AText);
end;

procedure Print(const AText: string; const Args: array of const); overload;
begin
  Writeln(Format(AText, Args));
end;

function RegionToString(const ARegion: TRegion): string;
begin
  Result := Format('X1:%4d; Y1:%4d; Width:%4d; Height:%4d',
    [ARegion.X1, ARegion.Y1, ARegion.Width, ARegion.Height]);
end;

procedure Main;
var
  LFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LPicture: TFitsPicture;
  LFrame: TFitsFrame;
  LHandle: TFrameHandle;
  LRegion: TRegion;
  LBitmap: TBitmap;
begin
  Print('DeLaFits Demo "Render a frame from HDU:PICTURE"');
  Print('');
  LStream := nil;
  LContainer := nil;
  LFrame := nil;
  LBitmap := nil;
  try
    // Create the stream of FITS file and the FITS container
    LFileName := ExtractFilePath(ParamStr(0)) + '../../data/demo-image.fits';
    LFileName := ExpandFileName(LFileName);
    LStream := TFileStream.Create(LFileName, fmOpenRead);
    LContainer := TFitsContainer.Create(LStream);
    // Set the "TFitsPicture" class for HDU
    LContainer.ItemClasses[0] := TFitsPicture;
    LPicture := LContainer.Items[0] as TFitsPicture;
    // Create frame - a two-dimensional data fragment HDU
    LHandle := LPicture.Data.FrameHandles[0];
    LFrame := TFitsFrame.Create(LHandle);
    // Set contrast for rendering
    LFrame.Tone.Contrast := 1.2;
    // Set scale and angle for rendering
    LFrame.Geometry.Scale(0.5, 0.5, xy00).Rotate(42.0, xy00);
    // Set the scene rendering region: 3/4 of the full scene relative to the frame center
    LRegion := LFrame.SceneRegion;
    LRegion.X1 := LRegion.X1 + LRegion.Width div 8;
    LRegion.Y1 := LRegion.Y1 + LRegion.Height div 8;
    LRegion.Width := LRegion.Width * 3 div 4;
    LRegion.Height := LRegion.Height * 3 div 4;
    // Create bitmap object
    LFileName := ExtractFilePath(ParamStr(0)) + 'output.bmp';
    LBitmap := TBitmap.Create;
    // Render frame: build a bitmap from the frame values
    LFrame.RenderScene(LRegion, LBitmap);
    // Save bitmap to a file
    LBitmap.SaveToFile(LFileName);
    // Print log
    Print('# Create container from FITS file "../../data/demo-image.fits"');
    Print('# Get HDU from container');
    Print('# Get frame from HDU');
    Print('# Set frame rendering parameters');
    Print('%-19s %d', ['Index Black', LFrame.Histogram.IndexBlack]);
    Print('%-19s %d', ['Index White', LFrame.Histogram.IndexWhite]);
    Print('%-19s %.1f', ['Value Black', LFrame.Histogram.Buckets[LFrame.Histogram.IndexBlack].Value]);
    Print('%-19s %.1f', ['Value White', LFrame.Histogram.Buckets[LFrame.Histogram.IndexWhite].Value]);
    Print('%-19s %.1f', ['Brightness', LFrame.Tone.Brightness]);
    Print('%-19s %.1f', ['Contrast', LFrame.Tone.Contrast]);
    Print('%-19s %.1f', ['Gamma', LFrame.Tone.Gamma]);
    Print('%-19s %.1f', ['Scale', 0.5]);
    Print('%-19s %.1f', ['Rotation angle', 42.0]);
    Print('%-19s (%s)', ['Local frame region', RegionToString(LFrame.Region)]);
    Print('%-19s (%s)', ['Scene frame region', RegionToString(LFrame.SceneRegion)]);
    Print('%-19s (%s)', ['Local render region', RegionToString(LFrame.Geometry.SceneRegionToLocalRegion(LRegion))]);
    Print('%-19s (%s)', ['Scene render region', RegionToString(LRegion)]);
    Print('# Render frame');
  finally
    LBitmap.Free;
    LFrame.Free;
    LContainer.Free;
    LStream.Free;
  end;
  Print('');
  Print('DeLaFits Demo successfully completed, see "%s" file', [ExtractFileName(LFileName)]);
end;

end.
