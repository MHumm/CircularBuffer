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
  SysUtils, Generics.Collections;

type
  /// <summary>
  ///   raised when there are more data written to the buffer than it can hold
  /// </summary>
  EBufferFullException  = class(Exception);
  /// <summary>
  ///   raised when a single element is taken from an empty buffer
  /// </summary>
  EBufferEmptyException = class(Exception);

  /// <summary>
  ///   types of ring buffer events: <br />
  /// </summary>
  TRingbufferEventType = (
    /// <summary>
    ///   at least one element was added
    /// </summary>
    evAdd,
    /// <summary>
    ///   at least one element was removed or deleted or the buffer is cleared
    /// </summary>
    evRemove);

  /// <summary>
  ///   Event type triggered by all operations manipulating the number of elements in the ring buffer: Add, Remove,
  ///   Delete...
  /// </summary>
  /// <param name="Count">
  ///   new number of elements in the buffer
  /// </param>
  /// <param name="Event">
  ///   type of event:
  ///   <list type="bullet">
  ///     <item>
  ///       evAdd when Count was increased,
  ///     </item>
  ///     <item>
  ///       evRemove when Count was decreased
  ///     </item>
  ///   </list>
  /// </param>
  TRingbufferNotify = procedure(Count: UInt32; Event:TRingbufferEventType) of Object;

  /// <summary>
  ///   Implementation of a generic ring buffer for all types without taking any ownership. For a ring buffer freeing
  ///   all contained objects on Destroy use <c>TObjectRingBuffer&lt;T&gt;</c>.
  /// </summary>
  /// <seealso cref="TObjectRingBuffer&lt;T&gt;">
  ///   TObjectRingBuffer&lt;T&gt;
  /// </seealso>
  TRingbuffer<T> = class(TObject)
  type
    /// <summary>
    ///   return and parameter type for most of the operators
    /// </summary>
    TRingbufferArray = TArray<T>;
  strict private
    /// <summary>
    ///   Indicates whether the ring buffer takes ownership of the instances
    /// </summary>
    FOwnsObjects : Boolean;
    /// <summary>
    ///   Copies items into the already allocated Dest array. Since this is
    ///   coded the naive way it is only meant for managed types where move is wrong.
    /// </summary>
    /// <param name="Dest">
    ///   Already allocated target array where the copied items will be stored in
    /// </param>
    /// <param name="StartIndex">
    ///   Index of the first item to be copied
    /// </param>
    /// <param name="Count">
    ///   Number of items to copy
    /// </param>
    /// <remarks>
    ///   This method expects that the parameters given are valid!
    /// </remarks>
    procedure CopyItems(var Dest: TRingbufferArray; StartIndex, Count: UInt32); inline;
    /// <summary>
    ///   Frees all object instances in the buffer if OwnsObject is true and
    ///   the type is an object based type
    /// </summary>
    /// <param name="StartIndex">
    ///   Index of the first item to be deleted. Must be less than <c>EndIndex</c>
    ///   and in the range <c>0 .. Count - 1</c>. Thus wrapped buffer content
    ///   cannot be deleted in one go.
    /// </param>
    /// <param name="EndIndex">
    ///   Index of the last item to be deleted. Must be larger than <c>StartIndex</c>
    ///   and in the range <c>0 .. Count - 1.</c>
    /// </param>
    procedure FreeObjectsIfOwned(StartIndex, EndIndex: UInt32);
  strict protected
    /// <summary>
    ///   Static storage for all elements. The size is determined in the constructor.
    /// </summary>
    FItems        : TRingbufferArray;
    /// <summary>
    ///   Index of the first buffer item
    /// </summary>
    FStart        : UInt32;
    /// <summary>
    ///   Index of the next free buffer item, where an element can be written directly
    /// </summary>
    /// <remarks>
    ///   If <c>FNextFree = FStart</c> the buffer is either empty or full. The actual state is determined by <c>
    ///   FContainsData</c>: True means <i>the buffer is full</i>.
    /// </remarks>
    FNextFree     : UInt32;
    /// <summary>
    ///   Indicates whether the buffer actually contains data.
    /// </summary>
    /// <remarks>
    ///   If <c>FStart = FNextFree</c> the buffer is either empty or full. This field gives the missing information.
    /// </remarks>
    FContainsData : Boolean;
    /// <summary>
    ///   This event is triggered by all operations manipulating the number of elements in the ring buffer: Add,
    ///   Remove, Delete... <br />
    /// </summary>
    FNotify       : TRingbufferNotify;

    /// <summary>
    ///   Returns the number of items currently in the ring buffer
    /// </summary>
    function GetCount: UInt32;
    /// <summary>
    ///   Returns the number of elements that can be stored in the ring buffer
    /// </summary>
    function GetSize: UInt32;
    /// <summary>
    ///   Increments the Tail marker, wrapping it to 0 when necessary
    /// </summary>
    /// <param name="Increment">
    ///   How much items the Tail should be advanced
    /// </param>
    /// <remarks>
    ///   The method assumes that the case <c>Tail+ Increment &gt; First</c> is already taken care of by the caller
    /// </remarks>
    procedure AdvanceNextFree(Increment: UInt32); inline;
    /// <summary>
    ///   Prototype method for freeing objects
    /// </summary>
    /// <param name="StartIndex">
    ///   Index of the first item to be deleted. Must be less than <c>EndIndex</c> and in the range <c>0 .. Count - 1</c>
    ///   . Thus wrapped buffer content cannot be deleted in one go.
    /// </param>
    /// <param name="EndIndex">
    ///   Index of the last item to be deleted. Must be larger than <c>StartIndex</c> and in the range <c>0 .. Count -
    ///   1.</c>
    /// </param>
    /// <remarks>
    ///   The current implementation is empty, but is overridden in <c>TObjectRiungBuffer&lt;T&gt;</c>.
    /// </remarks>
    procedure FreeOrNilItems(StartIndex, EndIndex: UInt32); virtual;
  public
    /// <summary>
    ///   Creates the ring buffer with the given size
    /// </summary>
    /// <param name="Size">
    ///   Number of elements the ring buffer will hold
    /// </param>
    constructor Create(Size: UInt32);
    /// <summary>
    ///   Frees the ring buffer memory
    /// </summary>
    /// <example>
    ///   Any object instances in the ring buffer will not be freed. If the ring buffer shall be responsible for
    ///   managing the lifetime of those objects <c>TObjectRingbuffer&lt;T&gt;</c> would be the better choice!
    /// </example>
    destructor  Destroy; override;

    /// <summary>
    ///   Appends the given item to the ring buffer
    /// </summary>
    /// <param name="Item">
    ///   Anzuhängendes Element
    /// </param>
    /// <exception cref="EBufferFullException">
    ///   not enough capacity
    /// </exception>
    /// <remarks>
    ///   If there is not enough capacity an <c>EBufferFullException</c> is raised. <br />
    /// </remarks>
    procedure   Add(Item: T); overload; virtual;
    /// <summary>
    ///   Appends multiple items to the ring buffer
    /// </summary>
    /// <param name="Items">
    ///   array of elements to append
    /// </param>
    /// <exception cref="EBufferFullException">
    ///   not enough capacity
    /// </exception>
    /// <remarks>
    ///   The size of the array must be less than the free capacity of the buffer. Otherwise an <c>EBufferFullException</c>
    ///    is raised.
    /// </remarks>
    procedure   Add(Items:TRingbufferArray); overload; virtual;

    /// <summary>
    ///   Returns the first element from the ring buffer and removes it
    /// </summary>
    /// <returns>
    ///   The element from the buffer which was longest in the buffer
    /// </returns>
    /// <exception cref="EBufferEmptyException">
    ///   buffer is empty
    /// </exception>
    /// <remarks>
    ///   If the buffer is empty an <c>EBufferEmptyException</c> is raised
    /// </remarks>
    function    Remove:T; overload; virtual;
    /// <summary>
    ///   Returns the first <c>RemoveCount</c> elements from the buffer
    /// </summary>
    /// <param name="RemoveCount">
    ///   Number of elements to retrieve
    /// </param>
    /// <returns>
    ///   Array mit einer maximalen Länge von Count
    /// </returns>
    /// <exception cref="EBufferEmptyException">
    ///   buffer is empty
    /// </exception>
    /// <exception cref="EArgumentOutOfRangeException">
    ///   <c>RemoveCount</c> exceeds buffer size
    /// </exception>
    /// <remarks>
    ///   <list type="bullet">
    ///     <item>
    ///       If there are less elements in the buffer as requested, only the vailable elements are returned
    ///     </item>
    ///     <item>
    ///       If the buffer is empty an EBufferEmptyException is raised.
    ///     </item>
    ///     <item>
    ///       If more elements are requested than the capacity of the buffer an EArgumentOutOfRangeException is
    ///       raised
    ///     </item>
    ///   </list>
    /// </remarks>
    function    Remove(RemoveCount: UInt32):TRingbufferArray; overload; virtual;
    /// <summary>
    ///   Removes the given number of elements from the buffers Head
    /// </summary>
    /// <param name="Count">
    ///   Number of elements to be deleted
    /// </param>
    /// <exception cref="EArgumentOutOfRangeException">
    ///   <c>Count</c> exceeds buffer size
    /// </exception>
    /// <remarks>
    ///   <para>
    ///     Elements are not overridden, but cannot be accessed after being deleted.
    ///   </para>
    ///   <para>
    ///     If more elements are to be deleted than are available in the buffer, the buffer is cleared.
    ///   </para>
    ///   <para>
    ///     If more elements are to be deleted than the capacity of the buffer an <b>EArgumentOutOfRangeException</b>
    ///     is raised.
    ///   </para>
    /// </remarks>
    procedure   Delete(Count: UInt32); virtual;
    /// <summary>
    ///   Clears the buffer and initializes Head and Tail
    /// </summary>
    /// <remarks>
    ///   There is no data overridden, but cannot be accessed any more.
    /// </remarks>
    procedure   Clear; virtual;

    /// <summary>
    ///   Returns an item from the buffer from the given position without removing it
    /// </summary>
    /// <param name="Index">
    ///   Index of the item to be returned. Range is <c>0 .. Count-1</c>. <c>0</c> is same as Head.
    /// </param>
    /// <returns>
    ///   Item at <c>Index</c> position. The item stays in the buffer.
    /// </returns>
    /// <exception cref="EArgumentOutOfRangeException">
    ///   <c>Index</c> exceeds available elements
    /// </exception>
    /// <remarks>
    ///   The allowed range for Index is 0 .. Count-1. If the index is outside this range an
    ///   EArgumentOutOfRangeException is raised. <br />
    /// </remarks>
    function    Peek(Index: UInt32):T; overload;
    /// <summary>
    ///   Retrieves multiple items from the buffer without removing them
    /// </summary>
    /// <param name="Index">
    ///   Index of the first element retrieved. Rangs is <c>0 .. Count-1</c>.
    /// </param>
    /// <param name="Count">
    ///   Number of items to retrieve.
    /// </param>
    /// <returns>
    ///   The items from <c>Index</c> position up to the requested count or less. The buffer content is not changed.
    /// </returns>
    /// <exception cref="EArgumentOutOfRangeException">
    ///   <c>Index</c> exceeds <c>Count - 1</c> or the buffer capacity
    /// </exception>
    /// <remarks>
    ///   <para>
    ///     If Index is larger than <c>Count - 1</c> an <b>EArgumentOutOfRangeException</b> is raised.
    ///   </para>
    ///   <para>
    ///     <c>Count = 0</c> returns an empty array.
    ///   </para>
    ///   <para>
    ///     If more items are requested than are available in the buffer the number of items returned is capped to
    ///     the possible number.
    ///   </para>
    ///   <para>
    ///     If more items are requested than the buffer capacity an <b>EArgumentOutOfRangeException</b> is raised.
    ///   </para>
    /// </remarks>
    function    Peek(Index, Count: UInt32):TRingbufferArray overload;

    /// <summary>
    ///   Returns the number of elements that can be stored in the ring buffer
    /// </summary>
    property Size   : UInt32
      read   GetSize;

    /// <summary>
    ///   Returns the number of items currently in the ring buffer
    /// </summary>
    property Count  : UInt32
      read   GetCount;

    /// <summary>
    ///   This event is triggered by all operations manipulating the number of elements in the ring buffer: Add,Remove,
    ///   Delete...
    /// </summary>
    property Notify : TRingbufferNotify
      read   FNotify
      write  FNotify;

    /// <summary>
    ///   Indicates whether the ring buffer takes ownership of the instances <br />
    /// </summary>
    property OwnsObjects: Boolean
      read   FOwnsObjects
      write  FOwnsObjects;
  end;

implementation

{ TRingbuffer<T> }

procedure TRingbuffer<T>.Add(Item: T);
begin
  // nur hinzufügen wenn entweder noch Platz im Puffer oder wenn Puffer ganz
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
  i                 : UInt32;
begin
  assert(length(Items) > 0, 'Hinzufügen eines leeren Arrays ist nicht sinnvoll');

  // ist überhaupt noch soviel Platz im Puffer?
  // Typecast nach Int64 um W1023 Warnung zu unterdrücken
  if (length(Items) <= Int64(Size-Count)) then
  begin
    // leeres Array sollte eigentlich nicht vorkommen, aber falls im Release
    // Build Assertions aus sind sollte es auch nicht abstürzen
    if (length(Items) > 0) then
    begin
      // Passt das übergebene Array im Stück in den Puffer und der Puffer Inhalt
      // geht derzeit auch nicht über die obere Grenze hinaus, oder muss es
      // gesplittet werden? Typecast nach Int64 um W1023 Warnung zu unterdrücken
      if (Int64(Size-FNextFree) >= length(Items)) then
      begin
        if not IsManagedType(T) then
          Move(Items[0], FItems[FNextFree], length(Items) * SizeOf(Items[0]))
        else
          for i := 0 to length(Items) - 1 do
            FItems[FNextFree + i] := Items[i];
      end
      else
      begin
        // restlichen Platz im Puffer berechnen
        FreeItemsAfterEnd := Size - FNextFree;

        if not IsManagedType(T) then
        begin
          // von Ende-Marker bis zum Array Ende
          Move(Items[0], FItems[FNextFree], FreeItemsAfterEnd * SizeOf(Items[0]));
          // restliche Daten vom Anfang an
          Move(Items[FreeItemsAfterEnd], FItems[0],
               (UInt32(length(Items))-FreeItemsAfterEnd) * SizeOf(Items[0]));
        end
        else
        begin
          for i := 0 to FreeItemsAfterEnd - 1 do
            FItems[FNextFree + i] := Items[i];

          for i := FreeItemsAfterEnd to length(Items) - 1 do
            FItems[i-FreeItemsAfterEnd] := Items[i];
        end;
      end;

      // Endeindex erhöhen
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
  Remaining : UInt32; // Verbleibende Speicherplätze bis zur oberen Array Grenze
begin
  Remaining := Size-FNextFree;

  inc(FNextFree, Increment);
  // Ende Marker über das Array-Ende hinaus erhöht
  if (FNextFree > Size-1) then
    FNextFree := (Increment-Remaining);
end;

procedure TRingbuffer<T>.Clear;
var
  i : Integer;
begin
  FStart        := 0;
  FNextFree     := 0;
  FContainsData := false;

  FreeObjectsIfOwned(FStart, Size - 1);

  if (Count > Count - (Size -FStart)) then
    FreeObjectsIfOwned(0, Count - (Size -FStart));

  if IsManagedType(T) then
    for i := 0 to High(FItems) do
      FItems[i] := Default(T);

  if assigned(FNotify) then
    FNotify(0, evRemove);
end;

constructor TRingbuffer<T>.Create(Size: UInt32);
var
  i : Integer;
begin
  assert(Size >= 2, 'Puffer mit weniger als 2 Elementen sind nicht sinnvoll!');

  inherited Create;

  SetLength(FItems, Size);
  for i :=  0 to High(FItems) do
    FItems[i] := Default(T);

  FStart        := 0;
  FNextFree     := 0;
  FContainsData := false;
  FNotify       := nil;
end;

procedure TRingbuffer<T>.Delete(Count: UInt32);
var
  Remaining : UInt32; // Verbleibende Speicherplätze bis zur oberen Array Grenze
  i         : Integer;
begin
  if (Count <= Size) then
  begin
    // Puffer nur teilweise zu löschen?
    if (Count < self.Count) then
    begin
      Remaining := Size - FStart;
      // Pufferinhalt geht nicht über obere Array Grenze hinaus?
      if (Count < Remaining) then
      begin
        if (Count > 0) then
        begin
          if IsManagedType(T) then
            for i := FStart to FStart + Count - 1 do
              FItems[i] := Default(T);

          FreeObjectsIfOwned(FStart, FStart + Count - 1);

          // Startmarker verschieben
          FStart := FStart + Count;
        end;
      end
      else
      begin
        if (Count > 0) then
        begin
          FreeObjectsIfOwned(FStart, FStart + Remaining - 1);
          FreeObjectsIfOwned(0, Count - Remaining - 1);

          if IsManagedType(T) then
          begin
            // clear until the high end
            for i := FStart to Size - 1 do
              FItems[i] := Default(T);

            for i := 0 to Count - Remaining - 1 do
              FItems[i] := Default(T);
          end;

          // Anzahl der Positionen um die insgesamt verschoben werden soll - Anzahl
          // der Positionen bis zum oberen Array Ende abziehen ergibt neue
          // Startposition vom Array-Anfang aus gesehen.
          FStart := (Count - Remaining);
        end;
      end;

      // nur benachrichtigen wenn überhaupt was gelöscht werden sollte
      if assigned(FNotify) and (Count > 0) then
        FNotify(Count, evRemove);
    end
    else
      // alles zu löschen
      Clear;
  end
  else
    raise EArgumentOutOfRangeException.Create('Cannot delete more that buffer '+
                                              'size elements. Size: '+Size.ToString+
                                              ' Elements to be deleted: '+Count.ToString);
end;

destructor TRingbuffer<T>.Destroy;
begin
  FreeObjectsIfOwned(0, Size-1);

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
    // Je nach dem ob der Puffer gerade über das Ende hinaus geht und am Anfang
    // weiter geht
    if (FNextFree > FStart) then
      result := FNextFree-FStart
    else
    begin
      // Puffer geht über das Ende hinaus und beginnt am Array Anfang wieder
      l := (length(FItems)-Int64(FStart))+FNextFree;
      result := abs(l);
    end;
  end
  else
    // Start = Ende aber es sind daten da? Dann ist Puffer maximal gefüllt
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
    // buffer doesn't wrap at the high array bound yet
    if ((FStart+Index) < Size) then
      result := FItems[FStart+Index]
    else
    begin
      // how much does the buffer exceed the upper array bounds?
      reminder := (FStart+Index)-Size;
      result   := FItems[reminder];
    end;
  end
  else
    raise EArgumentOutOfRangeException.Create('Invalid Index: '+Index.ToString+
                                              ' Max. Index: '+Count.ToString);
end;

procedure TRingbuffer<T>.CopyItems(var Dest: TRingbufferArray; StartIndex, Count: UInt32);
var
  i, n : Integer;
begin
  assert(assigned(Dest), 'Destination array not assigned');
  assert(StartIndex < self.Count,
         'StartIndex too high. StartIndex: ' + StartIndex.ToString +
         ' Count: ' + self.Count.ToString);
  assert(Count <= self.Count,
         'Cannot copy ' + Count.ToString + ' items when only ' +
         self.Count.ToString + ' are in the buffer');

  n := 0;
  for i := StartIndex to StartIndex + Count-1 do
  begin
    Dest[n] := self.FItems[i];
    inc(n);
  end;
end;

function TRingbuffer<T>.Peek(Index, Count: UInt32): TRingbufferArray;
var
  RemoveableCount   : UInt32;  // Number of removeable items, most times count
  RemainingCount    : UInt32;  // Number of items from Start until Pufferende
  i                 : UInt32;
begin
  // Have more items been requested than fitting into the buffer?
  // Is the index in the valid range?
  if (Count <= Size) and (Index < self.Count) then
  begin
    // Ist überhaupt was im Puffer?
    if (self.Count > 0) then
    begin
      // there are as many items in the buffer as shall be copied
      if (Count <= self.Count) then
        RemoveableCount := Count
      else
        // No, just remove as many as possible
        RemoveableCount := self.Count;

      SetLength(result, RemoveableCount);

      // wraps the current buffer contents at the upper border of the buffer?
      if ((FStart+Index+RemoveableCount) <= Size)  then
      begin
        // No, one can copy directly
        if not IsManagedType(T) then
          Move(FItems[FStart+Index], result[0], RemoveableCount * SizeOf(FItems[0]))
        else
          if RemoveableCount > 0 then
            CopyItems(result, FStart+Index, RemoveableCount);
      end
      else
      begin
        // Yes, two copy operations necessary
        RemainingCount := (Size-(FStart+Index));

        if not IsManagedType(T) then
          // from Startindex until buffer end
          Move(FItems[FStart+Index], result[0], RemainingCount * SizeOf(FItems[0]))
        else
          CopyItems(result, FStart+Index, RemainingCount);

        // from start of the buffer until end-pointer
        RemoveableCount := RemoveableCount-RemainingCount;

        if not IsManagedType(T) then
          Move(FItems[0], result[RemainingCount], RemoveableCount * SizeOf(FItems[0]))
        else
          for i := 0 to RemoveableCount - 1 do
            result[RemainingCount + i] := FItems[i];
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
  StillContainsData : Boolean; // Enthält der Puffer nach der Remove Operation
                               // immer noch Daten?
  i                 : UInt32;
begin
  if (RemoveCount > 0) then
  begin
    // wurden mehr Elemente angefordert als überhaupt je in den Puffer passen?
    if (RemoveCount <= Size) then
    begin
      // Ist überhaupt was im Puffer?
      if (Count > 0) then
      begin
        // es sind soviele Elemente im Puffer wie entfernt werden sollen
        if (RemoveCount <= Count) then
          RemoveableCount := RemoveCount
        else
          // Nein, also nur soviele entfernen wie überhaupt möglich
          RemoveableCount := Count;

        SetLength(result, RemoveableCount);
        // wenn alle Elemente entfernt werden sollen muss Flag hinterher auf False
        // gesetzt werden
        StillContainsData := RemoveCount <> Count;

        // geht der aktuelle Puffer inhalt über die obere Grenze (d.h. klappt um)?
        if ((FStart + RemoveableCount) <= Size)  then
        begin
          // Nein, also Elemente direkt kopierbar
          if not IsManagedType(T) then
            Move(FItems[FStart], result[0], RemoveableCount * SizeOf(FItems[0]))
          else
            for i := FStart to FStart + RemoveableCount - 1 do
            begin
              result[i-FStart] := FItems[i];
              // Take care of the reference counting by setting it to default
              // for the type
              FItems[i]        := Default(T);
            end;

          inc(FStart, RemoveableCount);
        end
        else
        begin
          // 2 Kopieroperationen nötig
          RemainingCount := (Size-FStart);

          // von Startzeiger bis Pufferende
          if not IsManagedType(T) then
            Move(FItems[FStart], result[0], RemainingCount * SizeOf(FItems[0]))
          else
            for i := FStart to FStart + RemainingCount - 1 do
            begin
              result[i-FStart] := FItems[i];
              // Take care of the reference counting by setting it to default
              // for the type
              FItems[i]        := Default(T);
            end;

          // von Pufferstart bis Endezeiger
          RemoveableCount := RemoveableCount-RemainingCount;

          if not IsManagedType(T) then
            Move(FItems[0], result[RemainingCount], RemoveableCount * SizeOf(FItems[0]))
          else
            for i := 0 to RemoveableCount - 1 do
            begin
              result[RemainingCount + i] := FItems[i];
              // Take care of the reference counting by setting it to default
              // for the type
              FItems[i]                  := Default(T);
            end;

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
  end
  else
    SetLength(Result, 0);
end;

function TRingbuffer<T>.Remove: T;
var
  i : UInt32;
begin
  // ist überhaupt was im Puffer?
  if Count > 0 then
  begin
    result := FItems[FStart];

    // for managed types we need to free it or decrement reference counter
    if IsManagedType(T) then
      FItems[FStart] := Default(T);

    // Anfangsmarker verschieben
    inc(FStart);
    // obere Grenze überschritten?
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

procedure TRingbuffer<T>.FreeObjectsIfOwned(StartIndex, EndIndex: UInt32);
var
  i : UInt32;
begin
  assert(EndIndex <= Size, 'Endindex too high. Is: '+
         EndIndex.ToString+' Allowed: '+Size.ToString);
  assert(StartIndex <= EndIndex, 'Invalid range specified: '+
         StartIndex.ToString+'/'+EndIndex.ToString);

  if FOwnsObjects and (GetTypeKind(T) = tkClass) then
  begin
    for i := StartIndex to EndIndex do
      PObject(@FItems[i])^.Free;

    for i := StartIndex to EndIndex do
      FItems[i] := Default(T);
  end;
end;

end.
