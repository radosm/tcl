#!/usr/bin/tclsh

rename unknown _original_unknown

proc unknown args {
    set argsori $args
    set args [ join $args " " ]
    set cmd [ lindex $args 0 ]
    set args [ lrange $args 1 end ]
    switch $cmd { 
      "objfecha"   { uplevel 1 "[ return [ objfecha {*}$args ]]" } 
      "objpersona" { uplevel 1 "[ return [ objpersona {*}$args ]]" } 
      #"objpersona" { uplevel 1 "[ return [ concat objpersona $args ]]" } 
      default { uplevel 1 [list _original_unknown {*}$argsori]} 
    }
}

set fechas [ dict create ]
set cant_fechas 0

set personas [ dict create ]
set cant_personas 0

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
    uplevel 1 "lappend ftmp \"$id\""
  }
  dict set fechas $id dia $dia
  dict set fechas $id mes $mes
  dict set fechas $id ano $ano

  set self "objfecha $id"
  return $self
}


proc objpersona {id cmd args } {
  global personas
  set self "objpersona $id"
  switch $cmd {
    nombre { dict get $personas $id nombre }
    apellido { dict get $personas $id apellido }
    fecha_nacimiento { dict get $personas $id fecha_nacimiento }
    toStr { return "[$self nombre] [$self apellido], nacio el [ [$self fecha_nacimiento] toStr ]" }
    default { return $self }
  }
}

proc persona { nombre apellido fecha_nacimiento args} {
  global personas
  global cant_personas

  switch $args { "" {set id -1} default { set id [lindex [ join $args " " ] 1 ] } }

  if {$id < 0} {
    set id $cant_personas
    incr cant_personas
  }
  dict set personas $id nombre $nombre
  dict set personas $id apellido $apellido
  dict set personas $id fecha_nacimiento $fecha_nacimiento

  set self "objpersona $id"
  uplevel 1 "set ptmp \"$self\""
  return $self
}


proc main {} {
  set p1 [ persona "martin miguel" rados [ fecha 8 4 1973 ] ]
  puts $ftmp
  set p2 [ persona adriana "almeida silva" [ fecha 10 6 1974 ] ]
  puts $ftmp
  set p2 [ persona adriana "almeida silva" [ fecha 10 6 1974 ] "$p2" ]
  puts $ftmp

  puts "[[ fecha 8 9 10 ] toStr]"
  puts $ftmp

  puts "[$p1 nombre ], clase [[$p1 fecha_nacimiento] ano]"
  puts "[$p1 toStr]"
  puts "[$p2 toStr]"

  puts "vars [info vars]"
  puts "level [info level]"
}

main 

puts "despues de main"
puts [dict size $fechas ] ; #ojo
puts [dict size $personas ]
puts "vars [info vars]"
puts "level [info level]"

set ff [fecha 10 10 10]
set ff [fecha 11 11 11]
puts $ftmp

puts "[$ff toStr]"
