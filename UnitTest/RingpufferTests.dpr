{*****************************************************************************
  The CircularBuffer team (see file NOTICE.txt) licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License. A copy of this licence is found in the root directory of
  this project in the file LICENCE.txt or alternatively at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
*****************************************************************************}
program RingpufferTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Vcl.Forms,
  {$IFDEF TESTINSIGHT}
  TestInsight.Client,
  TestInsight.DUnit,
  {$ELSE}
  TestFramework,
  {$ENDIF }
  TestRingbuffer in 'TestRingbuffer.pas',
  Ringbuffer in '..\Source\Ringbuffer.pas';

{$R *.RES}

function IsTestInsightRunning: Boolean;
{$IFDEF TESTINSIGHT}
var
  client: ITestInsightClient;
begin
  client := TTestInsightRestClient.Create;
  client.StartedTesting(0);
  Result := not client.HasError;
end;
{$ELSE}
begin
  result := false;
end;
{$ENDIF}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;

  if IsTestInsightRunning then
    {$IFDEF TESTINSIGHT}
    TestInsight.DUnit.RunRegisteredTests
    {$ENDIF}
  else
    {$IFNDEF TESTINSIGHT}
    if IsConsole then
      TextTestRunner.RunRegisteredTests.Free
    else
      GUITestRunner.RunRegisteredTests;
    {$ENDIF}
end.
