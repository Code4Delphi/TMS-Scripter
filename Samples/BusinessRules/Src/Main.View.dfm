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
    DesignSize = (
      1080
      154)
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
        Width = 123
        Height = 17
        Caption = 'Valor do pedido (R$)'
      end
      object lbQuantidadeItens: TLabel
        Left = 216
        Top = 26
        Width = 118
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
        Width = 60
        Height = 17
        Caption = 'Percentual'
      end
      object lbDesconto: TLabel
        Left = 144
        Top = 26
        Width = 55
        Height = 17
        Caption = 'Desconto'
      end
      object lbTotal: TLabel
        Left = 312
        Top = 26
        Width = 56
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
    DesignSize = (
      1080
      96)
    object lbExemplo: TLabel
      Left = 16
      Top = 2
      Width = 145
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
    ActiveLineSettings.ShowActiveLine = False
    ActiveLineSettings.ShowActiveLineIndicator = False
    ActiveLineSettings.ActiveLineColor = 10066380
    ActiveLineSettings.ActiveLineTextColor = clBlack
    Align = alClient
    AutoCompletion.Font.Charset = DEFAULT_CHARSET
    AutoCompletion.Font.Color = clWindowText
    AutoCompletion.Font.Height = -12
    AutoCompletion.Font.Name = 'Segoe UI'
    AutoCompletion.Font.Style = []
    AutoCompletion.StartToken = '(.'
    AutoCorrect.Active = True
    AutoHintParameterPosition = hpBelowCode
    BkColor = clWindow
    BookmarkGlyph.Data = {
      36050000424D3605000000000000360400002800000010000000100000000100
      0800000000000001000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A6000020400000206000002080000020A0000020C0000020E000004000000040
      20000040400000406000004080000040A0000040C0000040E000006000000060
      20000060400000606000006080000060A0000060C0000060E000008000000080
      20000080400000806000008080000080A0000080C0000080E00000A0000000A0
      200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
      200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
      200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
      20004000400040006000400080004000A0004000C0004000E000402000004020
      20004020400040206000402080004020A0004020C0004020E000404000004040
      20004040400040406000404080004040A0004040C0004040E000406000004060
      20004060400040606000406080004060A0004060C0004060E000408000004080
      20004080400040806000408080004080A0004080C0004080E00040A0000040A0
      200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
      200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
      200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
      20008000400080006000800080008000A0008000C0008000E000802000008020
      20008020400080206000802080008020A0008020C0008020E000804000008040
      20008040400080406000804080008040A0008040C0008040E000806000008060
      20008060400080606000806080008060A0008060C0008060E000808000008080
      20008080400080806000808080008080A0008080C0008080E00080A0000080A0
      200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
      200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
      200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
      2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
      2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
      2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
      2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
      2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
      2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
      2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFD25252525
      2525252525252525FDFDFD2E25FFFFFFFFFFFFFFFFFFFF25FDFDFD2525252525
      2525252525252525FDFD9A9AB7B7B7B7B7B7B7B7B7B72525FDFDFD25B7B7B7B7
      B7B7B7B7B7B72525FDFD9A9AB7B7B7B7B7B7B7B7B7B72525FDFDFD25BFB7BFBF
      B7B7B7B7B7B72525FDFD9A9ABFBFBFB7BFBFB7B7B7B72525FDFDFD25BFBFBFBF
      BFB7BFBFB7B72525FDFD9A9ABFBFBFB7BFBFBFB7BFB72525FDFDFD25BFBFBFBF
      BFBFBFBFBFB72525FDFD9A9ABFBFBFBFBFB7BFBFB7B72525FDFDFD25BFBFBFBF
      BFBFBFBFBFB72525FDFD9A9ABFBFBFBFBFBFBFBFBFB725FDFDFDFD2525252525
      25252525252525FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD}
    BorderStyle = bsSingle
    BreakpointColor = 16762823
    BreakpointTextColor = clBlack
    ClipboardFormats = [cfText]
    CodeFolding.Enabled = False
    CodeFolding.LineColor = clGray
    Ctl3D = False
    DelErase = True
    EnhancedHomeKey = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -13
    Gutter.Font.Name = 'Consolas'
    Gutter.Font.Style = []
    Gutter.GutterColorTo = clBtnFace
    Gutter.LineNumberTextColor = clWindowText
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    HiddenCaret = False
    Lines.Strings = (
      '')
    MarkerList.UseDefaultMarkerImageIndex = False
    MarkerList.DefaultMarkerImageIndex = -1
    MarkerList.ImageTransparentColor = 33554432
    OleDropTarget = []
    PrintOptions.MarginLeft = 0
    PrintOptions.MarginRight = 0
    PrintOptions.MarginTop = 0
    PrintOptions.MarginBottom = 0
    PrintOptions.PageNr = False
    PrintOptions.PrintLineNumbers = False
    RightMarginColor = 14869218
    ScrollHint = False
    SelColor = clHighlightText
    SelBkColor = clHighlight
    ShowRightMargin = True
    SmartTabs = False
    SyntaxStyles = PascalStyler
    TabOrder = 2
    TabStop = True
    TrimTrailingSpaces = False
    UILanguage.ScrollHint = 'Row'
    UILanguage.Undo = 'Undo'
    UILanguage.Redo = 'Redo'
    UILanguage.Copy = 'Copy'
    UILanguage.Cut = 'Cut'
    UILanguage.Paste = 'Paste'
    UILanguage.Delete = 'Delete'
    UILanguage.SelectAll = 'Select All'
    UrlStyle.TextColor = clBlue
    UrlStyle.BkColor = clWhite
    UrlStyle.Style = [fsUnderline]
    UseStyler = True
    Version = '3.9.3.0'
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
    OnCompileError = ScripterError
    OnRuntimeError = ScripterError
    ShortBooleanEval = True
    LibOptions.SearchPath.Strings = (
      '$(CURDIR)'
      '$(APPDIR)')
    LibOptions.UseScriptFiles = False
    CallExecHookEvent = False
    Left = 760
    Top = 320
  end
  object IDEScripterDebug: TIDEScripter
    DefaultLanguage = slPascal
    SaveCompiledCode = False
    ShortBooleanEval = True
    LibOptions.SearchPath.Strings = (
      '$(CURDIR)'
      '$(APPDIR)')
    LibOptions.UseScriptFiles = False
    CallExecHookEvent = False
    Left = 888
    Top = 320
  end
  object IDEEngine1: TIDEEngine
    Scripter = IDEScripterDebug
    Options.AutoHideTabControl = True
    FileExtPascalUnit = '.psc'
    FileExtForm = '.sfm'
    FileExtBasicUnit = '.bsc'
    FileExtJavaScriptUnit = '.jsc'
    AutoStyler = True
    ProjectExt = '.ssproj'
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
    CommentStyle.TextColor = clNavy
    CommentStyle.BkColor = clNone
    CommentStyle.Style = [fsItalic]
    NumberStyle.TextColor = clFuchsia
    NumberStyle.BkColor = clNone
    NumberStyle.Style = [fsBold]
    HighlightStyle.TextColor = clWhite
    HighlightStyle.BkColor = clRed
    HighlightStyle.Style = [fsBold]
    AllStyles = <>
    AutoCompletion.Strings = (
      'ShowMessage'
      'MessageDlg')
    HintParameter.TextColor = clBlack
    HintParameter.BkColor = clInfoBk
    HintParameter.HintCharStart = '('
    HintParameter.HintCharEnd = ')'
    HintParameter.HintCharDelimiter = ';'
    HintParameter.HintClassDelimiter = '.'
    HintParameter.HintCharWriteDelimiter = ','
    HintParameter.Parameters.Strings = (
      'ShowMessage(const Msg: string);'
      
        'MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMs' +
        'gDlgButtons; HelpCtx: Longint): Integer);')
    HexIdentifier = '$'
    Description = 'Pascal'
    Filter = 'Pascal Files (*.pas,*.dpr,*.dpk,*.inc)|*.pas;*.dpr;*.dpk;*.inc'
    DefaultExtension = '.pas'
    StylerName = 'Pascal'
    Extensions = 'pas;dpr;dpk;inc'
    RegionDefinitions = <
      item
        Identifier = 'procedure'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'procedure'
        RegionEnd = 'forward'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'constructor'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'destructor'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'interface'
        RegionStart = 'interface'
        RegionType = rtOpen
        ShowComments = False
      end
      item
        Identifier = 'unit'
        RegionStart = 'unit'
        RegionType = rtFile
        ShowComments = False
      end
      item
        Identifier = 'implementation'
        RegionStart = 'implementation'
        RegionType = rtOpen
        ShowComments = False
      end
      item
        Identifier = 'case'
        RegionStart = 'case'
        RegionEnd = 'end'
        RegionType = rtIgnore
        ShowComments = False
      end
      item
        Identifier = 'try'
        RegionStart = 'try'
        RegionEnd = 'end'
        RegionType = rtIgnore
        ShowComments = False
      end
      item
        Identifier = 'function'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = '{$region'
        RegionStart = '{$region'
        RegionEnd = '{$endregion'
        RegionType = rtClosed
        ShowComments = False
      end>
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
