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
  procedure Hoch(Canv: TCanvas;F: TFont;R: TRect;txt: String);
  function  InSec(Value: String): Double;
  function  IntAusStr(Str: String): Integer;
  function  InternetOnline: Boolean;
  function  IsDigit(c: Char): Boolean;
  function  IsDoppelt(txt,Ltxt,trz: String): Boolean;
  function  IsFloat(c: Char): Boolean;
  function  KontrastFarbe(AColor: TColor;Nr: Integer): TColor;
  function  Kristrukt(txt: String): String;
  function  MakeKlammer(txt: String): String;
  procedure MaleZerfall(Canv: TCanvas;F: TFont;R: TRect;txt: String);
  procedure MaleZerfallsarten(Canv: TCanvas;F: TFont;R: TRect;txt: String);
  procedure MikroSek(Canv: TCanvas;F: TFont;R: TRect;txt: String);
  procedure PicRTyp(Txt: String;F: TFont;bmp: TBitmap);
  procedure PosText(Canv: TCanvas;F: TFont;R: TRect;txt: String);
  procedure Potenz(Canv: TCanvas;F: TFont;R: TRect;txt: String);
  function  Schale(txt: String): String;
  function  SFilter(a1,a2,z,n1,n2:Integer;th1,th2: Double): String;
  function  StringIndex(such: string; aus: array of string):Integer;
  procedure SymFont(Canv: TCanvas;Sym: Boolean);
  procedure TextUpDown(Canv: TCanvas;F: TFont;R: TRect;txt: String;Ptxt: Integer);
  procedure Tief(Canv: TCanvas;F: TFont;R: TRect;txt: String);
  function  VisibleContrast(BackGroundColor: TColor): TColor;
  function  ZahlFormat(Value: Double;geteilt,AnzNKS: Integer): String;
  function  ZeitFormat(Value: Double): String;
  procedure Zuviele(anz: Integer;txt: String);

implementation

uses UnitDM;

function AppVersInfo(const p_sFilepath : string): String;
const // Das Ergebnis soll ja nett formatiert sein :)
  //sFixVerFormat = 'Fileversion: %d.%d.%d.%d / Productversion: %d.%d.%d.%d';
  sFixVerFormat = 'Version: %d.%d';//.%d';
var
  dwVersionSize   : DWord;            // Buffer f�r die Gr�sse der Versionsinfo der abgefragten Datei
  dwDummy         : DWord;            // Dummy, Wert wird nicht ben�tigt
  pVerBuf         : Pointer;          // Buffer f�r die Versionsdaten
  pFixBuf         : PVSFixedFileInfo; // Buffer f�r die Versionsinfo fester L�nge
  sReqdInfo       : string;           // Hier kommt rein, welcher Teil der Versionsinfo abgefragt werden soll
begin
  pVerBuf := nil;
  // Annahme: Die Datei hat keine Versionsinfo
  Result        := Format(sFixVerFormat,[0,0,0,0,0,0,0,0]);
  dwDummy       := 0;   // Dummy initialisieren
  sReqdInfo     := '\'; // Es soll die Versionsinfo fester L�nge abgefragt werden
  // Mal sehen, wieviel Platz die Versionsinfo der Datei braucht
  dwVersionSize := GetFileVersionInfoSize(PChar(p_sFilepath),dwDummy);
  if dwVersionSize > 0 then
  begin // Wenn > 0, dann Versionsinfo vorhanden
    try
      pVerBuf := AllocMem(dwVersionSize); // Buffer initialisieren
      // Gesamte Versionsinformationen auslesen
      if GetFileVersionInfo(PChar(p_sFilepath),0,dwVersionSize,pVerBuf) then
      begin // Werte f�r Versionsinfo fester L�nge extrahieren
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

procedure Hoch(Canv: TCanvas;F: TFont;R: TRect;txt: String);
var
  i,tw,th,tp,tn: Integer;
  temp,pot: String;
begin
  with Canv do
  begin
    Font := F;
    tn := F.Size;
    pot := '';
    temp := txt;
    temp := StringReplace(temp,'^','',[rfReplaceAll]);
    tw := (R.Right - R.Left - TextWidth(temp)) div 2;
    th := (R.Bottom - R.Top - TextHeight(txt)) div 2;
    if R.Bottom - R.Top - TextHeight(txt) = 1 then tp := -2
    else if R.Bottom - R.Top - TextHeight(txt) = -1 then tp := -1
    else if R.Bottom - R.Top - TextHeight(txt) = 7 then tp := 2
    else tp := 2;
    temp := txt;
    while Pos('^',temp) > 0 do
    begin
      if temp[1] = 'p' then tw := tw + 1;
      pot := Copy(temp,1,Pos('^',temp)-1);
      Font := F;
      Font.Size := tn;
      Font.Style := [fsBold];
      TextOut(R.Left+tw,R.Top+th,pot);
      tw := tw + TextWidth(pot);
      Delete(temp,1,Pos('^',temp));
      pot := '';
      for i := 1 to Length(temp) do
      begin
        if (temp[i] = #32) or not isDigit(temp[i]) then
          Break
        else pot := pot + temp[i];
      end;
      Font.Charset := ANSI_CHARSET;
      Font.Name := 'Arial';
      Font.Style := [];
      Font.Size := 6;
      TextOut(R.Left+tw,R.Top+tp,pot);
      tw := tw + TextWidth(pot);
      Delete(temp,1,Length(pot));
    end;
  end;
end;

function InSec(Value: String): Double;
var temp: String;
begin
  Result := 0;
  temp := Trim(Value);      // 365,2422 Tage/Jahr
  while Pos(#32,temp) > 0 do Delete(temp, Pos(#32,temp), 1);
  if Pos('a',temp) > 0 then
  begin
    Delete(temp, Pos('a',temp), 1);
    Result := (((StrToFloat(Trim(temp)) * 365.2422) * 24) * 60) * 60;
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

function IsFloat(c: Char): Boolean;
begin
  if (c = DM.DezS) or IsDigit(c) then
    Result := True
  else Result := False;
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

procedure MaleZerfall(Canv: TCanvas;F: TFont;R: TRect;txt: String);
var
  i,tw,th,rd: Integer;
  temp: String;
begin
  temp := txt;
  with Canv do
  begin
    Font := F;
    temp := StringReplace(temp,'ec','e',[rfReplaceAll]);
    th := (R.Bottom - R.Top - TextHeight(temp)) div 2;
    tw := (R.Right - R.Left - TextWidth(temp)) div 2;
    if Pos('Ne',temp) = 0 then
      for i := 1 to Length(temp) do
      begin
        if (temp[i] = 'a') or (temp[i] = 'b') or (temp[i] = 'e') then
        begin SymFont(Canv,True); rd := 2; end
        else begin SymFont(Canv,False); rd := 0; end;
        TextOut(R.Left+tw,R.Top+th-rd,temp[i]);
        tw := tw + TextWidth(temp[i]);
      end
    else begin SymFont(Canv,False); TextOut(R.Left+tw,R.Top+th,temp); end;
  end;
end;

procedure MaleZerfallsarten(Canv: TCanvas;F: TFont;R: TRect;txt: String);
var
  i,i1,tw,th,rd: Integer;
  temp: String;
  List: TStringList;
begin
  if Trim(txt) = '' then Exit;
  List := TStringList.Create;
  temp := txt;
  with Canv do
  begin
    Font := F;
    th := (R.Bottom - R.Top - TextHeight(temp)) div 2;
    tw := ((R.Right - R.Left - TextWidth(temp)) div 2);
    if (Pos('a',temp) > 0) or (Pos('b',temp) > 0) or (Pos('ec',temp) > 0) then
    begin
      i1 := 0;
      for i := 1 to Length(temp) do
        if (temp[i] = 'a') or (temp[i] = 'b') or
          ((temp[i] = 'e') and (temp[i+1] = 'c')) then
        begin
          if (i1 > 0) or (i > 1) then List.Add(Copy(temp,i1+1,i-i1-1));
          if (temp[i] = 'e') and (temp[i+1] = 'c') then
          begin
            List.Add(Copy(temp,i,2));
            i1 := i+1;
          end
          else
          begin
            List.Add(Copy(temp,i,1));
            i1 := i;
          end;
        end else if i = Length(temp) then List.Add(Copy(temp,i1+1,i-i1));
    end else List.Add(temp);
    for i := 0 to List.Count-1 do
    begin
      temp := List.Strings[i];
      temp := StringReplace(temp,'ec','e',[rfReplaceAll]);
      if (temp = 'a') or (temp = 'b') or (temp = 'e') then
      begin SymFont(Canv,True); rd := 2; end
      else begin SymFont(Canv,False); rd := 0; end;
      TextOut(R.Left+tw,R.Top+th-rd,temp);
      tw := tw + TextWidth(temp);
    end;
  end;
  List.Free;
end;

procedure MikroSek(Canv: TCanvas;F: TFont;R: TRect;txt: String);
var
  tw,th: Integer;
  temp: String;
begin
  with Canv do
  begin
    Font := F;
    temp := txt;
    tw := (R.Right - R.Left - TextWidth(temp)) div 2;
    th := (R.Bottom - R.Top - TextHeight(temp)) div 2;
    temp := Copy(temp,1,Pos('us',temp)-1);
    TextOut(R.Left+tw,R.Top+th,temp);
    tw := tw + TextWidth(temp);
    Font.Charset := SYMBOL_CHARSET;
    Font.Name := 'Symbol';
    TextOut(R.Left+tw,R.Top+th,chr(109));
    tw := tw + TextWidth(chr(109));
    Font.Charset := ANSI_CHARSET;
    Font.Name := 'Arial';
    TextOut(R.Left+tw+1,R.Top+th,'s');
  end;
end;

procedure PicRTyp(Txt: String;F: TFont;bmp: TBitmap);
  procedure SymFontx(S: String;Sym: Boolean);
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
            SymFontx(hk1,True) else SymFontx(hk1,False);
          if hk1 = 'ec' then begin hk1 := 'e'; Inc(tw2); Dec(th); end;
          if (hk2 <> '') then
          begin
            TextOut(tw2-2,th,hk1);
            if (StringIndex(hk2,RTyp) > -1) then
              SymFontx(hk2,True) else SymFontx(hk2,False);
            if hk2 = 'ec' then hk2 := 'e';
            if hk2 = 'xa' then hk2 := chr(180)+'a';
            TextOut(tw2+TextWidth(hk1)-1,th,','+hk2);
          end else TextOut(tw2,th,hk1);
        end;
        if StringIndex(vk1,RTyp) > -1 then
          SymFontx(vk1,True) else SymFontx(vk1,False);
        if vk1 = 'ec' then begin vk1 := 'e'; Inc(tw1); Dec(th); end;
        if Pos('b',vk1) > 0 then Inc(tw1);
        if (vk2 <> '') then
        begin
          TextOut(tw1+1,th,vk1);
          if (StringIndex(vk2,RTyp) > -1) then
            SymFontx(vk2,True) else SymFontx(vk2,False);
          if vk2 = 'ec' then vk2 := 'e';
          if vk2 = 'xa' then vk2 := chr(180)+'a';
          TextOut(tw1+TextWidth(vk1),th,','+vk2);
        end else TextOut(tw1,th,vk1);
      end;
    end;
  end;
  List.Free;
end;

procedure PosText(Canv: TCanvas;F: TFont;R: TRect;txt: String);
var
  temp,vk,hk,uk: String;
  vi,hi,ui,th: Integer;
begin
  vk := ''; hk := ''; uk := '';
  temp := txt;
  if Pos(DM.DezS,temp) > 0 then
  begin
    vk := Copy(temp,1,Pos(DM.DezS,temp)-1);
    Delete(temp,1,Pos(DM.DezS,temp)-1);
    if Pos('  ',temp) > 0 then
    begin
      hk := Copy(temp,1,Pos('  ',temp)-1);
      Delete(temp,1,Pos('  ',temp)-1);
      uk := Trim(temp);
    end else hk := temp;
  end
  else if Pos('E',temp) > 0 then
  begin
    vk := Copy(temp,1,Pos('E',temp)-1);
    Delete(temp,1,Pos('E',temp)-1);
    if Pos('  ',temp) > 0 then
    begin
      hk := Copy(temp,1,Pos('  ',temp)-1);
      Delete(temp,1,Pos('  ',temp)-1);
      uk := Trim(temp);
    end else hk := Trim(temp);
  end
  else if Pos('  ',temp) > 0 then
  begin
    vk := Copy(temp,1,Pos('  ',temp)-1);
    Delete(temp,1,Pos('  ',temp)-1);
    uk := Trim(temp);
  end else vk := temp;
  with Canv do
  begin
    Font := F;
    Font.Size := 10;
    if vk = '' then
      th := (R.Bottom - R.Top - TextHeight(hk)) div 2
    else th := (R.Bottom - R.Top - TextHeight(vk)) div 2;
    hi := ((R.Right - R.Left) div 2) - 30;
    if (Pos('Keine',vk) > 0) or (Pos('Daten',vk) > 0) or (Pos('vorh',vk) > 0) then
      vi := (R.Right - R.Left - TextWidth(vk)) div 2
    else if (Pos('E',vk) > 0) and (hk = '') then
      vi := hi - TextWidth('0')
    else vi := hi - TextWidth(vk);
    ui := R.Right - R.Left - TextWidth(uk) - 35;
    TextOut(R.Left+vi,R.Top+th,vk);
    if hk <> '' then
      if Pos('E',hk) > 0 then
      begin
        if hk[1] = 'E' then
        begin
          Delete(hk,1,1);
          TextOut(R.Left+hi,R.Top+th,'x10');
          hi := hi + TextWidth('x10');
        end
        else
        begin
          temp := Copy(hk,1,Pos('E',hk)-1);
          Delete(hk,1,Pos('E',hk));
          TextOut(R.Left+hi,R.Top+th,temp+'x10');
          hi := hi + TextWidth(temp+'x10');
        end;
        Font.Style := [];
        Font.Size := 6;
        TextOut(R.Left+hi,R.Top+2,hk);
        Font := F;
        Font.Size := 10;
        Font.Style := [fsBold];
      end else TextOut(R.Left+hi,R.Top+th,hk);
    if uk <> '' then
    begin
      Font.Style := [fsItalic];
      Font.Size := 8;
      TextOut(R.Left+ui,R.Top+th,uk);
    end;
  end;
end;

procedure Potenz(Canv: TCanvas;F: TFont;R: TRect;txt: String);
var
  tw,th,tp: Integer;
  temp,pot: String;
begin
  with Canv do
  begin
    Font := F;
    pot := '';
    tw := (R.Right - R.Left - TextWidth(txt)) div 2;
    th := (R.Bottom - R.Top - TextHeight(txt)) div 2;
    if R.Bottom - R.Top - TextHeight(txt) = 1 then tp := -2
    else if R.Bottom - R.Top - TextHeight(txt) = -1 then tp := -1
    else if R.Bottom - R.Top - TextHeight(txt) = 7 then tp := 2
    else tp := 2;
    temp := Copy(txt,1,Pos('E',txt)-1);
    TextOut(R.Left+tw,R.Top+th,temp + 'x10');
    tw := tw + TextWidth(temp + 'x10')+1;
    temp := txt;
    Delete(temp,1,Pos('E',temp));
    if Pos(#32,temp) > 0 then
    begin
      pot := Copy(temp,1,Pos(#32,temp)-1);
      Delete(temp,1,Pos(#32,temp));
    end else begin pot := temp; temp := ''; end;
    Font.Charset := ANSI_CHARSET;
    Font.Name := 'Arial';
    Font.Style := [];
    Font.Size := 6;
    TextOut(R.Left+tw,R.Top+tp,pot);
    Font := F;
    Font.Size := 8;
    Font.Style := [fsBold];
    tw := tw + TextWidth(pot);
    if temp <> '' then TextOut(R.Left+tw,R.Top+th,temp);
  end;
end;

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

function  SFilter(a1,a2,z,n1,n2:Integer;th1,th2: Double): String;
var
  Bab,Ba1,Bz,Bnb,Bn1,Bthb,Bth1: Boolean;
  Sa,Sa1,Sa2,Sz,Sn,Sn1,Sn2,Sth,Sth1,Sth2: String;
begin
  Ba1 := (a1 > 0);
  Bab := (a1 > 0) and (a2 > a1);
  Bz := (z > 0);
  Bn1 := (n1 > 0);
  Bnb := (n1 > 0) and (n2 > n1);
  Bth1 := (th1 > 0);
  Bthb := (th1 >= 0) and (th2 > th1);
  Sa := '(A = ' + IntToStr(a1) + ')';
  Sa1 := '(A >= ' + IntToStr(a1) + ')';
  Sa2 := '(A <= ' + IntToStr(a2) + ')';
  Sz := '(Z = ' + IntToStr(z) + ')';
  Sn := '(N = ' + IntToStr(n1) + ')';
  Sn1 := '(N >= ' + IntToStr(n1) + ')';
  Sn2 := '(N <= ' + IntToStr(n2) + ')';
  Sth := '(Tsek = ' + FloatToStr(th1) + ')';
  Sth1 := '(Tsek >= ' + FloatToStr(th1) + ')';
  Sth2 := '(Tsek <= ' + FloatToStr(th2) + ')';
  if Bz and not Ba1 and not Bn1 and not Bth1 and not Bthb then
    Result := 'Z = ' + IntToStr(z)                              // nur Z
  else if Ba1 and not Bab and not Bz and not Bn1 and not Bth1 and not Bthb then
    Result := 'A = ' + IntToStr(a1)                             // nur a1
  else if Bab and not Bz and not Bn1 and not Bth1 and not Bthb then
    Result := Sa1 + ' AND ' + Sa2                               // nur a1+a2
  else if Bn1 and not Bnb and not Bz and not Ba1 and not Bth1 and not Bthb then
    Result := 'N = ' + IntToStr(n1)                             // nur n1
  else if Bnb and not Bz and not Ba1 and not Bth1 and not Bthb then
    Result := Sn1 + ' AND ' + Sn2                               // nur n1+n2
  else if Bth1 and not Bthb and not Bz and not Ba1 and not Bn1 then
    Result := 'Tsek = ' + FloatToStr(th1)                       // nur th1
  else if Bthb and not Ba1 and not Bz and not Bn1 then
    Result := Sth1 + ' AND ' + Sth2                             // nur th1+th2
  else if Ba1 and not Bab and Bz and not Bth1 and not Bthb then
    Result := Sa + ' AND ' + Sz                                 // z+a1
  else if Bn1 and not Bnb and Bz and not Ba1 and not Bth1 and not Bthb then
    Result := Sz + ' AND ' + Sn                                 // z+n1
  else if Bth1 and not Bthb and Bz and not Ba1 and not Bn1 then
    Result := Sz + ' AND ' + Sth                                // z+th1
  else if Ba1 and not Bab and Bn1 and not Bnb and not Bz and not Bth1 and not Bthb then
    Result := Sa + ' AND ' + Sn                                 // a1+n1
  else if Ba1 and not Bab and not Bn1 and not Bnb and not Bz and Bth1 and not Bthb then
    Result := Sa + ' AND ' + Sth                                // a1+th1
  else if Ba1 and not Bab and not Bn1 and not Bnb and not Bz and Bthb then
    Result := Sa + ' AND ' + Sth1 + ' AND ' + Sth2              // a1+th1+th2
  else if Bn1 and not Bnb and not Ba1 and not Bab and not Bz and Bth1 and not Bthb then
    Result := Sn + ' AND ' + Sth                                // n1+th1
  else if Bn1 and not Bnb and not Ba1 and not Bab and not Bz and Bthb then
    Result := Sn + ' AND ' + Sth1 + ' AND ' + Sth2              // n1+th1+th2
  else if Bnb and not Ba1 and not Bab and not Bz and Bthb then  // n1+n2+th1+th2
    Result := Sn1 + ' AND ' + Sn2 + ' AND ' + Sth1 + ' AND ' + Sth2
  else if Bab and Bz and not Bth1 and not Bthb then
    Result := Sa1 + ' AND ' + Sa2 + ' AND ' + Sz                // z+a1+a2
  else if Bnb and Bz and not Ba1 and not Bth1 and not Bthb then
    Result := Sz + ' AND ' + Sn1 + ' AND ' + Sn2                // z+n1+n2
  else if Bthb and Bz and not Ba1 and not Bn1 then
    Result := Sz + ' AND ' + Sth1 + ' AND ' + Sth2              // z+th1+th2
  else if Bab and Bn1 and not Bnb and not Bz and not Bth1 and not Bthb then
    Result := Sa1 + ' AND ' + Sa2 + ' AND ' + Sn                // a1+a2+n1
  else if Bab and Bnb and not Bz and not Bth1 and not Bthb then // a1+a2+n1+n2
    Result := Sa1 + ' AND ' + Sa2 + ' AND ' + Sn1 + ' AND ' + Sn2
  else if Bab and Bz and Bth1 and not Bthb then                 // a1+a2+z+th1
    Result := Sa1 + ' AND ' + Sa2 + ' AND ' + Sz + ' AND ' + Sth
  else if Bab and Bz and Bthb then                           // a1+a2+z+th1+th2
    Result := Sa1 + ' AND ' + Sa2 + ' AND ' + Sz + ' AND ' + Sth1 + ' AND ' + Sth2
  else if Bab and Bn1 and not Bnb and not Bz and Bth1 and not Bthb then
    Result := Sa1 + ' AND ' + Sa2 + ' AND ' + Sn + ' AND ' + Sth // a1+a2+n1+th1
  else if Bab and Bn1 and not Bnb and not Bz and Bthb then  // a1+a2+n1+th1+th2
    Result := Sa1 + ' AND ' + Sa2 + ' AND ' + Sn + ' AND ' + Sth1 + ' AND ' + Sth2
  else if Bab and Bnb and not Bz and Bthb then            // a1+a2+n1+n2+th1+th2
    Result := Sa1 + ' AND ' + Sa2 + ' AND ' + Sn1 + ' AND ' + Sn2 + ' AND ' +
    Sth1 + ' AND ' + Sth2
  else if Bab and not Bnb and not Bz and Bthb then  // a1+a2+th1+th2
    Result := Sa1 + ' AND ' + Sa2 + ' AND ' + Sth1 + ' AND ' + Sth2
  else Result := '';
end;

function  StringIndex(such: string; aus: array of string):Integer;
begin
  for Result := High(aus) downto 0 do
    if AnsiSameText(such, aus[Result]) then Break;
end;

procedure SymFont(Canv: TCanvas;Sym: Boolean);
begin
  with Canv do
    if Sym then
    begin
      Font.Charset := SYMBOL_CHARSET;
      Font.Name := 'Symbol';
      Font.Size := 10;
    end
    else
    begin
      Font.Charset := ANSI_CHARSET;
      Font.Name := 'Arial';
      Font.Size := 8;
    end;
end;

procedure TextUpDown(Canv: TCanvas;F: TFont;R: TRect;txt: String;Ptxt: Integer);
const RTyp: array[1..5] of String =('a','b','g','h','e');
var
  i,tw,th: Integer;
  temp,to1,to2,tu1,tu2: String;
begin
  to1 := ''; to2 := ''; tu1 := ''; tu2 := '';
  temp := txt;
  if Pos('_',temp) > 0 then
  begin
    to1 := Copy(temp,1,Pos('_',temp)-1);
    Delete(temp,1,Pos('_',temp));
    if Pos('^',temp) > 0 then
    begin
      tu1 := Copy(temp,1,Pos('^',temp)-1);
      Delete(temp,1,Pos('^',temp));
      if Pos('_',temp) > 0 then
      begin
        to2 := Copy(temp,1,Pos('_',temp)-1);
        Delete(temp,1,Pos('_',temp));
        tu2 := temp;
      end else to2 := temp;
    end else tu1 := temp;
  end;
  with Canv do
  begin
    Font := F;
    th := (R.Bottom - R.Top - TextHeight(to1)) div 2;
    tw := TextWidth(to1);
    if to1 = 'vorhanden' then
    begin
      TextOut(R.Left+tw,R.Top+th,to1);
      Exit;
    end;
    tw := Ptxt;
    TextOut(R.Left+tw,R.Top+th,to1);
    tw := tw + TextWidth(to1);
    if Pos('l',tu1) > 0 then Font.Style := [fsBold,fsItalic];
    if tu1 = 'ec' then tu1 := 'e';
    for i := 1 to 5 do
      if Pos(RTyp[i],tu1) > 0 then
      begin
        SymFont(Canv,True);
        Break;
      end;
    if Font.Name <> 'Symbol' then Font.Size := 8;
    TextOut(R.Left+tw+1,R.Top+th+4,tu1);
    SymFont(Canv,False);
    tw := tw + TextWidth(tu1);
    Font.Size := 10;
    if to2 <> '' then TextOut(R.Left+tw,R.Top+th,to2);
    tw := tw + TextWidth(to2);
    Font.Size := 8;
    if tu2 <> '' then TextOut(R.Left+tw,R.Top+th+4,tu2);
  end;
end;

procedure Tief(Canv: TCanvas;F: TFont;R: TRect;txt: String);
begin
  //
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
    //1..5: Result := FloatToStr(d);
    4..10: Result := FloatToStrF(d,ffGeneral,AnzNKS,2);
    11..20: Result := FloatToStrF(d,ffGeneral,AnzNKS,2);
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
    Result := FloatToStrF(Value*1000000,ffGeneral,4,2) + ' us'      // 10-6
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

procedure Zuviele(anz: Integer;txt: String);
begin
  MessageDlg('Es wurden ' +
    IntToStr(anz) + ' ''' + txt + ''' gefunden!' + #13#10 +
    'Es k�nnen nur bis etwa 1200 Eintr�ge angezeigt werden.' + #13#10 + #13#10 +
    'Bitte schr�nken Sie Ihre Suche entsprechend ein!',mtWarning, [mbOK], 0);
end;

end.
