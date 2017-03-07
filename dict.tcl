
rename unknown _original_unknown

proc unknown args {
    set argsori $args
    set args [ join $args " " ]
    set cmd [ lindex $args 0 ]
    set args [ lrange $args 1 end ]
    switch $cmd { "objfecha" { uplevel 1 [ return [ objfecha {*}$args ] ] } default { uplevel 1 [list _original_unknown {*}$argsori]} }
}

set fechas [ dict create ]
set cant_fechas 0

proc objfecha {id cmd args } {
  global fechas
  set self "objfecha $id"
  switch $cmd {
    dia: { set d [ lrange [split $args] 0 0]
           dict set fechas $id dia $d
           return $self }
    dia { dict get $fechas $id dia }
    mes { dict get $fechas $id mes }
    ano { dict get $fechas $id ano }
    toStr { return "[$self dia]/[$self mes]/[$self ano]"}
    default { return $self }
  }
}

proc fecha { dia mes ano args} {
  global fechas
  global cant_fechas

  switch $args { "" {set id -1} default { set id [lindex [ join $args " " ] 1 ] } }

  if {$id < 0} {
    set id $cant_fechas
    incr cant_fechas
  }
  dict set fechas $id dia $dia
  dict set fechas $id mes $mes
  dict set fechas $id ano $ano

  return "objfecha $id"
}

set f1 [fecha 1 2 3]
set f2 [fecha 4 5 6]

for {set i 0} {$i < 1000000} {incr i} {
  ##if {[info exists f1]} { set f1 [fecha 1 2 3 "$f1"] } else { set f1 [fecha 1 2 3 ] }
  set f1 [fecha 1 2 3 "$f1"]
  $f2 dia: [expr {[$f1 dia] +90}] ]
}


puts "resultados:"
puts [ $f2 toStr ]

puts [ dict size $fechas ]

puts [ $f1 dia ]
puts [ [ $f2 dia: [$f1 dia] ] toStr]
