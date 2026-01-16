{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{       (De)Serialize a content data array into        }
{               a physical value array:                }
{         Values = Zero + Scale * Swap(Buffer)         }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsSerialize;

{$I DeLaFitsDefine.inc}

interface

uses
{$IFDEF DCC}
  Math,
{$ENDIF}
  DeLaFitsCommon, DeLaFitsMath;

{$I DeLaFitsSuppress.inc}

type
  TSerializeArray = Pointer;

  TSerializeContext = record
    Count: Integer;
    Start: Integer;
    Scale: Extended;
    Zero: Extended;
  end;

  TSerializeProc = procedure (const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);

  TBufferType = TBitPix;

  TValuesType = TNumberType;

  function GetBufferToValuesProc(ABufferType: TBufferType; AValuesType: TValuesType; ALinearType: TLinearType): TSerializeProc;
  function GetValuesToBufferProc(ABufferType: TBufferType; AValuesType: TValuesType; ALinearType: TLinearType): TSerializeProc;

implementation

{$IFDEF DCC}
  {$WARN COMBINING_SIGNED_UNSIGNED OFF}
{$ENDIF}

{$IFDEF FPC}
  {$WARN 4035 OFF}
  {$WARN 4079 OFF}
  {$WARN 4080 OFF}
{$ENDIF}

var

  { Swap rules caching }

  Swapper: TSwapper;

const

  { Explicit type casting }

  cZero16u_T32c: T32c = cZero16u;
  cZero32u_T64c: T64c = cZero32u;
  cZero32u_T64f: T64f = cZero32u;

{ Deserialize buffer into values }

procedure BTOV_64F_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap64f(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_64F_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap64f(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_64F_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32f(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64F_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08c(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64F_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08u(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64F_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16c(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64F_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16u(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64F_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32c(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64F_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32u(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64F_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round64c(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64F_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero;
end;

procedure BTOV_64F_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure64f(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64F_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32f(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64F_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08c(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64F_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08u(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64F_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16c(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64F_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16u(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64F_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32c(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64F_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32u(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64F_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round64c(Swapper.Swap64f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32F_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32f(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_32F_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32f(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_32F_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32f(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_32F_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08c(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32F_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08u(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32F_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16c(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32F_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16u(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32F_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32c(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32F_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32u(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32F_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round64c(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32F_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero;
end;

procedure BTOV_32F_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure64f(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32F_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32f(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32F_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08c(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32F_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08u(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32F_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16c(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32F_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16u(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32F_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32c(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32F_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32u(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32F_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round64c(Swapper.Swap32f(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_08U_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex];
end;

procedure BTOV_08U_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex];
end;

procedure BTOV_08U_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex];
end;

procedure BTOV_08U_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_08U_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex];
end;

procedure BTOV_08U_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex];
end;

procedure BTOV_08U_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex];
end;

procedure BTOV_08U_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex];
end;

procedure BTOV_08U_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex];
end;

procedure BTOV_08U_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex];
end;

procedure BTOV_08U_80F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex] + cZero08c;
end;

procedure BTOV_08U_64F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex] + cZero08c;
end;

procedure BTOV_08U_32F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex] + cZero08c;
end;

procedure BTOV_08U_08C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex] + cZero08c;
end;

procedure BTOV_08U_08U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08u(TBuffer(ABuffer)[LIndex] + cZero08c);
end;

procedure BTOV_08U_16C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex] + cZero08c;
end;

procedure BTOV_08U_16U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure16u(TBuffer(ABuffer)[LIndex] + cZero08c);
end;

procedure BTOV_08U_32C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex] + cZero08c;
end;

procedure BTOV_08U_32U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32u(TBuffer(ABuffer)[LIndex] + cZero08c);
end;

procedure BTOV_08U_64C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex] + cZero08c;
end;

procedure BTOV_08U_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero;
end;

procedure BTOV_08U_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure64f(TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero);
end;

procedure BTOV_08U_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32f(TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero);
end;

procedure BTOV_08U_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08c(TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero);
end;

procedure BTOV_08U_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08u(TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero);
end;

procedure BTOV_08U_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16c(TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero);
end;

procedure BTOV_08U_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16u(TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero);
end;

procedure BTOV_08U_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32c(TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero);
end;

procedure BTOV_08U_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32u(TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero);
end;

procedure BTOV_08U_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round64c(TBuffer(ABuffer)[LIndex] * AContext.Scale + AContext.Zero);
end;

procedure BTOV_16C_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_16C_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_16C_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_16C_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08c(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_16C_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08u(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_16C_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_16C_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure16u(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_16C_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_16C_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32u(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_16C_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_16C_80F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u;
end;

procedure BTOV_16C_64F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u;
end;

procedure BTOV_16C_32F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u;
end;

procedure BTOV_16C_08C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08c(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u);
end;

procedure BTOV_16C_08U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08u(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u);
end;

procedure BTOV_16C_16C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure16c(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u);
end;

procedure BTOV_16C_16U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u;
end;

procedure BTOV_16C_32C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u;
end;

procedure BTOV_16C_32U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u;
end;

procedure BTOV_16C_64C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) + cZero16u;
end;

procedure BTOV_16C_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero;
end;

procedure BTOV_16C_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure64f(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_16C_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32f(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_16C_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08c(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_16C_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08u(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_16C_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16c(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_16C_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16u(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_16C_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32c(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_16C_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32u(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_16C_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round64c(Swapper.Swap16c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32C_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_32C_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_32C_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_32C_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08c(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32C_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08u(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32C_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure16c(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32C_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure16u(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32C_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_32C_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32u(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_32C_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_32C_80F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u;
end;

procedure BTOV_32C_64F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u;
end;

procedure BTOV_32C_32F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u;
end;

procedure BTOV_32C_08C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08c(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u);
end;

procedure BTOV_32C_08U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08u(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u);
end;

procedure BTOV_32C_16C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure16c(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u);
end;

procedure BTOV_32C_16U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure16u(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u);
end;

procedure BTOV_32C_32C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32c(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u);
end;

procedure BTOV_32C_32U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u;
end;

procedure BTOV_32C_64C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) + cZero32u;
end;

procedure BTOV_32C_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero;
end;

procedure BTOV_32C_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure64f(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32C_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32f(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32C_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08c(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32C_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08u(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32C_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16c(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32C_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16u(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32C_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32c(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32C_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32u(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_32C_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round64c(Swapper.Swap32c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64C_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap64c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_64C_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap64c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_64C_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap64c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_64C_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08c(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64C_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure08u(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64C_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure16c(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64C_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure16u(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64C_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32c(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64C_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32u(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]));
end;

procedure BTOV_64C_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap64c(TBuffer(ABuffer)[LIndex]);
end;

procedure BTOV_64C_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero;
end;

procedure BTOV_64C_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure64f(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64C_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Ensure32f(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64C_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08c(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64C_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round08u(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64C_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16c(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64C_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round16u(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64C_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32c(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64C_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round32u(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

procedure BTOV_64C_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TValues(AValues)[AContext.Start + LIndex] := Round64c(Swapper.Swap64c(TBuffer(ABuffer)[LIndex]) * AContext.Scale + AContext.Zero);
end;

{ Serialize values into buffer }

procedure VTOB_64F_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_64F_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64F_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64F_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64F_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64F_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64F_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64F_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64F_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64F_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64F_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64F_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64F_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64F_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64F_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64F_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64F_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64F_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64F_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64F_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64f;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64f(Ensure64f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_32F_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_32F_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32F_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32F_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32F_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32F_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32F_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32F_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32F_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32F_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32F_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32f;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32f(Ensure32f((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_08U_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_08U_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_08U_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_08U_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_08U_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := TValues(AValues)[AContext.Start + LIndex];
end;

procedure VTOB_08U_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_08U_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_08U_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_08U_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_08U_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_08U_80F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u(TValues(AValues)[AContext.Start + LIndex] - cZero08c);
end;

procedure VTOB_08U_64F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u(TValues(AValues)[AContext.Start + LIndex] - cZero08c);
end;

procedure VTOB_08U_32F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u(TValues(AValues)[AContext.Start + LIndex] - cZero08c);
end;

procedure VTOB_08U_08C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := TValues(AValues)[AContext.Start + LIndex] - cZero08c;
end;

procedure VTOB_08U_08U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex] - cZero08c);
end;

procedure VTOB_08U_16C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex] - cZero08c);
end;

procedure VTOB_08U_16U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex] - cZero08c);
end;

procedure VTOB_08U_32C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex] - cZero08c);
end;

procedure VTOB_08U_32U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex] - cZero08c);
end;

procedure VTOB_08U_64C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Ensure08u(TValues(AValues)[AContext.Start + LIndex] - cZero08c);
end;

procedure VTOB_08U_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_08U_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_08U_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_08U_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_08U_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_08U_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_08U_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_08U_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_08U_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_08U_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA08u;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Round08u((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale);
end;

procedure VTOB_16C_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_16C_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_16C_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_16C_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_16C_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_16C_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_16C_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Ensure16c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_16C_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Ensure16c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_16C_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Ensure16c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_16C_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Ensure16c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_16C_80F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u));
end;

procedure VTOB_16C_64F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u));
end;

procedure VTOB_16C_32F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u));
end;

procedure VTOB_16C_08C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Ensure16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u));
end;

procedure VTOB_16C_08U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u);
end;

procedure VTOB_16C_16C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Ensure16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u));
end;

procedure VTOB_16C_16U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u);
end;

procedure VTOB_16C_32C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Ensure16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u));
end;

procedure VTOB_16C_32U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Ensure16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u_T32c));
end;

procedure VTOB_16C_64C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Ensure16c(TValues(AValues)[AContext.Start + LIndex] - cZero16u));
end;

procedure VTOB_16C_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_16C_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_16C_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_16C_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_16C_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_16C_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_16C_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_16C_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_16C_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_16C_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA16c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap16c(Round16c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_32C_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_32C_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_32C_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32C_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32C_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32C_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32C_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_32C_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Ensure32c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_32C_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Ensure32c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_32C_80F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u));
end;

procedure VTOB_32C_64F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u));
end;

procedure VTOB_32C_32F_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u_T64f));
end;

procedure VTOB_32C_08C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Ensure32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u));
end;

procedure VTOB_32C_08U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u_T64c);
end;

procedure VTOB_32C_16C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Ensure32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u));
end;

procedure VTOB_32C_16U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u_T64c);
end;

procedure VTOB_32C_32C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Ensure32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u));
end;

procedure VTOB_32C_32U_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u_T64c);
end;

procedure VTOB_32C_64C_SHIFT(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Ensure32c(TValues(AValues)[AContext.Start + LIndex] - cZero32u));
end;

procedure VTOB_32C_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_32C_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA32c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap32c(Round32c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_80F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_64C_64F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_64C_32F_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c(TValues(AValues)[AContext.Start + LIndex]));
end;

procedure VTOB_64C_08C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64C_08U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64C_16C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64C_16U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64C_32C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64C_32U_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64C_64C_PLAIN(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(TValues(AValues)[AContext.Start + LIndex]);
end;

procedure VTOB_64C_80F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA80f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_64F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA64f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_32F_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32f;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_08C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA08c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_08U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA08u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_16C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA16c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_16U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA16u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_32C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_32U_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA32u;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

procedure VTOB_64C_64C_SCALE(const ABuffer, AValues: TSerializeArray; const AContext: TSerializeContext);
type
  TBuffer = TA64c;
  TValues = TA64c;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AContext.Count - 1 do
    TBuffer(ABuffer)[LIndex] := Swapper.Swap64c(Round64c((TValues(AValues)[AContext.Start + LIndex] - AContext.Zero) / AContext.Scale));
end;

{ Get the serialization procedure }

function GetBufferToValuesProc(ABufferType: TBufferType; AValuesType: TValuesType; ALinearType: TLinearType): TSerializeProc;
begin
  Result := nil;
  case ABufferType of
    bi64f:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_80F_PLAIN;
            linearScale : Result := @BTOV_64F_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_64F_PLAIN;
            linearScale : Result := @BTOV_64F_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_32F_PLAIN;
            linearScale : Result := @BTOV_64F_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_08C_PLAIN;
            linearScale : Result := @BTOV_64F_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_08U_PLAIN;
            linearScale : Result := @BTOV_64F_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_16C_PLAIN;
            linearScale : Result := @BTOV_64F_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_16U_PLAIN;
            linearScale : Result := @BTOV_64F_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_32C_PLAIN;
            linearScale : Result := @BTOV_64F_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_32U_PLAIN;
            linearScale : Result := @BTOV_64F_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @BTOV_64F_64C_PLAIN;
            linearScale : Result := @BTOV_64F_64C_SCALE;
          end;
      end;
    bi32f:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_80F_PLAIN;
            linearScale : Result := @BTOV_32F_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_64F_PLAIN;
            linearScale : Result := @BTOV_32F_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_32F_PLAIN;
            linearScale : Result := @BTOV_32F_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_08C_PLAIN;
            linearScale : Result := @BTOV_32F_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_08U_PLAIN;
            linearScale : Result := @BTOV_32F_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_16C_PLAIN;
            linearScale : Result := @BTOV_32F_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_16U_PLAIN;
            linearScale : Result := @BTOV_32F_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_32C_PLAIN;
            linearScale : Result := @BTOV_32F_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_32U_PLAIN;
            linearScale : Result := @BTOV_32F_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @BTOV_32F_64C_PLAIN;
            linearScale : Result := @BTOV_32F_64C_SCALE;
          end;
      end;
    bi08u:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_80F_PLAIN;
            linearShift : Result := @BTOV_08U_80F_SHIFT;
            linearScale : Result := @BTOV_08U_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_64F_PLAIN;
            linearShift : Result := @BTOV_08U_64F_SHIFT;
            linearScale : Result := @BTOV_08U_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_32F_PLAIN;
            linearShift : Result := @BTOV_08U_32F_SHIFT;
            linearScale : Result := @BTOV_08U_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_08C_PLAIN;
            linearShift : Result := @BTOV_08U_08C_SHIFT;
            linearScale : Result := @BTOV_08U_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_08U_PLAIN;
            linearShift : Result := @BTOV_08U_08U_SHIFT;
            linearScale : Result := @BTOV_08U_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_16C_PLAIN;
            linearShift : Result := @BTOV_08U_16C_SHIFT;
            linearScale : Result := @BTOV_08U_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_16U_PLAIN;
            linearShift : Result := @BTOV_08U_16U_SHIFT;
            linearScale : Result := @BTOV_08U_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_32C_PLAIN;
            linearShift : Result := @BTOV_08U_32C_SHIFT;
            linearScale : Result := @BTOV_08U_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_32U_PLAIN;
            linearShift : Result := @BTOV_08U_32U_SHIFT;
            linearScale : Result := @BTOV_08U_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @BTOV_08U_64C_PLAIN;
            linearShift : Result := @BTOV_08U_64C_SHIFT;
            linearScale : Result := @BTOV_08U_64C_SCALE;
          end;
      end;
    bi16c:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_80F_PLAIN;
            linearShift : Result := @BTOV_16C_80F_SHIFT;
            linearScale : Result := @BTOV_16C_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_64F_PLAIN;
            linearShift : Result := @BTOV_16C_64F_SHIFT;
            linearScale : Result := @BTOV_16C_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_32F_PLAIN;
            linearShift : Result := @BTOV_16C_32F_SHIFT;
            linearScale : Result := @BTOV_16C_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_08C_PLAIN;
            linearShift : Result := @BTOV_16C_08C_SHIFT;
            linearScale : Result := @BTOV_16C_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_08U_PLAIN;
            linearShift : Result := @BTOV_16C_08U_SHIFT;
            linearScale : Result := @BTOV_16C_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_16C_PLAIN;
            linearShift : Result := @BTOV_16C_16C_SHIFT;
            linearScale : Result := @BTOV_16C_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_16U_PLAIN;
            linearShift : Result := @BTOV_16C_16U_SHIFT;
            linearScale : Result := @BTOV_16C_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_32C_PLAIN;
            linearShift : Result := @BTOV_16C_32C_SHIFT;
            linearScale : Result := @BTOV_16C_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_32U_PLAIN;
            linearShift : Result := @BTOV_16C_32U_SHIFT;
            linearScale : Result := @BTOV_16C_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @BTOV_16C_64C_PLAIN;
            linearShift : Result := @BTOV_16C_64C_SHIFT;
            linearScale : Result := @BTOV_16C_64C_SCALE;
          end;
      end;
    bi32c:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_80F_PLAIN;
            linearShift : Result := @BTOV_32C_80F_SHIFT;
            linearScale : Result := @BTOV_32C_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_64F_PLAIN;
            linearShift : Result := @BTOV_32C_64F_SHIFT;
            linearScale : Result := @BTOV_32C_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_32F_PLAIN;
            linearShift : Result := @BTOV_32C_32F_SHIFT;
            linearScale : Result := @BTOV_32C_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_08C_PLAIN;
            linearShift : Result := @BTOV_32C_08C_SHIFT;
            linearScale : Result := @BTOV_32C_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_08U_PLAIN;
            linearShift : Result := @BTOV_32C_08U_SHIFT;
            linearScale : Result := @BTOV_32C_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_16C_PLAIN;
            linearShift : Result := @BTOV_32C_16C_SHIFT;
            linearScale : Result := @BTOV_32C_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_16U_PLAIN;
            linearShift : Result := @BTOV_32C_16U_SHIFT;
            linearScale : Result := @BTOV_32C_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_32C_PLAIN;
            linearShift : Result := @BTOV_32C_32C_SHIFT;
            linearScale : Result := @BTOV_32C_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_32U_PLAIN;
            linearShift : Result := @BTOV_32C_32U_SHIFT;
            linearScale : Result := @BTOV_32C_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @BTOV_32C_64C_PLAIN;
            linearShift : Result := @BTOV_32C_64C_SHIFT;
            linearScale : Result := @BTOV_32C_64C_SCALE;
          end;
      end;
    bi64c:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_80F_PLAIN;
            linearScale : Result := @BTOV_64C_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_64F_PLAIN;
            linearScale : Result := @BTOV_64C_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_32F_PLAIN;
            linearScale : Result := @BTOV_64C_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_08C_PLAIN;
            linearScale : Result := @BTOV_64C_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_08U_PLAIN;
            linearScale : Result := @BTOV_64C_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_16C_PLAIN;
            linearScale : Result := @BTOV_64C_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_16U_PLAIN;
            linearScale : Result := @BTOV_64C_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_32C_PLAIN;
            linearScale : Result := @BTOV_64C_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_32U_PLAIN;
            linearScale : Result := @BTOV_64C_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @BTOV_64C_64C_PLAIN;
            linearScale : Result := @BTOV_64C_64C_SCALE;
          end;
      end;
  end;
  Assert(Assigned(@Result), SAssertionFailure);
end;

function GetValuesToBufferProc(ABufferType: TBufferType; AValuesType: TValuesType; ALinearType: TLinearType): TSerializeProc;
begin
  Result := nil;
  case ABufferType of
    bi64f:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_80F_PLAIN;
            linearScale : Result := @VTOB_64F_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_64F_PLAIN;
            linearScale : Result := @VTOB_64F_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_32F_PLAIN;
            linearScale : Result := @VTOB_64F_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_08C_PLAIN;
            linearScale : Result := @VTOB_64F_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_08U_PLAIN;
            linearScale : Result := @VTOB_64F_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_16C_PLAIN;
            linearScale : Result := @VTOB_64F_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_16U_PLAIN;
            linearScale : Result := @VTOB_64F_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_32C_PLAIN;
            linearScale : Result := @VTOB_64F_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_32U_PLAIN;
            linearScale : Result := @VTOB_64F_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @VTOB_64F_64C_PLAIN;
            linearScale : Result := @VTOB_64F_64C_SCALE;
          end;
      end;
    bi32f:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_80F_PLAIN;
            linearScale : Result := @VTOB_32F_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_64F_PLAIN;
            linearScale : Result := @VTOB_32F_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_32F_PLAIN;
            linearScale : Result := @VTOB_32F_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_08C_PLAIN;
            linearScale : Result := @VTOB_32F_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_08U_PLAIN;
            linearScale : Result := @VTOB_32F_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_16C_PLAIN;
            linearScale : Result := @VTOB_32F_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_16U_PLAIN;
            linearScale : Result := @VTOB_32F_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_32C_PLAIN;
            linearScale : Result := @VTOB_32F_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_32U_PLAIN;
            linearScale : Result := @VTOB_32F_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @VTOB_32F_64C_PLAIN;
            linearScale : Result := @VTOB_32F_64C_SCALE;
          end;
      end;
    bi08u:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_80F_PLAIN;
            linearShift : Result := @VTOB_08U_80F_SHIFT;
            linearScale : Result := @VTOB_08U_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_64F_PLAIN;
            linearShift : Result := @VTOB_08U_64F_SHIFT;
            linearScale : Result := @VTOB_08U_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_32F_PLAIN;
            linearShift : Result := @VTOB_08U_32F_SHIFT;
            linearScale : Result := @VTOB_08U_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_08C_PLAIN;
            linearShift : Result := @VTOB_08U_08C_SHIFT;
            linearScale : Result := @VTOB_08U_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_08U_PLAIN;
            linearShift : Result := @VTOB_08U_08U_SHIFT;
            linearScale : Result := @VTOB_08U_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_16C_PLAIN;
            linearShift : Result := @VTOB_08U_16C_SHIFT;
            linearScale : Result := @VTOB_08U_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_16U_PLAIN;
            linearShift : Result := @VTOB_08U_16U_SHIFT;
            linearScale : Result := @VTOB_08U_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_32C_PLAIN;
            linearShift : Result := @VTOB_08U_32C_SHIFT;
            linearScale : Result := @VTOB_08U_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_32U_PLAIN;
            linearShift : Result := @VTOB_08U_32U_SHIFT;
            linearScale : Result := @VTOB_08U_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @VTOB_08U_64C_PLAIN;
            linearShift : Result := @VTOB_08U_64C_SHIFT;
            linearScale : Result := @VTOB_08U_64C_SCALE;
          end;
      end;
    bi16c:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_80F_PLAIN;
            linearShift : Result := @VTOB_16C_80F_SHIFT;
            linearScale : Result := @VTOB_16C_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_64F_PLAIN;
            linearShift : Result := @VTOB_16C_64F_SHIFT;
            linearScale : Result := @VTOB_16C_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_32F_PLAIN;
            linearShift : Result := @VTOB_16C_32F_SHIFT;
            linearScale : Result := @VTOB_16C_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_08C_PLAIN;
            linearShift : Result := @VTOB_16C_08C_SHIFT;
            linearScale : Result := @VTOB_16C_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_08U_PLAIN;
            linearShift : Result := @VTOB_16C_08U_SHIFT;
            linearScale : Result := @VTOB_16C_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_16C_PLAIN;
            linearShift : Result := @VTOB_16C_16C_SHIFT;
            linearScale : Result := @VTOB_16C_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_16U_PLAIN;
            linearShift : Result := @VTOB_16C_16U_SHIFT;
            linearScale : Result := @VTOB_16C_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_32C_PLAIN;
            linearShift : Result := @VTOB_16C_32C_SHIFT;
            linearScale : Result := @VTOB_16C_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_32U_PLAIN;
            linearShift : Result := @VTOB_16C_32U_SHIFT;
            linearScale : Result := @VTOB_16C_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @VTOB_16C_64C_PLAIN;
            linearShift : Result := @VTOB_16C_64C_SHIFT;
            linearScale : Result := @VTOB_16C_64C_SCALE;
          end;
      end;
    bi32c:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_80F_PLAIN;
            linearShift : Result := @VTOB_32C_80F_SHIFT;
            linearScale : Result := @VTOB_32C_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_64F_PLAIN;
            linearShift : Result := @VTOB_32C_64F_SHIFT;
            linearScale : Result := @VTOB_32C_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_32F_PLAIN;
            linearShift : Result := @VTOB_32C_32F_SHIFT;
            linearScale : Result := @VTOB_32C_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_08C_PLAIN;
            linearShift : Result := @VTOB_32C_08C_SHIFT;
            linearScale : Result := @VTOB_32C_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_08U_PLAIN;
            linearShift : Result := @VTOB_32C_08U_SHIFT;
            linearScale : Result := @VTOB_32C_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_16C_PLAIN;
            linearShift : Result := @VTOB_32C_16C_SHIFT;
            linearScale : Result := @VTOB_32C_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_16U_PLAIN;
            linearShift : Result := @VTOB_32C_16U_SHIFT;
            linearScale : Result := @VTOB_32C_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_32C_PLAIN;
            linearShift : Result := @VTOB_32C_32C_SHIFT;
            linearScale : Result := @VTOB_32C_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_32U_PLAIN;
            linearShift : Result := @VTOB_32C_32U_SHIFT;
            linearScale : Result := @VTOB_32C_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @VTOB_32C_64C_PLAIN;
            linearShift : Result := @VTOB_32C_64C_SHIFT;
            linearScale : Result := @VTOB_32C_64C_SCALE;
          end;
      end;
    bi64c:
      case AValuesType of
        num80f:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_80F_PLAIN;
            linearScale : Result := @VTOB_64C_80F_SCALE;
          end;
        num64f:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_64F_PLAIN;
            linearScale : Result := @VTOB_64C_64F_SCALE;
          end;
        num32f:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_32F_PLAIN;
            linearScale : Result := @VTOB_64C_32F_SCALE;
          end;
        num08c:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_08C_PLAIN;
            linearScale : Result := @VTOB_64C_08C_SCALE;
          end;
        num08u:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_08U_PLAIN;
            linearScale : Result := @VTOB_64C_08U_SCALE;
          end;
        num16c:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_16C_PLAIN;
            linearScale : Result := @VTOB_64C_16C_SCALE;
          end;
        num16u:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_16U_PLAIN;
            linearScale : Result := @VTOB_64C_16U_SCALE;
          end;
        num32c:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_32C_PLAIN;
            linearScale : Result := @VTOB_64C_32C_SCALE;
          end;
        num32u:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_32U_PLAIN;
            linearScale : Result := @VTOB_64C_32U_SCALE;
          end;
        num64c:
          case ALinearType of
            linearPlain : Result := @VTOB_64C_64C_PLAIN;
            linearScale : Result := @VTOB_64C_64C_SCALE;
          end;
      end;
  end;
  Assert(Assigned(@Result), SAssertionFailure);
end;

initialization
  Swapper := GetSwapper;

end.
