﻿{ ******************************************************* }
{ }
{ Extension Library }
{ Visual Designer Unit }
{ }
{ (c) 1999 - 2002, Balabuyev Yevgeny }
{ E-mail: stalcer@rambler.ru }
{ Licence: Freeware }
{ https://torry.net/authorsmore.php?id=3588 }
{ ******************************************************* }

unit ELDsgnr;

interface

uses
  Messages, Forms, Classes, Controls, SysUtils, Graphics, Menus;

{ TELDesignPanel }

type
  TELCustomDesignPanel = class(TWinControl)
  private
    FEng: Pointer;
    FBorderStyle: TBorderStyle;
    FForm: TCustomForm;
    procedure SetEng(AEng: Pointer);
    procedure SetBorderStyle(const Value: TBorderStyle);
    function GetIsUsed: Boolean;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CMBiDiModeChanged(var Message: TMessage);
      message CM_BIDIMODECHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMParentBiDiModeChanged(var Message: TMessage);
      message CM_PARENTBIDIMODECHANGED;
    procedure CMParentColorChanged(var Message: TMessage);
      message CM_PARENTCOLORCHANGED;
    procedure CMParentFontChanged(var Message: TMessage);
      message CM_PARENTFONTCHANGED;
    procedure CMParentShowHintChanged(var Message: TMessage);
      message CM_PARENTSHOWHINTCHANGED;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    function GetAutoScroll: Boolean;
    procedure SetAutoScroll(const Value: Boolean);
    function GetHorzScrollBar: TControlScrollBar;
    procedure SetHorzScrollBar(const Value: TControlScrollBar);
    function GetVertScrollBar: TControlScrollBar;
    procedure SetVertScrollBar(const Value: TControlScrollBar);
    procedure UpdateFormParentWindow;
    procedure UpdateFormBounds;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    function GetPopupMenu: TPopupMenu; override;
    property IsUsed: Boolean read GetIsUsed;
    property Form: TCustomForm read FForm;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle
      default bsSingle;
    property AutoScroll: Boolean read GetAutoScroll write SetAutoScroll;
    property HorzScrollBar: TControlScrollBar read GetHorzScrollBar
      write SetHorzScrollBar;
    property VertScrollBar: TControlScrollBar read GetVertScrollBar
      write SetVertScrollBar;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  end;

  TELDesignPanel = class(TELCustomDesignPanel)
  public
    property IsUsed;
    property Form;
  published
    property BorderStyle;
    property AutoScroll;
    property HorzScrollBar;
    property VertScrollBar;
    property BiDiMode;
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TELDesigner }

  EELDesigner = class(Exception);
  TELCustomDesigner = class;

  TELDesignerLockMode = set of (lmNoMove, lmNoResize, lmNoDelete, lmNoInsertIn,
    lmNoCopy, lmCustom1, lmCustom2, lmCustom3, lmCustom4, lmCustom5, lmCustom6,
    lmCustom7, lmCustom8);
  TELDesignerAlignType = (atNoChanges, atLeftTop, atRightBottom, atSpaceEqually,
    atCenter, atCenterInWindow);

  TELDesignerGridSize = 2 .. 32;

  TELDesignerGrid = class(TPersistent)
  private
    FDesigner: TELCustomDesigner;
    FVisible: Boolean;
    FYStep: TELDesignerGridSize;
    FXStep: TELDesignerGridSize;
    FColor: TColor;
    procedure SetVisible(const Value: Boolean);
    procedure SetXStep(const Value: TELDesignerGridSize);
    procedure SetYStep(const Value: TELDesignerGridSize);
    procedure SetColor(const Value: TColor);
  public
    constructor Create(AOwnerDesigner: TELCustomDesigner);
    procedure Assign(Source: TPersistent); override;
  published
    property XStep: TELDesignerGridSize read FXStep write SetXStep default 8;
    property YStep: TELDesignerGridSize read FYStep write SetYStep default 8;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Color: TColor read FColor write SetColor default clBlack;
  end;

  TELDesignerSelectedControls = class
  private
    FDesigner: TELCustomDesigner;
    FItems: TList;
    FVisible: Boolean;
    FActive: Boolean;
    FRootWinControl: TWinControl;
    FUpdateCount: Integer;
    FChanged: Boolean;
    FDestroying: Boolean;
    function GetCount: Integer;
    procedure SetVisible(const Value: Boolean);
    procedure SetActive(const Value: Boolean);
    procedure SetRootWinControl(const Value: TWinControl);
    function GetItems(I: Integer): TControl;
    function GetDefaultControl: TControl;
    procedure Change;
    procedure UpdateMode;
    procedure DeleteItem(AItem: Integer);
    procedure AddItem(AItem: Pointer);
    function IndexOfByItem(AItem: Pointer): Integer;
    procedure CheckDesignControl(AControl: TControl);
  public
    constructor Create(AOwnerDesigner: TELCustomDesigner);
    destructor Destroy; override;
    function Add(AControl: TControl): Integer;
    function IndexOf(AControl: TControl): Integer;
    procedure Delete(AItem: Integer);
    procedure Remove(AControl: TControl);
    procedure SelectControls(AControls: TList);
    procedure GetControls(AResult: TList);
    procedure ClearExcept(AControl: TControl);
    procedure ClearNotChildrensOf(AParent: TWinControl);
    procedure Clear;
    procedure SelectAll;
    procedure Update;
    procedure UpdateControl(AIndex: Integer);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Lock(ALockMode: TELDesignerLockMode);
    procedure AlignToGrid;
    procedure Align(AHorzAlign, AVertAlign: TELDesignerAlignType);
    procedure BringToFront;
    procedure SendToBack;
    property Items[I: Integer]: TControl read GetItems; default;
    property Count: Integer read GetCount;
    property DefaultControl: TControl read GetDefaultControl;
  end;

  TELDesignerHintType = (htControl, htSize, htMove, htInsert);
  TELDesignerHintTypes = set of TELDesignerHintType;
  TELDesignerOnValidateNameEvent = procedure(Sender: TObject;
    const AName: string; var AIsValidName: Boolean) of object;
  TELDesignerOnControlInsertingEvent = procedure(Sender: TObject;
    var AControlClass: TControlClass) of object;
  TELDesignerOnControlDeletingEvent = procedure(Sender: TObject;
    SelectedControls: TELDesignerSelectedControls) of object;
  TELDesignerOnControlHintEvent = procedure(Sender: TObject; AControl: TControl;
    var AHint: string) of object;
  TELDesignerOnNotificationEvent = procedure(Sender: TObject;
    AnObject: TPersistent; Operation: TOperation) of object;
  TELDesignerOnGetUniqueName = procedure(Sender: TObject;
    const ABaseName: string; var AUniqueName: string) of object;
  TELDesignerDragOverEvent = procedure(Sender, ASource, ATarget: TObject;
    XPos, YPos: Integer; AState: TDragState; var AAccept: Boolean) of object;
  TELDesignerDragDropEvent = procedure(Sender, ASource, ATarget: TObject;
    XPos, YPos: Integer) of object;

  TELCustomDesigner = class(TComponent)
  private
    FEng: Pointer; // TDEng
    FSnapToGrid: Boolean;
    FActive: Boolean;
    FOnControlInserted: TNotifyEvent;
    FOnControlInserting: TELDesignerOnControlInsertingEvent;
    FOnControlDeleting: TELDesignerOnControlDeletingEvent;
    FGrid: TELDesignerGrid;
    FSelectedControls: TELDesignerSelectedControls;
    FDesignPanel: TELCustomDesignPanel;
    FActivating: Boolean;
    FOnModified: TNotifyEvent;
    FOnChangeSelection: TNotifyEvent;
    FOnValidateName: TELDesignerOnValidateNameEvent;
    FDesignControl: TWinControl;
    FOnControlHint: TELDesignerOnControlHintEvent;
    FShowingHints: TELDesignerHintTypes;
    FOnDesignFormClose: TCloseEvent;
    FPopupMenu: TPopupMenu;
    FOnContextPopup: TContextPopupEvent;
    FHandleClr: TColor;
    FMultySelectHandleClr: TColor;
    FHandleBorderClr: TColor;
    FInactiveHandleClr: TColor;
    FInactiveHandleBorderClr: TColor;
    FLockedHandleClr: TColor;
    FMultySelectHandleBorderClr: TColor;
    FClipboardFormat: string;
    FClipbrdFormatRegistered: Boolean;
    FClipboardFormatWord: Word;
    FOnKeyUp: TKeyEvent;
    FOnKeyDown: TKeyEvent;
    FOnKeyPress: TKeyPressEvent;
    FOnNotification: TELDesignerOnNotificationEvent;
    FOnGetUniqueName: TELDesignerOnGetUniqueName;
    FOnDblClick: TNotifyEvent;
    FOnDragDrop: TELDesignerDragDropEvent;
    FOnDragOver: TELDesignerDragOverEvent;
    FGuiDesignerHints: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetDesignControl(const Value: TWinControl);
    procedure SetDesignPanel(const Value: TELCustomDesignPanel);
    function GetDesignControlVisible: Boolean;
    procedure SetDesignControlVisible(const Value: Boolean);
    procedure ChangeDesignPanel(const Value: TELCustomDesignPanel);
    procedure SetPopupMenu(const Value: TPopupMenu);
    procedure SetHandleBorderClr(const Value: TColor);
    procedure SetHandleClr(const Value: TColor);
    procedure SetInactiveHandleBorderClr(const Value: TColor);
    procedure SetInactiveHandleClr(const Value: TColor);
    procedure SetLockedHandleClr(const Value: TColor);
    procedure SetMultySelectHandleBorderClr(const Value: TColor);
    procedure SetMultySelectHandleClr(const Value: TColor);
    procedure SetClipboardFormat(const Value: string);
    procedure SetGrid(const Value: TELDesignerGrid);
    function DoKeyDown(var AMessage: TWMKey): Boolean;
    function DoKeyPress(var AMessage: TWMKey): Boolean;
    function DoKeyUp(var AMessage: TWMKey): Boolean;
    procedure GridParamsChanged;
    procedure RegisterClipboardFormat;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure CheckActive(AIsActiveNeeded: Boolean);
    function GetPopupMenu: TPopupMenu; dynamic;
    procedure DoModified; virtual;
    procedure ValidateName(const AName: string;
      var AIsValidName: Boolean); virtual;
    procedure ChangeSelection; virtual;
    procedure ControlInserting(var AControlClass: TControlClass); virtual;
    procedure ControlDeleting(SelectedControls
      : TELDesignerSelectedControls); virtual;
    procedure ControlInserted; virtual;
    procedure DoNotification(AnObject: TPersistent;
      Operation: TOperation); virtual;
    procedure ControlHint(AControl: TControl; var AHint: string); virtual;
    procedure ContextPopup; virtual;
    procedure DesignFormClose(var Action: TCloseAction); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure KeyPress(var Key: Char); virtual;
    procedure KeyUp(var Key: Word; Shift: TShiftState); virtual;
    procedure DblClick; virtual;
    procedure DragOver(ASource, ATarget: TObject; XPos, YPos: Integer;
      AState: TDragState; var AAccept: Boolean); dynamic;
    property Active: Boolean read FActive write SetActive;
    property DesignControl: TWinControl read FDesignControl
      write SetDesignControl;

    property DesignControlVisible: Boolean read GetDesignControlVisible
      write SetDesignControlVisible;
    property DesignPanel: TELCustomDesignPanel read FDesignPanel
      write SetDesignPanel;
    property Grid: TELDesignerGrid read FGrid write SetGrid;
    property SnapToGrid: Boolean read FSnapToGrid write FSnapToGrid
      default True;
    property ShowingHints: TELDesignerHintTypes read FShowingHints
      write FShowingHints default [htControl, htSize, htMove, htInsert];
    property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property HandleClr: TColor read FHandleClr write SetHandleClr
      default clBlack;
    property HandleBorderClr: TColor read FHandleBorderClr
      write SetHandleBorderClr default clBlack;
    property MultySelectHandleClr: TColor read FMultySelectHandleClr
      write SetMultySelectHandleClr default clGray;
    property MultySelectHandleBorderClr: TColor read FMultySelectHandleBorderClr
      write SetMultySelectHandleBorderClr default clGray;
    property InactiveHandleClr: TColor read FInactiveHandleClr
      write SetInactiveHandleClr default clGray;
    property InactiveHandleBorderClr: TColor read FInactiveHandleBorderClr
      write SetInactiveHandleBorderClr default clBlack;
    property LockedHandleClr: TColor read FLockedHandleClr
      write SetLockedHandleClr default clRed;
    property ClipboardFormat: string read FClipboardFormat
      write SetClipboardFormat;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
    property OnValidateName: TELDesignerOnValidateNameEvent read FOnValidateName
      write FOnValidateName;
    property OnGetUniqueName: TELDesignerOnGetUniqueName read FOnGetUniqueName
      write FOnGetUniqueName;
    property OnControlInserting: TELDesignerOnControlInsertingEvent
      read FOnControlInserting write FOnControlInserting;
    property OnControlInserted: TNotifyEvent read FOnControlInserted
      write FOnControlInserted;
    property OnControlDeleting: TELDesignerOnControlDeletingEvent
      read FOnControlDeleting write FOnControlDeleting;
    property OnNotification: TELDesignerOnNotificationEvent read FOnNotification
      write FOnNotification;
    property OnChangeSelection: TNotifyEvent read FOnChangeSelection
      write FOnChangeSelection;
    property OnControlHint: TELDesignerOnControlHintEvent read FOnControlHint
      write FOnControlHint;
    property OnDesignFormClose: TCloseEvent read FOnDesignFormClose
      write FOnDesignFormClose;
    property OnContextPopup: TContextPopupEvent read FOnContextPopup
      write FOnContextPopup;
    property OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnKeyUp: TKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnDragDrop: TELDesignerDragDropEvent read FOnDragDrop
      write FOnDragDrop;
    property OnDragOver: TELDesignerDragOverEvent read FOnDragOver
      write FOnDragOver;
    property GuiDesignerHints: Boolean read FGuiDesignerHints
      write FGuiDesignerHints;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DragDrop(ASource, ATarget: TObject; XPos, YPos: Integer); dynamic;
    procedure Modified;
    procedure DeleteSelectedControls;
    procedure SelectControl(const AName: string);
    procedure LockControl(AControl: TControl; ALockMode: TELDesignerLockMode);
    procedure LockAll(ALockMode: TELDesignerLockMode);
    function GetLockMode(AControl: TControl): TELDesignerLockMode;
    procedure GetUniqueName(const ABaseName: string;
      var AUniqueName: string); virtual;
    function IsUniqueName(const AName: string): Boolean;
    function CanCopy: Boolean;
    function CanCut: Boolean;
    function CanPaste: Boolean;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    property SelectedControls: TELDesignerSelectedControls
      read FSelectedControls;
  end;

  TELDesigner = class(TELCustomDesigner)
  public
    property Active;
    property DesignControl;
    property SelectedControls;
    property DesignControlVisible;
  published
    property DesignPanel;
    property Grid;
    property SnapToGrid;
    property ShowingHints;
    property PopupMenu;
    property HandleClr;
    property HandleBorderClr;
    property MultySelectHandleClr;
    property MultySelectHandleBorderClr;
    property InactiveHandleClr;
    property InactiveHandleBorderClr;
    property LockedHandleClr;
    property ClipboardFormat;
    property GuiDesignerHints;
    property OnModified;
    property OnValidateName;
    property OnGetUniqueName;
    property OnControlInserting;
    property OnControlInserted;
    property OnControlDeleting;
    property OnNotification;
    property OnChangeSelection;
    property OnControlHint;
    property OnDesignFormClose;
    property OnContextPopup;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
  end;

procedure Register;

implementation

uses Windows, RTLConsts, Math, Clipbrd, ExtCtrls, Types,
  JvGnugettext, ELHintWindow, ELSConsts, uCommonFunctions, ULink, UBaseWidgets;

procedure Register;
begin
  RegisterComponents(SELComponentPage, [TELDesigner, TELDesignPanel]);
end;

const
  DESIGNER_BASE = CM_BASE + $B00;
  DESIGNER_SIZING = DESIGNER_BASE + $002;
  DESIGNER_CANCEL = DESIGNER_BASE + $003;
  DESIGNER_SCUPDT = DESIGNER_BASE + $004;

type
  TCustomFormAccess = class(TCustomForm);
  TControlAccess = class(TControl);
  TWinControlAccess = class(TWinControl);

  PTWMMouse = ^TWMMouse;

  TELDMSizing = packed record
    Msg: Cardinal;
    MouseMessage: PTWMMouse;
    Unused: LongInt;
    Result: LongInt;
  end;

  PELDesignerLockMode = ^TELDesignerLockMode;

  TDPForm = class(TCustomForm)
  private
    FDesignPanel: TELCustomDesignPanel;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TDEngCanvas = class(TCanvas)
  private
    FWinControl: TWinControl;
    FHiddenControl: TWinControl;
    procedure SetWinControl(const Value: TWinControl);
  protected
    procedure CreateHandle; override;
  public
    constructor Create;
    destructor Destroy; override;
    function ScreenToClient(const Point: TPoint): TPoint;
    property WinControl: TWinControl read FWinControl write SetWinControl;
  end;

  TDEngHintTimerMode = (tmShow, tmHide);

  TDEngHint = class
  private
    FTimer: TTimer;
    FTimerMode: TDEngHintTimerMode;
    FNeedStartHideTimer: Boolean;
    FCaption: string;
    FActive: Boolean;
    FCheckControl: TControl;
    FUseHooks: Boolean;
    procedure FTimerOnTimer(Sender: TObject);
    procedure DoShowNoPause;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Show(APauseBeforeShow, AHideAfterPause, AUseHooks: Boolean;
      ACheckControl: TControl);
    procedure Hide;
    procedure CheckHideMessageProc(AHandle: Integer; const Message: TMessage);
    property Caption: string read FCaption write FCaption;
    property Active: Boolean read FActive;
  end;

  TDEngNames = class
  private
    FSourceNames, FDestNames: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(const ASourceName, ADestName: string);
    function IndexOf(const ASourceName: string): Integer;
    function DestName(Idx: Integer): string;
  end;

  TDEngDrawProcFlag = (pfInitAndDraw, pfMove, pfOkRemoveAndDispose,
    ddpfCancelRemoveAndDispose);
  TDEngDrawProc = function(ACanvas: TDEngCanvas; AOldDataPtr: Pointer;
    const AVirtualCursorPos: TPoint; AFlag: TDEngDrawProcFlag)
    : Pointer of object;

  IDEngDesigner = IDesignerHook;

  TDEng = class(TInterfacedObject, IDEngDesigner)
  private
    FDesigner: TELCustomDesigner;
    FSelCtrls: TELDesignerSelectedControls;
    FGrid: TELDesignerGrid;
    FHint: TDEngHint;
    FHintControl: TControl;
    FCanvas: TDEngCanvas;
    FRoot: TWinControl;
    FForm: TCustomForm;
    FIsInDrawMode: Boolean;
    FOldDrawInfo: Pointer;
    FLastVirtCursorPos: TPoint;
    FInitDrawProc: TDEngDrawProc;
    FInitCursorPos: TPoint;
    FInitSnapToGrid: Boolean;
    FInitSkipXCursorMoving, FInitSkipYCursorMoving: Boolean;
    FInsertingControlClass: TControlClass;
    FOldRootParent: TWinControl;
    FOldRootLeft: Integer;
    FOldRootTop: Integer;
    FReaderNames: TDEngNames;
    FGridBitmap: Graphics.TBitmap;
    FGridBrush: HBRUSH;
    FGridBkColor: TColor;
    FGridHScrollPos: Integer;
    FGridVScrollPos: Integer;
    FGuiDesignerHints: Boolean;
    function GetRootVisible: Boolean;
    procedure SetRootVisible(const Value: Boolean);
    procedure GridParamsChanged;
    procedure UpdateGridPattern;
    function SelectRectProc(ACanvas: TDEngCanvas; AOldDataPtr: Pointer;
      const AVirtCursorPos: TPoint; AFlag: TDEngDrawProcFlag): Pointer;
    function MoveControlsProc(ACanvas: TDEngCanvas; AOldDataPtr: Pointer;
      const AVirtCursorPos: TPoint; AFlag: TDEngDrawProcFlag): Pointer;
    function SizeControlProc(ACanvas: TDEngCanvas; AOldDataPtr: Pointer;
      const AVirtCursorPos: TPoint; AFlag: TDEngDrawProcFlag): Pointer;
    function InsertControlProc(ACanvas: TDEngCanvas; AOldDataPtr: Pointer;
      const AVirtCursorPos: TPoint; AFlag: TDEngDrawProcFlag): Pointer;
    procedure ReaderSetName(Reader: TReader; Component: TComponent;
      var Name: string);
    procedure ReaderReadComponent(Component: TComponent);
    procedure ReaderReferenceName(Reader: TReader; var Name: string);
  protected
    { IUnknown }
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IDesignerNotify }
    procedure Modified;
    procedure Notification(AnObject: TPersistent; Operation: TOperation);
    procedure CanInsertComponent(AComponent: TComponent);
    function GetExcludedStyleElements(AControl: TControl): TStyleElements;
    { IDEngDesigner }
    function GetCustomForm: TCustomForm;
    procedure SetCustomForm(Value: TCustomForm);
    function GetIsControl: Boolean;
    procedure SetIsControl(Value: Boolean);
    function IsDesignMsg(Sender: TControl; var Message: TMessage): Boolean;
    procedure DrawSelectionMarks(AControl: TControl);
    function IsSelected(AControl: TControl): Boolean;
    procedure PaintGrid;
    procedure ValidateRename(AComponent: TComponent;
      const CurName, NewName: string);
    function UniqueName(const BaseName: string): string;
    function GetRoot: TComponent;
    procedure UpdateCaption(AVisible: Boolean; AUpdateFrame: Boolean);
    procedure UpdateDesigner;
    function DesignPPI(AControl: TWinControl): Integer;
    function GetDesignerHighDPIMode: TVCLDesignerHighDPIMode;
    { Other }
    function IsUniqueName(const AName: string): Boolean;
    function IsDesignControl(AControl: TControl): Boolean;
    function GetDesignControl(AControl: TControl): TControl;
    function MouseMessage(Sender: TControl; const Message: TMessage): Boolean;
    function KeyMessage(const Message: TMessage): Boolean;
    procedure RecursionRefresh(AWinControl: TWinControl);
    procedure DeleteSelectedControls;
    function FindContainer(ASender: TControl): TWinControl;
    procedure LockControl(AControl: TControl; ALockMode: TELDesignerLockMode);
    class function GetLockMode(AControl: TControl): TELDesignerLockMode;
    class function GetFullLockMode(AControl: TControl): TELDesignerLockMode;
    procedure SaveControlsToStream(AStream: TStream; AControls: TList);
    procedure LoadControlsFromStream(AStream: TStream; AParent: TWinControl);
    procedure AlignToGrid(AControl: TControl);
    property RootVisible: Boolean read GetRootVisible write SetRootVisible;
    property GuiDesignerHints: Boolean read FGuiDesignerHints
      write FGuiDesignerHints;
  public
    constructor Create(AOwnerDesigner: TELCustomDesigner; ARoot: TWinControl;
      ADesignPanel: TELCustomDesignPanel);
    destructor Destroy; override;
    procedure SelectAll;
    procedure PaintMenu;
  end;

  TDSelCtrlItemMode = (imNone, imSizeable, imMultySelect);
  TDSelCtrlItemPointPos = (ppTopLeft, ppTop, ppTopRight,
    // 8 Controlpoints of an object
    ppRight, ppBottomRight, ppBottom, ppBottomLeft, ppLeft);

  TDSelCtrlItem = class;

  TDSelCtrlItemPoint = class(TCustomControl)
  private
    FSelCtrl: TDSelCtrlItem;
    FPos: TDSelCtrlItemPointPos;
    FBorderColor: TColor;
    FHandleSize: Integer;
  protected
    procedure Paint; override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwnerSelCtrl: TDSelCtrlItem;
      APos: TDSelCtrlItemPointPos); reintroduce;
    procedure Update; reintroduce;
  end;

  TDSelCtrlItem = class
  private
    FSelCtrls: TELDesignerSelectedControls;
    FPoints: array [TDSelCtrlItemPointPos] of TDSelCtrlItemPoint;
    FControl: TControl;
    FMode: TDSelCtrlItemMode;
    FActivePos: TDSelCtrlItemPointPos;
    procedure SetMode(const Value: TDSelCtrlItemMode);
  public
    constructor Create(AOwnerSelCtrls: TELDesignerSelectedControls;
      AControl: TControl);
    destructor Destroy; override;
    procedure Update;
    property Mode: TDSelCtrlItemMode read FMode write SetMode;
    property Control: TControl read FControl;
  end;

var
  DHintWindow: TESHintWindow;
  DHintWindowShower: TDEngHint;
  DHintWindowRefCount: Integer;
  DHintHook: HHOOK;

function HintHookMsgProc(ACode: Integer; AParam: LongInt; var AMsg: TMsg)
  : LongInt; stdcall;
var
  Message: TMessage;
begin
  Result := CallNextHookEx(DHintHook, ACode, AParam, LPARAM(@AMsg));
  if Assigned(DHintWindowShower) and DHintWindowShower.Active then
  begin
    Message.Msg := AMsg.Message;
    Message.WParam := AMsg.WParam;
    Message.LPARAM := AMsg.LPARAM;
    if DHintWindowShower.FUseHooks then
      DHintWindowShower.CheckHideMessageProc(AMsg.hwnd, Message);
  end;
end;

procedure HookDesignerHintHooks;
begin
  if DHintHook = 0 then
    DHintHook := SetWindowsHookEx(WH_GETMESSAGE, @HintHookMsgProc, 0,
      GetCurrentThreadId);
end;

procedure UnhookDesignerHintHooks;
begin
  if DHintHook <> 0 then
    UnhookWindowsHookEx(DHintHook);
  DHintHook := 0;
end;

function RectFromPoints(AP1, AP2: TPoint): TRect;
begin
  if AP1.X < AP2.X then
  begin
    Result.Left := AP1.X;
    Result.Right := AP2.X;
  end
  else
  begin
    Result.Left := AP2.X;
    Result.Right := AP1.X;
  end;
  if AP1.Y < AP2.Y then
  begin
    Result.Top := AP1.Y;
    Result.Bottom := AP2.Y;
  end
  else
  begin
    Result.Top := AP2.Y;
    Result.Bottom := AP1.Y;
  end;
end;

function IsRectCrossed(AR1, AR2: TRect): Boolean;
begin
  Result := (AR1.Left <= AR2.Right) and (AR2.Left <= AR1.Right) and
    (AR1.Top <= AR2.Bottom) and (AR2.Top <= AR1.Bottom);
end;

procedure DrawSelectRect(ARect: TRect; ACanvas: TCanvas);
begin
  ACanvas.Pen.Color := clWhite;
  ACanvas.Pen.Mode := pmXor;
  ACanvas.Pen.Width := 1;
  ACanvas.Pen.Style := psDot;
  ACanvas.Brush.Style := bsClear;
  ACanvas.Rectangle(ARect);
end;

procedure DrawControlRect(ARect: TRect; ACanvas: TCanvas);
begin
  ACanvas.Pen.Color := clGray;
  ACanvas.Pen.Mode := pmXor;
  ACanvas.Pen.Width := 2;
  ACanvas.Pen.Style := psSolid;
  ACanvas.Brush.Style := bsClear;
  Inc(ARect.Left);
  Inc(ARect.Top);
  ACanvas.Rectangle(ARect);
end;

constructor TDEng.Create(AOwnerDesigner: TELCustomDesigner; ARoot: TWinControl;
  ADesignPanel: TELCustomDesignPanel);

  procedure _UpdateSelectedControlsActive;
  var
    LActive: Boolean;
  begin
    if FForm is TDPForm then
      LActive := TDPForm(FForm).FDesignPanel.Focused
    else
      LActive := FForm.Active;
    FSelCtrls.SetActive(LActive);
  end;

begin
  FDesigner := AOwnerDesigner;
  FSelCtrls := AOwnerDesigner.SelectedControls;
  FGrid := AOwnerDesigner.Grid;
  FHint := TDEngHint.Create;
  FGridBitmap := Graphics.TBitmap.Create;
  if ARoot is TCustomForm then
  begin
    FRoot := ARoot;
    FForm := TCustomForm(ARoot);
  end
  else
  begin
    ADesignPanel.SetEng(Self);
    FRoot := ARoot;
    FForm := ADesignPanel.Form;
    FOldRootParent := FRoot.Parent;
    FOldRootLeft := FRoot.Left;
    FOldRootTop := FRoot.Top;
    FRoot.Parent := FForm;
    FRoot.Left := 0;
    FRoot.Top := 0;
  end;
  FForm.Designer := Self;
  TCustomFormAccess(FForm).SetDesigning(True, False);
  TWinControlAccess(FRoot).SetDesigning(True);
  FRoot.UpdateControlState;
  RecursionRefresh(FRoot);
  FForm.ActiveControl := nil;
  _UpdateSelectedControlsActive;
end;

destructor TDEng.Destroy;
var
  LDMCancelMessage: TMessage;
begin
  if FIsInDrawMode then
  begin
    LDMCancelMessage.Msg := DESIGNER_CANCEL;
    MouseMessage(FForm, LDMCancelMessage);
  end;
  if not(csDestroying in FForm.ComponentState) then
    TCustomFormAccess(FForm).SetDesigning(False, False);
  if not(csDestroying in FRoot.ComponentState) then
    TWinControlAccess(FRoot).SetDesigning(False);
  FForm.Designer := nil;
  if not(csDestroying in FRoot.ComponentState) and Assigned(FRoot) then
  begin
    FRoot.UpdateControlState;
    RecursionRefresh(FRoot);
    if not(FRoot is TCustomForm) then
    begin
      FRoot.Parent := FOldRootParent;
      FRoot.Left := FOldRootLeft;
      FRoot.Top := FOldRootTop;
    end;
  end;
  if FForm is TDPForm then
    TDPForm(FForm).FDesignPanel.SetEng(nil);
  FreeAndNil(FHint);
  FreeAndNil(FCanvas);
  FreeAndNil(FGridBitmap);
  if FGridBrush <> 0 then
    DeleteObject(FGridBrush);
  inherited;
end;

procedure TDEng.PaintMenu;
begin
  // otherwise the compiler will complain!
end;

procedure TDEng.CanInsertComponent(AComponent: TComponent);
begin
  // otherwise the compiler will complain!
end;

function TDEng.GetExcludedStyleElements(AControl: TControl): TStyleElements;
begin
  // otherwise the compiler will complain!
  Result := [];
end;

function TDEng.GetCustomForm: TCustomForm;
begin
  if FRoot is TCustomForm then
    Result := TCustomForm(FRoot)
  else
    Result := nil;
end;

function TDEng.GetIsControl: Boolean;
begin
  Result := TControlAccess(FRoot).IsControl;
end;

function TDEng.GetRoot: TComponent;
begin
  Result := FRoot;
end;

procedure TDEng.UpdateCaption(AVisible: Boolean; AUpdateFrame: Boolean);
begin
end;

procedure TDEng.UpdateDesigner;
begin
end;

function TDEng.DesignPPI(AControl: TWinControl): Integer;
begin
  Result := 0;
end;

function TDEng.GetDesignerHighDPIMode: TVCLDesignerHighDPIMode;
begin
  Result := hdmAutoScale;
end;

procedure TDEng.GridParamsChanged;
begin
  UpdateGridPattern;
  FForm.Refresh;
end;

function TDEng.IsDesignMsg(Sender: TControl; var Message: TMessage): Boolean;

  procedure _FormClose;
  var
    LCloseAction: TCloseAction;
    LForm: TCustomFormAccess;
  begin
    LForm := TCustomFormAccess(FRoot);
    if LForm.FormStyle = fsMDIChild then
      if biMinimize in LForm.BorderIcons then
        LCloseAction := caMinimize
      else
        LCloseAction := caNone
    else
      LCloseAction := caHide;
    FDesigner.DesignFormClose(LCloseAction);
    if LCloseAction <> caNone then
    begin
      if Application.MainForm = TCustomForm(LForm) then
        Application.Terminate
      else
        case LCloseAction of
          caHide:
            RootVisible := False;
          caMinimize:
            if RootVisible then
              ShowWindow(LForm.Handle, SW_SHOWMINIMIZED);
        else
          LForm.Release;
        end;
    end;
  end;

var
  LTarget: TControl;
  AObject: TObject;
  Accepts, IsDockOp: Boolean;

begin
  Result := False;
  if not Assigned(Sender) then
    Exit;
  if not FIsInDrawMode then
    FHint.CheckHideMessageProc(0, Message);
  case Message.Msg of
    CM_DRAG:
      begin
        case TCMDrag(Message).DragMessage of
          dmDragEnter, dmDragLeave, dmDragMove, dmDragDrop:
            with TCMDrag(Message) do
            begin
              LTarget := TControl(DragRec.Target);
              if Assigned(LTarget) then
                LTarget := GetDesignControl(LTarget);
              if Assigned(LTarget) and Assigned(DragRec.Source) then
              begin
                AObject := DragRec.Source;
                IsDockOp := AObject is TDragDockObject;
                if not IsDockOp then
                  AObject := (AObject as TDragControlObject).Control;
                if Assigned(AObject) then
                  with LTarget.ScreenToClient(DragRec.Pos) do
                    case DragMessage of
                      dmDragEnter, dmDragLeave, dmDragMove:
                        begin
                          Accepts := True;
                          FDesigner.DragOver(AObject, LTarget, X, Y,
                            TDragState(DragMessage), Accepts);
                          Result := Ord(Accepts);
                        end;
                      dmDragDrop:
                        if not IsDockOp then
                          FDesigner.DragDrop(AObject, LTarget, X, Y);
                    end;
              end;
            end;
          dmFindTarget:
            begin
              Sender := GetDesignControl(Sender);
              with TCMDrag(Message) do
              begin
                if Assigned(Sender) and (Sender is TWinControl) then
                begin
                  Result := LPARAM(TWinControl(Sender)
                    // LPARAM instead of LongInt
                    .ControlAtPos(Sender.ScreenToClient(DragRec.Pos), False));
                  if Result = 0 then
                    Result := LPARAM(Sender); // LPARAM instead of LongInt
                end
                else
                  TCMDrag(Message).Result := 0;
              end;
            end;
        end;
        Result := True;
      end;
    WM_WINDOWPOSCHANGED:
      PostMessage(FForm.Handle, DESIGNER_SCUPDT, Integer(Sender), 0);
    // PostMessage is
    // improves control
    // repaint speed
    // becouse SelCtrls
    // will be updated after
    // control painting
    DESIGNER_SCUPDT:
      begin
        var
        Int := FSelCtrls.IndexOf(TControl(Message.WParam));
        if Int <> -1 then
          FSelCtrls.UpdateControl(Int);
      end;
    WM_SETFOCUS:
      FSelCtrls.SetActive(True);
    WM_KILLFOCUS:
      FSelCtrls.SetActive(False);
    WM_MOUSEFIRST .. WM_MOUSELAST, DESIGNER_SIZING:
      begin
        Result := MouseMessage(Sender, Message);
        if (Message.Msg = WM_RBUTTONUP) and not FIsInDrawMode then
        begin
          FDesigner.ContextPopup;
          Result := True;
        end;
      end;
    WM_KEYFIRST .. WM_KEYLAST:
      Result := KeyMessage(Message);
    WM_CLOSE:
      begin
        if (Sender = FRoot) and (FRoot is TCustomForm) then
          _FormClose;
        Result := True;
      end;
  end;
end;

procedure TDEng.DrawSelectionMarks(AControl: TControl);
begin

end;

function TDEng.IsSelected(AControl: TControl): Boolean;
begin
  Result := False;
end;

function TDEng.IsUniqueName(const AName: string): Boolean;
begin
  Result := (FRoot.FindComponent(AName) = nil);
end;

procedure TDEng.Modified;
begin
  FSelCtrls.Update;
  FDesigner.DoModified;
end;

procedure TDEng.Notification(AnObject: TPersistent; Operation: TOperation);
begin
  FDesigner.DoNotification(AnObject, Operation);
end;

procedure TDEng.PaintGrid;
begin
  if FGrid.Visible then
  begin
    if (FGridBrush = 0) or (FGridBkColor <> FForm.Color) or
      (FForm.HorzScrollBar.ScrollPos <> FGridHScrollPos) or
      (FForm.VertScrollBar.ScrollPos <> FGridVScrollPos) then
      UpdateGridPattern;
    FillRect(FForm.Canvas.Handle, FForm.Canvas.ClipRect, FGridBrush);
  end;
end;

procedure TDEng.SetCustomForm(Value: TCustomForm);
begin
  raise EELDesigner.Create('Not implemented');
end;

procedure TDEng.SetIsControl(Value: Boolean);
begin
  TControlAccess(FRoot).IsControl := Value;
end;

function TDEng.UniqueName(const BaseName: string): string;
var
  Int: Integer;
  Str: string;
begin
  FDesigner.GetUniqueName(BaseName, Result);
  if Result = '' then
  begin
    if (Length(BaseName) >= 2) and CharInSet(BaseName[1], ['t', 'T']) then
      Str := Copy(BaseName, 2, MaxInt);
    Int := 1;
    Result := Str + IntToStr(Int);
    while not IsUniqueName(Result) do
    begin
      Inc(Int);
      Result := Str + IntToStr(Int);
    end;
  end;
end;

procedure TDEng.ValidateRename(AComponent: TComponent;
  const CurName, NewName: string);
var
  LIsValidName: Boolean;
begin
  if (AComponent is TControl) and IsDesignControl(TControl(AComponent)) and
    (NewName <> '') then
  begin
    LIsValidName := IsValidIdent(NewName);
    if LIsValidName then
      FDesigner.ValidateName(NewName, LIsValidName);
    if not LIsValidName then
      raise EELDesigner.CreateFmt(SInvalidName, [NewName]);
    if UpperCase(CurName) <> UpperCase(NewName) then // changed by Röhner
      if not IsUniqueName(NewName) then
        raise EELDesigner.CreateFmt(SDuplicateName, [NewName]);
  end;
end;

function TDEng.MouseMessage(Sender: TControl; const Message: TMessage): Boolean;

  function _DispatchDesignHitTest(Sender: TControl; Message: TWMMouse): Boolean;
  begin
    Message.Msg := CM_DESIGNHITTEST;
    Message.Result := 0;
    Sender.Dispatch(Message);
    Result := (Message.Result <> 0);
  end;

  function _FindVisibleScreenRect(AClient: TWinControl;
    out ARect: TRect): Boolean;
  var
    LR1, LR2: TRect;
  begin
    LR1 := AClient.ClientRect;
    LR1.TopLeft := AClient.ClientToScreen(LR1.TopLeft);
    LR1.BottomRight := AClient.ClientToScreen(LR1.BottomRight);
    LR2 := FForm.ClientRect;
    LR2.TopLeft := FForm.ClientToScreen(LR2.TopLeft);
    LR2.BottomRight := FForm.ClientToScreen(LR2.BottomRight);
    ARect.Left := Max(LR1.Left, LR2.Left);
    ARect.Top := Max(LR1.Top, LR2.Top);
    ARect.Right := Min(LR1.Right, LR2.Right);
    ARect.Bottom := Min(LR1.Bottom, LR2.Bottom);
    Result := (ARect.Left <= ARect.Right) and (ARect.Top <= ARect.Bottom);
    if not Result then
      ARect := Rect(0, 0, 0, 0);
  end;

  function _GetVirtualCursorPos(AStartCursorPos: TPoint): TPoint;
  begin
    GetCursorPos(Result);
    if FInitSkipXCursorMoving then
      Result.X := AStartCursorPos.X
    else if FDesigner.SnapToGrid and FInitSnapToGrid then
      Result.X := Round((Result.X - AStartCursorPos.X) / FGrid.FXStep) *
        FGrid.FXStep + AStartCursorPos.X;
    if FInitSkipYCursorMoving then
      Result.Y := AStartCursorPos.Y
    else if FDesigner.SnapToGrid and FInitSnapToGrid then
      Result.Y := Round((Result.Y - AStartCursorPos.Y) / FGrid.FYStep) *
        FGrid.FYStep + AStartCursorPos.Y;
  end;

  procedure _InitDrawMode(AControlToDrawOn: TWinControl;
    ADrawProc: TDEngDrawProc; ASnapToGrid, AInitSkipXCursorMoving,
    AInitSkipYCursorMoving, ASnapToGridFirstCursorPos: Boolean);
  var
    Rect: TRect;
  begin
    FHint.Hide;
    FForm.Update;
    FCanvas := TDEngCanvas.Create;
    FCanvas.WinControl := AControlToDrawOn;
    FInitDrawProc := ADrawProc;
    FInitSnapToGrid := ASnapToGrid;
    FInitSkipXCursorMoving := AInitSkipXCursorMoving;
    FInitSkipYCursorMoving := AInitSkipYCursorMoving;
    GetCursorPos(FInitCursorPos);
    if FDesigner.SnapToGrid and ASnapToGridFirstCursorPos then
    begin
      FInitCursorPos := FForm.ScreenToClient(FInitCursorPos);
      FInitCursorPos.X := ((FInitCursorPos.X + FForm.HorzScrollBar.ScrollPos)
        div FGrid.FXStep) * FGrid.FXStep - FForm.HorzScrollBar.ScrollPos;
      FInitCursorPos.Y := ((FInitCursorPos.Y + FForm.VertScrollBar.ScrollPos)
        div FGrid.FYStep) * FGrid.FYStep - FForm.VertScrollBar.ScrollPos;
      FInitCursorPos := FForm.ClientToScreen(FInitCursorPos);
    end;
    FInitCursorPos := _GetVirtualCursorPos(FInitCursorPos);
    SetCaptureControl(FRoot);
    if _FindVisibleScreenRect(AControlToDrawOn, Rect) then
      ClipCursor(@Rect);
    FLastVirtCursorPos := FInitCursorPos;
    FOldDrawInfo := FInitDrawProc(FCanvas, nil, FInitCursorPos, pfInitAndDraw);
    FIsInDrawMode := True;
  end;

  procedure _DrawModeMouseMove;
  var
    Point: TPoint;
  begin
    Point := _GetVirtualCursorPos(FInitCursorPos);
    if (FLastVirtCursorPos.X <> Point.X) or (FLastVirtCursorPos.Y <> Point.Y)
    then
      FOldDrawInfo := FInitDrawProc(FCanvas, FOldDrawInfo, Point, pfMove);
    FLastVirtCursorPos := Point;
  end;

  procedure _DrawModeLButtonUp(ACancel: Boolean);
  var
    Point: TPoint;
    LFlag: TDEngDrawProcFlag;
  begin
    try
      Point := _GetVirtualCursorPos(FInitCursorPos);
      if ACancel then
        LFlag := ddpfCancelRemoveAndDispose
      else
        LFlag := pfOkRemoveAndDispose;
      try
        FInitDrawProc(FCanvas, FOldDrawInfo, Point, LFlag);
      finally
        if GetCaptureControl = FRoot then
          SetCaptureControl(nil);
        ClipCursor(nil);
        FreeAndNil(FCanvas);
      end;
    finally
      FIsInDrawMode := False;
    end;
  end;

var
  LDesignMessage: Boolean;
  LContainer: TWinControl;
  Str: string;
  LInsertingControl: Boolean;
  LNeedMove: Boolean;
  LControls: TList;
  Typ: string;
begin
  Result := FIsInDrawMode or (Message.Msg = DESIGNER_SIZING);
  if not Result then
  begin
    LDesignMessage := _DispatchDesignHitTest(Sender, TWMMouse(Message));
    Result := Result or not LDesignMessage;
  end;
  case Message.Msg of
    DESIGNER_SIZING:
      if not(lmNoResize in GetLockMode(Sender)) then
      begin
        Sender := GetDesignControl(Sender);
        FSelCtrls.SetVisible(False);
        FSelCtrls.ClearExcept(Sender);
        if FDesigner.FSnapToGrid then
        begin
          if TDSelCtrlItem(FSelCtrls.FItems[0]).FActivePos
            in [ppTopLeft, ppTop, ppTopRight] then
            Sender.Top := Round(Sender.Top / FGrid.FYStep) * FGrid.FYStep;
          if TDSelCtrlItem(FSelCtrls.FItems[0]).FActivePos
            in [ppBottomLeft, ppBottom, ppBottomRight] then
            Sender.Height := Round((Sender.Top + Sender.Height) / FGrid.FYStep)
              * FGrid.FYStep - Sender.Top;
          if TDSelCtrlItem(FSelCtrls.FItems[0]).FActivePos
            in [ppTopLeft, ppLeft, ppBottomLeft] then
            Sender.Left := Round(Sender.Left / FGrid.FXStep) * FGrid.FXStep;
          if TDSelCtrlItem(FSelCtrls.FItems[0]).FActivePos
            in [ppTopRight, ppRight, ppBottomRight] then
            Sender.Width := Round((Sender.Left + Sender.Width) / FGrid.FXStep) *
              FGrid.FXStep - Sender.Left;
        end;
        _InitDrawMode(Sender.Parent, SizeControlProc, True,
          TDSelCtrlItem(FSelCtrls.FItems[0]).FActivePos in [ppTop, ppBottom],
          TDSelCtrlItem(FSelCtrls.FItems[0]).FActivePos in [ppLeft,
          ppRight], False);
      end;
    WM_LBUTTONDOWN, WM_RBUTTONDOWN:
      if not((Sender = FForm) and (FRoot <> FForm)) then
      begin
        LInsertingControl := False;
        if Message.Msg = WM_LBUTTONDOWN then
        begin
          FInsertingControlClass := nil;
          LContainer := FindContainer(Sender);
          if not(lmNoInsertIn in GetLockMode(LContainer)) and
            Assigned(LContainer) then
          begin
            FDesigner.ControlInserting(FInsertingControlClass);
            if Assigned(FInsertingControlClass) then
            begin
              LInsertingControl := True;
              _InitDrawMode(LContainer, InsertControlProc, True, False,
                False, True);
            end;
          end;
        end;
        if not LInsertingControl then
        begin
          Sender := GetDesignControl(Sender);
          if ssShift in KeysToShiftState(TWMMouse(Message).Keys) then
          begin
            FSelCtrls.BeginUpdate;
            try
              if FSelCtrls.IndexOf(Sender) = -1 then
              begin
                if not((Sender = FRoot) and (FSelCtrls.Count <> 0)) then
                  FSelCtrls.Add(Sender);
              end
              else
                FSelCtrls.Remove(Sender);
              if FSelCtrls.Count = 0 then
                FSelCtrls.Add(FRoot);
            finally
              FSelCtrls.EndUpdate;
            end;
          end
          else
          begin
            if (Sender = FRoot) or ((TWMMouse(Message).Keys and MK_CONTROL) > 0)
            then
            begin
              FSelCtrls.ClearExcept(FRoot);
              if Result and (Message.Msg = WM_LBUTTONDOWN) then
              begin
                while Assigned(Sender) and
                  (not IsDesignControl(Sender) or
                  not(TControlAccess(Sender).GetChildParent <> nil) or
                  not(TControlAccess(Sender).GetChildParent is TWinControl) or
                  not(csAcceptsControls in TWinControl(TControlAccess(Sender)
                  .GetChildParent).ControlStyle)) do
                  Sender := Sender.Parent;
                if Assigned(Sender) and
                  (TControlAccess(Sender).GetChildParent <> nil) then
                  _InitDrawMode
                    (TWinControl(TControlAccess(Sender).GetChildParent),
                    SelectRectProc, False, False, False, False);
              end;
            end
            else
            begin
              LControls := TList.Create;
              try
                if FSelCtrls.IndexOf(Sender) = -1 then
                begin
                  if FDesigner.FSnapToGrid then
                  begin
                    Sender.Top := Round(Sender.Top / FGrid.FYStep) *
                      FGrid.FYStep;
                    Sender.Left := Round(Sender.Left / FGrid.FXStep) *
                      FGrid.FXStep;
                  end;
                  LControls.Add(Sender);
                end
                else
                begin
                  FSelCtrls.ClearNotChildrensOf(Sender.Parent);
                  FSelCtrls.GetControls(LControls);
                end;
                if Result and (Message.Msg = WM_LBUTTONDOWN) then
                begin
                  LNeedMove := False;
                  for var I := 0 to LControls.Count - 1 do
                    if not(lmNoMove in GetLockMode(LControls[I])) then
                    begin
                      LNeedMove := True;
                      Break;
                    end;
                  if not(lmNoMove in GetLockMode(Sender)) and LNeedMove then
                  begin
                    for var I := LControls.Count - 1 downto 0 do
                      if lmNoMove in GetLockMode(LControls[I]) then
                        LControls.Delete(I);
                    FSelCtrls.SetVisible(False);
                    FSelCtrls.SelectControls(LControls);
                    _InitDrawMode(Sender.Parent, MoveControlsProc, True, False,
                      False, False);
                  end
                  else
                    FSelCtrls.SelectControls(LControls);
                end
                else
                  FSelCtrls.SelectControls(LControls);
              finally
                FreeAndNil(LControls);
              end;
            end;
          end;
        end;
      end;
    WM_MOUSEMOVE: // Show/Hide FHint
      if FIsInDrawMode then
        _DrawModeMouseMove
      else
      begin
        Sender := GetDesignControl(Sender);
        if Assigned(Sender) then
        begin
          if (Sender = FRoot) or (Sender = FForm) or not Result then
            FHint.Hide
          else if FHintControl <> Sender then
          begin
            if htControl in FDesigner.ShowingHints then
            begin
              Typ := Tag2PythonType((Sender as TBaseWidget).Tag);
              if (Sender as TBaseWidget).Tag > 70 then Typ:= 'Q' + Typ;
              Str := Sender.Name + ': ' + Typ + #13#10;
              Str := Str + _('Position') + ': ' +
                IntToStr(Sender.PPIUnScale(Sender.Left)) + ', ' +
                IntToStr(Sender.PPIUnScale(Sender.Top)) + #13#10;
              Str := Str + _('Size') + ': ' +
                IntToStr(Sender.PPIUnScale(Sender.Width)) + ', ' +
                IntToStr(Sender.PPIUnScale(Sender.Height));
              Str := Str + #13#10 + _('Font size') + ': ' +
                IntToStr((Sender as TBaseWidget).Font.Size);
              if Assigned(FDesigner) then
                FDesigner.ControlHint(Sender, Str);
              if Str <> '' then
              begin
                FHint.Caption := Str;
                if GuiDesignerHints then
                  FHint.Show(False, False, True, Sender)
                else
                  FHint.Show(not FHint.Active, True, True, Sender);
              end
              else
                FHint.Hide;
            end
            else
              FHint.Hide;
          end;
          if Result then
            FHintControl := Sender
          else
            FHintControl := nil;
        end;
      end;
    WM_LBUTTONUP:
      if FIsInDrawMode then
      begin
        _DrawModeLButtonUp(False);
        FSelCtrls.SetVisible(True);
      end;
    WM_LBUTTONDBLCLK:
      if not FIsInDrawMode then
        FDesigner.DblClick;
    DESIGNER_CANCEL:
      if FIsInDrawMode then
      begin
        _DrawModeLButtonUp(True);
        FSelCtrls.SetVisible(True);
      end;
  end;
end;

function TDEng.SelectRectProc(ACanvas: TDEngCanvas; AOldDataPtr: Pointer;
  const AVirtCursorPos: TPoint; AFlag: TDEngDrawProcFlag): Pointer;

type
  PPointsRect = ^TPointsRect;
  TPointsRect = array [0 .. 1] of TPoint;

  procedure _DoXORDraw(AData: PPointsRect);
  begin
    DrawSelectRect(RectFromPoints(AData^[0], AData^[1]), ACanvas);
  end;

  procedure _FillData(PointsRect: PPointsRect);
  var
    Rect: TRect;
  begin
    Rect := ACanvas.WinControl.ClientRect;
    Rect.TopLeft := ACanvas.WinControl.ClientToScreen(Rect.TopLeft);
    Rect.BottomRight := ACanvas.WinControl.ClientToScreen(Rect.BottomRight);
    PointsRect^[0] := ACanvas.ScreenToClient(AVirtCursorPos);
  end;

var
  LSelectRect: TRect;
  LPointsRect: TPointsRect;
  LControl: TControl;

begin
  Result := nil;
  case AFlag of
    pfInitAndDraw:
      begin
        if not Assigned(AOldDataPtr) then
          New(PPointsRect(Result))
        else
          Result := AOldDataPtr;
        _FillData(Result);
        if not Assigned(AOldDataPtr) then
          PPointsRect(Result)^[1] := PPointsRect(Result)^[0];
        _DoXORDraw(Result);
      end;
    pfMove:
      begin
        LPointsRect := PPointsRect(AOldDataPtr)^;
        _FillData(@LPointsRect);
        _DoXORDraw(AOldDataPtr);
        _DoXORDraw(@LPointsRect);
        PPointsRect(AOldDataPtr)^ := LPointsRect;
        Result := AOldDataPtr;
      end;
    pfOkRemoveAndDispose:
      try
        _DoXORDraw(AOldDataPtr);
        LSelectRect := RectFromPoints(PPointsRect(AOldDataPtr)^[0],
          PPointsRect(AOldDataPtr)^[1]);
        FSelCtrls.BeginUpdate;
        try
          for var I := 0 to ACanvas.WinControl.ControlCount - 1 do
          begin
            LControl := ACanvas.WinControl.Controls[I];
            if IsRectCrossed(LControl.BoundsRect, LSelectRect) and
              IsDesignControl(LControl) then
              FSelCtrls.Add(ACanvas.WinControl.Controls[I]);
          end;
          if FSelCtrls.Count > 1 then
            FSelCtrls.Remove(FRoot);
        finally
          FSelCtrls.EndUpdate; // hier werden schwarze Punkte gezeichnet
        end;
      finally
        Dispose(PPointsRect(AOldDataPtr));
      end;
    ddpfCancelRemoveAndDispose:
      try
        _DoXORDraw(AOldDataPtr);
      finally
        Dispose(PPointsRect(AOldDataPtr));
      end;
  end;
end;

function TDEng.MoveControlsProc(ACanvas: TDEngCanvas; AOldDataPtr: Pointer;
  const AVirtCursorPos: TPoint; AFlag: TDEngDrawProcFlag): Pointer;

type
  PControlItem = ^TControlItem;

  TControlItem = record
    Rect: TRect;
    Control: TControl;
  end;

  PDataRec = ^TDataRec;

  TDataRec = record
    ControlList: TList;
    StartClientCursorPos: TPoint;
    Offset: TPoint;
    MinLeftTop: TPoint;
  end;

  function _InitData: PDataRec;

    procedure __AddControl(AData: PDataRec; AControl: TControl);
    var
      LControlItemPtr: PControlItem;
      Rect: TRect;
    begin
      New(LControlItemPtr);
      Rect := AControl.BoundsRect;
      LControlItemPtr.Rect := Rect;
      LControlItemPtr.Control := AControl;
      AData.ControlList.Add(LControlItemPtr);
      if AData.MinLeftTop.X > Rect.Left then
        AData.MinLeftTop.X := Rect.Left;
      if AData.MinLeftTop.Y > Rect.Top then
        AData.MinLeftTop.Y := Rect.Top;
    end;

  begin
    New(Result);
    Result.ControlList := TList.Create;
    Result.MinLeftTop := Point(MaxInt, MaxInt);
    for var I := 0 to FSelCtrls.Count - 1 do
      __AddControl(Result, FSelCtrls[I]);
    Result.StartClientCursorPos := ACanvas.ScreenToClient(AVirtCursorPos);
    Result.Offset := Point(0, 0);
  end;

  procedure _DisposeData(AData: PDataRec);
  begin
    for var I := 0 to AData.ControlList.Count - 1 do
      Dispose(PControlItem(AData.ControlList[I]));
    FreeAndNil(AData.ControlList);
    Dispose(AData);
  end;

  procedure _DoXORDraw(AData: PDataRec);
  var
    Rect: TRect;
  begin
    for var I := 0 to AData.ControlList.Count - 1 do
      if not(lmNoMove in GetLockMode(PControlItem(AData.ControlList[I]).Control))
      then
      begin
        Rect := PControlItem(AData.ControlList[I]).Rect;
        OffsetRect(Rect, AData.Offset.X, AData.Offset.Y);
        DrawControlRect(Rect, ACanvas);
      end;
  end;

  procedure _ShowHint(Point: TPoint);
  begin
    if htMove in FDesigner.ShowingHints then
    begin
      if Assigned(FHintControl) then
        FHint.Caption := IntToStr(FHintControl.PPIUnScale(Point.X)) + ', ' +
          IntToStr(FHintControl.PPIUnScale(Point.Y))
      else
        FHint.Caption := IntToStr(Point.X) + ', ' + IntToStr(Point.Y);
      FHint.Show(False, False, False, nil);
    end;
  end;

  procedure _FillData(DataRecPtr: PDataRec);
  var
    Point: TPoint;
  begin
    Point := ACanvas.ScreenToClient(AVirtCursorPos);
    Point.X := Point.X - DataRecPtr.StartClientCursorPos.X;
    Point.Y := Point.Y - DataRecPtr.StartClientCursorPos.Y;
    DataRecPtr.Offset.X := Point.X;
    DataRecPtr.Offset.Y := Point.Y;
  end;

var
  LNewControlBounds: TRect;
  LDataRec: TDataRec;

begin
  Result := nil;
  case AFlag of
    pfInitAndDraw:
      begin
        Result := _InitData;
        _FillData(Result);
        _DoXORDraw(Result);
        _ShowHint(Point(PDataRec(Result).MinLeftTop.X + PDataRec(Result)
          .Offset.X, PDataRec(Result).MinLeftTop.Y + PDataRec(Result)
          .Offset.Y));
      end;
    pfMove:
      begin
        LDataRec := PDataRec(AOldDataPtr)^;
        _FillData(@LDataRec);
        FHint.Hide;
        _DoXORDraw(AOldDataPtr);
        _DoXORDraw(@LDataRec);
        _ShowHint(Point(LDataRec.MinLeftTop.X + LDataRec.Offset.X,
          LDataRec.MinLeftTop.Y + LDataRec.Offset.Y));
        PDataRec(AOldDataPtr)^ := LDataRec;
        Result := AOldDataPtr;
      end;
    pfOkRemoveAndDispose:
      try
        FHint.Hide;
        _DoXORDraw(AOldDataPtr);
        if (PDataRec(AOldDataPtr).Offset.X <> 0) or
          (PDataRec(AOldDataPtr).Offset.Y <> 0) then
        begin
          for var I := 0 to PDataRec(AOldDataPtr).ControlList.Count - 1 do
            if not(lmNoMove in GetLockMode(PControlItem(PDataRec(AOldDataPtr)
              .ControlList[I]).Control)) then
            begin
              LNewControlBounds :=
                PControlItem(PDataRec(AOldDataPtr).ControlList[I]).Rect;
              OffsetRect(LNewControlBounds, PDataRec(AOldDataPtr).Offset.X,
                PDataRec(AOldDataPtr).Offset.Y);
              with LNewControlBounds do
                PControlItem(PDataRec(AOldDataPtr).ControlList[I])
                  .Control.SetBounds(Left, Top, Right - Left, Bottom - Top);
            end;
          Modified;
        end;
      finally
        _DisposeData(AOldDataPtr);
      end;
    ddpfCancelRemoveAndDispose:
      try
        FHint.Hide;
        _DoXORDraw(AOldDataPtr);
      finally
        _DisposeData(AOldDataPtr);
      end;
  end;
end;

function TDEng.SizeControlProc(ACanvas: TDEngCanvas; AOldDataPtr: Pointer;
  const AVirtCursorPos: TPoint; AFlag: TDEngDrawProcFlag): Pointer;

type
  PDataRec = ^TDataRec;

  TDataRec = record
    Control: TControl;
    PointPosition: TDSelCtrlItemPointPos;
    StartClientCursorPos: TPoint;
    Offset: TPoint;
  end;

  function _InitData: PDataRec;
  begin
    New(Result);
    Result.Control := FSelCtrls[0];
    Result.PointPosition := TDSelCtrlItem(FSelCtrls.FItems[0]).FActivePos;
    Result.StartClientCursorPos := ACanvas.ScreenToClient(AVirtCursorPos);
    Result.Offset := Point(0, 0);
  end;

  procedure _DisposeData(AData: PDataRec);
  begin
    Dispose(AData);
  end;

  procedure _DoXORDraw(ARect: TRect);
  begin
    DrawControlRect(ARect, ACanvas);
  end;

  function _CalcDrawRect(AData: PDataRec): TRect;
  begin
    Result := AData.Control.BoundsRect;
    Result.Left := Result.Left + AData.Offset.X *
      Ord(AData.PointPosition in [ppTopLeft, ppBottomLeft, ppLeft]);
    Result.Top := Result.Top + AData.Offset.Y *
      Ord(AData.PointPosition in [ppTopLeft, ppTop, ppTopRight]);
    Result.Right := Result.Right + AData.Offset.X *
      Ord(AData.PointPosition in [ppTopRight, ppRight, ppBottomRight]);
    Result.Bottom := Result.Bottom + AData.Offset.Y *
      Ord(AData.PointPosition in [ppBottomRight, ppBottom, ppBottomLeft]);
    Result := RectFromPoints(Result.TopLeft, Result.BottomRight);
  end;

  procedure _ShowHint(Rect: TRect);
  begin
    if htSize in FDesigner.ShowingHints then
    begin
      if Assigned(FHintControl) then
        FHint.Caption :=
          IntToStr(FHintControl.PPIUnScale(Rect.Right - Rect.Left)) + ' X ' +
          IntToStr(FHintControl.PPIUnScale(Rect.Bottom - Rect.Top))
      else
        FHint.Caption := IntToStr(Rect.Right - Rect.Left) + ' X ' +
          IntToStr(Rect.Bottom - Rect.Top);
      FHint.Show(False, False, False, nil);
    end;
  end;

  procedure _FillData(ADataRec: PDataRec);
  var
    Point: TPoint;
  begin
    Point := ACanvas.ScreenToClient(AVirtCursorPos);
    Point.X := Point.X - ADataRec.StartClientCursorPos.X;
    Point.Y := Point.Y - ADataRec.StartClientCursorPos.Y;
    ADataRec.Offset.X := Point.X;
    ADataRec.Offset.Y := Point.Y;
  end;

var
  LOldControlBoundsRect, LDrawRect: TRect;
  LDataRec: TDataRec;

begin
  Result := nil;
  case AFlag of
    pfInitAndDraw:
      begin
        Result := _InitData;
        _FillData(Result);
        LDrawRect := _CalcDrawRect(Result);
        _DoXORDraw(LDrawRect);
        _ShowHint(LDrawRect);
      end;
    pfMove:
      begin
        LDataRec := PDataRec(AOldDataPtr)^;
        _FillData(@LDataRec);
        LDrawRect := _CalcDrawRect(@LDataRec);
        FHint.Hide;
        _DoXORDraw(_CalcDrawRect(AOldDataPtr));
        _DoXORDraw(LDrawRect);
        _ShowHint(LDrawRect);
        PDataRec(AOldDataPtr)^ := LDataRec;
        Result := AOldDataPtr;
      end;
    pfOkRemoveAndDispose:
      try
        LDrawRect := _CalcDrawRect(AOldDataPtr);
        FHint.Hide;
        _DoXORDraw(LDrawRect);
        LOldControlBoundsRect := PDataRec(AOldDataPtr).Control.BoundsRect;
        if (LDrawRect.Left <> LOldControlBoundsRect.Left) or
          (LDrawRect.Top <> LOldControlBoundsRect.Top) or
          (LDrawRect.Right <> LOldControlBoundsRect.Right) or
          (LDrawRect.Bottom <> LOldControlBoundsRect.Bottom) then
        begin
          with LDrawRect do
            PDataRec(AOldDataPtr).Control.SetBounds(Left, Top, Right - Left,
              Bottom - Top);
          PDataRec(AOldDataPtr).Control.Update;
          Modified;
        end;
      finally
        _DisposeData(AOldDataPtr);
      end;
    ddpfCancelRemoveAndDispose:
      try
        FHint.Hide;
        _DoXORDraw(_CalcDrawRect(AOldDataPtr));
      finally
        _DisposeData(AOldDataPtr);
      end;
  end;
end;

function TDEng.KeyMessage(const Message: TMessage): Boolean;

type
  TDirection = (dNone, dLeft, dUp, dRight, dDown);

  function _CalcDistance(AFromRect, AToRect: TRect;
    ADirection: TDirection): Real;
  const
    LRotateCount: array [TDirection] of Integer = (-1, 4, 3, 2, 1);
  var
    LBufRect: TRect;
    LFromP, LToP: TPoint;
  begin
    Result := -1;
    if LRotateCount[ADirection] = -1 then
      Exit;
    for var I := 1 to LRotateCount[ADirection] do
    begin
      LBufRect := AFromRect;
      AFromRect.TopLeft := Point(-LBufRect.Bottom, LBufRect.Left);
      AFromRect.BottomRight := Point(-LBufRect.Top, LBufRect.Right);
      LBufRect := AToRect;
      AToRect.TopLeft := Point(-LBufRect.Bottom, LBufRect.Left);
      AToRect.BottomRight := Point(-LBufRect.Top, LBufRect.Right);
    end;
    if AToRect.Right < AFromRect.Left then
    begin
      if (AToRect.Bottom < AFromRect.Top) and
        (AFromRect.Top - AToRect.Bottom > AFromRect.Left - AToRect.Right) then
        Exit;
      if (AToRect.Top > AFromRect.Bottom) and
        (AToRect.Top - AFromRect.Bottom > AFromRect.Left - AToRect.Right) then
        Exit;
    end
    else if (AToRect.Left <= AFromRect.Right) and
      (AToRect.Right >= AFromRect.Left) then
    begin
      if AToRect.Bottom < AFromRect.Top then
        Exit;
      if AToRect.Top > AFromRect.Bottom then
        Exit;
      if (AToRect.Left + AToRect.Right) div 2 >=
        (AFromRect.Left + AFromRect.Right) div 2 then
        Exit;
    end
    else
      Exit;
    LFromP := Point(AFromRect.Left, (AFromRect.Top + AFromRect.Bottom) div 2);
    if AToRect.Right < AFromRect.Left then
    begin
      if AToRect.Bottom < LFromP.Y then
        LToP := AToRect.BottomRight
      else if AToRect.Bottom > LFromP.Y then
        LToP := Point(AToRect.Right, AToRect.Top)
      else
        LToP := Point(AToRect.Right, LFromP.Y);
    end
    else if AToRect.Top > LFromP.Y then
      LToP := Point(AToRect.Top, LFromP.Y)
    else if AToRect.Bottom < LFromP.Y then
      LToP := Point(AToRect.Bottom, LFromP.Y)
    else
      LToP := LFromP;
    Result := Sqrt((LFromP.X - LToP.X) * (LFromP.X - LToP.X) +
      (LFromP.Y - LToP.Y) * (LFromP.Y - LToP.Y));
  end;

  function _FindNearControl(AForward: Boolean): TControl;

    function __DoFind(AFromIndex, AToIndex: Integer; AForward: Boolean)
      : TControl;
    begin
      Result := nil;
      while AFromIndex * (-1 + 2 * Ord(AForward)) <= AToIndex *
        (-1 + 2 * Ord(AForward)) do
      begin
        if (FRoot.Components[AFromIndex] is TControl) and
          (TControl(FRoot.Components[AFromIndex]).Parent <> nil) then
        begin
          Result := TControl(FRoot.Components[AFromIndex]);
          Break;
        end;
        Inc(AFromIndex, -1 + 2 * Ord(AForward));
      end;
    end;

  var
    LMainControl: TControl;

  begin
    Result := nil;
    if FSelCtrls.Count > 0 then
    begin
      LMainControl := FSelCtrls.DefaultControl;
      if LMainControl.Owner = FRoot then
      begin
        Result := __DoFind(LMainControl.ComponentIndex + (-1 + 2 * Ord(AForward)
          ), (FRoot.ComponentCount - 1) * Ord(AForward), AForward);
        if not Assigned(Result) then
          Result := __DoFind((FRoot.ComponentCount - 1) * Ord(not AForward),
            LMainControl.ComponentIndex + (1 - 2 * Ord(AForward)), AForward);
      end;
    end;
  end;

var
  LDMCancelMessage: TMessage;
  LShiftState: TShiftState;
  LControl, LChousedControl: TControl;
  LdX, LdY: Integer;
  LControlOffset, LChousedControlOffset: Real;
  LDirection: TDirection;

begin
  case Message.Msg of
    WM_KEYDOWN, WM_SYSKEYDOWN:
      begin
        FDesigner.DoKeyDown(TWMKey((@Message)^));
        LShiftState := KeyDataToShiftState(TWMKeyDown(Message).KeyData);
        case TWMKeyDown(Message).CharCode of
          VK_ESCAPE:
            if FIsInDrawMode then
            begin
              LDMCancelMessage.Msg := DESIGNER_CANCEL;
              MouseMessage(FForm, LDMCancelMessage);
            end
            else
            begin
              LControl := nil;
              if (FSelCtrls.DefaultControl <> nil) and
                (FSelCtrls.DefaultControl.Parent <> nil) then
                LControl := GetDesignControl(FSelCtrls.DefaultControl.Parent);
              if not Assigned(LControl) then
                LControl := FRoot;
              FSelCtrls.ClearExcept(LControl);
            end;
          VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN:
            if (FSelCtrls.Count > 0) and not FIsInDrawMode then
            begin
              if ((ssShift in LShiftState) or (ssCtrl in LShiftState)) then
              begin
                if FSelCtrls.DefaultControl <> FRoot then
                begin
                  FSelCtrls.BeginUpdate;
                  try
                    FSelCtrls.ClearNotChildrensOf
                      (FSelCtrls.DefaultControl.Parent);
                    if ssShift in LShiftState then
                    begin
                      for var I := FSelCtrls.Count - 1 downto 0 do
                        if lmNoResize in GetLockMode(FSelCtrls[I]) then
                          FSelCtrls.Delete(I);
                    end
                    else
                      for var I := FSelCtrls.Count - 1 downto 0 do
                        if lmNoMove in GetLockMode(FSelCtrls[I]) then
                          FSelCtrls.Delete(I);
                  finally
                    FSelCtrls.EndUpdate;
                  end;
                  if FSelCtrls.Count > 0 then
                  begin
                    LdX := 0;
                    LdY := 0;
                    case TWMKeyDown(Message).CharCode of
                      VK_LEFT:
                        LdX := -1;
                      VK_UP:
                        LdY := -1;
                      VK_RIGHT:
                        LdX := 1;
                      VK_DOWN:
                        LdY := 1;
                    end;
                    if (LdX <> 0) or (LdY <> 0) then
                    begin
                      if ssShift in LShiftState then
                      begin
                        for var I := 0 to FSelCtrls.Count - 1 do
                          with FSelCtrls[I] do
                            SetBounds(Left, Top, Max(Width + LdX, 0),
                              Max(Height + LdY, 0));
                      end
                      else
                        for var I := 0 to FSelCtrls.Count - 1 do
                          with FSelCtrls[I] do
                            SetBounds(Left + LdX, Top + LdY, Width, Height);
                      Modified;
                    end;
                  end;
                end;
              end
              else if (LShiftState = []) then
              begin
                if FSelCtrls.DefaultControl <> FRoot then
                begin
                  case TWMKeyDown(Message).CharCode of
                    VK_LEFT:
                      LDirection := dLeft;
                    VK_UP:
                      LDirection := dUp;
                    VK_RIGHT:
                      LDirection := dRight;
                    VK_DOWN:
                      LDirection := dDown;
                  else
                    LDirection := dNone;
                  end;
                  LChousedControl := nil;
                  LChousedControlOffset := 1.7E+308; // MaxReal
                  for var I := 0 to FSelCtrls.DefaultControl.Parent.
                    ControlCount - 1 do
                  begin
                    LControl := FSelCtrls.DefaultControl.Parent.Controls[I];
                    if (LControl <> FSelCtrls.DefaultControl) and
                      IsDesignControl(LControl) then
                    begin
                      LControlOffset :=
                        _CalcDistance(FSelCtrls.DefaultControl.BoundsRect,
                        LControl.BoundsRect, LDirection);
                      if (LControlOffset >= 0) and
                        (LChousedControlOffset > LControlOffset) then
                      begin
                        LChousedControl := LControl;
                        LChousedControlOffset := LControlOffset;
                      end;
                    end;
                  end;
                  if Assigned(LChousedControl) then
                    FSelCtrls.ClearExcept(LChousedControl);
                end;
              end;
            end;
          VK_TAB:
            if not FIsInDrawMode then
            begin
              LChousedControl := _FindNearControl(not(ssShift in LShiftState));
              if Assigned(LChousedControl) then
                FSelCtrls.ClearExcept(LChousedControl);
            end;
          VK_DELETE:
            DeleteSelectedControls;
        end;
      end;
    WM_KEYUP, WM_SYSKEYUP:
      FDesigner.DoKeyUp(TWMKey((@Message)^));
    WM_CHAR:
      FDesigner.DoKeyPress(TWMKey((@Message)^));
  end;
  Result := True;
end;

procedure TDEng.RecursionRefresh(AWinControl: TWinControl);
begin
  AWinControl.Refresh;
  for var I := 0 to AWinControl.ControlCount - 1 do
    if AWinControl.Controls[I] is TWinControl then
      RecursionRefresh(TWinControl(AWinControl.Controls[I]));
end;

procedure TDEng.DeleteSelectedControls;
var
  LLockedIndex: Integer;
begin
  if ((FSelCtrls.Count = 1) and (FSelCtrls[0] <> FRoot)) or (FSelCtrls.Count > 1)
  then
  begin
    FSelCtrls.BeginUpdate;
    try
      LLockedIndex := -1;
      for var I := 0 to FSelCtrls.Count - 1 do
        if (FSelCtrls[I] <> FRoot) and
          (lmNoDelete in GetFullLockMode(FSelCtrls[I])) then
          if LLockedIndex = -1 then
            LLockedIndex := I
          else
            LLockedIndex := -2;
      if LLockedIndex = -1 then
      begin
        FDesigner.ControlDeleting(FSelCtrls);
        var
        Int := FSelCtrls.Count - 1;
        while True do
        begin
          if Int > FSelCtrls.Count - 1 then
            Int := FSelCtrls.Count - 1;
          if Int < 0 then
            Break;
          if FSelCtrls[Int] <> FRoot then
            FreeAndNil(FSelCtrls[Int]);
          Dec(Int);
        end;
      end
      else if LLockedIndex = -2 then
        raise EELDesigner.Create(SELDsgnrControlsLockedDel);
    finally
      FSelCtrls.EndUpdate;
    end;
    Modified;
  end;
end;

function TDEng.InsertControlProc(ACanvas: TDEngCanvas; AOldDataPtr: Pointer;
  const AVirtCursorPos: TPoint; AFlag: TDEngDrawProcFlag): Pointer;

type
  PDataRec = ^TDataRec;

  TDataRec = record
    StartClientCursorPos: TPoint;
    Offset: TPoint;
    Drawn: Boolean;
  end;

  function _InitData: PDataRec;
  begin
    New(Result);
    Result.StartClientCursorPos := ACanvas.ScreenToClient(AVirtCursorPos);
    Result.Offset := Point(0, 0);
    Result.Drawn := False;
  end;

  procedure _DisposeData(AData: PDataRec);
  begin
    Dispose(AData);
  end;

  procedure _DoXORDraw(ARect: TRect);
  begin
    DrawControlRect(ARect, ACanvas);
  end;

  function _CalcDrawRect(AData: PDataRec): TRect;
  begin
    Result := RectFromPoints(AData.StartClientCursorPos,
      Point(AData.StartClientCursorPos.X + AData.Offset.X,
      AData.StartClientCursorPos.Y + AData.Offset.Y));
    Inc(Result.Right);
    Inc(Result.Bottom);
  end;

  procedure _ShowHint(Rect: TRect);
  begin
    if htInsert in FDesigner.ShowingHints then
    begin
      if Assigned(FHintControl) then
        FHint.Caption :=
          IntToStr(FHintControl.PPIUnScale(Rect.Right - Rect.Left)) + ' X ' +
          IntToStr(FHintControl.PPIUnScale(Rect.Bottom - Rect.Top))
      else
        FHint.Caption := IntToStr(Rect.Right - Rect.Left) + ' X ' +
          IntToStr(Rect.Bottom - Rect.Top);
      FHint.Show(False, False, False, nil);
    end;
  end;

  procedure _FillData(ADataRec: PDataRec);
  var
    Point: TPoint;
  begin
    Point := ACanvas.ScreenToClient(AVirtCursorPos);
    Point.X := Point.X - ADataRec.StartClientCursorPos.X;
    Point.Y := Point.Y - ADataRec.StartClientCursorPos.Y;
    ADataRec.Offset.X := Point.X;
    ADataRec.Offset.Y := Point.Y;
  end;

var
  LDrawRect: TRect;
  LDataRec: TDataRec;
  LInsertingControl: TControl;

begin
  Result := nil;
  case AFlag of
    pfInitAndDraw:
      begin
        Result := _InitData;
        _FillData(Result);
        LDrawRect := _CalcDrawRect(Result);
      end;
    pfMove:
      begin
        LDataRec := PDataRec(AOldDataPtr)^;
        _FillData(@LDataRec);
        LDrawRect := _CalcDrawRect(@LDataRec);
        FHint.Hide;
        if PDataRec(AOldDataPtr)^.Drawn then
          _DoXORDraw(_CalcDrawRect(AOldDataPtr));
        _DoXORDraw(LDrawRect);
        _ShowHint(LDrawRect);
        LDataRec.Drawn := True;
        PDataRec(AOldDataPtr)^ := LDataRec;
        Result := AOldDataPtr;
      end;
    pfOkRemoveAndDispose:
      try
        LDrawRect := _CalcDrawRect(AOldDataPtr);
        FHint.Hide;
        if PDataRec(AOldDataPtr)^.Drawn then
          _DoXORDraw(LDrawRect);
        LInsertingControl := FInsertingControlClass.Create(FRoot);
        try
          with LInsertingControl do
          begin
            Name := UniqueName(Tag2PythonType(Tag));
            Parent := FCanvas.WinControl; // <-- Here may be exception
            with LDrawRect do
              if (Right - Left > 1) or (Bottom - Top > 1) then
                SetBounds(Left, Top, Right - Left, Bottom - Top)
              else
                SetBounds(Left, Top, LInsertingControl.Width,
                  LInsertingControl.Height);
          end;
        except
          FreeAndNil(LInsertingControl);
          raise;
        end;
        FSelCtrls.ClearExcept(LInsertingControl);
        FDesigner.ControlInserted;
        Modified;
      finally
        _DisposeData(AOldDataPtr);
      end;
    ddpfCancelRemoveAndDispose:
      try
        FHint.Hide;
        if PDataRec(AOldDataPtr)^.Drawn then
          _DoXORDraw(_CalcDrawRect(AOldDataPtr));
      finally
        _DisposeData(AOldDataPtr);
      end;
  end;
end;

constructor TELDesignerGrid.Create(AOwnerDesigner: TELCustomDesigner);
begin
  FDesigner := AOwnerDesigner;
  FXStep := 8;
  FYStep := 8;
  FVisible := True;
  FColor := clBlack;
end;

procedure TELDesignerGrid.Assign(Source: TPersistent);
begin
  FVisible := TELDesignerGrid(Source).FVisible;
  FYStep := TELDesignerGrid(Source).FYStep;
  FXStep := TELDesignerGrid(Source).FXStep;
  FColor := TELDesignerGrid(Source).FColor;
end;

procedure TELDesignerGrid.SetColor(const Value: TColor);
begin
  if FColor = Value then
    Exit;
  FColor := Value;
  FDesigner.GridParamsChanged;
end;

procedure TELDesignerGrid.SetVisible(const Value: Boolean);
begin
  if Value = FVisible then
    Exit;
  FVisible := Value;
  FDesigner.GridParamsChanged;
end;

procedure TELDesignerGrid.SetXStep(const Value: TELDesignerGridSize);
begin
  if Value = FXStep then
    Exit;
  if Value < 2 then
    FXStep := 2
  else if Value > 32 then
    FXStep := 32
  else
    FXStep := Value;
  FDesigner.GridParamsChanged;
end;

procedure TELDesignerGrid.SetYStep(const Value: TELDesignerGridSize);
begin
  if Value = FYStep then
    Exit;
  if Value < 2 then
    FYStep := 2
  else if Value > 32 then
    FYStep := 32
  else
    FYStep := Value;
  FDesigner.GridParamsChanged;
end;

function TDEng.GetRootVisible: Boolean;
begin
  Result := IsWindowVisible(FRoot.Handle);
end;

procedure TDEng.SetRootVisible(const Value: Boolean);
begin
  ShowWindow(FRoot.Handle, (SW_SHOW * Ord(Value)) or
    (SW_HIDE * Ord(not Value)));
end;

procedure TDEng.SelectAll;

  procedure _SelectChildControls(AControl: TWinControl);
  begin
    if IsDesignControl(AControl) then
    begin
      FSelCtrls.Add(AControl);
      for var I := 0 to AControl.ControlCount - 1 do
        if AControl.Controls[I] is TWinControl then
          _SelectChildControls(TWinControl(AControl.Controls[I]))
        else if IsDesignControl(AControl.Controls[I]) then
          FSelCtrls.Add(AControl.Controls[I]);
    end;
  end;

begin
  FSelCtrls.BeginUpdate;
  try
    _SelectChildControls(FRoot);
  finally
    FSelCtrls.EndUpdate;
  end;
end;

procedure TDEng.AlignToGrid(AControl: TControl);
var
  LNewLeft, LNewTop: Integer;
begin
  if (AControl <> FRoot) and IsDesignControl(AControl) then
  begin
    LNewLeft := Round(AControl.Left / FGrid.XStep) * FGrid.XStep;
    LNewTop := Round(AControl.Top / FGrid.YStep) * FGrid.YStep;
    AControl.SetBounds(LNewLeft, LNewTop, AControl.Width, AControl.Height);
    Modified;
  end;
end;

function TDEng.FindContainer(ASender: TControl): TWinControl;
begin
  Result := nil;
  while Assigned(ASender) do
  begin
    if (ASender is TWinControl) and (csAcceptsControls in ASender.ControlStyle)
    then
    begin
      Result := TWinControl(ASender);
      Break;
    end;
    ASender := ASender.Parent;
  end;
end;

function TDEng.GetDesignControl(AControl: TControl): TControl;
begin
  Result := nil;
  while Assigned(AControl) do
  begin
    if IsDesignControl(AControl) then
    begin
      Result := AControl;
      Break;
    end;
    AControl := AControl.Parent;
  end;
end;

function TDEng.IsDesignControl(AControl: TControl): Boolean;
begin
  Result := (AControl = FRoot) or ((csDesigning in AControl.ComponentState) and
    (AControl.Owner = FRoot));
end;

class function TDEng.GetLockMode(AControl: TControl): TELDesignerLockMode;
var
  LIntLockMode: Integer;
begin
  LIntLockMode := AControl.DesignInfo;
  Result := PELDesignerLockMode(@LIntLockMode)^;
end;

procedure TDEng.LockControl(AControl: TControl; ALockMode: TELDesignerLockMode);
var
  LIntLockMode: Integer;
begin
  if IsDesignControl(AControl) and (AControl <> FRoot) then
  begin
    PELDesignerLockMode(@LIntLockMode)^ := ALockMode;
    AControl.DesignInfo := LIntLockMode;
    FSelCtrls.Update;
  end;
end;

class function TDEng.GetFullLockMode(AControl: TControl): TELDesignerLockMode;
begin
  Result := GetLockMode(AControl);
  if AControl is TWinControl then
    for var I := 0 to TWinControl(AControl).ControlCount - 1 do
      Result := Result + GetLockMode(TWinControl(AControl).Controls[I]);
end;

procedure TDEng.LoadControlsFromStream(AStream: TStream; AParent: TWinControl);
var
  Reader: TReader;
begin
  FSelCtrls.BeginUpdate;
  try
    FSelCtrls.Clear;
    FReaderNames := TDEngNames.Create;
    try
      Reader := TReader.Create(AStream, 1024);
      try
        Reader.OnSetName := ReaderSetName;
        Reader.OnReferenceName := ReaderReferenceName;
        Reader.ReadComponents(FRoot, AParent, ReaderReadComponent);
      finally
        FreeAndNil(Reader);
      end;
    finally
      FreeAndNil(FReaderNames);
    end;
  finally
    FSelCtrls.EndUpdate;
  end;
end;

procedure TDEng.SaveControlsToStream(AStream: TStream; AControls: TList);
var
  Writer: TWriter;
begin
  Writer := TWriter.Create(AStream, 1024);
  try
    Writer.Root := FRoot;
    for var I := 0 to AControls.Count - 1 do
      if not(lmNoCopy in GetFullLockMode(AControls[I])) then
      begin
        Writer.WriteSignature;
        Writer.WriteComponent(AControls[I]);
      end;
    Writer.WriteListEnd;
  finally
    FreeAndNil(Writer);
  end;
end;

procedure TDEng.ReaderSetName(Reader: TReader; Component: TComponent;
  var Name: string);
var
  LOldName: string;
begin
  if not IsUniqueName(Name) then
  begin
    LOldName := Name;
    Name := UniqueName(LOldName);
    FReaderNames.Add(LOldName, Name);
  end;
end;

procedure TDEng.ReaderReadComponent(Component: TComponent);

  function _ControlExist(AParent: TWinControl; ALeft, ATop: Integer): Boolean;
  begin
    Result := False;
    for var I := 0 to AParent.ControlCount - 1 do
      if AParent.Controls[I] <> Component then
        with AParent.Controls[I] do
          if (Left = ALeft) and (Top = ATop) then
          begin
            Result := True;
            Break;
          end;
  end;

var
  LNewLeft, LNewTop: Integer;

begin
  if (Component is TControl) and IsDesignControl(TControl(Component)) then
    with TControl(Component) do
    begin
      if Parent <> nil then
      begin
        LNewLeft := Left;
        LNewTop := Top;
        while _ControlExist(Parent, LNewLeft, LNewTop) do
        begin
          Inc(LNewLeft, FGrid.XStep);
          Inc(LNewTop, FGrid.YStep);
        end;
        SetBounds(LNewLeft, LNewTop, Width, Height);
      end;
      FSelCtrls.Add(TControl(Component));
    end;
end;

procedure TDEng.ReaderReferenceName(Reader: TReader; var Name: string);
var
  Int: Integer;
begin
  Int := FReaderNames.IndexOf(Name);
  if Int <> -1 then
    Name := FReaderNames.DestName(Int);
end;

function TDEng._AddRef: Integer;
begin
  Result := -1;
end;

function TDEng._Release: Integer;
begin
  Result := -1;
end;

constructor TDPForm.Create(AOwner: TComponent);
begin
  CreateNew(AOwner);
  // Screen.RemoveForm(Self); ???
end;

procedure TDPForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := Style and not(WS_POPUP or WS_CAPTION or WS_THICKFRAME or
      WS_MINIMIZEBOX or WS_MAXIMIZEBOX or WS_SYSMENU) or
      (WS_CHILD or WS_GROUP or WS_TABSTOP);
    ExStyle := ExStyle and not(WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE or
      WS_EX_TOOLWINDOW);
  end;
end;

procedure TDPForm.CreateWnd;
begin
  inherited;
  if FDesignPanel.IsUsed then
    TDEng(FDesignPanel.FEng).FSelCtrls.Update;
end;

procedure TDPForm.WndProc(var Message: TMessage);
begin
  if Message.Msg in [WM_MOUSEACTIVATE, WM_ACTIVATE] then
  begin
    if (GetParentForm(FDesignPanel) = nil) or GetParentForm(FDesignPanel)
      .SetFocusedControl(FDesignPanel) then
    begin
      Dispatch(Message);
      Windows.SetFocus(Handle);
    end;
    Exit;
  end;
  inherited;
end;

procedure TELCustomDesignPanel.CMBiDiModeChanged(var Message: TMessage);
begin
  inherited;
  FForm.BiDiMode := BiDiMode;
end;

procedure TELCustomDesignPanel.CMColorChanged(var Message: TMessage);
begin
  inherited;
  FForm.Color := Color;
end;

procedure TELCustomDesignPanel.CMCursorChanged(var Message: TMessage);
begin
  inherited;
  FForm.Cursor := Cursor;
end;

procedure TELCustomDesignPanel.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FForm.Font := Font;
end;

procedure TELCustomDesignPanel.CMParentBiDiModeChanged(var Message: TMessage);
begin
  inherited;
  TDPForm(FForm).ParentBiDiMode := ParentBiDiMode;
end;

procedure TELCustomDesignPanel.CMParentColorChanged(var Message: TMessage);
begin
  inherited;
  TDPForm(FForm).ParentColor := ParentColor;
end;

procedure TELCustomDesignPanel.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  TDPForm(FForm).ParentFont := ParentFont;
end;

procedure TELCustomDesignPanel.CMParentShowHintChanged(var Message: TMessage);
begin
  inherited;
  TDPForm(FForm).ParentShowHint := ParentShowHint;
end;

constructor TELCustomDesignPanel.Create(AOwner: TComponent);
begin
  inherited;
  TabStop := True;
  Width := 185;
  Height := 41;
  FBorderStyle := bsSingle;
  FForm := TDPForm.Create(nil);
  TDPForm(FForm).FDesignPanel := Self;
  FForm.Visible := True;
end;

procedure TELCustomDesignPanel.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array [TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited;
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
    WindowClass.Style := WindowClass.Style and not(CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TELCustomDesignPanel.CreateWnd;
begin
  inherited;
  UpdateFormBounds;
  UpdateFormParentWindow;
  if FForm.ParentWindow <> 0 then
    ShowWindow(FForm.Handle, SW_SHOW);
end;

destructor TELCustomDesignPanel.Destroy;
begin
  inherited;
  FreeAndNil(FForm);
end;

function TELCustomDesignPanel.GetAutoScroll: Boolean;
begin
  Result := TDPForm(FForm).AutoScroll;
end;

function TELCustomDesignPanel.GetHorzScrollBar: TControlScrollBar;
begin
  Result := FForm.HorzScrollBar;
end;

function TELCustomDesignPanel.GetIsUsed: Boolean;
begin
  Result := Assigned(FEng);
end;

function TELCustomDesignPanel.GetPopupMenu: TPopupMenu;
begin
  Result := inherited GetPopupMenu;
  if IsUsed then
    Result := nil;
end;

function TELCustomDesignPanel.GetVertScrollBar: TControlScrollBar;
begin
  Result := FForm.VertScrollBar;
end;

procedure TELCustomDesignPanel.SetAutoScroll(const Value: Boolean);
begin
  TDPForm(FForm).AutoScroll := Value;
end;

procedure TELCustomDesignPanel.SetBorderStyle(const Value: TBorderStyle);
begin
  if (Value <> FBorderStyle) and (Value in [bsSingle, bsNone]) then
  begin
    FBorderStyle := Value;
    RecreateWnd;
    UpdateFormBounds;
  end;
end;

procedure TELCustomDesignPanel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  UpdateFormBounds;
end;

procedure TELCustomDesignPanel.SetEng(AEng: Pointer);
begin
  FEng := AEng;
  UpdateFormParentWindow;
end;

procedure TELCustomDesignPanel.SetHorzScrollBar(const Value: TControlScrollBar);
begin
  FForm.HorzScrollBar := Value;
end;

procedure TELCustomDesignPanel.SetVertScrollBar(const Value: TControlScrollBar);
begin
  FForm.VertScrollBar := Value;
end;

procedure TELCustomDesignPanel.UpdateFormBounds;
var
  Rect: TRect;
begin
  if HandleAllocated then
  begin
    Rect := ClientRect;
    FForm.SetBounds(Rect.Left, Rect.Top, Rect.Right - Rect.Left,
      Rect.Bottom - Rect.Top);
  end;
end;

procedure TELCustomDesignPanel.UpdateFormParentWindow;
begin
  if IsUsed and HandleAllocated then
    FForm.ParentWindow := Handle
  else
    FForm.ParentWindow := 0;
end;

procedure TELCustomDesignPanel.WMSetFocus(var Msg: TWMSetFocus);
begin
  if Assigned(FForm) and FForm.HandleAllocated and (FForm.ParentWindow <> 0)
  then
    Windows.SetFocus(FForm.Handle);
end;

procedure TDEngHint.CheckHideMessageProc(AHandle: Integer;
  const Message: TMessage);
var
  LMsg: TMsg;
begin
  if DHintWindowShower = Self then
  begin
    LMsg.hwnd := AHandle;
    LMsg.Message := Message.Msg;
    LMsg.WParam := Message.WParam;
    LMsg.LPARAM := Message.LPARAM;
    if DHintWindow.IsHintMsg(LMsg) then
      Hide;
  end;
end;

constructor TDEngHint.Create;
begin
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.OnTimer := FTimerOnTimer;
  if not Assigned(DHintWindow) then
  begin
    DHintWindow := TESHintWindow.Create(nil);
    HookDesignerHintHooks;
  end;
  Inc(DHintWindowRefCount);
end;

destructor TDEngHint.Destroy;
begin
  Hide;
  FreeAndNil(FTimer);
  Dec(DHintWindowRefCount);
  if DHintWindowRefCount = 0 then
  begin
    FreeAndNil(DHintWindow);
    UnhookDesignerHintHooks;
  end;
  if DHintWindowShower = Self then
    DHintWindowShower := nil;
  inherited;
end;

procedure TDEngHint.DoShowNoPause;

{ From Forms unit }
  function GetCursorHeightMargin: Integer;
  var
    IconInfo: TIconInfo;
    BitmapInfoSize, BitmapBitsSize, ImageSize: DWORD;
    Bitmap: PBitmapInfoHeader;
    Bits: Pointer;
    BytesPerScanline: Integer;

    function FindScanline(Source: Pointer; MaxLen: Cardinal; Value: Cardinal)
      : Cardinal;
    var
      PSource: PByte;
    begin
      PSource := Source;
      Result := MaxLen;
      while (Result > 0) and (PSource^ = Value) do
      begin
        Inc(PSource);
        Dec(Result);
      end;
    end;

  begin
    { Default value is entire icon height }
    Result := GetSystemMetrics(SM_CYCURSOR);
    if GetIconInfo(GetCursor, IconInfo) then
      try
        GetDIBSizes(IconInfo.hbmMask, BitmapInfoSize, BitmapBitsSize);
        Bitmap := AllocMem(DWORD(BitmapInfoSize) + BitmapBitsSize);
        try
          Bits := Pointer(DWORD(Bitmap) + BitmapInfoSize);
          if GetDIB(IconInfo.hbmMask, 0, Bitmap^, Bits^) and
            (Bitmap^.biBitCount = 1) then
          begin
            { Point Bits to the end of this bottom-up bitmap }
            with Bitmap^ do
            begin
              BytesPerScanline := ((biWidth * biBitCount + 31) and
                not 31) div 8;
              ImageSize := biWidth * BytesPerScanline;
              Bits := Pointer(DWORD(Bits) + BitmapBitsSize - ImageSize);
              { Use the width to determine the height since another mask bitmap
                may immediately follow }
              Result := FindScanline(Bits, ImageSize, $FF);
              { In case the and mask is blank, look for an empty scanline in the
                xor mask. }
              if (Result = 0) and (biHeight >= 2 * biWidth) then
                Result := FindScanline(Pointer(DWORD(Bits) - ImageSize),
                  ImageSize, $00);
              Result := Result div BytesPerScanline;
            end;
            Dec(Result, IconInfo.yHotSpot);
          end;
        finally
          FreeMem(Bitmap, BitmapInfoSize + BitmapBitsSize);
        end;
      finally
        if IconInfo.hbmColor <> 0 then
          DeleteObject(IconInfo.hbmColor);
        if IconInfo.hbmMask <> 0 then
          DeleteObject(IconInfo.hbmMask);
      end;
  end;

var
  Point: TPoint;
  Rect: TRect;

begin
  GetCursorPos(Point);
  if Assigned(FCheckControl) and (FindDragTarget(Point, True) <> FCheckControl)
  then
    Hide
  else
  begin
    FTimer.Enabled := False;
    DHintWindow.Color := Application.HintColor;
    DHintWindow.Font := Screen.HintFont;
    Rect := DHintWindow.CalcHintRect(Screen.Width, Caption, nil);
    OffsetRect(Rect, Point.X, Point.Y + GetCursorHeightMargin);
    DHintWindow.ActivateHint(Rect, Caption);
    DHintWindow.Update;
    DHintWindowShower := Self;
    if FNeedStartHideTimer then
    begin
      FTimer.Interval := Application.HintHidePause;
      FTimerMode := tmHide;
      FTimer.Enabled := True;
    end;
    FActive := True;
  end;
end;

procedure TDEngHint.Hide;
begin
  FTimer.Enabled := False;
  if DHintWindowShower = Self then
  begin
    ShowWindow(DHintWindow.Handle, SW_HIDE);
    DHintWindowShower := nil;
  end;
  FActive := False;
end;

procedure TDEngHint.Show(APauseBeforeShow, AHideAfterPause, AUseHooks: Boolean;
  ACheckControl: TControl);
begin
  FNeedStartHideTimer := AHideAfterPause;
  FCheckControl := ACheckControl;
  FUseHooks := AUseHooks;
  if APauseBeforeShow then
  begin
    FTimer.Interval := Application.HintPause;
    FTimerMode := tmShow;
    FTimer.Enabled := True;
  end
  else
    DoShowNoPause;
end;

procedure TDEngHint.FTimerOnTimer(Sender: TObject);
begin
  case FTimerMode of
    tmShow:
      DoShowNoPause;
    tmHide:
      Hide;
  end;
end;

constructor TDSelCtrlItemPoint.Create(AOwnerSelCtrl: TDSelCtrlItem;
  APos: TDSelCtrlItemPointPos);
const
  HANDLESIZE = 5;
begin
  inherited Create(nil);
  FSelCtrl := AOwnerSelCtrl;
  FPos := APos;
  FHandleSize := Round(AOwnerSelCtrl.FControl.ScaleFactor * HANDLESIZE);
  Width := FHandleSize;
  Height := FHandleSize;
  Visible := False;
  Update;
end;

procedure TDSelCtrlItemPoint.Paint;
begin
  Canvas.Pen.Color := FBorderColor;
  Canvas.Brush.Color := Color;
  Canvas.Rectangle(0, 0, Width, Height);
end;

procedure TDSelCtrlItemPoint.Update;

const
  HANDLECURSORS: array [TDSelCtrlItemPointPos] of TCursor = (crSizeNWSE,
    crSizeNS, crSizeNESW, crSizeWE, crSizeNWSE, crSizeNS, crSizeNESW, crSizeWE);

var
  LLockMode: TELDesignerLockMode;
  LDesigner: TELCustomDesigner;

begin
  if (FSelCtrl.Control.Parent <> nil) and FSelCtrl.Control.Parent.HandleAllocated
  then
    ParentWindow := FSelCtrl.Control.Parent.Handle
  else
    ParentWindow := 0;
  if ParentWindow = 0 then
    Exit;
  case FPos of
    ppTopLeft, ppTop, ppTopRight:
      if FSelCtrl.Mode = imSizeable then
        Top := FSelCtrl.Control.Top - FHandleSize div 2
      else
        Top := FSelCtrl.Control.Top - FHandleSize;
    ppRight, ppLeft:
      Top := FSelCtrl.Control.Top + FSelCtrl.Control.Height div 2 -
        FHandleSize div 2;
    ppBottomRight, ppBottom, ppBottomLeft:
      if FSelCtrl.Mode = imSizeable then
        Top := FSelCtrl.Control.Top + FSelCtrl.Control.Height -
          FHandleSize div 2
      else
        Top := FSelCtrl.Control.Top + FSelCtrl.Control.Height;
  end;
  case FPos of
    ppTopLeft, ppLeft, ppBottomLeft:
      if FSelCtrl.Mode = imSizeable then
        Left := FSelCtrl.Control.Left - FHandleSize div 2
      else
        Left := FSelCtrl.Control.Left - FHandleSize;
    ppTop, ppBottom:
      Left := FSelCtrl.Control.Left + FSelCtrl.Control.Width div 2 -
        FHandleSize div 2;
    ppTopRight, ppRight, ppBottomRight:
      if FSelCtrl.Mode = imSizeable then
        Left := FSelCtrl.Control.Left + FSelCtrl.Control.Width -
          FHandleSize div 2
      else
        Left := FSelCtrl.Control.Left + FSelCtrl.Control.Width;
  end;
  LDesigner := FSelCtrl.FSelCtrls.FDesigner;
  LLockMode := TDEng.GetLockMode(FSelCtrl.Control);
  if FSelCtrl.FSelCtrls.FActive then
  begin
    if FSelCtrl.Mode = imSizeable then
    begin
      FBorderColor := LDesigner.HandleBorderClr;
      Color := LDesigner.HandleClr;
    end
    else
    begin
      FBorderColor := LDesigner.MultySelectHandleBorderClr;
      Color := LDesigner.MultySelectHandleClr;
    end;
    if lmNoMove in LLockMode then
      Color := LDesigner.LockedHandleClr;
    if lmNoResize in LLockMode then
      FBorderColor := LDesigner.LockedHandleClr;
  end
  else
  begin
    if FSelCtrl.Mode = imSizeable then
    begin
      FBorderColor := LDesigner.InactiveHandleBorderClr;
      Color := LDesigner.InactiveHandleClr;
    end
    else
    begin
      FBorderColor := LDesigner.MultySelectHandleBorderClr;
      Color := LDesigner.MultySelectHandleClr;
    end;
  end;

  Visible := (FSelCtrl.Mode = imSizeable) or
    ((FPos in [ppTopLeft, ppTopRight, ppBottomRight, ppBottomLeft]) and
    (FSelCtrl.Mode = imMultySelect));
  BringToFront;
  if (FSelCtrl.Mode = imSizeable) and not(lmNoResize in LLockMode) then
    Cursor := HANDLECURSORS[FPos]
  else
    Cursor := crDefault;
  Invalidate;
end;

constructor TDSelCtrlItem.Create(AOwnerSelCtrls: TELDesignerSelectedControls;
  AControl: TControl);
begin
  FSelCtrls := AOwnerSelCtrls;
  FControl := AControl;
  for var I := ppTopLeft to ppLeft do
    FPoints[I] := TDSelCtrlItemPoint.Create(Self, I);
  AControl.FreeNotification(FSelCtrls.FDesigner);
  FSelCtrls.AddItem(Self);
end;

destructor TDSelCtrlItem.Destroy;
begin
  Control.RemoveFreeNotification(FSelCtrls.FDesigner);
  var
  Int := FSelCtrls.IndexOfByItem(Self);
  if Int <> -1 then
    FSelCtrls.DeleteItem(Int);
  for var I := ppTopLeft to ppLeft do
    FreeAndNil(FPoints[I]);
  inherited;
end;

procedure TDSelCtrlItem.SetMode(const Value: TDSelCtrlItemMode);
begin
  if FMode = Value then
    Exit;
  FMode := Value;
  Update;
  Control.Invalidate; // added due to invalid ellipse resizing
end;

procedure TDSelCtrlItem.Update;
begin
  for var I := ppTopLeft to ppLeft do
    FPoints[I].Update;
end;

procedure TELDesignerSelectedControls.UpdateMode;

  procedure _SetHandlesMode(Value: TDSelCtrlItemMode);
  begin
    for var I := 0 to Count - 1 do
      if TDSelCtrlItem(FItems[I]).Control <> FRootWinControl then
        TDSelCtrlItem(FItems[I]).SetMode(Value)
      else
        TDSelCtrlItem(FItems[I]).SetMode(imNone);
  end;

begin
  if FVisible then
  begin
    if Count = 1 then
      _SetHandlesMode(imSizeable)
    else
      _SetHandlesMode(imMultySelect);
  end
  else
    _SetHandlesMode(imNone);
end;

procedure TELDesignerSelectedControls.AddItem(AItem: Pointer);
begin
  FItems.Add(AItem);
  if FVisible and (TDSelCtrlItem(AItem).Control.Parent <> nil) then
    TWinControlAccess(TDSelCtrlItem(AItem).Control.Parent)
      .ShowControl(TDSelCtrlItem(AItem).Control);
  Change;
end;

procedure TELDesignerSelectedControls.Update;
begin
  for var I := 0 to Count - 1 do
    TDSelCtrlItem(FItems[I]).Update;
end;

function TELDesignerSelectedControls.IndexOf(AControl: TControl): Integer;
begin
  Result := -1;
  for var I := 0 to Count - 1 do
    if TDSelCtrlItem(FItems[I]).Control = AControl then
    begin
      Result := I;
      Break;
    end;
end;

procedure TELDesignerSelectedControls.Clear;
begin
  ClearExcept(nil);
end;

procedure TELDesignerSelectedControls.SetActive(const Value: Boolean);
begin
  if FActive = Value then
    Exit;
  FActive := Value;
  Update;
end;

function TELDesignerSelectedControls.Add(AControl: TControl): Integer;
var
  Int: Integer;
begin
  FDesigner.CheckActive(True);
  Int := IndexOf(AControl);
  if Int = -1 then
  begin
    CheckDesignControl(AControl);
    TDSelCtrlItem.Create(Self, AControl);
    Result := Count - 1;
  end
  else
    Result := Int;
end;

constructor TELDesignerSelectedControls.Create(AOwnerDesigner
  : TELCustomDesigner);
begin
  FDesigner := AOwnerDesigner;
  FItems := TList.Create;
end;

procedure TELDesignerSelectedControls.Delete(AItem: Integer);
begin
  FreeAndNil(TObject(FItems[AItem]));
end;

procedure TELDesignerSelectedControls.DeleteItem(AItem: Integer);
begin
  FItems.Delete(AItem);
  Change;
end;

destructor TELDesignerSelectedControls.Destroy;
begin
  FDestroying := True;
  Clear;
  FreeAndNil(FItems);
  inherited;
end;

function TELDesignerSelectedControls.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TELDesignerSelectedControls.IndexOfByItem(AItem: Pointer): Integer;
begin
  Result := FItems.IndexOf(AItem);
end;

procedure TELDesignerSelectedControls.SetVisible(const Value: Boolean);
begin
  if FVisible = Value then
    Exit;
  FVisible := Value;
  UpdateMode;
end;

procedure TELDesignerSelectedControls.SetRootWinControl
  (const Value: TWinControl);
begin
  if FRootWinControl = Value then
    Exit;
  FRootWinControl := Value;
  UpdateMode;
end;

function TELDesignerSelectedControls.GetItems(I: Integer): TControl;
begin
  Result := TDSelCtrlItem(FItems[I]).Control;
end;

procedure TELDesignerSelectedControls.Remove(AControl: TControl);
var
  Int: Integer;
begin
  Int := IndexOf(AControl);
  if Int <> -1 then
    Delete(Int);
end;

procedure TELDesignerSelectedControls.ClearExcept(AControl: TControl);
begin
  if not FDestroying then
    FDesigner.CheckActive(True);
  BeginUpdate;
  try
    while (Count > 0) and (Items[0] <> AControl) do
      Delete(0);
    while Count > 1 do
      Delete(1);
    if Count = 0 then
    begin
      if Assigned(AControl) then
        Add(AControl);
    end
    else if FVisible and (AControl.Parent <> nil) then
      TWinControlAccess(AControl.Parent).ShowControl(AControl);
  finally
    EndUpdate;
  end;
end;

procedure TELDesignerSelectedControls.Change;
begin
  if FUpdateCount <= 0 then
  begin
    FChanged := False;
    if not FDestroying then
    begin
      UpdateMode;
      Update;
      FDesigner.ChangeSelection;
    end;
  end
  else
    FChanged := True;
end;

procedure TELDesignerSelectedControls.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TELDesignerSelectedControls.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount < 0 then
    FUpdateCount := 0;
  if (FUpdateCount = 0) and FChanged then
    Change;
end;

constructor TDEngCanvas.Create;
begin
  inherited Create;
  FHiddenControl := TWinControl.Create(nil);
end;

procedure TDEngCanvas.CreateHandle;
begin
  inherited;
  Handle := GetDCEx(FHiddenControl.Handle, 0, DCX_PARENTCLIP);
end;

destructor TDEngCanvas.Destroy;
begin
  FreeAndNil(FHiddenControl);
  inherited;
end;

function TDEngCanvas.ScreenToClient(const Point: TPoint): TPoint;
begin
  Result := FHiddenControl.ScreenToClient(Point);
end;

procedure TDEngCanvas.SetWinControl(const Value: TWinControl);
begin
  FWinControl := Value;
  if Assigned(Value) then
    FHiddenControl.ParentWindow := Value.Handle
  else
    FHiddenControl.ParentWindow := 0;
  Handle := 0;
end;

procedure TDSelCtrlItemPoint.WndProc(var Message: TMessage);
var
  LDMSng: TELDMSizing;
  LEng: TDEng;
{$IFDEF WIN64}
  AMsg: TMessage;
{$ENDIF}
begin
  inherited;
  if (Message.Msg = WM_LBUTTONDOWN) and (FSelCtrl.Mode = imSizeable) then
  begin
    LDMSng.Msg := DESIGNER_SIZING;
    LDMSng.MouseMessage := @Message;
    FSelCtrl.FActivePos := FPos;
    LEng := FSelCtrl.FSelCtrls.FDesigner.FEng;
{$IFDEF WIN32}
    LEng.IsDesignMsg(FSelCtrl.Control, TMessage(LDMSng));
{$ENDIF}
{$IFDEF WIN64}
    AMsg.Msg := LDMSng.Msg;
    AMsg.WParam := WParam(LDMSng.MouseMessage); // WPARAM instead of LongInt
    AMsg.LPARAM := LDMSng.Unused;
    AMsg.Result := LDMSng.Result;
    LEng.IsDesignMsg(FSelCtrl.Control, AMsg);
{$ENDIF}
  end;
end;

procedure TELCustomDesigner.ChangeSelection;
begin
  if Assigned(OnChangeSelection) then
    OnChangeSelection(Self);
end;

procedure TELCustomDesigner.CheckActive(AIsActiveNeeded: Boolean);
var
  Str: string;
begin
  if AIsActiveNeeded then
    Str := 'Designer must be active'
  else
    Str := 'Designer must be inactive';
  if Active <> AIsActiveNeeded then
    raise EELDesigner.Create(Str);
end;

procedure TELCustomDesigner.ControlHint(AControl: TControl; var AHint: string);
begin
  if Assigned(OnControlHint) then
    OnControlHint(Self, AControl, AHint);
end;

procedure TELCustomDesigner.ControlInserted;
begin
  if Assigned(OnControlInserted) then
    OnControlInserted(Self);
end;

procedure TELCustomDesigner.ControlInserting(var AControlClass: TControlClass);
begin
  if Assigned(OnControlInserting) then
    OnControlInserting(Self, AControlClass);
end;

procedure TELCustomDesigner.ControlDeleting(SelectedControls
  : TELDesignerSelectedControls);
begin
  if Assigned(OnControlDeleting) then
    OnControlDeleting(Self, SelectedControls);
end;

constructor TELCustomDesigner.Create(AOwner: TComponent);
begin
  inherited;
  FGrid := TELDesignerGrid.Create(Self);
  FSelectedControls := TELDesignerSelectedControls.Create(Self);
  FSnapToGrid := True;
  FShowingHints := [htControl, htSize, htMove, htInsert];
  FHandleClr := clBlack;
  FHandleBorderClr := clBlack;
  FMultySelectHandleClr := clGray;
  FMultySelectHandleBorderClr := clGray;
  FInactiveHandleClr := clGray;
  FInactiveHandleBorderClr := clBlack;
  FLockedHandleClr := clRed;
  FClipboardFormat := SELDsgnrClipboardFormat;
end;

destructor TELCustomDesigner.Destroy;
begin
  Active := False;
  FreeAndNil(FGrid);
  FreeAndNil(FSelectedControls);
  inherited;
end;

function TELCustomDesigner.GetDesignControlVisible: Boolean;
begin
  CheckActive(True);
  Result := TDEng(FEng).RootVisible;
end;

procedure TELCustomDesigner.GridParamsChanged;
begin
  if Active then
    TDEng(FEng).GridParamsChanged;
end;

procedure TELCustomDesigner.Modified;
begin
  CheckActive(True);
  SelectedControls.Update;
end;

procedure TELCustomDesigner.DeleteSelectedControls;
begin
  CheckActive(True);
  TDEng(FEng).DeleteSelectedControls;
end;

procedure TELCustomDesigner.SelectControl(const AName: string);
var
  I: Integer;
  AControl: TControl;
begin
  if not Assigned(DesignControl) then
    Exit;
  for I := 0 to DesignControl.ComponentCount - 1 do
    if (DesignControl.Components[I].Name = AName) and
      (DesignControl.Components[I] is TControl) then
    begin
      AControl := TControl(DesignControl.Components[I]);
      SelectedControls.Clear;
      SelectedControls.Add(AControl);
      Exit;
    end;
end;

procedure TELCustomDesigner.DoModified;
begin
  if Assigned(OnModified) then
    OnModified(Self);
end;

procedure TELCustomDesigner.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if not FActivating then
    begin
      if AComponent = DesignPanel then
      begin
        if DesignPanel.IsUsed then
          Active := False;
        ChangeDesignPanel(nil);
      end;
      if AComponent = DesignControl then
      begin
        Active := False;
        DesignControl := nil;
      end;
    end;
    if AComponent = PopupMenu then
      PopupMenu := nil;
    if AComponent is TControl then
      SelectedControls.Remove(TControl(AComponent));
  end;
end;

procedure TELCustomDesigner.DesignFormClose(var Action: TCloseAction);
begin
  if Assigned(OnDesignFormClose) then
    OnDesignFormClose(Self, Action);
end;

procedure TELCustomDesigner.SetActive(const Value: Boolean);
begin
  if FActive = Value then
    Exit;
  if Value then
  begin
    FActivating := True;
    try
      if DesignControl = nil then
        raise EELDesigner.Create('Design control not specified');
      if not(DesignControl is TCustomForm) then
      begin
        if DesignPanel = nil then
          raise EELDesigner.Create('No design panel specified');
        if DesignPanel.IsUsed then
          raise EELDesigner.CreateFmt('Design panel ''%S'' is' +
            ' used by another designer', [DesignPanel.Name]);
      end;
      FEng := TDEng.Create(Self, DesignControl, DesignPanel);
      TDEng(FEng).GuiDesignerHints := GuiDesignerHints;
      SelectedControls.SetRootWinControl(DesignControl);
    finally
      FActivating := False;
    end;
  end
  else
  begin
    FActivating := True;
    try
      SelectedControls.SetVisible(False);
      SelectedControls.Clear;
      SelectedControls.SetRootWinControl(nil);
      FreeAndNil(TObject(FEng));
      FEng := nil;
    finally
      FActivating := False;
    end;
  end;
  FActive := Value;
  if FActive then
  begin
    SelectedControls.Add(DesignControl);
    SelectedControls.SetVisible(True);
  end;
end;

procedure TELCustomDesigner.SetDesignControl(const Value: TWinControl);
begin
  CheckActive(False);
  if Assigned(FDesignControl) then
    FDesignControl.RemoveFreeNotification(Self);
  FDesignControl := Value;
  if Assigned(FDesignControl) then
    FDesignControl.FreeNotification(Self);
end;

procedure TELCustomDesigner.SetDesignPanel(const Value: TELCustomDesignPanel);
begin
  CheckActive(False);
  ChangeDesignPanel(Value);
end;

procedure TELCustomDesigner.SetDesignControlVisible(const Value: Boolean);
begin
  CheckActive(True);
  TDEng(FEng).RootVisible := Value;
end;

procedure TELCustomDesigner.ValidateName(const AName: string;
  var AIsValidName: Boolean);
begin
  if Assigned(OnValidateName) then
    OnValidateName(Self, AName, AIsValidName);
end;

procedure TELCustomDesigner.ChangeDesignPanel(const Value
  : TELCustomDesignPanel);
begin
  if Assigned(FDesignPanel) then
    FDesignPanel.RemoveFreeNotification(Self);
  FDesignPanel := Value;
  if Assigned(FDesignPanel) then
    FDesignPanel.FreeNotification(Self);
end;

procedure TELCustomDesigner.SetPopupMenu(const Value: TPopupMenu);
begin
  FPopupMenu := Value;
end;

procedure TELCustomDesigner.SetGrid(const Value: TELDesignerGrid);
begin
  FGrid.Assign(Value);
end;

procedure TELCustomDesigner.ContextPopup;
var
  LPt: TPoint;
  LHandled: Boolean;
  LPopupMenu: TPopupMenu;
begin
  GetCursorPos(LPt);
  LHandled := False;
  if Assigned(OnContextPopup) then
    OnContextPopup(Self, LPt, LHandled);
  if LHandled then
    Exit;
  LPopupMenu := GetPopupMenu;
  if Assigned(LPopupMenu) and LPopupMenu.AutoPopup then
  begin
    LPopupMenu.PopupComponent := Self;
    LPopupMenu.Popup(LPt.X, LPt.Y);
  end;
end;

function TELCustomDesigner.GetPopupMenu: TPopupMenu;
begin
  Result := FPopupMenu;
end;

procedure TELDesignerSelectedControls.SelectAll;
begin
  FDesigner.CheckActive(True);
  TDEng(FDesigner.FEng).SelectAll;
end;

procedure TELCustomDesigner.LockControl(AControl: TControl;
  ALockMode: TELDesignerLockMode);
begin
  CheckActive(True);
  TDEng(FEng).LockControl(AControl, ALockMode);
end;

function TELCustomDesigner.GetLockMode(AControl: TControl): TELDesignerLockMode;
begin
  if Active then
    Result := TDEng.GetLockMode(AControl)
  else
    Result := [];
end;

procedure TELCustomDesigner.SetHandleBorderClr(const Value: TColor);
begin
  FHandleBorderClr := Value;
  SelectedControls.Update;
end;

procedure TELCustomDesigner.SetHandleClr(const Value: TColor);
begin
  FHandleClr := Value;
  SelectedControls.Update;
end;

procedure TELCustomDesigner.SetInactiveHandleBorderClr(const Value: TColor);
begin
  FInactiveHandleBorderClr := Value;
  SelectedControls.Update;
end;

procedure TELCustomDesigner.SetInactiveHandleClr(const Value: TColor);
begin
  FInactiveHandleClr := Value;
  SelectedControls.Update;
end;

procedure TELCustomDesigner.SetLockedHandleClr(const Value: TColor);
begin
  FLockedHandleClr := Value;
  SelectedControls.Update;
end;

procedure TELCustomDesigner.SetMultySelectHandleBorderClr(const Value: TColor);
begin
  FMultySelectHandleBorderClr := Value;
  SelectedControls.Update;
end;

procedure TELCustomDesigner.SetMultySelectHandleClr(const Value: TColor);
begin
  FMultySelectHandleClr := Value;
  SelectedControls.Update;
end;

procedure TELDesignerSelectedControls.SelectControls(AControls: TList);
begin
  FDesigner.CheckActive(True);
  BeginUpdate;
  try
    for var I := Count - 1 downto 0 do
      if AControls.IndexOf(Items[I]) = -1 then
        Delete(I);
    for var I := 0 to AControls.Count - 1 do
      Add(AControls[I]);
  finally
    EndUpdate;
  end;
end;

procedure TELCustomDesigner.Copy;
var
  LMemHandle: THandle;
  LGlobalDataPtr: Pointer;
  LStream: TMemoryStream;
  LControls: TList;
begin
  if CanCopy then
  begin
    RegisterClipboardFormat;
    SelectedControls.ClearNotChildrensOf
      (SelectedControls.DefaultControl.Parent);
    if SelectedControls.Count > 0 then
    begin
      LStream := TMemoryStream.Create;
      try
        LControls := TList.Create;
        try
          SelectedControls.GetControls(LControls);
          TDEng(FEng).SaveControlsToStream(LStream, LControls);
        finally
          FreeAndNil(LControls);
        end;
        LMemHandle := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, LStream.Size);
        try
          LGlobalDataPtr := GlobalLock(LMemHandle);
          try
            Move(LStream.Memory^, LGlobalDataPtr^, LStream.Size);
          finally
            GlobalUnlock(LMemHandle);
          end;
        except
          GlobalFree(LMemHandle);
        end;
      finally
        FreeAndNil(LStream);
      end;
      Clipboard.SetAsHandle(FClipboardFormatWord, LMemHandle);
    end;
  end;
end;

procedure TELCustomDesigner.Cut;
begin
  if CanCut then
  begin
    Copy;
    DeleteSelectedControls;
  end;
end;

procedure TELCustomDesigner.Paste;
var
  LMemHandle: THandle;
  LGlobalDataPtr: Pointer;
  LStream: TMemoryStream;
  LLocalDataPtr: Pointer;
  LLocalDataSize: Integer;
  LParent: TWinControl;
begin
  if CanPaste then
  begin
    LMemHandle := Clipboard.GetAsHandle(FClipboardFormatWord);
    LGlobalDataPtr := GlobalLock(LMemHandle);
    try
      LLocalDataPtr := nil;
      LLocalDataSize := GlobalSize(LMemHandle);
      ReallocMem(LLocalDataPtr, LLocalDataSize);
      try
        Move(LGlobalDataPtr^, LLocalDataPtr^, LLocalDataSize);

        LStream := TMemoryStream.Create;
        try
          LStream.Size := LLocalDataSize;
          Move(LLocalDataPtr^, LStream.Memory^, LLocalDataSize);

          if SelectedControls.Count > 0 then
            LParent := TDEng(FEng).FindContainer
              (SelectedControls.DefaultControl)
          else
            LParent := nil;
          if not Assigned(LParent) then
            LParent := TDEng(FEng).FRoot;
          TDEng(FEng).LoadControlsFromStream(LStream, LParent);
        finally
          FreeAndNil(LStream);
        end;
      finally
        FreeMem(LLocalDataPtr);
      end;
    finally
      GlobalUnlock(LMemHandle);
    end;
  end;
end;

procedure TELCustomDesigner.SetClipboardFormat(const Value: string);
begin
  if FClipboardFormat = Value then
    Exit;
  FClipboardFormat := Value;
  FClipbrdFormatRegistered := False;
  RegisterClipboardFormat;
end;

procedure TELCustomDesigner.RegisterClipboardFormat;
begin
  if not FClipbrdFormatRegistered then
    FClipboardFormatWord := Windows.RegisterClipboardFormat
      (PChar(FClipboardFormat));
  FClipbrdFormatRegistered := True;
end;

procedure TELCustomDesigner.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyDown) then
    OnKeyDown(Self, Key, Shift);
end;

procedure TELCustomDesigner.KeyPress(var Key: Char);
begin
  if Assigned(OnKeyPress) then
    OnKeyPress(Self, Key);
end;

procedure TELCustomDesigner.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Assigned(OnKeyUp) then
    OnKeyUp(Self, Key, Shift);
end;

function TELCustomDesigner.DoKeyDown(var AMessage: TWMKey): Boolean;
var
  LShiftState: TShiftState;
begin
  Result := True;
  with AMessage do
  begin
    LShiftState := KeyDataToShiftState(KeyData);
    KeyDown(CharCode, LShiftState);
    if CharCode = 0 then
      Exit;
  end;
  Result := False;
end;

function TELCustomDesigner.DoKeyPress(var AMessage: TWMKey): Boolean;
var
  LCh: Char;
begin
  Result := True;
  with AMessage do
  begin
    LCh := Char(CharCode);
    KeyPress(LCh);
    CharCode := Word(LCh);
    if Char(CharCode) = #0 then
      Exit;
  end;
  Result := False;
end;

function TELCustomDesigner.DoKeyUp(var AMessage: TWMKey): Boolean;
var
  LShiftState: TShiftState;
begin
  Result := True;
  with AMessage do
  begin
    LShiftState := KeyDataToShiftState(KeyData);
    KeyUp(CharCode, LShiftState);
    if CharCode = 0 then
      Exit;
  end;
  Result := False;
end;

procedure TELCustomDesigner.DoNotification(AnObject: TPersistent;
  Operation: TOperation);
begin
  if Assigned(OnNotification) then
    OnNotification(Self, AnObject, Operation);
end;

procedure TELDesignerSelectedControls.ClearNotChildrensOf(AParent: TWinControl);
begin
  FDesigner.CheckActive(True);
  BeginUpdate;
  try
    for var I := Count - 1 downto 0 do
      if Items[I].Parent <> AParent then
        Delete(I);
  finally
    EndUpdate;
  end;
end;

function TELCustomDesigner.IsUniqueName(const AName: string): Boolean;
begin
  CheckActive(True);
  Result := TDEng(FEng).IsUniqueName(AName);
end;

procedure TELCustomDesigner.GetUniqueName(const ABaseName: string;
  var AUniqueName: string);
begin
  if Assigned(OnGetUniqueName) then
    OnGetUniqueName(Self, ABaseName, AUniqueName);
end;

procedure TELCustomDesigner.DblClick;
begin
  if Assigned(OnDblClick) then
    OnDblClick(Self);
end;

function TELCustomDesigner.CanCopy: Boolean;
begin
  if Active and (((SelectedControls.Count = 1) and
    (SelectedControls[0] <> TDEng(FEng).FRoot)) or (SelectedControls.Count > 1))
  then
  begin
    Result := True;
    for var I := 0 to SelectedControls.Count - 1 do
      if (SelectedControls[I].Parent = SelectedControls.DefaultControl.Parent)
        and (SelectedControls[I] <> TDEng(FEng).FRoot) and
        (lmNoCopy in TDEng(FEng).GetFullLockMode(SelectedControls[I])) then
      begin
        Result := False;
        Break;
      end;
  end
  else
    Result := False;
end;

function TELCustomDesigner.CanPaste: Boolean;
begin
  if Active then
  begin
    Result := True;
    if SelectedControls.Count > 0 then
    begin
      var
      AControl := TDEng(FEng).FindContainer(SelectedControls.DefaultControl);
      if not Assigned(AControl) or
        (lmNoInsertIn in TDEng(FEng).GetLockMode(AControl)) then
        Result := False;
    end;
    if Result then
    begin
      RegisterClipboardFormat;
      Result := Clipboard.HasFormat(FClipboardFormatWord);
    end;
  end
  else
    Result := False;
end;

function TELCustomDesigner.CanCut: Boolean;
begin
  if Active and (((SelectedControls.Count = 1) and
    (SelectedControls[0] <> TDEng(FEng).FRoot)) or (SelectedControls.Count > 1))
  then
  begin
    Result := True;
    for var I := 0 to SelectedControls.Count - 1 do
      if (SelectedControls[I].Parent = SelectedControls.DefaultControl.Parent)
        and (SelectedControls[I] <> TDEng(FEng).FRoot) and
        ((lmNoCopy in TDEng(FEng).GetFullLockMode(SelectedControls[I])) or
        (lmNoDelete in TDEng(FEng).GetFullLockMode(SelectedControls[I]))) then
      begin
        Result := False;
        Break;
      end;
  end
  else
    Result := False;
end;

procedure TELCustomDesigner.LockAll(ALockMode: TELDesignerLockMode);
begin
  CheckActive(True);
  for var I := 0 to TDEng(FEng).FRoot.ComponentCount - 1 do
    if TDEng(FEng).FRoot.Components[I] is TControl then
      TDEng(FEng).LockControl(TControl(TDEng(FEng).FRoot.Components[I]),
        ALockMode);
end;

procedure TDEngNames.Add(const ASourceName, ADestName: string);
begin
  FSourceNames.Add(ASourceName);
  FDestNames.Add(ADestName);
end;

procedure TDEngNames.Clear;
begin
  FSourceNames.Clear;
  FDestNames.Clear;
end;

constructor TDEngNames.Create;
begin
  FSourceNames := TStringList.Create;
  FDestNames := TStringList.Create;
end;

function TDEngNames.DestName(Idx: Integer): string;
begin
  Result := FDestNames[Idx];
end;

destructor TDEngNames.Destroy;
begin
  Clear;
  FreeAndNil(FSourceNames);
  FreeAndNil(FDestNames);
  inherited;
end;

function TDEngNames.IndexOf(const ASourceName: string): Integer;
begin
  Result := FSourceNames.IndexOf(ASourceName);
end;

procedure TELDesignerSelectedControls.GetControls(AResult: TList);
begin
  AResult.Clear;
  for var I := 0 to Count - 1 do
    AResult.Add(Items[I]);
end;

function TELDesignerSelectedControls.GetDefaultControl: TControl;
begin
  if Count > 0 then
    Result := Items[Count - 1]
  else
    Result := nil;
end;

procedure TELDesignerSelectedControls.Lock(ALockMode: TELDesignerLockMode);
begin
  FDesigner.CheckActive(True);
  for var I := 0 to Count - 1 do
    FDesigner.LockControl(Items[I], ALockMode);
end;

procedure TELDesignerSelectedControls.AlignToGrid;
begin
  FDesigner.CheckActive(True);
  for var I := 0 to Count - 1 do
    TDEng(FDesigner.FEng).AlignToGrid(Items[I]);
end;

procedure TELDesignerSelectedControls.BringToFront;
begin
  FDesigner.CheckActive(True);
  for var I := 0 to Count - 1 do
    if Items[I] <> TDEng(FDesigner.FEng).FRoot then
      Items[I].BringToFront;
  TDEng(FDesigner.FEng).Modified;
end;

procedure TELDesignerSelectedControls.SendToBack;
begin
  FDesigner.CheckActive(True);
  for var I := 0 to Count - 1 do
    if Items[I] <> TDEng(FDesigner.FEng).FRoot then
      Items[I].SendToBack;
  TDEng(FDesigner.FEng).Modified;
end;

function Align_HorzSortProc(Item1, Item2: Pointer): Integer;
begin
  if TControl(Item1).Left < TControl(Item2).Left then
    Result := 1
  else if TControl(Item1).Left > TControl(Item2).Left then
    Result := -1
  else
    Result := 0;
end;

function Align_VertSortProc(Item1, Item2: Pointer): Integer;
begin
  if TControl(Item1).Top < TControl(Item2).Top then
    Result := 1
  else if TControl(Item1).Top > TControl(Item2).Top then
    Result := -1
  else
    Result := 0;
end;

procedure TELDesignerSelectedControls.Align(AHorzAlign,
  AVertAlign: TELDesignerAlignType);

type
  _TEdges = (etLeft, etTop, etRight, etBottom);
  _TDirection = (dtHorz, dtVert);

  procedure _AlignAdges(AEdges: _TEdges);
  var
    LBase, LCur: Integer;
  begin
    if Count < 2 then
      Exit;
    LBase := 0 + MaxInt * Ord(AEdges in [etLeft, etTop]);
    for var I := 0 to Count - 1 do
    begin
      LCur := 0; // Initialize
      case AEdges of
        etLeft:
          LCur := Items[I].Left;
        etTop:
          LCur := Items[I].Top;
        etRight:
          LCur := Items[I].Left + Items[I].Width;
        etBottom:
          LCur := Items[I].Top + Items[I].Height;
      end;
      if AEdges in [etLeft, etTop] then
      begin
        if LCur < LBase then
          LBase := LCur;
      end
      else if LCur > LBase then
        LBase := LCur;
    end;
    for var I := 0 to Count - 1 do
    begin
      case AEdges of
        etLeft:
          Items[I].Left := LBase;
        etTop:
          Items[I].Top := LBase;
        etRight:
          Items[I].Left := LBase - Items[I].Width;
        etBottom:
          Items[I].Top := LBase - Items[I].Height;
      end;
    end;
    TDEng(FDesigner.FEng).Modified;
  end;

  procedure _SpaceEqually(ADir: _TDirection);
  var
    LMin, LMax, LCur: Integer;
    LControls: TList;
  begin
    if Count <= 2 then
      Exit;
    LControls := TList.Create;
    GetControls(LControls);
    try
      if ADir = dtHorz then
      begin
        LControls.Sort(Align_HorzSortProc);
        LMin := TControl(LControls[0]).Left;
        LMax := TControl(LControls.Last).Left;
      end
      else
      begin
        LControls.Sort(Align_VertSortProc);
        LMin := TControl(LControls[0]).Top;
        LMax := TControl(LControls.Last).Top;
      end;
      for var I := 1 to LControls.Count - 2 do
      begin
        LCur := LMin + Round(I * (LMax - LMin) / (LControls.Count - 1));
        if ADir = dtHorz then
          TControl(LControls[I]).Left := LCur
        else
          TControl(LControls[I]).Top := LCur;
      end;
    finally
      FreeAndNil(LControls);
    end;
    TDEng(FDesigner.FEng).Modified;
  end;

  procedure _SetCenters(ADir: _TDirection; AValue: Integer);
  begin
    for var I := 0 to Count - 1 do
    begin
      if ADir = dtHorz then
        Items[I].Left := AValue - Items[I].Width div 2
      else
        Items[I].Top := AValue - Items[I].Height div 2;
    end;
  end;

  procedure _Center(ADir: _TDirection);
  begin
    if Count < 2 then
      Exit;
    if ADir = dtHorz then
      _SetCenters(ADir, Items[0].Left + Items[0].Width div 2)
    else
      _SetCenters(ADir, Items[0].Top + Items[0].Height div 2);
    TDEng(FDesigner.FEng).Modified;
  end;

  procedure _CenterInWindow(ADir: _TDirection);
  begin
    if Count < 1 then
      Exit;
    if ADir = dtHorz then
      _SetCenters(ADir, Items[0].Parent.Width div 2)
    else
      _SetCenters(ADir, (Items[0].Parent.Height - 38) div 2);
    TDEng(FDesigner.FEng).Modified;
  end;

begin
  FDesigner.CheckActive(True);
  if (DefaultControl <> nil) and (DefaultControl <> TDEng(FDesigner.FEng).FRoot)
  then
  begin
    ClearNotChildrensOf(DefaultControl.Parent);
    BeginUpdate;
    try
      case AHorzAlign of
        atLeftTop:
          _AlignAdges(etLeft);
        atRightBottom:
          _AlignAdges(etRight);
        atSpaceEqually:
          _SpaceEqually(dtHorz);
        atCenter:
          _Center(dtHorz);
        atCenterInWindow:
          _CenterInWindow(dtHorz);
      end;
      case AVertAlign of
        atLeftTop:
          _AlignAdges(etTop);
        atRightBottom:
          _AlignAdges(etBottom);
        atSpaceEqually:
          _SpaceEqually(dtVert);
        atCenter:
          _Center(dtVert);
        atCenterInWindow:
          _CenterInWindow(dtVert);
      end;
    finally
      Update;
      EndUpdate;
    end;
  end;
end;

procedure TELDesignerSelectedControls.CheckDesignControl(AControl: TControl);
begin
  if not TDEng(FDesigner.FEng).IsDesignControl(AControl) then
    raise EELDesigner.CreateFmt('Control ''%S'' can not be selected',
      [AControl.Name]);
end;

procedure TDEng.UpdateGridPattern;
var
  Int1, Int2, LXOff, LYOff: Integer;
begin
  FGridBkColor := FForm.Color;
  FGridHScrollPos := FForm.HorzScrollBar.ScrollPos;
  FGridVScrollPos := FForm.VertScrollBar.ScrollPos;
  if FGrid.XStep = 0 then
    LXOff := FGridHScrollPos mod 2
  else
    LXOff := FGridHScrollPos mod FGrid.XStep;
  if FGrid.YStep = 0 then
    LYOff := FGridVScrollPos mod 2
  else
    LYOff := FGridVScrollPos mod FGrid.YStep;
  with FGridBitmap do
  begin
    Width := 2 * FGrid.XStep;
    Height := 2 * FGrid.YStep;
    Canvas.Brush.Color := FGridBkColor;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(Rect(0, 0, FGridBitmap.Width, FGridBitmap.Height));

    Int1 := -LXOff;
    while Int1 < FGridBitmap.Width do
    begin
      Int2 := -LYOff;
      while Int2 < FGridBitmap.Height do
      begin
        if (Int1 >= 0) and (Int2 >= 0) then
          Canvas.Pixels[Int1, Int2] := FGrid.Color;
        Inc(Int2, FGrid.YStep);
      end;
      Inc(Int1, FGrid.XStep);
    end;
  end;
  if FGridBrush <> 0 then
    DeleteObject(FGridBrush);
  FGridBrush := CreatePatternBrush(FGridBitmap.Handle);
end;

procedure TELDesignerSelectedControls.UpdateControl(AIndex: Integer);
begin
  TDSelCtrlItem(FItems[AIndex]).Update;
end;

procedure TELCustomDesigner.DragOver(ASource, ATarget: TObject;
  XPos, YPos: Integer; AState: TDragState; var AAccept: Boolean);
begin
  AAccept := False;
  if Assigned(FOnDragOver) then
  begin
    AAccept := True;
    FOnDragOver(Self, ASource, ATarget, XPos, YPos, AState, AAccept);
  end;
end;

procedure TELCustomDesigner.DragDrop(ASource, ATarget: TObject;
  XPos, YPos: Integer);
begin
  if Assigned(FOnDragDrop) then
    FOnDragDrop(Self, ASource, ATarget, XPos, YPos);
end;

end.
