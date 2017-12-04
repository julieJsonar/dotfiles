#!/usr/bin/expect

#If it all goes pear shaped the script will timeout after 20 seconds.

set timeout 20
log_file -noappend log.exp
set argsCount [llength $argv]

if { $argsCount < 0} {
	send "exit\r";
	expect eof;
} elseif { $argsCount == 1 } {
	set host [lindex $argv 0];
	spawn telnet $host
	expect "login:"
	send "admin\r"
	expect "Password:"
	send "admin\r"

} elseif { $argsCount == 3 } {
	set host [lindex $argv 0]
	set user [lindex $argv 1]
	set password [lindex $argv 2]

	spawn telnet $host
	expect "login:"
	send "$user\r"
	expect "Password:"
	send "$password\r"
}

set output [open "log.1" "w"]

send "c g\r"
send "diag wad debug enable level verbose\r"
send "diag wad debug enable cat all\r"
send "diag wad debug display pid enable\r"
send "diag debug console no enable\r"
#send "diag debug console timestamp enable\r"
send "diag debug enable\r"

interact

