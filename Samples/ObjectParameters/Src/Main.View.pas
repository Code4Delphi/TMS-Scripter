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
  ScrMps,
  Client.Model;

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
    Label1: TLabel;
    edtId: TEdit;
    Label2: TLabel;
    edtName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnCalculateDiscountClick(Sender: TObject);
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.FormCreate(Sender: TObject);
begin
  IDEScripter1.DefineClassByRTTI(TClient);
end;

procedure TMainView.btnCalculateDiscountClick(Sender: TObject);
begin
  edtDiscount.Clear;

  var LClient := TClient.Create;
  try
    LClient.Id := StrToIntDef(edtId.Text, 0);
    LClient.Name := edtName.Text;
    LClient.TypeClient := cBoxTypeClient.Text;

    IDEScripter1.SourceCode := IDEMemo1.Lines;
    IDEScripter1.Compile;

    var LDiscount := IDEScripter1.ExecuteSubroutineAsVariant('GetDiscount', [LClient]);
    if not VarIsNumeric(LDiscount) or (VarType(LDiscount) = varBoolean) then
      raise Exception.Create('GetDiscount deve retornar um percentual numerico.');

    edtDiscount.Text := VarToStr(LDiscount) + '%';
  finally
    LClient.Free;
  end;
end;

end.
