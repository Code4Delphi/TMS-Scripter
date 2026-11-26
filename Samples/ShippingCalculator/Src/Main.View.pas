unit Main.View;

interface

uses
  System.SysUtils,
  System.Classes,
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
  atScripter, IDEMain, ScrMemo, ScrMps;

type
  TMainView = class(TForm)
    pnCompra: TPanel;
    lbValorCompra: TLabel;
    edtValorCompra: TEdit;
    btnCalcularFrete: TButton;
    lbInstrucao: TLabel;
    gBoxScript: TGroupBox;
    IDEScripter1: TIDEScripter;
    IDEMemo1: TIDEMemo;
    ScrPascalMemoStyler1: TScrPascalMemoStyler;
    Label1: TLabel;
    edtValorFrete: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnCalcularFreteClick(Sender: TObject);
    procedure IDEScripter1CompileError(Sender: TObject; var msg: string; row, col: Integer; var ShowException: Boolean);
  private
    FFormatSettings: TFormatSettings;
    procedure CalcularFrete;
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.FormCreate(Sender: TObject);
begin
  FFormatSettings := TFormatSettings.Create('pt-BR');
end;

procedure TMainView.CalcularFrete;
begin
  var LValorCompra: Currency;
  if not TryStrToCurr(Trim(edtValorCompra.Text), LValorCompra, FFormatSettings) then
    raise EArgumentException.Create('Informe um valor de compra válido, como 150,00.');
  if LValorCompra <= 0 then
    raise EArgumentException.Create('O valor da compra deve ser maior que zero.');

  // O Delphi envia o valor da compra. O script decide o valor do frete.
  IDEScripter1.SourceCode := IDEMemo1.Lines;
  IDEScripter1.Compile;
  var LRetorno := IDEScripter1.ExecuteSubroutineAsVariant('CalcularFrete', [LValorCompra]);
  if not VarIsNumeric(LRetorno) or (VarType(LRetorno) = varBoolean) then
    raise EArgumentException.Create('CalcularFrete deve retornar um valor numérico.');

  var LValor: Double := LRetorno;
  if IsNan(LValor) or IsInfinite(LValor) or (LValor < 0) then
    raise EArgumentException.Create('O frete deve ser um valor finito maior ou igual a zero.');

  var LFrete: Currency;
  try
    LFrete := LRetorno;
  except
    on E: Exception do
      raise EArgumentException.Create('O frete ultrapassa o limite de um valor monetário.');
  end;
  edtValorFrete.Text := FormatFloat('#,##0.00', LFrete, FFormatSettings);
end;

procedure TMainView.btnCalcularFreteClick(Sender: TObject);
begin
  try
    Self.CalcularFrete;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TMainView.IDEScripter1CompileError(Sender: TObject; var msg: string; row, col: Integer; var ShowException: Boolean);
begin
  if Row > 0 then
    Msg := Format('Linha %d, coluna %d: %s', [Row, Col, Msg]);

  ShowException := True;
end;

end.
