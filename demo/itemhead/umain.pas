{ **************************************************** }
{                    DeLaFits Demo                     }
{                                                      }
{            Read and write the HDU header             }
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
  SysUtils, Classes, DeLaFitsCommon, DeLaFitsString, DeLaFitsCard, DeLaFitsClasses;

procedure Print(const AText: string); overload;
begin
  Writeln(AText);
end;

procedure Print(const AText: string; const AArgs: array of const); overload;
begin
  Writeln(Format(AText, AArgs));
end;

function CopyFile(const ASourceFileName, ADestFileName: string): string;
var
  LRoot: string;
  LSource, LDest: TFileStream;
begin
  LSource := nil;
  LDest := nil;
  try
    LRoot := ExtractFilePath(ParamStr(0));
    LSource := TFileStream.Create(LRoot + ASourceFileName, fmOpenRead);
    LDest := TFileStream.Create(LRoot + ADestFileName, fmCreate);
    LSource.Position := 0;
    if LDest.CopyFrom(LSource, LSource.Size) <> LSource.Size then
      raise EFilerError.CreateFmt('Error copying file "%s" to "%s"',
        [ASourceFileName, ADestFileName]);
    Result := ExpandFileName(LDest.FileName);
  finally
    LSource.Free;
    LDest.Free;
  end;
end;

function TruncText(const AText: string; AMaxLength: Integer): string;
var
  L1, L2: Integer;
begin
  if Length(AText) > AMaxLength then
  begin
    L1 := AMaxLength div 2;
    L2 := AMaxLength - (AMaxLength div 2) - 3;
    Result := Copy(AText, 1, L1) + '...' + Copy(AText, Length(AText) - L2 + 1, L2);
  end else
    Result := AText;
end;

procedure ReadHeaderLines(AHead: TFitsItemHead);
var
  LIndex: Integer;
  LLines: array of string;
begin
  // Get header lines
  LLines := nil;
  SetLength(LLines, AHead.LineCount);
  for LIndex := 0 to AHead.LineCount - 1 do
    LLines[LIndex] := AHead.Lines[LIndex];
  // Print header lines
  Print('Read header lines');
  Print(StringOfChar('-', 85));
  Print(' # | Line');
  Print(StringOfChar('-', 85));
  for LIndex := Low(LLines) to High(LLines) do
    Print('%2d | %s', [LIndex, LLines[LIndex]]);
  Print('');
end;

procedure ReadHeaderCards(AHead: TFitsItemHead);
type
  TVariable = record
    CardType: TCardType;
    Keyword, Value, Note: string;
  end;
  TVariableDynArray = array of TVariable;
var
  LVariable: TVariable;
  LVariables: TVariableDynArray;

  procedure LogVariable(const AVariable: TVariable);
  begin
    SetLength(LVariables, Length(LVariables) + 1);
    LVariables[High(LVariables)] := AVariable;
  end;

var
  LCard: TFitsCard;
  LIndex: Integer;
  LCardType, LKeyword, LValue, LNote: string;
begin
  LVariables := nil;
  // Get header cards
  if AHead.FirstCard then
  repeat
    LVariable.CardType := AHead.CardType;
    case AHead.CardType of
      cardTypical:
        begin
          LCard := TFitsTypicalCard.Create;
          try
            LCard.Card := AHead.Card;
            LVariable.Keyword := LCard.Keyword;
            LVariable.Value := LCard.Value;
            LVariable.Note := (LCard as TFitsTypicalCard).Note;
          finally
            LCard.Free;
          end;
        end;
      cardContinued:
        begin
          LCard := TFitsStringCard.Create;
          try
            LCard.Card := AHead.Card;
            LVariable.Keyword := LCard.Keyword;
            LVariable.Value := LCard.Value;
            LVariable.Note := (LCard as TFitsStringCard).Note;
          finally
            LCard.Free;
          end;
        end;
      cardGrouped:
        begin
          LCard := TFitsGroupCard.Create;
          try
            LCard.Card := AHead.Card;
            LVariable.Keyword := LCard.Keyword;
            LVariable.Value := LCard.Value;
            LVariable.Note := '';
          finally
            LCard.Free;
          end;
        end;
    else { cardUnknown, cardEmpty: }
      LVariable.Keyword := '';
      LVariable.Value := '';
      LVariable.Note := '';
    end;
    LogVariable(LVariable);
  until not AHead.NextCard;
  // Print header cards
  Print('Read header cards');
  Print(StringOfChar('-', 85));
  Print(' %s | %-9s | %-8s | %28s | %s', ['#', 'Type', 'Keyword', 'Value: string', 'Note']);
  Print(StringOfChar('-', 85));
  for LIndex := Low(LVariables) to High(LVariables) do
  begin
    LVariable := LVariables[LIndex];
    case LVariable.CardType of
      cardUnknown:   LCardType := 'UNKNOWN';
      cardEmpty:     LCardType := 'EMPTY';
      cardTypical:   LCardType := 'TYPICAL';
      cardContinued: LCardType := 'CONTINUED';
      cardGrouped:   LCardType := 'GROUPED';
    else
      LCardType := '';
    end;
    LKeyword := IfThen(LVariable.Keyword = '', '(NONE)', LVariable.Keyword);
    LValue := LVariable.Value;
    case LVariable.CardType of
      cardTypical: if IsQuotedString(LValue) then LValue := UnquotedString(LValue);
      cardGrouped: LValue := Trim(LValue);
    end;
    LValue := TruncText(LValue, 28);
    LValue := IfThen(LValue = '', '(NONE)', LValue);
    LNote := TruncText(LVariable.Note, 26);
    LNote := IfThen(LNote = '', '(NONE)', LNote);
    Print('%2d | %-9s | %-8s | %28s | %s', [LIndex, LCardType, LKeyword, LValue, LNote]);
  end;
  Print('');
end;

procedure LocateHeaderCards(AHead: TFitsItemHead);
type
  TVariable = record
    Keyword, ValueType, Value: string;
  end;
  TVariableDynArray = array of TVariable;
var
  LVariable: TVariable;
  LVariables: TVariableDynArray;

  procedure LogVariable(const AVariable: TVariable);
  begin
    SetLength(LVariables, Length(LVariables) + 1);
    LVariables[High(LVariables)] := AVariable;
  end;

var
  LStringCard: TFitsStringCard;
  LIntegerCard: TFitsIntegerCard;
  LFloatCard: TFitsFloatCard;
  LCoordinateCard: TFitsEquatorialCoordinateCard;
  LDateTimeCard: TFitsDateTimeCard;
  LGroupCard: TFitsGroupCard;
  LIndex: Integer;
begin
  LVariables := nil;
  // OBSERVER
  if AHead.LocateCard('OBSERVER') then
  begin
    LStringCard := TFitsStringCard.Create;
    try
      LStringCard.Card := AHead.Card;
      LVariable.Keyword := LStringCard.Keyword;
      LVariable.ValueType := 'STRING';
      LVariable.Value := LStringCard.Value;
      LogVariable(LVariable);
    finally
      LStringCard.Free;
    end;
  end;
  // WEATHER
  if AHead.LocateCard('WEATHER') then
  begin
    LStringCard := TFitsStringCard.Create;
    try
      LStringCard.Card := AHead.Card;
      LVariable.Keyword := LStringCard.Keyword;
      LVariable.ValueType := 'STRING';
      LVariable.Value := TruncText(LStringCard.Value, 62);
      LogVariable(LVariable);
    finally
      LStringCard.Free;
    end;
  end;
  // SNAPSHOT
  if AHead.LocateCard('SNAPSHOT') then
  begin
    LIntegerCard := TFitsIntegerCard.Create;
    try
      LIntegerCard.Card := AHead.Card;
      LVariable.Keyword := LIntegerCard.Keyword;
      LVariable.ValueType := 'INTEGER';
      LVariable.Value := IntToStr(LIntegerCard.ValueAsInteger);
      LogVariable(LVariable);
    finally
      LIntegerCard.Free;
    end;
  end;
  // EXPOSURE
  if AHead.LocateCards(['EXPOSURE', 'EXPTIME', 'TELAPSE', 'ELAPTIME']) then
  begin
    LFloatCard := TFitsFloatCard.Create;
    try
      LFloatCard.Card := AHead.Card;
      LVariable.Keyword := LFloatCard.Keyword;
      LVariable.ValueType := 'DOUBLE';
      LVariable.Value := FloatToStrF(LFloatCard.ValueAsDouble, ffFixed, 8, 5);
      LogVariable(LVariable);
    finally
      LFloatCard.Free;
    end;
  end;
  // DATE-OBS
  if AHead.LocateCards(['DATE', 'DATE-OBS']) then
  begin
    LDateTimeCard := TFitsDateTimeCard.Create;
    try
      LDateTimeCard.Card := AHead.Card;
      LVariable.Keyword := LDateTimeCard.Keyword;
      LVariable.ValueType := 'TDATETIME';
      LVariable.Value := FormatDateTime('d mmm yyyy hh:nn:ss.z', LDateTimeCard.ValueAsDateTime);
      LogVariable(LVariable);
    finally
      LDateTimeCard.Free;
    end;
  end;
  // RA
  if AHead.LocateCards(['RA', 'RA_OBJ', 'RA_PNT']) then
  begin
    LCoordinateCard := TFitsRightAscensionCard.Create;
    try
      LCoordinateCard.Card := AHead.Card;
      LVariable.Keyword := LCoordinateCard.Keyword;
      LVariable.ValueType := 'DOUBLE';
      LVariable.Value :=  FloatToStrF(LCoordinateCard.ValueAsDouble, ffFixed, 8, 5);
      LogVariable(LVariable);
    finally
      LCoordinateCard.Free;
    end;
  end;
  // DEC
  if AHead.LocateCards(['DEC', 'DEC_OBJ', 'DEC_PNT']) then
  begin
    LCoordinateCard := TFitsDeclinationCard.Create;
    try
      LCoordinateCard.Card := AHead.Card;
      LVariable.Keyword := LCoordinateCard.Keyword;
      LVariable.ValueType := 'DOUBLE';
      LVariable.Value :=  FloatToStrF(LCoordinateCard.ValueAsDouble, ffFixed, 8, 5);
      LogVariable(LVariable);
    finally
      LCoordinateCard.Free;
    end;
  end;
  // COMMENT
  if AHead.LocateCard('COMMENT') then
  begin
    LGroupCard := TFitsGroupCard.Create;
    try
      LGroupCard.Card := AHead.Card;
      LVariable.Keyword := LGroupCard.Keyword;
      LVariable.ValueType := 'STRING';
      LVariable.Value := TruncText(Trim(LGroupCard.Value), 62);
      LogVariable(LVariable);
    finally
      LGroupCard.Free;
    end;
  end;
  // Print the typed values of the found header cards
  Print('Locate header card values');
  Print(StringOfChar('-', 85));
  Print('%-9s | %-8s | %s', ['Type', 'Keyword', 'Value: type']);
  Print(StringOfChar('-', 85));
  for LIndex := Low(LVariables) to High(LVariables) do
  begin
    LVariable := LVariables[LIndex];
    Print('%-9s | %-8s | %s', [LVariable.ValueType, LVariable.Keyword, LVariable.Value]);
  end;
  Print('');
end;

procedure WriteHeaderCards(AHead: TFitsItemHead);
type
  TVariable = string; // Card
  TVariableDynArray = array of TVariable;
var
  LVariable: TVariable;
  LVariables: TVariableDynArray;

  procedure LogVariable(const AVariable: TVariable);
  begin
    SetLength(LVariables, Length(LVariables) + 1);
    LVariables[High(LVariables)] := AVariable;
  end;

var
  LStringCard: TFitsStringCard;
  LIntegerCard: TFitsIntegerCard;
  LFloatCard: TFitsFloatCard;
  LDateTimeCard: TFitsDateTimeCard;
  LCoordinateCard: TFitsEquatorialCoordinateCard;
  LGroupCard: TFitsGroupCard;
  LIndex, LPosition: Integer;
  LMark, LLine: string;
begin
  LVariables := nil;
  // OBSERVER
  if AHead.LocateCard('OBSERVER') then
  begin
    LStringCard := TFitsStringCard.Create;
    try
      LStringCard.Card := AHead.Card;
      LStringCard.Value := 'Demo Observer';
      AHead.Card := LStringCard.Card;
      LogVariable(LStringCard.Card)
    finally
      LStringCard.Free;
    end;
  end;
  // WEATHER
  if AHead.LocateCard('WEATHER') then
  begin
    LStringCard := TFitsStringCard.Create;
    try
      LStringCard.Card := AHead.Card;
      LStringCard.Value := 'Clear in the evening and at night, air temperature around at Low -10C. Winds NE at 2 to 5 mph.';
      AHead.Card := LStringCard.Card;
      LogVariable(LStringCard.Card)
    finally
      LStringCard.Free;
    end;
  end;
  // SNAPSHOT
  if AHead.LocateCard('SNAPSHOT') then
  begin
    LIntegerCard := TFitsIntegerCard.Create;
    try
      LIntegerCard.Card := AHead.Card;
      LIntegerCard.ValueAsInteger := 999;
      AHead.Card := LIntegerCard.Card;
      LogVariable(LIntegerCard.Card)
    finally
      LIntegerCard.Free;
    end;
  end;
  // EXPOSURE
  if AHead.LocateCards(['EXPOSURE', 'EXPTIME', 'TELAPSE', 'ELAPTIME']) then
  begin
    LFloatCard := TFitsFloatCard.Create;
    try
      LFloatCard.Card := AHead.Card;
      LFloatCard.ValueAsDouble := 99.5;
      AHead.Card := LFloatCard.Card;
      LogVariable(LFloatCard.Card)
    finally
      LFloatCard.Free;
    end;
  end;
  // DATE-OBS
  if AHead.LocateCards(['DATE', 'DATE-OBS']) then
  begin
    LDateTimeCard := TFitsDateTimeCard.Create;
    try
      LDateTimeCard.Card := AHead.Card;
      LDateTimeCard.ValueAsDateTime := Now;
      AHead.Card := LDateTimeCard.Card;
      LogVariable(LDateTimeCard.Card)
    finally
      LDateTimeCard.Free;
    end;
  end;
  // RA
  if AHead.LocateCards(['RA', 'RA_OBJ', 'RA_PNT']) then
  begin
    LCoordinateCard := TFitsRightAscensionCard.Create;
    try
      LCoordinateCard.Card := AHead.Card;
      LCoordinateCard.ValueAsDouble := 266.4168333;
      AHead.Card := LCoordinateCard.Card;
      LogVariable(LCoordinateCard.Card)
    finally
      LCoordinateCard.Free;
    end;
  end;
  // DEC
  if AHead.LocateCards(['DEC', 'DEC_OBJ', 'DEC_PNT']) then
  begin
    LCoordinateCard := TFitsDeclinationCard.Create;
    try
      LCoordinateCard.Card := AHead.Card;
      LCoordinateCard.ValueAsDouble := -29.0078056;
      AHead.Card := LCoordinateCard.Card;
      LogVariable(LCoordinateCard.Card)
    finally
      LCoordinateCard.Free;
    end;
  end;
  // COMMENT
  if AHead.LocateCard('COMMENT') then
  begin
    LGroupCard := TFitsGroupCard.Create;
    try
      LGroupCard.Card := AHead.Card;
      LGroupCard.Value := 'It has been said that astronomy is a humbling and character-building experience (c) Carl Sagan';
      AHead.Card := LGroupCard.Card;
      LogVariable(LGroupCard.Card)
    finally
      LGroupCard.Free;
    end;
  end;
  // Print updated header cards
  Print('Write header cards');
  Print(StringOfChar('-', 85));
  Print(' # | Card lines');
  Print(StringOfChar('-', 85));
  for LIndex := Low(LVariables) to High(LVariables) do
  begin
    LVariable := LVariables[LIndex];
    LPosition := 1;
    while LPosition < Length(LVariable) do
    begin
      LMark := IfThen(LPosition = 1, '*', ' ');
      LLine := Copy(LVariable, LPosition, cSizeLine);
      Print('%2s | %s', [LMark, LLine]);
      Inc(LPosition, cSizeLine);
    end;
  end;
  Print('');
end;

procedure AppendHeaderCards(AHead: TFitsItemHead);
type
  TVariable = string; // Card
  TVariableDynArray = array of TVariable;
var
  LVariable: TVariable;
  LVariables: TVariableDynArray;

  procedure LogVariable(const AVariable: TVariable);
  begin
    SetLength(LVariables, Length(LVariables) + 1);
    LVariables[High(LVariables)] := AVariable;
  end;

var
  LStringCard: TFitsStringCard;
  LIntegerCard: TFitsIntegerCard;
  LFloatCard: TFitsFloatCard;
  LDateTimeCard: TFitsDateTimeCard;
  LCoordinateCard: TFitsEquatorialCoordinateCard;
  LGroupCard: TFitsGroupCard;
  LIndex, LPosition: Integer;
  LMark, LLine: string;
begin
  LVariables := nil;
  // STRING
  LStringCard := TFitsStringCard.Create;
  try
    LStringCard.Keyword := 'STRING';
    LStringCard.Value := 'Text';
    LStringCard.Note := 'Demo string value';
    AHead.AddCard(LStringCard.Card);
    LogVariable(LStringCard.Card);
  finally
    LStringCard.Free;
  end;
  // INTEGER
  LIntegerCard := TFitsIntegerCard.Create;
  try
    LIntegerCard.Keyword := 'INTEGER';
    LIntegerCard.ValueAsInteger := 123;
    LIntegerCard.Note := 'Demo integer value';
    AHead.AddCard(LIntegerCard.Card);
    LogVariable(LIntegerCard.Card);
  finally
    LIntegerCard.Free;
  end;
  // FLOAT
  LFloatCard := TFitsFloatCard.Create;
  try
    LFloatCard.Keyword := 'FLOAT';
    LFloatCard.ValueAsDouble := 123.0;
    LFloatCard.Note := 'Demo float value';
    AHead.AddCard(LFloatCard.Card);
    LogVariable(LFloatCard.Card);
  finally
    LFloatCard.Free;
  end;
  // DATETIME
  LDateTimeCard := TFitsDateTimeCard.Create;
  try
    LDateTimeCard.Keyword := 'DATETIME';
    LDateTimeCard.ValueAsDateTime := Now;
    LDateTimeCard.Note := 'Demo datetime value';
    AHead.AddCard(LDateTimeCard.Card);
    LogVariable(LDateTimeCard.Card);
  finally
    LDateTimeCard.Free;
  end;
  // RA_OBJ
  LCoordinateCard := TFitsRightAscensionCard.Create;
  try
    LCoordinateCard.Keyword := 'RA_OBJ';
    LCoordinateCard.ValueAsDouble := 123.4567;
    LCoordinateCard.Note := 'Demo RA value';
    AHead.AddCard(LCoordinateCard.Card);
    LogVariable(LCoordinateCard.Card);
  finally
    LCoordinateCard.Free;
  end;
  // DEC_OBJ
  LCoordinateCard := TFitsDeclinationCard.Create;
  try
    LCoordinateCard.Keyword := 'DEC_OBJ';
    LCoordinateCard.ValueAsDouble := 12.34567;
    LCoordinateCard.Note := 'Demo DEC value';
    AHead.AddCard(LCoordinateCard.Card);
    LogVariable(LCoordinateCard.Card);
  finally
    LCoordinateCard.Free;
  end;
  // HISTORY
  LGroupCard := TFitsGroupCard.Create;
  try
    LGroupCard.Keyword := 'HISTORY';
    LGroupCard.Value := 'This keyword should be used to describe the history of steps and procedures ' +
      'associated with the processing of the associated data (c) The FITS Standard, Version 4.0';
    AHead.AddCard(LGroupCard.Card);
    LogVariable(LGroupCard.Card);
  finally
    LGroupCard.Free;
  end;
  // Append empty card
  LStringCard := TFitsStringCard.Create;
  try
    AHead.AddCard(LStringCard.Card);
    LogVariable(LStringCard.Card);
  finally
    LStringCard.Free;
  end;
  // Print append header cards
  Print('Append header cards');
  Print(StringOfChar('-', 85));
  Print(' # | Card lines');
  Print(StringOfChar('-', 85));
  for LIndex := Low(LVariables) to High(LVariables) do
  begin
    LVariable := LVariables[LIndex];
    LPosition := 1;
    while LPosition < Length(LVariable) do
    begin
      LMark := IfThen(LPosition = 1, '*', ' ');
      LLine := Copy(LVariable, LPosition, cSizeLine);
      Print('%2s | %s', [LMark, LLine]);
      Inc(LPosition, cSizeLine);
    end;
  end;
  Print('');
end;

procedure DeleteHeaderCards(AHead: TFitsItemHead);
type
  TVariable = string; // Card
  TVariableDynArray = array of TVariable;
var
  LVariable: TVariable;
  LVariables: TVariableDynArray;

  procedure LogVariable(const AVariable: TVariable);
  begin
    SetLength(LVariables, Length(LVariables) + 1);
    LVariables[High(LVariables)] := AVariable;
  end;

var
  LIndex, LPosition: Integer;
  LMark, LLine: string;
begin
  LVariables := nil;
  // CREATOR
  if AHead.LocateCard('CREATOR') then
  begin
    LogVariable(AHead.Card);
    AHead.DeleteCard;
  end;
  // HISTORY
  if AHead.LocateCard('HISTORY') then
  begin
    LogVariable(AHead.Card);
    AHead.DeleteCard;
  end;
  // Print deleted header cards
  Print('Delete header cards');
  Print(StringOfChar('-', 85));
  Print(' # | Card lines');
  Print(StringOfChar('-', 85));
  for LIndex := Low(LVariables) to High(LVariables) do
  begin
    LVariable := LVariables[LIndex];
    LPosition := 1;
    while LPosition < Length(LVariable) do
    begin
      LMark := IfThen(LPosition = 1, '*', ' ');
      LLine := Copy(LVariable, LPosition, cSizeLine);
      Print('%2s | %s', [LMark, LLine]);
      Inc(LPosition, cSizeLine);
    end;
  end;
  Print('');
end;

procedure Main;
var
  LFileName: string;
  LStream: TFileStream;
  LContainer: TFitsContainer;
  LHead: TFitsItemHead;
begin
  Print('DeLaFits Demo "Read and write the HDU header"');
  Print('');
  LStream := nil;
  LContainer := nil;
  try
    // Copy the demo FITS file from the "data" directory to the project directory
    LFileName := CopyFile('../../data/demo-item.fits', 'output.fits');
    // Create the stream of FITS file and the FITS container
    LStream := TFileStream.Create(LFileName, fmOpenReadWrite);
    LContainer := TFitsContainer.Create(LStream);
    // Get header of the primary HDU
    LHead := LContainer.Primary.Head;
    // Read and write header
    ReadHeaderLines(LHead);
    ReadHeaderCards(LHead);
    LocateHeaderCards(LHead);
    WriteHeaderCards(LHead);
    AppendHeaderCards(LHead);
    DeleteHeaderCards(LHead);
  finally
    LContainer.Free;
    LStream.Free;
  end;
  Print('DeLaFits Demo successfully completed, see "%s" file', [ExtractFileName(LFileName)]);
end;

end.
