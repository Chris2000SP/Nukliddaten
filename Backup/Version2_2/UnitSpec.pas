unit UnitSpec;

interface

uses Windows, Types, Classes, SysUtils, Math, Graphics, Dialogs, DB, EasyTable,
     SpecLib, JvgListBox;

  procedure SpecKonf;
  procedure UpdateImage(Z: Integer;txt: String;Erste: Boolean);

implementation

  uses UnitMain, UnitDM;

procedure SpecKonf;
var
  i,tw,w: Integer;
  cl: TColor;
  R,G,B: Byte;
  bmp: TBitmap;
begin
  with frmMain do
  begin
    lblSpecTitel.Left := ImSpecAbs.Left + (ImSpecAbs.Width - lblSpecTitel.Width) div 2;
    GridSpecPSE.RowHeights[7] := 10;
    lblSpecElem.Left := ImSpecAbs.Left + (ImSpecAbs.Width - lblSpecElem.Width) div 2;
    lblSpecAb.Left := ImSpecAbs.Left + (ImSpecAbs.Width - lblSpecAb.Width) div 2;
    lblSpecEm.Left := ImSpecEm.Left + (ImSpecEm.Width - lblSpecEm.Width) div 2;
    ImSpecAbScale.Width := ImSpecAbs.Width + 40;
    ImSpecAbScale.Left := ImSpecAbs.Left-20;
    ImSpecEmScale.Width := ImSpecAbScale.Width;
    ImSpecEmScale.Left := ImSpecAbScale.Left;
    bmp := TBitmap.Create;
    try
      bmp.Width := ImSpecAbScale.Width;
      bmp.Height := ImSpecAbScale.Height;
      with bmp.Canvas do
      begin
        Font.Charset := ANSI_CHARSET;
        Font.Name := 'Arial';
        for i := 0 to 6 do
        begin
          if i = 0 then w := 0 else w := ImSpecAbs.Width div 6;
          tw := TextWidth(IntToStr((i*50)+400) + ' nm') div 2;
          if i = 6 then
          begin
            MoveTo(ImSpecAbs.Width+19,0);
            LineTo((i*w)+19,10);
            TextOut(ImSpecAbs.Width+20-tw,10,IntToStr((i*50)+400) + ' nm');
          end
          else
          begin
            MoveTo((i*w)+20,0);
            LineTo((i*w)+20,10);
            TextOut((i*w)+20-tw,10,IntToStr((i*50)+400) + ' nm');
          end;
        end;
      end;
      ImSpecAbScale.Picture.Graphic := bmp;
      ImSpecEmScale.Picture.Graphic := bmp;
    finally
      bmp.Free;
    end;
    lblnm.Caption  := ' = ' + IntToStr(400) + ' nm';
    lblTHz.Caption := 'f = ' + IntToStr(Round(WavelengthToFrequency(400))) + ' THz';
    WavelengthToRGB(400, R,G,B);
    cl := RGB(R,G,B);
    ShapeSpec.Brush.Color := cl;
  end;
end;

procedure UpdateImage(Z: Integer;txt: String;Erste: Boolean);
type
  TRGBTripleArray = array[Word] of TRGBTriple;
  pRGBTripleArray = ^TRGBTripleArray;
var
  i,index,j: Integer;
  B,G,R: Byte;
  wavel: Double;
  BlueWavelength,RedWavelength,Wavelength: Nanometers;
  flags:  pByteArray;
  Row:  pRGBTripleArray;
  BmpSpecAb,BmpSpecEm: TBitmap;
begin
  BmpSpecAb := TBitmap.Create;
  BmpSpecAb.Width  := frmMain.ImSpecAbs.Width;
  BmpSpecAb.Height := frmMain.ImSpecAbs.Height;
  BmpSpecAb.PixelFormat := pf24bit;
  BmpSpecEm := TBitmap.Create;
  BmpSpecEm.Width  := frmMain.ImSpecEm.Width;
  BmpSpecEm.Height := frmMain.ImSpecEm.Height;
  BmpSpecEm.PixelFormat := pf24bit;
  BlueWavelength := 400;
  RedWavelength  := 700;
  if Erste then
    for i := 1 to 5 do
    begin
      frmMain.ChLB.Checked[i] := False;
      frmMain.ChLB.ItemEnabled[i] := False;
      //frmMain.ChLB.State[i] := cbGrayed;
    end;
  GetMem(flags, frmMain.ImSpecAbs.Width);
  for i := 0 to frmMain.ImSpecAbs.Width-1 do flags[i] := 0;
  i := 0;
  DM.ETSpec.Filter := 'Z = '+ IntToStr(Z);
  if DM.ETSpec.FindFirst then
  repeat
    if Erste or frmMain.ChLB.Checked[DM.ETSpec.FieldByName('Phase').AsInteger] then
    begin
      wavel := DM.ETSpec.FieldByName('WaveL').AsFloat / 10;
      index := Round((frmMain.ImSpecAbs.Width-1) *
                     (wavel - BlueWavelength) / (RedWavelength - BlueWavelength));
      if (index >= 0) and (index < frmMain.ImSpecAbs.Width) then flags[index] := 1;
    end;
    frmMain.ChLB.ItemEnabled[DM.ETSpec.FieldByName('Phase').AsInteger] := True;
    Inc(i);
  until DM.ETSpec.FindNext = False;
  DM.ETSpec.Filter := '';
  if i = 0 then
    frmMain.lblSpecNo.Caption := 'Keine Spektraldaten für ' + txt + ' vorhanden'
  else frmMain.lblSpecNo.Caption := '';
  if Erste then
    for i := 1 to 5 do
      if frmMain.ChLB.ItemEnabled[i] then frmMain.ChLB.Checked[i] := True;
  for i := 0 to BmpSpecAb.Width-1 do
  begin
    Wavelength := BlueWavelength +
                  (RedWavelength-BlueWavelength) * i / BmpSpecAb.Width;
    WavelengthToRGB(Wavelength, R,G,B);
    if flags[i] = 1 then
    begin
      R := 0;
      G := 0;
      B := 0
    end;
    for j := 0 to BmpSpecAb.Height-1 do
    begin
      Row := BmpSpecAb.Scanline[j];
      with Row[i] do
      begin
        rgbtRed   := R;
        rgbtGreen := G;
        rgbtBlue  := B
      end;
    end;
  end;
  for i := 0 to BmpSpecEm.Width-1 do
  begin
    Wavelength := BlueWavelength +
                  (RedWavelength-BlueWavelength) * i / BmpSpecAb.Width;
    WavelengthToRGB(Wavelength, R,G,B);
    if flags[i] = 0 then
    begin
      R := 0;
      G := 0;
      B := 0
    end;
    for j := 0 to BmpSpecEm.Height-1 do
    begin
      Row := BmpSpecEm.Scanline[j];
      with Row[i] do
      begin
        rgbtRed   := R;
        rgbtGreen := G;
        rgbtBlue  := B
      end;
    end;
  end;
  frmMain.ImSpecAbs.Picture.Graphic := BmpSpecAb;
  frmMain.ImSpecEm.Picture.Graphic := BmpSpecEm;
  FreeMem(Flags);
  BmpSpecAb.Free;
  BmpSpecEm.Free;
end;

end.
