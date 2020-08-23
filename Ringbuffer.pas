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
unit Ringbuffer;

interface

uses
  SysUtils;

type
  /// <summary>
  ///   Diese Exception wird ausgel�st, wenn mehr Daten in den Puffer geschrieben
  ///   werden sollten wie Platz im Puffer ist
  /// </summary>
  EBufferFullException  = class(Exception);
  /// <summary>
  ///   Diese Exception wird ausgel�st, wenn versucht wird ein einzelnes Element
  ///   aus einem komplett leeren Puffer zu entnehmen.
  /// </summary>
  EBufferEmptyException = class(Exception);

  /// <summary>
  ///   Art eines Ereignisses des Ringpuffers: Add wenn mindestens ein Element
  ///   hinzugef�gt wurde, Remove wenn mindestens ein Element entnommen oder
  ///   gel�scht wurde aber auch wenn der Puffer komplett gel�scht wurde
  /// </summary>
  TRingbufferEventType = (evAdd, evRemove);

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
  TRingbufferNotify = procedure(Count: UInt32; Event:TRingbufferEventType) of Object;

  /// <summary>
  ///   Umsetzung eines generischen Ringpuffers f�r alle m�glichen Variablentypen
  ///   jedoch ohne Besitzer darin gespeicherter Objekte zu sein. F�r einen
  ///   Ringpuffer mit Freigabe von Objekten am Ende die Klasse TObjectRingbuffer<T>
  ///   verwenden.
  /// </summary>
  TRingbuffer<T> = class(TObject)
  type
    /// <summary>
    ///   R�ckgabe und �bergabetyp f�r viele Operatoren
    /// </summary>
    TRingbufferArray = TArray<T>; //array of T;
  strict protected
    /// <summary>
    ///   Hier werden alle Elemente drin gespeichert. Die Gr��e wird �ber den
    ///   Size Parameter des Constructors bestimmt
    /// </summary>
    FItems        : TRingbufferArray;
    /// <summary>
    ///   Index des aktuell ersten Eintrags des Puffers
    /// </summary>
    FStart        : UInt32;
    /// <summary>
    ///   Index des n�chsten freien Eintrags im Puffer, an diese Stelle des
    ///   Puffers kann also sofort ein Element geschrieben werden. Ist FNextFree
    ///   gleich FStart ist der Puffer entweder leer oder ganz voll. Wie es
    ///   tats�chlich ist bestimmt dann FContainsData. Ist es true ist er voll.
    /// </summary>
    FNextFree     : UInt32;
    /// <summary>
    ///   Wenn FStart = FNextFree muss der Puffer nicht unbedingt leer sein,
    ///   sondern er k�nnte auch komplett gef�llt sein. Ist dieses Flag true
    ///   dann ist er in diesem Zustand tats�chlich komplett gef�llt.
    /// </summary>
    FContainsData : Boolean;
    /// <summary>
    ///   Dieses Ereignis wird bei allen Operationen ausgel�st, die einen Einfluss
    ///   auf den F�llstand des Ringpuffers haben. Hinzuf�gen, Entfernen, L�schen...
    /// </summary>
    FNotify       : TRingbufferNotify;

    /// <summary>
    ///   Liefert die Anzahl der im Puffer befindlichen Eintr�ge
    /// </summary>
    function GetCount: UInt32;
    /// <summary>
    ///   Liefert die Anzahl der maximal im Puffer speicherbaren Eintr�ge
    /// </summary>
    function GetSize: UInt32;
    /// <summary>
    ///   Erh�ht den Ende-Marker und fall dieser �ber die obere Array Grenze
    ///   l�uft wird er von 0 ausgehend weiter berechnet. Es wird davon
    ///   ausgegangen, dass die Konstellation Ende-Marker + Increment > Start-Marker
    ///   nicht auftreten kann da diese vom Aufrufer bereits abgefangen wurde.
    /// </summary>
    /// <param name="Increment">
    ///   Wert um den der Ende-Marker erh�ht werden soll
    /// </param>
{ TODO : Am Ende inline-Direktive aktivieren! }
    procedure AdvanceNextFree(Increment: UInt32); // inline;
    /// <summary>
    ///   Prototyp f�r die Routine zur Freigabe von Objekten. Bleibt in dieser
    ///   Klasse leer, wird aber von TObjectRingbuffer �berschrieben.
    /// </summary>
    /// <param name="StartIndex">
    ///   Index des ersten zu l�schenden Eintrags. Muss kleiner gleich Endindex
    ///   sein und l�uft von 0 bis Count-1. �ber die obere Arraygrenze hinausge-
    ///   hende Pufferinhalte k�nnen somit nicht auf einmal gel�scht werden
    /// </param>
    /// <param name="EndIndex">
    ///   Index des letzten zu l�schenden Eintrags. Muss gr��er gleich Endindex
    ///   sein und l�uft von 0 bis Count-1
    /// </param>
    procedure FreeOrNilItems(StartIndex, EndIndex: UInt32); virtual;
  public
    /// <summary>
    ///   Erzeugt den Puffer und dimensioniert ihn
    /// </summary>
    /// <param name="Size">
    ///   Anzahl der Elemente die im Puffer Platz finden sollen
    /// </param>
    constructor Create(Size: UInt32); overload;
    /// <summary>
    ///   Gibt den Puffer frei, jedoch nicht in diesem gespeicherte Objekte. Soll
    ///   der Ringpuffer auch f�r das Speichermanagement der Objekte zust�ndig
    ///   sein ist der TObjectRingbuffer zu verwenden!
    /// </summary>
    destructor  Destroy; override;

    /// <summary>
    ///   H�ngt einen Wert an den Puffer an. Ist die Kapazit�t des Puffers
    ///   ersch�pft, wird eine EBufferFullException geworfen.
    /// </summary>
    /// <param name="Item">
    ///   Anzuh�ngendes Element
    /// </param>
    procedure   Add(Item: T); overload; virtual;
    /// <summary>
    ///   F�gt mehrere Werte auf einmal zum Puffer hinzu
    /// </summary>
    /// <param name="Items">
    ///   Array mit den hinzuzuf�genden Elementen. Gr��e des Arrays muss kleiner
    ///   als die freie Speicherkapazit�t des Puffers sein, anderenfalls wird
    ///   eine EBufferFullException geworfen.
    /// </param>
    procedure   Add(Items:TRingbufferArray); overload; virtual;

    /// <summary>
    ///   Liefert das am fr�hesten in den Puffer geschriebene Element und
    ///   entfernt es aus dem Puffer. Ist der Puffer leer wird eine
    ///   EBufferEmptyException ausgel�st
    /// </summary>
    /// <returns>
    ///   Das Element aus dem Puffer welches am l�ngsten im Puffer ist
    /// </returns>
    function    Remove:T; overload; virtual;
    /// <summary>
    ///   Liefert mehrere Elemente aus dem Puffer. Ist der Puffer leer wird eine
    ///   EBufferEmptyException ausgel�st
    /// </summary>
    /// <param name="RemoveCount">
    ///   Anzahl der zur�ckzuliefernden Elemente. Befinden sich weniger Elemente
    ///   als angefordert im Puffer werden weniger zur�ckgeliefert. Werden mehr
    ///   Elemente angefordert als im Puffer Platz haben (Puffergr��e) wird eine
    ///   EArgumentOutOfRangeException ausgel�st.
    /// </param>
    /// <returns>
    ///   Array mit einer maximalen L�nge von Count
    /// </returns>
    function    Remove(RemoveCount: UInt32):TRingbufferArray; overload; virtual;
    /// <summary>
    ///   L�scht die angegebene Anzahl an Elementen ab dem Beginn des Puffers.
    ///   Die Elemente werden dabei allerdings nicht irgendwie �berschrieben,
    ///   sie sind nur nach dem L�schvorgang nicht mehr zug�nglich.
    /// </summary>
    /// <param name="Count">
    ///   Anzahl zu l�schender Elemente. Sollen mehr Elemente gel�scht werden
    ///   als Elemente im Puffer sind wird einfach der Pufferinhalt gel�scht.
    ///   Sollen mehr Elemente als die Puffergr��e gel�scht werden wird eine
    ///   EArgumentOutOfRangeException ausgel�st.
    /// </param>
    procedure   Delete(Count: UInt32); virtual;
    /// <summary>
    ///   Leert den Puffer in dem Start und Ende Zeiger zur�ck auf Initialwert
    ///   gesetzt werden. Die Daten werden dadurch nicht �berschrieben, sind aber
    ///   nicht mehr (legal) zug�nglich
    /// </summary>
    procedure   Clear; virtual;

    /// <summary>
    ///   Liefert ein einzelnes Element des Puffers, jedoch ohne dieses zu
    ///   entfernen
    /// </summary>
    /// <param name="Index">
    ///   Index des zu liefernden Elements des Puffers. Index geht von 0 bis
    ///   Count-1. Wird ein Index angegeben der gr��er als Count-1 ist wird eine
    ///   EArgumentOutOfRangeException Exception geworfen
    /// </param>
    /// <returns>
    ///   Element an der durch den Index angegebenen Stelle im Puffer. Das
    ///   Element verbleibt im Puffer.
    /// </returns>
    function    Peek(Index: UInt32):T; overload;
    /// <summary>
    ///   Liefert mehrere Elemente des Puffers, jedoch ohne diese zu entfernen
    /// </summary>
    /// <param name="Index">
    ///   Index des zu liefernden Elements des Puffers. Index geht von 0 bis
    ///   Count-1. Wird ein Index angegeben der gr��er als Count-1 ist wird eine
    ///   EArgumentOutOfRangeException Exception geworfen
    /// </param>
    /// <param name="Count">
    ///   Anzahl der zu liefernden Elemente. Bei 0 wird ein leeres Array
    ///   geliefert und wenn mehr Elemente angefordert wurden als im Puffer
    ///   vorhanden sind werden soviele zur�ckgegeben wie im Puffer vorhanden
    ///   sind. Werden mehr Elemente angefordert als im Puffer je Platz haben
    ///   wird eine EArgumentOutOfRangeException Exception geworfen
    /// </param>
    /// <returns>
    ///   Maximal Count Elemente ab der durch Index angegebenen Stelle im Puffer.
    ///   Der Pufferinhalt und Zustand bleibt dabei unver�ndert
    /// </returns>
    function    Peek(Index, Count: UInt32):TRingbufferArray overload;

    /// <summary>
    ///   Liefert die Anzahl der maximal im Puffer speicherbaren Eintr�ge
    /// </summary>
    property Size   : UInt32
      read   GetSize;

    /// <summary>
    ///   Liefert die Anzahl der derzeit im Puffer befindlichen Eintr�ge
    /// </summary>
    property Count  : UInt32
      read   GetCount;

    /// <summary>
    ///   Dieses Ereignis wird bei allen Operationen ausgel�st, die einen Einfluss
    ///   auf den F�llstand des Ringpuffers haben. Hinzuf�gen, Entfernen, L�schen...
    /// </summary>
    property Notify : TRingbufferNotify
      read   FNotify
      write  FNotify;
  end;

  /// <summary>
  ///   Ringpuffer zur Speicherung von Objekten inklusive der M�glichkeit
  ///   Besitzer der Objekte zu sein und damit beim Freigeben auch die noch
  ///   enthaltenen Objekte freigeben zu k�nnen.
  /// </summary>
  TObjectRingbuffer<T:class> = class(TRingbuffer<T>)
  strict private
    /// <summary>
    ///   Wenn true ist das Object Besitzer der im Puffer abgelegten Objektinstanzen
    /// </summary>
    FOwnsObjects : Boolean;
    /// <summary>
    ///   Gibt alle im Puffer gespeicherten Objekte frei und setzt die Referennz
    ///   im Puffer auf nil
    /// </summary>
    procedure FreeContents;
    /// <summary>
    ///   Wenn FOwnsObjects true ist werden alle Objekte freigegeben. Ist
    ///   FOwnsObjects false aber der Code l�uft auf einer ARC Plattform werden
    ///   die Referenzen trotzdem genillt, damit nicht aus versehen Speicherlecks
    ///   entstehen k�nnen.
    /// </summary>
    procedure FreeIfOwnedOrARC;
  strict protected
    /// <summary>
    ///   Gibt die Objekte eines Bereichs des Puffers frei oder setzt deren
    ///   Referenz auf nil. Ist FOwnsObjects true werden die Objekte freigegeben,
    ///   falls nicht nur die Speicherpl�tze im Puffer auf NIL gesetzt. Letzteres
    ///   hat auf ARC basierten Plattformen den Effekt, dass der Referenzz�hler
    ///   um eins verringert wird. Dadurch werden Speicherlecks verhindert, die
    ///   sonst beim Entnehmen von Eintr�gen auftreten k�nnten.
    /// </summary>
    /// <param name="StartIndex">
    ///   Index des ersten zu l�schenden Eintrags. Muss kleiner gleich Endindex
    ///   sein und l�uft von 0 bis Count-1. �ber die obere Arraygrenze hinausge-
    ///   hende Pufferinhalte k�nnen somit nicht auf einmal gel�scht werden
    /// </param>
    /// <param name="EndIndex">
    ///   Index des letzten zu l�schenden Eintrags. Muss gr��er gleich Endindex
    ///   sein und l�uft von 0 bis Count-1
    /// </param>
    procedure FreeOrNilItems(StartIndex, EndIndex: UInt32); override;
  public
    /// <summary>
    ///   Erzeugt den Puffer und dimensioniert ihn
    /// </summary>
    /// <param name="Size">
    ///   Anzahl der Elemente die im Puffer Platz finden sollen
    /// </param>
    /// <param name="OwnsObjects">
    ///   Wenn true werden die im Puffer gespeicherten Objekte vom Puffer
    ///   besessen, d.h. beim Freigeben oder L�schen werden diese auch freigegebem
    /// </param>
    constructor Create(Size: UInt32; OwnsObjects: Boolean = false); overload;
    /// <summary>
    ///   Gibt, sofern OwnsObjects gesetzt ist, die noch im Puffer befindlichen
    ///   Objekte frei
    /// </summary>
    destructor  Destroy; override;

    /// <summary>
    ///   L�scht die angegebene Anzahl an Elementen ab dem Beginn des Puffers.
    ///   Die gel�schten Objekte werden dabei freigegeben, wenn OwnsObjects true ist
    /// </summary>
    /// <param name="Count">
    ///   Anzahl zu l�schender Elemente. Sollen mehr Elemente gel�scht werden
    ///   als Elemente im Puffer sind wird einfach der Pufferinhalt gel�scht.
    ///   Sollen mehr Elemente als die Puffergr��e gel�scht werden wird eine
    ///   EArgumentOutOfRangeException ausgel�st.
    /// </param>
    procedure   Delete(Count: UInt32); override;
    /// <summary>
    ///   Leert den Puffer in dem Start und Ende Zeiger zur�ck auf Initialwert
    ///   gesetzt werden. Au�erdem werden alle enthaltenen Objekte freigegeben,
    ///   sofern OwnsObjects true ist
    /// </summary>
    procedure   Clear; override;

    /// <summary>
    ///   Wenn true werden die im Puffer gespeicherten Objekte vom Puffer
    ///   besessen, d.h. beim Freigeben oder L�schen werden diese auch freigegebem
    /// </summary>
    property OwnsObjects: Boolean
      read   FOwnsObjects
      write  FOwnsObjects;
  end;


implementation

{ TRingbuffer<T> }

procedure TRingbuffer<T>.Add(Item: T);
begin
  // nur hinzuf�gen wenn entweder noch Platz im Puffer oder wenn Puffer ganz
  // leer (dann sind Start- und Ende Zeiger gleich, aber das FContaisData Flag
  // ist noch false
  if (Count < Size) or ((Count = Size) and not FContainsData) then
  begin
    FItems[FNextFree] := Item;
    AdvanceNextFree(1);

    FContainsData := true;

    if assigned(FNotify) then
      FNotify(Count, evAdd);
  end
  else
    raise EBufferFullException.Create('Capacity of this ringbuffer is exhausted. '+
                                     'Capacity is '+Size.ToString+' Start: '+
                                     FStart.ToString+' End: '+FNextFree.ToString);
end;

procedure TRingbuffer<T>.Add(Items: TRingbufferArray);
var
  FreeItemsAfterEnd : UInt32; // Anzahl freier Elemente zwischen Ende Marker und
                              // Ende des Arrays
begin
  assert(length(Items) > 0, 'Hinzuf�gen eines leeren Arrays ist nicht sinnvoll');

  // ist �berhaupt noch soviel Platz im Puffer?
  // Typecast nach Int64 um W1023 Warnung zu unterdr�cken
  if (length(Items) <= Int64(Size-Count)) then
  begin
    // leeres Array sollte eigentlich nicht vorkommen, aber falls im Release
    // Build Assertions aus sind sollte es auch nicht abst�rzen
    if (length(Items) > 0) then
    begin
      // Passt das �bergebene Array im St�ck in den Puffer und der Puffer Inhalt
      // geht derzeit auch nicht �ber die obere Grenze hinaus, oder muss es
      // gesplittet werden? Typecast nach Int64 um W1023 Warnung zu unterdr�cken
      if (Int64(Size-FNextFree) >= length(Items)) then
        Move(Items[0], FItems[FNextFree], length(Items) * SizeOf(Items[0]))
      else
      begin
        // restlichen Platz im Puffer berechnen
        FreeItemsAfterEnd := Size - FNextFree;
        // von Ende-Marker bis zum Array Ende
        Move(Items[0], FItems[FNextFree], FreeItemsAfterEnd * SizeOf(Items[0]));
        // restliche Daten vom Anfang an
        Move(Items[FreeItemsAfterEnd], FItems[0],
             (UInt32(length(Items))-FreeItemsAfterEnd) * SizeOf(Items[0]));
      end;

      // Endeindex erh�hen
      AdvanceNextFree(length(Items));
      FContainsData := true;

      if assigned(FNotify) then
        FNotify(Count, evAdd);
    end;
  end
  else
    raise EBufferFullException.Create('Capacity of this ringbuffer is exhausted. '+
                                     'Free space is '+(Size-Count).ToString+' Start: '+
                                     FStart.ToString+' End: '+FNextFree.ToString);
end;

procedure TRingbuffer<T>.AdvanceNextFree(Increment: UInt32);
var
  Remaining : UInt32; // Verbleibende Speicherpl�tze bis zur oberen Array Grenze
begin
  Remaining := Size-FNextFree;

  inc(FNextFree, Increment);
  // Ende Marker �ber das Array-Ende hinaus erh�ht
  if (FNextFree > Size-1) then
    FNextFree := (Increment-Remaining);
end;

procedure TRingbuffer<T>.Clear;
begin
  FStart        := 0;
  FNextFree     := 0;
  FContainsData := false;

  if assigned(FNotify) then
    FNotify(0, evRemove);
end;

constructor TRingbuffer<T>.Create(Size: UInt32);
begin
  assert(Size >= 2, 'Puffer mit weniger als 2 Elementen sind nicht sinnvoll!');

  inherited Create;

  SetLength(FItems, Size);
  FStart        := 0;
  FNextFree     := 0;
  FContainsData := false;
  FNotify       := nil;
end;

procedure TRingbuffer<T>.Delete(Count: UInt32);
var
  Remaining : UInt32; // Verbleibende Speicherpl�tze bis zur oberen Array Grenze
begin
  if (Count <= Size) then
  begin
    // Puffer nur teilweise zu l�schen?
    if (Count < self.Count) then
    begin
      Remaining := Size - FStart;
      // Pufferinhalt geht nicht �ber obere Array Grenze hinaus?
      if (Count < Remaining) then
        // Startmarker verschieben
        FStart := FStart + Count
      else
        // Anzahl der Positionen um die insgesamt verschoben werden soll - Anzahl
        // der Positionen bis zum oberen Array Ende abziehen ergibt neue
        // Startposition vom Array-Anfang aus gesehen.
        FStart := (Count - Remaining);

      // nur benachrichtigen wenn �berhaupt was gel�scht werden sollte
      if assigned(FNotify) and (Count > 0) then
        FNotify(Count, evRemove);
    end
    else
      // alles zu l�schen
      Clear;
  end
  else
    raise EArgumentOutOfRangeException.Create('Cannot delete more that buffer '+
                                              'size elements. Size: '+Size.ToString+
                                              ' Elements to be deleted: '+Count.ToString);
end;

destructor TRingbuffer<T>.Destroy;
begin
  SetLength(FItems, 0);

  inherited;
end;

procedure TRingbuffer<T>.FreeOrNilItems(StartIndex, EndIndex: UInt32);
begin
  // absichtlich leer, wird in Kindklasse ausprogrammiert
end;

function TRingbuffer<T>.GetCount: UInt32;
var
  l : Int64;
begin
  // Puffer ist weder komplett leer noch komplett voll
  if (FNextFree <> FStart) then
  begin
    // Je nach dem ob der Puffer gerade �ber das Ende hinaus geht und am Anfang
    // weiter geht
    if (FNextFree > FStart) then
      result := FNextFree-FStart
    else
    begin
      // Puffer geht �ber das Ende hinaus und beginnt am Array Anfang wieder
      l := (length(FItems)-Int64(FStart))+FNextFree;
      result := abs(l);
    end;
  end
  else
    // Start = Ende aber es sind daten da? Dann ist Puffer maximal gef�llt
    if FContainsData then
      result := Size
    else
      // Start = Ende und Puffer ist leer
      result := 0;
end;

function TRingbuffer<T>.GetSize: UInt32;
begin
  result := length(FItems);
end;

function TRingbuffer<T>.Peek(Index: UInt32): T;
var
  reminder : UInt32;
begin
  if (Index < Count) then
  begin
    // Puffer l�uft derzeit nicht �ber seine obere Grenze hinaus
    if ((FStart+Index) < Size) then
      result := FItems[FStart+Index]
    else
    begin
      // um wieviel geht es �ber die obere Grenze hinaus?
      reminder := (FStart+Index)-Size;
      result   := FItems[reminder];
    end;
  end
  else
    raise EArgumentOutOfRangeException.Create('Invalid Index: '+Index.ToString+
                                              ' Max. Index: '+Count.ToString);
end;

function TRingbuffer<T>.Peek(Index, Count: UInt32): TRingbufferArray;
var
  RemoveableCount   : UInt32;  // Anzahl entfernbarer Elemente, meist Count
  RemainingCount    : UInt32;  // Anzahl Elemente von Start bis Pufferende
begin
  // wurden mehr Elemente angefordert als �berhaupt je in den Puffer passen?
  // ist der Index im g�ltigen bereich?
  if (Count <= Size) and (Index < self.Count) then
  begin
    // Ist �berhaupt was im Puffer?
    if (self.Count > 0) then
    begin
      // es sind soviele Elemente im Puffer wie entfernt werden sollen
      if (Count <= self.Count) then
        RemoveableCount := Count
      else
        // Nein, also nur soviele entfernen wie �berhaupt m�glich
        RemoveableCount := self.Count;

      SetLength(result, RemoveableCount);

      // geht der aktuelle Puffer inhalt �ber die obere Grenze (d.h. klappt um)?
      if ((FStart+Index+RemoveableCount) < Size)  then
        // Nein, also Elemente direkt kopierbar
        Move(FItems[FStart+Index], result[0], RemoveableCount * SizeOf(FItems[0]))
      else
      begin
        // 2 Kopieroperationen n�tig
        RemainingCount := (Size-(FStart+Index));
        // von Startzeiger bis Pufferende
        Move(FItems[FStart+Index], result[0], RemainingCount * SizeOf(FItems[0]));

        // von Pufferstart bis Endezeiger
        RemoveableCount := RemoveableCount-RemainingCount;
        Move(FItems[0], result[RemainingCount], RemoveableCount * SizeOf(FItems[0]));
      end;
    end
    else
      SetLength(result, 0);
  end
  else
    raise EArgumentOutOfRangeException.Create('Too many elements requested or '+
                                              'index out of range. Size: '+
                                              Size.ToString+'Index: '+
                                              Index.ToString+' Count: '+Count.ToString);
end;

function TRingbuffer<T>.Remove(RemoveCount: UInt32): TRingbufferArray;
var
  RemoveableCount   : UInt32;  // Anzahl entfernbarer Elemente, meist Count
  RemainingCount    : UInt32;  // Anzahl Elemente von Start bis Pufferende
  StillContainsData : Boolean; // Enth�lt der Puffer nach der Remove Operation
                               // immer noch Daten?
begin
  // wurden mehr Elemente angefordert als �berhaupt je in den Puffer passen?
  if (RemoveCount <= Size) then
  begin
    // Ist �berhaupt was im Puffer?
    if (Count > 0) then
    begin
      // es sind soviele Elemente im Puffer wie entfernt werden sollen
      if (RemoveCount <= Count) then
        RemoveableCount := RemoveCount
      else
        // Nein, also nur soviele entfernen wie �berhaupt m�glich
        RemoveableCount := Count;

      SetLength(result, RemoveableCount);
      // wenn alle Elemente entfernt werden sollen muss Flag hinterher auf False
      // gesetzt werden
      StillContainsData := RemoveCount <> Count;

      // geht der aktuelle Puffer inhalt �ber die obere Grenze (d.h. klappt um)?
      if ((FStart + RemoveableCount) < Size)  then
      begin
        // die Elemente freigeben oder den Referenzz�hler erniedrigen. Kann nur
        // in Kindklassen eine Auswirkung haben, da hier eine leere Operation
        if (RemoveableCount > 0) then
          FreeOrNilItems(FStart, FStart + RemoveableCount - 1);

        // Nein, also Elemente direkt kopierbar
        Move(FItems[FStart], result[0], RemoveableCount * SizeOf(FItems[0]));
        inc(FStart, RemoveableCount);
      end
      else
      begin
        // 2 Kopieroperationen n�tig
        RemainingCount := (Size-FStart);

        // die Elemente freigeben oder den Referenzz�hler erniedrigen. Kann nur
        // in Kindklassen eine Auswirkung haben, da hier eine leere Operation
        if (RemoveableCount > 0) then
          FreeOrNilItems(FStart, FStart + RemainingCount - 1);

        // von Startzeiger bis Pufferende
        Move(FItems[FStart], result[0], RemainingCount * SizeOf(FItems[0]));

        // von Pufferstart bis Endezeiger
        RemoveableCount := RemoveableCount-RemainingCount;

        // die Elemente freigeben oder den Referenzz�hler erniedrigen. Kann nur
        // in Kindklassen eine Auswirkung haben, da hier eine leere Operation
        if (RemoveableCount > 0) then
          FreeOrNilItems(FStart, FStart + RemoveableCount - 1);

        Move(FItems[0], result[RemainingCount], RemoveableCount * SizeOf(FItems[0]));

        FStart := RemoveableCount;
      end;

      FContainsData := StillContainsData;

      if assigned(FNotify) then
        FNotify(RemoveCount, evRemove);
    end
    else
      SetLength(result, 0);
  end
  else
    raise EArgumentOutOfRangeException.Create('Too many elements requested: '+RemoveCount.ToString+
                                              ' Max. possible number: '+Size.ToString);
end;

function TRingbuffer<T>.Remove: T;
var
  i : UInt32;
begin
  // ist �berhaupt was im Puffer?
  if Count > 0 then
  begin
    result := FItems[FStart];

    // das Element freigeben oder den Referenzz�hler erniedrigen. Kann nur in
    // Kindklassen eine Auswirkung haben, da hier eine leere Operation
    FreeOrNilItems(FStart, FStart);

    // Anfangsmarker verschieben
    inc(FStart);
    // obere Grenze �berschritten?
    if (FStart = Size) then
      FStart := 0;

    // wenn Start = Ende ist der Puffer leer
    if (FStart = FNextFree) then
      FContainsData := false;

    if assigned(FNotify) then
      FNotify(Count, evRemove);
  end
  else
    raise EBufferEmptyException.Create('Attempt to remove an item from a '+
                                      'completely empty buffer');
end;

{ TObjectRingbuffer<T> --------------------------------------------------------}

procedure TObjectRingbuffer<T>.Clear;
begin
  // Objekte ggf. freigeben oder bei ARC Referenzz�hler erniedrigen um
  // Speicherlecks zu vermeiden
  FreeIfOwnedOrARC;

  inherited;
end;

constructor TObjectRingbuffer<T>.Create(Size: UInt32; OwnsObjects: Boolean);
begin
  inherited Create(Size);

  FOwnsObjects := OwnsObjects;
end;

procedure TObjectRingbuffer<T>.Delete(Count: UInt32);
begin
  // Sicherheitspr�fung aus dem geerbten Delete muss hier leider dupliziert
  // werden, da sonst ggf. Elemente freigegeben werden, obwohl Delete sp�ter
  // eine Exception ausl�st, weil mehr Elemente gel�scht werden sollten als im
  // Puffer sind!
  if (Count <= Size) then
  begin
    // Freigaberoutine ber�cksichtigt kein �berlauf �ber obere Array Grenze, aber
    // FOwnsObjects wird automatisch ber�cksichtigt
    if (FStart + Count <= Size) then
      FreeOrNilItems(FStart, FStart + Count)
    else
    begin
      // Elemente von Start bis zur oberen Array-Grenze behandeln
      FreeOrNilItems(FStart, Size);
      // Rest ausrechnen und behandeln
      FreeOrNilItems(0, (Count - ((Size - FStart) + 1)) - 1);
    end;

    inherited;
  end
  else
    raise EArgumentOutOfRangeException.Create('Cannot delete more that buffer '+
                                              'size elements. Size: '+Size.ToString+
                                              ' Elements to be deleted: '+Count.ToString);
end;

destructor TObjectRingbuffer<T>.Destroy;
begin
  // Objekte ggf. freigeben oder bei ARC Referenzz�hler erniedrigen um
  // Speicherlecks zu vermeiden
  FreeIfOwnedOrARC;

  inherited;
end;

procedure TObjectRingbuffer<T>.FreeIfOwnedOrARC;
begin
  if FOwnsObjects then
    FreeContents
  else
  begin
    // wenn ARC vorhanden alle Objektreferenzen nillen, da sonst m�glicherweise
    // Speicherlecks entstehen.
    {$IFDEF AUTOREFCOUNT}
    FreeContents;
    {$ENDIF}
  end;
end;

procedure TObjectRingbuffer<T>.FreeContents;
var
  x : T;
  i : Integer;
begin
  // es d�rfen nur die Objekte freigegeben werden, die im derzeit belegten Teil
  // des Ringpuffers gespeichert sind.

  // belegter Teil des Puffers geht derzeit nicht �ber die Grenze hinaus
  if (FStart < FNextFree) then
  begin
    for i := FStart to FNextFree do
      if assigned(FItems[i]) then
        FreeAndNil(FItems[i]);
  end
  else
    if (FStart > FNextFree) then
    begin
      // Bis zum oberen Ende freigeben
      for i := FStart to High(FItems) do
        if assigned(FItems[i]) then
          FreeAndNil(FItems[i]);

      // vom Start bis zum Ende Marker freigeben
      for i := 0 to FNextFree do
        if assigned(FItems[i]) then
          FreeAndNil(FItems[i]);
    end
    else
      // FStart = FNextFree, d.h. Puffer entweder ganz leer oder ganz voll!
      // Wenn FContainsData = true, ist der Puffer ganz voll
      if FContainsData then
        for i := 0 to high(FItems) do
          if assigned(FItems[i]) then
            FreeAndNil(FItems[i]);
end;

procedure TObjectRingbuffer<T>.FreeOrNilItems(StartIndex, EndIndex: UInt32);
var
  i : UInt32;
begin
  assert(EndIndex <= Size, 'Zu hoher Endindex angegeben. Ist: '+
         EndIndex.ToString+' Erlaubt: '+Size.ToString);
  assert(StartIndex <= EndIndex, 'Ung�ltiger Bereich angegeben: '+
         StartIndex.ToString+'/'+EndIndex.ToString);

  if FOwnsObjects then
  begin
    for i := StartIndex to EndIndex do
      FreeAndNil(FItems[i]);
  end
  else
    for i := StartIndex to EndIndex do
      FItems[i] := nil;
end;

end.
