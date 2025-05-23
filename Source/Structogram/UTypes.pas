﻿{-------------------------------------------------------------------------------
 Unit:     UTypes
 Author:   Gerhard Röhner
 Based on: NSD-Editor by Marcel Kalt
 Date:     August 2013
 Purpose:  elements of a structogram
-------------------------------------------------------------------------------}

unit UTypes;

interface

uses
  Windows, Classes, Graphics, ExtCtrls, Forms, Controls;

const
  LEFT_RIGHT = 10;   { Default left/right margin of element }

type

  TStringListReader = class
    SL: TStringList;
    nr: Integer;
    kind: Byte;
    IndentAsInt: Integer;
    Text: string;
    aRect: TRect;
    Point: TPoint;
    key: string;
    val: string;
    constructor Create(FileName: string);
    function nextLineIndent: Integer;
    procedure ReadLine;
    procedure LineBack;
    function getKind(Kind: string): byte;
    destructor Destroy; override;
  end;

  TStrType = (nsAlgorithm, nsStatement, nsIf, nsWhile, nsDoWhile, nsFor, nsSwitch,
              nsSubProgram, nsListHead, nsCase, nsBreak, nsList);

  TStrList = class;

  TStrElement = class
  private
    procedure Draw; virtual;
    procedure DrawRightBottom; virtual;
    procedure DrawLeftBottom; virtual;
    procedure DrawCircle(x, y, h: Integer);
    procedure DrawLines(x, y, line_height: Integer);
    procedure DrawLinesRight(x, y, line_height: Integer);
    procedure DrawCenteredLines(center, y: Integer; percent: real);
    procedure DrawContent(x, y: Integer); virtual;
    procedure MoveRight(w: Integer); virtual;
    procedure MoveRightList(b: Integer); virtual;
    procedure MoveDown(h: Integer); virtual;
    procedure MoveDownList(h: Integer); virtual;
    procedure Resize(x, y: Integer); virtual;
    procedure setRight(Right: Integer); virtual;
    procedure setBottomList(b: Integer); virtual;
    procedure setBottom(b: Integer); virtual;
    procedure LoadFromStream(Stream: TStream; Version: byte); virtual;
    procedure LoadFromReader(Reader: TStringListReader); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    function getText(Indent: string): string; virtual;
    procedure RectToStream(Stream: TStream; Rect: TRect);
    function getRectPosAsText(Indent: string; Rect: TRect; Pos: TPoint): string;
    function RectFromStream(Stream: TStream): TRect;
    procedure IntegerToStream(Stream: TStream; i: Integer);
    function IntegerFromStream(Stream: TStream): Integer;
    procedure StringToStream(Stream: TStream; const s: string);
    function StringFromStream(Stream: TStream): string;
    function AppendToClipboard: string; virtual;
    procedure CreateFromClipboard(var ClipboardStr: string); virtual;
    procedure SetRctList(X1, Y1, X2, Y2: Integer); virtual;
    procedure setList(aList: TStrList); virtual;
  public
    Kind: byte;
    text: string;
    rct: TRect;
    Next: TStrElement;
    prev: TStrElement;
    list: TStrList;
    textPos: TPoint;
    constructor Create(aList: TStrList);
    function getHeadHeight: Integer; virtual;
    procedure SetRct(X1, Y1, X2, Y2: Integer);
    procedure ResizeList(x, y: Integer);
    procedure setRightList(Right: Integer);
    function getStatementFromKind(aKind: byte; const aList: TStrList; aParent: TStrElement): TStrElement;
    function getStatementFromReader(Reader: TStringListReader; const aList: TStrList; aParent: TStrElement): TStrElement;
    function getLineHeight: Integer;
    function getDefaultRectWidth: Integer;
    function getLines: Integer;
    function asString: string; virtual;
    function getKind: string;
    function getMaxDelta: Integer;
    procedure debug; virtual;
    procedure debug1;
    procedure Collapse; virtual;
    procedure CollapseCase; virtual;
  end;

  TStrStatement = class(TStrElement)
    constructor Create(aList: TStrList);
    destructor Destroy; override;
    function asString: string; override;
    procedure LoadFromReader(Reader: TStringListReader); override;
    procedure debug; override;
  end;

  TStrIf = class(TStrElement)
  private
    percent: real; // then-width to else-width
    procedure Draw; override;
    procedure DrawContent(x, y: Integer); override;
    procedure MoveRight(w: Integer); override;
    procedure MoveDown(h: Integer); override;
    procedure Resize(x, y: Integer); override;
    procedure setRight(Right: Integer); override;
    procedure setBottom(b: Integer); override;
    procedure LoadFromStream(Stream: TStream; Version: byte); override;
    procedure LoadFromReader(Reader: TStringListReader); override;
    procedure SaveToStream(Stream: TStream); override;
    function getText(Indent: string): string; override;
    function AppendToClipboard: string; override;
    procedure CreateFromClipboard(var ClipboardStr: string); override;
    procedure setTextPos;
    procedure setList(aList: TStrList); override;
  public
    then_elem: TStrElement;
    else_elem: TStrElement;
    constructor Create(aList: TStrList);
    constructor createStructogram(aList: TStrList; dummy: Boolean = True);
    destructor Destroy; override;
    function getHeadHeight: Integer; override;
    function asString: string; override;
    procedure debug; override;
    procedure Collapse; override;
  end;

  TStrWhile = class(TStrElement)
  private
    procedure Draw; override;
    procedure DrawContent(x, y: Integer); override;
    procedure MoveRight(w: Integer); override;
    procedure MoveDown(h: Integer); override;
    procedure Resize(x, y: Integer); override;
    procedure setRight(Right: Integer); override;
    procedure setBottom(b: Integer); override;
    procedure LoadFromStream(Stream: TStream; Version: byte); override;
    procedure LoadFromReader(Reader: TStringListReader); override;
    procedure SaveToStream(Stream: TStream); override;
    function getText(Indent: string): string; override;
    function AppendToClipboard: string; override;
    procedure CreateFromClipboard(var ClipboardStr: string); override;
    procedure setList(aList: TStrList); override;
  public
    do_elem: TStrElement;
    constructor Create(aList: TStrList);
    constructor createStructogram(aList: TStrList; dummy: Boolean = True);
    destructor Destroy; override;
    function getHeadHeight: Integer; override;
    function asString: string; override;
    procedure debug; override;
    procedure Collapse; override;
  end;

  TStrDoWhile = class(TStrWhile)
  private
    procedure Draw; override;
    procedure DrawContent(x, y: Integer); override;
    procedure Resize(x, y: Integer); override;
  public
    constructor Create(aList: TStrList);
    constructor createStructogram(aList: TStrList; dummy: Boolean = True);
    procedure setBottom(b: Integer); override;
    function getHeadHeight: Integer; override;
    function asString: string; override;
    procedure debug; override;
  end;

  TStrFor = class(TStrWhile)
  private
  public
    constructor Create(aList: TStrList);
    constructor createStructogram(aList: TStrList; dummy: Boolean = True);
    function asString: string; override;
    procedure debug; override;
  end;

  TStrCase = class(TStrElement)
  private
    procedure Draw; override;
    procedure DrawRightBottom; override;
    procedure DrawLeftBottom; override;
    function getText(Indent: string): string; override;
  public
    constructor Create(aList: TStrList);
    function asString: string; override;
    procedure debug; override;
  end;

  TStrSwitch = class(TStrElement)
  private
    percent: real; // then-width to else-width
    procedure Draw; override;
    procedure DrawContent(x, y: Integer); override;
    procedure MoveRight(w: Integer); override;
    procedure MoveDown(h: Integer); override;
    procedure Resize(x, y: Integer); override;
    procedure setRight(Right: Integer); override;
    procedure setBottom(b: Integer); override;
    procedure LoadFromStream(Stream: TStream; Version: byte); override;
    procedure LoadFromReader(Reader: TStringListReader); override;
    procedure SaveToStream(Stream: TStream); override;
    function getText(Indent: string): string; override;
    function AppendToClipboard: string; override;
    procedure CreateFromClipboard(var ClipboardStr: string); override;
    procedure setTextPos;
    procedure setList(aList: TStrList); override;
    procedure AdjustCaseElems(i: Integer);
  public
    case_elems: array of TStrElement;  // SetLength, Length, High, Low
    constructor Create(aList: TStrList);
    constructor createStructogram(aList: TStrList; dummy: Boolean = True);
    destructor Destroy; override;
    function getHeadHeight: Integer; override;
    function asString: string; override;
    procedure debug; override;
    procedure Collapse; override;
  end;

  { example debug of a switch element

    TStrSwitch Kind = 6 Text= cases rct(0, 0, 300, 125)

    CASE 0
    TStrListHead Kind=8 Text=case 0 head rct(0, 25, 75, 125)
    TStrCase Kind = 9 Text= case A rct(0, 25, 75, 50)
    StrStatement Kind=1 Text=A rct(0, 50, 75, 75)
    StrStatement Kind=1 Text=X rct(0, 75, 75, 100)
    StrStatement Kind=1 Text=Y rct(0, 100, 75, 125)
    CASE 0 END

    CASE 1
    TStrListHead Kind=8 Text=case 1 head rct(75, 25, 75, 125)
    TStrCase Kind = 9 Text= case B rct(75, 25, 75, 50)
    StrStatement Kind=1 Text=B rct(75, 50, 75, 75)
    StrStatement Kind=1 Text=W rct(75, 75, 75, 125)
    CASE 1 END

    CASE 2
    TStrListHead Kind=8 Text=case 2 head rct(150, 25, 75, 125)
    TStrCase Kind = 9 Text= case C rct(150, 25, 75, 50)
    StrStatement Kind=1 Text=B rct(150, 50, 75, 125)
    CASE 2 END

    CASE 3
    TStrListHead Kind=8 Text=case 3 head rct(225, 25, 75, 125)
    TStrCase Kind = 9 Text= else rct(225, 25, 75, 50)
    StrStatement Kind=1 Text=D rct(225, 50, 75, 125)
    CASE 3 END

  }

  TStrSubprogram = class(TStrElement)
  private
    procedure Draw; override;
    procedure Resize(x, y: Integer); override;
    function getText(Indent: string): string; override;
    procedure LoadFromReader(Reader: TStringListReader); override;
  public
    constructor Create(aList: TStrList);
    function getHeadHeight: Integer; override;
    function asString: string; override;
    procedure debug; override;
  end;

  TStrBreak = class(TStrElement)
  private
    procedure Draw; override;
    procedure Resize(x, y: Integer); override;
    procedure LoadFromReader(Reader: TStringListReader); override;
    function getText(Indent: string): string; override;
  public
    constructor Create(aList: TStrList);
    function getHeadHeight: Integer; override;
    function asString: string; override;
    procedure debug; override;
  end;

  // head of a list of statements as part of a statement, used in in If/While/Do/Switch...
  TStrListHead = class(TStrElement)
  private
    procedure SetRctList(X1, Y1, X2, Y2: Integer); override;
    procedure setList(aList: TStrList); override;
  public
    Parent: TStrElement;
    constructor Create(aList: TStrList; aParent: TStrElement);
    constructor createStructogram(aList: TStrList; aParent: TStrElement; Dummy: Boolean = True);
    procedure Resize(x, y: Integer); override;
    destructor Destroy; override;
    function asString: string; override;
    procedure debug; override;
    procedure Collapse; override;
    procedure CollapseCase; override;
  end;

  TListImage = class;

  // a whole structure without Algorithm
  TStrList = class(TStrElement)
  private
    BlackAndWhite: boolean;
    procedure Draw; override;
    procedure Resize(x, y: Integer); override;
    procedure SetRctList(X1, Y1, X2, Y2: Integer); override;
  public
    LoadError: Boolean;
    SwitchWithCaseLine: Boolean;
    rctList: TRect;
    LineHeight: Integer;
    Image: TListImage;
    Canvas: TCanvas;
    PuzzleMode: Integer;
    DontMove: Boolean;
    SL: TStringList;
    nr: Integer;
    dirty: Boolean;
    constructor Create(ScrollBox: TScrollBox; Mode: Integer; Font: TFont);
    destructor Destroy; override;
    procedure PaintShadow;
    procedure Paint; virtual;
    procedure SetColors;
    procedure Print;
    procedure ResizeAll; virtual;
    procedure LoadFromStream(Stream: TStream; Version: byte); override;
    procedure LoadFromReader(Reader: TStringListReader); override;
    procedure SaveToStream(Stream: TStream); override;
    function getText(indent: string): string; override;
    function getRectPos(Indent: string): string;
    procedure deleteElem(elem: TStrElement);
    function getWidth: Integer;
    function getHeight: Integer;
    procedure insert(at, elem: TStrElement);

    procedure getWidthHeigthOfText(const aText: string; var w, h: Integer);
    function getWidthOfOneLine(const aText: string): Integer;
    function getWidthOfLines(const aText: string): Integer;
    procedure setLineHeight;
    function asString: string; override;
    procedure debug; override;
    procedure setList(aList: TStrList); override;
    procedure setPuzzleMode(Mode: Integer);
    procedure setFont(Font: TFont);
    procedure setBlackAndWhite(value: boolean);
    procedure Collapse; override;
  end;

  // a whole structure, inherited form TStrList
  TStrAlgorithm = class(TStrList)
  private
    procedure Resize(x, y: Integer); override;
  public
    constructor Create(ScrollBox: TScrollBox; Mode: Integer; Font: TFont);
    function getAlgorithmName: string;
    function asString: string; override;
    procedure debug; override;
  end;

  TListImage = class (TImage)
  public
    StrList: TStrList;
    // the constructor in TImage is not overload
    constructor Create(Scrollbox: TScrollBox; List: TStrList); reintroduce;
  end;


implementation

uses SysUtils, Printers, Math, Themes, System.UITypes, System.Types,
     frmMessages, uCommonFunctions, UUtils, UConfiguration;

const
  DO_LEFT = 22;                   { Default left margin of do-element }
  DO_BREAK = 15;
  DO_SUB = 16;
  SEP  = #254;                    { Separator of commands }
  TERM = #255;                    { Terminator of commands }

  RECT_WIDTH = 75;                { Minimal width of a rectangle }
  TOP_BOTTOM = 4;                 { Default top/bottom margin of element }

constructor TStringListReader.Create(FileName: string);
begin
  SL:= TStringList.Create;
  nr:= 0;
  try
    SL.LoadFromFile(FileName);
  except on e: Exception do
    ErrorMsg(e.Message);
  end;
end;

function TStringListReader.nextLineIndent: Integer;
  var s: string; p: Integer;
begin
  if nr < SL.Count - 1 then begin
    s:= SL[nr+1];
    p:= 1;
    if s <> '' then
      while s[p] = ' ' do
        Inc(p);
    Result:= p - 1;
  end else
    Result:= 0;
end;

procedure TStringListReader.ReadLine;
  var line: string;
      p, q: Integer;

  function getInt: Integer;
    var p: Integer;
  begin
    p:= pos(' ', val);
    if p > 1 then begin
      Result:= StrToInt(Copy(val, 1, p-1));
      Delete(val, 1, p)
    end else
      Result:= 0;
  end;

begin
  Kind:= Ord(nsStatement);
  Text:= '';
  aRect:= Rect(0, 0, 0, 0);
  Point.X:= 0;
  Point.Y:= 0;
  line:= '';
  IndentAsInt:= 0;
  key:= '';
  val:= '';

  Inc(nr);
  while (nr < SL.Count) and (Trim(SL[nr]) = '') do
    Inc(nr);

  if nr < SL.Count then begin
    line:= SL[nr];
    q:= 1;
    if line <> '' then
      while line[q] = ' ' do
        Inc(q);
    IndentAsInt:= q - 1;
    line:= UnhideCrLf(Trim(line));
    //dline:= line;
  end;

  p:= Length(line);
  while (p > 0) and (line[p] <> '|') do
    Dec(p);
  if p > 0 then begin
    val:= Copy(line, p + 1, Length(line)) + ' ';
    aRect.Left:= getInt;
    aRect.Top:= getInt;
    aRect.Right:= getInt;
    aRect.Bottom:= getInt;
    Point.x:= getInt;
    Point.y:= getInt;
  end;

  Text:= Copy(line, 1, p - 1);
  if Text = '' then begin
    q:= Pos(':', Line);
    if q > 0 then begin
      key:= Copy(line, 1, q - 1);
      val:= Copy(line, q + 2, Length(line));
      if (key <> '') and (val = '') then
        Kind:= getKind(key)
    end
  end else
    if Text[1] = '|' then
      Delete(Text, 1, 1);
end;

function TStringListReader.getKind(Kind: string): byte;
begin
  if Kind = 'Algorithm'  then Result:= Ord(nsAlgorithm) else
  if Kind = 'if'         then Result:= Ord(nsIf) else
  if Kind = 'while'      then Result:= Ord(nsWhile) else
  if Kind = 'do while'   then Result:= Ord(nsDoWhile) else
  if Kind = 'for'        then Result:= Ord(nsFor) else
  if Kind = 'switch'     then Result:= Ord(nsSwitch) else
  if Kind = 'subprogram' then Result:= Ord(nsSubprogram) else
  if Kind = 'listhead'   then Result:= Ord(nsListHead) else
  if Kind = 'case'       then Result:= Ord(nsCase) else
  if Kind = 'break'      then Result:= Ord(nsBreak) else
  if Kind = 'list'       then Result:= Ord(nsList) else
                              Result:= Ord(nsStatement);
end;

procedure TStringListReader.LineBack;
begin
  Dec(nr);
end;

destructor TStringListReader.destroy;
begin
  FreeAndNil(SL);
end;

(*********************************************************************************)
(*                                      ELEMENT                                  *)
(*********************************************************************************)

constructor TStrElement.Create(aList: TStrList);
begin
  kind:= 0;
  text:= '';
  Next:= nil;
  prev:= nil;
  Self.list:= aList;
end;

procedure TStrElement.DrawCircle(x, y, h: Integer);
begin
  with list.Canvas do begin
    Ellipse(x - h, y - h, x + h, y + h);
    MoveTo(x - h, y + h);
    LineTo(x + h, y -h);
  end;
end;

procedure TStrElement.DrawLines(x, y, line_height: Integer);
  var s, s1: string; p: Integer; BrushColor: TColor;
begin
  BrushColor:= list.Canvas.Brush.Color;
  list.Canvas.Brush.Style:= bsClear;
  s:= text;
  p:= Pos(#13#10, s);
  while p > 0 do begin
    s1:= Copy(s, 1, p-1);
    Delete(s, 1, p+1);
    list.Canvas.TextOut(x, y, s1);
    y:= y + line_height;
    p:= Pos(#13#10, s);
  end;
  if s <> '' then list.Canvas.TextOut(x, y, s);
  list.Canvas.Brush.Style:= bsSolid;
  list.Canvas.Brush.Color:= BrushColor;
end;

procedure TStrElement.DrawLinesRight(x, y, line_height: Integer);
  var s, s1: string; p: Integer; BrushColor: TColor;
begin
  BrushColor:= list.Canvas.Brush.Color;
  list.Canvas.Brush.Style:= bsClear;
  s:= text;
  p:= Pos(#13#10, s);
  while p > 0 do begin
    s1:= Copy(s, 1, p-1);
    Delete(s, 1, p+1);
    x:= rct.Right - list.Canvas.TextWidth(s1) -  LEFT_RIGHT div 2;
    list.Canvas.TextOut(x, y, s1);
    y:= y + line_height;
    p:= Pos(#13#10, s);
  end;
  if s <> '' then begin
    x:= rct.Right - list.Canvas.TextWidth(s) -  LEFT_RIGHT div 2;
    list.Canvas.TextOut(x, y, s);
  end;
  list.Canvas.Brush.Style:= bsSolid;
  list.Canvas.Brush.Color:= BrushColor;
end;

procedure TStrElement.DrawCenteredLines(center, y: Integer; percent: real);
  var s, s1: string; x, w, p: Integer; BrushColor: TColor;
begin
  list.Canvas.Rectangle(rct.Left, rct.top, rct.Right+1, rct.bottom+1);
  BrushColor:= list.Canvas.Brush.Color;
  list.Canvas.Brush.Style:= bsClear;
  s:= text;
  y:= textPos.Y;
  p:= Pos(#13#10, s);
  while p > 0 do begin
    s1:= Copy(s, 1, p-1);
    Delete(s, 1, p+1);
    w:= round(percent * list.getWidthOfOneLine(s1));
    x:= center - w;
    list.Canvas.TextOut(x, y, s1);
    y:= y + list.LineHeight;
    p:= Pos(#13#10, s);
  end;
  if s <> '' then begin
    w:= round(percent * list.getWidthOfOneLine(s));
    x:= center - w;
    list.Canvas.TextOut(x, y, s);
  end;
  list.Canvas.Brush.Style:= bsSolid;
  list.Canvas.Brush.Color:= BrushColor;
end;

procedure TStrElement.DrawContent(x, y: Integer);
  var h: Integer;
begin
  with list.Canvas do
    if text = '' then begin
      x:= (rct.Left + rct.Right + 1) div 2;
      y:= (rct.top + rct.bottom + 1) div 2;
      h:= (getLineHeight - 10) div 2;
      DrawCircle(x, y, h);
    end else
      DrawLines(x, y, list.LineHeight);
end;

procedure TStrElement.Draw;
begin
  with list.Canvas do begin
    Rectangle(rct.Left, rct.top, rct.Right+1, rct.bottom+1);
    DrawContent(textPos.X, textPos.Y);
  end;
end;

procedure TStrElement.DrawRightBottom;
begin
end;

procedure TStrElement.DrawLeftBottom;
begin
end;

procedure TStrElement.MoveRight(w: Integer);
begin
  rct.Left:= rct.Left + w;
  rct.Right:= rct.Right + w;
  textPos.x:= textPos.x + w;
end;

procedure TStrElement.MoveDown(h: Integer);
begin
  rct.top:= rct.top + h;
  rct.bottom:= rct.bottom + h;
  textPos.y:= textPos.y + h;
end;

procedure TStrElement.MoveRightList(b: Integer);
  var tmp: TStrElement;
begin
  MoveRight(b);
  tmp:= Next;
  while tmp <> nil do begin
    tmp.MoveRight(b);
    tmp:= tmp.Next;
  end;
end;

procedure TStrElement.MoveDownList(h: Integer);
  var tmp: TStrElement;
begin
  MoveDown(h);
  tmp:= Next;
  while tmp <> nil do begin
    tmp.MoveDown(h);
    tmp:= tmp.Next;
  end;
end;

procedure TStrElement.Resize(x, y: Integer);
  var w, h: Integer;
begin
  list.getWidthHeigthOfText(text, w, h);
  if list.PuzzleMode = 1
    then SetRct(x, y, x + rct.Right-rct.Left, y + rct.Bottom-rct.top)
  else if list.PuzzleMode = 2 then
    SetRct(x, y, x + rct.Right-rct.Left, y + h)
  else
    SetRct(x, y, x + w, y + h);
end;

procedure TStrElement.setRight(Right: Integer);
begin
  rct.Right:= Right;
end;

procedure TStrElement.setBottomList(b: Integer);
  var tmp: TStrElement;
begin
  setBottom(b);
  tmp:= Next;
  if Assigned(tmp) then begin
    while tmp.Next <> nil do
      tmp:= tmp.Next;
    tmp.setBottom(b);
  end;
end;

procedure TStrElement.setBottom(b: Integer);
begin
  rct.Bottom:= b;
end;

procedure TStrElement.ResizeList(x, y: Integer);
  var x1, y1: Integer; tmp: TStrElement; k1: byte;
begin
  // calculate width
  Resize(x, y); // Listhead  or StrList
  k1 := Ord(nsAlgorithm);
  if Kind = k1
    then x1:= getDefaultRectWidth + list.Canvas.Font.Size + 2*LEFT_RIGHT
    else x1:= Self.rct.Right;
  y1:= Self.rct.Bottom;
  tmp:= Next;
  while tmp <> nil do begin
    tmp.Resize(x, y1);
    x1:= Max(x1, tmp.rct.Right);
    y1:= tmp.rct.Bottom;
    tmp:= tmp.Next;
  end;
  // set width
  setRightList(x1);
  SetRctList(x, y, x1, y1);
end;

procedure TStrElement.setRightList(Right: Integer);
  var tmp: TStrElement;
begin
  setRight(Right);
  tmp:= Next;
  while tmp <> nil do begin
    tmp.setRight(Right);
    tmp:= tmp.Next
  end;
  rct.Right:= Right;
end;

function TStrElement.getLineHeight: Integer;
begin
  Result:= list.LineHeight;
end;

function TStrElement.getDefaultRectWidth: Integer;
begin
  Result:= round(RECT_WIDTH*(list.Canvas.Font.Size/12.0));
end;

function TStrElement.getLines: Integer;
  var p, n: Integer; s: string;
begin
  n:= 0;
  s:= text;
  p:= Pos(#13#10, s);
  while p > 0 do begin
    Delete(s, 1, p+1);
    Inc(n);
    p:= Pos(#13#10, s);
  end;
  if s <> '' then Inc(n);
  if n = 0 then n:= 1;
  Result:= n;
end;

function TStrElement.getHeadHeight: Integer;
begin
  Result:= getLineHeight;
end;

procedure TStrElement.LoadFromStream(Stream: TStream; Version: byte);
  var i: byte; s: ShortString;
begin
  if Version >= $0E then begin
    Text:= StringFromStream(Stream);
    rct:= RectFromStream(Stream);
    TextPos.X:= IntegerFromStream(Stream);
    TextPos.Y:= IntegerFromStream(Stream);
  end else begin
    Stream.Read(i, 1);
    setLength(s, i);
    Stream.Read(s[1], i);
    Text:= string(s);
  end;
end;

procedure TStrElement.LoadFromReader(Reader: TStringListReader);
begin
  Reader.ReadLine;
  Text:= Reader.Text;
  rct:= Reader.aRect;
  TextPos:= Reader.Point;
end;

procedure TStrElement.SaveToStream(Stream: TStream);
begin
  Stream.Write(kind, 1);
  StringToStream(Stream, Text);
  RectToStream(Stream, rct);
  IntegerToStream(Stream, TextPos.X);
  IntegerToStream(Stream, TextPos.Y);
end;

function TStrElement.getText(Indent: string): string;
  var s: string;
begin
  s:= HideCrLf(Text);
  if (s <> '') and (s[1] = ' ') then
    s:= '|' + s;
  Result:= Indent + s + getRectPosAsText(indent, rct, TextPos) + CrLf;
end;

procedure TStrElement.RectToStream(Stream: TStream; Rect: TRect);
begin
  IntegerToStream(Stream, Rect.Left);
  IntegerToStream(Stream, Rect.Top);
  IntegerToStream(Stream, Rect.Right);
  IntegerToStream(Stream, Rect.Bottom);
end;

function TStrElement.getRectPosAsText(Indent: string; Rect: TRect; Pos: TPoint): string;
begin
  Result:= '|' +
           IntToStr(Rect.Left) + ' ' +
           IntTostr(Rect.Top) + ' '  +
           IntToStr(Rect.Right) + ' ' +
           IntToStr(Rect.Bottom) + ' ' +
           IntToStr(Pos.x) + ' ' +
           IntToStr(Pos.y);
end;

function TStrElement.RectFromStream(Stream: TStream): TRect;
begin
  Result.Left:= IntegerFromStream(Stream);
  Result.Top:= IntegerFromStream(Stream);
  Result.Right:= IntegerFromStream(Stream);
  Result.Bottom:= IntegerFromStream(Stream);
end;

procedure TStrElement.IntegerToStream(Stream: TStream; i: Integer);
  var si: SmallInt;
begin
  si:= SmallInt(i);
  Stream.Write(si, 2);
end;

function TStrElement.IntegerFromStream(Stream: TStream): Integer;
begin
  Result:= 0;
  Stream.read(Result, 2);
end;

procedure TStrElement.StringToStream(Stream: TStream; const s: string);
  var Size: LongInt;
begin
  Size:= Length(s)*SizeOf(Char);
  stream.Write(Size, SizeOf(Size));
  stream.Write(Pointer(s)^, Size);
end;

function TStrElement.StringFromStream(Stream: TStream): string;
  var Size: LongInt;
begin
  stream.read(Size, SizeOf(Size));
  setLength(Result, Size div SizeOf(Char));
  stream.read(Pointer(Result)^, Size);
end;

function TStrElement.AppendToClipboard: string;
begin
  Result:= chr(kind) + text + SEP;
end;

procedure TStrElement.CreateFromClipboard(var ClipboardStr: string);
var
  index: Byte;
begin
  index:= Pos(SEP, ClipboardStr);
  text:= Copy(ClipboardStr, 2, index-2);
  Delete(ClipboardStr, 1, index);
end;

procedure TStrElement.SetRct(X1, Y1, X2, Y2: Integer);
begin
  rct.Left:= X1;
  rct.top:= Y1;
  rct.Right:= X2;
  rct.bottom:= Y2;
  textPos.X:= rct.Left + LEFT_RIGHT div 2;
  textPos.Y:= rct.top + TOP_BOTTOM div 2;
end;

procedure TStrElement.SetRctList(X1, Y1, X2, Y2: Integer);
begin
end;

procedure TStrElement.SetList(aList: TStrList);
begin
  Self.List:= aList;
end;

function TStrElement.getStatementFromKind(aKind: byte; const aList: TStrList; aParent: TStrElement): TStrElement;
begin
  case aKind of
    ord(nsAlgorithm)  : Result:= nil; //TStrAlgorithm.create(aList);
    ord(nsStatement)  : Result:= TStrStatement.Create(aList);
    ord(nsIf)         : Result:= TStrIf.Create(aList);
    ord(nsWhile)      : Result:= TStrWhile.Create(aList);
    ord(nsDoWhile)    : Result:= TStrDoWhile.Create(aList);
    ord(nsFor)        : Result:= TStrFor.Create(aList);
    ord(nsSwitch)     : Result:= TStrSwitch.Create(aList);
    ord(nsSubprogram) : Result:= TStrSubprogram.Create(aList);
    ord(nsListhead)   : Result:= TStrListHead.Create(aList, aParent);
    ord(nsCase)       : Result:= nil; // TStrCase.create(aList);
    ord(nsBreak)      : Result:= TStrBreak.Create(aList);
    else                Result:= nil;
  end;
  if Result = nil then
    list.LoadError:= True;
end;

function TStrElement.getStatementFromReader(Reader: TStringListReader; const aList: TStrList; aParent: TStrElement): TStrElement;
begin
  case Reader.Kind of
    ord(nsStatement)  : Result:= TStrStatement.Create(aList);
    ord(nsIf)         : Result:= TStrIf.Create(aList);
    ord(nsWhile)      : Result:= TStrWhile.Create(aList);
    ord(nsDoWhile)    : Result:= TStrDoWhile.Create(aList);
    ord(nsFor)        : Result:= TStrFor.Create(aList);
    ord(nsSwitch)     : Result:= TStrSwitch.Create(aList);
    ord(nsSubprogram) : Result:= TStrSubprogram.Create(aList);
    ord(nsListhead)   : Result:= TStrListHead.Create(aList, aParent);
    ord(nsBreak)      : Result:= TStrBreak.Create(aList);
    else                Result:= TStrStatement.Create(aList);
  end;
end;

function TStrElement.asString: string;
begin
  Result:= Text;
end;

function TStrElement.getKind: string;
begin
  case Kind of
    Ord(nsAlgorithm) : Result:= 'Algorithm';
    ord(nsStatement) : Result:= 'Statement';
    ord(nsIf)        : Result:= 'if';
    ord(nsWhile)     : Result:= 'while';
    ord(nsDoWhile)   : Result:= 'do while';
    ord(nsFor)       : Result:= 'for';
    ord(nsSwitch)    : Result:= 'switch';
    ord(nsSubprogram): Result:= 'subprogram';
    ord(nsListhead)  : Result:= 'list head';
    ord(nsCase)      : Result:= 'case';
    ord(nsBreak)     : Result:= 'break';
    else               Result:= 'List';
  end;
end;

function TStrElement.getMaxDelta: Integer;
begin
  Result:= Min((rct.bottom - rct.top) div 2, getHeadHeight);
end;

procedure TStrElement.debug;
  var s: string;
begin
  s:= 'StrElement Kind = ' + IntToStr(kind) + ' Text= ' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
  if Assigned(prev) and (prev.Next <> TStrElement(Self)) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> TStrElement(Self)) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
end;

procedure TStrElement.debug1;
  var s: string;
begin
  s:= 'StrElement Kind = ' + IntToStr(kind) + ' Text= ' + text;
  if Assigned(prev) and (prev.Next <> TStrElement(Self)) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> TStrElement(Self)) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
end;

procedure TStrElement.Collapse;
begin
end;

procedure TStrElement.CollapseCase;
begin
end;

(*********************************************************************************)
(*                                      Statement                                *)
(*********************************************************************************)

constructor TStrStatement.Create(aList: TStrList);
begin
  inherited Create(aList);
  kind:= Ord(nsStatement);
end;

destructor TStrStatement.destroy;
begin
  inherited;
end;

function TStrStatement.asString: string;
begin
  Result:= Text;
end;

procedure TStrStatement.debug;
  var s: string;
begin
  s:= 'StrStatement Kind=' + IntToStr(kind) + ' Text=' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
  if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
end;

procedure TStrStatement.LoadFromReader(Reader: TStringListReader);
begin
  text:= Reader.Text;
  rct:= Reader.aRect;
  textPos:= Reader.Point;
end;

(*********************************************************************************)
(*                                      IF                                       *)
(*********************************************************************************)

constructor TStrIf.Create(aList: TStrList);
begin
  inherited Create(aList);
  kind:= ord(nsIf);
  then_elem:= TStrListHead.Create(aList, Self);
  then_elem.text:= 'then list head';
  else_elem:= TStrListHead.Create(aList, Self);
  else_elem.text:= 'else list head';
end;

constructor TStrIf.createStructogram(aList: TStrList; dummy: Boolean = True);
begin
  inherited Create(aList);
  kind:= ord(nsIf);
  then_elem:= TStrListHead.CreateStructogram(aList, Self);
  then_elem.text:= 'then list head';
  else_elem:= TStrListHead.CreateStructogram(aList, Self);
  else_elem.text:= 'else list head';
end;

destructor TStrIf.Destroy;
begin
  inherited;
  FreeAndNil(then_elem);
  FreeAndNil(else_elem);
end;

procedure TStrIf.Draw;
  var tmp: TStrElement;
      uh, h, w: Integer;
      BrushColor: TColor;
begin
  with list.Canvas do begin
    if text = ''
      then inherited Draw
      else drawCenteredLines(then_elem.rct.Right, textPos.Y, percent);
    uh:= then_elem.rct.Top - rct.Top;
    MoveTo(rct.Left, rct.top+1);
    LineTo(then_elem.rct.Right-1, rct.top + uh);
    MoveTo(rct.Right, rct.top+1);
    LineTo(else_elem.rct.Left+1, rct.top + uh);

    MoveTo(rct.Left, rct.top + uh);
    LineTo(rct.Right, rct.top + uh);
    MoveTo(then_elem.rct.Right, rct.top + uh + 1);
    LineTo(then_elem.rct.Right, rct.Bottom);

    Font.Size:= Font.Size - 2;
    BrushColor:= Brush.Color;
    Brush.Style:= bsClear;
    h:= then_elem.rct.Top - getLineHeight + TOP_BOTTOM;
    w:= TextWidth(GuiPyLanguageOptions.No);
    TextOut(rct.Left+4, h+4, GuiPyLanguageOptions.Yes);
    TextOut(rct.Right-w-2, h+4, GuiPyLanguageOptions.No);
    Brush.Style:= bsSolid;
    Brush.Color:= BrushColor;
    Font.Size:= Font.Size + 2;

    tmp:= then_elem.Next;
    while tmp <> nil do begin
      tmp.Draw;
      tmp:= tmp.Next;
    end;

    tmp:= else_elem.Next;
    while tmp <> nil do begin
      tmp.Draw;
      tmp:= tmp.Next;
    end;
  end;
end;

procedure TStrIf.DrawContent(x, y: Integer);
  var h: Integer;
begin
  with list.Canvas do
    if text = '' then begin
      h:= getLineHeight;
      y:= rct.top + h div 2;
      h:= (h - 10) div 2;
      x:= then_elem.rct.Right;
      DrawCircle(x, y, h);
    end else
      DrawLines(x, y, list.LineHeight);
end;

procedure TStrIf.MoveRight(w: Integer);
  var tmp: TStrElement;
begin
  inherited MoveRight(w);    { move IF-rectangle and condition-text }
  tmp:= then_elem;
  while tmp <> nil do begin  { move all THEN-elements }
    tmp.MoveRight(w);
    tmp:= tmp.Next;
  end;
  tmp:= else_elem;
  while tmp <> nil do begin  { move all ELSE-elements }
    tmp.MoveRight(w);
    tmp:= tmp.Next;
  end;
end;

procedure TStrIf.MoveDown(h: Integer);
  var tmp: TStrElement;
begin
  inherited MoveDown(h);    { move IF-rectangle and condition-text }
  tmp:= then_elem;
  while tmp <> nil do begin  { move all THEN-elements }
    tmp.MoveDown(h);
    tmp:= tmp.Next;
  end;
  tmp:= else_elem;
  while tmp <> nil do begin  { move all ELSE-elements }
    tmp.MoveDown(h);
    tmp:= tmp.Next;
  end;
end;

procedure TStrIf.Resize(x, y: Integer);
  var b, w, d, h, wcondition, wb: Integer;
begin
  then_elem.ResizeList(x, y);
  else_elem.ResizeList(x, y);

  list.getWidthHeigthOfText(text, wcondition, h);
  // width of "if" is at least 1.5* witdh of condition
  wb:= Max(then_elem.rct.Right - then_elem.rct.Left +
           else_elem.rct.Right - else_elem.rct.Left, wcondition);
  if wb <= 1.5*wcondition then wb:= round(1.5*wcondition);
  w:= Max(wb, getDefaultRectWidth);

  SetRct(x, y, x + w, y + h);
  then_elem.ResizeList(x, y + h);
  else_elem.ResizeList(then_elem.rct.Right, y + h);
  b:= Max(then_elem.rct.Bottom, else_elem.rct.Bottom);
  if b > then_elem.rct.Bottom then
    then_elem.setBottomList(b);
  if b > else_elem.rct.Bottom then
    else_elem.setBottomList(b);
  SetRct(x, y, else_elem.rct.Right, b);

  // 1.5*condition_width > rct.width ?
  d:= wb - (rct.Right - rct.Left);
  if d > 0 then
    setRight(rct.Right + d);

  setTextPos;
end;

procedure TStrIf.setRight(Right: Integer);
  var r1, dr: Integer;
begin
  dr:= Right - rct.Right;
  r1:= dr div 2;
  then_elem.setRightList(then_elem.rct.Right + r1);
  else_elem.MoveRightList(r1);
  else_elem.setRightList(Right);
  rct.Right:= Right;
  setTextPos;
end;

procedure TStrIf.setBottom(b: Integer);
begin
  inherited setBottom(b);
  then_elem.setBottomList(b);
  else_elem.setBottomList(b);
end;

function TStrIf.getHeadHeight: Integer;
begin
  Result:= then_elem.rct.top - rct.top;
end;

procedure TStrIf.setTextPos;
  var w, h: Integer;
      dthen, dif: real;
begin
  dthen:= then_elem.rct.Right - then_elem.rct.Left;
  dif:= rct.Right - rct.Left;
  if dif = 0
    then percent:= dthen
    else percent:= dthen/dif;
  list.getWidthHeigthOfText(text, w, h);
  w:= round(percent * w);
  TextPos.x:= then_elem.rct.Right - w;
  TextPos.y:= rct.top;
end;

procedure TStrIf.setList(aList: TStrList);
begin
  inherited;
  then_elem.setList(aList);
  else_elem.setList(aList);
end;

procedure TStrIf.LoadFromStream(Stream: TStream; Version: byte);
  var current, elem: TStrElement;
      aKind, Count: Byte;
begin
  inherited LoadFromStream(Stream, Version);
  FreeAndNil(Next); {necessary for corrupted files !}
  Stream.Read(aKind, 1);  {overread aKind}
  then_elem.LoadFromStream(Stream, Version);
  FreeAndNil(then_elem.Next);
  current:= then_elem;
  Count:= Stream.Read(aKind, 1);
  while (Count = 1) and (aKind <> $FF) do begin
    elem:= getStatementFromKind(aKind, list, Self);
    if elem = nil then Exit;
    elem.LoadFromStream(Stream, Version);
    FreeAndNil(elem.Next);
    list.Insert(current, elem);
    current:= elem;
    Count:= Stream.Read(aKind, 1);
  end;
  if Count = 1 then begin
    Stream.Read(akind, 1);  {overread kind}
    else_elem.LoadFromStream(Stream, Version);
    FreeAndNil(else_elem.Next);
    current:= else_elem;
    Count:= Stream.Read(aKind, 1);
    while (Count = 1) and (aKind <> $FF) do begin
      elem:= getStatementFromKind(aKind, list, Self);
      if elem = nil then Exit;
      elem.LoadFromStream(Stream, Version);
      FreeAndNil(elem.Next);
      list.Insert(current, elem);
      current:= elem;
      Count:= Stream.Read(aKind, 1);
    end;
  end;
end;

procedure TStrIf.LoadFromReader(Reader: TStringListReader);
  var current, elem: TStrElement;
      myIndent: Integer;
begin
  inherited LoadFromReader(Reader); // condition
  myIndent:= Reader.IndentAsInt;
  then_elem.LoadFromReader(Reader);
  FreeAndNil(then_elem.Next); // don't use empty statement
  current:= then_elem;
  while Reader.nextLineIndent = myIndent do begin
    Reader.ReadLine;
    elem:= getStatementFromReader(Reader, list, Self);
    elem.LoadFromReader(Reader);
    list.Insert(current, elem);
    current:= elem;
  end;
  Reader.ReadLine; // else
  else_elem.LoadFromReader(Reader);
  FreeAndNil(else_elem.Next); // don't use empty statement
  current:= else_elem;
  while Reader.nextLineIndent = myIndent do begin
    Reader.ReadLine;
    elem:= getStatementFromReader(Reader, list, Self);
    elem.LoadFromReader(Reader);
    list.Insert(current, elem);
    current:= elem;
  end;
end;

procedure TStrIf.SaveToStream(Stream: TStream);
var
  tmp: TStrElement;
  tag: Byte;
begin
  inherited SaveToStream(Stream);
  tmp:= then_elem;
  while tmp <> nil do begin
    tmp.SaveToStream(Stream);
    tmp:= tmp.Next;
  end;
  tag:= $FF;
  Stream.Write(tag, 1);      {write end tag}
  tmp:= else_elem;
  while tmp <> nil do begin
    tmp.SaveToStream(Stream);
    tmp:= tmp.Next;
  end;
  tag:= $FF;
  Stream.Write(tag, 1);      {write end tag}
end;

function TStrIf.getText(Indent: string): string;
  var tmp: TStrElement;
begin
  Result:= Indent + 'if: ' + CrLf + inherited getText(Indent + '  ');
  tmp:= then_elem;
  while tmp <> nil do begin
    Result:= Result + tmp.getText(Indent + '  ');
    tmp:= tmp.Next;
  end;
  Result:= Result + Indent + 'else:' + CrLf;
  tmp:= else_elem;
  while tmp <> nil do begin
    Result:= Result + tmp.getText(Indent + '  ');
    tmp:= tmp.Next;
  end;
end;

function TStrIf.AppendToClipboard: string;
var
  tmp: TStrElement;
begin
  Result:= inherited AppendToClipboard;
  tmp:= then_elem;
  while tmp <> nil do begin
    Result:= Result + tmp.AppendToClipboard;
    tmp:= tmp.Next;
  end;
  Result:= Result + TERM + SEP;
  tmp:= else_elem;
  while tmp <> nil do begin
    Result:= Result + tmp.AppendToClipboard;
    tmp:= tmp.Next;
  end;
  Result:= Result + TERM + SEP;
end;

procedure TStrIf.CreateFromClipboard(var ClipboardStr: string);
var
  elem, tmp: TStrElement;
  aKind, index: Byte;
begin
  inherited CreateFromClipboard(ClipboardStr);

  tmp:= nil;
  aKind:= ord(ClipboardStr[1]);
  while aKind <> $FF do begin
    elem:= getStatementFromKind(aKind, list, Self);
    if elem = nil then Exit;
    elem.CreateFromClipboard(ClipboardStr);
    if tmp = nil then
      then_elem:= elem
    else begin
      tmp.Next:= elem;
      elem.prev:= tmp;
    end;
    tmp:= elem;
    aKind:= ord(ClipboardStr[1]);
  end;
  index:= Pos(SEP, ClipboardStr);
  Delete(ClipboardStr, 1, index);

  tmp:= nil;
  aKind:= ord(ClipboardStr[1]);
  while aKind <> $FF do begin
    elem:= getStatementFromKind(aKind, list, Self);
    if elem = nil then Exit;
    elem.CreateFromClipboard(ClipboardStr);
    if tmp = nil then
      else_elem:= elem
    else begin
      tmp.Next:= elem;
      elem.prev:= tmp;
    end;
    tmp:= elem;
    aKind:= ord(ClipboardStr[1]);
  end;
  index:= Pos(SEP, ClipboardStr);
  Delete(ClipboardStr, 1, index);
end;

function TStrIf.asString: string;
begin
  Result:= 'If(' + text + ',' + then_elem.asString + ',' + else_elem.asString + ')';
end;

procedure TStrIf.debug;
  var s: string;
begin
  s:= 'TStrIf Kind=' + IntToStr(kind) + ' Text=' + text +
     ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
   if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
  MessagesWindow.AddMessage('THEN');
  then_elem.debug;
  MessagesWindow.AddMessage('ELSE');
  else_elem.debug;
  MessagesWindow.AddMessage('IF END');
end;

procedure TStrIf.Collapse;
begin
  then_elem.Collapse;
  else_elem.Collapse;
end;

(*********************************************************************************)
(*                                     WHILE                                     *)
(*********************************************************************************)

constructor TStrWhile.Create(aList: TStrList);
begin
  inherited Create(aList);
  kind:= ord(nsWhile);
  do_elem:= TStrListHead.Create(aList, Self);
  do_elem.text:= 'while head';
end;

constructor TStrWhile.createStructogram(aList: TStrList; dummy: Boolean = True);
begin
  inherited Create(aList);
  kind:= ord(nsWhile);
  do_elem:= TStrListHead.CreateStructogram(aList, Self);
  do_elem.text:= 'while head';
end;

destructor TStrWhile.Destroy;
begin
  FreeAndNil(do_elem);
end;

procedure TStrWhile.Draw;
  var tmp: TStrElement;
begin
  with list.Canvas do begin
    inherited Draw;           { draw WHILE-rectangle and condition-text }
    MoveTo(do_elem.rct.Right, do_elem.rct.top);
    LineTo(do_elem.rct.Left, do_elem.rct.top);
    LineTo(do_elem.rct.Left, rct.bottom);
    tmp:= do_elem.Next;
    while tmp <> nil do begin
      tmp.Draw;
      tmp:= tmp.Next;
    end;
  end;
end;

procedure TStrWhile.DrawContent(x, y: Integer);
begin
  if text = '' then begin
    x := (Rct.Left + Rct.Right + 1) div 2;
    y := (Rct.Top + do_elem.Rct.Top + 1) div 2;
    DrawCircle(x, y, (GetLineHeight - 10) div 2);
  end else
    DrawLines(x, y, list.LineHeight);
end;

procedure TStrWhile.MoveRight(w: Integer);
  var tmp: TStrElement;
begin
  inherited MoveRight(w);    { move WHILE-rectangle and condition-text }
  tmp:= do_elem;
  while tmp <> nil do begin  { move all WHILE-elements }
    tmp.MoveRight(w);
    tmp:= tmp.Next;
  end;
end;

procedure TStrWhile.MoveDown(h: Integer);
  var tmp: TStrElement;
begin
  inherited MoveDown(h);    { move WHILE-rectangle and condition-text }
  tmp:= do_elem;
  while tmp <> nil do begin  { move all WHILE-elements }
    tmp.MoveDown(h);
    tmp:= tmp.Next;
  end;
end;

procedure TStrWhile.Resize(x, y: Integer);
  var w: Integer;
begin
  inherited Resize(x, y);
  do_elem.ResizeList(x + DO_LEFT, y + getLines*list.LineHeight);
  w:= Max(Self.rct.Right, do_elem.rct.Right);
  SetRct(x, y, w, do_elem.rct.Bottom);
  do_elem.setRightList(rct.Right);
end;

procedure TStrWhile.setRight(Right: Integer);
begin
  rct.Right:= Right;
  do_elem.setRightList(Right);
end;

procedure TStrWhile.setBottom(b: Integer);
begin
  inherited setBottom(b);
  do_elem.setBottomList(b);
end;

function TStrWhile.getHeadHeight: Integer;
begin
  Result:= do_elem.rct.top - rct.top;
end;

procedure TStrWhile.LoadFromStream(Stream: TStream; Version: byte);
var
  current, elem: TStrElement;
  aKind, Count: Byte;
begin
  inherited LoadFromStream(Stream, Version);
  FreeAndNil(Next); {necessary for corrupted files !}
  Stream.Read(aKind, 1);  {overread aKind}
  do_elem.LoadFromStream(Stream, Version);
  FreeAndNil(do_elem.Next); {necessary for corrupted files !}
  current:= do_elem;
  Count:= Stream.Read(aKind, 1);
  while (Count = 1) and (aKind <> $FF) do begin
    elem:= getStatementFromKind(aKind, list, Self);
    if elem = nil then Exit;
    elem.LoadFromStream(Stream, Version);
    FreeAndNil(elem.Next);
    list.Insert(current, elem);
    current:= elem;
    Count:= Stream.Read(aKind, 1);
  end;
end;

procedure TStrWhile.LoadFromReader(Reader: TStringListReader);
  var current, elem: TStrElement;
      myIndent: Integer;
begin
  inherited LoadFromReader(Reader);
  do_elem.LoadFromReader(Reader);
  FreeAndNil(do_elem.Next); // don't use empty statement
  current:= do_elem;
  myIndent:= Reader.IndentAsInt;
  while Reader.nextLineIndent = myIndent do begin
    Reader.ReadLine;
    elem:= getStatementFromReader(Reader, list, Self);
    elem.LoadFromReader(Reader);
    list.Insert(current, elem);
    current:= elem;
  end;
end;

procedure TStrWhile.SaveToStream(Stream: TStream);
var
  tmp: TStrElement;
  tag: Byte;
begin
  inherited SaveToStream(Stream);
  tmp:= do_elem;
  while tmp <> nil do begin
    tmp.SaveToStream(Stream);
    tmp:= tmp.Next;
  end;
  tag:= $FF;
  Stream.Write(tag, 1);      {write end tag}
end;

function TStrWhile.getText(Indent: string): string;
  var tmp: TStrElement;
begin
  Result:= Indent + getKind + ': ' + CrLf + inherited getText(Indent + '  ');
  tmp:= do_elem;
  while tmp <> nil do begin
    Result:= Result + tmp.getText(Indent + '  ');
    tmp:= tmp.Next;
  end;
end;

function TStrWhile.AppendToClipboard: string;
var
  tmp: TStrElement;
begin
  Result:= inherited AppendToClipboard;
  tmp:= do_elem;
  while tmp <> nil do begin
    Result:= Result + tmp.AppendToClipboard;
    tmp:= tmp.Next;
  end;                           // $FF
  Result:= Result + TERM + SEP;
end;

procedure TStrWhile.CreateFromClipboard(var ClipboardStr: string);
var
  elem, tmp: TStrElement;
  aKind, index: Byte;
begin
  inherited CreateFromClipboard(ClipboardStr);

  tmp:= nil;
  aKind:= ord(ClipboardStr[1]);
  while aKind <> $FF do begin
    elem:= getStatementFromKind(aKind, list, Self);
    if elem = nil then Exit;
    elem.CreateFromClipboard(ClipboardStr);
    if tmp = nil then
      do_elem:= elem
    else begin
      tmp.Next:= elem;
      elem.prev:= tmp;
    end;
    tmp:= elem;
    aKind:= ord(ClipboardStr[1]);
  end;
  index:= Pos(SEP, ClipboardStr);
  Delete(ClipboardStr, 1, index);
end;

procedure TStrWhile.setList(aList: TStrList);
begin
  inherited;
  do_elem.setList(aList);
end;

function TStrWhile.asString: string;
begin
  Result:= 'While(' + text + ',' + do_elem.asString + ')';
end;

procedure TStrWhile.debug;
  var s: string;
begin
  s:= 'TStrWhile Kind = ' + IntToStr(kind) + ' Text= ' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
  if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
  MessagesWindow.AddMessage('DO');
  do_elem.debug;
  MessagesWindow.AddMessage('WHILE END');
end;

procedure TStrWhile.Collapse;
begin
  do_elem.Collapse;
end;

(*********************************************************************************)
(*                                    Do-While                                   *)
(*********************************************************************************)

constructor TStrDoWhile.Create(aList: TStrList);
begin
  inherited Create(aList);
  kind:= ord(nsDoWhile);
  do_elem.text:= 'do-while head';
end;

constructor TStrDoWhile.createStructogram(aList: TStrList; dummy: Boolean = True);
begin
  inherited createStructogram(aList);
  kind:= ord(nsDoWhile);
  do_elem.text:= 'do-while head';
end;

procedure TStrDoWhile.Draw;
  var tmp: TStrElement;
begin
  with list.Canvas do begin
    Rectangle(rct.Left, rct.top, rct.Right+1, rct.bottom+1);
    DrawContent(textPos.x, textPos.y);

    MoveTo(do_elem.rct.Left, do_elem.rct.top);
    LineTo(do_elem.rct.Left, do_elem.rct.bottom);
    LineTo(do_elem.rct.Right,do_elem.rct.bottom);
    tmp:= do_elem.Next;
    while tmp <> nil do begin
      tmp.Draw;
      tmp:= tmp.Next;
    end;
  end;
end;

procedure TStrDoWhile.DrawContent(x, y: Integer);
begin
  if Text = '' then
  begin
    x := (Rct.Left + Rct.Right + 1) div 2;
    y := (Rct.Bottom + do_elem.Rct.Bottom + 1) div 2;
    DrawCircle(x, y, (GetLineHeight - 10) div 2);
  end
  else
    DrawLines(x, y, GetLineHeight);
end;

function TStrDoWhile.getHeadHeight: Integer; 
begin
  Result:= rct.top - do_elem.rct.top;
end;

procedure TStrDoWhile.Resize(x, y: Integer);
  var x1, y1, w, h: Integer;
begin
  do_elem.ResizeList(x + DO_LEFT, y);

  y1:= do_elem.rct.Bottom;
  list.getWidthHeigthOfText(text, w, h);
  x1:= Max(w, do_elem.rct.Right - do_elem.rct.Left);
  SetRct(x, y, x + x1, y1 + h);
  TextPos.y:= y1 + TOP_BOTTOM div 2;

  x1:= Max(Self.rct.Right, do_elem.rct.Right);
  do_elem.setRightList(x1);
  rct.Right:= x1;
end;

procedure TStrDoWhile.setBottom(b: Integer);
begin
  rct.Bottom:= b;
  //do_elem.setBottomList(b);
end;

function TStrDoWhile.asString: string;
begin
  Result:= 'DoWhile(' + do_elem.asString + ',' + text + ')';
end;

procedure TStrDoWhile.debug;
  var s: string;
begin
  s:= 'TStrDoWhile Kind = ' + IntToStr(kind) + ' Text= ' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
   if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
  MessagesWindow.AddMessage('DO WHILE');
  MessagesWindow.AddMessage('');
  do_elem.debug;
  MessagesWindow.AddMessage('DO WHILE END');
end;

(*********************************************************************************)
(*                                      FOR                                      *)
(*********************************************************************************)

constructor TStrFor.Create(aList: TStrList);
begin
  inherited Create(aList);
  kind:= ord(nsFor);
  do_elem.text:= 'for head';
end;

constructor TStrFor.createStructogram(aList: TStrList; dummy: Boolean = True);
begin
  inherited createStructogram(aList);
  kind:= ord(nsFor);
  do_elem.text:= 'for head';
end;

function TStrFor.asString: string;
begin
  Result:= 'For(' + do_elem.asString + ')';
end;

procedure TStrFor.debug;
  var s: string;
begin
  s:= 'TStrFor Kind = ' + IntToStr(kind) + ' Text= ' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
   if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
  MessagesWindow.AddMessage('FOR ');
  do_elem.debug;
  MessagesWindow.AddMessage('FOR END');
end;

(*********************************************************************************)
(*                                      CASE                                     *)
(*********************************************************************************)

constructor TStrCase.Create(aList: TStrList);
begin
  inherited Create(aList);
  kind:= ord(nsCase);
  text:= '';
end;

procedure TStrCase.Draw;
begin
  DrawContent(textPos.X, textPos.Y);
end;

procedure TStrCase.DrawRightBottom;
  var h1, h2, w, y: Integer;
begin
  if text = ''
    then DrawContent(0,0)
  else begin
    list.getWidthHeigthOfText(text, w, h1);
    h2:= rct.Bottom - rct.Top;
    y:= textPos.Y + h2 - h1;
    DrawLinesRight(textPos.x, y, list.LineHeight);
  end;
end;

procedure TStrCase.DrawLeftBottom;
  var h1, h2, w, y: Integer;
begin
  if text = ''
    then DrawContent(0,0)
  else begin
    list.getWidthHeigthOfText(text, w, h1);
    h2:= rct.Bottom - rct.Top;
    y:= textPos.Y + h2 - h1;
    DrawLines(textPos.x, y, list.LineHeight);
  end;
end;

function TStrCase.asString: string;
begin
  Result:= 'Case';
end;

function TStrCase.getText(Indent: string): string;
begin
  Result:= inherited getText(Indent);
end;

procedure TStrCase.debug;
  var s: string;
begin
  s:= 'TStrCase Kind = ' + IntToStr(kind) + ' Text= ' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
  if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
end;

(*********************************************************************************)
(*                                      SWITCH                                   *)
(*********************************************************************************)

constructor TStrSwitch.Create(aList: TStrList);
  var i: Integer;
begin
  inherited Create(aList);
  kind:= ord(nsSwitch);
  SetLength(case_elems, GuiPyOptions.CaseCount);
  for i:= 0 to high(case_elems) do begin
    case_elems[i]:= TStrListHead.Create(aList, Self);
    case_elems[i].text:= 'case ' + IntToStr(i) + ' head';
  end;
  case_elems[high(case_elems)].Next.text:= GuiPyLanguageOptions.Other;
end;

constructor TStrSwitch.createStructogram(aList: TStrList; dummy: Boolean = True);
begin
  inherited Create(aList);
  kind:= ord(nsSwitch);
end;

procedure TStrSwitch.Draw;
  var tmp: TStrElement;
      uh, x, dx, dy, dx1, dy1, case_h, i: Integer;
begin
  with list.Canvas do begin
    if text = ''
      then inherited Draw
      else drawCenteredLines(case_elems[high(case_elems)].rct.Left, textPos.Y, percent);

    // draw diagonals
    case_h:= case_elems[0].Next.rct.Bottom - case_elems[0].Next.rct.Top;
    uh:= case_elems[0].rct.Top - rct.Top + case_h;
    if list.SwitchWithCaseLine then uh:= uh - case_h;
    MoveTo(rct.Left, rct.top);
    LineTo(case_elems[high(case_elems)].rct.Left, rct.top + uh);
    MoveTo(rct.Right, rct.top);
    LineTo(case_elems[high(case_elems)].rct.Left, rct.top + uh);

    // draw verticals
    dy:= uh + 1;
    dx:= case_elems[high(case_elems)].rct.Left - rct.Left;
    for i:= 0 to high(case_elems) - 1 do begin
      x:= case_elems[i].rct.Right;
      dx1:= x - rct.Left;
      if dx = 0
        then dy1:= round(dy*dx1)
        else dy1:= round(dy*dx1/dx);
      MoveTo(x, rct.Top + dy1);
      LineTo(x, rct.Bottom);
    end;

    // draw then elements
    for i:= 0 to high(case_elems) - 1  do begin
      tmp:= case_elems[i].Next;
      tmp.DrawLeftBottom;
      tmp:= tmp.Next;
      while tmp <> nil do begin
        tmp.Draw;
        tmp:= tmp.Next;
      end;
    end;

    // draw else element right justified
    i:= high(case_elems);
    tmp:= case_elems[i].Next;
    tmp.DrawRightBottom;
    tmp:= tmp.Next;
    while tmp <> nil do begin
      tmp.Draw;
      tmp:= tmp.Next;
    end;
  end;
end;

procedure TStrSwitch.DrawContent(x, y: Integer);
  var h: Integer;
begin
  with list.Canvas do
    if text = '' then begin
      x:= case_elems[high(case_elems)].rct.Left;
      y:= (rct.top + case_elems[high(case_elems)].rct.top + 1) div 2;
      h:= (getLineHeight - 10) div 2;
      DrawCircle(x, y, h);
    end else
      DrawLines(x, y, list.LineHeight);
end;

procedure TStrSwitch.MoveRight(w: Integer);
  var tmp: TStrElement; i: Integer;
begin
  inherited MoveRight(w);    { move case-rectangle and condition-text }
  for i:= 0 to high(case_elems) do begin
    tmp:= case_elems[i];
    while tmp <> nil do begin  { move all case-elements }
      tmp.MoveRight(w);
      tmp:= tmp.Next;
    end;
  end;
end;

procedure TStrSwitch.MoveDown(h: Integer);
  var tmp: TStrElement; i: Integer;
begin
  inherited MoveDown(h);    { move case-rectangle and condition-text }
  for i:= 0 to high(case_elems) do begin
    tmp:= case_elems[i];
    while tmp <> nil do begin  { move all case-elements }
      tmp.MoveDown(h);
      tmp:= tmp.Next;
    end;
  end;
end;

procedure TStrSwitch.Resize(x, y: Integer);
  var b, w, d, h, dh, wcondition, wb, i: Integer;
begin
  for i:= 0 to high(case_elems) do
    case_elems[i].ResizeList(x, y);

  list.getWidthHeigthOfText(text, wcondition, h);

  // height is at least 2*LineHeight;
  //if h <= list.LineHeight then h:= 2*list.LineHeight;

  // width of "case" is at least 1.5* width of condition
  wb:= 0;
  for i:= 0 to high(case_elems) do
     wb:= wb + case_elems[i].rct.Right - case_elems[i].rct.Left;
  wb:= Max(wb, wcondition);
  if wb <= 1.5*wcondition then wb:= round(1.5*wcondition);
  w:= Max(wb, getDefaultRectWidth);

  // position horizontal
  SetRct(x, y, x + w, y + h);
  case_elems[0].ResizeList(x, y + h);
  for i:= 1 to high(case_elems) do
    case_elems[i].ResizeList(case_elems[i-1].rct.Right, y + h);

  // set common case head
  h:= 0;
  for i:= 0 to high(case_elems) do
    h:= Max(h, case_elems[i].Next.rct.Bottom);
  for i:= 0 to high(case_elems) do begin
    dh:= h - case_elems[i].Next.rct.Bottom;
    case_elems[i].Next.rct.Bottom:= h;
    if dh > 0 then begin
      if Assigned(case_elems[i].Next) and Assigned(case_elems[i].Next.Next) then
        case_elems[i].Next.Next.MoveDownList(dh);
      case_elems[i].rct.Bottom:= case_elems[i].rct.Bottom + dh;
    end;
  end;

  // set common bottom
  b:= 0;
  for i:= 0 to high(case_elems) do
    b:= Max(b, case_elems[i].rct.Bottom);
  for i:= 0 to high(case_elems) do
    if b > case_elems[i].rct.Bottom then
      case_elems[i].setBottomList(b);

  SetRct(x, y, case_elems[high(case_elems)].rct.Right, b);

  // 1.5*condition_width > rct.width ?
  d:= wb - (rct.Right - rct.Left);
  if d > 0 then
    setRight(rct.Right + d);
  setTextPos;
end;

procedure TStrSwitch.setRight(Right: Integer);
  var dr, i: Integer;
begin
  dr:= (Right - rct.Right) div Length(case_elems);
  for i:= 0 to high(case_elems) - 1 do begin
    case_elems[i].MoveRightList(i*dr);
    case_elems[i].setRightList(case_elems[i].rct.Right + dr);
  end;
  case_elems[high(case_elems)].MoveRightList(high(case_elems)*dr);
  case_elems[high(case_elems)].setRightList(Right);
  rct.Right:= Right;
  setTextPos;
end;

procedure TStrSwitch.setBottom(b: Integer);
  var i: Integer;
begin
  inherited setBottom(b);
  for i:= 0 to high(case_elems) do
    case_elems[i].setBottomList(b);
end;

procedure TStrSwitch.setTextPos;
  var w, h: Integer;
      dthen, dcase: real;
begin
  dthen:= case_elems[high(case_elems)].rct.Left - case_elems[0].rct.Left;
  dcase:= rct.Right - rct.Left;
  if dcase = 0
    then percent:= dthen
    else percent:= dthen/dcase;
  list.getWidthHeigthOfText(text, w, h);
  w:= round(percent * w);
  TextPos.x:= case_elems[high(case_elems)].rct.Left - w;
  TextPos.y:= rct.top;
end;

procedure TStrSwitch.setList(aList: TStrList);
  var i: Integer;
begin
  inherited;
  for i:= 0 to high(case_elems) do
    case_elems[i].setList(aList);
end;

procedure TStrSwitch.AdjustCaseElems(i: Integer);
  var j: Integer;
begin
  for j:= high(case_elems) downto i do
    FreeAndNil(case_elems[j]);
  if i <= high(case_elems) then
    SetLength(case_elems, i);
end;

function TStrSwitch.getHeadHeight: Integer;
begin
  Result:= case_elems[0].rct.top - rct.top;
end;

procedure TStrSwitch.LoadFromStream(Stream: TStream; Version: byte);
var
  current, elem: TStrElement;
  aKind, Count: Byte; i: Integer;
begin
  inherited LoadFromStream(Stream, Version);
  i:= 0;
  FreeAndNil(Next);  // necessary for corrupted files !
  Count:= Stream.Read(akind, 1);  // overread aKind
  while (Count = 1) and (aKind <> $FF) do begin
    if i > high(case_elems) then begin
      SetLength(case_elems, i+1);
      case_elems[i]:= TStrListHead.Create(list, Self);
      case_elems[i].text:= 'case ' + IntToStr(i) + ' head';
    end;
    case_elems[i].Next.LoadFromStream(Stream, Version);
    current:= case_elems[i].Next;
    Count:= Stream.Read(aKind, 1);
    while (Count = 1) and (aKind <> $FF) do begin
      elem:= getStatementFromKind(aKind, list, Self);
      if elem = nil then Exit;
      elem.LoadFromStream(Stream, Version);
      FreeAndNil(elem.Next);
      list.Insert(current, elem);
      current:= elem;
      Count:= Stream.Read(aKind, 1);
    end;
    // delete default statement from TStrListHead.create
    list.deleteElem(current.Next);
    Inc(i);
    Count:= Stream.Read(aKind, 1);
  end;
  AdjustCaseElems(i);
end;

procedure TStrSwitch.LoadFromReader(Reader: TStringListReader);
  var current, elem: TStrElement;
      i, myIndent: Integer;
begin
  i:= 0;
  inherited LoadFromReader(Reader);
  myIndent:= Reader.IndentAsInt;
  while Reader.nextLineIndent = myIndent do begin
    Reader.ReadLine;
    if i > high(case_elems) then begin
      SetLength(case_elems, i+1);
      case_elems[i]:= TStrListHead.Create(list, Self);
      case_elems[i].text:= 'case ' + IntToStr(i) + ' head';
    end;
    case_elems[i].LoadFromReader(Reader);
    case_elems[i].Next.LoadFromReader(Reader);
    current:= case_elems[i].Next;

    while Reader.nextLineIndent = myIndent + 2 do begin
      Reader.ReadLine;
      elem:= getStatementFromReader(Reader, list, Self);
      elem.LoadFromReader(Reader);
      list.Insert(current, elem);
      current:= elem;
    end;
    list.deleteElem(current.Next);
    Inc(i);
  end;
  AdjustCaseElems(i);
end;

procedure TStrSwitch.SaveToStream(Stream: TStream);
var
  tmp: TStrElement;
  tag: Byte;
  i: Integer;
begin
  inherited SaveToStream(Stream); // save condition
  tag:= $FF;
  for i:= 0 to high(case_elems) do begin
    tmp:= case_elems[i].Next;
    while tmp <> nil do begin
      tmp.SaveToStream(Stream);
      tmp:= tmp.Next;
    end;
    Stream.Write(tag, 1);      // write end tag
  end;
  Stream.Write(tag, 1);
end;

function TStrSwitch.getText(Indent: string): string;
var
  tmp: TStrElement;
  i: Integer;
begin
  Result:= Indent + 'switch: ' + CrLf + inherited getText(Indent + '  ');
  for i:= 0 to high(case_elems) do begin
    tmp:= case_elems[i];
    Result:= Result + Indent + '  case:' + CrLf;
    while tmp <> nil do begin
      Result:= Result + tmp.getText(Indent + '    ');
      tmp:= tmp.Next;
    end;
  end;
end;

function TStrSwitch.AppendToClipboard: string;
  var tmp: TStrElement; i: Integer;
begin
  Result:= inherited AppendToClipboard;
  for i:= 0 to high(case_elems) do begin
    tmp:= case_elems[i].Next;
    while tmp <> nil do begin
      Result:= Result + tmp.AppendToClipboard;
      tmp:= tmp.Next;
    end;
    Result:= Result + TERM + SEP;
  end;
  Result:= Result + TERM + SEP;
end;

procedure TStrSwitch.CreateFromClipboard(var ClipboardStr: string);
var
  elem, current: TStrElement;
  aKind, index: Byte; i: Integer;
begin
  inherited CreateFromClipboard(ClipboardStr);
  i:= 0;
  aKind:= ord(ClipboardStr[1]);
  while akind <> $FF do begin
    if i > high(case_elems) then begin
      SetLength(case_elems, i+1);
      case_elems[i]:= TStrListHead.Create(list, Self);
      case_elems[i].text:= 'case ' + IntToStr(i) + ' head';
    end;
    case_elems[i].Next.CreateFromClipboard(ClipboardStr);
    current:= case_elems[i].Next;
    aKind:= ord(ClipboardStr[1]);
    while akind <> $FF do begin
      elem:= getStatementFromKind(aKind, list, Self);
      if elem = nil then Exit;
      elem.CreateFromClipboard(ClipboardStr);
      FreeAndNil(elem.Next);
      list.Insert(current, elem);
      current:= elem;
      aKind:= ord(ClipboardStr[1]);
    end;
    index:= Pos(SEP, ClipboardStr);
    Delete(ClipboardStr, 1, index);
    // delete default statement from TStrListHead.create
    list.deleteElem(current.Next);
    Inc(i);
    aKind:= ord(ClipboardStr[1]);
  end;
  index:= Pos(SEP, ClipboardStr);
  Delete(ClipboardStr, 1, index);
  AdjustCaseElems(i);
end;

destructor TStrSwitch.Destroy;
  var i: Integer;
begin
  for i:= 0 to high(case_elems) do
    FreeAndNil(case_elems[i]);
end;

function TStrSwitch.asString: string;
 var i: Integer;
begin
  Result:= 'Switch(';
  for i:= 0 to high(case_elems) do
    Result:= Result + 'case(' + case_elems[i].asString + '),';
  Delete(Result, Length(Result), 1);
  Result:= Result + ')';
end;

procedure TStrSwitch.debug;
  var s: string; i: Integer;
begin
  s:= 'TStrSwitch Kind = ' + IntToStr(kind) + ' Text= ' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
  if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
  for i:= 0 to high(case_elems) do begin
    MessagesWindow.AddMessage('');
    MessagesWindow.AddMessage('CASE ' + IntToStr(i));
    case_elems[i].debug;
    MessagesWindow.AddMessage('CASE ' + IntToStr(i) + ' END');
  end;
end;

procedure TStrSwitch.Collapse;
  var i: Integer;
begin
  for i:= 0 to high(case_elems) do
    case_elems[i].CollapseCase;
end;

(*********************************************************************************)
(*                                  SUBPROGRAM                                   *)
(*********************************************************************************)

constructor TStrSubProgram.Create(aList: TStrList);
begin
  inherited Create(aList);
  kind:= ord(nsSubProgram);
end;

procedure TStrSubprogram.Draw;
  var d: Integer;
begin
  inherited Draw;
  with list.Canvas do begin
    d:= DO_SUB div 2;
    MoveTo(rct.Left + d, rct.top+1);
    LineTo(rct.Left + d, rct.bottom);
    MoveTo(rct.Right - d, rct.top+1);
    LineTo(rct.Right - d, rct.bottom);
  end;
end;

procedure TStrSubprogram.Resize(x, y: Integer);
begin
  inherited Resize(x, y);
  textPos.x:= textPos.x + DO_SUB div 2;                { ... correct text position }
  rct.Right:= rct.Right + DO_SUB;
end;

function TStrSubprogram.getHeadHeight: Integer;
begin
  Result:= rct.bottom - rct.top;
end;

function TStrSubprogram.asString: string;
begin
  Result:= 'Sub(' + text + ')';
end;

procedure TStrSubprogram.LoadFromReader(Reader: TStringListReader);
begin
  inherited LoadFromReader(Reader);
end;

function TStrSubprogram.getText(Indent: string): string;
begin
  Result:= Indent + 'subprogram: ' + CrLf + inherited getText(Indent + '  ');
end;

procedure TStrSubprogram.debug;
  var s: string;
begin
  s:= 'TStrSubprogram Kind = ' + IntToStr(kind) + ' Text= ' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
  if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
end;

(*********************************************************************************)
(*                                  BREAK                                        *)
(*********************************************************************************)

constructor TStrBreak.Create(aList: TStrList);
begin
  inherited Create(aList);
  kind:= ord(nsBreak);
end;

procedure TStrBreak.Draw;
  var d: Integer;
begin
  inherited Draw;
  with list.Canvas do begin
    d:= DO_BREAK;
    MoveTo(rct.Left + d, rct.top+1);
    LineTo(rct.Left, (rct.bottom + rct.top) div 2);
    LineTo(rct.Left + d, rct.bottom);
  end;
end;

procedure TStrBreak.Resize(x, y: Integer);
begin
  inherited Resize(x, y);
  textPos.x:= textPos.x + DO_BREAK;        { ... correct text position }
end;

function TStrBreak.getHeadHeight: Integer;
begin
  Result:= rct.bottom - rct.top;
end;

function TStrBreak.asString: string;
begin
  Result:= 'Break';
end;

procedure TStrBreak.LoadFromReader(Reader: TStringListReader);
begin
  inherited LoadFromReader(Reader);
end;

function TStrBreak.getText(Indent: string): string;
begin
  Result:= Indent + 'break: ' + CrLf + inherited getText(Indent + '  ');
end;

procedure TStrBreak.debug;
  var s: string;
begin
  s:= 'TStrBreak Kind = ' + IntToStr(kind) + ' Text= ' + text +
     ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';
  if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
end;

(*********************************************************************************)
(*                                      Listhead                                 *)
(*********************************************************************************)

constructor TStrListHead.Create(aList: TStrList; aParent: TStrElement);
begin
  inherited Create(aList);
  kind:= Ord(nsListHead);
  Self.Parent:= aParent;
  Self.Next:= TStrStatement.Create(aList);
  Self.Next.prev:= Self;
  if parent is TStrSwitch then
    aList.insert(Self, TStrCase.Create(aList));
end;

constructor TStrListHead.createStructogram(aList: TStrList; aParent: TStrElement; Dummy: Boolean = True);
begin
  inherited Create(aList);
  kind:= Ord(nsListHead);
  Self.Parent:= aParent;
  if parent is TStrSwitch then
    aList.insert(Self, TStrCase.Create(aList));
end;

destructor TStrListHead.Destroy;
  var cur, tmp: TStrElement;
begin
  inherited;
  cur:= Next;
  while cur <> nil do begin
    tmp:= cur;
    cur:= cur.Next;
    FreeAndNil(tmp);
  end;
end;

procedure TStrListHead.SetRctList(X1, Y1, X2, Y2: Integer);
begin
  rct.Left := X1;
  rct.top := Y1;
  rct.Right := X2;
  rct.bottom := Y2;
end;

procedure TStrListHead.setList(aList: TStrList);
  var cur: TStrElement;
begin
  inherited;
  cur:= Next;
  while cur <> nil do begin
    cur.setList(aList);
    cur:= cur.Next;
  end;
end;

procedure TStrListHead.Resize(x, y: Integer);
begin
  inherited Resize(x, y);
  setRct(x, y, x, y);
end;

function TStrListHead.asString: string;
  var s: string; var tmp: TStrElement;
begin
  s:= '';
  tmp:= Next;
  while tmp <> nil do begin
    s:= s + tmp.asString + ',';
    tmp:= tmp.Next;
  end;
  Result:= Copy(s, 1, Length(s)-1);
end;

procedure TStrListHead.debug;
  var s: string; var tmp: TStrElement;
begin
  s:= 'TStrListHead Kind=' + IntToStr(kind) + ' Text=' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')';

  if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
  tmp:= Next;
  while tmp <> nil do begin
    tmp.debug;
    tmp:= tmp.Next;
  end;
end;

procedure TStrListHead.collapse;
  var cur: TStrElement;
begin
  cur:= Next;
  while cur.Next <> nil do
    if cur.Next.text = '' then
      list.deleteElem(cur.Next)
    else begin
      cur.Next.collapse;
      cur:= cur.Next;
    end;
  if (Next.text = '') and Assigned(Next.Next)
    then list.deleteElem(Next)
    else Next.Collapse;
end;

procedure TStrListHead.collapseCase;
  var cur: TStrElement;
begin
  cur:= Next.Next;
  while cur.Next <> nil do
    if cur.Next.text = '' then
      list.deleteElem(cur.Next)
    else begin
      cur.Next.collapse;
      cur:= cur.Next;
    end;
  Next.Collapse;
end;

(*******************************************************************************)
(*                                      LIST                                   *)
(*******************************************************************************)

constructor TStrList.Create(Scrollbox: TScrollBox; Mode: Integer; Font: TFont);
begin
  Kind:= Ord(nsList);
  text:= 'list head';
  LoadError:= False;
  list:= Self;
  Image:= TListImage.Create(ScrollBox, Self);
  Image.setBounds(100, 150, 400, 250);
  Image.AutoSize:= True;
  Image.Parent:= ScrollBox;
  Image.Canvas.Font.Assign(Font);
  Canvas:= Image.Canvas;
  SwitchWithCaseLine:= GuiPyOptions.SwitchWithCaseLine;
  setLineHeight;
  PuzzleMode:= Mode;
  BlackAndWhite:= false;
end;

destructor TStrList.Destroy;
var
  tmp: TStrElement;
begin
  while Next <> nil do begin
    tmp:= Next;
    Next:= tmp.Next;
    FreeAndNil(tmp);
  end;
  FreeAndNil(Image);
end;

procedure TStrList.Draw;
var
  h, xm, ym: Integer;
  tmp: TStrElement;
begin
  with Canvas do begin
    DrawLines(textPos.X, textPos.Y, LineHeight-TOP_BOTTOM);
    if text = GuiPyLanguageOptions.Algorithm + ' ' then begin
      h:= (LineHeight - 10) div 2;
      xm:= PenPos.x + TextHeight('X') div 2 + 5;
      ym:= PenPos.y + TextHeight('X') div 2;
      Ellipse(xm - h, ym - h, xm + h, ym + h);
      MoveTo(xm - h, ym + h);
      LineTo(xm + h, ym -h);
    end;
    tmp:= Next;
    while tmp <> nil do begin  { paint all elements }
      tmp.Draw;
      tmp:= tmp.Next;
    end;
  end;
end;

procedure TStrList.LoadFromStream(Stream: TStream; Version: byte);
var
  current, elem: TStrElement;
  aKind, Count: Byte;
begin
  if Version >= $0E then
    rctList:= RectFromStream(Stream);
  Stream.Read(aKind, 1);  {overread StrList aKind }
  inherited LoadFromStream(Stream, Version); // read algorithm name
  FreeAndNil(Next);
  current:= Self;
  Count:= Stream.Read(aKind, 1);
  while (Count = 1) and (aKind <> $FF) do begin
    elem:= getStatementFromKind(aKind, Self, Self);
    if elem = nil then Exit;
    elem.LoadFromStream(Stream, Version);
    FreeAndNil(elem.Next); {necessary for corrupted files !}
    list.Insert(current, elem);
    current:= elem;
    Count:= Stream.Read(aKind, 1);
  end;
end;

procedure TStrList.LoadFromReader(Reader: TStringListReader);
  var current, elem: TStrElement;
begin
  Reader.ReadLine;   // RectPos [...]
  rctList:= Reader.aRect;
  Image.Left:= Image.PPIScale(Reader.Point.X);
  Image.Top:= Image.PPIScale(Reader.Point.Y);

  Reader.ReadLine;   // Algorithm or list head
  Text:= Reader.Text;
  rct:= Reader.aRect;
  TextPos:= Reader.Point;
  current:= Self;

  while Reader.nextLineIndent = 4 do begin
    Reader.ReadLine;
    elem:= getStatementFromReader(Reader, Self, Self);
    elem.LoadFromReader(Reader);
    list.Insert(current, elem);
    current:= elem;
  end;
end;

procedure TStrList.SaveToStream(Stream: TStream);
var
  tmp: TStrElement;
  tag: Byte;
begin
  RectToStream(Stream, rctList);
  inherited SaveToStream(Stream);
  tmp:= Next;
  while tmp <> nil do begin
    tmp.SaveToStream(Stream);
    tmp:= tmp.Next;
  end;
  tag:= $FF;
  Stream.Write(tag, 1);      {write end tag}
end;

function TStrList.getText(indent: string): string;
var
  tmp: TStrElement;
begin
  Result:= inherited getText(indent);
  tmp:= Next;
  while tmp <> nil do begin
    Result:= Result + tmp.getText(indent + '  ');
    tmp:= tmp.Next;
  end;
end;

function TStrList.getRectPos(Indent: string): string;
begin
  Result:= getRectPosAsText(Indent, rctList,
    Point(Image.PPIUnScale(Image.Left), Image.PPIUnScale(Image.Top)));
end;

procedure TStrList.PaintShadow;
  var i, sw, t, b, d, SCol, ECol, sr, sg, sb, er, eg, eb: Integer;
      R: TRect;

  function ColorGradient(i: Integer): TColor;
    var r, g, b: Integer;
  begin
    r:= sr + round(((er - sr)*i)/Sw);
    g:= sg + round(((eg - sg)*i)/Sw);
    b:= sb + round(((eb - sb)*i)/Sw);
    Result:= RGB(r, g, b);
  end;

begin
  if Kind = Byte(nsAlgorithm)
    then Sw:= GuiPyOptions.StructogramShadowWidth
    else Sw:= 0;
  if (sw = 0) or (Next = nil) then Exit;

  t:= rct.Bottom + Sw;
  b:= getHeight + 1 + Sw;
  d:= 2*Sw - (b - t);
  if d > 0 then
    t:= t - d;
  R:= Rect(Sw, t, Next.rct.Right + Sw, b);

  Canvas.Pen.Mode:= pmCopy;
  SetColors;
  SCol:= ColorToRGB(Canvas.Brush.Color);
  sr:= GetRValue(SCol);
  sg:= GetGValue(SCol);
  sb:= getBValue(SCol);
  ECol:= ColorToRGB(Canvas.Pen.Color);
  er:= GetRValue(ECol);
  eg:= GetGValue(ECol);
  eb:= getBValue(ECol);
  for i:= 0 to Sw - 1 do begin
    Canvas.Pen.Color:= ColorGradient(i);
    Canvas.PolyLine([Point(R.Right - Sw + 1, R.Top + i),
                     Point(R.Right - i, R.Top + i),
                     Point(R.Right - i, R.Bottom - i - 1),
                     Point(R.Left + i, R.Bottom - i - 1),
                     Point(R.Left + i, R.Bottom - Sw - 1)]);
  end;
end;

procedure TStrList.Paint;
  var Bitmap: TBitmap;
      sw: Integer;
begin
  if Kind = Byte(nsAlgorithm)
    then Sw:= GuiPyOptions.StructogramShadowWidth
    else Sw:= 0;

  Bitmap:= TBitmap.Create;
  try
    Canvas:= Bitmap.Canvas;
    Canvas.Font:= Image.Canvas.Font;
    Canvas.Pen:= Image.Canvas.Pen;
    SetColors;
    Bitmap.SetSize(getWidth + 1 + Sw, getHeight + 1 + Sw);
    Canvas.Fillrect(Rect(0, 0, bitmap.width, bitmap.height));
    PaintShadow;
    Draw;
    Image.Picture.Bitmap.Height:= Bitmap.Height;
    Image.Picture.Bitmap.Width := Bitmap.Width;

    // paint structogram on canvas
    Image.Canvas.Draw(0, 0, Bitmap);
    Canvas:= Image.Canvas;
  finally
    FreeAndNil(Bitmap);
  end;
end;

procedure TStrList.SetColors;
begin
  if StyleServices.IsSystemStyle or BlackAndWhite then begin
    Canvas.Pen.Color:= clBlack;
    Canvas.Font.Color:= clBlack;
    Canvas.Brush.Color:= clWhite;
  end else begin
    Canvas.Pen.Color:= StyleServices.GetStyleFontColor(sfTabTextInactiveNormal);  // clWhite
    Canvas.Font.Color:= StyleServices.GetStyleFontColor(sfTabTextInactiveNormal);
    Canvas.Brush.Color:= StyleServices.GetStyleColor(scPanel);
  end;
end;

procedure TStrList.Print;
begin
  Canvas:= Printer.Canvas;
  Draw;
end;

procedure TStrList.SetRctList(X1, Y1, X2, Y2: Integer);
begin
  rctList.Left := X1;
  rctList.top := Y1;
  rctList.Right := X2;
  rctList.bottom := Y2;
end;

procedure TStrList.Resize(x, y: Integer);
  var w: Integer;
begin
  w:= getWidthOfLines(text) + Canvas.Font.Size + 2*LEFT_RIGHT;
  SetRct(x, y, x + Max(w, getDefaultRectWidth), y); // h = 0
end;

procedure TStrList.ResizeAll;
begin
  ResizeList(0, 0);
  setRct(0, 0, Max(getWidthOfLines(text) + Canvas.Font.Size + 2*LEFT_RIGHT, rct.Right), rct.Bottom);
end;

function TStrList.getWidth: Integer;
begin
  Result:= rct.Right - rct.Left;
end;

function TStrList.getHeight: Integer;
begin
  Result:= Self.rctList.Bottom;
end;

procedure TStrList.insert(at, elem: TStrElement);
  // insert one element or a list of elements
  var tmp: TStrElement;
begin
  tmp:= at.Next;
  at.Next:= elem;
  elem.prev:= at;
  while (elem.Next <> nil) and (elem.Next <> elem) do
    elem:= elem.Next;
  elem.Next:= tmp;
  if Assigned(tmp) then
    tmp.prev:= elem;
end;

procedure TStrList.deleteElem(elem: TStrElement);
  var p, n: TStrElement;
begin
  if elem = nil then Exit;
  p:= elem.prev;
  if p = nil then begin
    FreeAndNil(elem);
    Exit;
  end;
  n:= elem.Next;
  p.Next:= n;
  if n <> nil then
    n.prev:= p
  else if (p is TStrListHead) or (p is TStrCase) then
    insert(p, TStrStatement.Create(list));
  elem.Destroy;
end;

procedure TStrList.getWidthHeigthOfText(const aText: string; var w, h: Integer);
  var s, s1: string; p: Integer;
begin
  w:= getDefaultRectWidth;
  h:= LineHeight;
  s:= aText;
  p:= Pos(#13#10, s);
  while p > 0 do begin
    s1:= Copy(s, 1, p-1);
    Delete(s, 1, p+1);
    w:= Max(Image.Canvas.TextWidth(s1) + LEFT_RIGHT, w);
    h:= h + LineHeight;
    p:= Pos(#13#10, s);
  end;
  w:= Max(Image.Canvas.TextWidth(s) + LEFT_RIGHT, w);
end;

function TStrList.getWidthOfOneLine(const aText: string): Integer;
begin
  Result:= Image.Canvas.TextWidth(aText) + LEFT_RIGHT;
end;

function TStrList.getWidthOfLines(const aText: string): Integer;
  var w, h: Integer;
begin
  getWidthHeigthOfText(aText, w, h);
  Result:= w;
end;

procedure TStrList.setLineHeight;
begin
  LineHeight:= Canvas.TextHeight('X') + TOP_BOTTOM;
end;

function TStrList.asString: string;
  var s: string; tmp: TStrElement;
begin
  s:= text + ',';
  tmp:= Next;
  while Assigned(tmp) do begin
    s:= s + tmp.asString + ',';
    tmp:= tmp.Next;
  end;
  Result:= Copy(s, 1, Length(s)-1);
end;

procedure TStrList.debug;
  var s: string; tmp: TStrElement;
begin
  s:= 'TStrList Kind=' + IntToStr(kind) + ' Text=' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')' +
      ' rctList(' + IntToStr(rctList.Left) + ', ' + IntToStr(rctList.Top) + ', ' + IntToStr(rctList.Width) + ', ' + IntToStr(rctList.Bottom) + ')';
  if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);

  tmp:= Next;
  while Assigned(tmp) do begin
    tmp.debug;
    tmp:= tmp.Next;
  end;
  MessagesWindow.AddMessage('-----------------------');
end;

procedure TStrList.setList(aList: TStrList);
  var tmp: TStrElement;
begin
  Self.List:= aList;
  tmp:= Next;
  while Assigned(tmp) do begin
    tmp.setList(aList);
    tmp:= tmp.Next;
  end;
end;

procedure TStrList.setPuzzleMode(Mode: Integer);
begin
  PuzzleMode:= Mode;
end;

procedure TStrList.setFont(Font: TFont);
begin
  Canvas.Font.Assign(Font);
  setLineHeight;
end;

procedure TStrList.setBlackAndWhite(value: boolean);
begin
  BlackAndwhite:= value;
  Paint;
end;

procedure TStrList.Collapse;
  var cur: TStrElement;
begin
  cur:= Next;
  while cur <> nil do begin
    if cur.text = '' then begin
      deleteElem(cur);
      cur:= Next;
    end else begin
      cur.collapse;
      cur:= cur.Next;
    end;
  end;
end;

(******************************************************************************)
(*                                TStrAlgorithm                               *)
(******************************************************************************)

constructor TStrAlgorithm.Create(Scrollbox: TScrollBox; Mode: Integer; Font: TFont);
begin
  inherited Create(Scrollbox, Mode, Font);
  text:= '';
  Kind:= Ord(nsAlgorithm);
end;

procedure TStrAlgorithm.Resize(x, y: Integer);
var
  w, h, h1: Integer;
begin
  w:= getWidthOfLines(text) + Canvas.Font.Size + 2*LEFT_RIGHT;
  h:= getLines*(LineHeight - TOP_BOTTOM);
  h1:= Canvas.Font.Size div 2;             {height of bottom line}
  SetRct(x, y, x + Max(w, getDefaultRectWidth), y + h + h1);
end;

function TStrAlgorithm.getAlgorithmName: string;
  var i: Integer; s: string;
begin
  i:= Pos(GuiPyLanguageOptions.Algorithm + ' ', text);
  if i > 0
    then s:= Copy(list.text, i + Length(GuiPyLanguageOptions.Algorithm + ' '), 255)
    else s:= text;
  i:= Pos('(', s);
  if i > 0 then
    Delete(s, i, Length(s));
  Result:= Trim(s);
end;

function TStrAlgorithm.asString: string;
  var s: string; tmp: TStrElement;
begin
  s:=  text + '(';
  tmp:= Next;
  while Assigned(tmp) do begin
    s:= s + tmp.asString + ',';
    tmp:= tmp.Next;
  end;
  Result:= Copy(s, 1, Length(s)-1);
end;

procedure TStrAlgorithm.debug;
  var s: string; tmp: TStrElement;
begin
  s:= 'TStrAlgorithm Kind=' + IntToStr(kind) + ' Text=' + text +
      ' rct(' + IntToStr(rct.Left) + ', ' + IntToStr(rct.Top) + ', ' + IntToStr(rct.Width) + ', ' + IntToStr(rct.Bottom) + ')' +
      ' rctList(' + IntToStr(rctList.Left) + ', ' + IntToStr(rctList.Top) + ', ' + IntToStr(rctList.Width) + ', ' + IntToStr(rctList.Bottom) + ')' +
      ' Image(' + IntTostr(Image.Left) + ', ' + IntToStr(Image.Top) + ')';

  if Assigned(prev) and (prev.Next <> Self) then
    s:= s + ' prev.next <> self';
  if Assigned(Next) and (Next.prev <> Self) then
    s:= s + ' next.prev <> self';
  MessagesWindow.AddMessage(s);
  tmp:= Next;
  while Assigned(tmp) do begin
    tmp.debug;
    tmp:= tmp.Next;
  end;
  MessagesWindow.AddMessage('-----------------------');
end;

(*******************************************************************************)
(*                                 TListImage                                  *)
(*******************************************************************************)

constructor TListImage.Create(Scrollbox: TScrollBox; List: TStrList);
begin
  inherited Create(ScrollBox);
  StrList:= List;
end;

end.
