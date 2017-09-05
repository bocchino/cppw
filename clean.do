#!/bin/sh -e

# ----------------------------------------------------------------------
# clean.do
# ----------------------------------------------------------------------

. ./defs.sh

subdir_targets redo clean
rm_tmp
rm -rf .redo .do_built.dir .do_built
