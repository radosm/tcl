package require sqlite3
sqlite3 db :memory:

db eval {pragma synchronous=off}
db eval {pragma journal_mode=off}

db eval {create table fechas(id integer primary key, dia integer, mes integer, ano integer)}

set cant_fechas 0

proc objfecha {id cmd args } {
  set self "objfecha $id"
  
  switch $cmd {
    dia: { set d [ lrange [split $args] 0 0]
           db eval {update fechas set dia=$d where id=$id}
           return $self }
  }

  db eval {select dia,mes,ano from fechas where id=$id} {
    switch $cmd {
      dia { return $dia }
      mes { return $mes }
      ano { return $ano }
      toStr { return "[eval $self dia]/[eval $self mes]/[eval $self ano]"}
      default { return $self }
    }
  }
}

proc fecha { dia mes ano args} {
  global cant_fechas

  set args [string trim $args "{}"]
  switch $args { "" {set id -1} default { set id [lrange $args 1 1 ]} }

  if {$id < 0} {
    set id $cant_fechas
    incr cant_fechas
    db eval {insert into fechas (id,dia,mes,ano) values ($id,$dia,$mes,$ano)}
  } else {
    db eval {update fechas set dia=$dia, mes=$mes, ano=$ano where id=$id}
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
puts [ eval $f2 toStr ]

puts [ db eval {select count(*) from fechas} ]

puts [ eval $f1 dia ]
puts [ eval [ eval $f2 dia: [eval $f1 dia] ] toStr]

##db eval {select * from fechas} {
  ##puts "$id $dia $mes $ano"
##}

db close
