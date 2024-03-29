unit UnitChart;

interface

uses Windows, SysUtils, Dialogs, Graphics, TeEngine, Series, TeeProcs, Chart,
     DB, Controls;

  function  LeftText(idx: Integer): String;
  function  NukChart(idx: Integer): Boolean;
  function  PSEChartANI(Feld: String): Boolean;
  function  PSEChartEDM(Feld: String): Boolean;
  function  SetChartButtons: Boolean;
  function  SetDiagLeg(idx: Integer;Farbe: TColor;Txt: String): Boolean;
  function  ShowPSEDiagramm(Idx: Integer): Boolean;

implementation

uses UnitMain, UnitDM, UnitNukFunc, Aligrid;

function LeftText(idx: Integer): String;
begin
  with frmMain do
    case idx of
      3..6: if bAbund then
              Result := GridPSEDaten.Cells[0,8]
            else Result := RG.Items[RG.ItemIndex];
      7..9: Result := GridPSEDaten.Cells[0,RG.ItemIndex + 2];
      11..25:  Result := GridPSEDaten.Cells[0,RG.ItemIndex + 1];
    else Result := RG.Items[RG.ItemIndex];
    end;
end;

function NukChart(idx: Integer): Boolean;
var
  A,iza: Integer;
  MeV: Double;
  Farbe: TColor;
  temp,Feld: String;
begin
  with frmMain do
  begin
    case idx of
      2: begin
           temp := Copy(GridDaten.Cells[0,9],1,Pos(#32,GridDaten.Cells[0,9])-1);
           Feld := 'BE';
         end;
      3: begin
           temp := 'Massenexzess';
           Feld := 'MassExc';
         end;
      4: begin
           temp := GridDaten.HintCell[0,11];
           Feld := 'Sn';
         end;
      5: begin
           temp := GridDaten.HintCell[0,10];
           Feld := 'Sp';
         end;
    end;
    Chart1.View3D := False;
    if bZoom then Chart1.MaxPointsPerPage := 100 else Chart1.MaxPointsPerPage := 0;
    Farbe := clBlue;
    DM.ETChem.DisableControls;
    DM.ETNukl.DisableControls;
    if (idx >= 2) and (idx <= 5) then
    begin
      Series1.Active := False;
      if bAbund then
      begin
        Series2.Active := False;
        Series3.Active := True;
        Series3.Clear;
        DM.ETNukl.First;
        while not DM.ETNukl.Eof do
        begin
          iza := DM.ETNukl.FieldByName('iZA').AsInteger;
          if (iza mod 10 = 0) and (DM.ETNukl.FieldByName(Feld).AsFloat <> 0) then
          begin
            MeV := DM.ETNukl.FieldByName(Feld).AsFloat / 1000;
            A := DM.GetA(iza);
            Series3.AddXY(A,MeV,'',Farbe);
          end;
          DM.ETNukl.Next;
        end;
        if Series3.Marks.Visible then
          btnMarks.Caption := 'Werte nicht anzeigen'
        else btnMarks.Caption := 'Werte anzeigen';
      end
      else
      begin
        Series3.Active := False;
        Series2.Active := True;
        Series2.Clear;
        DM.ETChem.First;
        while not DM.ETChem.Eof do
        begin
          iza := DM.ETChem.FieldByName('iZA').AsInteger;
          A := DM.GetA(iza);
          if DM.ETNukl.Locate('iZA',iza,[]) then
          begin
            MeV := DM.ETNukl.FieldByName(Feld).AsFloat / 1000;
            Series2.AddXY(A,MeV,'',Farbe);
          end;
          DM.ETChem.Next;
        end;
        if Series2.Marks.Visible then
          btnMarks.Caption := 'Werte nicht anzeigen'
        else btnMarks.Caption := 'Werte anzeigen';
      end;
      Chart1.LeftAxis.Title.Caption := temp + ' in MeV';
      Chart1.Title.Text[0] := temp + ' pro Nukleon(A)';
      Chart1.BottomAxis.Title.Caption := 'Massenzahl A';
    end;
    {else
    begin
      Series1.Active := False;
      Series2.Active := False;
      Series3.Active := False;
      //Chart1.View3DWalls := True;
      //Chart1.View3D := True;
      for i := 0 to 117 do
      begin
        //BarSerie[i].Active := True;
        //BarSerie[i].Marks.Visible := False;
        BarSerie[i].Clear;
      end;
      DM.ETNukl.First;
      while not DM.ETNukl.Eof do
      begin
        iza := DM.ETNukl.FieldByName('iZA').AsInteger;
        Z := DM.GetZ(iza);
        if (iza mod 10 = 0) and (Z < 20) and
          (DM.ETNukl.FieldByName('MassExc').AsFloat <> 0) then
        begin
          MeV := DM.ETNukl.FieldByName('MassExc').AsFloat / 1000;
          //A := DM.GetA(iza);
          N := DM.GetN(iza);
          //Z := DM.GetZ(iza);
          BarSerie[118-Z].Active := True;
          BarSerie[118-Z].AddXY(N,MeV,IntToStr(Z),Farbe);
        end;
        DM.ETNukl.Next;
      end;
      Chart1.LeftAxis.Title.Caption := 'MassenExcess in MeV';
      Chart1.Title.Text[0] := 'MassenExcess pro A';
      Chart1.BottomAxis.Title.Caption := 'N';
    end;}
    DM.ETNukl.EnableControls;
    DM.ETChem.EnableControls;
    for A := 0 to 9 do
    begin
      LegShape[A].Visible := False;
      LegLbl[A].Visible := False;
    end;
    btnVor.Enabled := (Chart1.NumPages > 1);
  end;
  Result := True;
end;

function PSEChartANI(Feld: String): Boolean;
var
  Z,Y: Integer;
  Farbe: TColor;
begin
  with frmMain do
  begin
    Series1.Active := True;
    Series2.Active := False;
    Series3.Active := False;
    Series1.Clear;
    Chart1.View3D := False;
    if bZoom then Chart1.MaxPointsPerPage := 25 else Chart1.MaxPointsPerPage := 0;
    DM.ETChem.DisableControls;
    DM.ETChem.First;
    if RG.ItemIndex = 5 then Farbe := clPurple else Farbe := clRed;
    while not DM.ETChem.Eof do
    begin
      Z := DM.ETChem.FieldByName('Nr').AsInteger;
      if RG.ItemIndex = 3 then
      begin
        Y := Trunc(DM.ETChem.FieldByName(Feld).AsFloat -
          Frac(DM.ETChem.FieldByName(Feld).AsFloat));
        if Frac(DM.ETChem.FieldByName(Feld).AsFloat) > 0 then
          Series1.AddXY(Z,Y,'',clPurple) else Series1.AddXY(Z,Y,'',clRed);
      end
      else if RG.ItemIndex = 4 then
        Series1.AddXY(Z,DM.AnzIso(DM.IZAvonZ(Z),True),'',Farbe)
        //Series1.AddXY(Z,DM.ETChem.FieldByName(Feld).AsInteger,'',Farbe)
      else if RG.ItemIndex = 5 then
        Series1.AddXY(Z,DM.AnzIso(DM.IZAvonZ(Z),False),'',Farbe)
        //Series1.AddXY(Z,DM.ETChem.FieldByName(Feld).AsInteger,'',Farbe)
      else if (RG.ItemIndex = 6) and bAbund then
      begin
        if DM.ETNukl.Locate('iZA',DM.IZAvonZ(Z),[]) then
          Series1.AddXY(Z,DM.ETNukl.FieldByName('Abund').AsFloat,'',Farbe);
      end else Series1.AddXY(Z,DM.ETChem.FieldByName(Feld).AsFloat,'',Farbe);
      DM.ETChem.Next;
    end;
    DM.ETChem.EnableControls;
    Chart1.LeftAxis.Title.Caption := LeftText(RG.ItemIndex);
    if bAbund then
      Chart1.Title.Text[0] :=
        Copy(Chart1.LeftAxis.Title.Caption,1,Pos('in',Chart1.LeftAxis.Title.Caption)-1)
    else Chart1.Title.Text[0] := RG.Items[RG.ItemIndex];
    Chart1.BottomAxis.Maximum := 118;
    Chart1.BottomAxis.Title.Caption := 'Kernladungszahl Z';
    Chart1.LeftAxis.Maximum := Max;
    if (RG.ItemIndex >= 3) and (RG.ItemIndex <= 5) then
    begin
      SetDiagLeg(1,clRed,'nat�rlich');
      SetDiagLeg(2,clPurple,'radoaktiv');
    end
    else
      for Z := 0 to 9 do
      begin
        LegShape[Z].Visible := False;
        LegLbl[Z].Visible := False;
      end;
  end;
  Result := True;
end;

function  PSEChartEDM(Feld: String): Boolean;
var
  i,i1: Integer;
  temp: String;
  NukLand: array[0..12] of Integer;
begin
  for i := 0 to 12 do NukLand[i] := 0;
  frmMain.Series1.Active := True;
  frmMain.Series2.Active := False;
  frmMain.Series3.Active := False;
  frmMain.Series1.Clear;
  frmMain.Series1.ColorEachPoint := True;
  frmMain.Chart1.View3D := True;
  frmMain.Chart1.MaxPointsPerPage := 0;
  with DM.ETChem do
  begin
    DisableControls;
    First;
    while not Eof do
    begin
      if Frac(FieldByName(Feld).AsFloat) > 0 then
      begin
        temp := FloatToStr(FieldByName(Feld).AsFloat);
        i := Trunc(FieldByName(Feld).AsFloat);
        System.Delete(temp,1,Pos(DM.DezS,temp));
        i1 := StrToInt(temp);
        Inc(NukLand[i-1]);
        Inc(NukLand[i1-1]);
      end
      else
      begin
        i := Trunc(FieldByName(Feld).AsFloat);
        Inc(NukLand[i-1]);
      end;
      Next;
    end;
    EnableControls;
  end;
  for i := 0 to 12 do
    frmMain.Series1.AddXY(i+1,NukLand[i],'',clTeeColor);
  frmMain.Chart1.Title.Text[0] := frmMain.RG.Items[frmMain.RG.ItemIndex];
  frmMain.Chart1.BottomAxis.Maximum := 13;
  frmMain.Chart1.BottomAxis.Title.Caption := 'Nation';
  frmMain.Chart1.LeftAxis.Title.Caption := 'Anzahl entdeckter Elemente';
  for i := 0 to 9 do
  begin
    frmMain.LegShape[i].Visible := False;
    frmMain.LegLbl[i].Visible := False;
  end;
  Result := True;
end;

function SetChartButtons: Boolean;
begin
  with frmMain do
  begin
    if not MenuPSE.Enabled then
    begin
      btnPSE.Caption := 'Zur�ck zum PSE';
      btnAbund.Visible := (RG.ItemIndex = 6);
      if not bAbund then
           btnAbund.Caption := 'Nat�rliche H�ufigkeit'
      else btnAbund.Caption := 'Massenanteil Erdkruste';
      if Series1.Marks.Visible then
        btnMarks.Caption := 'Werte nicht anzeigen'
      else btnMarks.Caption := 'Werte anzeigen';
    end
    else
    begin
      btnPSE.Caption := 'Zur Nuklidkarte';
      btnAbund.Visible := (CBHalf.ItemIndex > 1);
      if not bAbund then
        btnAbund.Caption := 'Alle Isotope'
      else btnAbund.Caption := 'Nur nat�rliche Nuklide';
    end;
    btnPSE.Left := Chart1.Width - btnPSE.Width - 30;
    btnPSE.Top := Chart1.Top + Chart1.Height - btnPSE.Height - 10;
    btnMarks.Top := btnPSE.Top;
    btnMarks.Left := Chart1.Left + 30;
    btnZoom.Top := btnMarks.Top;
    btnZoom.Left := btnMarks.Left + btnMarks.Width + 10;
    btnAbund.Top := btnMarks.Top;
    btnAbund.Left := btnPSE.Left - btnAbund.Width - 10;
    btnZur.Left := btnZoom.Left + btnZoom.Width-2;
    btnVor.Left := btnZur.Left + btnZur.Width-2;
    btnZur.Top := btnMarks.Top;
    btnVor.Top := btnMarks.Top;
    btnVor.Enabled := (Chart1.NumPages > 1);
  end;
  Result := True;
end;

function  SetDiagLeg(idx: Integer;Farbe: TColor;Txt: String): Boolean;
var i,i1: Integer;
begin
  with frmMain do
  begin
    LegShape[idx].Brush.Color := Farbe;
    i1 := LegShape[0].Width + 15 + LegLbl[0].Width + 5;
    for i := 0 to idx-1 do
    begin
       LegShape[i].Left := Chart1.ClientWidth - ((idx * i1 + 20) - (i * i1));
       LegLbl[i].Left := LegShape[i].Left + 15;
    end;
    LegShape[idx-1].Brush.Color := Farbe;
    LegLbl[idx-1].Caption := Txt;
    LegShape[idx-1].Visible := True;
    LegLbl[idx-1].Visible := True;
  end;
  Result := True;
end;

function ShowPSEDiagramm(Idx: Integer): Boolean;
begin
  frmMain.Series1.Active := True;
  frmMain.Series2.Active := False;
  frmMain.Series3.Active := False;
  case Idx of
    3..9,11..25,27,28: PSEChartANI(frmMain.Spalte);
    31: PSEChartEDM('Land');
  end;
  SetChartButtons;
  Result := True;
end;

end.
