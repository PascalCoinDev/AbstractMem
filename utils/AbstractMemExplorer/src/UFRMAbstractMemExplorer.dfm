object FRMAbstractMemExplorer: TFRMAbstractMemExplorer
  Left = 0
  Top = 0
  Caption = 'FRMAbstractMemExplorer'
  ClientHeight = 298
  ClientWidth = 631
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 631
    Height = 43
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 627
    object lblFileName: TLabel
      Left = 97
      Top = 15
      Width = 53
      Height = 13
      Caption = 'lblFileName'
    end
    object bbSelectFilename: TButton
      Left = 16
      Top = 12
      Width = 75
      Height = 21
      Caption = 'Select File'
      TabOrder = 0
      OnClick = bbSelectFilenameClick
    end
  end
  object memoInfo: TMemo
    Left = 0
    Top = 43
    Width = 631
    Height = 255
    Align = alClient
    Lines.Strings = (
      'memoInfo')
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
    ExplicitWidth = 627
    ExplicitHeight = 254
  end
end
