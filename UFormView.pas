//-----------------------------------------------------
{$I ATViewerOptions.inc} //ATViewer options
{$I ATStreamSearchOptions.inc} //ATStreamSearch options
{$I Compilers.inc} //Compilers defines
{$I ViewerOptions.inc} //UV options

unit UFormView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, ImgList, IniFiles,
  TntClasses, TntForms, TntDialogs,
  ATBinHex, ATViewer, ATxCodepages, WLXProc,
  ATxNextFile, ATxToolbarList, ATxUserTools, ATxIniFile,
  UFormViewToolList,
  ToolWin, VistaAltFixUnit, XPMan, Grids, ValEdit, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit,

  ScktComp, SBSimpleSftp, SBSftpCommon,
  SBSSHConstants, SBSSHKeyStorage, SBUtils, ShlObj, cxShellCommon,
  cxMaskEdit, cxDropDownEdit, cxShellComboBox, cxShellListView, urut;

const
  cViewerVersion = '4.3.0';
  cViewerDate = '3 sep 2009';

const
  cToolbarListDefault =
    'FileOpen FileSaveAs Sep ' +
    'FileRename FileDelete Sep ' +
    'FilePrev FileNext Sep ' +
    'EditCopy EditFind EditFindNext Sep ' +
    'ViewShowNav ViewImageFit ViewFullScreen Sep ' +
    'ViewZoomIn ViewZoomOut ViewZoomOriginal Sep ' +
    'OptionsConfigure OptionsPlugins Sep ' +
    'UserTool1 UserTool2 UserTool3 UserTool4';

const
  EM_DISPLAYBAND = WM_USER + 51;
type

  TName = class
    public
      name: string;
  end;

  ve=class(TValueListEditor);

  TRecentMenus = array[0..9] of TMenuItem;
  TPluginsList = array[1..WlxPluginsMaxCount] of record
    FFileName: TWlxFilename;
    FDetectStr: string;
    FEnabled: boolean;
  end;

  TViewerGotoMode = (
    vgPercent,
    vgLine,
    vgHex,
    vgDec,
    vgSelStart,
    vgSelEnd);

type
  TFormViewUV = class(TTntForm)
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuView: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuSep: TMenuItem;
    mnuFileOpen: TMenuItem;
    N2: TMenuItem;
    mnuViewTextOEM: TMenuItem;
    mnuViewTextANSI: TMenuItem;
    mnuViewTextWrap: TMenuItem;
    mnuViewImageFit: TMenuItem;
    mnuEdit: TMenuItem;
    mnuEditFind: TMenuItem;
    mnuEditFindNext: TMenuItem;
    N4: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditSelectAll: TMenuItem;
    mnuFileClose: TMenuItem;
    mnuHelp: TMenuItem;
    mnuHelpAbout: TMenuItem;
    mnuViewWebOffline: TMenuItem;
    N5: TMenuItem;
    mnuFilePrint: TMenuItem;
    mnuFilePrintSetup: TMenuItem;
    mnuFilePrintPreview: TMenuItem;
    N6: TMenuItem;
    mnuOptionsConfigure: TMenuItem;
    mnuFileReload: TMenuItem;
    mnuFileSaveAs: TMenuItem;
    N7: TMenuItem;
    mnuEditGoto: TMenuItem;
    N8: TMenuItem;
    mnuFilePrev: TMenuItem;
    mnuFileNext: TMenuItem;
    mnuOptionsPlugins: TMenuItem;
    mnuEditCopyHex: TMenuItem;
    ImageList1: TImageList;
    mnuViewAlwaysOnTop: TMenuItem;
    mnuViewFullScreen: TMenuItem;
    mnuOptions: TMenuItem;
    mnuFileOpenRecent: TMenuItem;
    mnuRecent0: TMenuItem;
    mnuRecent1: TMenuItem;
    mnuRecent2: TMenuItem;
    mnuRecent3: TMenuItem;
    mnuRecent4: TMenuItem;
    mnuRecent5: TMenuItem;
    mnuRecent6: TMenuItem;
    mnuRecent7: TMenuItem;
    mnuRecent8: TMenuItem;
    mnuRecent9: TMenuItem;
    N9: TMenuItem;
    mnuRecentClear: TMenuItem;
    MenuRecents: TPopupMenu;
    mnuBarRecent0: TMenuItem;
    mnuBarRecent1: TMenuItem;
    mnuBarRecent2: TMenuItem;
    mnuBarRecent3: TMenuItem;
    mnuBarRecent4: TMenuItem;
    mnuBarRecent5: TMenuItem;
    mnuBarRecent6: TMenuItem;
    mnuBarRecent7: TMenuItem;
    mnuBarRecent8: TMenuItem;
    mnuBarRecent9: TMenuItem;
    mnuViewMode8: TMenuItem;
    mnuViewMode7: TMenuItem;
    mnuViewMode6: TMenuItem;
    mnuViewMode5: TMenuItem;
    mnuViewMode4: TMenuItem;
    mnuViewMode3: TMenuItem;
    mnuViewMode2: TMenuItem;
    mnuViewMode1: TMenuItem;
    mnuViewImageMenu: TMenuItem;
    Toolbar: TToolBar;
    ToolButton4: TToolButton;
    mnuUserTool1: TMenuItem;
    mnuUserTool2: TMenuItem;
    mnuUserTool3: TMenuItem;
    mnuUserTool4: TMenuItem;
    mnuUserTool5: TMenuItem;
    mnuUserTool6: TMenuItem;
    mnuUserTool7: TMenuItem;
    mnuUserTool8: TMenuItem;
    MenuToolbar: TPopupMenu;
    mnuToolbarCustomize: TMenuItem;
    N1: TMenuItem;
    mnuOptionsToolbar: TMenuItem;
    mnuViewImageGrayscale: TMenuItem;
    mnuViewImageRotateLeft: TMenuItem;
    mnuViewImageRotateRight: TMenuItem;
    mnuViewTextMenu: TMenuItem;
    N3: TMenuItem;
    mnuViewWebMenu: TMenuItem;
    N12: TMenuItem;
    mnuViewWebGoBack: TMenuItem;
    mnuViewWebGoForward: TMenuItem;
    mnuViewImageFitOnlyBig: TMenuItem;
    mnuHelpWebMenu: TMenuItem;
    mnuHelpWebHomepage: TMenuItem;
    mnuHelpWebEmail: TMenuItem;
    N14: TMenuItem;
    mnuFileDelete: TMenuItem;
    mnuOptionsUserTools: TMenuItem;
    N15: TMenuItem;
    mnuViewImageShowLabel: TMenuItem;
    mnuTools: TMenuItem;
    mnuViewImageCenter: TMenuItem;
    TimerShow: TTimer;
    mnuViewInterfaceMenu: TMenuItem;
    mnuViewShowMenu: TMenuItem;
    mnuViewShowToolbar: TMenuItem;
    mnuViewShowStatusbar: TMenuItem;
    N16: TMenuItem;
    mnuOptionsAdvanced: TMenuItem;
    mnuOptionsEditIni: TMenuItem;
    mnuViewZoomMenu: TMenuItem;
    mnuViewZoomOut: TMenuItem;
    mnuViewZoomIn: TMenuItem;
    mnuViewZoomOriginal: TMenuItem;
    mnuViewImageFitWindow: TMenuItem;
    MenuImage: TPopupMenu;
    mnuImageFit: TMenuItem;
    mnuImageFitOnlyBig: TMenuItem;
    mnuImageCenter: TMenuItem;
    N17: TMenuItem;
    mnuImageFitWindow: TMenuItem;
    N18: TMenuItem;
    mnuImageRotateRight: TMenuItem;
    mnuImageRotateLeft: TMenuItem;
    mnuImageGrayscale: TMenuItem;
    mnuImageShowLabel: TMenuItem;
    mnuViewShowNav: TMenuItem;
    mnuHelpWebPlugins: TMenuItem;
    ViewerPanel: TPanel;
    Viewer: TATViewer;
    StatusBar1: TStatusBar;
    mnuViewMediaPlayPause: TMenuItem;
    mnuViewMediaVolumeUp: TMenuItem;
    mnuViewMediaVolumeDown: TMenuItem;
    mnuViewMediaVolumeMute: TMenuItem;
    mnuOptionsEditIniHistory: TMenuItem;
    mnuFileRename: TMenuItem;
    mnuHelpContents: TMenuItem;
    mnuFileCopy: TMenuItem;
    mnuFileMove: TMenuItem;
    mnuOptionsSavePos: TMenuItem;
    mnuFileProp: TMenuItem;
    mnuViewImageNegative: TMenuItem;
    mnuViewImageFlipVert: TMenuItem;
    mnuViewImageFlipHorz: TMenuItem;
    mnuImageFlipHorz: TMenuItem;
    mnuImageFlipVert: TMenuItem;
    mnuImageNegative: TMenuItem;
    mnuViewTextKOI8: TMenuItem;
    mnuViewTextEBCDIC: TMenuItem;
    mnuViewTextMac: TMenuItem;
    mnuViewTextEncSubmenu: TMenuItem;
    mnuViewTextEncMenu: TMenuItem;
    N19: TMenuItem;
    mnuViewTextEncNext: TMenuItem;
    mnuViewTextEncPrev: TMenuItem;
    N21: TMenuItem;
    mnuViewTextISO: TMenuItem;
    mnuViewTextNonPrint: TMenuItem;
    mnuViewTextTail: TMenuItem;
    mnuEditCopyToFile: TMenuItem;
    mnuEditFindPrev: TMenuItem;
    ImageListS: TImageList;
    mnuViewImageShowEXIF: TMenuItem;
    mnuImageShowEXIF: TMenuItem;
    mnuViewMediaEffect: TMenuItem;
    mnuViewMediaPlayback: TMenuItem;
    N11: TMenuItem;
    mnuViewMediaLoop: TMenuItem;
    mnuEditPaste: TMenuItem;
    N22: TMenuItem;
    mnuFileEmail: TMenuItem;
    MenuModes: TPopupMenu;
    mnuModes1: TMenuItem;
    mnuModes2: TMenuItem;
    mnuModes3: TMenuItem;
    mnuModes4: TMenuItem;
    mnuModes5: TMenuItem;
    mnuModes6: TMenuItem;
    mnuModes7: TMenuItem;
    mnuModes8: TMenuItem;
    mnuViewModeMenu: TMenuItem;
    mnuFileCopyFN: TMenuItem;
    N25: TMenuItem;
    mnuBarRecentClear: TMenuItem;
    XPManifest1: TXPManifest;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    cboTipoArchivo: TComboBox;
    valEditor: TValueListEditor;
    Button2: TButton;
    SftpClient: TElSimpleSFTPClient;
    Panel2: TPanel;
    Memo1: TMemo;
    pbProgress: TProgressBar;
    Generarcdigo1: TMenuItem;
    Subirarchivosencache1: TMenuItem;
    Timer1: TTimer;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);
    procedure mnuViewMode3Click(Sender: TObject);
    procedure mnuViewMode2Click(Sender: TObject);
    procedure mnuViewMode1Click(Sender: TObject);
    procedure mnuViewMode4Click(Sender: TObject);
    procedure mnuViewMode6Click(Sender: TObject);
    procedure mnuViewTextOEMClick(Sender: TObject);
    procedure mnuViewTextANSIClick(Sender: TObject);
    procedure mnuViewTextWrapClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuViewImageFitClick(Sender: TObject);
    procedure mnuEditFindClick(Sender: TObject);
    procedure mnuEditFindNextClick(Sender: TObject);
    procedure mnuEditCopyClick(Sender: TObject);
    procedure mnuEditSelectAllClick(Sender: TObject);
    procedure mnuFileCloseClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure mnuViewMode5Click(Sender: TObject);
    procedure mnuViewWebOfflineClick(Sender: TObject);
    procedure mnuFilePrintClick(Sender: TObject);
    procedure mnuFilePrintPreviewClick(Sender: TObject);
    procedure mnuFilePrintSetupClick(Sender: TObject);
    procedure mnuOptionsConfigureClick(Sender: TObject);
    procedure mnuFileReloadClick(Sender: TObject);
    procedure mnuFileSaveAsClick(Sender: TObject);
    procedure mnuEditGotoClick(Sender: TObject);
    procedure mnuFilePrevClick(Sender: TObject);
    procedure mnuFileNextClick(Sender: TObject);
    procedure mnuViewMode7Click(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
    procedure mnuOptionsPluginsClick(Sender: TObject);
    procedure WMDropFiles(var Message: TWMDROPFILES); message WM_DROPFILES;
    procedure mnuEditCopyHexClick(Sender: TObject);
    procedure mnuViewMode8Click(Sender: TObject);
    procedure mnuViewAlwaysOnTopClick(Sender: TObject);
    procedure mnuViewFullScreenClick(Sender: TObject);
    procedure mnuRecent0Click(Sender: TObject);
    procedure mnuRecentClearClick(Sender: TObject);
    procedure btnImageRotate90Click(Sender: TObject);
    procedure btnImageRotate270Click(Sender: TObject);
    procedure btnImageNegativeClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuToolbarCustomizeClick(Sender: TObject);
    procedure mnuViewImageGrayscaleClick(Sender: TObject);
    procedure mnuViewWebGoBackClick(Sender: TObject);
    procedure mnuViewWebGoForwardClick(Sender: TObject);
    procedure mnuViewImageFitOnlyBigClick(Sender: TObject);
    procedure mnuHelpWebHomepageClick(Sender: TObject);
    procedure mnuHelpWebEmailClick(Sender: TObject);
    procedure mnuFileDeleteClick(Sender: TObject);
    procedure mnuOptionsUserToolsClick(Sender: TObject);
    procedure ViewerTextFileReload(Sender: TObject);
    procedure ViewerMediaPlaybackEnd(Sender: TObject);
    procedure ViewerPluginsAfterLoading(const APluginName: string);
    procedure ViewerPluginsBeforeLoading(const APluginName: string);
    procedure mnuViewImageShowLabelClick(Sender: TObject);
    procedure mnuViewImageCenterClick(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure mnuViewShowMenuClick(Sender: TObject);
    procedure mnuViewShowToolbarClick(Sender: TObject);
    procedure mnuViewShowStatusbarClick(Sender: TObject);
    procedure mnuOptionsEditIniClick(Sender: TObject);
    procedure mnuViewZoomInClick(Sender: TObject);
    procedure mnuViewZoomOutClick(Sender: TObject);
    procedure mnuViewZoomOriginalClick(Sender: TObject);
    procedure mnuViewImageFitWindowClick(Sender: TObject);
    procedure ViewerFileUnload(Sender: TObject);
    procedure mnuViewShowNavClick(Sender: TObject);
    procedure mnuHelpWebPluginsClick(Sender: TObject);
    procedure mnuViewMediaPlayPauseClick(Sender: TObject);
    procedure mnuViewMediaVolumeUpClick(Sender: TObject);
    procedure mnuViewMediaVolumeDownClick(Sender: TObject);
    procedure mnuViewMediaVolumeMuteClick(Sender: TObject);
    procedure mnuOptionsEditIniHistoryClick(Sender: TObject);
    procedure mnuFileRenameClick(Sender: TObject);
    procedure mnuHelpContentsClick(Sender: TObject);
    procedure mnuFileCopyClick(Sender: TObject);
    procedure mnuFileMoveClick(Sender: TObject);
    procedure mnuOptionsSavePosClick(Sender: TObject);
    procedure mnuFilePropClick(Sender: TObject);
    procedure mnuViewImageNegativeClick(Sender: TObject);
    procedure mnuViewImageFlipVertClick(Sender: TObject);
    procedure mnuViewImageFlipHorzClick(Sender: TObject);
    procedure mnuViewTextKOI8Click(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuViewTextEBCDICClick(Sender: TObject);
    procedure mnuViewTextMacClick(Sender: TObject);
    procedure mnuViewTextEncMenuClick(Sender: TObject);
    procedure mnuViewTextEncPrevClick(Sender: TObject);
    procedure mnuViewTextEncNextClick(Sender: TObject);
    procedure mnuViewTextISOClick(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure mnuViewTextNonPrintClick(Sender: TObject);
    procedure mnuViewTextTailClick(Sender: TObject);
    procedure mnuEditCopyToFileClick(Sender: TObject);
    procedure mnuRecent0MeasureItem(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer);
    procedure mnuRecent0DrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);
    procedure mnuEditFindPrevClick(Sender: TObject);
    procedure mnuUserTool1Click(Sender: TObject);
    procedure mnuUserTool2Click(Sender: TObject);
    procedure mnuUserTool3Click(Sender: TObject);
    procedure mnuUserTool4Click(Sender: TObject);
    procedure mnuUserTool5Click(Sender: TObject);
    procedure mnuUserTool6Click(Sender: TObject);
    procedure mnuUserTool7Click(Sender: TObject);
    procedure mnuUserTool8Click(Sender: TObject);
    procedure mnuViewImageShowEXIFClick(Sender: TObject);
    procedure mnuViewMediaLoopClick(Sender: TObject);
    procedure mnuEditPasteClick(Sender: TObject);
    procedure mnuFileEmailClick(Sender: TObject);
    procedure mnuViewModeMenuClick(Sender: TObject);
    procedure mnuFileCopyFNClick(Sender: TObject);
    procedure cboTipoArchivoChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SftpClientKeyValidate(Sender: TObject; ServerKey: TElSSHKey;
      var Validate: Boolean);
    procedure valEditorKeyPress(Sender: TObject; var Key: Char);
    procedure Generarcdigo1Click(Sender: TObject);
    procedure Subirarchivosencache1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    OpenDialog1: TTntOpenDialog;
    SaveDialog1: TTntSaveDialog;

    //Ini
    FIniName: WideString;
    FIniNameHist: WideString;
    FIniNameLS: AnsiString;
    FIni: TATIniFile;
    FIniHist: TATIniFile;
    FIniSave: TATIniFileSave;
    FIniHistSave: TATIniFileSave;

    //Fields
    FFileName: WideString;
    FFileFolder: WideString;
    FFileFolderSave: WideString;
    FPicture: TPicture;

    FIconsName: string;
    FSingleInstance: boolean;
    FShowMenu: boolean;
    FShowStatusBar: boolean;
    FShowFullScreen: boolean;
    FShowNoFindError: boolean;
    FShowNoFindReset: boolean;
    FShowFindSelection: boolean;
    FFileNextMsg: boolean;
    FFileMoveDelay: integer;
    FResolveLinks: boolean;

    FViewerTitle: integer;
    FViewerMode: integer; //0, 1..8
    FViewerOptPage: integer;

    FFindHistory: TTntStringList;
    FFindText: WideString;
    FFindWords: boolean;
    FFindCase: boolean;
    FFindBack: boolean;
    FFindHex: boolean;
    FFindRegex: boolean;
    FFindMLine: boolean;
    FFindOrigin: boolean;
    FGotoMode: TViewerGotoMode;

    FSaveRecents: boolean;
    FSavePosition: boolean;
    FSaveSearch: boolean;
    FSaveFolder: boolean;

    FPluginsTotalcmdVar: boolean;
    FPluginsHideKeys: boolean;

    FMediaAutoAdvance: boolean;
    FMediaFitWindow: boolean;
    FImageLabelVisible: boolean;
    FImageLabelColor: TColor;
    FImageLabelColorErr: TColor;

    FQuickViewMode: boolean; //Set by /Q cmd param
    FNoTaskbarIcon: boolean;
    FBoundsRectOld: TRect;
    FActivateBusy: boolean;

    //Other fields
    FFileList: TATFileList;
    FRecentList: TTntStringList;
    FToolbarList: TToolbarList;
    FRecentMenus: TRecentMenus;
    FRecentMenusBar: TRecentMenus;
    FUserTools: TATUserTools;
    FFormFindProgress: TForm;
    FPluginsList: TPluginsList;
    FPluginsNum: integer;

{$IFDEF CMDLINE}
    FStartupPosDo: boolean;
    FStartupPosLine: boolean;
    FStartupPosPercent: boolean;
    FStartupPos: Int64;
    FStartupPrint: boolean;
    FNavHandle: THandle;
{$ENDIF}

    (*-----------------------------------------------------------------------*)

    appActive: boolean;

    fLastHeight, fLastWidth, fLastScale: Integer;

    fslTipoDocs: TStringList;
    fFilesOkList: TStringList;
    FKeyStorage: TElSSHMemoryKeyStorage;
    fhost, fport, fuser, fpass, flocalbackup, fremotedir, flocaldir,
    flocalbackupdate, fcompany: string;

    FEmpleadoRutLen, FEmpleadoCCostoLen, FEmpleadoCajaLen, FDocFechaCCostoLen, FDocFechaRutLen: Word;

    procedure Init;
    function ShowFirstFile(rootdir: string): boolean;
    procedure RefreshDirCombo;
    procedure InitComboTipoArchivo;
    procedure ClearValEditor;
    procedure SendDirFiles(sourceDir, remoteDir, backUpDir, name: string);
    procedure SendFile(localfile, remoteDir, remoteFile: string);

    procedure SendFilesInList;
    function doGetfileNameOk(): String;
    procedure ResetValueList;

    procedure SaveOkListToCache();
    procedure LoadCacheToOkList();
    procedure UploadCache();

    function SFTPConnect(host, port, user, pass: string): boolean;
    function IsValidFieldGroup: boolean;
    function IsValid: boolean;
    function getNamefromValEditor: string;

    (*-----------------------------------------------------------------------*)

    procedure InitConfigs;
    procedure SetIconsName(const Name: string);
    function IsImageListSaved: boolean;
    function SCollapseVars(const fn: string): string;
    function SelTextShort: WideString;
    function TextNotSelected: boolean;
    procedure ViewerStatusTextChange(Sender: TObject; const Text: WideString);
    procedure ViewerTitleChange(Sender: TObject; const Text: WideString);
    procedure UpdateOptions(AUpdateFitWindow: boolean = false);
    procedure UpdateImageLabel;
    procedure UpdateStatusBar;
    procedure UpdateCaption(const APluginName: string = '';
      ABeforeLoading: boolean = true;
      const AWebTitle: WideString = '');
    procedure UpdateFitWindow(AUseOriginalImageSizes: boolean);
    procedure ReloadFile;
    procedure ReopenFile;
    procedure CloseFile(AKeepList: boolean = false);
    procedure LoadOptions;
    procedure SavePosition;
    procedure SaveOptionsInt;
    procedure SaveOptionsDlg;
    procedure LoadMargins;
    procedure SaveMargins;
    procedure LoadUserTools;
    procedure SaveUserTools;
    procedure ApplyUserTools;
    procedure LoadToolbar;
    procedure SaveToolbar;
    procedure ApplyToolbar;
    procedure ApplyToolbarCaptions;
    procedure InitPlugins;
    procedure LoadPluginsOptions;
    procedure SavePluginsOptions;
    procedure ResizePlugin;
    function PluginPresent(const AFileName: TWlxFilename): boolean;
    function RecentItemIndex(Sender: TObject): integer;

{$IFDEF CMDLINE}
    function ReadCommandLine: WideString;
    function ActiveFileName: WideString;
    function GetShowNav: boolean;
    procedure SetShowNav(AValue: boolean);
    property ShowNav: boolean read GetShowNav write SetShowNav;
    procedure NavSync;
    procedure NavMove;
{$ENDIF}

    procedure AppOnActivate(Sender: TObject);
    procedure AppOnMessage(var Msg: TMsg; var Handled: boolean);
    procedure LoadShortcuts;
    procedure SaveShortcuts;
    procedure LoadRecents;
    procedure SaveRecents;
    procedure ApplyRecents;
    procedure ClearRecents;
    procedure LoadSearch;
    procedure SaveSearch;
    procedure ClearSearch;
    procedure AddRecent(const S: WideString);
    function GetShowOnTop: boolean;
    procedure SetShowOnTop(AValue: boolean);
    function GetShowHidden: boolean;
    procedure SetShowHidden(AValue: boolean);
    procedure SetShowFullScreen(AValue: boolean);
    function GetShowToolbar: boolean;
    procedure SetShowToolbar(AValue: boolean);
    function GetShowBorder: boolean;
    procedure SetShowBorder(AValue: boolean);
    procedure SetShowMenu(AValue: boolean);
    function GetShowMenuIcons: boolean;
    procedure SetShowMenuIcons(AValue: boolean);
    function GetEnableMenu: boolean;
    procedure SetEnableMenu(AValue: boolean);
    procedure DoUserToolActions1(const Tool: TATUserTool);
    procedure DoUserToolActions2(const Tool: TATUserTool);
    procedure SearchPrepareAndStart;
    procedure InitFormFindProgress;
    procedure InitPreview;
    function GetStatusVisible: boolean;
    function GetFollowTail: boolean;
    procedure SetFollowTail(AValue: boolean);
    procedure ViewerOptionsChange(ASender: TObject);
    procedure UpdateShortcuts;
    procedure DoFindFirst;
    procedure DoFindNext(AFindPrevious: boolean = false);
    procedure DoUserTool(AIndex: integer);

    function GetImageBorderWidth: Integer;
    function GetImageBorderHeight: Integer;
    function GetImageWidthActual: Integer;
    function GetImageHeightActual: Integer;
    function GetImageWidthActual2: Integer;
    function GetImageHeightActual2: Integer;
    function GetImageScrollVisible: Boolean;
    procedure SetImageScrollVisible(AValue: Boolean);

    property MediaFitWindow: boolean read FMediaFitWindow write FMediaFitWindow;
    property ImageBorderWidth: integer read GetImageBorderWidth;
    property ImageBorderHeight: integer read GetImageBorderHeight;
    property ImageWidthActual: integer read GetImageWidthActual;
    property ImageWidthActual2: integer read GetImageWidthActual2;
    property ImageHeightActual: integer read GetImageHeightActual;
    property ImageHeightActual2: integer read GetImageHeightActual2;
    property ImageScrollVisible: boolean read GetImageScrollVisible write
      SetImageScrollVisible;
    procedure DoFileRename;
    procedure DoFileCopy;
    procedure DoFileMove;
    function IsMHT: boolean;

  public
    { Public declarations }
    function LoadArc(const AFileName: WideString): boolean;
    function LoadFile(
      const AFileName: WideString;
      AKeepList: boolean = false;
      APicture: TPicture = nil): boolean;
    property FileName: WideString read FFileName write FFileName;
    property FileFolder: WideString read FFileFolder write FFileFolder;
    property Picture: TPicture read FPicture write FPicture;
    property IconsName: string read FIconsName write SetIconsName;
    property ShowOnTop: boolean read GetShowOnTop write SetShowOnTop;
    property ShowFullScreen: boolean read FShowFullScreen write
      SetShowFullScreen;
    property ShowMenu: boolean read FShowMenu write SetShowMenu;
    property ShowStatusBar: boolean read FShowStatusBar write FShowStatusBar;
    property ShowMenuIcons: boolean read GetShowMenuIcons write
      SetShowMenuIcons;
    property ShowToolbar: boolean read GetShowToolbar write SetShowToolbar;
    property ShowBorder: boolean read GetShowBorder write SetShowBorder;
    property ShowHidden: boolean read GetShowHidden write SetShowHidden;

    property EnableMenu: boolean read GetEnableMenu write SetEnableMenu;
    property MediaAutoAdvance: boolean read FMediaAutoAdvance write
      FMediaAutoAdvance;
    property FollowTail: boolean read GetFollowTail write SetFollowTail;

  protected
    { Protected declarations }
    procedure WMCommand(var Message: TMessage); message WM_COMMAND;
      //To process WM_COMMAND sent by plugins
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
      //To focus active embedded control
{$IFDEF CMDLINE}
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure WMDisp(var Msg: TMessage); message EM_DISPLAYBAND;
    procedure WMMove(var Msg: TMessage); message WM_MOVE;
{$ENDIF}
  end;

var
  FormViewUV: TFormViewUV;

  //Functions to use in 3rd-party applications:
procedure OpenUniversalViewer(const AFileName: WideString; APicture: TPicture =
  nil);
procedure OpenUniversalViewerOptions;

implementation

uses
  ShellAPI, Consts,
  TntSysUtils, TntFileCtrl,
  ATxSProc, ATxSHex, ATxFProc, ATxRegistry,
  ATxParamStr, ATxMsgProc, ATxVersionInfo,
  ATViewerMsg, ATxMsg, ATxShellExtension, ATxUtils, ATxIconsProc,
  ATStreamSearch, ATImageBox, WLXPlugin,
  ATxUnpack_Dll, ATxLnk,
  ATxClipboard,
{$IFDEF PREVIEW}
  ATPrintPreview,
  ATxPrintProc,
{$ENDIF}
{$IFNDEF COMPILER_6_UP}
  SystemUTF8,
{$ENDIF}
  UFormViewFindText, UFormViewFindProgress, UFormViewOptions,
  UFormViewGoto, UFormViewToolbar, UFormPluginsOptions,
  UFormViewRename,
{$IFDEF EXIF}
  UFormViewEXIF,
{$ENDIF}
  UFormViewEdit,
  UFormViewAbout,
  SBSSLConstants, StrUtils, UFormKeyGenerate, DSiWin32;

{$R *.DFM}

{$I ViewerIni.inc}
{$I UFormView_FitWindow.pas}
{$I UFormView_File.pas}

{ Constants }

const
  CR = #13#10;
  cViewerCompATV = 'ATViewer'{$IFDEF PREVIEW} + ', ATPrintPreview'{$ENDIF} +
    ' © Alexey Torgashin' + CR;
  cViewerCompTNT = {$IFDEF TNT} 'Tnt Unicode Controls © Troy Wolbrink' +
    CR{$ELSE} ''{$ENDIF};
  cViewerCompRegEx = {$IFDEF REGEX}
    'DIRegEx © Ralf Junker, The Delphi Inspiration' + CR{$ELSE} ''{$ENDIF};
  cViewerCompGEX = {$IFDEF GEX} 'GraphicEx © Mike Lischke' + CR{$ELSE}
    ''{$ENDIF};
  cViewerCompGIF = {$IFDEF GIF} 'GIFImage © Anders Melander, Finn Tolderlund' +
    CR{$ELSE} ''{$ENDIF};
  cViewerCompPNG = {$IFDEF PNG} 'PNGImage © Gustavo Huffenbacher Daud' +
    CR{$ELSE} ''{$ENDIF};
  cViewerCompJP2 = {$IFDEF JP2} 'JPEG 2000 for Delphi © Gabriel Corneanu' +
    CR{$ELSE} ''{$ENDIF};
  cViewerCompAni = {$IFDEF ANI} 'AmnAni.dll © Alexey Novosselov' + CR{$ELSE}
    ''{$ENDIF};
  cViewerCompHelp = {$IFDEF HELP} 'HTML Help interface © Project JEDI' +
    CR{$ELSE} ''{$ENDIF};

  cViewerCompUnzipDll = 'Unzip32.dll © InfoZip project' + CR;
  cViewerCompUnzipCode = 'UnZip code © Headcrash Industries' + CR;
  cViewerCompUnrarDll = 'Unrar.dll © Eugene Roshal' + CR;
  cViewerCompUnrarCode = 'RAR Component © Philippe Wechsler' + CR;
  cViewerComps =
    cViewerCompATV +
    cViewerCompTNT +
    cViewerCompRegEx +
    cViewerCompGEX +
    cViewerCompGIF +
    cViewerCompPNG +
    cViewerCompJP2 +
    cViewerCompHelp +
    cViewerCompAni +
    cViewerCompUnzipDll +
    cViewerCompUnzipCode +
    cViewerCompUnrarDll +
    cViewerCompUnrarCode;
  cViewerBuild = {$IFDEF TNT} ''{$ELSE} ' (ANSI build)'{$ENDIF};

const
  cFindCount = 30;

  { Helper functions }

  //----------------------------------------------

procedure OpenUniversalViewer(const AFileName: WideString; APicture: TPicture =
  nil);
var
  Form: TFormViewUV;
begin
  Application.CreateForm(TFormViewUV, Form);
  with Form do
  begin
    FileName := AFileName;
    Picture := APicture;
    Show;
  end;
end;

//----------------------------------------------

procedure OpenUniversalViewerOptions;
var
  Form: TFormViewUV;
begin
  Application.CreateForm(TFormViewUV, Form);
  with Form do
    try
      FileName := '';
      mnuOptionsConfigureClick(Form);
    finally
      Release;
    end;
end;

//----------------------------------------------
const
  cModesNumbered: array[1..8] of TATViewerMode =
    (vmodeText, vmodeBinary, vmodeHex, vmodeMedia, vmodeWeb, vmodeUnicode,
      vmodeWLX, vmodeRTF);

function ListToModes(S: string): TATViewerModes;
//
  function SGetListValue(var S: string): string;
  var
    i: integer;
  begin
    i := Pos(' ', s);
    if i = 0 then
      i := MaxInt;
    Result := Copy(s, 1, i - 1);
    Delete(s, 1, i);
  end;
  //
var
  SS: string;
  N: integer;
begin
  Result := [];
  repeat
    S := Trim(S);
    SS := SGetListValue(S);
    if SS = '' then
      Break;
    N := StrToIntDef(SS, 0);
    if (N >= Low(cModesNumbered)) and (N <= High(cModesNumbered)) then
      Include(Result, cModesNumbered[N]);
  until false;
end;

function IntegerToMode(N: integer; Default: TATViewerMode): TATViewerMode;
begin
  if (N >= Low(cModesNumbered)) and (N <= High(cModesNumbered)) then
    Result := cModesNumbered[N]
  else
    Result := Default;
end;

function IntegerToMediaMode(N: integer): TATViewerMediaMode;
begin
  if (N >= 1 {Skip vmmodeNone}) and (N <= Ord(High(TATViewerMediaMode))) then
    Result := TATViewerMediaMode(N)
  else
    Result := High(TATViewerMediaMode);
end;

//----------------------------------------------

procedure CopyMenuItem(Source, Dest: TMenuItem);
begin
  Dest.Caption := Source.Caption;
  Dest.Enabled := Source.Enabled;
  Dest.Checked := Source.Checked;
  Dest.ShortCut := Source.ShortCut;
  Dest.OnClick := Source.OnClick;
end;

procedure MsgTextNotSelected;
begin
  MsgWarning(MsgString(125));
end;

{ Additional helper functions }

//----------------------------------------------
{
Application's configuration files are searched in these locations:

1) Highest precedence: UV folder, if Viewer.ini file exists there;
2) Location stored in the registry under "HKEY_CURRENT_USER\Software\UniversalViewer";
3) Location stored in the registry under "HKEY_LOCAL_MACHINE\Software\UniversalViewer";
4) Default location, which is:
  a) Under Windows Vista: "%AppData%\ATViewer" folder;
  b) Under Windows XP and older systems: UV folder.
}

function ConfigFolder: WideString;
begin
  Result := '';

  if IsFileExist(SParamDir + '\Viewer.ini') then
  begin
    Result := SParamDir;
    Exit
  end;

  Result :=
    SExpandVars(
    GetRegKeyStr(HKEY_CURRENT_USER, cIniRegKey, cIniRegValue,
    GetRegKeyStr(HKEY_LOCAL_MACHINE, cIniRegKey, cIniRegValue, '')));
  if Result <> '' then
    Exit;

  if IsWindowsVista then
    Result := FGetAppDataPath + '\ATViewer'
  else
    Result := SParamDir;
end;

{$IFDEF CMDLINE}
{$I ViewerCmdLine.inc}
{$ENDIF}

//----------------------------------------------
{ TFormView }

procedure TFormViewUV.InitConfigs;
var
  Folder: WideString;
begin
  Folder := ConfigFolder;
  if not IsDirExist(Folder) then
    FCreateDir(Folder);

  FIniName := Folder + '\Viewer.ini';
  FIniNameHist := Folder + '\ViewerHistory.ini';
  FIniNameLS := FGetShortName(Folder) + '\lsplugin.ini';

  FIni := TATIniFile.Create(FIniName);
  FIniHist := TATIniFile.Create(FIniNameHist);
  FIniSave := TATIniFileSave.Create(FIniName);
  FIniHistSave := TATIniFileSave.Create(FIniNameHist);
end;

function TFormViewUV.SCollapseVars(const fn: string): string;
  procedure CollapseVar(var S: string; const VarName: string);
  var
    Value: string;
  begin
    Value := SExpandVars(VarName);
    if (Pos('%', Value) = 0) and (Pos(Value, S) = 1) then
      SReplace(S, Value, VarName);
  end;
begin
  Result := fn;
  CollapseVar(Result, '%ATViewer%');
  if FPluginsTotalcmdVar then
    CollapseVar(Result, '%COMMANDER_PATH%');
end;

function TFormViewUV.GetShowToolbar: boolean;
begin
  Result := Toolbar.Visible;
end;

procedure TFormViewUV.SetShowToolbar(AValue: boolean);
begin
  Toolbar.Visible := AValue;
end;

function TFormViewUV.GetShowHidden: boolean;
begin
  Result := not FFileList.SkipHidden;
end;

procedure TFormViewUV.SetShowHidden(AValue: boolean);
begin
  FFileList.SkipHidden := not AValue;
end;

function TFormViewUV.GetShowBorder: boolean;
begin
  Result := Viewer.BorderStyleInner = bsSingle;
end;

procedure TFormViewUV.SetShowBorder(AValue: boolean);
const
  Borders: array[boolean] of TBorderStyle = (bsNone, bsSingle);
begin
  Viewer.BorderStyleInner := Borders[AValue];
end;

{$IFDEF MENX}

procedure LoadShortcutsStr;
var
  k: TMenuKeyCap;
begin
  for k := Low(MenuKeyCaps) to High(MenuKeyCaps) do
    MenuKeyCaps[k] := MsgString(Ord(k) + 400);
end;

procedure DefaultShortcutsStr;
const
  cMenuKeyCaps: array[TMenuKeyCap] of string = (
    SmkcBkSp, SmkcTab, SmkcEsc, SmkcEnter, SmkcSpace, SmkcPgUp,
    SmkcPgDn, SmkcEnd, SmkcHome, SmkcLeft, SmkcUp, SmkcRight,
    SmkcDown, SmkcIns, SmkcDel, SmkcShift, SmkcCtrl, SmkcAlt);
var
  k: TMenuKeyCap;
begin
  for k := Low(MenuKeyCaps) to High(MenuKeyCaps) do
    MenuKeyCaps[k] := cMenuKeyCaps[k];
end;
{$ENDIF}

procedure TFormViewUV.LoadShortcuts;
const
  SUnknown = '--';
var
  i: integer;
  S: string;
  Rec: PToolbarButtonRec;
begin
{$IFDEF MENX}
  DefaultShortcutsStr;
{$ENDIF}

  for i := 1 to cToolbarButtonsMax do
  begin
    if not FToolbarList.GetAvail(i, Rec) then
      Break;
    S := FIni.ReadString(csShortcuts, GetToolbarButtonId(Rec^), SUnknown);
    if S <> SUnknown then
      Rec.FMenuItem.Shortcut := TextToShortCut(S);
  end;

{$IFDEF MENX}
  LoadShortcutsStr;
{$ENDIF}
end;

procedure TFormViewUV.SaveShortcuts;
var
  i: integer;
  S: string;
  Rec: PToolbarButtonRec;
begin
{$IFDEF MENX}
  DefaultShortcutsStr;
{$ENDIF}

  for i := 1 to cToolbarButtonsMax do
  begin
    if not FToolbarList.GetAvail(i, Rec) then
      Break;
    if Rec.FMenuItem.Caption <> '-' then
    begin
      S := ShortcutToText(Rec.FMenuItem.Shortcut);
      FIniSave.WriteString(csShortcuts, GetToolbarButtonId(Rec^), S);
    end;
  end;

{$IFDEF MENX}
  LoadShortcutsStr;
{$ENDIF}
end;

procedure TFormViewUV.LoadRecents;
var
  i: integer;
  S: WideString;
begin
  with FRecentList do
  begin
    Clear;
    for i := 0 to High(TRecentMenus) do
    begin
      S := UTF8Decode(FIniHist.ReadString(csRecent, IntToStr(i), ''));
      if S <> '' then
        if (not IsFilenameFixed(S)) or IsFileExist(S) then
          Add(S);
    end;
  end;

  FRecentMenus[0] := mnuRecent0;
  FRecentMenus[1] := mnuRecent1;
  FRecentMenus[2] := mnuRecent2;
  FRecentMenus[3] := mnuRecent3;
  FRecentMenus[4] := mnuRecent4;
  FRecentMenus[5] := mnuRecent5;
  FRecentMenus[6] := mnuRecent6;
  FRecentMenus[7] := mnuRecent7;
  FRecentMenus[8] := mnuRecent8;
  FRecentMenus[9] := mnuRecent9;

  FRecentMenusBar[0] := mnuBarRecent0;
  FRecentMenusBar[1] := mnuBarRecent1;
  FRecentMenusBar[2] := mnuBarRecent2;
  FRecentMenusBar[3] := mnuBarRecent3;
  FRecentMenusBar[4] := mnuBarRecent4;
  FRecentMenusBar[5] := mnuBarRecent5;
  FRecentMenusBar[6] := mnuBarRecent6;
  FRecentMenusBar[7] := mnuBarRecent7;
  FRecentMenusBar[8] := mnuBarRecent8;
  FRecentMenusBar[9] := mnuBarRecent9;
end;

procedure TFormViewUV.SaveRecents;
var
  i: integer;
begin
  with FRecentList do
  begin
    for i := 0 to Count - 1 do
      FIniHistSave.WriteString(csRecent, IntToStr(i), UTF8Encode(Strings[i]));

    for i := Count to High(TRecentMenus) do
      FIniHistSave.DeleteKey(csRecent, IntToStr(i));
  end;
end;

procedure TFormViewUV.ApplyRecents;
var
  i: integer;
  S: WideString;
begin
  for i := 0 to High(TRecentMenus) do
  begin
    if i < FRecentList.Count then
      S := FRecentList[i]
    else
      S := '';

    //FRecentMenus[i].Caption:= S;
    FRecentMenus[i].Visible := S <> '';

    //FRecentMenusBar[i].Caption:= S;
    FRecentMenusBar[i].Visible := S <> '';
  end;

  mnuRecentClear.Enabled := FRecentList.Count > 0;
  mnuBarRecentClear.Enabled := mnuRecentClear.Enabled;
end;

procedure TFormViewUV.ClearRecents;
begin
  FRecentList.Clear;
  ApplyRecents;
  SaveRecents;
end;

procedure TFormViewUV.ClearSearch;
begin
  FFindHistory.Clear;
  FFindText := '';
  FFindWords := false;
  FFindCase := false;
  FFindBack := false;
  FFindHex := false;
  FFindRegex := false;
  FFindMLine := false;
  FFindOrigin := false;
  SaveSearch;
end;

procedure TFormViewUV.AddRecent(const S: WideString);
var
  i: integer;
begin
  if FSaveRecents then
    if S <> '' then
    begin
      with FRecentList do
      begin
        i := IndexOf(S);
        if i >= 0 then
          Delete(i);
        Insert(0, S);
        while Count > High(TRecentMenus) + 1 do
          Delete(Count - 1);
      end;
      ApplyRecents;
    end;
end;

procedure TFormViewUV.LoadSearch;
var
  i: integer;
  S: WideString;
begin
  with FFindHistory do
  begin
    Clear;

    for i := 0 to cFindCount - 1 do
    begin
      S := UTF8Decode(FIniHist.ReadString(csSearchHist, IntToStr(i), ''));
      if S <> '' then
        Add(S);
    end;

    if Count > 0 then
      FFindText := Strings[0];
  end;

  FFindWords := FIniHist.ReadBool(csSearchOpt, ccSrchWords, FFindWords);
  FFindCase := FIniHist.ReadBool(csSearchOpt, ccSrchCase, FFindCase);
  FFindBack := FIniHist.ReadBool(csSearchOpt, ccSrchBack, FFindBack);
  FFindHex := FIniHist.ReadBool(csSearchOpt, ccSrchHex, FFindHex);
  FFindRegex := FIniHist.ReadBool(csSearchOpt, ccSrchRegex, FFindRegex);
  FFindMLine := FIniHist.ReadBool(csSearchOpt, ccSrchMLine, FFindMLine);

  FFindOrigin := FIniHist.ReadBool(csSearchOpt, ccSrchOrigin, FFindOrigin);
end;

procedure TFormViewUV.LoadOptions;
begin
  Left := FIniHist.ReadInteger(csWindow, ccWinLeft, Left);
  Top := FIniHist.ReadInteger(csWindow, ccWinTop, Top);
  Width := FIniHist.ReadInteger(csWindow, ccWinWidth, Width);
  Height := FIniHist.ReadInteger(csWindow, ccWinHeight, Height);

  if FIniHist.ReadBool(csWindow, ccWinMaximized, false) then
    WindowState := wsMaximized;

  SetMsgLanguage(FIni.ReadString(csOpt, ccOLanguage, 'English'));
  IconsName := FIni.ReadString(csOpt, ccOIconsName, '');
  FSingleInstance := FIni.ReadBool(csOpt, ccOSingleInst, FSingleInstance);

  FViewerTitle := FIni.ReadInteger(csOpt, ccOViewerTitle, FViewerTitle);
  FViewerMode := FIni.ReadInteger(csOpt, ccOViewerMode, FViewerMode);
  if FViewerMode > 0 then
  begin
    Viewer.ModeDetect := false;
    Viewer.Mode := IntegerToMode(FViewerMode, vmodeText);
  end;

  ShowMenu := FIni.ReadBool(csOpt, ccOShowMenu, ShowMenu);
  ShowMenuIcons := FIni.ReadBool(csOpt, ccOShowMenuIcons, false);
  ShowToolbar := FIni.ReadBool(csOpt, ccOShowToolbar, ShowToolbar);
  ShowBorder := FIni.ReadBool(csOpt, ccOShowBorder, ShowBorder);
  ShowStatusBar := FIni.ReadBool(csOpt, ccOShowStatusBar, ShowStatusBar);
  ShowHidden := FIni.ReadBool(csOpt, ccOShowHiddenFiles, false);
{$IFDEF CMDLINE}
  ShowNav := FIni.ReadBool(csOpt, ccOShowNavigation, false);
{$ENDIF}
  Viewer.ModeUndetectedCfm := FIni.ReadBool(csOpt, ccOShowCfm, true);

  FSaveRecents := FIni.ReadBool(csOpt, ccOSaveRecents, FSaveRecents);
  FSavePosition := FIni.ReadBool(csOpt, ccOSavePos, FSavePosition);
  FSaveSearch := FIni.ReadBool(csOpt, ccOSaveSearch, FSaveSearch);
  FSaveFolder := FIni.ReadBool(csOpt, ccOSaveFolder, FSaveFolder);

  FFileList.SortOrder := TATFileSort(FIni.ReadInteger(csOpt, ccOFileSortOrder,
    integer(FFileList.SortOrder)));
  FFileList.SkipHidden := FIni.ReadBool(csOpt, ccOFileSkipHidden,
    FFileList.SkipHidden);
  FFileNextMsg := FIni.ReadBool(csOpt, ccOFileNextMsg, FFileNextMsg);
  FFileMoveDelay := FIni.ReadInteger(csOpt, ccOFileMoveDelay, FFileMoveDelay);
  with StatusBar1.Panels[2] do
    Width := FIni.ReadInteger(csOpt, ccOStatusUrlWidth, Width);

  FResolveLinks := FIni.ReadBool(csOpt, ccOResolveLinks, true);
  FShowNoFindError := FIni.ReadBool(csOpt, ccOSearchNoMsg, FShowNoFindError);
  FShowNoFindReset := FIni.ReadBool(csOpt, ccOSearchNoCfm, FShowNoFindReset);
  FShowFindSelection := FIni.ReadBool(csOpt, ccOSearchSel, FShowFindSelection);

  FPluginsTotalcmdVar := FIni.ReadBool(csOpt, ccPTcVar, FPluginsTotalcmdVar);
  FPluginsHideKeys := FIni.ReadBool(csOpt, ccPHideKeys, FPluginsHideKeys);
  MediaAutoAdvance := FIni.ReadBool(csOpt, ccOMediaAutoAdvance,
    MediaAutoAdvance);
  MediaFitWindow := FIni.ReadBool(csOpt, ccOMediaFitWindow, MediaFitWindow);

  ShowOnTop := FIni.ReadBool(csOpt, ccOShowAlwaysOnTop, ShowOnTop);
  ShowFullScreen := FIni.ReadBool(csOpt, ccOShowFullScreen, ShowFullScreen);

  LoadToolbar;
  LoadShortcuts;
  LoadRecents;
  LoadSearch;
  LoadMargins;

  ApplyToolbar;
  ApplyRecents;

  with Viewer do
  begin
    ModeUndetected := IntegerToMode(FIni.ReadInteger(csOpt, ccOModeUndetected,
      0), ModeUndetected);
    ModesDisabledForDetect := ListToModes(FIni.ReadString(csOpt,
      ccOModesDisabled, ''));

    TextDetect := FIni.ReadBool(csOpt, ccOTextDetect, TextDetect);
    TextDetectOEM := FIni.ReadBool(csOpt, ccOTextDetectOEM, TextDetectOEM);
    TextDetectSize := FIni.ReadInteger(csOpt, ccOTextDetectSize,
      TextDetectSize);
    TextDetectLimit := FIni.ReadInteger(csOpt, ccOTextDetectLimit,
      TextDetectLimit);
    TextEncoding := TATEncoding(FIni.ReadInteger(csOpt, ccOTextEncoding,
      integer(TextEncoding)));
    TextWrap := FIni.ReadBool(csOpt, ccOTextWrap, TextWrap);
    TextUrlHilight := FIni.ReadBool(csOpt, ccOTextURLs, TextUrlHilight);
    TextNonPrintable := FIni.ReadBool(csOpt, ccOTextNonPrint, TextNonPrintable);
    TextWidth := FIni.ReadInteger(csOpt, ccOTextWidth, 80);
    TextSearchIndentVert := FIni.ReadInteger(csOpt, ccOTextSearchIndent,
      TextSearchIndentVert);
    TextSearchIndentHorz := TextSearchIndentVert;
    TextTabSize := FIni.ReadInteger(csOpt, ccOTextTabSize, TextTabSize);
    TextMaxLengths[vbmodeText] := FIni.ReadInteger(csOpt, ccOTextMaxLength,
      TextMaxLengths[vbmodeText]);
    TextMaxLengths[vbmodeUnicode] := TextMaxLengths[vbmodeText];
    TextMaxClipboardDataSizeMb := FIni.ReadInteger(csOpt, ccOTextMaxClipSize,
      TextMaxClipboardDataSizeMb);

{$IFDEF OFFLINE}
    WebOffline := FIni.ReadBool(csOpt, ccOWebOffline, WebOffline);
{$ENDIF}
    WebAcceptAllFiles := FIni.ReadBool(csOpt, ccOWebAcceptAll, true);

    //Fonts
    SSetFont(TextFont, FIni.ReadString(csFonts, ccOTextFont, ''));
    SSetFont(TextFontOem, FIni.ReadString(csFonts, ccOTextFontOem, ''));
    SSetFont(TextFontFooter, FIni.ReadString(csFonts, ccOTextFontFooter, ''));
    SSetFont(TextFontGutter, FIni.ReadString(csFonts, ccOTextFontGutter, ''));

    TextColor := FIni.ReadInteger(csOpt, ccOTextBackColor, TextColor);
    TextColorHex := FIni.ReadInteger(csOpt, ccOTextHexColor1, TextColorHex);
    TextColorHex2 := FIni.ReadInteger(csOpt, ccOTextHexColor2, TextColorHex2);
    TextColorHexBack := FIni.ReadInteger(csOpt, ccOTextHexColorBack,
      TextColorHexBack);
    TextColorGutter := FIni.ReadInteger(csOpt, ccOTextGutterColor,
      TextColorGutter);
    TextColorURL := FIni.ReadInteger(csOpt, ccOTextUrlColor, TextColorURL);

    TextWidthFit := FIni.ReadBool(csOpt, ccOTextWidthFit, TextWidthFit);
    TextWidthFitHex := TextWidthFit;
    TextWidthFitUHex := TextWidthFit;
    TextOemSpecial := FIni.ReadBool(csOpt, ccOTextOemSpec, Win32Platform <>
      VER_PLATFORM_WIN32_NT);

    TextGutter := FIni.ReadBool(csOpt, ccOTextGutter, true);
    TextGutterLines := FIni.ReadBool(csOpt, ccOTextGutterLines, false);
    TextGutterLinesBufSize := FIni.ReadInteger(csOpt, ccOTextGutterLinesSize,
      300) * 1024;
    TextGutterLinesCount := FIni.ReadInteger(csOpt, ccOTextGutterLinesCount,
      2000);
    TextGutterLinesStep := FIni.ReadInteger(csOpt, ccOTextGutterLinesStep,
      TextGutterLinesStep);

    TextGutterLinesExtUse := FIni.ReadBool(csOpt, ccOTextGutterLinesExtUse,
      false);
    TextGutterLinesExtList := FIni.ReadString(csOpt, ccOTextGutterLinesExtList,
      'c,cpp,h,hpp,pas,dpr,bas,asm,mak,inc');

    TextAutoReload := FIni.ReadBool(csOpt, ccOTextAutoReload, TextAutoReload);
    TextAutoReloadBeep := FIni.ReadBool(csOpt, ccOTextAutoReloadBeep,
      TextAutoReloadBeep);
    TextAutoReloadFollowTail := FIni.ReadBool(csOpt, ccOTextAutoReloadTail,
      TextAutoReloadFollowTail);
    TextAutoCopy := FIni.ReadBool(csOpt, ccOTextAutoCopy, TextAutoCopy);

    MediaMode := IntegerToMediaMode(FIni.ReadInteger(csOpt, ccOMediaMode,
      integer(MediaMode)));
    MediaAutoPlay := FIni.ReadBool(csOpt, ccOMediaAutoPlay, MediaAutoPlay);
    MediaPlayCount := FIni.ReadInteger(csOpt, ccOMediaPlayCount,
      MediaPlayCount);
    ImageColor := FIni.ReadInteger(csOpt, ccOImageColor, ImageColor);
    ImageResample := FIni.ReadBool(csOpt, ccOImageResample, true);
    ImageTransparent := FIni.ReadBool(csOpt, ccOImageTransparent, false);
    ImageErrorMessageBox := false;
    FImageLabelVisible := FIni.ReadBool(csOpt, ccOImageLabelVisible,
      FImageLabelVisible);
    FImageLabelColor := FIni.ReadInteger(csOpt, ccOImageLabelColor,
      FImageLabelColor);
    FImageLabelColorErr := FIni.ReadInteger(csOpt, ccOImageLabelColorErr,
      FImageLabelColorErr);

    MediaFit := FIni.ReadBool(csOpt, ccOMediaFit, MediaFit);
    MediaFitOnlyBig := FIni.ReadBool(csOpt, ccOMediaFitOnlyBig,
      MediaFitOnlyBig);
    MediaCenter := FIni.ReadBool(csOpt, ccOMediaCenter, MediaCenter);

    MediaLoop := FIniHist.ReadBool(csOpt, ccOMediaLoop, MediaLoop);
    MediaVolume := FIniHist.ReadInteger(csOpt, ccOMediaVolume, MediaVolume);
    MediaMute := FIniHist.ReadBool(csOpt, ccOMediaMute, MediaMute);

    with ATViewerOptions do
    begin
      ExtText := FIni.ReadString(csOpt, ccOExtText, ATViewerOptions.ExtText);
      ExtImages := FIni.ReadString(csOpt, ccOExtImages,
        ATViewerOptions.ExtImages);
      if Pos('jp2', ExtImages) = 0 then
        ExtImages := ExtImages + ',jp2,jpc,pnm,ras,mis';
      if Pos('ani', ExtImages) = 0 then
        ExtImages := ExtImages + ',ani';
      if Pos('cur', ExtImages) = 0 then
        ExtImages := ExtImages + ',cur';

      ExtMedia := FIni.ReadString(csOpt, ccOExtMedia, ATViewerOptions.ExtMedia);
      ExtWeb := FIni.ReadString(csOpt, ccOExtWeb, ATViewerOptions.ExtWeb);
      ExtRTF := FIni.ReadString(csOpt, ccOExtRTF, ATViewerOptions.ExtRTF);
    end;

    PluginsHighPriority := FIni.ReadBool(csOpt, ccPPrior, PluginsHighPriority);

{$IFDEF IVIEW}
    with IViewIntegration do
    begin
      Enabled := FIni.ReadBool(csOpt, ccOIViewEnabled, Enabled);
      ExeName := SExpandVars(FIni.ReadString(csOpt, ccOIViewExeName, ExeName));
      ExtList := FIni.ReadString(csOpt, ccOIViewExtList, ExtList);
      HighPriority := FIni.ReadBool(csOpt, ccOIViewPriority, HighPriority);
    end;
{$ENDIF}

{$IFDEF IJL}
    with IJLIntegration do
    begin
      Enabled := FIni.ReadBool(csOpt, ccOIJLEnabled, Enabled);
      ExtList := FIni.ReadString(csOpt, ccOIJLExtList, ExtList);
    end;
{$ENDIF}
  end;

  FGotoMode := TViewerGotoMode(FIniHist.ReadInteger(csOpt, ccOTextGotoMode,
    integer(FGotoMode)));
  FFileFolder := UTF8Decode(FIniHist.ReadString(csWindow, ccOLastFolder, ''));
  FFileFolderSave := UTF8Decode(FIniHist.ReadString(csWindow, ccOLastFolderSave,
    ''));
end;

procedure TFormViewUV.LoadUserTools;
var
  i: integer;
  Tool: TATUserTool;
begin
  ClearUserTools(FUserTools);

  for i := Low(TATUserTools) to High(TATUserTools) do
  begin
    ClearUserTool(Tool);
    Tool.FCaption := FIni.ReadString(csUserTools, IntToStr(i) + ccUCaption, '');
    Tool.FCommand := UTF8Decode(FIni.ReadString(csUserTools, IntToStr(i) +
      ccUCommand, ''));
    Tool.FParams := UTF8Decode(FIni.ReadString(csUserTools, IntToStr(i) +
      ccUParams, ''));
    Tool.FActions := FIni.ReadString(csUserTools, IntToStr(i) + ccUActions, '');
    AddUserTool(FUserTools, Tool);
  end;

  ApplyUserTools;
end;

procedure TFormViewUV.SaveUserTools;
var
  i: integer;
begin
  for i := Low(TATUserTools) to High(TATUserTools) do
    with FUserTools[i] do
    begin
      FIniSave.WriteString(csUserTools, IntToStr(i) + ccUCaption, FCaption);
      FIniSave.WriteString(csUserTools, IntToStr(i) + ccUCommand,
        UTF8Encode(FCommand));
      FIniSave.WriteString(csUserTools, IntToStr(i) + ccUParams,
        UTF8Encode(FParams));
      FIniSave.WriteString(csUserTools, IntToStr(i) + ccUActions, FActions);
    end;
  FIniSave.UpdateFile;
end;

procedure TFormViewUV.ApplyUserTools;
var
  i, N: integer;
  S: WideString;
  MItems: array[Low(TATUserTools)..High(TATUserTools)] of TMenuItem;
begin
  //Initialize menu array
  MItems[1] := mnuUserTool1;
  MItems[2] := mnuUserTool2;
  MItems[3] := mnuUserTool3;
  MItems[4] := mnuUserTool4;
  MItems[5] := mnuUserTool5;
  MItems[6] := mnuUserTool6;
  MItems[7] := mnuUserTool7;
  MItems[8] := mnuUserTool8;

  //Delete old tools icons from ImageList
  for i := High(TATUserTools) downto Low(TATUserTools) do
    with MItems[i] do
      if (ImageIndex >= 0) and (ImageIndex < ImageList1.Count) then
      begin
        N := ImageIndex;
        ImageIndex := -1;
        ImageList1.Delete(N);
      end;

  //Add/update tools captions and icons
  N := NumOfUserTools(FUserTools);
  mnuTools.Visible := mnuFile.Visible and (N > 0);

  for i := Low(TATUserTools) to High(TATUserTools) do
    with FUserTools[i] do
      with MItems[i] do
      begin
        if (i <= N) then
        begin
          Visible := true;
          S := SExpandVars(FCommand);
          ImageIndex := AddCommandIcon(S, ImageList1);
          Caption := Format('&%d  %s', [i, FCaption]);
        end
        else
        begin
          Visible := false;
          ImageIndex := -1;
          Caption := '';
        end;
      end;
end;

procedure TFormViewUV.mnuUserTool1Click(Sender: TObject);
begin
  DoUserTool(1);
end;

procedure TFormViewUV.mnuUserTool2Click(Sender: TObject);
begin
  DoUserTool(2);
end;

procedure TFormViewUV.mnuUserTool3Click(Sender: TObject);
begin
  DoUserTool(3);
end;

procedure TFormViewUV.mnuUserTool4Click(Sender: TObject);
begin
  DoUserTool(4);
end;

procedure TFormViewUV.mnuUserTool5Click(Sender: TObject);
begin
  DoUserTool(5);
end;

procedure TFormViewUV.mnuUserTool6Click(Sender: TObject);
begin
  DoUserTool(6);
end;

procedure TFormViewUV.mnuUserTool7Click(Sender: TObject);
begin
  DoUserTool(7);
end;

procedure TFormViewUV.mnuUserTool8Click(Sender: TObject);
begin
  DoUserTool(8);
end;

procedure TFormViewUV.DoUserTool(AIndex: integer);
var
  ACmd, AParams: WideString;
begin
  with FUserTools[AIndex] do
  begin
    ACmd := SExpandVars(FCommand);
    AParams := SExpandVars(FParams);
    SReplaceAllW(AParams, '{PosLine}', IntToStr(Viewer.PosLine));
    SReplaceAllW(AParams, '{PosOffset}', IntToStr(Viewer.PosOffset));
    SReplaceAllW(AParams, '"', '|');

{$IFDEF CMDLINE}
    if IsFileExist(ACmd) then
    begin
      DoUserToolActions1(FUserTools[AIndex]);
      NavOp('tool', ACmd, AParams, FFileName, '', False {fWait});
      DoUserToolActions2(FUserTools[AIndex])
    end
    else
      MsgError(SFormatW(MsgString(0151), [ACmd]));
{$ENDIF}
  end;
end;

procedure TFormViewUV.DoUserToolActions1(const Tool: TATUserTool);
begin
  if UserToolHasAction(Tool, 'SelectAll') then
    Viewer.SelectAll;
  if UserToolHasAction(Tool, 'Copy') then
    Viewer.CopyToClipboard;
end;

procedure TFormViewUV.DoUserToolActions2(const Tool: TATUserTool);
begin
  if UserToolHasAction(Tool, 'Exit') then
    mnuFileExitClick(Self);
end;

procedure TFormViewUV.SaveSearch;
var
  i: integer;
begin
  with FFindHistory do
  begin
    for i := 0 to Count - 1 do
      FIniHistSave.WriteString(csSearchHist, IntToStr(i),
        UTF8Encode(Strings[i]));
    for i := Count to cFindCount - 1 do
      FIniHistSave.DeleteKey(csSearchHist, IntToStr(i));
  end;

  FIniHistSave.WriteBool(csSearchOpt, ccSrchWords, FFindWords);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchCase, FFindCase);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchBack, FFindBack);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchHex, FFindHex);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchRegex, FFindRegex);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchMLine, FFindMLine);
  FIniHistSave.WriteBool(csSearchOpt, ccSrchOrigin, FFindOrigin);
end;

procedure TFormViewUV.SavePosition;
const
  DefWidth = 630;
  DefHeight = 450;
begin
  if (WindowState <> wsMaximized) and (not ShowFullScreen) then
  begin
    //Save current position, if valid
    if (ClientWidth > 0) and (ClientHeight > 0) then
    begin
      FIniHistSave.WriteInteger(csWindow, ccWinLeft, Left);
      FIniHistSave.WriteInteger(csWindow, ccWinTop, Top);
      FIniHistSave.WriteInteger(csWindow, ccWinWidth, Width);
      FIniHistSave.WriteInteger(csWindow, ccWinHeight, Height);
    end;
  end
  else
  begin
    if ShowFullScreen then
    begin
      //Save previous (not Full Screen) position
      with FBoundsRectOld do
      begin
        FIniHistSave.WriteInteger(csWindow, ccWinLeft, Left);
        FIniHistSave.WriteInteger(csWindow, ccWinTop, Top);
        FIniHistSave.WriteInteger(csWindow, ccWinWidth, Right - Left);
        FIniHistSave.WriteInteger(csWindow, ccWinHeight, Bottom - Top);
      end;
    end
    else
    begin
      //Save default position
      FIniHistSave.WriteInteger(csWindow, ccWinLeft, (Screen.Width - DefWidth)
        div 2);
      FIniHistSave.WriteInteger(csWindow, ccWinTop, (Screen.Height - DefHeight)
        div 2);
      FIniHistSave.WriteInteger(csWindow, ccWinWidth, DefWidth);
      FIniHistSave.WriteInteger(csWindow, ccWinHeight, DefHeight);
    end;
  end;

  //Save maximized state
  FIniHistSave.WriteBool(csWindow, ccWinMaximized, WindowState = wsMaximized);
  FIniHistSave.UpdateFile;
end;

//Saves options changable in main menu

procedure TFormViewUV.SaveOptionsInt;
begin
  if FSavePosition then
    SavePosition;

  with Viewer do
  begin
    FIniSave.WriteBool(csOpt, ccOMediaFit, MediaFit);
    FIniSave.WriteBool(csOpt, ccOMediaFitOnlyBig, MediaFitOnlyBig);
    FIniSave.WriteBool(csOpt, ccOMediaCenter, MediaCenter);
    FIniSave.WriteBool(csOpt, ccOMediaFitWindow, MediaFitWindow);

    FIniHistSave.WriteBool(csOpt, ccOMediaLoop, MediaLoop);
    FIniHistSave.WriteInteger(csOpt, ccOMediaVolume, MediaVolume);
    FIniHistSave.WriteBool(csOpt, ccOMediaMute, MediaMute);
    FIniHistSave.WriteInteger(csOpt, ccOTextGotoMode, integer(FGotoMode));

    FIniSave.WriteString(csFonts, ccOTextFont, SFontToString(TextFont));
    FIniSave.WriteString(csFonts, ccOTextFontOem, SFontToString(TextFontOem));

    FIniSave.WriteInteger(csOpt, ccOTextEncoding, integer(TextEncoding));
    FIniSave.WriteBool(csOpt, ccOTextWrap, TextWrap);
    FIniSave.WriteBool(csOpt, ccOTextNonPrint, TextNonPrintable);
    FIniSave.WriteBool(csOpt, ccOTextAutoReload, TextAutoReload);
    FIniSave.WriteBool(csOpt, ccOTextAutoReloadTail, TextAutoReloadFollowTail);

{$IFDEF OFFLINE}
    FIniSave.WriteBool(csOpt, ccOWebOffline, WebOffline);
{$ENDIF}
    FIniSave.WriteBool(csOpt, ccOWebAcceptAll, WebAcceptAllFiles);
    FIniSave.WriteBool(csOpt, ccOImageLabelVisible, FImageLabelVisible);
  end;

  FIniSave.WriteBool(csOpt, ccOShowAlwaysOnTop, ShowOnTop);
  FIniSave.WriteBool(csOpt, ccOShowFullScreen, ShowFullScreen);
  FIniSave.WriteBool(csOpt, ccOShowMenu, ShowMenu);
  FIniSave.WriteBool(csOpt, ccOShowToolbar, ShowToolbar);
  FIniSave.WriteBool(csOpt, ccOShowStatusBar, ShowStatusBar);
{$IFDEF CMDLINE}
  FIniSave.WriteBool(csOpt, ccOShowNavigation, ShowNav);
{$ENDIF}

  if FSaveFolder then
  begin
    FIniHistSave.WriteString(csWindow, ccOLastFolder, UTF8Encode(FFileFolder));
    FIniHistSave.WriteString(csWindow, ccOLastFolderSave,
      UTF8Encode(FFileFolderSave));
  end
  else
  begin
    FIniHistSave.WriteString(csWindow, ccOLastFolder, '');
    FIniHistSave.WriteString(csWindow, ccOLastFolderSave, '');
  end;

  if FSaveRecents then
    SaveRecents;
  if FSaveSearch then
    SaveSearch;

  FIniSave.UpdateFile;
  FIniHistSave.UpdateFile;
end;

//Saves options changable only in Configure dialog

procedure TFormViewUV.SaveOptionsDlg;
begin
  FIniSave.WriteString(csOpt, ccOLanguage, SMsgLanguage);
  FIniSave.WriteString(csOpt, ccOIconsName, IconsName);
  FIniSave.WriteBool(csOpt, ccOSingleInst, FSingleInstance);
  FIniSave.WriteInteger(csOpt, ccOViewerTitle, FViewerTitle);
  FIniSave.WriteInteger(csOpt, ccOViewerMode, FViewerMode);

  FIniSave.WriteBool(csOpt, ccOShowMenu, ShowMenu);
  FIniSave.WriteBool(csOpt, ccOShowMenuIcons, ShowMenuIcons);
  FIniSave.WriteBool(csOpt, ccOShowToolbar, ShowToolbar);
  FIniSave.WriteBool(csOpt, ccOShowStatusBar, ShowStatusBar);
  FIniSave.WriteBool(csOpt, ccOShowBorder, ShowBorder);
  FIniSave.WriteBool(csOpt, ccOShowHiddenFiles, ShowHidden);
{$IFDEF CMDLINE}
  FIniSave.WriteBool(csOpt, ccOShowNavigation, ShowNav);
{$ENDIF}
  FIniSave.WriteBool(csOpt, ccOShowCfm, Viewer.ModeUndetectedCfm);

  FIniSave.WriteBool(csOpt, ccOSaveRecents, FSaveRecents);
  FIniSave.WriteBool(csOpt, ccOSavePos, FSavePosition);
  FIniSave.WriteBool(csOpt, ccOSaveSearch, FSaveSearch);
  FIniSave.WriteBool(csOpt, ccOSaveFolder, FSaveFolder);
  FIniSave.WriteInteger(csOpt, ccOFileSortOrder, integer(FFileList.SortOrder));
  FIniSave.WriteBool(csOpt, ccOResolveLinks, FResolveLinks);

  with Viewer do
  begin
    FIniSave.WriteBool(csOpt, ccOTextDetect, TextDetect);
    FIniSave.WriteBool(csOpt, ccOTextDetectOEM, TextDetectOEM);
    FIniSave.WriteInteger(csOpt, ccOTextDetectSize, TextDetectSize);
    FIniSave.WriteInteger(csOpt, ccOTextDetectLimit, TextDetectLimit);

    //Fonts
    FIniSave.WriteString(csFonts, ccOTextFont, SFontToString(TextFont));
    FIniSave.WriteString(csFonts, ccOTextFontOem, SFontToString(TextFontOem));
    FIniSave.WriteString(csFonts, ccOTextFontFooter,
      SFontToString(TextFontFooter));
    FIniSave.WriteString(csFonts, ccOTextFontGutter,
      SFontToString(TextFontGutter));

    FIniSave.WriteInteger(csOpt, ccOTextBackColor, TextColor);
    FIniSave.WriteInteger(csOpt, ccOTextHexColor1, TextColorHex);
    FIniSave.WriteInteger(csOpt, ccOTextHexColor2, TextColorHex2);
    FIniSave.WriteInteger(csOpt, ccOTextHexColorBack, TextColorHexBack);
    FIniSave.WriteInteger(csOpt, ccOTextGutterColor, TextColorGutter);
    FIniSave.WriteInteger(csOpt, ccOTextUrlColor, TextColorURL);

    FIniSave.WriteInteger(csOpt, ccOTextWidth, TextWidth);
    FIniSave.WriteBool(csOpt, ccOTextWidthFit, TextWidthFit);
    FIniSave.WriteBool(csOpt, ccOTextOemSpec, TextOemSpecial);
    FIniSave.WriteBool(csOpt, ccOTextWrap, TextWrap);
    FIniSave.WriteBool(csOpt, ccOTextURLs, TextUrlHilight);
    FIniSave.WriteBool(csOpt, ccOTextNonPrint, TextNonPrintable);

    FIniSave.WriteBool(csOpt, ccOTextGutter, TextGutter);
    FIniSave.WriteBool(csOpt, ccOTextGutterLines, TextGutterLines);
    FIniSave.WriteInteger(csOpt, ccOTextGutterLinesSize, TextGutterLinesBufSize
      div 1024);
    FIniSave.WriteInteger(csOpt, ccOTextGutterLinesCount, TextGutterLinesCount);
    FIniSave.WriteInteger(csOpt, ccOTextGutterLinesStep, TextGutterLinesStep);
    FIniSave.WriteBool(csOpt, ccOTextGutterLinesExtUse, TextGutterLinesExtUse);
    FIniSave.WriteString(csOpt, ccOTextGutterLinesExtList,
      TextGutterLinesExtList);

    FIniSave.WriteInteger(csOpt, ccOTextSearchIndent, TextSearchIndentVert);
    FIniSave.WriteInteger(csOpt, ccOTextMaxLength, TextMaxLengths[vbmodeText]);
    FIniSave.WriteInteger(csOpt, ccOTextTabSize, TextTabSize);

    FIniSave.WriteBool(csOpt, ccOSearchSel, FShowFindSelection);
    FIniSave.WriteBool(csOpt, ccOSearchNoMsg, FShowNoFindError);

    FIniSave.WriteBool(csOpt, ccOTextAutoReload, TextAutoReload);
    FIniSave.WriteBool(csOpt, ccOTextAutoReloadBeep, TextAutoReloadBeep);
    FIniSave.WriteBool(csOpt, ccOTextAutoReloadTail, TextAutoReloadFollowTail);
    FIniSave.WriteBool(csOpt, ccOTextAutoCopy, TextAutoCopy);

    FIniSave.WriteInteger(csOpt, ccOMediaMode, integer(MediaMode));
    FIniSave.WriteBool(csOpt, ccOMediaAutoPlay, MediaAutoPlay);
    FIniSave.WriteInteger(csOpt, ccOMediaPlayCount, MediaPlayCount);
    FIniSave.WriteInteger(csOpt, ccOImageColor, ImageColor);

    FIniSave.WriteBool(csOpt, ccOMediaFit, MediaFit);
    FIniSave.WriteBool(csOpt, ccOMediaFitOnlyBig, MediaFitOnlyBig);
    FIniSave.WriteBool(csOpt, ccOMediaCenter, MediaCenter);
    FIniSave.WriteBool(csOpt, ccOImageResample, ImageResample);
    FIniSave.WriteBool(csOpt, ccOImageTransparent, ImageTransparent);
    FIniSave.WriteInteger(csOpt, ccOImageLabelColor, FImageLabelColor);
    FIniSave.WriteInteger(csOpt, ccOImageLabelColorErr, FImageLabelColorErr);

    FIniSave.WriteString(csOpt, ccOExtText, ATViewerOptions.ExtText);
    FIniSave.WriteString(csOpt, ccOExtImages, ATViewerOptions.ExtImages);
    FIniSave.WriteString(csOpt, ccOExtMedia, ATViewerOptions.ExtMedia);
    FIniSave.WriteString(csOpt, ccOExtWeb, ATViewerOptions.ExtWeb);
    FIniSave.WriteString(csOpt, ccOExtRTF, ATViewerOptions.ExtRTF);

{$IFDEF IVIEW}
    with IViewIntegration do
    begin
      FIniSave.WriteBool(csOpt, ccOIViewEnabled, Enabled);
      FIniSave.WriteString(csOpt, ccOIViewExeName, ExeName);
      FIniSave.WriteString(csOpt, ccOIViewExtList, ExtList);
      FIniSave.WriteBool(csOpt, ccOIViewPriority, HighPriority);
    end;
{$ENDIF}

{$IFDEF IJL}
    with IJLIntegration do
    begin
      FIniSave.WriteBool(csOpt, ccOIJLEnabled, Enabled);
      FIniSave.WriteString(csOpt, ccOIJLExtList, ExtList);
    end;
{$ENDIF}
  end;

  SaveShortcuts;

  FIniSave.UpdateFile;
  FIniHistSave.UpdateFile;
end;

procedure TFormViewUV.LoadMargins;
begin
  with Viewer do
  begin
    MarginLeft := FIni.ReadFloat(csPrintOpt, ccPMarginL, MarginLeft);
    MarginTop := FIni.ReadFloat(csPrintOpt, ccPMarginT, MarginTop);
    MarginRight := FIni.ReadFloat(csPrintOpt, ccPMarginR, MarginRight);
    MarginBottom := FIni.ReadFloat(csPrintOpt, ccPMarginB, MarginBottom);
    PrintFooter := FIni.ReadBool(csPrintOpt, ccPFooter, PrintFooter);
  end;
end;

procedure TFormViewUV.SaveMargins;
begin
  with Viewer do
  begin
    FIniSave.WriteFloat(csPrintOpt, ccPMarginL, MarginLeft);
    FIniSave.WriteFloat(csPrintOpt, ccPMarginT, MarginTop);
    FIniSave.WriteFloat(csPrintOpt, ccPMarginR, MarginRight);
    FIniSave.WriteFloat(csPrintOpt, ccPMarginB, MarginBottom);
    FIniSave.WriteBool(csPrintOpt, ccPFooter, PrintFooter);
  end;
  FIniSave.UpdateFile;
end;

procedure TFormViewUV.FormCreate(Sender: TObject);
begin
  //Init;

  Appactive := false;

  FKeyStorage := TElSSHMemoryKeyStorage.Create(Self);
  SftpClient.KeyStorage := FKeyStorage;

  //Dialogs
  OpenDialog1 := TTntOpenDialog.Create(Self);
  SaveDialog1 := TTntSaveDialog.Create(Self);
  OpenDialog1.Options := OpenDialog1.Options + [ofFileMustExist];
  OpenDialog1.Filter := '*.*|*.*';
  SaveDialog1.Filter := '*.*|*.*';

  //Fix Vista 'Alt' key
  if IsWindowsVista then
    TVistaAltFix.Create(Self);

  //Fix ImageList
  FixImageList32Bit(ImageList1);
  FixImageList32Bit(ImageListS);

  //Init configs
  FIniName := '';
  FIniNameHist := '';
  FIniNameLS := '';
  FIni := nil;
  FIniHist := nil;
  FIniSave := nil;
  FIniHistSave := nil;
  InitConfigs;

  //Init fields
  FFileName := '';
  FFileFolder := '';
  FFileFolderSave := '';
  FPicture := nil;

  FFileList := TATFileList.Create;
  FRecentList := TTntStringList.Create;
  FToolbarList := TToolbarList.Create(ImageList1, cToolbarListDefault);
  FFormFindProgress := nil;
  FFindHistory := TTntStringList.Create;
  FFindText := '';
  FFindWords := false;
  FFindCase := false;
  FFindBack := false;
  FFindHex := false;
  FFindRegex := false;
  FFindMLine := false;
  FFindOrigin := false;
  FGotoMode := vgPercent;
  FFileNextMsg := true;
  FFileMoveDelay := 800;

  FIconsName := '';
  FSingleInstance := false;
  FViewerTitle := 1; //Name only
  FViewerMode := 0; //Autodetect
  FViewerOptPage := -1;

  FShowMenu := true;
  FShowStatusBar := true;
  FShowFullScreen := false;
  FShowNoFindError := false;
  FShowNoFindReset := false;
  FShowFindSelection := false;
  FMediaAutoAdvance := true;
  FMediaFitWindow := false;
  FImageLabelVisible := true;
  FImageLabelColor := clBlue;
  FImageLabelColorErr := clRed;

  FSaveRecents := true;
  FSavePosition := true;
  FSaveSearch := true;
  FSaveFolder := false;

  FPluginsTotalcmdVar := false;
  FPluginsHideKeys := false;

  FQuickViewMode := false;
  FNoTaskbarIcon := false;
  FBoundsRectOld := Rect(0, 0, 0, 0);
  FActivateBusy := false;

{$IFDEF CMDLINE}
  FStartupPosDo := false;
  FStartupPosLine := false;
  FStartupPosPercent := false;
  FStartupPos := 0;
  FStartupPrint := false;
  FNavHandle := 0;
{$ENDIF}

  //Load options, plugins and tools
  LoadUserTools;
  LoadOptions;
  LoadPluginsOptions;

  //Init Drag&Drop
  DragAcceptFiles(Self.Handle, true);

  //Init event handlers
  Viewer.OnOptionsChange := ViewerOptionsChange;
  Viewer.OnPluginsBeforeLoading := ViewerPluginsBeforeLoading;
  Viewer.OnPluginsAfterLoading := ViewerPluginsAfterLoading;
  Viewer.OnWebStatusTextChange := ViewerStatusTextChange;
  Viewer.OnWebTitleChange := ViewerTitleChange;

  Application.OnActivate := AppOnActivate;
  Application.OnMessage := AppOnMessage;

{$IFDEF CMDLINE}
  FFileName := ReadCommandLine;
{$ENDIF}
end;

procedure TFormViewUV.FormDestroy(Sender: TObject);
begin
  //Save options, when not in QV mode
  if not FQuickViewMode then
    SaveOptionsInt;

  //Close Nav
{$IFDEF CMDLINE}
  ShowNav := false;
{$ENDIF}

  //Free objects
  FreeAndNil(FToolbarList);
  FreeAndNil(FFindHistory);
  FreeAndNil(FRecentList);
  FreeAndNil(FFileList);

  FreeAndNil(FIni);
  FreeAndNil(FIniHist);
  FreeAndNil(FIniSave);
  FreeAndNil(FIniHistSave);

  if Assigned(FFormFindProgress) then
  begin
    FFormFindProgress.Release;
    FFormFindProgress := nil;
  end;
end;

procedure TFormViewUV.UpdateCaption(
  const APluginName: string = '';
  ABeforeLoading: boolean = true;
  const AWebTitle: WideString = '');
var
  sFileName: WideString;
  sPluginName: string;
  sResult: WideString;
begin
  //Viewer.FileName contains both file and folder names:
  case FViewerTitle of
    0: sFileName := Viewer.FileName;
    1: sFileName := SExtractFileName(Viewer.FileName);
  end;

  if sFileName = '' then
  begin
    sResult := MsgViewerCaption;
  end
  else
  begin
    sResult := '';

    //If web title passed
    if AWebTitle <> '' then
      sFileName := AWebTitle + ' (' + sFileName + ')';

    //If @Filelist read, show number in square brackets:
    if FFileList.Locked then
      sResult := sResult + Format(' [%d/%d]', [FFileList.ListIndex + 1,
        FFileList.Count]);

    sResult := sResult + ' - ' + MsgViewerCaption;

    //Show plugin name
    if APluginName <> '' then
    begin
      if ABeforeLoading then
        sResult := sResult + Format(' (%s...)', [APluginName]);
    end
    else
    begin
      sPluginName := Viewer.ActivePluginName;
      if sPluginName <> '' then
        sResult := sResult + Format(' (%s)', [sPluginName]);
    end;
  end;

  Caption := sFileName + sResult;
  TntApplication.Title := SExtractFileName(sFileName) + sResult;
end;

function TFormViewUV.PluginPresent(const AFileName: TWlxFilename): boolean;
var
  i: integer;
begin
  Result := false;
  for i := Low(FPluginsList) to High(FPluginsList) do
    with FPluginsList[i] do
      if UpperCase(FFileName) = UpperCase(AFileName) then
      begin
        Result := true;
        Break
      end;
end;

function TFormViewUV.LoadArc(const AFileName: WideString): boolean;
var
  SPluginsFolder: WideString;
  SDesc, SType, SDefDir,
    sAdded, sDups: string;
  SPlugin: string;
begin
  Result := FArchiveProp(AFileName, SDesc, SType, SDefDir);
  if not Result then
    Exit;

  Result := (SDesc <> '') and (SType <> '');
  if not Result then
    Exit;

  if LowerCase(SType) <> 'wlx' then
  begin
    MsgError(Format(MsgViewerPluginUnsup, [SType]));
    Exit
  end;

  if MsgBox(
    Format(MsgViewerPluginSup, [SDesc]),
    MsgViewerCaption,
    MB_OKCANCEL or MB_ICONINFORMATION, Handle) <> IDOK then
    Exit;

  SPluginsFolder := ConfigFolder + '\Plugins';
  FCreateDir(SPluginsFolder);

  if FAddPluginZip(AFileName, SPluginsFolder, Handle, SPlugin) then
  begin
    if PluginPresent(SPlugin) then
    begin
      sAdded := '';
      sDups := SPluginName(SPlugin) + #13;
    end
    else
    begin
      sAdded := SPluginName(SPlugin) + #13;
      sDups := '';
      if FPluginsNum < High(TPluginsList) then
      begin
        Inc(FPluginsNum);
        FPluginsList[FPluginsNum].FFileName := SPlugin;
        FPluginsList[FPluginsNum].FDetectStr := WlxGetDetectString(SPlugin);
        FPluginsList[FPluginsNum].FEnabled := True;
        Viewer.AddPlugin(
          FPluginsList[FPluginsNum].FFileName,
          FPluginsList[FPluginsNum].FDetectStr);
        SavePluginsOptions;
      end;
    end;
    MsgInstall(sAdded, sDups, True, Handle);
  end;
end;

function TFormViewUV.LoadFile(
  const AFileName: WideString;
  AKeepList: boolean = false;
  APicture: TPicture = nil): boolean;
var
  S: WideString;
begin
  //Handle folder name
  if IsDirExist(AFileName) then
  begin
    FFileName := '';
    FFileFolder := AFileName;

    Result := Viewer.OpenFolder(FFileFolder);
    Viewer.ModeDetect := true;

    UpdateOptions(true);
{$IFDEF CMDLINE}
    NavSync;
{$ENDIF}
    Exit;
  end;

  //Handle archive with plugin
  if SFileExtensionMatch(AFileName, 'zip,rar') then
    if LoadArc(AFileName) then
    begin
      FFileName := '';
      FFileFolder := '';
      Result := Viewer.Open('');
      UpdateOptions(true);
      Exit;
    end;

  //Filename is expanded inside ATViewer, do the same here
  //for commands "Save as", "Move" etc to work properly.
  FFileName := FGetFullPathName(AFileName);
  FPicture := APicture;

  if not AKeepList then
  begin
    FFileList.Locked := false; //Clear filelist
    if IsFilenameFixed(FFileName) then //Get file number, if not floppy:
      FFileList.GetNext(FFileName, nfCurrent);
  end;

  try
    if FResolveLinks and (UpperCase(SExtractFileExt(FFileName)) = '.LNK') then
    begin
      S := FLinkInfo(FFileName);
      if not IsFileExist(S) then
      begin
        S := '';
        FFileName := ''
      end;
      Result := Viewer.Open(S, FPicture);
      Viewer.ModeDetect := true;
    end
    else
    begin
      Result := Viewer.Open(FFileName, FPicture);
      Viewer.ModeDetect := true;
    end;

    //Wait for MHT, it may give exception:
    if IsMHT then
      Viewer.WebWait;
  except
    on E: Exception do
      MsgError(E.Message);
  end;

  if FFileName <> '' then
    if Result then
    begin
      AddRecent(FFileName);
      FFileFolder := SExtractFileDir(FFileName);
{$IFDEF CMDLINE}
      NavSync;
{$ENDIF}
    end
    else
    begin
      FFileName := '';
    end;
  UpdateOptions(true);
end;

procedure TFormViewUV.FormShow(Sender: TObject);
var
  AKeepList: boolean;
begin
{$I Lang.FormView.inc}

  ApplyToolbarCaptions;
  SetForegroundWindow(Application.Handle); //For focusing taskbar button
  Application.BringToFront; //For bringing to front

  AKeepList := (FFileList.Count > 0);
  LoadFile(FFileName, AKeepList, FPicture);
  TimerShow.Enabled := true; //Start timer for changing view position

end;

procedure TFormViewUV.mnuFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormViewUV.mnuFileOpenClick(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    FileName := FFileName;
    if FFileFolder <> '' then
      InitialDir := FFileFolder;
    if Execute then
      LoadFile(FileName);
  end;
end;

procedure TFormViewUV.mnuFileSaveAsClick(Sender: TObject);
var
  OK: boolean;
begin
  with SaveDialog1 do
  begin
    if FSaveFolder then
    begin
      FileName := WideExtractFileName(FFileName);
      InitialDir := FFileFolderSave;
      if InitialDir = '' then
        InitialDir := WideExtractFileDir(FFileName);
    end
    else
    begin
      FileName := WideChangeFileExt(FFileName, ' (2)' +
        WideExtractFileExt(FFileName));
      InitialDir := WideExtractFileDir(FFileName);
    end;

    if Execute then
    begin
      FFileFolderSave := WideExtractFileDir(FileName);

      try
        Screen.Cursor := crHourGlass;
        OK := FFileCopy(FFileName, FileName);
      finally
        Screen.Cursor := crDefault;
      end;

      if not OK then
        MsgCopyMoveError(FFileName, FileName);
    end;
  end;
end;

procedure TFormViewUV.UpdateOptions(AUpdateFitWindow: boolean = false);
var
  En, En2,
    IsText, IsTextVar, IsTextAnsi, IsTextBH,
    IsHex, IsMedia, IsWeb, IsImage, IsIcon, IsMMedia, IsWMP,
    IsSearch, IsSearchNext, IsSearchPrev,
    IsPrint, IsPrintPreview,
    IsWLX, IsWLXSearch, IsWLXPrint, IsWLXCmd: boolean;
  AMode: TATViewerMode;
  AEnc: TATEncoding;
  N: integer;
begin
  UpdateCaption;

  En := FFileName <> ''; //File is loaded
  En2 := Viewer.FileName <> ''; //File or folder is loaded
  AMode := Viewer.Mode;
  AEnc := Viewer.TextEncoding;

  IsText := AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF];
  IsTextBH := AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode];
  IsTextVar := AMode in [vmodeText, vmodeUnicode, vmodeRTF];
  IsTextAnsi := AMode in [vmodeText, vmodeBinary, vmodeHex];
  IsHex := AMode = vmodeHex;
  IsMedia := AMode = vmodeMedia;
  IsWeb := AMode = vmodeWeb;

  IsImage := IsMedia and Viewer.IsImage;
  IsIcon := IsMedia and Viewer.IsIcon;
  IsMMedia := IsMedia and Viewer.IsMedia;
  IsWMP := IsMMedia{$IFDEF MEDIA_PLAYER} and (Viewer.MediaMode <>
    vmmodeMCI){$ENDIF};

  IsWLX := (AMode = vmodeWLX) and (Viewer.ActivePluginName <> '');
  IsWLXSearch := Viewer.ActivePluginSupportsSearch;
  IsWLXPrint := Viewer.ActivePluginSupportsPrint;
  IsWLXCmd := Viewer.ActivePluginSupportsCommands;

  IsSearch := (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode,
    vmodeRTF, vmodeWeb]);
  IsSearchNext := (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode,
    vmodeRTF]);
  IsSearchPrev := (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode]) and
    Viewer.SearchStarted and (not FFindRegex);
  IsPrint := (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode,
    vmodeRTF, vmodeWeb]) or IsImage;
  IsPrintPreview := (AMode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode,
    vmodeWeb]) or IsImage;

  with FToolbarList do
  begin
    Update(mnuFileSaveAs, integer(En));
    Update(mnuFileReload, integer(En2));
    Update(mnuFileClose, integer(En2));

    Update(mnuFilePrint, integer(En2 and (IsPrint or (IsWLX and IsWLXPrint))));
    Update(mnuFilePrintSetup, integer(En2 and (IsPrint or (IsWLX and
      IsWLXPrint))));
    Update(mnuFilePrintPreview, {$IFDEF PREVIEW}integer(En and
      IsPrintPreview){$ELSE}0{$ENDIF});

    Update(mnuFileNext, integer(En));
    Update(mnuFilePrev, integer(En));
    Update(mnuFileDelete, integer(En));
    Update(mnuFileCopyFN, integer(En));
    Update(mnuFileProp, integer(En));

    Update(mnuFileRename, {$IFDEF CMDLINE}integer(En){$ELSE}0{$ENDIF});
    Update(mnuFileCopy, {$IFDEF CMDLINE}integer(En){$ELSE}0{$ENDIF});
    Update(mnuFileMove, {$IFDEF CMDLINE}integer(En){$ELSE}0{$ENDIF});
    Update(mnuFileEmail, {$IFDEF CMDLINE}integer(En){$ELSE}0{$ENDIF});

    Update(mnuEditCopy, integer(En2 and (IsText or (IsImage and (not IsIcon)) or
      IsWeb or (IsWLX and IsWLXCmd))));
    Update(mnuEditCopyHex, integer(En and IsHex));
    Update(mnuEditCopyToFile, integer(En and IsText));
    Update(mnuEditSelectAll, integer(En2 and (IsText or IsWeb or (IsWLX and
      IsWLXCmd))));
    Update(mnuEditFind, integer(En2 and (IsSearch or (IsWLX and IsWLXSearch))));
    Update(mnuEditFindNext, integer(En2 and (IsSearchNext or (IsWLX and
      IsWLXSearch))));
    Update(mnuEditFindPrev, integer(En and IsSearchPrev));
    Update(mnuEditGoto, integer(En2 and (IsText or IsWeb or (IsWLX and
      IsWLXCmd))));

    Update(mnuViewModeMenu, integer(En));
    Update(mnuViewMode1, integer(En), integer(AMode = vmodeText));
    Update(mnuViewMode2, integer(En), integer(AMode = vmodeBinary));
    Update(mnuViewMode3, integer(En), integer(AMode = vmodeHex));
    Update(mnuViewMode4, integer(En), integer(AMode = vmodeMedia));
    Update(mnuViewMode5, integer(En), integer(AMode = vmodeWeb));
    Update(mnuViewMode6, integer(En), integer(AMode = vmodeUnicode));
    Update(mnuViewMode7, integer(En2), integer(AMode = vmodeWLX));
    Update(mnuViewMode8, integer(En), integer(AMode = vmodeRTF));

    mnuModes1.Checked := mnuViewMode1.Checked;
    mnuModes2.Checked := mnuViewMode2.Checked;
    mnuModes3.Checked := mnuViewMode3.Checked;
    mnuModes4.Checked := mnuViewMode4.Checked;
    mnuModes5.Checked := mnuViewMode5.Checked;
    mnuModes6.Checked := mnuViewMode6.Checked;
    mnuModes7.Checked := mnuViewMode7.Checked;
    mnuModes8.Checked := mnuViewMode8.Checked;

    //Update modes menu icon
    case AMode of
      vmodeText: N := mnuViewMode1.ImageIndex;
      vmodeBinary: N := mnuViewMode2.ImageIndex;
      vmodeHex: N := mnuViewMode3.ImageIndex;
      vmodeMedia: N := mnuViewMode4.ImageIndex;
      vmodeWeb: N := mnuViewMode5.ImageIndex;
      vmodeUnicode: N := mnuViewMode6.ImageIndex;
      vmodeWlx: N := mnuViewMode7.ImageIndex;
    else
      N := mnuViewMode8.ImageIndex;
    end;
    FToolbarList.UpdateImageIndex(mnuViewModeMenu, N);

    Update(mnuViewTextEncSubmenu, integer(En2));
    Update(mnuViewTextANSI, integer(En2 and (IsTextAnsi or (IsWLX and
      IsWLXCmd))), integer(AEnc = vencANSI));
    Update(mnuViewTextOEM, integer(En2 and (IsTextAnsi or (IsWLX and
      IsWLXCmd))), integer(AEnc = vencOEM));
    Update(mnuViewTextEBCDIC, integer(En and IsTextAnsi), integer(AEnc =
      vencEBCDIC));
    Update(mnuViewTextKOI8, integer(En and IsTextAnsi), integer(AEnc =
      vencKOI8));
    Update(mnuViewTextISO, integer(En and IsTextAnsi), integer(AEnc = vencISO));
    Update(mnuViewTextMac, integer(En and IsTextAnsi), integer(AEnc = vencMac));
    Update(mnuViewTextEncPrev, integer(En and IsTextAnsi));
    Update(mnuViewTextEncNext, integer(En and IsTextAnsi));
    Update(mnuViewTextEncMenu, integer(En and IsTextBH));
    Update(mnuViewTextWrap, integer(En2 and (IsTextVar or (IsWLX and
      IsWLXCmd))), integer(Viewer.TextWrap));
    Update(mnuViewTextNonPrint, integer(En and IsTextBH),
      integer(Viewer.TextNonPrintable));
    Update(mnuViewTextTail, integer(En and IsTextBH), integer(FollowTail));

    Update(mnuViewZoomIn, integer(En and (IsText or IsWeb or
      (IsImage and (Viewer.ImageScale <
        cViewerImageScales[High(cViewerImageScales)])))));
    Update(mnuViewZoomOut, integer(En and (IsText or IsWeb or
      (IsImage and (Viewer.ImageScale >
        cViewerImageScales[Low(cViewerImageScales)])))));
    Update(mnuViewZoomOriginal, integer(En and IsImage));

    Update(mnuViewWebGoBack, integer(En and IsWeb));
    Update(mnuViewWebGoForward, integer(En and IsWeb));
    Update(mnuViewWebOffline, {$IFDEF OFFLINE}integer(En and IsWeb),
      integer(Viewer.WebOffline){$ELSE}0, 0{$ENDIF});

    Update(mnuViewImageFit, integer(En2 and (IsMedia or (IsWLX and IsWLXCmd))),
      integer(Viewer.MediaFit));
    Update(mnuViewImageFitOnlyBig, integer(En2 and (IsImage or (IsWLX and
      IsWLXCmd)) and Viewer.MediaFit), integer(Viewer.MediaFitOnlyBig));
    Update(mnuViewImageCenter, integer(En2 and (IsImage or (IsWLX and
      IsWLXCmd))), integer(Viewer.MediaCenter));
    Update(mnuViewImageFitWindow, integer(En and IsImage),
      integer(MediaFitWindow));

    Update(mnuViewImageShowEXIF, {$IFDEF EXIF}integer(En and
      IsImage){$ELSE}0{$ENDIF});
    Update(mnuViewImageRotateRight, integer(En and IsImage), 0, integer(En and
      IsImage));
    Update(mnuViewImageRotateLeft, integer(En and IsImage), 0, integer(En and
      IsImage));
    Update(mnuViewImageFlipVert, integer(En and IsImage), 0, integer(En and
      IsImage));
    Update(mnuViewImageFlipHorz, integer(En and IsImage), 0, integer(En and
      IsImage));
    Update(mnuViewImageGrayscale, integer(En and IsImage), 0, integer(En and
      IsImage));
    Update(mnuViewImageNegative, integer(En and IsImage), 0, integer(En and
      IsImage));
    Update(mnuViewImageShowLabel, integer(En and IsImage),
      integer(FImageLabelVisible), integer(En and IsImage));

    Update(mnuViewMediaEffect, integer(En and IsImage));
    Update(mnuViewMediaPlayback, integer(En and IsMMedia));
    Update(mnuViewMediaPlayPause, integer(En and IsMMedia), 0, integer(En and
      IsMMedia));
    Update(mnuViewMediaLoop, integer(En and IsWMP), integer(Viewer.MediaLoop),
      integer(En and IsWMP));
    Update(mnuViewMediaVolumeUp, integer(En and IsWMP), 0, integer(En and
      IsWMP));
    Update(mnuViewMediaVolumeDown, integer(En and IsWMP), 0, integer(En and
      IsWMP));
    Update(mnuViewMediaVolumeMute, integer(En and IsWMP),
      integer(Viewer.MediaMute), integer(En and IsWMP));

    Update(mnuViewShowMenu, 1, integer(ShowMenu));
    Update(mnuViewShowToolbar, 1, integer(ShowToolbar));
    Update(mnuViewShowStatusbar, 1, integer(ShowStatusBar));
    Update(mnuViewShowNav, {$IFDEF CMDLINE}integer(not ShowFullScreen),
      integer(ShowNav){$ELSE}0, 0{$ENDIF});
    Update(mnuViewAlwaysOnTop, 1, integer(ShowOnTop));
    Update(mnuViewFullScreen, 1, integer(ShowFullScreen));

    N := NumOfUserTools(FUserTools);
    Update(mnuUserTool1, integer(En), 0, integer(N >= 1));
    Update(mnuUserTool2, integer(En), 0, integer(N >= 2));
    Update(mnuUserTool3, integer(En), 0, integer(N >= 3));
    Update(mnuUserTool4, integer(En), 0, integer(N >= 4));
    Update(mnuUserTool5, integer(En), 0, integer(N >= 5));
    Update(mnuUserTool6, integer(En), 0, integer(N >= 6));
    Update(mnuUserTool7, integer(En), 0, integer(N >= 7));
    Update(mnuUserTool8, integer(En), 0, integer(N >= 8));

{$IFNDEF HELP}
    Update(mnuHelpContents, 0);
{$ENDIF}
  end;

  UpdateImageLabel;
  UpdateStatusBar;
  UpdateShortcuts;

  if AUpdateFitWindow then
  begin
    UpdateFitWindow(true);
    if Viewer.MediaFit then
      UpdateFitWindow(false);
  end;

  if IsImage then
    if Assigned(Viewer.ImageBox) then
    begin
      Viewer.ImageBox.PopupMenu := MenuImage;
      CopyMenuItem(mnuViewImageFit, mnuImageFit);
      CopyMenuItem(mnuViewImageFitOnlyBig, mnuImageFitOnlyBig);
      CopyMenuItem(mnuViewImageCenter, mnuImageCenter);
      CopyMenuItem(mnuViewImageFitWindow, mnuImageFitWindow);
      CopyMenuItem(mnuViewImageShowEXIF, mnuImageShowEXIF);
      CopyMenuItem(mnuViewImageShowLabel, mnuImageShowLabel);
      CopyMenuItem(mnuViewImageRotateRight, mnuImageRotateRight);
      CopyMenuItem(mnuViewImageRotateLeft, mnuImageRotateLeft);
      CopyMenuItem(mnuViewImageFlipVert, mnuImageFlipVert);
      CopyMenuItem(mnuViewImageFlipHorz, mnuImageFlipHorz);
      CopyMenuItem(mnuViewImageGrayscale, mnuImageGrayscale);
      CopyMenuItem(mnuViewImageNegative, mnuImageNegative);
    end;
end;

procedure TFormViewUV.mnuFileCloseClick(Sender: TObject);
begin
  CloseFile;
end;

procedure TFormViewUV.mnuViewMode1Click(Sender: TObject);
begin
  Viewer.Mode := vmodeText;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode3Click(Sender: TObject);
begin
  Viewer.Mode := vmodeHex;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode2Click(Sender: TObject);
begin
  Viewer.Mode := vmodeBinary;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode4Click(Sender: TObject);
begin
  Viewer.Mode := vmodeMedia;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode5Click(Sender: TObject);
begin
  Viewer.WebWaitForNavigate := false; //No need to wait here
  Viewer.Mode := vmodeWeb;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode6Click(Sender: TObject);
begin
  Viewer.Mode := vmodeUnicode;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode8Click(Sender: TObject);
begin
  Viewer.Mode := vmodeRTF;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMode7Click(Sender: TObject);
begin
  Viewer.Mode := vmodeWLX;
  UpdateOptions;
  ResizePlugin;
end;

procedure TFormViewUV.mnuViewTextANSIClick(Sender: TObject);
begin
  Viewer.TextEncoding := vencANSI;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextOEMClick(Sender: TObject);
begin
  Viewer.TextEncoding := vencOEM;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextKOI8Click(Sender: TObject);
begin
  Viewer.TextEncoding := vencKOI8;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextEBCDICClick(Sender: TObject);
begin
  Viewer.TextEncoding := vencEBCDIC;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextISOClick(Sender: TObject);
begin
  Viewer.TextEncoding := vencISO;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextMacClick(Sender: TObject);
begin
  Viewer.TextEncoding := vencMac;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextWrapClick(Sender: TObject);
begin
  Viewer.TextWrap := not Viewer.TextWrap;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextNonPrintClick(Sender: TObject);
begin
  Viewer.TextNonPrintable := not Viewer.TextNonPrintable;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextTailClick(Sender: TObject);
begin
  FollowTail := not FollowTail;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageFitClick(Sender: TObject);
begin
  Viewer.MediaFit := not Viewer.MediaFit;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageFitOnlyBigClick(Sender: TObject);
begin
  Viewer.MediaFitOnlyBig := not Viewer.MediaFitOnlyBig;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageCenterClick(Sender: TObject);
begin
  Viewer.MediaCenter := not Viewer.MediaCenter;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewWebOfflineClick(Sender: TObject);
begin
{$IFDEF OFFLINE}
  Viewer.WebOffline := not Viewer.WebOffline;
{$ENDIF}
  UpdateOptions;
end;

procedure TFormViewUV.SearchPrepareAndStart;
var
  fString: WideString;
  fStringA: string;
  fOptions: TATStreamSearchOptions;
  i: integer;
begin
  if FFindHex then
  begin
    if not SHexToNormal(FFindText, fStringA) then
    begin
      MsgWarning(SFormatW(MsgViewerErrInvalidHex, [FFindText]), Handle);
      Exit
    end;
    fString := fStringA;
  end
  else
  begin
    fString := FFindText;
    if not FFindRegex then
      SDecodeSearchW(fString);
  end;

  with FFindHistory do
  begin
    i := IndexOf(FFindText);
    if i >= 0 then
      Delete(i);
    Insert(0, FFindText);
  end;

  fOptions := [];
  if FFindWords then
    Include(fOptions, asoWholeWords);
  if FFindCase then
    Include(fOptions, asoCaseSens);
  if FFindBack then
    Include(fOptions, asoBackward);
{$IFDEF REGEX}
  if FFindRegex then
    Include(fOptions, asoRegex);
  if FFindMLine then
    Include(fOptions, asoRegexMLine);
{$ENDIF}
  if FFindOrigin then
    Include(fOptions, asoFromPage);

  InitFormFindProgress;
  if Assigned(FFormFindProgress) then
    with TFormViewFindProgress(FFormFindProgress) do
    begin
      FViewer := Viewer;
      FFindText := fString;
      FFindTextOrig := FFindText;
      FFindOptions := fOptions;
      FFindFirst := true;
      FShowNoErrorMsg := Self.FShowNoFindError;
      StartSearch;
    end;
end;

function TFormViewUV.SelTextShort: WideString;
begin
  if Viewer.Mode = vmodeUnicode then
    Result := Viewer.TextSelTextShortW
  else
    Result := Viewer.TextSelTextShort;

  //Strip leading CRs
  while (Result <> '') and (Pos(Result[1], #13#10) > 0) do
    Delete(Result, 1, 1);

  //Leave only first line
  SDeleteFromStrW(Result, #13);
  SDeleteFromStrW(Result, #10);
end;

procedure TFormViewUV.DoFindFirst;
var
  OK: boolean;
  i: integer;
begin
  //Try to show custom dialog
  //in Internet/Plugins mode
  if Viewer.FindDialog(false) then
    Exit;

  //Show our own dialog
  with TFormViewFindText.Create(Self) do
    try
      with FFindHistory do
        for i := 0 to Count - 1 do
          edText.Items.Add(Strings[i]);

      if FShowFindSelection then
        edText.Text := SelTextShort;
      if edText.Text = '' then
        edText.Text := FFindText;
      chkWords.Checked := FFindWords;
      chkCase.Checked := FFindCase;
      chkHex.Checked := FFindHex;
      chkRegex.Checked := FFindRegex;
      chkMLine.Checked := FFindMLine;
      chkDirBackward.Checked := FFindBack;
      chkDirForward.Checked := not chkDirBackward.Checked;
      chkOriginCursor.Checked := FFindOrigin;
      chkOriginEntire.Checked := not chkOriginCursor.Checked;

      BackEnabled := Viewer.Mode <> vmodeRTF;
      HexEnabled := Viewer.Mode <> vmodeUnicode;
{$IFDEF REGEX}
      RegexEnabled := ((Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex]) and
        (Viewer.TextEncoding in [vencANSI, vencOEM]))
        or (Viewer.Mode = vmodeUnicode);
{$ELSE}
      RegexEnabled := false;
{$ENDIF}
      OriginEnabled := Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex,
        vmodeUnicode, vmodeRTF];

      OK := (ShowModal = mrOk) and (edText.Text <> '');
      if OK then
      begin
        FFindText := edText.Text;
        FFindWords := chkWords.Checked;
        FFindCase := chkCase.Checked;
        FFindHex := chkHex.Checked;
        FFindRegex := chkRegex.Checked;
        FFindMLine := chkMLine.Checked;
        FFindBack := chkDirBackward.Checked;
        FFindOrigin := chkOriginCursor.Checked;
      end;
    finally
      Release;
    end;

  if OK then
    SearchPrepareAndStart;
end;

procedure TFormViewUV.DoFindNext(AFindPrevious: boolean = false);
begin
  //Try to show custom search dialog
  //in Internet/Plugins modes
  if Viewer.FindDialog(true) then
    Exit;

  if Viewer.SearchStarted then
    //Continue search, or start search again
    //(when search is finished and option is on)
  begin
    InitFormFindProgress;
    if Assigned(FFormFindProgress) then
      with TFormViewFindProgress(FFormFindProgress) do
      begin
        FViewer := Viewer;
        FFindFirst := Self.FShowNoFindError and Viewer.SearchFinished;
        FFindPrevious := AFindPrevious;
        FShowNoErrorMsg := Self.FShowNoFindError;
        StartSearch;
      end;
  end
  else
  begin
    if Self.FShowNoFindReset and (FFindText <> '') then
      //Start search with previously saved params
      //(when option is on)
      SearchPrepareAndStart
    else
      //Show search dialog
      mnuEditFindClick(Self)
  end;
end;

procedure TFormViewUV.mnuEditFindClick(Sender: TObject);
begin
  DoFindFirst;
  UpdateOptions;
end;

procedure TFormViewUV.mnuEditFindNextClick(Sender: TObject);
begin
  DoFindNext;
  UpdateOptions;
end;

procedure TFormViewUV.mnuEditFindPrevClick(Sender: TObject);
begin
  DoFindNext(true);
  UpdateOptions;
end;

function TFormViewUV.TextNotSelected: boolean;
begin
  Result :=
    (Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode, vmodeRTF])
      and
    (Viewer.TextSelLength = 0);
end;

procedure TFormViewUV.mnuEditCopyClick(Sender: TObject);
begin
  if TextNotSelected then
  begin
    MsgTextNotSelected;
    Exit;
  end;
  Viewer.CopyToClipboard;
end;

procedure TFormViewUV.mnuEditCopyHexClick(Sender: TObject);
begin
  if TextNotSelected then
  begin
    MsgTextNotSelected;
    Exit;
  end;
  Viewer.CopyToClipboard(true);
end;

procedure TFormViewUV.mnuEditSelectAllClick(Sender: TObject);
begin
  Viewer.SelectAll;
end;

{
procedure TFormViewUV.Unfocus;
begin
  Viewer.IsFocused:= false;
  with TButton.Create(nil) do
    try
      Parent:= Self;
      Caption:= '';
      SetBounds(0, 0, 20, 2);
      SetFocus;
    finally
      Free;
    end;
end;
}

procedure TFormViewUV.mnuHelpAboutClick(Sender: TObject);
begin
 Showmessage('Rubrika Doc Viewer - 2013');
  (*
  with TFormViewAbout.Create(Self) do
    try
      labVersion.Caption:= Format('%s %s (%s)', [
        MsgCaption(411),
        cViewerVersion + cViewerBuild,
        cViewerDate ]);
      memoCredits.Lines.Add(cViewerComps);
      memoCredits.SelStart:= 0;
      ShowModal;
    finally
      Release;
    end;
   *)
end;

procedure TFormViewUV.mnuFilePrintClick(Sender: TObject);
begin
  InitPreview;
  Viewer.PrintDialog;
  SaveMargins;
end;

procedure TFormViewUV.mnuFilePrintPreviewClick(Sender: TObject);
begin
  InitPreview;
  Viewer.PrintPreview;
  SaveMargins;
end;

procedure TFormViewUV.mnuFilePrintSetupClick(Sender: TObject);
begin
  Viewer.PrintSetup;
  SaveMargins;
end;

procedure TFormViewUV.mnuOptionsConfigureClick(Sender: TObject);
var
  ALanguage: string;
  AIcons: string;
  AExtension: boolean;
begin
  with TFormViewOptions.Create(Self) do
    try
      //Restore last page
      if FViewerOptPage >= 0 then
        PageControl1.ActivePageIndex := FViewerOptPage
      else
        PageControl1.ActivePage := tabIntf;

      if IsImageListSaved then
        ffImgList := ImageListS
      else
        ffImgList := ImageList1;

      ffToolbar := FToolbarList;
      ffClearRecent := ClearRecents;
      ffClearSearch := ClearSearch;

      edText.Text := ATViewerOptions.ExtText;
      edImages.Text := ATViewerOptions.ExtImages;
      edMedia.Text := ATViewerOptions.ExtMedia;
      edInternet.Text := ATViewerOptions.ExtWeb;
      edRTF.Text := ATViewerOptions.ExtRTF;

      ffTextDetect := Viewer.TextDetect;
      ffTextDetectOEM := Viewer.TextDetectOEM;
      ffTextDetectSize := Viewer.TextDetectSize;
      ffTextDetectLimit := Viewer.TextDetectLimit;

      ffTextFontName := Viewer.TextFont.Name;
      ffTextFontSize := Viewer.TextFont.Size;
      ffTextFontColor := Viewer.TextFont.Color;
      ffTextFontStyle := Viewer.TextFont.Style;
      ffTextFontCharset := Viewer.TextFont.CharSet;

      ffTextFontOEMName := Viewer.TextFontOEM.Name;
      ffTextFontOEMSize := Viewer.TextFontOEM.Size;
      ffTextFontOEMColor := Viewer.TextFontOEM.Color;
      ffTextFontOEMStyle := Viewer.TextFontOEM.Style;
      ffTextFontOEMCharset := Viewer.TextFontOEM.CharSet;

      ffFooterFontName := Viewer.TextFontFooter.Name;
      ffFooterFontSize := Viewer.TextFontFooter.Size;
      ffFooterFontColor := Viewer.TextFontFooter.Color;
      ffFooterFontStyle := Viewer.TextFontFooter.Style;
      ffFooterFontCharset := Viewer.TextFontFooter.CharSet;

      ffTextBackColor := Viewer.TextColor;
      ffTextHexColor1 := Viewer.TextColorHex;
      ffTextHexColor2 := Viewer.TextColorHex2;
      ffTextHexColorBack := Viewer.TextColorHexBack;
      ffTextGutterColor := Viewer.TextColorGutter;
      ffTextUrlColor := Viewer.TextColorURL;

      ffMediaColor := Viewer.ImageColor;
      ffMediaColorLabel := FImageLabelColor;
      ffMediaColorLabelErr := FImageLabelColorErr;

      chkTextReload.Checked := Viewer.TextAutoReload;
      chkTextReloadBeep.Checked := Viewer.TextAutoReloadBeep;
      chkTextReloadTail.Checked := Viewer.TextAutoReloadFollowTail;
      chkTextAutoCopy.Checked := Viewer.TextAutoCopy;

      chkTextWidthFit.Checked := Viewer.TextWidthFit;
      chkTextOemSpecial.Checked := Viewer.TextOemSpecial;
      chkTextWrap.Checked := Viewer.TextWrap;
      chkTextURLs.Checked := Viewer.TextUrlHilight;
{$IFNDEF REGEX}
      chkTextURLs.Enabled := false;
      chkTextURLs.Checked := false;
{$ENDIF}

      chkTextNonPrint.Checked := Viewer.TextNonPrintable;
      edTextWidth.Text := IntToStr(Viewer.TextWidth);
      edTextLength.Text := IntToStr(Viewer.TextMaxLengths[vbmodeText]);
      edTextTabSize.Text := IntToStr(Viewer.TextTabSize);

      edSearchIndent.Text := IntToStr(Viewer.TextSearchIndentVert);
      chkSearchSel.Checked := FShowFindSelection;
      chkSearchNoMsg.Checked := FShowNoFindError;

      edMediaMode.ItemIndex := Pred(Ord(Viewer.MediaMode));
      chkMediaStart.Checked := Viewer.MediaAutoPlay;
      chkMediaLoop.Checked := Viewer.MediaLoop;
      edMediaPlayCount.Text := IntToStr(Viewer.MediaPlayCount);

      chkImageFit.Checked := Viewer.MediaFit;
      chkImageFitBig.Checked := Viewer.MediaFitOnlyBig;
      chkImageCenter.Checked := Viewer.MediaCenter;
      chkImageFitWindow.Checked := FMediaFitWindow;
      chkImageLabel.Checked := FImageLabelVisible;

      chkImageResample.Checked := Viewer.ImageResample;
      chkImageResample.Enabled := Win32Platform = VER_PLATFORM_WIN32_NT;
        //Doesn't work under Win9x
      chkImageTransp.Checked := Viewer.ImageTransparent;

      chkWebAcceptAll.Checked := Viewer.WebAcceptAllFiles;
      chkWebOffline.Checked := Viewer.WebOffline;
      chkResolveLinks.Checked := FResolveLinks;
      chkShowHidden.Checked := ShowHidden;
{$IFDEF CMDLINE}
      chkNav.Checked := ShowNav;
{$ENDIF}
      chkShowCfm.Checked := Viewer.ModeUndetectedCfm;

      ALanguage := SMsgLanguage;
      AIcons := IconsName;
      AExtension := IsShellExtensionEnabled;
      ffOptLang := ALanguage;
      ffOptIcon := AIcons;
      chkShell.Checked := AExtension;

      chkMenu.Checked := ShowMenu;
      chkMenuIcons.Checked := ShowMenuIcons;
      chkToolbar.Checked := ShowToolbar;
      chkBorder.Checked := ShowBorder;
      chkStatusBar.Checked := ShowStatusBar;
      chkSingleInst.Checked := FSingleInstance;
      edViewerTitle.ItemIndex := FViewerTitle;
      edViewerMode.ItemIndex := FViewerMode;
      edFileSort.ItemIndex := integer(FFileList.SortOrder);

      chkSaveRecents.Checked := FSaveRecents;
      chkSavePosition.Checked := FSavePosition;
      chkSaveSearch.Checked := FSaveSearch;
      chkSaveFolder.Checked := FSaveFolder;

{$IFNDEF CMDLINE}
      chkNav.Checked := false;
      chkNav.Enabled := false;
      chkShell.Checked := false;
      chkShell.Enabled := false;
      chkSingleInst.Checked := false;
      chkSingleInst.Enabled := false;
{$ENDIF}

{$IFDEF IVIEW}
      with Viewer.IViewIntegration do
      begin
        ffIViewEnabled := Enabled;
        ffIViewExeName := ExeName;
        ffIViewExtList := ExtList;
        ffIViewHighPriority := HighPriority;
      end;
{$ENDIF}

{$IFDEF IJL}
      with Viewer.IJLIntegration do
      begin
        ffIJLEnabled := Enabled;
        ffIJLExtList := ExtList;
      end;
{$ENDIF}

      ffShowGutter := Viewer.TextGutter;
      ffShowLines := Viewer.TextGutterLines;
      ffLinesBufSize := Viewer.TextGutterLinesBufSize div 1024;
      ffLinesCount := Viewer.TextGutterLinesCount;
      ffLinesStep := Viewer.TextGutterLinesStep;
      ffLinesExtUse := Viewer.TextGutterLinesExtUse;
      ffLinesExtList := Viewer.TextGutterLinesExtList;

      with Viewer.TextFontGutter do
      begin
        ffGutterFontName := Name;
        ffGutterFontSize := Size;
        ffGutterFontColor := Color;
        ffGutterFontStyle := Style;
        ffGutterFontCharset := CharSet;
      end;

      if ShowModal = mrOk then
      begin
        //Apply options
        ATViewerOptions.ExtText := edText.Text;
        ATViewerOptions.ExtImages := edImages.Text;
        ATViewerOptions.ExtMedia := edMedia.Text;
        ATViewerOptions.ExtWeb := edInternet.Text;
        ATViewerOptions.ExtRTF := edRTF.Text;

        Viewer.TextDetect := ffTextDetect;
        Viewer.TextDetectOEM := ffTextDetectOEM;
        Viewer.TextDetectSize := ffTextDetectSize;
        Viewer.TextDetectLimit := ffTextDetectLimit;

        Viewer.TextFont.Name := ffTextFontName;
        Viewer.TextFont.Size := ffTextFontSize;
        Viewer.TextFont.Color := ffTextFontColor;
        Viewer.TextFont.Style := ffTextFontStyle;
        Viewer.TextFont.CharSet := ffTextFontCharset;

        Viewer.TextFontOEM.Name := ffTextFontOEMName;
        Viewer.TextFontOEM.Size := ffTextFontOEMSize;
        Viewer.TextFontOEM.Color := ffTextFontOEMColor;
        Viewer.TextFontOEM.Style := ffTextFontOEMStyle;
        Viewer.TextFontOEM.CharSet := ffTextFontOEMCharset;

        Viewer.TextFontFooter.Name := ffFooterFontName;
        Viewer.TextFontFooter.Size := ffFooterFontSize;
        Viewer.TextFontFooter.Color := ffFooterFontColor;
        Viewer.TextFontFooter.Style := ffFooterFontStyle;
        Viewer.TextFontFooter.CharSet := ffFooterFontCharset;

        Viewer.TextColor := ffTextBackColor;
        Viewer.TextColorHex := ffTextHexColor1;
        Viewer.TextColorHex2 := ffTextHexColor2;
        Viewer.TextColorHexBack := ffTextHexColorBack;
        Viewer.TextColorGutter := ffTextGutterColor;
        Viewer.TextColorURL := ffTextUrlColor;

        Viewer.TextWidth := StrToIntDef(edTextWidth.Text, Viewer.TextWidth);
        Viewer.TextWidthFit := chkTextWidthFit.Checked;
        Viewer.TextWidthFitHex := Viewer.TextWidthFit;
        Viewer.TextWidthFitUHex := Viewer.TextWidthFit;
        Viewer.TextOemSpecial := chkTextOemSpecial.Checked;
        Viewer.TextWrap := chkTextWrap.Checked;
        Viewer.TextUrlHilight := chkTextURLs.Checked;
        Viewer.TextNonPrintable := chkTextNonPrint.Checked;
        Viewer.TextSearchIndentVert := StrToIntDef(edSearchIndent.Text,
          Viewer.TextSearchIndentVert);
        Viewer.TextSearchIndentHorz := Viewer.TextSearchIndentVert;
        Viewer.TextMaxLengths[vbmodeText] := StrToIntDef(edTextLength.Text,
          Viewer.TextMaxLengths[vbmodeText]);
        Viewer.TextMaxLengths[vbmodeUnicode] :=
          Viewer.TextMaxLengths[vbmodeText];
        Viewer.TextTabSize := StrToIntDef(edTextTabSize.Text,
          Viewer.TextTabSize);
        FShowFindSelection := chkSearchSel.Checked;
        FShowNoFindError := chkSearchNoMsg.Checked;

        Viewer.TextAutoReload := chkTextReload.Checked;
        Viewer.TextAutoReloadBeep := chkTextReloadBeep.Checked;
        Viewer.TextAutoReloadFollowTail := chkTextReloadTail.Checked;
        Viewer.TextAutoCopy := chkTextAutoCopy.Checked;

        Viewer.ImageColor := ffMediaColor;
        FImageLabelColor := ffMediaColorLabel;
        FImageLabelColorErr := ffMediaColorLabelErr;

        Viewer.MediaFit := chkImageFit.Checked;
        Viewer.MediaFitOnlyBig := chkImageFitBig.Checked;
        Viewer.MediaCenter := chkImageCenter.Checked;
        FMediaFitWindow := chkImageFitWindow.Checked;
        FImageLabelVisible := chkImageLabel.Checked;
        Viewer.ImageResample := chkImageResample.Checked;
        Viewer.ImageTransparent := chkImageTransp.Checked;

        Viewer.MediaMode := Succ(TATViewerMediaMode(edMediaMode.ItemIndex));
        Viewer.MediaAutoPlay := chkMediaStart.Checked;
        Viewer.MediaLoop := chkMediaLoop.Checked;
        Viewer.MediaPlayCount := StrToIntDef(edMediaPlayCount.Text, 1);

{$IFDEF IVIEW}
        with Viewer.IViewIntegration do
        begin
          Enabled := ffIViewEnabled;
          ExeName := ffIViewExeName;
          ExtList := ffIViewExtList;
          HighPriority := ffIViewHighPriority;
        end;
{$ENDIF}

{$IFDEF IJL}
        with Viewer.IJLIntegration do
        begin
          Enabled := ffIJLEnabled;
          ExtList := ffIJLExtList;
        end;
{$ENDIF}

        Viewer.TextGutter := ffShowGutter;
        Viewer.TextGutterLines := ffShowLines;
        Viewer.TextGutterLinesBufSize := ffLinesBufSize * 1024;
        Viewer.TextGutterLinesCount := ffLinesCount;
        Viewer.TextGutterLinesStep := ffLinesStep;
        Viewer.TextGutterLinesExtUse := ffLinesExtUse;
        Viewer.TextGutterLinesExtList := ffLinesExtList;

        with Viewer.TextFontGutter do
        begin
          Name := ffGutterFontName;
          Size := ffGutterFontSize;
          Color := ffGutterFontColor;
          Style := ffGutterFontStyle;
          CharSet := ffGutterFontCharset;
        end;

        Viewer.WebAcceptAllFiles := chkWebAcceptAll.Checked;
        Viewer.WebOffline := chkWebOffline.Checked;
        Viewer.ModeUndetectedCfm := chkShowCfm.Checked;

{$IFDEF CMDLINE}
        ShowNav := chkNav.Checked;
{$ENDIF}
        ShowMenu := chkMenu.Checked;
        ShowMenuIcons := chkMenuIcons.Checked;
        ShowToolbar := chkToolbar.Checked;
        ShowBorder := chkBorder.Checked;
        ShowStatusBar := chkStatusBar.Checked;
        ShowHidden := chkShowHidden.Checked;
        FSingleInstance := chkSingleInst.Checked;
        FViewerTitle := edViewerTitle.ItemIndex;
        FViewerMode := edViewerMode.ItemIndex;
        FFileList.SortOrder := TATFileSort(edFileSort.ItemIndex);
        FResolveLinks := chkResolveLinks.Checked;

        FSaveRecents := chkSaveRecents.Checked;
        FSavePosition := chkSavePosition.Checked;
        FSaveSearch := chkSaveSearch.Checked;
        FSaveFolder := chkSaveFolder.Checked;

        if not FSaveRecents then
          ClearRecents;
        if not FSaveSearch then
          ClearSearch;

        if ALanguage <> ffOptLang then
          SetMsgLanguage(ffOptLang);

        if AIcons <> ffOptIcon then
          IconsName := ffOptIcon;

        if AExtension <> chkShell.Checked then
        begin
          if not ApplyShellExtension(chkShell.Checked) then
            MsgError(MsgString(152));
        end;

        //Save options and reload file
        SaveOptionsDlg;
        Self.FormShow(Self);
        ReopenFile;
      end;

      //Save last tab
      FViewerOptPage := PageControl1.ActivePageIndex;
    finally
      Release;
    end;

  //Update shortcuts, even if user cancelled the dialog:
  UpdateShortcuts;
end;

procedure TFormViewUV.ReloadFile;
begin
  //Use Viewer.FileName, it can be both file and folder name
  if (Viewer.FileName <> '') and IsFileOrDirExist(Viewer.FileName) then
  begin
    Viewer.Reload;
    UpdateOptions;
  end
  else
    CloseFile;
end;

procedure TFormViewUV.ReopenFile;
var
  S: WideString;
begin
  //Use Viewer.FileName, it can be both file and folder name
  if (Viewer.FileName <> '') and IsFileOrDirExist(Viewer.FileName) then
  begin
    S := Viewer.FileName;
    CloseFile;
    LoadFile(S);
  end
  else
    CloseFile;
end;

procedure TFormViewUV.CloseFile(AKeepList: boolean = false);
begin
  LoadFile('', AKeepList);
end;

procedure TFormViewUV.mnuFileReloadClick(Sender: TObject);
begin
  ReloadFile;
end;

procedure TFormViewUV.mnuEditGotoClick(Sender: TObject);
var
  APos: Int64;
  AMode: TViewerGotoMode;
begin
  APos := -1;
  AMode := FGotoMode;

  with TFormViewGoto.Create(nil) do
    try
      if not (Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode,
        vmodeRTF, vmodeWeb]) then
      begin
        AMode := vgPercent;
        chkHex.Enabled := false;
        chkDec.Enabled := false;
        chkSelStart.Enabled := false;
        chkSelEnd.Enabled := false;
      end;

      if not (Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode,
        vmodeRTF]) then
      begin
        if AMode = vgLine then
          AMode := vgPercent;
        chkLine.Enabled := false;
      end;

      if (Viewer.TextSelLength = 0) then
      begin
        if AMode in [vgSelStart, vgSelEnd] then
          AMode := vgPercent;
        chkSelStart.Enabled := false;
        chkSelEnd.Enabled := false;
      end;

      case AMode of
        vgPercent:
          begin
            chkPercent.Checked := true;
            edPos.Text := IntToStr(Viewer.PosPercent);
          end;
        vgLine:
          begin
            chkLine.Checked := true;
            edPos.Text := IntToStr(Viewer.PosLine);
          end;
        vgHex:
          begin
            chkHex.Checked := true;
            edPos.Text := IntToHex(Viewer.PosOffset, 1);
          end;
        vgDec:
          begin
            chkDec.Checked := true;
            edPos.Text := IntToStr(Viewer.PosOffset);
          end;
        vgSelStart:
          begin
            chkSelStart.Checked := true;
            edPos.Text := IntToStr(Viewer.PosOffset);
          end;
        vgSelEnd:
          begin
            chkSelEnd.Checked := true;
            edPos.Text := IntToStr(Viewer.PosOffset);
          end;
      end;

      if ShowModal = mrOk then
      begin
        if chkPercent.Checked then
        begin
          AMode := vgPercent;
          APos := StrToIntDef(edPos.Text, -1);
        end
        else if chkLine.Checked then
        begin
          AMode := vgLine;
          APos := StrToIntDef(edPos.Text, -1);
        end
        else if chkHex.Checked then
        begin
          AMode := vgHex;
          APos := HexToIntDef(edPos.Text, -1);
        end
        else if chkDec.Checked then
        begin
          AMode := vgDec;
          APos := StrToIntDef(edPos.Text, -1);
        end
        else if chkSelStart.Checked then
        begin
          AMode := vgSelStart;
          APos := 0;
        end
        else if chkSelEnd.Checked then
        begin
          AMode := vgSelEnd;
          APos := 0;
        end;
      end;
    finally
      Release;
    end;

  if APos >= 0 then
  begin
    FGotoMode := AMode;
    case AMode of
      vgPercent:
        Viewer.PosPercent := APos;
      vgLine:
        Viewer.PosLine := APos;
      vgHex,
        vgDec:
        Viewer.PosOffset := APos;
      vgSelStart:
        Viewer.PosOffset := Viewer.TextSelStart;
      vgSelEnd:
        Viewer.PosOffset := Viewer.TextSelStart + Viewer.TextSelLength - 1;
    end;
  end;
end;

procedure TFormViewUV.mnuFilePrevClick(Sender: TObject);
var
  fn: WideString;
begin
  fn := FFileList.GetNext(FFileName, nfPrev, FFileNextMsg and (not
    FFileList.Locked));
  if fn <> '' then
    LoadFile(fn, true);
end;

procedure TFormViewUV.mnuFileNextClick(Sender: TObject);
var
  fn: WideString;
begin
  fn := FFileList.GetNext(FFileName, nfNext, FFileNextMsg and (not
    FFileList.Locked));
  if fn <> '' then
    LoadFile(fn, true);
end;

procedure TFormViewUV.InitPlugins;
begin
  Viewer.InitPluginsParams(Self, FIniNameLS);
end;

procedure TFormViewUV.LoadPluginsOptions;
var
  i: integer;
  fn: TWlxFilename;
  detect: string;
  en: boolean;
begin
  FPluginsNum := 0;

  for i := 0 to High(TPluginsList) - 1 do
  begin
    fn := FIni.ReadString(csPlugins, IntToStr(i), '');
    fn := SExpandVars(fn);
    if fn = '' then
      Break;
    detect := FIni.ReadString(csPlugins, IntToStr(i) + ccPDetect, '');
    en := FIni.ReadBool(csPlugins, IntToStr(i) + ccPEnabled, true);

    if FPluginsNum < High(TPluginsList) then
    begin
      Inc(FPluginsNum);
      FPluginsList[FPluginsNum].FFileName := fn;
      FPluginsList[FPluginsNum].FDetectStr := detect;
      FPluginsList[FPluginsNum].FEnabled := en;
    end;
  end;

  Viewer.RemovePlugins;
  for i := Low(TPluginsList) to High(TPluginsList) do
    with FPluginsList[i] do
      if FEnabled then
        Viewer.AddPlugin(FFileName, FDetectStr);
  InitPlugins;
end;

procedure TFormViewUV.SavePluginsOptions;
var
  i: integer;
  S: string;
begin
  for i := Low(TPluginsList) to High(TPluginsList) do
  begin
    S := IntToStr(i - 1);
    if i <= FPluginsNum then
      with FPluginsList[i] do
      begin
        FIniSave.WriteString(csPlugins, S, SCollapseVars(FFileName));
        FIniSave.WriteString(csPlugins, S + ccPDetect, FDetectStr);
        FIniSave.WriteBool(csPlugins, S + ccPEnabled, FEnabled);
      end
    else
    begin
      FIniSave.DeleteKey(csPlugins, S);
      FIniSave.DeleteKey(csPlugins, S + ccPDetect);
      FIniSave.DeleteKey(csPlugins, S + ccPEnabled);
    end;
  end;

  FIniSave.WriteBool(csOpt, ccPPrior, Viewer.PluginsHighPriority);
  FIniSave.WriteBool(csOpt, ccPTcVar, FPluginsTotalcmdVar);
  FIniSave.WriteBool(csOpt, ccPHideKeys, FPluginsHideKeys);
  FIniSave.UpdateFile;
end;

procedure TFormViewUV.ResizePlugin;
var
  Pnt: TPoint;
begin
  with Viewer do
  begin
    Pnt := Self.ScreenToClient(ClientToScreen(Point(0, 0)));
    ResizeActivePlugin(Rect(Pnt.X, Pnt.Y, Pnt.X + Width, Pnt.Y + Height));
  end;
end;

procedure TFormViewUV.ViewerPluginsBeforeLoading(const APluginName: string);
begin
  UpdateCaption(APluginName, true);
end;

procedure TFormViewUV.ViewerPluginsAfterLoading(const APluginName: string);
begin
  UpdateCaption(APluginName, false);
end;

procedure TFormViewUV.TntFormResize(Sender: TObject);
begin
  ResizePlugin;
  UpdateImageLabel;
{$IFDEF CMDLINE}
  NavMove;
{$ENDIF}
end;

procedure TFormViewUV.mnuOptionsPluginsClick(Sender: TObject);
var
  i: integer;
  OldFileName: WideString;
begin
  with TFormPluginsOptions.Create(Self) do
    try
      List.Items.BeginUpdate;
      List.Items.Clear;
      for i := Low(TPluginsList) to High(TPluginsList) do
        if i <= FPluginsNum then
          with FPluginsList[i] do
            with List.Items.Add do
            begin
              Checked := FEnabled;
              Caption := SPluginName(FFileName);
              SubItems.Add(FDetectStr);
              SubItems.Add(FFileName);
            end;
      List.Items.EndUpdate;

      chkPriority.Checked := Viewer.PluginsHighPriority;
      chkTCVar.Checked := FPluginsTotalcmdVar;
      chkHideKeys.Checked := FPluginsHideKeys;
      FConfigFolder := ConfigFolder;

      if ShowModal = mrOk then
      begin
        //Close file
        OldFileName := FFileName;
        CloseFile;
        Application.ProcessMessages;

        //Reload and init plugins
        FPluginsNum := 0;
        for i := 0 to List.Items.Count - 1 do
          with List.Items[i] do
            if FPluginsNum < High(TPluginsList) then
            begin
              Inc(FPluginsNum);
              FPluginsList[FPluginsNum].FFileName := SubItems[1];
              FPluginsList[FPluginsNum].FDetectStr := SubItems[0];
              FPluginsList[FPluginsNum].FEnabled := Checked;
            end;

        Viewer.RemovePlugins;
        for i := Low(TPluginsList) to High(TPluginsList) do
          if i <= FPluginsNum then
            with FPluginsList[i] do
              if FEnabled then
                Viewer.AddPlugin(FFileName, FDetectStr);
        InitPlugins;

        Viewer.PluginsHighPriority := chkPriority.Checked;
        FPluginsTotalcmdVar := chkTCVar.Checked;
        FPluginsHideKeys := chkHideKeys.Checked;

        //Save options and reopen previous file
        SavePluginsOptions;
        LoadFile(OldFileName);
      end;
    finally
      Release;
    end;
end;

procedure TFormViewUV.WMDropFiles(var Message: TWMDROPFILES);
var
  Count: UINT;
  BufA: array[0..MAX_PATH] of char;
  BufW: array[0..MAX_PATH] of WideChar;
  Name: WideString;
begin
  Name := '';
  Count := DragQueryFile(Message.Drop, $FFFFFFFF, nil, 0);
  if Count > 0 then
  begin
    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      DragQueryFileW(Message.Drop, 0, @BufW, SizeOf(BufW) div 2);
      Name := BufW;
    end
    else
    begin
      DragQueryFileA(Message.Drop, 0, @BufA, SizeOf(BufA));
      Name := string(BufA);
    end;
  end;
  DragFinish(Message.Drop);

  if (Name <> '') and IsFileExist(Name) then
    LoadFile(Name);
end;

procedure TFormViewUV.WMCommand(var Message: TMessage);
begin
  inherited;
  if Message.WParamHi = itm_percent then
    Viewer.PluginsSendMessage(Message);
end;

procedure TFormViewUV.WMActivate(var Msg: TWMActivate);
begin
  inherited;

  //Focus viewer, if needed
  if Msg.Active = WA_ACTIVE then
    if Viewer.IsFocused then
      Viewer.FocusActiveControl;

  Msg.Result := 0;
end;

procedure TFormViewUV.AppOnActivate(Sender: TObject);
begin
  if FNoTaskbarIcon then
    ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormViewUV.ViewerMediaPlaybackEnd(Sender: TObject);
begin
  if MediaAutoAdvance then
    if Assigned(FFileList) then
      with FFileList do
        if Locked and (ListIndex < Count - 1) then
        begin
          mnuFileNextClick(Self);
        end;
end;

procedure TFormViewUV.mnuViewAlwaysOnTopClick(Sender: TObject);
begin
  ShowOnTop := not ShowOnTop;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewFullScreenClick(Sender: TObject);
begin
  ShowFullScreen := not ShowFullScreen;
  UpdateOptions;
end;

function TFormViewUV.GetShowOnTop: boolean;
begin
  Result := GetFormOnTop(Self);
end;

procedure TFormViewUV.SetShowOnTop(AValue: boolean);
begin
  if GetShowOnTop <> AValue then
    SetFormOnTop(Self, AValue);
end;

procedure TFormViewUV.SetShowFullScreen(AValue: boolean);
begin
  if FShowFullScreen <> AValue then
  begin
    FShowFullScreen := AValue;
{$IFDEF CMDLINE}
    if AValue then
      ShowNav := false;
{$ENDIF}

    //Update menu and form state
    ShowMenu := ShowMenu;
    SetFormStyle(Self, not AValue);

    if AValue then
    begin
      FBoundsRectOld := BoundsRect;
      BoundsRect := Monitor.BoundsRect;
        //Seems like correct, puts on current monitor
    end
    else
    begin
      BoundsRect := FBoundsRectOld;
    end;
  end;
end;

procedure TFormViewUV.SetShowMenu(AValue: boolean);
var
  En: boolean;
begin
  FShowMenu := AValue;
  En := FShowMenu and not ShowFullScreen;
  mnuFile.Visible := En;
  mnuEdit.Visible := En;
  mnuView.Visible := En;
  mnuOptions.Visible := En;
  mnuTools.Visible := En and (NumOfUserTools(FUserTools) > 0);
  mnuHelp.Visible := En;
end;

function TFormViewUV.GetShowMenuIcons: boolean;
begin
  Result := Assigned(MainMenu1.Images);
end;

procedure TFormViewUV.SetShowMenuIcons(AValue: boolean);
begin
  if AValue then
    MainMenu1.Images := ImageList1
  else
    MainMenu1.Images := nil;
end;

function TFormViewUV.GetEnableMenu: boolean;
begin
  Result := mnuFile.Enabled;
end;

procedure TFormViewUV.SetEnableMenu(AValue: boolean);
begin
  mnuFile.Enabled := AValue;
  mnuEdit.Enabled := AValue;
  mnuView.Enabled := AValue;
  mnuOptions.Enabled := AValue;
  mnuHelp.Enabled := AValue;
end;

procedure TFormViewUV.mnuRecentClearClick(Sender: TObject);
begin
  ClearRecents;
end;

procedure TFormViewUV.mnuRecent0Click(Sender: TObject);
begin
  LoadFile(FRecentList[RecentItemIndex(Sender)]);
end;

procedure TFormViewUV.btnImageRotate90Click(Sender: TObject);
begin
  Viewer.ImageEffect(vieRotate90);
  UpdateOptions(true);
end;

procedure TFormViewUV.btnImageRotate270Click(Sender: TObject);
begin
  Viewer.ImageEffect(vieRotate270);
  UpdateOptions(true);
end;

procedure TFormViewUV.btnImageNegativeClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieNegative);
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageGrayscaleClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieGrayscale);
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageNegativeClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieNegative);
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageFlipVertClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieFlipVertical);
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewImageFlipHorzClick(Sender: TObject);
begin
  Viewer.ImageEffect(vieFlipHorizontal);
  UpdateOptions;
end;

procedure TFormViewUV.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  CloseFile;
  Action := caFree;
end;

procedure TFormViewUV.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if IsMHT then
    CanClose := True
  else
    CanClose := (not Viewer.WebBusy) or Application.Terminated;
end;

function TFormViewUV.IsMHT: boolean;
begin
  //Some MHT can cause webbrowser to hang and give
  //exception on loading (ZeroDevide). No wait for them.
  Result := SFileExtensionMatch(FFileName, 'mht');
end;

procedure TFormViewUV.LoadToolbar;
var
  S: AnsiString;
begin
  FToolbarList.AddAvail(mnuSep);
 // FToolbarList.AddAvail(mnuFileOpen, MenuRecents);
  //FToolbarList.AddAvail(mnuFileReload);
  //FToolbarList.AddAvail(mnuFileSaveAs);
  FToolbarList.AddAvail(mnuFileClose);
  FToolbarList.AddAvail(mnuFilePrint);
  FToolbarList.AddAvail(mnuFilePrintPreview);
  FToolbarList.AddAvail(mnuFilePrintSetup);
  FToolbarList.AddAvail(mnuFilePrev);
  FToolbarList.AddAvail(mnuFileNext);
  FToolbarList.AddAvail(mnuFileRename);
  FToolbarList.AddAvail(mnuFileCopy);
  FToolbarList.AddAvail(mnuFileMove);
  FToolbarList.AddAvail(mnuFileDelete);
  FToolbarList.AddAvail(mnuFileCopyFN);
  FToolbarList.AddAvail(mnuFileEmail);
  FToolbarList.AddAvail(mnuFileProp);
  FToolbarList.AddAvail(mnuFileExit);
  FToolbarList.AddAvail(mnuEditCopy);
  FToolbarList.AddAvail(mnuEditCopyHex);
  FToolbarList.AddAvail(mnuEditCopyToFile);
  FToolbarList.AddAvail(mnuEditPaste);
  FToolbarList.AddAvail(mnuEditSelectAll);
  FToolbarList.AddAvail(mnuEditFind);
  FToolbarList.AddAvail(mnuEditFindNext);
  FToolbarList.AddAvail(mnuEditFindPrev);
  FToolbarList.AddAvail(mnuEditGoto);
  FToolbarList.AddAvail(mnuViewMode1);
  FToolbarList.AddAvail(mnuViewMode2);
  FToolbarList.AddAvail(mnuViewMode3);
  FToolbarList.AddAvail(mnuViewMode4);
  FToolbarList.AddAvail(mnuViewMode5);
  FToolbarList.AddAvail(mnuViewMode6);
  FToolbarList.AddAvail(mnuViewMode7);
  FToolbarList.AddAvail(mnuViewMode8);
  FToolbarList.AddAvail(mnuViewModeMenu, MenuModes);
  FToolbarList.AddAvail(mnuViewTextWrap);
  FToolbarList.AddAvail(mnuViewTextNonPrint);
  FToolbarList.AddAvail(mnuViewTextTail);
  FToolbarList.AddAvail(mnuViewTextANSI);
  FToolbarList.AddAvail(mnuViewTextOEM);
  FToolbarList.AddAvail(mnuViewTextEBCDIC);
  FToolbarList.AddAvail(mnuViewTextKOI8);
  FToolbarList.AddAvail(mnuViewTextISO);
  FToolbarList.AddAvail(mnuViewTextMac);
  FToolbarList.AddAvail(mnuViewTextEncPrev);
  FToolbarList.AddAvail(mnuViewTextEncNext);
  FToolbarList.AddAvail(mnuViewTextEncMenu);
  FToolbarList.AddAvail(mnuViewImageFit);
  FToolbarList.AddAvail(mnuViewImageFitOnlyBig);
  FToolbarList.AddAvail(mnuViewImageCenter);
  FToolbarList.AddAvail(mnuViewImageFitWindow);
  FToolbarList.AddAvail(mnuViewImageShowEXIF);
  FToolbarList.AddAvail(mnuViewImageShowLabel);
  FToolbarList.AddAvail(mnuViewImageRotateRight);
  FToolbarList.AddAvail(mnuViewImageRotateLeft);
  FToolbarList.AddAvail(mnuViewImageFlipVert);
  FToolbarList.AddAvail(mnuViewImageFlipHorz);
  FToolbarList.AddAvail(mnuViewImageGrayscale);
  FToolbarList.AddAvail(mnuViewImageNegative);

  FToolbarList.AddAvail(mnuViewMediaPlayPause);
  FToolbarList.AddAvail(mnuViewMediaLoop);
  FToolbarList.AddAvail(mnuViewMediaVolumeUp);
  FToolbarList.AddAvail(mnuViewMediaVolumeDown);
  FToolbarList.AddAvail(mnuViewMediaVolumeMute);

  FToolbarList.AddAvail(mnuViewWebGoBack);
  FToolbarList.AddAvail(mnuViewWebGoForward);
  FToolbarList.AddAvail(mnuViewWebOffline);

  FToolbarList.AddAvail(mnuViewZoomIn);
  FToolbarList.AddAvail(mnuViewZoomOut);
  FToolbarList.AddAvail(mnuViewZoomOriginal);

  FToolbarList.AddAvail(mnuViewShowNav);
  FToolbarList.AddAvail(mnuViewShowMenu);
  FToolbarList.AddAvail(mnuViewShowToolbar);
  FToolbarList.AddAvail(mnuViewShowStatusbar);
  FToolbarList.AddAvail(mnuViewAlwaysOnTop);
  FToolbarList.AddAvail(mnuViewFullScreen);

  FToolbarList.AddAvail(mnuOptionsConfigure);
  FToolbarList.AddAvail(mnuOptionsPlugins);
  FToolbarList.AddAvail(mnuOptionsToolbar);
  FToolbarList.AddAvail(mnuOptionsUserTools);
  FToolbarList.AddAvail(mnuOptionsEditIni);
  FToolbarList.AddAvail(mnuOptionsEditIniHistory);
  FToolbarList.AddAvail(mnuOptionsSavePos);

  FToolbarList.AddAvail(mnuUserTool1);
  FToolbarList.AddAvail(mnuUserTool2);
  FToolbarList.AddAvail(mnuUserTool3);
  FToolbarList.AddAvail(mnuUserTool4);
  FToolbarList.AddAvail(mnuUserTool5);
  FToolbarList.AddAvail(mnuUserTool6);
  FToolbarList.AddAvail(mnuUserTool7);
  FToolbarList.AddAvail(mnuUserTool8);
  FToolbarList.AddAvail(mnuHelpContents);
  FToolbarList.AddAvail(mnuHelpAbout);

  //Read option, add ShowNav if missed
  S := FIni.ReadString(csToolbars, ccToolbarMain, cToolbarListDefault);
  SDelLastSpace(S);
  if Pos('ViewShowNav', S) = 0 then
    S := S + ' ViewShowNav';
  FToolbarList.CurrentString := S;
end;

procedure TFormViewUV.SaveToolbar;
begin
  FIniSave.WriteString(csToolbars, ccToolbarMain, FToolbarList.CurrentString);
  FIniSave.UpdateFile;
end;

procedure TFormViewUV.ApplyToolbar;
begin
  FToolbarList.ApplyTo(Toolbar);
end;

procedure TFormViewUV.ApplyToolbarCaptions;
begin
  FToolbarList.UpdateCaptions;
end;

procedure TFormViewUV.mnuToolbarCustomizeClick(Sender: TObject);
begin
  if CustomizeToolbarDialog(FToolbarList) then
  begin
    ApplyToolbar;
    SaveToolbar;
    UpdateOptions;
  end;
end;

procedure TFormViewUV.mnuViewWebGoBackClick(Sender: TObject);
begin
  Viewer.WebGoBack;
end;

procedure TFormViewUV.mnuViewWebGoForwardClick(Sender: TObject);
begin
  Viewer.WebGoForward;
end;

procedure TFormViewUV.mnuHelpWebHomepageClick(Sender: TObject);
begin
  FOpenURL('http://www.uvviewsoft.com', Handle);
end;

procedure TFormViewUV.mnuHelpWebPluginsClick(Sender: TObject);
begin
  FOpenURL('http://www.uvviewsoft.com/lister_plugins.htm', Handle);
end;

procedure TFormViewUV.mnuHelpWebEmailClick(Sender: TObject);
begin
  FOpenURL('mailto:support@uvviewsoft.com', Handle);
end;

procedure TFormViewUV.UpdateImageLabel;
var
  S: string;
begin
  with Viewer do
    if IsImage and Assigned(ImageBox) then
      if ImageError then
      begin
        ImageBox.ImageLabel.Caption := ImageErrorMessage;
        ImageBox.ImageLabel.Visible := True;
        ImageBox.ImageLabel.Font.Color := FImageLabelColorErr;
      end
      else
      begin
        S := Format('%d x %d', [ImageWidth, ImageHeight]);
        if ImageScale <> 100 then
          S := S + Format(' (%d%%)', [ImageScale]);
        ImageBox.ImageLabel.Caption := S;
        ImageBox.ImageLabel.Visible := FImageLabelVisible;
        ImageBox.ImageLabel.Font.Color := FImageLabelColor;
      end;
end;

procedure TFormViewUV.mnuFileDeleteClick(Sender: TObject);
var
  OldName, NewName: WideString;
begin
  OldName := FFileName;

  if MsgBox(
    SFormatW(MsgViewerDeleteWarningRecycle, [SExtractFileName(OldName)]),
    MsgViewerDeleteCaption,
    MB_OKCANCEL or MB_ICONWARNING,
    Handle
    ) = IDOK then
  begin
    NewName := FFileList.GetNext(OldName, nfNext);
    if SCompareIW(NewName, OldName) = 0 then
      NewName := '';

    CloseFile(true {Keep});

    if FDeleteToRecycle(Handle, OldName) then
    begin
      FFileList.Delete(OldName);
      if NewName <> '' then
        LoadFile(NewName, true {Keep});
    end
    else
    begin
      MsgDeleteError(OldName);
    end;
  end;
end;

procedure TFormViewUV.ViewerTextFileReload(Sender: TObject);
begin
  if IsFileExist(FFileName) then
    UpdateStatusBar
  else
    CloseFile;
end;

procedure TFormViewUV.mnuOptionsUserToolsClick(Sender: TObject);
begin
  with TFormViewToolList.Create(Self) do
    try
      CopyUserTools(Self.FUserTools, Tools);
      if ShowModal = mrOk then
      begin
        CopyUserTools(Tools, Self.FUserTools);
        SaveUserTools;
        ApplyUserTools;
        ApplyToolbar;
        UpdateOptions;
      end;
    finally
      Release;
    end;
end;

procedure TFormViewUV.mnuViewImageShowLabelClick(Sender: TObject);
begin
  FImageLabelVisible := not FImageLabelVisible;
  UpdateOptions;
end;

procedure TFormViewUV.InitFormFindProgress;
begin
  if not Assigned(FFormFindProgress) then
    FFormFindProgress := TFormViewFindProgress.Create(Self);
end;

procedure TFormViewUV.TimerShowTimer(Sender: TObject);
begin
  TimerShow.Enabled := false;

{$IFDEF CMDLINE}
  NavSync;

  if FStartupPosDo then
  begin
    FStartupPosDo := false;

    if FStartupPosPercent then
      Viewer.PosPercent := FStartupPos
    else if FStartupPosLine then
      Viewer.PosLine := FStartupPos
    else
      Viewer.PosOffset := FStartupPos;
  end;

  if FStartupPrint then
  begin
    Viewer.PrintDialog;
    Close;
  end;
{$ENDIF}
end;

//---------------------------------------------------------
// http://www.mustangpeak.net/phpBB2/viewtopic.php?p=3781#3781
//

procedure TFormViewUV.AppOnMessage(var Msg: TMsg; var Handled: boolean);
begin
  case Msg.Message of
    WM_XBUTTONUP:
      case HiWord(Msg.wParam) of
        $0001 {MK_XBUTTON1}:
          begin
            if mnuFilePrev.Enabled then
              mnuFilePrevClick(Self);
            Handled := true;
          end;
        $0002 {MK_XBUTTON2}:
          begin
            if mnuFileNext.Enabled then
              mnuFileNextClick(Self);
            Handled := true;
          end;
      end;
  end;
end;

function TFormViewUV.GetStatusVisible: boolean;
begin
  Result := not ShowFullscreen;
end;

procedure TFormViewUV.UpdateStatusBar;
var
  PanelIndex: integer;

  procedure ClearText;
  var
    i: integer;
  begin
    PanelIndex := 0;
    with StatusBar1 do
      for i := 0 to Panels.Count - 1 do
        Panels[i].Text := '';
  end;

  procedure AddText(const AText: string; AWidth: integer = 0);
  begin
    with StatusBar1 do
    begin
      Panels[PanelIndex].Text := AText;
      if AWidth > 0 then
        Panels[PanelIndex].Width := AWidth;
      Inc(PanelIndex);
    end;
  end;

var
  ASize: Int64;
  ATime: TFileTime;
  S: string;
begin
  with StatusBar1 do
  begin
    Visible := ShowStatusBar {Option} and GetStatusVisible {Need to show};
    if not Visible then
      Exit;
  end;

  ClearText;

  if FFileName = '' then
    Exit;

  if FGetFileInfo(FFileName, ASize, ATime) then
  begin
    AddText(FormatFileSize(ASize));
    AddText(FormatFileTime(ATime));
  end
  else
  begin
    AddText('');
    AddText('');
  end;

  case Viewer.Mode of
    vmodeText,
      vmodeBinary,
      vmodeHex,
      vmodeUnicode,
      vmodeRTF:
      AddText(Viewer.TextEncodingName);
    vmodeMedia:
      if Viewer.IsImage then
      begin
        S := Format('%d x %d', [Viewer.ImageWidth, Viewer.ImageHeight]);
        if Viewer.ImageBPP > 0 then
          S := S + Format(', %d BPP', [Viewer.ImageBPP]);
        AddText(S);
      end
      else
        AddText('');
  else
    AddText('');
  end;

  //Show file number only when list read
  if (FFileList.Count > 0) and
    (FFileList.ListIndex >= 0) then
  begin
    if FFileList.Locked then
      S := MsgString(307)
    else
      S := MsgString(306);
    AddText(Format(S, [FFileList.ListIndex + 1, FFileList.Count]));
  end;
end;

procedure TFormViewUV.mnuViewShowMenuClick(Sender: TObject);
begin
  ShowMenu := not ShowMenu;
  ResizePlugin;
  UpdateOptions(true);
end;

procedure TFormViewUV.mnuViewShowToolbarClick(Sender: TObject);
begin
  ShowToolbar := not ShowToolbar;
  ResizePlugin;
  UpdateOptions(true);
end;

procedure TFormViewUV.mnuViewShowStatusbarClick(Sender: TObject);
begin
  ShowStatusBar := not ShowStatusBar;
  UpdateOptions(true);
end;

procedure TFormViewUV.mnuViewShowNavClick(Sender: TObject);
begin
{$IFDEF CMDLINE}
  ShowNav := not ShowNav;
{$ENDIF}
  UpdateOptions;
end;

procedure TFormViewUV.mnuOptionsEditIniClick(Sender: TObject);
begin
  FOpenURL(FIniName, Handle);
end;

procedure TFormViewUV.mnuOptionsEditIniHistoryClick(Sender: TObject);
begin
  FOpenURL(FIniNameHist, Handle);
end;

procedure TFormViewUV.mnuViewZoomInClick(Sender: TObject);
begin
  Viewer.IncreaseScale(true);
  UpdateOptions(true);
  fLastScale := Viewer.ImageScale;
end;

procedure TFormViewUV.mnuViewZoomOutClick(Sender: TObject);
begin
  Viewer.IncreaseScale(false);
  UpdateOptions(true);
  fLastScale := Viewer.ImageScale;
end;

procedure TFormViewUV.mnuViewZoomOriginalClick(Sender: TObject);
begin
  if (Viewer.Mode = vmodeMedia) and (Viewer.IsImage) then
  begin
    Viewer.ImageScale := 100;
    UpdateOptions(true);
  end;
end;

procedure TFormViewUV.mnuViewImageFitWindowClick(Sender: TObject);
begin
  MediaFitWindow := not MediaFitWindow;
  UpdateOptions(true);
end;

procedure TFormViewUV.ViewerFileUnload(Sender: TObject);
begin
  //MsgInfo('OnFileUnload');
end;

procedure TFormViewUV.mnuViewMediaPlayPauseClick(Sender: TObject);
begin
  Viewer.MediaDoPlayPause;
end;

procedure TFormViewUV.mnuViewMediaVolumeUpClick(Sender: TObject);
begin
  with Viewer do
    MediaVolume := MediaVolume + 1;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewMediaVolumeDownClick(Sender: TObject);
begin
  with Viewer do
    MediaVolume := MediaVolume - 1;
  UpdateOptions;

  //debug
  //MsgInfo(IntToStr(Viewer.MediaVolume));
end;

procedure TFormViewUV.mnuViewMediaVolumeMuteClick(Sender: TObject);
begin
  with Viewer do
    MediaMute := not MediaMute;
  UpdateOptions;
end;

procedure TFormViewUV.ViewerOptionsChange(ASender: TObject);
begin
  UpdateOptions;
end;

procedure TFormViewUV.mnuHelpContentsClick(Sender: TObject);
begin
  ShowHelp(Handle);
end;

procedure TFormViewUV.mnuFileRenameClick(Sender: TObject);
begin
  DoFileRename;
end;

procedure TFormViewUV.mnuFileCopyClick(Sender: TObject);
begin
  DoFileCopy;
end;

procedure TFormViewUV.mnuFileMoveClick(Sender: TObject);
begin
  DoFileMove;
end;

procedure TFormViewUV.InitPreview;
begin
{$I Lang.FormViewPreview.inc}
end;

procedure TFormViewUV.mnuOptionsSavePosClick(Sender: TObject);
begin
  SavePosition;
end;

procedure TFormViewUV.mnuFilePropClick(Sender: TObject);
begin
  FShowProperties(FFileName, Handle);
end;

procedure TFormViewUV.mnuViewTextEncMenuClick(Sender: TObject);
var
  P: TPoint;
begin
  P := Mouse.CursorPos;
  Viewer.TextEncodingsMenu(P.X, P.Y);
  UpdateOptions;
end;

const
  cLastCycleEncoding = vEncMac;

procedure TFormViewUV.mnuViewTextEncPrevClick(Sender: TObject);
begin
  with Viewer do
  begin
    if (TextEncoding in [Succ(Low(TATEncoding))..cLastCycleEncoding]) then
      TextEncoding := Pred(TextEncoding)
    else
      TextEncoding := cLastCycleEncoding;
  end;
  UpdateOptions;
end;

procedure TFormViewUV.mnuViewTextEncNextClick(Sender: TObject);
begin
  with Viewer do
  begin
    if (TextEncoding in [Low(TATEncoding)..Pred(cLastCycleEncoding)]) then
      TextEncoding := Succ(TextEncoding)
    else
      TextEncoding := Low(TATEncoding);
  end;
  UpdateOptions;
end;

procedure TFormViewUV.UpdateShortcuts;
begin
  if FPluginsHideKeys then
  begin
    if (FFileName <> '') and (Viewer.Mode = vmodeWLX) then
      FToolbarList.PrepareShortcuts
    else
      FToolbarList.RestoreShortcuts;
  end;
end;

procedure TFormViewUV.StatusBar1Click(Sender: TObject);
var
  P: TPoint;
  X1: Integer;
begin
  with StatusBar1 do
  begin
    P := ScreenToClient(Mouse.CursorPos);
    X1 := Panels[0].Width + Panels[1].Width;
    if (P.X >= X1) and (P.X <= X1 + Panels[2].Width) then
      if mnuViewTextEncMenu.Enabled then
        mnuViewTextEncMenuClick(Self);
  end;
end;

function TFormViewUV.GetFollowTail: boolean;
begin
  Result :=
    Viewer.TextAutoReload and
    Viewer.TextAutoReloadFollowTail;
end;

procedure TFormViewUV.SetFollowTail(AValue: boolean);
begin
  Viewer.TextAutoReloadFollowTail := AValue;
  if AValue then
    Viewer.TextAutoReload := AValue;
end;

procedure TFormViewUV.mnuEditCopyToFileClick(Sender: TObject);
var
  OK: boolean;
begin
  if TextNotSelected then
  begin
    MsgTextNotSelected;
    Exit;
  end;

  with SaveDialog1 do
  begin
    FileName := FNumberName(SExtractFileDir(FFileName) + '\Text (%d).txt');
    InitialDir := SExtractFileDir(FFileName);
    if Execute then
    begin
      Screen.Cursor := crHourGlass;
      try
        if Viewer.Mode <> vmodeUnicode then
          OK := FFileWriteStringA(FileName, Viewer.TextSelText)
        else
          OK := FFileWriteStringW(FileName, Viewer.TextSelTextW);
      finally
        Screen.Cursor := crDefault;
      end;
      if not OK then
        MsgCopyMoveError('(Text)', FileName);
    end;
  end;
end;

//--------------------------------------------------------

function TFormViewUV.RecentItemIndex(Sender: TObject): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to High(TRecentMenus) do
    if (Sender = FRecentMenus[i]) or (Sender = FRecentMenusBar[i]) then
    begin
      Result := i;
      Break
    end;
end;

const
  cMenuOffsetX = 18; //Offset lefter than menu item text
  cMenuOffsetX2 = 16; //Offset righter then menu item text

procedure TFormViewUV.mnuRecent0MeasureItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
const
  cHeight = 18;
begin
  Width := STextWidth(ACanvas, FRecentList[RecentItemIndex(Sender)])
  + cMenuOffsetX
    + cMenuOffsetX2;
  if not ShowMenuIcons then
    Height := cHeight;
end;

procedure TFormViewUV.mnuRecent0DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
const
  cColors: array[boolean] of TColor = (clMenu, clHighlight);
  cOffsetX = 4; //Offsets to draw menuitem correctly
  cOffsetY = 2;
begin
  ACanvas.Brush.Color := cColors[Selected];
  ACanvas.FillRect(ARect);
  STextOut(ACanvas,
    ARect.Left + cMenuOffsetX + cOffsetX,
    ARect.Top + cOffsetY,
    FRecentList[RecentItemIndex(Sender)]);
end;

//--------------------------------------------------------

function TFormViewUV.IsImageListSaved: boolean;
begin
  Result := ImageListS.Count > 0;
end;

//--------------------------------------------------------

procedure TFormViewUV.SetIconsName(const Name: string);
begin
  if FIconsName <> Name then
  begin
    FIconsName := Name;
    if FIconsName = '' then
    begin
      if IsImageListSaved then
      begin
        ImageList1.Clear;
        ImageList1.Width := 16;
        ImageList1.Height := 16;
        ImageList1.AddImages(ImageListS);
      end;
    end
    else
    begin
      if not IsImageListSaved then
        ImageListS.AddImages(ImageList1);
      FLoadIcons(ImageList1, SIconsFN(Name));
    end;

    ApplyToolbar;
    ApplyUserTools;
  end;
end;

procedure TFormViewUV.mnuViewImageShowEXIFClick(Sender: TObject);
begin
{$IFDEF EXIF}
  ShowEXIF(FFileNameWideToAnsi(FFileName));
{$ENDIF}
end;

procedure TFormViewUV.mnuViewMediaLoopClick(Sender: TObject);
begin
  Viewer.MediaLoop := not Viewer.MediaLoop;
  UpdateOptions;
end;

procedure TFormViewUV.mnuEditPasteClick(Sender: TObject);
var
  fn: WideString;
begin
  //Is Clipboard file opened?
  if (FFileName <> '') and
    (FFileName = FClipName(SExtractFileExt(FFileName))) then
    CloseFile;

  fn := FPasteToFile;
  if (fn <> '') then
    LoadFile(fn);
end;

procedure TFormViewUV.mnuFileEmailClick(Sender: TObject);
begin
{$IFDEF CMDLINE}
  NavOp('mail', MsgString(153), FFileName, '', '', False {fWait});
{$ENDIF}
end;

procedure TFormViewUV.ViewerStatusTextChange;
var
  S: string;
  N: Integer;
begin
  S := Text;
  with StatusBar1 do
  begin
    N := Panels[2].Width - 8;
    Canvas.Font := Font; //VCL misses Canvas.Font setting
    if Canvas.TextWidth(S) > N then
    begin
      S := S + #$85;
      while (Length(S) > 1) and (Canvas.TextWidth(S) > N) do
        Delete(S, Length(S) - 1, 1);
    end;
    Panels[2].Text := S;
  end;
end;

procedure TFormViewUV.ViewerTitleChange;
begin
  UpdateCaption('', false, Text);
end;

//Show popup menu

procedure TFormViewUV.mnuViewModeMenuClick(Sender: TObject);
var
  B: TToolButton;
  p: TPoint;
begin
  B := FToolbarList.GetToolButton(mnuViewModeMenu);
  if Assigned(B) then
  begin
    p := Toolbar.ClientToScreen(Point(B.Left, B.Top + B.Height));
    MenuModes.Popup(p.x, p.y);
  end;
end;

procedure TFormViewUV.mnuFileCopyFNClick(Sender: TObject);
begin
  SCopyToClipboardW(FFileName);
end;

{$IFDEF CMDLINE}

function TFormViewUV.GetShowNav: boolean;
begin
  Result := FNavHandle <> 0;
end;
{$ENDIF}

{$IFDEF CMDLINE}

procedure TFormViewUV.SetShowNav(AValue: boolean);
var
  S: WideString;
begin
  if AValue <> GetShowNav then
    if AValue then
    begin
      S := SParamDir + '\Nav.exe';
      if IsFileExist(S) then
        FExecute(S, SFormatW('%s "%s" "%s" "%s"', [
          IntToStr(Handle),
            SMsgLanguage,
            ConfigFolder + '\ViewerHistory.ini',
            ActiveFileName]),
            Handle)
      else
        MsgError(MsgViewerNavMissed);
    end
    else
      SendMessage(FNavHandle, WM_CLOSE, 0, 0);
end;
{$ENDIF}

{$IFDEF CMDLINE}

procedure TFormViewUV.WMDisp(var Msg: TMessage);
begin
  case Msg.WParam of
    100:
      begin
        Msg.Result := 1;
        FNavHandle := Msg.LParam;
        UpdateOptions;
      end;
  else
    Msg.Result := 0;
  end;
end;
{$ENDIF}

{$IFDEF CMDLINE}

function TFormViewUV.ActiveFileName: WideString;
begin
  Result := FFileName;
  if Result = '' then
    Result := FFileFolder;
end;
{$ENDIF}

{$IFDEF CMDLINE}

procedure TFormViewUV.NavSync;
var
  Data: TCopyDataStruct;
  S: WideString;
begin
  S := ActiveFileName;
  if S <> '' then
  begin
    Application.ProcessMessages; //Wait to receive nav handle
    FillChar(Data, SizeOf(Data), 0);
    Data.dwData := 101; //"Open Unicode filename"
    Data.cbData := (Length(S) + 1) * 2;
    Data.lpData := PWideChar(S);
    SendMessage(FNavHandle, WM_COPYDATA, Handle, integer(@Data));
  end;
  //d
  //Showmessage('s: '+S+#13'h: '+IntToStr(FNavHandle));
end;
{$ENDIF}

{$IFDEF CMDLINE}

procedure TFormViewUV.NavMove;
begin
  SendMessage(FNavHandle, EM_DISPLAYBAND, 0, 0);
end;

procedure TFormViewUV.WMMove;
begin
  NavMove;
end;

{$ENDIF}

procedure TFormViewUV.InitComboTipoArchivo;
begin
end;

procedure TFormViewUV.cboTipoArchivoChange(Sender: TObject);
var
  i: integer;
  customPath: string;
  CarpetaEmpRutProp : TItemProp;
  CarpetaEmpCCostoProp : TItemProp;

begin
  LoadFile('');

  if cboTipoArchivo.Text = '' then
    //shellList.Enabled := false
  else
  begin
    //shellList.Enabled := true;
    customPath := flocaldir+cboTipoArchivo.Text;
    //shellList.Root.CustomPath := customPath;
  end;

  clearValEditor;

  //Carpeta_empleado.rut.length := ;

  if (cboTipoArchivo.text = 'Carpeta_Empleado') then
  begin
    valEditor.InsertRow('Rut', '', true);
    valEditor.InsertRow('CentroCosto', '', true);
    valEditor.InsertRow('Caja', '', true);

    //FEmpleadoRutLen, FEmpleadoCCostoLen, FEmpleadoCajaLen, FDocFechaCCostoLen, FDocFechaRutLen

    valEditor.ItemProps[0].MaxLength := FEmpleadoRutLen;
    valEditor.ItemProps[1].MaxLength := FEmpleadoCCostoLen;
    valEditor.ItemProps[2].MaxLength := FEmpleadoCajaLen;
  end;

  if (cboTipoArchivo.text = 'Documentos_Fecha') then
  begin
    valEditor.InsertRow('Rut', '', true);
    valEditor.InsertRow('TipoDocumento', '', true);
    valEditor.InsertRow('Fecha', '', true);

    for i := 0 to fslTipoDocs.Count - 1 do
    begin
      valEditor.ItemProps[1].PickList.AddObject(fslTipoDocs.Names[i],TObject(StrToInt(fslTipoDocs.values[fslTipoDocs.Names[i]])));
    end;

    valEditor.ItemProps[1].EditStyle := esPickList;
    valEditor.ItemProps[1].ReadOnly := true;

    valEditor.ItemProps[2].EditMask := '99-99-9999';

    valEditor.ItemProps[0].MaxLength := FDocFechaRutLen;
    valEditor.ItemProps[2].MaxLength := FDocFechaCCostoLen;
  end;

  ShowFirstFile(customPath);

  valEditor.Row := 1;
  valEditor.Col := 1;
  valEditor.SetFocus;

end;

procedure TFormViewUV.clearValEditor;
var
  i: integer;
begin
  if valEditor.RowCount <= 2 then
    exit;
  for i := 1 to valEditor.RowCount - 1 do
    valEditor.DeleteRow(1);
end;

function TFormViewUV.getNamefromValEditor: string;
var
  i: integer;
  aName: string;
begin

  for i := 1 to valEditor.RowCount - 1 do
  begin
    if i < valEditor.RowCount - 1 then
      aName := aName + valEditor.Cells[1, i] + '_'
  end;

  result := aName;
end;

procedure TFormViewUV.SendDirFiles(sourceDir, remoteDir, backUpDir, name: string);

  function createBackUpdir(const afile: string): boolean;
  var resultDir, drive, path: String;
    lenLocalDir: integer;
  begin
    drive := ExtractFileDrive(afile);
    path := ExtractFilePath(aFile);
    lenLocalDir := length(flocaldir)-1;
    resultDir := copy(flocalbackupdate,length(path),length(flocalbackupdate));
  end;

var
  correlativo: integer;
  path, newName, newLocalPath, msg, remotePath: string;
  SR: TSearchRec;
begin
  remotePath := copy(sourceDir,length(flocaldir), length(sourceDir));
  remotePath := ReplaceStr(remotePath,'\','/');
  remotePath := copy(remoteDir,1,length(remoteDir)-1) + remotePath;

  name := getNamefromValEditor;
  correlativo := 0;
  path := sourceDir;

  if FindFirst(Path + '*.*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        newName := backUpDir + name + IntToStr(correlativo) + ExtractFileExt(Sr.Name);
        memo1.Lines.Add('Enviando: ' + path + name + IntToStr(correlativo) + ExtractFileExt(Sr.Name));

        //SendFileRemote(path+SR.Name,remoteDir + '/' + name + IntToStr(correlativo) + ExtractFileExt(Sr.Name));
        //SendFileRemote(path+SR.Name, name + IntToStr(correlativo) + ExtractFileExt(Sr.Name));

        SendFile(path + SR.Name, remotePath, name + IntToStr(correlativo) + ExtractFileExt(Sr.Name));
        (*
        if renameFile(path + SR.Name, newName) then
          Memo1.lines.add('moviendo: ' + path + SR.Name + ' -> ' + newName + ' Ok.')
        else
          Memo1.lines.add('Error moviendo: ' + path + SR.Name + ' -> ' + newName);
        *)

        //msg := msg + SR.Name + ':' + backUpDir + name + IntToStr(correlativo) + ExtractFileExt(Sr.Name) + #13#10;


        inc(correlativo);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  //ShowMEssage(msg);
end;

function TFormViewUV.IsValidFieldGroup: boolean;
var
  i: integer;
  isValid: boolean;
begin
  isValid := true;
  for i := 1 to valEditor.RowCount - 1 do
  begin
    if trim(valEditor.Cells[1, i]) = '' then
    begin
      ShowMessage('Debe ingresar un valor válido para: ' + valEditor.Keys[i]);
      isValid := false;
      break;
    end;
  end;
  result := isValid;
end;

function TFormViewUV.IsValid: boolean;
begin
  valEditor.SetFocus;

  if cboTipoArchivo.Text = 'Carpeta_Empleado' then
  begin

    if not ValidarRUT(valEditor.Values['rut']) then
    begin
      MessageDlg('Debe ingresar un rut válido', mtError, [mbOK], 0);
      result := false;
      //ve(valEditor).FocusCell(1,1,true);
      valEditor.col := 1;
      valEditor.Row := 1;
      exit;
    end;

    if (valEditor.Values['CentroCosto']='') then
    begin
      MessageDlg('Debe ingresar un centro de costo', mtError, [mbOK], 0);
      result := false;
      //ve(valEditor).FocusCell(1,2,true)
      valEditor.col := 1;
      valEditor.Row := 2;
      exit;
    end;

    if (valEditor.Values['Caja']='') then
    begin
      MessageDlg('Debe ingresar una caja', mtError, [mbOK], 0);
      result := false;
      //ve(valEditor).FocusCell(1,3,true);
      valEditor.col := 1;
      valEditor.Row := 3;
      exit;
    end;

  end;

  if cboTipoArchivo.Text = 'Documentos_Fecha' then
  begin

    if not ValidarRUT(valEditor.Values['rut']) then
    begin
      MessageDlg('Debe ingresar un rut válido', mtError, [mbOK], 0);
      //ve(valEditor).FocusCell(1,1,true);
      valEditor.col := 1;
      valEditor.Row := 1;

      result := false;
      exit;
    end;

    if (valEditor.Values['TipoDocumento']='') then
    begin
      MessageDlg('Debe seleccionar un tipo de documento', mtError, [mbOK], 0);
      //ve(valEditor).FocusCell(1,2,true);
      valEditor.col := 1;
      valEditor.Row := 2;

      result := false;
      exit;
    end;

    if not validarFecha(valEditor.Values['fecha']) then
    begin
      MessageDlg('Debe ingresar una fecha válida', mtError, [mbOK], 0);
      //ve(valEditor).FocusCell(1,3,true);
      valEditor.col := 1;
      valEditor.Row := 3;

      result := false;
      exit;
    end;

  end;

  result := true;
end;

procedure TFormViewUV.Button2Click(Sender: TObject);
var
  msg: string;
  sl: TStringList;
  aIni: TIniFile;
  aIniFileName, path: string;
  SR: TSearchRec;
  host, port, user, pass, remotedir, localbackup, localdir: string;
  i: integer;
begin

  msg := 'Se van a subir los siguientes archivos:';

  for i := 0 to fFilesOkList.Count - 1 do
  begin
    msg := msg + #13#10 + fFilesOkList.Names[i];
  end;

  ShowMessage(msg);

  SendFilesInList;
end;

function TFormViewUV.SFTPConnect(host, port, user, pass: string): boolean;
var
  Key: TElSSHKey;
begin
  result := false;

  SftpClient.Address := host;
  SftpClient.Port := StrToIntDef(port, 22);
  SftpClient.Username := user;
  SftpClient.Password := pass;

  SftpClient.CompressionAlgorithms[SSH_CA_ZLIB] := true;

  SftpClient.AuthenticationTypes := SftpClient.AuthenticationTypes and not
    SSH_AUTH_TYPE_PUBLICKEY;

  memo1.Lines.Add('Connecting to ' + SftpClient.Address);

  SftpClient.Open;
  memo1.Lines.Add('Sftp connection established');
  result := true;

  (*
  try
    SftpClient.Open;
    memo1.Lines.Add('Sftp connection established');
    result := true;
  except on E: Exception do
    begin
      memo1.Lines.Add('Sftp connection failed with message [' + E.Message +
        ']');
      if Length(SftpClient.ServerSoftwareName) > 0 then
        memo1.Lines.Add('Server software identified itself as: ' +
          SftpClient.ServerSoftwareName);
      SftpClient.Close;
      Exit;
    end;
  end;
  *)
end;

procedure TFormViewUV.SendFilesInList;

  function getBackUpdir(const afile: string): String;
  var drive, path, sub: String;
    lenLocalDir: integer;
  begin
    drive := ExtractFileDrive(afile);
    path := ExtractFilePath(aFile);
    sub := copy(path,length(flocaldir)+1,length(path));
    sub := flocalbackupdate + '\' + sub;
    //sub := flocalbackup + '/' +sub;
    if not DirectoryExists(sub) then
      ForceDirectories(sub);
    result := sub;   //flocalbackupdate
  end;

var i, Slindex: integer;
  filelocal, fileremote, dirremote, newFileName, currFile: String;
  sendError: boolean;
begin

  sendError := false;

  if (fFilesOkList.Count = 0) then
  begin
    ShowMessage('No existen archivos para subir');
    exit;
  end;

  memo1.Lines.Clear;

  (*
  if not SftpClient.Active then
  begin
    if SFTPConnect(fhost, fport, fuser, fpass) then
      memo1.lines.add('connected')
    else
    begin
      ShowMessage('Existen problemas de conexión al servidor, revisar.');
      exit;
    end;
  end;
  *)
  i := 0;
  while (fFilesOkList.Count > 0) do
  //for i := 0 to fFilesOkList.Count - 1 do
  begin
    if not fileExists(fFilesOkList.Names[i]) then
    begin
      fFilesOkList.Delete(i);
      SaveOkListToCache;
      continue;
    end;

    SlIndex := LastDelimiter('/',fFilesOkList.Values[fFilesOkList.Names[i]]);
    fileremote  := copy(fFilesOkList.Values[fFilesOkList.Names[i]],Slindex +1, length(fFilesOkList.Values[fFilesOkList.Names[i]]));
    dirremote   := copy(fFilesOkList.Values[fFilesOkList.Names[i]],1, SlIndex);

    //showmessage(dirremote +'-'+ fileremote);
    memo1.Lines.add('Enviando: '+ fFilesOkList.Names[i]);
    memo1.Lines.add('Destino: ' + fFilesOkList.Values[fFilesOkList.Names[i]]);

    try
      SendFile(fFilesOkList.Names[i],dirremote,fileremote);
    except
      sendError := true;
      ShowMessage('Problemas al enviar archivos');
      break;
      exit;
    end;

    if fileexists(getBackUpdir(fFilesOkList.Names[i])+fileremote) then
      DeleteFile(getBackUpdir(fFilesOkList.Names[i])+fileremote);

    if not (RenameFile(fFilesOkList.Names[i],getBackUpdir(fFilesOkList.Names[i])+fileremote)) then
    begin
      ShowMessage('Error al mover archivo: ' + #13#10 +
        'Origen:  ' + fFilesOkList.Names[i] + #13#10 +
        'Destino: ' + getBackUpdir(fFilesOkList.Names[i])+fileremote + #13#10 +
        'Error:   ' + IntToStr(GetLastError) + ', el archivo destino ya existe.');
      Exit;
    end;

    if IsDirectoryEmpty(ExtractFilePath(fFilesOkList.Names[i])) then
      RmDir(ExtractFilePath(fFilesOkList.Names[i]));

    fFilesOkList.Delete(i);

    (*
    currfile := fFilesOkList.Names[i];

    fFilesOkList.Delete(i);

    RenameFile(currfile,getBackUpdir(currfile)+fileremote);

    if IsDirectoryEmpty(ExtractFilePath(currfile)) then
      RmDir(ExtractFilePath(currfile));
    *)
    SaveOkListToCache;

  end;

  if not sendError then
    ShowMessage('Se subieron todos los archivos');

  //ShowFirstFile(flocaldir+cboTipoArchivo.Text);

  ResetValueList;

end;

procedure TFormViewUV.SendFile(localfile, remoteDir, remoteFile: string);
var
  shortName: string;
  Size: integer;
  FName: string;
  Attrs: TElSftpFileAttributes;

  function GetFileSize(const Name: string): Int64;
  var
    F: TFileStream;
  begin
    try
      F := TFileStream.Create(Name, fmOpenRead or fmShareDenyNone);
      try
        Result := F.Size;
      finally
        FreeAndNil(F);
      end;
    except
      Result := 0;
    end;
  end;

begin

  if not SftpClient.Active then
  begin

      SFTPConnect(fhost, fport, fuser, fpass);



    (*
    if SFTPConnect(fhost, fport, fuser, fpass) then
      memo1.lines.add('connected')
    else
    begin
      //ShowMessage('Existen problemas de conexión al servidor, revisar.');
      raise Exception.Create('Existen problemas de conexión al servidor, revisar.');
      exit;
    end; *)
  end;

  if SftpClient.Active then
  begin
    try
      if not SftpClient.FileExists(remoteDir) then
        raise Exception.Create('Error al acceder a directorio remoto');
    except
      on e: exception do
      begin
        if (e.Message = 'No such file') then
        begin
          SftpClient.CreateFile(remoteDir);
        end;
      end;
    end;

    memo1.lines.add('Cambiando a directorio ' + remoteDir);
    memo1.lines.add('Subiendo archivo ' + localfile);

    Size := GetFileSize(localfile);
    pbProgress.Position := 0;

    //SftpClient.UploadFile(localfile, remoteDir + remoteFile);


    try
      SftpClient.UploadFile(localfile, remoteDir + remoteFile);
    except
      on E: Exception do
      begin
        ShowMessage('Error de sftp al intentar subir archivo: ' + E.Message);
        raise Exception.Create('Error al acceder a directorio remoto');
        exit;
      end;
    end;

    Refresh;
  end;
end;

procedure TFormViewUV.SftpClientKeyValidate(Sender: TObject;
  ServerKey: TElSSHKey; var Validate: Boolean);
begin
  memo1.Lines.add('Server key [' + DigestToStr(ServerKey.FingerprintMD5) +  '] received');
  Validate := true;
end;

procedure TFormViewUV.Init;
const
  my_key = 33189;
var
  aIniFilename, userStr: string;
  aIni : TIniFile;
  aFile: textfile;
  aSize: Integer;
begin

  aIniFileName := ExtractFilePath(ParamStr(0)) + 'config.ini';
  aIni := TIniFile.Create(aIniFileName);
  fhost := aIni.ReadString('comm', 'host', '');
  fport := aIni.ReadString('comm', 'port', '');

  FEmpleadoRutLen := StrToIntDef(aIni.ReadString('fields', 'Carpeta_Empleado.rut.length', ''),0);
  FEmpleadoCCostoLen := StrToIntDef(aIni.ReadString('fields', 'Carpeta_Empleado.centrocosto.length', ''),0);
  FEmpleadoCajaLen := StrToIntDef(aIni.ReadString('fields', 'Carpeta_Empleado.caja.length', ''),0);

  FDocFechaCCostoLen := StrToIntDef(aIni.ReadString('fields', 'Documentos_Fecha.centrocosto.length', ''),0);
  FDocFechaRutLen := StrToIntDef(aIni.ReadString('fields', 'Documentos_Fecha.rut.length', ''),0);

  //, FEmpleadoCCostoLen, FEmpleadoCajaLen, FDocFechaCCostoLen, FDocFechaRutLen


  fcompany :=  aIni.ReadString('comm', 'company'  , '');

  if (trim(fcompany)='') then
    fuser := getMachineName
  else
    fuser := fcompany + '_' + getMachineName;

  fpass := 'rubrika.5741';

  flocalbackup := aIni.ReadString('dir' , 'localbackup', '');
  flocaldir    := aIni.ReadString('dir' , 'localdir'   , '');
  fremotedir   := aIni.ReadString('comm', 'remotedir'  , '');

  aIni.Free;

  flocalbackupdate := flocalbackup + FormatDateTime('yyyymmdd',now);

  if not ForceDirectories(flocalbackupdate) then
  begin
    MessageDlg('Error al intentar crear directorio de respaldo: ' + flocalbackupdate, mtError, [mbOK], 0);
    exit;
  end;

  fFilesOkList := TStringList.Create;

  if Fileexists(SParamDir + '\work\cache.dat') then
  begin
    try
      AssignFile(aFile,SParamDir + '\work\cache.dat');
      reset(aFile);
      aSize := FileSize(aFile);
    finally
      system.CloseFile(aFile);
    end;

    if (aSize > 0) then
    begin
      if (Application.MessageBox( 'Existen archivos sin enviar, ¿desea enviarlos ahora?', 'Archivos sin enviar',
			  MB_YESNOCANCEL Or MB_ICONQUESTION) = IDYES) then
      begin
        UploadCache;
      end
      else
        fFilesOkList.LoadFromFile(SParamDir + '\work\cache.dat');
    end;
  end;

  RefreshDirCombo;
end;

procedure TFormViewUV.RefreshDirCombo;
var  searchResult : TSearchRec;
  dirList: TStringList;
  aIniFileName: string;
  i: integer;
  aIni: TInifile;
begin
  LoadFile('');
  cboTipoArchivo.Clear;
  
  aIniFileName := ExtractFilePath(ParamStr(0)) + 'config.ini';
  aIni := TIniFile.Create(aIniFileName);
  dirList := TStringlist.Create;

  dirlist.Add(aIni.ReadString('dir', 'Carpeta_Empleado',''));
  dirlist.Add(aIni.ReadString('dir', 'Documentos_Fecha',''));
  dirlist.Add(aIni.ReadString('dir', 'Electronico',     ''));

  //Carpeta_Empleado
  //Documentos_Fecha
  //Electronico

  for i := 0 to dirList.Count - 1 do
  begin
    //if not IsDirectoryEmpty(dirList.Strings[i]) then
      cboTipoArchivo.AddItem(ExtractFileName(dirList.Strings[i]),TObject(i));
  end;

  fslTipoDocs := TStringList.Create;
  aIni.ReadSectionValues('list',fslTipoDocs);

end;

function TFormViewUV.ShowFirstFile(RootDir: String): boolean;
var
  sr            : TSearchRec;
  iResult       : Integer;
  szNextFolder, remotePath  : String;
begin
  result := false;

  iResult := FindFirst(RootDir + '\*.*',faAnyFile,sr);
  while iResult = 0 do
  begin
    if sr.Attr = faDirectory then
    begin
      if (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        szNextFolder := RootDir + '\' + sr.Name;
        ShowFirstFile(szNextFolder);
      end;
    end
    else
    begin
      if ((ExtractFileExt(sr.Name)='.tif') or (ExtractFileExt(sr.Name)='.pdf')) and
        (fFilesOkList.IndexOfName(rootdir + '\' + SR.Name) = -1) then
      begin
        result := true;
        LoadFile(RootDir +'\' + SR.Name);

        if (fLastScale > 0) then
          Viewer.ImageScale := fLastScale;

        break;
        //Exit;
      end
      else
        //Exit;
    end;
    iResult := FindNext(sr);
  end;
end;

procedure TFormViewUV.valEditorKeyPress(Sender: TObject; var Key: Char);
var remotePath, rootDir, localRem: String;
begin
  if (key <> #13) then
    exit;

  if Viewer.FileName = '' then
  begin
    ShowMessage('No existen mas archivos de este tipo');
    exit;
  end;

  //ShowMessage( 'row: ' + IntToStr(valEditor.Row) + ', col: ' + IntToStr(valEditor.Row) + ', rows: ' + IntToStr(valEditor.RowCount));

  if (valEditor.Row < valEditor.RowCount - 1) then
  begin
    valEditor.Row := valEditor.Row + 1;
    valEditor.Col := 1;
    valEditor.SetFocus;
    exit;
  end
  else
  if not IsValid then
  begin
    valEditor.SetFocus;
    exit;
  end;

  rootDir    := ExtractFilePath(Viewer.FileName);
  remotePath := copy(rootDir,length(flocaldir), length(rootDir));
  remotePath := ReplaceStr(remotePath,'\','/');
  remotePath := copy(fremoteDir,1,length(fremotedir)-1) + remotePath ;

  localRem := Viewer.FileName+'='+remotePath+doGetfileNameOk+ExtractFileExt(Viewer.FileName);

  if (fFilesOkList.IndexOfName(Viewer.FileName) = -1) then
  begin

    fFilesOkList.Add(localRem);

    SaveOkListToCache;

    memo1.Lines := fFilesOkList;
    
    LoadFile('');

    //showmessage(fFilesOkList.Text);

    ShowFirstFile(flocaldir+cboTipoArchivo.Text);

    if (Viewer.FileName = '') then
    begin
      ShowMessage('No existen mas archivos de este tipo para procesar, se subiran los archivos');
      SendFilesInList;
    end;

    ResetValueList;
  end
  else
  begin
    ShowMessage('No existen mas archivos de este tipo para procesar, se subiran los archivos');
    SendFilesInList;
  end;

end;

function TFormViewUV.doGetfileNameOk: String;
var CodTipoDoc, val: String;
  index: integer;
begin

  if (cboTipoArchivo.text = 'Carpeta_Empleado') then
  begin
    result := rightpad(valEditor.Values['rut'],'_',10) + '_' +
      rightpad(valEditor.Values['CentroCosto'],'_',06) + '_' +
      rightpad(valEditor.Values['Caja'],'_',06) ;
  end;

  if cboTipoArchivo.Text = 'Documentos_Fecha' then
  begin
    index := valEditor.ItemProps['TipoDocumento'].PickList.IndexOf(valEditor.Values['TipoDocumento']);
    CodTipoDoc := IntToStr(Integer(valEditor.ItemProps['TipoDocumento'].PickList.Objects[index]));

    result := rightpad(valEditor.Values['rut'],'_',10) + '_' +
      CodTipoDoc                                       + '_' +
      //rightpad(valEditor.Values['fecha'],'0',06);
      StringReplace(valEditor.Values['fecha'],'-','',[rfReplaceAll]);
  end;

end;

procedure TFormViewUV.ResetValueList;
begin

  if cboTipoArchivo.Text = 'Carpeta_Empleado' then
  begin
    valEditor.Values['rut'] := '';
    valEditor.Values['CentroCosto'] := '';
    valEditor.Values['Caja'] := '';
  end;

  if cboTipoArchivo.Text = 'Documentos_Fecha' then
  begin
    valEditor.Values['rut'] := '';
    //valEditor.Values['TipoDocumento'] := '';
    valEditor.Values['fecha'] := '';
  end;

   ve(valEditor).FocusCell(1,1,true);
   valEditor.SetFocus;
   //valEditor.ItemProps['rut'].

end;

procedure TFormViewUV.Generarcdigo1Click(Sender: TObject);
begin
  FmKeyGenerate.ShowModal;
end;

procedure TFormViewUV.SaveOkListToCache;
begin
  try
    fFilesOkList.SaveToFile(SParamDir + '\work\cache.dat');
  except
    ShowMessage('Problema al tratar de escribir en archivo de cache, desocupar el archivo e intentar nuevamente');
  end;
end;

procedure TFormViewUV.LoadCacheToOkList;
begin
end;

procedure TFormViewUV.Subirarchivosencache1Click(Sender: TObject);
begin
  UploadCache;
end;

procedure TFormViewUV.UploadCache;
var msg : string;
 i: integer;
begin

  if not fileexists(SParamDir + '\work\cache.dat') then       
  begin
    showmessage('No existe el archivo de cache');
    exit;
  end;

  try
    fFilesOkList.LoadFromFile(SParamDir + '\work\cache.dat');
  except
    ShowMessage('No se pudo cargar archivo cache');
    exit;
  end;

  msg := 'Se van a subir los siguientes archivos:';

  for i := 0 to fFilesOkList.Count - 1 do
  begin
    msg := msg + #13#10 + fFilesOkList.Names[i];
  end;

  ShowMessage(msg);

  SendFilesInList;
end;

procedure TFormViewUV.Timer1Timer(Sender: TObject);
begin

  if not AppActive then
  begin
    AppActive := true;
    timer1.Enabled := false;
    init;
  end;

end;

procedure TFormViewUV.Button1Click(Sender: TObject);
begin
  RefreshDirCombo;
end;

initialization
  MsgViewerCaption := 'Universal Viewer';
  SSetEnv('ATViewer', SParamDir);

{$IFDEF CMDLINE}
  CheckCommandLine;
{$ENDIF}

  SetLicenseKey('485E29B696E96A099866A1D9E58B6814415B97CFADC170C5C887408E8DB98200'
    +
    '3C884B8328BD6B5E6397B202EE728308D1652BE29D72DE2199DE11D180E66822' +
    '5B978F38E5A06E36A87F8CB026827A80177B1C009E7E229C3DDBAD8D263457AD' +
    '5ADC670972D65E2C41CF63FCB35385C4189482EB363BBD12046ABDC502E08692' +
    '4CC82637F98E737696C145F972BBF50A41A395252EF61932CA739BFBB94E482B' +
    '05BCD414D5FBF80537DA69C748B1F3F7B7AC7814428EB6CD82FF1D507E5B97D1' +
    'D08E57A138E3BECE31E6FB7353EE8AC6E6C93AF251BFE7063EF3E466620464D9' +
    '56186EEA80718DA24FB0CFF6E4C3B3971219D17CC11EB4EC9A117B03BAFB1FDC');

end.

