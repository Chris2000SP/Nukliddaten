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
  UnitAboutBox in 'UnitAboutBox.pas' {AboutBox};

{$R *.res}

begin
  AboutBox := TAboutBox.Create(Application);
  if AboutBox.AppVers then AboutBox.Show;
  AboutBox.Update;
  Application.Initialize;
  Application.Title := 'Nukliddaten';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
