oo::class create fecha

oo::define fecha {
    variable vdia
    variable vmes
    variable vano

    constructor {dia mes ano} {
      set vdia $dia
      set vmes $mes
      set vano $ano
    }
    method dia {} {
        return $vdia
    }
    method mes {} {
        return $vmes
    }
    method ano {} {
        return $vano
    }
    method dia: {dia} {
        set vdia $dia
    }
    method toStr {} {
        return "[my dia]/[my mes]/[my ano]"
    }
}

proc main {} {
  set f1 [fecha new 1 2 3]
  set f2 [fecha new 4 5 6]
  
  for {set i 0} {$i < 10} {incr i} {
    set f1 [fecha new 1 2 3]
    $f2 dia: [expr { [$f1 dia] +90}]
  }
  
  puts "$f1"
  puts "resultados:"
  puts [ $f2 toStr]
  
  puts [ $f1 dia ]
  $f2 dia: [ $f1 dia ]
  puts [ $f2 toStr ]
}

main

puts "resultados fuera:"

info body ::oo::Unknown
puts [ ::oo::Obj20 dia ]
puts [ ::oo::Obj21 dia ]
puts [ ::oo::Obj22 dia ]
puts [ ::oo::Obj23 dia ]

