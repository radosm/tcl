#!/usr/bin/tclsh

proc juggler {name target {value ""}} {
    if {$value eq ""} {
        set value [yield [info coroutine]]
    }
    while {$value ne ""} {
        puts "$name : $value"
        set value [string range $value 0 end-1]
        lassign [yieldto $target $value] value
    }
}
coroutine j1 juggler Larry [
    coroutine j2 juggler Curly [
        coroutine j3 juggler Moe j1]] "Nyuck!Nyuck!Nyuck!"
