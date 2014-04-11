#!/usr/bin/expect -f
if { $argc < 1 } {
	puts "Usage: command 123";
	exit
}
set box [lindex $argv 0]
if { [llength $box] <= 3 } {
	spawn /bin/sh -c "plink -telnet 172.16.80.$box | tee ~/tmp/log.$box"
} else {
	spawn /bin/sh -c "plink -telnet $box | tee ~/tmp/log.$box"
}
expect "login:"; send "admin\r";
expect "Password:"; send "\r";
send "\r"

