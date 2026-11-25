object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'TMS Scripter - Regras de desconto sem recompilar'
  ClientHeight = 680
  ClientWidth = 1080
  Color = clBtnFace
  Constraints.MinHeight = 640
  Constraints.MinWidth = 1096
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 17
  object pnPedido: TPanel
    Left = 0
    Top = 0
    Width = 1080
    Height = 154
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object gBoxPedido: TGroupBox
      Left = 12
      Top = 8
      Width = 548
      Height = 138
      Caption = ' Dados do pedido '
      TabOrder = 0
      object lbValorPedido: TLabel
        Left = 16
        Top = 26
        Width = 118
        Height = 17
        Caption = 'Valor do pedido (R$)'
      end
      object lbQuantidadeItens: TLabel
        Left = 216
        Top = 26
        Width = 123
        Height = 17
        Caption = 'Quantidade de itens'
      end
      object edtValorPedido: TEdit
        Left = 16
        Top = 48
        Width = 180
        Height = 25
        TabOrder = 0
        Text = '1000,00'
        OnChange = PedidoChange
      end
      object edtQuantidadeItens: TEdit
        Left = 216
        Top = 48
        Width = 120
        Height = 25
        NumbersOnly = True
        TabOrder = 1
        Text = '1'
        OnChange = PedidoChange
      end
      object ckClienteVIP: TCheckBox
        Left = 360
        Top = 49
        Width = 144
        Height = 23
        Caption = 'Cliente VIP'
        TabOrder = 2
        OnClick = PedidoChange
      end
      object btnCalcular: TButton
        Left = 16
        Top = 90
        Width = 180
        Height = 32
        Cursor = crHandPoint
        Caption = 'Calcular pedido'
        TabOrder = 3
        OnClick = btnCalcularClick
      end
    end
    object gBoxResultado: TGroupBox
      Left = 572
      Top = 8
      Width = 496
      Height = 138
      Anchors = [akLeft, akTop, akRight]
      Caption = ' Resultado da regra atual '
      TabOrder = 1
      object lbPercentual: TLabel
        Left = 16
        Top = 26
        Width = 65
        Height = 17
        Caption = 'Percentual'
      end
      object lbDesconto: TLabel
        Left = 144
        Top = 26
        Width = 58
        Height = 17
        Caption = 'Desconto'
      end
      object lbTotal: TLabel
        Left = 312
        Top = 26
        Width = 57
        Height = 17
        Caption = 'Total final'
      end
      object edtPercentual: TEdit
        Left = 16
        Top = 48
        Width = 112
        Height = 29
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object edtDesconto: TEdit
        Left = 144
        Top = 48
        Width = 152
        Height = 29
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object edtTotal: TEdit
        Left = 312
        Top = 48
        Width = 168
        Height = 29
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
    end
  end
  object pnScript: TPanel
    Left = 0
    Top = 154
    Width = 1080
    Height = 96
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lbExemplo: TLabel
      Left = 16
      Top = 2
      Width = 141
      Height = 17
      Caption = 'Exemplo de regra Pascal'
    end
    object lbArquivo: TLabel
      Left = 16
      Top = 66
      Width = 1048
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Nenhum arquivo carregado'
      EllipsisPosition = epPathEllipsis
      ParentShowHint = False
      ShowHint = True
    end
    object cBoxExemplos: TComboBox
      Left = 16
      Top = 26
      Width = 242
      Height = 25
      Style = csDropDownList
      TabOrder = 0
      OnChange = cBoxExemplosChange
      Items.Strings = (
        'Padr'#227'o - 5% a partir de R$ 500'
        'VIP - 10% para clientes VIP'
        'Campanha - 15% com 10 itens')
    end
    object btnAbrirScript: TButton
      Left = 274
      Top = 24
      Width = 138
      Height = 30
      Caption = 'Abrir script...'
      TabOrder = 1
      OnClick = btnAbrirScriptClick
    end
    object btnSalvarScript: TButton
      Left = 424
      Top = 24
      Width = 138
      Height = 30
      Caption = 'Salvar script...'
      TabOrder = 2
      OnClick = btnSalvarScriptClick
    end
    object btnAbrirIDE: TButton
      Left = 574
      Top = 24
      Width = 170
      Height = 30
      Caption = 'Abrir IDE / Depurar'
      TabOrder = 3
      OnClick = btnAbrirIDEClick
    end
  end
  object memoScript: TIDEMemo
    Left = 0
    Top = 250
    Width = 1080
    Height = 394
    Cursor = crIBeam
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clGray
    Gutter.Font.Height = -13
    Gutter.Font.Name = 'Consolas'
    Gutter.Font.Style = []
    Gutter.ShowLineNumbers = True
    SyntaxStyles = PascalStyler
    TabOrder = 2
    TabStop = True
    UseStyler = True
    WordWrap = wwNone
    OnChange = memoScriptChange
  end
  object pnStatus: TPanel
    Left = 0
    Top = 644
    Width = 1080
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    Padding.Left = 12
    Padding.Right = 12
    TabOrder = 3
    object lbStatus: TLabel
      Left = 12
      Top = 0
      Width = 1056
      Height = 36
      Align = alClient
      AutoSize = False
      Caption = 'Carregando regra...'
      Layout = tlCenter
      WordWrap = True
    end
  end
  object IDEScripter1: TIDEScripter
    DefaultLanguage = slPascal
    SaveCompiledCode = False
    ShortBooleanEval = True
    OnCompileError = ScripterError
    OnRuntimeError = ScripterError
    Left = 760
    Top = 320
  end
  object IDEScripterDebug: TIDEScripter
    DefaultLanguage = slPascal
    SaveCompiledCode = False
    ShortBooleanEval = True
    Left = 888
    Top = 320
  end
  object IDEEngine1: TIDEEngine
    Scripter = IDEScripterDebug
    FileExtPascalUnit = '.psc'
    FileExtForm = '.sfm'
    ProjectExt = '.ssproj'
    AutoStyler = True
    Left = 760
    Top = 384
  end
  object IDEDialog1: TIDEDialog
    Engine = IDEEngine1
    Title = 'TMS Scripter - Depurar regra - %s'
    IDECloseAction = icaNothing
    ShowInTaskBar = True
    Left = 888
    Top = 384
  end
  object PascalStyler: TScrPascalMemoStyler
    AutoBlockEnd = True
    BlockStart = 'begin,try,case,class,record,interface,implementation'
    BlockEnd = 'end'
    LineComment = '//'
    MultiCommentLeft = '{'
    MultiCommentRight = '}'
    Left = 760
    Top = 448
  end
  object dlgAbrirScript: TOpenDialog
    DefaultExt = 'psc'
    Filter = 'Scripts Pascal (*.psc)|*.psc|Todos os arquivos (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Abrir regra de desconto'
    Left = 888
    Top = 448
  end
  object dlgSalvarScript: TSaveDialog
    DefaultExt = 'psc'
    Filter = 'Scripts Pascal (*.psc)|*.psc|Todos os arquivos (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Salvar regra de desconto em UTF-8'
    Left = 888
    Top = 512
  end
end
