{ **************************************************** }
{     DeLaFits - Library FITS for Delphi & Lazarus     }
{                                                      }
{             Compiler conditional defines             }
{                                                      }
{          Copyright(c) 2013-2026, felleroff           }
{              delafits.library@gmail.com              }
{        https://github.com/felleroff/delafits         }
{ **************************************************** }

// [platform] delphi and lazarus symbol

{$IFNDEF FPC}
  {$IFNDEF DCC}
    {$DEFINE DCC}
  {$ENDIF}
{$ENDIF}

// [platform] supports "inline" directive

{$DEFINE HAS_INLINE}
{$IFDEF DCC}
  {$IF CompilerVersion < 21.0}
    {$UNDEF HAS_INLINE}
  {$IFEND}
{$ENDIF}

// [platform] support for 10-byte floating point numbers of the "extended" type

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

// [platform] overflow checking

{$IFOPT Q+}
  {$DEFINE HAS_OVERFLOW_CHECK}
{$ENDIF}

// [platform] range checking

{$IFOPT R+}
  {$DEFINE HAS_RANGE_CHECK}
{$ENDIF}

// [project] memory allocation for temporary buffer

{$IF NOT (DEFINED(DELAFITS_MEMORY_SHARED) OR DEFINED(DELAFITS_MEMORY_OBJECT) OR DEFINED(DELAFITS_MEMORY_LOCAL))}
  {$DEFINE DELAFITS_MEMORY_SHARED}
{$IFEND}

// [project] support NaN math

{$IF NOT (DEFINED(DELAFITS_MATH_NAN_OFF))}
  {$DEFINE DELAFITS_MATH_NAN}
{$IFEND}

// [project] support for customizing the pseudo-random number generator

{.$DEFINE DELAFITS_CUSTOM_RANDOM}

// [project] round a pixel value in the picture render routine

{.$DEFINE DELAFITS_ROUND_RENDER}
