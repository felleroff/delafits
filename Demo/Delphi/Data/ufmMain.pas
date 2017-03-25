{ *********************************************************** }
{               DeLaFits. Demo program. Delphi.               }
{            Add to the project a DeLaFits library            }
{                                                             }
{          Reading and editing the data of FITS-file          }
{                                                             }
{  Map Data:                                                  }
{                                                             }
{  0-----|-----|-----|-----|--- X ~ NAXIS1, ColsCount, Width  }
{  | 0;0 | 1;0 | 2;0 | 3;0 |                                  }
{  |-----|-----|-----|-----|                                  }
{  | 0;1 | 1;1 | 2;1 | 3;1 |                                  }
{  |-----|-----|-----|-----|                                  }
{  | 0;2 | 1;2 | 2;2 | 3;2 |                                  }
{  |-----|-----|-----|-----|                                  }
{  |                                                          }
{  Y ~ NAXIS2, RowsCount, Height                              }
{                                                             }
{            Copyright(c) 2013-2017, Evgeniy Dikov            }
{                 delafits.library@gmail.com                  }
{            https://github.com/felleroff/delafits            }
{ *********************************************************** }

unit ufmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  //
  DeLaFitsCommon,
  DeLaFitsString,
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
  AppPath: string;

var
  FitName: string;
  Fit: TFitsFileFrame;
  Hdu: THduCore2d;
  Rgn: TRgn;
  X, Y: Integer;
  Valu: Word;
  S: string;
  Data16u: array of array of Word;
  Data32c: array of array of Integer;
  Data64f: array of array of Double;

begin
  Memo1.Lines.Add('');
  Memo1.Lines.Add('DeLaFits.Demo: Reading and editing the data of FITS-file');
  Memo1.Lines.Add('');

  // Prepare the file: to copy "some.fit" into the project directory as "copysome.fit"

  AppPath := ExtractFilePath(ParamStr(0));
  AppPath := IncludeTrailingPathDelimiter(AppPath);
  FitName := AppPath + 'copysome.fit';
  CopyFile(PChar(AppPath + '..\some.fit'), PChar(FitName), False);

  // Create object in read/write mode

  Fit := TFitsFileFrame.CreateJoin(FitName, cFileReadWrite);

  // Read

  Memo1.Lines.Add('------------------------------------------------------------------');
  Memo1.Lines.Add(#13#10'Read. File info:'#13#10);

  Hdu := Fit.HduCore; // get a core of the file
  S := Format('BitPix = %d bit'#13#10 +
              'NAXIS1 = %d'#13#10 +
              'NAXIS2 = %d'#13#10 +
              'BSCALE = %e'#13#10 +
              'BZERO  = %e'#13#10 ,
              [BitPixToInt(Hdu.BitPix), Hdu.NAxis1, Hdu.NAxis2, Hdu.BScale, Hdu.BZero]);
  Memo1.Lines.Add(S);

  Rgn := Fit.DataRgn; // get a full region of the data of the file
  S := Format('Number of columns in the data array = %d pix'#13#10 +
              'Number of rows in the data array    = %d pix'#13#10 ,
              [Rgn.ColsCount, Rgn.RowsCount]);
  Memo1.Lines.Add(S);

  Memo1.Lines.Add('------------------------------------------------------------------');
  Memo1.Lines.Add(#13#10'Read a block of data (5x10), physical_value = BZERO + BSCALE * array_value'#13#10);

                       // define region (2d-matrix):
                       // ## 10 11 12 13 14 15 16 17 18 19, ~X
  Rgn.X1        := 10; // 20 .. .. .. .. .. .. .. .. .. ..
  Rgn.Y1        := 20; // 21 .. .. .. .. .. .. .. .. .. ..
  Rgn.ColsCount := 10; // 22 .. .. .. .. .. .. .. .. .. ..
  Rgn.RowsCount := 5;  // 23 .. .. .. .. .. .. .. .. .. ..
                       // 24 .. .. .. .. .. .. .. .. .. ..
                       // ~Y

  Memo1.Lines.Add('# is used a 16-bit buffer, array of array of Word:');
  Fit.DataRep := rep16u;                   // set type of the elements of user buffer
  Fit.DataPrepare(Pointer(Data16u), Rgn);  // ~ SetLength(Data16u, Rgn.ColsCount, Rgn.RowsCount)
  Fit.DataRead(Pointer(Data16u), Rgn);
  for Y := 0 to Length(Data16u[0]) - 1 do  // line-by-line output, Length(Data16u[0]) = Rgn.RowsCount, Length(Data16u) = Rgn.ColsCount
  begin
    S := '';
    for X := 0 to Length(Data16u) - 1 do
      S := S + IntToStr(Data16u[X, Y]) + ' ';
    Memo1.Lines.Add(S);
  end;
  Data16u := nil;
  Memo1.Lines.Add('');

  Memo1.Lines.Add('# is used a 32-bit buffer, array of array of Integer:');
  Fit.DataRep := rep32c;
  Fit.DataPrepare(Pointer(Data32c), Rgn);
  Fit.DataRead(Pointer(Data32c), Rgn);
  for Y := 0 to Length(Data32c[0]) - 1 do
  begin
    S := '';
    for X := 0 to Length(Data32c) - 1 do
      S := S + IntToStr(Data32c[X, Y]) + ' ';
    Memo1.Lines.Add(S);
  end;
  Data32c := nil;
  Memo1.Lines.Add('');

  Memo1.Lines.Add('# is used a 64-bit buffer (double precision floating-point), array of array of Double:');
  Fit.DataRep := rep64f;
  Fit.DataPrepare(Pointer(Data64f), Rgn);
  Fit.DataRead(Pointer(Data64f), Rgn);
  for Y := 0 to Length(Data64f[0]) - 1 do
  begin
    S := '';
    for X := 0 to Length(Data64f) - 1 do
      S := S + FloatToStri(Data64f[X, Y], False, '%.2f') + ' '; // is declared in DeLaFitsString
    Memo1.Lines.Add(S);
  end;
  Data64f := nil;
  Memo1.Lines.Add('');

  // Write

  Memo1.Lines.Add('------------------------------------------------------------------');
  Memo1.Lines.Add(#13#10'Rewrite a data, physical_value = BZERO + BSCALE * array_value'#13#10);

  Rgn.X1        := 500;
  Rgn.Y1        := 400;
  Rgn.ColsCount := 400;
  Rgn.RowsCount := 200;

  Fit.DataRep := rep16u;                   // set type of the elements of user buffer
  Fit.DataPrepare(Pointer(Data16u), Rgn);  // ~ SetLength(Data16u, Rgn.ColsCount, Rgn.RowsCount)
  Valu := High(Word);                      // 65535
  for X := 0 to Rgn.ColsCount - 1 do       // Rgn.ColsCount = Length(Data16u)
  for Y := 0 to Rgn.RowsCount - 1 do       // Rgn.RowsCount = Length(Data16u[0])
    Data16u[X, Y] := Valu;
  Fit.DataWrite(Pointer(Data16u), Rgn);
  Data16u := nil;
  Memo1.Lines.Add('Write 200x400 a block of data into center of the file;');

  X := 650;
  Y := 450;
  while X < 751 do                             // pixel-access is slow
  begin
    Fit.DataPixels[X, Y] := 0.0;               // \
    Fit.DataPixels[750 - (X - 650), Y] := 0.0; // /
    Inc(X);
    Inc(Y);
  end;
  Memo1.Lines.Add('Write cross 100x100 into center of the file;'#13#10);

  Fit.Free;

  // out

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Ok! Data Processing is successfully complete'#13#10 + FitName);

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Press Escape to close program');

end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.
