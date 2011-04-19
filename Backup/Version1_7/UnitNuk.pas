unit UnitNuk;

interface

uses Windows, Types, SysUtils, Classes, Math, Graphics, Grids, Aligrid, icongrid,
     DB, ExtCtrls, Controls, StdCtrls, ComCtrls, Dialogs, Variants, Forms;

  function  ClearGridRad: Boolean;
  function  ClearGridRadDat: Boolean;
  function  ClearGridReihe(Erste: Boolean): Boolean;
  procedure GridAktPos(xCol,xRow: Integer);
  function  LeseNukExplorer(TV: TTreeView;idx: Integer;Start: Boolean): Boolean;
  function  LeseNukKarte: Boolean;
  procedure Nukliddaten(Symbol: String;Wahr: Boolean);
  procedure NukEck(Canv: TCanvas;R: TRect;Typ: Integer;Farbe: TColor);
  procedure NukKarteKonf;
  procedure PosGridReihe(Allein: Boolean);
  procedure PosGridRadScrollbar(iZA: Integer);
  procedure PosNuk(Col,Row: Integer);
  procedure PosNukReihe(Col,Row: Integer;Alle: Boolean);
  procedure PosPanelLeg;
  procedure RadAlle;
  function  RadBack(iZA: Integer): Boolean;
  function  RadBackAlle(iZA: Integer): Boolean;
  function  RadDaten(txt: String): Boolean;
  function  RadGridAlle: Boolean;
  function  RadReihe(iZA: Integer): Boolean;
  function  SetRadAlle(minn,maxn,minz,maxz: Integer): Boolean;
  function  SetNukLeg(idx: Integer): Boolean;
  procedure ZerfallsreiheDaten(txt: String);

implementation

uses UnitMain, UnitDM, UnitNukFunc, EasyTable;

function ClearGridRad: Boolean;
var
  i,i1,n,z: Integer;
  temp: String;
begin
  with frmMain.GridRad do
  begin
    for i := 0 to ColCount - 1 do
      for i1 := 0 to RowCount - 1 do
      begin
        Cells[i,i1] := '';
        HintCell[i,i1] := '';
      end;
    DM.ETNukl.First;
    while not DM.ETNukl.Eof do
    begin
      if DM.ETNukl.FieldByName('iZA').AsInteger mod 10 = 0 then
      begin
        z := DM.GetZ(DM.ETNukl.FieldByName('iZA').AsInteger);
        n := DM.GetN(DM.ETNukl.FieldByName('iZA').AsInteger);
        temp := DM.GetSymb(DM.ETNukl.FieldByName('iZA').AsInteger);
        if DM.ETNukl.FieldByName('Tsek').AsFloat = -99 then
          ColorCell[n+1,RowCount-z-1] := clBtnFace
        else ColorCell[n+1,RowCount-z-1] := clWhite;
      end;
      DM.ETNukl.Next;
    end;
  end;
  Result := ClearGridReihe(False);
end;

function  ClearGridRadDat: Boolean;
var i,i1: Integer;
begin
  for i := 1 to 7 do
    for i1 := 0 to 2 do
    begin
      frmMain.GridRadDat.ColorCell[i1,i] := clInfoBk;
      frmMain.GridRadDat.Cells[i1,i] := '';
    end;
  Result := True;
end;

function  ClearGridReihe(Erste: Boolean): Boolean;
var i,i1: Integer;
begin
  with frmMain.GridReihe do
  begin
    for i := 0 to ColCount - 1 do
        for i1 := 0 to RowCount - 1 do
        begin
          Cells[i,i1] := '';
          HintCell[i,i1] := '';
          if Erste then ColorCell[i,i1] := $00FFFFCC;
          if not Erste and (i1 > 0) then ColorCell[i,i1] := $00FFFFCC;
        end;
    ColCount := 1;
    RowCount := 3;
  end;
  Result := True;
end;

procedure GridAktPos(xCol,xRow: Integer);
var i,i1,c,r: Integer;
begin
  if xCol < 6 then c := 6              // Cols: 189, Rows: 125
  else if xCol > 173 then c := 173     // Min:  n+5,rows-z-3
  else c := xCol;                      // Grid: n+1,rows-z-6
  if xRow < 6 then r := 6              // MaxZ: 118, MaxN: 176, A:293
  else if xRow > 114 then r := 114
  else r := xRow;
  with frmMain.GridMin do
  begin
    for i := 0 to ColCount - 1 do
      for i1 := 0 to RowCount - 1 do
      begin
        if (ColorCell[i,i1] <> Color) and
           (ColorCell[i,i1] <> frmMain.GridNuk.ColorCell[i-4,i1-4]) then
           ColorCell[i,i1] := frmMain.GridNuk.ColorCell[i-4,i1-4];
        if i = 3 then ColorCell[i,i1] := Color;
      end;
    for i := c-7 to c+7 do
      for i1 := r-7 to r+7 do
      begin
        if i1 = r-7 then ColorCell[i+4,i1+4] := clGray; // horizontal oben
        if i = c-7 then ColorCell[i+4,i1+4] := clGray;  // vertikal links
        if i1 = r+7 then ColorCell[i+4,i1+4] := clGray; // horizontal unten
        if i = c+7 then ColorCell[i+4,i1+4] := clGray;  // vertikal rechts
      end;
  end;
  frmMain.AktPosCol := xCol;
  frmMain.AktPosRow := xRow;
end;

function LeseNukExplorer(TV: TTreeView;idx: Integer;Start: Boolean): Boolean;
var
  i,iza,tvri: Integer;
  temp,Symbol,von,bis,m: String;
  TNode1,TNode2,TNode3,TNode4: TTreeNode;
begin
  with DM.ETNukl do
  begin
    tvri := 0;
    TV.Items.Clear;
    if Start then frmMain.TVRad.Items.Clear;
    DisableControls;
    First;
    Next;
    temp := '';
    Symbol := '';
    DM.ETChem.First;
    while not DM.ETChem.Eof do
    begin
      iza := DM.ETChem.FieldByName('iZA').AsInteger;
      Symbol := DM.GetSymb(iza);
      temp := DM.NukName(Symbol)+' ('+IntToStr(DM.GetZ(iza))+#32+Symbol+')';
      TNode1 := TV.Items.Add(nil,temp);
      TNode1.ImageIndex := DM.ILFlag.Count - 1;
      TNode1.StateIndex := -1;
      TNode1.SelectedIndex := TNode1.ImageIndex;
      if Start then
      begin
        TNode3 := frmMain.TVRad.Items.Add(nil,temp);
        TNode3.ImageIndex := DM.ILFlag.Count - 1;
        TNode3.StateIndex := -1;
        TNode3.SelectedIndex := TNode3.ImageIndex;
      end else TNode3 := nil;
      von := IntToStr(DM.GetZ(iza)) + '0000';
      bis := IntToStr(DM.GetZ(iza)) + '9990';
      Filter := '(iZA > ' + von + ') AND (iZA < ' + bis + ')';
      if FindFirst then
      repeat
        i := FieldByName('iZA').AsInteger;
        if TV.Tag > 0 then
        begin
          if i mod 10 > 0 then
          begin
            if i mod 10 > 1 then m := IntToStr(i mod 10) else m := '';
            temp := IntToStr(DM.GetZ(i)) + #32 + Symbol + #32 +
              IntToStr(DM.GetA(i)) + 'm' + m;
            TNode2 := TV.Items.AddChild(TNode1,temp);
            if FieldByName('Tsek').AsFloat = -99 then
              TNode2.ImageIndex := 13//DM.ILFlag.Count - 1
            else TNode2.ImageIndex := 12;
            TNode2.StateIndex := - 1;
            TNode2.SelectedIndex := TNode2.ImageIndex;
          end
          else if i <> 30030 then
          begin
            temp := IntToStr(DM.GetZ(i))+#32+Symbol+#32+IntToStr(DM.GetA(i));
            TNode2 := TV.Items.AddChild(TNode1,temp);
            if FieldByName('Tsek').AsFloat = -99 then
              TNode2.ImageIndex := 13//DM.ILFlag.Count - 1
            else TNode2.ImageIndex := 12;
            TNode2.StateIndex := - 1;
            TNode2.SelectedIndex := TNode2.ImageIndex;
          end;
        end
        else if (i mod 10 = 0) then
        begin
          temp := IntToStr(DM.GetZ(i))+#32+Symbol+#32+IntToStr(DM.GetA(i));
          TNode2 := TV.Items.AddChild(TNode1,temp);
          if FieldByName('Tsek').AsFloat = -99 then
            TNode2.ImageIndex := 13//DM.ILFlag.Count - 1
          else TNode2.ImageIndex := 12;
          TNode2.StateIndex := - 1;
          TNode2.SelectedIndex := TNode2.ImageIndex;
        end;
        if Start and (i <> 30030) then
        begin
          if (i mod 10 > 0) then
          begin
            if i mod 10 > 1 then m := IntToStr(i mod 10) else m := '';
            temp := IntToStr(DM.GetZ(i)) + #32 + Symbol + #32 +
              IntToStr(DM.GetA(i)) + 'm' + m;
          end
          else temp := IntToStr(DM.GetZ(i))+#32+Symbol+#32+IntToStr(DM.GetA(i));
          TNode4 := frmMain.TVRad.Items.AddChild(TNode3,temp);
          if FieldByName('Tsek').AsFloat = -99 then
            TNode4.ImageIndex := 13//DM.ILFlag.Count - 1
          else TNode4.ImageIndex := 12;
          TNode4.StateIndex := - 1;
          TNode4.SelectedIndex := TNode4.ImageIndex;
          if i = 791690 then tvri := frmMain.TVRad.Items.Count - 1;
        end;
      until FindNext = False;
      Filter := '';
      DM.ETChem.Next;
    end;
    EnableControls;
  end;
  frmMain.TvAktiv := False;
  if Start then
  begin
    frmMain.TVNuk.Items[0].Expand(False);
    frmMain.TVNuk.Items[1].Selected := True;
    frmMain.TVRad.Items[tvri].Parent.Expand(False);
    frmMain.TVRad.Items[tvri].Selected := True;
  end
  else if idx > 0 then
  begin
    TV.Items[idx].Parent.Expand(False);
    TV.Items[idx].Selected := True;
  end;
  Result := True;
end;

function  LeseNukKarte: Boolean;
var
  i,z,n,r,a,rows: Integer;
  d: Double;
begin
  rows := frmMain.GridNuk.RowCount;
  DM.ETName.DisableControls;
  with DM.ETNukl do
  begin
    DisableControls;
    First;
    while not Eof do
    begin
      i := FieldByName('iZA').AsInteger;
      z := DM.GetZ(i);
      n := DM.GetN(i);
      a := DM.GetA(i);
      if (i mod 10 = 0) or (i = 1) then
      begin
        case frmMain.CBHalf.ItemIndex of
          1: d := FieldByName('Tsek').AsFloat;
          2: d := FieldByName('BE').AsFloat;
          3: d := FieldByName('MassExc').AsFloat;
          4: d := FieldByName('Sn').AsFloat;
          5: d := FieldByName('Sp').AsFloat;
        else d := FieldByName('Tsek').AsFloat;
        end;
        if frmMain.CBHalf.ItemIndex = 0 then
        begin
          if (d = -99) then r := 10  // or (d > Power(10,15))
          else if FieldByName('Max_RTyp').AsInteger > 0 then
            r := FieldByName('Max_RTyp').AsInteger
          else r := 0;
        end
        else if frmMain.CBHalf.ItemIndex = 1 then
        begin
          if (d = -99) or (d > Power(10,15)) then r := 10
          else if d = 0 then r := 0
          else if d > Power(10,10) then r := 1
          else if d > Power(10,5) then r := 2
          else if d > Power(10,3) then r := 3
          else if d > Power(10,1) then r := 4
          else if d > Power(10,-1) then r := 5
          else if d > Power(10,-3) then r := 6
          else if d > Power(10,-7) then r := 7
          else if d >= Power(10,-15) then r := 8
          else if d < Power(10,-15) then r := 9
          else r := 0;
        end
        else if frmMain.CBHalf.ItemIndex = 2 then// Bindungsenergie
        begin
          if (d > 9000) then r := 10
          else if (d > 8700) and (d < 9000) then r := 1
          else if (d > 8600) and (d < 8700) then r := 2
          else if (d > 8500) and (d < 8600) then r := 3
          else if (d > 8400) and (d < 8500) then r := 4
          else if (d > 8200) and (d < 8400) then r := 5
          else if (d > 7600) and (d < 8200) then r := 6
          else if (d > 6600) and (d < 7600) then r := 7
          else if (d > 5000) and (d < 6600) then r := 8
          else if (d > 0) and (d < 5000) then r := 9
          else r := 0;
        end
        else if frmMain.CBHalf.ItemIndex = 3 then// Mass Excess
        begin
          if (d > 199000) then r := 10
          else if (d > 175000) and (d <= 199000) then r := 1
          else if (d > 150000) and (d <= 175000) then r := 2
          else if (d > 125000) and (d <= 150000) then r := 3
          else if (d > 0) and (d <= 125000) then r := 4
          else if (d < 0) and (d > -25000) then r := 5
          else if (d <= -25000) and (d > -50000) then r := 6
          else if (d <= -50000) and (d > -75000) then r := 7
          else if (d <= -75000) and (d > -95000) then r := 8
          else if d < -95000 then r := 9
          else r := 0;
        end
        else if frmMain.CBHalf.ItemIndex = 4 then// Neutron Seperationsenergie
        begin
          if (d > 28000) then r := 10
          else if (d > 25000) and (d <= 28000) then r := 1
          else if (d > 20000) and (d <= 25000) then r := 2
          else if (d > 15000) and (d <= 20000) then r := 3
          else if (d > 10000) and (d <= 15000) then r := 4
          else if (d > 5000) and (d <= 10000) then r := 5
          else if (d > 0) and (d <= 5000) then r := 6
          else if (d < 0) and (d > -1000) then r := 7
          else if (d <= -1000) and (d > -2000) then r := 8
          else if d < -2000 then r := 9
          else r := 0;
        end
        else if frmMain.CBHalf.ItemIndex = 5 then// Proton Seperationsenergie
        begin
          if (d > 30000) then r := 10
          else if (d > 25000) and (d <= 30000) then r := 1
          else if (d > 20000) and (d <= 25000) then r := 2
          else if (d > 15000) and (d <= 20000) then r := 3
          else if (d > 10000) and (d <= 15000) then r := 4
          else if (d > 5000) and (d <= 10000) then r := 5
          else if (d > 0) and (d <= 5000) then r := 6
          else if (d < 0) and (d > -2500) then r := 7
          else if (d <= -2500) and (d > -5000) then r := 8
          else if d < -5000 then r := 9
          else r := 0;
        end
        else if frmMain.CBHalf.ItemIndex = 6 then// gg-uu-Kerne
        begin
          if (z = n) and (z mod 2 = 0) then r := 10
          else if (z = n) and (z mod 2 = 1) then r := 1
          else if (z mod 2 = 0) and (n mod 2 = 0) and (a mod 2 = 0) then r := 2 // gg und gA
          else if (z mod 2 = 0) and (n mod 2 = 0) and (a mod 2 = 1) then r := 3 // gg und uA
          else if (z mod 2 = 1) and (n mod 2 = 1) and (a mod 2 = 0) then r := 4 // uu und gA
          else if (z mod 2 = 1) and (n mod 2 = 1) and (a mod 2 = 1) then r := 5 // uu und uA
          else if (z mod 2 = 0) and (n mod 2 = 1) and (a mod 2 = 0) then r := 6 // gu und gA
          else if (z mod 2 = 0) and (n mod 2 = 1) and (a mod 2 = 1) then r := 7 // gu und uA
          else if (z mod 2 = 1) and (n mod 2 = 0) and (a mod 2 = 0) then r := 8 // ug und gA
          else if (z mod 2 = 1) and (n mod 2 = 0) and (a mod 2 = 1) then r := 9 // ug und uA
          else r := 0;
        end else r := 0;
        frmMain.GridNuk.ColorCell[n+1,rows-z-6] := frmMain.NukF[r];
        frmMain.GridMin.ColorCell[n+5,rows-z-3] := frmMain.NukF[r];
        frmMain.GridNuk.HintCell[n+1,rows-z-6] := IntToStr(DM.GetZ(i)) +
          #32 + DM.GetSymb(i) + #32 + IntToStr(DM.GetA(i));
        frmMain.GridMin.HintCell[n+5,rows-z-3] := '     ' +
          frmMain.GridNuk.HintCell[n+1,rows-z-6];
      end;
      Next;
    end;
    EnableControls;
  end;
  DM.ETName.EnableControls;
  Result := True;
end;

procedure NukEck(Canv: TCanvas;R: TRect;Typ: Integer;Farbe: TColor);
var
  x,y,z: TPoint;
  fc: TColor;
begin
  with Canv do
  begin
    fc := Brush.Color;
    case Typ of
      1: begin     // Dreick links oben
           x := R.TopLeft;
           y.X := R.Left;
           y.Y := R.Top+11;
           z.X := R.Left+11;
           z.Y := R.Top;
         end;
      2: begin     // Dreick rechts unten
           x.X := R.Right-1;
           x.Y := R.Bottom-11;
           y.X := R.Right-11;
           y.Y := R.Bottom-1;
           z.X := R.Right-1;
           z.Y := R.Bottom-1;
         end;
      3: begin     // Dreick rechts oben
           x.X := R.Right-11;
           x.Y := R.Top;
           y.X := R.Right-1;
           y.Y := R.Top;
           z.X := R.Right-1;
           z.Y := R.Top+11;
         end;
      4: begin     // Dreick links unten
           x.X := R.Left;
           x.Y := R.Bottom-11;
           y.X := R.Left;
           y.Y := R.Bottom-1;
           z.X := R.Left+11;
           z.Y := R.Bottom-1;
         end;
    else begin     // Dreick halb unten
           x.X := R.Right-1;
           x.Y := R.Top;
           y.X := R.Left;
           y.Y := R.Bottom-1;
           z.X := R.Right-1;
           z.Y := R.Bottom-1;
         end;
    end;
    Brush.Color := Farbe;
    Pen.Color := Farbe;
    Polygon([x,y,z]);
    Brush.Color := fc;
  end;
end;

procedure NukKarteKonf;
var i: Integer;
begin
  with frmMain do
  begin
    PanelZoom.Parent := PC.Pages[1];
    PanelZoom.Font.Style := [];
    PanelZoom.Left := PanelTV.Width+2;
    PanelZoom.Top := 2;
    PanelMin := TPanel.Create(PC.Pages[1]);
    PanelMin.Parent := PC.Pages[1];
    PanelMin.Top := PanelZoom.Top + PanelZoom.Height;
    PanelMin.Left := PanelZoom.Left;
    PanelMin.Width := PanelZoom.Width;
    PanelMin.Height := PanelMin.Width-60;
    GridMin := TIconGrid.Create(PanelMin);
    GridMin.Name := 'GridMin';
    GridMin.Parent := PanelMin;
    GridMin.Align := alClient;
    GridMin.ColCount := GridNuk.ColCount;
    GridMin.RowCount := GridNuk.RowCount+1;
    GridMin.GridLineWidth := 0;
    GridMin.DefaultColWidth := 1;
    GridMin.DefaultRowHeight := 1;
    GridMin.Color := $00FFFFCC;
    GridMin.ScrollBars := ssNone;
    GridMin.DrawSelection := False;
    GridMin.OnSelectCell := GridSelectCell;
    GridMin.OnMouseMove := GridNukMouseMove;
    GridMin.Hint := 'Klicken sie innerhalb der Mini-Nuklidkarte auf ein Nuklid';
    GridMin.PopupMenu := PMenuLeg;
    GridMin.ShowCellHints := True;
    PanelTVRad := TPanel.Create(PC.Pages[3]);
    PanelTVRad.Parent := PC.Pages[3];
    PanelTVRad.Width := 218;
    PanelTVRad.BorderStyle := bsNone;
    PanelTVRad.BevelInner := bvNone;
    PanelTVRad.BevelOuter := bvNone;
    PanelTVRad.Align := alLeft;
    PanelTVRad.Color := $00FFFFCC;
    GridRadDat := TIconGrid.Create(PanelTVRad);
    GridRadDat.Name := 'GridRadDat';
    GridRadDat.Parent := PanelTVRad;
    GridRadDat.Align := alTop;
    GridRadDat.ColCount := 3;
    GridRadDat.RowCount := 8;
    GridRadDat.DefaultRowHeight := 18;
    GridRadDat.Alignment := alCenter;
    GridRadDat.Height := 155;
    GridRadDat.ScrollBars := ssNone;
    GridRadDat.DrawSelection := False;
    GridRadDat.ShowHint := False;
    GridRadDat.ShowCellHints := False;
    GridRadDat.FixedCols := 0;
    GridRadDat.FixedRows := 1;
    GridRadDat.FixedColor := $00FFFFCC;
    GridRadDat.FixedRowFont[0].Style := [fsBold];
    GridRadDat.FixedRowFont[0].Color := clNavy;
    GridRadDat.Color := clInfoBk;
    GridRadDat.Font.Style := [fsBold];
    GridRadDat.ColWidths[0] := 76;
    GridRadDat.ColWidths[1] := 65;
    GridRadDat.ColWidths[2] := 70;
    GridRadDat.Cells[0,0] := 'Zerfallsart';
    GridRadDat.Cells[1,0] := 'BR %';
    GridRadDat.Cells[2,0] := 'Tochter';
    GridRadDat.OnSelectCell := GridSelectCell;
    btnRadSort.Parent := PanelTVRad;
    btnRadSort.Align := alTop;
    TVRad.Parent := PanelTVRad;
    GridReihe := TIconGrid.Create(SBGridReihe);
    GridReihe.Name := 'GridReihe';
    GridReihe.Parent := SBGridReihe;
    GridReihe.BorderStyle := bsNone;
    GridReihe.Align := alClient;
    GridReihe.FixedCols := 0;
    GridReihe.FixedRows := 0;
    GridReihe.FixedColor := clInfoBk; //$00FFFFCC;
    GridReihe.ColCount := 1;
    GridReihe.RowCount := 2;
    GridReihe.DefaultRowHeight := 18;
    GridReihe.DefaultDrawing := False;
    GridReihe.GridLineWidth := 0;
    GridReihe.Alignment := alCenter;
    GridReihe.Font.Name := 'Arial';
    GridReihe.Font.Style := [fsBold];
    GridReihe.Color := $00FFFFCC;
    GridReihe.ScrollBars := ssNone;// ssBoth;
    GridReihe.DrawSelection := False;
    GridReihe.ShowCellHints := True;
    GridReihe.OnShowHintCell := GridShowHintCell;
    GridReihe.OnSelectCell := GridSelectCell;
    GridReihe.OnDrawCell := GridReiheDrawCell;
    PanelMin.Visible := False;
    PanelLeg.Parent := PC.Pages[1];
    PanelLeg.Hint := 'Zerfall bzw. Emission';
    PanelIso.Parent := GridNuk;
    PanelIso.Left := 50;
    PanelIso.Top := 220;
    PanelProton.Parent := GridNuk;
    PanelProton.Top := 330;
    PanelProton.Left := 20;
    btnPSE.Parent := Chart1;
    btnMarks.Parent := Chart1;
    for i := 0 to 9 do
    begin
      LegShape[i] := TShape.Create(Chart1);
      LegShape[i].Parent := Chart1;
      LegShape[i].Height := 12;
      LegShape[i].Width := 12;
      LegShape[i].Top := 30;
      LegShape[i].Visible := False;
      LegLbl[i] := TLabel.Create(Chart1);
      LegLbl[i].Parent := Chart1;
      LegLbl[i].Transparent := True;
      LegLbl[i].Top := LegShape[i].Top;
    end;
    for i := 10 to 20 do
    begin
      LegShape[i] := TShape.Create(PanelLeg);
      LegShape[i].Parent := PanelLeg;
      LegShape[i].Height := 12;
      LegShape[i].Width := 12;
      LegShape[i].Top := ((i-10) * 14) + 7;
      LegShape[i].Left := 7;
      LegShape[i].Pen.Color := clGray;
      if i = 20 then
        LegShape[i].Brush.Color := NukF[0]
      else LegShape[i].Brush.Color := NukF[i-10];
      LegLbl[i] := TLabel.Create(PanelLeg);
      LegLbl[i].Parent := PanelLeg;
      LegLbl[i].Transparent := True;
      LegLbl[i].Top := LegShape[i].Top - 1;
      LegLbl[i].Height := 13;
      LegLbl[i].Left := 52;
      LegLbl[i].Font.Charset := ANSI_CHARSET;
      LegLbl[i].Font.Name := 'MS Sans Serif';
      if (i > 10) and (i < 20) then
      begin
        LegLbl[i+10] := TLabel.Create(PanelLeg);
        LegLbl[i+10].Parent := PanelLeg;
        LegLbl[i+10].Transparent := True;
        if (i = 14) then
          LegLbl[i+10].Top := LegShape[i].Top - 3
        else if (i = 18) then
          LegLbl[i+10].Top := LegShape[i].Top - 5
        else LegLbl[i+10].Top := LegShape[i].Top - 1;
        LegLbl[i+10].Height := 15;
        LegLbl[i+10].Width := 15;
        LegLbl[i+10].Left := 25;
        LegLbl[i+10].AutoSize := False;
        LegLbl[i+10].Alignment := taCenter;
        LegLbl[i+10].Font.Charset := ANSI_CHARSET;
        LegLbl[i+10].Font.Name := 'Arial';
        LegLbl[i+10].Font.Style := [fsBold];
        case i of
          11,12,14,18: begin
                      LegLbl[i+10].Font.Charset := SYMBOL_CHARSET;
                      LegLbl[i+10].Font.Name := 'Symbol';
                    end;
        end;
      end;
    end;
    LegShape[10].Brush.Color := clBlack;
    LegShape[20].Brush.Color := clSilver;
    LegLbl[10].Caption := 'stabil';
    LegLbl[11].Caption := 'Elektronen-Zerfall';
    LegLbl[12].Caption := 'Positronen-Zerfall';
    LegLbl[13].Caption := 'Isomerer Übergang';
    LegLbl[14].Caption := 'Alpha-Zerfall';
    LegLbl[15].Caption := 'Neutronen-Zerfall';
    LegLbl[16].Caption := 'Spontanspaltung';
    LegLbl[17].Caption := 'Protonen-Zerfall';
    LegLbl[18].Caption := 'Elektronen-Einfang';
    LegLbl[19].Caption := 'Cluster-Emission';
    LegLbl[20].Caption := 'unbekannt';
    LegLbl[21].Caption := 'b-';//chr(226) + '-';
    LegLbl[22].Caption := 'b+';//chr(226) + '+';
    LegLbl[23].Caption := 'IT';
    LegLbl[24].Font.Size := 10;
    LegLbl[24].Caption := 'a';//chr(225);
    LegLbl[25].Caption := 'n';
    LegLbl[26].Caption := 'SF';
    LegLbl[27].Caption := 'p';
    LegLbl[28].Font.Size := 11;
    LegLbl[28].Caption := 'e';//chr(229);
    LegLbl[29].Caption := 'CE';
    for i := 0 to PC.PageCount - 1 do
      PC.Pages[i].TabVisible := False;
    with GridDaten do
    begin
      for i := 1 to RowCount - 1 do
        CellFont[0,i].Color := clNavy;
      CellFont[0,0].Style := [fsBold];
      CellFont[1,0].Style := [fsBold];
      Cells[0,0] := 'Bezeichnung';
      Cells[1,0] := 'Wert';
      Cells[0,1] := 'Elementname';
      Cells[0,2] := 'Symbol';
      Cells[0,3] := 'Anzahl Protonen';
      Cells[0,4] := 'Anzahl Neutronen';
      Cells[0,5] := 'Kernmasse in u';
      Cells[0,6] := 'Häufigkeit in %';
      Cells[0,7] := 'Halbwertzeit';
      HintCell[1,7] := 'as = Attosek.'+#13#10+
                       'fs = Femtosek.'+#13#10+
                       'ps = Pikosek.'+#13#10+
                       'ns = Nanosek.'+#13#10+
                       'mis = Mikrosek.'+#13#10+
                       'ms = Millisek.'+#13#10+
                       's = Sekunden'+#13#10+
                       'min = Minuten'+#13#10+
                       'h = Stunden'+#13#10+
                       'd = Tage'+#13#10+
                       'a = Jahre';
      Cells[0,8] := 'Zerfallsart(en)';
      Cells[0,9] := 'Bindungsenergie keV/A';
      Cells[0,10] := 'P-Sep.-Energie keV/A';
      HintCell[0,10] := 'Proton-Separationsenergie';
      Cells[0,11] := 'N-Sep.-Energie keV/A';
      HintCell[0,11] := 'Neutron-Separationsenergie';
      Cells[0,12] := 'Massenexzess keV/A';
      Cells[0,13] := 'Spin';
      AdjustColWidth(0);
      ColWidths[1] := GridDaten.ClientWidth - ColWidths[0] + 15;
    end;
  end;
end;

procedure Nukliddaten(Symbol: String;Wahr: Boolean);
var
  i,a,z,iza: Integer;
  temp, symb: String;
begin
  iza := DM.GetiZA(Symbol);
  a := DM.GetA(iza);
  z := DM.GetZ(iza);
  symb := DM.GetSymb(iza);
  with frmMain.GridDaten do
    if Wahr and (Symbol <> '') then
    begin
      if symb = 'H' then
        case a of
          2: Cells[1,1] := 'Deuterium';
          3: Cells[1,1] := 'Tritium';
        else Cells[1,1] := DM.NukName(symb);
        end
      else if (z = 0) and (a = 1) then Cells[1,1] := 'freies Neutron'
      else Cells[1,1] := DM.NukName(symb);
      if DM.ETNukl.Locate('iZA',iza,[]) then
      begin
        Cells[1,2] := DM.GetSymb(iza);
        Cells[1,3] := IntToStr(DM.GetZ(iza));
        Cells[1,4] := IntToStr(DM.GetN(iza));
        if DM.GetA(iza) > 0 then
          Cells[1,5] := ZahlFormat(DM.ETNukl.FieldByName('Masse').AsFloat,2,7)
        else Cells[1,5] := IntToStr(DM.GetA(iza));
        if not DM.ETNukl.FieldByName('Abund').IsNull then
          Cells[1,6] := ZahlFormat(DM.ETNukl.FieldByName('Abund').AsFloat,0,5)
        else Cells[1,6] := '';
        if not DM.ETNukl.FieldByName('Tsek').IsNull then
          Cells[1,7] := ZeitFormat(DM.ETNukl.FieldByName('Tsek').AsFloat)
        else Cells[1,7] := '';
        temp := Trim(DM.FindRTypS(iza,DM.ETNukl.FieldByName('Max_RTyp').AsInteger));
        temp := StringReplace(temp,'a','Alpha',[rfReplaceAll]);
        temp := StringReplace(temp,'b','ß',[rfReplaceAll]);
        Cells[1,8] := temp;
        HintCell[1,8] := temp;
        if not DM.ETNukl.FieldByName('BE').IsNull then
          Cells[1,9] := ZahlFormat(DM.ETNukl.FieldByName('BE').AsFloat,0,7)
        else Cells[1,9] := '';
        if not DM.ETNukl.FieldByName('SP').IsNull then
          Cells[1,10] := ZahlFormat(DM.ETNukl.FieldByName('SP').AsFloat,0,7)
        else Cells[1,10] := '';
        if not DM.ETNukl.FieldByName('SN').IsNull then
          Cells[1,11] := ZahlFormat(DM.ETNukl.FieldByName('SN').AsFloat,0,7)
        else Cells[1,11] := '';
        if not DM.ETNukl.FieldByName('MassExc').IsNull then
          Cells[1,12] := ZahlFormat(DM.ETNukl.FieldByName('MassExc').AsFloat,0,7)
        else Cells[1,12] := '';
        Cells[1,13] := DM.ETNukl.FieldByName('JPi').AsString;
      end;
    end else for i := 1 to RowCount-1 do Cells[1,i] := '';
end;

procedure PosGridReihe(Allein: Boolean);
begin
  with frmMain do
  begin
    SBGridRad.Visible := Allein;
    {if not SBGridRad.Visible then
      GridReihe.Align := alClient
    else
    begin
      GridReihe.Align := alNone;
      GridReihe.Width := 794;
      GridReihe.Height := 387;
      SBGridRad.Top := GridReihe.Top + GridReihe.Height;
    end;}
  end;
end;

procedure PosGridRadScrollbar(iZA: Integer);
var z: Integer;
begin
  if DM.GetZ(iZA) < 55 then
    frmMain.SBGridRad.HorzScrollBar.Position := 0
  else if DM.GetZ(iZA) > 90 then
    frmMain.SBGridRad.HorzScrollBar.Position := 122
  else frmMain.SBGridRad.HorzScrollBar.Position := 60;
  if DM.GetZ(iZA) < 30 then
    z := 120
  else if DM.GetZ(iZA) > 94 then
    z := 0
  else z := 120 - DM.GetZ(iZA);
  frmMain.SBGridRad.VertScrollBar.Position := Trunc((376 / 120) * z);
end;

procedure PosNuk(Col,Row: Integer);
var i: Integer;
begin
  with frmMain do
  begin
    if GridMin.Visible and (GridNuk.DefaultColWidth > 5) then
    begin
      i := Trunc((SBNuk.ClientWidth / GridNuk.DefaultColWidth) / 2);
      SBNuk.HorzScrollBar.Position := (Col * GridNuk.DefaultColWidth) -
        (i * GridNuk.DefaultColWidth);
      i := Trunc((SBNuk.ClientHeight / GridNuk.DefaultRowHeight) / 2);
      SBNuk.VertScrollBar.Position := (Row * GridNuk.DefaultRowHeight) -
        (i * GridNuk.DefaultRowHeight);
      MinPosX := SBNuk.HorzScrollBar.Position;
      MinPosY := SBNuk.VertScrollBar.Position;
    end;
    GridAktPos(Col,Row);
  end;
end;

procedure PosNukReihe(Col,Row: Integer;Alle: Boolean);
begin
  with frmMain.SBGridReihe do
  begin
    HorzScrollBar.Range :=
      (frmMain.GridReihe.ColCount+1) * frmMain.GridReihe.DefaultColWidth;
    HorzScrollBar.Increment := frmMain.GridReihe.DefaultColWidth;
    VertScrollBar.Range :=
      (frmMain.GridReihe.RowCount+1) * frmMain.GridReihe.DefaultRowHeight;
    VertScrollBar.Increment := (frmMain.GridReihe.DefaultRowHeight*2);
    if Alle then
      if Col <= 6 then
        HorzScrollBar.Position := 0
      else if Col >= (frmMain.GridReihe.ColCount - 6) then
        HorzScrollBar.Position := HorzScrollBar.Range
      else HorzScrollBar.Position := (Col div 2) * frmMain.GridReihe.DefaultColWidth
    else HorzScrollBar.Position := 0;
    if Row < (frmMain.GridReihe.RowCount div 2) then
      VertScrollBar.Position := 0
    else VertScrollBar.Position := VertScrollBar.Range;
  end;
end;

procedure PosPanelLeg;
begin
  with frmMain do
    if PanelLeg.Parent = PC.Pages[1] then
    begin
      if SBNuk.VertScrollBar.IsScrollBarVisible then
        PanelLeg.Left := ClientWidth - PanelLeg.Width-27
      else PanelLeg.Left := ClientWidth - PanelLeg.Width-10;
      if SBNuk.HorzScrollBar.IsScrollBarVisible then
        PanelLeg.Top := ClientHeight - StatusBar.Height - PanelLeg.Height-29
      else PanelLeg.Top := ClientHeight - StatusBar.Height - PanelLeg.Height-10;
    end
    else
    begin
      if GridReihe.VerticalScrollBarVisible then
        PanelLeg.Left := GridReihe.Left+GridReihe.Width-PanelLeg.Width-19
      else PanelLeg.Left := GridReihe.Left + GridReihe.Width - PanelLeg.Width-2;
      if GridReihe.HorizontalScrollBarVisible then
        PanelLeg.Top := GridReihe.Top + GridReihe.Height - PanelLeg.Height-2 //218 -21
      else PanelLeg.Top := GridReihe.Top + GridReihe.Height - PanelLeg.Height-2; //220;
      SBGridRad.Top := GridReihe.Top + GridReihe.Height;
    end;
end;

procedure RadAlle;
begin
  while RadGridAlle = False do
end;

function RadBack(iZA: Integer): Boolean;
var
  i,n,z,iz,minn,maxn,minz,maxz: Integer;
  NewNuk: Boolean;
begin
  NewNuk := False;
  minn := 178; maxn := 0; minz := 119; maxz := 0;
  with frmMain.GridRad do
  begin
    z := DM.GetZ(iZA);
    n := DM.GetN(iZA);
    if minn > n then minn := n;
    if maxn < n then maxn := n;
    if minz > z then minz := z;
    if maxz < z then maxz := z;
    if DM.ETRZA.Locate('iZA',iZA,[]) then
    begin
      HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iZA,True);
      if ColorCell[n+1,RowCount-z-1] = clWhite then
      begin
        HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iZA,True);
        DM.ETDMI.Filter := 'iZA = ' + IntToStr(iZA);
        if DM.ETDMI.FindFirst then
        repeat
          if DM.ETDMI.FieldByName('nMode').AsInteger = 1 then
          begin
            ColorCell[n+1,RowCount-z-1] :=
              DM.RadFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
            NewNuk := True;
          end;
        until DM.ETDMI.FindNext = False;
        DM.ETDMI.Filter := '';
      end
      else if ColorCell[n+1,RowCount-z-1] = clBtnFace then
      begin
        HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iZA,True);
        if (iZA mod 10 > 0) and DM.ETNukl.Locate('iZA',iZA,[]) and
          (DM.ETNukl.FieldByName('Max_RTyp').AsInteger = 3) then
          ColorCell[n+1,RowCount-z-1] := DM.RadFarbe(3)
        else ColorCell[n+1,RowCount-z-1] := clBlack;
      end;
      for i := 1 to DM.ETRZA.FieldCount-1 do
        if DM.ETRZA.FieldByName('RZA'+IntToStr(i)).AsInteger > 0 then
        begin
          iz := DM.ETRZA.FieldByName('RZA'+IntToStr(i)).AsInteger;
          z := DM.GetZ(iz);
          n := DM.GetN(iz);
          if minn > n then minn := n;
          if maxn < n then maxn := n;
          if minz > z then minz := z;
          if maxz < z then maxz := z;
          HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iz,True);
          DM.ETDMI.Filter := 'iZA = ' + IntToStr(iz);
          if DM.ETDMI.FindFirst then
          repeat
            if DM.ETDMI.FieldByName('nMode').AsInteger = 1 then
              ColorCell[n+1,RowCount-z-1] :=
                DM.RadFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
          until DM.ETDMI.FindNext = False;
          DM.ETDMI.Filter := '';
          frmMain.Gauge.Position := Trunc((i / DM.ETRZA.FieldCount) * 100);
        end else Break;
    end
    else
    begin
      if not DM.ETDMI.Locate('iZA',iZA,[]) and DM.ETNukl.Locate('iZA',iZA,[]) and
        (DM.ETNukl.FieldByName('Tsek').AsFloat <> -99) then
      begin
        HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iZA,True);
        ColorCell[n+1,RowCount-z-1] := clSilver;
      end
      else if ColorCell[n+1,RowCount-z-1] = clWhite then
      begin
        HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iZA,True);
        DM.ETDMI.Filter := 'iZA = ' + IntToStr(iZA);
        if DM.ETDMI.FindFirst then
        repeat
          if DM.ETDMI.FieldByName('nMode').AsInteger = 1 then
          begin
            ColorCell[n+1,RowCount-z-1] :=
              DM.RadFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
            NewNuk := True;
          end;
        until DM.ETDMI.FindNext = False;
        DM.ETDMI.Filter := '';
        DM.ETDMI.Filter := 'DAUGHTER = ' + IntToStr(iZA);
        if DM.ETDMI.FindFirst then
        repeat
          iz := DM.ETDMI.FieldByName('iZA').AsInteger;
          z := DM.GetZ(iz);
          n := DM.GetN(iz);
          if ColorCell[n+1,RowCount-z-1] = clWhite then
          begin
            HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iz,True);
            ColorCell[n+1,RowCount-z-1] :=
              DM.RadFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
            NewNuk := True;
          end;
        until DM.ETDMI.FindNext = False;
        DM.ETDMI.Filter := '';
      end
      else if ColorCell[n+1,RowCount-z-1] = clBtnFace then
      begin
        HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iZA,True);
        if (iZA mod 10 > 0) and DM.ETNukl.Locate('iZA',iZA,[]) and
          (DM.ETNukl.FieldByName('Max_RTyp').AsInteger = 3) then
          ColorCell[n+1,RowCount-z-1] := DM.RadFarbe(3)
        else ColorCell[n+1,RowCount-z-1] := clBlack;
        DM.ETDMI.Filter := 'DAUGHTER = ' + IntToStr(iZA);
        if DM.ETDMI.FindFirst then
        repeat
          iz := DM.ETDMI.FieldByName('iZA').AsInteger;
          z := DM.GetZ(iz);
          n := DM.GetN(iz);
          if ColorCell[n+1,RowCount-z-1] = clWhite then
          begin
            HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iz,True);
            ColorCell[n+1,RowCount-z-1] :=
              DM.RadFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
            NewNuk := True;
          end;
        until DM.ETDMI.FindNext = False;
        DM.ETDMI.Filter := '';
      end;
    end;
  end;
  Result := NewNuk;
  if not NewNuk then
  begin
    PosGridRadScrollbar(DM.IZAvonZ(maxz));
    SetRadAlle(minn,maxn,minz,maxz);
  end else while RadBackAlle(iZA) = True do begin end;
end;

function RadBackAlle(iZA: Integer): Boolean;
var
  i,i1,iz,dz,n,z,minn,maxn,minz,maxz,max,von: Integer;
  NewNuk: Boolean;
begin
  NewNuk := False;
  minn := 178; maxn := 0; minz := 119; maxz := 0;
  max := DM.GetZ(iZA);
  if max < 60 then von := 30 else von := 1;
  frmMain.Gauge.Position := 0;
  with frmMain.GridRad do
  begin
    for i1 := von to RowCount-1 do
    begin
      for i := 1 to ColCount-1 do
        if (HintCell[i,i1] <> '') and DM.isDecFarbe(ColorCell[i,i1]) then
        begin
          dz := DM.GetiZA(HintCell[i,i1]);
          z := DM.GetZ(dz);
          n := DM.GetN(dz);
          if minn > n then minn := n;
          if maxn < n then maxn := n;
          if minz > z then minz := z;
          if maxz < z then maxz := z;
          DM.ETDMI.Filter := 'DAUGHTER = ' + IntToStr(dz);
          if DM.ETDMI.FindFirst then
          repeat
            iz := DM.ETDMI.FieldByName('iZA').AsInteger;
            z := DM.GetZ(iz);
            n := DM.GetN(iz);
            if ColorCell[n+1,RowCount-z-1] = clWhite then
            begin
              HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iz,True);
              ColorCell[n+1,RowCount-z-1] :=
                DM.RadFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
              NewNuk := True;
            end;
          until DM.ETDMI.FindNext = False;
          DM.ETDMI.Filter := '';
        end;
      frmMain.Gauge.Position := Trunc((i1 / RowCount) * 100);
      if i1 > (RowCount - (max - 10)) then Break;
    end;
  end;
  if not NewNuk then
  begin
    max := DM.IZAvonZ(maxz);
    PosGridRadScrollbar(max);
    SetRadAlle(minn,maxn,minz,maxz);
  end;
  Result := NewNuk;
end;

function  RadDaten(txt: String): Boolean;
var
  i,i2,farbe: Integer;
  temp,temp1: String;
  List: TStringList;
begin
  with frmMain.GridRadDat do
    if Trim(txt) <> '' then
    begin
      temp := txt;
      List := TStringList.Create;
      while Pos('|',temp) > 0 do
      begin
        List.Add(Copy(temp,1,Pos('|',temp)-1));
        Delete(temp,1,Pos('|',temp));
      end;
      if temp <> '' then List.Add(temp);
      for i := 0 to List.Count-1 do
      begin
        temp := Trim(List.Strings[i]);
        temp1 := Trim(Copy(temp,1,Pos('(',temp)-1));
        if (temp1 <> '') and DM.ETDM.Locate('D_Mode',temp1,[]) then
        begin
          farbe := Trunc(DM.ETDM.FieldByName('RTYP').AsFloat);
          for i2 := 0 to 2 do
          begin
            ColorCell[i2,i+1] := DM.RadFarbe(farbe);
            CellFont[i2,i+1].Color := DM.RadFontFarbe(farbe);
          end;
        end;
        temp1 := StringReplace(temp1,'a','Alpha',[rfReplaceAll]);
        temp1 := StringReplace(temp1,'b','Beta',[rfReplaceAll]);
        temp1 := StringReplace(temp1,'ec','EC',[rfReplaceAll]);
        Cells[0,i+1] := temp1;
        Cells[1,i+1] := StringReplace(GetKlammer(temp),'%','',[]);
        Delete(temp,1,Pos('>',temp));
        Cells[2,i+1] := temp;
      end;
      List.Free;
    end;
  Result := True;
end;

function RadGridAlle: Boolean;
var
  i,i1,i2,iza,stab,n,z,minn,maxn,minz,maxz: Integer;
  NeuesNuk: Boolean;
begin
  stab := 300; minn := 178; maxn := 0; minz := 119; maxz := 0;
  frmMain.Gauge.Position := 0;
  NeuesNuk := False;
  with frmMain.GridRad do
    for i1 := 0 to RowCount-1 do
    begin
      for i := 0 to ColCount-1 do
      begin
        if ColorCell[i,i1] = clBlack then
        begin
          stab := i1;
          iza := DM.GetiZA(HintCell[i,i1]);
          n := DM.GetN(iza);
          z := DM.GetZ(iza);
          if minn > n then minn := n;
          if maxn < n then maxn := n;
          if minz > z then minz := z;
          if maxz < z then maxz := z;
        end;
        if DM.isDecFarbe(ColorCell[i,i1]) and (HintCell[i,i1] <> '') and
          (ColorCell[i,i1] <> clBlack) then
        begin
          iza := DM.GetiZA(HintCell[i,i1]);
          n := DM.GetN(iza);
          z := DM.GetZ(iza);
          if minn > n then minn := n;
          if maxn < n then maxn := n;
          if minz > z then minz := z;
          if maxz < z then maxz := z;
          DM.ETDMI.Filter := 'iZA = ' + IntToStr(iza);
          if DM.ETDMI.FindFirst then
          repeat
            if (DM.ETDMI.FieldByName('nMode').AsInteger = 1) then
              ColorCell[i,i1] := DM.RadFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
            i2 := DM.ETDMI.FieldByName('DAUGHTER').AsInteger;
            if i2 <> 0 then
            begin
              if i2 <> -60 then
              begin
                n := DM.GetN(i2);
                z := DM.GetZ(i2);
                if minn > n then minn := n;
                if maxn < n then maxn := n;
                if minz > z then minz := z;
                if maxz < z then maxz := z;
                if ColorCell[n+1,RowCount-z-1] = clWhite then
                begin
                  ColorCell[n+1,RowCount-z-1] :=
                      DM.RadFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
                  HintCell[n+1,RowCount-z-1] := DM.GetNukBez(i2,True);
                  NeuesNuk := True;
                end
                else if ColorCell[n+1,RowCount-z-1] = clBtnFace then
                begin
                  ColorCell[n+1,RowCount-z-1] := clBlack;
                  HintCell[n+1,RowCount-z-1] := DM.GetNukBez(i2,True);
                end;
              end;
            end;
          until DM.ETDMI.FindNext = False;
          DM.ETDMI.Filter := '';
        end;
      end;
      frmMain.Gauge.Position := Trunc((i1 / RowCount) * 100);
      if i1 = stab+10 then Break;
    end;
  if not NeuesNuk then
  begin
    SetRadAlle(minn,maxn,minz,maxz);
    Result := True;
  end else Result := False;
end;

function RadReihe(iZA: Integer): Boolean;
  function FolgeNuk(iz: Integer): Integer;
  begin
    with DM.ETDMI do
    begin
      Filter := 'iZA = ' + IntToStr(iz);
      Result := 0;
      if FindFirst then
      repeat
        if FieldByName('nMode').AsInteger = 1 then
          Result := FieldByName('Nr').AsInteger;
      until FindNext = False;
      Filter := '';
    end;
  end;
var
  i,i1,i2,i3,n,z,r: Integer;
  temp: String;
  Farbe: TColor;
  nuk: array[0..10] of Integer;
begin
  if not frmMain.btnRad1.Enabled then
  begin
    frmMain.GridReihe.DefaultColWidth := 100;
    frmMain.GridReihe.DefaultRowHeight := 21;
  end;
  with DM.ETDMI do
    if DM.ETNukl.Locate('iZA',iZA,[]) and
      (DM.ETNukl.FieldByName('Tsek').AsFloat = -99) then
    begin
      n := DM.GetN(iZA);
      z := DM.GetZ(iZA);
      if (iZA mod 10 > 0) and (DM.ETNukl.FieldByName('Max_RTyp').AsInteger = 3) then
        frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] := DM.RadFarbe(3)
      else frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] := clBlack;
      frmMain.GridRad.HintCell[n+1,frmMain.GridRad.RowCount-z-1] :=
        DM.GetNukBez(iZA,True);
      if not frmMain.btnRad1.Enabled then
      begin
        frmMain.GridReihe.ColorCell[0,0] := clBlack;
        frmMain.GridReihe.ColorCell[0,1] := clBlack;
        frmMain.GridReihe.Cells[0,0] := DM.GetNukBez(iZA,True);
        frmMain.GridReihe.Cells[0,1] := 'stabil';
      end;
      Result := True;
    end
    else if Locate('iZA',iZA,[]) then
    begin
      i1 := 0;
      Filter := 'iZA = ' + IntToStr(iZA);
      if FindFirst then
      repeat
        if FieldByName('DAUGHTER').AsInteger <> 0 then
        begin
          Inc(i1);
          i := FieldByName('nMode').AsInteger;
          nuk[i-1] := FieldByName('Nr').AsInteger;
          if not frmMain.btnRad1.Enabled then
          begin
            if frmMain.GridReihe.ColCount < i1 then
              frmMain.GridReihe.ColCount := i1;
            frmMain.GridReihe.CellFont[i-1,0].Style := [fsBold];
            frmMain.GridReihe.ColorCell[i-1,0] := clInfoBk;
            frmMain.GridReihe.Cells[i-1,0] := 'Zerfallsreihe ' + IntToStr(i);
            frmMain.GridReihe.HintCell[i-1,0] := 'Klick hier für weitere Daten der ' +
              frmMain.GridReihe.Cells[i-1,0];
            if DM.ETDM.Locate('RTYP',FieldByName('RTYP').AsFloat,[]) then
            begin
              Farbe := DM.RadFarbe(FieldByName('RTYP1').AsInteger);
              frmMain.GridReihe.ColorCell[i-1,1] := Farbe;
              frmMain.GridReihe.ColorCell[i-1,2] := Farbe;
              frmMain.GridReihe.Cells[i-1,1] :=
                DM.GetNukBez(FieldByName('iZA').AsInteger,True);
              frmMain.GridReihe.CellFont[i-1,2].Style := [];
              frmMain.GridReihe.HintCell[i-1,2] := 'Icon';
              if FieldByName('RTYP').AsFloat <> 0 then
              begin
                if (Frac(FieldByName('BR').AsFloat) = 0) or
                  (FieldByName('BR').AsFloat = 100) then i3 := 0 else i3 := 1;
                if (FieldByName('BR').AsFloat > 0) and
                  (FieldByName('BR').AsFloat < 0.1) then
                  temp := '< 0,1'
                else
                  temp := FloatToStrF(FieldByName('BR').AsFloat,ffFixed,15,i3);
                if Pos(',0',temp) > 0 then
                  temp := Copy(temp,1,Pos(',0',temp)-1);
                if temp = '0' then temp := '';
                if temp <> '' then temp := temp + '%';
              end else temp := '';
              frmMain.GridReihe.Cells[i-1,2] :=
                DM.ETDM.FieldByName('D_MODE').AsString + ';' + temp;
            end;
          end;
        end;
      until FindNext = False;
      Filter := '';
      for i := 0 to i1-1 do
      begin
        if Locate('Nr',nuk[i],[]) then
        begin
          r := 3;
          n := DM.GetN(FieldByName('iZA').AsInteger);
          z := DM.GetZ(FieldByName('iZA').AsInteger);
          if (i = 0) and
            (frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] = clWhite) then
            frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] :=
              DM.RadFarbe(FieldByName('RTYP1').AsInteger);
          frmMain.GridRad.HintCell[n+1,frmMain.GridRad.RowCount-z-1] :=
            DM.GetNukBez(FieldByName('iZA').AsInteger,True);
          i2 := FieldByName('DAUGHTER').AsInteger;
          while i2 > 1 do
          begin
            if DM.ETNukl.Locate('iZA',i2,[]) and
              (DM.ETNukl.FieldByName('Tsek').AsFloat = -99) then
            begin
              n := DM.GetN(DM.ETNukl.FieldByName('iZA').AsInteger);
              z := DM.GetZ(DM.ETNukl.FieldByName('iZA').AsInteger);
              frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] := clBlack;
              frmMain.GridRad.HintCell[n+1,frmMain.GridRad.RowCount-z-1] :=
                DM.GetNukBez(DM.ETNukl.FieldByName('iZA').AsInteger,True);
              if not frmMain.btnRad1.Enabled then
              begin
                r := r + 2;
                if frmMain.GridReihe.RowCount < r then
                  frmMain.GridReihe.RowCount := r;
                frmMain.GridReihe.ColorCell[i,r-2] := clBlack;
                frmMain.GridReihe.ColorCell[i,r-1] := clBlack;
                frmMain.GridReihe.Cells[i,r-2] := DM.GetNukBez(i2,True);
                frmMain.GridReihe.CellFont[i,r-1].Style := [fsBold];
                frmMain.GridReihe.Cells[i,r-1] := 'stabil';
              end;
              i2 := 0;
            end
            else if Locate('Nr',FolgeNuk(i2),[]) then
            begin
              n := DM.GetN(FieldByName('iZA').AsInteger);
              z := DM.GetZ(FieldByName('iZA').AsInteger);
              Farbe := DM.RadFarbe(FieldByName('RTYP1').AsInteger);
              frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] := Farbe;
              frmMain.GridRad.HintCell[n+1,frmMain.GridRad.RowCount-z-1] :=
                DM.GetNukBez(FieldByName('iZA').AsInteger,True);
              i2 := FieldByName('DAUGHTER').AsInteger;
              if not frmMain.btnRad1.Enabled then
              begin
                r := r + 2;
                temp := '';
                if frmMain.GridReihe.RowCount < r then
                  frmMain.GridReihe.RowCount := r;
                frmMain.GridReihe.ColorCell[i,r-2] := Farbe;
                frmMain.GridReihe.ColorCell[i,r-1] := Farbe;
                frmMain.GridReihe.Cells[i,r-2] :=
                  DM.GetNukBez(FieldByName('iZA').AsInteger,True);
                if DM.ETDM.Locate('RTYP',FieldByName('RTYP').AsFloat,[]) then
                begin
                  if FieldByName('RTYP').AsFloat <> 0 then
                  begin
                    if (Frac(FieldByName('BR').AsFloat) = 0) or
                      (FieldByName('BR').AsFloat = 1) then i3 := 0
                    else if FieldByName('BR').AsFloat > 0.001 then i3 := 1
                    else i3 := 3;
                    temp := FloatToStrF(FieldByName('BR').AsFloat,ffFixed,15,i3);
                    if Pos('100,0',temp) > 0 then
                      temp := Copy(temp,1,Pos(',0',temp)-1);
                    if temp = '0' then temp := '';
                    if temp <> '' then temp := ';' + temp + '%' else temp := ';';
                  end else temp := ';';
                  frmMain.GridReihe.CellFont[i,r-1].Style := [];
                end;
                frmMain.GridReihe.Cells[i,r-1] :=
                    DM.ETDM.FieldByName('D_MODE').AsString + temp;
                frmMain.GridReihe.HintCell[i,r-1] := 'Icon';
              end;
            end else i2 := 0;
          end;
        end;
        frmMain.Gauge.Position := Trunc((i / i1) * 100);
      end;
      Result := True;
    end
    else
    begin
      n := DM.GetN(DM.ETNukl.FieldByName('iZA').AsInteger);
      z := DM.GetZ(DM.ETNukl.FieldByName('iZA').AsInteger);
      frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] := clSilver;
      if not frmMain.btnRad1.Enabled then
      begin
        frmMain.GridReihe.ColorCell[0,0] := clSilver;
        frmMain.GridReihe.ColorCell[0,1] := clSilver;
        frmMain.GridReihe.Cells[0,0] := DM.GetNukBez(iZA,True);
        frmMain.GridReihe.Cells[0,1] := 'unbekannt';
      end;
      Result := False;
    end;
  PosGridRadScrollbar(iZA);
  if frmMain.bRad = 2 then
    RadAlle
  else
  begin
    frmMain.btnRad2.Enabled := True;
    frmMain.SBGridReihe.HorzScrollBar.Range :=
      (frmMain.GridReihe.ColCount+1) * frmMain.GridReihe.DefaultColWidth;
    frmMain.SBGridReihe.HorzScrollBar.Increment := frmMain.GridReihe.DefaultColWidth;
    frmMain.SBGridReihe.VertScrollBar.Range := 
      (frmMain.GridReihe.RowCount+1) * frmMain.GridReihe.DefaultRowHeight;
    frmMain.SBGridReihe.VertScrollBar.Increment := frmMain.GridReihe.DefaultRowHeight;
  end;
  frmMain.Gauge.Position := 0;
end;

function SetRadAlle(minn,maxn,minz,maxz: Integer): Boolean;
var
  i,i1,i2,n,z,iza,y,c,r: Integer;
  temp,temp1,temp2: String;
  List: TStringList;
begin
  List := TStringList.Create;
  frmMain.Gauge.Position := 0;
  {iza := DM.GetiZA(frmMain.TVRad.Items[frmMain.TVRadIdx].Text);
  if (frmMain.bRad = 3) and not DM.ETRZA.Locate('iZA',iza,[]) then
  begin
    DM.ETRZA.Append;
    DM.ETRZA.FieldByName('iZA').AsInteger := iZA;
    DM.ETRZA.Post;
  end else DM.ETRZA.Locate('iZA',iza,[]);}
  with frmMain.GridReihe do
  begin
    c := 0; r := 0; //anz := 0;
    for i2 := 0 to 9 do List.Add('d');
    ClearGridReihe(True);
    DefaultColWidth := 77;
    DefaultRowHeight := 50;
    ColCount := maxn - minn + 2;
    RowCount := maxz - minz + 2;
    for i := 0 to ColCount-1 do ColorCell[i,0] := $00FFFFCC;
    for i1 := 1 to frmMain.GridRad.RowCount-1 do
    begin
      for i := 1 to frmMain.GridRad.ColCount-1 do
        if DM.isDecFarbe(frmMain.GridRad.ColorCell[i,i1]) and
          (frmMain.GridRad.HintCell[i,i1] <> '') then
        begin
          iza := DM.GetiZA(frmMain.GridRad.HintCell[i,i1]);
          z := DM.GetZ(iza);
          n := DM.GetN(iza);
          y := (maxz - z)+1;
          if DM.GetiZA(frmMain.TVRad.Items[frmMain.TVRadIdx].Text) = iza then
          begin
            c := n-minn+1;
            r := y;
          end;
          {else if frmMain.bRad = 3 then
          begin
            Inc(anz);
            if DM.ETRZA.FieldByName('RZA'+IntToStr(anz)).AsInteger = 0 then
            begin
              DM.ETRZA.Edit;
              DM.ETRZA.FieldByName('RZA'+IntToStr(anz)).AsInteger := iza;
              DM.ETRZA.Post;
            end;
          end;}
          ColorCell[n-minn+1,y] := frmMain.GridRad.ColorCell[i,i1];
          if (frmMain.GridRad.HintCell[i,i1] <> '') and
            (frmMain.GridRad.ColorCell[i,i1] <> clBlack) then
          begin
            temp := DM.FindRTypS(iza,DM.RadFarbNr(frmMain.GridRad.ColorCell[i,i1]));
            Cells[n-minn+1,y] := DM.GetNukBez(iza,True) + '[' + temp + ']';
            for i2 := 0 to 9 do List.Strings[i2] := '';
            DM.ETDMI.Filter := 'iZA = ' + IntToStr(iza);
            if DM.ETDMI.FindFirst then
            repeat
              temp := DM.Zerfallart(DM.ETDMI.FieldByName('RTYP').AsFloat);
              if DM.ETDMI.FieldByName('BR').AsFloat = 0 then
                temp1 := '?'
              else
                //temp1 := ZahlFormat(DM.ETDMI.FieldByName('BR').AsFloat,0,2) + '%';
                temp1 := FloatToStr(DM.ETDMI.FieldByName('BR').AsFloat) + '%';
              if (DM.ETDMI.FieldByName('DAUGHTER').AsInteger = 0) or
                 (DM.ETDMI.FieldByName('DAUGHTER').AsInteger = -60) then
                temp2 := '->?'
              else
                temp2 := '->' +
                  DM.GetNukBez(DM.ETDMI.FieldByName('DAUGHTER').AsInteger,True);
              i2 := DM.ETDMI.FieldByName('nMode').AsInteger;
              List.Strings[i2-1] := temp + '(' + temp1 + ')' + temp2;
            until DM.ETDMI.FindNext = False;
            DM.ETDMI.Filter := '';
            temp := '';
            for i2 := 0 to 9 do
            begin
              if List.Strings[i2] <> '' then
              begin
                if temp <> '' then
                  temp := temp + '|' + List.Strings[i2]
                else temp := List.Strings[i2];
              end else Break;
            end;
            HintCell[n-minn+1,y] := temp;
          end else Cells[n-minn+1,y] := DM.GetNukBez(iza,True);
        end
        else if frmMain.GridRad.ColorCell[i,i1] = clSilver then
        begin
          //Inc(anz);
          ColorCell[1,1] := clSilver;
          Cells[1,1] := frmMain.GridRad.HintCell[i,i1];
        end;
      frmMain.Gauge.Position := Trunc((i1 / RowCount) * 100);
    end;
    PosNukReihe(c,r,True);
  end;
  List.Free;
  if frmMain.bRad = 1 then frmMain.btnRad1.Enabled := True;
  frmMain.Gauge.Position := 0;
  //if anz > frmMain.anzrad then frmMain.anzrad := anz;
  Result := True;
end;

function SetNukLeg(idx: Integer): Boolean;
var
  i,i1,i2: Integer;
  temp: String;
begin
  with frmMain do
  begin
    i1 := idx + 152;
    {if idx = 6 then i2 := 8 else} i2 := 10;
    if DM.ETName.Locate('Nr',i1,[]) then
      for i := 0 to i2 do
      begin
        if i > 0 then
          temp := DM.ETName.FieldByName('F'+IntToStr(i)).AsString;
        if (i > 0) and (i < 10) then
        begin
          NukF[i] := StrToInt(GetKlammer(temp));
          LegLbl[i+10].Caption := Copy(temp,1,Pos('(',temp)-1);
          if idx > 0 then
          begin
            LegLbl[i+20].Visible := False;
            LegLbl[i+10].Left := LegLbl[21].Left;
          end
          else
          begin
            LegLbl[i+20].Visible := True;
            LegLbl[i+10].Left := 52;
          end;
        end
        else if i = 10 then
        begin
          if idx = 1 then
            LegLbl[i].Caption := '> 10+15 s oder ' + Copy(temp,1,Pos('(',temp)-1)
          else LegLbl[i].Caption := Copy(temp,1,Pos('(',temp)-1);
          if idx = 0 then
            LegLbl[i+10].Left := 52
          else LegLbl[i+10].Left := LegLbl[21].Left;
        end;
       end;
    if idx = 0 then
      LegLbl[10].Left := 52
    else LegLbl[10].Left := LegLbl[21].Left;
    NukF[0] := clSilver;
    if idx = 0 then
      PanelLeg.Hint := 'Zerfall = Emission'
    else if idx = 1 then
      PanelLeg.Hint := 'a = Jahre'+#13#10+
                       'd = Tage'+#13#10+
                       'h = Stunden'+#13#10+
                       'min = Minuten'+#13#10+
                       's = Sekunden'+#13#10+
                       'ms = Millisekunden'
    else PanelLeg.Hint := '';
    for i := 11 to 19 do LegShape[i].Brush.Color := NukF[i-10];
  end;
  Result := True;
end;

procedure ZerfallsreiheDaten(txt: String);
var
  i,i1,a,l,z,iza: Integer;
  d: Double;
  temp,temp1,temp2: String;
begin
  iza := 0;
  PosGridReihe(False);
  frmMain.btnBack.Visible := True;
  temp := txt;
  with frmMain.GridReihe do
  begin
    for i := 0 to ColCount - 1 do
      for i1 := 0 to RowCount - 1 do
      begin
        Cells[i,i1] := '';
        HintCell[i,i1] := '';
        if i1 > 0 then
        begin
          ColorCell[i,i1] := $00FFFFCC;
          CellFont[i,i1].Style := [fsBold];
        end else ColorCell[i,i1] := clInfoBk;
      end;
    ColCount := 6;
    RowCount := 1;
    Cells[0,0] := 'Nuklid';
    Cells[1,0] := 'Zerfallsart';
    Cells[2,0] := 'Wahrscheinlichkeit';
    Cells[3,0] := 'Halbwertzeit';
    Cells[4,0] := 'Zerfallsenergie';
    Cells[5,0] := 'Zerfallsprodukt';
    i1 := 0;
    for i := 0 to ColCount - 1 do
    begin
      if (i = 0) or (i > 2) then
        ColWidths[i] := 132
      else ColWidths[i] := 134;
      ColorCell[i,0] := clInfoBk;
      CellFont[i,0].Color := clNavy;
      i1 := i1 + ColWidths[i];
    end;
    frmMain.SBGridReihe.HorzScrollBar.Range := i1-3;
    while Pos(#13#10,temp) > 0 do
    begin
      l := 0; temp2 := '';
      temp1 := Trim(Copy(temp,1,Pos(#13#10,temp)));
      Delete(temp,1,Pos(#13#10,temp));
      if (temp1 <> '') and (Pos('Zerf',temp1) = 0) and (Pos(';',temp1) = 0) and
         (Pos('stabil',temp1) = 0) then
      begin
        RowCount := RowCount + 1;
        CellFont[0,RowCount-1].Style := [fsBold];
        Cells[0,RowCount-1] := temp1;
        z := StrToInt(Copy(temp1,1,Pos(#32,temp1)-1));
        while Pos(#32,temp1) > 0 do Delete(temp1,1,Pos(#32,temp1));
        if Pos('m',temp1) > 0 then
        begin
          a := StrToInt(Copy(temp1,1,Pos('m',temp1)-1));
          if temp1[Length(temp1)] = 'm' then l := 1
          else l := StrToInt(Copy(temp1,Pos('m',temp1)+1,1));
        end else a := IntAusStr(temp1);
        iza := DM.MakeIZA(z,a,l);
        if DM.ETNukl.Locate('iZA',iza,[]) then
          if DM.ETNukl.FieldByName('Tsek').AsFloat = -99 then
          begin
            for i := 0 to ColCount - 1 do
            begin
              ColorCell[i,RowCount-1] := clBlack;
              CellFont[i,RowCount-1].Color := DM.RadFontFarbe(10); //KontrastFarbe(clBlack,1);
              Cells[3,RowCount-1] := 'stabil';
            end;
          end
          else if DM.ETNukl.FieldByName('Tsek').AsFloat <> 0 then
            Cells[3,RowCount-1] := ZeitFormat(DM.ETNukl.FieldByName('Tsek').AsFloat);
      end
      else if Pos(';',temp1) > 0 then
      begin
        temp2 := Trim(Copy(temp1,1,Pos(';',temp1)-1));
        Cells[1,RowCount-1] := temp2;
        if DM.ETDM.Locate('D_MODE',temp2,[]) and
          (DM.ETDM.FieldByName('RTYP').asFloat > 0) then
        begin
          d := DM.ETDM.FieldByName('RTYP').asFloat;
          if DM.ETDMI.Locate('iZA;RTYP',VarArrayOf([iza,d]),[]) then
          begin
            for i := 0 to ColCount - 1 do
            begin
              ColorCell[i,RowCount-1] :=
                DM.RadFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
              CellFont[i,RowCount-1].Color :=
                DM.RadFontFarbe(DM.ETDMI.FieldByName('RTYP1').AsInteger);
                //KontrastFarbe(ColorCell[i,RowCount-1],2);
            end;
            if DM.ETDMI.FieldByName('BR').AsFloat <> 0 then
              Cells[2,RowCount-1] :=
                FloatToStr(DM.ETDMI.FieldByName('BR').AsFloat) + ' %';
            if {(d <> 3) and} (DM.ETDMI.FieldByName('DQ').AsFloat > 0) then
              Cells[4,RowCount-1] :=
                FloatToStr(DM.ETDMI.FieldByName('DQ').AsFloat) + ' keV'
            else if (d = 3) and DM.ETNukl.Locate('iZA',iza,[]) and
              (DM.ETNukl.FieldByName('El').AsFloat <> 0) then
              Cells[4,RowCount-1] :=
                FloatToStr(DM.ETNukl.FieldByName('El').AsFloat) + ' keV';
            if DM.ETDMI.FieldByName('DAUGHTER').AsInteger > 0 then
              Cells[5,RowCount-1] :=
                DM.GetNukBez(DM.ETDMI.FieldByName('DAUGHTER').AsInteger,True)
            else if temp2 = 'SF' then Cells[5,RowCount-1] := '?';
          end;
        end;
      end;
    end;
  end;
end;

end.
