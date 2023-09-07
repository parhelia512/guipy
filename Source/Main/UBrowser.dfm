object FBrowser: TFBrowser
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 336
  ClientWidth = 527
  Color = clBtnFace
  ParentFont = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 25
    Width = 527
    Height = 311
    Align = alClient
    TabOrder = 0
    SelectedEngine = EdgeIfAvailable
    OnCommandStateChange = WebBrowserCommandStateChange
    OnDownloadBegin = WebBrowserDownloadBegin
    OnDownloadComplete = WebBrowserDownloadComplete
    OnBeforeNavigate2 = WebBrowserBeforeNavigate2
    ControlData = {
      4C00000078360000252000000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object PBrowser: TPanel
    Left = 0
    Top = 0
    Width = 527
    Height = 25
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 523
    object PTop: TPanel
      Left = 188
      Top = 1
      Width = 338
      Height = 23
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 334
      object Splitter: TSplitter
        Left = 156
        Top = 0
        Width = 4
        Height = 23
        Beveled = True
      end
      object PLeft: TPanel
        Left = 0
        Top = 0
        Width = 156
        Height = 23
        Align = alLeft
        Constraints.MinWidth = 50
        TabOrder = 0
        DesignSize = (
          156
          23)
        object CBUrls: TComboBox
          Left = 0
          Top = 1
          Width = 156
          Height = 23
          Hint = 'Enter address'
          Anchors = [akLeft, akRight]
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = False
          OnClick = CBUrlsClick
          OnKeyDown = CBUrlsKeyDown
        end
      end
      object PRight: TPanel
        Left = 160
        Top = 0
        Width = 178
        Height = 23
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitWidth = 174
      end
    end
    object ToolBar: TToolBar
      Left = 1
      Top = 1
      Width = 187
      Height = 23
      Align = alLeft
      Caption = 'ToolBar'
      EdgeInner = esNone
      EdgeOuter = esNone
      Images = ILBrowser
      TabOrder = 1
      object TBClose: TToolButton
        Left = 0
        Top = 0
        Hint = 'Close'
        ImageIndex = 0
        ParentShowHint = False
        ShowHint = True
        OnClick = TBCloseClick
      end
      object TBShowSource: TToolButton
        Left = 23
        Top = 0
        Hint = 'Show source code'
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = TBShowSourceClick
      end
      object TBBack: TToolButton
        Left = 46
        Top = 0
        Hint = 'Back'
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = TBBackClick
      end
      object TBForward: TToolButton
        Left = 69
        Top = 0
        Hint = 'Forward'
        ImageIndex = 3
        ParentShowHint = False
        ShowHint = True
        OnClick = TBForwardClick
      end
      object TBStop: TToolButton
        Left = 92
        Top = 0
        Hint = 'Cancel loading'
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        OnClick = TBStopClick
      end
      object TBRefresh: TToolButton
        Left = 115
        Top = 0
        Hint = 'Reload'
        ImageIndex = 6
        ParentShowHint = False
        ShowHint = True
        OnClick = TBRefreshClick
      end
      object TBFavoritesAdd: TToolButton
        Left = 138
        Top = 0
        Hint = 'Add to favorites'
        ImageIndex = 7
        ParentShowHint = False
        ShowHint = True
        OnClick = TBFavoritesAddClick
      end
      object TBFavoritesDelete: TToolButton
        Left = 161
        Top = 0
        Hint = 'delete as favorite '
        ImageIndex = 8
        ParentShowHint = False
        ShowHint = True
        OnClick = TBFavoritesDeleteClick
      end
    end
  end
  object ILBrowser: TImageList
    Left = 24
    Top = 40
    Bitmap = {
      494C010109000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF000000000000FFFF000000000000FFFF000000
      000000FFFF000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF000000000000FFFF008400000000000000000000000000
      00008400000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00000000000000000000000000840000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF000000000000FFFF000000000084000000FFFFFF008400
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000FFFF00000000000000000000000000840000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FF000000FF00
      00000000000000FFFF000000000000FFFF008400000000000000000000000000
      00008400000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FF000000FF00
      0000000000000082840000828400008284000082840000828400008284000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00008200000082
      0000FFFFFF008486840000000000000000000000000000000000848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00008200000082
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00008200000082
      0000FFFFFF00FF000000FF000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004A4A4A004A4A4A004A4A4A004A4A4A004A4A4A004A4A4A000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000009C0000009C0000009C0000009C0000009C0000009C000000
      0000000000000000000000000000000000000000000084848400CED6D600CECE
      CE00CED6D600CECECE00CED6D600CECECE00CED6D600CECECE00CED6D600CECE
      CE00CED6D6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484006363
      63006363630063636300636363006363630063636300636363004A4A4A004A4A
      4A004A4A4A00000000000000000000000000000000000000000000009C000000
      CE000000CE000000CE000000CE000000CE000000CE000000CE0000009C000000
      9C0000009C000000000000000000000000000000000084848400FFFFFF00FFFF
      FF009CFFFF00FFFFFF009CFFFF00009C31009CFFFF00FFFFFF009CFFFF00FFFF
      FF00CED6D6000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF000000000000FFFF000000000000FFFF000000
      000000FFFF000000000000FFFF0000000000000000008484840063636300B5B5
      B500848484008484840084848400848484008484840063636300636363006363
      63004A4A4A004A4A4A0000000000000000000000000000009C000000CE000063
      FF003100FF003100FF003100FF003100FF003100FF000000CE000000CE000000
      CE0000009C0000009C0000000000000000000000000084848400FFFFFF009CFF
      FF00FFFFFF009CFFFF00009C3100009C3100FFFFFF009CFFFF00FFFFFF009CFF
      FF00CECECE000000000000000000000000000000000000000000000000000000
      00000000000000FFFF000000000000FFFF008400000000000000000000000000
      00008400000000FFFF0000000000000000000000000084848400CECECE00B5B5
      B500848484008484840084848400848484008484840084848400848484006363
      6300636363004A4A4A0000000000000000000000000000009C000063FF003100
      FF003100FF003100FF003100FF003100FF003100FF003100FF003100FF000000
      CE000000CE0000009C0000000000000000000000000084848400FFFFFF00FFFF
      FF009CFFFF00009C3100009C3100009C3100009C3100009C31009CFFFF00FFFF
      FF00CECECE000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00000000000000000000000000840000000000
      0000000000000000000000FFFF000000000084848400B5B5B500B5B5B5008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400636363004A4A4A004A4A4A000000000000009C006363FF000063FF003100
      FF003100FF003100FF003100FF003100FF003100FF003100FF003100FF003100
      FF000000CE0000009C0000009C00000000000000000084848400FFFFFF009CFF
      FF00FFFFFF009CFFFF00009C3100009C3100FFFFFF00639C0000636300009CFF
      FF00CED6D6000000000000000000000000000000000000000000000000000000
      00000000000000FFFF000000000000FFFF000000000084000000FFFFFF008400
      00000000000000FFFF00000000000000000084848400B5B5B500DEDEDE009C9C
      9C0084848400FFFFFF00FFFFFF008484840084848400FFFFFF00FFFFFF008484
      840063636300636363004A4A4A000000000000009C006363FF00319CFF003100
      FF003100FF00FFFFFF00FFFFFF003100FF003100FF00FFFFFF00FFFFFF003100
      FF000000CE000000CE0000009C00000000000000000084848400FFFFFF00FFFF
      FF009CFFFF00FFFFFF009CFFFF00009C31009CFFFF00FFFFFF0063630000FFFF
      FF00CECECE0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000FFFF00000000000000000000000000840000000000
      0000000000000000000000FFFF000000000084848400B5B5B500DEDEDE008484
      84008484840084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484008484
      840084848400636363004A4A4A000000000000009C006363FF00319CFF003100
      FF003100FF003100FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003100FF003100
      FF003100FF000000CE0000009C00000000000000000084848400FFFFFF009CFF
      FF00636300009CFFFF00FFFFFF009CFFFF00FFFFFF009CFFFF00636300009CFF
      FF00CECECE0000000000000000000000000000000000FFFFFF00FF000000FF00
      00000000000000FFFF000000000000FFFF008400000000000000000000000000
      00008400000000FFFF00000000000000000084848400B5B5B500DEDEDE00B5B5
      B500848484008484840084848400FFFFFF00FFFFFF0084848400848484008484
      840084848400636363004A4A4A000000000000009C006363FF00319CFF003100
      FF003100FF003100FF003100FF00FFFFFF00FFFFFF003100FF003100FF003100
      FF003100FF000000CE0000009C00000000000000000084848400FFFFFF00FFFF
      FF0063630000FFFFFF009CFFFF00009C31009CFFFF00FFFFFF009CFFFF00FFFF
      FF00CED6D60000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000000084848400B5B5B500DEDEDE00CECE
      CE008484840084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484008484
      840084848400636363004A4A4A000000000000009C006363FF00319CFF000063
      FF003100FF003100FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003100FF003100
      FF003100FF000000CE0000009C00000000000000000084848400FFFFFF009CFF
      FF0063630000639C0000FFFFFF00009C3100009C31009CFFFF00FFFFFF009CFF
      FF00CECECE0000000000000000000000000000000000FFFFFF00FF000000FF00
      0000000000000084840000848400008484000084840000848400008484000000
      00000000000000000000000000000000000084848400B5B5B500DEDEDE00B5B5
      B50084848400FFFFFF00FFFFFF008484840084848400FFFFFF00FFFFFF008484
      840084848400636363004A4A4A000000000000009C006363CE00319CFF000063
      FF003100FF00FFFFFF00FFFFFF003100FF003100FF00FFFFFF00FFFFFF003100
      FF003100FF000000CE0000009C00000000000000000084848400FFFFFF00FFFF
      FF009CFFFF00009C3100009C3100009C3100009C3100009C31009CFFFF00FFFF
      FF00CECECE0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400B5B5B500DEDE
      DE00CECECE008484840084848400848484008484840084848400848484008484
      8400848484006363630000000000000000000000000000009C006363FF00319C
      FF000063FF003100FF003100FF003100FF003100FF003100FF003100FF003100
      FF003100FF000000CE0000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00009C3100009C31009CFFFF00FFFFFF00CECE
      CE00CED6D60000000000000000000000000000000000FFFFFF00008400000084
      0000FFFFFF008484840000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000084848400B5B5B500DEDE
      DE00DEDEDE00CECECE00B5B5B500848484008484840084848400848484008484
      8400848484004A4A4A0000000000000000000000000000009C006363CE00319C
      FF00319CFF000063FF000063FF003100FF003100FF003100FF003100FF003100
      FF003100FF0000009C0000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00009C31009CFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00008400000084
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009C9C9C00B5B5
      B500B5B5B500DEDEDE00DEDEDE00CECECE00B5B5B50084848400848484008484
      840063636300000000000000000000000000000000000000000000009C006363
      CE006363FF00319CFF00319CFF000063FF000063FF003100FF003100FF003100
      FF000000CE000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009CFFFF00FFFFFF009CFFFF0084848400FFFF
      FF000000000000000000000000000000000000000000FFFFFF00008400000084
      0000FFFFFF00FF000000FF000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      840084848400B5B5B500B5B5B500B5B5B500B5B5B500B5B5B500848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      9C0000009C006363CE006363FF006363FF006363FF006363FF000000CE000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400848484008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000009C0000009C0000009C0000009C0000009C0000009C000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080005555
      5500555555005555550055555500555555005555550055555500555555005555
      5500555555005555550000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FEFE
      FE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FEFE
      FE00800000008000000080000000800000008000000080000000800000008000
      000080000000FEFEFE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00800000008000000080000000800000008000000080000000800000008000
      000080000000FFFFFF0000000000000000000000000000000000000000000000
      000000000000FF98300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF6331000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FF983000FF98300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF9C3100FF63
      3100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF00FFFFFF000000000000000000000000000000000000000000FF98
      3000FFC83000FF983000FF983000FF983000FF983000FF983000FF983000FF98
      3000FF6030000000000000000000000000000000000000000000FF633100FF9C
      3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FFCE
      3100FF6331000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FF603000FFFF
      9800FFFF9800FFFF9800FFFF9800FFFF9800FFFF9800FFFF9800FFFF9800FFFF
      9800FF6030000000000000000000000000000000000000000000FF633100FFFF
      CE00FFFFCE00FFFFCE00FFFFCE00FFFFCE00FFFFCE00FFFFCE00FFFFCE00FFFF
      9C00FFCE31000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00800000008000000080000000800000008000000080000000800000008000
      000080000000FFFFFF000000000000000000000000000000000000000000FF60
      3000FFFF9800FFFF980000000000FF603000FF603000FF603000FF603000FF60
      3000FF6030000000000000000000000000000000000000000000FF633100FF63
      3100FF633100FF633100FF633100FF633100FF633100FF633100FFFFCE00FFCE
      3100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FF603000FFFF980000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF633100FFCE31000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FF60300000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF633100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF008000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF633100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000F000000000000000
      F154000000000000F252000000000000F18C0000000000000202000000000000
      018C000000000000025200000000000000000000000000000000000000000000
      01DF000000000000001F000000000000007F0000000000000060000000000000
      007F000000000000007F000000000000F81FF81F8003FFFFE007E0078003F000
      C003C0038003F154800180018003F252800180018003F18C0000000080030202
      000000008003018C000000008003025200000000800300000000000080030000
      00000000800301DF800180018003001B800180018003007BC003C00380070060
      E007E007800F007BF81FF81F801F007BFFFFFFFFFFFFFFFFFFFFC001FFFFFFFF
      FFFFC001FFFFFFFFFFFFC001FDFFFFBFFFFFC001F9FFFF9FF3CFC001F1FFFF8F
      F99FC001E007C007FC3FC001C007C003FE7FC001C007C003FC3FC001E007C007
      F99FC001F1FFFF8FF3CFC001F9FFFF9FFFFFC001FDFFFFBFFFFFC001FFFFFFFF
      FFFFC001FFFFFFFFFFFFC001FFFFFFFF00000000000000000000000000000000
      000000000000}
  end
end
