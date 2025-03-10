{-------------------------------------------------------------------------------
 Unit:     UTTKTextBase
 Author:   Gerhard Röhner
 Date:     May 2021
 Purpose:  TKKinter text widgets
-------------------------------------------------------------------------------}

unit UTTKTextBase;

{ class hierarchy

  TKTextBaseWidget
    TTKEntry
    TKSpinbox
    TTKCombobox
}

interface

uses
  Classes, UTtkWidgets;

type

  // for disabeling  - different to TButtonState in TKButtonBase
  TTextState = (disabled, normal, readonly);

  TActiveStyle = (_TS_underline, _TS_dotbox, _TS_none);

  TSelectMode = (browse, single, multiple, extended);

  TValidate = (_TV_none, _TV_all, _TV_key, _TV_focus, _TV_focusin, _TV_focusout);

  TTKTextBaseWidget = class(TTKWidget)
  private
    FExportSelection: Boolean;
    FInvalidCommand: Boolean;
    FState: TTextState;
    FValidate: TValidate;
    FValidateCommand: Boolean;
    procedure setState(aValue: TTextState);
  public
    constructor Create(AOwner: TComponent); override;
    procedure DeleteWidget; override;
    procedure setAttribute(Attr, Value, Typ: string); override;
    function getAttributes(ShowAttributes: Integer): string; override;
    function getEvents(ShowEvents: Integer): string; override;
    procedure MakeCommand(Attr, Value: string); override;
    procedure Paint; override;
  published
    property ExportSelection: Boolean read FExportSelection write FExportSelection default True;
    property Font;
    property Foreground;
    property InvalidCommand: Boolean read FInvalidCommand write FInvalidCommand;
    property Justify;
    property Scrollbar;
    property State: TTextState read FState write setState default normal;
    property Validate: TValidate read FValidate write FValidate default _TV_none;
    property ValidateCommand: Boolean read FValidateCommand write FValidateCommand;
  end;

  TTKEntry = class (TTKTextBaseWidget)
  private
    FShow: Boolean;
    FText: string;
  public
    constructor Create(AOwner: TComponent); override;
    procedure NewWidget(Widget: string = ''); override;
    procedure setAttribute(Attr, Value, Typ: string); override;
    function getAttributes(ShowAttributes: Integer): string; override;
    function getEvents(ShowEvents: Integer): string; override;
    procedure setText(Value: string); override;
    procedure Paint; override;
  published
    {$WARNINGS OFF}
    property Show: Boolean read FShow write FShow default True;
    {$WARNINGS ON}
    property Text: string read FText write setText;
    property TakeFocus;
  end;

  TTKSpinbox = class (TTKTextBaseWidget)
  private
    FFormat: string;
    FFrom: string;
    FIncrement: string;
    FTo: string;
    FValue: string;
    FValues: TStrings;
    procedure setValues(Values: TStrings);
    procedure setRValue(aValue: string);
    procedure MakeValues;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure setAttribute(Attr, Value, Typ: string); override;
    function getAttributes(ShowAttributes: Integer): string; override;
    procedure NewWidget(Widget: string = ''); override;
    procedure Paint; override;
  published
    property Command;
    property Format: string read FFormat write FFormat;
    property From_: string read FFrom write FFrom;
    property Increment: string read FIncrement write FIncrement;
    property TakeFocus;
    property _To: string read FTo write FTo;
    property Values: TStrings read FValues write setValues;
    property Value: string read FValue write setRValue;
  end;

  TTKCombobox = class(TTKTextBaseWidget)
  private
    FPostCommand: Boolean;
    FValue: string;
    FValues: TStrings;
    procedure setRValue(aValue: string);
    procedure setValues(Values: TStrings);
    function getListItems: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure setAttribute(Attr, Value, Typ: string); override;
    function getAttributes(ShowAttributes: Integer): string; override;
    procedure NewWidget(Widget: string = ''); override;
    procedure DeleteWidget; override;
    procedure Paint; override;
  published
    property PostCommand: Boolean read FPostCommand write FPostCommand;
    property TakeFocus;
    property Value: string read FValue write setRValue;
    property Values: TStrings read FValues write setValues;
  end;

implementation

uses Controls, Graphics, SysUtils, Types, UITypes,
     UBaseTkWidgets, UUtils;

{--- TButtonBaseWidget --------------------------------------------------------}

constructor TTKTextBaseWidget.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FExportSelection:= True;
  FState:= normal;
  FValidate:= _TV_none;
  Cursor:= crIBeam;
  Justify:= _TJ_Left;
  Relief:= _TR_solid;
end;

procedure TTKTextBaseWidget.DeleteWidget;
begin
  inherited;
  if FInvalidCommand then Partner.DeleteMethod(Name + '_InvalidCommand');
  if FValidateCommand then Partner.DeleteMethod(Name + '_ValidateCommand');
end;

procedure TTKTextBaseWidget.setAttribute(Attr, Value, Typ: string);
begin
  if Attr = 'Scrollbar' then
    MakeScrollbar(Value, 'ttk.')
  else
    inherited;
end;

function TTKTextBaseWidget.getAttributes(ShowAttributes: Integer): string;
begin
  Result:= '|Background|Show';
  if ShowAttributes >= 2 then
    Result:= Result + '|Justify|Scrollbar|State';
  if ShowAttributes = 3 then
    Result:= Result + '|ExportSelection|Foreground' +
                      '|InvalidCommand|Validate|ValidateCommand';
  Result:= Result + inherited getAttributes(ShowAttributes);
end;

function TTKTextBaseWidget.getEvents(ShowEvents: Integer): string;
begin
  Result:= getMouseEvents(ShowEvents);
end;

procedure TTKTextBaseWidget.MakeCommand(Attr, Value: string);
begin
  inherited;
  if Attr = 'ValidateCommand' then
    AddParameter(Value, 'why, where, what');
end;

procedure TTKTextbaseWidget.Paint;
begin
  if FState = normal
    then Background:= clWindow
    else Background:= clBtnFace;
  inherited;
end;

procedure TTKTextBaseWidget.setState(aValue: TTextState);
begin
  if aValue <> FState then begin
    FState:= aValue;
    Invalidate;
  end;
end;

{--- TTKEntry ------------------------------------------------------------------}

constructor TTKEntry.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Tag:= 32;
  Width:= 80;
  Height:= 24;
  FShow:= True;
end;

procedure TTKEntry.NewWidget(Widget: string = '');
begin
  Partner.ActiveSynEdit.BeginUpdate;
  inherited NewWidget('ttk.Entry');
  MakeControlVar('textvariable', Name + 'CV', FText);
  Partner.ActiveSynEdit.EndUpdate;
end;

procedure TTKEntry.setAttribute(Attr, Value, Typ: string);
begin
  if Attr = 'Text' then  // different from Button.Text
    setValue(Name + 'CV', asString(Value))
  else if Attr = 'ValidateCommand' then
    MakeValidateCommand(Attr, Value)
  else
    inherited;
end;

function TTKEntry.getAttributes(ShowAttributes: Integer): string;
begin
  Result:= '|Text' + inherited getAttributes(ShowAttributes);
end;

function TTKEntry.getEvents(ShowEvents: Integer): string;
begin
  Result:= getKeyboardEvents(ShowEvents);
end;

procedure TTKEntry.setText(Value: string);
begin
  if Value <> FText then begin
    FText:= Value;
    Invalidate;
  end;
end;

procedure TTKEntry.Paint;
  var newHeight: Integer;
begin
  Canvas.Pen.Color:= $7A7A7A;
  inherited; // shows no text, because FText of TKWidget is overridden
  if Scrollbar
    then newHeight:= Height - 20
    else newHeight:= Height;
  ShowText(FText, Width, newHeight);
  PaintAScrollbar(Scrollbar);
end;

{--- TTKSpinbox ----------------------------------------------------------------}

constructor TTKSpinbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Tag:= 39;
  Width:= 40;
  Height:= 24;
  FFrom:= '0';
  FTo:= '0';
  FValue:= '0';
  FIncrement:= '1';
  FValues:= TStringList.Create;
end;

destructor TTKSpinbox.Destroy;
begin
  FreeAndNil(FValues);
  inherited;
end;

procedure TTKSpinbox.MakeValues;
  var s1, Value, AllValues: string; i: Integer;
begin
  s1:= 'self.' + Name + '[''values'']';
  AllValues:= '[';
  for i := 0 to FValues.Count - 1 do begin
    Value:= Trim(FValues[i]);
    if Value = '' then Continue;
    AllValues:= AllValues + asString(Value) + ', ';
  end;
  if Copy(AllValues, Length(AllValues) -1, 2) = ', ' then
    Delete(AllValues, Length(AllValues)-1, 2);
  AllValues:= AllValues + ']';
  setAttributValue(s1, s1 + ' = ' + AllValues);
end;

procedure TTKSpinbox.setAttribute(Attr, Value, Typ: string);
begin
  if Attr = 'Value' then
    setValue(Name + 'CV', asString(Value))
  else if Attr = 'Values' then
    MakeValues
  else
    inherited;
end;

function TTKSpinbox.getAttributes(ShowAttributes: Integer): string;
begin
  Result:= '|From_|_To|Increment|Values|Value';
  if ShowAttributes >= 2 then
    Result:= Result + '|Command|Format';
  if ShowAttributes = 3 then
    Result:= Result + '|Exportselection';
  Result:= Result + inherited getAttributes(ShowAttributes);
end;

procedure TTKSpinbox.setValues(Values: TStrings);
begin
  FValues.Assign(Values);
  Invalidate;
end;

procedure TTKSpinbox.SetRValue(aValue: string);
begin
  if FValue <> aValue then begin
    FValue:= aValue;
    Invalidate;
  end;
end;

procedure TTKSpinbox.NewWidget(Widget: string = '');
begin
  Partner.ActiveSynEdit.BeginUpdate;
  inherited NewWidget('ttk.Spinbox');
  MakeControlVar('textvariable', Name + 'CV', FValue);
  Partner.ActiveSynEdit.EndUpdate;
end;

procedure TTKSpinbox.Paint;
  var s: string;
      x, y, newHeight: Integer;
      Points: array[0..2] of TPoint;
      R: TRect;
begin
  Canvas.Pen.Color:= $7A7A7A;
  inherited;
  // paint number/value
  if FValue <> ''
    then s:= FValue
    else if FValues.Count > 0
      then s:= FValues[0]
      else s:= FFrom;
  if Scrollbar
    then newHeight:= Height - PPIScale(20)
    else newHeight:= Height;
  ShowText(s, Width - PPIScale(16), newHeight);

  // paint up/down
  Canvas.Brush.Color:= $F0F0F0;
  Canvas.Pen.Color:= $ACACAC;

  R:= Rect(Width - PPIScale(19), 2, Width - 2, PPIScale(11));
  Canvas.FillRect(R);
  R.Inflate(-1, -1);
  Canvas.Rectangle(R);

  R:= Rect(Width - PPIScale(19), newHeight - PPIScale(11), Width - 2, newHeight - 2);
  Canvas.FillRect(R);
  R.Inflate(-1, -1);
  Canvas.Rectangle(R);

  Canvas.Brush.Color:= clBlack;
  Canvas.Pen.Color:= clBlack;
  x:= Width - PPIScale(13);
  y:= PPIScale(7);
  var i2:= PPIScale(2);
  var i4:= PPIScale(4);
  Points[0]:= Point(x, y);
  Points[1]:= Point(x + i4, y);
  Points[2]:= Point(x + i2, y - i2);
  Canvas.Polygon(Points);

  y:= newHeight - PPIScale(8);
  Points[0]:= Point(x, y);
  Points[1]:= Point(x + i4, y);
  Points[2]:= Point(x + i2, y + i2);
  Canvas.Polygon(Points);
  PaintAScrollbar(Scrollbar);
end;

{--- TKKCombobox --------------------------------------------------------------}

constructor TTKCombobox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Tag:= 38;
  Width:= 80;
  Height:= 24;
  Foreground:= clBtnText;
  FValues:= TStringList.Create;
  FValues.Text:= defaultItems;
end;

destructor TTKCombobox.Destroy;
begin
  FreeAndNil(FValues);
  inherited;
end;

function TTKCombobox.getAttributes(ShowAttributes: Integer): string;
begin
  Result:= '|Value|Values';
  if ShowAttributes >= 2 then
    Result:= Result + '|PostCommand';
  Result:= Result + inherited getAttributes(ShowAttributes);
end;

function TTKCombobox.getListItems: string;
  var s: string; i: Integer;
begin
  s:= '[';
  for i:= 0 to FValues.Count -1 do
    s:= s + asString(FValues[i]) + ', ';
  Delete(s, Length(s) - 1, 2);
  Result:= s + ']';
end;

procedure TTKCombobox.setAttribute(Attr, Value, Typ: string);
begin
  if Attr = 'Value' then
    setValue(Name + 'CV', asString(Value))
  else if Attr = 'Values' then
    inherited setAttribute(Attr, getListItems, 'Source')
  else if Attr = 'ValidateCommand' then
    MakeValidateCommand(Attr, Value)
  else
    inherited;
end;

procedure TTKCombobox.setRValue(aValue: string);
begin
  if FValue <> aValue then begin
    FValue:= aValue;
    Invalidate;
  end;
end;

procedure TTKCombobox.setValues(Values: TStrings);
begin
  FValues.Assign(Values);
  Invalidate;
end;

procedure TTKCombobox.NewWidget(Widget: string = '');
begin
  Partner.ActiveSynEdit.BeginUpdate;
  inherited NewWidget('ttk.Combobox');
  MakeControlVar('textvariable', Name + 'CV', FValue);
  InsertValue('self.' + Name + '[' + asString('values') + '] = ' + getListItems);
  Partner.ActiveSynEdit.EndUpdate;
end;

procedure TTKCombobox.DeleteWidget;
begin
  inherited;
  if FPostCommand then Partner.DeleteMethod(Name + '_PostCommand');
end;

procedure TTKCombobox.Paint;
  var s: string; x, y, newHeight, i3, i4, i5, i8, i10: Integer;
begin
  Canvas.Pen.Color:= $7A7A7A;
  inherited;
  i3:= PPIScale(3);
  i4:= PPIScale(4);
  i5:= PPIScale(5);
  i8:= PPIScale(8);
  i10:= PPIScale(10);
  if FValue <> ''
    then s:= FValue
    else if FValues.Count > 0
      then s:= FValues[0]
      else s:= '';
  if Scrollbar
    then newHeight:= Height - 20
    else newHeight:= Height;
  ShowText(s, Width - PPIScale(16), newHeight);

  x:= Width - PPIScale(14);
  y:= newHeight div 2 - 2;
  Canvas.Pen.Color:= $F1F1F1;
  Canvas.MoveTo(x, y);
  Canvas.LineTo(x + i4, y + i4);
  Canvas.LineTo(x + i5, y + i4);
  Canvas.LineTo(x + i10, y -1);

  Canvas.Pen.Color:= $5C5C5C;
  x:= x + 1;
  Canvas.MoveTo(x, y);
  Canvas.LineTo(x + i3, y + i3);
  Canvas.LineTo(x + i4, y + i3);
  Canvas.LineTo(x + i8, y - 1);

  y:= y - 1;
  Canvas.Pen.Color:= $ADADAD;
  Canvas.MoveTo(x, y);
  Canvas.LineTo(x + i3, y + i3);
  Canvas.LineTo(x + i4, y + i3);
  Canvas.LineTo(x + i8, y - 1);
  PaintAScrollbar(Scrollbar);
end;

end.

