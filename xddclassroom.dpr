program xddclassroom;

uses
  Vcl.Forms,
  Utimain in 'Utimain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '小叮当教室播报';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
