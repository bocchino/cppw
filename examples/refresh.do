#!/bin/sh -e

# ----------------------------------------------------------------------
# refresh.do
# ----------------------------------------------------------------------

. ./defs.sh

bin=$CPPW_ROOT/bin
redo-ifchange Example.cppw

Example_hpp_do() {
  echo '// ======================================================================
// \\name Example.hpp
// \\author AUTO-GENERATED: DO NOT EDIT
// \\brief Example class interface
// ======================================================================'
  awk -f $bin/cppw2hpp.awk Example.cppw
}

Example_cpp_do() {
  echo '// ======================================================================
// \\name Example.cpp
// \\author AUTO-GENERATED: DO NOT EDIT
// \\brief Example class implementation
// ======================================================================'
  awk -f $bin/cppw2cpp.awk -v cppfile=Example.cpp Example.cppw
}

Value_cpp_do() {
  redo-ifchange Example.cppw
  echo '// ======================================================================
// \\name Value.cpp
// \\author AUTO-GENERATED: DO NOT EDIT
// \\brief Implementation file for Example::Value
// ======================================================================'
  awk -f $bin/cppw2cpp.awk -v cppfile=Value.cpp Example.cppw
}

Example_hpp_do > Example.hpp
Example_cpp_do > Example.cpp
Value_cpp_do > Value.cpp

