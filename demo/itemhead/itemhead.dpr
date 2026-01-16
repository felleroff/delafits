program itemhead;

{$APPTYPE CONSOLE}

{$R *.res}

uses
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
