#!/usr/bin/tclsh

package require sqlite3
sqlite3 db basefechas.sqlite
#sqlite3 db :memory:

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
    db eval {update fechas set ano=1974 where id=2}
    ##coroutine siguiente lasfechas $id
    ##for {set i 0} {$i < 10} {incr i} {
        ##set d [siguiente]
        ##if {$d!=-1} { puts "received $d" } else { break }
    ##}
    after 10000
    puts ""
    #rename siguiente {}
  }
}

main
