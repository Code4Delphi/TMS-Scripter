unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ScrMemo, ScrMps, IDEMain, atScript, atScripter, Vcl.ExtCtrls, IDEDialog,
  ap_Classes, ap_Controls, ap_Forms, ap_Graphics, ap_Dialogs, ap_StdCtrls;

type
  TMainView = class(TForm)
    IDEScripter1: TIDEScripter;
    IDEMemo1: TIDEMemo;
    ScrPascalMemoStyler1: TScrPascalMemoStyler;
    Panel1: TPanel;
    btnExecute: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    IDEDialog1: TIDEDialog;
    IDEEngine1: TIDEEngine;
    edtShowIDE: TButton;
    procedure btnExecuteClick(Sender: TObject);
    procedure edtShowIDEClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.btnExecuteClick(Sender: TObject);
begin
  IDEScripter1.AddComponent(Edit1);
  IDEScripter1.AddComponent(Edit2);
  IDEScripter1.AddComponent(Edit3);

  IDEScripter1.SourceCode := IDEMemo1.Lines;
  IDEScripter1.Execute;
end;

procedure TMainView.edtShowIDEClick(Sender: TObject);
begin
  IDEScripter1.AddComponent(Edit1);
  IDEScripter1.AddComponent(Edit2);
  IDEScripter1.AddComponent(Edit3);

  IDEDialog1.Execute;
end;

end.
