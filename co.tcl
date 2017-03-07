#!/usr/bin/tclsh

package require sqlite3
sqlite3 db basefechas.sqlite
#sqlite3 db :memory:

#db eval {pragma synchronous=off}
#db eval {pragma journal_mode=off}

db eval {drop table if exists fechas}
db eval {create table fechas(id integer primary key, dia integer, mes integer, ano integer)}
after 5000
db eval {insert into fechas values (1,8,4,1973)}
db eval {insert into fechas values (2,10,6,1973)}
after 5000
#db eval {begin}
db eval {update fechas set ano=1974 where id=2}
db eval {insert into fechas values (3,31,1,2002)}
db eval {insert into fechas values (4,13,8,2004)}
db eval {insert into fechas values (5,2,1,2007)}

after 5000

#db eval {commit}

proc lasfechas { id } {
    yield
    db eval {select * from fechas where id>=$id} {
      set f [list $id $dia $mes $ano]
      yield $f
    }
    yield -1
}

proc main {} {
  db eval {select * from fechas} {
    puts "$id $dia/$mes/$ano"
    coroutine siguiente lasfechas $id
    for {set i 0} {$i < 10} {incr i} {
        set d [siguiente]
        if {$d!=-1} { puts "received $d" } else { break }
    }
    puts ""
    rename siguiente {}
  }
}

main
