#!/bin/sh

# ----------------------------------------------------------------------
# cpp.sh
# Rules for building C++ files
# ----------------------------------------------------------------------

# Build a .o file from a .cpp file
default_o_do()
{
  redo-ifchange $2.cpp
  gcc -c $2.cpp -o $3
}
