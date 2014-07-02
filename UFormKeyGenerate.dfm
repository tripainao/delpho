object FmKeyGenerate: TFmKeyGenerate
  Left = 384
  Top = 209
  Width = 483
  Height = 210
  Caption = 'FmKeyGenerate'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 475
    Height = 183
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 40
      Top = 74
      Width = 39
      Height = 13
      Caption = 'Clave 1:'
    end
    object Label2: TLabel
      Left = 40
      Top = 102
      Width = 39
      Height = 13
      Caption = 'Clave 2:'
    end
    object Edit1: TEdit
      Left = 96
      Top = 72
      Width = 289
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 96
      Top = 96
      Width = 289
      Height = 21
      TabOrder = 1
    end
    object Button1: TButton
      Left = 128
      Top = 24
      Width = 241
      Height = 25
      Caption = 'Generar claves'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
end
