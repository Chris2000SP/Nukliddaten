unit UnitNuk;

interface

uses Windows, Types, SysUtils, Classes, Math, Graphics, Grids, Aligrid, icongrid,
     DB, ExtCtrls, Controls, StdCtrls, ComCtrls, Dialogs, Variants, Forms,
     EasyTable;

  function  Alpha(iZA: Integer): Boolean;
  function  Beta(iZA: Integer): Boolean;
  function  CheckLedOn(Idx,iza: Integer): Boolean;
  function  ClearGridRad(RGrid: TIconGrid): Boolean;
  function  ClearGridRadDat: Boolean;
  function  ClearGridReihe(Erste: Boolean): Boolean;
  function  ClearGridForDaten(XGrid: TIconGrid;Idx: Integer;Kopf: Boolean): Boolean;
  function  Gamma(iZA: Integer): Boolean;
  procedure GridAktPos(xCol,xRow: Integer);
  procedure KeineNuklide(XGrid: TIconGrid;txt: String);
  function  LeseNukExplorer(TV: TTreeView;idx: Integer;Start: Boolean): Boolean;
  function  LeseNukKarte: Boolean;
  procedure MaleSchema(iza: Integer;rtyp,DQL: Double);
  procedure Nukliddaten(Symbol: String;Wahr: Boolean);
  procedure NukEck(Canv: TCanvas;R: TRect;Typ: Integer;Farbe: TColor);
  procedure NukKarteKonf;
  procedure PosGridRadScrollbar(iZA: Integer);
  procedure PosGridReihe(XPos,YPos: Integer);
  procedure PosGridSuchKarteScrollbar(iZA: Integer);
  procedure PosNuk(XCol,XRow: Integer);
  procedure PosNukReihe(XCol,XRow: Integer;Alle: Boolean);
  procedure PosPanelLeg;
  procedure PosPanels;
  procedure RadAlle;
  function  RadBack(iZA: Integer): Boolean;
  function  RadBackAlle(iZA: Integer): Boolean;
  function  RadDaten(txt: String): Boolean;
  function  RadGridAlle: Boolean;
  function  RadReihe(iZA: Integer): Boolean;
  function  ResetBtnGam: Boolean;
  function  ResetCBs(Alle: Boolean): Boolean;
  procedure RGSuchItems;
  procedure RGSuchIndex;
  function  RTypBtn(idx: Integer;rtyp,DQL: Double): Boolean;
  function  SetRadAlle(minn,maxn,minz,maxz: Integer): Boolean;
  function  SetNukLeg(idx: Integer): Boolean;
  function  TVSuchNuk(TV: TTreeView;txt,btn: String): Boolean;
  function  XRay(iZA: Integer): Boolean;
  procedure ZeigeAlpha(i,iza: Integer);
  procedure ZeigeBeta(i,iza: Integer;ET: TEasyTable);
  procedure ZeigeXRay(i,iza: Integer;ET: TEasyTable);
  procedure ZerfallsreiheDaten(txt: String;NMode: Integer);

implementation

uses UnitMain, UnitDM, UnitNukFunc;

function Alpha(iZA: Integer): Boolean;
var
  i,i1: Integer;
  temp: String;
begin
  i := 1;
  frmMain.SBGridRad.Visible := False;
  ClearGridForDaten(frmMain.GridReihe,1,True);
  with frmMain.GridReihe do
  begin
    if frmMain.RGGamSort.ItemIndex = 1 then
      DM.ETA.IndexName := 'ByIa' else DM.ETA.IndexName := 'ByEa';
    DM.ETA.Filter := 'iZA = ' + IntToStr(iZA);
    if DM.ETA.FindFirst then
    repeat
      if RowCount < i+1 then RowCount := i+1;
      for i1 := 0 to ColCount-1 do ColorCell[i1,i] := clInfoBk;
      if DM.ETA.FieldByName('Ea').AsFloat <> 0 then
      begin
        temp := Runde(DM.ETA.FieldByName('Ea').AsFloat,-3);
        if DM.ETA.FieldByName('Eau').AsFloat <> 0 then
          temp := temp + '   ' + Runde(DM.ETA.FieldByName('Eau').AsFloat,-2);
        Cells[1,i] := temp;
      end;
      if DM.ETA.FieldByName('Ia').AsFloat <> 0 then
      begin
        temp := Runde(DM.ETA.FieldByName('Ia').AsFloat,-3);
        if DM.ETA.FieldByName('Iau').AsFloat <> 0 then
          temp := temp + '   ' + Runde(DM.ETA.FieldByName('Iau').AsFloat,-3);
        Cells[2,i] := temp;
      end;
      Inc(i);
    until DM.ETA.FindNext = False;
    DM.ETA.Filter := '';
    if i = 1 then KeineNuklide(frmMain.GridReihe,'Alpha');
    {begin
      Cells[1,i] := 'Keine Alpha-';
      Cells[2,i] := 'Emissions-Daten vorh.';
      //Cells[3,i] := 'vorhanden';
    end;}
    frmMain.SBGridReihe.VertScrollBar.Range := (i+1) * DefaultRowHeight;
  end;
  Result := True;
end;

function Beta(iZA: Integer): Boolean;
var
  i,i1: Integer;
  temp: String;
begin
  i := 1;
  frmMain.SBGridRad.Visible := False;
  ClearGridForDaten(frmMain.GridReihe,2,True);
  with frmMain.GridReihe do
  begin
    if frmMain.RGGamSort.ItemIndex = 1 then
      DM.ETB.IndexName := 'ByIb' else DM.ETB.IndexName := 'ByEb';
    DM.ETB.Filter := 'iZA = ' + IntToStr(iZA);
    if DM.ETB.FindFirst then
    repeat
      if RowCount < i+1 then RowCount := i+1;
      for i1 := 0 to ColCount-1 do ColorCell[i1,i] := clInfoBk;
      if DM.ETB.FieldByName('Eb').AsFloat <> 0 then
      begin
        temp := Runde(DM.ETB.FieldByName('Eb').AsFloat,-3);
        if DM.ETB.FieldByName('Ebu').AsFloat <> 0 then
          temp := temp + '   ' + Runde(DM.ETB.FieldByName('Ebu').AsFloat,-2);
        Cells[1,i] := temp;
      end;
      if DM.ETB.FieldByName('Ib').AsFloat <> 0 then
      begin
        temp := Runde(DM.ETB.FieldByName('Ib').AsFloat,-3);
        if DM.ETB.FieldByName('Ibu').AsFloat <> 0 then
          temp := temp + '   ' + Runde(DM.ETB.FieldByName('Ibu').AsFloat,-3);
        Cells[2,i] := temp;
      end;
      Cells[3,i] := DM.Zerfallart(DM.ETB.FieldByName('DMode').AsFloat);
      Inc(i);
    until DM.ETB.FindNext = False;
    DM.ETB.Filter := '';
    if i = 1 then KeineNuklide(frmMain.GridReihe,'Beta');
    frmMain.SBGridReihe.VertScrollBar.Range := (i+1) * DefaultRowHeight;
  end;
  Result := True;
end;

function CheckLedOn(Idx,iza: Integer): Boolean;
begin
  case Idx of
    1: begin
         DM.ETA.DisableControls;
         Result := DM.ETA.Locate('iZA',iza,[]);
         DM.ETA.EnableControls;
       end;
    2: begin
         DM.ETB.DisableControls;
         Result := DM.ETB.Locate('iZA',iza,[]);
         DM.ETB.EnableControls;
       end;
    3: begin
         DM.ETG.DisableControls;
         Result := DM.ETG.Locate('iZA',iza,[]);
         DM.ETG.EnableControls;
       end;
    4: begin
         DM.ETXI.DisableControls;
         Result := DM.ETXI.Locate('iZA',iza,[]);
         DM.ETXI.EnableControls;
       end;
    5: Result := False;
  else Result := False;
  end;
end;

function ClearGridRad(RGrid: TIconGrid): Boolean;
var
  i,i1,n,z,iza: Integer;
  temp: String;
begin
  with RGrid do
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
      iza := DM.ETNukl.FieldByName('iZA').AsInteger;
      if (iza mod 10 = 0) or (iza = 1) then
      begin
        z := DM.GetZ(iza);
        n := DM.GetN(iza);
        temp := DM.GetSymb(iza);
        if DM.ETNukl.FieldByName('Tsek').AsFloat = -99 then
          ColorCell[n+1,RowCount-z-1] := clBtnFace
        else ColorCell[n+1,RowCount-z-1] := clWhite;
      end;
      DM.ETNukl.Next;
    end;
  end;
  PosGridSuchKarteScrollbar(10010);
  if RGrid.Name = 'GridRad' then
    Result := ClearGridReihe(False)
  else Result := True;
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
  frmMain.PanelRadNuk.Caption := '';
  Result := True;
end;

function  ClearGridReihe(Erste: Boolean): Boolean;
var i,i1: Integer;
begin
  with frmMain.GridReihe do
  begin
    Color := $00FFFFCC;
    ResetColorCellAll;
    ResetHintCellAll;
    for i := 0 to ColCount - 1 do
      for i1 := 0 to RowCount - 1 do
      begin
        ColorCell[i,i1] := Color;
        Cells[i,i1] := '';
        //HintCell[i,i1] := '';
      end;
    ColCount := 1;
    RowCount := 3;
  end;
  Result := True;
end;

function ClearGridForDaten(XGrid: TIconGrid;Idx: Integer;Kopf: Boolean): Boolean;
var i,i1: Integer;
  Wahr: Boolean;
begin
  with XGrid do
  begin
    if Name = 'GridReihe' then
      if (Idx >= 1) and (Idx <= 5) then
        Color := clInfoBk else Color := $00FFFFCC;
    for i := 0 to ColCount - 1 do
      for i1 := 0 to RowCount - 1 do
      begin
        Cells[i,i1] := '';
        HintCell[i,i1] := '';
        ColorCell[i,i1] := Color;
        CellFont[i,i1].Style := [fsBold];
      end;
    if not Kopf then
      RowCount := 2
    else
    begin
      if Idx = 1 then  // Alpha
      begin
        RowCount := 2;
        if Name = 'GridReihe' then
        begin
          ColCount := 3;
          DefaultColWidth := 180;
          ColWidths[0] := 160;
          for i := 0 to ColCount-1 do ColorCell[i,0] := clInfoBk;
          Cells[1,0] := 'Energie (keV)';
          Cells[2,0] := 'Intensit�t (%)';
        end
        else
        begin
          ColCount := 5;
          DefaultColWidth := 160;
          ColWidths[0] := 80;
          for i := 0 to ColCount-1 do CellFont[i,0].Color := clNavy;
          Cells[1,0] := 'Energie (keV)';
          Cells[2,0] := 'Intensit�t (%)';
          Cells[3,0] := 'Halbwertzeit';
          Cells[4,0] := 'Ausgangsnuklid';
        end;
      end;
      if Idx = 2 then  // Beta
      begin
        RowCount := 2;
        if Name = 'GridReihe' then
        begin
          ColCount := 4;
          DefaultColWidth := 180;
          ColWidths[0] := 160;
          for i := 0 to ColCount-1 do
          begin
            CellFont[i,0].Size := 8;
            ColorCell[i,0] := clInfoBk;
          end;
          Cells[1,0] := 'Endpunkt-Energie(keV)';
          Cells[2,0] := 'Intensit�t (%)';
          Cells[3,0] := 'Zerfallsart';
        end
        else
        begin
          ColCount := 5;
          DefaultColWidth := 150;
          for i := 0 to ColCount-1 do CellFont[i,0].Color := clNavy;
          Cells[0,0] := 'Endpunkt-Energie(keV)';
          Cells[1,0] := 'Intensit�t (%)';
          Cells[2,0] := 'Halbwertzeit';
          Cells[3,0] := 'Zerfallsart';
          Cells[4,0] := 'Ausgangsnuklid';
        end;
      end;
      if Idx = 3 then  // Gamma
      begin
        RowCount := 2;
        if Name = 'GridReihe' then
        begin
          ColCount := 4;
          DefaultColWidth := 180;
          ColWidths[0] := 160;
          for i := 0 to ColCount-1 do ColorCell[i,0] := clInfoBk;
          Cells[1,0] := 'Energie (keV)';
          Cells[2,0] := 'Intensit�t (%)';
          Cells[3,0] := 'Zerfallsart';
        end
        else
        begin
          ColCount := 5;
          DefaultColWidth := 150;
          for i := 0 to ColCount-1 do CellFont[i,0].Color := clNavy;
          Cells[0,0] := 'Energie (keV)';
          Cells[1,0] := 'Intensit�t (%)';
          Cells[2,0] := 'Halbwertzeit';
          Cells[3,0] := 'Zerfallsart';
          Cells[4,0] := 'Ausgangsnuklid';
        end;
      end;
      if Idx = 4 then  // X-Ray
      begin
        RowCount := 2;
        if Name = 'GridReihe' then
        begin
          ColCount := 4;
          DefaultColWidth := 180;
          ColWidths[0] := 160;
          for i := 0 to ColCount-1 do ColorCell[i,0] := clInfoBk;
          Cells[1,0] := 'Energie (keV)';
          Cells[2,0] := 'Intensit�t (%)';
          Cells[3,0] := 'Zuordnung';
        end
        else
        begin
          ColCount := 7;
          DefaultColWidth := 126;
          ColWidths[0] := 100;
          ColWidths[1] := 40;
          for i := 0 to ColCount-1 do CellFont[i,0].Color := clNavy;
          Cells[0,0] := 'Zuordnung';
          Cells[1,0] := 'Z';
          Cells[2,0] := 'Energie (keV)';
          Cells[3,0] := 'K-Schale';
          Cells[4,0] := 'L_1^-Schale';
          Cells[5,0] := 'L_2^-Schale';
          Cells[6,0] := 'L_3^-Schale';
        end;
      end;
      if Idx = 7 then  // Nuklidsuche
      begin
        ColCount := 8;
        RowCount := 2;
        DefaultColWidth := 99;
        ColWidths[1] := 48;
        ColWidths[2] := 40;
        ColWidths[3] := 240;
        ColWidths[5] := 89;
        ColWidths[6] := 66;
        ColWidths[7] := 89;
        for i := 0 to ColCount-1 do CellFont[i,0].Color := clNavy;
        Cells[0,0] := 'Nuklid';
        Cells[1,0] := 'Z';
        Cells[2,0] := 'N';
        Cells[3,0] := 'Zerfallsart(en)';
        Cells[4,0] := 'Halbwertzeit';
        Cells[5,0] := 'Energie(keV)';
        Cells[6,0] := 'Spin';
        Cells[7,0] := 'H�ufigkeit(%)';
        OnSelectCell(XGrid,0,1,Wahr);
      end;
      if (XGrid.Name = 'GridReihe') and (Idx >= 1) and (Idx <= 5) then
        frmMain.SBGridReihe.HorzScrollBar.Range := (ColCount * DefaultColWidth)-4;
      if Idx = 6 then
      begin
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
        frmMain.SBGridReihe.HorzScrollBar.Range := i1 - 3;
      end;
    end;
  end;
  Result := True;
end;

function Gamma(iZA: Integer): Boolean;
var
  i,i1: Integer;
  temp: String;
begin
  i := 1;
  frmMain.SBGridRad.Visible := False;
  ClearGridForDaten(frmMain.GridReihe,3,True);
  with frmMain.GridReihe do
  begin
    if frmMain.RGGamSort.ItemIndex = 1 then
      DM.ETG.IndexName := 'ByIg' else DM.ETG.IndexName := 'ByEg';
    DM.ETG.Filter := 'iZA = ' + IntToStr(iZA);
    if DM.ETG.FindFirst then
    repeat
      if DM.ETG.FieldByName('Ig').AsFloat <> -1 then
      begin
        if RowCount < i+1 then RowCount := i+1;
        for i1 := 0 to ColCount-1 do ColorCell[i1,i] := clInfoBk;
        if DM.ETG.FieldByName('Eg').AsFloat <> 0 then
        begin
          temp := Runde(DM.ETG.FieldByName('Eg').AsFloat,-3);
          if DM.ETG.FieldByName('Egu').AsFloat <> 0 then
            temp := temp + '   ' + Runde(DM.ETG.FieldByName('Egu').AsFloat,-2);
          Cells[1,i] := temp;
        end;
        if DM.ETG.FieldByName('Ig').AsFloat <> 0 then
        begin
          temp := Runde(DM.ETG.FieldByName('Ig').AsFloat,-3);
          if DM.ETG.FieldByName('Igu').AsFloat <> 0 then
            temp := temp + '   ' + Runde(DM.ETG.FieldByName('Igu').AsFloat,-3);
          Cells[2,i] := temp;
        end;
        Cells[3,i] := DM.Zerfallart(DM.ETG.FieldByName('DMode').AsFloat);
        Inc(i);
      end;
    until DM.ETG.FindNext = False;
    DM.ETG.Filter := '';
    if i = 1 then KeineNuklide(frmMain.GridReihe,'Gamma');
    {begin
      Cells[1,i] := 'Keine Gamma-';
      Cells[2,i] := 'Emissions-Daten';
      Cells[3,i] := 'vorhanden';
    end;}
    frmMain.SBGridReihe.VertScrollBar.Range := (i+1) * DefaultRowHeight;
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

procedure KeineNuklide(XGrid: TIconGrid;txt: String);
begin
  if ClearGridForDaten(XGrid,1,False) then
  begin
    XGrid.ColCount := 1;
    XGrid.ColWidths[0] := 770;
    if XGrid.Name = 'GridSuch' then
    begin
      XGrid.Cells[0,1] := 'Keine ' + txt + ' f�r diese Vorgaben vorhanden';
      frmMain.lblAnz.Caption := 'Gefunden: 0';
    end else XGrid.Cells[0,1] := 'Keine ' + txt + '-Emissions-Daten vorhanden';
  end;
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
            if (FieldByName('Tsek').AsFloat = -99) or
              (FieldByName('Tsek').AsFloat > Power(10,18)) then
              TNode2.ImageIndex := 13
            else TNode2.ImageIndex := 12;
            TNode2.StateIndex := - 1;
            TNode2.SelectedIndex := TNode2.ImageIndex;
          end
          else if i <> 30030 then
          begin
            temp := IntToStr(DM.GetZ(i))+#32+Symbol+#32+IntToStr(DM.GetA(i));
            TNode2 := TV.Items.AddChild(TNode1,temp);
            if (FieldByName('Tsek').AsFloat = -99) or
              (FieldByName('Tsek').AsFloat > Power(10,18)) then
              TNode2.ImageIndex := 13
            else TNode2.ImageIndex := 12;
            TNode2.StateIndex := - 1;
            TNode2.SelectedIndex := TNode2.ImageIndex;
          end;
        end
        else if (i mod 10 = 0) then
        begin
          temp := IntToStr(DM.GetZ(i))+#32+Symbol+#32+IntToStr(DM.GetA(i));
          TNode2 := TV.Items.AddChild(TNode1,temp);
          if (FieldByName('Tsek').AsFloat = -99) or
              (FieldByName('Tsek').AsFloat > Power(10,18)) then
            TNode2.ImageIndex := 13
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
          if (FieldByName('Tsek').AsFloat = -99) or
              (FieldByName('Tsek').AsFloat > Power(10,18)) then
            TNode4.ImageIndex := 13
          else TNode4.ImageIndex := 12;
          TNode4.StateIndex := - 1;
          TNode4.SelectedIndex := TNode4.ImageIndex;
          if i = 922350 then tvri := frmMain.TVRad.Items.Count - 1;
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
    frmMain.TVRadIdx := tvri;
  end
  else if idx > 0 then
  begin
    TV.Items[idx].Parent.Expand(False);
    TV.Items[idx].Selected := True;
  end;
  Result := True;
end;

function  LeseNukKarte: Boolean;
  function NucCol(z,n: Integer;tsec: Double;stab: Boolean): Integer;
  begin
    if stab and (tsec = -99) then Result := 10
    else if z = n then Result := 5
    else if (z mod 2 = 0) and (n mod 2 = 0) then Result := 1
    else if (z mod 2 = 0) and (n mod 2 = 1) then Result := 2
    else if (z mod 2 = 1) and (n mod 2 = 0) then Result := 3
    else if (z mod 2 = 1) and (n mod 2 = 1) then Result := 4
    else Result := 9;
  end;
var
  iza,z,n,r,reihe,ch: Integer;
  d: Double;
begin
  reihe := frmMain.GridNuk.RowCount;
  ch := frmMain.CBHalf.ItemIndex;
  DM.ETName.DisableControls;
  with DM.ETNukl do
  begin
    DisableControls;
    First;
    while not Eof do
    begin
      iza := FieldByName('iZA').AsInteger;
      z := DM.GetZ(iza);
      n := DM.GetN(iza);
      if (iza mod 10 = 0) or (iza = 1) then
      begin
        case ch of
          1: d := FieldByName('Tsek').AsFloat;
          2: d := FieldByName('BE').AsFloat;
          3: d := FieldByName('MassExc').AsFloat;
          4: d := FieldByName('Sn').AsFloat;
          5: d := FieldByName('Sp').AsFloat;
        else d := FieldByName('Tsek').AsFloat;
        end;
        if ch = 0 then
        begin
          if d = -99 then r := 10  // or (d > Power(10,18))
          else if FieldByName('Max_RTyp').AsInteger > 0 then
            r := FieldByName('Max_RTyp').AsInteger
          else r := 0;
        end
        else if ch = 1 then
        begin
          if (d = -99) or (d > Power(10,17)) then r := 10
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
        else if ch = 2 then// Bindungsenergie
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
        else if ch = 3 then// Mass Excess
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
        else if ch = 4 then// Neutron Seperationsenergie
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
        else if ch = 5 then// Proton Seperationsenergie
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
        else if ch = 6 then
        begin
          if FieldByName('Exp').AsBoolean = True then
            r := 2
          else r := 0;
        end
        else if ch = 7 then
        begin
          if (iza > 1) and (d = -99) then// or (d > Power(10,15)) then
          begin
            if z = n then r := 5
            else if (z mod 2 = 0) and (n mod 2 = 0) then r := 1
            else if (z mod 2 = 0) and (n mod 2 = 1) then r := 2
            else if (z mod 2 = 1) and (n mod 2 = 0) then r := 3
            else if (z mod 2 = 1) and (n mod 2 = 1) then r := 4
            else r := 9;
          end else r := 9
        end
        else if (ch = 8) then
          if (iza > 1) and ((d = -99) or (d > Power(10,15))) then
            r := NucCol(z,n,d,False) else r := 9
        else if (ch = 9) then
          if (iza > 1) and ((d = -99) or ((d >= 31536000) and (d < Power(10,15)))) then
            r := NucCol(z,n,d,False) else r := 9
        else if (ch = 10) then
          if (iza > 1) and ((d = -99) or ((d >= 2592000) and (d < 31536000))) then
            r := NucCol(z,n,d,True) else r := 9
        else if (ch = 11) then
          if (iza > 1) and ((d = -99) or ((d >= 86400) and (d < 2592000))) then
            r := NucCol(z,n,d,True) else r := 9
        else if (ch = 12) then
          if (iza > 1) and ((d = -99) or ((d >= 3600) and (d < 86400))) then
            r := NucCol(z,n,d,True) else r := 9
        else if (ch = 13) then
          if (iza > 1) and ((d = -99) or ((d >= 60) and (d < 3600))) then
            r := NucCol(z,n,d,True) else r := 9
        else if (ch = 14) then
          if (iza > 1) and ((d = -99) or ((d >= 1) and (d < 60))) then
            r := NucCol(z,n,d,True) else r := 9
        else if (ch = 15) then
          if (iza > 1) and ((d = -99) or (d < 1)) then
            r := NucCol(z,n,d,True) else r := 9
        else if ch = 16 then r := NucCol(z,n,d,True)
        else r := 0;
        frmMain.GridNuk.ColorCell[n+1,reihe-z-6] := frmMain.NukF[r];
        frmMain.GridNuk.HintCell[n+1,reihe-z-6] := IntToStr(DM.GetZ(iza)) +
          #32 + DM.GetSymb(iza) + #32 + IntToStr(DM.GetA(iza));
        frmMain.GridMin.ColorCell[n+5,reihe-z-3] := frmMain.NukF[r];
        frmMain.GridMin.HintCell[n+5,reihe-z-3] := '     ' +
          frmMain.GridNuk.HintCell[n+1,reihe-z-6];
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
    PanelZoom.Left := PanelGridDat.Width+2;
    PanelZoom.Top := 2;
    PanelNukDis := TPanel.Create(SBNuk);
    PanelNukDis.Parent := SBNuk;
    PanelNukDis.Width := 20;//50;
    PanelNukDis.BevelOuter := bvNone;
    PanelNukDis.BorderStyle := bsNone;
    PanelNukDis.Caption := '';
    PanelNukDis.Color := $00FFFFCC;
    PanelNukDis.Align := alLeft;
    PanelNukDis.Visible := False;
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
    PanelGamma := TPanel.Create(PanelTVRad);
    PanelGamma.Parent := PanelTVRad;
    PanelGamma.Height := 175;//155;
    PanelGamma.BorderStyle := bsSingle;
    PanelGamma.BevelInner := bvNone;
    PanelGamma.BevelOuter := bvNone;
    PanelGamma.Align := alTop;
    PanelGamma.Color := $00FFFFCC;
    PanelTVRadBtn := TPanel.Create(PanelTVRad);
    PanelTVRadBtn.Parent := PanelTVRad;
    PanelTVRad.BorderStyle := bsNone;
    PanelTVRadBtn.Height := 22;
    PanelTVRadBtn.Align := alTop;
    PanelTVRadBtn.Color := $00FFFFCC;
    PanelRadNuk := TPanel.Create(PanelGamma);
    PanelRadNuk.Name := 'PanelRadNuk';
    PanelRadNuk.Parent := PanelGamma;
    PanelRadNuk.Height := 20;
    PanelRadNuk.BorderStyle := bsSingle;
    PanelRadNuk.BevelInner := bvNone;
    PanelRadNuk.BevelOuter := bvNone;
    PanelRadNuk.Align := alTop;
    PanelRadNuk.Color := clInfoBk;
    PanelRadNuk.Font.Style := [fsBold];
    PanelRadNuk.Visible := False;
    btnA.Parent := PanelGamma;
    btnB.Parent := PanelGamma;
    btnG.Parent := PanelGamma;
    btnX.Parent := PanelGamma;
    btnSchema.Parent := PanelGamma;
    btnA.Name := 'btnA';
    btnB.Name := 'btnB';
    btnG.Name := 'btnG';
    btnX.Name := 'btnX';
    btnSchema.Name := 'btnSchema';
    btnA.AllowAllUp := True;
    btnB.AllowAllUp := True;
    btnG.AllowAllUp := True;
    btnX.AllowAllUp := True;
    btnA.GroupIndex := 2;
    btnB.GroupIndex := 2;
    btnG.GroupIndex := 2;
    btnX.GroupIndex := 2;
    btnA.Tag := 1;
    btnB.Tag := 2;
    btnG.Tag := 3;
    btnX.Tag := 4;
    btnSchema.Tag := 9;
    btnA.Width := 150;
    btnB.Width := 150;
    btnG.Width := 150;
    btnX.Width := 150;
    btnSchema.Width := 150;
    btnA.Height := 18;
    btnB.Height := 18;
    btnG.Height := 18;
    btnX.Height := 18;
    btnSchema.Height := 18;
    btnA.Font.Style := [fsBold];
    btnB.Font.Style := [fsBold];
    btnG.Font.Style := [fsBold];
    btnX.Font.Style := [fsBold];
    btnSchema.Font.Style := [fsBold];
    btnA.Caption := 'Alpha-Emissionen';
    btnB.Caption := 'Beta-Emissionen';
    btnG.Caption := 'Gamma-Emissionen';
    btnX.Caption := 'R�ntgen-Emissionen';
    btnSchema.Caption := 'Zerfallsschema';
    btnA.Top := 15; //(PanelGamma.ClientHeight - (btnA.Height * 4) - 40) div 2;
    btnB.Top := btnA.Top + btnA.Height;
    btnG.Top := btnB.Top + btnB.Height;
    btnX.Top := btnG.Top + btnG.Height;
    btnA.Left := (PanelGamma.ClientWidth - btnA.Width) div 2;
    btnB.Left := btnA.Left;
    btnG.Left := btnA.Left;
    btnX.Left := btnA.Left;
    btnSchema.Left := btnA.Left;
    btnA.OnClick := btnGamClick;
    btnB.OnClick := btnGamClick;
    btnG.OnClick := btnGamClick;
    btnX.OnClick := btnGamClick;
    btnSchema.OnClick := ShowPage;
    RGGamSort := TRadioGroup.Create(PanelGamma);
    RGGamSort.Name := 'RGGamSort';
    RGGamSort.Font.Charset := ANSI_CHARSET;
    RGGamSort.Font.Name := 'Arial';//'MS Sans Serif';
    RGGamSort.Font.Style := [];
    RGGamSort.Parent := PanelGamma;
    RGGamSort.ParentColor := True;
    RGGamSort.Columns := 2;
    RGGamSort.Caption := 'Sortieren nach';
    RGGamSort.Items.Add('Energie');
    RGGamSort.Items.Add('Intensit�t');
    RGGamSort.ItemIndex := 0;
    RGGamSort.Height := 35;
    RGGamSort.Width := btnA.Width;
    RGGamSort.Left := (PanelGamma.ClientWidth - RGGamSort.Width) div 2;
    RGGamSort.Top := btnX.Top + btnX.Height+5;
    RGGamSort.OnClick := RGGamSortClick;
    btnSchema.Top := RGGamSort.Top + RGGamSort.Height + 13;
    GridRadDat := TIconGrid.Create(PanelGamma);
    GridRadDat.Name := 'GridRadDat';
    GridRadDat.Parent := PanelGamma;
    GridRadDat.Align := alClient;
    GridRadDat.ColCount := 3;
    GridRadDat.RowCount := 8;
    GridRadDat.DefaultRowHeight := 18;
    GridRadDat.Alignment := alCenter;
    GridRadDat.ScrollBars := ssNone;
    GridRadDat.DrawSelection := False;
    GridRadDat.ShowHint := True;
    GridRadDat.ShowCellHints := True;
    GridRadDat.FixedCols := 0;
    GridRadDat.FixedRows := 1;
    GridRadDat.FixedColor := $00FFFFCC;
    GridRadDat.FixedRowFont[0].Style := [fsBold];
    GridRadDat.FixedRowFont[0].Color := clNavy;
    GridRadDat.Color := clInfoBk;
    GridRadDat.Font.Style := [fsBold];
    GridRadDat.ColWidths[0] := 66;
    GridRadDat.ColWidths[1] := 60;//70;
    GridRadDat.ColWidths[2] := 86;//76;
    GridRadDat.Cells[0,0] := 'Zerfallsart';
    GridRadDat.Cells[1,0] := 'BR %';
    GridRadDat.HintCell[1,0] := 'Zerfalls-Wahrscheinlichkeit in %';
    GridRadDat.Cells[2,0] := 'Tochternuklid';
    GridRadDat.OnSelectCell := GridSelectCell;
    GridRadDat.OnShowHintCell := GridShowHintCell;
    GridRadDat.OnDrawCell := GridRadDatDrawCell;
    GridRadDat.Visible := False;
    btnTVRadSuch.Parent := PanelTVRadBtn;
    btnTVRadSuch.Align := alRight;
    btnRadSort.Parent := PanelTVRadBtn;
    btnRadSort.Align := alClient;
    TVRad.Parent := PanelTVRad;
    TVRad.Align := alClient;
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
    GridReihe.Font.Charset := ANSI_CHARSET;
    GridReihe.Font.Name := 'MS Sans Serif'; //'Arial';
    GridReihe.Font.Size := 8;
    GridReihe.Font.Style := [fsBold];
    GridReihe.Color := $00FFFFCC;
    GridReihe.ScrollBars := ssNone;// ssBoth;
    GridReihe.DrawSelection := False;
    GridReihe.ShowCellHints := True;
    GridReihe.OnShowHintCell := GridShowHintCell;
    GridReihe.OnSelectCell := GridSelectCell;
    GridReihe.OnDrawCell := GridReiheDrawCell;
    GridReihe.OnClick := GridReiheClick;
    PanelMin.Visible := False;
    PanelLeg.Parent := PC.Pages[1];
    PanelLeg.Hint := 'Zerfall bzw. Emission';
    PanelIso.Parent := GridNuk;
    PanelIso.Left := 50;
    PanelIso.Top := 220;
    PanelProton.Parent := GridNuk;
    PanelProton.Top := 320;
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
    LegLbl[13].Caption := 'Isomerer �bergang';
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
      Cells[0,5] := 'Atommasse in u';
      Cells[0,6] := 'H�ufigkeit in %';
      Cells[0,7] := 'Halbwertzeit';
      HintCell[1,7] := 'as = Attosek.'+#13#10+
                       'fs = Femtosek.'+#13#10+
                       'ps = Pikosek.'+#13#10+
                       'ns = Nanosek.'+#13#10+
                       'us = Mikrosek.'+#13#10+
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

procedure MaleSchema(iza: Integer;rtyp,DQL: Double);
  procedure SymF(Canv: TCanvas;x,y: Integer;txt: String;TA: Boolean);
  var temp: String;
  begin
    with Canv do
    begin
      temp := Copy(txt,1,Pos(#32,txt)-1);
      TextOut(x,y,temp);
      Font.Charset := SYMBOL_CHARSET;
      Font.Name := 'Symbol';
      Textout(x+TextWidth(temp)+2,y,chr(109)); //m
      temp := temp + 'm';
      if TA then
      begin
        Font.Charset := ANSI_CHARSET;
        Font.Name := 'Arial';
      end
      else
      begin
        Font.Charset := DEFAULT_CHARSET;
        Font.Name := 'Tahoma';
      end;
      Textout(x+TextWidth(temp),y,'s');
    end;
  end;
var
  i,i1,i2,i3,i4,i5,h,w,ws,th,tw,tiza,anza,anzb,anzg,anzls: Integer;
  A,Z,N,temp: String;
  d,d1,DQ,DQIT,toplev,hwz,br,trtyp: Double;
  Wahr,BP,EC,BPEC: Boolean;
  R: TRect;
  p1,p2: TPoint;
  levsort: array of Double;
  alph,bet,gamm: array of array of Double;
begin
  frmMain.bmpS.FreeImage;
  frmMain.bmpS.Width := 100;
  frmMain.bmpS.Height := 100;
  frmMain.SBSchema.HorzScrollBar.Position := 0;
  frmMain.SBSchema.VertScrollBar.Position := 0;
  frmMain.PBSchema.Canvas.Brush.Color := $00FFFFCC;
  frmMain.PBSchema.Canvas.FillRect(frmMain.PBSchema.ClientRect);
  anza := 0; anzb := 0; anzg := 0; anzls := 0;
  DQ := 0; tiza := 0; hwz := 0; DQIT := 0; br := 0; trtyp := 0;
  BP := False; EC := False; BPEC := False;
  if DM.ETDMI.Locate('iZA',iza,[]) then
  begin
    DM.ETDMI.Filter := 'iZA = ' + IntToStr(iza);
    if DM.ETDMI.FindFirst then
    repeat
      d1 := DM.ETDMI.FieldByName('RTYP').AsFloat;
      if d1 = 2 then BP := True;
      if d1 = 8 then EC := True;
      if BP and EC and (rtyp = 8) then BPEC := True;
      if d1 = rtyp then
      begin
        if DM.ETDMI.FieldByName('DQ').AsFloat = DQL then
        begin
          DQ := DM.ETDMI.FieldByName('DQ').AsFloat;
          if (DM.ETDMI.FieldByName('BR').AsFloat <> 0) then
            br := DM.ETDMI.FieldByName('BR').AsFloat;
          tiza := DM.ETDMI.FieldByName('Tochter').AsInteger;
          if (tiza mod 10 > 0) and (DM.ETDMI.FieldByName('TRTYP').AsFloat <> 0) then
            trtyp := DM.ETDMI.FieldByName('TRTYP').AsFloat;
        end;
        if {(d1 <> 3) and} (DQL < DM.ETDMI.FieldByName('DQ').AsFloat) then BPEC := True;
        frmMain.lblDB.Caption := DBDaten(DM.ETDMI.FieldByName('DB').AsInteger);
      end;
      if (iza mod 10 > 0) and (DM.ETDMI.FieldByName('El').AsFloat <> 0) then
        DQIT := DM.ETDMI.FieldByName('El').AsFloat;
    until DM.ETDMI.FindNext = False;
    DM.ETDMI.Filter := '';
  end;
  if DM.ETA.Locate('iZA',iza,[]) then
  begin
    DM.ETA.Filter := 'iZA = ' + IntToStr(iza);
    if DM.ETA.FindFirst then
    repeat
      if (rtyp = 4) and (DM.ETA.FieldByName('Level').AsFloat <> 0) then
      begin
        Inc(anza);
        SetLength(alph,anza);
        SetLength(alph[anza-1],3);
        alph[anza-1,0] := DM.ETA.FieldByName('Ea').AsFloat;
        alph[anza-1,1] := DM.ETA.FieldByName('Level').AsFloat;
        alph[anza-1,2] := DM.ETA.FieldByName('Ia').AsFloat;
      end;
    until DM.ETA.FindNext = False;
    DM.ETA.Filter := '';
  end;
  if DM.ETB.Locate('iZA',iza,[]) and not BPEC then
  begin
    DM.ETB.Filter := 'iZA = ' + IntToStr(iza);
    if DM.ETB.FindFirst then
    repeat
      d1 := DM.ETB.FieldByName('DMode').AsFloat;
      if (d1 = rtyp) or ((rtyp = 2) and (d1 = 8)) then
      begin
        Inc(anzb);
        SetLength(bet,anzb);
        SetLength(bet[anzb-1],2);
        bet[anzb-1,0] := DM.ETB.FieldByName('Eb').AsFloat;
        bet[anzb-1,1] := DM.ETB.FieldByName('Ib').AsFloat;
      end;
    until DM.ETB.FindNext = False;
    DM.ETB.Filter := '';
  end;
  if DM.ETG.Locate('iZA',iza,[]) and not BPEC then 
  begin
    DM.ETG.Filter := 'iZA = ' + IntToStr(iza);
    if DM.ETG.FindFirst then
    repeat
      d1 := DM.ETG.FieldByName('DMode').AsFloat;
      if (d1 = rtyp) or ((rtyp = 2) and (d1 = 8)) or ((rtyp = 8) and (d1 = 2)) then
      begin
        if DM.ETG.FieldByName('Level').AsFloat <> 0 then
        begin
          if DM.ETG.FieldByName('Ig').AsFloat <> -1 then
          begin
            Inc(anzg);
            SetLength(gamm,anzg);
            SetLength(gamm[anzg-1],3);
            gamm[anzg-1,0] := DM.ETG.FieldByName('Eg').AsFloat;
            gamm[anzg-1,1] := DM.ETG.FieldByName('Level').AsFloat;
            gamm[anzg-1,2] := DM.ETG.FieldByName('Ig').AsFloat;
          end;
          Wahr := False;
          if anzls > 0 then
            for i1 := 0 to anzls-1 do
              if SameValue(levsort[i1],DM.ETG.FieldByName('Level').AsFloat,0.01) then
              begin
                Wahr := True;
                Break;
              end;
          if not Wahr then
          begin
            Inc(anzls);
            SetLength(levsort,anzls);
            levsort[anzls-1] := DM.ETG.FieldByName('Level').AsFloat;
          end;
        end;
      end;
    until DM.ETG.FindNext = False;
    DM.ETG.Filter := '';
  end;
  toplev := 0;
  if anzb > 0 then
    for i := 0 to anzb-1 do
    begin
      Wahr := False;
      if anzls > 0 then
        for i1 := 0 to anzls-1 do
          if SameValue(levsort[i1],DQ-bet[i,0],0.01) then
          begin
            Wahr := True;
            Break;
          end;
      if not Wahr and (DQ-bet[i,0] > 1.5) then
      begin
        Inc(anzls);
        SetLength(levsort,anzls);
        levsort[anzls-1] := DQ-bet[i,0];
      end;
    end;
  if anza > 0 then
    for i := 0 to anza-1 do
    begin
      Wahr := False;
      if anzls > 0 then
        for i1 := 0 to anzls-1 do
          if SameValue(levsort[i1],alph[i,1],0.01) then
          begin
            Wahr := True;
            Break;
          end;
      if not Wahr and (alph[i,1] > 0) then
      begin
        Inc(anzls);
        SetLength(levsort,anzls);
        levsort[anzls-1] := alph[i,1];
      end;
    end;
  if (rtyp = 4) and (anza = 1) and (anzg = 0) then toplev := 130;
  if (rtyp = 3) and (anzls = 0) then
  begin
    Inc(anzls);
    SetLength(levsort,anzls);
    if DQ = 0 then
      levsort[anzls-1] := 100
    else levsort[anzls-1] := DQ;
  end;
  if anzls > 1 then QuickSort(levsort);
  for i := anzls-1 downto 0 do
    if toplev < levsort[i] then toplev := levsort[i];
  A := IntToStr(DM.GetA(iza));
  Z := IntToStr(DM.GetZ(iza));
  N := DM.GetSymb(iza);
  with frmMain.bmpS.Canvas do
  begin
    Font.Charset := ANSI_CHARSET;
    Font.Name := 'Arial';
    Font.Size := 8;
    i2 := 130; i3 := 0;
    if toplev > 0 then
      for i := anzls-1 downto 0 do
      begin
        th := Trunc((100-(((levsort[i]) / toplev)*100)) * 3);
        if (i > 0) and  (th-i2 < TextHeight('I')) then
          i2 := i2 + TextHeight('I')
        else i2 := th;
        if i3 < i2 then i3 := i2;
      end;
    if i3 > 300 then
    begin
      i3 := i3 + 100;
      d := i3 / 100;
      h := 130 + i3;
    end
    else
    begin
      d := ((anzls * TextHeight('I')) + 100) / 100;
      h := 130 + ((anzls * TextHeight('I')) + 100);
    end;
    i := anzg * 16;
    ws := 20 + i + 40;
    w := 210 + ws + 170;
    frmMain.bmpS.Height := h+80;
    frmMain.bmpS.Width := w;
    Brush.Color := $00FFFFCC;
    FillRect(ClipRect);
    Brush.Style := bsClear;
    Pen.Color := clBlack;
    Pen.Style := psSolid;
    Pen.Width := 1;
    Font.Size := 10;
    Font.Style := [fsBold];
    Wahr := False;
    th := 30;
    if rtyp <> 3 then
    begin
      Font.Color := clGreen;
      if DM.GetZ(tiza) < DM.GetZ(iza) then Wahr := True;
      if DM.ETNukl.Locate('iZA',iza,[]) then
      begin
        temp := ZeitFormat(DM.ETNukl.FieldByName('Tsek').AsFloat);
        if Wahr then
          i := w-110-(TextWidth(temp) div 2)
        else i := 110-(TextWidth(temp) div 2);
        i1 := th-TextHeight('H');
        if Pos('u',temp) > 0 then
          SymF(frmMain.bmpS.Canvas,i,i1,temp,True)
        else TextOut(i,i1,temp);
        temp := DM.GetSpin(DM.ETNukl.FieldByName('JPi').AsFloat,
          DM.ETNukl.FieldByName('Par').AsInteger);
        if Wahr then i := w-10-TextWidth(temp) else i := 10;
        TextOut(i,i1,temp);
      end;
      for i := 0 to 2 do
      begin
        if i > 0 then Inc(th);
        if Wahr then
        begin
          MoveTo(w-200,th);
          LineTo(w-10,th);
        end
        else
        begin
          MoveTo(10,th);
          LineTo(200,th);
        end;
      end;
      if (iza mod 10 > 0) and (DQIT > 0) then
        temp := FloatToStr(RoundTo(DQIT,-1))
      else if (iza mod 10 > 0) and (DQIT = 0) then
        temp := '0+X'
      else temp := '0';
      if Wahr then i := w-205-TextWidth(temp) else i := 205;
      TextOut(i,th-(TextHeight('0') div 2),temp);
      Font.Size := 16;
      i := TextWidth(A)-TextWidth(N);
      if i <> 0 then i := i div 2;
      if Wahr then tw := w-105+i else tw := 105+i;
      TextOut(tw-TextWidth(A),35,A);
      th := 30+TextHeight('1');
      TextOut(tw-TextWidth(Z),th,Z);
      th := 35+(TextHeight('1') div 2);
      TextOut(tw,th,N);
      th := th + TextHeight('1')+10;
      Font.Size := 12;
      Font.Color := clBlack;
      if Wahr then TextOut(w-200,th,'Q') else TextOut(20,th,'Q');
      if Wahr then tw := w-200 + TextWidth('Q') else tw := 20 + TextWidth('Q');
      temp := DM.Zerfallart(rtyp);
      R.Top := th+5;
      R.Bottom := R.Top + TextHeight('1');
      R.Left := tw;
      R.Right := R.Left + TextWidth(temp);
      MaleZerfall(frmMain.bmpS.Canvas,Font,R,temp);
      tw := tw + TextWidth(temp);
      Font.Charset := ANSI_CHARSET;
      Font.Name := 'Arial';
      Font.Size := 10;
      if DQ = 0 then TextOut(tw,th,' = ?')
      else TextOut(tw,th,' = ' + FloatToStr(RoundTo(DQ,-2)) + ' keV');
      tw := tw + TextWidth(' = ' + FloatToStr(RoundTo(DQ,-2)) + ' keV') + 20;
      if br <> 0 then TextOut(tw,th,Runde(br,-2) + '%');
      if Wahr then i := w-10 else i := 10;
      MoveTo(i,30);
      LineTo(i,56);
      Font.Size := 14;
      Font.Style := [];
      TextOut(i-5,43,'~');
      TextOut(i-5,48,'~');
      MoveTo(i,60);
      LineTo(i,130);
      if (anza > 0) or (anzb > 0) then
      begin
        Font.Size := 8;
        Font.Color := clSilver;
        Font.Style := [fsBold];
        SymFont(frmMain.bmpS.Canvas,True);
        if anza > 0 then i := 50 else i := 45;
        if Wahr then TextOut(w-i,102,'I') else TextOut(25,102,'I');
        if Wahr then tw := w-i + TextWidth('I')
        else tw := 25 + TextWidth('I');
        R.Top := 105;
        R.Bottom := R.Top + TextHeight('I');
        if Wahr then R.Left := tw else R.Left := tw;
        R.Right := R.Left + TextWidth(temp);
        MaleZerfall(frmMain.bmpS.Canvas,Font,R,temp);
        if anza > 0 then
        begin
          TextOut(w-95,102,'E');
          tw := w-95 + TextWidth('E');
          R.Top := 105;
          R.Bottom := R.Top + TextHeight('E');
          if Wahr then R.Left := tw else R.Left := tw;
          R.Right := R.Left + TextWidth(temp);
          MaleZerfall(frmMain.bmpS.Canvas,Font,R,temp);
        end;
      end;
    end;
    if anzg > 0 then
    begin
      Font.Size := 8;
      Font.Color := clSilver;
      Font.Style := [fsBold];
      SymFont(frmMain.bmpS.Canvas,True);
      SymFont(frmMain.bmpS.Canvas,True);
      if Wahr then TextOut(w-210-ws+20,70,'Eg') else TextOut(230,70,'Eg');
      if Wahr then TextOut(w-210-ws+20,45,'Ig') else TextOut(230,45,'Ig');
    end;
    Font.Charset := DEFAULT_CHARSET; //ANSI_CHARSET;
    Font.Name := 'Tahoma';//'Arial';
    Font.Size := 8;
    Font.Style := [];
    Font.Color := clBlack;
    i2 := 130;
    if anzb > 0 then
    begin
      i3 := 0;
      for i := 0 to anzb-1 do
        if bet[i,1] <> 0 then i3 := 1;
      if (i3 = 1) and (toplev > 0) then // Test, ob zuviele Betas ohne Gammas
      begin
        for i := 0 to anzb-1 do
        begin
          th := 130 + Trunc((100-(((DQ-bet[i,0]) / toplev)*100)) * d);
          if (i > 0) and  (th-i2 < TextHeight('I')-2) then
          begin
            i2 := i2 + TextHeight('I');
            if (60+(i2-th) > 200) then
            begin
              i3 := 0;
              Break;
            end;
          end else i2 := th;
        end;
      end;
      i2 := 130;
      for i := 0 to anzb-1 do
      begin
        if (toplev = 0) and (anzb = 1) and (DQ-bet[i,0] <= 1.5 ) then
          th := h
        else th := 130 + Trunc((100-(((DQ-bet[i,0]) / toplev)*100)) * d);
        if frmMain.CBIB.Checked and (i > 0) and  (th-i2 < TextHeight('I')-2) and
          (i3 = 1) then
        begin
          if (bet[i,1] = 0) and (Sign(th-i2) = 1) then
            i2 := th
          else if (bet[i,1] = 0) and (Sign(th-i2) = -1) then
            i2 := i2 + 2
          else i2 := i2 + TextHeight('I')-2;
          if Wahr then MoveTo(w-10,130) else MoveTo(10,130);
          if Wahr then LineTo(w-10,i2) else LineTo(10,i2);
          if Wahr then MoveTo(w-10,i2) else MoveTo(10,i2);
          if Wahr then LineTo(w-60,i2) else LineTo(60,i2);
          if Wahr then MoveTo(w-60,i2) else MoveTo(60,i2);
          if Wahr then LineTo(w-60-(i2-th),th) else LineTo(60+(i2-th),th);
          if 60+(i2-th) > 195 then
          begin
            if Wahr then p1.X := w-50-(i2-th) else p1.X := 50+(i2-th);
            p1.Y := th+10;
            if Wahr then p2.X := w-60-(i2-th) else p2.X := 60+(i2-th);
            p2.Y := th;
          end
          else
          begin
            if Wahr then MoveTo(w-60-(i2-th),th) else MoveTo(60+(i2-th),th);
            if Wahr then LineTo(w-200,th) else LineTo(200,th);
            if Wahr then p1.X := w-194 else p1.X := 194;
            p1.Y := th;
            if Wahr then p2.X := w-200 else p2.X := 200;
            p2.Y := th;
          end;
          MalePfeil(frmMain.bmpS.Canvas,clBlack,5,50,True,p1,p2);
          Brush.Style := bsClear;
          if bet[i,1] <> 0 then
          begin
            d1 := bet[i,1];
            if d1 < 0.001 then
              temp := FormatFloat('#.#E-0',d1)+' %'
            else
            begin
              d1 := RoundTo(d1,-3);
              temp := FloatToStr(d1)+' %';
            end;
            if Wahr then
              TextOut(w-15-TextWidth(temp),i2-TextHeight('1')+1,temp)
            else TextOut(15,i2-TextHeight('1')+1,temp);
          end;
        end
        else
        begin
          if Wahr then MoveTo(w-10,130) else MoveTo(10,130);
          if Wahr then LineTo(w-10,th) else LineTo(10,th);
          if Wahr then MoveTo(w-10,th) else MoveTo(10,th);
          if Wahr then LineTo(w-200,th) else LineTo(200,th);
          if Wahr then p1.X := w-190 else p1.X := 190;
          p1.Y := th;
          if Wahr then p2.X := w-200 else p2.X := 200;
          p2.Y := th;
          MalePfeil(frmMain.bmpS.Canvas,clBlack,5,50,True,p1,p2);
          Brush.Style := bsClear;
          if (bet[i,1] <> 0) and
            ((i = 0) or (th-i2 >= TextHeight('I')-2)) then
          begin
            d1 := bet[i,1];
            temp := FloatToStr(d1)+' %';
            if Wahr then
              TextOut(w-15-TextWidth(temp),th-TextHeight('1')+1,temp)
            else TextOut(15,th-TextHeight('1')+1,temp);
          end;
          i2 := th;
        end;
      end;
    end
    else if (anza > 0) and (toplev > 0) then
    begin
      for i1 := anzls-1 downto 0 do
        for i := 0 to anza-1 do
          if SameValue(levsort[i1],alph[i,1],0.001) then
          begin
            th := 130 + Trunc((100-((alph[i,1] / toplev)*100)) * d);
            if frmMain.CBIB.Checked and (i1 < anzls-1) and
              (th-i2 < TextHeight('I')-2) then
            begin
              i2 := i2 + TextHeight('I')-2;
              MoveTo(w-10,130);
              LineTo(w-10,i2);
              MoveTo(w-10,i2);
              LineTo(w-100,i2);
              MoveTo(w-100,i2);
              LineTo(w-100-(i2-th),th);
              MoveTo(w-100-(i2-th),th);
              LineTo(w-200,th);
              p1.X := w-190;
              p1.Y := th;
              p2.X := w-200;
              p2.Y := th;
              MalePfeil(frmMain.bmpS.Canvas,clBlack,5,50,True,p1,p2);
              Brush.Style := bsClear;
              TextOut(w-100,i2-TextHeight('1')+1,FloatToStr(RoundTo(alph[i,0],-1)));
              if alph[i,2] <> 0 then
              begin
                d1 := alph[i,2];
                if d1 < 0.001 then
                  temp := FormatFloat('#.#E-0',d1)+' %'
                else
                begin
                  d1 := RoundTo(d1,-3);
                  temp := FloatToStr(d1)+' %';
                end;
                TextOut(w-60,i2-TextHeight('1')+1,temp);
              end;
            end
            else
            begin
              MoveTo(w-10,130);
              LineTo(w-10,th);
              MoveTo(w-10,th);
              LineTo(w-200,th);
              p1.X := w-190;
              p1.Y := th;
              p2.X := w-200;
              p2.Y := th;
              MalePfeil(frmMain.bmpS.Canvas,clBlack,5,50,True,p1,p2);
              Brush.Style := bsClear;
              if (i = 0) or (th-i2 >= TextHeight('I')-2) then
                TextOut(w-100,th-TextHeight('1')+1,FloatToStr(RoundTo(alph[i,0],-1)));
              if (alph[i,2] <> 0) and ((i=0) or (th-i2 >= TextHeight('I')-2)) then
              begin
                d1 := alph[i,2];
                if d1 < 0.001 then
                  TextOut(w-60,th-TextHeight('1')+1,FormatFloat('#.#E-0',d1)+' %')
                else
                begin
                  d1 := RoundTo(d1,-3);
                  TextOut(w-60,th-TextHeight('1')+1,FloatToStr(d1)+' %');
                end;
              end;
              i2 := th;
            end;
          end;
    end;
    Font.Style := [fsBold];
    i1 := 0; i2 := 0;
    i3 := TextHeight('I')-6;  // TextHeight = 14
    if (anzls > 0) and (toplev > 0) then
      for i := anzls-1 downto 0 do
      begin
        th := 130 + Trunc((100-((levsort[i] / toplev)*100)) * d);
        if (i1 > 0) and (i2 > 0) and (th-i1 > i3) and (h-th > i3) then i2 := 0;
        if (i1 > 0) and (i2 = 0) and (th-i1 < i3) then i4 := 1
        else if (i2 > 0) and (th-i1 < i3) then i4 := 2
        else if (i2 > 0) and (h-th < i3) then i4 := 2
        else if (i2 = 0) and (h-th < i3) then i4 := 1
        else i4 := 0;
        d1 := RoundTo(levsort[i],-1);
        Font.Size := 7;
        if d1 > 0.1 then
        begin
          if (rtyp = 3) and (DQ = 0) then temp := '?' else temp := FloatToStr(d1);
          if Wahr then MoveTo(w-210,th) else MoveTo(210,th);
          if i4 = 1 then
          begin
            if Wahr then LineTo(w-210-ws-2,th) else LineTo(210+ws+2,th);
            if Wahr then MoveTo(w-210-ws-50,th) else MoveTo(210+ws+50,th);
            if Wahr then LineTo(w-210-ws-58,th) else LineTo(210+ws+58,th);
            if Wahr then
              TextOut(w-210-ws-61-TextWidth(temp),th-(TextHeight('1') div 2),temp)
            else TextOut(210+ws+61,th-(TextHeight('1') div 2),temp);
            i2 := th;
          end
          else if i4 = 2 then
          begin
            if Wahr then LineTo(w-210-ws-4,th) else LineTo(210+ws+4,th);
            if Wahr then MoveTo(w-210-ws-107,th) else MoveTo(210+ws+107,th);
            if Wahr then LineTo(w-210-ws-115,th) else LineTo(210+ws+115,th);
            if Wahr then
              TextOut(w-210-ws-118-TextWidth(temp),th-(TextHeight('1') div 2),temp)
            else TextOut(210+ws+118,th-(TextHeight('1') div 2),temp);
            i2 := 0;
          end
          else
          begin
            if Wahr then LineTo(w-210-ws,th) else LineTo(210+ws,th);
            if Wahr then
              TextOut(w-210-ws-5-TextWidth(temp),th-(TextHeight('1') div 2),temp)
            else TextOut(210+ws+5,th-(TextHeight('1') div 2),temp);
            i1 := th; i2 := 0;
            if (rtyp = 3) and (i = anzls-1) then
            begin
              Font.Color := clGreen;
              if br <> 0 then  // 130
                TextOut(90,th-(TextHeight('1') div 2),'IT  ' + Runde(br,-2) + '%')
              else TextOut(90,th-(TextHeight('1') div 2),'IT');
              if DM.ETNukl.Locate('iZA',iza,[]) then
              begin
                temp := ZeitFormat(DM.ETNukl.FieldByName('Tsek').AsFloat);
                if Pos('u',temp) > 0 then
                  SymF(frmMain.bmpS.Canvas,155,th-(TextHeight('1') div 2),temp,False)
                else TextOut(155,th-(TextHeight('1') div 2),temp);
              end;
            end;
          end;
          Font.Size := 8;
          Font.Color := clBlack;
        end;
      end;
    Font.Style := [];
    if Wahr then i1 := w-210-ws+20 else i1 := 230;
    if anzg > 0 then
    begin
      Font.Size := 8;
      for i4 := anzls-1 downto 0 do
        for i := anzg-1 downto 0 do
          if SameValue(gamm[i,1],levsort[i4],0.01) then
          begin
            i1 := i1 + 16;
            i5 := 130 + Trunc((100-((gamm[i,1] / toplev)*100)) * d);
            MoveTo(i1,i5);
            i2 := i5 + Trunc(((gamm[i,0] / toplev) * 100) * d);
            LineTo(i1,i2);
            if i2-i5 > 8 then
            begin
              Brush.Style := bsSolid;
              Brush.Color := clBlack;
              Ellipse(i1-2,i5-2,i1+3,i5+3);
              Brush.Style := bsClear;
            end;
            p1.X := i1;
            p1.Y := i2-5;
            p2.X := i1;
            p2.Y := i2;
            MalePfeil(frmMain.bmpS.Canvas,clBlack,5,50,True,p1,p2);
            Brush.Style := bsClear;
            RotText(45,i1+8,90,FloatToStr(RoundTo(gamm[i,0],-3)),frmMain.bmpS.Canvas,True);
            if gamm[i,2] <> 0 then
            begin
              d1 := gamm[i,2];
              if d1 < 0.01 then
                RotText(45,i1+41,55,FormatFloat('#.#E-0',d1),frmMain.bmpS.Canvas,False)
              else
              begin
                d1 := RoundTo(d1,-2);
                RotText(45,i1+41,55,FloatToStr(d1),frmMain.bmpS.Canvas,False);
              end;
            end;
            Pen.Color := clSilver;
            MoveTo(i1,123);
            LineTo(i1,110);
            p1.X := i1;
            p1.Y := 110;
            p2.X := i1;
            p2.Y := 123;
            MalePfeil(frmMain.bmpS.Canvas,clSilver,5,50,True,p1,p2);
            Brush.Style := bsClear;
            MoveTo(i1,110);
            LineTo(i1+13,97);
            Pen.Color := clBlack;
          end;
    end;
    Font.Charset := ANSI_CHARSET;
    Font.Name := 'Arial';
    Font.Style := [fsBold];
    for i := 0 to 2 do
    begin
      if i > 0 then Inc(h);
      if Wahr then MoveTo(w-210,h) else MoveTo(210,h);
      if Wahr then LineTo(w-210-ws,h) else LineTo(210+ws,h);
    end;
    i := tiza - (tiza mod 10);
    if DM.ETNukl.Locate('iZA',i,[]) then
      hwz := DM.ETNukl.FieldByName('Tsek').AsFloat;
    Font.Size := 8;
    if BPEC and (rtyp <> 3) then
    begin
      d1 := DM.GetEl(tiza,trtyp);
      d1 := RoundTo(d1,-1);
      if d1 = 0 then temp := '0+X'
      else temp := FloatToStr(d1);
    end else temp := '0';
    if Wahr then
      TextOut(w-210-ws-5-TextWidth(temp),h-(TextHeight('0') div 2),temp)
    else TextOut(210+ws+5,h-(TextHeight('0') div 2),temp);
    Font.Color := clGreen;
    h := h - 2;
    A := IntToStr(DM.GetA(tiza));
    Z := IntToStr(DM.GetZ(tiza));
    N := DM.GetSymb(tiza);
    Font.Size := 16;
    h := h + 5;
    i := TextWidth(A)-TextWidth(N);
    if i <> 0 then i := i div 2;
    if Wahr then tw := w-210-(ws div 2)+i else tw := 210 + (ws div 2) + i;
    TextOut(tw-TextWidth(A),h,A);
    TextOut(tw-TextWidth(Z),h+TextHeight(Z)-5,Z);
    h := h+(TextHeight(N) div 2);
    if BPEC and (rtyp <> 3) then
    begin
      i := tiza mod 10;
      if i > 1 then N := N + ' m' + IntToStr(i)
      else N := N + ' m';
      TextOut(tw,h,N);
    end else TextOut(tw,h,N);
    if hwz = -99 then
    begin
      i := TextWidth(N);
      Font.Size := 10;
      TextOut(tw+i+20,h+5,'stabil');
    end;
    Font.Size := 8;
  end;
  alph := nil;
  bet := nil;
  gamm := nil;
  levsort := nil;
  if frmMain.bmpS.Width < frmMain.SBSchema.ClientWidth then
  begin
    frmMain.bmpl := (frmMain.SBSchema.ClientWidth - frmMain.bmpS.Width) div 2;
    frmMain.PBSchema.Width := frmMain.SBSchema.ClientWidth;
  end
  else
  begin
    frmMain.bmpl := 0;
    frmMain.PBSchema.ClientWidth := frmMain.bmpS.Width;
  end;
  if frmMain.bmpS.Height < frmMain.SBSchema.ClientHeight then
  begin
    frmMain.bmpt := (frmMain.SBSchema.ClientHeight - frmMain.bmpS.Height) div 2;
    frmMain.PBSchema.Height := frmMain.SBSchema.ClientHeight;
  end
  else
  begin
    frmMain.bmpt := 0;
    frmMain.PBSchema.ClientHeight := frmMain.bmpS.Height;
  end;
  frmMain.PBSchema.Canvas.Draw(frmMain.bmpl,frmMain.bmpt,frmMain.bmpS);
  if Wahr and (frmMain.bmpS.Width > frmMain.SBSchema.ClientWidth) then
    frmMain.SBSchema.HorzScrollBar.Position :=
      frmMain.SBSchema.HorzScrollBar.Range - frmMain.SBSchema.ClientWidth;
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
          Cells[1,5] := FloatToStrF(DM.ETNukl.FieldByName('Masse').AsFloat / 1000 / 1000,ffGeneral,6,2)
          //Cells[1,5] := ZahlFormat(DM.ETNukl.FieldByName('Masse').AsFloat,2,7)
        else Cells[1,5] := IntToStr(DM.GetA(iza));
        if not DM.ETNukl.FieldByName('Abund').IsNull then
          Cells[1,6] := ZahlFormat(DM.ETNukl.FieldByName('Abund').AsFloat,0,5)
        else Cells[1,6] := '';
        if not DM.ETNukl.FieldByName('Tsek').IsNull then
          Cells[1,7] := ZeitFormat(DM.ETNukl.FieldByName('Tsek').AsFloat)
        else Cells[1,7] := '';
        temp := Trim(DM.FindRTypS(iza,DM.ETNukl.FieldByName('Max_RTyp').AsInteger));
        temp := StringReplace(temp,'a','Alpha',[rfReplaceAll]);
        temp := StringReplace(temp,'b','Beta',[rfReplaceAll]);
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
        Cells[1,13] := DM.GetSpin(DM.ETNukl.FieldByName('JPi').AsFloat,
          DM.ETNukl.FieldByName('Par').AsInteger);
      end;
    end else for i := 1 to RowCount-1 do
             begin
               Cells[1,i] := '';
               HintCell[1,i] := '';
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

procedure PosGridReihe(XPos,YPos: Integer);
begin
  with frmMain.SBGridReihe do
  begin
    HorzScrollBar.Position := XPos;
    VertScrollBar.Position := YPos;
  end;
  frmMain.GridReihe.Repaint;
end;

procedure PosGridSuchKarteScrollbar(iZA: Integer);
var z,n: Integer;
begin
  z := DM.GetZ(iZA);
  n := DM.GetN(iZA);
  with frmMain.SBSuchKarte.VertScrollBar do
  begin
    if z < 20 then
      Position := Range - frmMain.SBSuchKarte.ClientHeight
    else if z > 94 then
      Position := 0
    else Position := Range - ((6 * z) + 99);
  end;
  with frmMain.SBSuchKarte.HorzScrollBar do
    if n < 90 then
      Position := 0 else Position := Range - frmMain.SBSuchKarte.ClientWidth;
end;

procedure PosNuk(XCol,XRow: Integer);
var i: Integer;
begin
  with frmMain do
  begin
    if GridMin.Visible and (GridNuk.DefaultColWidth > nukw) then
    begin
      i := Trunc((SBNuk.ClientWidth / GridNuk.DefaultColWidth) / 2);
      SBNuk.HorzScrollBar.Position := (XCol * GridNuk.DefaultColWidth) -
        (i * GridNuk.DefaultColWidth);
      i := Trunc((SBNuk.ClientHeight / GridNuk.DefaultRowHeight) / 2);
      SBNuk.VertScrollBar.Position := (XRow * GridNuk.DefaultRowHeight) -
        (i * GridNuk.DefaultRowHeight);
      MinPosX := SBNuk.HorzScrollBar.Position;
      MinPosY := SBNuk.VertScrollBar.Position;
    end;
    GridAktPos(XCol,XRow);
  end;
end;

procedure PosNukReihe(XCol,XRow: Integer;Alle: Boolean);
begin
  with frmMain.SBGridReihe do
  begin
    HorzScrollBar.Range :=
      (frmMain.GridReihe.ColCount+1) * frmMain.GridReihe.DefaultColWidth;
    HorzScrollBar.Increment := frmMain.GridReihe.DefaultColWidth;
    VertScrollBar.Range :=
      (frmMain.GridReihe.RowCount+1) * frmMain.GridReihe.DefaultRowHeight;
    if frmMain.bRad > 1 then
      VertScrollBar.Increment := frmMain.GridReihe.DefaultRowHeight
    else VertScrollBar.Increment := (frmMain.GridReihe.DefaultRowHeight*2);
    if Alle then
      if XCol <= 6 then
        HorzScrollBar.Position := 0
      else if XCol >= (frmMain.GridReihe.ColCount - 6) then
        HorzScrollBar.Position := HorzScrollBar.Range
      else HorzScrollBar.Position := (XCol div 2) * frmMain.GridReihe.DefaultColWidth
    else HorzScrollBar.Position := 0;
    if XRow < (frmMain.GridReihe.RowCount div 2) then
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
      else PanelLeg.Top := ClientHeight - StatusBar.Height - PanelLeg.Height-11;
    end;
end;

procedure PosPanels;
var i: Integer;
begin
  with frmMain do
  begin
    if MenuExpl.Checked then
    begin
      PanelIso.Left := ((PanelZoom.Width - PanelIso.Width) div 2) + 2;
      PanelNukTV.Top := PanelGridDat.Height + 2;
      PanelNukTV.Height := PageKarte.ClientHeight - PanelGridDat.Height;
      if GridNuk.DefaultColWidth = nukw then MenuGridDat.Enabled := False;
    end
    else
      PanelIso.Left := PanelGridDat.Width - 20 + (PanelZoom.Width - PanelIso.Width) div 2;
    if MenuGridDat.Checked or (GridNuk.DefaultColWidth = nukw) then
      PanelGridDat.Visible := True
    else
    begin
      PanelGridDat.Visible := False;
      PanelZoom.Left := 2;
    end;
    i := PageKarte.ClientWidth - (nukw * 178);
    if (i > PanelNukDis.Width) and ((GridNuk.DefaultColWidth = nukw) and
      not MenuExpl.Checked) then
    begin
      PanelNukDis.Width := i div 2;
      PanelNukDis.Visible := True
    end else PanelNukDis.Visible := False;
    //PanelNukDis.Visible := ((GridNuk.DefaultColWidth = nukw) and not MenuExpl.Checked);
    if (not MenuGridDat.Checked and (GridNuk.DefaultColWidth > nukw)) or
       not MenuExpl.Checked then
    begin
      PanelNukTV.Visible := False;
      SBNuk.Align := alClient;
    end
    else
    begin
      PanelNukTV.Visible := True;
      SBNuk.Align := alRight;
      SBNuk.Width := PageKarte.ClientWidth - PanelGridDat.Width - 2;
    end;
    if not MenuGridDat.Checked and (GridNuk.DefaultColWidth > nukw) then
      MenuExpl.Enabled := False else MenuExpl.Enabled := True;
    MenuGridDat.Enabled := ((GridNuk.DefaultColWidth > nukw) and
      (not MenuExpl.Checked or not MenuGridDat.Checked));
    if PanelNukTV.Visible then
      PanelZoom.Left := PanelGridDat.Width + 4
    else if not PanelGridDat.Visible then
      PanelZoom.Left := 2
    else PanelZoom.Left := PanelGridDat.Width;
    PanelIso.Top := PanelZoom.Height + (PanelZoom.Width - PanelIso.Width) div 2;
    PanelMin.Top := PanelZoom.Top + PanelZoom.Height;
    PanelMin.Left := PanelZoom.Left;
  end;
  PosPanelLeg;
end;

procedure RadAlle;
begin
  while RadGridAlle = False do
end;

function RadBack(iZA: Integer): Boolean;
var
  n,z,iz,minn,maxn,minz,maxz: Integer;
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
    {if DM.ETRZA.Locate('iZA',iZA,[]) then
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
              DM.RadFarbe(DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
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
                DM.RadFarbe(DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
          until DM.ETDMI.FindNext = False;
          DM.ETDMI.Filter := '';
          frmMain.Gauge.Position := Trunc((i / DM.ETRZA.FieldCount) * 100);
        end else Break;
    end
    else
    begin}
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
              DM.RadFarbe(DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
            NewNuk := True;
          end;
        until DM.ETDMI.FindNext = False;
        DM.ETDMI.Filter := '';
        DM.ETDMI.Filter := 'Tochter = ' + IntToStr(iZA);
        if DM.ETDMI.FindFirst then
        repeat
          iz := DM.ETDMI.FieldByName('iZA').AsInteger;
          z := DM.GetZ(iz);
          n := DM.GetN(iz);
          if ColorCell[n+1,RowCount-z-1] = clWhite then
          begin
            HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iz,True);
            ColorCell[n+1,RowCount-z-1] :=
              DM.RadFarbe(DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
            NewNuk := True;
          end;
        until DM.ETDMI.FindNext = False;
        DM.ETDMI.Filter := '';
      end
      else if ColorCell[n+1,RowCount-z-1] = clBtnFace then
      begin
        HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iZA,True);
        if (iZA mod 10 > 0) and DM.ETNukl.Locate('iZA',iZA,[]) and
          (DM.ETNukl.FieldByName('Max_RTyp').AsInteger <> 0) then
          ColorCell[n+1,RowCount-z-1] :=
            DM.RadFarbe(DM.ETNukl.FieldByName('Max_RTyp').AsInteger)
        else ColorCell[n+1,RowCount-z-1] := clBlack;
        DM.ETDMI.Filter := 'Tochter = ' + IntToStr(iZA);
        if DM.ETDMI.FindFirst then
        repeat
          iz := DM.ETDMI.FieldByName('iZA').AsInteger;
          z := DM.GetZ(iz);
          n := DM.GetN(iz);
          if ColorCell[n+1,RowCount-z-1] = clWhite then
          begin
            HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iz,True);
            ColorCell[n+1,RowCount-z-1] :=
              DM.RadFarbe(DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
            NewNuk := True;
          end;
        until DM.ETDMI.FindNext = False;
        DM.ETDMI.Filter := '';
      end;
    //end;
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
  //if max < 60 then von := 30 else von := 1;
  frmMain.Gauge.Position := 0;
  with frmMain.GridRad do
  begin
    if max > 10 then von := RowCount-1 - max + 10 else von := RowCount-1;
    //for i1 := von to RowCount-1 do
    for i1 := von downto 1 do
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
          DM.ETDMI.Filter := 'Tochter = ' + IntToStr(dz);
          if DM.ETDMI.FindFirst then
          repeat
            iz := DM.ETDMI.FieldByName('iZA').AsInteger;
            z := DM.GetZ(iz);
            n := DM.GetN(iz);
            if ColorCell[n+1,RowCount-z-1] = clWhite then
            begin
              HintCell[n+1,RowCount-z-1] := DM.GetNukBez(iz,True);
              ColorCell[n+1,RowCount-z-1] :=
                DM.RadFarbe(DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
              NewNuk := True;
            end;
          until DM.ETDMI.FindNext = False;
          DM.ETDMI.Filter := '';
        end;
      frmMain.Gauge.Position := Trunc((i1 / RowCount) * 100);
      //if i1 > (RowCount - (max - 10)) then Break;
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
var i,i2,iza,farbe: Integer;
begin
  ClearGridRadDat;
  with frmMain.GridRadDat do
    if Trim(txt) <> '' then
    begin
      frmMain.PanelRadNuk.Caption := DM.GetNukBez(DM.GetiZA(txt),True);
      DM.ETDMI.Filter := 'iZA = ' + IntToStr(DM.GetiZA(txt));
      if DM.ETDMI.FindFirst then
      repeat
        i := DM.ETDMI.FieldByName('nMode').AsInteger;
        iza := DM.ETDMI.FieldByName('Tochter').AsInteger;
        farbe := DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat);
        ColorCell[0,i] := DM.RadFarbe(farbe);
        CellFont[0,i].Color := DM.RadFontFarbe(farbe);
        if DM.ETNukl.Locate('iZA',iza,[]) then
        begin
          i2 := DM.ETNukl.FieldByName('Max_RTyp').AsInteger;
          if DM.ETNukl.FieldByName('Tsek').AsFloat = -99 then
          begin
            ColorCell[2,i] := DM.RadFarbe(10);
            CellFont[2,i].Color := DM.RadFontFarbe(10);
          end
          else
          begin
            ColorCell[2,i] := DM.RadFarbe(i2);
            CellFont[2,i].Color := DM.RadFontFarbe(i2);
          end;
        end;
        Cells[0,i] := DM.Zerfallart(DM.ETDMI.FieldByName('RTYP').AsFloat);
        if DM.ETDMI.FieldByName('BR').AsFloat <> 0 then
          Cells[1,i] := Runde(DM.ETDMI.FieldByName('BR').AsFloat,-3);
        if iza = - 60 then
        begin
          CellFont[2,i].Color := clBlack;
          Cells[2,i] := '?'
        end else
          Cells[2,i] := DM.GetNukBez(DM.ETDMI.FieldByName('Tochter').AsInteger,True);
      until DM.ETDMI.FindNext = False;
      DM.ETDMI.Filter := '';
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
              ColorCell[i,i1] := DM.RadFarbe(DM.Rtyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
            i2 := DM.ETDMI.FieldByName('Tochter').AsInteger;
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
                      DM.RadFarbe(DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
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
  function FolgeNuk(iz: Integer;trt: Double): Integer;
  begin
    with DM.ETDMI do
    begin
      Filter := 'iZA = ' + IntToStr(iz);
      Result := 0;
      if FindFirst then
      repeat
        if (trt = 0) and (FieldByName('nMode').AsInteger = 1) then
          Result := FieldByName('Nr').AsInteger
        else if FieldByName('RTYP').AsFloat = trt then
          Result := FieldByName('Nr').AsInteger;
      until FindNext = False;
      Filter := '';
    end;
  end;
var
  i,i1,i2,i3,n,z,r: Integer;
  trtyp: Double;
  temp: String;
  Farbe: TColor;
  nuk: array[0..10] of Integer;
begin
  if not frmMain.btnRad1.Enabled then
  begin
    frmMain.GridReihe.DefaultColWidth := 100;
    frmMain.GridReihe.DefaultRowHeight := 21;
  end;
  for i := 0 to frmMain.GridRbtn.ColCount-1 do
  begin
    frmMain.GridRbtn.Cells[i,0] := '';
    frmMain.GridRbtn.HintCell[i,0] := '';
  end;
  frmMain.GridRbtn.ColCount := 1;
  with DM.ETDMI do
    if DM.ETNukl.Locate('iZA',iZA,[]) and
      (DM.ETNukl.FieldByName('Tsek').AsFloat = -99) then
    begin
      n := DM.GetN(iZA);
      z := DM.GetZ(iZA);
      if (iZA mod 10 > 0) and (DM.ETNukl.FieldByName('Max_RTyp').AsInteger <> 0) then
        frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] :=
          DM.RadFarbe(DM.ETNukl.FieldByName('Max_RTyp').AsInteger)
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
      frmMain.btnSchema.Enabled := False;
      Result := True;
    end
    else if Locate('iZA',iZA,[]) then
    begin
      i1 := 0;
      Filter := 'iZA = ' + IntToStr(iZA);
      if FindFirst then
      repeat
        if FieldByName('Tochter').AsInteger <> 0 then
        begin
          Inc(i1);
          i := FieldByName('nMode').AsInteger;
          if (FieldByName('Tochter').AsInteger <> -60) then
          begin
            RTypBtn(i,FieldByName('RTYP').AsFloat,FieldByName('DQ').AsFloat);
            frmMain.btnSchema.Enabled := True;
          end;
          nuk[i-1] := FieldByName('Nr').AsInteger;
          if not frmMain.btnRad1.Enabled then
          begin
            if frmMain.GridReihe.ColCount < i1 then
              frmMain.GridReihe.ColCount := i1;
            frmMain.GridReihe.CellFont[i-1,0].Style := [fsBold];
            frmMain.GridReihe.ColorCell[i-1,0] := clInfoBk;
            frmMain.GridReihe.Cells[i-1,0] := 'Zerfallsreihe ' + IntToStr(i);
            frmMain.GridReihe.HintCell[i-1,0] := 'Klick hier f�r weitere Daten der ' +
              frmMain.GridReihe.Cells[i-1,0];
            if DM.ETDM.Locate('RTYP',FieldByName('RTYP').AsFloat,[]) then
            begin
              Farbe := DM.RadFarbe(DM.RTyp1(FieldByName('RTYP').AsFloat));
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
              DM.RadFarbe(DM.RTyp1(FieldByName('RTYP').AsFloat));
          frmMain.GridRad.HintCell[n+1,frmMain.GridRad.RowCount-z-1] :=
            DM.GetNukBez(FieldByName('iZA').AsInteger,True);
          i2 := FieldByName('Tochter').AsInteger;
          if FieldByName('TRTYP').AsFloat <> 0 then
            trtyp := FieldByName('TRTYP').AsFloat
          else trtyp := 0;
          while i2 > 1 do
          begin
            if ((iZA mod 10 = 0) or (frmMain.bRad = 1)) and
              DM.ETNukl.Locate('iZA',i2,[]) and
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
            else if Locate('Nr',FolgeNuk(i2,trtyp),[]) then
            begin
              n := DM.GetN(FieldByName('iZA').AsInteger);
              z := DM.GetZ(FieldByName('iZA').AsInteger);
              Farbe := DM.RadFarbe(DM.RTyp1(FieldByName('RTYP').AsFloat));
              frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] := Farbe;
              frmMain.GridRad.HintCell[n+1,frmMain.GridRad.RowCount-z-1] :=
                DM.GetNukBez(FieldByName('iZA').AsInteger,True);
              i2 := FieldByName('Tochter').AsInteger;
              if FieldByName('TRTYP').AsFloat <> 0 then
                trtyp := FieldByName('TRTYP').AsFloat
              else trtyp := 0;
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
            end
            else if (iZA mod 10 > 0) and (i2 = iZA - (iZA mod 10)) then
            begin
              n := DM.GetN(FieldByName('iZA').AsInteger);
              z := DM.GetZ(FieldByName('iZA').AsInteger);
              Farbe := DM.RadFarbe(DM.RTyp1(FieldByName('RTYP').AsFloat));
              frmMain.GridRad.ColorCell[n+1,frmMain.GridRad.RowCount-z-1] := Farbe;
              frmMain.GridRad.HintCell[n+1,frmMain.GridRad.RowCount-z-1] :=
                DM.GetNukBez(FieldByName('iZA').AsInteger,True);
              i2 := 0;
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
      frmMain.btnSchema.Enabled := False;
      Result := False;
    end;
  PosGridRadScrollbar(iZA);
  if frmMain.bRad = 2 then
    RadAlle
  else
  begin
    frmMain.btnRad2.Enabled := True;
    frmMain.btnRad3.Enabled := True;
    frmMain.SBGridReihe.HorzScrollBar.Range :=
      (frmMain.GridReihe.ColCount+1) * frmMain.GridReihe.DefaultColWidth;
    frmMain.SBGridReihe.HorzScrollBar.Increment := frmMain.GridReihe.DefaultColWidth;
    frmMain.SBGridReihe.VertScrollBar.Range := 
      (frmMain.GridReihe.RowCount+1) * frmMain.GridReihe.DefaultRowHeight;
    frmMain.SBGridReihe.VertScrollBar.Increment := frmMain.GridReihe.DefaultRowHeight;
    frmMain.SBGridReihe.VertScrollBar.Position := 0;
  end;
  frmMain.Gauge.Position := 0;
end;

function ResetBtnGam: Boolean;
begin
  with frmMain do
  begin
    btnA.Down := False;
    btnB.Down := False;
    btnG.Down := False;
    btnX.Down := False;
    XAkt := 0;
  end;
  Result := True;
end;

function ResetCBs(Alle: Boolean): Boolean;
begin
  with frmMain do
  begin
    ETZ.Value := 0;
    CBSym.ItemIndex := -1;
    ETN1.Value := 0;
    ETN2.Value := 0;
    if Alle then
    begin
      ETA1.Value := 0;
      ETA2.Value := 0;
      CBTH1.ItemIndex := 0;
      CBTH2.ItemIndex := 0;
      ETH1.Value := 0;
      ETH2.Value := 0;
      EEnergy.Value := 0;
      EkeV.Value := 0;
      ClearGridRad(frmMain.GridSuchKarte);
    end;
    lblFilter.Caption := '';
  end;
  Result := True;
end;

procedure RGSuchItems;
var
  i,i1: Integer;
  List: TStrings;
  Wahr: Boolean;
begin
  List := TStringList.Create;
  with frmMain do
  begin
    case RGSuch.ItemIndex of
      0: begin List.Add('Z'); List.Add('A'); List.Add('Halbwertzeit'); end;
      1..3: begin List.Add('Energie'); List.Add('Intensit�t'); List.Add('Z');
              List.Add('A'); end;
      4,5: begin List.Add('Energie'); List.Add('Z'); end;
    end;
    Wahr := False;
    if List.Count <= RGSuchSort.Items.Count then
      i1 := List.Count-1 else i1 := RGSuchSort.Items.Count-1;
    for i := 0 to i1 do
      if RGSuchSort.Items[i] <> List.Strings[i] then Wahr := True;
    if Wahr then
    begin
      RGSuchSort.Items.Clear;
      RGSuchSort.Items.AddStrings(List);
      for i := 0 to RGSuchSort.Items.Count-1 do
        if RGSuchSort.Items[i] = RGSuchIdxAlt then
        begin
          RGSuchSort.ItemIndex := i;
          Break;
        end;
      if RGSuchSort.ItemIndex = -1 then RGSuchSort.ItemIndex := 0;
      //RGSuchIdxAlt := RGSuchSort.Items[RGSuchSort.ItemIndex];
    end;
  end;
  List.Free;
  RGSuchIndex;
end;

procedure RGSuchIndex;
begin
  with frmMain do
  begin
    case RGSuch.ItemIndex of
      0: if RGSuchSort.ItemIndex = 2 then DM.ETNukl.IndexName := 'ByTH'
         else if RGSuchSort.ItemIndex = 1 then DM.ETNukl.IndexName := 'ByA'
         else DM.ETNukl.IndexName := 'ByiZA';
      1: if RGSuchSort.ItemIndex = 1 then DM.ETA.IndexName := 'ByIa'
         else if RGSuchSort.ItemIndex = 2 then DM.ETA.IndexName := 'ByiZA'
         else if RGSuchSort.ItemIndex = 3 then DM.ETA.IndexName := 'ByA'
         else DM.ETA.IndexName := 'ByEa';
      2: if RGSuchSort.ItemIndex = 1 then DM.ETB.IndexName := 'ByIb'
         else if RGSuchSort.ItemIndex = 2 then DM.ETB.IndexName := 'ByiZA'
         else if RGSuchSort.ItemIndex = 3 then DM.ETB.IndexName := 'ByA'
         else DM.ETB.IndexName := 'ByEb';
      3: if RGSuchSort.ItemIndex = 1 then DM.ETG.IndexName := 'ByIg'
         else if RGSuchSort.ItemIndex = 2 then DM.ETG.IndexName := 'ByiZA'
         else if RGSuchSort.ItemIndex = 3 then DM.ETG.IndexName := 'ByA'
         else DM.ETG.IndexName := 'ByEg';
      4: if RGSuchSort.ItemIndex = 1 then DM.ETXR.IndexName := 'ByXCode'
         else DM.ETXR.IndexName := 'ByEx';
      5: if RGSuchSort.ItemIndex = 1 then DM.ETAug.IndexName := 'ByACode'
         else DM.ETAug.IndexName := 'ByEa';
    end;
    RGSuchIdxAlt := RGSuchSort.Items[RGSuchSort.ItemIndex];
  end;
end;

function RTypBtn(idx: Integer;rtyp,DQL: Double): Boolean;
var i: Integer;
begin
  if (rtyp <> 6) and (rtyp <> 1.6) and (rtyp <> 2.6) then
  begin
    {if idx = 1 then
      frmMain.GridRbtn.ColCount := idx
    else frmMain.GridRbtn.ColCount := frmMain.GridRbtn.ColCount + 1;}
    if frmMain.GridRbtn.Cells[0,0] <> '' then
      frmMain.GridRbtn.ColCount := frmMain.GridRbtn.ColCount + 1;
    i := frmMain.GridRbtn.ColCount;
    frmMain.GridRbtn.ColorCell[i-1,0] := DM.RadFarbe(DM.RTyp1(rtyp));
    frmMain.GridRbtn.CellFont[i-1,0].Color := DM.RadFontFarbe(rtyp);
    frmMain.GridRbtn.Cells[i-1,0] := DM.Zerfallart(rtyp) + #32 + FloatToStr(DQL);
    frmMain.GridRbtn.HintCell[i-1,0] := FloatToStr(rtyp);
    frmMain.GridRbtn.Width := (frmMain.GridRbtn.DefaultColWidth * i) +
      ((i-1) * frmMain.GridRbtn.GridLineWidth) + 4;
    frmMain.GridRbtn.Left :=
      (frmMain.PanelSchema.ClientWidth - frmMain.GridRbtn.Width) div 2;
    if (i = 1) and (frmMain.RadTyp = 0) then
    begin
      frmMain.RadTyp := rtyp;
      frmMain.DQL := DQL;
    end;
  end;
  Result := True;
end;

function SetRadAlle(minn,maxn,minz,maxz: Integer): Boolean;
var
  i,i1,n,z,iza,y,c,r: Integer;
  temp: String;
begin
  frmMain.Gauge.Position := 0;
  with frmMain.GridReihe do
  begin
    c := 0; r := 0;
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
          ColorCell[n-minn+1,y] := frmMain.GridRad.ColorCell[i,i1];
          if (frmMain.GridRad.HintCell[i,i1] <> '') and
            (frmMain.GridRad.ColorCell[i,i1] <> clBlack) then
          begin
            temp := DM.FindRTypS(iza,DM.RadFarbNr(frmMain.GridRad.ColorCell[i,i1]));
            Cells[n-minn+1,y] := DM.GetNukBez(iza,True) + '[' + temp + ']';
          end else Cells[n-minn+1,y] := DM.GetNukBez(iza,True);
        end
        else if frmMain.GridRad.ColorCell[i,i1] = clSilver then
        begin
          ColorCell[1,1] := clSilver;
          Cells[1,1] := frmMain.GridRad.HintCell[i,i1];
        end;
      frmMain.Gauge.Position := Trunc((i1 / RowCount) * 100);
    end;
    for i1 := 1 to RowCount-1 do
      for i := 1 to ColCount-1 do
        if (Pos('[',Cells[i,i1]) > 0) and (ColorCell[i,i1] <> Color) then
        begin
          temp := Copy(Cells[i,i1],1,Pos('[',Cells[i,i1])-1);
          iza := DM.GetiZA(temp);
          DM.RadPfeilHint(iza,i,i1);
        end;
    PosNukReihe(c,r,True);
  end;
  frmMain.btnRad1.Enabled := (frmMain.bRad <> 1);
  frmMain.Gauge.Position := 0;
  Result := True;
end;

function SetNukLeg(idx: Integer): Boolean;
var
  i,i1,i2: Integer;
  temp: String;
begin
  with frmMain do
  begin
    if idx >= 7 then i1 := 158 else i1 := idx + 152;
    if MenuLeg.Checked then PanelLeg.Visible := (idx <> 6);
    {if idx = 6 then i2 := 8 else} i2 := 10;
    if DM.ETName.Locate('Nr',i1,[]) then
    begin
      {if idx >= 7 then
      begin
        temp := DM.ETName.FieldByName('F10').AsString;
        NukF[10] := StrToInt(GetKlammer(temp));
      end else NukF[10] := clBlack;}
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
            LegLbl[i].Caption := '> 10+17 s oder ' + Copy(temp,1,Pos('(',temp)-1)
          else LegLbl[i].Caption := Copy(temp,1,Pos('(',temp)-1);
          if idx = 0 then
            LegLbl[i+10].Left := 52
          else LegLbl[i+10].Left := LegLbl[21].Left;
        end;
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
    for i := 11 to 19 do
    begin
      LegShape[i].Brush.Color := NukF[i-10];
      LegShape[i].Visible := ((idx < 7) or ((i < 16) or (i = 19)));
      LegLbl[i].Visible := ((idx < 7) or ((i < 16) or (i = 19)));
    end;
    LegLbl[20].Visible := (idx < 7);
    LegShape[20].Visible := (idx < 7);
    LegShape[10].Visible := ((idx < 7) or (idx > 9));
    LegLbl[10].Visible := ((idx < 7) or (idx > 9));
  end;
  Result := True;
end;

function  TVSuchNuk(TV: TTreeView;txt,btn: String): Boolean;
var i: Integer;
begin
  Result := False;
  with frmMain do
    for i := 0 to TV.Items.Count-1 do
      if Pos(Trim(txt),TV.Items[i].Text) > 0 then
      begin
        TV.FullCollapse;
        TV.Select(TV.Items[i],[]);
        if btn = 'btnTVRadSuch' then
          TV.SetFocus
        else if PanelNukTV.Visible then TV.SetFocus;
        if (TV = TVNuk) and (GridNuk.DefaultColWidth > nukw) then
          PMExplGoNukClick(TVNuk);
        Result := True;
        Break;
      end;
end;

function XRay(iZA: Integer): Boolean;
var
  i,i1: Integer;
  temp: String;
begin
  i := 1;
  frmMain.SBGridRad.Visible := False;
  ClearGridForDaten(frmMain.GridReihe,4,True);
  with frmMain.GridReihe do
  begin
    if frmMain.RGGamSort.ItemIndex = 1 then
      DM.ETXI.IndexName := 'ByInt' else DM.ETXI.IndexName := 'ByEx';
    DM.ETXI.Filter := 'iZA = ' + IntToStr(iZA);
    if DM.ETXI.FindFirst then
    repeat
      if RowCount < i+1 then RowCount := i+1;
      for i1 := 0 to ColCount-1 do ColorCell[i1,i] := clInfoBk;
      if DM.ETXI.FieldByName('Ex').AsFloat <> 0 then
        Cells[1,i] := FloatToStr(DM.ETXI.FieldByName('Ex').AsFloat);
      if DM.ETXI.FieldByName('Int').AsFloat <> 0 then
      begin
        temp := FloatToStr(DM.ETXI.FieldByName('Int').AsFloat);
        if DM.ETXI.FieldByName('Intu').AsFloat <> 0 then
          temp := temp + '   ' + FloatToStr(DM.ETXI.FieldByName('Intu').AsFloat);
        Cells[2,i] := temp;
      end;
      i1 := DM.ETXI.FieldByName('XCode').AsInteger;
      if DM.ETXR.Locate('XCode',i1,[]) then
        Cells[3,i] := DM.GetSymXCode(i1) + #32 + DM.ETXR.FieldByName('Ass').AsString;
      Inc(i);
    until DM.ETXI.FindNext = False;
    DM.ETXI.Filter := '';
    if i = 1 then KeineNuklide(frmMain.GridReihe,'R�ntgen');
    {begin
      Cells[1,i] := 'Keine R�ntgen-';
      Cells[2,i] := 'Emissions-Daten';
      Cells[3,i] := 'vorhanden';
    end;}
    frmMain.SBGridReihe.VertScrollBar.Range := (i+1) * DefaultRowHeight;
  end;
  Result := True;
end;

procedure ZeigeAlpha(i,iza: Integer);
var
  //xn,xz,rc: Integer;
  temp: String;
begin
  if i = 1 then ClearGridForDaten(frmMain.GridSuch,1,True);
  with frmMain.GridSuch do
  begin
    if RowCount < i+1 then RowCount := i+1;
    if DM.ETA.FieldByName('Ea').AsFloat <> 0 then
    begin
      temp := Runde(DM.ETA.FieldByName('Ea').AsFloat,-3);
      if DM.ETA.FieldByName('Eau').AsFloat <> 0 then
        temp := temp + '   ' + Runde(DM.ETA.FieldByName('Eau').AsFloat,-2);
      Cells[1,i] := temp;
    end;
    if DM.ETA.FieldByName('Ia').AsFloat <> 0 then
    begin
      temp := Runde(DM.ETA.FieldByName('Ia').AsFloat,-3);
      if DM.ETA.FieldByName('Iau').AsFloat <> 0 then
        temp := temp + '   ' + Runde(DM.ETA.FieldByName('Iau').AsFloat,-3);
      Cells[2,i] := temp;    // SimpleRoundTo()
    end;
    if (DM.ETNukl.FieldByName('Tsek').AsFloat <> 0) then
      if DM.ETNukl.FieldByName('Tsek').AsFloat = -99 then
        Cells[3,i] := 'stabil'
      else Cells[3,i] := ZeitFormat(DM.ETNukl.FieldByName('Tsek').AsFloat);
    Cells[4,i] := DM.GetNukBez(iza,True);
  end;
  if i = 1 then PosGridSuchKarteScrollbar(iza);
end;

procedure ZeigeBeta(i,iza: Integer;ET: TEasyTable);
var
  a: Integer; // ,xn,xz,rc
  temp,Eb,Ib,Ibu: String;
begin
  if i = 1 then
    ClearGridForDaten(frmMain.GridSuch,frmMain.RGSuch.ItemIndex,True);
  if ET.Name = 'ETG' then
  begin
    Eb := 'Eg'; Ib := 'Ig'; Ibu := 'Igu';
  end else begin Eb := 'Eb'; Ib := 'Ib'; Ibu := 'Ibu'; end;
  with frmMain.GridSuch do
  begin
    a := DM.GetA(iza);
    if RowCount < i+1 then RowCount := i+1;
    if ET.FieldByName(Eb).AsFloat <> 0 then
    begin
      temp := Runde(ET.FieldByName(Eb).AsFloat,-3);
      if ET.Name = 'ETG' then
      begin
        if ET.FieldByName('Egu').AsFloat <> 0 then
          temp := temp + '   ' + Runde(ET.FieldByName('Egu').AsFloat,-3);
        if ET.FieldByName('EgStr').AsString <> '' then
          HintCell[0,i] := DM.GetSymb(iza) + #32 +
            ET.FieldByName('EgStr').AsString;
      end;
      if (ET.Name = 'ETB') and (ET.FieldByName('Ebu').AsFloat <> 0) then
        temp := temp + '   ' + Runde(ET.FieldByName('Ebu').AsFloat,-2);
      Cells[0,i] := temp;
    end;
    if ET.FieldByName(Ib).AsFloat <> 0 then
    begin
      temp := Runde(ET.FieldByName(Ib).AsFloat,-3);
      if ET.FieldByName(Ibu).AsFloat <> 0 then
        temp := temp + '   ' + Runde(ET.FieldByName(Ibu).AsFloat,-3);
      Cells[1,i] := temp;
    end;
    if (a > 0) and (DM.ETNukl.FieldByName('Tsek').AsFloat <> 0) then
      if DM.ETNukl.FieldByName('Tsek').AsFloat = -99 then
        Cells[2,i] := 'stabil'
      else Cells[2,i] := ZeitFormat(DM.ETNukl.FieldByName('Tsek').AsFloat);
    Cells[3,i] := DM.Zerfallart(ET.FieldByName('DMode').AsFloat);
    if a = 0 then
      Cells[4,i] := DM.GetSymb(iza)
    else Cells[4,i] := DM.GetNukBez(iza,True);
  end;
  if i = 1 then PosGridSuchKarteScrollbar(iza);
end;

procedure ZeigeXRay(i,iza: Integer;ET: TEasyTable);
var
  //xn,xz,rc: Integer;
  temp,Ea: String;
begin
  if i = 1 then ClearGridForDaten(frmMain.GridSuch,4,True);
  if ET.Name = 'ETXR' then Ea := 'Ex' else Ea := 'Ea';
  with frmMain.GridSuch do
  begin
    {xz := DM.GetZ(iza);
    rc := frmMain.GridSuchKarte.RowCount;
    if (ET.Name = 'ETXR') and (rc-xz-1 >= 1) then
    begin
      xn := DM.GetN(iza);
      frmMain.GridSuchKarte.ColorCell[xn+1,rc-xz-1] := clNavy;
      frmMain.GridSuchKarte.HintCell[xn+1,rc-xz-1] :=
        IntToStr(xz) + #32 + DM.GetSymb(iza) + #32 + IntToStr(DM.GetA(iza)) +
        ' = ' + DM.NukName(DM.GetSymb(iza));
    end;}
    if RowCount < i+1 then RowCount := i+1;
    Cells[0,i] := DM.GetSymb(iza) + #32 + ET.FieldByName('Ass').AsString;
    Cells[1,i] := IntToStr(DM.GetZ(iza));
    if ET.FieldByName(Ea).AsFloat <> 0 then
      Cells[2,i] := FloatToStr(ET.FieldByName(Ea).AsFloat);
    if ET.FieldByName('KInt').AsFloat <> 0 then
    begin
      temp := FloatToStr(ET.FieldByName('KInt').AsFloat);
      if (ET.Name = 'ETXR') and (ET.FieldByName('KIntu').AsFloat <> 0) then
        temp := temp + '   ' + FloatToStr(ET.FieldByName('KIntu').AsFloat);
      Cells[3,i] := temp;
    end;
    if ET.FieldByName('L1Int').AsFloat <> 0 then
    begin
      temp := FloatToStr(ET.FieldByName('L1Int').AsFloat);
      if (ET.Name = 'ETXR') and (ET.FieldByName('L1Intu').AsFloat <> 0) then
        temp := temp + '   ' + FloatToStr(ET.FieldByName('L1Intu').AsFloat);
      Cells[4,i] := temp;
    end;
    if ET.FieldByName('L2Int').AsFloat <> 0 then
    begin
      temp := FloatToStr(ET.FieldByName('L2Int').AsFloat);
      if (ET.Name = 'ETXR') and (ET.FieldByName('L2Intu').AsFloat <> 0) then
        temp := temp + '   ' + FloatToStr(ET.FieldByName('L2Intu').AsFloat);
      Cells[5,i] := temp;
    end;
    if ET.FieldByName('L3Int').AsFloat <> 0 then
    begin
      temp := FloatToStr(ET.FieldByName('L3Int').AsFloat);
      if (ET.Name = 'ETXR') and (ET.FieldByName('L3Intu').AsFloat <> 0) then
        temp := temp + '   ' + FloatToStr(ET.FieldByName('L3Intu').AsFloat);
      Cells[6,i] := temp;
    end;
  end;
  if i = 1 then PosGridSuchKarteScrollbar(iza);
end;

procedure ZerfallsreiheDaten(txt: String;NMode: Integer);
var
  i,i1,a,l,z,iza: Integer;
  d,trtyp,trt: Double;
  temp,temp1,temp2: String;
begin
  iza := 0; i1 := 0; trtyp := 0; trt := 0;
  frmMain.SBGridRad.Visible := False;
  frmMain.btnBack.Visible := True;
  temp := txt;
  //ShowMessage(temp);
  ClearGridForDaten(frmMain.GridReihe,6,True);
  with frmMain.GridReihe do
  begin
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
        Inc(i1);
        temp2 := Trim(Copy(temp1,1,Pos(';',temp1)-1));
        Cells[1,RowCount-1] := temp2;   // RTyp
        if DM.ETDM.Locate('D_MODE',temp2,[]) and
          (DM.ETDM.FieldByName('RTYP').asFloat > 0) then
        begin
          d := DM.ETDM.FieldByName('RTYP').asFloat;
          //if DM.ETDMI.Locate('iZA;RTYP;BR',VarArrayOf([iza,d,br]),[]) then
          DM.ETDMI.Filter := 'iZA = ' + IntToStr(iza);
          if DM.ETDMI.FindFirst then
          repeat
            if (i1 = 1) and (DM.ETDMI.FieldByName('NMode').AsFloat = NMode) then
              trtyp := DM.ETDMI.FieldByName('TRTyp').AsFloat;
            if (DM.ETDMI.FieldByName('RTYP').AsFloat = d) and
               (((i1 = 2) and (d = trtyp)) or ((i1 > 2) and (d = trt)) or
               ((i1=1) and (DM.ETDMI.FieldByName('NMode').AsFloat = NMode)) or
               ((i1>1) and (DM.ETDMI.FieldByName('NMode').AsFloat = 1))) then
            begin
              if i1 > 1 then trtyp := DM.ETDMI.FieldByName('TRTyp').AsFloat;
              if (i1 > 2) and (d = trt) then trt := 0;
              for i := 0 to ColCount - 1 do
              begin
                ColorCell[i,RowCount-1] :=
                  DM.RadFarbe(DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
                CellFont[i,RowCount-1].Color :=
                  DM.RadFontFarbe(DM.RTyp1(DM.ETDMI.FieldByName('RTYP').AsFloat));
                  //KontrastFarbe(ColorCell[i,RowCount-1],2);
              end;
              if DM.ETDMI.FieldByName('BR').AsFloat <> 0 then
                Cells[2,RowCount-1] :=
                  FloatToStr(DM.ETDMI.FieldByName('BR').AsFloat) + ' %';
              if {(d <> 3) and} (DM.ETDMI.FieldByName('DQ').AsFloat > 0) then
                Cells[4,RowCount-1] :=
                  FloatToStr(DM.ETDMI.FieldByName('DQ').AsFloat) + ' keV';
              {else if (d = 3) and (DM.ETDMI.FieldByName('El').AsFloat > 0) then
                Cells[4,RowCount-1] :=
                  FloatToStr(DM.ETDMI.FieldByName('El').AsFloat) + ' keV';}
              if DM.ETDMI.FieldByName('Tochter').AsInteger > 0 then
                Cells[5,RowCount-1] :=
                  DM.GetNukBez(DM.ETDMI.FieldByName('Tochter').AsInteger,True)
              else if temp2 = 'SF' then Cells[5,RowCount-1] := '?';
            end;
            if (i1 > 1) and (DM.ETDMI.FieldByName('TRTyp').AsFloat <> 0) then
              trt := DM.ETDMI.FieldByName('TRTyp').AsFloat;
          until DM.ETDMI.FindNext = False;
          DM.ETDMI.Filter := '';
        end;
      end;
    end;
  end;
end;

end.
