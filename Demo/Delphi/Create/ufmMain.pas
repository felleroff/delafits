{ **************************************************** }
{           DeLaFits. Demo program. Delphi.            }
{        Add to the project a DeLaFits library         }
{                                                      }
{            Create new file in FITS format:           }
{         convert BMP-image in the FITS format         }
{                                                      }
{        Copyright(c) 2013-2017, Evgeniy Dikov         }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit ufmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  //
  DeLaFitsCommon,
  DeLaFitsClasses;

type

  TfmMain = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.FormCreate(Sender: TObject);
var
  Path: string;
  
var
  Fit: TFitsFileFrame;
  FitName: string;
  Hdu: THduCore2d; // Core of Header
  Item: TLineItem; // Item of Header
  Rgn: TRgn;       // Region of Data
  X, Y: Integer;
  Data: array of array of LongWord;

type
  // For TBitMap.ScanLines: fast access an the pixels of the image
  // http://stackoverflow.com/questions/13583451/how-to-use-scanline-property-for-24-bit-bitmaps
  TLine24Item = packed record
    B, G, R: Byte;
  end;
  PLine24 = ^TLine24;
  TLine24 = array [0 .. 0] of TLine24Item;

var
  Bmp: Graphics.TBitMap;
  Line24: PLine24;
  Luminance: Double;

begin
  Memo1.Lines.Add('');
  Memo1.Lines.Add('DeLaFits.Demo: Create new file in FITS format');
  Memo1.Lines.Add('');

  Path := ExtractFilePath(ParamStr(0));
  Path := IncludeTrailingPathDelimiter(Path);

  // Init Region of the data, Image size

  Rgn.X1 := 0;
  Rgn.Y1 := 0;
  Rgn.ColsCount := 200; // Width
  Rgn.RowsCount := 200; // Height

  // Init Hdu, core of the header:
  // - data size = 200x200 pixels;
  // - data format = 32-bit [0 .. 2^32 - 1];

  Hdu.Simple := True;
  Hdu.BitPix := bi32c;
  Hdu.NAxis1 := Rgn.ColsCount; 
  Hdu.NAxis2 := Rgn.RowsCount;
  Hdu.BScale := 1.0;
  Hdu.BZero  := cBZero32u;

  // Create new object

  FitName := Path + 'image.fit';
  Fit := TFitsFileFrame.CreateMade(FitName, Hdu);

  // Add into header a Chars-value, the long comment

  Item.Keyword       := 'COMMENT';
  Item.ValueIndicate := False;
  Item.Value.Str     := 'DeLaFits(demo). This file was created specifically ' +
                        'to demonstrate features of the library DeLaFits. ' +
                        'Create new file in FITS format: convert BMP-image ' +
                        'in the FITS format';
  Item.NoteIndicate  := False;
  Item.Note          := '';
  Fit.LineBuilder.Add(Item, cCastCharsLong);

  // Define data representation: array of array of LongWord;

  Fit.DataRep := rep32u;

  // Prepare Buffer: SetLength(Data, Rgn.ColsCount, Rgn.RowsCount)

  Fit.DataPrepare(Pointer(Data), Rgn);

  // Read Bmp-pixel (24-bit) and convert into Fit-pixel (32-bit, LongWord)
  // Bmp.Width  = Rgn.ColsCount, X-axis
  // Bmp.Height = Rgn.RowsCount, Y-axis

  Bmp := TBitMap.Create;
  Bmp.PixelFormat := pf24bit;
  Bmp.LoadFromFile(Path + 'image.bmp');
  for Y := 0 to Bmp.Height - 1 do
  begin
    Line24 := Bmp.ScanLine[Y];
    for X := 0 to Bmp.Width - 1 do
    begin
      // Grayscale, linear luminance
      // https://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
      with Line24^[X] do
        Luminance := 0.2126 * R + 0.7152 * G + 0.0722 * B;
      Data[X, Y] := Round(Luminance);
    end;
  end;
  Bmp.Free;

  // Write Buffer

  Fit.DataWrite(Pointer(Data), Rgn);
  Data := nil;

  // Free

  Fit.Free;

  // Out

  Memo1.Lines.Add('Ok! New file in FITS format is created:'+ #13#10 + FitName);

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Press Escape to close program');

end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.
