object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'TMS Scripter - Relat'#243'rios personalizados'
  ClientHeight = 540
  ClientWidth = 1100
  Color = clBtnFace
  Constraints.MinHeight = 440
  Constraints.MinWidth = 1000
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 17
  object pnAcoes: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 88
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lbInstrucao: TLabel
      Left = 12
      Top = 55
      Width = 1076
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'O Delphi prepara as vendas. O script define o t'#237'tulo e calcula a comiss'#227'o.'
    end
    object btnGerarRelatorio: TButton
      Left = 12
      Top = 12
      Width = 160
      Height = 32
      Caption = 'Gerar relat'#243'rio'
      TabOrder = 0
      OnClick = btnGerarRelatorioClick
    end
    object btnSalvarScript: TButton
      Left = 184
      Top = 12
      Width = 136
      Height = 32
      Caption = 'Salvar script'
      TabOrder = 1
      OnClick = btnSalvarScriptClick
    end
  end
  object pnConteudo: TPanel
    Left = 0
    Top = 88
    Width = 1100
    Height = 408
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 12
    Padding.Right = 12
    Padding.Bottom = 8
    TabOrder = 1
    object gBoxScript: TGroupBox
      Left = 12
      Top = 0
      Width = 490
      Height = 400
      Align = alLeft
      Caption = ' Script Pascal '
      Padding.Left = 8
      Padding.Top = 4
      Padding.Right = 8
      Padding.Bottom = 8
      TabOrder = 0
      object memoScript: TMemo
        Left = 10
        Top = 23
        Width = 470
        Height = 367
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        WantTabs = True
        WordWrap = False
        OnChange = memoScriptChange
      end
    end
    object splitterRelatorio: TSplitter
      Left = 502
      Top = 0
      Width = 8
      Height = 400
      MinSize = 280
    end
    object gBoxRelatorio: TGroupBox
      Left = 510
      Top = 0
      Width = 578
      Height = 400
      Align = alClient
      Caption = ' Relat'#243'rio de vendas '
      Padding.Left = 8
      Padding.Top = 4
      Padding.Right = 8
      Padding.Bottom = 8
      TabOrder = 1
      object memoRelatorio: TMemo
        Left = 10
        Top = 23
        Width = 558
        Height = 367
        Align = alClient
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object pnStatus: TPanel
    Left = 0
    Top = 496
    Width = 1100
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    Padding.Left = 12
    Padding.Right = 12
    TabOrder = 2
    object lbStatus: TLabel
      Left = 12
      Top = 0
      Width = 1076
      Height = 44
      Align = alClient
      AutoSize = False
      Layout = tlCenter
      WordWrap = True
    end
  end
  object Scripter: TatScripter
    DefaultLanguage = slPascal
    SaveCompiledCode = False
    ShortBooleanEval = True
    OnCompileError = ScripterError
    OnRuntimeError = ScripterError
    Left = 392
    Top = 12
  end
end
