{ **************************************************** }
{                DeLaFits. Demo Program                }
{                                                      }
{ Reading and editing the Data Block of the FITS file  }
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

// Reading all Data Block as raw bytes

procedure ReadBytes(AData: TFitsItemData);
const
  Chunk = 10;
var
  Buffer: array[0 .. Chunk - 1] of Byte;
  Size, Offset: Int64;
  I, N: Integer;
  S: string;
begin

  {$IFDEF FPC} Buffer[0] := 0; {$ENDIF} // Supress Hint: Local variable "Buffer" does not seem to be initialized

  Log(System.StringOfChar('-', 33));

  Size := AData.Cize; // useful data size

  Offset := 0; // local offset

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

  Log(System.StringOfChar('-', 33));

end;

// Rewrite 10 bytes of data block

procedure RewriteBytes(AData: TFitsItemData);
const
  Chunk = 10;
  Offset = 10;
var
  Buffer: array[0 .. Chunk - 1] of Byte;
begin

  {$IFDEF FPC} Buffer[0] := 0; {$ENDIF} // Supress Hint: Local variable "Buffer" does not seem to be initialized

  if AData.Cize < (Offset + Chunk) then
    raise EDemo.Create('Invalid Data Block size');

  FillChar(Buffer[0], Chunk, $AA);

  AData.Write(Offset, Chunk, Buffer[0]);

end;

// Add a new 10 bytes of the data chunk

procedure AddBytes(AData: TFitsItemData);
const
  Chunk = 10;
var
  Head: TFitsItemHead;
  Buffer: array[0 .. Chunk - 1] of Byte;
  Index: Integer;
begin

  {$IFDEF FPC} Buffer[0] := 0; {$ENDIF} // Supress Hint: Local variable "Buffer" does not seem to be initialized

  if (AData.Size - AData.Cize) < Chunk then
    raise EDemo.Create('Invalid Data Block size');

  // Write a new data chunk

  FillChar(Buffer[0], Chunk, $BB);
  AData.Write(AData.Cize, Chunk, Buffer[0]);

  // Edit a size of the axis

  Head := AData.Item.Head;
  Index := Head.IndexOf(cNAXIS1);
  if Index < 0 then
    raise EDemo.CreateFmt('Keyword %s not found', [cNAXIS1]);
  Head.ValuesInteger[Index] := Head.ValuesInteger[Index] + Chunk;

end;

procedure Edit(const AFileName: string);
var
  Stream: TFileStream;
  Container: TFitsContainer;
  Data: TFitsItemData;
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

    // Get the Data Block of Primary HDU

    Data := Container.Primary.Data;

    // Demo

    Log(sLineBreak + 'Origin Data Block of size %d bytes', [Data.Cize]);
    ReadBytes(Data);

    Log(sLineBreak + '=>');

    Log(sLineBreak + 'Rewrite bytes 10 to 19 as $AA value');
    RewriteBytes(Data);

    Log(sLineBreak + 'Add a new 10 bytes as $BB value');
    AddBytes(Data);

    Log(sLineBreak + '=>');

    Log(sLineBreak + 'Edition Data Block of size %d bytes', [Data.Cize]);
    ReadBytes(Data);

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

  Log('DeLaFits. Demo Program. Reading and editing the Data Block of the FITS file');
  Log('');

  FileName := Prepare();

  Edit(FileName);

  Log('');
  Log('Reading and editing completed successfully, see "%s" file', [FileName]);

end;

end.
