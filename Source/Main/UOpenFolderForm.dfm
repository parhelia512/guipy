object FOpenFolderForm: TFOpenFolderForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Open folder'
  ClientHeight = 337
  ClientWidth = 398
  Color = clBtnFace
  ParentFont = True
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    398
    337)
  TextHeight = 15
  object LFiletype: TLabel
    Left = 14
    Top = 279
    Width = 79
    Height = 15
    Anchors = [akLeft, akBottom]
    Caption = 'Select file type:'
  end
  object BOK: TButton
    Left = 211
    Top = 306
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object BCancel: TButton
    Left = 293
    Top = 306
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object CBFiletype: TComboBox
    Left = 108
    Top = 275
    Width = 69
    Height = 23
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    TabStop = False
    ExplicitTop = 274
  end
  object CBWithSubFolder: TCheckBox
    Left = 9
    Top = 310
    Width = 161
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'With &subfolders'
    Checked = True
    State = cbChecked
    TabOrder = 3
    ExplicitLeft = 5
    ExplicitTop = 309
  end
end
