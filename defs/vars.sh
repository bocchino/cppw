#!/bin/sh -e

# ----------------------------------------------------------------------
# vars.sh
# Variable definitions
# ----------------------------------------------------------------------

# Get the value of a variable
vars_get_value()
{
  if test $# -ne 1
  then
    echoerr 'usage: vars_get_value var'
    exit 1
  fi
  cmd='echo $'$1
  eval $cmd
}

# Require that variables be set
vars_require_set()
{
  for var in $@
  do
    if test -z "`vars_get_value $var`"
    then
      echoerr "error: variable $var not set"
      exit 1
    fi
  done
}

# Display the values of variables
vars_display()
{
  for var in $@
  do
    value=`vars_get_value $var`
    echo "$var=$value"
  done
}
