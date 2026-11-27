program ScripterDiscountRules;

uses
  Vcl.Forms,
  Main.View in 'Src\Main.View.pas' {MainView},
  Calculator in 'Src\Calculator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'TMS Scripter - Regras de desconto';
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
