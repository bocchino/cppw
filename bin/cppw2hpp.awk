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

# Emit a function prototype
function emit_function_prototype() {
  printf(indent_spacing)
  if (static)
    printf("static ")
  if (virtual)
    printf("virtual ")
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
}

BEGIN {
  BOTH = 0
  CPP = 1
  CPPFILE = 2
  FUNCTION = 3
  HPP = 4
  state = HPP
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

$1 == "@BOTH" {
  state = BOTH
}

$1 == "@END" {
  begin = 0
  state = HPP
  next
}

state == BOTH && begin == 1 { print }

$1 == "@BEGIN" {
  begin = 1
}

$1 == "@FUNCTION" {
  state = FUNCTION
  static = 0
  const = 0
  virtual = 0
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

$1 == "@VIRTUAL" { virtual = 1 }

$1 == "@BEGIN" && state == FUNCTION {
  emit_function_prototype()
  print ";"
}

begin == 0 && !($1 ~ /^@/) {
  if (state == FUNCTION) {
    print $0 > "/dev/stderr"
    # Pure virtual function
    emit_function_prototype()
    print " = 0;"
  }
  state = HPP
}

state == HPP { print }

END {
  if (guard != "") {
    print ""
    print "#endif"
  }
}
