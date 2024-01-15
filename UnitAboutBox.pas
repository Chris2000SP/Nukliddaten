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
    '<font size="-1">Copyright � 2007-2011 by</font>' +
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
    '<font size="-1">Copyright � 2007-2011 by</font>' +
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
    'Weitere R�ckfragen beantwortet gern der Autor von Nukliddaten:<BR><BR>' +
    'Holger Werner<BR>' +
    'L�dinghauser Str.29<BR>' +
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
    'Ist der Button ''Diagramm'' (rechts unten) aktiv, dann kann dar�ber<BR>' +
    '   das Diagramm f�r die angew�hlten Daten angezeigt werden.<BR><BR>' +
    'Die einzelnen Elemente im PSE k�nnen auch �ber die Pfeiltasten angew�hlt werden,' +
    ' wenn es den Fokus hat, der �ber die Tab-Taste erreicht wird.<BR>' +
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
    '�ber den Schalter "Nuklidkarte vergr��ern" wird die Gro�ansicht aktiviert.<BR><BR>' +
    'Mit einem Klick auf ein Nuklid der Minikarte wird das ausgew�hlte Nuklid<BR>' +
    'in der Mitte des Fensterbereiches der Nuklidkarte angezeigt.<BR><BR>' +
    'Bei vergr��erter Nuklidkarte haben Sie �ber Rechts-Klick im Nuklid-Explorer<BR>' +
    'weitere Navigationsm�glichkeiten, die Sie im Klartext vorfinden.<BR><BR>' +
    '�ber den Button "Suche Nuklid" kann ein Nuklid auch angesteuert werden. Die daf�r erforderliche Eingabe wird im Klartext im Suchdialog angezeigt.<BR><BR>' +
    'Mit Rechtsklick k�nnen die Minikarte und Legende �ber Popup-Men�<BR>' +
    'und Men�punkt "Optionen" aus- bzw. eingeblendet werden.<BR><BR>' +
    'Der Nukildexplorer kann auch �ber die Tasten Pfeil hoch/runter gesteuert werden.' +
    ' Ist ein Hauptpfad (z.B. "1 H") markiert, kann er mit der Taste Return ge�ffnet oder geschlossen werden.' +
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
    'Die untere Nuklidkarte kann �ber Men�-Punkt "Optionen/Zerfallsdaten" aus- bzw. eingeblendet werden.<BR><BR>' +
    'Unter "Optionen/Zerfallsdaten" kann mit "Emissionen-Auswertung" das Vorhandensein von Emissionsdaten �ber Aktivit�t der jeweiligen Button angezeigt werden.<BR><BR>' +
    'Bei Anzeige "Wahrscheinliche Zerfallsreihe(n)" werden durch Klick auf den Titel ' +
    '"Zerfallsreihe X" weitere Daten angezeigt.<BR><BR>' +
    'Bei Anzeige "Alle m�glichen Zerfallsreihen" und "Zerf�lle zum markierten Nuklid"' +
    ' werden die jeweiligen Tochternuklide links oben angezeigt, ' +
    'wenn sich der Mauspfeil �ber einem radioaktiven Nuklid gefindet.<BR>' +
    'So k�nnen alle vorhandenen Zerfallswege bis zum stabilen bzw. markierten Nuklid verfolgt werden.<BR><BR>' +
    '�ber den Button "Suchen" kann ein Nuklid direkt angesteuert werden. Die daf�r erforderliche Eingabe wird im Klartext im Suchdialog angezeigt.<BR><BR>' +
    'Der Nuklid-Explorer kann auch �ber die Tasten Pfeil hoch/runter gesteuert werden.' +
    ' Ist ein Hauptpfad (z.B. "1 H") markiert, kann er mit der Taste Return ge�ffnet oder geschlossen werden.' +
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
    '�ber folgenden Link k�nnen Sie nach einem Update schauen:<BR>' +
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
    'Die Mindest-Vorgabe f�r eine Suche ist die Angabe von Z eines Nuklids.<BR>' +
    'Es kann auch ein Bereich �ber A und N vorgegeben werden.<BR>' +
    'Zu dem kann die Suche durch Angabe eines Halbwertzeit-Bereiches eingeschr�nkt werden.<BR>' +
    'Genauso verh�lt es sich mit der Vorgabe eines Energie-Bereiches.<BR>' +
    'Die Eingabefelder "Halbwertzeit" und "Energie" sind nur bei entsprechender Suchart aktiviert.<BR><BR>' +
    'Ist der vorgegebene Suchbereich bei z.B. "Energie" zu gro�, kann die Suche' +
    ' sehr lange dauern und entsprechende Aktivit�ten verursachen.<BR>' +
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
    'Bei der Checkbox "IB" links oben kann vorgew�hlt werden, um die Alphawerte oder Beta-Intensit�ten erweitert anzuzeigen.<BR><BR>' +
    '�ber den Button "Zur�ck" kommt man zur�ck zu den Zerfallsdaten.<BR>' +
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
  '�ber einen der elementaren Masse-Entstehung betreffend heuristischen Gesichtspunkt:<BR>';
  Result := Result + '<BR><FONT SIZE="3">03.01.2011 von Holger Werner</CENTER>' +
  '<font size="-1"><center><a href="mailto:nukliddaten@dokom.net">nukliddaten@dokom.net</a><BR><BR>' +
  '(�ber beiliegende "Zentrumswirkung.pdf" kann dieser Text ausgedruckt werden.)</center></font><BR>' +
  'Hiermit soll versucht werden, eine Sichtweise zu entwickeln, "wie und warum" ' +
  'es zur Entstehung von elementarer Masse im Universum kommen kann. Dazu muss ' +
  'erst einmal erkannt werden, welche elementare Urwirkung daf�r verantwortlich ' +
  'sein d�rfte.<BR><BR>' +
  'Betrachtet man die bekannten Wirksysteme, wie Galaxien, Sterne/Sonnen, Planeten ' +
  'und Atome, dann haben alle etwas recht eindeutig gemeinsam, n�mlich die ' +
  '"Zentrumswirkung", denn alles dieser Wirksysteme tendiert zu ihrem Zentrum ' +
  'hin, weshalb sie auch alle kugelf�rmig sein d�rften. Dabei spielt es doch ' +
  'kaum eine Rolle, dass kleinere Wirksysteme das zentrale Wirksystem umkreisen, ' +
  'wie z.B. Planeten ihre Sonne.<BR><BR>' +
  'Entscheidend muss die Frage sein, wie solch eine makroskopische ' +
  'Zentrumswirkung aus mikroskopisch elementarster Urwirkung resultieren kann. ' +
  'Es kann aber nur teilweise erkl�rt werden, wenn man es aus "unserer" ' +
  'makroskopischen Sicht versucht zu erkl�ren und es wie fast alles ' +
  'im Teilchenmodell �ber die Elektrodynamik beschreibt. Die Elektrodynamik ' +
  'kann doch nur aus den gegenseitigen Wechselwirkungen der Atome resultieren, ' +
  'wenn z.B. elektrischer Strom aus flie�enden Elektronen besteht und ' +
  'Magnetismus resultiert auch aus elektrischem Strom.<BR><BR>' +
  'Die oben beschriebene Zentrumswirkung muss aber elementarster Ursache sein, ' +
  'denn die starke WW und die Gravitation wirken exakt identisch zum Zentrum ' +
  'hin und unterscheiden sich nur in ihrer St�rke und Reichweite. Also k�nnte ' +
  'die starke WW die Urwirkung sein und die Gravitation der weitr�umige ' +
  'Ausl�ufer der starken WW. Es handelt sich somit bei beiden WW um eine ' +
  'einzige, die sich uns nur makroskopisch betrachtet als getrennt darstellt, ' +
  'weil wir die starke WW erst bei den Atomen erkennen k�nnen, die aber auch ' +
  'der Zentrumswirkung unterliegen, wie auch alle makroskopischen Wirksysteme.<BR><BR>' +
  'Newton betrachtete die Gravitation so, dass sich alle Massen gegenseitig ' +
  'anziehen und Einstein berechnete �ber seine ART die r�umliche Auswirkung, ' +
  'woraus sich die Raumkr�mmung ergab. Leider kann das Wort Kr�mmung nur ' +
  'etwas Zweidimensionales beschreiben, wie man einen Stab kr�mmen kann, aber ' +
  'die Gravitation wirkt dreidimensional zum Zentrum hin. Also muss es sich um ' +
  'ein "Zerren" zum Zentrum hin handeln, was zur Folge hat, dass der umliegende ' +
  'Raum gedehnt wird. Daraus l�sst sich schlie�en, dass die Masse des Zentrums ' +
  'und ihre nahe Umgebung, die auch noch "verdichtet" ist, eine Konzentration ' +
  'des umliegenden "Mediums/Raumes" darstellt.<BR><BR>' +
  'Somit sollte von einem "Urmedium" ausgegangen werden, welches sich ' +
  'innerhalb des kugelf�rmigen Sonnensystems zum Zentrum hin, also als Sonne ' +
  'verdichtet hat. Genauso k�nnen alle Galaxien betrachtet werden, denn dort ' +
  'handelt es sich lediglich um die Zentren als "schwarze Sterne", welche "leider" ' +
  'von uns Oberfl�chenbetrachter "schwarzes Loch" genannt werden. Die schwarzen ' +
  'Sterne stellen die makroskopische Maximierung der Zentrumswirkung dar. Es ' +
  'muss sich also um ein elastisches Urmedium handeln, was wir als Raum, Vakuum, ' +
  'Nichts und fr�her auch als recht starren �ther bezeichne(te)n.<BR><BR>' +
  'Um aber die elementarste Zentrumswirkung erkl�ren zu k�nnen, darf die ' +
  'elementarste Welle, das Licht, nicht als "elektromagnetisch transversale" ' +
  'Welle betrachtet werden, was ja auch nur ein willk�rliches Postulat von ' +
  'Maxwell war. Eine transversale Welle kann auch nur aus der Bewegung eines ' +
  '"Teilchen" resultieren, welches vom Medium, das es durchquert, zur transversalen ' +
  'Wellenbewegung gezwungen wird.<BR><BR>' +
  'Somit d�rfte es sich bei der Lichtwelle, die aus allen Richtungen ' +
  'betrachtet und gemessen werden kann, um eine longitudinale Welle, also ' +
  'Druckwelle im Urmedium handeln, denn w�rde ein Wirksystem nach jedem ' +
  '"Betrachter" ein Teilchen als Photon schicken, welche ja alle die gleiche ' +
  'Energie haben m�ssten, dann lie�e es sich sicherlich einfach berechnen, ' +
  'wie schnell sich die Gesamtenergie des emittierenden Wirksystems verbraucht ' +
  'h�tte.<BR><BR>' +
  'Das aber wird nie experimentell beobachtet. Ein Atom gibt meist nur ' +
  '�berschu�energie als Gamma- bzw. Lichtwelle ab. Nur eine longitudinale Welle ' +
  'innerhalb des Urmediums kann alle umliegenden "Betrachter" mit einem einzigen ' +
  'Impuls als Lichtwelle treffen und das emittierende Wirksystem gibt nur diese ' +
  'Art Impuls ans Urmedium ab, der alle mit gleicher Energie trifft.<BR><BR>' +
  'Ebenso erkl�rt Licht als longitudinale Welle das Plancksche ' +
  'Wirkungsquantum, denn jede Verdichtung der Welle stellt ein Wirkungsquantum ' +
  'dar. Deshalb l��t sich Licht als Quanten berechnen. Es lassen sich sogar einzelne ' +
  'Photonen erzeugen, in dem nur eine einzige Druckwelle ausgesandt wird. Diese ' +
  'aber d�rfte aus allen Richtungen gesehen und gemessen werden, in die sie ' +
  'wirkt, denn wenn eine longitudinale Welle z.B. durch ein ' +
  '"Laser-R�hrchen" geschickt wird, so breitet sich dieser Impuls erst in sehr ' +
  'gro�er Entfernung aus und trifft in der N�he nur einen winzigen Punkt.<BR><BR>' +
  'Genauso erkl�ren sich Lichtstrahlen in unserer Atmosph�re, denn sie tauchen ' +
  'nur dort deutlich erkennbar auf, wo die Sonnenstrahlen ein Loch in den Wolken ' +
  'durchqueren. Die wesentlich intensiveren Sonnenstrahlen setzen sich auch ' +
  'geradlinig von Atom zu Atom in der Atmosph�re fort, aber jedes dieser ' +
  'getroffenen Luftatome emittiert diese Energie sofort wieder als longitudinale ' +
  'Welle, weshalb wir diese Lichtstrahlen auch von der Seite sehen k�nnen.<BR><BR>' +
  'Dieser Effekt taucht auch bei experimentellen Laserstrahlen auf, wenn es ' +
  'sich um keine Lichtfrequenz handelt. Erst wenn der Laserstrahl ein Gas ' +
  'durchqueren muss, wird er sichtbar. Das kann ein experimenteller Beleg ' +
  'daf�r sein, dass wir Atome erst mit sichtbar emittierenden Lichtwellen sehen ' +
  'k�nnen, genauso wie bei Sonnenstrahlen in unserer Atmosph�re. Auch die Biophotonen ' +
  'erkl�ren sich so, denn alle Atome unseres K�rpers emittieren sofort jede absorbierte ' +
  'Energie als Photon, welcher Frequenz auch immer.<BR><BR>' +
  'Das erkl�rt auch, warum wir nur die Seite unseres Mondes "beleuchtet" sehen, ' +
  'denn nur von der Sonne getroffene Mondatome emittieren diese Energie wieder ' +
  'und diese trifft auf unsere Augen. Da wir aber alle den Mond gleichzeitig ' +
  'sehen, d�rfte er kaum nach jedem Auge Photonen als Teilchen schicken, sondern ' +
  'die vom Sonnenlicht getroffenen Mondatome senden daraufhin eigene Lichtwellen ' +
  'aus, die unser aller Augen als longitudinale Welle mit gleicher Energie treffen.<BR><BR>' +
  'Zu dem erkl�ren sich die Rotverschiebungen aller Galaxien, um so entfernter ' +
  'sie sind. Der Raum bzw. das Urmedium innerhalb unseres Sonnensystems ' +
  'muss gedehnt sein und umso weiter eine Galaxis entfernt ist, umso ' +
  'mehr hat sich die Lichtwelle ausgedehnt, weshalb sie mit weniger Verdichtung ' +
  'bei uns ankommt. Dies erkl�rt somit die jeweilige Rotverschiebung der Galaxien ' +
  'nach dem Dopplereffekt. Dann muss auch noch ' +
  'ber�cksichtigt werden, dass der Dopplereffekt direkt auf unserem Planeten ' +
  'anders wirken d�rfte, als drau�en im gedehnten Urmedium.<BR><BR>' +
  'Also kann daraus nicht (mehr) geschlossen werden, unser Universum dehnt ' +
  'sich st�ndig nach allen Richtungen aus. Schon allein die Deep-Field-Aufnahme ' +
  'des Hubble-Teleskops ben�tigte etwa 14 Tage starre Belichtung, ' +
  'um �berhaupt erst ein Bild dieser Galaxien erzeugen zu k�nnen. ' +
  'Daraus kann doch recht einfach geschlossen werden, dass dieses Licht mit ' +
  'wesentlich geringerer Intensit�t beim Hubble-Telescop ankam.<BR><BR>' +
  'Dar�ber hinaus werden diese Lichtwellen auch noch vom gedehnten Urmedium innerhalb ' +
  'unseres Sonnensystems noch mehr gedehnt als die Lichtwellen von nahen Sternen ' +
  'und Galaxien, denn deren Licht erreicht uns mit erheblich h�herer Energie, ' +
  'also als wesentlich st�rker verdichtete longitudinale Wellen, weshalb sie vom ' +
  'gedehnten Urmedium im Sonnensystem auch weniger gedehnt werden.<BR><BR>' +
  'Genauso erkl�rt sich die Synchrotronstrahlung, denn jede verdichtete Masse, ' +
  'z.B. als Elektron, verdichtet das Urmedium entsprechend weit in ' +
  'Bewegungsrichtung, je mehr sie sich der Lichtgeschwindigkeit n�hert, was die ' +
  'experimentellen Ergebnisse recht eindeutig zeigen und was die Richtung der ' +
  'Synchrotronstrahlung selbst kreisf�rmig bewegender Elektronen ausmacht. ' +
  'Jeder Druck, also jede Verdichtung innerhalb des Urmediums, bewirkt eine ' +
  'longitudinale Lichtwelle, weshalb auch dieses Licht aus allen Richtungen ' +
  'gesehen und gemessen werden kann, was wie ein experimenteller Nachweis f�r ' +
  'Licht als longitudinale Welle und das elastische Urmedium wirkt.<BR><BR>' +
  'Weiterhin ergibt sich auch eine Erkl�rung f�r die Pioneer-Anomalie, denn wenn ' +
  'das Urmedium innerhalb des Sonnensystems zum Zentrum, also unserer Sonne ' +
  'hin immer st�rker gedehnt ist, muss diese Dehnungswirkung auch ihre Grenze ' +
  'am Rande des Sonnensystems haben. Exakt das erkl�rt sich �ber die ' +
  'Gravitation und dar�ber d�rfte sich die Dehnung sogar berechnen lassen.<BR><BR>' +
  'Am Rand unseres Sonnensystems, den die Pioneer-Sonden bereits erreicht ' +
  'und sogar �berschritten haben, muss sich das Urmedium, durch das sich ' +
  'die Sonden bewegen, immer mehr verdichten. Genau das bewirkt diese minimale ' +
  'Geschwindigkeits-Reduktion. Leider werden keine weiteren Nachrichten mehr ' +
  'von den Sonden empfangen, denn sie d�rften sich immer weiter verlangsamen. ' +
  'Wer wei�, vielleicht wurden sie inzwischen sogar vom dichteren Urmedium ' +
  '"erdr�ckt", eben weil sie sich zu schnell dadurch bewegten, weshalb sie ' +
  'auch nichts mehr senden k�nnen?<BR><BR>' +
  'Genauso erkl�rt sich die "relative" Konstanz der Lichtgeschwindigkeit durch ' +
  'das Urmedium als longitudinale Welle, denn diese wird durch die jeweilig ' +
  'lokale Dichte und den Eigenschaften des Urmediums bestimmt. Die Dichte des ' +
  'Urmediums au�erhalb aller Sonnensysteme d�rfte erheblich h�her sein und so ' +
  'k�nnte sich die "Dunkle Materie" erkl�ren. Ebenso, weshalb es die Oortsche ' +
  'Wolke gibt, denn au�erhalb d�rften sich dauernd neue Brocken bilden, eben ' +
  'weil das Urmedium dort wesentlich dichter ist und st�ndig von Lichtwellen ' +
  'der umliegenden Sterne durchquert wird. Wom�glich sind die R�ume zwischen ' +
  'den einzelnen Sonnensystemen sogar mit Kometen regelrecht gef�llt. Also auch ' +
  'so k�nnte sich die Dunkle Materie erkl�ren.<BR><BR>' +
  'Betrachtet man zwei sich frontal begegnende Lichtwellen, die ja verdichtetes ' +
  'Urmedium, also bereits verdichtete Masse darstellen, dann d�rfte es zu einem ' +
  'weiteren Verdichtungseffekt kommen, wo sich die Wellen direkt frontal ' +
  'treffen. Es sollte sich aber lediglich um einen weiteren Verdichtungseffekt ' +
  'und keine Verwirbelung handeln, wovon viele andere Theorien fast generell ' +
  'ausgehen. Wirbelsysteme d�rften sich nie nahe beieinander ' +
  'erhalten k�nnen und sich allenfalls schnell gegenseitig vernichten. Ein ' +
  'einfaches Beispiel sind zwei sich drehend n�hernde Kreisel und wie sie sich ' +
  'gegenseitig st�ren, wenn sie sich ber�hren.<BR><BR>' +
  '<CENTER>> )( <</CENTER><BR><BR>' +
  'Durch das frontale Zusammentreffen entsteht eine punktf�rmige Verdichtung. ' +
  'Somit k�nnte dieses dem elementarsten Wirksystem, also der elementarsten ' +
  'Entstehung von Masse entsprechen, welche aber schnell wieder als Lichtwelle ' +
  '"zerf�llt".<BR><BR>' +
  'Kann sich so auch die Paarerzeugung von ' +
  'Positron und Elektron erkl�ren, was aber bisher nur in der N�he von ' +
  'Atomkernen experimentell beobachtet wurde? Diese elementarsten Urwirkungen ' +
  'bewirken die kosmische Hintergrundstrahlung und/oder Vakuumfluktuationen, denn ' +
  'alle Sterne senden stets Gammawellen unterschiedlichster Frequenz aus, die ' +
  '�berall dauernd aufeinander treffen.<BR><BR>' +
  'Gleichzeitig erkl�rt es erstmalig, warum bei unserer bekannten Formel E=mc� ' +
  'das c zum Quadrat stehen muss, denn diese verdichtete Urmasse beinhaltet die ' +
  'Energie zweier jeweils mit c kollidierten Lichtwellen. Diese elementarst ' +
  'physikalische Urgesetzm��igkeit muss sich somit ins Makroskopische fortsetzen.<BR><BR>' +
  'Entstehen aber mehrere solcher "Urwirksysteme" recht nahe ' +
  'beieinander, die alle das umgebende Urmedium zu ihren Zentren zerren, ' +
  'm�ssen sie sich gegenseitig mit starker WW anziehen. Zerfallen sie ' +
  'wieder, treffen sich die daraus entstehenden Wellen auf engstem ' +
  'Raum und alle zusammen erhalten sich durch diese st�ndige "Fluktuation" als ' +
  'Gesamtsystem. Da alles mit Lichtgeschwindigkeit auf engstem Raum stattfindet, ' +
  'unterliegt solch ein Gesamtsystem auch einer relativ langen "Zerfallszeit".<BR><BR>' +
  'Dann d�rften sich auch solche Gesamtsysteme vereinen, die sich durch ihre ' +
  'st�ndigen Fluktuationen auch st�ndig gegenseitig anziehen. Also k�nnten ' +
  'diese Gesamtsysteme den Valenzquarks entsprechen und die dazwischen, wegen ' +
  'des st�ndigen Zerfalls der Einzelsysteme, st�ndig entstehenden neuen ' +
  'Wirksysteme den Seequarks, die wie "Gluonen" auf die Valenzquarks wirken ' +
  'und somit alles als Proton erhalten.<BR><BR>' +
  'Gleichzeitig erkl�rt sich daraus, weshalb die starke WW und Gravitation als ' +
  'weitr�umiger Ausl�ufer der starken WW "dauernd" wirken, denn es resultiert ' +
  'aus diesen st�ndigen Fluktuationen, die stets mit starker WW stattfinden.<BR><BR>' +
  'Um das Proton herum ist aber alles auch noch relativ zum Urmedium verdichtet, ' +
  'was als Elektronium bezeichnet wird. Diese Verdichtung entspricht somit dem ' +
  'Wasserstoffatom(H), also dem elementarsten Atom.<BR><BR>' +
  'Zu dem vereinigen sich �ber die Zentrumswirkung auch H-Atome, wobei sich ' +
  'die gemeinsame Zentrumsenergie erh�ht. Eins von beiden Protonen ' +
  'verdichtet seine nahe Umgebung deswegen st�rker und n�her um sich, was aus ' +
  'der gemeinsamen Zentrumsenergie resultiert und dieses System entspricht dem ' +
  'Neutron.<BR><BR>' +
  'Dieses l�sst sich recht einfach nachvollziehbar aus den Beta-Zerf�llen ' +
  'erkennen, denn Neutronen entstehen ausschlie�lich im Kernverband, wobei ein ' +
  'Proton �ber Elektronen-Einfang zum Neutron wird. Jedes freie Neutron ' +
  'zerf�llt ja nach sp�testens 11 Minuten zur�ck zum Proton, in dem es ein ' +
  'Elektron emittiert.<BR><BR>' +
  'Die Beta+-Emission k�nnte einem "aktiven Wirksystem" als z.B. Valenzquark ' +
  'entsprechen, weshalb es magnetisch positiv wirkt und mit jedem Kontakt von ' +
  'stabileren Systemen, aber auch verdichtetem Elektronium zur Gammawelle ' +
  'zerf�llt. �berhaupt alle Wirksysteme zerfallen zu Gammewellen und allenfalls ' +
  'in ihre Bestandteile aus Einzel-Wirksystemen, die sich aber kaum so lange ' +
  'erhalten k�nnen und relativ schnell zerfallen.<BR><BR>' +
  'Somit widerspricht diese Sichtweise kaum dem Teilchenmodell und best�tigt es ' +
  'sogar zumindest in seinen Grundelementen. Nicht aber Licht als elektromagnetische ' +
  'und transversale Welle, zumal bis heute Licht nie elektromagnetische ' +
  'Eigenschaften experimentell nachgewiesen werden konnte. Es handelt(e) sich ' +
  'stets nur um wunschgem��e Interpretation als transversal elektromagnetische ' +
  'Welle, wie es auch Heinrich Hertz aus seinem Experiment "interpretierte". ' +
  'Andererseits soll aber Nikola Tesla sogar Lord Kelvin bei einem Experiment ' +
  'Licht und elektromagnetische Welle als longitudinale Welle nachgewiesen ' +
  'haben, was aber allgemein nicht anerkannt worden ist.<BR><BR>' +
  'Weshalb wir Licht immer noch als Strahl interpretieren, liegt einfach daran, ' +
  'weil es noch nicht ausreichend als longitudinale Welle betrachtet wurde. Es ' +
  'erkl�rt sich aber recht einfach, denn unsere Augen haben auch Kugelform, ' +
  'wie auch jede longitudinale Welle, wobei diese Wellen unsere Augen aber ' +
  'relativ geradlinig erreichen d�rften, es sein denn die Lichtquelle ist ' +
  'recht nahe.<BR><BR>' +
  '<CENTER>> |(</CENTER><BR><BR>' +
  'Trotzdem werden nur diese Atome unserer Augen von der Lichtwelle angeregt, ' +
  'worauf sie frontal auftrifft. Die meisten umliegenden Atome werden ' +
  'nicht frontal getroffen, weshalb sie deutlich weniger Energie �bertragen ' +
  'bekommen. Also wird nur ein Punkt ausreichend angeregt und dieses deuten ' +
  'wir deshalb als Strahl bzw. Teilchen, als Photon.<BR><BR>' +
  'Auch das Olbersche Paradoxon erkl�rt sich somit, denn das Universum muss ' +
  'deshalb dunkel sein, weil uns das Licht aller entfernten Galaxien nur noch ' +
  'abgeschw�cht erreicht, weshalb ja f�r die Deep-Field-Aufnahme des ' +
  'Hubble-Teleskop mindestens 14 Tage Belichtung dieses Punktes des Universums ' +
  'erforderte. Somit k�nnen wir auch nie Grenzen des Universums erkennen und ' +
  'deuteten bisher alles lediglich auf Grund unserer technisch m�glichen ' +
  '"Sichtweite".<BR><BR>' +
  'Weiterhin erkl�rt sich auch nachvollziehbar, woraus die magnetischen ' +
  'Feldlinien bestehen k�nnen, die bisher als virtuelle Photonen beschrieben ' +
  'wurden. Das Elektronium muss sich ja mit zunehmendem Abstand vom Atomkern ' +
  'entsprechend "verd�nnen", also immer weniger verdichtet sein. Somit haben ' +
  'wir es mit einem f�r uns technisch kaum me�baren �u�eren Bereich zu ' +
  'tun, weshalb Pauli seinerzeit das Neutrino als Teilchen postulierte, um die ' +
  'fehlende Energie eines Gesamtatoms berechnen zu k�nnen. Also k�nnte der �u�ere ' +
  'Bereich auch Neutrinium genannt werden, wenn es sich lediglich um die ' +
  '�u�eren Bereiche des Elektroniums handelt.<BR><BR>' +
  'Neutrinos sollen ja jegliche Materie durchdringen k�nnen, wie auch die ' +
  'magnetischen Feldlinien. Betrachtet man einen elektrischen Leiter, der beim ' +
  'Stromdurchflu� von einem kreisf�rmigen Magnetfeld umgeben ist, dann k�nnte ' +
  'es sich so erkl�ren, dass das den Leiter durchflie�ende Elektronium den ' +
  '"schw�cheren" Teil, also das Neutrinium, nach au�en dr�ckt. Da der ' +
  'Leiter aus Kugelatome besteht, bewegt sich auch alles ' +
  'Elektronium entsprechend verwirbelt spiralf�rmig dadurch. Deshalb wird auch ' +
  'das nach au�en verdr�ngte Neutrinium kreisf�rmig um den Leiter verdr�ngt.<BR><BR>' +
  'Da es sich beim Neutrinium bereits um verdichtete Masse handelt, muss es ' +
  'auch Auswirkungen auf dichtere Masse haben, weshalb sich um den Leiter z.B. ' +
  'Eisensp�ne kreisf�rmig anordnet. Das Neutrinium muss ja eine �hnliche ' +
  'Wirkung auf diese Eisensp�ne, bestehend aus Atome haben, genauso wie ' +
  'Lichtwellen wirken. Nur die Energie des Neutriniums muss st�rker sein, ' +
  'weshalb es die Eisensp�ne sogar kreisf�rmig ausrichtet. L�sst sich somit ' +
  'sogar erstmalig die elementare Entstehung des Magnetismus erkl�ren?<BR><BR>' +
  'So erkl�rt sich alles aus einer einzigen WW, der starken WW und alle ' +
  'weiteren, wie die Gravitation als weitr�umiger Ausl�ufer der starken WW. ' +
  'Die Elektromagnetische WW resultiert aus den Wirkungen zwischen den ' +
  'Wirksystemen als Atome.<BR><BR>' +
  'Ist es nicht interessant, wie sich �ber diese Sichtweise praktisch alles ' +
  'erkl�ren l�sst, also das Teilchenmodell aus elementarster Entstehung und ' +
  'einige bisher kaum erkl�rbare Ph�nomene, wie die Entstehung der Gravitation, ' +
  'die starke WW, die EM-WW, die Rotverschiebung der Galaxien, die ' +
  'Pioneer-Anomalie und das Olbersche Paradoxon?<BR><BR>' +
  'Genauso interessant ist, dass nichts hinzu postuliert wird und alles nur aus ' +
  'der Sichtweise der Licht- bzw- Gammawelle im elastischen und somit dehn- ' +
  'und "kr�mmbaren" Urmedium als longitudinale Welle betrachtet wird! Zu ' +
  'dem stimmt alles l�ckenlos mit allen experimentellen Erkenntnissen �berein, ' +
  'was allerdings z.B. Albert Einstein zu seiner Zeit noch nicht erkennen ' +
  'konnte, weil die experimentelle Atomphysik noch nicht so weit ' +
  'fortgeschritten war.<BR><BR>' +
  'Was sich aber als unwahrscheinlich daraus ergeben d�rfte, ist der Urknall, ' +
  'der sich aus der "scheinbar" st�ndigen Vergr��erung des Universums ergab. ' +
  'Dieses resultierte aus der "rein mathematischen" Interpretation des ' +
  'Dopplereffekts, ohne die lokale Dichte des Raumes/Urmediums zu ' +
  'ber�cksichtigen. Der Raum soll aber laut ART kr�mmbar sein, was sich recht ' +
  'eindeutig aus den r�umlichen Wirkungen der Gravitation ergibt.<BR><BR>' +
  'Genauso kann es sich bei nicht wenigen "Teilchen" des Teilchenmodells nur ' +
  'um sehr kurzzeitige Kollisionsresultate handeln, weshalb sie auch derart ' +
  'schnell wieder zerfallen. Das d�rfte auch kaum verwundern, wenn die ' +
  'kosmische Strahlung mit Atome der Atmosph�re kollidiert. Exakt das ' +
  'wird in den Teilchenbeschleunigern gemacht und das mit ' +
  'immer h�heren Energien, wie jetzt beim LHC, um z.B. das Higgs-Teilchen ' +
  'daraus "interpretieren" zu k�nnen.<BR><BR>' +
  'Antimaterie entsteht ja nur aus Kollisionen von Atomen, welcher Art auch immer, ' +
  'wie durch die kosmische Strahlung, die mit Atomen der Atmosph�re kollidiert, was ' +
  'genauso in allen Teilchenbeschleunigern geschieht. Somit k�nnte es sich beim ' +
  'Myon und Tauon um deaktivierte Wirksysteme als Proton oder Neutron handeln, ' +
  'weshalb sie magnetisch negativ wirken. Das erkl�rt auch, warum Myon und Tauon ' +
  'so viel Masse im Vergleich zum Elektron haben.<BR><BR>' +
  'Genauso erkl�rt sich das Anti-Myon und Anti-Tauon, denn diese "Antiteilchen" ' +
  'sind noch nicht komplett deaktiviert, aber nicht mehr so vollst�ndig, um z.B. ' +
  'als Proton weiter existieren zu k�nnen, weshalb sie aber weiterhin magnetisch ' +
  'positiv wirken. Da nur das Proton und alle daraus sich ergebenden Systeme als ' +
  'Atome "recht stabil" sind, zerfallen auch alle bereits durch Kollision teilweise ' +
  'deaktivierten Wirksysteme sehr schnell, weil die Voraussetzungen wie im Proton ' +
  'nicht mehr vorhanden sind und sich die noch aktiven Wirksysteme nicht gegenseitig ' +
  'erhalten k�nnen. Somit erkl�rt sich auch, warum Antimaterie stets so schnell ' +
  'zerf�llt und weshalb es nur Materie gibt.<BR><BR>' +
  'Auch die Antimaterie k�nnte somit nur eine Interpretation sein, was sich ja auch ' +
  'rein mathematisch ergab. Nat�rlich kann nicht ausgeschlossen werden, dass es ' +
  'so etwas wie ein Anti-Proton und Anti-Neutron geben kann, denn wenn wegen einer Kollision im ' +
  'Proton die einzelnen Wirksysteme anders und somit magnetisch ' +
  'gegens�tzlich wirken, dann kann das nicht ausgeschlossen werden. Allerdings ' +
  'd�rften solche Anti-Teilchen generell keine lange Lebensdauer haben, weshalb ' +
  'sich nur aus "stabilen" Wirkystemen Materie evolution�r bilden konnte und ' +
  'kann.<BR><BR>' +
  'Das Problem der mathematischen "Forschung" ist, dass immer wieder rein ' +
  'willk�rliche Postulate erforderlich sind, um ein "wunschgem��es" Resultat ' +
  'zu erreichen. Das beste Beispiel sind die Stringtheorien, wobei immer mehr ' +
  'Dimensionen postuliert wurden, die ihren Ursprung aus der ' +
  'Kaluza-Klein-Theorie haben, bei der Magnetismus als winzig aufgerollte 5. ' +
  'Dimension postuliert wurde.<BR><BR>' +
  'Somit muss (fast) jedes willk�rliche Postulat, welches zum mathematischen ' +
  'Wunschergebnis erforderlich ist, zwangsl�ufig in zus�tzliche Dimensionen ' +
  'und sogar scheinbare Parallelwelten f�hren. Also kann der Spruch "Was ' +
  'Mathematik alles bewirken kann" doch real (fast) nur Phantasiewelten schaffen. ' +
  'Er sollte eher lauten: "In welch reine Phantasiewelten Mathematik entf�hren ' +
  'kann!"<BR><BR>' +
  'Erst die kausale und somit logische Schlu�folgerung aus allen bereits ' +
  'bekannt experimentellen Erkenntnissen, ohne ein einzig willk�rliches ' +
  'Postulat einzuf�gen, kann nahe an die Realit�t unserer physikalischen ' +
  'Welt f�hren! Erst diese Basis schafft die m�gliche mathematische Interpretation, ' +
  'ohne ein einziges Postulat einzuf�gen, um m�glichst nahe an der Realit�t ' +
  'bleiben zu k�nnen.<BR><BR>' +
  'Spricht somit nicht sogar vieles f�r diese Sichtweise der elementaren ' +
  'Masse-Entstehung? Ist es nicht w�nschenswert, sich nahe der ' +
  'physikalischen Realit�t zu befinden, statt all diesen Phantastereien ' +
  'zu erliegen, wie sie besonders von Mathematikern wie u.a. Minkowski ' +
  'aus den Relativit�tstheorien errechnet wurden? ' +
  'All das erledigt sich dadurch regelrecht als phantastisches "Wunschdenken", ' +
  'wie ja auch jeglicher "Glaube", ' +
  'der meist auch nur reinem Wunschdenken entsprechen kann, ' +
  'eben weil alles f�r uns Menschen recht ern�chternd wirken muss.<BR><BR>' +
  'Trotzdem spricht nicht viel daf�r, dass diese Sichtweise "etablierte" ' +
  'Anerkennung findet. Eher wird es von "dort oben" lauten, alles sei nicht ' +
  '"(etabliert) wissenschaftlich", eben weil u.A. so wenig mathematisch dargestellt wird. ' +
  'Jeder hat aber hiermit zumindest die M�glichkeit, sich �ber reine Logik ' +
  'recht nahe der physikalischen Realit�t selbst "Wissen zu schaffen".<BR><BR>';
  Result := Result + '<BR></BODY></HTML>';
end;

end.
