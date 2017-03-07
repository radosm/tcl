# Save the original one so we can chain to it
rename unknown _original_unknown

# Provide our own implementation
proc unknown args {
    #puts $args
    #puts "[list _original_unknown {*}$args ]"
    #puts "[concat _original_unknown $args ]"
    set args [ join $args " " ]
    puts stderr "WARNING: unknown command: [ lindex $args 0 ]"
    puts [ lrange $args 1 end ]
    #uplevel 1 [list _original_unknown {*}$args]
    uplevel 1 [concat _original_unknown $args ]
}

koko kiko kuku
