# CircularBuffer
Generic circular buffer/ring buffer implementation

# Supported Delphi versions
At least from XE7 onwards, but most likely earlier versions 
supporting generics as well. Erarlier versions will not worksdue 
to the use of some intrinsics added in XE7.

# Contents
The project contains one unit implementing a generic circular buffer class
which can be used to easily create circular buffers for simple data types
like Byte, Integer, Single, Double as well as for object types, which
means any TObject descendants.

I have not tested yet whether the current implmementationalso works with
interface references but since it can handle strings as managed types,
why don't you just try it out?

Also contained is a DUnit test project. Since this also tests the exceptions
raised it might be better to be run from outside the IDE.

# Contributing
Contributions are welcome!
Check notice.txt for an e-mail address or submit a pull request.

# Useful contributions

1. Adding further unit tests where useful, especially for use with 
   interface types

2. Maybe writing a simple demo application