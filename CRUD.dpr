program CRUD;

uses
  Vcl.Forms,
  UCad_Aluno in 'UCad_Aluno.pas' {frm_CRUD};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_CRUD, frm_CRUD);
  Application.Run;
end.
