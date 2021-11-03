{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{             Compiler conditional defines             }
{                                                      }
{          Copyright(c) 2013-2021, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

// platform: delphi and lazarus symbol

{$IFNDEF FPC}
  {$IFNDEF DCC}
    {$DEFINE DCC}
  {$ENDIF}
{$ENDIF}

// platform: supports 'inline' directive?

{$DEFINE HAS_INLINE}
{$IFDEF DCC}
  {$IF CompilerVersion < 21.0}
    {$UNDEF HAS_INLINE}
  {$IFEND}
{$ENDIF}

// platform: supports 10-bytes 'extended' type floating point numbers?

{$IFDEF FPC}
  {$IFDEF FPC_HAS_TYPE_EXTENDED}
    {$DEFINE HAS_EXTENDED_FLOAT}
  {$ENDIF}
{$ENDIF}

{$IFDEF DCC}
  {$IF SizeOf(Extended) >= 10}
    {$DEFINE HAS_EXTENDED_FLOAT}
  {$IFEND}
{$ENDIF}

// platform: overflow checking

{$IFOPT Q+}
  {$DEFINE HAS_OVERFLOW_CHECK}
{$ENDIF}

// platform: range checking

{$IFOPT R+}
  {$DEFINE HAS_RANGE_CHECK}
{$ENDIF}

// project: memory manager behavior

{$IF NOT (DEFINED(DELA_MEMORY_SHARED) OR DEFINED(DELA_MEMORY_PRIVATE) OR DEFINED(DELA_MEMORY_TEMP))}
  {$DEFINE DELA_MEMORY_SHARED}
{$IFEND}

// project: support NaN math

{$IF NOT (DEFINED(DELA_MATH_NAN_OFF))}
  {$DEFINE DELA_MATH_NAN}
{$IFEND}

// project: custom interface of the pseudorandom number generator

// {$DEFINE DELA_CUSTOM_RANDOM}

// project: round a pixel value in the picture render routine

// {$DEFINE DELA_ROUND_RENDER}

