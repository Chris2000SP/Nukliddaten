unit UnitDM;

interface

uses
  SysUtils, Classes, DB, EasyTable, DateUtils, ImgList, Controls, Graphics,
  Types;

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
  private
    { Private-Deklarationen }
    function  OpenTab(ETab: TEasyTable;Tabname,IdxName: String): Boolean;
    function  ErzTab(TabName: String): TEasyTable;
    function  ErzDS(DSName: String;Tab: TEasyTable): TDataSource;
  public
    { Public-Deklarationen }
    DataPfad,DezS: String;
    Datengeladen: Boolean;
    ETNukl,ETDM,ETDMI,ETName,ETChem,ETRZA: TEasyTable;
    DSNukl,DSDM,DSDMI,DSName,DSChem: TDataSource;
    function GetZ(iza: Integer): Integer;
    function GetN(iza: Integer): Integer;
    function GetA(iza: Integer): Integer;
    function GetSymb(iza: Integer): String;
    function GetNukBez(iza: Integer;MitZ: Boolean): String;
    function GetiZA(txt: String): Integer;
    function MakeIZA(Z,A,L: Integer): Integer;
    function IZAvonZ(Z: Integer): Integer;
  end;

var
  DM: TDM;

implementation

  uses UnitMain, UnitNukFunc, UnitPSE, UnitNuk;

{$R *.dfm}

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
        if stabil and (ETNukl.FieldByName('Tsek').AsFloat = -99) then
          Inc(anz)
        else if not stabil and (ETNukl.FieldByName('Tsek').AsFloat <> -99) then
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
  ETRZA := ErzTab('ETRZA');
  DSNukl := ErzDS('DSNukl',ETNukl);
  DSDM := ErzDS('DSDM',ETDM);
  DSDMI := ErzDS('DSDMI',ETDMI);
  DSName := ErzDS('DSName',ETName);
  DSChem := ErzDS('DSChem',ETChem);
  if OpenTab(ETNukl,'Nukl','ByiZA') and OpenTab(ETName,'NukNa','ByNr') and
    OpenTab(ETDM,'NukDM','ByR') and OpenTab(ETDMI,'DMI','ByiZA') and
    OpenTab(ETChem,'Chem','ByNr') and OpenTab(ETRZA,'RZA','ByiZA') then
  begin
    if LeseNukKarte then
      if LeseNukExplorer(frmMain.TVNuk,1,True) then
        if ClearGridRad and RadReihe(791690) then
          for i := 1 to 118 do GridPSENuk(i);
    Datengeladen := True;
  end else Datengeladen := False;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  if ETNukl.Active then ETNukl.Close;
  if ETDM.Active then ETDM.Close;
  if ETDMI.Active then ETDMI.Close;
  if ETName.Active then ETName.Close;
  if ETChem.Active then ETChem.Close;
  if ETRZA.Active then ETRZA.Close;
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
  if iza mod 10 > 0 then
    if iza mod 10 > 1 then temp := 'm' + IntToStr(iza mod 10) else temp := 'm'
  else temp := '';
  if MitZ then
    Result := IntToStr(GetZ(iza))+#32+GetSymb(iza)+#32+IntToStr(GetA(iza)) + temp
  else Result := GetSymb(iza)+#32+IntToStr(GetA(iza)) + temp;
end;

function TDM.GetSymb(iza: Integer): String;
begin
  if (iza = 1) and ETName.Locate('Nr',119,[]) then
    Result := ETName.FieldByName('F1').AsString
  else if (iza > 1) and ETName.Locate('Nr',GetZ(iza),[]) then
    Result := ETName.FieldByName('F1').AsString
  else Result := '';
end;

function TDM.GetZ(iza: Integer): Integer;
var temp: String;
begin
  temp := IntToStr(iza);
  if iza = 1 then Result := 0
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
        if FieldByName(Feld).AsFloat > 0 then
          if (frmMain.RG.ItemIndex = 3) and (FieldByName(Feld).AsFloat >= 1) and
            ((frmMain.Min = 0) or (FieldByName(Feld).AsFloat < frmMain.Min)) then
            frmMain.Min := FieldByName(Feld).AsFloat
          else if (frmMain.RG.ItemIndex <> 3) and (FieldByName(Feld).AsFloat > 0) and
            ((frmMain.Min = 0) or (FieldByName(Feld).AsFloat < frmMain.Min)) then
            frmMain.Min := FieldByName(Feld).AsFloat
          else
            if (frmMain.Max = 0) or (FieldByName(Feld).AsFloat > frmMain.Max) then
              frmMain.Max := FieldByName(Feld).AsFloat;
      if FieldByName(Feld).DataType = ftInteger then
        if FieldByName(Feld).AsInteger > 0 then
          if (frmMain.Min = 0) or (FieldByName(Feld).AsInteger < frmMain.Min) then
            frmMain.Min := FieldByName(Feld).AsInteger
          else
            if (frmMain.Max = 0) or (FieldByName(Feld).AsInteger > frmMain.Max) then
              frmMain.Max := FieldByName(Feld).AsInteger;
      Next;
    end;
  Result := True;
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
          (FieldByName('RTYP1').AsInteger <> C) then//MaxR) then
        begin
          Result := FieldByName('RTYP1').AsInteger;
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
          i1 := FieldByName('RTYP1').AsInteger;
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
