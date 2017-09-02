#!/bin/sh -e

# ----------------------------------------------------------------------
# default.hpp.do
# ----------------------------------------------------------------------

. ./defs.sh

redo-ifchange Example.cppw
awk -f ../scripts/cppw2hpp.awk Example.cppw
