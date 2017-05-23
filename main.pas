unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Buttons, StdCtrls, process, about, LCLIntf;

type

  { Tf_main }

  Tf_main = class(TForm)
    aProcess: TProcess;
    b_open: TBitBtn;
    b_comp: TBitBtn;
    b_info: TBitBtn;
    b_quit: TBitBtn;
    weblink: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog: TOpenDialog;
    procedure b_compClick(Sender: TObject);
    procedure b_infoClick(Sender: TObject);
    procedure b_openClick(Sender: TObject);
    procedure b_quitClick(Sender: TObject);
    procedure weblinkClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_main: Tf_main;
  nexe,cmd: string;
  F: File Of char;

implementation

{$R *.lfm}

{ Tf_main }

procedure Tf_main.b_openClick(Sender: TObject);
var
  nom, dir, base: string;
begin
  Memo1.Clear;
  Memo2.Clear;
  // Selecc. y abro el archivo. exe.
  if OpenDialog.Execute then
  begin
    nexe:= OpenDialog.FileName; // Global
    base:= ExtractFilePath(Application.EXEName); // de la aplicacion wcompressor
    Memo1.Lines.Add('');
    Memo1.Lines.Add('Ejecutable cargado (OK)');
    Memo1.Lines.Add('Ruta y Nombre del Archivo: '+nexe);
    dir:= ExtractFilePath(base); {cambiado por base}
    nom:= ExtractFileName(nexe);
    dir:= dir + 'bk_original';
    // Crea o no el directorio de backup!
    if not DirectoryExists(dir) Then CreateDir(dir);
    // Ruta para el nuevo exe
    dir:= dir + '/' + nom;
    // Intento realizar la copia
    try
      CopyFile(nexe, dir);
      AssignFile(F,dir);
      Reset(F);
      //Memo1.Lines.Add('Tamaño Actual: '+IntToStr(FileSize(F)));
      Memo1.Lines.Add('Tamaño ACTUAL del Ejecutable: '+FloatToStrF(FileSize(F)/1048576,ffNumber,4,2)+'MB');
      Memo1.Lines.Add('Copia de seguridad del original (OK)');
      Memo1.Lines.Add('Puede proceder a realizar la compresión.');
      Memo1.Lines.Add('----------------------------------------');
    finally
      CloseFile(F);
    end;
    b_comp.Enabled:= true;
  end;
end;

procedure Tf_main.b_compClick(Sender: TObject);
var
  stripped, final: integer;
  fin: extended; {real super grande 10bytes}
Begin
  // 1er proceso con strip.exe ------------------------------------------
  try
    aProcess:= TProcess.Create(Nil);
    cmd:= 'strip --verbose --strip-all "'+nexe+'"';
    Memo2.Lines.Add('Proceso 1 strip.exe');
    Memo2.Lines.Add(cmd);                          {muestro comando}
    aProcess.Executable:= 'strip';
    aProcess.Parameters.Text:= ' --verbose --strip-all "'+nexe+'"';
    //aProcess.CommandLine:= cmd;
    aProcess.Options:= aProcess.Options + [poWaitOnExit, poNoConsole, poUsePipes];
    Memo2.Lines.Add('Ejecutando ... ');
    aProcess.Execute;
  finally
    aProcess.Free;
  end;
  // Muestro tamaño del archivo con strip
  AssignFile(F,nexe);
  Reset(F);
  stripped:= FileSize(F);
  CloseFile(F);
  Memo2.Lines.Add('Resultado (1): '+IntToStr(stripped));
  Memo2.Lines.Add('--------------------------');
  // 2do proceso UPX.exe ------------------------------------------------
  try
    aProcess:= TProcess.Create(Nil);
    cmd:= 'upx -9 -qv "'+nexe+'"';
    Memo2.Lines.Add('Proceso 2 upx.exe (externo)');
    Memo2.Lines.Add(cmd);                          {muestro comando}
    aProcess.Executable:= 'upx';
    aProcess.Parameters.Text:= ' -9 -qv "'+nexe+'"';
    //aProcess.CommandLine:= cmd;
    aProcess.Options:= aProcess.Options + [poWaitOnExit, poNoConsole, poUsePipes];
    Memo2.Lines.Add('Ejecutando ... ');
    aProcess.Execute;
  finally
    aProcess.Free;
  end;
  // Muestro tamaño del archivo con upx
  AssignFile(F,nexe);
  {$I-} Reset(f); {$I+}
  final:= FileSize(F);
  CloseFile(F);
  Memo2.Lines.Add('Resultado (2): '+IntToStr(final));
  // Msje popup y Aviso Final --------------------------
  fin:= final / 1048576;
  if final < stripped then
    MessageDlg('WCompressor','Compresión completa!'+#13+'El nuevo ejecutable pesa: '
    +FloatToStrF(fin,ffNumber,4,2)+'MB',mtInformation,[mbYes],0);
  Memo2.Lines.Add('--------------------------');
  Memo2.Lines.Add('La tarea se ha completado!');
  Memo2.Lines.Add('Tamaño FINAL del Ejecutable: '+FloatToStrF(fin,ffNumber,6,2)+'MB');
  Memo2.Lines.Add('--------------------------');
  Memo2.Lines.Add('Visita: www.webscom.net');
  b_comp.Enabled:= false;
  // -- FIN -- //
end;

procedure Tf_main.weblinkClick(Sender: TObject);
begin
   OpenURL('http://www.webscom.net');
end;

procedure Tf_main.b_infoClick(Sender: TObject);
begin
  f_about.ShowModal;
end;

procedure Tf_main.b_quitClick(Sender: TObject);
begin
  close;
end;

end.

