program Nukliddaten;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {frmMain},
  only_one in 'only_one.pas',
  UnitDM in 'UnitDM.pas' {DM: TDataModule},
  UnitNukFunc in 'UnitNukFunc.pas',
  UnitPSE in 'UnitPSE.pas',
  UnitChart in 'UnitChart.pas',
  UnitNuk in 'UnitNuk.pas',
  UnitAboutBox in 'UnitAboutBox.pas' {AboutBox},
  UnitSpec in 'UnitSpec.pas',
  SpecLib in 'SpecLib.pas';

{$R *.res}

begin
  AboutBox := TAboutBox.Create(Application);
  if not AboutBox.geladen and AboutBox.AppVers then
  begin
    AboutBox.Show;
    AboutBox.Update;
  end;
  Application.Initialize;
  Application.Title := 'Nukliddaten';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
