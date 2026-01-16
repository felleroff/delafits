program imagevalues;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  SysUtils, umain;

begin
  try
    umain.Main;
  except
    on E: Exception do
      Writeln(E.ClassName + ': ' + E.Message);
  end;
  ReadLn;
end.

