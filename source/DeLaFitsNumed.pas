{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{         Numbers Binary Editor of Data Block          }
{                                                      }
{ Read and Write physical data values to custom buffer }
{      Elems[Index] = Terms[Index] * Scal + Zero       }
{                                                      }
{  Interface name semantics: [RW]_BITPIX_SCALE_REPPIX  }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

unit DeLaFitsNumed;

{$I DeLaFitsDefine.inc}

interface

uses
  SysUtils, Classes, Math, DeLaFitsCommon, DeLaFitsMath;

{$I DeLaFitsSuppress.inc}

type

  TEditor = record
    BufferAllocate: procedure (var ABuffer: Pointer; ASize: Integer) of object;
    BufferRelease : procedure (var ABuffer: Pointer) of object;
    DataRead      : procedure (const Uffset, ASize: Int64; var ABuffer) of object;
    DataWrite     : procedure (const Uffset, ASize: Int64; const ABuffer) of object;
  end;

  { Read }

  procedure R_64F_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_64F_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_64F_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_64F_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_64F_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_64F_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_64F_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_64F_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_64F_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_64F_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
  procedure R_64F_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_64F_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_64F_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_64F_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_64F_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_64F_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_64F_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_64F_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_64F_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_64F_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);

  procedure R_32F_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_32F_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_32F_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_32F_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_32F_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_32F_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_32F_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_32F_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_32F_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_32F_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
  procedure R_32F_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_32F_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_32F_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_32F_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_32F_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_32F_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_32F_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_32F_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_32F_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_32F_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);

  procedure R_08U_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_08U_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_08U_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_08U_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_08U_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_08U_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_08U_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_08U_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_08U_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_08U_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
  procedure R_08U_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_08U_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_08U_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_08U_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_08U_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_08U_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_08U_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_08U_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_08U_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_08U_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
  procedure R_08U_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_08U_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_08U_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_08U_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_08U_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_08U_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_08U_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_08U_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_08U_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_08U_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);

  procedure R_16C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_16C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_16C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_16C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_16C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_16C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_16C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_16C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_16C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_16C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
  procedure R_16C_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_16C_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_16C_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_16C_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_16C_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_16C_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_16C_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_16C_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_16C_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_16C_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
  procedure R_16C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_16C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_16C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_16C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_16C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_16C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_16C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_16C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_16C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_16C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);

  procedure R_32C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_32C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_32C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_32C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_32C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_32C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_32C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_32C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_32C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_32C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
  procedure R_32C_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_32C_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_32C_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_32C_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_32C_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_32C_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_32C_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_32C_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_32C_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_32C_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
  procedure R_32C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_32C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_32C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_32C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_32C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_32C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_32C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_32C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_32C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_32C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);

  procedure R_64C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_64C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_64C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_64C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_64C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_64C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_64C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_64C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_64C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_64C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
  procedure R_64C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
  procedure R_64C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
  procedure R_64C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
  procedure R_64C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
  procedure R_64C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
  procedure R_64C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
  procedure R_64C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
  procedure R_64C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
  procedure R_64C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
  procedure R_64C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);

  { Write }

  procedure W_64F_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_64F_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_64F_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_64F_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_64F_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_64F_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_64F_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_64F_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_64F_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_64F_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_64F_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_64F_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_64F_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_64F_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_64F_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_64F_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_64F_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_64F_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_64F_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_64F_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);

  procedure W_32F_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_32F_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_32F_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_32F_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_32F_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_32F_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_32F_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_32F_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_32F_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_32F_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_32F_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_32F_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_32F_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_32F_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_32F_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_32F_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_32F_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_32F_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_32F_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_32F_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_08U_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_08U_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_08U_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_08U_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_08U_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_08U_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_08U_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_08U_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_08U_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_08U_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_08U_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_08U_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_08U_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_08U_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_08U_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_08U_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_08U_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_08U_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_08U_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_08U_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_08U_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_08U_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_08U_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_08U_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_08U_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_08U_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_08U_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_08U_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_08U_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_08U_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);

  procedure W_16C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_16C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_16C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_16C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_16C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_16C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_16C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_16C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_16C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_16C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_16C_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_16C_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_16C_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_16C_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_16C_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_16C_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_16C_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_16C_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_16C_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_16C_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_16C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_16C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_16C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_16C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_16C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_16C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_16C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_16C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_16C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_16C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);

  procedure W_32C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_32C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_32C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_32C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_32C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_32C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_32C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_32C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_32C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_32C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_32C_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_32C_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_32C_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_32C_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_32C_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_32C_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_32C_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_32C_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_32C_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_32C_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_32C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_32C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_32C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_32C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_32C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_32C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_32C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_32C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_32C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_32C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);

  procedure W_64C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_64C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_64C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_64C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_64C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_64C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_64C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_64C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_64C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_64C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
  procedure W_64C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
  procedure W_64C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
  procedure W_64C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
  procedure W_64C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
  procedure W_64C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
  procedure W_64C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
  procedure W_64C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
  procedure W_64C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
  procedure W_64C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
  procedure W_64C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);

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

{ Read }

procedure R_64F_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap64f(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap64f(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32f(Swapper.Swap64f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08c(Swapper.Swap64f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08u(Swapper.Swap64f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16c(Swapper.Swap64f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16u(Swapper.Swap64f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32c(Swapper.Swap64f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32u(Swapper.Swap64f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round64c(Swapper.Swap64f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap64f(Terms[I]) * AScal + AZero;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure64f(Swapper.Swap64f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32f(Swapper.Swap64f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08c(Swapper.Swap64f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08u(Swapper.Swap64f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16c(Swapper.Swap64f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16u(Swapper.Swap64f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32c(Swapper.Swap64f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32u(Swapper.Swap64f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64F_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round64c(Swapper.Swap64f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;


procedure R_32F_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32f(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32f(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32f(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08c(Swapper.Swap32f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08u(Swapper.Swap32f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16c(Swapper.Swap32f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16u(Swapper.Swap32f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32c(Swapper.Swap32f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32u(Swapper.Swap32f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round64c(Swapper.Swap32f(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32f(Terms[I]) * AScal + AZero;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure64f(Swapper.Swap32f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32f(Swapper.Swap32f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08c(Swapper.Swap32f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08u(Swapper.Swap32f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16c(Swapper.Swap32f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16u(Swapper.Swap32f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32c(Swapper.Swap32f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32u(Swapper.Swap32f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32F_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round64c(Swapper.Swap32f(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;


procedure R_08U_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I];
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I];
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I];
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I];
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I];
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I];
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I];
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I];
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I];
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I] + cZero08c;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I] + cZero08c;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I] + cZero08c;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I] + cZero08c;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08u(Terms[I] + cZero08c);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I] + cZero08c;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure16u(Terms[I] + cZero08c);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I] + cZero08c;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32u(Terms[I] + cZero08c);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I] + cZero08c;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Terms[I] * AScal + AZero;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure64f(Terms[I] * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32f(Terms[I] * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08c(Terms[I] * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08u(Terms[I] * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16c(Terms[I] * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16u(Terms[I] * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32c(Terms[I] * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32u(Terms[I] * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_08U_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round64c(Terms[I] * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;


procedure R_16C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08c(Swapper.Swap16c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08u(Swapper.Swap16c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure16u(Swapper.Swap16c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32u(Swapper.Swap16c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]) + cZero16u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]) + cZero16u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]) + cZero16u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08c(Swapper.Swap16c(Terms[I]) + cZero16u);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08u(Swapper.Swap16c(Terms[I]) + cZero16u);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure16c(Swapper.Swap16c(Terms[I]) + cZero16u);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]) + cZero16u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]) + cZero16u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]) + cZero16u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]) + cZero16u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap16c(Terms[I]) * AScal + AZero;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure64f(Swapper.Swap16c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32f(Swapper.Swap16c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08c(Swapper.Swap16c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08u(Swapper.Swap16c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16c(Swapper.Swap16c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16u(Swapper.Swap16c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32c(Swapper.Swap16c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32u(Swapper.Swap16c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_16C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round64c(Swapper.Swap16c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;


procedure R_32C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08c(Swapper.Swap32c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08u(Swapper.Swap32c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure16c(Swapper.Swap32c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure16u(Swapper.Swap32c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32u(Swapper.Swap32c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]) + cZero32u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]) + cZero32u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]) + cZero32u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08c(Swapper.Swap32c(Terms[I]) + cZero32u);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08u(Swapper.Swap32c(Terms[I]) + cZero32u);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure16c(Swapper.Swap32c(Terms[I]) + cZero32u);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure16u(Swapper.Swap32c(Terms[I]) + cZero32u);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32c(Swapper.Swap32c(Terms[I]) + cZero32u);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]) + cZero32u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]) + cZero32u;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap32c(Terms[I]) * AScal + AZero;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure64f(Swapper.Swap32c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32f(Swapper.Swap32c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08c(Swapper.Swap32c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08u(Swapper.Swap32c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16c(Swapper.Swap32c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16u(Swapper.Swap32c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32c(Swapper.Swap32c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32u(Swapper.Swap32c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_32C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round64c(Swapper.Swap32c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;


procedure R_64C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap64c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap64c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap64c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08c(Swapper.Swap64c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure08u(Swapper.Swap64c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure16c(Swapper.Swap64c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure16u(Swapper.Swap64c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32c(Swapper.Swap64c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32u(Swapper.Swap64c(Terms[I]));
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap64c(Terms[I]);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA80f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Swapper.Swap64c(Terms[I]) * AScal + AZero;
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure64f(Swapper.Swap64c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Ensure32f(Swapper.Swap64c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08c(Swapper.Swap64c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA08u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round08u(Swapper.Swap64c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16c(Swapper.Swap64c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA16u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round16u(Swapper.Swap64c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32c(Swapper.Swap64c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA32u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round32u(Swapper.Swap64c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure R_64C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; var AElems: TA64c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountRead: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountRead := 0;
    while CountRead < ACount do
    begin
      CountTerms := Math.Min(ACount - CountRead, CountTerms);
      AEditor.DataRead((AIndex + CountRead) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      for I := 0 to CountTerms - 1 do
        AElems[CountRead + I] := Round64c(Swapper.Swap64c(Terms[I]) * AScal + AZero);
      Inc(CountRead, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

{ Write }

procedure W_64F_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64F_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T64f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64f(Ensure64f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;


procedure W_32F_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32F_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T32f;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32f(Ensure32f((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := AElems[CountWrite + I];
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u(AElems[CountWrite + I] - cZero08c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u(AElems[CountWrite + I] - cZero08c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u(AElems[CountWrite + I] - cZero08c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := AElems[CountWrite + I] - cZero08c;
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I] - cZero08c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I] - cZero08c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I] - cZero08c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I] - cZero08c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I] - cZero08c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Ensure08u(AElems[CountWrite + I] - cZero08c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_08U_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T08u;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Round08u((AElems[CountWrite + I] - AZero) / AScal);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;


procedure W_16C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Ensure16c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Ensure16c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Ensure16c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Ensure16c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c(AElems[CountWrite + I] - cZero16u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c(AElems[CountWrite + I] - cZero16u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c(AElems[CountWrite + I] - cZero16u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Ensure16c(AElems[CountWrite + I] - cZero16u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(AElems[CountWrite + I] - cZero16u);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Ensure16c(AElems[CountWrite + I] - cZero16u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(AElems[CountWrite + I] - cZero16u);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Ensure16c(AElems[CountWrite + I] - cZero16u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Ensure16c(AElems[CountWrite + I] - cZero16u_T32c));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Ensure16c(AElems[CountWrite + I] - cZero16u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_16C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T16c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap16c(Round16c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;


procedure W_32C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Ensure32c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Ensure32c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c(AElems[CountWrite + I] - cZero32u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c(AElems[CountWrite + I] - cZero32u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c(AElems[CountWrite + I] - cZero32u_T64f));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Ensure32c(AElems[CountWrite + I] - cZero32u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(AElems[CountWrite + I] - cZero32u_T64c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Ensure32c(AElems[CountWrite + I] - cZero32u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(AElems[CountWrite + I] - cZero32u_T64c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Ensure32c(AElems[CountWrite + I] - cZero32u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(AElems[CountWrite + I] - cZero32u_T64c);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_OFF_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Ensure32c(AElems[CountWrite + I] - cZero32u));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_32C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T32c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap32c(Round32c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;


procedure W_64C_ONE_80F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_ONE_64F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_ONE_32F(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c(AElems[CountWrite + I]));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_ONE_08C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_ONE_08U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_ONE_16C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_ONE_16U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_ONE_32C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_ONE_32U(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_ONE_64C(const AEditor: TEditor; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(AElems[CountWrite + I]);
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_80F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA80f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_64F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_32F(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32f);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_08C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_08U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA08u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_16C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_16U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA16u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_32C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_32U(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA32u);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

procedure W_64C_EXT_64C(const AEditor: TEditor; const AScal, AZero: Extended; const AIndex, ACount: Int64; const AElems: TA64c);
type
  TTerm = T64c;
const
  SizeTerm = SizeOf(TTerm);
var
  I: Integer;
  Terms: array of TTerm;
  CountTerms, SizeTerms, CountWrite: Int64;
begin
  CountTerms := Math.Min(ACount, Math.Max(1, cMaxSizeBuffer div SizeTerm));
  SizeTerms  := CountTerms * SizeTerm;
  Terms := nil;
  AEditor.BufferAllocate(Pointer(Terms), SizeTerms);
  try
    CountWrite := 0;
    while CountWrite < ACount do
    begin
      CountTerms := Math.Min(ACount - CountWrite, CountTerms);
      for I := 0 to CountTerms - 1 do
        Terms[I] := Swapper.Swap64c(Round64c((AElems[CountWrite + I] - AZero) / AScal));
      AEditor.DataWrite((AIndex + CountWrite) * SizeTerm, CountTerms * SizeTerm, Terms[0]);
      Inc(CountWrite, CountTerms);
    end;
  finally
    AEditor.BufferRelease(Pointer(Terms));
    Terms := nil;
  end;
end;

initialization
  Swapper := GetSwapper();

end.