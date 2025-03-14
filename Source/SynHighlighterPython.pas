﻿{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: SynHighlighterPython.pas, released 2000-06-23.
The Original Code is based on the odPySyn.pas file from the
mwEdit component suite by Martin Waldenburg and other developers, the Initial
Author of this file is Olivier Deckmyn.
Portions created by M.Utku Karatas and Dennis Chuah.
Unicode translation by Maλl Hφrz.
All Rights Reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.
-------------------------------------------------------------------------------}
{
@abstract(A Python language highlighter for SynEdit)
@author(Olivier Deckmyn, converted to SynEdit by David Muir <dhmn@dmsoftware.co.uk>)
@created(unknown, converted to SynEdit on 2000-06-23)
@lastmod(2003-02-13)
The SynHighlighterPython implements a highlighter for Python for the SynEdit projects.
}
unit SynHighlighterPython;

interface

uses
  System.SysUtils,
  System.Classes,
  System.RegularExpressions,
  Vcl.Graphics,
  SynEditHighlighter,
  SynEditCodeFolding,
  StringResources,
  SynEditTypes;

type
  TtkTokenKind = (tkComment, tkIdentifier, tkKey, tkNull, tkNumber, tkSpace,
    tkString, tkSymbol, tkNonKeyword, tkCodeComment, tkTrippleQuotedString,
    tkTrippleQuotedString2, tkFunctionName, tkClassName, tkSystemDefined, tkHex,
    tkOct, tkFloat, tkUnknown,
    // used in the interpreter
    tkBanner, tkOutput, tkTraceback,
    tkPrompt, tkSystemCmd);

  TRangeState = (rsANil, rsComment, rsUnKnown, rsMultilineString, rsMultilineString2,
                 rsMultilineString3, //this is to indicate if a string is made multiline by backslash char at line end (as in C++ highlighter)
                 rsTraceback  // used in the interpreter
                );

  TPyFoldType = (pftCodeBlock, pftMultiLineStringFoldType, pftClassDefType, pftFunctionDefType);

  TSynPythonSyn = class(TSynCustomCodeFoldingHighlighter)
  private
    fStringStarter: WideChar;  // used only for rsMultilineString3 stuff
    fRange: TRangeState;
    FTokenID: TtkTokenKind;
    FKeywords: TStringList;
    fLastIdentifier : UnicodeString;
    fStringAttri: TSynHighlighterAttributes;
    fDocStringAttri: TSynHighlighterAttributes;
    fMultiLineStringAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fHexAttri: TSynHighlighterAttributes;
    fOctalAttri: TSynHighlighterAttributes;
    fFloatAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNonKeyAttri: TSynHighlighterAttributes;
    fSystemAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fCommentAttri: TSynHighlighterAttributes;
    fCodeCommentAttri: TSynHighlighterAttributes;
    fFunctionNameAttri: TSynHighlighterAttributes;
    fClassNameAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fErrorAttri: TSynHighlighterAttributes;
    fMatchingBraceAttri: TSynHighlighterAttributes;
    fUnbalancedBraceAttri: TSynHighlighterAttributes;
    fTempSpaceAttri: TSynHighlighterAttributes;
    BlockOpenerRE: TRegEx;
    function IdentKind(MayBe: PWideChar): TtkTokenKind;
    procedure SymbolProc;
    procedure CRProc;
    procedure CommentProc;
    procedure GreaterProc;
    procedure IdentProc;
    procedure LFProc;
    procedure LowerProc;
    procedure NullProc;
    procedure NumberProc;
    procedure SpaceProc;
    procedure PreStringProc;
    procedure StringProc;
    procedure String2Proc;
    procedure StringEndProc(EndChar: WideChar);
    procedure UnknownProc;
  protected
    function GetSampleSource: UnicodeString; override;
    function IsFilterStored: Boolean; override;
    procedure GetKeywordIdentifiers(KeywordList: TStrings); virtual;
    property TokenID: TtkTokenKind read FTokenID;
    procedure DispatchProc; virtual;
  public
    class function GetCapabilities: TSynHighlighterCapabilities; override;
    class function GetLanguageName: string; override;
    class function GetFriendlyLanguageName: UnicodeString; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsIdentChar(AChar: WideChar): Boolean; override;
    function GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetRange: Pointer; override;
    function GetTokenID: TtkTokenKind;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: Integer; override;
    procedure Next; override;
    procedure SetRange(Value: Pointer); override;
    procedure ResetRange; override;
    function GetKeyWords(TokenKind: Integer): UnicodeString; override;
    procedure InitFoldRanges(FoldRanges : TSynFoldRanges); override;
    procedure ScanForFoldRanges(FoldRanges: TSynFoldRanges;
      LinesToScan: TStrings; FromLine: Integer; ToLine: Integer); override;
    procedure AdjustFoldRanges(FoldRanges: TSynFoldRanges;
      LinesToScan: TStrings); override;
    function FlowControlAtLine(Lines: TStrings; Line: Integer): TSynFlowControl; override;
    property Keywords: TStringList read FKeywords;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri
      write fCommentAttri;
    property CodeCommentAttri: TSynHighlighterAttributes read fCodeCommentAttri
      write fCodeCommentAttri;
    property FunctionNameAttri: TSynHighlighterAttributes read fFunctionNameAttri
      write fFunctionNameAttri;
    property ClassNameAttri: TSynHighlighterAttributes read fClassNameAttri
      write fClassNameAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri
      write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NonKeyAttri: TSynHighlighterAttributes read fNonKeyAttri
      write fNonKeyAttri;
    property SystemAttri: TSynHighlighterAttributes read fSystemAttri
      write fSystemAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri
      write fNumberAttri;
    property HexAttri: TSynHighlighterAttributes read fHexAttri
      write fHexAttri;
    property OctalAttri: TSynHighlighterAttributes read fOctalAttri
      write fOctalAttri;
    property FloatAttri: TSynHighlighterAttributes read fFloatAttri
      write fFloatAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri
      write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri
      write fStringAttri;
    property DocStringAttri: TSynHighlighterAttributes read fDocStringAttri
      write fDocStringAttri;
    property MultiLineStringAttri: TSynHighlighterAttributes read fMultiLineStringAttri
      write fMultiLineStringAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri
      write fSymbolAttri;
    property ErrorAttri: TSynHighlighterAttributes read fErrorAttri
      write fErrorAttri;
    property MatchingBraceAttri : TSynHighlighterAttributes read fMatchingBraceAttri
      write fMatchingBraceAttri;
    property UnbalancedBraceAttri : TSynHighlighterAttributes read fUnbalancedBraceAttri
      write fUnbalancedBraceAttri;
  end;

  TSynPythonInterpreterSyn = class(TSynPythonSyn)
  private
    fPS1 : string;
    fPS2 : string;
    fDbg : string;
    fPM : string;
    fBannerAttri: TSynHighlighterAttributes;
    fOutputAttri: TSynHighlighterAttributes;
    fTracebackAttri: TSynHighlighterAttributes;
    fPromptAttri: TSynHighlighterAttributes;
    fSystemCmdAttri: TSynHighlighterAttributes;
    fTracebackStartRE: TRegEx;
    fTracebackEndRE: TRegEx;
    fSystemCmdRE: TRegEx;
    procedure BannerProc;
    procedure OutputProc;
    procedure TracebackProc;
    procedure PromptProc(Len : Integer);
    procedure SystemCmdProc;
  protected
    procedure DispatchProc; override;
    function GetSampleSource: UnicodeString; override;
  public
    class function GetLanguageName: string; override;
    class function GetFriendlyLanguageName: UnicodeString; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
  published
    property BannerAttri: TSynHighlighterAttributes read fBannerAttri
      write fBannerAttri;
    property OutputAttri: TSynHighlighterAttributes read fOutputAttri
      write fOutputAttri;
    property TracebackAttri: TSynHighlighterAttributes read fTracebackAttri
      write fTracebackAttri;
    property PromptAttri: TSynHighlighterAttributes read fPromptAttri
      write fPromptAttri;
    property SystemCmdAttri: TSynHighlighterAttributes read fSystemCmdAttri
      write fSystemCmdAttri;
    property PS1 : string read fPS1 write fPS1;
    property PS2 : string read fPS2 write fPS2;
    property Dbg : string read fDbg write fDbg;
    property PM : string read fPM write fPM;
  end;

  TSynCythonSyn = class(TSynPythonSyn)
  protected
    procedure GetKeywordIdentifiers(KeywordList: TStrings); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddCythonKeywords(KeywordList: TStrings);
    class function GetLanguageName: string; override;
    class function GetFriendlyLanguageName: UnicodeString; override;
  end;

const
  SYNS_CommentedCode = 'Commented Code';
  SYNS_FunctionName = 'Function Name';
  SYNS_ClassName = 'Class Name';
  SYNS_MatchingBrace = 'Matching Brace';
  SYNS_UnbalancedBrace = 'Unbalanced Brace';
  SYNS_MultiLineString = 'Multi-Line String';
  SYNS_FilterCython =  sCythonFileFilter;

resourcestring
  SYNS_FriendlyCommentedCode = 'Commented Code';
  SYNS_FriendlyFunctionName = 'Function Name';
  SYNS_FriendlyClassName = 'Class Name';
  SYNS_FriendlyMatchingBrace = 'Matching Brace';
  SYNS_FriendlyUnbalancedBrace = 'Unbalanced Brace';
  SYNS_FriendlyMultiLineString = 'Multi-Line String';

implementation

uses
  System.Character,
  System.RegularExpressionsCore,
  SynEditStrConst,
  SynEditMiscProcs;

function TSynPythonSyn.GetKeyWords(TokenKind: Integer): UnicodeString;
begin
  Result := Keywords.CommaText;
end;

procedure TSynPythonSyn.GetKeywordIdentifiers(KeywordList: TStrings);
const
  // No need to localise keywords!

  // List of keywords
  KEYWORDCOUNT = 31;
  KEYWORDS: array [1..KEYWORDCOUNT] of UnicodeString =
    (
    'and',
    'as',
    'assert',
    'break',
    'class',
    'continue',
    'def',
    'del',
    'elif',
    'else',
    'except',
    'exec',
    'finally',
    'for',
    'from',
    'global',
    'if',
    'import',
    'in',
    'is',
    'lambda',
    'not',
    'or',
    'pass',
    'print',
    'raise',
    'return',
    'try',
    'with',
    'while',
    'yield'
    );

  // List of non-keyword identifiers
  NONKEYWORDCOUNT = 137;
  NONKEYWORDS: array [1..NONKEYWORDCOUNT] of UnicodeString =
    (
    'ArithmeticError',
    'AssertionError',
    'AttributeError',
    'BaseException',
    'DeprecationWarning',
    'EOFError',
    'Ellipsis',
    'EnvironmentError',
    'Exception',
    'False',
    'FloatingPointError',
    'FutureWarning',
    'GeneratorExit',
    'IOError',
    'ImportError',
    'ImportWarning',
    'IndentationError',
    'IndexError',
    'KeyError',
    'KeyboardInterrupt',
    'LookupError',
    'MemoryError',
    'NameError',
    'None',
    'NotImplemented',
    'NotImplementedError',
    'OSError',
    'OverflowError',
    'PendingDeprecationWarning',
    'ReferenceError',
    'RuntimeError',
    'RuntimeWarning',
    'StandardError',
    'StopIteration',
    'SyntaxError',
    'SyntaxWarning',
    'SystemError',
    'SystemExit',
    'TabError',
    'True',
    'TypeError',
    'UnboundLocalError',
    'UnicodeDecodeError',
    'UnicodeEncodeError',
    'UnicodeError',
    'UnicodeTranslateError',
    'UnicodeWarning',
    'UserWarning',
    'ValueError',
    'Warning',
    'WindowsError',
    'ZeroDivisionError',
    '_',
    '__debug__',
    '__doc__',
    '__future__',
    '__import__',
    '__name__',
    'abs',
    'all',
    'any',
    'apply',
    'basestring',
    'bool',
    'buffer',
    'callable',
    'chr',
    'classmethod',
    'cmp',
    'coerce',
    'compile',
    'complex',
    'copyright',
    'credits',
    'delattr',
    'dict',
    'dir',
    'divmod',
    'enumerate',
    'eval',
    'execfile',
    'exit',
    'file',
    'filter',
    'float',
    'frozenset',
    'getattr',
    'globals',
    'hasattr',
    'hash',
    'help',
    'hex',
    'id',
    'input',
    'int',
    'intern',
    'isinstance',
    'issubclass',
    'iter',
    'len',
    'license',
    'list',
    'locals',
    'long',
    'map',
    'max',
    'min',
    'object',
    'oct',
    'open',
    'ord',
    'pow',
    'property',
    'quit',
    'range',
    'raw_input',
    'reduce',
    'reload',
    'repr',
    'reversed',
    'round',
    'self',
    'set',
    'setattr',
    'slice',
    'sorted',
    'staticmethod',
    'str',
    'sum',
    'super',
    'tuple',
    'type',
    'unichr',
    'unicode',
    'vars',
    'xrange',
    'zip'
    );
var
  f: Integer;
begin
  for f := 1 to KEYWORDCOUNT do
    KeywordList.AddObject(KEYWORDS[f], Pointer(Ord(tkKey)));
  for f := 1 to NONKEYWORDCOUNT do
    KeywordList.AddObject(NONKEYWORDS[f], Pointer(Ord(tkNonKeyword)));
end;

function TSynPythonSyn.IdentKind(MayBe: PWideChar): TtkTokenKind;
var
  i: Integer;
  temp: PWideChar;
  s: UnicodeString;
begin
  // Extract the identifier out - it is assumed to terminate in a
  //   non-alphanumeric character
  fToIdent := MayBe;
  temp := MayBe;
  while IsIdentChar(temp^) do
    Inc(temp);
  fStringLen := temp - fToIdent;

  SetString(s, fToIdent, fStringLen);

  // Check to see if it is a keyword
  if ((Run <= 0) or (FLine[Run-1]<> '.')) and (fLastIdentifier <> 'class') and
    (fLastIdentifier <> 'def') and FKeywords.Find(s, i) then
  begin
//    // TStringList is not case sensitive!  KV Not now using Delphi's StringList
//    if s <> FKeywords[i] then
//      i := -1;
  end
  else
    i := -1;

  if i <> -1 then
    Result := TtkTokenKind(FKeywords.Objects[i])

  // Check if it is a class name
  else if fLastIdentifier = 'class' then
    Result := tkClassName

  // Check if it is a function name
  else if fLastIdentifier = 'def' then
    Result := tkFunctionName

  // Check if it is a system identifier (__*__)
  else if (fStringLen >= 5) and
     (MayBe[0] = '_') and (MayBe[1] = '_') and (MayBe[2] <> '_') and
     (MayBe[fStringLen - 1] = '_') and (MayBe[fStringLen - 2] = '_') and
     (MayBe[fStringLen - 3] <> '_') then
    Result := tkSystemDefined

  // Else, hey, it is an ordinary run-of-the-mill identifier!
  else
    Result := tkIdentifier;

  //fLastIdentifier := s;
  SetString(fLastIdentifier, fToIdent, fStringLen);
end;

constructor TSynPythonSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fCaseSensitive := True;

  FKeywords := TStringList.Create;
  GetKeywordIdentifiers(FKeywords);
  FKeywords.CaseSensitive := True;
  FKeywords.Duplicates := dupIgnore;
  FKeywords.Sorted := True;

  BlockOpenerRE := CompiledRegEx(
     '^(def|class|while|for|if|else|elif|try|except|finally|with'+
     '|(async[ \t]+def)|(async[ \t]+with)|(async[ \t]+for))\b');

  fRange := rsUnknown;
  fCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrComment, SYNS_FriendlyAttrComment);
  fCommentAttri.Foreground := clGray;
  fCommentAttri.Style := [fsItalic];
  AddAttribute(fCommentAttri);
  fCodeCommentAttri := TSynHighlighterAttributes.Create(SYNS_CommentedCode, SYNS_FriendlyCommentedCode);
  fCodeCommentAttri.Foreground := clSilver;
  fCodeCommentAttri.Style := [fsItalic];
  AddAttribute(fCodeCommentAttri);
  fFunctionNameAttri := TSynHighlighterAttributes.Create(SYNS_FunctionName, SYNS_FriendlyFunctionName);
  fFunctionNameAttri.Foreground := clTeal;
  fFunctionNameAttri.Style := [fsBold];
  AddAttribute(fFunctionNameAttri);
  fClassNameAttri := TSynHighlighterAttributes.Create(SYNS_ClassName, SYNS_FriendlyClassName);
  fClassNameAttri.Foreground := clNavy;
  fClassNameAttri.Style := [fsBold];
  AddAttribute(fClassNameAttri);
  fIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier, SYNS_FriendlyAttrIdentifier);
  fIdentifierAttri.Foreground := clBlack;
  AddAttribute(fIdentifierAttri);
  fKeyAttri := TSynHighlighterAttributes.Create(SYNS_AttrReservedWord, SYNS_FriendlyAttrReservedWord);
  fKeyAttri.Foreground := clNavy;
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);
  fNonKeyAttri := TSynHighlighterAttributes.Create (SYNS_AttrNonReservedKeyword, SYNS_FriendlyAttrNonReservedKeyword);
  fNonKeyAttri.Foreground := clNavy;
  AddAttribute (fNonKeyAttri);
  fSystemAttri := TSynHighlighterAttributes.Create (SYNS_AttrSystem, SYNS_FriendlyAttrSystem);
  fSystemAttri.Style := [fsBold];
  AddAttribute (fSystemAttri);
  fNumberAttri := TSynHighlighterAttributes.Create(SYNS_AttrNumber, SYNS_FriendlyAttrNumber);
  fNumberAttri.Foreground := clTeal;
  AddAttribute(fNumberAttri);
  fHexAttri := TSynHighlighterAttributes.Create(SYNS_AttrHexadecimal, SYNS_FriendlyAttrHexadecimal);
  fHexAttri.Foreground := clTeal;
  AddAttribute(fHexAttri);
  fOctalAttri := TSynHighlighterAttributes.Create(SYNS_AttrOctal, SYNS_FriendlyAttrOctal);
  fOctalAttri.Foreground := clTeal;
  AddAttribute(fOctalAttri);
  fFloatAttri := TSynHighlighterAttributes.Create(SYNS_AttrFloat, SYNS_FriendlyAttrFloat);
  fFloatAttri.Foreground := clTeal;
  AddAttribute(fFloatAttri);
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace, SYNS_FriendlyAttrSpace);
  fSpaceAttri.Background := clWhite;
  fSpaceAttri.Foreground := clSilver;
  AddAttribute(fSpaceAttri);
  fStringAttri := TSynHighlighterAttributes.Create(SYNS_AttrString, SYNS_FriendlyAttrString);
  fStringAttri.Foreground := clOlive;
  AddAttribute(fStringAttri);
  fDocStringAttri := TSynHighlighterAttributes.Create(SYNS_AttrDocumentation, SYNS_FriendlyAttrDocumentation);
  fDocStringAttri.Foreground := $FF00CC;
  AddAttribute(fDocStringAttri);
  fMultiLineStringAttri := TSynHighlighterAttributes.Create(SYNS_MultiLineString, SYNS_FriendlyMultiLineString);
  fMultiLineStringAttri.Foreground := clOlive;
  AddAttribute(fMultiLineStringAttri);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol, SYNS_FriendlyAttrSymbol);
  fSymbolAttri.Foreground := clMaroon;
  AddAttribute(fSymbolAttri);
  fErrorAttri := TSynHighlighterAttributes.Create(SYNS_AttrSyntaxError, SYNS_FriendlyAttrSyntaxError);
  fErrorAttri.Foreground := clRed;
  AddAttribute(fErrorAttri);
  fMatchingBraceAttri := TSynHighlighterAttributes.Create(SYNS_MatchingBrace, SYNS_FriendlyMatchingBrace);
  fMatchingBraceAttri.Foreground := clBlue;
  fMatchingBraceAttri.Style := [fsBold];
  AddAttribute(fMatchingBraceAttri);
  fUnbalancedBraceAttri := TSynHighlighterAttributes.Create(SYNS_UnbalancedBrace, SYNS_FriendlyUnbalancedBrace);
  fUnbalancedBraceAttri.Background := clRed;
  fUnbalancedBraceAttri.Foreground := clYellow;
  AddAttribute(fUnbalancedBraceAttri);

  SetAttributesOnChange(DefHighlightChange);
  fDefaultFilter := SYNS_FilterPython;
  // for coloring doc comment background
  fTempSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace, SYNS_FriendlyAttrSpace);
end; { Create }

destructor TSynPythonSyn.Destroy;
begin
  FKeywords.Free;
  fTempSpaceAttri.Free;
  inherited;
end;

procedure TSynPythonSyn.SymbolProc;
begin
  Inc(Run);
  fTokenID := tkSymbol;
end;

procedure TSynPythonSyn.CRProc;
begin
  fTokenID := tkSpace;
  case FLine[Run + 1] of
    #10: Inc(Run, 2);
  else
    Inc(Run);
  end;
end;

procedure TSynPythonSyn.AdjustFoldRanges(FoldRanges: TSynFoldRanges;
  LinesToScan: TStrings);
var
  I: Integer;
begin
  inherited;
  for I := 0 to FoldRanges.Count - 1 do
    with FoldRanges.Ranges.List[I] do
      if FoldType <> Integer(pftCodeBlock) then
        Indent := 0;
end;

procedure TSynPythonSyn.CommentProc;
begin
  Inc(Run);
  if FLine[Run] = '#' then
    fTokenID := tkCodeComment
  else
    fTokenID := tkComment;
  while not IsLineEnd(Run) do
    Inc(Run);
end;

procedure TSynPythonSyn.GreaterProc;
begin
  case FLine[Run + 1] of
    '=': begin
        Inc(Run, 2);
        fTokenID := tkSymbol;
      end;
  else begin
      Inc(Run);
      fTokenID := tkSymbol;
    end;
  end;
end;

procedure TSynPythonSyn.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  Inc(Run, fStringLen);
end;

procedure TSynPythonSyn.LFProc;
begin
  fTokenID := tkSpace;
  Inc(Run);
end;

procedure TSynPythonSyn.LowerProc;
begin
  case FLine[Run + 1] of
    '=': begin
        Inc(Run, 2);
        fTokenID := tkSymbol;
      end;
    '>': begin
        Inc(Run, 2);
        fTokenID := tkSymbol;
      end
  else begin
      Inc(Run);
      fTokenID := tkSymbol;
    end;
  end;
end;

procedure TSynPythonSyn.NullProc;
begin
  fTokenID := tkNull;
  Inc(Run);
end;

procedure TSynPythonSyn.NumberProc;
type
  TNumberState =
    (
    nsStart,
    nsDotFound,
    nsHex,
    nsOct,
    nsBinary,
    nsExpFound
    );

var
  temp: WideChar;
  State: TNumberState;

  function CheckSpecialCases: Boolean;
  begin
    case temp of
      // Look for dot (.)
      '.': begin
        // .45
        if CharInSet(FLine[Run], ['0'..'9']) then
        begin
          Inc(Run);
          fTokenID := tkFloat;
          State := nsDotFound;

        // Non-number dot
        end else begin
          // Ellipsis
          if (FLine[Run] = '.') and (FLine[Run+1] = '.') then
            Inc (Run, 2);
          fTokenID := tkSymbol;
          Result := False;
          Exit;
        end; // if
      end; // DOT

      // Look for zero (0)
      '0': begin
        temp := FLine[Run];
        // 0x123ABC
        if CharInSet(temp, ['x', 'X']) then begin
          Inc (Run);
          fTokenID := tkHex;
          State := nsHex;
        // 0o123
        end else if CharInSet(temp, ['o', 'O']) then begin
          Inc (Run);
          fTokenID := tkOct;
          State := nsOct;
        // 0b1010
        end else if CharInSet(temp, ['b', 'B']) then begin
          Inc (Run);
          fTokenID := tkOct; //paint same as octal
          State := nsBinary;
        // 0.45
        end else if temp = '.' then begin
          Inc (Run);
          State := nsDotFound;
          fTokenID := tkFloat;
        end; // if
      end; // ZERO
    end; // case

    Result := True;
  end; // CheckSpecialCases

  function HandleBadNumber: Boolean;
  begin
    Result := False;
    fTokenID := tkUnknown;
    // Ignore all tokens till end of "number"
    while IsIdentChar(FLine[Run]) or (FLine[Run] = '.') do
      Inc (Run);
  end; // HandleBadNumber

  function HandleExponent: Boolean;
  begin
    State := nsExpFound;
    fTokenID := tkFloat;
    // Skip e[+/-]
    if CharInSet(FLine[Run+1], ['+', '-']) then
      Inc (Run);
    // Invalid token : 1.0e
    if not CharInSet(FLine[Run+1], ['0'..'9']) then begin
      Inc (Run);
      Result := HandleBadNumber;
      Exit;
    end; // if

    Result := True;
  end; // HandleExponent

  function HandleDot: Boolean;
  begin
    // Check for ellipsis
    Result := (FLine[Run+1] <> '.') or (FLine[Run+2] <> '.');
    if Result then begin
      State := nsDotFound;
      fTokenID := tkFloat;
    end; // if
  end; // HandleDot

  function CheckStart: Boolean;
  begin
    // Allow underscores inside the number
    if temp = '_' then begin
      if CharInSet(FLine[Run + 1], ['0'..'9']) then
        Result := True
      else
        Result := HandleBadNumber;
    // 1234
    end else if CharInSet(temp, ['0'..'9']) then begin
      Result := True;
    //123e4
    end else if CharInSet(temp, ['e', 'E']) then begin
      Result := HandleExponent;
    // 123.45j
    end else if CharInSet(temp, ['j', 'J']) then begin
      Inc (Run);
      fTokenID := tkFloat;
      Result := False;
    // 123.45
    end else if temp = '.' then begin
      Result := HandleDot;
    // Error!
    end else if IsIdentChar(temp) then begin
      Result := HandleBadNumber;
    // End of number
    end else begin
      Result := False;
    end; // if
  end; // CheckStart

  function CheckDotFound: Boolean;
  begin
    // Allow underscores inside the number
    if temp = '_' then begin
      if CharInSet(FLine[Run - 1], ['0'..'9']) and
        CharInSet(FLine[Run + 1], ['0'..'9'])
      then
        Result := True
      else
        Result := HandleBadNumber;
    // 1.0e4
    end else if CharInSet(temp, ['e', 'E']) then begin
      Result := HandleExponent;
    // 123.45
    end else if CharInSet(temp, ['0'..'9']) then begin
      Result := True;
    // 123.45j
    end else if CharInSet(temp, ['j', 'J']) then begin
      Inc (Run);
      Result := False;
    // 123.45.45: Error!
    end else if temp = '.' then begin
      Result := False;
      if HandleDot then
        HandleBadNumber;
    // Error!
    end else if IsIdentChar(temp) then begin
      Result := HandleBadNumber;
    // End of number
    end else begin
      Result := False;
    end; // if
  end; // CheckDotFound

  function CheckSpecialInt(ValidChars: TSysCharSet): Boolean;
  begin
    // Allow underscores inside the number
    if temp = '_' then begin
      if CharInSet(FLine[Run - 1], ValidChars) and
        CharInSet(FLine[Run + 1], ValidChars)
      then
        Result := True
      else
        Result := HandleBadNumber;
    end else if CharInSet(temp, ValidChars) then
    begin
      Result := True;
    end else if CharInSet(temp, ['l', 'L']) then begin
      Inc (Run);
      Result := False;
    end else if temp = '.' then begin
      Result := False;
      if HandleDot then
        HandleBadNumber;
    end else if IsIdentChar(temp) then begin
      Result := HandleBadNumber;
    end else begin
      Result := False;
    end; // if
  end; // CheckHex

  function CheckExpFound: Boolean;
  begin
    // Allow underscores inside the number
    if temp = '_' then begin
      if CharInSet(FLine[Run - 1], ['0'..'9']) and
        CharInSet(FLine[Run + 1], ['0'..'9'])
      then
        Result := True
      else
        Result := HandleBadNumber;
    // 1e+123
    end else if CharInSet(temp, ['0'..'9']) then begin
      Result := True;
    // 1e+123j
    end else if CharInSet(temp, ['j', 'J']) then begin
      Inc (Run);
      Result := False;
    // 1e4.5: Error!
    end else if temp = '.' then begin
      Result := False;
      if HandleDot then
        HandleBadNumber;
    // Error!
    end else if IsIdentChar(temp) then begin
      Result := HandleBadNumber;
    // End of number
    end else begin
      Result := False;
    end; // if
  end; // CheckExpFound

begin
  State := nsStart;
  fTokenID := tkNumber;

  temp := FLine[Run];
  Inc (Run);

  // Special cases
  if not CheckSpecialCases then
    Exit;

  // Use a state machine to parse numbers
  while True do begin
    temp := FLine[Run];

    case State of
      nsStart:
        if not CheckStart then Exit;
      nsDotFound:
        if not CheckDotFound then Exit;
      nsHex:
        if not CheckSpecialInt(['a'..'f', 'A'..'F', '0'..'9']) then Exit;
      nsOct:
        if not CheckSpecialInt(['0'..'7']) then Exit;
      nsBinary:
        if not CheckSpecialInt(['0'..'1']) then Exit;
      nsExpFound:
        if not CheckExpFound then Exit;
    end; // case

    Inc (Run);
  end; // while
end;

procedure TSynPythonSyn.SpaceProc;
begin
  Inc(Run);
  fTokenID := tkSpace;
  while (FLine[Run] <= #32) and not IsLineEnd(Run) do Inc(Run);
end;

procedure TSynPythonSyn.String2Proc;
var
  fBackslashCount: Integer;
begin
  fTokenID := tkString;
  if (FLine[Run + 1] = '"') and (FLine[Run + 2] = '"') then
  begin
    fTokenID := tkTrippleQuotedString2;
    Inc(Run, 3);

    fRange := rsMultilineString2;
    while fLine[Run] <> #0 do
    begin
      case fLine[Run] of

        '\':begin
               { If we're looking at a backslash, and the following character is an
               end quote, and it's preceeded by an odd number of backslashes, then
               it shouldn't mark the end of the string.  If it's preceeded by an
               even number, then it should. !!!THIS RULE DOESNT APPLY IN RAW STRINGS}
               if FLine[Run + 1] = '"' then
                 begin
                   fBackslashCount := 1;

                   while ((Run > fBackslashCount) and (FLine[Run - fBackslashCount] = '\')) do
                     fBackslashCount := fBackslashCount + 1;

                   if (fBackslashCount mod 2 = 1) then Inc(Run)
               end;
               Inc(Run);
            end;// '\':

        '"':
          if (fLine[Run + 1] = '"') and (fLine[Run + 2] = '"') then begin
            fRange := rsUnKnown;
            Inc(Run, 3);
            Exit;
          end else
            Inc(Run);
        #10: Exit;
        #13: Exit;
        else
          Inc(Run);
      end;
    end;
  end
  else //if short string
  repeat
    case FLine[Run] of
      #0, #10, #13:
        begin
          if FLine[Run-1] = '\' then
          begin
            fStringStarter := '"';
            fRange := rsMultilineString3;
          end;
          Break;
        end;
      {The same backslash stuff above...}
      '\':begin
             if FLine[Run + 1] = '"' then
               begin
                 fBackslashCount := 1;

                 while ((Run > fBackslashCount) and (FLine[Run - fBackslashCount] = '\')) do
                   fBackslashCount := fBackslashCount + 1;

                 if (fBackslashCount mod 2 = 1) then Inc(Run)
             end;
             Inc(Run);
          end;// '\':

      else Inc(Run);
    end; //case
  until (FLine[Run] = '"');
  if FLine[Run] <> #0 then Inc(Run);
end;

procedure TSynPythonSyn.PreStringProc;
// Handle string prefixes
// Valid prefixes: u, b, r, f, br, rb, rf, fr possibly capitalized
var
  PrefixLen: Integer;
begin
  PrefixLen := 0;
  case FLine[Run] of
    'u', 'U':
        if CharInSet(FLine[Run + 1], ['"', '''']) then
          PrefixLen := 1;
    'b', 'B':
      case FLine[Run + 1] of
        '"', '''': PrefixLen := 1;
        'r', 'R':
            if CharInSet(FLine[Run + 2], ['"', '''']) then
              PrefixLen := 2;
      end;
    'r', 'R':
      case FLine[Run + 1] of
        '"', '''': PrefixLen := 1;
        'b', 'B', 'f', 'F':
            if CharInSet(FLine[Run + 2], ['"', '''']) then
              PrefixLen := 2;
      end;
    'f', 'F':
      case FLine[Run + 1] of
        '"', '''': PrefixLen := 1;
        'r', 'R':
            if CharInSet(FLine[Run + 2], ['"', '''']) then
              PrefixLen := 2;
      end;
  end;

  if PrefixLen > 0 then
  begin
    Inc(Run, PrefixLen);
    if FLine[Run] = '"' then
      String2Proc
    else
      StringProc
  end
  else
    IdentProc;
end;

procedure TSynPythonSyn.StringProc;
var
  fBackslashCount: Integer;
begin
  fTokenID := tkString;
  if (FLine[Run + 1] = #39) and (FLine[Run + 2] = #39) then begin
    fTokenID := tkTrippleQuotedString;
    Inc(Run, 3);

    fRange:=rsMultilineString;
    while fLine[Run] <> #0 do begin
      case fLine[Run] of

        '\': begin
             { If we're looking at a backslash, and the following character is an
             end quote, and it's preceeded by an odd number of backslashes, then
             it shouldn't mark the end of the string.  If it's preceeded by an
             even number, then it should. !!!THIS RULE DOESNT APPLY IN RAW STRINGS}
              if FLine[Run + 1] = #39 then
                begin
                  fBackslashCount := 1;

                  while ((Run > fBackslashCount) and (FLine[Run - fBackslashCount] = '\')) do
                    fBackslashCount := fBackslashCount + 1;

                  if (fBackslashCount mod 2 = 1) then Inc(Run)
              end;
              Inc(Run);
            end;// '\':

        #39:
          if (fLine[Run + 1] = #39) and (fLine[Run + 2] = #39) then begin
            fRange := rsUnKnown;
            Inc(Run, 3);
            EXIT;
          end else
            Inc(Run);
        #10: EXIT;
        #13: EXIT;
        else
          Inc(Run);
      end;
    end;
  end
      else //if short string
  repeat
    case FLine[Run] of
      #0, #10, #13 : begin
        if FLine[Run-1] = '\' then begin
          fStringStarter := #39;
          fRange := rsMultilineString3;
        end;
        BREAK;
        end;

      {The same backslash stuff above...}
      '\':begin
             if FLine[Run + 1] = #39 then
               begin
                 fBackslashCount := 1;

                 while ((Run > fBackslashCount) and (FLine[Run - fBackslashCount] = '\')) do
                   fBackslashCount := fBackslashCount + 1;

                 if (fBackslashCount mod 2 = 1) then Inc(Run)
             end;
             Inc(Run);
          end;// '\':

      else Inc(Run);
    end; //case
  until (FLine[Run] = #39);
  if FLine[Run] <> #0 then Inc(Run);
end;

procedure TSynPythonSyn.StringEndProc(EndChar: WideChar);
var
  fBackslashCount: Integer;
begin
  if fRange = rsMultilineString3 then
    fTokenID := tkString
  else if EndChar = '"' then
    fTokenID := tkTrippleQuotedString2
  else
    fTokenID := tkTrippleQuotedString;

  case FLine[Run] of
    #0:
      begin
        NullProc;
        EXIT;
      end;
    #10:
      begin
        LFProc;
        EXIT;
    end;
    #13:
      begin
        CRProc;
        EXIT;
      end;
  end;

  if fRange = rsMultilineString3 then begin
    repeat
      if FLine[Run]=fStringStarter then begin
        Inc(Run);
        fRange:=rsUnknown;
        EXIT;
      end else if FLine[Run]='\' then   {The same backslash stuff above...}
      begin
         if FLine[Run + 1] = fStringStarter then
           begin
             fBackslashCount := 1;

             while ((Run >= fBackslashCount) and (FLine[Run - fBackslashCount] = '\')) do
               fBackslashCount := fBackslashCount + 1;

             if (fBackslashCount mod 2 = 1) then Inc(Run);
         end;
       end;// if FLine[Run]...

      Inc(Run);
    until IsLineEnd(Run);
    if FLine[Run-1]<>'\' then begin
      fRange:=rsUnknown;
      EXIT;
    end;
  end else
  repeat
    if (FLine[Run]=EndChar) and (FLine[Run+1]=EndChar) and (FLine[Run+2]=EndChar) then begin
      Inc(Run,3);
      fRange:=rsUnknown;
      EXIT;
    end;
    if FLine[Run] = '\' then begin
      if FLine[Run + 1] = EndChar then begin
          fBackslashCount := 1;

          while ((Run >= fBackslashCount) and (FLine[Run - fBackslashCount] = '\')) do
            fBackslashCount := fBackslashCount + 1;

          if (fBackslashCount mod 2 = 1) then Inc(Run);
      end;
    end;
    Inc(Run);
  until IsLineEnd(Run);
end;

procedure TSynPythonSyn.UnknownProc;
begin
  Inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSynPythonSyn.DispatchProc;
begin
  case fRange of
    rsMultilineString:
      StringEndProc(#39);
    rsMultilineString2:
      StringEndProc('"');
    rsMultilineString3:
      StringEndProc(fStringStarter);
    else
      case fLine[Run] of
        '&', '}', '{', ':', ',', ']', '[', '*', '`',
        '^', ')', '(', ';', '/', '=', '-', '+', '!', '\',
        '%', '|', '~', '@' :
          SymbolProc;
        #13: CRProc;
        '#': CommentProc;
        '>': GreaterProc;
        'A', 'C'..'E', 'G'..'Q', 'S', 'T', 'V'..'Z', 'a', 'c'..'e', 'g'..'q', 's', 't', 'v'..'z', '_': IdentProc;
        #10: LFProc;
        '<': LowerProc;
        #0: NullProc;
        '.', '0'..'9': NumberProc;
        #1..#9, #11, #12, #14..#32: SpaceProc;
        'r', 'R', 'u', 'U', 'b', 'B', 'f', 'F': PreStringProc;
        '''': StringProc;
        '"': String2Proc;
        else if IsIdentChar(fLine[Run]) then IdentProc
        else UnknownProc;
      end;
  end;
end;

function TSynPythonSyn.FlowControlAtLine(Lines: TStrings;
  Line: Integer): TSynFlowControl;
var
  SLine: string;
  Index: Integer;
begin
  Result := fcNone;

  SLine := Lines[Line - 1];

  Index :=  SLine.IndexOf('continue');
  if Index >= 0 then
    Result := fcContinue
  else
  begin
    Index :=  SLine.IndexOf('break');
    if Index >= 0 then
      Result := fcBreak
    else
    begin
      Index :=  SLine.IndexOf('return');
      if Index >= 0 then
        Result := fcExit
      else
      begin
        Index :=  SLine.IndexOf('yield');
        if Index >= 0 then
          Result := fcExit
      end;
    end;
  end;

  // Index is 0-based
  if (Index >= 0) and
    not (GetHighlighterAttriAtRowCol(Lines, Line - 1, Index + 1) = KeyAttri)
  then
    Result := fcNone;
end;

procedure TSynPythonSyn.Next;
begin
  fTokenPos := Run;
  DispatchProc;
  inherited;
end;

class function TSynPythonSyn.GetCapabilities: TSynHighlighterCapabilities;
begin
  Result := inherited GetCapabilities + [hcStructureHighlight];
end;

function TSynPythonSyn.GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_WHITESPACE:
      begin
        fTempSpaceAttri.Assign(fSpaceAttri);
        if (fRange = rsMultilineString) and (fMultiLineStringAttri.Background <> clNone) then
          fTempSpaceAttri.Background := fMultiLineStringAttri.Background
        else if (fRange = rsMultilineString2) and (fDocStringAttri.Background <> clNone)  then
          fTempSpaceAttri.Background := fDocStringAttri.Background;
        Result := fTempSpaceAttri;
      end;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
    SYN_ATTR_STRING: Result := fStringAttri;  // To allow background coloring of doc strings
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
  else
    Result := nil;
  end;
end;

function TSynPythonSyn.GetEol: Boolean;
begin
  Result := Run = fLineLen + 1;
end;

function TSynPythonSyn.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

function TSynPythonSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TSynPythonSyn.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case fTokenID of
    tkComment: Result := fCommentAttri;
    tkCodeComment: Result := fCodeCommentAttri;
    tkFunctionName: Result := fFunctionNameAttri;
    tkClassName: Result := fClassNameAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNonKeyword: Result := fNonKeyAttri;
    tkSystemDefined: Result := fSystemAttri;
    tkNumber: Result := fNumberAttri;
    tkHex: Result := fHexAttri;
    tkOct: Result := fOctalAttri;
    tkFloat: Result := fFloatAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkTrippleQuotedString: Result := fMultiLineStringAttri;
    tkTrippleQuotedString2: Result := fDocStringAttri;
    tkSymbol: Result := fSymbolAttri;
    tkUnknown: Result := fErrorAttri;
  else
    Result := nil;
  end;
end;

function TSynPythonSyn.GetTokenKind: Integer;
begin
  Result := Ord(fTokenId);
end;

procedure TSynPythonSyn.InitFoldRanges(FoldRanges: TSynFoldRanges);
begin
  inherited;
  FoldRanges.CodeFoldingMode := cfmIndentation;
end;

procedure TSynPythonSyn.ScanForFoldRanges(FoldRanges: TSynFoldRanges;
  LinesToScan: TStrings; FromLine, ToLine: Integer);
var
  CurLine: string;
  LeftTrimmedLine : string;
  Line: Integer;
  Indent : Integer;
  TabW : Integer;
  FoldType : Integer;

  function IsMultiLineString(Line : Integer; Range : TRangeState; Fold : Boolean): Boolean;
  begin
    Result := True;
    if TRangeState(GetLineRange(LinesToScan, Line)) = Range then
    begin
      if (TRangeState(GetLineRange(LinesToScan, Line - 1)) <> Range) and Fold then
        FoldRanges.StartFoldRange(Line + 1, Integer(pftMultiLineStringFoldType))
      else
        FoldRanges.NoFoldInfo(Line + 1);
    end
    else if (TRangeState(GetLineRange(LinesToScan, Line - 1)) = Range) and Fold then
    begin
      FoldRanges.StopFoldRange(Line + 1, Integer(pftMultiLineStringFoldType));
    end else
      Result := False;
  end;

  function FoldRegion(Line: Integer): Boolean;
  begin
    Result := False;
    if UpperCase(Copy(LeftTrimmedLine, 1, 7)) = '#REGION' then
    begin
      FoldRanges.StartFoldRange(Line + 1, FoldRegionType);
      Result := True;
    end
    else if UpperCase(Copy(LeftTrimmedLine, 1, 10)) = '#ENDREGION' then
    begin
      FoldRanges.StopFoldRange(Line + 1, FoldRegionType);
      Result := True;
    end;
  end;

begin
  //  Deal with multiline strings
  for Line := FromLine to ToLine do begin
    if IsMultiLineString(Line, rsMultilineString, True) or
       IsMultiLineString(Line, rsMultilineString2, True) or
       IsMultiLineString(Line, rsMultilineString3, False)
    then
      Continue;

    // Find Fold regions
    CurLine := LinesToScan[Line];
    LeftTrimmedLine := TrimLeft(CurLine);

    // Skip empty lines
    if LeftTrimmedLine = '' then begin
      FoldRanges.NoFoldInfo(Line + 1);
      Continue;
    end;

    // Skip code comments
    if Copy(CurLine, 1, 2) = '##' then begin
      FoldRanges.NoFoldInfo(Line + 1);
      Continue;
    end;

    // Find Fold regions
    if FoldRegion(Line) then
      Continue;

    TabW := TabWidth(LinesToScan);
    Indent := LeftSpaces(CurLine, True, TabW);

    // find fold openers
    with BlockOpenerRE.Match(LeftTrimmedLine) do
      if Success then
      begin
        if Groups[1].Value = 'class' then
          FoldType := Integer(pftClassDefType)
        else if Pos('def', Groups[1].Value) >= 1 then
          FoldType := Integer(pftFunctionDefType)
        else
          FoldType := Integer(pftCodeBlock);

        FoldRanges.StartFoldRange(Line + 1, FoldType, Indent);
        Continue;
      end;

    FoldRanges.StopFoldRange(Line + 1, 1, Indent)
  end;
end;

procedure TSynPythonSyn.ResetRange;
begin
  fRange := rsUnknown;
  fLastIdentifier := '';
end;

procedure TSynPythonSyn.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TSynPythonSyn.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterPython;
end;

function TSynPythonSyn.IsIdentChar(AChar: WideChar): Boolean;
begin
  Result := AChar.IsLetterOrDigit or (AChar = '_');
end;

class function TSynPythonSyn.GetLanguageName: string;
begin
  Result := SYNS_LangPython;
end;

function TSynPythonSyn.GetSampleSource: UnicodeString;
begin
  Result :=
    '#!/usr/local/bin/python'#13#10 +
    '__version__ = "$Revision: 01 $"'#13#10 +
    'import string, sys'#13#10 +
    'class Conversions:'#13#10 +
    '"""A collection of conversion functions"""'#13#10 +
    '    if len(sys.argv) < 1:'#13#10 +
    '        sys.exit(2)'#13#10 +
    '        assert 0x00 == 00    #well, it better'#13#10+
    ''#13#10+
    'if __name__ == ''__main__'''#13#10+
    '    main()';
end;

class function TSynPythonSyn.GetFriendlyLanguageName: UnicodeString;
begin
  Result := SYNS_FriendlyLangPython;
end;

{ TSynPythonInterpreterSyn }

resourcestring
  SYNS_AttrBanner = 'Banner';
  SYNS_FriendlyAttrBanner = 'Banner';
  SYNS_AttrOutput = 'Output';
  SYNS_FriendlyAttrOutput = 'Output';
  SYNS_AttrTraceback = 'Traceback';
  SYNS_FriendlyAttrTraceback = 'Traceback';
  SYNS_AttrPrompt = 'Prompt';
  SYNS_FriendlyAttrPrompt = 'Prompt';
  SYNS_AttrSystemCmd = 'System Command';
  SYNS_FriendlyAttrSystemCmd = 'System Command';
  SYNS_LangCython = 'Cython';
  SYNS_FriendlyLangCython = 'Cython';

const
  // Do not localise
  SYNS_LangPythonInterpreter = 'Python Interpreter';
  SYNS_FriendlyLangPythonInterpreter = 'Python Interpreter';

procedure TSynPythonInterpreterSyn.BannerProc;
begin
  Inc(Run);
  fTokenID := tkBanner;
  while not IsLineEnd(Run) do
    Inc(Run);
end;

constructor TSynPythonInterpreterSyn.Create(AOwner: TComponent);
begin
  inherited;
  fPS1 := '>>>';
  fPS2 := '...';
  fDbg := '[Dbg]';
  fPM := '[PM]';
  fBannerAttri := TSynHighlighterAttributes.Create(SYNS_AttrBanner, SYNS_FriendlyAttrBanner);
  fBannerAttri.Foreground := clBlue;
  AddAttribute(fBannerAttri);
  fOutputAttri := TSynHighlighterAttributes.Create(SYNS_AttrOutput, SYNS_FriendlyAttrOutput);
  fOutputAttri.Foreground := clTeal;
  AddAttribute(fOutputAttri);
  fTracebackAttri := TSynHighlighterAttributes.Create(SYNS_AttrTraceback, SYNS_FriendlyAttrTraceback);
  fTracebackAttri.Foreground := clRed;
  AddAttribute(fTracebackAttri);
  fPromptAttri := TSynHighlighterAttributes.Create(SYNS_AttrPrompt, SYNS_FriendlyAttrPrompt);
  fPromptAttri.Foreground := clGreen;
  AddAttribute(fPromptAttri);
  fSystemCmdAttri := TSynHighlighterAttributes.Create(SYNS_AttrSystemCmd, SYNS_FriendlyAttrSystemCmd);
  fSystemCmdAttri.Foreground := clFuchsia;
  AddAttribute(fSystemCmdAttri);
  fTracebackStartRE := CompiledRegEx('^Traceback \(|File ".*line');
  fTracebackEndRE := CompiledRegEx('^\w*(Error|Exception|Warning|KeyboardInterrupt):');
  fSystemCmdRE := CompiledRegEx(Format('^(%s)?%s\s*!', [fDbg, fPS1]));

  SetAttributesOnChange(DefHighlightChange);
end;

procedure TSynPythonInterpreterSyn.DispatchProc;
var
  Line, Prompt : string;
begin
  Line := fLineStr;
  Prompt := '';
  if Line.StartsWith(fPS1) then
    Prompt := fPS1
  else if Line.StartsWith(fPS2) then
    Prompt := fPS2
  else if Line.StartsWith(fDbg + fPS1) then
    Prompt := fDbg + fPS1
  else if Line.StartsWith(fDbg + fPS2) then
    Prompt := fDbg + fPS2
  else if Line.StartsWith(fPM + fPS1) then
    Prompt := fPM + fPS1
  else if Line.StartsWith(fPM + fPS2) then
    Prompt := fPM + fPS2;

  if (Prompt <> '') then begin
    if fRange = rsTraceback then
      fRange := rsUnknown;
    if Run < Length(Prompt) then
      PromptProc(Length(Prompt))
    else if fSystemCmdRe.IsMatch(Line) then
       SystemCmdProc
    else
      inherited; //Normal Python syntax
  end else if Line.StartsWith('***') then
    BannerProc
  else if fRange = rsTraceback then begin
    TracebackProc;
    if fTracebackEndRE.IsMatch(fLineStr) then
      fRange := rsUnknown;
  end else if (fLineLen < 100) and fTracebackStartRE.IsMatch(fLineStr) then begin
    fRange := rsTraceback;
    TracebackProc;
  end else
    OutputProc;
end;

class function TSynPythonInterpreterSyn.GetFriendlyLanguageName: UnicodeString;
begin
  Result := SYNS_FriendlyLangPythonInterpreter;
end;

class function TSynPythonInterpreterSyn.GetLanguageName: string;
begin
  Result := SYNS_LangPythonInterpreter;
end;

function TSynPythonInterpreterSyn.GetSampleSource: UnicodeString;
begin
  Result :=
    '*** Python 3.6.4 (v3.6.4:d48eceb, Dec 19 2017, 06:54:40) [MSC v.1900 64 bit (AMD64)] on win32. ***'#13#10 +
    '>>> def Greet(person):'#13#10 +
    '...     return "Hi "+ person'#13#10 +
    '>>> Greet("John")'#13#10 +
    'Hi John'#13#10 +
    '>>> errorvar = 1/0'#13#10 +
    'Traceback (most recent call last):'#13#10 +
    '  File "<interactive input>", line 1, in <module>'#13#10 +
    'ZeroDivisionError: integer division or modulo by zero'#13#10 +
    '>>> class Conversions:'#13#10 +
    '... """A collection of conversion functions"""'#13#10 +
    '...    if len(sys.argv) < 1:'#13#10 +
    '...        sys.exit(2)'#13#10 +
    '...        assert 0x00 == 00    #well, it better';
end;

function TSynPythonInterpreterSyn.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case fTokenID of
    tkBanner: Result := fBannerAttri;
    tkOutput: Result := fOutputAttri;
    tkTraceback: Result := fTracebackAttri;
    tkPrompt: Result := fPromptAttri;
    tkSystemCmd: Result := fSystemCmdAttri;
  else
    Result := inherited GetTokenAttribute;
  end;
end;

procedure TSynPythonInterpreterSyn.PromptProc(Len: Integer);
begin
  Inc(Run);
  fTokenID := tkPrompt;
  while Run < Len do
    Inc(Run);
end;

procedure TSynPythonInterpreterSyn.SystemCmdProc;
begin
  Inc(Run);
  fTokenID := tkSystemCmd;
  while not IsLineEnd(Run) do
    Inc(Run);
end;

procedure TSynPythonInterpreterSyn.OutputProc;
begin
  Inc(Run);
  fTokenID := tkOutput;
  while not IsLineEnd(Run) do
    Inc(Run);
end;

procedure TSynPythonInterpreterSyn.TracebackProc;
begin
  Inc(Run);
  fTokenID := tkTraceback;
  while not IsLineEnd(Run) do
    Inc(Run);
end;

{ TSynCythonSyn }

constructor TSynCythonSyn.Create(AOwner: TComponent);
begin
  inherited;
  fDefaultFilter := SYNS_FilterCython;
end;

class function TSynCythonSyn.GetFriendlyLanguageName: UnicodeString;
begin
  Result := SYNS_FriendlyLangCython;
end;

procedure TSynCythonSyn.AddCythonKeywords(KeywordList: TStrings);
const
  // No need to localise keywords!

  // List of keywords
  KEYWORDCOUNT = 7;
  KEYWORDS: array [1..KEYWORDCOUNT] of UnicodeString =
    (
      'cdef',
      'ctypedef',
      'cpdef',
      'inline',
      'cimport',
      'include',
      'DEF'
    );

  // List of non-keyword identifiers
  NONKEYWORDCOUNT = 13;
  NONKEYWORDS: array [1..NONKEYWORDCOUNT] of UnicodeString =
    (
      'bool',
      'char',
      'double',
      'enum',
      'float',
      'int',
      'long',
      'mutable',
      'short',
      'signed',
      'struct',
      'unsigned',
      'void'
    );
var
  f: Integer;
begin
  for f := 1 to KEYWORDCOUNT do
    KeywordList.AddObject(KEYWORDS[f], Pointer(Ord(tkKey)));
  for f := 1 to NONKEYWORDCOUNT do
    KeywordList.AddObject(NONKEYWORDS[f], Pointer(Ord(tkNonKeyword)));
end;

procedure TSynCythonSyn.GetKeywordIdentifiers(KeywordList: TStrings);
begin
    inherited;
    AddCythonKeywords(KeywordList);
end;

class function TSynCythonSyn.GetLanguageName: string;
begin
  Result := SYNS_LangCython;
end;

initialization
  RegisterPlaceableHighlighter(TSynPythonSyn);
  RegisterPlaceableHighlighter(TSynCythonSyn);
end.

