unit UnitAboutBox;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, HTMLLite, ExtCtrls, ShellAPI;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    Viewer: ThtmlLite;
    btnOK: TButton;
    procedure ViewerHotSpotClick(Sender: TObject; const SRC: String;
      var Handled: Boolean);
    function AppVers: Boolean;
    function AppAbout: Boolean;
    function Ref: Boolean;
    function HelpPSE: Boolean;
    function HelpDiag: Boolean;
    function HelpKarte: Boolean;
    function HelpRad: Boolean;
    function Upd: Boolean;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    //constructor CreateIt(Owner: TComponent);
  end;

var
  AboutBox: TAboutBox;

implementation

uses UnitNukFunc;

{$R *.DFM}

{constructor TAboutBox.CreateIt(Owner: TComponent);
begin
  inherited Create(Owner);
end;}

procedure TAboutBox.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) or (Key = VK_ESCAPE) then Close;
end;

function TAboutBox.AppVers: Boolean;
var temp: String;
begin
  Height := 150;
  Width := 314;
  temp := '<body bgcolor="#FFFFE1" text="000080">' +
    '<center>' +
    '<h1>'+'Nukliddaten</h1>' +
    '<font color="Maroon">Nuklidkarte - Zerfallsreihen - Periodensystem</font>' +
    '<h3>Freeware-' + AppVersInfo(Application.ExeName) +
    '</h3><font size="-1">Copyright © 2007-2008 by Holger Werner' +
    '</font></center>' +
    '</body>';
  Viewer.Clear;
  Viewer.DefFontName := 'Arial';
  Viewer.DefFontSize := 9;         // #CCFFFF
  Viewer.DefFontColor := clNavy;   // ffffeb
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

procedure TAboutBox.ViewerHotSpotClick(Sender: TObject; const SRC: String;
  var Handled: Boolean);
begin
  Handled := False;
  if (Pos('mailto:',SRC) > 0) or (Pos('http:',SRC) > 0) then
  begin
    if InternetOnline then
      ShellExecute(0, nil, @SRC[1], nil, nil, SW_SHOWNORMAL)
    else ShowMessage('Keine Internetverbindung vorhanden!');
    Handled := True;
  end else if Pos('OK',SRC) > 0 then Close;
end;

function TAboutBox.AppAbout: Boolean;
var temp: String;
begin
  Height := 190;         // cl InfoBk = #FFFFE1
  Width := 314;
  BorderStyle := bsNone;
  Position := poMainFormCenter;
  VertScrollBar.Range := 0;
  temp := '<body bgcolor="ffffeb" text="000080">' +
    '<center>' +
    '<h1>Nukliddaten</h1>' +
    '<font color="Maroon">Nuklidkarte - Zerfallsreihen - Periodensystem</font>' +
    '<h3>Freeware-' + AppVersInfo(Application.ExeName) +
    '</h3><font size="-1">Copyright © 2007-2008 by Holger Werner' +
    '</font></center>' +
    '<center><a href="mailto:mail@wernerhk.de">mail@wernerhk.de</a></center>' +
    '<h2><center><a href="OK">OK</a></center></h2>' +
    '</body>';
  Viewer.Clear;
  Viewer.DefFontName := 'Arial';
  Viewer.DefFontSize := 9;         // #CCFFFF
  Viewer.DefFontColor := clNavy;   // ffffeb
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

function TAboutBox.Ref: Boolean;
var temp: String;
begin
  Icon := Application.Icon;
  Width := 500;
  Height := 400;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 560;
  VertScrollBar.Range := 560;
  //Viewer.NoSelect := False;
  Self.Caption := 'Referenzen';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="MAROON"><B>Nuklid-Referenzen:</B><BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Die Nukliddatenbank in Nukliddaten hatte als Ausgangsbasis die:<BR>' +
    '<BR>' +
    '<B>TORI - Table of Radioactive Isotopes von 1999</B><BR>' +
    'Webseite: <A HREF="http://ie.lbl.gov/databases/databases.html" TARGET="_blank">http://ie.lbl.gov/databases/databases.html</A><BR>' +
    '<BR>' +
    'Dann wurde sie erweitert und aktualisiert mit:<BR>' +
    '<BR>' +
    '<B>2003 Atomic Mass Evaluation</B><BR>' +
    'Autoren: G.Audi, A.H.Wapstra and C.Thibault<BR>' +
    'Webseite: <A HREF="http://www.nndc.bnl.gov/masses/#atomic" TARGET="_blank">http://www.nndc.bnl.gov/masses/#atomic</A><BR>' +
    'Datei: mass.mas03</A><BR>' +
    '<BR>' +
    '<B>Nubase03</B><BR>' +
    'Autoren: G. Audi, O. Bersillon, J. Blachot and A.H. Wapstra<BR>' +
    'Webseite: <A HREF="http://www-nds.iaea.org/amdc/web/nubase_en.html" TARGET="_blank">http://www-nds.iaea.org/amdc/web/nubase_en.html</A><BR>' +
    'Datei: nubtab03.asc</A><BR>' +
    '<BR>' +
    'Letzter Aktualisierungsstand ist Januar 2008 mit:<BR>' +
    '<BR>' +
    '<B>OECD Nuclear Energy Agency</B><BR>' +
    '<BR>' +
    'Webseite: <A HREF="http://81.252.67.151/dbforms/data/eva/evatapes/endfb_7/" TARGET="_blank">http://81.252.67.151/dbforms/data/eva/evatapes/endfb_7/</A><BR>' +
    'Datei: dec-ENDF-VII0.endf<BR>' +
    '<BR>' +
    '<B>JEFF3.1.1 Radiactive Decay Data library</B><BR>' +
    'Webseite: <A HREF="http://81.252.67.151/dbforms/data/eva/evatapes/jeff_31/" TARGET="_blank">http://81.252.67.151/dbforms/data/eva/evatapes/jeff_31/</A><BR>' +
    'Datei: JEFF311RDD_ALL.OUT</P>' +
    '<h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  //Viewer.LoadFromFile('C:\Eigene Projekte\Nukliddaten\Nuklid-Refs\Nuklid-Refs.doc_HTML\Nuklid-Refs.doc.htm');
  Result := True;
end;

function TAboutBox.HelpPSE: Boolean;
var temp: String;
begin
  Icon := Application.Icon;
  Width := 400;
  Height := 200;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 200;
  VertScrollBar.Range := 0;
  Self.Caption := 'Hilfe';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="NAVY"><B>Periodensystem:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Mit einem Klick auf ein Element werden dessen Daten angezeigt.<BR><BR>' +
    'Ist der Button ''Diagramm'' (rechts unten) aktiv, dann kann darüber<BR>' +
    '   das Diagramm für die angewählten Daten angezeigt werden.<BR>' +
    '</B><h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

function TAboutBox.HelpDiag: Boolean;
var temp: String;
begin
  Icon := Application.Icon;
  Width := 400;
  Height := 200;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 200;
  VertScrollBar.Range := 0;
  Self.Caption := 'Hilfe';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="NAVY"><B>Diagramm:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +

    '<BR>' +
    '<h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

function TAboutBox.HelpKarte: Boolean;
var temp: String;
begin
  Icon := Application.Icon;
  Width := 480;
  Height := 310;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 310;
  VertScrollBar.Range := 0;
  Self.Caption := 'Hilfe';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="NAVY"><B>Nuklidkarte:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Über den Schalter "Nuklidkarte vergrößern" wird die Großansicht aktiviert.<BR><BR>' +
    'Mit einem Klick auf ein Nuklid der Minikarte wird das ausgewählte Nuklid<BR>' +
    'in der Mitte des Fensterbereiches der Nuklidkarte angezeigt.<BR><BR>' +
    'Bei vergrößerter Nuklidkarte haben Sie über Rechts-Klick im Nuklid-Explorer<BR>' +
    'weitere Navigationsmöglichkeiten, die Sie im Klartext vorfinden.<BR><BR>' +
    'Mit Rechtsklick können die Minikarte und Legende über Popup-Menü<BR>' +
    'und Menüpunkt "Optionen" aus- bzw. eingeblendet werden.<BR>' +
    '<h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

function TAboutBox.HelpRad: Boolean;
var temp: String;
begin
  Icon := Application.Icon;
  Width := 480;
  Height := 300;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 300;
  VertScrollBar.Range := 0;
  Self.Caption := 'Hilfe';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="NAVY"><B>Zerfallsreihen:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Die untere Nuklidkarte kann über Menü-Punkt "Optionen" aus- bzw. eingeblendet werden<BR><BR>' +
    'Bei Anzeige "Wahrscheinliche Zerfallsreihe(n)" werden durch Klick auf den Titel<BR>' +
    '"ZerfallsreiheX" weitere Daten angezeigt.<BR><BR>' +
    'Bei Anzeige "Alle möglichen Zerfallsreihen" werden die jeweiligen Tochternuklide' +
    ' als Hilfetext und unten in der Statuszeile angezeigt, <BR>' +
    'wenn sich der Mauspfeil über einem radioaktiven Nuklid gefindet.<BR>' +
    'So können alle vorhandenen Zerfallswege bis zum stabilen Nuklid verfolgt werden.<BR>' +
    '<h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

function TAboutBox.Upd: Boolean;
var temp: String;
begin
  Icon := Application.Icon;
  Width := 400;
  Height := 200;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 200;
  VertScrollBar.Range := 0;
  Viewer.NoSelect := False;
  Self.Caption := 'Lizenz';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="MAROON"><B>Update:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Über folgenden Link können Sie nach einem Update schauen:<BR>' +
    'Datei: <A HREF="http://www.marcoschwarz-online.de/physik/nukliddaten.htm" TARGET="_blank">http://www.marcoschwarz-online.de/physik/nukliddaten.htm</A><BR>' +
    '<BR>' +
    '<h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

end.
