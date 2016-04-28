program DemoData;

uses
  Forms,
  ufmMain in 'ufmMain.pas' {fmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
