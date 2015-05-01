unit UCad_Aluno;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, Datasnap.Provider,
  Datasnap.DBClient, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  Tfrm_CRUD = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edt_matricula: TEdit;
    edt_nome: TEdit;
    edt_curso: TEdit;
    btn_anterior: TButton;
    btn_salvar: TButton;
    btn_proximo: TButton;
    btn_cancelar: TButton;
    btn_adicionar: TButton;
    btn_editar: TButton;
    btn_excluir: TButton;
    DBGrid1: TDBGrid;
    FDConnection1: TFDConnection;
    qr_aluno: TFDQuery;
    ds_aluno: TDataSource;
    cds_aluno: TClientDataSet;
    dsp_aluno: TDataSetProvider;
    cds_alunomatricula: TWideStringField;
    cds_alunonome: TWideStringField;
    cds_alunocurso: TWideStringField;
    qr_CRUD: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure btn_adicionarClick(Sender: TObject);
    procedure btn_editarClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure btn_anteriorClick(Sender: TObject);
    procedure btn_proximoClick(Sender: TObject);
    procedure ds_alunoDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
   operacao : string;
   procedure limpacampos;
   procedure preenchecampos;
   procedure persistedados;
   procedure habilitacampos(status : boolean);
   procedure excluirregistro;

    { Public declarations }
  end;

var
  frm_CRUD: Tfrm_CRUD;

implementation

{$R *.dfm}

{ Tfrm_CRUD }

procedure Tfrm_CRUD.btn_adicionarClick(Sender: TObject);
begin
 operacao := 'adicionar';
 habilitacampos(true);
 limpacampos; 
 edt_matricula.SetFocus;
end;

procedure Tfrm_CRUD.btn_anteriorClick(Sender: TObject);
begin
 cds_aluno.Prior;
 preenchecampos;
end;

procedure Tfrm_CRUD.btn_cancelarClick(Sender: TObject);
begin
 habilitacampos(false);
end;

procedure Tfrm_CRUD.btn_editarClick(Sender: TObject);
begin
 operacao := 'editar';
 habilitacampos(true);
 edt_nome.SetFocus;
end;

procedure Tfrm_CRUD.btn_excluirClick(Sender: TObject);
begin
 operacao := 'excluir';
 if Application.MessageBox('Deseja excluir o registro?','Aten��o',MB_YESNO) = IDYES then
  begin
   excluirregistro;
   preenchecampos;
   habilitacampos(false);
  end;
end;

procedure Tfrm_CRUD.btn_proximoClick(Sender: TObject);
begin
 cds_aluno.Next;
 preenchecampos;
end;

procedure Tfrm_CRUD.btn_salvarClick(Sender: TObject);
begin
 persistedados;
 qr_aluno.Locate('matricula',edt_matricula.Text,[]);
 preenchecampos;
 operacao := '';
 habilitacampos(false);
end;

procedure Tfrm_CRUD.ds_alunoDataChange(Sender: TObject; Field: TField);
begin
 preenchecampos;
end;

procedure Tfrm_CRUD.excluirregistro;
begin
 with qr_CRUD do
  begin
   close;
   SQL.Clear;
   SQL.Add('DELETE FROM aluno where matricula = :matricula');

   ParamByName('matricula').AsString := edt_matricula.Text;

   try
    ExecSQL();  
    qr_aluno.Refresh;
    cds_aluno.Refresh;
   except on E: Exception do
    begin
      ShowMessage('Erro na exclus�o');
      Exit;
    end;
   end;
   
  end;
end;

procedure Tfrm_CRUD.FormCreate(Sender: TObject);
begin
 qr_aluno.Open;
 cds_aluno.Open;
 preenchecampos;
 habilitacampos(false);
end;

procedure Tfrm_CRUD.habilitacampos(status: boolean);
begin
 if operacao = 'editar' then
  begin
   edt_matricula.Enabled := not status;
  end
 else
  begin
    edt_matricula.Enabled := status;
  end;

  edt_nome.Enabled      := status;
  edt_curso.Enabled     := status;

  btn_salvar.Enabled    := status;
  btn_cancelar.Enabled  := status;
  btn_anterior.Enabled  := not status;
  btn_proximo.Enabled   := not status;
  btn_adicionar.Enabled := not status;
  btn_editar.Enabled    := not status;
  btn_excluir.Enabled   := not status;

end;

procedure Tfrm_CRUD.limpacampos;
begin
 edt_matricula.Clear;
 edt_nome.Clear;
 edt_curso.Clear;
end;

procedure Tfrm_CRUD.persistedados;
begin

 with qr_CRUD do
  begin
   close;
   SQL.Clear;

   if operacao = 'adicionar' then
    begin
     SQL.Add('INSERT INTO aluno (matricula, nome, curso) values (:matricula, :nome, :curso)');
    end
   else
    begin
      if operacao = 'editar' then
       begin
        SQL.Add('UPDATE aluno set nome = :nome, curso = :curso where matricula = :matricula');
       end;
    end;
    ParamByName('matricula').AsString   := edt_matricula.Text;
    ParamByName('nome').AsString        := edt_nome.Text;
    ParamByName('curso').AsString       := edt_curso.Text;

    try
     ExecSQL(); 
     qr_aluno.Refresh;
     cds_aluno.Refresh;
    except on E: Exception do
     begin
       ShowMessage('Error na opera��o.');
       Exit;
     end;
    end;

  end;


end;

procedure Tfrm_CRUD.preenchecampos;
begin
 edt_matricula.Text := cds_alunomatricula.AsString;
 edt_nome.Text := cds_alunonome.AsString;
 edt_curso.Text := cds_alunocurso.AsString;
end;

end.
