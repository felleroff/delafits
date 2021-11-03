{ **************************************************** }
{                DeLaFits. Demo Program                }
{                                                      }
{        Make new FITS file: typeless HDU item         }
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

procedure Log(AHead: TFitsItemHead); overload;
var
  I: Integer;
  Card: TCard;
begin
  Log('Add %d Head Cards', [AHead.Count]);

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
  Log('');
end;

procedure Log(AData: TFitsItemData); overload;
var
  I, N, Chunk: Integer;
  S: string;
  Size, Offset: Int64;
  Buffer: array of Byte;
begin
  Log('Add %d bytes of Data Block', [AData.Cize]);

  Log(System.StringOfChar('-', 33));

  Buffer := nil;
  try
    Chunk := 10;
    SetLength(Buffer, Chunk);
    Size := AData.Cize; // useful data size
    Offset := 0;        // local offset
    while Size > 0 do
    begin
      if Size > Chunk then
        N := Chunk
      else
        N := Integer(Size);
      AData.Read(Offset, N, Buffer[0]);
      S := '| ';
      for I := 0 to N - 1 do
        S := S + IntToHex(Buffer[I], 2) + ' ';
      Log(S + '|');
      Offset := Offset + N;
      Size := Size - N;
    end;
  finally
    Buffer := nil;
  end;

  Log(System.StringOfChar('-', 33));
end;

// Returns the full name of new FITS file

function GetNewFileName: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'demo-makeitem.fits';
  if FileExists(Result) then
    DeleteFile(Result);
end;

// Add the copyright of the demo project to the header

procedure AddCopyright(AHead: TFitsItemHead; const AText: string);
var
  Comment: string;
begin
  Comment := Format('This file was created specifically to demonstrate the features of the DeLaFits library (c) %4d.', [CurrentYear]);
  Comment := Comment + ' ' + AText;
  AHead.AddComment(Comment);
end;

procedure Make(const ANewFileName: string);
var
  Stream: TFileStream;

  Container: TFitsContainer;
  Item: TFitsItem;
  Head: TFitsItemHead;
  Data: TFitsItemData;

  I: Integer;

  Size: Int64;
  Buffer: array of Byte;

begin

  Stream := nil;
  Container := nil;

  try

    Stream := TFileStream.Create(ANewFileName, fmCreate);
    Log('Create new FITS file "%s"', [ANewFileName]);
    Log('');

    Container := TFitsContainer.Create(Stream);
    Log('Create new FITS container');
    Log('');

    Item := Container.Add(TFitsItem, nil);
    Log('Add new HDU to FITS container');
    Log('');

    // Edit Item Head

    Head := Item.Head;

    // BITPIX default is 8

    // Set the number and length of axis 1

    I := Head.IndexOf('NAXIS');
    Head.ValuesInteger[I] := 1;
    Head.InsertInteger(I + 1,'NAXIS1', 100, 'Length of first axis');

    Head.AddString('OBSERVER', 'mr. D''artagnan', 'Observer name');

    Head.AddDateTime('DATE-OBS', Now, 'Date of the observation');

    Head.FormatLine^.vaFloat.wFmt := '%e'; // optional, set scientific format of the text representation
    Head.AddFloat('EXPOSURE', 1.0, 'Duration of exposure [sec]');

    Head.AddRa('RA', 180.0, 'Right ascension [hh:mm:ss.ss J2000]');

    Head.AddDe('DEC', -45.0, 'Declination [dd:mm:ss.s +N J2000]');

    AddCopyright(Head, 'Make a new FITS file as typeless HDU item');

    // Log: output the head cards

    Log(Head);

    // Edit Item Data

    Data := Item.Data;

    // Add a 100 byte chunk

    Buffer := nil;
    try

      // Prepare values

      Size := 100;
      SetLength(Buffer, Size);
      for I := Low(Buffer) to High(Buffer) do
        Buffer[I] := I;

      // Add a new chunk (resize a Stream)

      Data.Add(Size);

      // Write values

      Data.Write(0, Size, Buffer[0]);

    finally
      Buffer := nil;
    end;

    // Log: output the data block

    Log(Data);


  finally

    if Assigned(Container) then
      Container.Free;

    if Assigned(Stream) then
      Stream.Free;

  end;

end;


procedure Main();
var
  NewFileName: string;
begin

  Log('DeLaFits. Demo Program. Make new FITS file: typeless HDU item');
  Log('');

  NewFileName := GetNewFileName();

  Make(NewFileName);

  Log('');
  Log('New FITS file make successfully, see "%s" file', [NewFileName]);

end;

end.
