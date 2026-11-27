unit Main.View;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Variants,
  Vcl.Controls,
  Vcl.Forms,
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
    pnCliente: TPanel;
    lbTypeClient: TLabel;
    cBoxTypeClient: TComboBox;
    btnCalculateDiscount: TButton;
    lbDiscount: TLabel;
    edtDiscount: TEdit;
    gBoxScript: TGroupBox;
    IDEMemo1: TIDEMemo;
    IDEScripter1: TIDEScripter;
    ScrPascalMemoStyler1: TScrPascalMemoStyler;
    procedure btnCalculateDiscountClick(Sender: TObject);
    procedure InputChange(Sender: TObject);
    procedure IDEScripter1CompileError(Sender: TObject; var Msg: string;
      Row, Col: Integer; var ShowException: Boolean);
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.btnCalculateDiscountClick(Sender: TObject);
begin
  edtDiscount.Clear;
  var LTypeClient := cBoxTypeClient.Text;

  IDEScripter1.SourceCode := IDEMemo1.Lines;
  IDEScripter1.Compile;

  var LDiscount := IDEScripter1.ExecuteSubroutineAsVariant('GetDiscount', [LTypeClient]);
  if not VarIsNumeric(LDiscount) or (VarType(LDiscount) = varBoolean) then
    raise Exception.Create('GetDiscount deve retornar um percentual numerico.');

  edtDiscount.Text := VarToStr(LDiscount) + '%';
end;

procedure TMainView.InputChange(Sender: TObject);
begin
  edtDiscount.Clear;
end;

procedure TMainView.IDEScripter1CompileError(Sender: TObject; var Msg: string;
  Row, Col: Integer; var ShowException: Boolean);
begin
  if Row > 0 then
    Msg := Format('Linha %d, coluna %d: %s', [Row, Col, Msg]);
end;

end.
