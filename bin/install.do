#/bin/sh -e

# ----------------------------------------------------------------------
# install.do
# Install redo bin files
# ----------------------------------------------------------------------

. ./defs.sh

vars_require_set INSTALL BINDIR

$INSTALL -d $BINDIR

for file in cppw2hpp.awk cppw2cpp.awk
do
  evald $INSTALL -m 0755 $file $BINDIR/$file
done
