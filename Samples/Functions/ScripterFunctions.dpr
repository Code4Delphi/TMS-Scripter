program ScripterFunctions;

uses
  Vcl.Forms,
  Main.View in 'Src\Main.View.pas' {MainView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'TMS Scripter - Funcoes com parametros e retorno';
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
