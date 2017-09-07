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

# Add a comma to an argument
function arg_with_comma(arg,  fields) {
  split(arg, fields, /\/\//)
  sub(/ *$/, "", fields[1])
  if (fields[2] == "")
    return fields[1] ","
  else
    return  fields[1] ", //" fields[2]
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
    if (i < num_args)
      arg = arg_with_comma(args[i])
    else
      arg = args[i]
    printf("%s    %s", indent_spacing, arg)
    print ""
  }
  if (num_args > 0)
    printf("%s)", indent_spacing)
  if (const == 1)
    printf " const"
  if (pure)
    printf " = 0"

}

# Emit a constructor prototype
function emit_constructor_prototype() {
  if (class == "") {
    print "cpp2hpp.awk: constructor outside of class at line " NR > "/dev/stderr"
    exit 1
  }
  name = class
  sub(/^.*::/, "", name)
  printf(indent_spacing)
  if (num_args == 0)
    printf("%s(void)", name)
  else
    printf("%s(\n", name)
  for (i = 1; i <= num_args; ++i) {
    printf("%s    %s", indent_spacing, args[i])
    if (i < num_args)
      printf(",")
    print ""
  }
  if (num_args > 0)
    printf("%s)", indent_spacing)
  print ";"
}

# Emit a destructor prototype
function emit_destructor_prototype() {
  if (class == "") {
    print "cpp2hpp.awk: destructor outside of class at line " NR > "/dev/stderr"
    exit 1
  }
  name = class
  sub(/^.*::/, "", name)
  printf(indent_spacing)
  if (virtual)
    printf "virtual "
  printf("~%s(void);\n", name)
}

BEGIN {
  BOTH = 0
  CONSTRUCTOR = 1
  CPP = 2
  CPPFILE = 3
  DESTRUCTOR = 4
  FUNCTION = 5
  HPP = 6
  state = HPP
  begin = 0
}

($1 == "class" || $1 == "struct") && begin == 0 {
  if (class == "")
    class = $2
  else
    class = class "::" $2
}

/typedef/ && /{/ && class != "" {
  class = class "::TYPE"
}

$1 ~ "}" && begin == 0 && class != "" {
  if (class ~ /::/)
    sub(/::[^:]*$/, "", class)
  else
    class = ""
}

$1 == "namespace" && begin == 0 {
  if (class != "") {
    print "cppw2hpp: namespace inside class at line " NR > "/dev/stderr"
    exit 1
  }
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
  pure = 0
  virtual = 0
  num_args = 0
  return_type = "void"
  set_indent_spacing()
}

$1 == "@CONSTRUCTOR" {
  state = CONSTRUCTOR
  num_args = 0
  set_indent_spacing()
}

$1 == "@DESTRUCTOR" {
  state = DESTRUCTOR
  pure = 0
  virtual = 0
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

$1 == "@PURE" { pure = 1; virtual = 1 }

$1 == "@VIRTUAL" { virtual = 1 }

$1 == "@BEGIN" && state == FUNCTION {
  emit_function_prototype()
  print ";"
}

$1 == "@BEGIN" && state == CONSTRUCTOR {
  emit_constructor_prototype()
}

$1 == "@BEGIN" && state == DESTRUCTOR {
  emit_destructor_prototype()
}

begin == 0 && !($1 ~ /^@/) {
  state = HPP
}

state == HPP { print }

END {
  if (guard != "") {
    print ""
    print "#endif"
  }
}
