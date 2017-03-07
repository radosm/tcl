proc vartrace2 {oldval varname element op} {
  upvar $varname localvar
  puts "op=$op"
  puts "oldval=$oldval"
  puts "chau"
}

proc vartrace3 {oldval varname element op} {
  puts "leida la variable $varname"
}

proc vartrace {oldval varname element op} {
    upvar $varname localvar
    puts "element=$element"
    set localvar $oldval
}

proc main {} {
  uplevel {set koko hola}
  set tracedvar 1
  trace add variable tracedvar write [list vartrace $tracedvar]
  trace add variable tracedvar unset [list vartrace2 $tracedvar]
  trace add variable tracedvar read [list vartrace3 $tracedvar]
  

  set tracedvar 2
  puts "tracedvar is $tracedvar"
}

main
puts [info vars]

set b [list a b {c d e} {f {g h}}]
puts "Treated as a list: $b\n"

set b [split "a b {c d e} {f {g h}}"]
puts "Transformed by split: $b\n"

set a [concat a b {c d e} {f {g h}}]
puts "Concated: $a\n"

lappend a {ij K lm}                        ;# Note: {ij K lm} is a single element
puts "After lappending: $a\n"

set b [linsert $a 3 "1 2 3"]               ;# "1 2 3" is a single element
puts "After linsert at position 3: $b\n"

set b [lreplace $b 3 5 "AA" "BB"]
puts "After lreplacing 3 positions with 2 values at position 3: $b\n"
