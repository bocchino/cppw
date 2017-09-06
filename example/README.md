# Example

This directory provides a detailed example showing how to use `cppw`.

## Contents

This directory contains the following files:

* `Example.cppw`: An example `.cppw` file.

* `Example.hpp`, `Example.cpp`, and `Value.cpp`: C++ files generated from `.cppw`
using `cppw`.

* `refresh.do`: The build script used to generate the `.hpp` and `.cpp` files.
Running `redo refresh` regenerates the files.

* Other `*.do` files and `defs.sh`: Standard `redo` build scripts for building
`.o` files from `.cpp` and `.hpp` files.

## Explanation of Example.cppw

The following is a detailed explanation of the file `Example.cppw`.
**Generating a `.hpp` file** means running `cppw -h`.
**Generating a `.cpp` file** means running `cppw` or `cppw -f`.

**Line 1:** The tag `@CPPFILE` sets the current C++ file.
In this case, the C++ file is set to `Example.cpp`.
The C++ file remains set to this value until it is set to `Value.cpp`
in line 7.

Running `cppw` with the option `-f` *cpp-file* causes tags to be processed
only when the current C++ file is equal to *cpp-file*.
By changing the C++ file to different values, you can 
use different parts of the same `.cppw` file to generate
different `.cpp` files.
In this case, the code generated from the tags in lines 2-6 
are processed when running `cpp -f Example.cpp` but when running `cpp -f Value.cpp`.
These lines generate lines 6-7 of `Example.cpp`.
The command that does it is in line 27 of `refresh.do`.

**Line 2:** The tag `@CPP` says to use the following `@BEGIN` block (see
immediately below) to generate C++ code. 
It is processed when generating a `.cpp` file if the C++ file matches (see above). 
It is ignored when generating an `.hpp` file.

**Lines 3-6:** An example of a `@BEGIN` block.
The block starts with the tag `@BEGIN` and ends with the tag `@END`.
The lines between the tags are the **lines** of the `@BEGIN` block.
When processing the tags, `cppw` copies these lines to its output,
except for spacing:

* A `@BEGIN` block following a `@CPP` tag (as here) has **relative spacing**:
  each line of the begin block is assigned an **offset**, which
  is the number of spaces to the right of the `@BEGIN` tag that the first non-whitespace
  character appears (characters appearing to the left of the `@BEGIN` tag
  have a negative offset).
  When `.cppw` constructs its output, the first character of each line appears
  at the position given by the current indent amount (determined by the
  context) plus the offset.
  In this case the current indent amount is zero and the offset is zero.

* Other `@BEGIN` blocks have **absolute spacing**. This means that each
  line of the block is copied to its output exactly, without altering
  the indent spacing.
  Examples of `@BEGIN` blocks with absolute spacing appear below.

Tabs count as two spaces for purposes of these rules. However, you should not
ever use tabs when writing C++ code! Set your editor to replace tabs with
spaces.

**Lines 7-12:** Similar to lines 6-11, except that the C++ file is
`Value.cpp`.
These lines generate lines 6-7 of `Value.cpp`.
The command that does it is in line 37 of `refresh.do`.

**Line 13:** Sets the C++ file to `Example.cpp`.

**Line 14:** Generates the blank line in line 6 of `Example.hpp`.
Ignored in generating `Example.cpp` and `Value.cpp`.

**Line 15:** Generates the include guard at lines 7-8 and 74 of `Example.hpp`.
Ignored in generating `Example.cpp` and `Value.cpp`.

**Lines 16-17:** Generates lines 9-10 of `Example.hpp`.
Ignored in generating `Example.cpp` and `Value.cpp`.

**Line 18:** The tag `@BOTH` says to place the lines of the following
`@BEGIN` block in the generated `.cpp` file with relative spacing
(if the C++ file matches) and in the generated `.hpp` file with
absolute spacing.

**Lines 19-24:**: Generates lines 11-14 of `Example.hpp` and lines
10-13 of `Example.cpp`.

**Lines 25-26:**: Generates lines 15-16 of `Example.hpp`.
Ignored in generating `Example.cpp` and `Value.cpp`.

**Line 27:** Illustrates a `@FUNCTION` tag. This is a way to specify
a C++ function prototype and body once, and use it to generate
both the prototype for the `.hpp` file and the prototype plus body
for the `.cpp` file.
A function specification consists of 

* The `@FUNCTION` tag.

* Zero or more tags giving the arguments, return types, and
qualifiers for the function (explained below).

* A `@BEGIN` block giving the body of the function.

**Line 28:** The name of the function is `sampleFunction`.

**Line 29:** The return type of the function is `int`.

**Lines 30-32:** The body of the function.
There are no arguments given, so the argument type is `void`.

**Lines 33-50:** A chunk of code that goes into the current C++ file,
which is `Example.cpp` (set in line 13).

**Lines 51-69:** Code that goes into `Value.cpp`.

**Lines 70-84:** Code that goes into `Example.hpp`.

**Lines 85-91:** A class member function.
Similar to the function definition starting at line 27, but it
generates the appropriate `.hpp` and `.cpp` syntax for a member
function.
The `@CONST` tag in line 88 causes the function to be marked `const`.
There are also tags `@STATIC`, `@VIRTUAL`, and `@PURE`,
where `@PURE` means pure virtual.

To keep the parsing simple, every function must have a `@BEGIN` block, 
even if it is pure virtual.
A pure virtual function should have an empty `@BEGIN` block (the
actual contents of the block are ignored).

**Lines 92-93:** Code that goes into `Example.hpp`.

**Lines 94-99:** A class member function with an argument.
There may be zero or more `@ARGUMENT` tags, each of which gives 
an argument.
Comments in the argument are reproduced in the `.hpp` file
and omitted in the `.cpp` file.

**Lines 100-106:** Code that goes into `Example.hpp`.

**Lines 108-114:** Code that goes into `Example.hpp` and `Example.cpp`.

**Lines 115-118:** Code that goes into `Example.hpp`.

**Lines 119-124:** A constructor.
The tag `@CONSTRUCTOR` introduces a constructor.
There is no `@NAME` tag because the name of the constructor is implied
by the enclosing class.
The arguments are optional and work like function arguments.
`@INITIALIZER` tags are optional; each one generates a constructor
initializer.
The constructor body goes in a `@BEGIN` block.

**Lines 125-126:** Code that goes into `Example.hpp`.

**Lines 127-132:** A destructor.
The tag `@DESTRUCTOR` introduces a destructor.
There is no `@NAME` tag because the name of the destructor is implied
by the enclosing class.
The constructor body goes in a `@BEGIN` block.

**Lines 131-137:** Code that goes into `Example.hpp` and `Example.cpp`

**Lines 138-141:** Code that goes into `Example.hpp`.

**Lines 142-148:** Another class member function.

**Lines 149-150:** Code that goes into `Example.hpp`.

**Lines 151-156:** Another class member function.

**Lines 157-169:** Code that goes into `Example.hpp`.
