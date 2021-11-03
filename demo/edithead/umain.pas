{ **************************************************** }
{                DeLaFits. Demo Program                }
{                                                      }
{   Reading and editing the Header of the FITS file    }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit umain;

interface

uses
  SysUtils, Classes, DeLaFitsCommon, DeLaFitsClasses;

  // Entry Point

  procedure Main;

implementation

type

  EDemo = class(Exception);

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

// Copy demo FITS file from "data" directory to project directory
// Returns the full name of the prepared FITS file

function Prepare: string;
const
  cName = 'demo-simple.fits';
var
  FileName: string;
  Source, Destination: TFileStream;
begin

  Source := nil;
  Destination := nil;

  try

    FileName := ExpandFileName(ExtractFilePath(ParamStr(0)) + '../../data/' + cName);
    Source := TFileStream.Create(FileName, fmOpenRead);
    Source.Position := 0;

    FileName := ExtractFilePath(ParamStr(0)) + cName;
    Destination := TFileStream.Create(FileName, fmCreate);
    Destination.Position := 0;

    if Destination.CopyFrom(Source, Source.Size) <> Source.Size then
      raise EFilerError.CreateFmt('Error copying "%s" to the demo project directory', [cName]);

    Result := Destination.FileName;

    Log('File "%s" copied to the project directory', [cName]);

  finally

    if Assigned(Source) then
      Source.Free;
    if Assigned(Destination) then
      Destination.Free;

  end;
end;

// Reading all useful header lines (without a parsing)

procedure ReadLines(AHead: TFitsItemHead);
var
  I: Integer;
  Line: string;
begin

  Log(System.StringOfChar('-', 89));
  Log('| %2s | %-80s |', ['#', 'Line']);
  Log(System.StringOfChar('-', 89));

  for I := 0 to AHead.Count - 1 do
  begin
    Line := AHead.Lines[I];
    Log('| %2d | %s |', [I, Line]);
  end;

  Log(System.StringOfChar('-', 89));

end;

// Reading all useful header cards (lines parsing as string)

procedure ReadCards(AHead: TFitsItemHead);
var
  I: Integer;
  Card: TCard;
begin

  Log(System.StringOfChar('-', 89));
  Log('| %2s | %-8s | %33s | %-33s |', ['#', 'Keyword', 'Value', 'Note']);
  Log(System.StringOfChar('-', 89));

  for I := 0 to AHead.Count - 1 do
  begin

    Card := AHead.Cards[I, cCastString];

    // Truncate long string value

    if Length(Card.Value.Str) > 30 then
      Card.Value.Str := Copy(Card.Value.Str, 1, 30) + '...';

    // Truncate long string note

    if Length(Card.Note) > 30 then
      Card.Note := Copy(Card.Note, 1, 30) + '...';

    Log('| %2d | %-8s | %33s | %-33s |', [I, Card.Keyword, Card.Value.Str, Card.Note]);

  end;

  Log(System.StringOfChar('-', 89));

end;

// Reading header values

procedure ReadValues(AHead: TFitsItemHead);
var
  Key: string;
  Index: Integer;
  Bol: Boolean;
  Str: string;
  Int: Int64;
  Ext: Extended;
  Dtm: TDateTime;
begin

  // Read Boolean Value

  Key := 'SIMPLE';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  Bol := AHead.ValuesBoolean[Index];
  Log('%8s: %-9s = %s', [Key, 'Boolean', BoolToStr(Bol, True)]);

  // Read Integer Value

  Key := 'BITPIX';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  Int := AHead.ValuesInteger[Index];
  Log('%8s: %-9s = %d', [Key, 'Integer', Int]);

  // Read Float Value

  Key := 'EXPOSURE';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  Ext := AHead.ValuesFloat[Index];
  Log('%8s: %-9s = %e', [Key, 'Extended', Ext]);

  // Read R.A. Value, "hh:mm:ss.s" -> "ddd.(d)"

  Key := 'RA';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  Ext := AHead.ValuesRa[Index];
  Log('%8s: %-9s = %.6f', [Key, 'Extended', Ext]);

  // Read Dec. Value, "gg:mm:ss.s" -> "dd.(d)"

  Key := 'DEC';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  Ext := AHead.ValuesDe[Index];
  Log('%8s: %-9s = %.6f', [Key, 'Extended', Ext]);

  // Read TDateTime Value

  Key := 'DATE-OBS';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  Dtm := AHead.ValuesDateTime[Index];
  Log('%8s: %-9s = %s', [Key, 'TDateTime', FormatDateTime('YYYY-MM-DD hh:mm:ss.zzz', Dtm)]);

  // Read String Value

  Key := 'OBSERVER';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  Str := AHead.ValuesString[Index];
  Log('%8s: %-9s = %s', [Key, 'String', Str]);

  // Read Text Value, long string value spread over multiple lines

  Key := 'COMMENT';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  Str := AHead.Cards[Index, cCastText].Value.Str;
  Log('%8s: %-9s = %s', [Key, 'String', Trim(Str)]);

end;

// Rewrite header values

procedure RewriteValues(AHead: TFitsItemHead);
var
  Key: string;
  Index: Integer;
  Card: TCard;
  Str: string;
  Ext: Extended;
  Dtm: TDateTime;
begin

  // Rewrite R.A. Value, "ddd.(d)" -> "hh:mm:ss.s"

  Key := 'RA';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  AHead.ValuesRa[Index] := 100.0;
  Ext := AHead.ValuesRa[Index];
  Log('%8s: %-9s = %.6f', [Key, 'Extended', Ext]);

  // Rewrite Dec. Value, "dd.(d)" -> "gg:mm:ss.s"

  Key := 'DEC';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  AHead.ValuesDe[Index] := 45.0;
  Ext := AHead.ValuesDe[Index];
  Log('%8s: %-9s = %.6f', [Key, 'Extended', Ext]);

  // Rewrite TDateTime Value

  Key := 'DATE-OBS';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  AHead.ValuesDateTime[Index] := Now;
  Dtm := AHead.ValuesDateTime[Index];
  Log('%8s: %-9s = %s', [Key, 'TDateTime', FormatDateTime('YYYY-MM-DD hh:mm:ss.zzz', Dtm)]);

  // Rewrite String Value

  Key := 'OBSERVER';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  AHead.ValuesString[Index] := 'mr. Demo Project';
  Str := AHead.ValuesString[Index];
  Log('%8s: %-9s = %s', [Key, 'String', Str]);

  // Rewrite Text Value, long string value spread over multiple lines

  Key := 'COMMENT';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  Card := ToCard(Key, False, 'It has been said that astronomy is a humbling and character-building experience (c) Carl Sagan', False, '');
  AHead.Cards[Index, cCastText] := Card;
  Str := AHead.Cards[Index, cCastText].Value.Str;
  Log('%8s: %-9s = %s', [Key, 'String', Trim(Str)]);

end;

// Add new header cards

procedure AddCards(AHead: TFitsItemHead);
var
  Key: string;
  Index: Integer;
  Str: string;
  Ext: Extended;
  Dtm: TDateTime;
begin

  // Add Float Value

  Key := 'FLOAT1';
  Index := AHead.AddFloat(Key, 1.0, 'Demo Float');
  Ext := AHead.ValuesFloat[Index];
  Log('%8s: %-9s = %g', [Key, 'Extended', Ext]);

  // Add Float Value, scientific format

  Key := 'FLOAT2';
  AHead.FormatLine^.vaFloat.wFmt := '%e';
  Index := AHead.AddFloat(Key, 1.0, 'Demo Float, scientific format');
  Ext := AHead.ValuesFloat[Index];
  Log('%8s: %-9s = %e', [Key, 'Extended', Ext]);

  // Add R.A. Card, "ddd.(d)" -> "hh:mm:ss.s"

  Key := 'RA1';
  Index := AHead.AddRa(Key, 180.0, 'Demo R.A.');
  Ext := AHead.ValuesRa[Index];
  Log('%8s: %-9s = %.6f', [Key, 'Extended', Ext]);

  // Add Dec. Card, "dd.(d)" -> "gg:mm:ss.s"

  Key := 'DEC1';
  Index := AHead.AddDe(Key, 10.0, 'Demo Dec.');
  Ext := AHead.ValuesDe[Index];
  Log('%8s: %-9s = %.6f', [Key, 'Extended', Ext]);

  // Add R.A. Card, "ddd.(d)" -> "ddd.(d)"

  Key := 'RA2';
  AHead.FormatLine^.vaCoord.wFmtRepCoord := coWhole;
  AHead.FormatLine^.vaCoord.wFmtMeaRa := coDegree;
  Index := AHead.AddRa(Key, 180.0, 'Demo R.A., float-point degrees');
  Ext := AHead.ValuesRa[Index];
  Log('%8s: %-9s = %.6f', [Key, 'Extended', Ext]);

  // Add Dec. Card, "dd.(d)" -> "dd.(d)"

  Key := 'DEC2';
  AHead.FormatLine^.vaCoord.wFmtRepCoord := coWhole;
  Index := AHead.AddDe(Key, 10.0, 'Demo Dec., float-point degrees');
  Ext := AHead.ValuesDe[Index];
  Log('%8s: %-9s = %.6f', [Key, 'Extended', Ext]);

  // Reset the formatting options of the header lines by default

  AHead.FormatLine^ := DeLaFitsCommon.FormatLineDefault();

  // Add TDateTime Value

  Key := 'DATE-DEM';
  Index := AHead.AddDateTime(Key, Now, 'Demo project start time');
  Dtm := AHead.ValuesDateTime[Index];
  Log('%8s: %-9s = %s', [Key, 'TDateTime', FormatDateTime('YYYY-MM-DD hh:mm:ss.zzz', Dtm)]);

  // Add String Value

  Key := 'INSTRUME';
  Index := AHead.AddString(Key, 'My PC', 'Demo name of instrument');
  Str := AHead.ValuesString[Index];
  Log('%8s: %-9s = %s', [Key, 'String', Str]);

  // Add History Value, long string value spread over multiple lines

  Key := 'COMMENT';
  Index := AHead.AddComment('Astronomy is one of the few sciences in which amateurs play an active role (c) Wiki');
  Str := AHead.Cards[Index, cCastText].Value.Str;
  Log('%8s: %-9s = %s', [Key, 'String', Trim(Str)]);

end;

// Remove header cards

procedure RemoveCards(AHead: TFitsItemHead);
var
  Key: string;
  Index: Integer;
begin

  // Delete one line

  Key := 'CREATOR';
  Index := AHead.IndexOf(Key);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [Key]);
  AHead.Delete(Index);
  Log('Removed one line with the keyword "%s"', [Key]);

  // Delete all lines with the "HISTORY" keyword

  Key := 'HISTORY';
  AHead.Delete([Key]);
  Log('Removed all lines with the "%s" keyword', [Key]);

end;

procedure Edit(const AFileName: string);
var
  Stream: TFileStream;
  Container: TFitsContainer;
  Head: TFitsItemHead;
begin

  Stream := nil;
  Container := nil;

  try

    // Open FITS file

    Stream := TFileStream.Create(AFileName, fmOpenReadWrite);
    Log('Open FITS file "%s"', [AFileName]);

    // Create the FITS container: parsing a FITS file

    Container := TFitsContainer.Create(Stream);
    if Container.Count <> 1 then
      raise EDemo.CreateFmt('There should be only one HDU in the "%s" file', [AFileName]);
    Log('Create the FITS container: Single HDU');

    // Get the Header of Primary HDU

    Head := Container.Primary.Head;

    // Demo

    Log(sLineBreak + 'Origin Lines');
    ReadLines(Head);
    
    Log(sLineBreak + 'Origin Cards');
    ReadCards(Head);

    Log(sLineBreak + '=>');

    Log(sLineBreak + 'Read Values');
    ReadValues(Head);

    Log(sLineBreak + 'Rewrite Values');
    RewriteValues(Head);

    Log(sLineBreak + 'Add Cards');
    AddCards(Head);

    Log(sLineBreak + 'Remove Cards');
    RemoveCards(Head);

    Log(sLineBreak + '=>');

    Log(sLineBreak + 'Edition Lines');
    ReadLines(Head);

    Log(sLineBreak + 'Edition Cards');
    ReadCards(Head);

  finally

    if Assigned(Container) then
      Container.Free;
    if Assigned(Stream) then
      Stream.Free;

  end;

end;


procedure Main();
var
  FileName: string;
begin

  Log('DeLaFits. Demo Program. Reading and editing the Header of the FITS file');
  Log('');

  FileName := Prepare();

  Edit(FileName);

  Log('');
  Log('Reading and editing completed successfully, see "%s" file', [FileName]);

end;

end.
