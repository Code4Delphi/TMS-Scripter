unit Main.View;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.Variants,
  System.Math,
  System.UITypes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ScripterInit,
  atScript,
  atScripter;

type
  TVenda = record
    Produto: string;
    Quantidade: Integer;
    ValorTotal: Currency;
  end;

  TMainView = class(TForm)
    pnAcoes: TPanel;
    btnGerarRelatorio: TButton;
    btnSalvarScript: TButton;
    lbInstrucao: TLabel;
    pnConteudo: TPanel;
    gBoxScript: TGroupBox;
    memoScript: TMemo;
    splitterRelatorio: TSplitter;
    gBoxRelatorio: TGroupBox;
    memoRelatorio: TMemo;
    pnStatus: TPanel;
    lbStatus: TLabel;
    Scripter: TatScripter;
    procedure FormCreate(Sender: TObject);
    procedure btnGerarRelatorioClick(Sender: TObject);
    procedure btnSalvarScriptClick(Sender: TObject);
    procedure memoScriptChange(Sender: TObject);
    procedure ScripterError(Sender: TObject; var Msg: string; Row, Col: Integer;
      var ShowException: Boolean);
  private
    FVendas: array[0..2] of TVenda;
    FFormatSettings: TFormatSettings;
    function ScriptFileName: string;
    procedure PrepararVendas;
    procedure GerarRelatorio;
    procedure MostrarErro(const AMensagem: string);
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.FormCreate(Sender: TObject);
begin
  FFormatSettings := TFormatSettings.Create('pt-BR');
  Self.PrepararVendas;
  Scripter.CurrentScript := Scripter.AddScript(slPascal);
  try
    memoScript.Lines.LoadFromFile(Self.ScriptFileName, TEncoding.UTF8);
    lbStatus.Caption := 'Edite o título ou a comissão e clique em Gerar relatório.';
  except
    on E: Exception do
      Self.MostrarErro(E.Message);
  end;
end;

function TMainView.ScriptFileName: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'Scripts\Relatorio.psc');
end;

procedure TMainView.PrepararVendas;
begin
  FVendas[0].Produto := 'Teclado';
  FVendas[0].Quantidade := 2;
  FVendas[0].ValorTotal := 200;
  FVendas[1].Produto := 'Mouse';
  FVendas[1].Quantidade := 3;
  FVendas[1].ValorTotal := 300;
  FVendas[2].Produto := 'Monitor';
  FVendas[2].Quantidade := 1;
  FVendas[2].ValorTotal := 500;
end;

procedure TMainView.GerarRelatorio;
begin
  var LTotal: Currency := 0;
  for var LVenda in FVendas do
    LTotal := LTotal + LVenda.ValorTotal;

  // O Delphi fornece os dados. O script personaliza o título e calcula a comissão.
  Scripter.SourceCode := memoScript.Lines;
  Scripter.Compile;
  var LTitulo := Scripter.ExecuteSubroutineAsVariant('TituloRelatorio');
  if not VarIsStr(LTitulo) then
    raise EArgumentException.Create('TituloRelatorio deve retornar um texto.');

  var LRetorno := Scripter.ExecuteSubroutineAsVariant('CalcularComissao', [LTotal]);
  if not VarIsNumeric(LRetorno) or (VarType(LRetorno) = varBoolean) then
    raise EArgumentException.Create('CalcularComissao deve retornar um valor numérico.');
  var LValor: Double := LRetorno;
  if IsNan(LValor) or IsInfinite(LValor) then
    raise EArgumentException.Create('CalcularComissao deve retornar um valor numérico finito.');
  var LComissao: Currency := RoundTo(LValor, -2);

  memoRelatorio.Lines.BeginUpdate;
  try
    memoRelatorio.Lines.Add(VarToStr(LTitulo));
    memoRelatorio.Lines.Add(StringOfChar('=', 45));
    memoRelatorio.Lines.Add(Format('%-16s %5s %22s', ['Produto', 'Qtd.', 'Valor total']));
    memoRelatorio.Lines.Add(StringOfChar('-', 45));
    for var LVenda in FVendas do
      memoRelatorio.Lines.Add(Format('%-16s %5d %22s', [LVenda.Produto,
        LVenda.Quantidade, 'R$ ' + FormatFloat('#,##0.00', LVenda.ValorTotal, FFormatSettings)]));
    memoRelatorio.Lines.Add(StringOfChar('-', 45));
    memoRelatorio.Lines.Add('Total de vendas: R$ ' + FormatFloat('#,##0.00', LTotal, FFormatSettings));
    memoRelatorio.Lines.Add('Comissão: R$ ' + FormatFloat('#,##0.00', LComissao, FFormatSettings));
  finally
    memoRelatorio.Lines.EndUpdate;
  end;
  lbStatus.Caption := 'Relatório gerado com o script atual, sem recompilar o aplicativo.';
end;

procedure TMainView.btnGerarRelatorioClick(Sender: TObject);
begin
  memoRelatorio.Clear;
  try
    Self.GerarRelatorio;
  except
    on E: Exception do
      Self.MostrarErro(E.Message);
  end;
end;

procedure TMainView.btnSalvarScriptClick(Sender: TObject);
begin
  try
    ForceDirectories(ExtractFilePath(Self.ScriptFileName));
    memoScript.Lines.SaveToFile(Self.ScriptFileName, TEncoding.UTF8);
    lbStatus.Caption := 'Script salvo em UTF-8: ' + Self.ScriptFileName;
  except
    on E: Exception do
      Self.MostrarErro(E.Message);
  end;
end;

procedure TMainView.memoScriptChange(Sender: TObject);
begin
  memoRelatorio.Clear;
  lbStatus.Caption := 'Script alterado. Gere novamente; use Salvar script para manter as alterações.';
end;

procedure TMainView.MostrarErro(const AMensagem: string);
begin
  memoRelatorio.Clear;
  lbStatus.Caption := 'Erro: ' + AMensagem;
  TaskMessageDlg('TMS Scripter - Erro', AMensagem, mtError, [mbOK], 0);
end;

procedure TMainView.ScripterError(Sender: TObject; var Msg: string; Row, Col: Integer;
  var ShowException: Boolean);
begin
  if Row > 0 then
    Msg := Format('Linha %d, coluna %d: %s', [Row, Col, Msg]);
  ShowException := True;
end;

end.
