{ **************************************************** }
{           DeLaFits. Demo program. Lazarus.           }
{        Add to the project a DeLaFits library         }
{                                                      }
{     Reading and editing the header of FITS-file      }
{   Line ~ <keyword-separator-value-separator-note>    }
{                                                      }
{        Copyright(c) 2013-2016, Evgeniy Dikov         }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit ufmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LCLType,
  StdCtrls,
  //
  DeLaFitsCommon,
  DeLaFitsClasses;

type

  { TfmMain }

  TfmMain = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.lfm}

{ TfmMain }

procedure TfmMain.FormCreate(Sender: TObject);
var
  AppPath: string;

var
  FitName: string;
  Fit: TFitsFileFrame;
  I, Count, Index: Integer;
  vStr: string;
  vInt: Integer;
  vFloat: Double;
  vDateTime: TDateTime;
  Item: TLineItem;

begin

  Memo1.Lines.Add('');
  Memo1.Lines.Add('DeLaFits.Demo: Reading and editing the header of FITS-file');
  Memo1.Lines.Add('');

  // Prepare the file: to copy "some.fit" into the project directory as "copysome.fit"

  AppPath := ExtractFilePath(ParamStr(0));
  AppPath := IncludeTrailingPathDelimiter(AppPath);
  FitName := AppPath + 'copysome.fit';
  CopyFile(AppPath + '..' + PathDelim + 'some.fit', FitName, [cffOverwriteFile]);

  // Create object in read/write mode

  Fit := TFitsFileFrame.CreateJoin(FitName, cFileReadWrite);

  // Read

  Memo1.Lines.Add('------------------------------------------------------------------');
  Memo1.Lines.Add(#13#10'Read Header. Value'#13#10);

  Index := Fit.LineBuilder.IndexOf('OBSERVER');
  if Index <> -1 then
  begin
    vStr := Fit.LineBuilder.ValuesString[Index];
    Memo1.Lines.Add('OBSERVER : ' + vStr);
  end;

  Index := Fit.LineBuilder.IndexOf('CREATOR');
  if Index <> -1 then
  begin
    vStr := Fit.LineBuilder.ValuesString[Index];
    Memo1.Lines.Add('CREATOR  : ' + vStr);
  end;

  Index := Fit.LineBuilder.IndexOf('DATE-OBS');
  if Index <> -1 then
  begin
    vDateTime := Fit.LineBuilder.ValuesDateTime[Index];
    Memo1.Lines.Add('DATE-OBS : ' + FormatDateTime('YYYY-MM-DD hh:mm:ss.zzz', vDateTime));
  end;

  Index := Fit.LineBuilder.IndexOf('EXPOSURE');
  if Index <> -1 then
  begin
    vFloat := Fit.LineBuilder.ValuesFloat[Index];
    Memo1.Lines.Add('EXPOSURE : ' + FloatToStr(vFloat));
  end;

  Index := Fit.LineBuilder.IndexOf('RA');
  if Index <> -1 then
  begin
    vFloat := Fit.LineBuilder.ValuesRa[Index];
    Memo1.Lines.Add('RA       : ' + FloatToStr(vFloat)); // in degree, Ra [000 .. 360]
  end;

  Index := Fit.LineBuilder.IndexOf('DEC');
  if Index <> -1 then
  begin
    vFloat := Fit.LineBuilder.ValuesDe[Index];
    Memo1.Lines.Add('DEC      : ' + FloatToStr(vFloat)); // in degree, Dec [-90 .. +90]
  end;

  Index := Fit.LineBuilder.IndexOf('XBINNING');
  if Index <> -1 then
  begin
    vInt := Fit.LineBuilder.ValuesInteger[Index];
    Memo1.Lines.Add('XBINNING : ' + IntToStr(vInt));
  end;

  Index := Fit.LineBuilder.IndexOf('COMMENT');
  if Index <> -1 then
  begin
    vStr := Fit.LineBuilder.ValuesCharsLong[Index];
    Memo1.Lines.Add('COMMENT  : ' + vStr);
  end;

  Memo1.Lines.Add('');

  Memo1.Lines.Add('------------------------------------------------------------------');
  Memo1.Lines.Add(#13#10'Read Header. Enumeration of the lines (as String):'#13#10);

  Count := Fit.LineBuilder.Count; // number of significant lines of header, including END
  Memo1.Lines.Add('Count lines in the header = ' +  IntToStr(Count));
  for I := 0 to Count - 1 do
  begin
    Item := Fit.LineBuilder.Items[I, cCastString]; // line ~ <keyword-separator-value-separator-note>
    vStr := Format('%.2d %-8s %-25s %s', [I, Item.Keyword, Item.Value.Str, Item.Note]);
    Memo1.Lines.Add(vStr);
  end;

  Memo1.Lines.Add('');

  // Edit

  Memo1.Lines.Add('------------------------------------------------------------------');
  Memo1.Lines.Add(#13#10'Edit Header. Value:'#13#10);

  Index := Fit.LineBuilder.IndexOf('OBSERVER');
  if Index <> -1 then
  begin
    vStr := 'demo-observer';
    Fit.LineBuilder.ValuesString[Index] := vStr;
    Memo1.Lines.Add('Editing: Value of OBSERVER');
  end;

  Index := Fit.LineBuilder.IndexOf('DATE-OBS');
  if Index <> -1 then
  begin
    vDateTime := Now;
    Fit.LineBuilder.ValuesDateTime[Index] := vDateTime;
    Fit.LineBuilder.Notes[Index]          := 'Date and time of launch of Demo';
    Memo1.Lines.Add('Editing: Value and Note of DATE-OBS');
  end;

  Index := Fit.LineBuilder.IndexOf('EXPOSURE');
  if Index <> -1 then
  begin
    vFloat := 0.123;
    Fit.LineBuilder.ValuesFloat[Index] := vFloat;
    Memo1.Lines.Add('Editing: Value of EXPOSURE');
  end;

  Item := ToLineItem('SOMEKEY1', True, 0.123, True, 'This my Float-value');
  Index := Fit.LineBuilder.IndexOf('EXPOSURE');
  Fit.LineBuilder.Fmt^.vaFloat.wFmt := '%e';           // set format of text represenation
  Fit.LineBuilder.Insert(Index + 1, Item, cCastFloat); // insert new line as Float
  Memo1.Lines.Add('Inserting: [SOMEKEY1, 0.123, This my Float-value]');

  Index := Fit.LineBuilder.IndexOf('RA');
  if Index <> -1 then
  begin
    vFloat := 180.000;                         // in degree, Ra [000 .. 360]
    Fit.LineBuilder.ValuesRa[Index] := vFloat; // default format of write in hour (hex), Ra [00h .. 24h], hh:mm:ss.ss, see Fit.LineBuilder.Fmt^.vaCoord...
    Memo1.Lines.Add('Editing: Value of RA');
  end;

  Index := Fit.LineBuilder.IndexOf('DEC');
  if Index <> -1 then
  begin
    vFloat := 45.000;                          // in degree, De [-90 .. +90]
    Fit.LineBuilder.ValuesDe[Index] := vFloat; // default format of write in degree (hex), De [-90 .. +90], dd:mm:ss.s, see Fit.LineBuilder.Fmt^.vaCoord...
    Memo1.Lines.Add('Editing: Value of DEC');
  end;

  Index := Fit.LineBuilder.IndexOf('XBINNING');
  if Index <> -1 then
  begin
    Fit.LineBuilder.Keywords[Index]      := 'SOMEKEY2';
    Fit.LineBuilder.ValuesInteger[Index] := 100;
    Fit.LineBuilder.Notes[Index]         := 'This my Integer-value';
    Memo1.Lines.Add('Editing: Value of XBINNING');
  end;

  Index := Fit.LineBuilder.IndexOf('COMMENT');
  if Index <> -1 then
  begin
    Fit.LineBuilder.Delete(Index, True); // remove all lines with comment-keyword (after index)
    Memo1.Lines.Add('Removing: COMMENT');
  end;

  Item := ToLineItem('COMMENT', False, '', False, '');
  Item.Value.Str := 'Astronomy is one of the few sciences where amateurs can still play an active role, especially in the discovery and observation of transient phenomena';
  Fit.LineBuilder.Add(Item, cCastCharsLong); // add new line as Chars-long
  Memo1.Lines.Add('Adding: COMMENT');

  Memo1.Lines.Add('');

  Fit.Free;

  // out

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Ok! Header Processing is successfully complete'#13#10 + FitName);

  Memo1.Lines.Add('');
  Memo1.Lines.Add('Press Escape to close program');

end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.

