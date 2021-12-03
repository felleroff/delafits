{ **************************************************** }
{                DeLaFits. Demo Program                }
{                                                      }
{  Make new FITS file: standard ASCII-TABLE extension  }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit umain;

interface

uses
  SysUtils, Classes, DeLaFitsCommon, DeLaFitsClasses, DeLaFitsAscTable;

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

// Returns the full name of new FITS file

function GetNewFileName: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'demo-makeasctable.fits';
  if FileExists(Result) then
    DeleteFile(Result);
end;

// Add the copyright of the demo project to the header

procedure AddCopyright(AHead: TFitsAscTableHead; const AText: string);
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

  Spec: TFitsAscTableSpec;
  C1, C2, C3, C4, C5: TAscColumn;

  Table: TFitsAscTable;
  Head: TFitsAscTableHead;
  Data: TFitsAscTableData;

  A1: array of string;
  A2: array of Boolean;
  A3: array of SmallInt;
  A4: array of Word;
  A5: array of Single;

  I, N: Integer;
begin

  Stream    := nil;
  Container := nil;
  Spec      := nil;

  A1 := nil;
  A2 := nil;
  A3 := nil;
  A4 := nil;
  A5 := nil;

  try

    // Create Stream and Container

    Stream := TFileStream.Create(ANewFileName, fmCreate);

    Container := TFitsContainer.Create(Stream);

    // Add a simple Primary HDU as the ASCII-TABLE extension cannot be primary

    Container.Add(TFitsUmit, nil);

    // Prepare the specification of standard ASCII-TABLE extension: 5 x 10

    C1 := AscColumnCreateString(1,     10, 'MYCOL1');
    C2 := AscColumnCreateString(1,      1, 'MYCOL2'); // ~ boolean
    C3 := AscColumnCreateNumber(1, rep16c, 'MYCOL3');
    C4 := AscColumnCreateNumber(1, rep16u, 'MYCOL4');
    C5 := AscColumnCreateNumber(1, rep32f, 'MYCOL5');

    Spec := TFitsAscTableSpec.Create([C1, C2, C3, C4, C5], 10);

    // Add new ASCII-TABLE extension

    Table := Container.Add(TFitsAscTable, Spec) as TFitsAscTable;

    // Edit ASCII-TABLE Head

    Head := Table.Head;

    AddCopyright(Head, 'Make a new FITS file with standard ASCII-TABLE extension');

    // Edit ASCII-TABLE Data

    Data := Table.Data;

    N := Data.RowCount;

    SetLength(A1, N);
    for I := 0 to N - 1 do
      A1[I] := Format('TEXT%d', [I]);
    Data.WriteCells(0, 0, N, TAstr(A1));

    SetLength(A2, N);
    for I := 0 to N - 1 do
      A2[I] := I mod 2 = 0;
    Data.WriteCells(1, 0, N, TAbol(A2));

    SetLength(A3, N);
    for I := 0 to N - 1 do
      A3[I] := I;
    Data.WriteCells(2, 0, N, TA16c(A3));

    SetLength(A4, N);
    for I := 0 to N - 1 do
      A4[I] := I;
    Data.WriteCells(3, 0, N, TA16u(A4));

    SetLength(A5, N);
    for I := 0 to N - 1 do
      A5[I] := I;
    Data.WriteCells(4, 0, N, TA32f(A5));

  finally

    A1 := nil;
    A2 := nil;
    A3 := nil;
    A4 := nil;
    A5 := nil;

    Spec.Free;

    Container.Free;

    Stream.Free;

  end;

end;

procedure Main();
var
  NewFileName: string;
begin

  Log('DeLaFits. Demo Program. Make new FITS file: standard ASCII-TABLE extension');
  Log('');

  NewFileName := GetNewFileName();

  Make(NewFileName);

  Log('');
  Log('New FITS file make successfully, see "%s" file', [NewFileName]);

end;

end.
