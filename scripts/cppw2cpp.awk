#!/usr/bin/awk -f

# ----------------------------------------------------------------------
# cppw2cpp.awk
# ----------------------------------------------------------------------

# Count the leading spaces in a line
function count_leading_spaces(line,  leading_spaces) {
  leading_spaces = line
  sub(/[^ \t].*/, "", leading_spaces)
  gsub(/\t/, "  ", leading_spaces)
  return length(leading_spaces)
}

# Get the indent count offset at the current line
function get_indent_count_offset(line,  indent_count_for_line, offset) {
  indent_count_for_line = count_leading_spaces(line)
  if (indent_count_for_line == 0) {
    # If the line started at the left-hand margin, then keep it there in the output
    offset = 0
  }
  else {
    offset = indent_count_for_line - indent_count_at_begin
  }
  return offset
}

# Get the indent count for the current line
function get_indent_count(line,  indent_count_offset, indent_count) {
  indent_count_offset = get_indent_count_offset(line)
  indent_count = desired_indent_count + indent_count_offset
  if (indent_count < 0)
    indent_count = 0
  return indent_count
}

# Print indent spacing
function print_indent_spacing(indent_count,  i) {
  for (i = 1; i <= indent_count; ++i)
    printf(" ")
}

# Print the line content, i.e., everything but leading whitespace
function print_content(line,  content) {
  content = line
  sub(/^[ \t]*/, "", content)
  print content
}

# Print line at current indentation
function print_with_indent(line,  indent_count) {
  indent_count = get_indent_count(line)
  print_indent_spacing(indent_count)
  print_content(line)
}

# Are we in the current cpp file?
function in_current_cppfile() {
  return current_cppfile == "" || current_cppfile == cppfile
}

# Print a function argument
function print_function_arg(arg,  printed_arg) {
  printed_arg = arg
  sub(/ *\/\/.*$/, "", printed_arg)
  printf(printed_arg)
}

# Print a class function prototype
function print_class_function_prototype() {
  print_indent_spacing(desired_indent_count)
  print return_type " " class " ::"
  print_indent_spacing(desired_indent_count + 2)
  printf name
  if (num_args == 0)
    printf("(void)")
  else if (num_args == 1) {
    printf("(")
    print_function_arg(args[1])
    printf ")"
  }
  else {
    printf("(\n")
    for (i = 1; i <= num_args; ++i) {
      print_indent_spacing(desired_indent_count + 6)
      printf(args[i])
      if (i < num_args)
        printf(",")
      print ""
    }
    print_indent_spacing(desired_indent_count + 2)
    printf ")"
  }
  if (const == 1)
    printf " const"
  print ""
  print_with_indent("{")
}

# Print a non-class function prototype
function print_non_class_function_prototype() {
  print_indent_spacing(desired_indent_count)
  if (static)
    printf("static ")
  printf("%s %s", return_type, name)
  if (num_args == 0)
    print "(void) {"
  else if (num_args == 1) {
    printf "("
    print_function_arg(args[1])
    print ") {"
  }
  else {
    printf("(\n")
    for (i = 1; i <= num_args; ++i) {
      print_indent_spacing(desired_indent_count + 4)
      printf(args[i])
      if (i < num_args)
        printf(",")
      print ""
    }
    print_with_indent ") {"
  }
}

BEGIN {
  cpp = 0
  fn = 0
  begin = 0
  desired_indent_count = 0
  indent_count_at_begin = 0
}

$1 == "@CPPFILE" {
  current_cppfile = $2
  gsub(/"/, "", current_cppfile)
}

$1 == "@CPP" {
  cpp = 1
}

$1 == "@END" && fn == 1 && in_current_cppfile() {
  print_with_indent("}")
}

$1 == "@END" {
  begin = 0
  cpp = 0
  fn = 0
}

cpp == 1 && begin == 1 && in_current_cppfile() {
  print
}

fn == 1 && begin == 1 && in_current_cppfile() {
  print_with_indent($0)
}

$1 == "@BEGIN" {
  indent_count_at_begin = count_leading_spaces($0)
}

$1 == "@BEGIN" && fn == 1 && in_current_cppfile() {
  print ""
  if (class != "")
    print_class_function_prototype()
  else
    print_non_class_function_prototype()
}

$1 == "@BEGIN" {
  begin = 1
}

$1 == "namespace" && begin == 0 {
  if (class != "") {
    print "cppw2cpp: namespace inside class at line " NR > "/dev/stderr"
    exit 1
  }
  print ""
  print_with_indent($0)
  desired_indent_count += 2
}

$1 == "class" && begin == 0 {
  if (class == "")
    class = $2
  else
    class = class "::" $2
}

$1 ~ "}" && begin == 0 && class != "" {
  if ($1 != "};") {
    print "cppw2cpp: missing semicolon at end of class in line " NR > "/dev/stderr"
    exit 1
  }
  if (class ~ /::/)
    sub(/::[^:]*$/, "", class)
  else
    class = ""
}

$1 == "}" && begin == 0 && class == "" {
  print ""
  desired_indent_count -= 2
  print_with_indent($0)
}

$1 == "@FUNCTION" {
  fn = 1
  static = 0
  const = 0
  num_args = 0
  return_type = "void"
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
