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
    function HelpSuch: Boolean;
    function HelpSchema: Boolean;
    function Upd: Boolean;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    function ZW(Titel: String): String;
  private
    { Private declarations }
  public
    geladen: Boolean;
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
  Height := 200;
  Width := 314;
  temp := '<body bgcolor="#FFFFE1" text="000080">' +
    '<center>' +
    '<h1>'+'Nukliddaten</h1>' +
    '<font color="Maroon">Nuklidkarte - Zerfallsreihen - Periodensystem</font>' +
    '<h3>Freeware<BR>' + AppVersInfo(Application.ExeName) + '<BR>' +
    '<font size="-1">Copyright © 2007-2011 by</font>' +
    '<h3>Holger Werner</h3></center>' +
    '<font size="-1"><center><a href="mailto:nukliddaten@dokom.net">nukliddaten@dokom.net</a></center></font>' +
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
    //if InternetOnline then
      ShellExecute(0, nil, @SRC[1], nil, nil, SW_SHOWNORMAL);
    {else
    begin
      ShowMessage('Keine Internetverbindung vorhanden!');
      ShellExecute(0, nil, @SRC[1], nil, nil, SW_SHOWNORMAL);
    end;}
    Handled := True;
  end else if Pos('OK',SRC) > 0 then Close;
end;

function TAboutBox.AppAbout: Boolean;
var temp: String;
begin
  Height := 230;         // cl InfoBk = #FFFFE1
  Width := 314;
  BorderStyle := bsNone;
  Position := poMainFormCenter;
  VertScrollBar.Range := 0;
  temp := '<body bgcolor="ffffeb" text="000080">' +
    '<center>' +
    '<h1>Nukliddaten</h1>' +
    '<font color="Maroon">Nuklidkarte - Zerfallsreihen - Periodensystem</font>' +
    '<h3>Freeware<BR>' + AppVersInfo(Application.ExeName) + '<BR>' +
    '<font size="-1">Copyright © 2007-2011 by</font>' +
    '<h3>Holger Werner</h3></center>' +
    '<font size="-1"><center><a href="mailto:nukliddaten@dokom.net">nukliddaten@dokom.net</a></center></font>' +
    '<h2><center>' +
    '<a href="OK">OK</a></center></h2>' +
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
  Height := 420;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 670;
  VertScrollBar.Range := 670;
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
    'Die Auger- und R&ouml;ntgen-Emissions-Daten entsprechen weiterhin' +
    ' der TORI-DB. Alle weiteren Daten bzgl. Nuklidkarte und Zerfall' +
    ' wurden erweitert und aktualisiert mit:<BR>' +
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
    'Datei: JEFF311RDD_ALL.OUT<BR><BR>' +
    'Weitere Rückfragen beantwortet gern der Autor von Nukliddaten:<BR><BR>' +
    'Holger Werner<BR>' +
    'Lüdinghauser Str.29<BR>' +
    '44339 Dortmund<BR>' +
    'Deutschland<BR>' +
    '<a href="mailto:nukliddaten@dokom.net">nukliddaten@dokom.net</a></P>' +
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
  Height := 260;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 260;
  VertScrollBar.Range := 0;
  Self.Caption := 'Hilfe';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="NAVY"><B>Periodensystem:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Mit einem Klick auf ein Element werden dessen Daten angezeigt.<BR><BR>' +
    'Ist der Button ''Diagramm'' (rechts unten) aktiv, dann kann darüber<BR>' +
    '   das Diagramm für die angewählten Daten angezeigt werden.<BR><BR>' +
    'Die einzelnen Elemente im PSE können auch über die Pfeiltasten angewählt werden,' +
    ' wenn es den Fokus hat, der über die Tab-Taste erreicht wird.<BR>' +
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
  Height := 400;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 400;
  VertScrollBar.Range := 0;
  Self.Caption := 'Hilfe';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    //'<BODY bgcolor="ccffff"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="NAVY"><B>Nuklidkarte:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Über den Schalter "Nuklidkarte vergrößern" wird die Großansicht aktiviert.<BR><BR>' +
    'Mit einem Klick auf ein Nuklid der Minikarte wird das ausgewählte Nuklid<BR>' +
    'in der Mitte des Fensterbereiches der Nuklidkarte angezeigt.<BR><BR>' +
    'Bei vergrößerter Nuklidkarte haben Sie über Rechts-Klick im Nuklid-Explorer<BR>' +
    'weitere Navigationsmöglichkeiten, die Sie im Klartext vorfinden.<BR><BR>' +
    'Über den Button "Suche Nuklid" kann ein Nuklid auch angesteuert werden. Die dafür erforderliche Eingabe wird im Klartext im Suchdialog angezeigt.<BR><BR>' +
    'Mit Rechtsklick können die Minikarte und Legende über Popup-Menü<BR>' +
    'und Menüpunkt "Optionen" aus- bzw. eingeblendet werden.<BR><BR>' +
    'Der Nukildexplorer kann auch über die Tasten Pfeil hoch/runter gesteuert werden.' +
    ' Ist ein Hauptpfad (z.B. "1 H") markiert, kann er mit der Taste Return geöffnet oder geschlossen werden.' +
    ' Nur markierte Nuklide der Unterzweige bleiben beim Wechseln der Fenster erhalten. <BR>' +
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
  Height := 480;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 480;
  VertScrollBar.Range := 0;
  Self.Caption := 'Hilfe';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="NAVY"><B>Zerfallsreihen:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Die untere Nuklidkarte kann über Menü-Punkt "Optionen/Zerfallsdaten" aus- bzw. eingeblendet werden.<BR><BR>' +
    'Unter "Optionen/Zerfallsdaten" kann mit "Emissionen-Auswertung" das Vorhandensein von Emissionsdaten über Aktivität der jeweiligen Button angezeigt werden.<BR><BR>' +
    'Bei Anzeige "Wahrscheinliche Zerfallsreihe(n)" werden durch Klick auf den Titel ' +
    '"Zerfallsreihe X" weitere Daten angezeigt.<BR><BR>' +
    'Bei Anzeige "Alle möglichen Zerfallsreihen" und "Zerfälle zum markierten Nuklid"' +
    ' werden die jeweiligen Tochternuklide links oben angezeigt, ' +
    'wenn sich der Mauspfeil über einem radioaktiven Nuklid gefindet.<BR>' +
    'So können alle vorhandenen Zerfallswege bis zum stabilen bzw. markierten Nuklid verfolgt werden.<BR><BR>' +
    'Über den Button "Suchen" kann ein Nuklid direkt angesteuert werden. Die dafür erforderliche Eingabe wird im Klartext im Suchdialog angezeigt.<BR><BR>' +
    'Der Nuklid-Explorer kann auch über die Tasten Pfeil hoch/runter gesteuert werden.' +
    ' Ist ein Hauptpfad (z.B. "1 H") markiert, kann er mit der Taste Return geöffnet oder geschlossen werden.' +
    ' Nur markierte Nuklide der Unterzweige bleiben beim Wechseln der Fenster erhalten. <BR>' +
    '<h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

function TAboutBox.Upd: Boolean;
var temp: String;
begin
  Icon := Application.Icon;
  Width := 450;
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
    '<A HREF="http://www.marcoschwarz-online.de/einstein-sagt/download-nukliddaten/" TARGET="_blank">http://www.marcoschwarz-online.de/einstein-sagt/download-nukliddaten/</A><BR>' +
    '<BR>' +
    '<h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  geladen := False;
end;

function TAboutBox.HelpSuch: Boolean;
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
    '<P><FONT SIZE="4" COLOR="NAVY"><B>Nuklid-Suche:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Die Mindest-Vorgabe für eine Suche ist die Angabe von Z eines Nuklids.<BR>' +
    'Es kann auch ein Bereich über A und N vorgegeben werden.<BR>' +
    'Zu dem kann die Suche durch Angabe eines Halbwertzeit-Bereiches eingeschränkt werden.<BR>' +
    'Genauso verhält es sich mit der Vorgabe eines Energie-Bereiches.<BR>' +
    'Die Eingabefelder "Halbwertzeit" und "Energie" sind nur bei entsprechender Suchart aktiviert.<BR><BR>' +
    'Ist der vorgegebene Suchbereich bei z.B. "Energie" zu groß, kann die Suche' +
    ' sehr lange dauern und entsprechende Aktivitäten verursachen.<BR>' +
    'Deshalb sollten die Vorgaben einen entsprechend kleinen Bereich umfassen.<BR>' +
    '<h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

function TAboutBox.HelpSchema: Boolean;
var temp: String;
begin
  Icon := Application.Icon;
  Width := 480;
  Height := 240;
  btnOK.Visible := False;
  BorderStyle := bsSingle;
  Position := poMainFormCenter;
  Panel1.Height := 240;
  VertScrollBar.Range := 0;
  Self.Caption := 'Hilfe';
  temp :=
    '<HTML>' +
    '<BODY bgcolor="ffffeb"><CENTER>' +
    '<P><FONT SIZE="4" COLOR="NAVY"><B>Zerfallsschema:<BR>' +
    '<BR>' + '<FONT SIZE="3">' +
    'Mit Klick oben auf die jeweilige Zerfallsart kann das Zerfallsschema angezeigt werden.<BR><BR>' +
    'Bei der Checkbox "IB" links oben kann vorgewählt werden, um die Alphawerte oder Beta-Intensitäten erweitert anzuzeigen.<BR><BR>' +
    'Über den Button "Zurück" kommt man zurück zu den Zerfallsdaten.<BR>' +
    '<h2><a href="OK">OK</a></h2>' +
    '</CENTER></BODY></HTML>';
  Viewer.LoadFromString(temp, '');
  Result := True;
end;

function TAboutBox.ZW(Titel: String): String;
begin
  Result := '<HTML>' +
    '<BODY bgcolor="#CCFFFF"><CENTER>' +
    '<FONT SIZE="4" COLOR="NAVY"><B>' +
  'Über einen der elementaren Masse-Entstehung betreffend heuristischen Gesichtspunkt:<BR>';
  Result := Result + '<BR><FONT SIZE="3">03.01.2011 von Holger Werner</CENTER>' +
  '<font size="-1"><center><a href="mailto:nukliddaten@dokom.net">nukliddaten@dokom.net</a><BR><BR>' +
  '(Über beiliegende "Zentrumswirkung.pdf" kann dieser Text ausgedruckt werden.)</center></font><BR>' +
  'Hiermit soll versucht werden, eine Sichtweise zu entwickeln, "wie und warum" ' +
  'es zur Entstehung von elementarer Masse im Universum kommen kann. Dazu muss ' +
  'erst einmal erkannt werden, welche elementare Urwirkung dafür verantwortlich ' +
  'sein dürfte.<BR><BR>' +
  'Betrachtet man die bekannten Wirksysteme, wie Galaxien, Sterne/Sonnen, Planeten ' +
  'und Atome, dann haben alle etwas recht eindeutig gemeinsam, nämlich die ' +
  '"Zentrumswirkung", denn alles dieser Wirksysteme tendiert zu ihrem Zentrum ' +
  'hin, weshalb sie auch alle kugelförmig sein dürften. Dabei spielt es doch ' +
  'kaum eine Rolle, dass kleinere Wirksysteme das zentrale Wirksystem umkreisen, ' +
  'wie z.B. Planeten ihre Sonne.<BR><BR>' +
  'Entscheidend muss die Frage sein, wie solch eine makroskopische ' +
  'Zentrumswirkung aus mikroskopisch elementarster Urwirkung resultieren kann. ' +
  'Es kann aber nur teilweise erklärt werden, wenn man es aus "unserer" ' +
  'makroskopischen Sicht versucht zu erklären und es wie fast alles ' +
  'im Teilchenmodell über die Elektrodynamik beschreibt. Die Elektrodynamik ' +
  'kann doch nur aus den gegenseitigen Wechselwirkungen der Atome resultieren, ' +
  'wenn z.B. elektrischer Strom aus fließenden Elektronen besteht und ' +
  'Magnetismus resultiert auch aus elektrischem Strom.<BR><BR>' +
  'Die oben beschriebene Zentrumswirkung muss aber elementarster Ursache sein, ' +
  'denn die starke WW und die Gravitation wirken exakt identisch zum Zentrum ' +
  'hin und unterscheiden sich nur in ihrer Stärke und Reichweite. Also könnte ' +
  'die starke WW die Urwirkung sein und die Gravitation der weiträumige ' +
  'Ausläufer der starken WW. Es handelt sich somit bei beiden WW um eine ' +
  'einzige, die sich uns nur makroskopisch betrachtet als getrennt darstellt, ' +
  'weil wir die starke WW erst bei den Atomen erkennen können, die aber auch ' +
  'der Zentrumswirkung unterliegen, wie auch alle makroskopischen Wirksysteme.<BR><BR>' +
  'Newton betrachtete die Gravitation so, dass sich alle Massen gegenseitig ' +
  'anziehen und Einstein berechnete über seine ART die räumliche Auswirkung, ' +
  'woraus sich die Raumkrümmung ergab. Leider kann das Wort Krümmung nur ' +
  'etwas Zweidimensionales beschreiben, wie man einen Stab krümmen kann, aber ' +
  'die Gravitation wirkt dreidimensional zum Zentrum hin. Also muss es sich um ' +
  'ein "Zerren" zum Zentrum hin handeln, was zur Folge hat, dass der umliegende ' +
  'Raum gedehnt wird. Daraus lässt sich schließen, dass die Masse des Zentrums ' +
  'und ihre nahe Umgebung, die auch noch "verdichtet" ist, eine Konzentration ' +
  'des umliegenden "Mediums/Raumes" darstellt.<BR><BR>' +
  'Somit sollte von einem "Urmedium" ausgegangen werden, welches sich ' +
  'innerhalb des kugelförmigen Sonnensystems zum Zentrum hin, also als Sonne ' +
  'verdichtet hat. Genauso können alle Galaxien betrachtet werden, denn dort ' +
  'handelt es sich lediglich um die Zentren als "schwarze Sterne", welche "leider" ' +
  'von uns Oberflächenbetrachter "schwarzes Loch" genannt werden. Die schwarzen ' +
  'Sterne stellen die makroskopische Maximierung der Zentrumswirkung dar. Es ' +
  'muss sich also um ein elastisches Urmedium handeln, was wir als Raum, Vakuum, ' +
  'Nichts und früher auch als recht starren Äther bezeichne(te)n.<BR><BR>' +
  'Um aber die elementarste Zentrumswirkung erklären zu können, darf die ' +
  'elementarste Welle, das Licht, nicht als "elektromagnetisch transversale" ' +
  'Welle betrachtet werden, was ja auch nur ein willkürliches Postulat von ' +
  'Maxwell war. Eine transversale Welle kann auch nur aus der Bewegung eines ' +
  '"Teilchen" resultieren, welches vom Medium, das es durchquert, zur transversalen ' +
  'Wellenbewegung gezwungen wird.<BR><BR>' +
  'Somit dürfte es sich bei der Lichtwelle, die aus allen Richtungen ' +
  'betrachtet und gemessen werden kann, um eine longitudinale Welle, also ' +
  'Druckwelle im Urmedium handeln, denn würde ein Wirksystem nach jedem ' +
  '"Betrachter" ein Teilchen als Photon schicken, welche ja alle die gleiche ' +
  'Energie haben müssten, dann ließe es sich sicherlich einfach berechnen, ' +
  'wie schnell sich die Gesamtenergie des emittierenden Wirksystems verbraucht ' +
  'hätte.<BR><BR>' +
  'Das aber wird nie experimentell beobachtet. Ein Atom gibt meist nur ' +
  'Überschußenergie als Gamma- bzw. Lichtwelle ab. Nur eine longitudinale Welle ' +
  'innerhalb des Urmediums kann alle umliegenden "Betrachter" mit einem einzigen ' +
  'Impuls als Lichtwelle treffen und das emittierende Wirksystem gibt nur diese ' +
  'Art Impuls ans Urmedium ab, der alle mit gleicher Energie trifft.<BR><BR>' +
  'Ebenso erklärt Licht als longitudinale Welle das Plancksche ' +
  'Wirkungsquantum, denn jede Verdichtung der Welle stellt ein Wirkungsquantum ' +
  'dar. Deshalb läßt sich Licht als Quanten berechnen. Es lassen sich sogar einzelne ' +
  'Photonen erzeugen, in dem nur eine einzige Druckwelle ausgesandt wird. Diese ' +
  'aber dürfte aus allen Richtungen gesehen und gemessen werden, in die sie ' +
  'wirkt, denn wenn eine longitudinale Welle z.B. durch ein ' +
  '"Laser-Röhrchen" geschickt wird, so breitet sich dieser Impuls erst in sehr ' +
  'großer Entfernung aus und trifft in der Nähe nur einen winzigen Punkt.<BR><BR>' +
  'Genauso erklären sich Lichtstrahlen in unserer Atmosphäre, denn sie tauchen ' +
  'nur dort deutlich erkennbar auf, wo die Sonnenstrahlen ein Loch in den Wolken ' +
  'durchqueren. Die wesentlich intensiveren Sonnenstrahlen setzen sich auch ' +
  'geradlinig von Atom zu Atom in der Atmosphäre fort, aber jedes dieser ' +
  'getroffenen Luftatome emittiert diese Energie sofort wieder als longitudinale ' +
  'Welle, weshalb wir diese Lichtstrahlen auch von der Seite sehen können.<BR><BR>' +
  'Dieser Effekt taucht auch bei experimentellen Laserstrahlen auf, wenn es ' +
  'sich um keine Lichtfrequenz handelt. Erst wenn der Laserstrahl ein Gas ' +
  'durchqueren muss, wird er sichtbar. Das kann ein experimenteller Beleg ' +
  'dafür sein, dass wir Atome erst mit sichtbar emittierenden Lichtwellen sehen ' +
  'können, genauso wie bei Sonnenstrahlen in unserer Atmosphäre. Auch die Biophotonen ' +
  'erklären sich so, denn alle Atome unseres Körpers emittieren sofort jede absorbierte ' +
  'Energie als Photon, welcher Frequenz auch immer.<BR><BR>' +
  'Das erklärt auch, warum wir nur die Seite unseres Mondes "beleuchtet" sehen, ' +
  'denn nur von der Sonne getroffene Mondatome emittieren diese Energie wieder ' +
  'und diese trifft auf unsere Augen. Da wir aber alle den Mond gleichzeitig ' +
  'sehen, dürfte er kaum nach jedem Auge Photonen als Teilchen schicken, sondern ' +
  'die vom Sonnenlicht getroffenen Mondatome senden daraufhin eigene Lichtwellen ' +
  'aus, die unser aller Augen als longitudinale Welle mit gleicher Energie treffen.<BR><BR>' +
  'Zu dem erklären sich die Rotverschiebungen aller Galaxien, um so entfernter ' +
  'sie sind. Der Raum bzw. das Urmedium innerhalb unseres Sonnensystems ' +
  'muss gedehnt sein und umso weiter eine Galaxis entfernt ist, umso ' +
  'mehr hat sich die Lichtwelle ausgedehnt, weshalb sie mit weniger Verdichtung ' +
  'bei uns ankommt. Dies erklärt somit die jeweilige Rotverschiebung der Galaxien ' +
  'nach dem Dopplereffekt. Dann muss auch noch ' +
  'berücksichtigt werden, dass der Dopplereffekt direkt auf unserem Planeten ' +
  'anders wirken dürfte, als draußen im gedehnten Urmedium.<BR><BR>' +
  'Also kann daraus nicht (mehr) geschlossen werden, unser Universum dehnt ' +
  'sich ständig nach allen Richtungen aus. Schon allein die Deep-Field-Aufnahme ' +
  'des Hubble-Teleskops benötigte etwa 14 Tage starre Belichtung, ' +
  'um überhaupt erst ein Bild dieser Galaxien erzeugen zu können. ' +
  'Daraus kann doch recht einfach geschlossen werden, dass dieses Licht mit ' +
  'wesentlich geringerer Intensität beim Hubble-Telescop ankam.<BR><BR>' +
  'Darüber hinaus werden diese Lichtwellen auch noch vom gedehnten Urmedium innerhalb ' +
  'unseres Sonnensystems noch mehr gedehnt als die Lichtwellen von nahen Sternen ' +
  'und Galaxien, denn deren Licht erreicht uns mit erheblich höherer Energie, ' +
  'also als wesentlich stärker verdichtete longitudinale Wellen, weshalb sie vom ' +
  'gedehnten Urmedium im Sonnensystem auch weniger gedehnt werden.<BR><BR>' +
  'Genauso erklärt sich die Synchrotronstrahlung, denn jede verdichtete Masse, ' +
  'z.B. als Elektron, verdichtet das Urmedium entsprechend weit in ' +
  'Bewegungsrichtung, je mehr sie sich der Lichtgeschwindigkeit nähert, was die ' +
  'experimentellen Ergebnisse recht eindeutig zeigen und was die Richtung der ' +
  'Synchrotronstrahlung selbst kreisförmig bewegender Elektronen ausmacht. ' +
  'Jeder Druck, also jede Verdichtung innerhalb des Urmediums, bewirkt eine ' +
  'longitudinale Lichtwelle, weshalb auch dieses Licht aus allen Richtungen ' +
  'gesehen und gemessen werden kann, was wie ein experimenteller Nachweis für ' +
  'Licht als longitudinale Welle und das elastische Urmedium wirkt.<BR><BR>' +
  'Weiterhin ergibt sich auch eine Erklärung für die Pioneer-Anomalie, denn wenn ' +
  'das Urmedium innerhalb des Sonnensystems zum Zentrum, also unserer Sonne ' +
  'hin immer stärker gedehnt ist, muss diese Dehnungswirkung auch ihre Grenze ' +
  'am Rande des Sonnensystems haben. Exakt das erklärt sich über die ' +
  'Gravitation und darüber dürfte sich die Dehnung sogar berechnen lassen.<BR><BR>' +
  'Am Rand unseres Sonnensystems, den die Pioneer-Sonden bereits erreicht ' +
  'und sogar überschritten haben, muss sich das Urmedium, durch das sich ' +
  'die Sonden bewegen, immer mehr verdichten. Genau das bewirkt diese minimale ' +
  'Geschwindigkeits-Reduktion. Leider werden keine weiteren Nachrichten mehr ' +
  'von den Sonden empfangen, denn sie dürften sich immer weiter verlangsamen. ' +
  'Wer weiß, vielleicht wurden sie inzwischen sogar vom dichteren Urmedium ' +
  '"erdrückt", eben weil sie sich zu schnell dadurch bewegten, weshalb sie ' +
  'auch nichts mehr senden können?<BR><BR>' +
  'Genauso erklärt sich die "relative" Konstanz der Lichtgeschwindigkeit durch ' +
  'das Urmedium als longitudinale Welle, denn diese wird durch die jeweilig ' +
  'lokale Dichte und den Eigenschaften des Urmediums bestimmt. Die Dichte des ' +
  'Urmediums außerhalb aller Sonnensysteme dürfte erheblich höher sein und so ' +
  'könnte sich die "Dunkle Materie" erklären. Ebenso, weshalb es die Oortsche ' +
  'Wolke gibt, denn außerhalb dürften sich dauernd neue Brocken bilden, eben ' +
  'weil das Urmedium dort wesentlich dichter ist und ständig von Lichtwellen ' +
  'der umliegenden Sterne durchquert wird. Womöglich sind die Räume zwischen ' +
  'den einzelnen Sonnensystemen sogar mit Kometen regelrecht gefüllt. Also auch ' +
  'so könnte sich die Dunkle Materie erklären.<BR><BR>' +
  'Betrachtet man zwei sich frontal begegnende Lichtwellen, die ja verdichtetes ' +
  'Urmedium, also bereits verdichtete Masse darstellen, dann dürfte es zu einem ' +
  'weiteren Verdichtungseffekt kommen, wo sich die Wellen direkt frontal ' +
  'treffen. Es sollte sich aber lediglich um einen weiteren Verdichtungseffekt ' +
  'und keine Verwirbelung handeln, wovon viele andere Theorien fast generell ' +
  'ausgehen. Wirbelsysteme dürften sich nie nahe beieinander ' +
  'erhalten können und sich allenfalls schnell gegenseitig vernichten. Ein ' +
  'einfaches Beispiel sind zwei sich drehend nähernde Kreisel und wie sie sich ' +
  'gegenseitig stören, wenn sie sich berühren.<BR><BR>' +
  '<CENTER>> )( <</CENTER><BR><BR>' +
  'Durch das frontale Zusammentreffen entsteht eine punktförmige Verdichtung. ' +
  'Somit könnte dieses dem elementarsten Wirksystem, also der elementarsten ' +
  'Entstehung von Masse entsprechen, welche aber schnell wieder als Lichtwelle ' +
  '"zerfällt".<BR><BR>' +
  'Kann sich so auch die Paarerzeugung von ' +
  'Positron und Elektron erklären, was aber bisher nur in der Nähe von ' +
  'Atomkernen experimentell beobachtet wurde? Diese elementarsten Urwirkungen ' +
  'bewirken die kosmische Hintergrundstrahlung und/oder Vakuumfluktuationen, denn ' +
  'alle Sterne senden stets Gammawellen unterschiedlichster Frequenz aus, die ' +
  'überall dauernd aufeinander treffen.<BR><BR>' +
  'Gleichzeitig erklärt es erstmalig, warum bei unserer bekannten Formel E=mc² ' +
  'das c zum Quadrat stehen muss, denn diese verdichtete Urmasse beinhaltet die ' +
  'Energie zweier jeweils mit c kollidierten Lichtwellen. Diese elementarst ' +
  'physikalische Urgesetzmäßigkeit muss sich somit ins Makroskopische fortsetzen.<BR><BR>' +
  'Entstehen aber mehrere solcher "Urwirksysteme" recht nahe ' +
  'beieinander, die alle das umgebende Urmedium zu ihren Zentren zerren, ' +
  'müssen sie sich gegenseitig mit starker WW anziehen. Zerfallen sie ' +
  'wieder, treffen sich die daraus entstehenden Wellen auf engstem ' +
  'Raum und alle zusammen erhalten sich durch diese ständige "Fluktuation" als ' +
  'Gesamtsystem. Da alles mit Lichtgeschwindigkeit auf engstem Raum stattfindet, ' +
  'unterliegt solch ein Gesamtsystem auch einer relativ langen "Zerfallszeit".<BR><BR>' +
  'Dann dürften sich auch solche Gesamtsysteme vereinen, die sich durch ihre ' +
  'ständigen Fluktuationen auch ständig gegenseitig anziehen. Also könnten ' +
  'diese Gesamtsysteme den Valenzquarks entsprechen und die dazwischen, wegen ' +
  'des ständigen Zerfalls der Einzelsysteme, ständig entstehenden neuen ' +
  'Wirksysteme den Seequarks, die wie "Gluonen" auf die Valenzquarks wirken ' +
  'und somit alles als Proton erhalten.<BR><BR>' +
  'Gleichzeitig erklärt sich daraus, weshalb die starke WW und Gravitation als ' +
  'weiträumiger Ausläufer der starken WW "dauernd" wirken, denn es resultiert ' +
  'aus diesen ständigen Fluktuationen, die stets mit starker WW stattfinden.<BR><BR>' +
  'Um das Proton herum ist aber alles auch noch relativ zum Urmedium verdichtet, ' +
  'was als Elektronium bezeichnet wird. Diese Verdichtung entspricht somit dem ' +
  'Wasserstoffatom(H), also dem elementarsten Atom.<BR><BR>' +
  'Zu dem vereinigen sich über die Zentrumswirkung auch H-Atome, wobei sich ' +
  'die gemeinsame Zentrumsenergie erhöht. Eins von beiden Protonen ' +
  'verdichtet seine nahe Umgebung deswegen stärker und näher um sich, was aus ' +
  'der gemeinsamen Zentrumsenergie resultiert und dieses System entspricht dem ' +
  'Neutron.<BR><BR>' +
  'Dieses lässt sich recht einfach nachvollziehbar aus den Beta-Zerfällen ' +
  'erkennen, denn Neutronen entstehen ausschließlich im Kernverband, wobei ein ' +
  'Proton über Elektronen-Einfang zum Neutron wird. Jedes freie Neutron ' +
  'zerfällt ja nach spätestens 11 Minuten zurück zum Proton, in dem es ein ' +
  'Elektron emittiert.<BR><BR>' +
  'Die Beta+-Emission könnte einem "aktiven Wirksystem" als z.B. Valenzquark ' +
  'entsprechen, weshalb es magnetisch positiv wirkt und mit jedem Kontakt von ' +
  'stabileren Systemen, aber auch verdichtetem Elektronium zur Gammawelle ' +
  'zerfällt. Überhaupt alle Wirksysteme zerfallen zu Gammewellen und allenfalls ' +
  'in ihre Bestandteile aus Einzel-Wirksystemen, die sich aber kaum so lange ' +
  'erhalten können und relativ schnell zerfallen.<BR><BR>' +
  'Somit widerspricht diese Sichtweise kaum dem Teilchenmodell und bestätigt es ' +
  'sogar zumindest in seinen Grundelementen. Nicht aber Licht als elektromagnetische ' +
  'und transversale Welle, zumal bis heute Licht nie elektromagnetische ' +
  'Eigenschaften experimentell nachgewiesen werden konnte. Es handelt(e) sich ' +
  'stets nur um wunschgemäße Interpretation als transversal elektromagnetische ' +
  'Welle, wie es auch Heinrich Hertz aus seinem Experiment "interpretierte". ' +
  'Andererseits soll aber Nikola Tesla sogar Lord Kelvin bei einem Experiment ' +
  'Licht und elektromagnetische Welle als longitudinale Welle nachgewiesen ' +
  'haben, was aber allgemein nicht anerkannt worden ist.<BR><BR>' +
  'Weshalb wir Licht immer noch als Strahl interpretieren, liegt einfach daran, ' +
  'weil es noch nicht ausreichend als longitudinale Welle betrachtet wurde. Es ' +
  'erklärt sich aber recht einfach, denn unsere Augen haben auch Kugelform, ' +
  'wie auch jede longitudinale Welle, wobei diese Wellen unsere Augen aber ' +
  'relativ geradlinig erreichen dürften, es sein denn die Lichtquelle ist ' +
  'recht nahe.<BR><BR>' +
  '<CENTER>> |(</CENTER><BR><BR>' +
  'Trotzdem werden nur diese Atome unserer Augen von der Lichtwelle angeregt, ' +
  'worauf sie frontal auftrifft. Die meisten umliegenden Atome werden ' +
  'nicht frontal getroffen, weshalb sie deutlich weniger Energie übertragen ' +
  'bekommen. Also wird nur ein Punkt ausreichend angeregt und dieses deuten ' +
  'wir deshalb als Strahl bzw. Teilchen, als Photon.<BR><BR>' +
  'Auch das Olbersche Paradoxon erklärt sich somit, denn das Universum muss ' +
  'deshalb dunkel sein, weil uns das Licht aller entfernten Galaxien nur noch ' +
  'abgeschwächt erreicht, weshalb ja für die Deep-Field-Aufnahme des ' +
  'Hubble-Teleskop mindestens 14 Tage Belichtung dieses Punktes des Universums ' +
  'erforderte. Somit können wir auch nie Grenzen des Universums erkennen und ' +
  'deuteten bisher alles lediglich auf Grund unserer technisch möglichen ' +
  '"Sichtweite".<BR><BR>' +
  'Weiterhin erklärt sich auch nachvollziehbar, woraus die magnetischen ' +
  'Feldlinien bestehen können, die bisher als virtuelle Photonen beschrieben ' +
  'wurden. Das Elektronium muss sich ja mit zunehmendem Abstand vom Atomkern ' +
  'entsprechend "verdünnen", also immer weniger verdichtet sein. Somit haben ' +
  'wir es mit einem für uns technisch kaum meßbaren äußeren Bereich zu ' +
  'tun, weshalb Pauli seinerzeit das Neutrino als Teilchen postulierte, um die ' +
  'fehlende Energie eines Gesamtatoms berechnen zu können. Also könnte der äußere ' +
  'Bereich auch Neutrinium genannt werden, wenn es sich lediglich um die ' +
  'äußeren Bereiche des Elektroniums handelt.<BR><BR>' +
  'Neutrinos sollen ja jegliche Materie durchdringen können, wie auch die ' +
  'magnetischen Feldlinien. Betrachtet man einen elektrischen Leiter, der beim ' +
  'Stromdurchfluß von einem kreisförmigen Magnetfeld umgeben ist, dann könnte ' +
  'es sich so erklären, dass das den Leiter durchfließende Elektronium den ' +
  '"schwächeren" Teil, also das Neutrinium, nach außen drückt. Da der ' +
  'Leiter aus Kugelatome besteht, bewegt sich auch alles ' +
  'Elektronium entsprechend verwirbelt spiralförmig dadurch. Deshalb wird auch ' +
  'das nach außen verdrängte Neutrinium kreisförmig um den Leiter verdrängt.<BR><BR>' +
  'Da es sich beim Neutrinium bereits um verdichtete Masse handelt, muss es ' +
  'auch Auswirkungen auf dichtere Masse haben, weshalb sich um den Leiter z.B. ' +
  'Eisenspäne kreisförmig anordnet. Das Neutrinium muss ja eine ähnliche ' +
  'Wirkung auf diese Eisenspäne, bestehend aus Atome haben, genauso wie ' +
  'Lichtwellen wirken. Nur die Energie des Neutriniums muss stärker sein, ' +
  'weshalb es die Eisenspäne sogar kreisförmig ausrichtet. Lässt sich somit ' +
  'sogar erstmalig die elementare Entstehung des Magnetismus erklären?<BR><BR>' +
  'So erklärt sich alles aus einer einzigen WW, der starken WW und alle ' +
  'weiteren, wie die Gravitation als weiträumiger Ausläufer der starken WW. ' +
  'Die Elektromagnetische WW resultiert aus den Wirkungen zwischen den ' +
  'Wirksystemen als Atome.<BR><BR>' +
  'Ist es nicht interessant, wie sich über diese Sichtweise praktisch alles ' +
  'erklären lässt, also das Teilchenmodell aus elementarster Entstehung und ' +
  'einige bisher kaum erklärbare Phänomene, wie die Entstehung der Gravitation, ' +
  'die starke WW, die EM-WW, die Rotverschiebung der Galaxien, die ' +
  'Pioneer-Anomalie und das Olbersche Paradoxon?<BR><BR>' +
  'Genauso interessant ist, dass nichts hinzu postuliert wird und alles nur aus ' +
  'der Sichtweise der Licht- bzw- Gammawelle im elastischen und somit dehn- ' +
  'und "krümmbaren" Urmedium als longitudinale Welle betrachtet wird! Zu ' +
  'dem stimmt alles lückenlos mit allen experimentellen Erkenntnissen überein, ' +
  'was allerdings z.B. Albert Einstein zu seiner Zeit noch nicht erkennen ' +
  'konnte, weil die experimentelle Atomphysik noch nicht so weit ' +
  'fortgeschritten war.<BR><BR>' +
  'Was sich aber als unwahrscheinlich daraus ergeben dürfte, ist der Urknall, ' +
  'der sich aus der "scheinbar" ständigen Vergrößerung des Universums ergab. ' +
  'Dieses resultierte aus der "rein mathematischen" Interpretation des ' +
  'Dopplereffekts, ohne die lokale Dichte des Raumes/Urmediums zu ' +
  'berücksichtigen. Der Raum soll aber laut ART krümmbar sein, was sich recht ' +
  'eindeutig aus den räumlichen Wirkungen der Gravitation ergibt.<BR><BR>' +
  'Genauso kann es sich bei nicht wenigen "Teilchen" des Teilchenmodells nur ' +
  'um sehr kurzzeitige Kollisionsresultate handeln, weshalb sie auch derart ' +
  'schnell wieder zerfallen. Das dürfte auch kaum verwundern, wenn die ' +
  'kosmische Strahlung mit Atome der Atmosphäre kollidiert. Exakt das ' +
  'wird in den Teilchenbeschleunigern gemacht und das mit ' +
  'immer höheren Energien, wie jetzt beim LHC, um z.B. das Higgs-Teilchen ' +
  'daraus "interpretieren" zu können.<BR><BR>' +
  'Antimaterie entsteht ja nur aus Kollisionen von Atomen, welcher Art auch immer, ' +
  'wie durch die kosmische Strahlung, die mit Atomen der Atmosphäre kollidiert, was ' +
  'genauso in allen Teilchenbeschleunigern geschieht. Somit könnte es sich beim ' +
  'Myon und Tauon um deaktivierte Wirksysteme als Proton oder Neutron handeln, ' +
  'weshalb sie magnetisch negativ wirken. Das erklärt auch, warum Myon und Tauon ' +
  'so viel Masse im Vergleich zum Elektron haben.<BR><BR>' +
  'Genauso erklärt sich das Anti-Myon und Anti-Tauon, denn diese "Antiteilchen" ' +
  'sind noch nicht komplett deaktiviert, aber nicht mehr so vollständig, um z.B. ' +
  'als Proton weiter existieren zu können, weshalb sie aber weiterhin magnetisch ' +
  'positiv wirken. Da nur das Proton und alle daraus sich ergebenden Systeme als ' +
  'Atome "recht stabil" sind, zerfallen auch alle bereits durch Kollision teilweise ' +
  'deaktivierten Wirksysteme sehr schnell, weil die Voraussetzungen wie im Proton ' +
  'nicht mehr vorhanden sind und sich die noch aktiven Wirksysteme nicht gegenseitig ' +
  'erhalten können. Somit erklärt sich auch, warum Antimaterie stets so schnell ' +
  'zerfällt und weshalb es nur Materie gibt.<BR><BR>' +
  'Auch die Antimaterie könnte somit nur eine Interpretation sein, was sich ja auch ' +
  'rein mathematisch ergab. Natürlich kann nicht ausgeschlossen werden, dass es ' +
  'so etwas wie ein Anti-Proton und Anti-Neutron geben kann, denn wenn wegen einer Kollision im ' +
  'Proton die einzelnen Wirksysteme anders und somit magnetisch ' +
  'gegensätzlich wirken, dann kann das nicht ausgeschlossen werden. Allerdings ' +
  'dürften solche Anti-Teilchen generell keine lange Lebensdauer haben, weshalb ' +
  'sich nur aus "stabilen" Wirkystemen Materie evolutionär bilden konnte und ' +
  'kann.<BR><BR>' +
  'Das Problem der mathematischen "Forschung" ist, dass immer wieder rein ' +
  'willkürliche Postulate erforderlich sind, um ein "wunschgemäßes" Resultat ' +
  'zu erreichen. Das beste Beispiel sind die Stringtheorien, wobei immer mehr ' +
  'Dimensionen postuliert wurden, die ihren Ursprung aus der ' +
  'Kaluza-Klein-Theorie haben, bei der Magnetismus als winzig aufgerollte 5. ' +
  'Dimension postuliert wurde.<BR><BR>' +
  'Somit muss (fast) jedes willkürliche Postulat, welches zum mathematischen ' +
  'Wunschergebnis erforderlich ist, zwangsläufig in zusätzliche Dimensionen ' +
  'und sogar scheinbare Parallelwelten führen. Also kann der Spruch "Was ' +
  'Mathematik alles bewirken kann" doch real (fast) nur Phantasiewelten schaffen. ' +
  'Er sollte eher lauten: "In welch reine Phantasiewelten Mathematik entführen ' +
  'kann!"<BR><BR>' +
  'Erst die kausale und somit logische Schlußfolgerung aus allen bereits ' +
  'bekannt experimentellen Erkenntnissen, ohne ein einzig willkürliches ' +
  'Postulat einzufügen, kann nahe an die Realität unserer physikalischen ' +
  'Welt führen! Erst diese Basis schafft die mögliche mathematische Interpretation, ' +
  'ohne ein einziges Postulat einzufügen, um möglichst nahe an der Realität ' +
  'bleiben zu können.<BR><BR>' +
  'Spricht somit nicht sogar vieles für diese Sichtweise der elementaren ' +
  'Masse-Entstehung? Ist es nicht wünschenswert, sich nahe der ' +
  'physikalischen Realität zu befinden, statt all diesen Phantastereien ' +
  'zu erliegen, wie sie besonders von Mathematikern wie u.a. Minkowski ' +
  'aus den Relativitätstheorien errechnet wurden? ' +
  'All das erledigt sich dadurch regelrecht als phantastisches "Wunschdenken", ' +
  'wie ja auch jeglicher "Glaube", ' +
  'der meist auch nur reinem Wunschdenken entsprechen kann, ' +
  'eben weil alles für uns Menschen recht ernüchternd wirken muss.<BR><BR>' +
  'Trotzdem spricht nicht viel dafür, dass diese Sichtweise "etablierte" ' +
  'Anerkennung findet. Eher wird es von "dort oben" lauten, alles sei nicht ' +
  '"(etabliert) wissenschaftlich", eben weil u.A. so wenig mathematisch dargestellt wird. ' +
  'Jeder hat aber hiermit zumindest die Möglichkeit, sich über reine Logik ' +
  'recht nahe der physikalischen Realität selbst "Wissen zu schaffen".<BR><BR>';
  Result := Result + '<BR></BODY></HTML>';
end;

end.
