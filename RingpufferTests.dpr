program RingpufferTests;
{

  Delphi DUnit-Testprojekt
  -------------------------
  Dieses Projekt enthält das DUnit-Test-Framework und die GUI/Konsolen-Test-Runner.
  Fügen Sie den Bedingungen in den Projektoptionen "CONSOLE_TESTRUNNER" hinzu,
  um den Konsolen-Test-Runner zu verwenden.  Ansonsten wird standardmäßig der
  GUI-Test-Runner verwendet.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Ringbuffer in 'Ringbuffer.pas',
  DUnitTestRunner,
  TestRingbuffer in 'TestRingbuffer.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := true;

  DUnitTestRunner.RunRegisteredTests;
end.

