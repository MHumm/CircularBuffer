# CircularBuffer
Generic circular buffer/ring buffer implementation

#Supported Delphi versions
At least from XE8 onwards, but most likely eralier versions 
supporting generics as well.

# Contents
The project contains one unit implementing a generic circular buffer class
which can be used to easily create circular buffers for simple data types
like Byte, Integer, Single, Double as well as for object types which
means any TObject descendants.

I didn't think about interfaces yet, but why don't you think about it and 
contribute where necessary?

Also contained is a DUnit test project. Since this also tests the exceptions
raised it might be better to be run from outside the IDE.

# Contributing
Contributions are welcome!
Check notice.txt for an e-mail address or submit a pull request.

# Useful contributions

1. Implementation of the still empty unit tests

2. Adding further unit tests where useful

3. Translating the German XMLDOC comments into English

4. Maybe writing a simple demo application