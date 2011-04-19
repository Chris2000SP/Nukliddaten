unit UnitNukFunc;

interface

uses Windows, Types, Classes, SysUtils, Math, Graphics, Dialogs, WinInet;

  function  AppVersInfo(const p_sFilepath : string): String;
  function  Bio(txt: String): String;
  function  ChangeKlammer(Txt,Zeichen: String;Anz: Integer;var A: Integer): String;
  function  DecToRoman (iDecimal: Integer): String;
  function  DelDoppelt(txt,trz: String): String;
  function  DelKlammer(Txt: String): String;
  procedure DrehText(const Canvas: TCanvas; X, Y: Integer; const AText: String;
    AAngle: Integer);
  function  GetKlammer(Txt: String): String;
  function  InSec(Value: String): Double;
  function  IntAusStr(Str: String): Integer;
  function  InternetOnline: Boolean;
  function  IsDigit(c: Char): Boolean;
  function  IsDoppelt(txt,Ltxt,trz: String): Boolean;
  function  KontrastFarbe(AColor: TColor;Nr: Integer): TColor;
  function  Kristrukt(txt: String): String;
  function  MakeKlammer(txt: String): String;
  procedure PicExp(Txt: String;F: TFont;C: TCanvas;R: TRect);
  procedure PicRTyp(Txt: String;F: TFont;bmp: TBitmap);
  //function  RFontFarbe(RTYP: Integer): TColor;
  function  Schale(txt: String): String;
  function  StringIndex(such: string; aus: array of string):Integer;
  function  VisibleContrast(BackGroundColor: TColor): TColor;
  function  ZahlFormat(Value: Double;geteilt,AnzNKS: Integer): String;
  function  ZeitFormat(Value: Double): String;

implementation

function AppVersInfo(const p_sFilepath : string): String;
const // Das Ergebnis soll ja nett formatiert sein :)
  //sFixVerFormat = 'Fileversion: %d.%d.%d.%d / Productversion: %d.%d.%d.%d';
  sFixVerFormat = 'Version: %d.%d';//.%d';
var
  dwVersionSize   : DWord;            // Buffer für die Grösse der Versionsinfo der abgefragten Datei
  dwDummy         : DWord;            // Dummy, Wert wird nicht benötigt
  pVerBuf         : Pointer;          // Buffer für die Versionsdaten
  pFixBuf         : PVSFixedFileInfo; // Buffer für die Versionsinfo fester Länge
  sReqdInfo       : string;           // Hier kommt rein, welcher Teil der Versionsinfo abgefragt werden soll
begin
  pVerBuf := nil;
  // Annahme: Die Datei hat keine Versionsinfo
  Result        := Format(sFixVerFormat,[0,0,0,0,0,0,0,0]);
  dwDummy       := 0;   // Dummy initialisieren
  sReqdInfo     := '\'; // Es soll die Versionsinfo fester Länge abgefragt werden
  // Mal sehen, wieviel Platz die Versionsinfo der Datei braucht
  dwVersionSize := GetFileVersionInfoSize(PChar(p_sFilepath),dwDummy);
  if dwVersionSize > 0 then
  begin // Wenn > 0, dann Versionsinfo vorhanden
    try
      pVerBuf := AllocMem(dwVersionSize); // Buffer initialisieren
      // Gesamte Versionsinformationen auslesen
      if GetFileVersionInfo(PChar(p_sFilepath),0,dwVersionSize,pVerBuf) then
      begin // Werte für Versionsinfo fester Länge extrahieren
        if VerQueryValue(pVerBuf,PChar(sReqdInfo),Pointer(pFixBuf),dwDummy) then
        begin
          // und als Ergebnis ausgeben
          Result := Format(sFixVerFormat,[
            (pFixBuf^.dwFileVersionMS and $FFFF0000) shr 16, // 1. Stelle HiWord, deshalb nach unten schieben
            pFixBuf^.dwFileVersionMS and $0000FFFF,
            (pFixBuf^.dwFileVersionLS and $FFFF0000) shr 16,
            pFixBuf^.dwFileVersionLS and $0000FFFF,
            (pFixBuf^.dwProductVersionMS and $FFFF0000) shr 16,
            pFixBuf^.dwProductVersionMS and $0000FFFF,
            (pFixBuf^.dwProductVersionLS and $FFFF0000) shr 16,
            pFixBuf^.dwProductVersionLS and $0000FFFF
           ]);
        end;
      end;
    finally // Resourcen wieder freigeben
      FreeMem(pVerBuf,dwVersionSize);
    end;
  end;
end;

function Bio(txt: String): String;
const fBio: array[0..4] of String =('EA','E1','FV','EM','VM');
var temp,temp1: String;
begin
  if Pos(',',txt) > 0 then
  begin
    temp1 := txt;
    temp := Copy(txt,1,Pos(',',txt)-1);
    Delete(temp1,1,Pos(',',temp1));
    temp1 := Trim(temp1);
  end else begin temp := Trim(txt); temp1 := ''; end;
  temp := IntToStr(StringIndex(temp,fBio));
  if StringIndex(temp1,fBio) > -1 then
    temp1 := IntToStr(StringIndex(temp1,fBio)) else temp1 := '';
  Result := Trim(temp + temp1);
end;

function  ChangeKlammer(Txt,Zeichen: String;Anz: Integer;var A: Integer): String;
var
  i,i1: Integer;
  temp,temp1: String;
  List: TStrings;
begin
  List := TStringList.Create;
  if (Pos('(',Txt) > 0) and (Anz >= 2) and (Zeichen <> '') then
  begin
    temp := Txt;
    if Pos(#32,Txt) > 0 then temp1 := Copy(Txt,1,Pos(#32,Txt)) else temp1 := '';
    while Pos('(',temp) > 0 do
    begin
      List.Add(Copy(temp, Pos('(',temp)+1, Pos(')',temp)-Pos('(',temp)-1));
      Delete(temp,1,Pos(')',temp));
    end;
    i1 := 0;
    temp := temp1;
    for i := 0 to List.Count - 1 do
    begin
      Inc(i1);
      if (i < List.Count - 1) and (i1 < 2) then
        temp := temp + '(' + List.Strings[i]
      else if i1 = 2 then
      begin
        temp := temp + Zeichen + List.Strings[i] + ')';
        i1 := 0;
        Dec(A);
      end
      else if (i = List.Count - 1) and (i1 = 1) then
        temp := temp + '(' + List.Strings[i] + ')';
    end;
    Result := temp;
  end else Result := Txt;
  List.Free;
end;

function DecToRoman (iDecimal: Integer): String;
  const
  aRomans: array [1..13] of string = ( 'I', 'IV', 'V',
   'IX', 'X', 'XL','L', 'XC', 'C', 'CD', 'D', 'CM', 'M' );
  aArabics: array [1..13] of integer = ( 1, 4, 5,
   9, 10, 40, 50, 90, 100, 400, 500, 900, 1000 );
var i: integer;
begin
  Result := '';
  for i := 13 downto 1 do
    while ( iDecimal >= aArabics[i] ) do
    begin
      iDecimal := iDecimal - aArabics[i];
      Result := Result + aRomans[i];
    end;
end;

function DelDoppelt(txt,trz: String): String;
var
  i: Integer;
  temp,temp1: String;
  vorh: Boolean;
  List: TStringList;
begin
  if Pos(trz,txt) > 0 then
  begin
    Result := '';
    List := TStringList.Create;
    temp := Trim(txt);
    while Pos(trz,temp) > 0 do
    begin
      temp1 := Trim(Copy(temp,1,Pos(trz,temp)-1));
      vorh := False;
      for i := 0 to List.Count-1 do
        if SameText(temp1,List.Strings[i]) then
        begin
          vorh := True;
          Break;
        end;
      if not vorh then List.Add(temp1);
      Delete(temp,1,Pos(trz,temp));
    end;
    if Trim(temp) <> '' then
    begin
      vorh := False;
      for i := 0 to List.Count-1 do
        if SameText(temp,List.Strings[i]) then
        begin
          vorh := True;
          Break;
        end;
      if not vorh then List.Add(temp);
    end;
    for i := 0 to List.Count-1 do
      if Result <> '' then
        Result := Result + MakeKlammer(List.Strings[i])
      else Result := List.Strings[i] + #32;
    List.Free;
  end else Result := txt;
end;

function DelKlammer(Txt: String): String;
var temp,temp1: String;
begin
  temp := Txt;
  if Pos('(',temp) > 1 then
  begin
    temp1 := Copy(temp,1,Pos('(',temp)-1);
    Delete(temp,1,Pos(')',temp));
    Result := temp1 + temp;
  end
  else
  begin
    Delete(temp,1,Pos(')',temp));
    Result := temp;
  end;
end;

procedure DrehText(const Canvas: TCanvas; X, Y: Integer; const AText: String;
    AAngle: Integer);
var
  hCurFont: HFONT;
  LogFont: TLogFont;      // Siehe Hilfe = gedrehte Schrift
begin
  with Canvas do
  begin
    hCurFont := Font.Handle;
    try
      GetObject(Font.Handle, SizeOf(LogFont), @LogFont);
      LogFont.lfEscapement := AAngle;
      LogFont.lfOrientation := AAngle;
      Font.Handle := CreateFontIndirect(LogFont);
      try
        TextOut(X, Y, AText);
      finally
        DeleteObject(Font.Handle);
      end;
    finally
      Font.Handle := hCurFont;
    end;
  end;
end;

function GetKlammer(Txt: String): String;
begin
  if Pos('(',Txt) > 0 then
    Result := Copy(Txt, Pos('(',Txt)+1, Pos(')',Txt)-Pos('(',Txt)-1)
  else Result := '';
end;

function InSec(Value: String): Double;
var temp: String;
begin
  Result := 0;
  temp := Trim(Value);
  while Pos(#32,temp) > 0 do Delete(temp, Pos(#32,temp), 1);
  if Pos('a',temp) > 0 then
  begin
    Delete(temp, Pos('a',temp), 1);
    Result := (((StrToFloat(Trim(temp)) * 365) * 24) * 60) * 60;
  end
  else if Pos('d',temp) > 0 then
  begin
    Delete(temp, Pos('d',temp), 1);
    Result := ((StrToFloat(Trim(temp)) * 24) * 60) * 60;
  end
  else if Pos('h',temp) > 0 then
  begin
    Delete(temp, Pos('h',temp), 1);
    Result := (StrToFloat(Trim(temp)) * 60) * 60;
  end
  else if Pos('min',temp) > 0 then
  begin
    Delete(temp, Pos('min',temp), 3);
    Result := StrToFloat(Trim(temp)) * 60;
  end
  else if Pos('ms',temp) > 0 then
  begin
    Delete(temp, Pos('ms',temp), 2);
    Result := StrToFloat(Trim(temp)) / 1000;
  end
  else if Pos('s',temp) > 0 then
  begin
    Delete(temp, Pos('s',temp), 1);
    Result := StrToFloat(Trim(temp));
  end;
end;

function IntAusStr(Str: String): Integer;
var
  i: Integer;
  temp: String;
begin
  temp := '';
  for i := 1 to Length(Str) do
    if Str[i] in ['0'..'9'] then temp := temp + Str[i];
  if temp <> '' then Result := StrToInt(temp) else Result := 0;
end;

function  InternetOnline: Boolean;
begin
  Result := InternetGetConnectedState(nil, 0);
  {if InternetGetConnectedState(nil, 0) then
  	Result := True else Result := False;}
end;

function  IsDigit(c: Char): Boolean;
begin
  Result := c in ['0'..'9'];
end;

function IsDoppelt(txt,Ltxt,trz: String): Boolean;
var
  i: Integer;
  temp: String;
  List: TStringList;
begin
  Result := False;
  if Pos(trz,Ltxt) > 0 then
  begin
    List := TStringList.Create;
    temp := Ltxt;
    while Pos(trz,temp) > 0 do
    begin
      List.Add(Copy(temp,1,Pos(trz,temp)-1));
      Delete(temp,1,Pos(trz,temp));
    end;
    List.Add(temp);
    for i := 0 to List.Count-1 do
      if SameText(List.Strings[i],txt) then
      begin
        Result := True;
        Break;
      end;
    List.Free;
  end else if SameText(txt,Ltxt) then Result := True;
end;

function KontrastFarbe(AColor: TColor;Nr: Integer): TColor;
var
  Hell: Integer;
  Farbe: Integer;
  F1,F2: TColor;
begin
  if Nr = 1 then
  begin
    F1 := clBlack;
    F2 := 11464687;
  end
  else if Nr = 3 then
  begin
    F1 := clBlack;
    F2 := clWhite;// clInfoBk;
  end
  else
  begin
    F1 := clBlack;
    F2 := clInfoBk;
  end;
  Farbe := AColor and $00FFFFFF;
  Hell := Round(((Farbe shr 16) and $FF) * 0.20 +
                  ((Farbe shr 8) and $FF)* 0.55 +
                  (Farbe and $FF) * 0.27);
  if Hell > 130 then
      Result := F1
  else Result := F2;
end;

function Kristrukt(txt: String): String;
const fKri: array[1..10] of String =('ku','krz','kfz','h','t','or','r','m','d','O2');
var temp,temp1: String;
begin
  if Pos(',',txt) > 0 then
  begin
    temp1 := txt;
    temp := Copy(txt,1,Pos(',',txt)-1);
    Delete(temp1,1,Pos(',',temp1));
    temp1 := Trim(temp1);
  end else begin temp := txt; temp1 := ''; end;
  if StringIndex(temp,fKri) > -1 then
    temp := IntToStr(StringIndex(temp,fKri)) else temp := '0';
  if StringIndex(temp1,fKri) > -1 then
    temp1 := IntToStr(StringIndex(temp1,fKri)) else temp1 := '';
  Result := Trim(temp + temp1);
end;

function  MakeKlammer(txt: String): String;
begin
  Result := '(' + Trim(txt) + ')';
end;

procedure PicExp(Txt: String;F: TFont;C: TCanvas;R: TRect);
  procedure SymFont(S: String;Sym: Boolean);
  begin
    with C do
      if Sym then
      begin
        Font.Charset := SYMBOL_CHARSET;
        Font.Name := 'Symbol';   
        if S = 'ec' then Font.Size := 8 else Font.Size := 7;
      end else Font := F;
  end;
const RTyp: array[1..8] of String =('a','xa','b-','b+','b-,b-','b+,b+','2b-','ec');
var
  i,anz,h,w,th,tw1,tw2: Integer;
  temp,vk1,vk2,hk1,hk2: String;
  Wahr: Boolean;
  List: TStrings;
begin
  List := TStringList.Create;
  anz := 0; tw1 := 0; tw2 := 0;
  h := R.Bottom - R.Top;
  w := R.Right - R.Left;
  temp := Trim(Txt);
  for i := 1 to Length(temp) do if temp[i] = ')' then Inc(anz);
  with C do
  begin
    Font := F;
    if anz = 0 then List.Add(temp);
    if Pos(#32,temp) > 0 then
    begin
      vk1 := Trim(Copy(temp,1,Pos(#32,temp)));
      List.Add(vk1);
      Delete(temp,1,Pos(#32,temp));
    end else vk1 := '';
    while Pos(')',temp) > 0 do
    begin
      if Trim(GetKlammer(temp)) <> vk1 then
        List.Add(Trim(GetKlammer(temp)));
      Delete(temp,1,Pos(')',temp));
    end;
    anz := List.Count;
    for i := 0 to anz - 1 do
    begin
      Wahr := False;
      temp := List.Strings[i];
      if Pos(',',temp) > 0 then
      begin
        if (anz >= 4) and ((i = 2) or (i = 4)) then
        begin
          if temp = 'b-,b-' then hk1 := '2b-'
          else
          begin
            hk2 := temp;
            hk1 := Copy(hk2,1,Pos(',',hk2)-1);
            Delete(hk2,1,Pos(',',hk2));
          end;
        end
        else
        begin
          vk2 := temp; hk1 := ''; hk2 := '';
          vk1 := Copy(vk2,1,Pos(',',vk2)-1);
          Delete(vk2,1,Pos(',',vk2));
        end;
      end
      else if (anz >= 4) and ((i = 2) or (i = 4)) then
        hk1 := temp
      else begin vk1 := temp; vk2 := ''; hk1 := ''; hk2 := ''; end;
      if anz = 1 then
      begin
        tw1 := (w - TextWidth(temp)) div 2;
        th := (h - TextHeight(temp)) div 2;
      end
      else if (anz = 2) or (anz = 3) then
      begin
        tw1 := (w - TextWidth(temp)) div 2;
        th := ((h-(TextHeight(temp)*anz)) div 2) + (TextHeight(temp)*i)-(i*1);
      end
      else if anz = 4 then
      begin
        if i = 1 then
          tw1 := ((w div 2) - TextWidth(temp)) div 2
        else if i = 2 then
          tw2 := (w div 2) + (((w div 2) - TextWidth(temp)) div 2)
        else tw1 := (w - TextWidth(temp)) div 2;
        if i = 1 then Wahr := True else Wahr := False;
        case i of
            0: th := (h-(TextHeight(temp)*3)) div 2;
          1,2: th := ((h-(TextHeight(temp)*3)) div 2) + TextHeight(temp)-1;
        else th := ((h-(TextHeight(temp)*3)) div 2) + (TextHeight(temp)*2)-2;
        end;
      end
      else
      begin
        if (i = 1) or (i = 3) then
          tw1 := ((w div 2) - TextWidth(temp)) div 2
        else if (i = 2) or (i = 4) then
          tw2 := (w div 2) + (((w div 2) - TextWidth(temp)) div 2)
        else tw1 := (w - TextWidth(temp)) div 2;
        if (i = 1) or (i = 3) then Wahr := True else Wahr := False;
        case i of
            0: th := (h-(TextHeight(temp)*3)) div 2;
          1,2: th := ((h-(TextHeight(temp)*3)) div 2) + TextHeight(temp)-1;
        else th := ((h-(TextHeight(temp)*3)) div 2) + (TextHeight(temp)*2)-2;
        end;
      end;
      if not Wahr then
      begin
        if hk1 <> '' then
        begin
          if StringIndex(hk1,RTyp) > -1 then
            SymFont(hk1,True) else SymFont(hk1,False);
          if hk1 = 'ec' then begin hk1 := 'e'; Inc(tw2); Dec(th); end;
          if (hk2 <> '') then
          begin
            TextOut(R.Left+tw2-2,R.Top+th,hk1);
            if (StringIndex(hk2,RTyp) > -1) then
              SymFont(hk2,True) else SymFont(hk2,False);
            if hk2 = 'ec' then hk2 := 'e';
            if hk2 = 'xa' then hk2 := chr(180)+'a';
            TextOut(R.Left+tw2+TextWidth(hk1)-1,R.Top+th,','+hk2);
          end else TextOut(R.Left+tw2,R.Top+th,hk1);
        end;
        if StringIndex(vk1,RTyp) > -1 then
          SymFont(vk1,True) else SymFont(vk1,False);
        if vk1 = 'ec' then begin vk1 := 'e'; Inc(tw1); Dec(th); end;
        if Pos('b',vk1) > 0 then Inc(tw1);
        if (vk2 <> '') then
        begin
          TextOut(R.Left+tw1+1,R.Top+th,vk1);
          if (StringIndex(vk2,RTyp) > -1) then
            SymFont(vk2,True) else SymFont(vk2,False);
          if vk2 = 'ec' then vk2 := 'e';
          if vk2 = 'xa' then vk2 := chr(180)+'a';
          TextOut(R.Left+tw1+TextWidth(vk1),R.Top+th,','+vk2);
        end else TextOut(R.Left+tw1,R.Top+th,vk1);
      end;
    end;
  end;
  List.Free;
end;

procedure PicRTyp(Txt: String;F: TFont;bmp: TBitmap);
  procedure SymFont(S: String;Sym: Boolean);
  begin
    with bmp.Canvas do
      if Sym then
      begin
        Font.Charset := SYMBOL_CHARSET;
        Font.Name := 'Symbol';   
        if S = 'ec' then Font.Size := 8 else Font.Size := 7;
      end else Font := F;
  end;
const RTyp: array[1..8] of String =('a','xa','b-','b+','b-,b-','b+,b+','2b-','ec');
var
  i,anz,h,w,th,tw1,tw2: Integer;
  temp,vk1,vk2,hk1,hk2: String;
  Wahr: Boolean;
  List: TStrings;
begin
  List := TStringList.Create;
  anz := 0; tw1 := 0; tw2 := 0;
  h := bmp.Height;
  w := bmp.Width;
  temp := Trim(Txt);
  for i := 1 to Length(temp) do if temp[i] = ')' then Inc(anz);
  with bmp.Canvas do
  begin
    Font := F;
    if anz = 0 then List.Add(temp);
    if Pos(#32,temp) > 0 then
    begin
      vk1 := Trim(Copy(temp,1,Pos(#32,temp)));
      List.Add(vk1);
      Delete(temp,1,Pos(#32,temp));
    end else vk1 := '';
    while Pos(')',temp) > 0 do
    begin
      if Trim(GetKlammer(temp)) <> vk1 then
        List.Add(Trim(GetKlammer(temp)));
      Delete(temp,1,Pos(')',temp));
    end;
    anz := List.Count;
    for i := 0 to anz - 1 do
    begin
      Wahr := False;
      temp := List.Strings[i];
      if Pos(',',temp) > 0 then
      begin
        if (anz >= 4) and ((i = 2) or (i = 4)) then
        begin
          if temp = 'b-,b-' then hk1 := '2b-'
          else
          begin
            hk2 := temp;
            hk1 := Copy(hk2,1,Pos(',',hk2)-1);
            Delete(hk2,1,Pos(',',hk2));
          end;
        end
        else
        begin
          vk2 := temp; hk1 := ''; hk2 := '';
          vk1 := Copy(vk2,1,Pos(',',vk2)-1);
          Delete(vk2,1,Pos(',',vk2));
        end;
      end
      else if (anz >= 4) and ((i = 2) or (i = 4)) then
        hk1 := temp
      else begin vk1 := temp; vk2 := ''; hk1 := ''; hk2 := ''; end;
      if anz = 1 then
      begin
        tw1 := (w - TextWidth(temp)) div 2;
        th := (h - TextHeight(temp)) div 2;
      end
      else if (anz = 2) or (anz = 3) then
      begin
        tw1 := (w - TextWidth(temp)) div 2;
        th := ((h-(TextHeight(temp)*anz)) div 2) + (TextHeight(temp)*i)-(i*1);
      end
      else if anz = 4 then
      begin
        if i = 1 then
          tw1 := ((w div 2) - TextWidth(temp)) div 2
        else if i = 2 then
          tw2 := (w div 2) + (((w div 2) - TextWidth(temp)) div 2)
        else tw1 := (w - TextWidth(temp)) div 2;
        if i = 1 then Wahr := True else Wahr := False;
        case i of
            0: th := (h-(TextHeight(temp)*3)) div 2;
          1,2: th := ((h-(TextHeight(temp)*3)) div 2) + TextHeight(temp)-1;
        else th := ((h-(TextHeight(temp)*3)) div 2) + (TextHeight(temp)*2)-2;
        end;
      end
      else
      begin
        if (i = 1) or (i = 3) then
          tw1 := ((w div 2) - TextWidth(temp)) div 2
        else if (i = 2) or (i = 4) then
          tw2 := (w div 2) + (((w div 2) - TextWidth(temp)) div 2)
        else tw1 := (w - TextWidth(temp)) div 2;
        if (i = 1) or (i = 3) then Wahr := True else Wahr := False;
        case i of
            0: th := (h-(TextHeight(temp)*3)) div 2;
          1,2: th := ((h-(TextHeight(temp)*3)) div 2) + TextHeight(temp)-1;
        else th := ((h-(TextHeight(temp)*3)) div 2) + (TextHeight(temp)*2)-2;
        end;
      end;
      if not Wahr then
      begin
        if hk1 <> '' then
        begin
          if StringIndex(hk1,RTyp) > -1 then
            SymFont(hk1,True) else SymFont(hk1,False);
          if hk1 = 'ec' then begin hk1 := 'e'; Inc(tw2); Dec(th); end;
          if (hk2 <> '') then
          begin
            TextOut(tw2-2,th,hk1);
            if (StringIndex(hk2,RTyp) > -1) then
              SymFont(hk2,True) else SymFont(hk2,False);
            if hk2 = 'ec' then hk2 := 'e';
            if hk2 = 'xa' then hk2 := chr(180)+'a';
            TextOut(tw2+TextWidth(hk1)-1,th,','+hk2);
          end else TextOut(tw2,th,hk1);
        end;
        if StringIndex(vk1,RTyp) > -1 then
          SymFont(vk1,True) else SymFont(vk1,False);
        if vk1 = 'ec' then begin vk1 := 'e'; Inc(tw1); Dec(th); end;
        if Pos('b',vk1) > 0 then Inc(tw1);
        if (vk2 <> '') then
        begin
          TextOut(tw1+1,th,vk1);
          if (StringIndex(vk2,RTyp) > -1) then
            SymFont(vk2,True) else SymFont(vk2,False);
          if vk2 = 'ec' then vk2 := 'e';
          if vk2 = 'xa' then vk2 := chr(180)+'a';
          TextOut(tw1+TextWidth(vk1),th,','+vk2);
        end else TextOut(tw1,th,vk1);
      end;
    end;
  end;
  List.Free;
end;

{function  RFontFarbe(RTYP: Double): TColor;
var i: Integer;
begin
  i := Trunc(RTYP);
  case i of
    2,3,10: Result := clWhite;
  else Result := clBlack;
  end;
end;}

function  Schale(txt: String): String;
const
  Sch: array [0..6] of string = ('K', 'L', 'M', 'N', 'O', 'P', 'Q');
var i: integer;
begin
  Result := txt;
  for i := 0 to 6 do
    if Sch[i] = Trim(txt) then
    begin
      Result := Trim(txt) + ' = ' + IntToStr(i+1);
      Break;
    end;
end;

function  StringIndex(such: string; aus: array of string):Integer;
begin
  for Result := High(aus) downto 0 do
    if AnsiSameText(such, aus[Result]) then Break;
end;

function VisibleContrast(BackGroundColor: TColor): TColor;
const cHalfBrightness = ((0.3 * 255.0) + (0.59 * 255.0) + (0.11 * 255.0)) / 2.0;
var Brightness : double;
begin
  with TRGBQuad(BackGroundColor) do
    BrightNess := (0.3 * rgbRed) + (0.59 * rgbGreen) + (0.11 * rgbBlue);
  if (Brightness>cHalfBrightNess) then
    result := clblack
  else
    result := clwhite;
end;

function ZahlFormat(Value: Double;geteilt,AnzNKS: Integer): String;
var
  temp: String;
  d: Double;
begin
  d := Value;
  if geteilt > 0 then
    case geteilt of
      1: d := Value / 1000;
      2: d := Value / 1000 / 1000;
      3: d := Value / 1000 / 1000 / 1000;
    end;
  temp := FloatToStr(d);
  case Length(temp) of
    1..5: Result := FloatToStr(d);
    6..10: Result := FloatToStrF(d,ffGeneral,AnzNKS,1);
    11..20: Result := FloatToStrF(d,ffGeneral,AnzNKS,1);
  else Result := FloatToStr(d);
  end;
end;

function ZeitFormat(Value: Double): String;
begin
  Result := '';
  if Value = -99 then                              // 10-18 as = Atto
    Result := 'stabil'                             // 10-15 fs = Femto
  else if Value < 0.000000000000001 then
    //Result := FloatToStrF(Value*1000000000000000000,ffGeneral,4,2) + ' as'
    //Result := Format('%5g',[Value*1000000000000000000]) + ' as'
    Result := FormatFloat('#.##E-',Value*1000000000000000000) + ' as'
  else if Value < 0.000000000001 then
    Result := FloatToStrF(Value*1000000000000000,ffGeneral,4,2) + ' fs'
  else if Value < 0.000000001 then
    Result := FloatToStrF(Value*1000000000000,ffGeneral,4,2) + ' ps' // 10-12
  else if Value < 0.000001 then
    Result := FloatToStrF(Value*1000000000,ffGeneral,4,2) + ' ns'       // 10-9
  else if Value < 0.001 then
    Result := FloatToStrF(Value*1000000,ffGeneral,4,2) + ' mis'      // 10-6
  else if Value < 1.0 then
    Result := FloatToStr(Value*1000) + ' ms'                         // 10-3
  else if Value < 60.0 then
    Result := FloatToStr(Value) + ' s'
  else if Value < 3600.0 then
    Result := FloatToStrF(Value/60,ffGeneral,4,2) + ' min'
  else if Value < 86400.0 then
    Result := FloatToStrF((Value/60)/60,ffGeneral,4,2) + ' h'
  else if Value < 31536000.0 then 
    Result := FloatToStrF(((Value/60)/60)/24,ffGeneral,4,2) + ' d'
  else Result := FloatToStrF((((Value/60)/60)/24)/365,ffGeneral,4,2) + ' a';
end;

end.
