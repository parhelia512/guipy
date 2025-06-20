unit UFileStructure;

interface

uses
  System.Classes,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Menus,
  Vcl.ExtCtrls,
  Vcl.VirtualImageList,
  Vcl.BaseImageCollection,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ComCtrls,
  TB2Item,
  SpTBXItem,
  JvAppStorage,
  SVGIconImageCollection,
  VirtualTrees,
  VirtualTrees.AncestorVCL,
  VirtualTrees.BaseAncestorVCL,
  VirtualTrees.BaseTree,
  frmIDEDockWin,
  frmFile;

type
  TInteger = class
  private
    FInt: Integer;
  public
    constructor Create(Int: Integer);
    property Int: Integer read FInt;
  end;

  TFFileStructure = class(TIDEDockWindow, IJvAppStorageHandler)
    PMFileStructure: TSpTBXPopupMenu;
    MIClose: TSpTBXItem;
    MIDefaultLayout: TSpTBXItem;
    MIFont: TSpTBXItem;
    icFileStructure: TSVGIconImageCollection;
    vilFileStructureLight: TVirtualImageList;
    vilFileStructureDark: TVirtualImageList;
    vilFileStructure: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure MIFontClick(Sender: TObject);
    procedure MIDefaulLayoutClick(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure vilFileStructureGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure vilFileStructureGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure vilFileStructureFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vilFileStructureClick(Sender: TObject);
    procedure vilFileStructureMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vilFileStructureKeyPress(Sender: TObject; var Key: Char);
  private
    FLocked: Boolean;
    FLockShowSelected: Boolean;
    FMyForm: TFileForm;
    function DifferentItems(Items: TTreeNodes): Boolean;
    procedure NavigateToVilNode(Node: PVirtualNode;
      ForceToMiddle: Boolean = True; Activate: Boolean = True);
  protected
    procedure ReadFromAppStorage(AppStorage: TJvCustomAppStorage;
      const BasePath: string);
    procedure WriteToAppStorage(AppStorage: TJvCustomAppStorage;
      const BasePath: string);
  public
    procedure Init(Items: TTreeNodes; Form: TFileForm);
    procedure ShowEditorCodeElement(Line: Integer);
    procedure Clear(Form: TFileForm);
    procedure ChangeStyle;
    property MyForm: TFileForm read FMyForm;
  end;

var
  FFileStructure: TFFileStructure;

implementation

{$R *.dfm}

uses
  Winapi.Windows,
  System.Math,
  VirtualTrees.Types,
  JvGnugettext,
  SynEdit,
  JvDockControlForm,
  dmResources,
  uEditAppIntfs,
  uCommonFunctions,
  frmPyIDEMain,
  frmEditor,
  UUMLForm,
  UUtils,
  UGUIDesigner;

type
  PMyRec = ^TMyRec;

  TMyRec = record
    LineNumber: Integer;
    ImageIndex: Integer;
    Caption: string;
  end;

constructor TInteger.Create(Int: Integer);
begin
  inherited Create;
  FInt := Int;
end;

{ --- TFFileStructure ---------------------------------------------------------- }

{ If TVFiletructure has ParentFont true and the default font with size 9
  then during dpi change the font doesn't change, remains small. But if it has
  another font size, then during dpi change it's size is scaled.

  But the dependency does not exist if ParentFont is false.
}

procedure TFFileStructure.FormCreate(Sender: TObject);
begin
  inherited;
  Visible := False;
  FLocked := False;
  FLockShowSelected := False;
  TranslateComponent(Self);
  FMyForm := nil;
  ChangeStyle;

  // Let the tree know how much data space we need.
  vilFileStructure.NodeDataSize := SizeOf(TMyRec);
  // used options: toShowTreeLines, toShowRoot
end;

procedure TFFileStructure.FormShow(Sender: TObject);
begin
  SetFocus;
end;

procedure TFFileStructure.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TFFileStructure.Clear(Form: TFileForm);
begin
  if Assigned(FMyForm) and (Form.Pathname = FMyForm.Pathname) then
  begin
    vilFileStructure.Clear;
    FMyForm := nil;
  end;
end;

procedure TFFileStructure.FormDestroy(Sender: TObject);
begin
  vilFileStructure.Clear;
end;

procedure TFFileStructure.Init(Items: TTreeNodes; Form: TFileForm);

  function addNode(Node: TTreeNode; Anchor: PVirtualNode): PVirtualNode;
  var
    Data: PMyRec;
  begin
    Result := vilFileStructure.AddChild(Anchor);
    Data := vilFileStructure.GetNodeData(Result);
    Data.LineNumber := TInteger(Node.Data).Int;
    Data.ImageIndex := Node.ImageIndex;
    Data.Caption := Node.Text;
    vilFileStructure.ValidateNode(Result, False);
  end;

  procedure AddClasses(ClassNode: TTreeNode; Anchor: PVirtualNode);
  var
    Node: TTreeNode;
    VilClassNode: PVirtualNode;
  begin
    while Assigned(ClassNode) do
    begin
      VilClassNode := addNode(ClassNode, Anchor);
      Node := ClassNode.getFirstChild;
      while Assigned(Node) do
      begin
        if Node.ImageIndex = 0 // is node an inner class
        then
          AddClasses(Node, VilClassNode)
        else
          addNode(Node, VilClassNode);
        Node := Node.getNextSibling;
      end;
      ClassNode := ClassNode.getNextSibling;
    end;
  end;

begin
  FMyForm := Form;
  if DifferentItems(Items) then
  begin
    vilFileStructure.BeginUpdate;
    vilFileStructure.Clear;
    AddClasses(Items.GetFirstNode, vilFileStructure.RootNode);
    vilFileStructure.EndUpdate;
    vilFileStructure.FullExpand;
  end;
end;

procedure TFFileStructure.vilFileStructureFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PMyRec;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure TFFileStructure.vilFileStructureGetImageIndex
  (Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
var
  Data: PMyRec;
begin
  if Kind in [ikNormal, ikSelected] then
  begin
    Data := Sender.GetNodeData(Node);
    ImageIndex := Data.ImageIndex;
  end
  else
    ImageIndex := -1;
end;

procedure TFFileStructure.vilFileStructureGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PMyRec;
begin
  if TextType = ttNormal then
  begin
    Data := Sender.GetNodeData(Node);
    CellText := Data.Caption;
  end;
end;

procedure TFFileStructure.vilFileStructureMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    PMFileStructure.Popup(X + (Sender as TVirtualStringTree).ClientOrigin.X -
      40, Y + (Sender as TVirtualStringTree).ClientOrigin.Y - 5);
end;

function TFFileStructure.DifferentItems(Items: TTreeNodes): Boolean;
var
  Data: PMyRec;
begin
  if vilFileStructure.TotalCount <> Cardinal(Items.Count) then
    Exit(True);
  var
  I := -1;
  for var Node in vilFileStructure.Nodes do
  begin
    Inc(I);
    Data := vilFileStructure.GetNodeData(Node);
    if Data.Caption <> Items[I].Text then
      Exit(True);
  end;
  Result := False;
end;

procedure TFFileStructure.WriteToAppStorage(AppStorage: TJvCustomAppStorage;
  const BasePath: string);
begin
  var
  CurrentSize := Font.Size;
  Font.Size := PPIUnScale(Font.Size);
  AppStorage.WritePersistent(BasePath + '\Font', Font);
  Font.Size := CurrentSize;
end;

procedure TFFileStructure.ReadFromAppStorage(AppStorage: TJvCustomAppStorage;
  const BasePath: string);
begin
  AppStorage.ReadPersistent(BasePath + '\Font', Font);
  vilFileStructure.Font.Size := PPIScale(Font.Size);
end;

procedure TFFileStructure.MIFontClick(Sender: TObject);
begin
  ResourcesDataModule.dlgFontDialog.Font.Assign(vilFileStructure.Font);
  if ResourcesDataModule.dlgFontDialog.Execute then
    vilFileStructure.Font.Assign(ResourcesDataModule.dlgFontDialog.Font);
end;

procedure TFFileStructure.MIDefaulLayoutClick(Sender: TObject);
begin
  PyIDEMainForm.mnViewDefaultLayoutClick(Self);
end;

procedure TFFileStructure.MICloseClick(Sender: TObject);
begin
  HideDockForm(Self);
end;

procedure TFFileStructure.vilFileStructureClick(Sender: TObject);
var
  Data: PMyRec;
begin
  if FLocked then
  begin
    FLocked := False;
    Exit;
  end;
  var
  Node := vilFileStructure.GetFirstSelected;
  if not Assigned(Node) then
    Exit;
  NavigateToVilNode(Node);

  Data := vilFileStructure.GetNodeData(Node);
  var
  Attri := Data.Caption;
  Delete(Attri, 1, Pos(' ', Attri));
  if (Pos('(', Attri) = 0) and Assigned(FGUIDesigner.ELDesigner) then
  // methods can't be selected
    FGUIDesigner.ELDesigner.SelectControl(Attri);
end;

procedure TFFileStructure.vilFileStructureKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
    NavigateToVilNode(vilFileStructure.GetFirstSelected);
end;

procedure TFFileStructure.ShowEditorCodeElement(Line: Integer);
var
  Data: PMyRec;
  Node, FoundNode: PVirtualNode;
begin
  FoundNode := nil;
  for Node in vilFileStructure.Nodes do
  begin
    Data := vilFileStructure.GetNodeData(Node);
    if Data.LineNumber = Line then
    begin
      FoundNode := Node;
      Break;
    end
    else if Data.ImageIndex in [1 .. 3] then
      Continue
    else if Data.LineNumber > Line then
      Break
    else
      FoundNode := Node;
  end;
  if Assigned(FoundNode) then
    vilFileStructure.Selected[FoundNode] := True;
end;

procedure TFFileStructure.NavigateToVilNode(Node: PVirtualNode;
  ForceToMiddle: Boolean = True; Activate: Boolean = True);
var
  ANodeLine: Integer;
  Line, AClassname, ANodeText: string;
  EditForm: TEditorForm;
  AEditor: IEditor;
  IsWrapping: Boolean;
  Files: TStringList;
  Data: PMyRec;

  function BufferCoord(AChar, ALine: Integer): TBufferCoord;
  begin
    Result.Char := AChar;
    Result.Line := ALine;
  end;

begin
  if not Assigned(Node) then
    Exit;
  Data := vilFileStructure.GetNodeData(Node);
  ANodeLine := Data.LineNumber;
  ANodeText := Data.Caption;
  EditForm := nil;
  IsWrapping := False;

  if Assigned(FMyForm) then
  begin
    if FMyForm.MyFile.GetFileKind = fkEditor then
      EditForm := FMyForm as TEditorForm
    else if FMyForm.MyFile.GetFileKind = fkUML then
    begin
      FLocked := True;
      Files := (FMyForm as TFUMLForm).MainModul.Model.ModelRoot.Files;
      while vilFileStructure.NodeParent[Node] <> nil do
        Node := vilFileStructure.NodeParent[Node];
      Data := vilFileStructure.GetNodeData(Node);
      AClassname := WithoutGeneric(Data.Caption);
      var
      I := 0;
      while I < Files.Count do
      begin
        AEditor := GI_EditorFactory.GetEditorByFileId(Files[I]);
        if Assigned(AEditor) then
        begin
          EditForm := AEditor.Form as TEditorForm;
          if Pos('class ' + AClassname, EditForm.ActiveSynEdit.Lines.Text) > 0
          then
            Break;
        end;
        Inc(I);
      end;
    end;
    if Assigned(EditForm) then
    begin
      IsWrapping := EditForm.ActiveSynEdit.WordWrap;
      with EditForm.ActiveSynEdit do
      begin
        // Changing TopLine/CaretXY calls indirect ShowSelected;
        if IsWrapping then
          EditForm.TBWordWrapClick(nil);
        Line := Lines[ANodeLine - 1];
        FLockShowSelected := True;
        TopLine := ANodeLine;
        FLockShowSelected := False;
        CaretXY := BufferCoord(Max(1, Pos(ANodeText, Line)), ANodeLine);
        if IsWrapping then
          EditForm.TBWordWrapClick(nil);
      end;
    end;
  end;
  if Assigned(EditForm) then
  begin
    if Activate and CanActuallyFocus(EditForm.ActiveSynEdit) then
      EditForm.ActiveSynEdit.SetFocus;
    if IsWrapping then
      EditForm.TBWordWrapClick(nil);
    with EditForm do
      GI_PyIDEServices.ShowFilePosition(Pathname, ActiveSynedit.CaretY, ActiveSynEdit.CaretX);
  end;
end;

procedure TFFileStructure.ChangeStyle;
begin
  if IsStyledWindowsColorDark then
    vilFileStructure.Images := vilFileStructureDark
  else
    vilFileStructure.Images := vilFileStructureLight;
end;

end.
