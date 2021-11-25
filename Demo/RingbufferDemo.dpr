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
program RingbufferDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Ringbuffer in '..\Source\Ringbuffer.pas';

type
  TPerson = record
    Name : string;
    Age  : UInt8;
  end;

  TPersonObject = class(TObject)
  public
    Name : string;
    Age  : UInt8;

    constructor Create(aName: string; aAge: UInt8);
    procedure Print;
  end;

var
  IntegerBuffer : TRingbuffer<Integer>;
  IntegerArray  : TRingbuffer<Integer>.TRingbufferArray;

  RecordBuffer  : TRingBuffer<TPerson>;
  Person        : TPerson;

  PersonBuffer  : TRingBuffer<TPersonObject>;
  PersonObject  : TPersonObject;

  i             : Integer;

procedure ShowIntegerBufferContents;
var
  i : Integer;
begin
  for i := 0 to IntegerBuffer.Count - 1 do
    WriteLn('Index: ', i:2, ' Value: ', IntegerBuffer.Peek(i));

  WriteLn('Capacity: ', IntegerBuffer.Size, ' Fill level: ', IntegerBuffer.Count);

  if (IntegerBuffer.Count = IntegerBuffer.Size) then
    WriteLn('Adding one more element raises an exception! Remove or delete at least one first');

  WriteLn;
end;

procedure ShowPersonBufferContents;
var
  i : Integer;
  Person : TPerson;
begin
  for i := 0 to RecordBuffer.Count - 1 do
  begin
    Person := RecordBuffer.Peek(i);
    WriteLn('Index: ', i:2, ' Name: ', Person.Name, ' Age: ' + Person.Age.ToString);
  end;

  WriteLn('Capacity: ', RecordBuffer.Size, ' Fill level: ', RecordBuffer.Count);

  if (RecordBuffer.Count = RecordBuffer.Size) then
    WriteLn('Adding one more element raises an exception! Remove or delete at least one first');

  WriteLn;
end;

procedure ShowPersonObjectBufferContents;
var
  i : Integer;
  Person : TPersonObject;
begin
  for i := 0 to PersonBuffer.Count - 1 do
  begin
    Person := PersonBuffer.Peek(i);
    Write('Index: ', i:2, ' ');
    Person.Print;
  end;

  WriteLn('Capacity: ', PersonBuffer.Size, ' Fill level: ', PersonBuffer.Count);

  if (PersonBuffer.Count = PersonBuffer.Size) then
    WriteLn('Adding one more element raises an exception! Remove or delete at least one first');

  WriteLn;
end;

{ TPersonObject }

constructor TPersonObject.Create(aName: string; aAge: UInt8);
begin
  Name := aName;
  Age  := aAge;
end;

procedure TPersonObject.Print;
begin
  WriteLn('My name is: ' + Name + ' and I am ' + Age.ToString + ' years old');
end;

begin
  try
    // Create a buffer with a capacity of 5 elements
    IntegerBuffer := TRingbuffer<Integer>.Create(5);

    try
      // completely fill the buffer
      for i := 1 to 5 do
        IntegerBuffer.Add(i);

      ShowIntegerBufferContents;

      // remove one element to be able to add another one later
      i := IntegerBuffer.Remove;

      WriteLn('Value removed element: ', i:2);
      WriteLn('After removing one element:');
      ShowIntegerBufferContents;

      IntegerBuffer.Add(6);
      WriteLn('After adding another element:');
      ShowIntegerBufferContents;

      IntegerBuffer.Clear;
      ShowIntegerBufferContents;

      SetLength(IntegerArray, 2);
      IntegerArray[0] := 11;
      IntegerArray[1] := -5;
      IntegerBuffer.Add(IntegerArray);
      ShowIntegerBufferContents;
    finally
      IntegerBuffer.Free;
    end;

    WriteLn('Press enter for 2nd part');
    WriteLn;
    ReadLn;

    RecordBuffer  := TRingBuffer<TPerson>.Create(8);

    try
      Person.Name := 'Steffie McKenzy';
      Person.Age  := 32;
      RecordBuffer.Add(Person);

      Person.Name := 'John Doe';
      Person.Age  := 55;
      RecordBuffer.Add(Person);

      ShowPersonBufferContents;
    finally
      RecordBuffer.Free;
    end;

    WriteLn('Press enter for 3rd part');
    WriteLn;
    ReadLn;

    PersonBuffer := TRingBuffer<TPersonObject>.Create(5);
    try
      PersonBuffer.OwnsObjects := true;

      PersonObject := TPersonObject.Create('Sally', 33);
      PersonBuffer.Add(PersonObject);
      PersonObject := TPersonObject.Create('Peter', 58);
      PersonBuffer.Add(PersonObject);
      PersonObject := TPersonObject.Create('Rufus', 12);
      PersonBuffer.Add(PersonObject);
      ShowPersonObjectBufferContents;
    finally
      PersonBuffer.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  ReadLn;
end.
