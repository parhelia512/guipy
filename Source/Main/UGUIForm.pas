unit UGUIForm;

{ For a long time there was a very hard to find runtime error
  when closing CodeCompletion. The cause was that when the
  CodeCompletion window was closed, another window was activated,
  which was a GUIForm window if it was in a certain order. This
  opened the corresponding EditorForm window. That means when
  typing an empty character with the CodeCompletion window open
  in the source code of a class, it jumped to the source code
  of the GUIForm window.

  Workaround: Set FormStyle to fsStayOnTop
  This took me 2 days to solve
}
interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Generics.Collections,
  System.Classes,
  Vcl.Graphics,
  Vcl.Forms,
  ELEvents,
  frmEditor,
  UBaseWidgets;

type

  TTheme = (alt, clam, default, classic, vista, winnative, xpnative);

  TToolButtonStyle = (ToolButtonIconOnly, ToolButtonTextOnly,
    ToolButtonTextBesideIcon, ToolButtonTextUnderIcon, ToolButtonFollowStyle);

  TTabShape = (Rounded, Triangular);

  TFGuiForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure FormAfterMonitorDpiChanged(Sender: TObject;
      OldDPI, NewDPI: Integer);
    procedure FormBeforeMonitorDpiChanged(Sender: TObject;
      OldDPI, NewDPI: Integer);
  private
    // Tk
    FAlwaysOnTop: Boolean;
    FFullscreen: Boolean;
    FIconified: Boolean;
    FMaxHeight: Integer;
    FMaxWidth: Integer;
    FMinHeight: Integer;
    FMinWidth: Integer;
    FResizable: Boolean;
    FUndecorated: Boolean;
    FTheme: TTheme;
    FTransparency: Real;
    FTitle: string;
    FFontSize: Integer;
    FIndent1: string;
    FIndent2: string;

    // events
    // Tk
    FActivate: TEvent;
    FButtonPress: TEvent;
    FButtonRelease: TEvent;
    FConfigure: TEvent;
    FDeactivate: TEvent;
    FDestroy: TEvent;
    FEnter: TEvent;
    FExpose: TEvent;
    FFocusIn: TEvent;
    FFocusOut: TEvent;
    FKeyPress: TEvent;
    FKeyRelease: TEvent;
    FLeave: TEvent;
    FMotion: TEvent;
    FMouseWheel: TEvent;
    FVisibility: TEvent;
    // Qt attributes
    FAnimated: Boolean;
    FDockNestingEnabled: Boolean;
    FDocumentMode: Boolean;
    FTabShape: TTabShape;
    FToolButtonStyle: TToolButtonStyle;
    // Qt signals
    FCustomContextMenuRequested: string;
    FWindowIconChanged: string;
    FWindowTitleChanged: string;
    FIconSizeChanged: string;
    FModified: Boolean;
    FPartner: TEditorForm;
    FPathname: string;
    FReadOnly: Boolean;
    FTabifiedDockWidgetActivated: string;
    FToolButtonStyleChanged: string;

    FWidget: TBaseWidget;
    FEventMap: TDictionary<string, TEvent>;
    function GetBackground: TColor;
    procedure SetBackground(Value: TColor);
    procedure SetTransparency(Value: Real);
    function Without_(Str: string): string;
    procedure SetWidgetPartners;
    procedure SetGridOptions;
    procedure GetFontSize;
  public
    constructor Create(AOwner: TComponent); override;
    procedure InitEvents;
    procedure Open(Pathname, State: string; WidthHeight: TPoint;
      Partner: TEditorForm);
    procedure EnterForm(Sender: TObject);
    procedure Save(MitBackup: Boolean);
    procedure UpdateState;
    procedure EnsureOnDesktop;
    procedure SetAttribute(Attr, Value, Typ: string);
    function GetAttributes(ShowAttributes: Integer): string;
    function GetEvents(ShowEvents: Integer): string;
    procedure SetEvent(Event: string);
    function Handlername(Event: string): string;
    function MakeHandler(Event: string): string;
    procedure DeleteEventHandler(const Event: string);
    function MakeBinding(Eventname: string): string;
    procedure EndOfResizeMoveDetected(var Msg: TMessage);
      message WM_EXITSIZEMOVE;
    procedure Paint; override;
    procedure Zoom(ZoomIn: Boolean);
    procedure Scale(NewPPI, OldPPI: Integer);

    property Modified: Boolean read FModified write FModified;
    property Partner: TEditorForm read FPartner write FPartner;
    property Pathname: string read FPathname write FPathname;
    property ReadOnly: Boolean read FReadOnly;
  published
    property AlwaysOnTop: Boolean read FAlwaysOnTop write FAlwaysOnTop;
    property Background: TColor read GetBackground write SetBackground;
    property Fullscreen: Boolean read FFullscreen write FFullscreen;
    property Iconified: Boolean read FIconified write FIconified;
    property MaxHeight: Integer read FMaxHeight write FMaxHeight;
    property MaxWidth: Integer read FMaxWidth write FMaxWidth;
    property MinHeight: Integer read FMinHeight write FMinHeight;
    property MinWidth: Integer read FMinWidth write FMinWidth;
    property Resizable: Boolean read FResizable write FResizable;
    property Title: string read FTitle write FTitle;
    property Theme: TTheme read FTheme write FTheme;
    property Transparency: Real read FTransparency write SetTransparency;
    property Undecorated: Boolean read FUndecorated write FUndecorated;
    property FontSize: Integer read FFontSize write FFontSize;
    property Height;
    property Width;
    // events
    // Tk
    property Activate: TEvent read FActivate write FActivate;
    property ButtonPress: TEvent read FButtonPress write FButtonPress;
    property ButtonRelease: TEvent read FButtonRelease write FButtonRelease;
    property Configure: TEvent read FConfigure write FConfigure;
    property Deactivate: TEvent read FDeactivate write FDeactivate;
    property Destroy_: TEvent read FDestroy write FDestroy;
    property Enter: TEvent read FEnter write FEnter;
    property Expose: TEvent read FExpose write FExpose;
    property FocusIn: TEvent read FFocusIn write FFocusIn;
    property FocusOut: TEvent read FFocusOut write FFocusOut;
    property KeyPress: TEvent read FKeyPress write FKeyPress;
    property KeyRelease: TEvent read FKeyRelease write FKeyRelease;
    property Leave: TEvent read FLeave write FLeave;
    property Motion: TEvent read FMotion write FMotion;
    property MouseWheel: TEvent read FMouseWheel write FMouseWheel;
    property Visibility: TEvent read FVisibility write FVisibility;
    // Qt
    // attributes
    property Animated: Boolean read FAnimated write FAnimated;
    property DockNestingEnabled: Boolean read FDockNestingEnabled
      write FDockNestingEnabled;
    property DocumentMode: Boolean read FDocumentMode write FDocumentMode;
    property TabShape: TTabShape read FTabShape write FTabShape;
    property ToolButtonStyle: TToolButtonStyle read FToolButtonStyle
      write FToolButtonStyle;
    // signals QWidget
    property customContextMenuRequested: string read FCustomContextMenuRequested
      write FCustomContextMenuRequested;
    property windowIconChanged: string read FWindowIconChanged
      write FWindowIconChanged;
    property windowTitleChanged: string read FWindowTitleChanged
      write FWindowTitleChanged;
    // signals QMainWindow
    property iconSizeChanged: string read FIconSizeChanged
      write FIconSizeChanged;
    property tabifiedDockWidgetActivated: string
      read FTabifiedDockWidgetActivated write FTabifiedDockWidgetActivated;
    property toolButtonStyleChanged: string read FToolButtonStyleChanged
      write FToolButtonStyleChanged;
  end;

implementation

uses
  SysUtils,
  Controls,
  Math,
  UxTheme,
  JvDockControlForm,
  frmPyIDEMain,
  StringResources,
  cPyScripterSettings,
  UBaseTKWidgets,
  UQtWidgetDescendants,
  UGUIDesigner,
  UObjectGenerator,
  UObjectInspector,
  UUtils,
  UConfiguration,
  uCommonFunctions;

{$R *.DFM}

constructor TFGuiForm.Create(AOwner: TComponent);
begin
  inherited;
  FAlwaysOnTop := False;
  FIconified := False;
  FFullscreen := False;
  FResizable := True;
  FTransparency := 1;
  FTheme := vista;
  FIndent1 := FConfiguration.Indent1;
  FIndent2 := FConfiguration.Indent2;
  // don't theme this window
  SetWindowTheme(Handle, nil, nil);
  SetGridOptions;
  ParentFont := False;
end;

procedure TFGuiForm.InitEvents;
begin
  FButtonPress := TEvent.Create(Self, 'ButtonPress');
  FButtonRelease := TEvent.Create(Self, 'ButtonRelease');
  FKeyPress := TEvent.Create(Self, 'KeyPress');
  FKeyRelease := TEvent.Create(Self, 'KeyRelease');
  FActivate := TEvent.Create(Self, 'Activate');
  FConfigure := TEvent.Create(Self, 'Configure');
  FDeactivate := TEvent.Create(Self, 'Deactivate');
  FDestroy := TEvent.Create(Self, 'Destroy');
  FEnter := TEvent.Create(Self, 'Enter');
  FExpose := TEvent.Create(Self, 'Expose');
  FFocusIn := TEvent.Create(Self, 'FocusIn');
  FFocusOut := TEvent.Create(Self, 'FocusOut');
  FLeave := TEvent.Create(Self, 'Leave');
  FMotion := TEvent.Create(Self, 'Motion');
  FMouseWheel := TEvent.Create(Self, 'MouseWheel');
  FVisibility := TEvent.Create(Self, 'Visibility');

  FEventMap := TDictionary<string, TEvent>.Create;
  FEventMap.Add('ButtonPress', FButtonPress);
  FEventMap.Add('ButtonRelease', FButtonRelease);
  FEventMap.Add('KeyPress', FKeyPress);
  FEventMap.Add('KeyRelease', FKeyRelease);
  FEventMap.Add('Activate', FActivate);
  FEventMap.Add('Configure', FConfigure);
  FEventMap.Add('Deactivate', FDeactivate);
  FEventMap.Add('Destroy_', FDestroy);
  FEventMap.Add('Enter', FEnter);
  FEventMap.Add('Expose', FExpose);
  FEventMap.Add('FocusIn', FFocusIn);
  FEventMap.Add('FocusOut', FFocusOut);
  FEventMap.Add('Leave', FLeave);
  FEventMap.Add('Motion', FMotion);
  FEventMap.Add('MouseWheel', FMouseWheel);
end;

procedure TFGuiForm.Open(Pathname, State: string; WidthHeight: TPoint;
  Partner: TEditorForm);
begin
  FPathname := Pathname;
  FPartner := Partner;
  {$WARNINGS OFF}
  // creation of Widgets with abstract methods, but these methods are not used
  if FPartner.FrameType < 3 then
    FWidget := TKMainWindow.Create(nil)
  else
    FWidget := TQtMainWindow.Create(nil);
  {$WARNINGS ON}
  FWidget.Partner := FPartner;
  SetAnimation(False);
  ClientWidth := PPIScale(WidthHeight.X);
  ClientHeight := PPIScale(WidthHeight.Y);
  Name := UUtils.GetUniqueName(PyIDEMainForm,
    ChangeFileExt(ExtractFileName(FPathname), ''));
  FModified := False;
  SetWidgetPartners;
  OnActivate := EnterForm;
  PyIDEMainForm.ConnectGUIandPyWindow(Self);
  EnterForm(Self); // must stay!
  SetAnimation(True);
  FReadOnly := IsWriteProtected(FPathname);
  if FontSize = 0 then
    GetFontSize;
end;

procedure TFGuiForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FGUIDesigner.ELDesigner.Active := False;
  FGUIDesigner.ELDesigner.DesignControl := nil;
  FGUIDesigner.DesignForm := nil;
  FObjectInspector.RefreshCBObjects;
  if PyIDEOptions.SaveFilesAutomatically then
    Save(PyIDEOptions.CreateBackupFiles);
  CanClose := True;
end;

procedure TFGuiForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FPartner) then
  begin
    FPartner.Partner := nil;
    FPartner.GetEditor.GUIFormOpen := False;
  end;
  for var I := 1 to 4 do
    PyIDEMainForm.TabControlWidgets.Items[I].Visible :=
      FConfiguration.VisTabs[I];
  Action := caFree;
end;

procedure TFGuiForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FActivate);
  FreeAndNil(FButtonPress);
  FreeAndNil(FButtonRelease);
  FreeAndNil(FConfigure);
  FreeAndNil(FDeactivate);
  FreeAndNil(FDestroy);
  FreeAndNil(FEnter);
  FreeAndNil(FExpose);
  FreeAndNil(FFocusIn);
  FreeAndNil(FFocusOut);
  FreeAndNil(FKeyPress);
  FreeAndNil(FKeyRelease);
  FreeAndNil(FLeave);
  FreeAndNil(FMotion);
  FreeAndNil(FMouseWheel);
  FreeAndNil(FVisibility);
  FreeAndNil(FWidget);
  FreeAndNil(FEventMap);
end;

function TFGuiForm.GetBackground: TColor;
begin
  Result := Color;
end;

procedure TFGuiForm.SetBackground(Value: TColor);
begin
  Color := Value;
end;

procedure TFGuiForm.SetTransparency(Value: Real);
begin
  if (0 <= Value) and (Value <= 1) then
    FTransparency := Value;
end;

procedure TFGuiForm.Save(MitBackup: Boolean);
var
  Backupname: string;
begin
  if FReadOnly then
    Exit;
  if MitBackup then
  begin
    Backupname := FPathname;
    Backupname := ChangeFileExt(Backupname, '.~fm');
    if FileExists(Backupname) then
      SysUtils.DeleteFile(Backupname);
    if FileExists(FPathname) then
      RenameFile(FPathname, Backupname);
  end;
  FGUIDesigner.Save(FPathname, Self);
  FModified := False;
end;

procedure TFGuiForm.EnterForm(Sender: TObject);
begin
  if Assigned(FPartner) and not FPartner.ParentTabItem.Checked then
    // show connected FPartner
    TThread.ForceQueue(nil,
      procedure
      begin
        FPartner.ParentTabItem.Checked := True;
      end);
  if not FObjectInspector.Visible then
    TThread.ForceQueue(nil,
      procedure
      begin
        ShowDockForm(FObjectInspector);
      end);
  FGUIDesigner.ChangeTo(Self);
  FPartner.SynEditEnter(FPartner.ActiveSynEdit);
  // without this in special scenarios controls couldn't be selected
  TThread.ForceQueue(nil,
    procedure
    begin
      PyIDEMainForm.ShowTkOrQt(FPartner.FrameType);
    end);
end;

procedure TFGuiForm.FormAfterMonitorDpiChanged(Sender: TObject;
OldDPI, NewDPI: Integer);
begin
  FGUIDesigner.ScaleImages;
  Invalidate;
  SetGridOptions;
  OnResize := FormResize;
end;

procedure TFGuiForm.FormBeforeMonitorDpiChanged(Sender: TObject;
OldDPI, NewDPI: Integer);
begin
  OnResize := nil;
end;

procedure TFGuiForm.SetGridOptions;
begin
  FGUIDesigner.ELDesigner.SnapToGrid := GuiPyOptions.SnapToGrid;
  FGUIDesigner.ELDesigner.Grid.XStep := PPIScale(GuiPyOptions.GridSize);
  FGUIDesigner.ELDesigner.Grid.YStep := PPIScale(GuiPyOptions.GridSize);
end;

procedure TFGuiForm.FormCanResize(Sender: TObject;
var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  if FGUIDesigner.ELDesigner.Active then
    FGUIDesigner.ELDesigner.Active := False;
end;

procedure TFGuiForm.FormResize(Sender: TObject);
begin
  FObjectInspector.ELPropertyInspector.Modified;
  if Assigned(FPartner) and not FReadOnly then
  begin
    FObjectGenerator.Partner := FPartner;
    FObjectGenerator.SetBoundsForFormular(Self);
  end;
  FModified := True;
  UpdateState;
end;

procedure TFGuiForm.EndOfResizeMoveDetected(var Msg: TMessage);
begin
  FGUIDesigner.ELDesigner.Active := True;
end;

procedure TFGuiForm.UpdateState;
begin
  FGUIDesigner.UpdateState(False);
end;

procedure TFGuiForm.EnsureOnDesktop;
var
  Lef1, Top1: Integer;
begin
  Lef1 := Left;
  if Lef1 < 0 then
    Lef1 := 0;
  if Lef1 + Width > Screen.DesktopWidth then
    Lef1 := Screen.DesktopWidth - Width;
  Top1 := Top;
  if Top1 < 0 then
    Top1 := 0;
  if Top1 + Height > Screen.DesktopHeight then
    Top1 := Screen.DesktopHeight - Height;
  SetBounds(Lef1, Top1, Width, Height);
end;

procedure TFGuiForm.SetAttribute(Attr, Value, Typ: string);
begin
  if (Attr = 'MaxHeight') or (Attr = 'MaxWidth') then
    Value := IntToStr(FMaxWidth) + ', ' + IntToStr(FMaxHeight)
  else if (Attr = 'MinHeight') or (Attr = 'MinWidth') then
    Value := IntToStr(FMinWidth) + ', ' + IntToStr(FMinHeight)
  else if Attr = 'Title' then
    Caption := Value;
  FWidget.SetAttribute(Attr, Value, Typ);
end;

function TFGuiForm.GetAttributes(ShowAttributes: Integer): string;
begin
  Result := FWidget.GetAttributes(ShowAttributes);
end;

function TFGuiForm.GetEvents(ShowEvents: Integer): string;
begin
  Result := FWidget.GetEvents(ShowEvents) + '|';
end;

function TFGuiForm.Without_(Str: string): string;
begin
  if Str = 'Destroy_' then
    Result := 'Destroy'
  else
    Result := Str;
end;

function TFGuiForm.MakeHandler(Event: string): string;
begin
  Result := FIndent1 + 'def ' + FWidget.HandlerNameAndParameter(Event) + CrLf +
    FIndent2 + LNGInsertSourceCodeHere + CrLf + FIndent2 +
    'pass' + CrLf;
end;

procedure TFGuiForm.SetEvent(Event: string);
begin
  Event := Without_(Event);
  if not FPartner.HasText('def ' + FWidget.HandlerNameAndParameter(Event)) then
    FPartner.InsertProcedure(CrLf + MakeHandler(Event));
  if FPartner.FrameType < 3 then
    FPartner.InsertTkBinding('root', Event, MakeBinding(Event))
  else
    FPartner.InsertQtBinding(FIndent2 + 'self.', MakeBinding(Event));
end;

function TFGuiForm.Handlername(Event: string): string;
begin
  if FPartner.FrameType < 3 then
    Result := 'root_' + Without_(Event)
  else
    Result := 'MainWindow_' + Event;
end;

function TFGuiForm.MakeBinding(Eventname: string): string;
var
  Event: TEvent;
begin
  if FPartner.FrameType < 3 then
  begin
    Eventname := Without_(Eventname);
    if not FEventMap.TryGetValue(Eventname, Event) then
      Event := FVisibility;
    Result := FIndent2 + 'self.root.bind(''<' + Event.GetModifiers(Eventname) +
      Eventname + Event.GetDetail(Eventname) + '>'', self.' +
      Handlername(Eventname) + ')';
  end
  else
    Result := FIndent2 + 'self.' + Eventname + '.connect(self.' +
      Handlername(Eventname) + ')';
end;

procedure TFGuiForm.DeleteEventHandler(const Event: string);
begin
  FPartner.DeleteMethod(Handlername(Event));
  var
  Binding := MakeBinding(Event);
  if FPartner.FrameType >= 3 then
    Binding := Copy(Binding, 1, Pos('(', Binding));
  FPartner.DeleteBinding(Binding);
end;

procedure TFGuiForm.Paint;
begin
  inherited;
  Canvas.FillRect(ClientRect);
end;

procedure TFGuiForm.SetWidgetPartners;
begin
  for var I := 0 to ComponentCount - 1 do
    if Components[I] is TBaseWidget then
      (Components[I] as TBaseWidget).Partner := FPartner;
end;

procedure TFGuiForm.Zoom(ZoomIn: Boolean);
begin
  for var I := 0 to ComponentCount - 1 do
    if Components[I] is TBaseWidget then
      (Components[I] as TBaseWidget).Zoom(ZoomIn);
  if ZoomIn then
    FontSize := FontSize + GuiPyOptions.ZoomSteps
  else
    FontSize := Max(FontSize - GuiPyOptions.ZoomSteps, 6);
end;

type
  TControlClass = class(TControl);

procedure TFGuiForm.Scale(NewPPI, OldPPI: Integer);
begin
  if NewPPI = OldPPI then
    Exit;
  FIScaling := True;
  try
    ScaleScrollBars(NewPPI, OldPPI);
    ScaleConstraints(NewPPI, OldPPI);
    ClientWidth := MulDiv(ClientWidth, NewPPI, OldPPI);
    ClientHeight := MulDiv(ClientHeight, NewPPI, OldPPI);
    for var I := 0 to ComponentCount - 1 do
      if Components[I] is TControl then
        TControlClass(Components[I]).ChangeScale(NewPPI, OldPPI, True);
    if not ParentFont then
      Font.Height := MulDiv(Font.Height, NewPPI, OldPPI);
    Realign;
  finally
    FIScaling := False;
  end;
end;

procedure TFGuiForm.GetFontSize;
var
  CompFontSize, Value, Key, MaxFontCount, MaxFontKey: Integer;
  FontSizeDictionary: TDictionary<Integer, Integer>;
begin
  FontSizeDictionary := TDictionary<Integer, Integer>.Create(20);
  for var I := 0 to ComponentCount - 1 do
    if Components[I] is TBaseWidget then
    begin
      CompFontSize := (Components[I] as TBaseWidget).Font.Size;
      if FontSizeDictionary.TryGetValue(CompFontSize, Value) then
        FontSizeDictionary.AddOrSetValue(CompFontSize, Value + 1)
      else
        FontSizeDictionary.AddOrSetValue(CompFontSize, 1);
    end;
  MaxFontCount := 0;
  MaxFontKey := 0;
  for Key in FontSizeDictionary.Keys do
    if FontSizeDictionary[Key] > MaxFontCount then
    begin
      MaxFontCount := FontSizeDictionary[Key];
      MaxFontKey := Key;
    end;
  if MaxFontKey > 0 then
    FontSize := MaxFontKey
  else
    FontSize := GuiPyOptions.GuiFontSize;
  FontSizeDictionary.Free;
end;

end.
