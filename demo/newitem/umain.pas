{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{     Create a new FITS file with the typeless HDU     }
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
  SysUtils, Classes, DeLaFitsCard, DeLaFitsClasses;

procedure Print(const AText: string); overload;
begin
  Writeln(AText);
end;

procedure Print(const AText: string; const Args: array of const); overload;
begin
  Writeln(Format(AText, Args));
end;

procedure UpdateHead(AHead: TFitsItemHead);
var
  LInteger: TFitsIntegerCard;
  LDateTime: TFitsDateTimeCard;
  LCoordinate: TFitsEquatorialCoordinateCard;
  LComment: TFitsGroupCard;
begin
  // The default data bit depth is 8 bits: BITPIX equal to "08"
  // Set the data axes size (dimension) to 10x20
  LInteger := TFitsIntegerCard.Create;
  try
    // Write NAXIS equal to 2 (default is 0)
    AHead.LocateCard('NAXIS');
    LInteger.Card := AHead.Card;
    LInteger.ValueAsInteger := 2;
    AHead.Card := LInteger.Card;
    // Add NAXIS2 value equal to 10
    LInteger.Keyword := 'NAXIS1';
    LInteger.ValueAsInteger := 10;
    LInteger.Note := 'Size of the axis 1';
    AHead.GotoCard(AHead.LineIndexOfLastAxis + 1);
    AHead.InsertCard(LInteger.Card);
    // Add NAXIS2 value equal to 20
    LInteger.Keyword := 'NAXIS2';
    LInteger.ValueAsInteger := 20;
    LInteger.Note := 'Size of the axis 2';
    AHead.GotoCard(AHead.LineIndexOfLastAxis + 1);
    AHead.InsertCard(LInteger.Card);
  finally
    LInteger.Free;
  end;
  // Set the date and time of observation
  LDateTime := TFitsDateTimeCard.Create;
  try
    LDateTime.Keyword := 'DATE_OBS';
    LDateTime.ValueAsDateTime := Now;
    LDateTime.Note := 'Date of the observation';
    AHead.AddCard(LDateTime.Card);
  finally
    LDateTime.Free;
  end;
  // Set the equatorial coordinates of object
  LCoordinate := TFitsRightAscensionCard.Create;
  try
    LCoordinate.Keyword := 'RA';
    LCoordinate.ValueAsDouble := 266.4168333;
    LCoordinate.Note := 'Right ascension [hh:mm:ss.ss J2000]';
    AHead.AddCard(LCoordinate.Card);
  finally
    LCoordinate.Free;
  end;
  LCoordinate := TFitsDeclinationCard.Create;
  try
    LCoordinate.Keyword := 'DEC';
    LCoordinate.ValueAsDouble := -29.0078056;
    LCoordinate.Note := 'Declination [dd:mm:ss.s +N J2000]';
    AHead.AddCard(LCoordinate.Card);
  finally
    LCoordinate.Free;
  end;
  // Add a comment
  LComment := TFitsGroupCard.Create;
  try
    LComment.Keyword := 'COMMENT';
    LComment.Value := 'Demo project "Create a new FITS file with the typeless HDU" (c) DeLaFits';
    AHead.AddCard(LComment.Card);
  finally
    LComment.Free;
  end;
  Print('# Update HDU header');
end;

procedure UpdateData(AData: TFitsItemData);
const
  cChunkCapacity = 10;
var
  LChunk: array [0 .. cChunkCapacity - 1] of Byte;
  LInternalOffset, LInternalSize, LChunkSize: Int64;
  LIndex: Byte;
begin
  // Set the size of meaningful bytes of the HDU data section
  AData.AddChunk(AData.InternalSize);
  // Prepare the chunk values
  for LIndex := 0 to cChunkCapacity - 1 do
    LChunk[LIndex] := LIndex;
  // Write values (byte stream) to the HDU data section
  LInternalOffset := 0;
  LInternalSize := AData.InternalSize;
  while LInternalOffset < LInternalSize do
  begin
    if LInternalSize > cChunkCapacity then
      LChunkSize := cChunkCapacity
    else
      LChunkSize := LInternalSize;
    AData.WriteChunk(LInternalOffset, LChunkSize, LChunk[0]);
    Inc(LInternalOffset, LChunkSize);
  end;
  Print('# Update HDU data section');
end;

procedure Main;
var
  LFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LItem: TFitsItem;
  LHead: TFitsItemHead;
  LData: TFitsItemData;
begin
  Print('DeLaFits Demo "Create a new FITS file with the typeless HDU"');
  Print('');
  LStream := nil;
  LContainer := nil;
  try
    LFileName := ExtractFilePath(ParamStr(0)) + 'output.fits';
    // Create a new stream of FITS file and an empty FITS container
    LStream := TFileStream.Create(LFileName, fmCreate);
    LContainer := TFitsContainer.Create(LStream);
    // Add new HDU
    LItem := LContainer.Add(TFitsItem, {AItemSpec:} nil);
    LHead := LItem.Head;
    LData := LItem.Data;
    // Update new HDU
    UpdateHead(LHead);
    UpdateData(LData);
  finally
    LContainer.Free;
    LStream.Free;
  end;
  Print('');
  Print('DeLaFits Demo successfully completed, see "%s" file', [ExtractFileName(LFileName)]);
end;

end.
