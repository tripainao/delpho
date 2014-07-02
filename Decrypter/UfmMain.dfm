object Form1: TForm1
  Left = 453
  Top = 248
  Width = 515
  Height = 149
  Caption = 'Decrypter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 83
    Height = 13
    Caption = 'Texto encriptado:'
  end
  object Label2: TLabel
    Left = 7
    Top = 83
    Width = 100
    Height = 13
    Caption = 'Texto desencriptado:'
  end
  object Button1: TButton
    Left = 8
    Top = 40
    Width = 137
    Height = 25
    Caption = 'Desencriptar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 112
    Top = 8
    Width = 393
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 112
    Top = 80
    Width = 393
    Height = 21
    TabOrder = 2
  end
end
