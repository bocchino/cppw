#!/usr/bin/awk -f

# ----------------------------------------------------------------------
# cppw2hpp.awk
# ----------------------------------------------------------------------

# Set the indent spacing
function set_indent_spacing() {
  indent_spacing = $0
  sub(/[^ \t].*/, "", indent_spacing)
  gsub(/\t/, "  ", indent_spacing)
}

BEGIN {
  TEXT = 0
  CPPFILE = 1
  CPP = 2
  FUNCTION = 3
  state = TEXT
  begin = 0
}

$1 == "@GUARD" {
  guard = $2
  gsub(/"/, "", guard)
  print "#ifndef " guard
  print "#define " guard
  next
}

$1 == "@CPPFILE" {
  state = CPPFILE
}

$1 == "@CPP" {
  state = CPP
}

$1 == "@BEGIN" {
  begin = 1
}

$1 == "@END" {
  begin = 0
}

begin == 0 && !($1 ~ /^@/) {
  state = TEXT
}

$1 == "@FUNCTION" {
  state = FUNCTION
  static = 0
  const = 0
  num_args = 0
  return_type = "void"
  set_indent_spacing()
}

$1 == "@NAME" { name = $2 }

$1 == "@RETURN" { return_type = $2  }

$1 == "@ARGUMENT" {
  arg = $0
  sub(/^.*@ARGUMENT */, "", arg)
  args[++num_args] = arg
}

$1 == "@STATIC" { static = 1 }

$1 == "@CONST" { const = 1 }

$1 == "@BEGIN" && state == FUNCTION {
  printf(indent_spacing)
  if (static)
    printf("static ")
  if (num_args == 0)
    printf("%s %s(void)", return_type, name)
  else
    printf("%s %s(\n", return_type, name)
  for (i = 1; i <= num_args; ++i) {
    printf("%s    %s", indent_spacing, args[i])
    if (i < num_args)
      printf(",")
    print ""
  }
  if (num_args > 0)
    printf("%s)", indent_spacing)
  if (const == 1)
    printf(" const")
  print ";"
}

state == TEXT { print }

END {
  if (guard != "") {
    print ""
    print "#endif"
  }
}
