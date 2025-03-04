unit UUpdate;

interface

uses
  Vcl.Controls, System.Classes, Forms, StdCtrls, ComCtrls, dlgPyIDEBase;

const
  Server  = 'https://guipy.de/download/';
  Inffile = Server + 'version.txt';
  {$IFDEF WIN32}
  Zipfile = 'GuiPy.zip';   // update portable version
  Setupfile = 'GuiPy-%s-x86-Setup.exe';   // update default version
  Version = '6.05, 32 Bit';
  Bits = '32';
  {$ENDIF}
  {$IFDEF WIN64}
  Zipfile = 'GuiPy64.zip';
  Setupfile = 'GuiPy-%s-x64-Setup.exe';
  Version = '6.05, 64 Bit';
  Bits = '64';
  {$ENDIF}

  Day   = 4;
  Month = 3;
  Year  = 2025;

type
  TFUpdate = class(TPyIDEDlgBase)
    LOldVersion: TLabel;
    EOldVersion: TEdit;
    LNewVersion: TLabel;
    ENewVersion: TEdit;
    Memo: TMemo;
    LChecking: TLabel;
    CBUpdate: TComboBox;
    ProgressBar: TProgressBar;
    BClose: TButton;
    BUpdate: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BCloseClick(Sender: TObject);
    procedure BUpdateClick(Sender: TObject);
  private
    FNewVersion: string;
    FLocalTempDir: string;
    procedure MakeUpdate;
    function GetNewVersion: Boolean;
    function ShowVersionDate(VersionDate: string): string;
    function ExtractZipToDir(const FileName, Dir: string): Boolean;
  public
    class function GetVersionDate: string;
    procedure CheckAutomatically;
  end;

implementation

uses Windows, SysUtils, DateUtils, IOUtils, Zip,
     frmPyIDEMain, JvGnugettext, cPyScripterSettings,
     UUtils, UConfiguration, UDownload;

{$R *.dfm}

procedure TFUpdate.FormCreate(Sender: TObject);
begin
  inherited;
  SetElevationRequiredState(BUpdate);
  PopupParent := Sender as TForm;
end;

procedure TFUpdate.FormShow(Sender: TObject);
begin
  FLocalTempDir:= TPath.Combine(GuiPyOptions.TempDir, 'GuiPy\');
  ForceDirectories(FLocalTempDir);
  TThread.ForceQueue(nil, procedure
    begin
      GetNewVersion;
    end);
end;

procedure TFUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PyIDEMainForm.AppStorage.WriteInteger('Program\Update', CBUpdate.ItemIndex);
end;

procedure TFUpdate.BCloseClick(Sender: TObject);
begin
  Close;
end;

{.$WARN SYMBOL_PLATFORM OFF}
procedure TFUpdate.BUpdateClick(Sender: TObject);
  var FileName, Filepath: string;
begin
  Screen.Cursor:= crHourGlass;
  try
    if TPyScripterSettings.IsPortable
      then FileName:= Zipfile
      else FileName:= Format(Setupfile, [FNewVersion]);
    Filepath:= TPath.Combine(FLocalTempDir, FileName);
    with TFDownload.Create(Self) do begin
      if GetInetFile(Server + FileName, Filepath, ProgressBar) then begin
        if TPyScripterSettings.IsPortable then begin
          if ExtractZipToDir(Filepath, FLocalTempDir)
            then MakeUpdate
            else Memo.Lines.Add(_('Unpacking error'));
        end else
          if FConfiguration.RunAsAdmin(Handle, Filepath, '') = 33 then begin
            Close;
            PyIDEMainForm.Close;
          end;
      end else
        Memo.Lines.Add(_('Download failed!'));
      Free;
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;
{.$WARN SYMBOL_PLATFORM ON}

procedure TFUpdate.MakeUpdate;
  var Updater, Params, SVersion: string;
begin
  Updater:= TPath.Combine(FLocalTempDir, 'setup.exe');
  SVersion:= Copy(Version, 1, Pos(',', Version) -1 );
  Params:= '-Update ' + HideBlanks(FConfiguration.EditorFolder) +  ' ' +
                        HideBlanks(withTrailingSlash(FLocalTempDir)) + ' ' + SVersion;
  if FConfiguration.RunAsAdmin(Handle, Updater, Params) = 33 then begin
    Close;
    TThread.ForceQueue(nil, procedure
      begin
        PyIDEMainForm.Close;
      end);
  end;
end;

function TFUpdate.ExtractZipToDir(const FileName, Dir: string): Boolean;
begin
  Result:= False;
  var ZipFile:= TZipFile.Create;
  try
    try
      ZipFile.Open(FileName, zmRead);
      ZipFile.ExtractAll(Dir);
      Result:= True;
    except on E: Exception do
      ErrorMsg(E.Message + ' ' + SysErrorMessage(GetLastError));
    end;
  finally
    FreeAndNil(ZipFile);
  end;
end;

function TFUpdate.GetNewVersion: Boolean;
  var StrList: TStringList; OldVersion, s, Pathname: string;
begin
  EOldVersion.Text:= Version + ', ' + GetVersionDate;
  ENewVersion.Text:= '';
  Memo.Lines.Clear;
  Screen.Cursor:= crHourGlass;
  try
    Pathname:= TPath.Combine(FLocalTempDir, 'version.txt');
    if DownloadURL(Inffile, Pathname) then begin
      StrList:= TStringList.Create;
      try
        StrList.LoadFromFile(Pathname);
        s:= ShowVersionDate(StrList[0]);
        insert(Bits + ' Bit, ', s, pos(', ', s) + 2);
        ENewVersion.Text:= s;
        Memo.Lines.AddStrings(StrList);
        OldVersion:= Copy(EOldVersion.Text, 1, Pos(',', EOldVersion.Text)-1);
        FNewVersion:= Copy(ENewVersion.Text, 1, Pos(',', ENewVersion.text)-1);
        if OldVersion = FNewVersion then begin
          ENewVersion.Text:= _('GuiPy is up to date.');
          Result:= False;
        end else
          Result:= True;
      finally
        FreeAndNil(StrList);
      end;
    end else begin
      Memo.Lines.Add(_('No Internet connection'));
      Result:= False;
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFUpdate.CheckAutomatically;
  var NextUpdate: Integer;
      ADate: TDateTime;
      AYear, AMonth, AWeekOfMonth, ADayOfWeek: Word;

  procedure NextMonth;
  begin
    Inc(AMonth);
    if AMonth = 13 then begin
      Inc(AYear);
      AMonth:= 1;
    end;
    AWeekOfMonth:= 1;
    ADayOfWeek:= 1;
  end;

  procedure NextWeek;
  begin
    ADayOfWeek:= 1;
    Inc(AWeekOfMonth);
    if not IsValidDateMonthWeek(AYear, AMonth, AWeekOfMonth, ADayOfWeek)then
      NextMonth;
  end;

  procedure NextDay;
  begin
    Inc(ADayOfWeek);
    if ADayOfWeek = 8 then
      NextWeek;
  end;

begin
  CBUpdate.ItemIndex:= PyIDEMainForm.AppStorage.ReadInteger('Program\Update', 0);
  if CBUpdate.ItemIndex <= 0 then Exit;
  NextUpdate:= PyIDEMainForm.AppStorage.ReadInteger('Program\NextUpdate', -1);
  if (Date < NextUpdate) and (CBUpdate.ItemIndex < 4) then
    Exit;
  DecodeDateMonthWeek(Date, AYear, AMonth, AWeekOfMonth, ADayOfWeek);
  case CBUpdate.ItemIndex of
    1: NextMonth;
    2: NextWeek;
    3: NextDay;
  end;
  ADate:= EncodeDateMonthWeek(AYear, AMonth, AWeekOfMonth, ADayOfWeek);
  PyIDEMainForm.AppStorage.WriteInteger('Program\NextUpdate', Round(ADate));
  if GetNewVersion then
    Show;
end;

function TFUpdate.ShowVersionDate(VersionDate: string): string;
  var Day, Month, Year, Posi: Integer;
      Version: string;
begin
  Posi:= Pos(',', VersionDate);
  Version:= Copy(VersionDate, 1, Posi);
  Delete(VersionDate, 1, Posi);
  Posi:= Pos('.', VersionDate);
  Result:= Version;
  if TryStrToInt(Copy(VersionDate, 1, Posi-1), Year) then begin
    Delete(VersionDate, 1, Posi);
    Posi:= pos('.', VersionDate);
    if TryStrToInt(Copy(VersionDate, 1, Posi-1), Month) then begin
      Delete(VersionDate, 1, Posi);
      if TryStrToInt(VersionDate, Day) then
        Result:= Version + ' ' + DateToStr(EncodeDate(Year, Month, Day));
    end;
  end;
end;

class function TFUpdate.GetVersionDate: string;
begin
  Result:= DateToStr(EncodeDate(Year, Month, Day));
end;

end.
