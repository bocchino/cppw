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
  $bin/cppw -h Example.cppw
}

Example_cpp_do() {
  echo '// ======================================================================
// \\name Example.cpp
// \\author AUTO-GENERATED: DO NOT EDIT
// \\brief Example class implementation
// ======================================================================'
  $bin/cppw -f Example.cpp Example.cppw
}

Value_cpp_do() {
  redo-ifchange Example.cppw
  echo '// ======================================================================
// \\name Value.cpp
// \\author AUTO-GENERATED: DO NOT EDIT
// \\brief Implementation file for Example::Value
// ======================================================================'
  $bin/cppw -f Value.cpp Example.cppw
}

Example_hpp_do > Example.hpp
Example_cpp_do > Example.cpp
Value_cpp_do > Value.cpp

