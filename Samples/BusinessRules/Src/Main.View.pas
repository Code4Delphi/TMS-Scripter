unit Main.View;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.Math,
  System.UITypes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  ScrMemo,
  ScrMps,
  IDEMain,
  IDEDialog,
  atScript,
  atScripter,
  ap_Classes,
  ap_Controls,
  ap_Forms,
  ap_Graphics,
  ap_Dialogs,
  ap_StdCtrls,
  Calculator;

type
  TMainView = class(TForm)
    pnPedido: TPanel;
    gBoxPedido: TGroupBox;
    lbValorPedido: TLabel;
    edtValorPedido: TEdit;
    lbQuantidadeItens: TLabel;
    edtQuantidadeItens: TEdit;
    ckClienteVIP: TCheckBox;
    btnCalcular: TButton;
    gBoxResultado: TGroupBox;
    lbPercentual: TLabel;
    edtPercentual: TEdit;
    lbDesconto: TLabel;
    edtDesconto: TEdit;
    lbTotal: TLabel;
    edtTotal: TEdit;
    pnScript: TPanel;
    lbExemplo: TLabel;
    cBoxExemplos: TComboBox;
    btnAbrirScript: TButton;
    btnSalvarScript: TButton;
    btnAbrirIDE: TButton;
    lbArquivo: TLabel;
    memoScript: TIDEMemo;
    pnStatus: TPanel;
    lbStatus: TLabel;
    IDEScripter1: TIDEScripter;
    IDEScripterDebug: TIDEScripter;
    IDEEngine1: TIDEEngine;
    IDEDialog1: TIDEDialog;
    PascalStyler: TScrPascalMemoStyler;
    dlgAbrirScript: TOpenDialog;
    dlgSalvarScript: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCalcularClick(Sender: TObject);
    procedure btnAbrirScriptClick(Sender: TObject);
    procedure btnSalvarScriptClick(Sender: TObject);
    procedure btnAbrirIDEClick(Sender: TObject);
    procedure cBoxExemplosChange(Sender: TObject);
    procedure memoScriptChange(Sender: TObject);
    procedure PedidoChange(Sender: TObject);
    procedure ScripterError(Sender: TObject; var Msg: string; Row, Col: Integer;
      var ShowException: Boolean);
  private
    FFileName: string;
    FSavedSource: string;
    FExampleIndex: Integer;
    FUpdating: Boolean;
    FFormatSettings: TFormatSettings;
    function ScriptFolder: string;
    function ExampleFileName(AIndex: Integer): string;
    function HasChanges: Boolean;
    function ConfirmDiscard: Boolean;
    function SaveScript: Boolean;
    function ReadOrder: TOrderData;
    procedure LoadScript(const AFileName: string; AExampleIndex: Integer);
    procedure ClearResults;
    procedure UpdateFileLabel;
    procedure ShowError(const AMessage: string);
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.FormCreate(Sender: TObject);
begin
  FFormatSettings := TFormatSettings.Create('pt-BR');
  FExampleIndex := -1;
  edtValorPedido.Text := FormatFloat('0.00', 1000, FFormatSettings);
  IDEScripter1.CurrentScript := IDEScripter1.AddScript(slPascal);
  dlgAbrirScript.InitialDir := Self.ScriptFolder;
  dlgSalvarScript.InitialDir := Self.ScriptFolder;
  try
    Self.LoadScript(Self.ExampleFileName(0), 0);
  except
    on E: Exception do
      Self.ShowError(E.Message);
  end;
end;

function TMainView.ScriptFolder: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'Scripts');
end;

function TMainView.ExampleFileName(AIndex: Integer): string;
begin
  case AIndex of
    0: Result := 'Padrao.psc';
    1: Result := 'VIP.psc';
    2: Result := 'Campanha.psc';
  else
    raise EArgumentException.Create('Selecione um exemplo de regra.');
  end;
  Result := TPath.Combine(Self.ScriptFolder, Result);
end;

function TMainView.HasChanges: Boolean;
begin
  Result := memoScript.Lines.Text <> FSavedSource;
end;

function TMainView.ConfirmDiscard: Boolean;
begin
  Result := True;
  if not Self.HasChanges then
    Exit;

  case TaskMessageDlg('Salvar alterações',
    'O script possui alterações não salvas. Deseja salvá-las antes de continuar?',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0, mbCancel,
    ['Salvar', 'Descartar', 'Cancelar']) of
    mrYes: Result := Self.SaveScript;
    mrNo: Result := True;
  else
    Result := False;
  end;
end;

function TMainView.SaveScript: Boolean;
begin
  Result := False;
  dlgSalvarScript.FileName := FFileName;
  if not dlgSalvarScript.Execute then
    Exit;
  try
    memoScript.Lines.SaveToFile(dlgSalvarScript.FileName, TEncoding.UTF8);
    FFileName := dlgSalvarScript.FileName;
    FSavedSource := memoScript.Lines.Text;
    Self.UpdateFileLabel;
    lbStatus.Caption := 'Script salvo em UTF-8.';
    Result := True;
  except
    on E: Exception do
      Self.ShowError(E.Message);
  end;
end;

procedure TMainView.LoadScript(const AFileName: string; AExampleIndex: Integer);
begin
  var LSource := TStringList.Create;
  try
    LSource.LoadFromFile(AFileName, TEncoding.UTF8);
    FUpdating := True;
    try
      memoScript.Lines.Assign(LSource);
      FFileName := AFileName;
      FSavedSource := memoScript.Lines.Text;
      FExampleIndex := AExampleIndex;
      cBoxExemplos.ItemIndex := FExampleIndex;
    finally
      FUpdating := False;
    end;
    Self.ClearResults;
    Self.UpdateFileLabel;
    lbStatus.Caption := 'Regra carregada. Clique em Calcular ou abra a IDE para depurar.';
  finally
    LSource.Free;
  end;
end;

function TMainView.ReadOrder: TOrderData;
begin
  if not TryStrToCurr(Trim(edtValorPedido.Text), Result.Value, FFormatSettings) then
    raise EArgumentException.Create('Informe um valor válido, por exemplo: 1000,00.');
  if not TryStrToInt(Trim(edtQuantidadeItens.Text), Result.ItemCount) then
    raise EArgumentException.Create('Informe uma quantidade inteira maior que zero.');
  Result.IsVIP := ckClienteVIP.Checked;
  TCalculator.ValidateOrder(Result);
  Result.Value := RoundTo(Result.Value, -2);
end;

procedure TMainView.ClearResults;
begin
  edtPercentual.Clear;
  edtDesconto.Clear;
  edtTotal.Clear;
end;

procedure TMainView.UpdateFileLabel;
begin
  lbArquivo.Caption := FFileName;
  if FFileName.IsEmpty then
    lbArquivo.Caption := 'Nenhum arquivo carregado';
  if Self.HasChanges then
    lbArquivo.Caption := lbArquivo.Caption + ' * (alterado)';
  lbArquivo.Hint := lbArquivo.Caption;
end;

procedure TMainView.ShowError(const AMessage: string);
begin
  Self.ClearResults;
  lbStatus.Caption := 'Erro: ' + AMessage;
  TaskMessageDlg('TMS Scripter - Erro', AMessage, mtError, [mbOK], 0);
end;

procedure TMainView.btnCalcularClick(Sender: TObject);
begin
  Self.ClearResults;
  try
    var LOrder := Self.ReadOrder;
    var LResult := TCalculator.Calculate(IDEScripter1, memoScript.Lines, LOrder);
    edtPercentual.Text := FormatFloat('0.##', LResult.Percent, FFormatSettings) + '%';
    edtDesconto.Text := 'R$ ' + FormatFloat('#,##0.00', LResult.Discount, FFormatSettings);
    edtTotal.Text := 'R$ ' + FormatFloat('#,##0.00', LResult.Total, FFormatSettings);
    lbStatus.Caption := 'Calculado com a regra atual. Edite o script e calcule novamente sem recompilar.';
  except
    on E: Exception do
      Self.ShowError(E.Message);
  end;
end;

procedure TMainView.btnAbrirScriptClick(Sender: TObject);
begin
  if not dlgAbrirScript.Execute then
    Exit;
  if not Self.ConfirmDiscard then
    Exit;
  try
    Self.LoadScript(dlgAbrirScript.FileName, -1);
  except
    on E: Exception do
      Self.ShowError(E.Message);
  end;
end;

procedure TMainView.btnSalvarScriptClick(Sender: TObject);
begin
  Self.SaveScript;
end;

procedure TMainView.cBoxExemplosChange(Sender: TObject);
begin
  if FUpdating then
    Exit;

  var LIndex := cBoxExemplos.ItemIndex;
  try
    if Self.ConfirmDiscard then
      Self.LoadScript(Self.ExampleFileName(LIndex), LIndex);
  except
    on E: Exception do
      Self.ShowError(E.Message);
  end;
  cBoxExemplos.ItemIndex := FExampleIndex;
end;

procedure TMainView.memoScriptChange(Sender: TObject);
begin
  if FUpdating then
    Exit;
  Self.ClearResults;
  Self.UpdateFileLabel;
  lbStatus.Caption := 'Script alterado. Calcule novamente para aplicar a regra.';
end;

procedure TMainView.PedidoChange(Sender: TObject);
begin
  Self.ClearResults;
  lbStatus.Caption := 'Dados do pedido alterados. Calcule novamente.';
end;

procedure TMainView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Self.ConfirmDiscard;
end;

procedure TMainView.ScripterError(Sender: TObject; var Msg: string; Row, Col: Integer;
  var ShowException: Boolean);
begin
  if Row > 0 then
    Msg := Format('Linha %d, coluna %d: %s', [Row, Col, Msg]);
  ShowException := True;
end;

procedure TMainView.btnAbrirIDEClick(Sender: TObject);
begin
  Self.ClearResults;
  try
    var LOrder := Self.ReadOrder;
    IDEEngine1.NewProject;
    var LRuleFile := IDEEngine1.NewUnit(slPascal, False);
    LRuleFile.UnitName := 'Regra';
    LRuleFile.Script.SourceCode.Assign(memoScript.Lines);
    var LTestFile := IDEEngine1.NewUnit(slPascal, False);
    LTestFile.UnitName := 'TestePedido';
    LTestFile.Script.SourceCode.Text := TCalculator.DebugSource(LOrder);
    IDEEngine1.MainUnit := LTestFile;
    IDEEngine1.ActiveFile := LRuleFile;

    // icaNothing preserva os scripts em memoria quando o dialogo e fechado.
    // A propria IDE sincroniza o editor com o script antes de desanexar o memo.
    IDEDialog1.Execute;

    for var I := 0 to Pred(IDEEngine1.Files.Count) do
      if IDEEngine1.Files[I] = LRuleFile then
      begin
        memoScript.Lines.Assign(LRuleFile.Script.SourceCode);
        Self.UpdateFileLabel;
        lbStatus.Caption := 'Regra recebida da IDE. Calcule novamente; use Salvar script para gravar.';
        Exit;
      end;
    raise EInvalidOperation.Create('A regra foi removida da IDE. O editor principal foi preservado.');
  except
    on E: Exception do
      Self.ShowError(E.Message);
  end;
end;

end.
