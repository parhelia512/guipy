{-----------------------------------------------------------------------------
 Unit Name: frmDocView
 Author:    Kiriakos Vlahos
 Date:      09-May-2005
 Purpose:   HTML documentation Editor View
 History:
-----------------------------------------------------------------------------}

unit frmWebPreview;

interface

uses
  System.Classes,
  System.ImageList,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.VirtualImageList,
  Vcl.ImgList,
  Vcl.Edge,
  TB2Item,
  TB2Dock,
  TB2Toolbar,
  SpTBXItem,
  uEditAppIntfs,
  cTools, Winapi.WebView2, Winapi.ActiveX;

type
  TWebPreviewForm = class(TForm, IEditorView)
    TBXDock1: TSpTBXDock;
    TBXToolbar1: TSpTBXToolbar;
    ToolButtonForward: TSpTBXItem;
    ToolButtonBack: TSpTBXItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    TBXItem3: TSpTBXItem;
    TBXSeparatorItem2: TSpTBXSeparatorItem;
    TBXItem5: TSpTBXItem;
    TBXItem7: TSpTBXItem;
    BrowserImages: TVirtualImageList;
    WebBrowser: TEdgeBrowser;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButtonBackClick(Sender: TObject);
    procedure ToolButtonForwardClick(Sender: TObject);
    procedure ToolButtonStopClick(Sender: TObject);
    procedure ToolButtonPrintClick(Sender: TObject);
    procedure ToolButtonSaveClick(Sender: TObject);
    procedure WebBrowserCreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult:
        HRESULT);
    procedure WebBrowserExecuteScript(Sender: TCustomEdgeBrowser; AResult: HRESULT;
        const AResultObjectAsJson: string);
    procedure WebBrowserHistoryChanged(Sender: TCustomEdgeBrowser);
  private
    FEditor: IEditor;
    FSaveFileName: string;
    FIsNotebook: Boolean;
    FHtml: string;
    procedure UpdateView(Editor: IEditor);
    class var FExternalTool: TExternalTool;
    class constructor Create;
    class destructor Destroy;
  public
    const JupyterServerCaption = 'Jupyter Server';
    const JupyterServer = '$[PythonDir-Short]Scripts\Jupyter-notebook.exe';
  end;

  TWebPreviewView = class(TInterfacedObject, IEditorViewFactory)
  private
    function CreateForm(Editor: IEditor; AOwner: TComponent): TCustomForm;
    function GetName: string;
    function GetTabCaption: string;
    function GetMenuCaption: string;
    function GetHint: string;
    function GetImageName: string;
    function GetShortCut: TShortCut;
    procedure GetContextHighlighters(List: TList);
  end;

var
  WebPreviewFactoryIndex: Integer;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.NetEncoding,
  Vcl.Dialogs,
  JvGnugettext,
  uCommonFunctions,
  StringResources,
  dmResources,
  frmCommandOutput,
  cPyScripterSettings;

{$R *.dfm}

class constructor TWebPreviewForm.Create;
begin
  FExternalTool := TExternalTool.Create;
  with FExternalTool do begin
    Caption := JupyterServerCaption;
    Description := Caption;
    ApplicationName := JupyterServer;
    Parameters := '--no-browser --NotebookApp.token=""';
    WorkingDirectory := '$[ActiveDoc-Short-Dir]';
    SaveFiles := sfActive;
    Context := tcAlwaysEnabled;
    ParseTraceback := False;
    CaptureOutput := True;
    ConsoleHidden := True;
  end;
end;

procedure TWebPreviewForm.FormCreate(Sender: TObject);
begin
  WebBrowser.UserDataFolder := TPath.Combine(TPyScripterSettings.UserDataPath,
    'WebView2');
end;

class destructor TWebPreviewForm.Destroy;
begin
  FExternalTool.Free;
end;

procedure TWebPreviewForm.FormDestroy(Sender: TObject);
begin
  if OutputWindow.IsRunning and (OutputWindow.RunningTool = FExternalTool.Caption) then
    OutputWindow.actToolTerminate.Execute;
end;

procedure TWebPreviewForm.ToolButtonBackClick(Sender: TObject);
begin
  WebBrowser.GoBack;
end;

procedure TWebPreviewForm.ToolButtonForwardClick(Sender: TObject);
begin
  WebBrowser.GoForward;
end;

procedure TWebPreviewForm.ToolButtonStopClick(Sender: TObject);
begin
  WebBrowser.Stop;
end;

procedure TWebPreviewForm.ToolButtonPrintClick(Sender: TObject);
begin
  WebBrowser.ShowPrintUI(TEdgeBrowser.TPrintUIDialogKind.Browser);
end;

procedure TWebPreviewForm.ToolButtonSaveClick(Sender: TObject);
begin
  if ResourcesDataModule.GetSaveFileName(FSaveFileName, ResourcesDataModule.SynWebHtmlSyn, 'html') then
    WebBrowser.ExecuteScript('encodeURIComponent(document.documentElement.outerHTML)');
end;

procedure TWebPreviewForm.UpdateView(Editor: IEditor);
begin
  FEditor := Editor;
  if Assigned(Editor.SynEdit.Highlighter) and
    (Editor.SynEdit.Highlighter = ResourcesDataModule.SynJSONSyn) then
  begin
    FIsNotebook := True;
    var FName := TPath.GetFileName(Editor.FileName);
    FName := StringReplace(FName, ' ', '%20', [rfReplaceAll]);
    WebBrowser.Navigate('http://localhost:8888/notebooks/'+FName);
  end
  else
  begin
    FHtml := Editor.SynEdit.Text;
    WebBrowser.CreateWebView;
  end;
end;

procedure TWebPreviewForm.WebBrowserCreateWebViewCompleted(Sender:
    TCustomEdgeBrowser; AResult: HRESULT);
begin
  if WebBrowser.BrowserControlState <> TEdgeBrowser.TBrowserControlState.Created then
    StyledMessageDlg(_(SWebView2Error), mtError, [mbOK], 0)
  else if not FIsNotebook then
    WebBrowser.NavigateToString(FHtml);
end;

procedure TWebPreviewForm.WebBrowserExecuteScript(Sender: TCustomEdgeBrowser;
    AResult: HRESULT; const AResultObjectAsJson: string);
begin
  if (FSaveFileName <> '') and (AResultObjectAsJson <> 'null') then
  begin
    var StringList := TSmartPtr.Make(TStringList.Create);
    StringList.Text := TNetEncoding.URL.Decode(AResultObjectAsJson.DeQuotedString('"'));
    StringList.WriteBOM := False;
    StringList.SaveToFile(FSaveFileName, TEncoding.UTF8);
    FSaveFileName := '';
  end;
end;

procedure TWebPreviewForm.WebBrowserHistoryChanged(Sender: TCustomEdgeBrowser);
begin
  ToolButtonBack.Enabled := WebBrowser.CanGoBack;
  ToolButtonForward.Enabled := WebBrowser.CanGoForward;
end;

{ TDocView }

function TWebPreviewView.CreateForm(Editor: IEditor; AOwner: TComponent): TCustomForm;
begin
  if Assigned(Editor.SynEdit.Highlighter) and
    (Editor.SynEdit.Highlighter = ResourcesDataModule.SynJSONSyn) then
  begin
    if Editor.FileName = '' then
      (Editor as IFileCommands).ExecSave;
    if LowerCase(ExtractFileExt(Editor.FileName)) <> '.ipynb' then begin
      StyledMessageDlg(_(SOnlyJupyterFiles), mtError, [mbOK], 0);
      Abort;
    end;

    if not FileExists(GI_PyIDEServices.ReplaceParams(TWebPreviewForm.JupyterServer)) then
    begin
      StyledMessageDlg(_(SNoJupyter), mtError, [mbOK], 0);
      Abort;
    end;

    if OutputWindow.IsRunning then begin
      StyledMessageDlg(_(SExternalProcessRunning), mtError, [mbOK], 0);
      Abort;
    end;

    try
      OutputWindow.ExecuteTool(TWebPreviewForm.FExternalTool);
    except
      Abort;
    end;
  end;

  Result := TWebPreviewForm.Create(AOwner);
end;

function TWebPreviewView.GetImageName: string;
begin
  Result := 'Web';
end;

procedure TWebPreviewView.GetContextHighlighters(List: TList);
begin
  List.Add(ResourcesDataModule.SynWebHtmlSyn);
  List.Add(ResourcesDataModule.SynWebXmlSyn);
  List.Add(ResourcesDataModule.SynWebCssSyn);
  List.Add(ResourcesDataModule.SynJSONSyn);
end;

function TWebPreviewView.GetHint: string;
begin
  Result := _(SWebPreviewHint);
end;

function TWebPreviewView.GetMenuCaption: string;
begin
  Result := _(SWebPreview);
end;

function TWebPreviewView.GetName: string;
begin
  Result := 'Web Preview';
end;

function TWebPreviewView.GetTabCaption: string;
begin
  Result := _(SWebPreviewTab);
end;

function TWebPreviewView.GetShortCut: TShortCut;
begin
  Result := 0;
end;

initialization
  //  This unit must be initialized after frmEditor
  if Assigned(GI_EditorFactory) then
    WebPreviewFactoryIndex := GI_EditorFactory.RegisterViewFactory(TWebPreviewView.Create as IEditorViewFactory);

end.

