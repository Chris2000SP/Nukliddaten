unit SpecLib;

interface

  type
    NanoMeters = DOUBLE;
    TeraHertz  = DOUBLE;

  const
    SpeedOfLight {c}  = 2.9979E8 {m/s};
    WavelengthMinimum = 380;  // Nanometers
    WavelengthMaximum = 780;


  procedure WavelengthToRGB(const Wavelength:  Nanometers; var R,G,B:  Byte);
  procedure FrequencyToRGB(const Frequency:  TeraHertz; var R,G,B:  Byte);
  function WavelengthToFrequency(const lambda:  NanoMeters):  TeraHertz;
  function FrequencyToWavelength(const frequency:  TeraHertz):  NanoMeters;
  function RGBtoString(const R,G,B: BYTE): String;

implementation

uses SysUtils, Math;


// Adapted from www.isc.tamu.edu/~astro/color.html
procedure WavelengthToRGB(const Wavelength:  Nanometers; var R,G,B:  Byte);
const
  Gamma        = 0.80;
  IntensityMax = 255;

var Blue,factor,Green,Red:  Double;

  function Adjust(const Color, Factor: Double): Integer;
  begin
    if   Color = 0.0 then
      Result := 0     // Don't want 0^x = 1 for x <> 0
    else Result := Round(IntensityMax * Power(Color * Factor, Gamma));
  end;
begin
  case Trunc(Wavelength) of
   380..439: begin
               Red   := -(Wavelength - 440) / (440 - 380);
               Green := 0.0;
               Blue  := 1.0
             end;
   440..489: begin
               Red   := 0.0;
               Green := (Wavelength - 440) / (490 - 440);
               Blue  := 1.0
             end;
   490..509: begin
               Red   := 0.0;
               Green := 1.0;
               Blue  := -(Wavelength - 510) / (510 - 490)
             end;
   510..579: begin
               Red   := (Wavelength - 510) / (580 - 510);
               Green := 1.0;
               Blue  := 0.0
             end;
   580..644: begin
               Red   := 1.0;
               Green := -(Wavelength - 645) / (645 - 580);
               Blue  := 0.0
             end;
   645..780: begin
               Red   := 1.0;
               Green := 0.0;
               Blue  := 0.0
             end;
   else begin
          Red   := 0.0;
          Green := 0.0;
          Blue  := 0.0;
        end;
  end;

 // Let the intensity fall off near the vision limits
 case Trunc(Wavelength) of
   380..419:  factor := 0.3 + 0.7*(Wavelength - 380) / (420 - 380);
   420..700:  factor := 1.0;
   701..780:  factor := 0.3 + 0.7*(780 - Wavelength) / (780 - 700)
   else       factor := 0.0
 end;

 R := Adjust(Red,   Factor);
 G := Adjust(Green, Factor);
 B := Adjust(Blue,  Factor)
end; 

procedure FrequencyToRGB(const Frequency:  TeraHertz; var R,G,B:  Byte);
begin
  WavelengthToRGB(FrequencyToWavelength(Frequency), R,G,B);
end;

// frequency * wavelength = SpeedOfLight
// frequency = c / lambda =
//             2.9979E8 m/s / [ lambda [nm] * [1 meter / 1E9 nm] ]
//                          * [1 THz / 1E12 Hz]
//           = (2.9979E8 m/s / lambda [nm]) * 1E-3  [THz]
function WavelengthToFrequency(const lambda:  NanoMeters):  TeraHertz;
begin
   Result := SpeedOfLight * 1E-3 / lambda;
end;

// frequency * wavelength = SpeedOfLight
// wavelength = c / frequency =
//             2.9979E8 m/s / [ frequency [THz] * [1E12 Hz / 1 THz] ]
//                          * [1E9 nm / m]
//           = (2.9979E8 m/s / f [THz]) * 1E-3
function FrequencyToWavelength(const frequency:  TeraHertz):  NanoMeters;
begin
   Result := SpeedOfLight * 1E-3 / frequency;
end;

function RGBtoString(const R,G,B: BYTE): String;
begin
  Result := 'R=' + IntToStr(R) + '  G=' + IntToStr(G) + '  B=' + IntToSTr(B);
end;

end.
