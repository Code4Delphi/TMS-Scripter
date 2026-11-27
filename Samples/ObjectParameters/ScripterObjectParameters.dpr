program ScripterObjectParameters;

uses
  Vcl.Forms,
  Main.View in 'Src\Main.View.pas' {MainView},
  Client.Model in 'Src\Client.Model.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'TMS Scripter - Objeto como parametro';
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
