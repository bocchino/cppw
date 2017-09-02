#!/bin/sh -e

# ----------------------------------------------------------------------
# default.hpp.do
# ----------------------------------------------------------------------

. ./defs.sh

redo-ifchange Example.cppw
echo '// ======================================================================
// \\name Value.cpp 
// \\author AUTO-GENERATED: DO NOT EDIT
// \\brief Implementation file for Example::Value
// ======================================================================'
awk -f ../scripts/cppw2cpp.awk -v cppfile=Value.cpp Example.cppw

