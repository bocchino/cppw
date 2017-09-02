#!/bin/sh -e

# ----------------------------------------------------------------------
# default.hpp.do
# ----------------------------------------------------------------------

. ./defs.sh

redo-ifchange Example.cppw
echo '// ======================================================================
// \\name Example.cpp 
// \\author AUTO-GENERATED: DO NOT EDIT
// \\brief Example class implementation
// ======================================================================'
awk -f ../scripts/cppw2cpp.awk -v cppfile=Example.cpp Example.cppw

