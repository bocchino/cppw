#!/bin/sh

# ----------------------------------------------------------------------
# defs-root.sh
# Root definitions for redo build scripts
# ----------------------------------------------------------------------

# Trap control-C
trap 'exit 1' INT

# Canonicalize a path name
canonicalize()
{
  (cd $1; pwd)
}

# Make echo print escape characters
if test -z "`echo -e`"
then
  alias echo='echo -e'
fi

# Environment variables
export CPPW=`canonicalize $CPPW`
export SCRIPTS=$CPPW/scripts

# Standardize the sort orer across platforms
export LC_ALL=C

# Global configuration
files=`ls $CPPW/defs/*.sh`
for file in $files
do
  . $file
done
