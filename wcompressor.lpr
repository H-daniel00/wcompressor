program wcompressor;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, about
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='WCompressor v1.0 by webscom.com.ar';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tf_main, f_main);
  Application.CreateForm(Tf_about, f_about);
  Application.Run;
end.

