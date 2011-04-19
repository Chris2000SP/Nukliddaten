unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ToolWin, ComCtrls, Grids, Aligrid, icongrid, Math,
  StdCtrls, Buttons, JvExControls, JvComponent, DB, Types, JvExExtCtrls,
  TeEngine, Series, TeeProcs, Chart, JvgBevel, JvButton, JvTransparentButton,
  JvExComCtrls, JvStatusBar, JvRadioGroup, EasyTable;

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
    PanelTV: TPanel;
    TVNuk: TTreeView;
    Panel1: TPanel;
    GridDaten: TIconGrid;
    CBHalf: TComboBox;
    CBMagig: TCheckBox;
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
    btnTVSort: TJvTransparentButton;
    MenuDecay: TMenuItem;
    PanelTVRad: TPanel;
    TVRad: TTreeView;
    btnRad1: TJvTransparentButton;
    btnRadSort: TJvTransparentButton;
    btnRad2: TJvTransparentButton;
    SBRad: TScrollBox;
    SBGridRad: TScrollBox;
    GridRad: TIconGrid;
    MenuOption: TMenuItem;
    MenuLeg: TMenuItem;
    MenuRadKarte: TMenuItem;
    MenuGridMin: TMenuItem;
    btnBack: TJvTransparentButton;
    SBGridReihe: TScrollBox;
    MnuRef: TMenuItem;
    N2: TMenuItem;
    MnuUpdate: TMenuItem;
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
    procedure CBMagigClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridNukMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PMExplGoNukClick(Sender: TObject);
    procedure btnVorClick(Sender: TObject);
    procedure btnTVSortClick(Sender: TObject);
    procedure GridNukMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PanelLegMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SBNukConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure btnRadClick(Sender: TObject);
    procedure TVRadChange(Sender: TObject; Node: TTreeNode);
    procedure GridReiheDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure MenuOptClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure TVKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
    RGlast,Zx: Integer;
    LongDatum: String;
    //List: TStrings;
  public
    { Public-Deklarationen }
    bDiag,bAbund,bZoom,TvAktiv: Boolean;
    IntRGB,PXneu,PYneu,PXalt,PYalt,MinPosX,MinPosY,AktPosCol,AktPosRow: Integer;
    TVNukIdx,TVRadIdx,bRad: Integer;
    Spalte: String;
    Min,Max: Double;
    VonF,ZuF: TColor;
    PSEF: array[0..17] of TColor;
    NukF: array[0..10] of TColor;
    RadF: array[0..10] of TColor;
    lbl: array[0..17] of TLabel;
    LegShape: array[0..20] of TShape;
    LegLbl: array[0..29] of TLabel;
    //NukList: TStrings;
    PanelMin: TPanel;
    GridMin,GridReihe: TIconGrid;
    procedure AppException(Sender: TObject; E: Exception);
    procedure DisplayHint(Sender: TObject);
    procedure GetAppIcon;
  end;

var
  frmMain: TfrmMain;

implementation

  uses UnitDM, UnitNukFunc, UnitPSE, UnitChart, UnitNuk, UnitAboutBox;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
var i: Integer;
begin
  Application.OnException := AppException;
  Application.OnHint := DisplayHint;
  Application.HintPause := 100;
  KeyPreview := True;
  LongDatum := LongDateFormat;
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
  //NukList := TStringList.Create;
  NukKarteKonf;
  PSEKonf;
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
  bRad := 2;
  PXalt := 1; PYalt := 1; PXneu := 1; PYneu := 1;
  //CBHalf.Items.Add('        gg-uu-gu-ug-Kerne');
  CBHalf.ItemIndex := 0;
  //List := TStringList.Create;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  i: Integer;
  temp: String;
begin
  DatumTimer(Sender);
  if DM.Datengeladen then
  begin
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
      for i := 30 to 51 do
        GridElektron.Cells[i-29,0] := Fields[i].DisplayName;
  end;
  if Screen.Width < 1024 then
    PanelLeg.Left := Self.ClientWidth - PanelLeg.Width-29
  else PanelLeg.Left := Self.ClientWidth - PanelLeg.Width-10;
  PanelLeg.Top := Self.ClientHeight - StatusBar.Height - PanelLeg.Height-29;
  SBNuk.VertScrollBar.Range := 642;
  SBNuk.HorzScrollBar.Range := 899;//939;
  PMenuLeg.Items[1].Visible := False;
  btnRad1.Left := btnRadSort.Left + btnRadSort.Width +
    ((PanelTVRad.ClientWidth - btnRadSort.Width - (btnRad1.Width * 2)) div 2);
  btnRad2.Left := btnRad1.Left + btnRad1.Width;
  //AboutBox.Free;
end;

procedure TfrmMain.DatumTimer(Sender: TObject);
begin
  StatusBar.Panels[1].Text := FormatDateTime(LongDatum, Date);
  StatusBar.Panels[1].Width := StatusBar.Canvas.TextWidth(StatusBar.Panels[1].Text)+20;
  StatusBar.Panels[0].Width := StatusBar.ClientWidth - StatusBar.Panels[1].Width;
end;

procedure TfrmMain.DisplayHint(Sender: TObject);
var temp: String;
begin
  temp := GetLongHint(Application.Hint);
  //if Pos(#13#10,temp) > 0 then
    temp := StringReplace(temp,#13#10,#32,[rfReplaceAll]);
  if Pos(', , ',temp) > 0 then
    temp := StringReplace(temp,', , ',#32,[rfReplaceAll]);
  StatusBar.Panels[0].Text := temp;
end;

procedure TfrmMain.TVNukChange(Sender: TObject; Node: TTreeNode);
var
  iza: Integer;
  temp: String;
begin
  if not TvAktiv then
  begin
    if Node.Level = 0 then
    begin
      temp := DM.GetNukBez(DM.IZAvonZ(IntAusStr(GetKlammer(Node.Text))),True);
      Nukliddaten(temp, True);
    end else Nukliddaten(Node.Text, True);
    if TVNuk.Selected <> nil then
      if TVNuk.Selected.Level = 0 then
      begin
        temp := GetKlammer(TVNuk.Selected.Text);
        temp := Copy(temp,1,Pos(#32,temp)-1);
        iza := DM.IZAvonZ(StrToInt(temp));
        temp := GetKlammer(TVNuk.Selected.Text) + #32 + IntToStr(DM.GetA(iza));
        PMExplGoNuk.Caption := 'Zeige ''' + temp + ''' in Nuklidkarte';
      end
      else
      begin
        PMExplGoNuk.Caption := 'Zeige ''' + TVNuk.Selected.Text + ''' in Nuklidkarte';
        TVNukIdx := Node.AbsoluteIndex;
      end;
  end;
end;

procedure TfrmMain.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  temp: String;
  i,iza: Integer;
begin
  CanSelect := False;
  with (Sender as TIconGrid) do
    if (Name <> 'GridDaten') and (Cells[ACol,ARow] <> '') then
    begin
      if (Name = 'GridPSE') and (ARow > 0) then
      begin
        temp := HintCell[ACol,ARow];
        iza := DM.IZAvonZ(IntAusStr(temp));
        PSEDaten(iza);
        if iza > 0 then
        begin
          PXneu := ACol;
          PYneu := ARow;
          if PXalt = 0 then PXalt := PXneu;
          if PYalt = 0 then PYalt := PYneu;
          Repaint;
        end;
      end
      else if (Name = 'GridReihe') and (ARow = 0) and not btnBack.Visible and
        not btnRad1.Enabled and (GridReihe.ColorCell[ACol,ARow] = clInfoBk) then
      begin
        btnRad1.Enabled := False;
        btnRad2.Enabled := False;
        temp := '';
        for i := 1 to GridReihe.RowCount - 1 do
          temp := temp + GridReihe.Cells[ACol,i] + #13#10;
        ZerfallsreiheDaten(temp);
      end;
    end
    else
      if (Name = 'GridMin') and (GridMin.ColorCell[ACol,ARow] <> GridMin.Color) then
        PosNuk(ACol-4,ARow-4);
end;

procedure TfrmMain.GridShowHintCell(Sender: TObject; col, row: Integer;
  var HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
var i: Integer;
begin
  if ((Sender as TIconGrid).Name = 'GridReihe') and (Pos('Icon',HintStr) = 0) then
  begin
    CanShow := True;
    StatusBar.Panels[0].Text := HintStr;
  end
  else if (Sender as TIconGrid).Name <> 'GridReihe' then
  begin
    CanShow := True;
    StatusBar.Panels[0].Text := HintStr;
  end
  else
  begin
    CanShow := False;
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
    Nukliddaten(HintStr, True);
  end;
  if (HintStr <> '') and ((Sender as TIconGrid).Name = 'GridRad') then
  begin
    i := StrToInt(Copy(HintStr,1,Pos(#32,HintStr)-1));
    if DM.ETName.Locate('Nr',i,[]) then
      StatusBar.Panels[0].Text := HintStr + ' = ' +
        DM.ETName.FieldByName('F2').AsString;// + ' [' +
          //(Sender as TIconGrid).Cells[col,row] + ']';
  end;
  MinPosX := SBNuk.HorzScrollBar.Position;
  MinPosY := SBNuk.VertScrollBar.Position;
end;

procedure TfrmMain.ShowPage(Sender: TObject);
var i: Integer;
begin
  if Sender is TMenuItem then
    i := (Sender as TMenuItem).Tag
  else i := (Sender as TJvTransparentButton).Tag;
  case i of
    1: begin
         PC.ActivePage := TTabSheet(PagePSE);
         MenuPSE.Enabled := False;
         MenuNukKarte.Enabled := True;
         MenuDecay.Enabled := True;
         btnDiagram.Enabled := bDiag;
         if btnNukZoom.Caption = 'verkleinerte Nuklidkarte' then
         begin
           MinPosX := SBNuk.HorzScrollBar.Position;
           MinPosY := SBNuk.VertScrollBar.Position;
         end;
       end;
    2: begin
         PC.ActivePage := TTabSheet(PageKarte);
         MenuPSE.Enabled := True;
         MenuDecay.Enabled := True;
         MenuNukKarte.Enabled := False;
         if btnNukZoom.Caption = 'verkleinerte Nuklidkarte' then
         begin
           SBNuk.HorzScrollBar.Position := MinPosX;
           SBNuk.VertScrollBar.Position := MinPosY;
           pmnuMinGrid.Visible := False;
           MenuGridMin.Enabled := True;
         end else pmnuMinGrid.Visible := True;
         PosPanelLeg;
       end;
    3: if ShowPSEDiagramm(RG.ItemIndex) then
       begin
         if Chart1.Zoomed then btnZoomClick(Sender);
         PC.ActivePage := TTabSheet(PageDiagram);
         SetChartButtons;
       end;
    4: if NukChart(CBHalf.ItemIndex) then
       begin
         if Chart1.Zoomed then btnZoomClick(Sender);
         PC.ActivePage := TTabSheet(PageDiagram);
         SetChartButtons;
         if btnNukZoom.Caption = 'verkleinerte Nuklidkarte' then
         begin
           MinPosX := SBNuk.HorzScrollBar.Position;
           MinPosY := SBNuk.VertScrollBar.Position;
         end;
       end;
    5: begin
         PC.ActivePage := TTabSheet(PageZerfall);
         pmnuMinGrid.Visible := False;
         MenuPSE.Enabled := True;
         MenuNukKarte.Enabled := True;
         MenuDecay.Enabled := False;
         {if MenuRadKarte.Checked then
           SBGridRad.Top := GridReihe.Top + GridReihe.Height;}
         TVRad.SetFocus;
       end;
  end;
  if i <> 2 then MenuGridMin.Enabled := False;
  Caption := 'Nukliddaten: ' + PC.Pages[PC.ActivePageIndex].Caption;
  Application.Title := Caption;
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
        Pen.Color := GridPSE.Color;
        Pen.Style := psSolid;
        MoveTo(Rect.Left-1,Rect.Top);
        LineTo(Rect.Left-1,Rect.Bottom);
        MoveTo(Rect.Left-1,Rect.Top-1);
        LineTo(Rect.Right,Rect.Top-1);
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
  //btnDiagram.Enabled := MnuDiagramm.Enabled;
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
end;

procedure TfrmMain.StopTimer(Sender: TObject);
begin
  if RGlast > 0 then Inc(RGlast);
  if RGlast >= 2 then RGlast := 0;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var i: Integer;
begin
  {if DM.ETName.Locate('Nr',159,[]) then
    if DM.ETName.FieldByName('Land').AsString <> IntToStr(ActPage) then
    begin
      DM.ETName.Edit;
      DM.ETName.FieldByName('Land').AsString := IntToStr(ActPage);
      DM.ETName.Post;
    end;}
  for i := 0 to 17 do
    if i < 11 then
    begin
      LegShape[i].Free;
      LegLbl[i].Free;
      lbl[i].Free;
    end else lbl[i].Free;
  //List.SaveToFile(DM.DataPfad + '\List.txt');
  //List.Free;
  //NukList.Free;
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
begin
  btnPSE.Left := Chart1.Width - btnPSE.Width - 30;
  btnPSE.Top := Chart1.Top + Chart1.Height - btnPSE.Height - 10;
  btnMarks.Top := btnPSE.Top;
  btnMarks.Left := Chart1.Left + 30;
  btnZoom.Top := btnMarks.Top;
  btnZoom.Left := btnMarks.Left + btnMarks.Width + 10;
  btnAbund.Top := btnMarks.Top;
  btnAbund.Left := btnPSE.Left - btnAbund.Width - 10;
  btnRad1.Left := btnRadSort.Left + btnRadSort.Width +
    ((PanelTVRad.ClientWidth - btnRadSort.Width - (btnRad1.Width * 2)) div 2);
  btnRad2.Left := btnRad1.Left + btnRad1.Width;
  if PC.ActivePageIndex = 1 then PosPanelLeg;
  PanelIso.Left := 50;
  PanelIso.Top := 220;
  PanelProton.Top := 330;
  PanelProton.Left := 20;
  //Caption := 'H: ' + IntToStr(Height) + ', W: ' + IntToStr(Width);
end;

procedure TfrmMain.AppException(Sender: TObject; E: Exception);
begin
  if Pos('TEasy',E.Message) > 0 then
  begin
    ShowMessage('Die Datenbank konnte nicht ge�ffnet werden!');
    Application.Terminate;
  end else Application.ShowException(E);;
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
  else MarkText := MarkText + #13#10 + IntToStr(ValueIndex+1) + #32 + 
    DM.GetSymb(DM.IZAvonZ(ValueIndex+1));
end;

procedure TfrmMain.btnZoomClick(Sender: TObject);
begin
  {if Chart1.Zoomed then
  begin
    Chart1.UndoZoom;
    btnZoom.Caption := 'Lupe Hilfe';
  end
  else
    ShowMessage('Um Bereiche des Diagramms detailliert zu betrachten' + #13#10 +
                'ziehen Sie einfach mit gedr�ckter linker Maustaste' + #13#10 +
                'einen beliebigen Bereich im Diagramm nach rechts' + #13#10 +
                'unten und lassen die Maustaste wieder los.' + #13#10 + #13#10 +
                'Mit den Buttom ''Lupe r�ckg�ngig'' k�nnen Sie wieder' + #13#10 +
                'das komplette Diagramm herstellen.');}
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
      btnAbund.Caption := 'Massenanteil'
    else btnAbund.Caption := 'Nat�rliche H�ufigkeit';
    ShowPSEDiagramm(6);
  end
  else
  begin
    if not bAbund then
      btnAbund.Caption := 'Alle Isotope'
    else btnAbund.Caption := 'Nur nat�rl. Nuklide';
    NukChart(CBHalf.ItemIndex);
  end;
end;

procedure TfrmMain.MnuHelpClick(Sender: TObject);
begin
  case (Sender as TMenuItem).Tag of
    6: begin
         if (PC.ActivePage = PagePSE) and AboutBox.HelpPSE then AboutBox.Show;
         if (PC.ActivePage = PageKarte) and AboutBox.HelpKarte then AboutBox.Show;
         if (PC.ActivePage = PageZerfall) and AboutBox.HelpRad then AboutBox.Show;
       end;
    7: if AboutBox.Ref then AboutBox.Show;
    8: if AboutBox.Upd then AboutBox.Show;
    9: if AboutBox.AppAbout then AboutBox.Show;
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
  //Stream: TStream;
begin
  with GridNuk.Canvas do
  begin
    Rekt := Rect;
    Rekt.Bottom := Rect.Bottom - 1;
    Rekt.Right := Rect.Right - 1;
    h := Rect.Right - Rect.Left;
    w := Rect.Bottom - Rect.Top;
    Pen.Color := clBlack;
    Pen.Width := 1;
    if (ACol = 30) and (ARow = 120) and (GridNuk.DefaultColWidth = 5) then
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
    if (GridNuk.DefaultColWidth = 5) and not GridNuk.DefaultDrawing then
    begin
      Brush.Color := GridNuk.ColorCell[Acol,Arow];
      FillRect(Rect);
    end;
    if (GridNuk.DefaultColWidth > 5) and (GridNuk.HintCell[ACol,ARow] <> '') then
    begin
      Bmp := TBitmap.Create;
      Bmp.Width := w;
      temp := GridNuk.HintCell[ACol,ARow];
      z := Trim(Copy(temp,1,Pos(#32,temp)));
      Delete(temp,1,Pos(#32,temp));
      a := IntToStr(IntAusStr(temp));
      symb := Trim(Copy(temp,1,Pos(#32,temp)));
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
        Font.Size := 7;
        case CBHalf.ItemIndex of
          1: a := DM.GetDaten(z,a,'Tsek',True,0);
          2: a := DM.GetDaten(z,a,'BE',False,0);
          3: a := DM.GetDaten(z,a,'MassExc',False,0);
          4: a := DM.GetDaten(z,a,'Sn',False,0);
          5: a := DM.GetDaten(z,a,'Sp',False,0);
        end;
        if a <> '' then
        begin
          tw := (w - TextWidth(a)) div 2;
          th := (h-y-TextHeight('I')) div 2;
          TextOut(Rect.Left + tw,Rect.Top+y+th,a);
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
          PicRTyp(temp,Font,Bmp);
          Draw(Rekt.Left,Rect.Top+th,Bmp);
        finally
          Bmp.Free;
        end;
      end;
    end;
    if CBMagig.Checked and (GridNuk.DefaultColWidth = 5) then
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
    end;
    Brush.Style := bsSolid;
  end;
end;

procedure TfrmMain.btnNukZoomClick(Sender: TObject);
begin
  if Trim(btnNukZoom.Caption) = 'Nuklidkarte vergr��ern' then
  begin
    btnNukZoom.Caption := 'verkleinerte Nuklidkarte';
    PanelMin.Visible := True;
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
    CBMagig.Enabled := False;
    MenuGridMin.Enabled := True;
  end
  else
  begin
    MinPosX := SBNuk.HorzScrollBar.Position;
    MinPosY := SBNuk.VertScrollBar.Position;
    btnNukZoom.Caption := 'Nuklidkarte vergr��ern';
    PanelMin.Visible := False;
    pmnuMinGrid.Visible := False;
    PMExpl.AutoPopup := False;
    GridNuk.DefaultColWidth := 5;
    GridNuk.DefaultRowHeight := 5;
    SBNuk.VertScrollBar.Range := 642;
    SBNuk.HorzScrollBar.Range := 899;//939;
    SBNuk.HorzScrollBar.Position := 0;
    SBNuk.HorzScrollBar.Increment := 8;
    SBNuk.VertScrollBar.Increment := 8;
    Image1.Visible := True;
    Image2.Visible := True;
    CBMagig.Enabled := True;
    MenuGridMin.Enabled := False;
  end;
  GridNuk.Repaint;
  PosPanelLeg;
end;

procedure TfrmMain.CBHalfChange(Sender: TObject);
begin
  SetNukLeg(CBHalf.ItemIndex);
  case CBHalf.ItemIndex of
    1..5: btnNukDiag.Enabled := True;
  else btnNukDiag.Enabled := False;
  end;
  LeseNukKarte;
end;

procedure TfrmMain.CBMagigClick(Sender: TObject);
begin
  if (GridNuk.DefaultColWidth = 5) then CBHalfChange(Sender);
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 112 then
  begin
    if (PC.ActivePage = PagePSE) and AboutBox.HelpPSE then AboutBox.Show;
    if (PC.ActivePage = PageKarte) and AboutBox.HelpKarte then AboutBox.Show;
    if (PC.ActivePage = PageZerfall) and AboutBox.HelpRad then AboutBox.Show;
  end;
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
    (GridNuk.DefaultColWidth > 5) then
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
var col,row: Integer;
begin
  if GridNuk.DefaultColWidth > 10 then
  begin
    col := SBNuk.HorzScrollBar.Position div SBNuk.HorzScrollBar.Increment;
    row := SBNuk.VertScrollBar.Position div SBNuk.VertScrollBar.Increment;
    GridAktPos(col+7,row+5);
  end;
end;

procedure TfrmMain.btnRadClick(Sender: TObject);
var i: Integer;
begin
  (Sender as TJvTransparentButton).Enabled := False;
  Screen.Cursor := crHourGlass;
  if (Sender as TJvTransparentButton).Tag = 1 then
  begin
    i := DM.GetiZA(TVRad.Items[TVRadIdx].Text);
    if ClearGridRad then RadReihe(i);
    bRad := 2;
  end
  else
  begin
    for i := 0 to GridReihe.ColCount-1 do
    begin
      GridReihe.HintCell[i,0] := '';
      GridReihe.ColorCell[i,0] := $00FFFFCC;
    end;
    RadAlle;
    bRad := 1;
  end;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.TVRadChange(Sender: TObject; Node: TTreeNode);
var iza: Integer;
begin
  if Node.Selected and (Node.Level > 0) then
  begin
    TVRadIdx := Node.AbsoluteIndex;
    iza := DM.GetiZA(Node.Text);
    Screen.Cursor := crHourGlass;
    if ClearGridRad and RadReihe(iza) then
    begin
      if btnBack.Visible then
      begin
        PosGridReihe(MenuRadKarte.Checked);
        btnBack.Visible := False;
      end;
    end;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.GridReiheDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  function isSymF(txt: String): Boolean;
  begin
    Result := (Pos('a',txt) > 0) or (Pos('b',txt) > 0) or (Pos('ec',txt) > 0);
  end;
var
  i,th,tw,h,w: Integer;
  temp,temp1,temp2,temp3: String;
  bc: TColor;
  Icon: TIcon;
  Bmp: TBitmap;
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
    {else if not btnRad2.Enabled then
      th := (h - (TextHeight(GridReihe.Cells[ACol,ARow]) * 2)) div 2}
    else th := 0;
    tw := (w - TextWidth(GridReihe.Cells[ACol,ARow])) div 2;
    Font.Color := KontrastFarbe(GridReihe.ColorCell[ACol,ARow],0);
    FillRect(Rekt);
    if not btnBack.Visible then
    begin
      if GridReihe.HintCell[ACol,ARow] = 'Icon' then
      begin
        temp1 := GridReihe.Cells[ACol,ARow];
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
              Font.Name := 'Arial';
              Font.Size := 8;
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
            Font.Name := 'Arial';
            Font.Size := 8;
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
            Font.Name := 'Arial';
            Font.Size := 8;
            TextOut(Rekt.Left+tw+2,Rekt.Top+th,temp3);
          end
          else
          begin
            Font.Size := 8;
            TextOut(Rekt.Left+2,Rekt.Top+th,temp1);
          end;
        end
        else
        begin
          Font.Charset := ANSI_CHARSET;
          Font.Name := 'Arial';
          Font.Size := 8;
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
      else if (ARow = 0) and (Pos('Zerfall',GridReihe.Cells[ACol,ARow]) > 0) then
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
        if Pos('[',GridReihe.Cells[ACol,ARow]) > 0 then  // Alle Rads
        begin
          temp1 := GridReihe.Cells[ACol,ARow];
          Delete(temp1,1,Pos('[',temp1));
          Delete(temp1,Pos(']',temp1),1);
          temp := GridReihe.Cells[ACol,ARow];
          temp := Copy(temp,1,Pos('[',temp)-1);
          i := DM.RTypFarbe(DM.GetiZA(temp),DM.RadFarbNr(Brush.Color));
          if (i > 0) and (i <> DM.RadFarbNr(Brush.Color)) then
          begin
            bc := Brush.Color;
            NukEck(GridReihe.Canvas,Rekt,0,RadF[i]);
            Brush.Color := bc;
          end;
          DM.RTypPlus(DM.GetiZA(temp),i,DM.RadFarbNr(Brush.Color),Rekt,GridReihe.Canvas);
          Brush.Style := bsClear;
          tw := (w - TextWidth(temp)) div 2;
          TextOut(Rekt.Left+tw,Rekt.Top+th,temp);
          Bmp := TBitmap.Create;
          try
            Bmp.Canvas.Brush.Color := Brush.Color;
            Bmp.TransparentColor := Brush.Color;
            Bmp.Transparent := True;
            Bmp.TransparentMode := tmAuto;
            Bmp.Width := w;
            Font.Size := 7;
            Font.Style := [];
            th := th + TextHeight(temp);
            Bmp.Height := Rekt.Bottom-Rekt.Top-th;
            PicRTyp(temp1,Font,Bmp);
            Draw(Rekt.Left,Rekt.Top+th,Bmp);
          finally
            Bmp.Free;
          end;
        end
        else
        begin
          TextOut(Rekt.Left+tw,Rekt.Top+th,GridReihe.Cells[ACol,ARow]);
          if not btnRad2.Enabled and (GridReihe.ColorCell[ACol,ARow] = clBlack) then
          begin
            Font.Style := [];
            temp := 'stabil';
            tw := (w - TextWidth(temp)) div 2;
            th := (h - th - TextHeight(temp)) div 2;
            TextOut(Rekt.Left+tw,Rekt.Top+th,temp);
          end;
        end;
      end;
      Pen.Color := GridReihe.Color;
      MoveTo(Rekt.Right,Rekt.Top);
      LineTo(Rekt.Right,Rekt.Bottom);
      if ((ARow > 1) and (ARow mod 2 = 0)) or btnRad1.Enabled then
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
      if (ACol = 1) and (ARow > 0) and isSymF(temp1) then
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
          Font.Name := 'Arial';
          Font.Size := 8;
          TextOut(Rekt.Left+tw,Rekt.Top+th-2,temp3);
        end
        else
        begin
          Font.Size := 8;
          TextOut(Rekt.Left+tw,Rekt.Top+th-2,temp1);
        end;
      end else TextOut(Rekt.Left+tw,Rekt.Top+th,GridReihe.Cells[ACol,ARow]);
      Pen.Color := clGray;
      MoveTo(Rekt.Right,Rekt.Top);
      LineTo(Rekt.Right,Rekt.Bottom);
      MoveTo(Rekt.Left,Rekt.Bottom-1);
      LineTo(Rekt.Right,Rekt.Bottom-1);
    end;
  end;
end;

procedure TfrmMain.MenuOptClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
  case (Sender as TMenuItem).Tag of
    1: PanelLeg.Visible := (Sender as TMenuItem).Checked;
    2: PanelMin.Visible := (Sender as TMenuItem).Checked;
    3: PosGridReihe((Sender as TMenuItem).Checked);
  end;
end;

procedure TfrmMain.btnBackClick(Sender: TObject);
var iza: Integer;
begin
  if TVRad.Selected.Level > 0 then
  begin
    Screen.Cursor := crHourGlass;
    if TVRad.Selected.Level > 0 then
      iza := DM.GetiZA(TVRad.Selected.Text)
    else iza := DM.GetiZA(TVRad.Items[TVRadIdx].Text);
    if ClearGridRad then RadReihe(iza);
    Screen.Cursor := crDefault;
  end;
  PosGridReihe(MenuRadKarte.Checked);
  TVRad.SetFocus;
  if TVRad.Selected.Level = 0 then
  begin
    if not TVRad.Items[TVRadIdx].Parent.Expanded then
      TVRad.Items[TVRadIdx].Parent.Expand(False);
    TVRad.Items[TVRadIdx].Selected := True;
  end;
  if bRad = 1 then
    btnRad1.Enabled := True
  else btnRad2.Enabled := True;
  frmMain.btnBack.Visible := False;
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
      if Selected.Level = 1 then
        if (Name = 'TVNuk') and (GridNuk.DefaultColWidth > 10) then
          PMExplGoNukClick(Sender);
    end;
  end;
end;

end.