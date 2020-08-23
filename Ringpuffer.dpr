program Ringpuffer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Ringbuffer in 'Ringbuffer.pas';

begin
  try
    { TODO -oUser -cConsole Main : Code hier einfügen }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
