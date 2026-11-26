program ScripterShippingCalculator;

uses
  Vcl.Forms,
  Main.View in 'Src\Main.View.pas' {MainView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'TMS Scripter - Calculo de frete';
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
