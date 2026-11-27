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
  atScripter,
  IDEMain,
  ScrMemo,
  ScrMps;

type
  TMainView = class(TForm)
    pnCompra: TPanel;
    lbValue: TLabel;
    edtValue: TEdit;
    btnCalculateShipping: TButton;
    gBoxScript: TGroupBox;
    IDEScripter1: TIDEScripter;
    IDEMemo1: TIDEMemo;
    ScrPascalMemoStyler1: TScrPascalMemoStyler;
    Label1: TLabel;
    edtValorFrete: TEdit;
    procedure btnCalculateShippingClick(Sender: TObject);
    procedure IDEScripter1CompileError(Sender: TObject; var msg: string; row, col: Integer; var ShowException: Boolean);
  private

  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.btnCalculateShippingClick(Sender: TObject);
var
 LRetorno: Variant;
begin
  var LValorCompra := StrToFloatDef(edtValue.Text, 0);
  if LValorCompra <= 0 then
    raise Exception.Create('Enter an amount');

  IDEScripter1.SourceCode := IDEMemo1.Lines;
  IDEScripter1.Compile;

  LRetorno := IDEScripter1.ExecuteSubroutineAsVariant('CalcularFrete', [LValorCompra]);
  if not VarIsNumeric(LRetorno) or (VarType(LRetorno) = varBoolean) then
    raise Exception.Create('CalcularFrete it should return a numeric value');

  edtValorFrete.Text := FloatToStr(LRetorno);
end;

procedure TMainView.IDEScripter1CompileError(Sender: TObject; var msg: string; row, col: Integer; var ShowException: Boolean);
begin
  if Row > 0 then
    Msg := Format('Line %d, column %d. %s', [Row, Col, Msg]);
end;

end.
