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
unit TestRingbuffer;

interface

uses
  TestFramework, Ringbuffer, SysUtils;

type
  /// <summary>
  ///   Von dieser Klasse sollen alle Ringpuffer Testklassen erben, damit diese
  ///   die Grundlagen des Tests des Benachrichtigungsmechanismus haben.
  /// </summary>
  BaseTestTRingbuffer = class(TTestCase)
  strict protected
    /// <summary>
    ///   Wird ggf. vom OnNotify Event auf true gesetzt
    /// </summary>
    FAdded     : Boolean;
    /// <summary>
    ///   Wird ggf. vom OnNotify Event auf true gesetzt
    /// </summary>
    FRemoved   : Boolean;

    /// <summary>
    ///   Setzt FAdded und FRemoved auf False
    /// </summary>
    procedure ClearEventFlags;
    /// <summary>
    ///   Prüft, ob das richtige Eventflag gesetzt ist
    /// </summary>
    /// <param name="EventType">
    ///   Art des Events: evAdd oder evRemove, das jeweilige Flag muss true sein
    ///   und das andere muss false sein
    /// </param>
    procedure CheckEventFlags(EventType : TRingbufferEventType);
    /// <summary>
    ///   Prüft, ob das richtige Eventflag gesetzt ist und setzt alle Eventflags
    ///   auf false
    /// </summary>
    /// <param name="EventType">
    ///   Art des Events: evAdd oder evRemove, das jeweilige Flag muss true sein
    ///   und das andere muss false sein
    /// </param>
    procedure CheckAndClearEventFlags(EventType: TRingbufferEventType);
    /// <summary>
    ///   Prüft, dass keine der Eventflags gesetzt sind und setzt gesetzte zurück,
    ///   da nachfolgende Tests ja von ungesetzten Flags ausgehen werden
    /// </summary>
    procedure CheckAndClearNoEventFlagsSet;
    /// <summary>
    ///   Dieses Ereignis wird bei allen Operationen ausgelöst, die einen Einfluss
    ///   auf den Füllstand des Ringpuffers haben. Hinzufügen, Entfernen, Löschen...
    /// </summary>
    /// <param name="Count">
    ///   Neue Anzahl der im Puffer befindlichen Elemente
    /// </param>
    /// <param name="Event">
    ///   Art des auslösenden Events: wenn Add wurde der Füllstand erhöht, wenn
    ///   Remove wurde er verringert.
    /// </param>
    procedure OnNotify(Count: UInt32; Event:TRingbufferEventType);
  end;

  // Testmethoden für Klasse TRingbuffer

  TestTRingbuffer = class(BaseTestTRingbuffer)
  strict private
    FRingbuffer: TRingbuffer<Byte>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;

    procedure TestAddWhenEmpty;
    procedure TestAddWrapAround;
    procedure TestAddException;

    procedure TestAddArrayWhenEmpty;
    procedure TestAddArrayWhenEmptyFull;
    procedure TestAddArrayPartiallyFilled;
    procedure TestAddArrayWrap1;
    procedure TestAddArrayWrap3;
    procedure TestAddArrayEndLessStart1;
    procedure TestAddArrayEndLessStart3;
    procedure TestAddArrayEnptyArray;
    procedure TestAddArrayException;

    procedure TestClear;

    procedure TestRemove;
    procedure TestRemoveWrap1;
    procedure TestRemoveWrap3;
    procedure TestRemoveException;
    procedure TestRemoveArray;
    procedure TestRemoveArrayWrap1;
    procedure TestRemoveArrayWrap3;
    procedure TestRemoveArrayException;
    procedure TestRemoveArraySize0;

    procedure TestPeek;
    procedure TestPeekWrap1;
    procedure TestPeekWrap3;
    procedure TestPeekException;
    procedure TestPeekArray;
    procedure TestPeekArrayAfterDelete;
    procedure TestPeekArrayWrap1;
    procedure TestPeekArrayWrap3;
    procedure TestPeekArrayException;
    procedure TestPeekArraySize0;

    procedure TestDelete;
    procedure TestDeleteWrap1;
    procedure TestDeleteWrap3;
    procedure TestDeleteException;
    procedure TestDeleteSize0;
    procedure TestDeleteAll;

    // Tests ohne Benachrichtigungsmechanismus
    procedure TestAddNoNotify;
    procedure TestArrayAddNoNotify;
    procedure TestRemoveNoNotify;
    procedure TestRemoveArrayNoNotify;
    procedure TestDeleteNoNotify;
    procedure TestClearNoNotify;
  end;

  /// <summary>
  ///   Gleiche Tests wie TestTRingbuffer, allerdings mit Integern als Pufferelemente
  /// </summary>
  TestTRingbufferInt = class(BaseTestTRingbuffer)
  strict private
    FRingbuffer: TRingbuffer<Integer>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;

    procedure TestAddWhenEmpty;
    procedure TestAddWrapAround;
    procedure TestAddException;

    procedure TestAddArrayWhenEmpty;
    procedure TestAddArrayWhenEmptyFull;
    procedure TestAddArrayPartiallyFilled;
    procedure TestAddArrayWrap1;
    procedure TestAddArrayWrap3;
    procedure TestAddArrayEndLessStart1;
    procedure TestAddArrayEndLessStart3;
    procedure TestAddArrayEnptyArray;
    procedure TestAddArrayException;

    procedure TestClear;

    procedure TestRemove;
    procedure TestRemoveWrap1;
    procedure TestRemoveWrap3;
    procedure TestRemoveException;
    procedure TestRemoveArray;
    procedure TestRemoveArrayWrap1;
    procedure TestRemoveArrayWrap3;
    procedure TestRemoveArrayException;
    procedure TestRemoveArraySize0;

    procedure TestPeek;
    procedure TestPeekWrap1;
    procedure TestPeekWrap3;
    procedure TestPeekException;
    procedure TestPeekArray;
    procedure TestPeekArrayWrap1;
    procedure TestPeekArrayWrap3;
    procedure TestPeekArrayException;
    procedure TestPeekArraySize0;

    procedure TestDelete;
    procedure TestDeleteWrap1;
    procedure TestDeleteWrap3;
    procedure TestDeleteException;
    procedure TestDeleteSize0;
    procedure TestDeleteAll;

    // Tests ohne Benachrichtigungsmechanismus
    procedure TestAddNoNotify;
    procedure TestArrayAddNoNotify;
    procedure TestRemoveNoNotify;
    procedure TestRemoveArrayNoNotify;
    procedure TestDeleteNoNotify;
    procedure TestClearNoNotify;
  end;

  /// <summary>
  ///   Same tests as TestTRingbuffer, just with strings as elements stored in
  ///   the buffer
  /// </summary>
  TestTRingbufferString = class(BaseTestTRingbuffer)
  strict private
    FRingbuffer: TRingbuffer<string>;
  private
    procedure InitBuffer(var Buffer: TRingbuffer<string>.TRingbufferArray);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;

    procedure TestAddWhenEmpty;
    procedure TestAddWrapAround;
    procedure TestAddException;

    procedure TestAddArrayWhenEmpty;
    procedure TestAddArrayWhenEmptyFull;
    procedure TestAddArrayPartiallyFilled;
    procedure TestAddArrayWrap1;
    procedure TestAddArrayWrap3;
    procedure TestAddArrayEndLessStart1;
    procedure TestAddArrayEndLessStart3;
    procedure TestAddArrayEnptyArray;
    procedure TestAddArrayException;

    procedure TestClear;

    procedure TestRemove;
    procedure TestRemoveWrap1;
    procedure TestRemoveWrap3;
    procedure TestRemoveException;
    procedure TestRemoveArray;
    procedure TestRemoveArrayWrap1;
    procedure TestRemoveArrayWrap3;
    procedure TestRemoveArrayException;
    procedure TestRemoveArraySize0;

    procedure TestPeek;
    procedure TestPeekWrap1;
    procedure TestPeekWrap3;
    procedure TestPeekException;
    procedure TestPeekArray;
    procedure TestPeekArrayWrap1;
    procedure TestPeekArrayWrap3;
    procedure TestPeekArrayException;
    procedure TestPeekArraySize0;

    procedure TestDelete;
    procedure TestDeleteWrap1;
    procedure TestDeleteWrap3;
    procedure TestDeleteException;
    procedure TestDeleteSize0;
    procedure TestDeleteAll;

    // Tests ohne Benachrichtigungsmechanismus
    procedure TestAddNoNotify;
    procedure TestArrayAddNoNotify;
    procedure TestRemoveNoNotify;
    procedure TestRemoveArrayNoNotify;
    procedure TestDeleteNoNotify;
    procedure TestClearNoNotify;
  end;

  /// <summary>
  ///   Einfache Datenhaltungsklasse für die Tests von TObjectRingbuffer
  /// </summary>
  TTestItem = class(TObject)
  public
    Name        : string;
    Age         : Integer;
    AgeChildren : array of Integer;

    constructor Create(Name: string; Age, NumberOfChildren: Integer);
  end;

  /// <summary>
  ///   Testmethoden für Klasse TObjectRingbuffer. Da die Grundlagen bereits in
  ///   den anderen Testklassen getestet werden werden hier nur noch die für die
  ///   Speicherverwaltung nötigen Details getestet.
  /// </summary>
  TestTObjectRingbuffer = class(BaseTestTRingbuffer)
  strict private
    /// <summary>
    ///   Zu testende Objektinstanz. Achtung: OwnsObjects muss bei Bedarf in
    ///   jedem Test selbst gesetzt werden!
    /// </summary>
    FObjectRingbuffer: TObjectRingbuffer<TTestItem>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;

    procedure TestPeek;
    procedure TestRemove;
    procedure TestDelete;
    procedure TestClear;
  end;

implementation

procedure BaseTestTRingbuffer.CheckAndClearEventFlags(EventType: TRingbufferEventType);
begin
  CheckEventFlags(EventType);
  ClearEventFlags;
end;

procedure BaseTestTRingbuffer.CheckAndClearNoEventFlagsSet;
begin
  CheckEquals(false, FAdded,   'Hinzufügen Benachrichtigung fälschlicherweise ausgelöst');
  CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung fälschlicherweise ausgelöst');
  ClearEventFlags;
end;

procedure BaseTestTRingbuffer.CheckEventFlags(EventType: TRingbufferEventType);
begin
  case EventType of
    evAdd    : begin
                 CheckEquals(true,  FAdded,   'Hinzufügen Benachrichtigung nicht ausgelöst');
                 CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung fälschlicherweise ausgelöst');
               end;
    evRemove : begin
                 CheckEquals(false, FAdded,   'Hinzufügen Benachrichtigung fälschlicherweise ausgelöst');
                 CheckEquals(true,  FRemoved, 'Entfernen Benachrichtigung nicht ausgelöst');
               end;
  end;
end;

procedure BaseTestTRingbuffer.ClearEventFlags;
begin
  FAdded   := false;
  FRemoved := false;
end;

procedure BaseTestTRingbuffer.OnNotify(Count: UInt32;
  Event: TRingbufferEventType);
begin
  case Event of
    evAdd    : FAdded   := true;
    evRemove : FRemoved := true;
  end;
end;

{ TestTRingbuffer -------------------------------------------------------------}

procedure TestTRingbuffer.SetUp;
begin
  FRingbuffer        := TRingbuffer<Byte>.Create(5);
  FRingbuffer.Notify := OnNotify;
  ClearEventFlags;
end;

procedure TestTRingbuffer.TearDown;
begin
  FRingbuffer.Free;
  FRingbuffer := nil;
end;

procedure TestTRingbuffer.TestClear;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
begin
  // Puffer teilweise füllen
  for i := 1 to 3 do
    FRingbuffer.Add(i);

  CheckEquals(3, FRingbuffer.Count, 'Falscher Pufferfüllstand');
  CheckAndClearEventFlags(evAdd);

  // und leeren
  FRingbuffer.Clear;
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nun leer sein');
  CheckAndClearEventFlags(evRemove);

  // Leeren Puffer muss man jetzt auch komplett füllen dürfen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer muss komplett voll sein');
  CheckAndClearEventFlags(evAdd);

  // und leeren
  FRingbuffer.Clear;
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nun leer sein');
  CheckAndClearEventFlags(evRemove);
end;

procedure TestTRingbuffer.TestClearNoNotify;
begin
  FRingbuffer.Notify := nil;

  FRingbuffer.Add(1);
  CheckEquals(1, FRingbuffer.Count,   'Puffer muss Element enthalten');
  CheckEquals(1, FRingbuffer.Peek(0), 'Falscher Pufferinhalt');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbuffer.TestCreate;
var
  Size, Count: Cardinal;
begin
  Size  := FRingBuffer.Size;
  Count := FRingBuffer.Count;

  CheckEquals(5, Size,  'Falsche Puffergröße');
  CheckEquals(0, Count, 'Puffer muss zu Beginn leer sein');
end;

procedure TestTRingbuffer.TestAddWhenEmpty;
var
  i    : Byte;
  Item : Byte;
begin
  // Puffer ganz füllen
  for i := 1 to FRingbuffer.Size  do
  begin
    Item := i;
    FRingbuffer.Add(Item);

    CheckEquals(i, FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+i.ToString+')');
    CheckEquals(i, FRingbuffer.Peek(i-1), 'Falscher Wert');
    CheckAndClearEventFlags(evAdd);
  end;
end;

procedure TestTRingbuffer.TestAddWrapAround;
var
  i    : Byte;
  Item : Byte;
begin
  // Puffer ganz füllen
  for i := 1 to FRingbuffer.Size do
  begin
    Item := i;
    FRingbuffer.Add(Item);

    CheckEquals(i, FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+i.ToString+')');
    CheckEquals(i, FRingbuffer.Peek(i-1), 'Falscher Wert');
    CheckAndClearEventFlags(evAdd);
  end;

  // erstes Element entfernen, Endezeiger steht jetzt auf letztem Array Element
  // und nächster Add-Aufruf muss am Anfang ein Item hinzufügen, d.h. kapieren,
  // dass es wieder bei 0 los geht
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  Item := 6;
  FRingbuffer.Add(Item);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+
                                                       FRingbuffer.Count.ToString+')');
  CheckEquals(Item, FRingbuffer.Peek(FRingbuffer.Size-1), 'Falscher Wert im Letzten Item');
  CheckAndClearEventFlags(evAdd);
end;

procedure TestTRingbuffer.TestArrayAddNoNotify;
var
  Items : TRingbuffer<Byte>.TRingbufferArray;
  i     : Byte;
begin
  FRingbuffer.Notify := nil;

  SetLength(Items, 5);
  for i := 0 to High(Items) do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+
                                                       FRingbuffer.Count.ToString+')');
  CheckAndClearNoEventFlagsSet;

  SetLength(Items, 0);
  Items := FRingbuffer.Remove(5);

  for i := 0 to High(Items) do
    CheckEquals(i, Items[i], 'Falscher Wert im Puffer. Soll: '+i.ToString+
                             ' Ist: '+Items[i].ToString);
end;

procedure TestTRingbuffer.TestAddArrayWhenEmpty;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  Item : Byte;
  i    : Byte;
begin
  SetLength(Items, 3);
  Items[0] := 1;
  Items[1] := 2;
  Items[2] := 3;

  FRingbuffer.Add(Items);
  CheckEquals(3, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckAndClearEventFlags(evAdd);

  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i+1, Item, 'Falscher Pufferwert');
  end;
end;

procedure TestTRingbuffer.TestAddArrayWhenEmptyFull;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  Item : Byte;
  i    : Byte;
begin
  SetLength(Items, FRingbuffer.Size);

  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i, Item, 'Falscher Pufferwert');
  end;
end;

procedure TestTRingbuffer.TestAddArrayEndLessStart1;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
begin
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  // Puffer ist jetzt komplett voll, Start aber immer noch 0
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
    CheckEquals(i, FRingbuffer.Peek(i), 'Pufferinhalt falsch');

  // 1 Element entfernen, damit ist Start = 1 und der Ende Marker immer noch 0
  // und damit Ende Marker < Start Marker
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  // Ein einzelnes Element als Array hinzufügen
  SetLength(Items, 1);
  Items[0] := 100;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-2 do
    CheckEquals(i+1, FRingbuffer.Peek(i), 'Pufferinhalt falsch');
  // später hinzugefügtes Element prüfen
  CheckEquals(100, FRingbuffer.Peek(FRingbuffer.Size-1), 'Später hinzugefügtes Element hat falschen Wert');
end;

procedure TestTRingbuffer.TestAddArrayEndLessStart3;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
begin
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  // Puffer ist jetzt komplett voll, Start aber immer noch 0
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
    CheckEquals(i, FRingbuffer.Peek(i), 'Pufferinhalt falsch');

  // 3 Elemente entfernen, damit ist Start = 3 und der Ende Marker immer noch 0
  // und damit Ende Marker < Start Marker
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  // 3 Elemente hinzufügen
  SetLength(Items, FRingbuffer.Size-2);
  Items[0] := 100;
  Items[1] := 150;
  Items[2] := 200;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to 1 do
    CheckEquals(i+3, FRingbuffer.Peek(i), 'Pufferinhalt falsch');
  // später hinzugefügte Elemente prüfen
  CheckEquals(100, FRingbuffer.Peek(2), 'Später hinzugefügtes Element hat falschen Wert');
  CheckEquals(150, FRingbuffer.Peek(3), 'Später hinzugefügtes Element hat falschen Wert');
  CheckEquals(200, FRingbuffer.Peek(4), 'Später hinzugefügtes Element hat falschen Wert');
end;

procedure TestTRingbuffer.TestAddArrayEnptyArray;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
begin
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss leer sein');

  // Testet das hinzufügen eines komplett leeren Arrays
  // Dieser Test ist derzeit dafür ausgelegt, einen Debugbuild mit eingeschalteten
  // Assertions zu prüfen.
  SetLength(Items, 0);

  // Prüfung, dass das Hinzufügen von zuviel Daten eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EAssertionFailed);

  FRingbuffer.Add(Items);
  CheckEquals(false, FAdded, 'Hinzufügen Event fälschlicherweise ausgelöst');

  StopExpectingException();

  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nach Hinzufügen von nichts immer noch leer sein');
end;

procedure TestTRingbuffer.TestAddArrayException;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
begin
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(1);

  // Prüfung, dass das Hinzufügen von zuviel Daten eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // Array hinzufügen der nicht mehr hinein passt
  FRingbuffer.Add(Items);
  CheckEquals(false, FAdded, 'Hinzufügen Event fälschlicherweise ausgelöst');

  StopExpectingException();

  // Puffer vollends "manuell" füllen
  for i := 2 to FRingbuffer.Size do
    FRingbuffer.Add(i);

  // aus dem vollen Puffer das erste Element entfernen
  FRingbuffer.Remove;
  // Damit ist der Ende Marker < Startmarker und 1 Element Platz im Puffer
  SetLength(Items, 2);
  Items[0] := 10;
  Items[1] := 11;

  // Prüfung, dass das Hinzufügen von zuviel Daten eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // Array hinzufügen der nicht mehr hinein passt
  FRingbuffer.Add(Items);
  CheckEquals(false, FAdded, 'Hinzufügen Event fälschlicherweise ausgelöst');

  StopExpectingException();
end;

procedure TestTRingbuffer.TestAddArrayPartiallyFilled;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
begin
  FRingbuffer.Add(1);

  SetLength(Items, 1);
  Items[0] := 2;
  FRingbuffer.Add(Items);

  CheckEquals(2, FRingbuffer.Count, 'Falsche Anzahl an items im Puffer');
  CheckAndClearEventFlags(evAdd);

  for i := 1 to 2 do
    CheckEquals(i, FRingbuffer.Peek(i-1), 'Falscher Wert im Puffer');

  // Puffer weiter füllen
  SetLength(Items, 2);
  Items[0] := 3;
  Items[1] := 4;
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  CheckEquals(4, FRingbuffer.Count, 'Falsche Anzahl an items im Puffer');
  for i := 1 to 4 do
    CheckEquals(i, FRingbuffer.Peek(i-1), 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestAddArrayWrap1;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
begin
  // Test mit 1 Element Überlauf
  FRingbuffer.Add(1);
  FRingbuffer.Add(2);
  CheckAndClearEventFlags(evAdd);

  // ersten Eintrag wieder entfernen, Startzeiger steht auf 2. Element,
  // 1. Position ist frei
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  SetLength(Items, FRingbuffer.Size-1);
  for i := 0 to FRingbuffer.Size-2 do
    Items[i] := i+3;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Items im Puffer');

  for i := 0 to FRingbuffer.Count-1 do
    CheckEquals(i+2, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestAddArrayWrap3;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
begin
  // Test mit 3 Elementen Überlauf, Puffer soweit füllen, dass Hinzufügen von 4
  // Elementen zum "Überlauf" von 3 Elementen führt
  FRingbuffer.Add(1);
  FRingbuffer.Add(2);
  FRingbuffer.Add(3);
  FRingbuffer.Add(4);
  CheckAndClearEventFlags(evAdd);

  // erste 3 Einträge wieder entfernen
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  SetLength(Items, FRingbuffer.Size-1);
  for i := 0 to FRingbuffer.Size-2 do
    Items[i] := i+5;

  FRingbuffer.Add(Items);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Items im Puffer');
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Count-1 do
    CheckEquals(i+4, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestAddException;
var
  i    : Byte;
  Item : Byte;
begin
  // Puffer zuerst komplett füllen
  for i := 1 to FRingbuffer.Size do
  begin
    Item := i;
    FRingbuffer.Add(Item);

    CheckEquals(i, FRingbuffer.Count, 'Anzahl Elemente ist falsch ('+i.ToString+')');
  end;

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer ist nicht voll!');
  CheckAndClearEventFlags(evAdd);

  // Prüfung, dass das Hinzufügen von zuviel Daten eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // ein Element zuviel hinzufügen
  Item := FRingbuffer.Size+1;
  FRingbuffer.Add(Item);
  CheckEquals(false, FAdded, 'Hinzufügen benachrichtigung fälschlicherweise ausgelöst');

  StopExpectingException();
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer ist nicht mehr voll!');
end;

procedure TestTRingbuffer.TestAddNoNotify;
begin
  FRingbuffer.Notify := nil;
  FRingbuffer.Add(1);

  CheckEquals(1, FRingbuffer.Peek(0), 'Falscher Wert');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbuffer.TestRemove;
var
  ReturnValue : Byte;
  Item        : Byte;
  i           : Byte;
begin
  // zuerst mit einem Eintrag prüfen
  Item := 1;
  FRingbuffer.Add(Item);
  CheckEquals(1, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckAndClearEventFlags(evAdd);

  ReturnValue := FRingbuffer.Remove;
  CheckEquals(0, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckEquals(1, ReturnValue,       'Entnommenes Element ist falsch');
  CheckAndClearEventFlags(evRemove);

  // Jetzt mit vollem Puffer prüfen
  // Puffer zuerst komplett füllen
  for i := FRingbuffer.Size downto 1 do
  begin
    Item := i;
    FRingbuffer.Add(Item);
  end;

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer ist nicht voll!');
  CheckAndClearEventFlags(evAdd);

  // Puffer komplett leeren
  for i := FRingbuffer.Size downto 1 do
  begin
    ReturnValue := FRingbuffer.Remove;

    CheckEquals(i-1, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
    CheckEquals(i,   ReturnValue,       'Entnommenes Element ist falsch');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(0, FRingbuffer.Count, 'Puffer ist nicht leer!');
end;

procedure TestTRingbuffer.TestRemoveArray;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  Count       : Cardinal;
  i           : Byte;

begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen, Elemente und Pufferfüllstand prüfen
  Count := 3;
  SetLength(ReturnValue, 3);
  ReturnValue := FRingbuffer.Remove(Count);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl verbleibender Elemente im Puffer');
  CheckAndClearEventFlags(evRemove);

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals(i, ReturnValue[i], 'Falscher Wert im entnommenen Array');
end;

procedure TestTRingbuffer.TestRemoveArrayException;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Prüfung, dass das Entfernen von mehr Items als Puffergröße eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  SetLength(ReturnValue, FRingbuffer.Size+1);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Size+1);
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();
end;

procedure TestTRingbuffer.TestRemoveArrayNoNotify;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  FRingbuffer.Notify := nil;

  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingBuffer.Add(Items);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Count);

  CheckAndClearNoEventFlagsSet;

  for i := 0 to High(ReturnValue) do
    CheckEquals(i, ReturnValue[i], 'Falscher Wert. Soll: '+
                                   i.ToString+' Ist: '+ReturnValue[i].ToString);
end;

procedure TestTRingbuffer.TestRemoveArraySize0;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
  Item        : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 0 Items entnehmen
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Remove(0);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Entnehmen von nix darf Puffergröße nicht ändern');
  CheckAndClearEventFlags(evRemove);

  // Pufferinhalt prüfen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i, Item, 'Falscher Wert');
  end;
end;

procedure TestTRingbuffer.TestRemoveArrayWrap1;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Ein Element entnehmen und wieder Auffüllen, damit der Puffer um ein Element
  // über das obere Array Ende hinaus von unten wieder beginnend geht
  i := FRingbuffer.Remove;
  CheckEquals(0, i, 'Entnommenes Element hat falschen Wert');
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auffüllen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Size);

  CheckEquals(0, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach Entnahme');
  CheckAndClearEventFlags(evRemove);

  for i := 0 to high(ReturnValue) do
    CheckEquals(i+1, ReturnValue[i], 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestRemoveArrayWrap3;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
  Item        : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen und wieder Auffüllen, damit der Puffer um ein Element
  // über das obere Array Ende hinaus von unten wieder beginnend geht
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i, Item, 'Entnommenes Element hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auffüllen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Size);

  CheckEquals(0, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach Entnahme');
  CheckAndClearEventFlags(evRemove);

  for i := 0 to high(ReturnValue) do
    CheckEquals(i+3, ReturnValue[i], 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestRemoveException;
var
  ReturnValue : Byte;
begin
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss bei Prüfungsbeginn leer sein!');

  // Prüfung, dass das Entfernen von items bei leerem Puffer eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferEmptyException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  ReturnValue := FRingbuffer.Remove;
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdrückt
  CheckEquals(100, ReturnValue, 'Entnommenes Element ist falsch');
  CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung fälschlicherweise ausgelöst');
  ClearEventFlags;

  StopExpectingException();

  // Prüfen, dass es auch bei nicht initial leerem Puffer zu einer Exception kommt
  FRingbuffer.Add(1);
  ReturnValue := FRingbuffer.Remove;
  CheckEquals(1, ReturnValue, 'Entnommenes Element ist falsch');
  CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung fälschlicherweise ausgelöst');
  ClearEventFlags;

  // einmal zuviel entnehmen
  StartExpectingException(EBufferEmptyException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  ReturnValue := FRingbuffer.Remove;
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdrückt
  CheckEquals(100, ReturnValue, 'Entnommenes Element ist falsch');
  CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung fälschlicherweise ausgelöst');
  ClearEventFlags;

  StopExpectingException();
end;

procedure TestTRingbuffer.TestRemoveNoNotify;
begin
  FRingbuffer.Notify := nil;

  FRingbuffer.Add(1);
  CheckAndClearNoEventFlagsSet;

  CheckEquals(1, FRingbuffer.Remove, 'Entnommenes Element ist falsch');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbuffer.TestRemoveWrap1;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
  Item : Byte;
begin
  // Puffer komplett füllen, ein Element entfernen und wieder auffüllen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen Überlauf um 1 Element über das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 1 Element löschen
  Item := FRingbuffer.Remove;
  CheckEquals(0,                  Item,              'Entfernter Eintrag hat falschen Wert');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evRemove);

  // 1 Element hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add(5);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer (Schleife)');
    CheckAndClearEventFlags(evRemove);
  end;
end;

procedure TestTRingbuffer.TestRemoveWrap3;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
  Item : Byte;
begin
  // Puffer komplett füllen, ein Element entfernen und wieder auffüllen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen Überlauf um 1 Element über das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente löschen
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i, Item, 'Entfernter Eintrag hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // 3 Elemente hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add(5);
  FRingbuffer.Add(6);
  FRingbuffer.Add(7);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+3, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer (Schleife)');
    CheckAndClearEventFlags(evRemove);
  end;
end;

procedure TestTRingbuffer.TestDelete;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // das eigentliche Löschen
  FRingbuffer.Delete(1);
  CheckAndClearEventFlags(evRemove);

  ReturnValue := FRingBuffer.Peek(0, FRingbuffer.Count);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer nach Delete');

  for i := 0 to high(ReturnValue) do
  begin
    CheckEquals(i+1, ReturnValue[i], 'Falscher Wert im Puffer');
  end;

  // alle bis auf einen löschen
  FRingbuffer.Delete(FRingbuffer.Size-2);
  CheckAndClearEventFlags(evRemove);
  CheckEquals(1,                  FRingbuffer.Count,   'Falsche Anzahl an Einträgen im Puffer nach 2. Delete');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Peek(0), 'Falscher Wert nach 2. Delete');
end;

procedure TestTRingbuffer.TestDeleteAll;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Alle Einträge auf einmal löschen
  FRingbuffer.Delete(FRingbuffer.Size);
  CheckAndClearEventFlags(evRemove);

  CheckEquals(0, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer nach dem Löschen');

  FRingbuffer.Add(123);
  CheckEquals(123, FRingbuffer.Peek(0), 'Falscher Wert im Puffer');
  CheckAndClearEventFlags(evAdd);
end;

procedure TestTRingbuffer.TestDeleteException;
begin
  // Prüfung, dass das Entfernen von mehr Items als Puffergröße eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // Versuchen ein Element mit falschem Index zu extrahieren
  FRingbuffer.Delete(FRingbuffer.Size+1);
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();

end;

procedure TestTRingbuffer.TestDeleteNoNotify;
begin
  FRingbuffer.Notify := nil;
  FRingBuffer.Add(1);

  CheckAndClearNoEventFlagsSet;
  FRingbuffer.Delete(1);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(0, FRingbuffer.Count, 'Puffer ist nicht leer');
end;

procedure TestTRingbuffer.TestDeleteSize0;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // nix löschen
  FRingbuffer.Delete(0);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer '+
                                                   'nach Löschen von 0 Einträgen');

  // Werte prüfen
  for i := 0 to FRingbuffer.Size-1 do
    CheckEquals(i, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestDeleteWrap1;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // Ein Element entfernen und eines hinzufügen, damit Puffer über obere Array
  // Grenze geht
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size);
  CheckAndClearEventFlags(evAdd);

  // Ein Element löschen und Puffer prüfen
  FRingbuffer.Delete(1);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer nach Löschen');

  // Werte prüfen
  for i := 0 to FRingbuffer.Size-2 do
    CheckEquals(i+2, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestDeleteWrap3;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // 3 Elemente entfernen und 3 hinzufügen, damit Puffer über obere Array
  // Grenze geht
  FRingbuffer.Remove(3);
  CheckAndClearEventFlags(evRemove);

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Ein Element löschen und Puffer prüfen
  FRingbuffer.Delete(3);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer nach Löschen');

  // Werte prüfen
  for i := 0 to FRingbuffer.Count-1 do
    CheckEquals(i+6, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestPeek;
var
  ReturnValue : Byte;
  i           : Byte;
begin
  FRingbuffer.Add(100);
  CheckAndClearEventFlags(evAdd);

  ReturnValue := FRingbuffer.Peek(0);
  // Peek darf Benachrichtigungsmechanismus nicht auslösen
  CheckAndClearNoEventFlagsSet;
  CheckEquals(100, ReturnValue, 'Falscher Wert aus dem Puffer geliefert1');

  // sicherstellen, dass auch nach Peek der Wert noch im Puffer ist
  ReturnValue := FRingbuffer.Peek(0);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(100, ReturnValue, 'Falscher Wert aus dem Puffer geliefert2');

  // auch bei vollem Puffer soll es funktionieren
  FRingbuffer.Clear;
  CheckAndClearEventFlags(evRemove);

  for i := 0 to FRingbuffer.Size-1 do
    FRingbuffer.Add(i);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
  begin
    ReturnValue := FRingbuffer.Peek(i);
    CheckEquals(i, ReturnValue, 'Falscher Wert aus dem Puffer geliefert3');
  end;
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbuffer.TestPeekArray;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // alle Elemente mittels Peek holen
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Spicken darf Puffergröße nicht ändern');
  CheckEquals(FRingbuffer.Size, length(ReturnValue), 'Falsche Größe der gelieferten Daten');
  CheckAndClearNoEventFlagsSet;

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals(i, ReturnValue[i], 'Falscher Wert');

  // nur ein Element holen
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckEquals(1, length(ReturnValue), 'Falsche Größe der gelieferten Daten');
  CheckEquals(1, ReturnValue[0], 'Falscher Wert');
  CheckAndClearNoEventFlagsSet;

  // 2 Elemente holen
  ReturnValue := FRingbuffer.Peek(1, 2);
  CheckEquals(2, length(ReturnValue), 'Falsche Größe der gelieferten Daten');
  CheckEquals(1, ReturnValue[0], 'Falscher Wert');
  CheckEquals(2, ReturnValue[1], 'Falscher Wert');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbuffer.TestPeekArrayAfterDelete;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // erstes Element löschen
  FRingbuffer.Delete(1);
  CheckAndClearEventFlags(evRemove);

  // alle Elemente mittels Peek holen
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Spicken darf Puffergröße nicht ändern');
  CheckEquals(FRingbuffer.Count, length(ReturnValue), 'Falsche Größe der gelieferten Daten');
  CheckAndClearNoEventFlagsSet;

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals(i+1, ReturnValue[i], 'Falscher Wert');

  // nur ein Element holen
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckEquals(1, length(ReturnValue), 'Falsche Größe der gelieferten Daten');
  CheckEquals(2, ReturnValue[0], 'Falscher Wert');
  CheckAndClearNoEventFlagsSet;

  // 2 Elemente holen
  ReturnValue := FRingbuffer.Peek(1, 2);
  CheckEquals(2, length(ReturnValue), 'Falsche Größe der gelieferten Daten');
  CheckEquals(2, ReturnValue[0], 'Falscher Wert');
  CheckEquals(3, ReturnValue[1], 'Falscher Wert');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbuffer.TestPeekArrayException;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Exception bei Index > Count prüfen
  FRingbuffer.Add(1);
  CheckAndClearEventFlags(evAdd);

  // Prüfung, dass das Entfernen von mehr Items als Puffergröße eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // Versuchen ein Element mit falschem Index zu extrahieren
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();

  // Puffer für nächsten Test leeren
  FRingbuffer.Clear;
  CheckAndClearEventFlags(evRemove);

  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Prüfung, dass das Entfernen von mehr Items als Puffergröße eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  SetLength(ReturnValue, FRingbuffer.Size+1);
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size+1);
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();
end;

procedure TestTRingbuffer.TestPeekArraySize0;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
  Item        : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 0 Items entnehmen
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Peek(0, 0);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Spicken darf Puffergröße nicht ändern');
  CheckAndClearNoEventFlagsSet;

  // Pufferinhalt prüfen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i, Item, 'Falscher Wert');
    CheckAndClearNoEventFlagsSet;
  end;
end;

procedure TestTRingbuffer.TestPeekArrayWrap1;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Ein Element entnehmen und wieder Auffüllen, damit der Puffer um ein Element
  // über das obere Array Ende hinaus von unten wieder beginnend geht
  i := FRingbuffer.Remove;
  CheckEquals(0, i, 'Entnommenes Element hat falschen Wert');
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auffüllen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach Entnahme');
  CheckAndClearNoEventFlagsSet;

  for i := 0 to high(ReturnValue) do
    CheckEquals(i+1, ReturnValue[i], 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestPeekArrayWrap3;
var
  Items       : TRingbuffer<Byte>.TRingbufferArray;
  ReturnValue : TRingbuffer<Byte>.TRingbufferArray;
  i           : Byte;
  Item        : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen und wieder Auffüllen, damit der Puffer um ein Element
  // über das obere Array Ende hinaus von unten wieder beginnend geht
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i, Item, 'Entnommenes Element hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auffüllen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach Entnahme');
  CheckAndClearNoEventFlagsSet;

  for i := 0 to high(ReturnValue) do
    CheckEquals(i+3, ReturnValue[i], 'Falscher Wert im Puffer');
end;

procedure TestTRingbuffer.TestPeekException;
var
  ReturnValue: Byte;
begin
  FRingbuffer.Add(123);
  CheckAndClearEventFlags(evAdd);

  ReturnValue := FRingbuffer.Peek(0);
  CheckEquals(123, ReturnValue, 'Falscher Wert im Puffer');
  CheckAndClearNoEventFlagsSet;

  StartExpectingException(EArgumentOutOfRangeException);

  // Versuchen ein Element hinter dem aktuellen Pufferende zu lesen
  ReturnValue := FRingbuffer.Peek(1);
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdrückt
  CheckEquals(100, ReturnValue, 'Entnommenes Element ist falsch');
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();
end;

procedure TestTRingbuffer.TestPeekWrap1;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
  Item : Byte;
begin
  // Puffer komplett füllen, ein Element entfernen und wieder auffüllen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen Überlauf um 1 Element über das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 1 Element löschen
  Item := FRingbuffer.Remove;
  CheckEquals(0,                  Item,              'Entfernter Eintrag hat falschen Wert');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evRemove);

  // 1 Element hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add(5);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i+1, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer (Schleife)');
    CheckAndClearNoEventFlagsSet;
  end;
end;

procedure TestTRingbuffer.TestPeekWrap3;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
  Item : Byte;
begin
  // Puffer komplett füllen, ein Element entfernen und wieder auffüllen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen Überlauf um 1 Element über das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente löschen
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i,                  Item,              'Entfernter Eintrag hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // 3 Elemente hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add(5);
  FRingbuffer.Add(6);
  FRingbuffer.Add(7);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i+3, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer (Schleife)');
    CheckAndClearNoEventFlagsSet;
  end;
end;

{ TestTRingbufferInt ----------------------------------------------------------}

procedure TestTRingbufferInt.SetUp;
begin
  FRingbuffer        := TRingbuffer<Integer>.Create(5);
  FRingbuffer.Notify := OnNotify;
  ClearEventFlags;
end;

procedure TestTRingbufferInt.TearDown;
begin
  FRingbuffer.Free;
  FRingbuffer := nil;
end;

procedure TestTRingbufferInt.TestClear;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
begin
  // Puffer teilweise füllen
  for i := 1 to 3 do
    FRingbuffer.Add(i);

  CheckEquals(3, FRingbuffer.Count, 'Falscher Pufferfüllstand');
  CheckAndClearEventFlags(evAdd);

  // und leeren
  FRingbuffer.Clear;
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nun leer sein');
  CheckAndClearEventFlags(evRemove);

  // Leeren Puffer muss man jetzt auch komplett füllen dürfen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer muss komplett voll sein');
  CheckAndClearEventFlags(evAdd);

  // und leeren
  FRingbuffer.Clear;
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nun leer sein');
  CheckAndClearEventFlags(evRemove);
end;

procedure TestTRingbufferInt.TestClearNoNotify;
begin
  FRingbuffer.Notify := nil;

  FRingbuffer.Add(100000);
  CheckEquals(1,      FRingbuffer.Count,   'Puffer muss Element enthalten');
  CheckEquals(100000, FRingbuffer.Peek(0), 'Falscher Pufferinhalt');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestCreate;
var
  Size, Count: Cardinal;
begin
  Size  := FRingBuffer.Size;
  Count := FRingBuffer.Count;

  CheckEquals(5, Size,  'Falsche Puffergröße');
  CheckEquals(0, Count, 'Puffer muss zu Beginn leer sein');
end;

procedure TestTRingbufferInt.TestAddWhenEmpty;
var
  i    : Byte;
  Item : Integer;
begin
  // Puffer ganz füllen
  for i := 1 to FRingbuffer.Size  do
  begin
    Item := i-1000;
    FRingbuffer.Add(Item);

    CheckEquals(i,      FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+i.ToString+')');
    CheckEquals(i-1000, FRingbuffer.Peek(i-1), 'Falscher Wert');
    CheckAndClearEventFlags(evAdd);
  end;
end;

procedure TestTRingbufferInt.TestAddWrapAround;
var
  i    : Byte;
  Item : Integer;
begin
  // Puffer ganz füllen
  for i := 1 to FRingbuffer.Size do
  begin
    Item := i-1000;
    FRingbuffer.Add(Item);

    CheckEquals(i,      FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+i.ToString+')');
    CheckEquals(i-1000, FRingbuffer.Peek(i-1), 'Falscher Wert');
    CheckAndClearEventFlags(evAdd);
  end;

  // erstes Element entfernen, Endezeiger steht jetzt auf letztem Array Element
  // und nächster Add-Aufruf muss am Anfang ein Item hinzufügen, d.h. kapieren,
  // dass es wieder bei 0 los geht
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  Item := 6000;
  FRingbuffer.Add(Item);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+
                                                       FRingbuffer.Count.ToString+')');
  CheckEquals(Item, FRingbuffer.Peek(FRingbuffer.Size-1), 'Falscher Wert im Letzten Item');
  CheckAndClearEventFlags(evAdd);
end;

procedure TestTRingbufferInt.TestArrayAddNoNotify;
var
  Items : TRingbuffer<Integer>.TRingbufferArray;
  i     : Byte;
begin
  FRingbuffer.Notify := nil;

  SetLength(Items, 5);
  for i := 0 to High(Items) do
    Items[i] := i + 1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+
                                                       FRingbuffer.Count.ToString+')');
  CheckAndClearNoEventFlagsSet;

  SetLength(Items, 0);
  Items := FRingbuffer.Remove(5);

  for i := 0 to High(Items) do
    CheckEquals(i + 1000, Items[i], 'Falscher Wert im Puffer. Soll: '+i.ToString+
                                    ' Ist: '+Items[i].ToString);
end;

procedure TestTRingbufferInt.TestAddArrayWhenEmpty;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  Item : Integer;
  i    : Byte;
begin
  SetLength(Items, 3);
  Items[0] := 1000;
  Items[1] := 1001;
  Items[2] := 1002;

  FRingbuffer.Add(Items);
  CheckEquals(3, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckAndClearEventFlags(evAdd);

  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i+1000, Item, 'Falscher Pufferwert');
  end;
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestAddArrayWhenEmptyFull;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  Item : Integer;
  i    : Byte;
begin
  SetLength(Items, FRingbuffer.Size);

  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i+1000, Item, 'Falscher Pufferwert');
  end;
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestAddArrayEndLessStart1;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
begin
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  // Puffer ist jetzt komplett voll, Start aber immer noch 0
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
    CheckEquals(i+1000, FRingbuffer.Peek(i), 'Pufferinhalt falsch');

  // 1 Element entfernen, damit ist Start = 1 und der Ende Marker immer noch 0
  // und damit Ende Marker < Start Marker
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  // Ein einzelnes Element als Array hinzufügen
  SetLength(Items, 1);
  Items[0] := -100;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-2 do
    CheckEquals(i+1+1000, FRingbuffer.Peek(i), 'Pufferinhalt falsch');
  // später hinzugefügtes Element prüfen
  CheckEquals(-100, FRingbuffer.Peek(FRingbuffer.Size-1), 'Später hinzugefügtes Element hat falschen Wert');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestAddArrayEndLessStart3;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
begin
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  // Puffer ist jetzt komplett voll, Start aber immer noch 0
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
    CheckEquals(i+1000, FRingbuffer.Peek(i), 'Pufferinhalt falsch');

  // 3 Elemente entfernen, damit ist Start = 3 und der Ende Marker immer noch 0
  // und damit Ende Marker < Start Marker
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  // 3 Elemente hinzufügen
  SetLength(Items, FRingbuffer.Size-2);
  Items[0] := 10000;
  Items[1] := 15000;
  Items[2] := 20000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to 1 do
    CheckEquals(i+3+1000, FRingbuffer.Peek(i), 'Pufferinhalt falsch');
  // später hinzugefügte Elemente prüfen
  CheckEquals(10000, FRingbuffer.Peek(2), 'Später hinzugefügtes Element hat falschen Wert');
  CheckEquals(15000, FRingbuffer.Peek(3), 'Später hinzugefügtes Element hat falschen Wert');
  CheckEquals(20000, FRingbuffer.Peek(4), 'Später hinzugefügtes Element hat falschen Wert');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestAddArrayEnptyArray;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
begin
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss leer sein');

  // Testet das hinzufügen eines komplett leeren Arrays
  // Dieser Test ist derzeit dafür ausgelegt, einen Debugbuild mit eingeschalteten
  // Assertions zu prüfen.
  SetLength(Items, 0);

  // Prüfung, dass das Hinzufügen von zuviel Daten eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EAssertionFailed);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();

  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nach Hinzufügen von nichts immer noch leer sein');
end;

procedure TestTRingbufferInt.TestAddArrayException;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
begin
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(1);
  CheckAndClearEventFlags(evAdd);

  // Prüfung, dass das Hinzufügen von zuviel Daten eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // Array hinzufügen der nicht mehr hinein passt
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();

  // Puffer vollends "manuell" füllen
  for i := 2 to FRingbuffer.Size do
    FRingbuffer.Add(i);

  CheckAndClearEventFlags(evAdd);

  // aus dem vollen Puffer das erste Element entfernen
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);
  // Damit ist der Ende Marker < Startmarker und 1 Element Platz im Puffer
  SetLength(Items, 2);
  Items[0] := 10;
  Items[1] := 11;

  // Prüfung, dass das Hinzufügen von zuviel Daten eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // Array hinzufügen der nicht mehr hinein passt
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();
end;

procedure TestTRingbufferInt.TestAddArrayPartiallyFilled;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
begin
  FRingbuffer.Add(100000);
  CheckAndClearEventFlags(evAdd);

  SetLength(Items, 1);
  Items[0] := 100001;
  FRingbuffer.Add(Items);

  CheckEquals(2, FRingbuffer.Count, 'Falsche Anzahl an items im Puffer');
  for i := 0 to 1 do
    CheckEquals(i+100000, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');

  // Puffer weiter füllen
  SetLength(Items, 2);
  Items[0] := 100002;
  Items[1] := 100003;
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  CheckEquals(4, FRingbuffer.Count, 'Falsche Anzahl an items im Puffer2');
  for i := 0 to 3 do
    CheckEquals(i+100000, FRingbuffer.Peek(i), 'Falscher Wert im Puffer2');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestAddArrayWrap1;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
begin
  // Test mit 1 Element Überlauf
  FRingbuffer.Add(1000);
  FRingbuffer.Add(1001);
  CheckAndClearEventFlags(evAdd);
  // ersten Eintrag wieder entfernen, Startzeiger steht auf 2. Element,
  // 1. Position ist frei
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  SetLength(Items, FRingbuffer.Size-1);
  for i := 0 to FRingbuffer.Size-2 do
    Items[i] := i+1002;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Items im Puffer');

  for i := 0 to FRingbuffer.Count-1 do
    CheckEquals(i+1001, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestAddArrayWrap3;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
begin
  // Test mit 3 Elementen Überlauf, Puffer soweit füllen, dass Hinzufügen von 4
  // Elementen zum "Überlauf" von 3 Elementen führt
  FRingbuffer.Add(1000);
  FRingbuffer.Add(1001);
  FRingbuffer.Add(1002);
  FRingbuffer.Add(1003);
  CheckAndClearEventFlags(evAdd);
  // erste 3 Einträge wieder entfernen
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  SetLength(Items, FRingbuffer.Size-1);
  for i := 0 to FRingbuffer.Size-2 do
    Items[i] := i+1004;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Items im Puffer');

  for i := 0 to FRingbuffer.Count-1 do
    CheckEquals(i+1003, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestAddException;
var
  i    : Byte;
  Item : Integer;
begin
  // Puffer zuerst komplett füllen
  for i := 1 to FRingbuffer.Size do
  begin
    Item := i-1000;
    FRingbuffer.Add(Item);

    CheckEquals(i, FRingbuffer.Count, 'Anzahl Elemente ist falsch ('+i.ToString+')');
    CheckAndClearEventFlags(evAdd);
  end;

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer ist nicht voll!');

  // Prüfung, dass das Hinzufügen von zuviel Daten eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // ein Element zuviel hinzufügen
  Item := FRingbuffer.Size+1;
  FRingbuffer.Add(Item);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer ist nicht mehr voll!');
end;

procedure TestTRingbufferInt.TestAddNoNotify;
begin
  FRingbuffer.Notify := nil;
  FRingbuffer.Add(1000);

  CheckEquals(1000, FRingbuffer.Peek(0), 'Falscher Wert');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestRemove;
var
  ReturnValue : Integer;
  Item        : Integer;
  i           : Byte;
begin
  // zuerst mit einem Eintrag prüfen
  Item := 1;
  FRingbuffer.Add(Item);
  CheckEquals(1, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckAndClearEventFlags(evAdd);

  ReturnValue := FRingbuffer.Remove;
  CheckEquals(0, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckEquals(1, ReturnValue,       'Entnommenes Element ist falsch');
  CheckAndClearEventFlags(evRemove);

  // Jetzt mit vollem Puffer prüfen
  // Puffer zuerst komplett füllen
  for i := FRingbuffer.Size downto 1 do
  begin
    Item := i+1000;
    FRingbuffer.Add(Item);
  end;

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer ist nicht voll!');
  CheckAndClearEventFlags(evAdd);

  // Puffer komplett leeren
  for i := FRingbuffer.Size downto 1 do
  begin
    ReturnValue := FRingbuffer.Remove;

    CheckEquals(i-1,    FRingbuffer.Count, 'Anzahl Elemente ist falsch');
    CheckEquals(i+1000, ReturnValue,       'Entnommenes Element ist falsch');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(0, FRingbuffer.Count, 'Puffer ist nicht leer!');
end;

procedure TestTRingbufferInt.TestRemoveArray;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  Count       : Cardinal;
  i           : Byte;

begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen, Elemente und Pufferfüllstand prüfen
  Count := 3;
  SetLength(ReturnValue, 3);
  ReturnValue := FRingbuffer.Remove(Count);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl verbleibender Elemente im Puffer');
  CheckAndClearEventFlags(evRemove);

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals(i+1000, ReturnValue[i], 'Falscher Wert im entnommenen Array');
end;

procedure TestTRingbufferInt.TestRemoveArrayException;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Prüfung, dass das Entfernen von mehr Items als Puffergröße eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  SetLength(ReturnValue, FRingbuffer.Size+1);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Size+1);
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();
end;

procedure TestTRingbufferInt.TestRemoveArrayNoNotify;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Integer;
begin
  FRingbuffer.Notify := nil;

  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i + 100000;

  FRingBuffer.Add(Items);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Count);

  CheckAndClearNoEventFlagsSet;

  for i := 0 to High(ReturnValue) do
    CheckEquals(i + 100000, ReturnValue[i], 'Falscher Wert. Soll: '+
                                            i.ToString+' Ist: '+ReturnValue[i].ToString);
end;

procedure TestTRingbufferInt.TestRemoveArraySize0;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
  Item        : Integer;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i-1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 0 Items entnehmen
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Remove(0);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Entnehmen von nix darf Puffergröße nicht ändern');
  CheckAndClearEventFlags(evRemove);

  // Pufferinhalt prüfen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i-1000, Item, 'Falscher Wert');
  end;
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestRemoveArrayWrap1;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Integer;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Ein Element entnehmen und wieder Auffüllen, damit der Puffer um ein Element
  // über das obere Array Ende hinaus von unten wieder beginnend geht
  i := FRingbuffer.Remove;
  CheckEquals(1000, i, 'Entnommenes Element hat falschen Wert');
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size+1000);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auffüllen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Size);
  CheckAndClearEventFlags(evRemove);

  CheckEquals(0, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach Entnahme');
  for i := 0 to high(ReturnValue) do
    CheckEquals(i+1+1000, ReturnValue[i], 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestRemoveArrayWrap3;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
  Item        : Integer;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen und wieder Auffüllen, damit der Puffer um ein Element
  // über das obere Array Ende hinaus von unten wieder beginnend geht
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1000, Item, 'Entnommenes Element hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i+1000);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auffüllen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Size);
  CheckAndClearEventFlags(evRemove);

  CheckEquals(0, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach Entnahme');
  for i := 0 to high(ReturnValue) do
    CheckEquals(i+3+1000, ReturnValue[i], 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestRemoveException;
var
  ReturnValue : Integer;
begin
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss bei Prüfungsbeginn leer sein!');

  // Prüfung, dass das Entfernen von items bei leerem Puffer eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferEmptyException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  ReturnValue := FRingbuffer.Remove;
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdrückt
  CheckEquals(100, ReturnValue, 'Entnommenes Element ist falsch');
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();

  // Prüfen, dass es auch bei nicht initial leerem Puffer zu einer Exception kommt
  FRingbuffer.Add(-1000);
  ReturnValue := FRingbuffer.Remove;
  CheckEquals(-1000, ReturnValue, 'Entnommenes Element ist falsch');
  CheckAndClearEventFlags(evRemove);

  // einmal zuviel entnehmen
  StartExpectingException(EBufferEmptyException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  ReturnValue := FRingbuffer.Remove;
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdrückt
  CheckEquals(100, ReturnValue, 'Entnommenes Element ist falsch');
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();
end;

procedure TestTRingbufferInt.TestRemoveNoNotify;
begin
  FRingbuffer.Notify := nil;

  FRingbuffer.Add(1000000);
  CheckAndClearNoEventFlagsSet;

  CheckEquals(1000000, FRingbuffer.Remove, 'Entnommenes Element ist falsch');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestRemoveWrap1;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
  Item : Integer;
begin
  // Puffer komplett füllen, ein Element entfernen und wieder auffüllen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen Überlauf um 1 Element über das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // 1 Element löschen
  Item := FRingbuffer.Remove;
  CheckEquals(1000,               Item,              'Entfernter Eintrag hat falschen Wert');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evRemove);

  // 1 Element hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add(1005);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1001,                 Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer (Schleife)');
    CheckAndClearEventFlags(evRemove);
  end;
end;

procedure TestTRingbufferInt.TestRemoveWrap3;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
  Item : Integer;
begin
  // Puffer komplett füllen, ein Element entfernen und wieder auffüllen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen Überlauf um 1 Element über das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // 3 Elemente löschen
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1000,             Item,              'Entfernter Eintrag hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // 3 Elemente hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add(1005);
  FRingbuffer.Add(1006);
  FRingbuffer.Add(1007);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+3+1000, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer (Schleife)');
    CheckAndClearEventFlags(evRemove);
  end;
end;

procedure TestTRingbufferInt.TestDelete;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Integer;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // das eigentliche Löschen
  FRingbuffer.Delete(1);
  CheckAndClearEventFlags(evRemove);
  ReturnValue := FRingBuffer.Peek(0, FRingbuffer.Count);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer nach Delete');

  for i := 0 to high(ReturnValue) do
  begin
    CheckEquals(i+1+1000, ReturnValue[i], 'Falscher Wert im Puffer');
  end;

  // alle bis auf einen löschen
  FRingbuffer.Delete(FRingbuffer.Size-2);
  CheckAndClearEventFlags(evRemove);
  CheckEquals(1, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer nach 2. Delete');
  CheckEquals(FRingbuffer.Size-1+1000, FRingbuffer.Peek(0), 'Falscher Wert nach 2. Delete');
end;

procedure TestTRingbufferInt.TestDeleteAll;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // Alle Einträge auf einmal löschen
  FRingbuffer.Delete(FRingbuffer.Size);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(0, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer nach dem Löschen');

  FRingbuffer.Add(123000);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(123000, FRingbuffer.Peek(0), 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestDeleteException;
begin
  // Prüfung, dass das Entfernen von mehr Items als Puffergröße eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // Versuchen ein Element mit falschem Index zu extrahieren
  FRingbuffer.Delete(FRingbuffer.Size+1);
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();

end;

procedure TestTRingbufferInt.TestDeleteNoNotify;
begin
  FRingbuffer.Notify := nil;
  FRingBuffer.Add(1000);

  CheckAndClearNoEventFlagsSet;
  FRingbuffer.Delete(1);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(0, FRingbuffer.Count, 'Puffer ist nicht leer');
end;

procedure TestTRingbufferInt.TestDeleteSize0;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // nix löschen
  FRingbuffer.Delete(0);
  // wenn nix gelöscht auch keine Benachrichtigung!
  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer '+
                                                   'nach Löschen von 0 Einträgen');

  // Werte prüfen
  for i := 0 to FRingbuffer.Size-1 do
    CheckEquals(i+1000, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestDeleteWrap1;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // Ein Element entfernen und eines hinzufügen, damit Puffer über obere Array
  // Grenze geht
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size+1000);
  CheckAndClearEventFlags(evAdd);

  // Ein Element löschen und Puffer prüfen
  FRingbuffer.Delete(1);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer nach Löschen');

  // Werte prüfen
  for i := 0 to FRingbuffer.Size-2 do
    CheckEquals(i+2+1000, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestDeleteWrap3;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
begin
  // Daten vorbereiten
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // 3 Elemente entfernen und 3 hinzufügen, damit Puffer über obere Array
  // Grenze geht
  FRingbuffer.Remove(3);
  CheckAndClearEventFlags(evRemove);

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i+1000);

  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // Ein Element löschen und Puffer prüfen
  FRingbuffer.Delete(3);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer nach Löschen');

  // Werte prüfen
  for i := 0 to FRingbuffer.Count-1 do
    CheckEquals(i+6+1000, FRingbuffer.Peek(i), 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestPeek;
var
  ReturnValue : Integer;
  i           : Byte;
begin
  FRingbuffer.Add(10000);
  CheckAndClearEventFlags(evAdd);

  ReturnValue := FRingbuffer.Peek(0);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(10000, ReturnValue, 'Falscher Wert aus dem Puffer geliefert1');
  // sicherstellen, dass auch nach Peek der Wert noch im Puffer ist
  ReturnValue := FRingbuffer.Peek(0);
  CheckEquals(10000, ReturnValue, 'Falscher Wert aus dem Puffer geliefert2');

  // auch bei vollem Puffer soll es funktionieren
  FRingbuffer.Clear;
  CheckAndClearEventFlags(evRemove);

  for i := 0 to FRingbuffer.Size-1 do
    FRingbuffer.Add(i+100000);

  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
  begin
    ReturnValue := FRingbuffer.Peek(i);
    CheckEquals(i+100000, ReturnValue, 'Falscher Wert aus dem Puffer geliefert3');
  end;
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestPeekArray;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+100000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // alle Elemente mittels Peek holen
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Spicken darf Puffergröße nicht ändern');
  CheckEquals(FRingbuffer.Size, length(ReturnValue), 'Falsche Größe der gelieferten Daten');

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals(i+100000, ReturnValue[i], 'Falscher Wert');

  // nur ein Element holen
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckEquals(1,      length(ReturnValue), 'Falsche Größe der gelieferten Daten');
  CheckEquals(100001, ReturnValue[0], 'Falscher Wert');

  // 2 Elemente holen
  ReturnValue := FRingbuffer.Peek(1, 2);
  CheckEquals(2,      length(ReturnValue), 'Falsche Größe der gelieferten Daten');
  CheckEquals(100001, ReturnValue[0], 'Falscher Wert');
  CheckEquals(100002, ReturnValue[1], 'Falscher Wert');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestPeekArrayException;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
begin
  // Exception bei Index > Count prüfen
  FRingbuffer.Add(1000);
  CheckAndClearEventFlags(evAdd);

  // Prüfung, dass das Entfernen von mehr Items als Puffergröße eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // Versuchen ein Element mit falschem Index zu extrahieren
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();

  // Puffer für nächsten Test leeren
  FRingbuffer.Clear;
  CheckAndClearEventFlags(evRemove);

  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');

  // Prüfung, dass das Entfernen von mehr Items als Puffergröße eine Exception auslöst
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anhält und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Auslösung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  SetLength(ReturnValue, FRingbuffer.Size+1);
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size+1);
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();
end;

procedure TestTRingbufferInt.TestPeekArraySize0;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
  Item        : Integer;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 0 Items entnehmen
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Peek(0, 0);

  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Spicken darf Puffergröße nicht ändern');

  // Pufferinhalt prüfen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckAndClearNoEventFlagsSet;
    CheckEquals(i+1000, Item, 'Falscher Wert');
  end;
end;

procedure TestTRingbufferInt.TestPeekArrayWrap1;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Integer;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');

  // Ein Element entnehmen und wieder Auffüllen, damit der Puffer um ein Element
  // über das obere Array Ende hinaus von unten wieder beginnend geht
  i := FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);
  CheckEquals(1000, i, 'Entnommenes Element hat falschen Wert');

  FRingbuffer.Add(FRingbuffer.Size+1000);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auffüllen');

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach Entnahme');
  for i := 0 to high(ReturnValue) do
    CheckEquals(i+1+1000, ReturnValue[i], 'Falscher Wert im Puffer');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestPeekArrayWrap3;
var
  Items       : TRingbuffer<Integer>.TRingbufferArray;
  ReturnValue : TRingbuffer<Integer>.TRingbufferArray;
  i           : Byte;
  Item        : Integer;
begin
  // Puffer komplett füllen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');

  // 3 Elemente entnehmen und wieder Auffüllen, damit der Puffer um ein Element
  // über das obere Array Ende hinaus von unten wieder beginnend geht
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1000, Item, 'Entnommenes Element hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i+1000);

  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auffüllen');

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);

  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach Entnahme');
  for i := 0 to high(ReturnValue) do
    CheckEquals(i+3+1000, ReturnValue[i], 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestPeekException;
var
  ReturnValue: Integer;
begin
  FRingbuffer.Add(123000);
  CheckAndClearEventFlags(evAdd);

  StartExpectingException(EArgumentOutOfRangeException);

  ReturnValue := FRingbuffer.Peek(0);
  CheckEquals(123000, ReturnValue, 'Falscher Wert im Puffer');
  CheckAndClearNoEventFlagsSet;

  // Versuchen ein Element hinter dem aktuellen Pufferende zu lesen
  ReturnValue := FRingbuffer.Peek(1);
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdrückt
  CheckEquals(100, ReturnValue, 'Entnommenes Element ist falsch');
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();
end;

procedure TestTRingbufferInt.TestPeekWrap1;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
  Item : Integer;
begin
  // Puffer komplett füllen, ein Element entfernen und wieder auffüllen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen Überlauf um 1 Element über das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // 1 Element löschen
  Item := FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);
  CheckEquals(1000,               Item,              'Entfernter Eintrag hat falschen Wert');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // 1 Element hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add(1005);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i+1+1000, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer (Schleife)');
  end;

  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestPeekWrap3;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
  Item : Integer;
begin
  // Puffer komplett füllen, ein Element entfernen und wieder auffüllen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen Überlauf um 1 Element über das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+100000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // 3 Elemente löschen
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+100000,         Item,              'Entfernter Eintrag hat falschen Wert');
  end;

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // 3 Elemente hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add(100005);
  FRingbuffer.Add(100006);
  FRingbuffer.Add(100007);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer');

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);

    CheckEquals(i+3+100000,       Item,              'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Einträgen im Puffer (Schleife)');
  end;
  CheckAndClearNoEventFlagsSet;
end;

{ TestTRingbuffer -------------------------------------------------------------}

procedure TestTObjectRingbuffer.SetUp;
begin
  FObjectRingbuffer        := TObjectRingbuffer<TTestItem>.Create(5);
  FObjectRingbuffer.Notify := OnNotify;
end;

procedure TestTObjectRingbuffer.TearDown;
begin
  FObjectRingbuffer.Free;
  FObjectRingbuffer := nil;
end;

procedure TestTObjectRingbuffer.TestClear;
begin

end;

procedure TestTObjectRingbuffer.TestCreate;
//var
//  OwnsObjects: Boolean;
//  Size: Cardinal;
begin
//
end;

procedure TestTObjectRingbuffer.TestDelete;
begin

end;

procedure TestTObjectRingbuffer.TestPeek;
var
  Items     : TRingbuffer<TTestItem>.TRingbufferArray;
  PeekItems : TRingbuffer<TTestItem>.TRingbufferArray;
  i         : Integer;
begin
  FObjectRingbuffer.OwnsObjects := true;

  // Testdaten vorbereiten
  SetLength(Items, 5);
  for i := 0 to length(Items)-1 do
    Items[i] := TTestItem.Create('Testname'+i.ToString, 30+i, 2);

  FObjectRingbuffer.Add(Items);

  // Daten mittels Peek holen, prüfen und Peek-Array nicht freigeben
  PeekItems := FObjectRingbuffer.Peek(0, 3);

  for i := Low(PeekItems) to High(PeekItems) do
  begin
    CheckEquals('Testname'+i.ToString, PeekItems[i].Name, 'falscher Name');
    CheckEquals(30+i,                  PeekItems[i].Age,  'falsches Alter');
    CheckEquals(1, PeekItems[i].AgeChildren[0], 'falsches Alter Kind 1');
    CheckEquals(2, PeekItems[i].AgeChildren[1], 'falsches Alter Kind 2');
  end;

  // Speicher freigeben
  SetLength(Items, 0);
  SetLength(PeekItems, 0);
end;

procedure TestTObjectRingbuffer.TestRemove;
begin

end;

{ TTestItem }

constructor TTestItem.Create(Name: string; Age, NumberOfChildren: Integer);
var
  i : Integer;
begin
  inherited Create;

  self.Name := Name;
  self.Age  := Age;
  SetLength(AgeChildren, NumberOfChildren);

  if (NumberOfChildren > 0) then
    for i := 0 to high(AgeChildren) do
      AgeChildren[i] := i + 1;
end;

{ TestTRingbufferString }

procedure TestTRingbufferString.SetUp;
begin
  FRingbuffer        := TRingbuffer<string>.Create(5);
  FRingbuffer.Notify := OnNotify;
  ClearEventFlags;
end;

procedure TestTRingbufferString.TearDown;
begin
  FRingbuffer.Free;
  FRingbuffer := nil;
end;

procedure TestTRingbufferString.TestClear;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
begin
  // Puffer teilweise füllen
  for i := 1 to 3 do
    FRingbuffer.Add('Item' + i.ToString);

  CheckEquals(3, FRingbuffer.Count, 'Wrong fill level');
  CheckAndClearEventFlags(evAdd);

  // und leeren
  FRingbuffer.Clear;
  CheckEquals(0, FRingbuffer.Count, 'Buffer is not empty');
  CheckAndClearEventFlags(evRemove);

  // Leeren Puffer muss man jetzt auch komplett füllen dürfen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := 'Item' + i.ToString;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Buffer must be filled completely');
  CheckAndClearEventFlags(evAdd);

  // und leeren
  FRingbuffer.Clear;
  CheckEquals(0, FRingbuffer.Count, 'Buffer not empty');
  CheckAndClearEventFlags(evRemove);
end;

procedure TestTRingbufferString.TestClearNoNotify;
begin
  FRingbuffer.Notify := nil;

  FRingbuffer.Add('Test item');
  CheckEquals(1,           FRingbuffer.Count,   'Invalid count');
  CheckEquals('Test item', FRingbuffer.Peek(0), 'Invalid buffer contents');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestCreate;
var
  Size, Count: Cardinal;
begin
  Size  := FRingBuffer.Size;
  Count := FRingBuffer.Count;

  CheckEquals(5, Size,  'Invalid buffer size');
  CheckEquals(0, Count, 'Buffer must be empty directly after creation');
end;

procedure TestTRingbufferString.TestAddWhenEmpty;
var
  i    : Byte;
  Item : Integer;
begin
  // Fill buffer completely
  for i := 1 to FRingbuffer.Size  do
  begin
    Item := i-1000;
    FRingbuffer.Add('Item' + Item.ToString);

    CheckEquals(i,                          FRingbuffer.Count,     'Count is wrong ('+i.ToString+')');
    CheckEquals('Item' + (i-1000).ToString, FRingbuffer.Peek(i-1), 'Invalid value');
    CheckAndClearEventFlags(evAdd);
  end;
end;

procedure TestTRingbufferString.TestAddWrapAround;
var
  i    : Byte;
  Item : Integer;
begin
  // Fill buffer completely
  for i := 1 to FRingbuffer.Size do
  begin
    Item := i-1000;
    FRingbuffer.Add('Item' + Item.ToString);

    CheckEquals(i,                          FRingbuffer.Count,     'Count is wrong ('+i.ToString+')');
    CheckEquals('Item' + (i-1000).ToString, FRingbuffer.Peek(i-1), 'Invalid value');
    CheckAndClearEventFlags(evAdd);
  end;

  // Remove first item. End pointer points to last array element now and next
  // call to add must add at the beginning, means it must detect that it starts
  // from 0 again
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  Item := 6000;
  FRingbuffer.Add('Item' +Item.ToString);
  CheckEquals(FRingbuffer.Size,       FRingbuffer.Count,  'Count is wrong ('+
                                                          FRingbuffer.Count.ToString+')');
  CheckEquals('Item' + Item.ToString, FRingbuffer.Peek(FRingbuffer.Size-1), 'Wrong value in last item');
  CheckAndClearEventFlags(evAdd);
end;

procedure TestTRingbufferString.TestArrayAddNoNotify;
var
  Items : TRingbuffer<string>.TRingbufferArray;
  i     : Byte;
begin
  FRingbuffer.Notify := nil;

  SetLength(Items, 5);
  for i := 0 to High(Items) do
    Items[i] := 'Item' + (i + 1000).ToString;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count,     'Count is wrong ('+
                                                       FRingbuffer.Count.ToString+')');
  CheckAndClearNoEventFlagsSet;

  SetLength(Items, 0);
  Items := FRingbuffer.Remove(5);

  for i := 0 to High(Items) do
    CheckEquals('Item'+ (i + 1000).ToString, Items[i],
                'Wrong value in buffer. Expected: ' + i.ToString + ' Actual: '+Items[i]);
end;

procedure TestTRingbufferString.TestAddArrayWhenEmpty;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  Item : string;
  i    : Byte;
begin
  SetLength(Items, 3);
  Items[0] := 'Item1000';
  Items[1] := 'Item1001';
  Items[2] := 'Item1002';

  FRingbuffer.Add(Items);
  CheckEquals(3, FRingbuffer.Count, 'Wrong count');
  CheckAndClearEventFlags(evAdd);

  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals('Item' + (i+1000).ToString, Item, 'Wrong value in buffer');
  end;
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestAddArrayWhenEmptyFull;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  Item : string;
  i    : Byte;
begin
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong count');
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals('Item' + (i+1000).ToString, Item, 'Wrong value in buffer');
  end;
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestAddArrayEndLessStart1;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
begin
  InitBuffer(Items);

  // Buffer is completely full, but still starts at 0
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
    CheckEquals('Item' + (i+1000).ToString, FRingbuffer.Peek(i), 'Wrong value in buffer');

  // remove 1 item, start is 1 now and the end pointer still 0 and thus
  // end index < start index
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  // Add one single element as array
  SetLength(Items, 1);
  Items[0] := 'Item-100';

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-2 do
    CheckEquals('Item' + (i+1+1000).ToString, FRingbuffer.Peek(i), 'Wrong value in buffer');
  // check item added later
  CheckEquals('Item-100', FRingbuffer.Peek(FRingbuffer.Size-1), 'Item added later has wrong value');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestAddArrayEndLessStart3;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
begin
  InitBuffer(Items);

  // Buffer is completely full, but still starts at 0
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
    CheckEquals('Item' + (i+1000).ToString, FRingbuffer.Peek(i), 'Wrong value in buffer');

  // Remove 3 elements, start is 3 now and end index still 0
  // and thus end index < start index
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  // add 3 items
  SetLength(Items, FRingbuffer.Size-2);
  Items[0] := 'Item10000';
  Items[1] := 'Item15000';
  Items[2] := 'Item20000';

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to 1 do
    CheckEquals('Item'+(i+3+1000).ToString, FRingbuffer.Peek(i), 'Wrong value in buffer');
  // check items added later
  CheckEquals('Item10000', FRingbuffer.Peek(2), 'Item added later has wrong value');
  CheckEquals('Item15000', FRingbuffer.Peek(3), 'Item added later has wrong value');
  CheckEquals('Item20000', FRingbuffer.Peek(4), 'Item added later has wrong value');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestAddArrayEnptyArray;
var
  Items: TRingbuffer<string>.TRingbufferArray;
begin
  CheckEquals(0, FRingbuffer.Count, 'Buffer needs to be empty');

  // Tests adding a complete array
  // This test is meant to test a debug build with assertions turned on
  SetLength(Items, 0);

  // Check that adding too many items raises an exception.
  // Both breakpoints are here on purpose and the properties of those have
  // been defined in such a way, that the IDE will not stop due to exceptions
  // between those. It will not stop on these breakpoints either.
  // The test whether the exception raises still works!
  StartExpectingException(EAssertionFailed);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();

  CheckEquals(0, FRingbuffer.Count, 'Buffer must still be empty after adding nothing');
end;

procedure TestTRingbufferString.TestAddArrayException;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
begin
  InitBuffer(Items);

  FRingbuffer.Add('Item1');
  CheckAndClearEventFlags(evAdd);

  // Check that adding too many items raises an exception.
  // Both breakpoints are here on purpose and the properties of those have
  // been defined in such a way, that the IDE will not stop due to exceptions
  // between those. It will not stop on these breakpoints either.
  // The test whether the exception raises still works!
  StartExpectingException(EBufferFullException);

  // Add some array which does not fit in due to not enough available space
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();

  // fill up buffer "manually"
  for i := 2 to FRingbuffer.Size do
    FRingbuffer.Add(i.ToString);

  CheckAndClearEventFlags(evAdd);

  // remove the first element from a completely full buffer
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);
  // Now end index is smaller start index and space for one element is available
  SetLength(Items, 2);
  Items[0] := 'Item10';
  Items[1] := 'Item11';

  // Check that adding too many items raises an exception.
  // Both breakpoints are here on purpose and the properties of those have
  // been defined in such a way, that the IDE will not stop due to exceptions
  // between those. It will not stop on these breakpoints either.
  // The test whether the exception raises still works!
  StartExpectingException(EBufferFullException);

  // Add some array which does not fit in due to not enough available space
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();
end;

procedure TestTRingbufferString.TestAddArrayPartiallyFilled;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
begin
  FRingbuffer.Add('Item100000');
  CheckAndClearEventFlags(evAdd);

  SetLength(Items, 1);
  Items[0] := 'Item100001';
  FRingbuffer.Add(Items);

  CheckEquals(2, FRingbuffer.Count, 'Wrong number of items in the buffer');
  for i := 0 to 1 do
    CheckEquals('Item'+(i+100000).ToString, FRingbuffer.Peek(i),
                'Wrong value is in the buffer');

  // Puffer weiter füllen
  SetLength(Items, 2);
  Items[0] := 'Item100002';
  Items[1] := 'Item100003';
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  CheckEquals(4, FRingbuffer.Count, 'Wrong number of items in the buffer2');
  for i := 0 to 3 do
    CheckEquals('Item'+(i+100000).ToString, FRingbuffer.Peek(i),
                'Wrong value is in the buffer2');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestAddArrayWrap1;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
begin
  // Test overflow of one item
  FRingbuffer.Add('Item1000');
  FRingbuffer.Add('Item1001');
  CheckAndClearEventFlags(evAdd);
  // remove first entry again. Start index points to 2nd item, 1st position is free
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  SetLength(Items, FRingbuffer.Size-1);
  for i := 0 to FRingbuffer.Size-2 do
    Items[i] := 'Item' + (i+1002).ToString;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong number of items in the buffer');

  for i := 0 to FRingbuffer.Count-1 do
    CheckEquals('Item' + (i+1001).ToString, FRingbuffer.Peek(i), 'Wrong value is in the buffer');
end;

procedure TestTRingbufferString.TestAddArrayWrap3;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
begin
  // Test with 3 items overflow. Fill buffer so far that adding 4 items leads to
  // an overflow of 3 items
  FRingbuffer.Add('Item1000');
  FRingbuffer.Add('Item1001');
  FRingbuffer.Add('Item1002');
  FRingbuffer.Add('Item1003');
  CheckAndClearEventFlags(evAdd);
  // remove first 3 elements again
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  SetLength(Items, FRingbuffer.Size-1);
  for i := 0 to FRingbuffer.Size-2 do
    Items[i] := 'Item' + (i+1004).ToString;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong number of items is in the buffer');

  for i := 0 to FRingbuffer.Count-1 do
    CheckEquals('Item' + (i+1003).ToString, FRingbuffer.Peek(i), 'Wrong value is in the buffer');
end;

procedure TestTRingbufferString.TestAddException;
var
  i    : Byte;
  Item : string;
begin
  // Fill buffer completely at first
  for i := 1 to FRingbuffer.Size do
  begin
    Item := 'Item' + (i-1000).ToString;
    FRingbuffer.Add(Item);

    CheckEquals(i, FRingbuffer.Count, 'Wrong number of items ('+i.ToString+')');
    CheckAndClearEventFlags(evAdd);
  end;

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Buffer is not completely full!');

  // Check that adding too many items raises an exception.
  // Both breakpoints are here on purpose and the properties of those have
  // been defined in such a way, that the IDE will not stop due to exceptions
  // between those. It will not stop on these breakpoints either.
  // The test whether the exception raises still works!
  StartExpectingException(EBufferFullException);

  // add one item too many
  Item := 'Item' + (FRingbuffer.Size+1).ToString;
  FRingbuffer.Add(Item);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count,
              'Buffer is not completely full any more!');
end;

procedure TestTRingbufferString.TestAddNoNotify;
begin
  FRingbuffer.Notify := nil;
  FRingbuffer.Add('Item1000');

  CheckEquals('Item1000', FRingbuffer.Peek(0), 'Wrong value');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestRemove;
var
  ReturnValue : string;
  Item        : string;
  i           : Byte;
begin
  // check with one item first
  Item := 'Item1';
  FRingbuffer.Add(Item);
  CheckEquals(1, FRingbuffer.Count, 'Wrong number of items');
  CheckAndClearEventFlags(evAdd);

  ReturnValue := FRingbuffer.Remove;
  CheckEquals(0, FRingbuffer.Count, 'Wrong number of items2');
  CheckEquals('Item1', ReturnValue, 'Removed item is wrong');
  CheckAndClearEventFlags(evRemove);

  // Now check with full buffer
  // Fill buffer completely at firs
  for i := FRingbuffer.Size downto 1 do
  begin
    Item := 'Item' + (i+1000).ToString;
    FRingbuffer.Add(Item);
  end;

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Buffer is not full!');
  CheckAndClearEventFlags(evAdd);

  // Empty buffer completely
  for i := FRingbuffer.Size downto 1 do
  begin
    ReturnValue := FRingbuffer.Remove;

    CheckEquals(i-1,                        FRingbuffer.Count, 'Wrong number of items3');
    CheckEquals('Item' + (i+1000).ToString, ReturnValue,       'Removed item is wrong2');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(0, FRingbuffer.Count, 'Puffer ist nicht leer!');
end;

procedure TestTRingbufferString.TestRemoveArray;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  Count       : Cardinal;
  i           : Byte;

begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong number of items');
  CheckAndClearEventFlags(evAdd);

  // Remove 3 items, check items and buffer count
  Count := 3;
  SetLength(ReturnValue, 3);
  ReturnValue := FRingbuffer.Remove(Count);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Wrong number of remaining items in buffer');
  CheckAndClearEventFlags(evRemove);

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals('Item' + (i+1000).ToString, ReturnValue[i], 'Wrong value in removed array');
end;

procedure TestTRingbufferString.TestRemoveArrayException;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong number of items in buffer!');
  CheckAndClearEventFlags(evAdd);

  // Check that adding too many items raises an exception.
  // Both breakpoints are here on purpose and the properties of those have
  // been defined in such a way, that the IDE will not stop due to exceptions
  // between those. It will not stop on these breakpoints either.
  // The test whether the exception raises still works!
  StartExpectingException(EArgumentOutOfRangeException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  SetLength(ReturnValue, FRingbuffer.Size+1);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Size+1);
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();
end;

procedure TestTRingbufferString.TestRemoveArrayNoNotify;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Integer;
begin
  FRingbuffer.Notify := nil;

  // Fill buffer completely
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := 'Item' + (i + 100000).ToString;

  FRingBuffer.Add(Items);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Count);

  CheckAndClearNoEventFlagsSet;

  for i := 0 to High(ReturnValue) do
    CheckEquals('Item' + (i + 100000).ToString, ReturnValue[i], 'Wrong value. Expected: ' +
                 i.ToString + ' Actual: ' + ReturnValue[i]);
end;

procedure TestTRingbufferString.TestRemoveArraySize0;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Byte;
  Item        : string;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // Remove 0 items
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Remove(0);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Removing 0 items may not alter count!');
  CheckAndClearEventFlags(evRemove);

  // Pufferinhalt prüfen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals('Item' + (i-1000).ToString, Item, 'Wrong value');
  end;
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestRemoveArrayWrap1;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Integer;
  s           : string;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong number of elements in buffer');
  CheckAndClearEventFlags(evAdd);

  // Remove one element and refill buffer so that the buffer begins at a position
  // one item above the upper end of the array which results in a begin from its
  // low end
  s := FRingbuffer.Remove;
  CheckEquals('Item1000', s, 'Removed item has wrong value');
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add('Item' + (FRingbuffer.Size+1000).ToString);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong item count after refilling buffer');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Size);
  CheckAndClearEventFlags(evRemove);

  CheckEquals(0, FRingbuffer.Count, 'Wrong item count after removal');
  for i := 0 to high(ReturnValue) do
    CheckEquals('Item' + (i+1+1000).ToString, ReturnValue[i], 'Wrong value in buffer');
end;

procedure TestTRingbufferString.TestRemoveArrayWrap3;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Byte;
  Item        : string;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wroing number of items in buffer');
  CheckAndClearEventFlags(evAdd);

  // Remove 3 elements and refill buffer so that the buffer begins at a position
  // one item above the upper end of the array which results in a begin from its
  // low end
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals('Item' + (i+1000).ToString, Item, 'Removed item has wrong value');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add('Item' + (FRingbuffer.Size+i+1000).ToString);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong item count after refilling');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und prüfen
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Remove(FRingbuffer.Size);
  CheckAndClearEventFlags(evRemove);

  CheckEquals(0, FRingbuffer.Count, 'Wrong item count after removal');
  for i := 0 to high(ReturnValue) do
    CheckEquals('Item' + (i+3+1000).ToString, ReturnValue[i], 'Wrong value in buffer');
end;

procedure TestTRingbufferString.TestRemoveException;
var
  ReturnValue : string;
begin
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss bei Prüfungsbeginn leer sein!');

  // Check that removing items from an empty buffer raises an exception.
  // Both breakpoints are here on purpose and the properties of those have
  // been defined in such a way, that the IDE will not stop due to exceptions
  // between those. It will not stop on these breakpoints either.
  // The test whether the exception raises still works!
  StartExpectingException(EBufferEmptyException);

  // try to remove an item from empty buffer
  ReturnValue := FRingbuffer.Remove;
  // Dummy check which should never be reached due to the exception but will
  // suppress a compiler warning about a never used ReturnValue
  CheckEquals('Item100', ReturnValue, 'Removed item is wrong');
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();

  // CHeck that an not initially empty buffer raises an exception as well
  FRingbuffer.Add('Item-1000');
  ReturnValue := FRingbuffer.Remove;
  CheckEquals('Item-1000', ReturnValue, 'Removed item is wrong');
  CheckAndClearEventFlags(evRemove);

  // remove one item too many
  StartExpectingException(EBufferEmptyException);

  // try to remove an item when the buffer is empty
  ReturnValue := FRingbuffer.Remove;

  // Dummy check which should never be reached due to the exception but will
  // suppress a compiler warning about a never used ReturnValue
  CheckEquals('Item100', ReturnValue, 'Removed item is wrong');
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();
end;

procedure TestTRingbufferString.TestRemoveNoNotify;
begin
  FRingbuffer.Notify := nil;

  FRingbuffer.Add('Item1000000');
  CheckAndClearNoEventFlagsSet;

  CheckEquals('Item1000000', FRingbuffer.Remove, 'Removed item is wrong');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestRemoveWrap1;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
  Item : string;
begin
  // Fill buffer completely, remove one item and refill and then remove all
  // items in a loop (that's the real test because there will be 1 item overflow
  // over the end of the array).
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // Delete 1 item
  Item := FRingbuffer.Remove;
  CheckEquals('Item1000',         Item,              'Removed item has wrong value');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Wrong number of items in the buffer');
  CheckAndClearEventFlags(evRemove);

  // Add 1 item to refill the buffer. Now the buffer spills over the high end
  // of the array
  FRingbuffer.Add('Item1005');
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Wrong number of items in the buffer2');
  CheckAndClearEventFlags(evAdd);

  // now remove all items, one by one in a loop
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals('Item' + (i+1001).ToString, Item, 'Removed item has wrong value (loop)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Wrong number of items in the buffer (loop)');
    CheckAndClearEventFlags(evRemove);
  end;
end;

procedure TestTRingbufferString.TestRemoveWrap3;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
  Item : string;
begin
  // Fill buffer completely, remove one item and refill and then remove all
  // items in a loop (that's the real test because there will be 1 item overflow
  // over the end of the array).
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // remove 3 items
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals('Item' + (i+1000).ToString, Item, 'Removed item has wrong value');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Item count in buffer is wrong');

  // add 3 items to refil the buffer and to wrap it around at the high end of
  // the array
  FRingbuffer.Add('Item1005');
  FRingbuffer.Add('Item1006');
  FRingbuffer.Add('Item1007');
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Wrong number of entries in the buffer');
  CheckAndClearEventFlags(evAdd);

  // now remove all items one by one
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals('Item' + (i+3+1000).ToString, Item, 'Removed item has wrong value (loop)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Wrong item count (loop)');
    CheckAndClearEventFlags(evRemove);
  end;
end;

procedure TestTRingbufferString.TestDelete;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Integer;
begin
  // Fill buffer
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong item count in buffer');
  CheckAndClearEventFlags(evAdd);

  // The actual deleting
  FRingbuffer.Delete(1);
  CheckAndClearEventFlags(evRemove);
  ReturnValue := FRingBuffer.Peek(0, FRingbuffer.Count);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Wrong item count in buffer after delete');

  for i := 0 to high(ReturnValue) do
  begin
    CheckEquals('Item' + (i+1+1000).ToString, ReturnValue[i], 'Wrong value in buffer');
  end;

  // delete all except one
  FRingbuffer.Delete(FRingbuffer.Size-2);
  CheckAndClearEventFlags(evRemove);
  CheckEquals(1, FRingbuffer.Count, 'Wrong number of items in buffer after 2nd delete');
  CheckEquals('Item' + (FRingbuffer.Size-1+1000).ToString, FRingbuffer.Peek(0), 'Wrong value after 2nd delete');
end;

procedure TestTRingbufferString.TestDeleteAll;
var
  Items : TRingbuffer<string>.TRingbufferArray;
begin
  // Fill buffer
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong item count i buffer');

  // Alle Einträge auf einmal löschen
  FRingbuffer.Delete(FRingbuffer.Size);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(0, FRingbuffer.Count, 'Wrong number of items in buffer after deleting');

  FRingbuffer.Add('Item123000');
  CheckAndClearEventFlags(evAdd);
  CheckEquals('Item123000', FRingbuffer.Peek(0), 'Wrong value in buffer');
end;

procedure TestTRingbufferString.TestDeleteException;
begin
  // Check that removing items from an empty buffer raises an exception.
  // Both breakpoints are here on purpose and the properties of those have
  // been defined in such a way, that the IDE will not stop due to exceptions
  // between those. It will not stop on these breakpoints either.
  // The test whether the exception raises still works!
  StartExpectingException(EArgumentOutOfRangeException);

  // Try to extract an item using a wrong index
  FRingbuffer.Delete(FRingbuffer.Size+1);
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();
end;

procedure TestTRingbufferString.TestDeleteNoNotify;
begin
  FRingbuffer.Notify := nil;
  FRingBuffer.Add('Item1000');

  CheckAndClearNoEventFlagsSet;
  FRingbuffer.Delete(1);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(0, FRingbuffer.Count, 'Buffer is not empty');
end;

procedure TestTRingbufferString.TestDeleteSize0;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  i           : Byte;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong count of items in buffer');

  // delete nothing
  FRingbuffer.Delete(0);
  // if nothing has been deleted no notification is expected either!
  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong count of items in buffer '+
              'after deleting 0 items');

  // Check values
  for i := 0 to FRingbuffer.Size-1 do
    CheckEquals('Item' + (i+1000).ToString, FRingbuffer.Peek(i), 'Wrong value in buffer');
end;

procedure TestTRingbufferString.TestDeleteWrap1;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  i           : Byte;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong item count');

  // Remove one item and add one so that the buffer wraps over the high end of
  // the array
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add('Item' + (FRingbuffer.Size+1000).ToString);
  CheckAndClearEventFlags(evAdd);

  // Delete one element and check buffer
  FRingbuffer.Delete(1);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Wrong number of items after deletion');

  // Check values
  for i := 0 to FRingbuffer.Size-2 do
    CheckEquals('Item' + (i+2+1000).ToString, FRingbuffer.Peek(i), 'Wrong value in buffer');
end;

procedure TestTRingbufferString.TestDeleteWrap3;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  i           : Byte;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong item count');

  // remove 3 items and add 3 items so that the buffer wraps at the high end of
  // the array
  FRingbuffer.Remove(3);
  CheckAndClearEventFlags(evRemove);

  for i := 0 to 2 do
    FRingbuffer.Add('Item' + (FRingbuffer.Size+i+1000).ToString);

  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong item count');

  // Delete one item and check buffer
  FRingbuffer.Delete(3);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Wrong item count after deletion');

  // Check values
  for i := 0 to FRingbuffer.Count-1 do
    CheckEquals('Item' + (i+6+1000).ToString, FRingbuffer.Peek(i), 'Wrong value in buffer');
end;

procedure TestTRingbufferString.TestPeek;
var
  ReturnValue : string;
  i           : Byte;
begin
  FRingbuffer.Add('Item10000');
  CheckAndClearEventFlags(evAdd);

  ReturnValue := FRingbuffer.Peek(0);
  CheckAndClearNoEventFlagsSet;
  CheckEquals('Item10000', ReturnValue, 'Wrong value returned from buffer');
  // ensure that after peer the value is still in the buffer
  ReturnValue := FRingbuffer.Peek(0);
  CheckEquals('Item10000', ReturnValue, 'Wrong value returned from buffer2');

  // must work when buffer is full as well
  FRingbuffer.Clear;
  CheckAndClearEventFlags(evRemove);

  for i := 0 to FRingbuffer.Size-1 do
    FRingbuffer.Add('Item' + (i+100000).ToString);

  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-1 do
  begin
    ReturnValue := FRingbuffer.Peek(i);
    CheckEquals('Item' + (i+100000).ToString, ReturnValue, 'Wrong value returned from buffer3');
  end;
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestPeekArray;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Byte;
begin
  // Fill buffer completely
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := 'Item' + (i+100000).ToString;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // fetch all items with peek
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Peek may not change buffer count');
  CheckEquals(FRingbuffer.Size, length(ReturnValue), 'Wrong count of data returned');

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals('Item' + (i+100000).ToString, ReturnValue[i], 'Wrong value');

  // nur ein Element holen
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckEquals(1,      length(ReturnValue), 'Wrong count of data returned');
  CheckEquals('Item100001', ReturnValue[0], 'Wrong value');

  // 2 Elemente holen
  ReturnValue := FRingbuffer.Peek(1, 2);
  CheckEquals(2,      length(ReturnValue), 'Wrong count of data returned');
  CheckEquals('Item100001', ReturnValue[0], 'Wrong value');
  CheckEquals('Item100002', ReturnValue[1], 'Wrong value');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestPeekArrayException;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Byte;
begin
  // Exception bei Index > Count prüfen
  FRingbuffer.Add('Item1000');
  CheckAndClearEventFlags(evAdd);

  // Check that peeking with an invalid index raises an exception.
  // Both breakpoints are here on purpose and the properties of those have
  // been defined in such a way, that the IDE will not stop due to exceptions
  // between those. It will not stop on these breakpoints either.
  // The test whether the exception raises still works!
  StartExpectingException(EArgumentOutOfRangeException);

  // Attempt to peek an item with an invalid index
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();

  // Empty buffer for the next test
  FRingbuffer.Clear;
  CheckAndClearEventFlags(evRemove);

  // Fill buffer completely
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := 'Item' + (i+1000).ToString;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');

  // Check that peeking with an invalid index raises an exception.
  // Both breakpoints are here on purpose and the properties of those have
  // been defined in such a way, that the IDE will not stop due to exceptions
  // between those. It will not stop on these breakpoints either.
  // The test whether the exception raises still works!
  StartExpectingException(EArgumentOutOfRangeException);

  // Try to peek in an empty buffer
  SetLength(ReturnValue, FRingbuffer.Size+1);
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size+1);
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();
end;

procedure TestTRingbufferString.TestPeekArraySize0;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Byte;
  Item        : string;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // peek 0 items
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Peek(0, 0);

  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Peek is not allowed to change buffer count');

  // Check buffer contents
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckAndClearNoEventFlagsSet;
    CheckEquals('Item' + (i+1000).ToString, Item, 'Wrong value');
  end;
end;

procedure TestTRingbufferString.TestPeekArrayWrap1;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Integer;
  s           : string;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong buffer count');

  // Remove one item and refill, so that the buffer wraps at the high end of the
  // array and restarts at the low end of the array
  s := FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);
  CheckEquals('Item1000', s, 'Removed item has wrong value');

  FRingbuffer.Add('Item' + (FRingbuffer.Size+1000).ToString);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong count after refilling buffer');

  // Peek the complete contents now and check
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong number of items after peek');
  for i := 0 to high(ReturnValue) do
    CheckEquals('Item' + (i+1+1000).ToString, ReturnValue[i], 'Wrong value in buffer');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestPeekArrayWrap3;
var
  Items       : TRingbuffer<string>.TRingbufferArray;
  ReturnValue : TRingbuffer<string>.TRingbufferArray;
  i           : Byte;
  Item        : string;
begin
  // Fill buffer completely
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong buffer count');

  // remove 3 items and refill, so that the buffer wraps att the high end of the
  // array and starts again at its low end
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals('Item' + (i+1000).ToString, Item, 'Removed item has wrong value');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add('Item' + (FRingbuffer.Size+i+1000).ToString);

  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong buffer count after refilling');

  // peek complete buffer contents and check
  SetLength(ReturnValue, FRingbuffer.Size);
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);

  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong buffer count after peek');
  for i := 0 to high(ReturnValue) do
    CheckEquals('Item' + (i+3+1000).ToString, ReturnValue[i], 'Wrong value in buffer');
end;

procedure TestTRingbufferString.TestPeekException;
var
  ReturnValue: string;
begin
  FRingbuffer.Add('Item123000');
  CheckAndClearEventFlags(evAdd);

  StartExpectingException(EArgumentOutOfRangeException);

  ReturnValue := FRingbuffer.Peek(0);
  CheckEquals('Item123000', ReturnValue, 'Wrong value in buffer');
  CheckAndClearNoEventFlagsSet;

  // Try to read one item after the end of the buffer
  ReturnValue := FRingbuffer.Peek(1);
  // Dummy check which should never be reached due to the exception but will
  // suppress a compiler warning about a never used ReturnValue
  CheckEquals('Item100', ReturnValue, 'Peekded item is wrong');
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();
end;

procedure TestTRingbufferString.InitBuffer(var Buffer:TRingbuffer<string>.TRingbufferArray);
var
  i : Integer;
begin
  SetLength(Buffer, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Buffer[i] := 'Item' + (i+1000).ToString;
end;

procedure TestTRingbufferString.TestPeekWrap1;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
  Item : string;
begin
  // Fill buffer completely, remove one item and refill. Then remove all items
  // in a loop (the real test, because that creates an overflow of 1 item over
  // the high end of the array)
  InitBuffer(Items);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // Remove 1 item
  Item := FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);
  CheckEquals('Item1000',         Item,              'Removed item has wrong value');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Wrong buffer count');

  // 1 Element hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add('Item1005');
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Wrong buffer count2');

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals('Item' + (i+1+1000).ToString, Item, 'Removed item has wrong value (loop)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong buffer count (loop)');
  end;

  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferString.TestPeekWrap3;
var
  Items: TRingbuffer<string>.TRingbufferArray;
  i    : Byte;
  Item : string;
begin
  // FIll buffer completely, remove one item and refill. Then remove all items
  // in a loop (the real test, because that creates an overflow of 1 item over
  // the high end of the array)
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := 'Item' + (i+100000).ToString;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // Remove 3 items
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals('Item' + (i+100000).ToString, Item, 'Removed item has wrong value');
  end;

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Wrong buffer count');

  // 3 Elemente hinzufügen damit der Puffer wieder voll ist und über die obere
  // Grenze des Array geht
  FRingbuffer.Add('Item100005');
  FRingbuffer.Add('Item100006');
  FRingbuffer.Add('Item100007');
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Wrong buffer count2');

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);

    CheckEquals('Item' + (i+3+100000).ToString, Item, 'Removed item has wrong value (loop)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Wrong buffer count (loop)');
  end;
  CheckAndClearNoEventFlagsSet;
end;

initialization
  // Alle Testfälle beim Testprogramm registrieren
  RegisterTest(TestTRingbuffer.Suite);
  RegisterTest(TestTRingbufferInt.Suite);
  RegisterTest(TestTRingbufferString.Suite);
  RegisterTest(TestTObjectRingbuffer.Suite);
end.

