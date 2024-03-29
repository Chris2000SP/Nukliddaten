unit UnitDM;

interface

uses
  SysUtils, Classes, DB, EasyTable, DateUtils, ImgList, Controls, Graphics,
  Types, Dialogs, Math, Aligrid, Grids, icongrid;

type
  TDM = class(TDataModule)
    ILFlag: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    function  NukName(Symb: String): String;
    function  Zerfallart(RTyp: Double): String;
    function  MinMax(Feld: String): Boolean;
    function  Rad(Z: Integer): Boolean;
    function  LandName(Land: Double): String;
    function  FindRTypS(iza,MaxR: Integer): String;
    function  RTypFarbe(iza,C: Integer): Integer;
    procedure RTypPlus(iza,F1,F2: Integer;R: TRect;C: TCanvas);
    function  GetDaten(z,a,Feld: String;Zeit: Boolean;geteilt: Integer): String;
    function  RadFarbe(RTyp: Integer): TColor;
    function  isDecFarbe(C: TColor): Boolean;
    function  RadFarbNr(C: TColor): Integer;
    function  RadFontFarbe(RTyp: Double): TColor;
    function  AnzIso(iza: Integer;stabil: Boolean): Integer;
    function  ErsteLadung: Boolean;
    function  MinMaxA(z: Integer;xMax: Boolean): Integer;
    function  SetzeFilter(ET: TEasyTable): Boolean;
    procedure ShowFilter(F1,F2: String);
    procedure SuchAlpha(ET: TEasyTable);
    procedure SuchAuger;
    procedure SuchNuk;
    procedure SuchXRay;
    function  SuchFilter(MitF: Boolean): String;
    function  XFilter(Aug: Boolean): String;
    function  GetHWZ(idx: Integer): Double;
    procedure RadPfeilHint(iZA,XCol,XRow: Integer);
    function  GetEl(tiza: Integer;trt: Double): Double;
  private
    { Private-Deklarationen }
    SiZA1,SiZA2: Integer;
    AFilt: String;
    function  OpenTab(ETab: TEasyTable;Tabname,IdxName: String): Boolean;
    function  ErzTab(TabName: String): TEasyTable;
    function  ErzDS(DSName: String;Tab: TEasyTable): TDataSource;
    //function  AktIsoInChem: Boolean;
  public
    { Public-Deklarationen }
    DataPfad,DezS: String;
    Datengeladen: Boolean;                     //  ETAug DSAug
    ETNukl,ETDM,ETDMI,ETName,ETChem,ETRZA,ETSpec: TEasyTable;
    ETA,ETB,ETG,ETXI,ETXR,ETAug: TEasyTable;
    DSNukl,DSDM,DSDMI,DSName,DSChem,DSA,DSB,DSG,DSXI,DSXR,DSAug,DSSpec: TDataSource;
    function GetZ(iza: Integer): Integer;
    function GetN(iza: Integer): Integer;
    function GetA(iza: Integer): Integer;
    function GetSymb(iza: Integer): String;
    function GetSymXCode(XCode: Integer): String;
    function GetNukBez(iza: Integer;MitZ: Boolean): String;
    function GetiZA(txt: String): Integer;
    function MakeIZA(Z,A,L: Integer): Integer;
    function IZAvonZ(Z: Integer): Integer;
    function GetSpin(spin: Double;par: Integer): String;
    function RTyp1(rtyp: Double): Integer;
    function RTyp2(rtyp: Double): Integer;
  end;

var
  DM: TDM;

implementation

  uses UnitMain, UnitNukFunc, UnitPSE, UnitNuk, UnitSpec;

{$R *.dfm}

{function TDM.AktIsoInChem: Boolean;
var anz: Integer;
begin
  with ETChem do
  begin
    First;
    while not Eof do
    begin
      anz := AnzIso(FieldByName('iZA').AsInteger,True);
      if FieldByName('AnzStabIso').AsInteger <> anz then
      begin
        Edit;
        if anz > 0 then
          FieldByName('AnzStabIso').AsInteger := anz
        else FieldByName('AnzStabIso').Clear;
        Post;
      end;
      anz := AnzIso(FieldByName('iZA').AsInteger,False);
      if FieldByName('AnzInstabIso').AsInteger <> anz then
      begin
        Edit;
        if anz > 0 then
          FieldByName('AnzInstabIso').AsInteger := anz
        else FieldByName('AnzInstabIso').Clear;
        Post;
      end;
      Next;
    end;
  end;
  Result := True;
end;}

function TDM.AnzIso(iza: Integer;stabil: Boolean): Integer;
var
  anz: Integer;
  von,bis: String;
begin
  anz := 0;
  if iza > 10 then
  begin
    von := IntToStr(DM.GetZ(iza)) + '0000';
    bis := IntToStr(DM.GetZ(iza)) + '9990';
    ETNukl.Filter := '(iZA > ' + von + ') AND (iZA < ' + bis + ')';
    if ETNukl.FindFirst then
    repeat
      if ETNukl.FieldByName('iZA').AsInteger mod 10 = 0 then
      begin
        if stabil and ((ETNukl.FieldByName('Tsek').AsFloat = -99) or
          (ETNukl.FieldByName('Tsek').AsFloat > Power(10,17))) then
          Inc(anz)
        else if not stabil and (ETNukl.FieldByName('Tsek').AsFloat <> -99) then
          //(ETNukl.FieldByName('Exp').AsBoolean = True) then
          Inc(anz);
      end;
    until ETNukl.FindNext = False;
    ETNukl.Filter := '';
  end;
  Result := anz;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
var i: Integer;
  //fs : TFormatSettings;
begin
  DataPfad := ExtractFilePath(ParamStr(0)) + 'Data';
  //if not DirectoryExists(DataPfad) then CreateDir(DataPfad);
  frmMain.GetAppIcon;
  //GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, fs);
  DezS := SysUtils.DecimalSeparator;
  ETNukl := ErzTab('ETNukl');
  ETDM := ErzTab('ETDM');
  ETDMI := ErzTab('ETDMI');
  ETName := ErzTab('ETName');
  ETChem := ErzTab('ETChem');
  //ETRZA := ErzTab('ETRZA');
  ETA := ErzTab('ETA');
  ETB := ErzTab('ETB');
  ETG := ErzTab('ETG');
  ETXI := ErzTab('ETXI');
  ETXR := ErzTab('ETXR');
  ETAug := ErzTab('ETAug');
  ETSpec := ErzTab('ETSpec');
  DSNukl := ErzDS('DSNukl',ETNukl);
  DSDM := ErzDS('DSDM',ETDM);
  DSDMI := ErzDS('DSDMI',ETDMI);
  DSName := ErzDS('DSName',ETName);
  DSChem := ErzDS('DSChem',ETChem);
  DSA := ErzDS('DSA',ETA);
  DSB := ErzDS('DSB',ETB);
  DSG := ErzDS('DSG',ETG);
  DSXI := ErzDS('DSXI',ETXI);
  DSXR := ErzDS('DSXR',ETXR);
  DSAug := ErzDS('DSAug',ETAug);
  DSSpec := ErzDS('DSSpec',ETSpec);
  if OpenTab(ETNukl,'Nukl','ByiZA') and OpenTab(ETName,'NukNa','ByNr') and
    OpenTab(ETDM,'NukDM','ByR') and OpenTab(ETDMI,'DMI','ByiZA') and
    OpenTab(ETChem,'Chem','ByNr') and //OpenTab(ETRZA,'RZA','ByiZA') and
    OpenTab(ETA,'Alpha','ByEa') and OpenTab(ETB,'Beta','ByEb') and
    OpenTab(ETG,'Gamma','ByEg') and OpenTab(ETXI,'XInt','ByEx') and
    OpenTab(ETXR,'XRay','') and OpenTab(ETAug,'Auger','') and
    OpenTab(ETSpec,'Spec','') then
  begin
    if LeseNukKarte then
      if LeseNukExplorer(frmMain.TVNuk,1,True) then
        if ClearGridRad(frmMain.GridRad) and ClearGridRad(frmMain.GridSuchKarte) and
          RadReihe(922350) then
            {if AktIsoInChem then} for i := 1 to 118 do GridPSENuk(i);
    if ErsteLadung then Datengeladen := True;
    if Datengeladen then UpdateImage(1,'Wasserstoff',True);
  end else Datengeladen := False;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  if ETNukl.Active then ETNukl.Close;
  if ETDM.Active then ETDM.Close;
  if ETDMI.Active then ETDMI.Close;
  if ETName.Active then ETName.Close;
  if ETChem.Active then ETChem.Close;
  //if ETRZA.Active then ETRZA.Close;
  if ETA.Active then ETA.Close;
  if ETB.Active then ETB.Close;
  if ETG.Active then ETG.Close;
  if ETXI.Active then ETXI.Close;
  if ETXR.Active then ETXR.Close;
  if ETAug.Active then ETAug.Close;
  if ETSpec.Active then ETSpec.Close;
end;

function TDM.ErsteLadung: Boolean;
begin
  ETName.First;
  while not ETName.Eof do
  begin
    if ETName.FieldByName('Nr').AsInteger < 119 then
      frmMain.CBSym.Items.Add(ETName.FieldByName('F1').AsString);
    ETName.Next;
  end;
  //frmMain.CBSym.ItemIndex := 39;
  Result := True;
end;

function TDM.ErzDS(DSName: String; Tab: TEasyTable): TDataSource;
var newDS: TDataSource;
begin
	newDS := TDataSource.Create(DM);
  with newDS do
  begin
    Name := DSName;
		DataSet := Tab;
  end;
  Result := newDS;
end;

function TDM.ErzTab(TabName: String): TEasyTable;
var newTab: TEasyTable;
begin
	newTab := TEasyTable.Create(DM);
  with newTab do
  begin
    Name := TabName;
		//DatabaseName := ETNukl.DatabaseName;
    //OnProgress := TabProgress;
  end;
  Result := newTab;
end;

function TDM.FindRTypS(iza,MaxR: Integer): String;
var
  i,i1: Integer;
  RT: array[0..9] of Double;
begin
  for i := 0 to 9 do RT[i] := 0;
  i1 := 0;
  with ETDMI do
  begin
    Result := Zerfallart(MaxR) + #32;
    Filter := 'iZA = ' + IntToStr(iza);
    if FindFirst then
    begin
      repeat
        RT[FieldByName('nMode').AsInteger-1] := FieldByName('RTYP').AsFloat;
        Inc(i1);
      until FindNext = False;
    end;
    Filter := '';
    if i1 > 0 then
    begin
      for i := 0 to i1-1 do
      begin
        if (i = 0) then
          Result := Zerfallart(RT[i]) + #32
        else Result := Result + '(' + Zerfallart(RT[i]) + ')';
      end;
    end;
  end;
end;

function TDM.GetA(iza: Integer): Integer;
var temp: String;
begin
  if iza <= 1 then Result := iza
  else
  begin
    temp := IntToStr(iza);
    Result := StrToInt(Copy(temp,Length(temp)-3,3));
  end;
end;

function TDM.GetDaten(z,a,Feld: String;Zeit: Boolean;geteilt: Integer): String;
var iza: Integer;
begin
  iza := MakeIZA(StrToInt(z),StrToInt(a),0);
  if ETNukl.Locate('iZA',iza,[]) and (ETNukl.FieldByName(Feld).AsFloat <> 0) then
    if Zeit then
      Result := ZeitFormat(ETNukl.FieldByName(Feld).AsFloat)
    else Result := ZahlFormat(ETNukl.FieldByName(Feld).AsFloat,geteilt,7)
  else Result := '';
end;

function TDM.GetEl(tiza: Integer; trt: Double): Double;
begin
  Result := 0;
  with ETDMI do
  begin
    Filter := 'iZA = ' + IntToStr(tiza);
    if FindFirst then
    repeat
      if FieldByName('RTYP').AsFloat = trt then
      begin
        if trt = 3 then
          Result := FieldByName('DQ').AsFloat
        else if FieldByName('El').AsFloat <> 0 then
          Result := FieldByName('El').AsFloat;
      end;
    until FindNext = False;
    Filter := '';
  end;
end;

function TDM.GetHWZ(idx: Integer): Double;
var temp: String;
begin
  Result := 0;
  if (idx = 1) then
  begin
    if frmMain.CBTH1.Text = 'm' then
      temp := 'min' else temp := frmMain.CBTH1.Text;
    if frmMain.ETH1.Value > 0 then
      Result := InSec(frmMain.ETH1.Text + temp);
  end
  else
  begin
    if frmMain.CBTH2.Text = 'm' then
      temp := 'min' else temp := frmMain.CBTH2.Text;
    if frmMain.ETH2.Value > 0 then
      Result := InSec(frmMain.ETH2.Text + temp);
  end;
end;

function TDM.GetiZA(txt: String): Integer;
var
  z,a,l: Integer;
  temp: String;
begin
  l := 0;
  temp := txt;
  while Pos(#32,temp) > 0 do Delete(temp,1,Pos(#32,temp));
  z := StrToInt(Trim(Copy(txt,1,Pos(#32,txt))));
  if Pos('m',temp) > 0 then
  begin
    if temp[Length(temp)] = 'm' then l := 1
    else l := StrToInt(temp[Length(temp)]);
    a := StrToInt(Copy(temp,1,Pos('m',temp)-1));
    Result := MakeIZA(z,a,l);
  end
  else
  begin
    a := IntAusStr(temp);
    Result := MakeIZA(z,a,l);
  end;
end;

function TDM.GetN(iza: Integer): Integer;
begin
  if iza = 1 then Result := iza
  else Result := GetA(iza) - GetZ(iza);
end;

function TDM.GetNukBez(iza: Integer; MitZ: Boolean): String;
var temp: String;
begin
  if (iza > 10) and (iza mod 10 > 0) then
    if iza mod 10 > 1 then
      temp := 'm' + IntToStr(iza mod 10) else temp := 'm'
  else temp := '';
  if MitZ then
    Result := IntToStr(GetZ(iza))+#32+GetSymb(iza)+#32+IntToStr(GetA(iza)) + temp
  else Result := GetSymb(iza)+#32+IntToStr(GetA(iza)) + temp;
end;

function TDM.GetSpin(spin: Double; par: Integer): String;
var temp: String;
begin
  if FloatToStr(spin) = '-77,777' then
    temp := ''
  else if Frac(spin) <> 0 then
    temp := IntToStr(Trunc(spin / 0.5)) + '/2'
  else temp := IntToStr(Trunc(spin));
  if par = 1 then Result := temp + '+'
  else if par = -1 then Result := temp + '-'
  else Result := temp;
end;

function TDM.GetSymb(iza: Integer): String;
begin
  if (iza = 1) and ETName.Locate('Nr',119,[]) then
    Result := ETName.FieldByName('F1').AsString
  else if (iza > 1) and ETName.Locate('Nr',GetZ(iza),[]) then
    Result := ETName.FieldByName('F1').AsString
  else Result := '';
end;

function TDM.GetSymXCode(XCode: Integer): String;
var
  i: Integer;
  temp: String;
begin
  temp := IntToStr(XCode);
  i := StrToInt(Copy(temp,1,Length(temp)-2));
  if ETName.Locate('Nr',i,[]) then
    Result := ETName.FieldByName('F1').AsString
  else Result := '';
end;

function TDM.GetZ(iza: Integer): Integer;
var temp: String;
begin
  temp := IntToStr(iza);
  if iza <= 1 then Result := 0
  else Result := StrToInt(Copy(temp,1,Length(temp)-4));
end;

function TDM.isDecFarbe(C: TColor): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 1 to 10 do
    if frmMain.RadF[i] = C then
    begin
      Result := True;
      Break;
    end;
end;

function TDM.IZAvonZ(Z: Integer): Integer;
var
  i: Integer;
  temp: String;
begin
  Result := 0;
  with ETChem do
  begin
    DisableControls;
    First;
    while not Eof do
    begin
      temp := IntToStr(FieldByName('iZA').AsInteger);
      i := Length(temp);
      if Z = StrToInt(Copy(temp, 1, i-4)) then
      begin
        Result := FieldByName('iZA').AsInteger;
        Break;
      end;
      Next;
    end;
    EnableControls;
  end;
end;

function TDM.LandName(Land: Double): String;
var
  i,i1: Integer;
  temp,temp1: String;
begin
  i1 := 0;
  temp := FloatToStr(Land);
  if Pos(DezS,temp) > 0 then
  begin
    i := Trunc(Land);
    Delete(temp,1,Pos(DezS,temp));
    i1 := StrToInt(temp);
  end else i := StrToInt(temp);
  if (i < 13) and ETName.Locate('Nr', i, []) then
  begin
    if i1 > 0 then temp := GetKlammer(ETName.FieldByName('Land').AsString)
    else
    begin
      temp := ETName.FieldByName('Land').AsString;
      temp := Copy(temp,1,Pos(#32,temp));
    end;
    if (i1 > 0) and (ETName.Locate('Nr', i1, [])) then
    begin
      temp1 := ETName.FieldByName('Land').AsString;
      temp1 := '/' + GetKlammer(temp1);
    end else temp1 := '';
    Result := temp + temp1;
  end else Result := 'unentdeckt';
end;

function TDM.MakeIZA(Z, A, L: Integer): Integer;
var tempA: String;
begin
  tempA := IntToStr(A);
  case Length(tempA) of
    1: tempA := '00' + tempA;
    2: tempA := '0' + tempA;
  end;
  if Z = 0 then
    Result := A
  else Result := StrToInt(IntToStr(Z) + tempA + IntToStr(L));
end;

function TDM.MinMax(Feld: String): Boolean;
begin
  if Feld = '' then begin Result := False; Exit; end;
  DM.ETChem.First;
  with DM.ETChem do
    while not Eof do
    begin
      if FieldByName(Feld).DataType = ftFloat then
        if FieldByName(Feld).AsFloat <> 0 then
        begin
          if frmMain.Min > FieldByName(Feld).AsFloat then
            frmMain.Min := FieldByName(Feld).AsFloat;
          if FieldByName(Feld).AsFloat > frmMain.Max then
            frmMain.Max := FieldByName(Feld).AsFloat;
        end;
      if FieldByName(Feld).DataType = ftInteger then
        if FieldByName(Feld).AsInteger > 0 then
        begin
          if (frmMain.Min = 0) or (FieldByName(Feld).AsInteger < frmMain.Min) then
            frmMain.Min := FieldByName(Feld).AsInteger;
          if (frmMain.Max = 0) or (FieldByName(Feld).AsInteger > frmMain.Max) then
            frmMain.Max := FieldByName(Feld).AsInteger;
        end;
      Next;
    end;
  Result := True;
end;

function TDM.MinMaxA(z: Integer; xMax: Boolean): Integer;
var
  a: Integer;
  von,bis: String;
begin
  a := 0;
  von := IntToStr(z) + '0000';
  bis := IntToStr(z) + '9990';
  ETNukl.Filter := '(iZA > ' + von + ') AND (iZA < ' + bis + ')';
  if ETNukl.FindFirst then
  repeat
    if not xMax and ((a = 0) or (a > ETNukl.FieldByName('A').AsInteger)) then
      a := ETNukl.FieldByName('A').AsInteger;
    if xMax and (ETNukl.FieldByName('A').AsInteger > a) then
      a := ETNukl.FieldByName('A').AsInteger;
  until ETNukl.FindNext = False;
  ETNukl.Filter := '';
  Result := a;
end;

function TDM.NukName(Symb: String): String;
begin
  ETName.DisableControls;
  if ETName.Locate('F1',Symb,[]) then
  begin
    {if frmNuk.MenuOptionLangEng.Checked then
      Result := ETName.FieldByName('F3').AsString
    else} Result := ETName.FieldByName('F2').AsString;
  end else Result := '';
  ETName.EnableControls;
end;

function TDM.OpenTab(ETab: TEasyTable;Tabname,IdxName: String): Boolean;
begin
  with ETab do
  begin
    Close;
    DatabaseName := DataPfad;
    TableName := Tabname;
    Password := '270924';
    Open;
    IndexName := IdxName;
  end;
  Result := True;
end;

function TDM.Rad(Z: Integer): Boolean;
var temp: String;
begin
  Result := False;
  if ETChem.Locate('Nr',Z,[]) then
  begin
    if frmMain.RG.ItemIndex = 3 then
    begin
      temp := FloatToStr(ETChem.FieldByName('AnzNatIso').AsFloat);
      if Pos(DezS,temp) > 0 then Result := True;
    end
    else if (frmMain.RG.ItemIndex = 2) and
      (ETChem.FieldByName('Agg').AsInteger = 4) then Result := True;
  end;
end;

function TDM.RadFarbe(RTyp: Integer): TColor;
var temp: String;
begin
  if (RTyp > 0) and (ETName.Locate('Nr',152,[])) then
  begin
    temp := ETName.FieldByName('F' + IntToStr(RTyp)).AsString;
    Result := StrToInt(GetKlammer(temp));
  end else Result := 0;
end;

function TDM.RadFarbNr(C: TColor): Integer;
var i: Integer;
begin
  Result := 0;
  for i := 1 to 10 do
    if frmMain.RadF[i] = C then
    begin
      Result := i;
      Break;
    end;
end;

function TDM.RadFontFarbe(RTyp: Double): TColor;
var i: Integer;
begin
  i := Trunc(RTyp);
  case i of
    1: Result := 11464687;
    3,6,10: Result := clInfoBk;
  else Result := clBlack;
  end;
end;

procedure TDM.RadPfeilHint(iZA,XCol,XRow: Integer);
var
  cn,rn: Integer;
  d: Double;
  temp,temp1: String;
  Wahr: Boolean;
begin
  with frmMain.GridReihe do
  begin
    ETDMI.Filter := 'iZA = ' + IntToStr(iZA);
    if ETDMI.FindFirst then
    repeat
      d := ETDMI.FieldByName('RTYP').AsFloat;
      if (d < 9) and (RTyp1(ETDMI.FieldByName('RTYP').AsFloat) <> 6) and
        (RTyp2(ETDMI.FieldByName('RTYP').AsFloat) <> 6) then
        Wahr := True else Wahr := False;
      if Wahr and ETDM.Locate('RTYP',d,[]) then
      begin
        cn := ETDM.FieldByName('Col').AsInteger;
        rn := ETDM.FieldByName('Row').AsInteger;
        temp := ''; temp1 := '';
        if ((XCol+cn) > 0) and ((XRow+rn) > 0) and
          (ColorCell[XCol+cn,XRow+rn] <> Color) then
          if ((cn > 0) or (rn > 0)) then
          begin
            temp := HintCell[XCol+cn,XRow+rn];
            if (d = 2) or (d = 8) or (FloatToStr(d) = '2'+DezS+'2') then
              temp1 := '(' + IntToStr(XCol) + DezS + IntToStr(XRow) + '[' + ')'
            else if (cn = -3) and (rn = 1) then
              temp1 := '(' + IntToStr(XCol) + DezS + IntToStr(XRow) + ']' + ')'
            else temp1 := '(' + IntToStr(XCol) + DezS + IntToStr(XRow) + ')';
            if (cn = -3) and (rn = 1) and (Pos(']',temp1) > 0) then
            begin
              if HintCell[XCol+cn+1,XRow+rn] <> '' then
                HintCell[XCol+cn+1,XRow+rn] := HintCell[XCol+cn+1,XRow+rn] + temp1
              else HintCell[XCol+cn+1,XRow+rn] := temp1;
              if Cells[XCol+cn+1,XRow+rn] = '' then
                Cells[XCol+cn+1,XRow+rn] := '2 He 8[]';
            end
            else if (HintCell[XCol+cn,XRow+rn] <> '') then
              HintCell[XCol+cn,XRow+rn] := temp + temp1
            else HintCell[XCol+cn,XRow+rn] := temp1;
          end
          else
          begin
            temp := HintCell[XCol,XRow];
            temp1 := '(' + IntToStr(XCol+cn) + DezS + IntToStr(XRow+rn) + ')';
            if HintCell[XCol,XRow] <> '' then
              HintCell[XCol,XRow] := temp + temp1
            else HintCell[XCol,XRow] := temp1;
          end;
      end;
    until ETDMI.FindNext = False;
    ETDMI.Filter := '';
  end;
end;

function TDM.RTyp1(rtyp: Double): Integer;
begin
  if Frac(rtyp) > 0 then
    Result := Trunc(rtyp - Frac(rtyp))
  else Result := Trunc(rtyp);
end;

function TDM.RTyp2(rtyp: Double): Integer;
var temp: String;
begin
  if Frac(rtyp) > 0 then
  begin
    temp := FloatToStr(rtyp);
    Delete(temp,1,Pos(DezS,temp));
    Result := StrToInt(temp);
  end else Result := Trunc(rtyp);
end;

function TDM.RTypFarbe(iza,C: Integer): Integer;
var
  MaxR: Integer;
  br,min,max: Double;
begin
  Result := 0; max := 50;//min := 5;
  if ETNukl.Locate('iZA',iza,[]) then
    MaxR := ETNukl.FieldByName('Max_RTyp').AsInteger else MaxR := C;
  with ETDMI do
  begin
    Filter := 'iZA = ' + IntToStr(iza);
    if FindFirst then
    begin
      repeat
        min := 4.9;
        br := FieldByName('BR').AsFloat;
        if (br > 5) and (br <= 50) and (min < br) then min := br;
        if (br > 50) and (max < br) then max := br;
        if (min > 5) and //(max > 50) and
          (RTyp1(FieldByName('RTYP').AsFloat) <> C) then//MaxR) then
        begin
          Result := RTyp1(FieldByName('RTYP').AsFloat);
          Break;
        end;
      until FindNext = False;
    end else Result := MaxR;
    Filter := '';
  end;
end;

procedure TDM.RTypPlus(iza,F1,F2: Integer;R: TRect;C: TCanvas);
var
  i,i1,anz: Integer;
  Wahr: Boolean;
  Rt: array[0..3] of Integer;
begin
  anz := 0;
  for i := 0 to 3 do Rt[i] := 0;
  with ETDMI do
  begin
    Filter := 'iZA = ' + IntToStr(iza);
    if FindFirst then
    begin
      repeat
        if (anz < 4) then
        begin
          Wahr := False;
          i1 := RTyp1(FieldByName('RTYP').AsFloat);
          if (i1 = F1) and (i1 = F2) then Wahr := True;
          if not Wahr then
            for i := 0 to anz-1 do if i1 = Rt[i] then Wahr := True;
          if not Wahr then
          begin
            Rt[anz] := i1;
            Inc(anz);
          end;
        end;
      until FindNext = False;
    end;
    Filter := '';
    i1 := 0;
    if anz > 0 then
      for i := 0 to anz-1 do
        if (Rt[i] <> 0) and (Rt[i] <> F1) and (Rt[i] <> F2) then
        begin
          Inc(i1);
          NukEck(C,R,i1,frmMain.RadF[Rt[i]]);
        end;
  end;
end;

function TDM.SetzeFilter(ET: TEasyTable): Boolean;
var
  en,ek: Double;
  temp,temp1,temp2,Ea: String;
begin
  en := frmMain.EEnergy.Value;
  ek := frmMain.EkeV.Value;
  case frmMain.RGSuch.ItemIndex of
    1: Ea := 'Ea';
    3: Ea := 'Eg';
    4: Ea := 'Ex';
  else Ea := 'Eb';
  end;
  temp1 := '';
  if (en > 0) and (ek <= 0) and (temp1 = '') then
    temp1 := Ea + ' = ' + FloatToStr(en)
  else if (en > 0) and (ek <= 0) and (temp1 <> '') then
    temp1 := temp1 + ' AND (' + Ea + ' = ' + FloatToStr(en) + ')'
  else if (en > 0) and (ek > 0) and (temp1 = '') then
    temp1 := '(' + Ea + ' >= ' + FloatToStr(en - ek) + ') AND (' + Ea + ' <= ' +
      FloatToStr(en + ek) + ')'
  else if (en > 0) and (ek > 0) and (temp1 <> '') then
    temp1 := temp1 + ' AND (' + Ea + ' >= ' + FloatToStr(en - ek) +
      ') AND (' + Ea + ' <= ' + FloatToStr(en + ek) + ')';
  temp := SuchFilter(True);
  ShowFilter(temp,temp1);
  temp2 := '';
  if (SiZA1 > 0) and (SiZA2 = 0) then
    temp2 := '(iZA = ' + IntToStr(SiZA1) + ')'
  else if (SiZA1 > 0) and (SiZA2 > SiZA1) then
    temp2 := '(iZA >= ' + IntToStr(SiZA1) + ')' +
      ' AND (iZA <= ' + IntToStr(SiZA2) + ')'
  else if (SiZA1 > 0) and (SiZA2 > 0) and (SiZA2 < SiZA1) then
  begin
    frmMain.lblFilter.Caption := 'A1-N1 muss gr��er oder gleich A2-N2 sein';
    if ClearGridForDaten(frmMain.GridSuch,frmMain.RGSuch.ItemIndex,False) and
      ClearGridRad(frmMain.GridSuchKarte) then
    begin
      Result := False;
      Exit;
    end;
  end;
  if (AFilt <> '') and (temp1 = '') then
    ET.Filter := AFilt
  else if (temp2 <> '') and (temp1 = '') then
    ET.Filter := temp2
  else if (AFilt <> '') and (temp1 <> '') and (Pos('(',temp1) = 0) then
    ET.Filter := AFilt + ' AND (' + temp1 + ')'
  else if (AFilt <> '') and (temp1 <> '') then
    ET.Filter := AFilt + ' AND ' + temp1
  else if (temp2 <> '') and (temp1 <> '') and (Pos('(',temp1) = 0) then
    ET.Filter := temp2 + ' AND (' + temp1 + ')'
  else if (temp2 <> '') and (temp1 <> '') then
    ET.Filter := temp2 + ' AND ' + temp1
  else if temp1 <> '' then ET.Filter := temp1;
  Result := (ET.Filter <> '');
end;

procedure TDM.ShowFilter(F1, F2: String);
var temp: String;
begin
  if (F1 <> '') and (F2 <> '') and (Pos('(',F1) = 0) then
    temp := '(' + F1 + ')'
  else if (F1 <> '') then temp := F1
  else temp := '';
  if (F2 <> '') and (Pos('(',F2) = 0) and (temp <> '') then
    temp := temp + ' und ' + '(' + F2 + ')'
  else if (F2 <> '') and (temp <> '') then
    temp := temp + ' und ' + F2
  else if (F2 <> '') and (temp = '') then temp := F2;
  if temp <> '' then
  begin
    temp := StringReplace(temp,'Ea','E',[rfReplaceAll]);
    temp := StringReplace(temp,'Eb','E',[rfReplaceAll]);
    temp := StringReplace(temp,'Eg','E',[rfReplaceAll]);
    temp := StringReplace(temp,'Ex','E',[rfReplaceAll]);
    temp := StringReplace(temp,'AND','und',[rfReplaceAll]);
    temp := StringReplace(temp,'Tsek','HWZ',[rfReplaceAll]);
  end else temp := 'Es ist keine Suche mit diesen Vorgaben vorgesehen!';
  frmMain.lblFilter.Caption := temp;
end;

procedure TDM.SuchAlpha(ET: TEasyTable);
var
  i,a,iza: Integer;
  th,th1,th2: Double;
  Wahr: Boolean;
begin
  th1 := GetHWZ(1);
  th2 := GetHWZ(2);
  i := 1;
  if (ET.Filter <> '') and ET.FindFirst then
  repeat
    iza := ET.FieldByName('iZA').AsInteger;
    a := GetA(iza);
    if DM.ETNukl.Locate('iZA',iza,[]) then
    begin
      Wahr := False;
      th := ETNukl.FieldByName('Tsek').AsFloat;
      if (th1 > 0) and (th2 = 0) and (th = th1) then
        Wahr := True
      else if (th1 > 0) and (th2 > th1) and (th >= th1) and (th <= th2) then
        Wahr := True
      else if (th1 = 0) and (th2 = 0) then Wahr := True;
      if Wahr then
      begin
        if ET.Name = 'ETA' then ZeigeAlpha(i,iza);
        if ET.Name = 'ETB' then ZeigeBeta(i,iza,ETB);
        if (ET.Name = 'ETG') and (ET.FieldByName('Ig').AsFloat <> -1) then
        begin
          ZeigeBeta(i,iza,ETG);
          Inc(i);
        end;
        frmMain.lblAnz.Caption := 'Gefunden: ' + IntToStr(i);
        frmMain.lblAnz.Refresh;
        if ET.Name <> 'ETG' then Inc(i);
      end;
    end else if (a = 0) and (ET.Name = 'ETG') then
    begin
      ZeigeBeta(i,iza,ETG);
      Inc(i);
    end;
    frmMain.Gauge.Position := Trunc((GetA(iza) / 293) * 100);
  until ET.FindNext = False;
  if (i = 1) and (ET.Filter <> '') then
    KeineNuklide(frmMain.GridSuch,frmMain.lblSuchArt.Caption);
  if ET.Filter <> '' then ET.Filter := '';
  if DM.ETNukl.Filter <> '' then DM.ETNukl.Filter := '';
  frmMain.Gauge.Position := 0;
end;

procedure TDM.SuchAuger;
var
  i,iza,acode: Integer;
  temp: String;
begin
  ETAug.Filter := XFilter(True);
  //if ClearGridRad(frmMain.GridSuchKarte) then
  //begin
    i := 1;
    //ClearGridRad(frmMain.GridSuchKarte);
    if (ETAug.Filter <> '') and ETAug.FindFirst then
    repeat
      acode := ETAug.FieldByName('ACode').AsInteger;
      temp := IntToStr(acode);
      temp := Copy(temp,1,Length(temp)-2) + '0000';
      iza := StrToInt(temp);
      ZeigeXRay(i,iza,ETAug);
      frmMain.lblAnz.Caption := 'Gefunden: ' + IntToStr(i);
      frmMain.lblAnz.Refresh;
      Inc(i);
      frmMain.Gauge.Position := Trunc((GetZ(iza) / 118) * 100);
    until ETAug.FindNext = False;
    if (i = 1) and (ETAug.Filter <> '') then
      KeineNuklide(frmMain.GridSuch,frmMain.lblSuchArt.Caption);
    if ETAug.Filter <> '' then ETAug.Filter := '';
    //if i > 1200 then Zuviele(i,frmMain.lblSuchArt.Caption);
  //end;
  frmMain.Gauge.Position := 0;
end;

function TDM.SuchFilter(MitF: Boolean): String;
var
  a1,a2,n1,n2,z: Integer;
  th1,th2: Double;
  temp: String;
begin
  frmMain.lblFilter.Caption := '';
  a1 := frmMain.ETA1.Value;
  a2 := frmMain.ETA2.Value;
  n1 := frmMain.ETN1.Value;
  n2 := frmMain.ETN2.Value;
  z := frmMain.ETZ.Value;
  if (z > 0) and (a1 <= 0) and (a2 <= a1) and (n1 <= 0) and (n2 <= n1) then // nur Z
    begin SiZA1 := MakeIZA(z,0,0); SiZA2 := MakeIZA(z,MinMaxA(z,True),9); end
  else if (z > 0) and (a1 > 0) and (a2 <= a1) then                      // Z+a1
    begin SiZA1 := MakeIZA(z,a1,0); SiZA2 := 0; end
  else if (z > 0) and (a1 > 0) and (a2 > a1) then                     // Z+a1+a2
    begin SiZA1 := MakeIZA(z,a1,0); SiZA2 := MakeIZA(z,a2,9); end
  else if (z > 0) and (a1 <= 0) and (a2 <= a1) and (n1 > 0) and (n2 <= n1) then
    begin SiZA1 := MakeIZA(z,z+n1,0); SiZA2 := 0; end                 // Z+n1
  else if (z > 0) and (a1 <= 0) and (a2 <= a1) and (n1 > 0) and (n2 > n1) then
    begin SiZA1 := MakeIZA(z,z+n1,0); SiZA2 := MakeIZA(z,z+n2,9); end // Z+n1+n2
  else if (z <= 0) and (a1 > 0) and (a2 <= a1) and (n1 > 0) and (n2 <= n1) then
    begin SiZA1 := MakeIZA(a1-n1,a1,0); SiZA2 := 0; end               // a1+n1
  else if (z <= 0) and (a1 > 0) and (a2 > a1) and (n1 > 0) and (n2 <= n1) then
    begin SiZA1 := MakeIZA(a1-n1,a1,0); SiZA2 := MakeIZA(a1-n1,a2,9); end// a1+a2+n1
  else if (z <= 0) and (a1 > 0) and (a2 > a1) and (n1 > 0) and (n2 > n1) then
    begin SiZA1 := MakeIZA(a1-n1,a1,0); SiZA2 := MakeIZA(a2-n2,a2,9); end// a1+a2+n1+n2
  else begin SiZA1 := 0; SiZA2 := 0; end;
  AFilt := '';
  if (SiZA1 = 0) and (SiZA2 = 0) then
    if (z <= 0) and (a1 > 0) and (a2 <= a1) and (n1 <= 0) and (n2 <= n1) then
      AFilt := '(A = ' + IntToStr(a1) + ')'
    else if (z <= 0) and (a1 > 0) and (a2 > a1) and (n1 <= 0) and (n2 <= n1) then
      AFilt := '(A >= ' + IntToStr(a1) + ') AND (A <= ' + IntToStr(a2) + ')'
    else if (z <= 0) and (a1 <= 0) and (a2 <= a1) and (n1 > 0) and (n2 <= n1) then
      AFilt := '(N = ' + IntToStr(n1) + ')'
    else if (z <= 0) and (a1 <= 0) and (a2 <= a1) and (n1 > 0) and (n2 > n1) then
      AFilt := '(N >= ' + IntToStr(n1) + ') AND (N <= ' + IntToStr(n2) + ')';
  if frmMain.CBTH1.Text = 'm' then
    temp := 'min' else temp := frmMain.CBTH1.Text;
  if frmMain.ETH1.Value > 0 then
    th1 := InSec(frmMain.ETH1.Text + temp) else th1 := 0;
  if frmMain.CBTH2.Text = 'm' then
    temp := 'min' else temp := frmMain.CBTH2.Text;
  if frmMain.ETH2.Value > 0 then
    th2 := InSec(frmMain.ETH2.Text + temp) else th2 := 0;
  if MitF then
    Result := SFilter(a1,a2,z,n1,n2,th1,th2)
  else Result := '';
end;

procedure TDM.SuchNuk;
var
  i,iza,xn,xz: Integer;
  temp: String;
begin
  temp := SuchFilter(True);
  if (SiZA1 > 0) and (SiZA2 > 0) and (SiZA2 < SiZA1) then
  begin
    frmMain.lblFilter.Caption := 'A1-N1 muss gr��er oder gleich A2-N2 sein';
    if ClearGridForDaten(frmMain.GridSuch,frmMain.RGSuch.ItemIndex,False) and
      ClearGridRad(frmMain.GridSuchKarte) then Exit;
  end;
  if temp <> '' then
  begin
    ETNukl.Filter := temp;
    ShowFilter(temp,'');
  end
  else
  begin
    frmMain.lblFilter.Caption :=
      'Es ist keine Suche mit diesen Vorgaben vorgesehen!';
    Exit;
  end;
  //if ClearGridRad(frmMain.GridSuchKarte) then
  //begin
    i := 1;
    //ClearGridRad(frmMain.GridSuchKarte);
    if ETNukl.FindFirst then
    repeat
      iza := ETNukl.FieldByName('iZA').AsInteger;
      if i = 1 then ClearGridForDaten(frmMain.GridSuch,7,True);
      with frmMain.GridSuch do
      begin
        xz := ETNukl.FieldByName('Z').AsInteger;
        xn := GetN(iza);// ETNukl.FieldByName('N').AsInteger;
        {rc := frmMain.GridSuchKarte.RowCount;
        if rc-xz-1 >= 1 then
        begin
          frmMain.GridSuchKarte.ColorCell[xn+1,rc-xz-1] := clNavy;
          frmMain.GridSuchKarte.HintCell[xn+1,rc-xz-1] :=
            IntToStr(xz) + #32 + GetSymb(iza) + #32 + IntToStr(GetA(iza)) +
            ' = ' + NukName(GetSymb(iza));
        end;}
        if RowCount < i+1 then RowCount := i+1;
        Cells[0,i] := GetNukBez(iza,False);
        Cells[1,i] := IntToStr(xz);
        Cells[2,i] := IntToStr(xn);
        Cells[3,i] := Trim(DM.FindRTypS(iza,DM.ETNukl.FieldByName('Max_RTyp').AsInteger));
        if DM.ETNukl.FieldByName('Tsek').AsFloat <> 0 then
          if DM.ETNukl.FieldByName('Tsek').AsFloat = -99 then
            Cells[4,i] := 'stabil'
          else Cells[4,i] := ZeitFormat(DM.ETNukl.FieldByName('Tsek').AsFloat);
        if (iza mod 10 > 0) and ETDMI.Locate('iZA',iza,[]) then
          if (ETDMI.FieldByName('RTYP').AsFloat = 3) and
            (ETDMI.FieldByName('DQ').AsFloat <> 0) then
              Cells[5,i] := FloatToStr(ETDMI.FieldByName('DQ').AsFloat)
          else if ETDMI.FieldByName('El').AsFloat <> 0 then
            Cells[5,i] := FloatToStr(ETDMI.FieldByName('El').AsFloat);
        Cells[6,i] := DM.GetSpin(DM.ETNukl.FieldByName('JPi').AsFloat,
          DM.ETNukl.FieldByName('Par').AsInteger);
        if DM.ETNukl.FieldByName('Abund').AsFloat <> 0 then
          Cells[7,i] := FloatToStr(DM.ETNukl.FieldByName('Abund').AsFloat);
      end;
      if i = 0 then PosGridSuchKarteScrollbar(iza);
      frmMain.Gauge.Position := Trunc((ETNukl.FieldByName('A').AsInteger / 293) * 100);
      frmMain.lblAnz.Caption := 'Gefunden: ' + IntToStr(i);
      frmMain.lblAnz.Refresh;
      Inc(i);
    until ETNukl.FindNext = False;
    ETNukl.Filter := '';
    if i = 1 then KeineNuklide(frmMain.GridSuch,frmMain.lblSuchArt.Caption);
    //if i > 1200 then Zuviele(i,frmMain.lblSuchArt.Caption);
    frmMain.Gauge.Position := 0;
  //end;
end;

procedure TDM.SuchXRay;
var
  i,iza,xcode: Integer;
  temp: String;
begin
  ETXR.Filter := XFilter(False);
  //if ClearGridRad(frmMain.GridSuchKarte) then
  //begin
    i := 1;
    //ClearGridRad(frmMain.GridSuchKarte);
    if (ETXR.Filter <> '') and ETXR.FindFirst then
    repeat
      xcode := ETXR.FieldByName('XCode').AsInteger;
      temp := IntToStr(xcode);
      temp := Copy(temp,1,Length(temp)-2) + '0000';
      iza := StrToInt(temp);
      ZeigeXRay(i,iza,ETXR);
      frmMain.lblAnz.Caption := 'Gefunden: ' + IntToStr(i);
      frmMain.lblAnz.Refresh;
      Inc(i);
      frmMain.Gauge.Position := Trunc((GetZ(iza) / 118) * 100);
    until ETXR.FindNext = False;
    if (i = 1) and (ETXR.Filter <> '') then
      KeineNuklide(frmMain.GridSuch,frmMain.lblSuchArt.Caption);
    if ETXR.Filter <> '' then ETXR.Filter := '';
    //if i > 1200 then Zuviele(i,frmMain.lblSuchArt.Caption);
  //end;
  frmMain.Gauge.Position := 0;
end;

function TDM.XFilter(Aug: Boolean): String;
var
  z1,z2: Integer;
  ea,ek: Double;
  temp,temp1,Ex,ACode: String;
begin
  ea := frmMain.EEnergy.Value;
  ek := frmMain.EkeV.Value;
  SuchFilter(False);
  temp := ''; temp1 := '';
  if Aug then
  begin
    Ex := 'Ea';
    ACode := 'ACode';
  end
  else
  begin
    Ex := 'Ex';
    ACode := 'XCode';
  end;
  if SiZA1 > 0 then
  begin
    z1 := GetZ(SiZA1);
    if GetZ(SiZA2) > z1 then z2 := GetZ(SiZA2) else z2 := 0;
  end else begin z1 := 0; z2 := 0; end;
  if (z1 > 0) and (z2 <= z1) then
    temp := '(' + ACode + ' >= ' + IntToStr(z1) + '00) AND (' + ACode + ' <= ' +
      IntToStr(z1) + '99)'
  else if (z1 > 0) and (z2 > z1) then
    temp := '(' + ACode + ' >= ' + IntToStr(z1) + '00) AND (' + ACode + ' <= ' +
      IntToStr(z2) + '99)';
  if (ea > 0) and (ek <= 0) then
    temp1 := '(' + Ex + ' = ' + FloatToStr(ea) + ')'
  else if (ea > 0) and (ek > 0) then
    temp1 := '(' + Ex + ' >= ' + FloatToStr(ea - ek) + ') AND (' + Ex + ' <= ' +
      FloatToStr(ea + ek) + ')';
  if (temp <> '') and (temp1 = '') then
    Result := temp
  else if (temp = '') and (temp1 <> '') then
    Result := temp1
  else if (temp <> '') and (temp1 <> '') then
    Result := temp + ' AND ' + temp1
  else Result := '';
  if (z1 > 0) and (z2 <= z1) then
    temp := 'Z = ' + IntToStr(z1)
  else if (z1 > 0) and (z2 > z1) then
    temp := '(Z >= ' + IntToStr(z1) + ') AND (Z <= ' + IntToStr(z2) + ')';
  ShowFilter(temp,temp1);
end;

function TDM.Zerfallart(RTyp: Double): String;
begin
  with ETDM do
  begin
    DisableControls;
    if Locate('RTYP',RTyp,[]) and (FieldByName('D_MODE').AsString <> '') then
      Result := FieldByName('D_MODE').AsString
    else Result := '';
    EnableControls;
  end;
end;

end.
