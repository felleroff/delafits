{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{       Parse of the Official Individual Samples       }
{                    of FITS files                     }
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
  SysUtils, Classes, DeLaFitsCommon, DeLaFitsString, DeLaFitsClasses;

type
  TByteDynArray = array of Byte;

  TIntegerDynArray = array of Integer;

  TItemInfo = record
    Extension: string;
    Offset: Int64;
    Size: Int64;
    BITPIX: TBitPix;
    NAXES: TIntegerDynArray;
    PCOUNT: Integer;
    GCOUNT: Integer;
    // Head
    HeadOffset: Int64;
    HeadSize: Int64;
    HeadInternalSize: Int64;
    HeadLineCount: Integer;
    HeadLineCapacity: Integer;
    HeadCardCount: Integer;
    HeadKeywords: TKeywordDynArray;
    // Data
    DataOffset: Int64;
    DataSize: Int64;
    DataInternalSize: Int64;
    DataChunk: TByteDynArray;
  end;

  TItemInfoDynArray = array of TItemInfo;

  TContainerInfo = record
    FileIndex: Integer;
    FileName: string;
    ContentSize: Int64;
    ItemCount: Integer;
    ItemsInfo: TItemInfoDynArray;
  end;

procedure Print(const AText: string); overload;
begin
  Writeln(AText);
end;

procedure Print(const AText: string; const AArgs: array of const); overload;
begin
  Writeln(Format(AText, AArgs));
end;

procedure Print(const AContainerInfo: TContainerInfo); overload;
var
  LFileName, LCaption, LValue, LKeyword: string;
  LItemIndex, LIndex: Integer;
  LItemInfo: TItemInfo;
begin
  Print(StringOfChar('-', 100));
  // Print info about container file
  LFileName := ExtractRelativePath(ExtractFilePath(ParamStr(0)), ExtractFilePath(AContainerInfo.FileName));
  LFileName := StringReplace(LFileName, '\', '/', [rfReplaceAll]);
  LFileName := LFileName + ExtractFileName(AContainerInfo.FileName);
  Print('%d. FITS-container "%s" of %d bytes contains %d HDUs', [AContainerInfo.FileIndex,
    LFileName, AContainerInfo.ContentSize, AContainerInfo.ItemCount]);
  Print(StringOfChar('-', 100));
  // Print info about each container HDU
  for LItemIndex := 0 to AContainerInfo.ItemCount - 1 do
  begin
    LItemInfo := AContainerInfo.ItemsInfo[LItemIndex];
    // XTENSION: real extension type name
    LCaption := Format('HDU[%d]', [LItemIndex]);
    LValue := LItemInfo.Extension;
    if LItemIndex = 0 then
      LValue := LValue + ' (PRIMARY)';
    Print('%-18s %s', [LCaption, LValue]);
    // Print HDU offset and size
    Print('%-18s %d', ['Offset', LItemInfo.Offset]);
    Print('%-18s %d', ['Size', LItemInfo.Size]);
    // BITPIX
    Print('%-18s %s', ['BITPIX', BitPixToString(LItemInfo.BITPIX)]);
    // Print NAXISn: HDU data dimension
    LValue := '';
    for LIndex := Low(LItemInfo.NAXES) to High(LItemInfo.NAXES) do
      LValue := LValue + 'x' + IntToStr(LItemInfo.NAXES[LIndex]);
    if Length(LValue) > 0 then
      Delete(LValue, 1, 1);
    Print('%-18s [%s]', ['NAXES', LValue]);
    Print('%-18s %d', ['PCOUNT', LItemInfo.PCOUNT]);
    Print('%-18s %d', ['GCOUNT', LItemInfo.GCOUNT]);
    // Print the offset and size of HDU header
    Print('%-18s %d', ['Head Offset', LItemInfo.HeadOffset]);
    Print('%-18s %d', ['Head Size', LItemInfo.HeadSize]);
    Print('%-18s %d', ['Head Internal Size', LItemInfo.HeadInternalSize]);
    Print('%-18s %d', ['Head Line Count', LItemInfo.HeadLineCount]);
    Print('%-18s %d', ['Head Line Capacity', LItemInfo.HeadLineCapacity]);
    Print('%-18s %d', ['Head Card Count', LItemInfo.HeadCardCount]);
    // Print the first and last 5 keywords of HDU header
    LValue := '';
    if LItemInfo.HeadCardCount > 10 then
    begin
      for LIndex := 0 to 4 do
      begin
        LKeyword := LItemInfo.HeadKeywords[LIndex];
        if LKeyword = '' then
          LKeyword := '(EMPTY)';
        LValue := LValue + ',' + LKeyword;
      end;
      Delete(LValue, 1, 1);
      LValue := LValue + ' ... ';
      for LIndex := LItemInfo.HeadCardCount - 5 to LItemInfo.HeadCardCount - 1 do
      begin
        LKeyword := LItemInfo.HeadKeywords[LIndex];
        if LKeyword = '' then
          LKeyword := '(EMPTY)';
        LValue := LValue + LKeyword + ',';
      end;
      Delete(LValue, Length(LValue), 1);
    end else
    begin
      for LIndex := 0 to LItemInfo.HeadCardCount - 1 do
      begin
        LKeyword := LItemInfo.HeadKeywords[LIndex];
        if LKeyword = '' then
          LKeyword := '(EMPTY)';
        LValue := LValue + ',' + LKeyword;
      end;
      if Length(LValue) > 0 then
        Delete(LValue, 1, 1);
    end;
    Print('%-18s [%s]', ['Head Keywords', LValue]);
    // Print the offset and size of HDU data
    Print('%-18s %d', ['Data Offset', LItemInfo.DataOffset]);
    Print('%-18s %d', ['Data Size', LItemInfo.DataSize]);
    Print('%-18s %d', ['Data Internal Size', LItemInfo.DataInternalSize]);
    // Print the first and last 5 bytes of HDU data
    LValue := '';
    for LIndex := Low(LItemInfo.DataChunk) to High(LItemInfo.DataChunk) do
      LValue := LValue + ' ' + IntToHex(LItemInfo.DataChunk[LIndex], 2);
    Delete(LValue, 1, 1);
    if LItemInfo.DataInternalSize > 10 then
      Insert(' ...', LValue, 15);
    Print('%-18s [%s]', ['Data Chunk', LValue]);
    Print('');
  end;
end;

procedure Main;
var
  LFileIndex, LItemIndex, LNumber: Integer;
  LFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LItem: TFitsItem;
  LHead: TFitsItemHead;
  LData: TFitsItemData;
  LContainerInfo: TContainerInfo;
  LItemInfo: TItemInfo;
begin
  Print('DeLaFits Demo "Parse of the Official Individual Samples of FITS files"');
  Print('');
  LStream := nil;
  LContainer := nil;
  for LFileIndex := 1 to 11 do
  try
    // Get FITS file name
    case LFileIndex of
      01: LFileName := '01-HST WFPC II.fits';
      02: LFileName := '02-HST WFPC II.fits';
      03: LFileName := '03-HST FOC.fits';
      04: LFileName := '04-HST FOS.fits';
      05: LFileName := '05-HST HRS.fits';
      06: LFileName := '06-HST NICMOS.fits';
      07: LFileName := '07-HST FGS.fits';
      08: LFileName := '08-ASTRO-UIT.fits';
      09: LFileName := '09-IUE LWP.fits';
      10: LFileName := '10-EUVE.fits';
      11: LFileName := '11-RANDOM-GROUPS.fits';
    else
      LFileName := '';
    end;
    LFileName := ExtractFilePath(ParamStr(0)) + '../../data/' + LFileName;
    LFileName := ExpandFileName(LFileName);
    // Create the stream of FITS file and the FITS container
    LStream := TFileStream.Create(LFileName, fmOpenRead);
    LContainer := TFitsContainer.Create(LStream);
    // Put a container info
    LContainerInfo.FileIndex := LFileIndex;
    LContainerInfo.FileName := LFileName;
    LContainerInfo.ContentSize := LContainer.Content.Size;
    LContainerInfo.ItemCount := LContainer.Count;
    LContainerInfo.ItemsInfo := nil;
    SetLength(LContainerInfo.ItemsInfo, LContainer.Count);
    // Iterate over HDUs in the FITS container
    for LItemIndex := 0 to LContainer.Count - 1 do
    begin
      LItem := LContainer.Items[LItemIndex];
      LHead := LItem.Head;
      LData := LItem.Data;
      // Get the HDU info
      LItemInfo.Extension := LItem.GetXTENSION;
      LItemInfo.Offset := LItem.Offset;
      LItemInfo.Size := LItem.Size;
      LItemInfo.BITPIX := LItem.GetBITPIX;
      LItemInfo.NAXES := nil;
      SetLength(LItemInfo.NAXES, LItem.GetNAXIS);
      for LNumber := 1 to LItem.GetNAXIS do
        LItemInfo.NAXES[LNumber - 1] := LItem.GetNAXES(LNumber);
      LItemInfo.PCOUNT := LItem.GetPCOUNT;
      LItemInfo.GCOUNT := LItem.GetGCOUNT;
      // Get info about the HDU header
      LItemInfo.HeadOffset := LHead.Offset;
      LItemInfo.HeadSize := LHead.Size;
      LItemInfo.HeadInternalSize := LHead.InternalSize;
      LItemInfo.HeadLineCount := LHead.LineCount;
      LItemInfo.HeadLineCapacity := LHead.LineCapacity;
      LItemInfo.HeadCardCount := 0;
      if LHead.FirstCard then
        repeat
          Inc(LItemInfo.HeadCardCount);
        until not LHead.NextCard;
      LItemInfo.HeadKeywords := LHead.ExtractCardKeywords;
      // Get info about the HDU data
      LItemInfo.DataOffset := LData.Offset;
      LItemInfo.DataSize := LData.Size;
      LItemInfo.DataInternalSize := LData.InternalSize;
      LItemInfo.DataChunk := nil;
      if LData.InternalSize > 10 then
      begin
        SetLength(LItemInfo.DataChunk, 10);
        LData.ReadChunk({AInternalOffset:} 0, {ASize:} 5, LItemInfo.DataChunk[0]);
        LData.ReadChunk(LData.InternalSize - 5, {ASize:} 5, LItemInfo.DataChunk[5]);
      end else
      if LData.InternalSize > 0 then
      begin
        SetLength(LItemInfo.DataChunk, LData.InternalSize);
        LData.ReadChunk({AInternalOffset:} 0, LData.InternalSize, LItemInfo.DataChunk[0]);
      end;
      // Put the HDU info
      LContainerInfo.ItemsInfo[LItemIndex] := LItemInfo;
    end;
    // Print the container info
    Print(LContainerInfo);
  finally
    LContainer.Free;
    LStream.Free;
  end;
  Print('DeLaFits Demo successfully completed');
end;

end.
