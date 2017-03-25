{ *********************************************************** }
{               DeLaFits. Demo program. Delphi.               }
{            Add to the project a DeLaFits library            }
{                                                             }
{              Data Visualization of FITS-file:               }
{     building a graphic image of the data in BMP-format      }
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
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,
  //
  DeLaFitsCommon,
  DeLaFitsString,
  DeLaFitsGraphics,
  DeLaFitsMath;

type

  TfmMain = class(TForm)

    GroupBoxPalette: TGroupBox;
    ComboBoxPalette: TComboBox;
    CheckBoxPaletteInvert: TCheckBox;

    GroupBoxTone: TGroupBox;
    LabelBrightness: TLabel;
    LabelContrast: TLabel;
    LabelGamma: TLabel;
    TrackBarBrightness: TTrackBar;
    TrackBarContrast: TTrackBar;
    TrackBarGamma: TTrackBar;

    GroupBoxGeometry: TGroupBox;
    LabelScl: TLabel;
    LabelSclValue: TLabel;
    BtnSclDec: TSpeedButton;
    BtnSclInc: TSpeedButton;

    LabelRot: TLabel;
    LabelRotValue: TLabel;
    BtnRotDec: TSpeedButton;
    BtnRotInc: TSpeedButton;

    BtnDefault: TButton;
    
    ImageRgn: TImage;
    BtnRgnLeft: TSpeedButton;
    BtnRgnUp: TSpeedButton;
    BtnRgnRight: TSpeedButton;
    BtnRgnDown: TSpeedButton;

    StatusBar1: TStatusBar;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure PaletteChange(Sender: TObject);
    procedure ToneChange(Sender: TObject);
    procedure GeomChange(Sender: TObject);
    procedure RgnChange(Sender: TObject);

    procedure BtnDefaultClick(Sender: TObject);

    procedure ImageRgnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

  private

    FFit: TFitsFileBitmap;
    FRgn: TRgn;
    procedure EditPalette;
    procedure EditTone;
    procedure EditGeom;
    procedure Draw;

  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

{ Private }

procedure TfmMain.EditPalette;
begin
  case ComboBoxPalette.ItemIndex of
    0: FFit.GraphicColor.Palette := cPaletteGrayScale;
    1: FFit.GraphicColor.Palette := cPaletteHot;
    2: FFit.GraphicColor.Palette := cPaletteCool;
    3: FFit.GraphicColor.Palette := cPaletteBonnet;
    4: FFit.GraphicColor.Palette := cPaletteJet;
  end;
  case CheckBoxPaletteInvert.Checked of
    True:  FFit.GraphicColor.PaletteOrder := palInverse;
    False: FFit.GraphicColor.PaletteOrder := palDirect;
  end;
end;

procedure TfmMain.EditTone;
var
  Brightness, Contrast, Gamma: Double;
begin
  Brightness := TrackBarBrightness.Position / 100;
  Contrast   := TrackBarContrast.Position   / 100;
  Gamma      := TrackBarGamma.Position      / 100;
  FFit.GraphicColor.Tone(Brightness, Contrast, Gamma);
  // - or individually (slowly):
  // FFit.GraphicColor.ToneBrightness := Value;
  // FFit.GraphicColor.ToneContrast   := Value;
  // FFit.GraphicColor.ToneGamma      := Value;
end;

procedure TfmMain.EditGeom;
var
  Scl, Rot: Double;
  Pnt: TPnt;
begin
  // Get cener of region
  Pnt.X := FRgn.X1 + FRgn.Width / 2;
  Pnt.Y := FRgn.Y1 + FRgn.Height / 2;
  Pnt := FFit.GraphicGeom.PntScnToFrm(Pnt);
  //
  Scl := DeLaFitsString.StriToFloat(LabelSclValue.Caption);
  Rot := DeLaFitsString.StriToFloat(LabelRotValue.Caption);
  // We scale and rotate a frame
  FFit.GraphicGeom.Clr.Scl(Scl, Scl, xy00).Rot(Rot, xy00);
  // Restore cener of region in ImageRgn
  Pnt := FFit.GraphicGeom.PntFrmToScn(Pnt);
  FRgn.X1 := Round(Pnt.X - FRgn.Width / 2);
  FRgn.Y1 := Round(Pnt.Y - FRgn.Height / 2);
end;

procedure TfmMain.Draw;
const
  SizeCross = 15;
var
  Xc, Yc: Integer;
begin
  // Draw graphic image of the data
  FFit.BitmapRead(ImageRgn.Picture.Bitmap, FRgn);
  // Draw cross in center ImageRgn
  Xc := ImageRgn.Width div 2;
  Yc := ImageRgn.Height div 2;
  with ImageRgn.Picture.Bitmap.Canvas do
  begin
    Pen.Color := clBlue;
    MoveTo(Xc - SizeCross, Yc);
    LineTo(Xc + SizeCross, Yc);
    MoveTo(Xc, Yc - SizeCross);
    LineTo(Xc, Yc + SizeCross);
  end;
  //
  ImageRgn.Refresh;
end;

{ Published }

procedure TfmMain.FormCreate(Sender: TObject);
var
  AppPath, FitName: string;
begin
  // Prepare the file: to copy "some.fit" into the project directory as "copysome.fit"
  AppPath := ExtractFilePath(ParamStr(0));
  AppPath := IncludeTrailingPathDelimiter(AppPath);
  FitName := AppPath + 'copysome.fit';
  CopyFile(PChar(AppPath + '..\some.fit'), PChar(FitName), False);
  // Init object
  FFit := TFitsFileBitmap.CreateJoin(FitName, cFileRead);
  // Init region
  FRgn.X1 := 0;
  FRgn.Y1 := 0;
  FRgn.Width  := ImageRgn.Width;
  FRgn.Height := ImageRgn.Height;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FFit.Free;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  Draw;
  StatusBar1.Panels[3].Text := FFit.StreamFileName;
end;

procedure TfmMain.PaletteChange(Sender: TObject);
begin
  EditPalette;
  Draw;
end;

procedure TfmMain.ToneChange(Sender: TObject);
begin
  EditTone;
  Draw;
end;

procedure TfmMain.GeomChange(Sender: TObject);
var
  Scl, Rot: Double;
begin
  Scl := DeLaFitsString.StriToFloat(LabelSclValue.Caption);
  Rot := DeLaFitsString.StriToFloat(LabelRotValue.Caption);
  case (Sender as TSpeedButton).Tag of
    10: // BtnSclDec.Click
      begin
        if Scl > 1.0 then
          Scl := Scl - 0.5
        else
          Scl := Scl - 0.1;
        if Scl < 0.1 then
          Scl := 0.1;
      end;
    11: // BtnSclInc.Click
      begin
        if Scl < 1.0 then
          Scl := Scl + 0.1
        else
          Scl := Scl + 0.5;
        if Scl > 10 then
          Scl := 10;
      end;
    20: // BtnRotDec.Click
      begin
        Rot := Rot - 5;
        if Rot < -355 then
          Rot := 0;
      end;
    21: // BtnRotInc.Click
      begin
        Rot := Rot + 5;
        if Rot > 355 then
          Rot := 0;
      end;
  end;
  LabelSclValue.Caption := DeLaFitsString.FloatToStri(Scl, False, 1, 1);
  LabelRotValue.Caption := DeLaFitsString.FloatToStri(Rot, True, 3, 1);
  //
  EditGeom;
  Draw;
end;

procedure TfmMain.RgnChange(Sender: TObject);
var
  dx, dy: Integer;
begin
  dx := FRgn.Width div 8;        // step change of region along X-axis
  dy := FRgn.Height div 8;       // step change of region along Y-axis
  case (Sender as TSpeedButton).Tag of
    10: FRgn.X1 := FRgn.X1 + dx; // BtnRgnLeft.Click
    20: FRgn.Y1 := FRgn.Y1 + dy; // BtnRgnUp.Click
    30: FRgn.X1 := FRgn.X1 - dx; // BtnRgnRight.Click
    40: FRgn.Y1 := FRgn.Y1 - dy; // BtnRgnDown.Click
  end;
  Draw;
end;

procedure TfmMain.BtnDefaultClick(Sender: TObject);
begin
  // To recover parameters of FFit
  // Palette
  FFit.GraphicColor.Palette      := cPaletteGrayScale;
  FFit.GraphicColor.PaletteOrder := palDirect;
  // Tone
  FFit.GraphicColor.ToneDefault;
  // Geometry
  FFit.GraphicGeom.Clr;
  // Region
  FRgn.X1 := 0;
  FRgn.Y1 := 0;
  FRgn.Width  := ImageRgn.Width;
  FRgn.Height := ImageRgn.Height;
  // To recover display of parameters
  // Palette
  ComboBoxPalette.OnChange      := nil;
  CheckBoxPaletteInvert.OnClick := nil;
  ComboBoxPalette.ItemIndex     := 0;
  CheckBoxPaletteInvert.Checked := False;
  ComboBoxPalette.OnChange      := PaletteChange;
  CheckBoxPaletteInvert.OnClick := PaletteChange;
  // Tone
  TrackBarBrightness.OnChange := nil;
  TrackBarContrast.OnChange   := nil;
  TrackBarGamma.OnChange      := nil;
  TrackBarBrightness.Position := Round(FFit.GraphicColor.ToneBrightness * 100);
  TrackBarContrast.Position   := Round(FFit.GraphicColor.ToneContrast   * 100);
  TrackBarGamma.Position      := Round(FFit.GraphicColor.ToneGamma      * 100);
  TrackBarBrightness.OnChange := ToneChange;
  TrackBarContrast.OnChange   := ToneChange;
  TrackBarGamma.OnChange      := ToneChange;
  // Geometry
  LabelSclValue.Caption := '1.0';
  LabelRotValue.Caption := '+000.0';
  //
  Draw;
end;

procedure TfmMain.ImageRgnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Pnt: TPnt;
  Pix: TPix;
  I: Extended;
begin
  // get coordinates in Scene-system
  Pnt.X := FRgn.X1 + X;
  Pnt.Y := FRgn.Y1 + Y;
  // convert: point of Scene-system -> point of Frame-system
  Pnt := FFit.GraphicGeom.PntScnToFrm(Pnt);
  // out pixel coordinate (Frame-system)
  StatusBar1.Panels[0].Text := 'X = ' + DeLaFitsString.FloatToStri(Pnt.X, False, 5, 1);
  StatusBar1.Panels[1].Text := 'Y = ' + DeLaFitsString.FloatToStri(Pnt.Y, False, 5, 1);
  // out pixel value
  Pix := DeLaFitsMath.CeilPnt(Pnt);
  if DeLaFitsCommon.RgnIsIncluded(FFit.DataRgn, Pix.X, Pix.Y) then
  begin
    I := FFit.DataPixels[Pix.X, Pix.Y];
    StatusBar1.Panels[2].Text := 'I = ' + DeLaFitsString.FloatToStri(I, False, '%.2f');
  end
  else
  begin
    StatusBar1.Panels[2].Text := '...';
  end;
end;

end.
