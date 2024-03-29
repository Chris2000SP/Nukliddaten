unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ToolWin, ComCtrls, Grids, Aligrid, icongrid, Math,
  StdCtrls, Buttons, DB, Types, TeEngine, Series, TeeProcs, Chart, JvExComCtrls,
  JvProgressBar, JvStatusBar, HTMLLite, CheckLst, JvExStdCtrls, JvCombobox,
  JvEdit, JvValidateEdit, JvExExtCtrls, JvRadioGroup, JvButton, JvTransparentButton,
  JvExControls, JvComponent, JvgBevel, ShellAPI, SpecLib, JvRollOut;

type
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    MenuDatei: TMenuItem;
    MenuDateiExit: TMenuItem;
    Datum: TTimer;
    PC: TPageControl;
    PagePSE: TTabSheet;
    PageKarte: TTabSheet;
    MenuPSE: TMenuItem;
    SBPSE: TScrollBox;
    GridPSE: TIconGrid;
    PanelPSEGridDaten: TPanel;
    GridPSEDaten: TIconGrid;
    RG: TRadioGroup;
    PanelFarbe: TPanel;
    lblTitel: TLabel;
    lblbez: TLabel;
    MenuNukKarte: TMenuItem;
    GridElektron: TIconGrid;
    GridZusatz: TIconGrid;
    MenuInfo: TMenuItem;
    MnuAbout: TMenuItem;
    Stop: TTimer;
    PageDiagram: TTabSheet;
    Chart1: TChart;
    Series1: TBarSeries;
    JvgBevel: TJvgBevel;
    btnPSE: TJvTransparentButton;
    btnMarks: TJvTransparentButton;
    btnZoom: TJvTransparentButton;
    PanelbtnDiag: TPanel;
    btnDiagram: TJvTransparentButton;
    btnAbund: TJvTransparentButton;
    MnuHelp: TMenuItem;
    N1: TMenuItem;
    StatusBar: TJvStatusBar;
    SBNuk: TScrollBox;
    GridNuk: TIconGrid;
    PanelLeg: TPanel;
    PanelProton: TPanel;
    Image1: TImage;
    PanelZoom: TPanel;
    btnNukZoom: TJvTransparentButton;
    PanelIso: TPanel;
    Image2: TImage;
    CBHalf: TComboBox;
    Series2: TFastLineSeries;
    btnNukDiag: TJvTransparentButton;
    PMenuLeg: TPopupMenu;
    pmnuLeg: TMenuItem;
    pmnuMinGrid: TMenuItem;
    PMExpl: TPopupMenu;
    PMExplGoNuk: TMenuItem;
    Series3: TPointSeries;
    btnVor: TJvTransparentButton;
    btnZur: TJvTransparentButton;
    PageZerfall: TTabSheet;
    MenuDecay: TMenuItem;
    PanelBtnRad: TPanel;
    TVRad: TTreeView;
    btnRad1: TJvTransparentButton;
    btnRadSort: TJvTransparentButton;
    btnRad2: TJvTransparentButton;
    SBRad: TScrollBox;
    SBGridRad: TScrollBox;
    GridRad: TIconGrid;
    MenuOption: TMenuItem;
    btnBack: TJvTransparentButton;
    SBGridReihe: TScrollBox;
    MnuRef: TMenuItem;
    N2: TMenuItem;
    MnuUpdate: TMenuItem;
    btnRad3: TJvTransparentButton;
    Gauge: TJvProgressBar;
    MenuSuch: TMenuItem;
    PageSuch: TTabSheet;
    PanelSuchEdit: TPanel;
    CBShowGrid: TCheckBox;
    PanelSuch: TPanel;
    SBSuchKarte: TScrollBox;
    GridSuchKarte: TIconGrid;
    PanelSuchFilter: TPanel;
    lblFilter: TLabel;
    lblAnz: TLabel;
    lblSuchArt: TLabel;
    GridSuch: TIconGrid;
    PanelSuchPos: TPanel;
    RGSuch: TJvRadioGroup;
    RGSuchSort: TJvRadioGroup;
    lblA: TLabel;
    ETA1: TJvValidateEdit;
    lblAbis: TLabel;
    ETA2: TJvValidateEdit;
    lblZ: TLabel;
    ETZ: TJvValidateEdit;
    lblSymb: TLabel;
    CBSym: TJvComboBox;
    lblN: TLabel;
    ETN1: TJvValidateEdit;
    lblNbis: TLabel;
    ETN2: TJvValidateEdit;
    ETH1: TJvValidateEdit;
    CBTH1: TJvComboBox;
    lblTHalb: TLabel;
    lblTbis: TLabel;
    ETH2: TJvValidateEdit;
    CBTH2: TJvComboBox;
    lblEnergy: TLabel;
    EEnergy: TJvValidateEdit;
    lblPlusMinus: TLabel;
    EkeV: TJvValidateEdit;
    lblkeV: TLabel;
    btnReset: TJvTransparentButton;
    btnSuch: TJvTransparentButton;
    PageSpec: TTabSheet;
    MenuSpec: TMenuItem;
    SBSpec: TScrollBox;
    ImSpecAbs: TImage;
    ImSpecEm: TImage;
    GridSpecPSE: TIconGrid;
    lblSpecAb: TLabel;
    lblSpecEm: TLabel;
    ImSpecAbScale: TImage;
    ImSpecEmScale: TImage;
    lblSpecElem: TLabel;
    ShapeSpec: TShape;
    lblnm: TLabel;
    lblTHz: TLabel;
    lblSpecNo: TLabel;
    lblLambda: TLabel;
    ChLB: TCheckListBox;
    lblSpecTitel: TLabel;
    MenuZW: TMenuItem;
    MenuVTS: TMenuItem;
    PageZW: TTabSheet;
    ZWViewer: ThtmlLite;
    Panel2: TPanel;
    MenuKarte: TMenuItem;
    MenuLeg: TMenuItem;
    MenuGridMin: TMenuItem;
    MenuZReihe: TMenuItem;
    MenuNSpalte: TMenuItem;
    MenuPfeil: TMenuItem;
    MenuRad: TMenuItem;
    MenuRadKarte: TMenuItem;
    MenuStrahl: TMenuItem;
    MenuExpl: TMenuItem;
    MenuGridDat: TMenuItem;
    N3: TMenuItem;
    PanelGridDat: TPanel;
    GridDaten: TIconGrid;
    PanelNukTV: TPanel;
    Panel1: TPanel;
    btnTVSort: TJvTransparentButton;
    TVNuk: TTreeView;
    btnTVRadSuch: TJvTransparentButton;
    MenuMagZahlen: TMenuItem;
    btnTVNukSuch: TJvTransparentButton;
    PageSchema: TTabSheet;
    PanelSchema: TPanel;
    btnSchemaBack: TJvTransparentButton;
    SBSchema: TScrollBox;
    PBSchema: TPaintBox;
    GridRbtn: TIconGrid;
    CBIB: TCheckBox;
    lblDB: TLabel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DatumTimer(Sender: TObject);
    procedure TVNukChange(Sender: TObject; Node: TTreeNode);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure GridShowHintCell(Sender: TObject; col, row: Integer;
      var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure ShowPage(Sender: TObject);
    procedure GridPSEDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure RGClick(Sender: TObject);
    procedure RGGamSortClick(Sender: TObject);
    procedure GruppenHint;
    procedure GridPSEShowHintCell(Sender: TObject; col, row: Integer;
      var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure MenuDateiExitClick(Sender: TObject);
    procedure GridPSEDatenDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StopTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPSEClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnMarksClick(Sender: TObject);
    procedure Series1GetMarkText(Sender: TChartSeries; ValueIndex: Integer;
      var MarkText: String);
    procedure btnZoomClick(Sender: TObject);
    procedure Chart1GetAxisLabel(Sender: TChartAxis; Series: TChartSeries;
      ValueIndex: Integer; var LabelText: String);
    procedure btnAbundClick(Sender: TObject);
    procedure MnuHelpClick(Sender: TObject);
    procedure GridNukDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnNukZoomClick(Sender: TObject);
    procedure CBHalfChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridNukMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PMExplGoNukClick(Sender: TObject);
    procedure btnVorClick(Sender: TObject);
    procedure btnTVSortClick(Sender: TObject);
    procedure GridNukMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure PanelLegMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure SBNukConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure btnRadClick(Sender: TObject);
    procedure TVRadChange(Sender: TObject; Node: TTreeNode);
    procedure GridReiheDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure MenuOptClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure TVKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridPSEKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGamClick(Sender: TObject);
    procedure SetMenueItem(Idx: Integer);
    procedure IntChange(Sender: TObject);
    procedure btnSuchClick(Sender: TObject);
    procedure GridSuchDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridRadDatDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure CBShowGridClick(Sender: TObject);
    procedure RGSuchClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure ETZChange(Sender: TObject);
    procedure RGSuchSortClick(Sender: TObject);
    procedure GridDatenDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure CBChange(Sender: TObject);
    procedure SBGridReiheConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure GridReiheClick(Sender: TObject);
    procedure GridSpecPSEDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ImSpecMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ChLBClickCheck(Sender: TObject);
    procedure ChLBClick(Sender: TObject);
    procedure ZWViewerHotSpotClick(Sender: TObject; const SRC: String;
      var Handled: Boolean);
    procedure MenuExplClick(Sender: TObject);
    procedure MenuGridDatClick(Sender: TObject);
    procedure btnTVSuchClick(Sender: TObject);
    procedure GridRbtnDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure PBSchemaPaint(Sender: TObject);
    procedure GridRbtnSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure CBIBClick(Sender: TObject);
  private
    { Private-Deklarationen }
    RGlast,Zx,AktZ,AktN,nochmal,SpecX,SpecY: Integer;
    LongDatum: String;
  public
    { Public-Deklarationen }
    bDiag,bAbund,bZoom,TvAktiv: Boolean;
    IntRGB,PXneu,PYneu,PXalt,PYalt,MinPosX,MinPosY,AktPosCol,AktPosRow: Integer;
    TVNukIdx,TVRadIdx,nukw,bRad,anzrad,XAkt,SBRadH,SBRadV,bmpt,bmpl: Integer;
    Spalte,RGSuchIdxAlt: String;
    Min,Max,RadTyp,DQL: Double;
    VonF,ZuF: TColor;
    PSEF: array[0..17] of TColor;
    NukF: array[0..10] of TColor;
    RadF: array[0..10] of TColor;
    lbl: array[0..17] of TLabel;
    LegShape: array[0..20] of TShape;
    LegLbl: array[0..29] of TLabel;
    btnA,btnB,btnG,btnX,btnSchema: TJvTransparentButton;
    bmpS: TBitmap;
    RGGamSort: TRadioGroup;   // RGGam,
    PanelMin,PanelTVRad,PanelGamma,PanelRadNuk,PanelNukDis,PanelTVRadBtn: TPanel;
    GridMin,GridReihe,GridRadDat: TIconGrid;
    procedure AppException(Sender: TObject; E: Exception);
    procedure DisplayHint(Sender: TObject);
    procedure GetAppIcon;
  end;

var
  frmMain: TfrmMain;

implementation

  uses UnitDM, UnitNukFunc, UnitPSE, UnitChart, UnitNuk, UnitSpec, UnitAboutBox;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
var i: Integer;
begin
  Application.OnException := AppException;
  //Application.ShowHint := True;
  Application.OnHint := DisplayHint;
  Application.HintPause := 100;
  KeyPreview := True;
  LongDatum := LongDateFormat;
  SysUtils.ThousandSeparator := #0;
  NukF[0] := clSilver;
  NukF[1] := 16678784;  // �-
  NukF[2] := 32767;     // �+
  NukF[3] := 43582;     // p      (ly)
  NukF[4] := 55259;     // alpha        // 65535
  NukF[5] := 1048064;   // ec     (n)
  NukF[6] := 9240831;   // ly     (sf)
  NukF[7] := 15871;     // sf     (p)
  NukF[8] := 16110739;  // ce     (ec)
  NukF[9] := 6393588;   // n      (ce)
  NukF[10] := clBlack;
  for i := 0 to 10 do RadF[i] := NukF[i];
  btnA := TJvTransparentButton.Create(PanelGamma);
  btnB := TJvTransparentButton.Create(PanelGamma);
  btnG := TJvTransparentButton.Create(PanelGamma);
  btnX := TJvTransparentButton.Create(PanelGamma);
  btnSchema := TJvTransparentButton.Create(PanelGamma);
  btnA.FrameStyle := fsRegular;
  btnB.FrameStyle := fsRegular;
  btnG.FrameStyle := fsRegular;
  btnX.FrameStyle := fsRegular;
  btnSchema.FrameStyle := fsRegular;
  //if Screen.Width >= 1152 then MenuExpl.Checked := True;
  if Screen.Height > 800 then
  begin
    i := (Screen.Height - 768) div 125;
    nukw := 5 + i;
  end else nukw := 5;
  GridNuk.DefaultColWidth := nukw;
  GridNuk.DefaultRowHeight := nukw;
  SBNuk.HorzScrollBar.Increment := nukw;
  SBNuk.VertScrollBar.Increment := nukw;
  NukKarteKonf;
  PSEKonf;
  SpecKonf;
  PC.ActivePageIndex := 1;
  RGlast := 0;
  IntRGB := 0;
  AktPosCol := 0;
  AktPosRow := 118;
  ZuF := clYellow;
  PSEF[16] := RGB(208,162,53);//3515088;
  PSEF[17] := RGB(150,28,0);  //7318;
  Spalte := 'ElemGruppe';
  bDiag := False;
  bAbund := False;
  bZoom := False;
  TvAktiv := False;
  TVNukIdx := 0;
  TVRadIdx := 0;
  Zx := 0;
  nochmal := 0;
  XAkt := 0; SpecX := 0; SpecY := 0;
  AktZ := 1; AktN := 0; SBRadH := 0; SBRadV := 0;
  bRad := 1; anzrad := 0;
  PXalt := 1; PYalt := 1; PXneu := 1; PYneu := 1;
  RGSuchIdxAlt := 'Z';
  CBHalf.ItemIndex := 0;
  btnRad1.Hint := 'Wahrscheinliche Zerfallsreihe(n),' + #13#10 +
    'vom markierten Nuklid ausgehend';
  btnRad2.Hint := 'Alle m�glichen Zerfallsreihen,' + #13#10 +
    'vom markierten Nuklid ausgehend';
  ChLB.Header[0] := True;
  bmpS := TBitmap.Create;
  bmpS.Height := PBSchema.ClientHeight;
  bmpS.Width := PBSchema.ClientWidth;
  bmpt := 0;
  bmpl := 0;
  RadTyp := 0;
  DQL := 0;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  i: Integer;
  temp: String;
  //List: TStrings;
begin
  DatumTimer(Sender);
  if DM.Datengeladen then
  begin
    AboutBox.geladen := True;
    if AboutBox.Visible then AboutBox.Close;
    {if DM.ETName.Locate('Nr',159,[]) then
    begin
      PC.ActivePageIndex := StrToInt(DM.ETName.FieldByName('Land').AsString);
      if PC.ActivePageIndex = 1 Then
      begin
        MenuNukKarte.Enabled := False;
        MenuPSE.Enabled := True;
      end
      else
      begin
        MenuNukKarte.Enabled := True;
        MenuPSE.Enabled := False;
      end;
    end;}
    Self.Caption := 'Nukliddaten: ' + PC.Pages[PC.ActivePageIndex].Caption;
    Application.Title := Caption;
    with DM.ETName do
    begin
      i := 120;
      if Locate('Nr',i,[]) then
        for i := 1 to 16 do
        begin
          temp := FieldByName('F'+IntToStr(i)).AsString;
          System.Delete(temp,1,Pos(')',temp));
          PSEF[i-1] := StrToInt(GetKlammer(temp));
        end;
      SetLabels;
      GruppenHint;
      PSEDaten(DM.IZAvonZ(1));
      GridZusatz.ColorCell[0,1] := clSkyBlue;
    end;
    with DM.ETChem do
    begin
      for i := 1 to 7 do GridElektron.Cells[i,0] := IntToStr(i);
      for i := 33 to 51 do
        GridElektron.Cells[i-24,0] := Fields[i].DisplayName;
    end;
  end;
  if Screen.Width < 1024 then
    PanelLeg.Left := Self.ClientWidth - PanelLeg.Width-29
  else PanelLeg.Left := Self.ClientWidth - PanelLeg.Width-10;
  PanelLeg.Top := Self.ClientHeight - StatusBar.Height - PanelLeg.Height-29;
  SBNuk.VertScrollBar.Range := 127 * nukw; //635;
  SBNuk.HorzScrollBar.Range := 180 * nukw; //900;
  PMenuLeg.Items[1].Visible := False;
  btnRad1.Left := (PanelBtnRad.ClientWidth - (btnRad1.Width * 3)) div 2;
  btnRad2.Left := btnRad1.Left + btnRad1.Width;
  btnRad3.Left := btnRad2.Left + btnRad2.Width;
  Application.UpdateFormatSettings := False;
  Application.UpdateMetricSettings := False;
  //PanelNukTV.Visible := MenuExpl.Checked;
  if PanelNukTV.Visible then TVNuk.SetFocus;
  //temp := '';
  //List := TStringList.Create;
  //List.LoadFromFile('C:\Eigene Projekte\Nukliddaten\Vielteilchensysteme\heuristisch.txt');
  //List.LoadFromFile('C:\Eigene Projekte\Nukliddaten\Theorie\Theorie01.txt');
  //ZWViewer.LoadFromString(MakeHTML('Test-Titel',List),'');
  ZWViewer.LoadFromString(AboutBox.ZW('Theo'),'');
  //ZWViewer.LoadImageFile('C:\Eigene Projekte\Nukliddaten\Bilder\Sombrero.jpg');
  //List.Free;
end;

procedure TfrmMain.DatumTimer(Sender: TObject);
begin
  StatusBar.Panels[2].Text := FormatDateTime(LongDatum, Date);
  StatusBar.Panels[2].Width := StatusBar.Canvas.TextWidth(StatusBar.Panels[2].Text)+20;
  StatusBar.Panels[0].Width := StatusBar.ClientWidth - StatusBar.Panels[1].Width -
    StatusBar.Panels[2].Width;
end;

procedure TfrmMain.DisplayHint(Sender: TObject);
var temp: String;
begin
  temp := GetLongHint(Application.Hint);
  temp := StringReplace(temp,#13#10,#32,[rfReplaceAll]);
  StatusBar.Panels[0].Text := temp;
end;

procedure TfrmMain.TVNukChange(Sender: TObject; Node: TTreeNode);
var
  iza: Integer;
  temp: String;
  Wahr: Boolean;
begin
  if not TvAktiv then
  begin
    Wahr := False;
    if Node.Level = 0 then
    begin
      temp := DM.GetNukBez(DM.IZAvonZ(IntAusStr(GetKlammer(Node.Text))),True);
      Nukliddaten(temp, PanelGridDat.Visible);
    end else Nukliddaten(Node.Text, PanelGridDat.Visible);
    if TVNuk.Selected <> nil then
      if TVNuk.Selected.Level = 0 then
      begin
        temp := GetKlammer(TVNuk.Selected.Text);
        temp := Copy(temp,1,Pos(#32,temp)-1);
        Wahr := (AktZ <> StrToInt(temp));
        AktZ := StrToInt(temp);
        iza := DM.IZAvonZ(AktZ);
        AktN := DM.GetN(iza);
        temp := GetKlammer(TVNuk.Selected.Text) + #32 + IntToStr(DM.GetA(iza));
        PMExplGoNuk.Caption := 'Zeige ''' + temp + ''' in Nuklidkarte';
      end
      else
      begin
        temp := TVNuk.Selected.Text;
        AktN := DM.GetN(DM.GetiZA(temp));
        temp := Copy(temp,1,Pos(#32,temp)-1);
        Wahr := (AktZ <> StrToInt(temp));
        AktZ := StrToInt(temp);
        PMExplGoNuk.Caption := 'Zeige ''' + TVNuk.Selected.Text + ''' in Nuklidkarte';
        TVNukIdx := Node.AbsoluteIndex;
      end;
    if ((Wahr and MenuZReihe.Checked) or MenuNSpalte.Checked) and
       (GridNuk.DefaultColWidth = nukw) then
      GridNuk.Repaint;
  end;
end;

procedure TfrmMain.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  temp: String;
  i,iza: Integer;
begin
  with (Sender as TIconGrid) do
  begin
    if Name = 'GridSpecPSE' then CanSelect := True else CanSelect := False;
    if DefaultDrawing and (Name <> 'GridSpecPSE') then ClearSelection;
    if (Name <> 'GridDaten') and (Cells[ACol,ARow] <> '') then
    begin
      if (Name = 'GridPSE') and (ARow > 0) then
      begin
        temp := HintCell[ACol,ARow];
        iza := DM.IZAvonZ(IntAusStr(temp));
        PSEDaten(iza);
        RelMass;
        if iza > 0 then
        begin
          PXneu := ACol;
          PYneu := ARow;
          GridPSE.Repaint;
        end;
      end
      else if (Name = 'GridReihe') and (ARow = 0) and (bRad = 1) and
        (Pos('Zerfallsreihe',Cells[ACol,ARow]) > 0) then
      begin
        btnRad1.Enabled := False;
        btnRad2.Enabled := False;
        btnRad3.Enabled := False;
        temp := '';
        for i := 1 to GridReihe.RowCount - 1 do
          temp := temp + GridReihe.Cells[ACol,i] + #13#10;
        ZerfallsreiheDaten(temp,ACol+1);
      end
      else if (Name = 'GridReihe') and (bRad > 1) then
        PosGridReihe(SBRadH,SBRadV)
      else if (Name = 'GridSpecPSE') and (HintCell[ACol,ARow] <> '') then
      begin
        temp := HintCell[ACol,ARow];
        i := StrToInt(Copy(temp,1,Pos(#32,temp)-1));
        Delete(temp,1,Pos('=',temp));
        lblSpecElem.Caption := Trim(temp);
        UpdateImage(i,Trim(temp),True);
      end;
    end
    else
      if (Name = 'GridMin') and (GridMin.ColorCell[ACol,ARow] <> GridMin.Color) then
        PosNuk(ACol-4,ARow-4);
    if (MenuZReihe.Checked or MenuNSpalte.Checked) and (Name = 'GridNuk') and
      (GridNuk.DefaultColWidth = nukw) and (HintCell[ACol,ARow] <> '') then
    begin
      temp := HintCell[ACol,ARow];
      i := DM.GetiZA(temp);
      AktZ := DM.GetZ(i);
      AktN := DM.GetN(i);
      GridNuk.Repaint;
      TVSuchNuk(TVNuk,temp,btnTVNukSuch.Name);
    end;
    if Name = 'GridSpecPSE' then
    begin
      SpecX := ACol;
      SpecY := ARow;
    end;
    if (Name = 'GridNuk') and PanelNukTV.Visible then TVNuk.SetFocus;
  end;
end;

procedure TfrmMain.GridShowHintCell(Sender: TObject; col, row: Integer;
  var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
var
  i: Integer;
  temp: String;
begin
  if ((Sender as TIconGrid).Name = 'GridReihe') and (Pos('Icon',HintStr) = 0) then
  begin
    if Pos('Klick',HintStr) > 0 then CanShow := True else CanShow := False;
    temp := '';
    if (col > -1) and (row > -1) then
    begin
      if (bRad = 1) and (row > 0) and (row mod 2 > 0) and not btnBack.Visible then
        temp := GridReihe.Cells[col,row]
      else if btnBack.Visible and (col = 0) and (row > 0) then
        temp := GridReihe.Cells[col,row]
      else if (bRad > 1) and (GridReihe.Cells[col,row] <> '') then
        temp := GridReihe.Cells[col,row];
    end
    else StatusBar.Panels[0].Text := '';
    if (bRad > 1) and (temp <> '') then
    begin
      if Pos('[',temp) > 0 then temp := Copy(temp,1,Pos('[',temp)-1);
      i := DM.IZAvonZ(StrToInt(Copy(temp,1,Pos(#32,temp)-1)));
      if Pos('[]',GridReihe.Cells[col,row]) = 0 then
        StatusBar.Panels[0].Text := temp + ' = ' + DM.NukName(DM.GetSymb(i));
      if (row > 0) and (Pos('[]',GridReihe.Cells[col,row]) = 0) then
        RadDaten(temp);
    end
    else if (Sender as TStringAlignGrid).ColorCell[col,row] = GridReihe.Color then
      StatusBar.Panels[0].Text := 'Taste F1 dr�cken f�r Hilfe'
    else StatusBar.Panels[0].Text := '';
  end
  else if ((Sender as TIconGrid).Name <> 'GridReihe') and
          ((Sender as TIconGrid).Name <> 'GridSpecPSE') then
  begin
    CanShow := True;
    StatusBar.Panels[0].Text := HintStr;
    if (Sender as TStringAlignGrid).ColorCell[col,row] = GridNuk.Color then
      StatusBar.Panels[0].Text := 'Taste F1 dr�cken f�r Hilfe';
  end
  else
  begin
    if Pos('Icon',HintStr) = 0 then CanShow := True else CanShow := False;
    StatusBar.Panels[0].Text := '';
  end;
  if (HintStr <> '') and (((Sender as TIconGrid).Name = 'GridNuk') or
    (((Sender as TIconGrid).Name = 'GridMin'))) then
  begin
    i := StrToInt(Copy(HintStr,1,Pos(#32,HintStr)-1));
    if i = 0 then StatusBar.Panels[0].Text := HintStr + ' = freies Neutron'
    else if DM.ETName.Locate('Nr',i,[]) then
      StatusBar.Panels[0].Text := HintStr + ' = ' +
        DM.ETName.FieldByName('F2').AsString;
    Nukliddaten(HintStr, PanelGridDat.Visible);
  end;
  if (HintStr <> '') and ((Sender as TIconGrid).Name = 'GridRad') then
  begin
    i := StrToInt(Copy(HintStr,1,Pos(#32,HintStr)-1));
    if DM.ETName.Locate('Nr',i,[]) then
      StatusBar.Panels[0].Text := HintStr + ' = ' +
        DM.ETName.FieldByName('F2').AsString;
  end;
  MinPosX := SBNuk.HorzScrollBar.Position;
  MinPosY := SBNuk.VertScrollBar.Position;
end;

procedure TfrmMain.ShowPage(Sender: TObject);
var i,iza: Integer;
begin
  if Sender is TMenuItem then
    i := (Sender as TMenuItem).Tag
  else i := (Sender as TJvTransparentButton).Tag;
  case i of
    1: begin
         PC.ActivePageIndex := 0;// TTabSheet(PagePSE);
         SetMenueItem(i);
         btnDiagram.Enabled := bDiag;
         if btnNukZoom.Caption = 'verkleinerte Nuklidkarte' then
         begin
           MinPosX := SBNuk.HorzScrollBar.Position;
           MinPosY := SBNuk.VertScrollBar.Position;
         end;
         GridPSE.SetFocus;
       end;
    2: begin
         PC.ActivePageIndex := 1;// TTabSheet(PageKarte);
         SetMenueItem(i);
         if btnNukZoom.Caption = 'verkleinerte Nuklidkarte' then
         begin
           SBNuk.HorzScrollBar.Position := MinPosX;
           SBNuk.VertScrollBar.Position := MinPosY;
           pmnuMinGrid.Visible := False;
         end else pmnuMinGrid.Visible := True;
         PosPanelLeg;
         if PanelNukTV.Visible then TVNuk.SetFocus;
       end;
    3: if ShowPSEDiagramm(RG.ItemIndex) then
       begin
         if Chart1.Zoomed then btnZoomClick(Sender);
         PC.ActivePageIndex := 2;// TTabSheet(PageDiagram);
         SetChartButtons;
       end;
    4: if NukChart(CBHalf.ItemIndex) then
       begin
         if Chart1.Zoomed then btnZoomClick(Sender);
         PC.ActivePageIndex := 2;// TTabSheet(PageDiagram);
         SetChartButtons;
         if btnNukZoom.Caption = 'verkleinerte Nuklidkarte' then
         begin
           MinPosX := SBNuk.HorzScrollBar.Position;
           MinPosY := SBNuk.VertScrollBar.Position;
         end;
       end;
    5: begin
         PC.ActivePageIndex := 3;// TTabSheet(PageZerfall);
         pmnuMinGrid.Visible := False;
         SetMenueItem(i);
         TVRad.SetFocus;
       end;
    6: begin
         PC.ActivePageIndex := 4;// TTabSheet(PageSuch);
         SetMenueItem(i);
       end;
    7: begin
         PC.ActivePageIndex := 5;// TTabSheet(PageSpec);
         SetMenueItem(i);
       end;
    8: begin
         PC.ActivePageIndex := 6;// TTabSheet(PageZW);
         SetMenueItem(i);
         ZWViewer.SetFocus;
       end;
    9: begin
         Screen.Cursor := crHourGlass;
         iza := DM.GetiZA(TVRad.Selected.Text);
         MaleSchema(iza,RadTyp,DQL);
         PC.ActivePageIndex := 7;// TTabSheet(PageSchema);
         Screen.Cursor := crDefault;
       end;
  end;
  Caption := 'Nukliddaten: ' + PC.Pages[PC.ActivePageIndex].Caption;
  Application.Title := Caption;
  StatusBar.Panels[0].Text := '';
end;

procedure TfrmMain.GridPSEDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  i,i1,th,tw,h,w,z: Integer;
  temp,temp1: String;
  Icon: TIcon;
begin
  h := Rect.Bottom - Rect.Top;
  w := Rect.Right - Rect.Left;
  with GridPSE.Canvas do
  begin
    if (ACol = 3) and ((ARow >= 6) and (ARow <= 8)) then
    begin
      if ARow = 8 then
      begin
        Icon := TIcon.Create;
        DM.ILFlag.GetIcon(11, Icon);
        Draw(Rect.Left+8,Rect.Top+1, Icon);
        Icon.Free;
      end
      else
      begin
        if ARow = 6 then temp := '57-71' else temp := '89-103';
        Font.Color := clNavy;
        Font.Style := [fsBold];
        Font.Size := 7;
        if RG.ItemIndex = 0 then
        begin
          if ARow = 6 then
            Brush.Color := PSEF[16] else Brush.Color := PSEF[17]
        end else Brush.Color := clGray;
        Rect.Left := Rect.Left +1;
        Rect.Bottom := Rect.Bottom - 1;
        FillRect(Rect);
        tw := TextWidth(temp);
        i := Rect.Left + ((w div 2) - (tw div 2));
        i1 := Rect.Top;
        TextOut(i, i1, temp);
        if ARow = 6 then temp := 'Lantha-' else temp := 'Acti-';
        Font.Color := clInfoBk;
        Font.Style := [];
        tw := TextWidth(temp);
        i := Rect.Left + ((w div 2) - (tw div 2));
        i1 := Rect.Top + 12;
        TextOut(i, i1, temp);
        tw := TextWidth('noide');
        i := Rect.Left + ((w div 2) - (tw div 2));
        i1 := Rect.Top + 23;
        TextOut(i, i1, 'noide');
      end;
    end
    else
    begin
      if GridPSE.Cells[ACol,ARow] <> '' then
      begin
        if (ACol > 0) and (ARow > 0) then
        begin
          temp := GridPSE.Cells[ACol,ARow];
          temp1 := Trim(Copy(temp,1,Pos(#13,temp)-1));
          z := StrToInt(temp1);
          Delete(temp,1,Pos(#10,temp));
          Font.Style := [fsBold];
          Font.Size := 10;
          Brush.Color := PSENukFarbe(z);
          Rect.Left := Rect.Left +1;
          Rect.Bottom := Rect.Bottom - 1;
          FillRect(Rect);
          if (RG.ItemIndex = 29) or (RG.ItemIndex = 30) then Dreieck(Rect,z);
          if DM.Rad(z) or (RG.ItemIndex = 31) then
            GetLand(Rect,z,temp)
          else
          begin
            case RG.ItemIndex of
              0,3..5,7..9,11..30: if Brush.Color = clBtnFace then
                             Font.Color := clNavy
                           else Font.Color := KontrastFarbe(Brush.Color,2);
            else Font.Color := clNavy;
            end;
            tw := TextWidth(temp1);
            i := Rect.Left + ((w div 2) - (tw div 2));
            TextOut(i, Rect.Top + 2, temp1);
            case RG.ItemIndex of
              0,3..5,7..9,11..30: if Brush.Color = clBtnFace then
                             Font.Color := clBlack
                           else Font.Color := KontrastFarbe(Brush.Color,1);
            else Font.Color := clBlack;
            end;
            Font.Style := [fsBold];
            Font.Size := 12;
            th := TextHeight(temp);
            tw := TextWidth(temp);
            i := Rect.Left + ((w div 2) - (tw div 2));
            i1 := Rect.Top + (h - th - 2);
            TextOut(i, i1, temp);
          end;
        end;
      end
      else if (ACol = 0) and (ARow > 0) and (ARow < 8) then
        GruppenNr(Rect,h,w,0,IntToStr(ARow))
      else if (ACol = 0) and (ARow > 8) and (ARow < 11) then
        GruppenNr(Rect,h,w,0,IntToStr(ARow - 3))
      else if (ACol = 1) and (ARow = 0) then GruppenNr(Rect,h,w,1,'I')
      else if (ACol = 2) and (ARow = 1) then GruppenNr(Rect,h,w,1,'II')
      else if (ACol = 3) and (ARow = 3) then GruppenNr(Rect,h,w,1,'IIIb')
      else if (ACol = 4) and (ARow = 3) then GruppenNr(Rect,h,w,1,'IVb')
      else if (ACol = 5) and (ARow = 3) then GruppenNr(Rect,h,w,1,'Vb')
      else if (ACol = 6) and (ARow = 3) then GruppenNr(Rect,h,w,1,'VIb')
      else if (ACol = 7) and (ARow = 3) then GruppenNr(Rect,h,w,1,'VIIb')
      else if (ACol = 8) and (ARow = 3) then GruppenNr(Rect,h,w,4,'VIIIb')
      else if (ACol = 9) and (ARow = 3) then GruppenNr(Rect,h,w,1,'VIIIb')
      else if (ACol = 11) and (ARow = 3) then GruppenNr(Rect,h,w,1,'Ib')
      else if (ACol = 12) and (ARow = 3) then GruppenNr(Rect,h,w,1,'IIb')
      else if (ACol = 13) and (ARow = 1) then GruppenNr(Rect,h,w,1,'III')
      else if (ACol = 14) and (ARow = 1) then GruppenNr(Rect,h,w,1,'IV')
      else if (ACol = 15) and (ARow = 1) then GruppenNr(Rect,h,w,1,'V')
      else if (ACol = 16) and (ARow = 1) then GruppenNr(Rect,h,w,1,'VI')
      else if (ACol = 17) and (ARow = 1) then GruppenNr(Rect,h,w,1,'VII')
      else if (ACol = 18) and (ARow = 0) then GruppenNr(Rect,h,w,1,'VIII')
      else if (ACol = 1) and (ARow = 9) then GruppenNr(Rect,h,w,2,'Lanthanoide')
      else if (ACol = 1) and (ARow = 10) then GruppenNr(Rect,h,w,2,'Actinoide')
      else if (ACol = 4) and (ARow = 0) then
        GruppenNr(Rect,h,w,3,'  Periodensystem der Elemente');
    end;
    if (ARow > 0) and (ACol > 0) then
    begin
      if (ACol = PXalt) and (ARow = PYalt) then
      begin
        if (PXneu = PXalt) and (PYalt = PYneu+1) then
        begin
          Pen.Color := clBlack;
          Pen.Style := psDot;
          MoveTo(Rect.Left-1,Rect.Top-1);
          LineTo(Rect.Right,Rect.Top-1);
          Pen.Color := GridPSE.Color;
          Pen.Style := psSolid;
        end
        else
        begin
          Pen.Color := GridPSE.Color;
          Pen.Style := psSolid;
          MoveTo(Rect.Left-1,Rect.Top-1);
          LineTo(Rect.Right,Rect.Top-1);
        end;
        MoveTo(Rect.Left-1,Rect.Top);
        LineTo(Rect.Left-1,Rect.Bottom);
        MoveTo(Rect.Left-1,Rect.Bottom);
        LineTo(Rect.Right,Rect.Bottom);
        MoveTo(Rect.Right,Rect.Top);
        LineTo(Rect.Right,Rect.Bottom);
        PXalt := PXneu; PYalt := PYneu;
      end;
      if (ACol = PXneu) and (ARow = PYneu) then
      begin
        Pen.Color := clBlack;
        Pen.Style := psDot;
        MoveTo(Rect.Left-1,Rect.Top);
        LineTo(Rect.Left-1,Rect.Bottom);
        MoveTo(Rect.Left-1,Rect.Top-1);
        LineTo(Rect.Right,Rect.Top-1);
        MoveTo(Rect.Left-1,Rect.Bottom);
        LineTo(Rect.Right,Rect.Bottom);
        MoveTo(Rect.Right,Rect.Top);
        LineTo(Rect.Right,Rect.Bottom);
      end
      else if (ACol = PXneu+1) and (ARow = PYneu) then
      begin
        Pen.Color := clBlack;
        Pen.Style := psDot;
        MoveTo(Rect.Left-1,Rect.Top);
        LineTo(Rect.Left-1,Rect.Bottom);
      end;
    end;
  end;
end;

procedure TfrmMain.RGClick(Sender: TObject);
var i: Integer;
begin
  if RGlast <> 0 then exit;
  Inc(RGlast);
  with GridPSEDaten do
  begin
    for i := 0 to RowCount - 1 do
    begin
      if i > 0 then ColorCell[1,i] := clInfoBk;
      if i < 3 then GridZusatz.ColorCell[i,1] := clInfoBk;
    end;
    case RG.ItemIndex of
      0: GridZusatz.ColorCell[0,1] := clSkyBlue;
      3..5: ColorCell[1,RG.ItemIndex+1] := clSkyBlue;
      6,31: begin
              ColorCell[1,RG.ItemIndex+1] := clSkyBlue;
              ColorCell[1,RG.ItemIndex+2] := clSkyBlue;
            end;
      7..9: ColorCell[1,RG.ItemIndex+2] := clSkyBlue;
     11..25: ColorCell[1,RG.ItemIndex+1] := clSkyBlue;
     27,28: ColorCell[1,RG.ItemIndex] := clSkyBlue;
     29: GridZusatz.ColorCell[1,1] := clSkyBlue;
     30: GridZusatz.ColorCell[2,1] := clSkyBlue;
    end;
  end;
  case RG.ItemIndex of
    3,4: JvgBevel.VertLines.Count := 9;
    5: JvgBevel.VertLines.Count := 25;
  else JvgBevel.VertLines.Count := 9;
  end;
  case RG.ItemIndex of
    3..9,11..25,27,28,31: btnDiagram.Enabled := True;
  else btnDiagram.Enabled := False;
  end;
  bDiag := btnDiagram.Enabled;
  SetLabels;
  GridPSE.Repaint;
end;

procedure TfrmMain.GruppenHint;
var
  i: Integer;
  temp: String;
begin
  i := 120;
  with DM.ETName do
    if Locate('Nr',i,[]) then
      for i := 0 to 15 do
      begin
        temp := FieldByName('F' + IntToStr(i+1)).AsString;
        System.Delete(temp,1,Pos(')',temp));
        case i of
          0: GridPSE.HintCell[1,0] := Copy(temp,1,Pos('(',temp)-1);
          1: GridPSE.HintCell[2,1] := Copy(temp,1,Pos('(',temp)-1);
          2: GridPSE.HintCell[13,1] := Copy(temp,1,Pos('(',temp)-1);
          3: GridPSE.HintCell[14,1] := Copy(temp,1,Pos('(',temp)-1);
          4: GridPSE.HintCell[15,1] := Copy(temp,1,Pos('(',temp)-1);
          5: GridPSE.HintCell[16,1] := Copy(temp,1,Pos('(',temp)-1);
          6: GridPSE.HintCell[17,1] := Copy(temp,1,Pos('(',temp)-1);
          7: GridPSE.HintCell[18,0] := Copy(temp,1,Pos('(',temp)-1);
          8: GridPSE.HintCell[11,3] := Copy(temp,1,Pos('(',temp)-1);
          9: GridPSE.HintCell[12,3] := Copy(temp,1,Pos('(',temp)-1);
         10: GridPSE.HintCell[3,3] := Copy(temp,1,Pos('(',temp)-1);
         11: GridPSE.HintCell[4,3] := Copy(temp,1,Pos('(',temp)-1);
         12: GridPSE.HintCell[5,3] := Copy(temp,1,Pos('(',temp)-1);
         13: GridPSE.HintCell[6,3] := Copy(temp,1,Pos('(',temp)-1);
         14: GridPSE.HintCell[7,3] := Copy(temp,1,Pos('(',temp)-1);
         15: begin
               GridPSE.HintCell[8,3] := Copy(temp,1,Pos('(',temp)-1);
               GridPSE.HintCell[9,3] := Copy(temp,1,Pos('(',temp)-1);
               GridPSE.HintCell[10,3] := Copy(temp,1,Pos('(',temp)-1);
             end;
        end;
      end;
end;

procedure TfrmMain.GridPSEShowHintCell(Sender: TObject; col, row: Integer;
  var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if IntAusStr(HintStr) = 0 then
    CanShow := True
  else CanShow := False;
  StatusBar.Panels[0].Text := HintStr;
end;

procedure TfrmMain.MenuDateiExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.GridPSEDatenDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  i,w,tw: Integer;
  temp: String;
begin
  with GridPSEDaten.Canvas do
  begin
    if (ACol = 1) and (ARow = 1) then
    begin
      w := Rect.Right - Rect.Left;
      temp := GridPSEDaten.Cells[ACol,ARow];
      Brush.Color := clInfoBk;
      FillRect(Rect);
      Font.Color := clNavy;
      Font.Style := [fsBold];
      Font.Size := 10;
      tw := TextWidth(temp);
      i := Rect.Left + ((w div 2) - (tw div 2));
      TextOut(i, Rect.Top-2, temp);
    end;
    if (ACol = 1) and (ARow > 2) and (ARow < 29) then
    begin
      if (Pos('E',GridPSEDaten.Cells[ACol,ARow]) > 0) then
      begin
        FillRect(Rect);
        Potenz(GridPSEDaten.Canvas,Font,Rect,GridPSEDaten.Cells[ACol,ARow]);
      end;
    end
    else if (Pos('^',GridPSEDaten.Cells[ACol,ARow]) > 0) then
    begin
      FillRect(Rect);
      Hoch(GridPSEDaten.Canvas,Font,Rect,GridPSEDaten.Cells[ACol,ARow]);
    end;
  end;
end;

procedure TfrmMain.StopTimer(Sender: TObject);
begin
  if RGlast > 0 then Inc(RGlast);
  if RGlast >= 2 then RGlast := 0;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
//var i: Integer;
begin
  {if DM.ETName.Locate('Nr',159,[]) then
    if DM.ETName.FieldByName('Land').AsString <> IntToStr(ActPage) then
    begin
      DM.ETName.Edit;
      DM.ETName.FieldByName('Land').AsString := IntToStr(ActPage);
      DM.ETName.Post;
    end;}
  {for i := 0 to 17 do
    if i < 11 then
    begin
      LegShape[i].Free;
      LegLbl[i].Free;
      lbl[i].Free;
    end else lbl[i].Free;}
  //List.SaveToFile(DM.DataPfad + '\List.txt');
  //List.Free;
  //NukList.Free;
  //BmpSpec.Free;
  bmpS.FreeImage;
  bmpS.Free;
end;

procedure TfrmMain.btnPSEClick(Sender: TObject);
begin
  if not MenuPSE.Enabled then
    PC.ActivePage := TTabSheet(PagePSE)
  else
  begin
    PC.ActivePage := TTabSheet(PageKarte);
    if btnNukZoom.Caption = 'verkleinerte Nuklidkarte' then
    begin
     SBNuk.HorzScrollBar.Position := MinPosX;
     SBNuk.VertScrollBar.Position := MinPosY;
    end;
  end;
  btnVor.Enabled := False;
  btnZur.Enabled := False;
end;

procedure TfrmMain.FormResize(Sender: TObject);
var i: Integer;
begin
  btnPSE.Left := Chart1.Width - btnPSE.Width - 30;
  btnPSE.Top := Chart1.Top + Chart1.Height - btnPSE.Height - 10;
  btnMarks.Top := btnPSE.Top;
  btnMarks.Left := Chart1.Left + 30;
  btnZoom.Top := btnMarks.Top;
  btnZoom.Left := btnMarks.Left + btnMarks.Width + 10;
  btnAbund.Top := btnMarks.Top;
  btnAbund.Left := btnPSE.Left - btnAbund.Width - 10;
  btnRad1.Left := (PanelBtnRad.ClientWidth - (btnRad1.Width * 3)) div 2;
  btnRad2.Left := btnRad1.Left + btnRad1.Width;
  btnRad3.Left := btnRad2.Left + btnRad2.Width;
  if PC.ActivePageIndex = 1 then PosPanelLeg;
  PosPanels;
  PanelProton.Top := 320;
  PanelProton.Left := 20;
  i := (PanelSuchEdit.ClientWidth - CBShowGrid.Width) div 2;
  CBShowGrid.Left := i;
  CBShowGrid.Top := PanelSuchEdit.ClientHeight - CBShowGrid.Height - (i div 2);
  PanelSuchPos.Top := (PanelSuchEdit.ClientHeight - PanelSuchPos.Height) div 2;
  GridRbtn.Left := (PanelSchema.ClientWidth - GridRbtn.Width) div 2;
end;

procedure TfrmMain.AppException(Sender: TObject; E: Exception);
begin
  if Pos('TEasy',E.Message) > 0 then
  begin
    ShowMessage('Eine Datenbank konnte nicht ge�ffnet werden!');
    Application.Terminate;
  end
  else if Pos('Listenindex',E.Message) > 0 then
  begin
    Application.ShowException(E);
    if Screen.Cursor <> crDefault then Screen.Cursor := crDefault;
  end else Application.ShowException(E);
end;

procedure TfrmMain.btnMarksClick(Sender: TObject);
var Wahr: Boolean;
begin
  Wahr := False;
  if Series1.Active then Series1.Marks.Visible := not Series1.Marks.Visible;
  if Series2.Active then Series2.Marks.Visible := not Series2.Marks.Visible;
  if Series3.Active then Series3.Marks.Visible := not Series3.Marks.Visible;
  if Series1.Active then Wahr := Series1.Marks.Visible;
  if Series2.Active then Wahr := Series2.Marks.Visible;
  if Series3.Active then Wahr := Series3.Marks.Visible;
  if Wahr then
    btnMarks.Caption := 'Werte nicht anzeigen'
  else btnMarks.Caption := 'Werte anzeigen';
end;

procedure TfrmMain.Series1GetMarkText(Sender: TChartSeries;
  ValueIndex: Integer; var MarkText: String);
begin
  if (Pos('.',MarkText) = 0) and (StrToFloat(MarkText) = 0) then
    MarkText := ''
  else if RG.ItemIndex <> 31 then
    MarkText := MarkText + #13#10 + IntToStr(ValueIndex+1) + #32 +
    DM.GetSymb(DM.IZAvonZ(ValueIndex+1));
end;

procedure TfrmMain.btnZoomClick(Sender: TObject);
begin
  bZoom := not bZoom;
  if bZoom then btnZoom.Caption := 'Komplett' else btnZoom.Caption := 'Zoom';
  if not MenuPSE.Enabled then
    btnDiagram.Click
  else btnNukDiag.Click;
end;

procedure TfrmMain.Chart1GetAxisLabel(Sender: TChartAxis;
  Series: TChartSeries; ValueIndex: Integer; var LabelText: String);
var
  i: Integer;
  temp: String;
begin
  if Sender = Chart1.BottomAxis then
  begin
    if not MenuPSE.Enabled and (RG.ItemIndex = 31) then
    begin
      i := Trunc(StrToFloat(LabelText));
      if DM.ETName.Locate('Nr',i,[]) then
      begin
        temp := DM.ETName.FieldByName('Land').AsString;
        if Pos(#32,temp) > 0 then
          LabelText := Copy(temp,1,Pos(#32,temp))
        else LabelText := temp;
      end;
    end;
    {if not MenuNukKarte.Enabled and (CBHalf.ItemIndex > 1) then
    begin
      temp := LabelText;
      i := 0;
      while Pos(#32,temp) > 0 do begin Inc(i); Delete(temp,1,Pos(#32,temp)); end;
      temp := Trim(LabelText);
      if (i = 2) and (temp <> '') and (Pos(',',temp) = 0) then
      begin
        List.Add(temp);
        Delete(temp,1,Pos(#32,temp));
        Delete(temp,1,Pos(#32,temp));
        i := StrToInt(temp);
        if i mod 5 = 0 then LabelText := temp else LabelText := ' ';
        //LabelText := temp;
      end;
    end;}
  end;
end;

procedure TfrmMain.btnAbundClick(Sender: TObject);
begin
  bAbund := not bAbund;
  if not MenuPSE.Enabled then
  begin
    if bAbund then
      btnAbund.Caption := 'Massenanteil Erdkruste'
    else btnAbund.Caption := 'Nat�rliche H�ufigkeit';
    ShowPSEDiagramm(6);
  end
  else
  begin
    if not bAbund then
      btnAbund.Caption := 'Alle Isotope'
    else btnAbund.Caption := 'Nur nat�rliche Nuklide';
    NukChart(CBHalf.ItemIndex);
  end;
end;

procedure TfrmMain.MnuHelpClick(Sender: TObject);
begin
  case (Sender as TMenuItem).Tag of
    6: begin
         if (PC.ActivePage = PagePSE) and AboutBox.HelpPSE then AboutBox.ShowModal;
         if (PC.ActivePage = PageKarte) and AboutBox.HelpKarte then AboutBox.ShowModal;
         if (PC.ActivePage = PageZerfall) and AboutBox.HelpRad then AboutBox.ShowModal;
         if (PC.ActivePage = PageSuch) and AboutBox.HelpSuch then AboutBox.ShowModal;
         if (PC.ActivePage = PageSchema) and AboutBox.HelpSchema then AboutBox.ShowModal;
       end;
    7: if AboutBox.Ref then AboutBox.ShowModal;
    8: if AboutBox.Upd then AboutBox.ShowModal;
    9: if AboutBox.AppAbout then AboutBox.ShowModal;
  end;
end;

procedure TfrmMain.GridNukDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  i,i1,i2,h,w,tw,th,y: Integer;
  temp,a,z,symb: String;
  bc: TColor;
  Rekt: TRect;
  Bmp: TBitmap;
begin
  with GridNuk.Canvas do
  begin
    Rekt := Rect;
    Rekt.Bottom := Rect.Bottom - 1;
    Rekt.Right := Rect.Right - 1;
    w := Rect.Right - Rect.Left;
    h := Rect.Bottom - Rect.Top;
    Pen.Color := clBlack;
    Pen.Width := 1;
    if MenuPfeil.Checked and (ACol = 30) and (ARow = 120) and
      (GridNuk.DefaultColWidth = nukw) then
    begin
      th := (TextHeight('I') div 2)+1;
      tw := TextWidth('Anzahl Neutronen');
      TextOut(Rect.Left,Rect.Top-TextHeight('I'),'Anzahl Neutronen');
      Pen.Style := psSolid;
      MoveTo(Rect.Right+tw+10,Rect.Top-th);
      LineTo(Rect.Right+tw+50,Rect.Top-th);
      MoveTo(Rect.Right+tw+50,Rect.Top-th);
      LineTo(Rect.Right+tw+45,Rect.Top-th-5);
      MoveTo(Rect.Right+tw+50,Rect.Top-th);
      LineTo(Rect.Right+tw+45,Rect.Top-th+5);
    end;
    if (GridNuk.DefaultColWidth = nukw) and not GridNuk.DefaultDrawing then
    begin
      Brush.Color := GridNuk.ColorCell[Acol,Arow];
      FillRect(Rect);
    end;
    if (GridNuk.DefaultColWidth > nukw) and (GridNuk.HintCell[ACol,ARow] <> '') then
    begin
      Bmp := TBitmap.Create;
      Bmp.Width := w;
      temp := GridNuk.HintCell[ACol,ARow];
      z := Trim(Copy(temp,1,Pos(#32,temp)));
      Delete(temp,1,Pos(#32,temp));
      a := IntToStr(IntAusStr(temp));
      symb := Trim(Copy(temp,1,Pos(#32,temp)));
      Brush.Color := GridNuk.ColorCell[Acol,Arow];
      bc := Brush.Color;
      Brush.Color := GridNuk.Color;
      Bmp.Canvas.Brush.Color := bc;
      Bmp.TransparentColor := bc;
      Bmp.Transparent := True;
      Bmp.TransparentMode := tmAuto;
      Font.Color := clGray;
      Font.Size := 8;
      Font.Style := [];
      if (Zx <> StrToInt(z)) and (z <> '0') then
      begin
        Zx := StrToInt(z);
        th := (h - TextHeight('I')) div 2;
        tw := TextWidth('Z = ' + z);
        TextOut(Rect.Left-tw-1,Rect.Top+th,'Z = ' + z);
      end;
      tw := (w - TextWidth('Z = ' + z)) div 2;
      TextOut(Rect.Left+tw,Rect.Bottom-1,'N = ' + IntToStr(Acol-1));
      Brush.Color := bc;
      Font.Style := [fsBold];
      if CBHalf.ItemIndex = 0 then
      begin
        FillRect(Rekt);
        tw := 0;
        for th := 0 to 10 do
          if NukF[th] = Brush.Color then
          begin
            tw := th;
            Break;
          end;
        i :=  DM.RTypFarbe(DM.MakeIZA(StrToInt(z),StrToInt(a),0),tw);
        if (i > 0) and (i <> tw) and (Brush.Color <> clBlack) then
        begin
          bc := Brush.Color;
          NukEck(GridNuk.Canvas,Rekt,0,NukF[i]);
          Brush.Color := bc;
        end;
        if Brush.Color <> clBlack then
          DM.RTypPlus(DM.MakeIZA(StrToInt(z),StrToInt(a),0),i,tw,Rekt,GridNuk.Canvas);
      end else FillRect(Rekt);
      Font.Color := KontrastFarbe(Brush.Color,2);
      Font.Size := 8;
      th := TextHeight('I');
      tw := (w - TextWidth(symb+#32+a)) div 2;
      Brush.Style := bsClear; // Pinselstil auf Transparent setzen
      TextOut(Rect.Left+tw,Rect.Top+3,symb+#32+a);
      Bmp.Height := Rect.Bottom-Rect.Top-th;
      y := 3+th;
      if CBHalf.ItemIndex > 0 then
      begin
        Font.Charset := ANSI_CHARSET;
        Font.Name := 'Arial';
        Font.Size := 7;
        case CBHalf.ItemIndex of
          1: a := DM.GetDaten(z,a,'Tsek',True,0);
          2: a := DM.GetDaten(z,a,'BE',False,0);
          3: a := DM.GetDaten(z,a,'MassExc',False,0);
          4: a := DM.GetDaten(z,a,'Sn',False,0);
          5: a := DM.GetDaten(z,a,'Sp',False,0);
          6: a := 'holl';
          //7: a := 'Z=' + z + ' N=' + IntToStr(StrToInt(a)-StrToInt(z));
        end;
        if a <> '' then
        begin
          if CBHalf.ItemIndex = 6 then
          begin
            if GridNuk.ColorCell[ACol,ARow] = NukF[2] then
              a := 'exp.' else a := 'theor.';
            tw := (w - TextWidth(a)) div 2;
            th := (h-y-TextHeight('I')) div 2;
          end
          else if CBHalf.ItemIndex > 6 then
          begin
            tw := (w - TextWidth('Z = ' + z)) div 2;
            th := ((h-y-TextHeight('I')) div 2) - TextHeight('I') + 3;
            TextOut(Rect.Left + tw,Rect.Top+y+th,'Z = ' + z);
            th := ((h-y-TextHeight('I')) div 2) + 3;
            a := 'N = ' + IntToStr(StrToInt(a)-StrToInt(z));
            tw := (w - TextWidth(a)) div 2;
          end
          else
          begin
            tw := (w - TextWidth(a)) div 2;
            th := (h-y-TextHeight('I')) div 2;
          end;
          if (CBHalf.ItemIndex = 1) and (Pos('us',a) > 0) then
          begin
            temp := Copy(a,1,Pos('us',a)-1);
            TextOut(Rect.Left + tw,Rect.Top+y+th,temp);
            Font.Charset := SYMBOL_CHARSET;
            Font.Name := 'Symbol';
            Font.Size := 7;
            Font.Style := [];
            TextOut(Rect.Left + tw + TextWidth(temp)-2,Rect.Top+y+th,chr(109));
            temp := temp + 'u';
            Font.Charset := ANSI_CHARSET;
            Font.Name := 'Arial';
            Font.Size := 7;
            TextOut(Rect.Left + tw + TextWidth(temp),Rect.Top+y+th,'s');
          end else TextOut(Rect.Left + tw,Rect.Top+y+th,a);
        end;
      end
      else
      begin
        if DM.ETNukl.FieldByName('Tsek').AsFloat = -99 then
          temp := 'stabil'
        else
          temp := DM.FindRTypS(DM.MakeIZA(StrToInt(z),StrToInt(a),0),
            DM.ETNukl.FieldByName('Max_RTyp').AsInteger);
        Font.Size := 7;
        Font.Style := [];
        try
          PicRTypBmp(temp,Font,Bmp);
          Draw(Rekt.Left,Rect.Top+th,Bmp);
        finally
          Bmp.Free;
        end;
      end;
    end;
    if MenuMagZahlen.Checked and (GridNuk.DefaultColWidth = nukw) then
    begin
      if (GridNuk.HintCell[ACol,ARow] <> '') then
      begin
        temp := GridNuk.HintCell[ACol,ARow];
        i := StrToInt(Trim(Copy(temp,1,Pos(#32,temp))));  // Z
        Delete(temp,1,Pos(#32,temp));
        i1 := DM.GetN(DM.MakeIZA(i,IntAusStr(temp),0));   // N
        Brush.Style := bsClear;
        Pen.Color := clBlue;
        Pen.Style := psSolid;//psDot;
        Pen.Width := 1;
        Font.Name := 'Arial';
        Font.Size := 7;
        Font.Style := [];
        case i1 of
          2,8,20,28,50,82,126:
            begin
              if GridNuk.HintCell[ACol,ARow-1] = '' then
              begin
                MoveTo(Rect.Left,Rect.Top);
                LineTo(Rect.Left,Rect.Top-12);
                MoveTo(Rect.Right-1,Rect.Top);
                LineTo(Rect.Right-1,Rect.Top-12);
                MoveTo(Rect.Left,Rect.Top-12);
                LineTo(Rect.Right,Rect.Top-12);
              end;
              MoveTo(Rect.Left,Rect.Top);
              LineTo(Rect.Left,Rect.Bottom);
              MoveTo(Rect.Right-1,Rect.Top);
              LineTo(Rect.Right-1,Rect.Bottom);
            end;
        end;
        case i of
          2,8,20,28,50,82,126:
            begin
              Pen.Width := 1;
              if GridNuk.HintCell[ACol-1,ARow] = '' then
              begin
                i2 := 12;
                MoveTo(Rect.Left-i2,Rect.Top);
                LineTo(Rect.Left-i2,Rect.Bottom);
                tw := TextWidth('Z='+IntToStr(i));
                if i > 8 then
                  TextOut(Rect.Left-i2-tw-1,Rect.Top-4,'Z='+IntToStr(i));
              end else i2 := 0;
              MoveTo(Rect.Left-i2,Rect.Top);
              LineTo(Rect.Right,Rect.Top);
              MoveTo(Rect.Left-i2,Rect.Bottom-1);
              LineTo(Rect.Right,Rect.Bottom-1);
            end;
        end;
      end;
      Pen.Color := clBlue;
      if ((ACol=3) and (ARow=120)) or ((ACol=9) and (ARow=119)) or
        ((ACol=21) and (ARow=113)) or ((ACol=29) and (ARow=109)) or
        ((ACol=51) and (ARow=93)) or ((ACol=83) and (ARow=74)) or
        ((ACol=127) and (ARow=42)) then
      begin
        MoveTo(Rect.Left,Rect.Bottom-1);
        LineTo(Rect.Right-1,Rect.Bottom-1);
        MoveTo(Rect.Left,Rect.Bottom);
        LineTo(Rect.Left,Rect.Bottom-12);
        MoveTo(Rect.Right-1,Rect.Bottom);
        LineTo(Rect.Right-1,Rect.Bottom-12);
      end;
      if ((ACol=11) and (ARow=117)) or ((ACol=23) and (ARow=111)) or
        ((ACol=40) and (ARow=99)) or ((ACol=53) and (ARow=91)) or
        ((ACol=90) and (ARow=69)) or ((ACol=136) and (ARow=37)) then
      begin
        MoveTo(Rect.Right-1,Rect.Top);
        LineTo(Rect.Right-15,Rect.Top);
        MoveTo(Rect.Right,Rect.Bottom-1);
        LineTo(Rect.Right-15,Rect.Bottom-1);
        MoveTo(Rect.Right-1,Rect.Top);
        LineTo(Rect.Right-1,Rect.Bottom);
      end;
      Font.Name := 'Arial';
      Font.Size := 7;
      Font.Style := [];
      if ((ACol=21) and (ARow=116)) or ((ACol=29) and (ARow=112)) or
        ((ACol=51) and (ARow=96)) or ((ACol=83) and (ARow=77)) or
        ((ACol=127) and (ARow=45)) or ((ACol=9) and (ARow=122)) or
        ((ACol=3) and (ARow=123)) then
      begin
        a := IntToStr(ACol-1);
        tw := (w -TextWidth('N='+a)) div 2;
        TextOut(Rect.Left-15-tw,Rect.Bottom-15,'N='+a);
      end;
      if ((ACol=16) and (ARow=118)) then
        TextOut(Rect.Left-TextWidth('Z=2')-3,Rect.Top-8,'Z=2');
      if ((ACol=28) and (ARow=112)) then
        TextOut(Rect.Left-TextWidth('Z=8')-3,Rect.Top-8,'Z=8');
    end
    else if (MenuZReihe.Checked or MenuNSpalte.Checked) and
      (GridNuk.ColorCell[ACol,ARow] <> GridNuk.Color) and
      (GridNuk.DefaultColWidth = nukw) then
    begin
      Brush.Style := bsClear;
      Font.Name := 'Arial';
      Font.Style := [];
      Font.Color := clGray;
      Pen.Color := clBlue;
      Pen.Style := psSolid;
      if MenuZReihe.Checked and (ARow = GridNuk.RowCount-AktZ-6) then
      begin
        MoveTo(Rect.Left,Rect.Top);
        LineTo(Rect.Right,Rect.Top);
        MoveTo(Rect.Left,Rect.Bottom-1);
        LineTo(Rect.Right,Rect.Bottom-1);
        if GridNuk.ColorCell[ACol-1,ARow] = GridNuk.Color then
        begin
          MoveTo(Rect.Left,Rect.Top);
          LineTo(Rect.Left,Rect.Bottom-1);
        end;
        if GridNuk.ColorCell[ACol+1,ARow] = GridNuk.Color then
        begin
          MoveTo(Rect.Right-1,Rect.Top);
          LineTo(Rect.Right-1,Rect.Bottom-1);
        end;
        if (GridNuk.ColorCell[ACol-1,ARow] = GridNuk.Color) and (AktZ > 10) then
        begin
          Pen.Color := clGray;
          MoveTo(Rect.Left-1,Rect.Top+2);
          LineTo(Rect.Left-8,Rect.Top+2);
        end;
      end;
      if MenuZReihe.Checked and (ARow = GridNuk.RowCount-AktZ-5) and
        (GridNuk.ColorCell[ACol-1,ARow] = GridNuk.Color) and (AktZ > 10) then
      begin
        Pen.Color := clGray;
        for i := 0 to 10 do
          if GridNuk.ColorCell[ACol+i,ARow-1] <> GridNuk.Color then
          begin
            MoveTo(Rect.Left+(i*5)-1,Rect.Top-3);
            LineTo(Rect.Left-6,Rect.Top-3);
            th := TextHeight('Z') div 2;
            tw := TextWidth('Z='+IntToStr(AktZ));
            TextOut(Rect.Left-7-tw,Rect.Top-3-th,'Z='+IntToStr(AktZ));
            Break;
          end;
      end;
      if MenuZReihe.Checked and (ARow = GridNuk.RowCount-AktZ-4) and
        (AktZ < 11) and (GridNuk.ColorCell[ACol+1,ARow] = GridNuk.Color) then
      begin
        Pen.Color := clGray;
        for i := 0 to 20 do
          if GridNuk.ColorCell[ACol+i,ARow-2] = GridNuk.Color then
          begin
            MoveTo(Rect.Left+(i*5),Rect.Top-8);
            LineTo(Rect.Left+(i*5)+16,Rect.Top-8);
            th := TextHeight('Z') div 2;
            TextOut(Rect.Left+(i*5)+17,Rect.Top-8-th,'Z='+IntToStr(AktZ));
            Break;
          end;
      end;
      if MenuNSpalte.Checked and (TVNuk.Selected.Level > 0) then
      begin
        Pen.Color := clBlue;
        temp := TVNuk.Selected.Text;
        //i := DM.GetN(DM.GetiZA(temp));
        if (AktN > 0) and (AktN+1 = ACol) then
        begin
          MoveTo(Rect.Left,Rect.Top);
          LineTo(Rect.Left,Rect.Bottom);
          MoveTo(Rect.Right-1,Rect.Top);
          LineTo(Rect.Right-1,Rect.Bottom);
          if GridNuk.ColorCell[ACol,ARow-1] = GridNuk.Color then
          begin
            MoveTo(Rect.Left,Rect.Top);
            LineTo(Rect.Right-1,Rect.Top);
            if AktN < 170 then
            begin
              tw := (TextWidth('N='+IntToStr(AktN)) - w) div 2;
              TextOut(Rect.Left-tw,Rect.Top-33,'N='+IntToStr(AktN));
              Pen.Color := clGray;
              MoveTo(Rect.Left+2,Rect.Top-21);
              LineTo(Rect.Left+2,Rect.Top);
            end;
          end;
          if GridNuk.ColorCell[ACol,ARow+1] = GridNuk.Color then
          begin
            Pen.Color := clBlue;
            MoveTo(Rect.Left,Rect.Bottom-1);
            LineTo(Rect.Right-1,Rect.Bottom-1);
          end;
        end;
      end;
    end;
    Brush.Style := bsSolid;
  end;
end;

procedure TfrmMain.btnNukZoomClick(Sender: TObject);
begin
  if Trim(btnNukZoom.Caption) = 'Nuklidkarte vergr��ern' then
  begin
    btnNukZoom.Caption := 'verkleinerte Nuklidkarte';
    if MenuGridMin.Checked then PanelMin.Visible := True;
    pmnuMinGrid.Visible := True;
    PMExpl.AutoPopup := True;
    GridNuk.DefaultColWidth := 50;
    GridNuk.DefaultRowHeight := 50;
    SBNuk.VertScrollBar.Range := 6050;//6250;
    SBNuk.HorzScrollBar.Range := 8950;//9200;
    SBNuk.HorzScrollBar.Increment := GridNuk.DefaultColWidth;
    SBNuk.VertScrollBar.Increment := GridNuk.DefaultRowHeight;
    if (MinPosX = 0) and (MinPosY = 0) then
    begin
      SBNuk.HorzScrollBar.Position := 0;//200;
      SBNuk.VertScrollBar.Position := 5700;
      MinPosX := SBNuk.HorzScrollBar.Position;
      MinPosY := SBNuk.VertScrollBar.Position;
    end
    else
    begin
      SBNuk.HorzScrollBar.Position := MinPosX;
      SBNuk.VertScrollBar.Position := MinPosY;
    end;
    Image1.Visible := False;
    Image2.Visible := False;
    GridNuk.DefaultDrawing := False;
    btnTVNukSuch.Enabled := True;
    if not MenuExpl.Checked then MenuGridDat.Enabled := True;
  end
  else
  begin
    MinPosX := SBNuk.HorzScrollBar.Position;
    MinPosY := SBNuk.VertScrollBar.Position;
    btnNukZoom.Caption := 'Nuklidkarte vergr��ern';
    PanelMin.Visible := False;
    pmnuMinGrid.Visible := False;
    PMExpl.AutoPopup := False;
    GridNuk.DefaultColWidth := nukw;
    GridNuk.DefaultRowHeight := nukw;
    SBNuk.VertScrollBar.Range := 127 * nukw; //635;
    SBNuk.HorzScrollBar.Range := 180 * nukw; //900;
    SBNuk.HorzScrollBar.Position := 0;
    SBNuk.HorzScrollBar.Increment := GridNuk.DefaultColWidth;
    SBNuk.VertScrollBar.Increment := GridNuk.DefaultRowHeight;
    Image1.Visible := True;
    Image2.Visible := True;
    btnTVNukSuch.Enabled := PanelNukTV.Visible;
  end;
  PosPanels;
  GridNuk.Repaint;
  PosPanelLeg;
  if PanelNukTV.Visible then TVNuk.SetFocus;
end;

procedure TfrmMain.CBHalfChange(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  SetNukLeg(CBHalf.ItemIndex);
  case CBHalf.ItemIndex of
    2..5: btnNukDiag.Enabled := True;
  else btnNukDiag.Enabled := False;
  end;
  if LeseNukKarte then
    if nochmal < 1 then
    begin
      LeseNukKarte;
      Inc(nochmal);
    end;
  CBHalf.Hint := Trim(CBHalf.Items.Strings[CBHalf.ItemIndex]);
  if PanelNukTV.Visible then TVNuk.SetFocus;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 112 then
  begin
    if (PC.ActivePage = PagePSE) and AboutBox.HelpPSE then AboutBox.ShowModal;
    if (PC.ActivePage = PageKarte) and AboutBox.HelpKarte then AboutBox.ShowModal;
    if (PC.ActivePage = PageZerfall) and AboutBox.HelpRad then AboutBox.ShowModal;
    if (PC.ActivePage = PageSuch) and AboutBox.HelpSuch then AboutBox.ShowModal;
    if (PC.ActivePage = PageSchema) and AboutBox.HelpSchema then AboutBox.ShowModal;
  end;
  if PC.ActivePage = PageKarte then
  begin
    if GridNuk.DefaultColWidth > nukw then
    begin
      if Key = VK_UP then PosNuk(AktPosCol,AktPosRow-1);
      if Key = VK_DOWN then PosNuk(AktPosCol,AktPosRow+1);
      if Key = VK_LEFT then PosNuk(AktPosCol-1,AktPosRow);
      if Key = VK_RIGHT then PosNuk(AktPosCol+1,AktPosRow);
    end;
    if PanelNukTV.Visible and (GridNuk.DefaultColWidth = nukw) then
    begin
      if Key = VK_LEFT then
        SBNuk.HorzScrollBar.Position :=
          SBNuk.HorzScrollBar.Position - SBNuk.HorzScrollBar.Increment;
      if Key = VK_RIGHT then
        SBNuk.HorzScrollBar.Position :=
          SBNuk.HorzScrollBar.Position + SBNuk.HorzScrollBar.Increment;
    end;
  end;
  if PC.ActivePage = PageSchema then
    if btnSchema.Enabled and (Key = 90 ) then btnSchemaBack.Click;
end;

procedure TfrmMain.GridNukMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SBNuk.HorzScrollBar.Position := MinPosX;
  SBNuk.VertScrollBar.Position := MinPosY;
end;

procedure TfrmMain.PMExplGoNukClick(Sender: TObject);
var
  z,a,iza: Integer;
  temp: String;
begin
  if Pos('(',TVNuk.Selected.Text) > 0 then
    temp := GetKlammer(TVNuk.Selected.Text)
  else temp := TVNuk.Selected.Text;
  z := IntAusStr(Trim(Copy(temp,1,Pos(#32,temp)-1)));
  Delete(temp, 1, Pos(#32,temp));
  if (IntAusStr(temp) = 0) and DM.ETChem.Locate('Symb',temp,[]) then
    a := DM.GetA(DM.ETChem.FieldByName('iZA').AsInteger)
  else a := IntAusStr(temp);
  iza := DM.MakeIZA(z,a,0);
  PosNuk(DM.GetN(iza)+1,GridNuk.RowCount-z-6);
end;

procedure TfrmMain.btnVorClick(Sender: TObject);
begin
  if (Sender as TJvTransparentButton).Tag = 1 then
    Chart1.NextPage else Chart1.PreviousPage;
  btnVor.Enabled := (Chart1.Page < Chart1.NumPages);
  btnZur.Enabled := (Chart1.Page > 1);
end;

procedure TfrmMain.GetAppIcon;
//var Icon: TIcon;
begin
  {Icon := TIcon.Create;
  try
    DM.ILFlag.GetIcon(12,Icon);
    DM.ILTV.AddIcon(Icon);
  finally
    Icon.Free;
  end;
  Icon := TIcon.Create;
  try
    //Icon.LoadFromFile('C:\Eigene Projekte\Nukliddaten\FavIcon\RadDecay_0000.ico');
    Icon.Handle := LoadIcon(HInstance,Pchar('Symbol1'));
    //Icon.Handle := RES_ICON;
    DM.ILTV.AddIcon(Icon);
  finally
    Icon.Free;
  end;}
  DM.ILFlag.AddIcon(Application.Icon);
end;

procedure TfrmMain.btnTVSortClick(Sender: TObject);
var temp: String;
begin
  if (Sender as TJvTransparentButton).Tag = 0 then
    temp := 'Alphabet. sortieren' else temp := 'Alphabetisch sortieren';
  (Sender as TJvTransparentButton).Enabled := False;
  if (Sender as TJvTransparentButton).Caption = temp then
  begin
    if (Sender as TJvTransparentButton).Tag = 1 then
      TVRad.SortType := stText else TVNuk.SortType := stText;
    (Sender as TJvTransparentButton).Caption := 'Nach Z sortieren';
  end
  else
  begin
    TvAktiv := True;
    if (Sender as TJvTransparentButton).Tag = 1 then
    begin
      TVRad.SortType := stNone;
      if TVRad.Selected <> nil then
        LeseNukExplorer(TVRad,TVRadIdx,False)
      else LeseNukExplorer(TVRad,0,False);
    end
    else
    begin
      TVNuk.SortType := stNone;
      if TVNuk.Selected <> nil then
        LeseNukExplorer(TVNuk,TVNukIdx,False)
      else LeseNukExplorer(TVNuk,0,False);
    end;
    (Sender as TJvTransparentButton).Caption := temp;
  end;
  (Sender as TJvTransparentButton).Enabled := True;
end;

procedure TfrmMain.GridNukMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (Sender as TIconGrid).Name = 'GridMin' then
  begin
    if pmnuLeg.Visible then pmnuLeg.Visible := False;
    if not pmnuMinGrid.Visible then pmnuMinGrid.Visible := True;
  end
  else if ((Sender as TIconGrid).Name = 'GridNuk') and
    (GridNuk.DefaultColWidth > nukw) then
  begin
    pmnuMinGrid.Visible := True;
    pmnuLeg.Visible := True;
  end
  else
  begin
    pmnuMinGrid.Visible := False;
    pmnuLeg.Visible := True;
  end;
end;

procedure TfrmMain.PanelLegMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if pmnuMinGrid.Visible then pmnuMinGrid.Visible := False;
  if not pmnuLeg.Visible then pmnuLeg.Visible := True;
end;

procedure TfrmMain.SBNukConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
var c,r: Integer;
begin
  if GridNuk.DefaultColWidth = 50 then //> 10 then
  begin
    c := SBNuk.HorzScrollBar.Position div SBNuk.HorzScrollBar.Increment;
    r := SBNuk.VertScrollBar.Position div SBNuk.VertScrollBar.Increment;
    GridAktPos(c+7,r+5);
  end;
end;

procedure TfrmMain.btnRadClick(Sender: TObject);
var i,iza: Integer;
begin
  Screen.Cursor := crHourGlass;
  ResetBtnGam;
  GridReihe.Color := $00FFFFCC;
  ClearGridRadDat;
  bRad := (Sender as TJvTransparentButton).Tag;
  btnRad1.Enabled := (bRad <> 1);
  btnRad2.Enabled := (bRad <> 2);
  btnRad3.Enabled := (bRad <> 3);
  btnBack.Visible := False;
  iza := DM.GetiZA(TVRad.Items[TVRadIdx].Text);
  if (bRad = 1) and ClearGridRad(GridRad) then
    RadReihe(iza)
  else if (bRad = 2) and ClearGridRad(GridRad) then
  begin
    for i := 0 to GridReihe.ColCount-1 do
    begin
      GridReihe.HintCell[i,0] := '';
      GridReihe.ColorCell[i,0] := $00FFFFCC;
    end;
    RadReihe(iza);
  end
  else if (bRad = 3) and ClearGridRad(GridRad) then RadBack(iza);
  if bRad = 1 then
    PanelGamma.BorderStyle := bsSingle
  else PanelGamma.BorderStyle := bsNone;
  PanelRadNuk.Visible := (bRad <> 1);
  GridRadDat.Visible := (bRad <> 1);
  SBGridRad.Visible := MenuRadKarte.Checked;
  Gauge.Position := 0;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.TVRadChange(Sender: TObject; Node: TTreeNode);
var iza: Integer;
begin
  frmMain.RadTyp := 0;
  if Node.Selected and (Node.Level > 0) then
  begin
    TVRadIdx := Node.AbsoluteIndex;
    btnRad1.Hint := 'Wahrscheinliche Zerfallsreihe(n) f�r ''' + Node.Text + '''';
    btnRad2.Hint := 'Alle m�glichen Zerfallsreihen von ''' + Node.Text + ''' ausgehend';
    btnRad3.Hint := 'Alle m�glichen Zerfallsreihen zu ''' + Node.Text + '''';
    iza := DM.GetiZA(Node.Text);
    Screen.Cursor := crHourGlass;
    if MenuStrahl.Checked then
    begin
      btnA.Enabled := CheckLedOn(1,iza);
      btnB.Enabled := CheckLedOn(2,iza);
      btnG.Enabled := CheckLedOn(3,iza);
      btnX.Enabled := CheckLedOn(4,iza);
    end;
    ClearGridRadDat;
    if (bRad = 1) and (XAkt > 0) then
    begin
      if btnA.Down and Alpha(iza) then btnBack.Visible := True;
      if btnB.Down and Beta(iza) then btnBack.Visible := True;
      if btnG.Down and Gamma(iza) then btnBack.Visible := True;
      if btnX.Down and XRay(iza) then btnBack.Visible := True;
    end
    else if (bRad < 3) and ClearGridRad(GridRad) and RadReihe(iza) then
    begin
      if btnBack.Visible then
      begin
        SBGridRad.Visible := MenuRadKarte.Checked;
        btnBack.Visible := False;
      end;
    end else if ClearGridRad(GridRad) then RadBack(iza);
    if bRad > 1 then
    begin
      SBRadH := SBGridReihe.HorzScrollBar.Position;
      SBRadV := SBGridReihe.VertScrollBar.Position;
    end;
    Gauge.Position := 0;
    Screen.Cursor := crDefault;
  end else btnSchema.Enabled := False;
end;

procedure TfrmMain.GridReiheDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  function isSymF(txt: String): Boolean;
  begin
    Result := (Pos('a',txt) > 0) or (Pos('b',txt) > 0) or (Pos('ec',txt) > 0);
  end;
var
  i,th,tw,h,w,c,r: Integer;
  temp,temp1,temp2,temp3: String;
  bc: TColor;
  Icon: TIcon;
  Rekt: TRect;
begin
  with GridReihe.Canvas do
  begin
    Brush.Color := GridReihe.ColorCell[ACol,ARow];
    FillRect(Rect);
    Rekt.Left := Rect.Left;
    Rekt.Right := Rect.Right-1;
    Rekt.Top := Rect.Top;
    Rekt.Bottom := Rect.Bottom;
    w := Rekt.Right - Rekt.Left;
    h := Rekt.Bottom - Rekt.Top;
    if not btnRad1.Enabled then
      th := (h - TextHeight(GridReihe.Cells[ACol,ARow])) div 2
    else th := 0;
    tw := (w - TextWidth(GridReihe.Cells[ACol,ARow])) div 2;
    Font.Color := DM.RadFontFarbe(DM.RadFarbNr(GridReihe.ColorCell[ACol,ARow]));
    if (DM.RadFarbNr(Brush.Color) = 0) and (GridReihe.Cells[ACol,ARow] = '') and
      (GridReihe.HintCell[ACol,ARow] = '') then
    begin
      Brush.Color := GridReihe.Color;
      FillRect(Rekt);
    end;
    if not btnBack.Visible then
    begin
      if GridReihe.HintCell[ACol,ARow] = 'Icon' then
      begin
        temp1 := GridReihe.Cells[ACol,ARow];
        Font.Style := [];
        if Pos(';',temp1) > 0 then
        begin
          temp := Copy(temp1,1,Pos(';',temp1)-1);
          if Pos(',',temp) > 0 then
          begin
            temp3 := temp;
            temp2 := Copy(temp3,1,Pos(',',temp3));
            Delete(temp3,1,Pos(',',temp3));
          end;
          if isSymF(temp) then
          begin
            if Pos('ec',temp) > 0 then
            begin
              temp := StringReplace(temp,'ec','e',[]);
              Font.Size := 10;
            end else Font.Size := 8;
            Font.Charset := SYMBOL_CHARSET;
            Font.Name := 'Symbol';
            if isSymF(temp2) and not isSymF(temp3) then
            begin
              TextOut(Rekt.Left+2,Rekt.Top+th,temp2);
              tw := TextWidth(temp2)+1;
              Font.Charset := ANSI_CHARSET;
              Font.Name := 'Arial';//'MS Sans Serif';
              Font.Size := 8;
              Font.Style := [];
              TextOut(Rekt.Left+tw+2,Rekt.Top+th,temp3);
            end
            else
            begin
              Font.Size := 8;
              TextOut(Rekt.Left+2,Rekt.Top+th,temp);
            end;
          end
          else
          begin
            Font.Charset := ANSI_CHARSET;
            Font.Name := 'Arial';//'MS Sans Serif';
            Font.Size := 8;
            Font.Style := [];
            TextOut(Rekt.Left+2,Rekt.Top+th,temp);
          end;
          Delete(temp1,1,Pos(';',temp1));
          TextOut(Rekt.Right-TextWidth(temp1)-1,Rekt.Top+th,temp1);
        end
        else if isSymF(temp1) then
        begin
          if Pos(',',temp1) > 0 then
          begin
            temp3 := temp1;
            temp2 := Copy(temp3,1,Pos(',',temp3));
            Delete(temp3,1,Pos(',',temp3));
          end;
          if Pos('ec',temp1) > 0 then
          begin
            temp1 := StringReplace(temp1,'ec','e',[]);
            Font.Size := 10;
          end else Font.Size := 8;
          Font.Charset := SYMBOL_CHARSET;
          Font.Name := 'Symbol';
          if isSymF(temp2) and not isSymF(temp3) then
          begin
            TextOut(Rekt.Left+2,Rekt.Top+th,temp2);
            tw := TextWidth(temp2)+1;
            Font.Charset := ANSI_CHARSET;
            Font.Name := 'Arial';//'MS Sans Serif';
            Font.Size := 8;
            Font.Style := [];
            TextOut(Rekt.Left+tw+2,Rekt.Top+th,temp3);
          end
          else
          begin
            Font.Size := 8;
            Font.Style := [];
            TextOut(Rekt.Left+2,Rekt.Top+th,temp1);
          end;
        end
        else
        begin
          Font.Charset := ANSI_CHARSET;
          Font.Name := 'Arial';//'MS Sans Serif';
          Font.Size := 8;
          Font.Style := [];
          TextOut(Rekt.Left+2,Rekt.Top+th,temp1);
        end;
        Icon := TIcon.Create;
        DM.ILFlag.GetIcon(11,Icon);
        tw := (w - Icon.Width) div 2;
        Draw(Rekt.Left+tw+8,Rekt.Top+6,Icon);
        Icon.Free;
        if Pos('SF',GridReihe.Cells[ACol,ARow]) > 0 then
        begin
          tw := (w - TextWidth('?')) div 2;
          TextOut(Rekt.Left+tw+1,Rekt.Top,'?');
        end;
      end
      else if (ARow = 0) and (Pos('Zerfallsreihe',GridReihe.Cells[ACol,ARow]) > 0) then
      begin
        Font.Color := clNavy;
        TextOut(Rekt.Left+tw,Rekt.Top+th,GridReihe.Cells[ACol,ARow]);
        Pen.Color := clBlack;
        MoveTo(Rekt.Left,Rekt.Top);
        LineTo(Rekt.Left,Rekt.Bottom);
        MoveTo(Rekt.Left,Rekt.Top);
        LineTo(Rekt.Right-1,Rekt.Top);
        MoveTo(Rekt.Right-1,Rekt.Top);
        LineTo(Rekt.Right-1,Rekt.Bottom);
        MoveTo(Rekt.Left,Rekt.Bottom-1);
        LineTo(Rekt.Right,Rekt.Bottom-1);
      end
      else
      begin
        if (Pos('[',GridReihe.Cells[ACol,ARow]) > 0) and
           (Pos('[]',GridReihe.Cells[ACol,ARow]) = 0) then  // Alle Rads
        begin
          temp1 := Trim(GridReihe.Cells[ACol,ARow]);
          Delete(temp1,1,Pos('[',temp1));
          Delete(temp1,Pos(']',temp1),1);
          temp := Trim(GridReihe.Cells[ACol,ARow]);
          temp := Copy(temp,1,Pos('[',temp)-1);
          i := DM.RTypFarbe(DM.GetiZA(temp),DM.RadFarbNr(Brush.Color));
          if (i > 0) and (i <> DM.RadFarbNr(Brush.Color)) then
          begin
            bc := Brush.Color;
            NukEck(GridReihe.Canvas,Rekt,0,RadF[i]);
            Brush.Color := bc;
          end;
          DM.RTypPlus(DM.GetiZA(temp),i,DM.RadFarbNr(Brush.Color),Rekt,GridReihe.Canvas);
          Font.Style := [fsBold];
          Brush.Style := bsClear;
          tw := (w - TextWidth(temp)) div 2;
          TextOut(Rekt.Left+tw,Rekt.Top+th,temp);
          Font.Size := 7;
          Font.Style := [];
          PicRTyp(GridReihe.Canvas,Font,Rekt,5,temp1);
        end
        else if Pos('[]',GridReihe.Cells[ACol,ARow]) = 0 then
        begin
          Font.Style := [fsBold];
          TextOut(Rekt.Left+tw,Rekt.Top+th,GridReihe.Cells[ACol,ARow]);
          if (brad > 1) then
          begin
            if (GridReihe.ColorCell[ACol,ARow] = clBlack) then
              temp := 'stabil'
            else if (GridReihe.ColorCell[ACol,ARow] = clSilver) then
              temp := 'unbekannt';
            Font.Style := [];
            tw := (w - TextWidth(temp)) div 2;
            th := (h - th - TextHeight(temp)) div 2;
            TextOut(Rekt.Left+tw,Rekt.Top+th,temp);
          end;
        end;
        if (Pos('[',GridReihe.Cells[ACol,ARow]) > 0) or
          (GridReihe.ColorCell[ACol,ARow] = clBlack) then
        begin
          temp := GridReihe.HintCell[ACol,ARow];
          while Pos('(',temp) > 0 do
          begin
            temp1 := GetKlammer(Copy(temp,1,Pos(')',temp)));
            if Pos('[',temp1) > 0 then i := 1
            else if Pos(']',temp1) > 0 then i := 2
            else i := 0;
            temp1 := StringReplace(temp1,'[','',[]);
            temp1 := StringReplace(temp1,']','',[]);
            Delete(temp,1,Pos(')',temp));
            c := StrToInt(Copy(temp1,1,Pos(DM.DezS,temp1)-1));
            Delete(temp1,1,Pos(DM.DezS,temp1));
            r := StrToInt(temp1);
            if i = 2 then
              RadPfeil(GridReihe.Canvas,GridReihe.CellRect(ACol-1,ARow),GridReihe.CellRect(c,r),ACol,ARow,c,r,i)
            else
              RadPfeil(GridReihe.Canvas,Rect,GridReihe.CellRect(c,r),ACol,ARow,c,r,i);
          end;
        end;
      end;
      Pen.Color := GridReihe.Color;
      MoveTo(Rekt.Right,Rekt.Top);
      LineTo(Rekt.Right,Rekt.Bottom);
      if ((ARow > 1) and (ARow mod 2 = 0)) or (bRad <> 1) then
      begin
        MoveTo(Rekt.Left,Rekt.Bottom-1);
        LineTo(Rekt.Right,Rekt.Bottom-1);
      end;
    end
    else
    begin
      if ARow = 0 then Font.Color := clNavy;
      temp1 := GridReihe.Cells[ACol,ARow];
      Font.Style := [fsBold];
      if (ACol = 1) and (ARow > 0) and (XAkt = 0) and isSymF(temp1) then
      begin
        if Pos(',',temp1) > 0 then
        begin
          temp3 := temp1;
          temp2 := Copy(temp3,1,Pos(',',temp3));
          Delete(temp3,1,Pos(',',temp3));
        end;
        if Pos('ec',temp1) > 0 then
        begin
          temp1 := StringReplace(temp1,'ec','e',[]);
          Font.Size := 10;
        end else Font.Size := 8;
        Font.Charset := SYMBOL_CHARSET;
        Font.Name := 'Symbol';
        tw := (w - TextWidth(temp1)) div 2;
        if isSymF(temp2) and not isSymF(temp3) then
        begin
          TextOut(Rekt.Left+tw,Rekt.Top+th-2,temp2);
          tw := tw+TextWidth(temp2)+1;
          Font.Charset := ANSI_CHARSET;
          Font.Name := 'Arial';//'MS Sans Serif';
          Font.Size := 7;//8;
          TextOut(Rekt.Left+tw,Rekt.Top+th-2,temp3);
        end
        else
        begin
          Font.Size := 8;
          TextOut(Rekt.Left+tw,Rekt.Top+th-2,temp1);
        end;
      end
      else if (XAkt = 4) and (ACol = 3) and
        (Pos('_',GridReihe.Cells[ACol,ARow]) > 0) then
      begin
        Font.Size := 10;
        Brush.Style := bsClear;
        TextUpDown(GridReihe.Canvas,Font,Rekt,GridReihe.Cells[ACol,ARow],60);
      end
      else if (Pos('Zerfallsart',GridReihe.Cells[ACol,0]) > 0) and (ARow > 0) and
      (ACol = 3) and (GridReihe.Cells[ACol,ARow] <> 'vorhanden') then
        MaleZerfall(GridReihe.Canvas,Font,Rekt,GridReihe.Cells[ACol,ARow])
      else if (ACol = 3) and (Pos('us',GridReihe.Cells[ACol,ARow]) > 0) then
        MikroSek(GridReihe.Canvas,Font,Rekt,GridReihe.Cells[ACol,ARow])
      else if (ACol = 3) and (Pos('E',GridReihe.Cells[ACol,ARow]) > 0) and
        (Pos('Em',GridReihe.Cells[ACol,ARow]) = 0) then
        Potenz(GridReihe.Canvas,Font,Rekt,GridReihe.Cells[ACol,ARow])
      else if (XAkt > 0) and (ACol < 3) and (ARow > 0) and
        (Pos('Em',GridReihe.Cells[ACol,ARow]) = 0) then
        PosText(GridReihe.Canvas,Font,Rekt,GridReihe.Cells[ACol,ARow])
      else
      begin
        if XAkt > 0 then Font.Size := 10;
        if ARow = 0 then
          TextOut(Rekt.Left+tw-3,Rekt.Top+th,GridReihe.Cells[ACol,ARow])
        else TextOut(Rekt.Left+tw,Rekt.Top+th,GridReihe.Cells[ACol,ARow]);
      end;
    end;
  end;
end;

procedure TfrmMain.MenuOptClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
  case (Sender as TMenuItem).Tag of
    1: if CBHalf.ItemIndex <> 6 then
         PanelLeg.Visible := (Sender as TMenuItem).Checked;
    2: if GridNuk.DefaultColWidth = 50 then
         PanelMin.Visible := (Sender as TMenuItem).Checked;
    3: SBGridRad.Visible := (Sender as TMenuItem).Checked;
    4: if not (Sender as TMenuItem).Checked then
       begin
         btnA.Enabled := True;
         btnB.Enabled := True;
         btnG.Enabled := True;
         btnX.Enabled := True;
       end;
    5: begin
         GridNuk.Repaint;
         MenuMagZahlen.Enabled := not MenuZReihe.Checked and not MenuNSpalte.Checked;
         btnTVNukSuch.Enabled := MenuZReihe.Checked and MenuNSpalte.Checked;
       end;
    6: begin
         PanelProton.Visible := MenuPfeil.Checked;
         PanelIso.Visible := MenuPfeil.Checked;
         GridNuk.Repaint;
       end;
    7: begin
         if (GridNuk.DefaultColWidth = nukw) then GridNuk.Repaint;
         MenuZReihe.Enabled := not MenuMagZahlen.Checked;
         MenuNSpalte.Enabled := not MenuMagZahlen.Checked;
         if PanelNukTV.Visible then TVNuk.SetFocus;
       end;
  end;
end;

procedure TfrmMain.btnBackClick(Sender: TObject);
var iza: Integer;
begin
  GridReihe.Color := $00FFFFCC;
  if TVRad.Selected.Level > 0 then
    iza := DM.GetiZA(TVRad.Selected.Text)
  else iza := DM.GetiZA(TVRad.Items[TVRadIdx].Text);
  if TVRad.Selected.Level > 0 then
  begin
    Screen.Cursor := crHourGlass;
    {if TVRad.Selected.Level > 0 then
      iza := DM.GetiZA(TVRad.Selected.Text)
    else iza := DM.GetiZA(TVRad.Items[TVRadIdx].Text);}
    if ClearGridRad(GridRad) then RadReihe(iza);
    Screen.Cursor := crDefault;
    ResetBtnGam;
  end;
  SBGridRad.Visible := MenuRadKarte.Checked;
  TVRad.SetFocus;
  if TVRad.Selected.Level = 0 then
  begin
    if not TVRad.Items[TVRadIdx].Parent.Expanded then
      TVRad.Items[TVRadIdx].Parent.Expand(False);
    TVRad.Items[TVRadIdx].Selected := True;
  end;
  btnRad1.Enabled := (bRad <> 1);
  btnRad2.Enabled := (bRad <> 2);
  btnRad3.Enabled := (bRad <> 3);
  btnBack.Visible := False;
  if DM.ETDMI.Locate('iZA',iza,[]) then btnSchema.Enabled := True;
end;

procedure TfrmMain.TVKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with Sender as TTreeView do
  begin
    if Key = VK_RETURN then
    begin
      if Selected.Level = 0 then
        if Selected.Expanded then
          Selected.Collapse(False)
        else Selected.Expand(False);
      if Selected.Level = 1 then                           //10
        if (Name = 'TVNuk') and (GridNuk.DefaultColWidth > nukw) then
          PMExplGoNukClick(Sender);
    end;
  end;
end;

procedure TfrmMain.GridPSEKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_LEFT) or (Key = VK_RIGHT) or (Key = VK_UP) or (Key = VK_DOWN) then
    PSEGoElement(Key);
end;

procedure TfrmMain.btnGamClick(Sender: TObject);
var iza: Integer;
begin
  (Sender as TJvTransparentButton).Enabled := False;
  Screen.Cursor := crHourGlass;
  iza := DM.GetiZA(TVRad.Items[TVRadIdx].Text);
  if not (Sender as TJvTransparentButton).Down then
  begin
    XAkt := 0;
    btnBackClick(Sender);
  end
  else
  begin
    btnSchema.Enabled := False;
    XAkt := (Sender as TJvTransparentButton).Tag;
    case XAkt of
      1: if Alpha(iza) then btnBack.Visible := True;
      2: if Beta(iza) then btnBack.Visible := True;
      3: if Gamma(iza) then btnBack.Visible := True;
      4: if XRay(iza) then btnBack.Visible := True;
    end;
  end;
  (Sender as TJvTransparentButton).Enabled := True;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.RGGamSortClick(Sender: TObject);
var iza: Integer;
begin
  Screen.Cursor := crHourGlass;
  iza := DM.GetiZA(TVRad.Items[TVRadIdx].Text);
  case XAkt of
    1: if Alpha(iza) then btnBack.Visible := True;
    2: if Beta(iza) then btnBack.Visible := True;
    3: if Gamma(iza) then btnBack.Visible := True;
    4: if XRay(iza) then btnBack.Visible := True;
  end;
  TVRad.SetFocus;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.SetMenueItem(Idx: Integer);
begin
  MenuPSE.Enabled := (Idx <> 1);
  MenuNukKarte.Enabled := (Idx <> 2);
  MenuDecay.Enabled := (Idx <> 5);
  MenuSuch.Enabled := (Idx <> 6);
  MenuSpec.Enabled := (Idx <> 7);
  MenuZW.Enabled := (Idx <> 8);
end;

procedure TfrmMain.IntChange(Sender: TObject);
var
  i,i1,i2: Integer;
  temp,CBName: String;
begin
  i1 := 0;
  CBName := (Sender as TJvComboBox).Name;
  i2 := (Sender as TJvComboBox).Items.Count;
  temp := (Sender as TJvComboBox).Text;
  if Trim(temp) <> '' then
  begin
    for i := 1 to Length(temp) do
      if not IsDigit(temp[i]) then
      begin
        Delete(temp,i,1);
        (Sender as TJvComboBox).Text := temp;
        (Sender as TJvComboBox).SelStart := i-1;
        Break;
      end else Inc(i1);
    if (i1 > 0) and ((StrToInt(temp) > i2) or (StrToInt(temp) = 0)) then
    begin
      Delete(temp,Length(temp),1);
      (Sender as TJvComboBox).Text := temp;
      (Sender as TJvComboBox).SelStart := Length(temp);
    end;
  end;
end;

procedure TfrmMain.btnSuchClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  lblAnz.Caption := 'Gefunden: 0';
  case RGSuch.ItemIndex of
    0: lblSuchArt.Caption := RGSuch.Items[RGSuch.ItemIndex];
    1..4: lblSuchArt.Caption := RGSuch.Items[RGSuch.ItemIndex] + '-Emissionen';
    5: lblSuchArt.Caption := RGSuch.Items[RGSuch.ItemIndex] + '-Elektronen';
  end;
  case RGSuch.ItemIndex of
    0: DM.SuchNuk;
    1: if DM.SetzeFilter(DM.ETA) then DM.SuchAlpha(DM.ETA);
    2: if DM.SetzeFilter(DM.ETB) then DM.SuchAlpha(DM.ETB);
    3: if DM.SetzeFilter(DM.ETG) then DM.SuchAlpha(DM.ETG);
    4: DM.SuchXRay;
    5: DM.SuchAuger;
  end;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.GridSuchDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  th,tw,h,w: Integer;
  temp,temp1: String;
  Wahr: Boolean;
  Rekt: TRect;
begin
  case RGSuch.ItemIndex of
    1: if (ACol = 1) or (ACol = 2) then Wahr := True else Wahr := False;
    2,3: if ACol <= 1 then Wahr := True else Wahr := False;
    4,5: if ACol >= 2 then Wahr := True else Wahr := False;
  else Wahr := False;
  end;
  with GridSuch.Canvas do
  begin
    w := Rect.Right - Rect.Left;
    h := Rect.Bottom - Rect.Top;
    Rekt.Left := Rect.Left;
    Rekt.Right := Rect.Right;
    Rekt.Top := Rect.Top;
    Rekt.Bottom := Rect.Bottom;
    temp := GridSuch.Cells[ACol,ARow];
    temp1 := GridSuch.HintCell[ACol,ARow];
    Font.Size := 8;//10;
    Brush.Color := GridSuch.Color;
    FillRect(Rekt);
    if Wahr and (Pos('_',temp1) > 0) then
    begin
      Brush.Style := bsClear;
      PosText(GridSuch.Canvas,Font,Rekt,temp);
      TextUpDown(GridSuch.Canvas,Font,Rekt,temp1,90);
    end
    else if Pos('_',temp) > 0 then
    begin
      Brush.Style := bsClear;
      TextUpDown(GridSuch.Canvas,Font,Rekt,temp,20);
    end
    else if ((RGSuch.ItemIndex = 2) or (RGSuch.ItemIndex = 3)) and (ACol = 3) and
      (temp <> 'xray') and (Arow > 0) then
      MaleZerfall(GridSuch.Canvas,Font,Rekt,temp)
    else if Wahr and (Arow > 0) and (Pos('Keine',temp) = 0) then
      PosText(GridSuch.Canvas,Font,Rekt,temp)
    else if (RGSuch.ItemIndex = 0) and (ACol = 3) and (Arow > 0) then
      MaleZerfallsarten(GridSuch.Canvas,Font,Rekt,temp)
    else if (Pos('Halbwert',GridSuch.Cells[ACol,0]) > 0) and (Arow > 0) then
    begin
      if Pos('us',temp) > 0 then MikroSek(GridSuch.Canvas,Font,Rekt,temp)
      else if (Pos('E',temp) > 0) then Potenz(GridSuch.Canvas,Font,Rekt,temp)
      else
      begin
        th := (h - TextHeight(temp)) div 2;
        tw := (w - TextWidth(temp)) div 2;
        TextOut(Rect.Left+tw,Rect.Top+th,temp);
      end;
    end
    else
    begin
      if temp = 'xray' then temp := 'R�ntgen-Strahlung';
      th := (h - TextHeight(temp)) div 2;
      tw := (w - TextWidth(temp)) div 2;
      TextOut(Rect.Left+tw,Rect.Top+th,temp);
    end;
  end;
end;

procedure TfrmMain.CBShowGridClick(Sender: TObject);
begin
  SBSuchKarte.Visible := CBShowGrid.Checked;
end;

procedure TfrmMain.RGSuchClick(Sender: TObject);
begin
  ETH1.Enabled := (RGSuch.ItemIndex < 4);
  ETH2.Enabled := (RGSuch.ItemIndex < 4);
  CBTH1.Enabled := (RGSuch.ItemIndex < 4);
  CBTH2.Enabled := (RGSuch.ItemIndex < 4);
  EEnergy.Enabled := (RGSuch.ItemIndex > 0);
  EkeV.Enabled := (RGSuch.ItemIndex > 0);
  SBSuchKarte.Visible :=  (RGSuch.ItemIndex < 4) and CBShowGrid.Checked;
  CBShowGrid.Enabled := (RGSuch.ItemIndex < 4);
  RGSuchItems;
end;

procedure TfrmMain.btnResetClick(Sender: TObject);
begin
  if MessageDlg('Alle Felder l�schen?',mtConfirmation,[mbYes,mbCancel],0) = mrYes then
  begin
    if ResetCBs(True) and ClearGridRad(GridSuchKarte) then
      ClearGridForDaten(GridSuch,RGSuch.ItemIndex,False);
  end;
end;

procedure TfrmMain.ETZChange(Sender: TObject);
var i: Integer;
begin
  if (ETZ.Value > 0) and (ETZ.Value < 119) then
  begin
    if DM.ETName.Locate('Nr',ETZ.Value,[]) then
      for i := 0 to CBSym.Items.Count-1 do
        if CBSym.Items[i] = DM.ETName.FieldByName('F1').AsString then
        begin
          CBSym.ItemIndex := i;
          Break;
        end;
  end else CBSym.ItemIndex := -1;
end;

procedure TfrmMain.RGSuchSortClick(Sender: TObject);
begin
  RGSuchIndex;
end;

procedure TfrmMain.GridDatenDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var temp: String;
begin
  with GridDaten.Canvas do
    if (ACol = 1) then
    begin
      if (ARow = 7) then
      begin
        if (Pos('us',GridDaten.Cells[ACol,ARow]) > 0) then
        begin
          FillRect(Rect);
          MikroSek(GridDaten.Canvas,Font,Rect,GridDaten.Cells[ACol,ARow]);
        end
        else if (Pos('E',GridDaten.Cells[ACol,ARow]) > 0) then
        begin
          FillRect(Rect);
          Potenz(GridDaten.Canvas,Font,Rect,GridDaten.Cells[ACol,ARow]);
        end;
      end
      else if (ARow = 8) then
      begin
        temp := GridDaten.HintCell[ACol,ARow];
        temp := StringReplace(temp,'Alpha','a',[rfReplaceAll]);
        temp := StringReplace(temp,'Beta','b',[rfReplaceAll]);
        FillRect(Rect);
        MaleZerfallsarten(GridDaten.Canvas,Font,Rect,temp);
      end;
    end;
end;

procedure TfrmMain.GridRadDatDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with GridRadDat.Canvas do
  begin
    if (ACol = 1) and (ARow > 0) and (Pos('E',GridRadDat.Cells[ACol,Arow]) > 0) then
    begin
      FillRect(Rect);
      Potenz(GridRadDat.Canvas,Font,Rect,GridRadDat.Cells[ACol,Arow]);
    end;
    if (ACol = 0) and (ARow > 0) then
    begin
      FillRect(Rect);
      MaleZerfall(GridRadDat.Canvas,Font,Rect,GridRadDat.Cells[ACol,Arow]);
    end;
  end;
end;

procedure TfrmMain.CBChange(Sender: TObject);
var
  i: Integer;
  temp,temp1: String;
  Wahr: Boolean;
begin
  Wahr := False;
  temp := (Sender as TJvComboBox).Text;
  for i := 0 to (Sender as TJvComboBox).Items.Count-1 do
  begin
    temp1 := (Sender as TJvComboBox).Items[i];
    if (Length(temp) = 1) and (UpperCase(temp) = temp1[1]) then
    begin
      (Sender as TJvComboBox).ItemIndex := i;
      Wahr := True;
      Break;
    end
    else if temp = temp1 then
    begin
      (Sender as TJvComboBox).ItemIndex := i;
      Wahr := True;
      Break;
    end;
  end;
  if not Wahr then (Sender as TJvComboBox).ItemIndex := -1;
  if ((Sender as TJvComboBox).ItemIndex >= 0) and
    DM.ETName.Locate('F1',(Sender as TJvComboBox).Text,[]) then
      ETZ.Value := DM.ETName.FieldByName('Nr').AsInteger
  else ETZ.Value := 0;
end;

procedure TfrmMain.SBGridReiheConstrainedResize(Sender: TObject;
  var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
begin
  if (PC.ActivePageIndex = 3) and (bRad > 1) then
  begin
    if (SBRadH <> SBGridReihe.HorzScrollBar.Position) or
       (SBRadV <> SBGridReihe.VertScrollBar.Position) then
      GridReihe.Repaint;
    SBRadH := SBGridReihe.HorzScrollBar.Position;
    SBRadV := SBGridReihe.VertScrollBar.Position;
  end;
  //Label1.Caption := IntToStr(SBRadH) + ',' + IntToStr(SBRadH);
end;

procedure TfrmMain.GridReiheClick(Sender: TObject);
begin
  SBGridReihe.HorzScrollBar.Position := SBRadH;
  SBGridReihe.VertScrollBar.Position := SBRadV;
  GridReihe.Repaint;
end;

procedure TfrmMain.GridSpecPSEDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  h,w: Integer;
  temp: String;
  Rekt: TRect;
begin
  Rekt.Left := Rect.Left;
  Rekt.Right := Rect.Right-1;
  Rekt.Top := Rect.Top;
  Rekt.Bottom := Rect.Bottom-1;
  with GridSpecPSE.Canvas do
  begin
    temp := GridSpecPSE.Cells[ACol,ARow];
    if temp <> '' then
      if (SpecX = ACol) and (SpecY = ARow) then
        Brush.Color := clLime
      else Brush.Color := clInfoBk;
    FillRect(Rekt);
    h := (Rekt.Bottom - Rekt.Top - TextHeight(temp)) div 2;
    w := (Rekt.Right - Rekt.Left - TextWidth(temp)) div 2;
    TextOut(Rekt.Left+w,Rekt.Top+h,temp);
  end;
end;

procedure TfrmMain.ImSpecMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  cb: Integer;
  color: TColor;
  R,G,B: Byte;
begin
  cb := Round(400  + x * (700 - 400) / (ImSpecAbs.Width-1));
  lblnm.Caption  := ' = ' + IntToStr(cb) + ' nm';
  lblTHz.Caption := 'f = ' + IntToStr(Round(WavelengthToFrequency(cb))) + ' THz';
  WavelengthToRGB(cb, R,G,B);
  color := RGB(R,G,B);
  ShapeSpec.Brush.Color := color;
end;

procedure TfrmMain.ChLBClickCheck(Sender: TObject);
var
  i: Integer;
  temp: String;
begin
  temp := GridSpecPSE.HintCell[SpecX,SpecY];
  i := StrToInt(Copy(temp,1,Pos(#32,temp)-1));
  Delete(temp,1,Pos('=',temp));
  UpdateImage(i,Trim(temp),False);
  GridSpecPSE.SetFocus;
end;

procedure TfrmMain.ChLBClick(Sender: TObject);
begin
  ChLB.ClearSelection;
end;

procedure TfrmMain.ZWViewerHotSpotClick(Sender: TObject; const SRC: String;
  var Handled: Boolean);
begin
  Handled := False;
  if (Pos('mailto:',SRC) > 0) or (Pos('http:',SRC) > 0) then
  begin
    ShellExecute(0, nil, @SRC[1], nil, nil, SW_SHOWNORMAL);
    Handled := True;
  end;
end;

procedure TfrmMain.MenuExplClick(Sender: TObject);
begin
  MenuExpl.Checked := not MenuExpl.Checked;
  PosPanels;
  if PanelNukTV.Visible then TVNuk.SetFocus;
  btnTVNukSuch.Enabled := PanelNukTV.Visible or
    ((GridNuk.DefaultColWidth = nukw) and MenuZReihe.Checked and MenuNSpalte.Checked
    or (GridNuk.DefaultColWidth > nukw));
end;

procedure TfrmMain.MenuGridDatClick(Sender: TObject);
begin
  MenuGridDat.Checked := not MenuGridDat.Checked;
  PosPanels;
end;

procedure TfrmMain.btnTVSuchClick(Sender: TObject);
var
  i,i1: Integer;
  c: Char;
  temp,temp1: String;
  tempTV: TTreeView;
begin
  if (Sender as TJvTransparentButton).Name = 'btnTVNukSuch' then
    tempTV := TVNuk else tempTV := TVRad;
  temp := InputBox('Suche Nuklid',
    'Eingabe Beispiele:' +
    #13#10 + 'Uran   oder   92 U   oder   U235   oder   92 U 235' +
    #13#10 + '(Gro�- und Kleinschreibung beachten!)','');
  if Trim(temp) = '' then Exit;
  temp1 := temp; i1 := 0;
  for i := 1 to Length(temp1) do
  begin
    c := temp1[i];
    if IsLower(c) or IsUpper(c) then Inc(i1);
    if not IsDigit(c) and IsDigit(temp1[i+1]) and (i < Length(temp1)) and
      (temp1[i] <> #32) then
    begin
      Insert(#32,temp,i+1);
      Break;
    end;
  end;
  if i1 = 0 then
  begin
    i := StrToInt(temp);
    temp := IntToStr(DM.GetZ(i)) + #32 + DM.GetSymb(i) + #32 + IntToStr(DM.GetA(i));
  end;
  if Trim(temp) <> '' then
    if not TVSuchNuk(tempTV,temp,(Sender as TJvTransparentButton).Name) then
      ShowMessage(''''+temp+''' wurde nicht gefunden!');
end;

procedure TfrmMain.GridRbtnDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var temp: String;
begin
  with GridRbtn do
  begin
    if (ACol = 0) and (ARow = 0) then ClearSelection;
    if Cells[ACol,ARow] <> '' then
    begin
      temp := Cells[ACol,ARow];
      temp := Copy(temp,1,Pos(#32,temp)-1);
      Canvas.Brush.Color := ColorCell[ACol,ARow];
      Canvas.FillRect(Rect);
      MaleZerfall(GridRbtn.Canvas,GridRbtn.Canvas.Font,Rect,temp);
    end;
  end;
end;

procedure TfrmMain.PBSchemaPaint(Sender: TObject);
begin
  PBSchema.Canvas.Draw(bmpl,bmpt,bmpS);
end;

procedure TfrmMain.GridRbtnSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  iza: Integer;
  temp,rt: String;
begin
  CanSelect := False;
  if GridRbtn.ColCount > 1 then
  begin
    iza := DM.GetiZA(TVRad.Selected.Text);
    temp := GridRbtn.Cells[ACol,ARow];
    Delete(temp,1,Pos(#32,temp));
    rt := GridRbtn.HintCell[ACol,ARow];
    if (rt <> FloatToStr(RadTyp)) or (temp <> FloatToStr(DQL)) or
      ((rt <> FloatToStr(RadTyp)) and (temp = '0')) then
    begin
      DQL := StrToFloat(temp);
      RadTyp := StrToFloat(GridRbtn.HintCell[ACol,ARow]);
      Screen.Cursor := crHourGlass;
      MaleSchema(iza,RadTyp,DQL);
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmMain.CBIBClick(Sender: TObject);
var iza: Integer;
begin
  iza := DM.GetiZA(TVRad.Selected.Text);
  Screen.Cursor := crHourGlass;
  MaleSchema(iza,RadTyp,DQL);
  Screen.Cursor := crDefault;
end;

end.
