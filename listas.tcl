set fechas ""
set cant_fechas 0

proc objfecha {id cmd args } {
  global fechas
  set self "objfecha $id"
  set f [string trim [lrange $fechas $id $id] "{}"]
  switch $cmd {
    dia: { set d [ lrange [split $args] 0 0]
           lset fechas $id "$d [eval $self mes] [eval $self ano]"
           return $self }
    dia { return [lrange $f 0 0] }
    mes { return [lrange $f 1 1] }
    ano { return [lrange $f 2 2] }
    toStr { return "[eval $self dia]/[eval $self mes]/[eval $self ano]"}
    default { return $self }
  }
}

proc fecha { dia mes ano args} {
  global fechas
  global cant_fechas

  set args [string trim $args "{}"]
  switch $args { "" {set id -1} default { set id [lrange $args 1 1 ]} }

  if {$id < 0} {
    set id $cant_fechas
    incr cant_fechas
    lappend fechas "$dia $mes $ano"
  } else {
    lset fechas $id "$dia $mes $ano"
  }

  return "objfecha $id"
}

set f1 [fecha 1 2 3]
set f2 [fecha 4 5 6]

for {set i 0} {$i < 1000000} {incr i} {
  if {[info exists f1]} { set f1 [fecha 1 2 3 "$f1"] } else { set f1 [fecha 1 2 3 ] }
  set f2 [eval $f2 dia: [expr {[eval $f1 dia] +90}] ]
}

puts "resultados:"
puts [eval $f2 toStr]

puts [ llength $fechas ]

puts [ eval $f1 dia ]
puts [ eval [ eval $f2 dia: [eval $f1 dia] ] toStr]
