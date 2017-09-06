# C++ Writer (cppw)

C++ Writer (cppw for short) is a tool that assists in writing C++ programs.
One bothersome aspect of C++ is that you generally have to maintain at least
two source files (an `.hpp` file and a `.cpp`) file for each class.
These files contain lots of duplicate information, which is a pain
to construct and maintain by hand.

cppw addresses this problem by letting you write your class as a single `.cppw` 
file, with no duplicate information.
The `.cppw` file contains the minimum C++ code needed to generate the `.hpp`
and `.cpp` files, plus a few simple annotations that tell the tool how you
want those file laid out.
Then you run the tool on the `.cppw` files to generate the `.hpp` and `.cpp`
files.

The tool is very flexible: from a single `.cppw` file you can generate the C++
code for an `.hpp` file and one or more `.cpp` files. You can use standard
shell scripts to combine this generated code with other text (e.g.,
auto-generated comment banners) into `.hpp` and `.cpp` files.

## Contents

This repository contains the following items:

* `bin`: The scripts that run the tool.

* `defs`: Definitions used by the build system in this repository, 
including system-specific configuration.

* `editors`: Files that provide syntax highlighting for text editors.
Currently, only `vim` is supported.

* `example`: An example `.cppw` file, together with its generated
`.hpp` and `.cpp` files, that illustrate the tool in action.

## Requirements

To use this software, you need the following:

1. A Unix environment.

2. The [`redo` build system](https://github.com/bocchino/redo).

## Installation

To install the software, carry out the following steps:

1. Clone this repository to your computer.

2. Copy `defs/config.sh.example` to `defs/config.sh`.
Edit the file so the following variables have the desired values:

  * `INSTALL`: The command to use for installation.

  * `BINDIR`: The directory for installing the "binary files" for 
running `cppw`.

  If you don't change anything, the installation will go into subdirectories
  of `$CPPW_ROOT/installdir`, where `CPPW_ROOT` is the top-level directory
  of this repository.
  To install `redo` globally, change `$REDO_ROOT/installdir` 
  to something like `/usr`.

3. In the top-level directory of this repository, run `do install`.
Note that if you opted for a global installation in step 2, you may
have to run the command with `sudo` permission (i.e., `sudo do install`).

4. If the directory that you picked for `$BINDIR` in step 2 is not already in your 
Unix `PATH`, then add it now.
It's best to do this in the startup configuration file for your shell
(e.g., `.bashrc`).

5. Check that you have a good `cppw` installation: `which cppw`.

## Using cppw

### Tags

A `.cppw` file consists of C++ code interspersed with **tags**. A cppw tag
consists of the symbol `@` followed by an identifier, with no intervening
space. Nothing but white space must occur before the tag on the same line as
the tag.

While sequence of characters meeting the definition above is a tag, only
certain tags are **meaningful**, i.e., recognized by the tool.
For more information on meaningful tags, and how to use `cppw` generally,
see the `README` file in the `example` directory.

In the future, more meaningful tags may be added.

### Running cppw

To run cppw, use the command `cppw`.
The following options are available when running this command:

* `cppw` `-v`: Print the version number and exit, ignoring input.

* `cppw` `-h` `[` `--` `]` `[` *files* ... `]`: Generate C++ code for inclusion
in an `.hpp` file

* `cppw` `[` `--` `]` `[` *files* ... `]`: Generate C++ code for inclusion in
a `.cpp` file, processing all tags.

* `cppw` `-f` *cpp-file* `[` `--` `] [` *files* ... `]`:
Generate C++ code for inclusion in a `.cpp` file, processing
tags only in regions where the current C++ file, set with
the tag `@CPPFILE`, is equal to *cpp-file*.

The notation `[` *files* ... `]` means (1)
process all input files, in order, if any appears; otherwise (2) 
read from standard input.

The option `--`, if present, marks the end of the options.
The filename `-` indicates the standard input.
