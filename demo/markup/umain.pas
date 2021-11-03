{ **************************************************** }
{                DeLaFits. Demo Program                }
{                                                      }
{      Markup of the Official Individual Samples       }
{                    of FITS files                     }
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

// Returns the path to the directory with samples FITS files

function GetDataPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
  Result := ExpandFileName(Result + '../../data/');
end;

// Returns the extension name of HDU

function GetItemName(AItem: TFitsItem): string;
begin

  Result := AItem.Name;

  // The FITS Standard (version 4.0), 6. "Random groups structure", page 16
  // ... NAXIS1 can be zero value, other NAXISn shall contain a non-negative integer ...

  if AItem.Index = 0 then
    if AItem.Naxis > 1 then
      if AItem.Naxes[1] = 0 then
        Result := 'RANDOM GROUP';

  // The first HDU is a Primary HDU

  if AItem.Index = 0 then
    Result := Result + ' (PRIMARY)';

end;

// Returns the dimension of Data Block

function GetItemNaxes(AItem: TFitsItem): string;
var
  I, V: Integer;
begin
  Result := '';
  for I := 1 to AItem.Naxis do
  begin
    V := AItem.Naxes[I];
    Result := Result + IntToStr(V) + 'x';
  end;
  Delete(Result, Length(Result), 1);
  Result := '[' + Result + ']';
end;

// Returns a chunk of Header Block: 5 first and last keywords (or all)

function GetItemHeadChunk(AHead: TFitsItemHead): string;
const
  ChunkCount = 5;
var
  I: Integer;
  Count: Integer;
begin

  Result := '';
  
  Count := AHead.Count; // total count of useful header lines

  if Count >= (ChunkCount * 2) then
  begin

    for I := 0 to ChunkCount - 1 do
      Result := Result + AHead.Keywords[I] + ',';
    Delete(Result, Length(Result), 1);

    Result := Result + ' ... ';

    for I := Count - ChunkCount to Count - 1 do
      Result := Result + AHead.Keywords[I] + ',';
    Delete(Result, Length(Result), 1);

  end

  else

  begin
    for I := 0 to Count - 1 do
      Result := Result + AHead.Keywords[I] + ',';
    Delete(Result, Length(Result), 1);
  end;

end;

// Returns a chunk of Data Block: 5 first and last bytes (or all)

function GetItemDataChunk(AData: TFitsItemData): string;
const
  ChunkSize = 5;
var
  I: Integer;
  Size: Int64;
  Buffer: array[0 .. ChunkSize - 1] of Byte;
begin

  {$IFDEF FPC} Buffer[0] := 0; {$ENDIF} // Supress Hint: Local variable "Buffer" does not seem to be initialized

  Result := '';
  
  Size := AData.Cize; // useful data size

  if Size >= (ChunkSize * 2) then
  begin

    AData.Read(0, ChunkSize, Buffer[0]);
    for I := Low(Buffer) to High(Buffer) do
      Result := Result + IntToHex(Buffer[I], 2) + ' ';
    Delete(Result, Length(Result), 1);

    Result := TrimLeft(Result) + ' ... ';

    AData.Read(Size - ChunkSize, ChunkSize, Buffer[0]);
    for I := Low(Buffer) to High(Buffer) do
      Result := Result + IntToHex(Buffer[I], 2) + ' ';
    Delete(Result, Length(Result), 1);

  end

  else

  begin
    AData.Read(0, Size, Buffer[0]);
    for I := Low(Buffer) to Size - 1 do
      Result := Result + IntToHex(Buffer[I], 2) + ' ';
    Delete(Result, Length(Result), 1);
  end;

end;

// Markup a FITS-file

procedure Markup(const AFileName: string);
var
  Stream: TFileStream;

  Container: TFitsContainer;
  Item: TFitsItem;
  Head: TFitsItemHead;
  Data: TFitsItemData;

  I, Count: Integer;
  Size: Int64;
  BitPix: Integer;
  Name, Naxes, Chunk: string;

begin

  Stream := nil;
  Container := nil;

  try

    // Open FITS file

    Stream := TFileStream.Create(AFileName, fmOpenRead);
    Log('Open FITS file "%s"', [AFileName]);

    // Create the FITS container: parsing a FITS file

    Container := TFitsContainer.Create(Stream);
    Size := Container.Content.Size;
    Count := Container.Count;
    Log('A FITS-container of %d bytes contains %d HDUs', [Size, Count]);

    // Iteration over HDUs

    for I := 0 to Count - 1 do
    begin

      Log('::');

      // HDU

      Item := Container.Items[I];

      Name := GetItemName(Item);
      Log('HDU[%d]       : %s', [Item.Index, Name]);

      Log('Offset       : %d',       [Item.Offset]);
      Log('Size         : %d bytes', [Item.Size]);

      BitPix := BitPixToInt(Item.BitPix);
      Log('BitPix       : %d', [BitPix]);

      Log('Gcount       : %d', [Item.Gcount]);
      Log('Pcount       : %d', [Item.Pcount]);

      Naxes := GetItemNaxes(Item);
      Log('Naxes        : %s dim', [Naxes]);

      // Header Block

      Head := Item.Head;

      Log('Head Offset  : %d',       [Head.Offset]);
      Log('Head Cize    : %d bytes', [Head.Cize]);
      Log('Head Size    : %d bytes', [Head.Size]);
      Log('Head Count   : %d lines', [Head.Count]);
      Log('Head Capacity: %d lines', [Head.Capacity]);

      Chunk := GetItemHeadChunk(Head);
      Log('Head Chunk   : %s', [Chunk]);

      // Data Block

      Data := Item.Data;

      Log('Data Offset  : %d',       [Data.Offset]);
      Log('Data Cize    : %d bytes', [Data.Cize]);
      Log('Data Size    : %d bytes', [Data.Size]);

      Chunk := GetItemDataChunk(Data);
      Log('Data Chunk   : %s', [Chunk]);

    end;

    Log('');

  finally

    if Assigned(Container) then
      Container.Free;

    if Assigned(Stream) then
      Stream.Free;

  end;

end;

procedure Main();

const
  Files: array [1 .. 11] of string = (
    '01-HST WFPC II.fits',
    '02-HST WFPC II.fits',
    '03-HST FOC.fits',
    '04-HST FOS.fits',
    '05-HST HRS.fits',
    '06-HST NICMOS.fits',
    '07-HST FGS.fits',
    '08-ASTRO-UIT.fits',
    '09-IUE LWP.fits',
    '10-EUVE.fits',
    '11-RANDOM-GROUPS.fits');

var
  I: Integer;
  FileName: string;

begin

  Log('DeLaFits. Demo Program. Markup of the Official Individual Samples of FITS files');
  Log('');

  for I := Low(Files) to High(Files) do
  begin
    FileName := GetDataPath + Files[I];   
    Markup(FileName);
  end;

  Log('');
  Log('Markup completed successfully');

end;

end.
