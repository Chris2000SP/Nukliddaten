unit UnitPSE;

interface

uses Windows, Types, SysUtils, Classes, Math, Graphics, Grids, Aligrid, DB,
     StdCtrls, JclUnitConv;

  procedure Dreieck(R: TRect;Z: Integer);
  procedure GetLand(R: TRect;Z: Integer; Symb: String);
  function  GridPSENuk(Z: Integer): Boolean;
  procedure GruppenNr(R: TRect;h,w,gr: Integer; txt: String);
  procedure MarkRect(R: TRect;Folge: Boolean;Alt: Boolean);
  procedure PSEDaten(iza: Integer);
  procedure PSEKonf;
  function  PSENukFarbe(Z: Integer): TColor;
  procedure PSEGoElement(Key: Word);
  procedure RelMass;
  function  SetFarbe(idx,anz: Integer): Boolean;
  procedure SetLabels;

implementation

uses UnitMain, UnitDM, UnitNukFunc;

procedure Dreieck(R: TRect;Z: Integer);
var
  temp: String;
  fc: TColor;
begin
  with frmMain do
    if DM.ETChem.Locate('Nr',Z,[]) then
    begin
      if RG.ItemIndex = 30 then
        temp := Bio(DM.ETChem.FieldByName(Spalte).AsString)
      else temp := Kristrukt(DM.ETChem.FieldByName(Spalte).AsString);
      if (Length(temp) > 1) and (temp <> '-1') then
        with GridPSE.Canvas do
        begin
          fc := Brush.Color;
          Brush.Color := PSEF[StrToInt(temp[2])];
          Pen.Color := Brush.Color;
          Polygon([Point(R.Right-11,R.Top),Point(R.Right-1,R.Top+10),Point(R.Right-1,R.Top)]);
          Brush.Color := fc;
        end;
    end;
end;

procedure GetLand(R: TRect;Z: Integer; Symb: String);
var
  i,i1,th,tw,h,w,iza,L1,L2: Integer;
  temp: String;
  Wahr: Boolean;
  Icon1,Icon2: TIcon;
begin
  Icon1 := TIcon.Create;
  Icon2 := TIcon.Create;
  Wahr := DM.Rad(Z);
  h := R.Bottom - R.Top;
  w := R.Right - R.Left;
  iza := DM.IZAvonZ(Z);
  with frmMain.GridPSE.Canvas do
    if DM.ETChem.Locate('iZA',iza,[]) then
      if not Wahr and (DM.ETChem.FieldByName('Land').AsFloat > 11) then
      begin
        Font.Name := 'Times New Roman';
        tw := TextWidth(IntToStr(Z));
        i := R.Left + ((w div 2) - (tw div 2));
        TextOut(i, R.Top + 2, IntToStr(Z));
        Font.Color := clBlack;
        Font.Style := [fsBold];
        Font.Size := 12;
        th := TextHeight(Symb);
        tw := TextWidth(Symb);
        i := R.Left + ((w div 2) - (tw div 2));
        i1 := R.Top + (h - th - 2);
        TextOut(i, i1, Symb);
      end
      else
      begin
        temp := FloatToStr(DM.ETChem.FieldByName('Land').AsFloat);
        if not Wahr and (Pos(DM.DezS,temp) > 0) then
        begin
          L1 := StrToInt(Copy(temp,1,Pos(DM.DezS,temp)-1))-1;
          Delete(temp,1,Pos(DM.DezS,temp));
          L2 := StrToInt(temp)-1;
          DM.ILFlag.GetIcon(L1, Icon1);
          DM.ILFlag.GetIcon(L2, Icon2);
          Draw(R.Right-16,R.Top-1, Icon2);
          Draw(R.Left-1,R.Top-1, Icon1);
        end
        else
        begin
          if Wahr then
            DM.ILFlag.GetIcon(12, Icon1)
          else
          begin
            L1 := StrToInt(temp)-1;
            DM.ILFlag.GetIcon(L1, Icon1)
          end;
          i := (w - 16) div 2;
          Draw(R.Left+i,R.Top-1, Icon1);
        end;
        Font.Name := 'Arial';
        Font.Color := clNavy;
        Font.Style := [];
        Font.Size := 7;
        tw := TextWidth(IntToStr(Z));
        i := R.Left + ((w div 2) - (tw div 2));
        i1 := R.Top + 13;
        TextOut(i, i1, IntToStr(Z));
        Font.Color := clBlack;
        Font.Style := [fsBold];
        Font.Size := 8;
        tw := TextWidth(Symb);
        i := R.Left + ((w div 2) - (tw div 2));
        i1 := R.Top + 22;
        TextOut(i, i1, Symb);
      end;
  Icon1.Free;
  Icon2.Free;
end;

function  GridPSENuk(Z: Integer): Boolean;
var
  c,r: Integer;
  temp,Sym: String;
begin
  if DM.ETChem.Locate('Nr',Z,[]) then
  begin
    Sym := DM.GetSymb(DM.ETChem.FieldByName('iZA').AsInteger);
    temp := FloatToStr(DM.ETChem.FieldByName('Gruppe').asFloat);
    c := Trunc(DM.ETChem.FieldByName('Gruppe').asFloat);
    Delete(temp,1,Pos(DM.DezS,temp));
    r := StrToInt(temp);
    if r > 7 then Inc(r);
    frmMain.GridPSE.Cells[c,r] := IntToStr(Z) + #13#10 + Sym;
    frmMain.GridPSE.HintCell[c,r] := IntToStr(Z) + #32 + Sym + ' = ' +
      DM.NukName(Sym);
    frmMain.GridSpecPSE.ColorCell[c-1,r-1] := clWhite;
    frmMain.GridSpecPSE.Cells[c-1,r-1] := Sym;//IntToStr(Z) + #32 + Sym;
    frmMain.GridSpecPSE.HintCell[c-1,r-1] := frmMain.GridPSE.HintCell[c,r];
    Result := True;
  end else Result := False;
end;

procedure GruppenNr(R: TRect;h,w,gr: Integer; txt: String);
var
  i,i1,th,tw,hw: Integer;
  Rekt: TRect;
begin
  with frmMain.GridPSE.Canvas do
  begin
    hw := w div 2;
    if gr > 0 then Rekt.Left := R.Left + 1
    else Rekt.Left := R.Right - (h div 2) + 2;
    if (gr = 1) or (gr = 4) then
      Rekt.Top := R.Top + (h div 2) + 4 else Rekt.Top := R.Top;
    if gr = 2 then Rekt.Right := R.Left + (w * 2)
    else if gr = 3 then Rekt.Right := R.Left + (w * 8)
    else if gr = 4 then Rekt.Right := R.Left + (w * 3)
    else Rekt.Right := R.Right;
    Rekt.Bottom := R.Bottom - 1;
    if gr = 3 then Brush.Color := $00FFFFCC else Brush.Color := clGray;
    FillRect(Rekt);
    if gr = 3 then Font.Color := clNavy else Font.Color := clInfoBk;
    Font.Style := [];
    if gr = 3 then Font.Size := 16 else Font.Size := 8;
    th := TextHeight(txt);
    tw := TextWidth(txt);
    if gr = 1 then i := R.Left + (hw - (tw div 2))
    else if gr = 2 then i := R.Left + (w - (tw div 2))
    else if gr = 3 then i := R.Left
    else if (gr <> 4) then i := R.Left + (w div 2) + ((hw - tw) div 2) + 4
    else
    begin
      Font.Color := clGray;
      i := R.Left + (hw - (tw div 2));
    end;
    if gr = 1 then i1 := R.Bottom - th - 1
    else if gr = 2 then i1 := R.Top + ((h div 2) - (th div 2))
    else if gr = 4 then i1 := R.Bottom - th - 1
    else i1 := R.Top + (h div 2) - (th div 2);
    TextOut(i, i1, txt);
  end;
end;

procedure MarkRect(R: TRect;Folge: Boolean;Alt: Boolean);
var
  Farbe: TColor;
  Rekt: TRect;
begin
  Rekt.Left := R.Left;
  Rekt.Top := R.Top;
  Rekt.Right := R.Right;
  Rekt.Bottom := R.Bottom;
  if Alt then Farbe := frmMain.GridPSE.Color else Farbe := clBlack;
  with frmMain.GridPSE.Canvas do
  begin
    Pen.Color := Farbe;
    if Folge then
    begin
      MoveTo(Rekt.Left-1,Rekt.Top-1);
      LineTo(Rekt.Left-1,Rekt.Bottom);
    end
    else
    begin
      MoveTo(Rekt.Left-1,Rekt.Top-1);
      LineTo(Rekt.Left-1,Rekt.Bottom);
      MoveTo(Rekt.Left-1,Rekt.Top-1);
      LineTo(Rekt.Right-1,Rekt.Top-1);
      MoveTo(Rekt.Left,Rekt.Bottom);
      LineTo(Rekt.Right-1,Rekt.Bottom);
    end;
  end;
end;

procedure PSEDaten(iza: Integer);
var
  i,i1,i2,i3,i4,i5,i6,i7: Integer;
  temp: String;
begin
  with frmMain.GridPSEDaten do
  begin
    if DM.ETName.Locate('Nr',DM.GetZ(iza),[]) then
      Cells[1,1] := DM.ETName.FieldByName('F2').AsString;
    if DM.ETChem.Locate('iZA',iza,[]) then
    begin
      Cells[1,2] := DM.ETChem.FieldByName('Symb').AsString;
      Cells[1,3] := IntToStr(DM.GetZ(iza));
      if not DM.ETChem.FieldByName('AnzNatIso').IsNull then
      begin
        temp := FloatToStr(DM.ETChem.FieldByName('AnzNatIso').AsFloat);
        if Pos(DM.DezS,temp) > 0 then
          temp := Copy(temp,1,Pos(DM.DezS,temp)-1);
        Cells[1,4] := temp;
      end else Cells[1,4] := '0';
      CellAsInt[1,5] := DM.AnzIso(iza,True);
      CellAsInt[1,6] := DM.AnzIso(iza,False);
      if DM.ETChem.FieldByName('MassErd').AsFloat <> 0 then
        Cells[1,7] := FloatToStr(DM.ETChem.FieldByName('MassErd').AsFloat)
      else Cells[1,7] := '';
      if DM.ETNukl.Locate('iZA',iza,[]) and
        (DM.ETNukl.FieldByName('Abund').AsFloat <> 0) then
        Cells[1,8] := FloatToStr(DM.ETNukl.FieldByName('Abund').AsFloat)
      else Cells[1,8] := '';
      if DM.ETChem.FieldByName('DMasse').AsFloat <> 0 then
        Cells[1,9] := FloatToStr(DM.ETChem.FieldByName('DMasse').AsFloat)
      else Cells[1,9] := '';
      if DM.ETChem.FieldByName('AVolum').AsFloat <> 0 then
        Cells[1,10] := FloatToStr(DM.ETChem.FieldByName('AVolum').AsFloat)
      else Cells[1,10] := '';
      if DM.ETChem.FieldByName('Dichte').AsFloat <> 0 then
        Cells[1,11] := FloatToStr(DM.ETChem.FieldByName('Dichte').AsFloat)
      else Cells[1,11] := '';
      if DM.ETChem.FieldByName('ElekN').AsFloat <> 0 then
        Cells[1,12] := FloatToStr(DM.ETChem.FieldByName('ElekN').AsFloat)
      else Cells[1,12] := '';
      if DM.ETChem.FieldByName('IEnergie').AsFloat <> 0 then
        Cells[1,13] := FloatToStr(DM.ETChem.FieldByName('IEnergie').AsFloat)
      else Cells[1,13] := '';
      if DM.ETChem.FieldByName('SEL').AsFloat <> 0 then
        Cells[1,14] := FloatToStr(DM.ETChem.FieldByName('SEL').AsFloat)
      else Cells[1,14] := '';
      if DM.ETChem.FieldByName('GEnergie').AsFloat <> 0 then
        Cells[1,15] := FloatToStr(DM.ETChem.FieldByName('GEnergie').AsFloat)
      else Cells[1,15] := '';
      if DM.ETChem.FieldByName('ARadius').AsFloat <> 0 then
        Cells[1,16] := FloatToStr(DM.ETChem.FieldByName('ARadius').AsFloat)
      else Cells[1,16] := '';
      if DM.ETChem.FieldByName('IRadius').AsInteger > 0 then
        CellAsInt[1,17] := DM.ETChem.FieldByName('IRadius').AsInteger
      else Cells[1,17] := '';
      if DM.ETChem.FieldByName('KRadius').AsInteger > 0 then
        CellAsInt[1,18] := DM.ETChem.FieldByName('KRadius').AsInteger
      else Cells[1,18] := '';
      if DM.ETChem.FieldByName('WRadius').AsInteger > 0 then
        CellAsInt[1,19] := DM.ETChem.FieldByName('WRadius').AsInteger
      else Cells[1,19] := '';
      if DM.ETChem.FieldByName('SchmTemp').AsFloat <> 0 then
        Cells[1,20] := FloatToStr(DM.ETChem.FieldByName('SchmTemp').AsFloat)
      else Cells[1,20] := '';
      if DM.ETChem.FieldByName('SiedeTemp').AsFloat <> 0 then
        Cells[1,21] := FloatToStr(DM.ETChem.FieldByName('SiedeTemp').AsFloat)
      else Cells[1,21] := '';
      if DM.ETChem.FieldByName('TempDiff').AsFloat <> 0 then
        Cells[1,22] := ZahlFormat(DM.ETChem.FieldByName('TempDiff').AsFloat,0,5)
      else Cells[1,22] := '';
      if DM.ETChem.FieldByName('VW').AsFloat <> 0 then
        Cells[1,23] := FloatToStr(DM.ETChem.FieldByName('VW').AsFloat)
      else Cells[1,23] := '';
      if DM.ETChem.FieldByName('SW').AsFloat <> 0 then
        Cells[1,24] := FloatToStr(DM.ETChem.FieldByName('SW').AsFloat)
      else Cells[1,24] := '';
      if DM.ETChem.FieldByName('WLF').AsFloat <> 0 then
        Cells[1,25] := FloatToStr(DM.ETChem.FieldByName('WLF').AsFloat)
      else Cells[1,25] := '';
      if DM.ETChem.FieldByName('SpWarm').AsFloat <> 0 then
        Cells[1,26] := FloatToStr(DM.ETChem.FieldByName('SpWarm').AsFloat)
      else Cells[1,26] := '';
      if DM.ETChem.FieldByName('AKoeff').AsFloat <> 0 then
        Cells[1,27] := FloatToStr(DM.ETChem.FieldByName('AKoeff').AsFloat)
      else Cells[1,27] := '';
      if DM.ETChem.FieldByName('ElModul').AsFloat <> 0 then
        Cells[1,28] := FloatToStr(DM.ETChem.FieldByName('ElModul').AsFloat)
      else Cells[1,28] := '';
      Cells[1,29] := DM.ETChem.FieldByName('Wertigkeit').AsString;
      Cells[1,30] := DM.ETChem.FieldByName('OxidZahl').AsString;
      Cells[1,31] := DM.ETChem.FieldByName('RedPot').AsString;
      if DM.ETChem.FieldByName('Jahr').AsInteger > 0 then
      begin
        Cells[1,32] := DM.ETChem.FieldByName('Entdecker').AsString;
        HintCell[1,32] := DM.ETChem.FieldByName('Entdecker').AsString;
        temp := IntToStr(DM.ETChem.FieldByName('Jahr').AsInteger) + ' - ';
        Cells[1,33] := temp + DM.LandName(DM.ETChem.FieldByName('Land').AsFloat);
      end
      else
      begin
        Cells[1,32] := '';
        HintCell[1,32] := '';
        Cells[1,33] := DM.ETChem.FieldByName('Entdecker').AsString;
      end;
      Cells[1,34] := Schale(DM.ETChem.FieldByName('HQ').AsString);
      temp := Bio(DM.ETChem.FieldByName('Bio').AsString);
      if (temp <> '-1') and DM.ETName.Locate('Nr',150,[]) then
      begin
        i := StrToInt(temp[1])+1;
        temp := DM.ETName.FieldByName('F' + IntToStr(i)).AsString;
        frmMain.GridZusatz.Cells[2,1] := Copy(temp,1,Pos('(',temp)-1);
      end else frmMain.GridZusatz.Cells[2,1] := '';
      Cells[1,35] := DM.ETChem.FieldByName('Kurzform').AsString;
      if (DM.ETChem.FieldByName('KStrukt').AsString = '?') or
        (DM.ETChem.FieldByName('KStrukt').AsString = '') then
        frmMain.GridZusatz.Cells[1,1] := '?'
      else
      begin
        temp := Kristrukt(DM.ETChem.FieldByName('KStrukt').AsString);
        if (StrToInt(temp) < 10) and DM.ETName.Locate('Nr',149,[]) then
        begin
          i := StrToInt(temp[1])+1;
          temp := DM.ETName.FieldByName('F' + IntToStr(i)).AsString;
          frmMain.GridZusatz.Cells[1,1] := Copy(temp,1,Pos('(',temp)-1);
        end else frmMain.GridZusatz.Cells[1,1] := '';
      end;
      if DM.ETName.Locate('Nr',120,[]) then
      begin
        i := Trunc(DM.ETChem.FieldByName('ElemGruppe').AsFloat);
        if i < 17 then
        begin
          temp := DM.ETName.FieldByName('F' + IntToStr(i)).AsString;
          frmMain.GridZusatz.Cells[0,1] := GetKlammer(Copy(temp,1,Pos(')',temp)));
          Delete(temp,1,Pos(')',temp));
          temp := Copy(temp,1,Pos('(',temp)-1);
          frmMain.GridZusatz.Cells[0,1] := frmMain.GridZusatz.Cells[0,1] + ' = '
            + temp; // 32
        end else if i = 17 then frmMain.GridZusatz.Cells[0,1] := 'Lanthanoide'
        else frmMain.GridZusatz.Cells[0,1] := 'Actinoide';
      end;
    end;
  end;
  i1 := 0; i2 := 0; i3 := 0; i4 := 0; i5 := 0; i6 := 0; i7 := 0;
  for i := 33 to 51 do   // Elektronen
  begin
    if DM.ETChem.Fields[i].AsInteger <> 0 then
    begin
      frmMain.GridElektron.Cells[i-24,1] := IntToStr(DM.ETChem.Fields[i].AsInteger);
      if i = 33 then i1 := DM.ETChem.Fields[i].AsInteger;
      if (i > 33) and (i < 36) then i2 := i2 + DM.ETChem.Fields[i].AsInteger;
      if (i > 35) and (i < 39) then i3 := i3 + DM.ETChem.Fields[i].AsInteger;
      if (i > 38) and (i < 43) then i4 := i4 + DM.ETChem.Fields[i].AsInteger;
      if (i > 42) and (i < 47) then i5 := i5 + DM.ETChem.Fields[i].AsInteger;
      if (i > 46) and (i < 50) then i6 := i6 + DM.ETChem.Fields[i].AsInteger;
      if i > 49 then i7 := i7 + DM.ETChem.Fields[i].AsInteger;
    end else frmMain.GridElektron.Cells[i-24,1] := '';
  end;
  if i1 > 0 then frmMain.GridElektron.Cells[1,1] := IntToStr(i1)
  else frmMain.GridElektron.Cells[1,1] := '';
  if i2 > 0 then frmMain.GridElektron.Cells[2,1] := IntToStr(i2)
  else frmMain.GridElektron.Cells[2,1] := '';
  if i3 > 0 then frmMain.GridElektron.Cells[3,1] := IntToStr(i3)
  else frmMain.GridElektron.Cells[3,1] := '';
  if i4 > 0 then frmMain.GridElektron.Cells[4,1] := IntToStr(i4)
  else frmMain.GridElektron.Cells[4,1] := '';
  if i5 > 0 then frmMain.GridElektron.Cells[5,1] := IntToStr(i5)
  else frmMain.GridElektron.Cells[5,1] := '';
  if i6 > 0 then frmMain.GridElektron.Cells[6,1] := IntToStr(i6)
  else frmMain.GridElektron.Cells[6,1] := '';
  if i7 > 0 then frmMain.GridElektron.Cells[7,1] := IntToStr(i7)
  else frmMain.GridElektron.Cells[7,1] := '';
end;

procedure PSEKonf;
var i: Integer;
begin
  with frmMain do
  begin
    GridPSE.ColWidths[0] := 41;
    GridPSE.RowHeights[8] := 18;
    GridPSE.ColWidths[19] := 5;
    with GridPSEDaten do
    begin
      RowHeights[0] := 24;
      CellFont[0,0].Size := 10;
      CellFont[1,0].Size := 10;
      for i := 1 to RowCount - 1 do
      begin
        ColorCell[1,i] := clInfoBk;
        CellFont[1,i].Charset := ANSI_CHARSET;
        CellFont[1,i].Name := 'MS Sans Serif'; //'Arial';
        //CellFont[1,i].Size := 10;
      end;
      CellFont[0,0].Style := [fsBold];
      CellFont[1,0].Style := [fsBold];
      Cells[0,0] := 'Beschreibung';
      Cells[1,0] := 'Wert';
      Cells[0,1] := 'Elementname';
      Cells[0,2] := 'Symbol';
      Cells[0,3] := 'Ordnungszahl Z';
      Cells[0,4] := 'Anzahl natürlicher Isotope';
      Cells[0,5] := 'Anzahl stabiler Isotope';
      Cells[0,6] := 'Anz. bekannter instabiler Isotope';
      Cells[0,7] := 'Massenanteil in der Erdkruste';
      Cells[0,8] := 'Natürliche Häufigkeit in %';
      Cells[0,9] := 'Durchschn. Masse in u';
      Cells[0,10] := 'Atomvolumen';
      Cells[0,11] := 'Dichte des Elements in g/cm³ bzw. g/L';
      Cells[0,12] := 'Elektronegativität';
      Cells[0,13] := '1. Ionisierungsenergie in eV';
      Cells[0,14] := 'Spezif. elektrische Leitfähigkeit';
      Cells[0,15] := 'Gitterenergie in eV/Gitterteilchen';
      Cells[0,16] := 'Atomradius in pm';
      Cells[0,17] := 'Ionenradius in pm';
      Cells[0,18] := 'Kovalenzradius für Einfachbindung pm';
      Cells[0,19] := 'van-der-Waals-Radius in pm';
      Cells[0,20] := 'Schmelzpunkt in °C';
      Cells[0,21] := 'Siedepunkt in °C';
      Cells[0,22] := 'Siede-Schmelztemperatur-Unterschied °C';
      Cells[0,23] := 'Verdampfungswärme in kJ/mol';
      Cells[0,24] := 'Schmelzwärme in kJ/mol';
      Cells[0,25] := 'Wärmeleitfähigkeit in W/cm/K';
      Cells[0,26] := 'spezifische Wärme in J/gK';
      Cells[0,27] := 'linearer Ausdehnungskoeffizient';
      Cells[0,28] := 'Elastizitätsmodul';
      Cells[0,29] := 'mögl. stöchiometrische Wertigkeiten';
      Cells[0,30] := 'Oxidationszahlen';
      Cells[0,31] := 'Reduktionspotential E° in V';
      Cells[0,32] := 'Entdecker';
      Cells[0,33] := 'Entdeckungsjahr/Land';
      Cells[0,34] := 'Äußerste besetzte Schale';
      Cells[0,35] := 'Elektronenkonfiguration   Kurzform';
      AdjustColWidth(0);
      ColWidths[1] := PanelPSEGridDaten.ClientWidth - ColWidths[0] - 6;
    end;
    GridZusatz.ColWidths[0] := 270;
    GridZusatz.ColWidths[1] := 160;
    GridZusatz.ColWidths[2] := 230;
    GridZusatz.Cells[0,0] := 'Elementgruppe';
    GridZusatz.Cells[1,0] := 'Kristallstruktur';
    GridZusatz.Cells[2,0] := 'Biologische Bedeutung';
    GridElektron.Cells[0,0] := 'E-Schale';
    GridElektron.Cells[0,1] := 'Langform';
    GridElektron.AdjustColWidth(0);
    {for i := 1 to 7 do
      GridElektron.HintCell[i,0] := 'Anzahl Elektronen in der ' + IntToStr(i) + '. Schale';}
    //GridElektron.HintCell[2,0] := 'Elektronen in der vorletzten besetzten Schale';
    //GridElektron.HintCell[3,0] := 'Elektronen in der 3.-letzten besetzten Schale';
    for i := 1 to GridElektron.ColCount - 1 do
    begin
      if i > 8 then GridElektron.ColWidths[i] := 22
      else GridElektron.ColWidths[i] := 24;
      //else if (i > 4) and (i < 8) then GridElektron.ColWidths[i] := 24;
      GridElektron.CellFont[i,1].Style := [fsBold];
      GridElektron.CellFont[i,1].Color := clNavy;
    end;
    GridElektron.ColWidths[8] := 1;
    GridElektron.ColorCell[8,1] := clBlack;
    for i := 0 to 17 do
    begin
      lbl[i] := TLabel.Create(frmMain);
      lbl[i].Parent := PanelFarbe;
      lbl[i].AutoSize := False;
      lbl[i].Layout := tlCenter;
      lbl[i].Alignment := taCenter;
      lbl[i].Height := 13;
      lbl[i].Font.Name := 'Times New Roman';
      lbl[i].Font.Style := [fsBold];
    end;
  end;
end;

function  PSENukFarbe(Z: Integer): TColor;
var
  i,r,g,b: Integer;
  dmin,dmax: Double;
  temp: String;
  Wahr: Boolean;
begin
  with frmMain do
  begin
    r := GetRValue(ZuF);
    g := GetGValue(ZuF);
    b := GetBValue(ZuF);
    i := 0;
    case RG.ItemIndex of
      13,19..25: Wahr := True;
    else Wahr := False;
    end;
    if DM.ETChem.Locate('Nr',Z,[]) then
    begin
      case RG.ItemIndex of
        3..9,11..25,27,28:
          if ((DM.ETChem.FieldByName(Spalte).DataType = ftFloat) and
            (DM.ETChem.FieldByName(Spalte).AsFloat >= Min) and
            (DM.ETChem.FieldByName(Spalte).AsFloat <> 0)) or
            ((DM.ETChem.FieldByName(Spalte).DataType = ftInteger) and
            (DM.ETChem.FieldByName(Spalte).AsInteger >= Min) and
            (DM.ETChem.FieldByName(Spalte).AsInteger <> 0)) then
          begin
            if DM.ETChem.FieldByName(Spalte).DataType = ftFloat then
            begin
              dmax := Max;
              if (RG.ItemIndex = 19) or (RG.ItemIndex = 20) then
              begin
                dmin := DM.ETChem.FieldByName(Spalte).AsFloat;
                dmin := CelsiusToKelvin(dmin);
                dmax := CelsiusToKelvin(Max);
              end
              else dmin := DM.ETChem.FieldByName(Spalte).AsFloat;
              if not Wahr then
                i := 255 - Trunc(((dmin / dmax) * 100) * 2.55)
              else i := Trunc(((dmin / dmax) * 100) * 2.55);
            end;
            if (DM.ETChem.FieldByName(Spalte).DataType = ftInteger) then
              i := 255 - Trunc(((DM.ETChem.FieldByName(Spalte).AsInteger / Max) * 100) * 2.55);
            case IntRGB of
              1: Result := RGB(i,g,b);
              2: Result := RGB(r,i,b);
              3: Result := RGB(r,g,i);
             12: Result := RGB(i,i,b);
             13: Result := RGB(i,g,i);
             23: Result := RGB(r,i,i);
            else Result := clBtnFace;
            end;
          end else Result := clBtnFace;
        0..2,10,26,31: if DM.ETChem.FieldByName(Spalte).IsNull then
            Result := clBtnFace
          else Result := PSEF[DM.ETChem.FieldByName(Spalte).AsInteger - 1];
        29: if not DM.ETChem.FieldByName(Spalte).IsNull and
              (DM.ETChem.FieldByName(Spalte).AsString <> '?') then
            begin
              temp := Kristrukt(DM.ETChem.FieldByName(Spalte).AsString);
              i := StrToInt(temp[1]);
              Result := PSEF[i];
            end else Result := clBtnFace;
        30: if Bio(DM.ETChem.FieldByName(Spalte).AsString) = '-1' then
              Result := clBtnFace
            else
            begin
              temp := Bio(DM.ETChem.FieldByName(Spalte).AsString);
              Result := PSEF[StrToInt(temp[1])];
            end;
      else Result := clBtnFace;
      end;
    end else Result := clBtnFace;
  end;
end;

procedure PSEGoElement(Key: Word);
var iza: Integer;
begin
  with frmMain do
  begin
    case Key of
      VK_LEFT:
        if (PXalt = 1) and (PYalt = 1) then begin PXneu := 18; PYneu := 7; end
        else if (PXalt = 18) and (PYalt = 1) then begin PXneu := 1; PYneu := 1; end
        else if (PXalt = 13) and (PYalt = 2) then begin PXneu := 2; PYneu := 2; end
        else if (PXalt = 13) and (PYalt = 3) then begin PXneu := 2; PYneu := 3; end
        else if (PXalt = 1) and (PYalt <= 7) then begin PXneu := 18; PYneu := PYalt-1; end
        else if (PXalt = 3) and (PYalt = 9) then begin PXneu := 2; PYneu := 6; end
        else if (PXalt = 3) and (PYalt = 10) then begin PXneu := 2; PYneu := 7; end
        else if (PXalt = 4) and (PYalt = 6) then begin PXneu := 17; PYneu := 9; end
        else if (PXalt = 4) and (PYalt = 7) then begin PXneu := 17; PYneu := 10; end
        else begin PXneu := PXalt-1; PYneu := PYalt end;
      VK_RIGHT:
        if (PXalt = 1) and (PYalt = 1) then begin PXneu := 18; PYneu := 1; end
        else if (PXalt = 2) and (PYalt = 2) then begin PXneu := 13; PYneu := 2; end
        else if (PXalt = 2) and (PYalt = 3) then begin PXneu := 13; PYneu := 3; end
        else if (PXalt = 18) and (PYalt = 7) then begin PXneu := 1; PYneu := 1; end
        else if (PXalt = 18) and (PYalt < 7) then begin PXneu := 1; PYneu := PYalt+1; end
        else if (PXalt = 2) and (PYalt = 6) then begin PXneu := 3; PYneu := 9; end
        else if (PXalt = 2) and (PYalt = 7) then begin PXneu := 3; PYneu := 10; end
        else if (PXalt = 17) and (PYalt = 9) then begin PXneu := 4; PYneu := 6; end
        else if (PXalt = 17) and (PYalt = 10) then begin PXneu := 4; PYneu := 7; end
        else begin PXneu := PXalt+1; PYneu := PYalt end;
      VK_UP:
        if (((PXalt = 1) or (PXalt = 18)) and (PYalt = 2)) or
          (((PXalt < 3) or (PXalt > 12)) and (PYalt > 2) and (PYalt < 8)) or
          ((PYalt > 4) and ((PYalt < 8) or (PYalt = 10))) then
          begin PXneu := PXalt; PYneu := PYalt-1; end;
      VK_DOWN:
        if (PXalt = 3) and (PYalt = 5) then
          begin PXneu := PXalt; PYneu := PYalt; end
        else if ((PYalt < 7) or (PYalt = 9)) then
          begin PXneu := PXalt; PYneu := PYalt+1; end;
    end;
    if (PXneu <> PXalt) or (PYneu <> PYalt) then
    begin
      GridPSE.Repaint;
      PXalt := PXneu; PYalt := PYneu;
      iza := DM.IZAvonZ(IntAusStr(GridPSE.HintCell[PXneu,PYneu]));
      PSEDaten(iza);
      RelMass;
    end;
  end;
end;

procedure RelMass;
var i: Integer;
begin
  i := DM.ETChem.FieldByName('Nr').AsInteger;
  if ((Frac(DM.ETChem.FieldByName('AnzNatIso').AsFloat) > 0) or
    DM.ETChem.FieldByName('AnzNatIso').IsNull) and ((i < 90) or (i > 92)) then
    frmMain.GridPSEDaten.Cells[0,9] := 'Relative Masse in u'
  else frmMain.GridPSEDaten.Cells[0,9] := 'Durchschn. Masse in u';
end;

function SetFarbe(idx,anz: Integer): Boolean;
var
  i: Integer;
  Wahr: Boolean;
begin
  with frmMain do
  begin
    case idx of
      0: Spalte := 'ElemGruppe';
      1: Spalte := 'Phase';
      2: Spalte := 'Agg';
      3: Spalte := 'AnzNatIso';
      4: Spalte := 'AnzStabIso';
      5: Spalte := 'AnzInstabIso';
      6: Spalte := 'MassErd';
      7: Spalte := 'DMasse';
      8: Spalte := 'AVolum';
      9: Spalte := 'Dichte';
     10: Spalte := 'SBE';
     11: Spalte := 'ElekN';
     12: Spalte := 'IEnergie';
     13: Spalte := 'SEL';
     14: Spalte := 'GEnergie';
     15: Spalte := 'ARadius';
     16: Spalte := 'IRadius';
     17: Spalte := 'KRadius';
     18: Spalte := 'WRadius';
     19: Spalte := 'SchmTemp';
     20: Spalte := 'SiedeTemp';
     21: Spalte := 'TempDiff';
     22: Spalte := 'VW';
     23: Spalte := 'SW';
     24: Spalte := 'WLF';
     25: Spalte := 'SpWarm';
     26: Spalte := 'Supra';
     27: Spalte := 'AKoeff';
     28: Spalte := 'ElModul';
     29: Spalte := 'KStrukt';
     30: Spalte := 'Bio';
     31: Spalte := 'Entdeckt';
    end;
    case RG.ItemIndex of
      3..9,11..25,27,28: DM.MinMax(Spalte);
    else Min := 0;
    end;
    case RG.ItemIndex of
      13,19..25: Wahr := True;
    else Wahr := False;
    end;
    if (Spalte <> '') and (RG.ItemIndex <> 0) then
    begin
      for i := 0 to 17 do
        if (i <> 0) and (i <> 3) then
          lbl[i].Visible := False
        else
        begin
          lbl[i].Visible := True;
          lbl[i].Width := JvgBevel.Width;
        end;
      lbl[0].Top := JvgBevel.Top - lbl[0].Height;
      lbl[0].Left := JvgBevel.Left;
      lbl[0].Width := JvgBevel.Width;
      lbl[0].Color := $00FFFFCC;
      lbl[0].Font.Color := clBlack;
      lbl[0].Font.Style := [];
      if (RG.ItemIndex = 19) or (RG.ItemIndex = 20) then
        lbl[0].Caption := ZahlFormat(Min,0,3) + ' - ' + FloatToStr(Max)
      else if Frac(Min) = 0 then
        lbl[0].Caption := FloatToStr(Min) + ' - ' + FloatToStr(Max)
      else lbl[0].Caption := ZahlFormat(Min,0,1) + ' - ' + FloatToStr(Max);
      lbl[3].Top := JvgBevel.Top + JvgBevel.Height;
      lbl[3].Left := JvgBevel.Left;
      lbl[3].Width := JvgBevel.Width;
      lbl[3].Font.Color := clBlack;
      lbl[3].Font.Style := [];
      lbl[3].Color := clBtnFace;
      lbl[3].Caption := 'unbekannt';
      lbl[3].Visible := True;
      lblbez.Top := lbl[3].Top + lbl[3].Height;
      lblbez.Left := lbl[3].Left;
      lblbez.Width := lbl[3].Width;
      if Wahr then
      begin
        JvgBevel.Gradient.FromColor := VonF;
        JvgBevel.Gradient.ToColor := ZuF;
      end
      else
      begin
        JvgBevel.Gradient.FromColor := ZuF;
        JvgBevel.Gradient.ToColor := VonF;
      end;
      JvgBevel.Visible := True;
    end
    else
    begin
      for i := 1 to anz do lbl[i-1].Color := PSEF[i-1];
      JvgBevel.Visible := False;
    end;
  end;
  if anz > 2 then Result := True else Result := False;
end;

procedure SetLabels;
var
  i,i1,lh,l,t: Integer;
  temp: String;
  List: TStrings;
begin
  List := TStringList.Create;
  with frmMain do
  begin
    for i := 0 to 15 do PSEF[i] := clBtnFace;
    lblbez.Caption := '';
    lblTitel.Caption := RG.Items[RG.ItemIndex];
    i := RG.ItemIndex + 120;
    if DM.ETName.Locate('Nr',i,[]) then
      for i := 0 to DM.ETName.FieldCount - 2 do
        if DM.ETName.Fields[i].AsString <> '' then
          List.Add(DM.ETName.Fields[i].AsString);
    if Pos('§',List.Strings[List.Count-1]) > 0 then
    begin
      temp := List.Strings[List.Count-1];
      Delete(temp,1,1);
      lblbez.Caption := temp;
      List.Delete(List.Count-1);
      lblbez.Visible := True;
    end;
    if List.Count < 3 then
    begin
      temp := Copy(List.Strings[0],1,Pos('(',List.Strings[0])-1);
      if (temp <> '') and (Length(temp) <= 2) then IntRGB := StrToInt(temp);
      VonF := StrToInt(GetKlammer(List.Strings[0]));
      ZuF := StrToInt(GetKlammer(List.Strings[1]));
    end;
    if RG.ItemIndex = 0 then
      for i := 0 to List.Count - 1 do
      begin
        temp := List.Strings[i];
        lbl[i].Caption := GetKlammer(temp);
        Delete(temp,1,Pos(')',temp));
        List.Strings[i] := temp;
      end;
    Min := 1000; Max := 0;
    if SetFarbe(RG.ItemIndex,List.Count) then
    begin
      lbl[List.Count].Hint := '';
      for i := 0 to 17 do
      begin
        lbl[i].Font.Name := 'Times New Roman';
        lbl[i].Hint := '';
        if i < List.Count then temp := List.Strings[i];
        if (i < 16) and (i < List.Count) then
        begin
          if RG.ItemIndex > 0 then lbl[i].Caption := Copy(temp,1,Pos('(',temp)-1);
          if RG.ItemIndex = 0 then lbl[i].Hint := Copy(temp,1,Pos('(',temp)-1);
          if GetKlammer(temp) <> '' then
            lbl[i].Color := StrToInt(GetKlammer(temp));
          if lbl[i].Color <> clBtnFace then
            lbl[i].Font.Color := KontrastFarbe(lbl[i].Color,1);
          PSEF[i] := StrToInt(GetKlammer(temp));
        end;
      end;
      if RG.ItemIndex = 0 then
      begin
        l := (PanelFarbe.ClientWidth - 160) div 2;
        t := 20;
        lh := lbl[0].Height;
        for i := 0 to List.Count-1 do
        begin
          lbl[i].Font.Name := 'Times New Roman';
          lbl[i].Font.Style := [fsBold];
          lbl[i].Width := 40;
          case i of
            0..3: begin lbl[i].Left := l; i1 := t + (i * lh); end;
            4..7: begin lbl[i].Left := l + 41; i1 := t + ((i-4) * lh); end;
            8..11: begin lbl[i].Left := l + 82; i1 := t + ((i-8) * lh); end;
            12..15: begin lbl[i].Left := l + 123; i1 := t + ((i-12) * lh); end;
          else i1 := 0;
          end;
          case i of
            0,4,8,12: lbl[i].Top := i1;
            1,5,9,13: lbl[i].Top := i1+1;
            2,6,10,14: lbl[i].Top := i1+2;
            3,7,11,15: lbl[i].Top := i1+3;
          end;
          lbl[i].Visible := True;
        end;
        lbl[16].Width := lbl[0].Width * 2 + 1;
        lbl[16].Left := lbl[0].Left;
        lbl[16].Top := lbl[3].Top + lbl[3].Height + 1;
        lbl[16].Color := PSEF[16];
        lbl[16].Caption := 'Lanthanoide';
        lbl[16].Visible := True;
        lbl[17].Width := lbl[16].Width;
        lbl[17].Left := lbl[0].Left + lbl[16].Width + 1;
        lbl[17].Top := lbl[16].Top;
        lbl[17].Color := PSEF[17];
        lbl[17].Caption := 'Actinoide';
        lbl[17].Visible := True;
        lblbez.Visible := False;
      end
      else if (RG.ItemIndex = 1) or (RG.ItemIndex = 31) then  // 6
      begin
        l := (PanelFarbe.ClientWidth - 300) div 2;
        t := 30;
        lh := lbl[0].Height;
        for i := 0 to List.Count-1 do
        begin
          lbl[i].Font.Style := [];
          lbl[i].Width := 150;
          case i of
            0..2: lbl[i].Left := l;
            3..5: lbl[i].Left := l + 151;
          end;
          case i of
            0,3: lbl[i].Top := t;
            1,4: lbl[i].Top := t+lh+1;
            2,5: lbl[i].Top := t+(2*lh)+2;
          end;
          lbl[i].Visible := True;
        end;
        if RG.ItemIndex = 1 then
        begin
          lbl[List.Count].Font.Style := [];
          lbl[List.Count].Width := lbl[0].Width * 2 + 1;
          lbl[List.Count].Left := lbl[0].Left;
          lbl[List.Count].Top := lbl[2].Top + lbl[0].Height + 1;
          lbl[List.Count].Color := clBtnFace;
          lbl[List.Count].Caption := 'unbekannt';
          lbl[List.Count].Visible := True;
        end;
      end
      else if (RG.ItemIndex = 2) or (RG.ItemIndex = 10) or (RG.ItemIndex = 26) or
        (RG.ItemIndex = 30) then // 3,4
      begin
        l := (PanelFarbe.ClientWidth - 150) div 2;
        case RG.ItemIndex of
          2: t := 20;
         10: t := 30;
         26: begin t := 30; l := (PanelFarbe.ClientWidth - 190) div 2; end;
         30: begin t := 15; l := (PanelFarbe.ClientWidth - 230) div 2; end;
        else t := 20;
        end;
        lh := lbl[0].Height;
        for i := 0 to List.Count-1 do
        begin
          lbl[i].Font.Style := [];
          case RG.ItemIndex of
            26: lbl[i].Width := 190;
            30: lbl[i].Width := 230;
          else lbl[i].Width := 150;
          end;
          lbl[i].Left := l;
          lbl[i].Top := t+(i*lh)+i;
          lbl[i].Visible := True;
        end;
        lbl[List.Count].Font.Style := [];
        lbl[List.Count].Width := lbl[0].Width;
        lbl[List.Count].Left := lbl[0].Left;
        lbl[List.Count].Top := lbl[List.Count-1].Top + lbl[0].Height + 1;
        lbl[List.Count].Color := clBtnFace;
        lbl[List.Count].Caption := 'unbekannt';
        lbl[List.Count].Visible := True;
      end
      else if RG.ItemIndex = 29 then // 10
      begin
        l := (PanelFarbe.ClientWidth - 260) div 2;
        t := 15;
        lh := lbl[0].Height;
        for i := 0 to List.Count-1 do
        begin
          lbl[i].Font.Style := [];
          lbl[i].Width := 130;
          case i of
            0..4: lbl[i].Left := l;
            5..9: lbl[i].Left := l + 131;
          end;
          case i of
            0,5: lbl[i].Top := t;
            1,6: lbl[i].Top := t+lh+1;
            2,7: lbl[i].Top := t+(2*lh)+2;
            3,8: lbl[i].Top := t+(3*lh)+3;
            4,9: lbl[i].Top := t+(4*lh)+4;
          end;
          lbl[i].Visible := True;
        end;
        lbl[List.Count].Font.Style := [];
        lbl[List.Count].Width := lbl[0].Width * 2 + 1;
        lbl[List.Count].Left := lbl[0].Left;
        lbl[List.Count].Top := lbl[4].Top + lbl[0].Height + 1;
        lbl[List.Count].Color := clBtnFace;
        lbl[List.Count].Caption := 'unbekannt';
        lbl[List.Count].Visible := True;
      end;
      JvgBevel.Visible := False;
    end;
  end;
  List.Free;
end;

end.
