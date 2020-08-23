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
    ///   Pr�ft, ob das richtige Eventflag gesetzt ist
    /// </summary>
    /// <param name="EventType">
    ///   Art des Events: evAdd oder evRemove, das jeweilige Flag muss true sein
    ///   und das andere muss false sein
    /// </param>
    procedure CheckEventFlags(EventType : TRingbufferEventType);
    /// <summary>
    ///   Pr�ft, ob das richtige Eventflag gesetzt ist und setzt alle Eventflags
    ///   auf false
    /// </summary>
    /// <param name="EventType">
    ///   Art des Events: evAdd oder evRemove, das jeweilige Flag muss true sein
    ///   und das andere muss false sein
    /// </param>
    procedure CheckAndClearEventFlags(EventType: TRingbufferEventType);
    /// <summary>
    ///   Pr�ft, dass keine der Eventflags gesetzt sind und setzt gesetzte zur�ck,
    ///   da nachfolgende Tests ja von ungesetzten Flags ausgehen werden
    /// </summary>
    procedure CheckAndClearNoEventFlagsSet;
    /// <summary>
    ///   Dieses Ereignis wird bei allen Operationen ausgel�st, die einen Einfluss
    ///   auf den F�llstand des Ringpuffers haben. Hinzuf�gen, Entfernen, L�schen...
    /// </summary>
    /// <param name="Count">
    ///   Neue Anzahl der im Puffer befindlichen Elemente
    /// </param>
    /// <param name="Event">
    ///   Art des ausl�senden Events: wenn Add wurde der F�llstand erh�ht, wenn
    ///   Remove wurde er verringert.
    /// </param>
    procedure OnNotify(Count: UInt32; Event:TRingbufferEventType);
  end;

  // Testmethoden f�r Klasse TRingbuffer

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
  ///   Einfache Datenhaltungsklasse f�r die Tests von TObjectRingbuffer
  /// </summary>
  TTestItem = class(TObject)
  public
    Name        : string;
    Age         : Integer;
    AgeChildren : array of Integer;

    constructor Create(Name: string; Age, NumberOfChildren: Integer);
  end;

  /// <summary>
  ///   Testmethoden f�r Klasse TObjectRingbuffer. Da die Grundlagen bereits in
  ///   den anderen Testklassen getestet werden werden hier nur noch die f�r die
  ///   Speicherverwaltung n�tigen Details getestet.
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
  CheckEquals(false, FAdded,   'Hinzuf�gen Benachrichtigung f�lschlicherweise ausgel�st');
  CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung f�lschlicherweise ausgel�st');
  ClearEventFlags;
end;

procedure BaseTestTRingbuffer.CheckEventFlags(EventType: TRingbufferEventType);
begin
  case EventType of
    evAdd    : begin
                 CheckEquals(true,  FAdded,   'Hinzuf�gen Benachrichtigung nicht ausgel�st');
                 CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung f�lschlicherweise ausgel�st');
               end;
    evRemove : begin
                 CheckEquals(false, FAdded,   'Hinzuf�gen Benachrichtigung f�lschlicherweise ausgel�st');
                 CheckEquals(true,  FRemoved, 'Entfernen Benachrichtigung nicht ausgel�st');
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
  // Puffer teilweise f�llen
  for i := 1 to 3 do
    FRingbuffer.Add(i);

  CheckEquals(3, FRingbuffer.Count, 'Falscher Pufferf�llstand');
  CheckAndClearEventFlags(evAdd);

  // und leeren
  FRingbuffer.Clear;
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nun leer sein');
  CheckAndClearEventFlags(evRemove);

  // Leeren Puffer muss man jetzt auch komplett f�llen d�rfen
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

  CheckEquals(5, Size,  'Falsche Puffergr��e');
  CheckEquals(0, Count, 'Puffer muss zu Beginn leer sein');
end;

procedure TestTRingbuffer.TestAddWhenEmpty;
var
  i    : Byte;
  Item : Byte;
begin
  // Puffer ganz f�llen
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
  // Puffer ganz f�llen
  for i := 1 to FRingbuffer.Size do
  begin
    Item := i;
    FRingbuffer.Add(Item);

    CheckEquals(i, FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+i.ToString+')');
    CheckEquals(i, FRingbuffer.Peek(i-1), 'Falscher Wert');
    CheckAndClearEventFlags(evAdd);
  end;

  // erstes Element entfernen, Endezeiger steht jetzt auf letztem Array Element
  // und n�chster Add-Aufruf muss am Anfang ein Item hinzuf�gen, d.h. kapieren,
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

  // Ein einzelnes Element als Array hinzuf�gen
  SetLength(Items, 1);
  Items[0] := 100;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-2 do
    CheckEquals(i+1, FRingbuffer.Peek(i), 'Pufferinhalt falsch');
  // sp�ter hinzugef�gtes Element pr�fen
  CheckEquals(100, FRingbuffer.Peek(FRingbuffer.Size-1), 'Sp�ter hinzugef�gtes Element hat falschen Wert');
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

  // 3 Elemente hinzuf�gen
  SetLength(Items, FRingbuffer.Size-2);
  Items[0] := 100;
  Items[1] := 150;
  Items[2] := 200;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to 1 do
    CheckEquals(i+3, FRingbuffer.Peek(i), 'Pufferinhalt falsch');
  // sp�ter hinzugef�gte Elemente pr�fen
  CheckEquals(100, FRingbuffer.Peek(2), 'Sp�ter hinzugef�gtes Element hat falschen Wert');
  CheckEquals(150, FRingbuffer.Peek(3), 'Sp�ter hinzugef�gtes Element hat falschen Wert');
  CheckEquals(200, FRingbuffer.Peek(4), 'Sp�ter hinzugef�gtes Element hat falschen Wert');
end;

procedure TestTRingbuffer.TestAddArrayEnptyArray;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
begin
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss leer sein');

  // Testet das hinzuf�gen eines komplett leeren Arrays
  // Dieser Test ist derzeit daf�r ausgelegt, einen Debugbuild mit eingeschalteten
  // Assertions zu pr�fen.
  SetLength(Items, 0);

  // Pr�fung, dass das Hinzuf�gen von zuviel Daten eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EAssertionFailed);

  FRingbuffer.Add(Items);
  CheckEquals(false, FAdded, 'Hinzuf�gen Event f�lschlicherweise ausgel�st');

  StopExpectingException();

  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nach Hinzuf�gen von nichts immer noch leer sein');
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

  // Pr�fung, dass das Hinzuf�gen von zuviel Daten eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // Array hinzuf�gen der nicht mehr hinein passt
  FRingbuffer.Add(Items);
  CheckEquals(false, FAdded, 'Hinzuf�gen Event f�lschlicherweise ausgel�st');

  StopExpectingException();

  // Puffer vollends "manuell" f�llen
  for i := 2 to FRingbuffer.Size do
    FRingbuffer.Add(i);

  // aus dem vollen Puffer das erste Element entfernen
  FRingbuffer.Remove;
  // Damit ist der Ende Marker < Startmarker und 1 Element Platz im Puffer
  SetLength(Items, 2);
  Items[0] := 10;
  Items[1] := 11;

  // Pr�fung, dass das Hinzuf�gen von zuviel Daten eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // Array hinzuf�gen der nicht mehr hinein passt
  FRingbuffer.Add(Items);
  CheckEquals(false, FAdded, 'Hinzuf�gen Event f�lschlicherweise ausgel�st');

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

  // Puffer weiter f�llen
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
  // Test mit 1 Element �berlauf
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
  // Test mit 3 Elementen �berlauf, Puffer soweit f�llen, dass Hinzuf�gen von 4
  // Elementen zum "�berlauf" von 3 Elementen f�hrt
  FRingbuffer.Add(1);
  FRingbuffer.Add(2);
  FRingbuffer.Add(3);
  FRingbuffer.Add(4);
  CheckAndClearEventFlags(evAdd);

  // erste 3 Eintr�ge wieder entfernen
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
  // Puffer zuerst komplett f�llen
  for i := 1 to FRingbuffer.Size do
  begin
    Item := i;
    FRingbuffer.Add(Item);

    CheckEquals(i, FRingbuffer.Count, 'Anzahl Elemente ist falsch ('+i.ToString+')');
  end;

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer ist nicht voll!');
  CheckAndClearEventFlags(evAdd);

  // Pr�fung, dass das Hinzuf�gen von zuviel Daten eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // ein Element zuviel hinzuf�gen
  Item := FRingbuffer.Size+1;
  FRingbuffer.Add(Item);
  CheckEquals(false, FAdded, 'Hinzuf�gen benachrichtigung f�lschlicherweise ausgel�st');

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
  // zuerst mit einem Eintrag pr�fen
  Item := 1;
  FRingbuffer.Add(Item);
  CheckEquals(1, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckAndClearEventFlags(evAdd);

  ReturnValue := FRingbuffer.Remove;
  CheckEquals(0, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckEquals(1, ReturnValue,       'Entnommenes Element ist falsch');
  CheckAndClearEventFlags(evRemove);

  // Jetzt mit vollem Puffer pr�fen
  // Puffer zuerst komplett f�llen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen, Elemente und Pufferf�llstand pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Pr�fung, dass das Entfernen von mehr Items als Puffergr��e eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
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

  // Puffer komplett f�llen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 0 Items entnehmen
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Remove(0);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Entnehmen von nix darf Puffergr��e nicht �ndern');
  CheckAndClearEventFlags(evRemove);

  // Pufferinhalt pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Ein Element entnehmen und wieder Auff�llen, damit der Puffer um ein Element
  // �ber das obere Array Ende hinaus von unten wieder beginnend geht
  i := FRingbuffer.Remove;
  CheckEquals(0, i, 'Entnommenes Element hat falschen Wert');
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auff�llen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen und wieder Auff�llen, damit der Puffer um ein Element
  // �ber das obere Array Ende hinaus von unten wieder beginnend geht
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i, Item, 'Entnommenes Element hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auff�llen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und pr�fen
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
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss bei Pr�fungsbeginn leer sein!');

  // Pr�fung, dass das Entfernen von items bei leerem Puffer eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferEmptyException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  ReturnValue := FRingbuffer.Remove;
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdr�ckt
  CheckEquals(100, ReturnValue, 'Entnommenes Element ist falsch');
  CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung f�lschlicherweise ausgel�st');
  ClearEventFlags;

  StopExpectingException();

  // Pr�fen, dass es auch bei nicht initial leerem Puffer zu einer Exception kommt
  FRingbuffer.Add(1);
  ReturnValue := FRingbuffer.Remove;
  CheckEquals(1, ReturnValue, 'Entnommenes Element ist falsch');
  CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung f�lschlicherweise ausgel�st');
  ClearEventFlags;

  // einmal zuviel entnehmen
  StartExpectingException(EBufferEmptyException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  ReturnValue := FRingbuffer.Remove;
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdr�ckt
  CheckEquals(100, ReturnValue, 'Entnommenes Element ist falsch');
  CheckEquals(false, FRemoved, 'Entfernen Benachrichtigung f�lschlicherweise ausgel�st');
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
  // Puffer komplett f�llen, ein Element entfernen und wieder auff�llen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen �berlauf um 1 Element �ber das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 1 Element l�schen
  Item := FRingbuffer.Remove;
  CheckEquals(0,                  Item,              'Entfernter Eintrag hat falschen Wert');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evRemove);

  // 1 Element hinzuf�gen damit der Puffer wieder voll ist und �ber die obere
  // Grenze des Array geht
  FRingbuffer.Add(5);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer (Schleife)');
    CheckAndClearEventFlags(evRemove);
  end;
end;

procedure TestTRingbuffer.TestRemoveWrap3;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
  Item : Byte;
begin
  // Puffer komplett f�llen, ein Element entfernen und wieder auff�llen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen �berlauf um 1 Element �ber das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente l�schen
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i, Item, 'Entfernter Eintrag hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // 3 Elemente hinzuf�gen damit der Puffer wieder voll ist und �ber die obere
  // Grenze des Array geht
  FRingbuffer.Add(5);
  FRingbuffer.Add(6);
  FRingbuffer.Add(7);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+3, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer (Schleife)');
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // das eigentliche L�schen
  FRingbuffer.Delete(1);
  CheckAndClearEventFlags(evRemove);

  ReturnValue := FRingBuffer.Peek(0, FRingbuffer.Count);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer nach Delete');

  for i := 0 to high(ReturnValue) do
  begin
    CheckEquals(i+1, ReturnValue[i], 'Falscher Wert im Puffer');
  end;

  // alle bis auf einen l�schen
  FRingbuffer.Delete(FRingbuffer.Size-2);
  CheckAndClearEventFlags(evRemove);
  CheckEquals(1,                  FRingbuffer.Count,   'Falsche Anzahl an Eintr�gen im Puffer nach 2. Delete');
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Alle Eintr�ge auf einmal l�schen
  FRingbuffer.Delete(FRingbuffer.Size);
  CheckAndClearEventFlags(evRemove);

  CheckEquals(0, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer nach dem L�schen');

  FRingbuffer.Add(123);
  CheckEquals(123, FRingbuffer.Peek(0), 'Falscher Wert im Puffer');
  CheckAndClearEventFlags(evAdd);
end;

procedure TestTRingbuffer.TestDeleteException;
begin
  // Pr�fung, dass das Entfernen von mehr Items als Puffergr��e eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // nix l�schen
  FRingbuffer.Delete(0);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer '+
                                                   'nach L�schen von 0 Eintr�gen');

  // Werte pr�fen
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // Ein Element entfernen und eines hinzuf�gen, damit Puffer �ber obere Array
  // Grenze geht
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size);
  CheckAndClearEventFlags(evAdd);

  // Ein Element l�schen und Puffer pr�fen
  FRingbuffer.Delete(1);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer nach L�schen');

  // Werte pr�fen
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // 3 Elemente entfernen und 3 hinzuf�gen, damit Puffer �ber obere Array
  // Grenze geht
  FRingbuffer.Remove(3);
  CheckAndClearEventFlags(evRemove);

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Ein Element l�schen und Puffer pr�fen
  FRingbuffer.Delete(3);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer nach L�schen');

  // Werte pr�fen
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
  // Peek darf Benachrichtigungsmechanismus nicht ausl�sen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // alle Elemente mittels Peek holen
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Spicken darf Puffergr��e nicht �ndern');
  CheckEquals(FRingbuffer.Size, length(ReturnValue), 'Falsche Gr��e der gelieferten Daten');
  CheckAndClearNoEventFlagsSet;

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals(i, ReturnValue[i], 'Falscher Wert');

  // nur ein Element holen
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckEquals(1, length(ReturnValue), 'Falsche Gr��e der gelieferten Daten');
  CheckEquals(1, ReturnValue[0], 'Falscher Wert');
  CheckAndClearNoEventFlagsSet;

  // 2 Elemente holen
  ReturnValue := FRingbuffer.Peek(1, 2);
  CheckEquals(2, length(ReturnValue), 'Falsche Gr��e der gelieferten Daten');
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // erstes Element l�schen
  FRingbuffer.Delete(1);
  CheckAndClearEventFlags(evRemove);

  // alle Elemente mittels Peek holen
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Spicken darf Puffergr��e nicht �ndern');
  CheckEquals(FRingbuffer.Count, length(ReturnValue), 'Falsche Gr��e der gelieferten Daten');
  CheckAndClearNoEventFlagsSet;

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals(i+1, ReturnValue[i], 'Falscher Wert');

  // nur ein Element holen
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckEquals(1, length(ReturnValue), 'Falsche Gr��e der gelieferten Daten');
  CheckEquals(2, ReturnValue[0], 'Falscher Wert');
  CheckAndClearNoEventFlagsSet;

  // 2 Elemente holen
  ReturnValue := FRingbuffer.Peek(1, 2);
  CheckEquals(2, length(ReturnValue), 'Falsche Gr��e der gelieferten Daten');
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
  // Exception bei Index > Count pr�fen
  FRingbuffer.Add(1);
  CheckAndClearEventFlags(evAdd);

  // Pr�fung, dass das Entfernen von mehr Items als Puffergr��e eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // Versuchen ein Element mit falschem Index zu extrahieren
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();

  // Puffer f�r n�chsten Test leeren
  FRingbuffer.Clear;
  CheckAndClearEventFlags(evRemove);

  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Pr�fung, dass das Entfernen von mehr Items als Puffergr��e eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 0 Items entnehmen
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Peek(0, 0);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Spicken darf Puffergr��e nicht �ndern');
  CheckAndClearNoEventFlagsSet;

  // Pufferinhalt pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Ein Element entnehmen und wieder Auff�llen, damit der Puffer um ein Element
  // �ber das obere Array Ende hinaus von unten wieder beginnend geht
  i := FRingbuffer.Remove;
  CheckEquals(0, i, 'Entnommenes Element hat falschen Wert');
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auff�llen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen und wieder Auff�llen, damit der Puffer um ein Element
  // �ber das obere Array Ende hinaus von unten wieder beginnend geht
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i, Item, 'Entnommenes Element hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auff�llen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und pr�fen
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
  // Compilerwarnung wg. ReturnValue nie benutzt unterdr�ckt
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
  // Puffer komplett f�llen, ein Element entfernen und wieder auff�llen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen �berlauf um 1 Element �ber das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 1 Element l�schen
  Item := FRingbuffer.Remove;
  CheckEquals(0,                  Item,              'Entfernter Eintrag hat falschen Wert');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evRemove);

  // 1 Element hinzuf�gen damit der Puffer wieder voll ist und �ber die obere
  // Grenze des Array geht
  FRingbuffer.Add(5);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i+1, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer (Schleife)');
    CheckAndClearNoEventFlagsSet;
  end;
end;

procedure TestTRingbuffer.TestPeekWrap3;
var
  Items: TRingbuffer<Byte>.TRingbufferArray;
  i    : Byte;
  Item : Byte;
begin
  // Puffer komplett f�llen, ein Element entfernen und wieder auff�llen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen �berlauf um 1 Element �ber das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente l�schen
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i,                  Item,              'Entfernter Eintrag hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // 3 Elemente hinzuf�gen damit der Puffer wieder voll ist und �ber die obere
  // Grenze des Array geht
  FRingbuffer.Add(5);
  FRingbuffer.Add(6);
  FRingbuffer.Add(7);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i+3, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer (Schleife)');
    CheckAndClearNoEventFlagsSet;
  end;
end;

{ TestTRingbuffer -------------------------------------------------------------}

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
  // Puffer teilweise f�llen
  for i := 1 to 3 do
    FRingbuffer.Add(i);

  CheckEquals(3, FRingbuffer.Count, 'Falscher Pufferf�llstand');
  CheckAndClearEventFlags(evAdd);

  // und leeren
  FRingbuffer.Clear;
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nun leer sein');
  CheckAndClearEventFlags(evRemove);

  // Leeren Puffer muss man jetzt auch komplett f�llen d�rfen
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

  CheckEquals(5, Size,  'Falsche Puffergr��e');
  CheckEquals(0, Count, 'Puffer muss zu Beginn leer sein');
end;

procedure TestTRingbufferInt.TestAddWhenEmpty;
var
  i    : Byte;
  Item : Integer;
begin
  // Puffer ganz f�llen
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
  // Puffer ganz f�llen
  for i := 1 to FRingbuffer.Size do
  begin
    Item := i-1000;
    FRingbuffer.Add(Item);

    CheckEquals(i,      FRingbuffer.Count,     'Anzahl Elemente ist falsch ('+i.ToString+')');
    CheckEquals(i-1000, FRingbuffer.Peek(i-1), 'Falscher Wert');
    CheckAndClearEventFlags(evAdd);
  end;

  // erstes Element entfernen, Endezeiger steht jetzt auf letztem Array Element
  // und n�chster Add-Aufruf muss am Anfang ein Item hinzuf�gen, d.h. kapieren,
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

  // Ein einzelnes Element als Array hinzuf�gen
  SetLength(Items, 1);
  Items[0] := -100;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to FRingbuffer.Size-2 do
    CheckEquals(i+1+1000, FRingbuffer.Peek(i), 'Pufferinhalt falsch');
  // sp�ter hinzugef�gtes Element pr�fen
  CheckEquals(-100, FRingbuffer.Peek(FRingbuffer.Size-1), 'Sp�ter hinzugef�gtes Element hat falschen Wert');
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

  // 3 Elemente hinzuf�gen
  SetLength(Items, FRingbuffer.Size-2);
  Items[0] := 10000;
  Items[1] := 15000;
  Items[2] := 20000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  for i := 0 to 1 do
    CheckEquals(i+3+1000, FRingbuffer.Peek(i), 'Pufferinhalt falsch');
  // sp�ter hinzugef�gte Elemente pr�fen
  CheckEquals(10000, FRingbuffer.Peek(2), 'Sp�ter hinzugef�gtes Element hat falschen Wert');
  CheckEquals(15000, FRingbuffer.Peek(3), 'Sp�ter hinzugef�gtes Element hat falschen Wert');
  CheckEquals(20000, FRingbuffer.Peek(4), 'Sp�ter hinzugef�gtes Element hat falschen Wert');
  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestAddArrayEnptyArray;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
begin
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss leer sein');

  // Testet das hinzuf�gen eines komplett leeren Arrays
  // Dieser Test ist derzeit daf�r ausgelegt, einen Debugbuild mit eingeschalteten
  // Assertions zu pr�fen.
  SetLength(Items, 0);

  // Pr�fung, dass das Hinzuf�gen von zuviel Daten eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EAssertionFailed);

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();

  CheckEquals(0, FRingbuffer.Count, 'Puffer muss nach Hinzuf�gen von nichts immer noch leer sein');
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

  // Pr�fung, dass das Hinzuf�gen von zuviel Daten eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // Array hinzuf�gen der nicht mehr hinein passt
  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  StopExpectingException();

  // Puffer vollends "manuell" f�llen
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

  // Pr�fung, dass das Hinzuf�gen von zuviel Daten eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // Array hinzuf�gen der nicht mehr hinein passt
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

  // Puffer weiter f�llen
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
  // Test mit 1 Element �berlauf
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
  // Test mit 3 Elementen �berlauf, Puffer soweit f�llen, dass Hinzuf�gen von 4
  // Elementen zum "�berlauf" von 3 Elementen f�hrt
  FRingbuffer.Add(1000);
  FRingbuffer.Add(1001);
  FRingbuffer.Add(1002);
  FRingbuffer.Add(1003);
  CheckAndClearEventFlags(evAdd);
  // erste 3 Eintr�ge wieder entfernen
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
  // Puffer zuerst komplett f�llen
  for i := 1 to FRingbuffer.Size do
  begin
    Item := i-1000;
    FRingbuffer.Add(Item);

    CheckEquals(i, FRingbuffer.Count, 'Anzahl Elemente ist falsch ('+i.ToString+')');
    CheckAndClearEventFlags(evAdd);
  end;

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Puffer ist nicht voll!');

  // Pr�fung, dass das Hinzuf�gen von zuviel Daten eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferFullException);

  // ein Element zuviel hinzuf�gen
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
  // zuerst mit einem Eintrag pr�fen
  Item := 1;
  FRingbuffer.Add(Item);
  CheckEquals(1, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckAndClearEventFlags(evAdd);

  ReturnValue := FRingbuffer.Remove;
  CheckEquals(0, FRingbuffer.Count, 'Anzahl Elemente ist falsch');
  CheckEquals(1, ReturnValue,       'Entnommenes Element ist falsch');
  CheckAndClearEventFlags(evRemove);

  // Jetzt mit vollem Puffer pr�fen
  // Puffer zuerst komplett f�llen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen, Elemente und Pufferf�llstand pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Pr�fung, dass das Entfernen von mehr Items als Puffergr��e eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
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

  // Puffer komplett f�llen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i-1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 0 Items entnehmen
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Remove(0);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Entnehmen von nix darf Puffergr��e nicht �ndern');
  CheckAndClearEventFlags(evRemove);

  // Pufferinhalt pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // Ein Element entnehmen und wieder Auff�llen, damit der Puffer um ein Element
  // �ber das obere Array Ende hinaus von unten wieder beginnend geht
  i := FRingbuffer.Remove;
  CheckEquals(1000, i, 'Entnommenes Element hat falschen Wert');
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size+1000);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auff�llen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');
  CheckAndClearEventFlags(evAdd);

  // 3 Elemente entnehmen und wieder Auff�llen, damit der Puffer um ein Element
  // �ber das obere Array Ende hinaus von unten wieder beginnend geht
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1000, Item, 'Entnommenes Element hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i+1000);

  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auff�llen');
  CheckAndClearEventFlags(evAdd);

  // nun den gesamten Pufferinhalt entnehmen und pr�fen
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
  CheckEquals(0, FRingbuffer.Count, 'Puffer muss bei Pr�fungsbeginn leer sein!');

  // Pr�fung, dass das Entfernen von items bei leerem Puffer eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EBufferEmptyException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  ReturnValue := FRingbuffer.Remove;
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdr�ckt
  CheckEquals(100, ReturnValue, 'Entnommenes Element ist falsch');
  CheckAndClearEventFlags(evRemove);

  StopExpectingException();

  // Pr�fen, dass es auch bei nicht initial leerem Puffer zu einer Exception kommt
  FRingbuffer.Add(-1000);
  ReturnValue := FRingbuffer.Remove;
  CheckEquals(-1000, ReturnValue, 'Entnommenes Element ist falsch');
  CheckAndClearEventFlags(evRemove);

  // einmal zuviel entnehmen
  StartExpectingException(EBufferEmptyException);

  // bei leerem Puffer versuchen ein Element zu extrahieren
  ReturnValue := FRingbuffer.Remove;
  // Dummy Abfrage die wg. Exception nie erreicht werden darf aber eine
  // Compilerwarnung wg. ReturnValue nie benutzt unterdr�ckt
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
  // Puffer komplett f�llen, ein Element entfernen und wieder auff�llen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen �berlauf um 1 Element �ber das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // 1 Element l�schen
  Item := FRingbuffer.Remove;
  CheckEquals(1000,               Item,              'Entfernter Eintrag hat falschen Wert');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evRemove);

  // 1 Element hinzuf�gen damit der Puffer wieder voll ist und �ber die obere
  // Grenze des Array geht
  FRingbuffer.Add(1005);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1001,                 Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer (Schleife)');
    CheckAndClearEventFlags(evRemove);
  end;
end;

procedure TestTRingbufferInt.TestRemoveWrap3;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
  Item : Integer;
begin
  // Puffer komplett f�llen, ein Element entfernen und wieder auff�llen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen �berlauf um 1 Element �ber das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // 3 Elemente l�schen
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1000,             Item,              'Entfernter Eintrag hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // 3 Elemente hinzuf�gen damit der Puffer wieder voll ist und �ber die obere
  // Grenze des Array geht
  FRingbuffer.Add(1005);
  FRingbuffer.Add(1006);
  FRingbuffer.Add(1007);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+3+1000, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size-(i+1), FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer (Schleife)');
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');
  CheckAndClearEventFlags(evAdd);

  // das eigentliche L�schen
  FRingbuffer.Delete(1);
  CheckAndClearEventFlags(evRemove);
  ReturnValue := FRingBuffer.Peek(0, FRingbuffer.Count);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer nach Delete');

  for i := 0 to high(ReturnValue) do
  begin
    CheckEquals(i+1+1000, ReturnValue[i], 'Falscher Wert im Puffer');
  end;

  // alle bis auf einen l�schen
  FRingbuffer.Delete(FRingbuffer.Size-2);
  CheckAndClearEventFlags(evRemove);
  CheckEquals(1, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer nach 2. Delete');
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // Alle Eintr�ge auf einmal l�schen
  FRingbuffer.Delete(FRingbuffer.Size);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(0, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer nach dem L�schen');

  FRingbuffer.Add(123000);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(123000, FRingbuffer.Peek(0), 'Falscher Wert im Puffer');
end;

procedure TestTRingbufferInt.TestDeleteException;
begin
  // Pr�fung, dass das Entfernen von mehr Items als Puffergr��e eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // nix l�schen
  FRingbuffer.Delete(0);
  // wenn nix gel�scht auch keine Benachrichtigung!
  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer '+
                                                   'nach L�schen von 0 Eintr�gen');

  // Werte pr�fen
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // Ein Element entfernen und eines hinzuf�gen, damit Puffer �ber obere Array
  // Grenze geht
  FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);

  FRingbuffer.Add(FRingbuffer.Size+1000);
  CheckAndClearEventFlags(evAdd);

  // Ein Element l�schen und Puffer pr�fen
  FRingbuffer.Delete(1);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer nach L�schen');

  // Werte pr�fen
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
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // 3 Elemente entfernen und 3 hinzuf�gen, damit Puffer �ber obere Array
  // Grenze geht
  FRingbuffer.Remove(3);
  CheckAndClearEventFlags(evRemove);

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i+1000);

  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // Ein Element l�schen und Puffer pr�fen
  FRingbuffer.Delete(3);

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer nach L�schen');

  // Werte pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+100000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // alle Elemente mittels Peek holen
  ReturnValue := FRingbuffer.Peek(0, FRingbuffer.Size);
  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Spicken darf Puffergr��e nicht �ndern');
  CheckEquals(FRingbuffer.Size, length(ReturnValue), 'Falsche Gr��e der gelieferten Daten');

  for i := 0 to length(ReturnValue)-1 do
    CheckEquals(i+100000, ReturnValue[i], 'Falscher Wert');

  // nur ein Element holen
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckEquals(1,      length(ReturnValue), 'Falsche Gr��e der gelieferten Daten');
  CheckEquals(100001, ReturnValue[0], 'Falscher Wert');

  // 2 Elemente holen
  ReturnValue := FRingbuffer.Peek(1, 2);
  CheckEquals(2,      length(ReturnValue), 'Falsche Gr��e der gelieferten Daten');
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
  // Exception bei Index > Count pr�fen
  FRingbuffer.Add(1000);
  CheckAndClearEventFlags(evAdd);

  // Pr�fung, dass das Entfernen von mehr Items als Puffergr��e eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
  // weiterhin!
  StartExpectingException(EArgumentOutOfRangeException);

  // Versuchen ein Element mit falschem Index zu extrahieren
  ReturnValue := FRingbuffer.Peek(1, 1);
  CheckAndClearNoEventFlagsSet;

  StopExpectingException();

  // Puffer f�r n�chsten Test leeren
  FRingbuffer.Clear;
  CheckAndClearEventFlags(evRemove);

  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');

  // Pr�fung, dass das Entfernen von mehr Items als Puffergr��e eine Exception ausl�st
  // Die beiden Breakpoints sind absichtlich hier. Die Eigenschaften der
  // Breakpoints wurden so angepasst, dass die IDE zwischen diesen beiden
  // Breakpoints nicht wegen Exceptions anh�lt und auch nicht an diesen
  // Breakpoints stoppt. Der Test auf die Ausl�sung der Exception funktioniert
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);

  // 0 Items entnehmen
  SetLength(ReturnValue, 0);
  ReturnValue := FRingbuffer.Peek(0, 0);

  CheckAndClearNoEventFlagsSet;
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Spicken darf Puffergr��e nicht �ndern');

  // Pufferinhalt pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');

  // Ein Element entnehmen und wieder Auff�llen, damit der Puffer um ein Element
  // �ber das obere Array Ende hinaus von unten wieder beginnend geht
  i := FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);
  CheckEquals(1000, i, 'Entnommenes Element hat falschen Wert');

  FRingbuffer.Add(FRingbuffer.Size+1000);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auff�llen');

  // nun den gesamten Pufferinhalt entnehmen und pr�fen
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
  // Puffer komplett f�llen
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer');

  // 3 Elemente entnehmen und wieder Auff�llen, damit der Puffer um ein Element
  // �ber das obere Array Ende hinaus von unten wieder beginnend geht
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+1000, Item, 'Entnommenes Element hat falschen Wert');
    CheckAndClearEventFlags(evRemove);
  end;

  for i := 0 to 2 do
    FRingbuffer.Add(FRingbuffer.Size+i+1000);

  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl Elemente im Puffer nach wieder Auff�llen');

  // nun den gesamten Pufferinhalt entnehmen und pr�fen
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
  // Compilerwarnung wg. ReturnValue nie benutzt unterdr�ckt
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
  // Puffer komplett f�llen, ein Element entfernen und wieder auff�llen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen �berlauf um 1 Element �ber das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+1000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // 1 Element l�schen
  Item := FRingbuffer.Remove;
  CheckAndClearEventFlags(evRemove);
  CheckEquals(1000,               Item,              'Entfernter Eintrag hat falschen Wert');
  CheckEquals(FRingbuffer.Size-1, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // 1 Element hinzuf�gen damit der Puffer wieder voll ist und �ber die obere
  // Grenze des Array geht
  FRingbuffer.Add(1005);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);
    CheckEquals(i+1+1000, Item, 'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer (Schleife)');
  end;

  CheckAndClearNoEventFlagsSet;
end;

procedure TestTRingbufferInt.TestPeekWrap3;
var
  Items: TRingbuffer<Integer>.TRingbufferArray;
  i    : Byte;
  Item : Integer;
begin
  // Puffer komplett f�llen, ein Element entfernen und wieder auff�llen und dann
  // in einer Schleife alle Elemente entfernen (der eigentliche Test, weil es
  // hier einen �berlauf um 1 Element �ber das Array Ende gibt
  SetLength(Items, FRingbuffer.Size);
  for i := 0 to FRingbuffer.Size-1 do
    Items[i] := i+100000;

  FRingbuffer.Add(Items);
  CheckAndClearEventFlags(evAdd);
  // 3 Elemente l�schen
  for i := 0 to 2 do
  begin
    Item := FRingbuffer.Remove;
    CheckEquals(i+100000,         Item,              'Entfernter Eintrag hat falschen Wert');
  end;

  CheckAndClearEventFlags(evRemove);
  CheckEquals(FRingbuffer.Size-3, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // 3 Elemente hinzuf�gen damit der Puffer wieder voll ist und �ber die obere
  // Grenze des Array geht
  FRingbuffer.Add(100005);
  FRingbuffer.Add(100006);
  FRingbuffer.Add(100007);
  CheckAndClearEventFlags(evAdd);
  CheckEquals(FRingbuffer.Size,   FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer');

  // jetzt alle Elemente der Reihe nach entfernen
  for i := 0 to FRingbuffer.Size-1 do
  begin
    Item := FRingbuffer.Peek(i);

    CheckEquals(i+3+100000,       Item,              'Entfernter Eintrag hat falschen Wert (Schleife)');
    CheckEquals(FRingbuffer.Size, FRingbuffer.Count, 'Falsche Anzahl an Eintr�gen im Puffer (Schleife)');
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

  // Daten mittels Peek holen, pr�fen und Peek-Array nicht freigeben
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

initialization
  // Alle Testf�lle beim Testprogramm registrieren
  RegisterTest(TestTRingbuffer.Suite);
  RegisterTest(TestTRingbufferInt.Suite);
  RegisterTest(TestTObjectRingbuffer.Suite);
end.

