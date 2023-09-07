inherited frmCustomKeyboard: TfrmCustomKeyboard
  Left = 306
  Top = 259
  HelpContext = 615
  Caption = 'Customize IDE Shortcuts'
  ClientHeight = 375
  ClientWidth = 455
  KeyPreview = True
  Position = poOwnerFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 467
  ExplicitHeight = 413
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 455
    Height = 375
    Align = alClient
    UseDockManager = False
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 451
    ExplicitHeight = 374
    DesignSize = (
      455
      375)
    object Bevel1: TBevel
      Left = 4
      Top = 329
      Width = 449
      Height = 2
      Anchors = [akLeft, akRight, akBottom]
      Shape = bsTopLine
      ExplicitTop = 330
      ExplicitWidth = 348
    end
    object lblNewShortcutKey: TLabel
      Left = 8
      Top = 205
      Width = 123
      Height = 15
      Caption = 'Press &new shortcut key:'
      Color = clNone
      ParentColor = False
    end
    object lblCategories: TLabel
      Left = 10
      Top = 9
      Width = 59
      Height = 15
      Caption = '&Categories:'
      Color = clNone
      ParentColor = False
    end
    object lblCommands: TLabel
      Left = 200
      Top = 9
      Width = 65
      Height = 15
      Caption = 'C&ommands:'
      Color = clNone
      ParentColor = False
    end
    object lblCurrent: TLabel
      Left = 8
      Top = 251
      Width = 115
      Height = 15
      Caption = 'Currently assigned to:'
      Color = clNone
      ParentColor = False
      Visible = False
    end
    object lblAssignedTo: TLabel
      Left = 8
      Top = 270
      Width = 73
      Height = 15
      Caption = 'lblAssignedTo'
      Color = clNone
      ParentColor = False
      Visible = False
    end
    object lblCurrentKeys: TLabel
      Left = 200
      Top = 205
      Width = 70
      Height = 15
      Caption = 'C&urrent Keys:'
      Color = clNone
      ParentColor = False
    end
    object btnOK: TButton
      Left = 196
      Top = 342
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 3
      ExplicitLeft = 192
      ExplicitTop = 341
    end
    object btnCancel: TButton
      Left = 280
      Top = 342
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 4
      ExplicitLeft = 276
      ExplicitTop = 341
    end
    object btnHelp: TButton
      Left = 364
      Top = 342
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Help'
      TabOrder = 8
      OnClick = HelpButtonClick
      ExplicitLeft = 360
      ExplicitTop = 341
    end
    object btnAssign: TButton
      Left = 8
      Top = 287
      Width = 107
      Height = 25
      Action = actAssignShortcut
      TabOrder = 6
    end
    object btnRemove: TButton
      Left = 192
      Top = 287
      Width = 97
      Height = 25
      Action = actRemoveShortcut
      TabOrder = 7
    end
    object lbCategories: TListBox
      Left = 10
      Top = 28
      Width = 184
      Height = 97
      ItemHeight = 15
      TabOrder = 1
      OnClick = lbCategoriesClick
    end
    object lbCommands: TListBox
      Left = 200
      Top = 28
      Width = 237
      Height = 97
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 15
      Sorted = True
      TabOrder = 2
      OnClick = lbCommandsClick
      ExplicitWidth = 233
    end
    object lbCurrentKeys: TListBox
      Left = 200
      Top = 224
      Width = 237
      Height = 57
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 15
      TabOrder = 5
      ExplicitWidth = 233
    end
    object gbDescription: TGroupBox
      Left = 10
      Top = 131
      Width = 429
      Height = 61
      Anchors = [akLeft, akTop, akRight]
      Caption = ' Description '
      TabOrder = 0
      ExplicitWidth = 425
      object lblDescription: TLabel
        Left = 2
        Top = 17
        Width = 425
        Height = 42
        Align = alClient
        AutoSize = False
        Color = clNone
        ParentColor = False
        Transparent = True
        ExplicitTop = 15
        ExplicitWidth = 324
        ExplicitHeight = 44
      end
    end
  end
  object ActionList1: TActionList
    Left = 304
    object actAssignShortcut: TAction
      Caption = '&Assign'
      Hint = 'Assign shortcut to command'
      OnExecute = btnAssignClick
      OnUpdate = actAssignShortcutUpdate
    end
    object actRemoveShortcut: TAction
      Caption = '&Remove'
      Hint = 'Remove shortcut'
      OnExecute = btnRemoveClick
      OnUpdate = actRemoveShortcutUpdate
    end
  end
end
