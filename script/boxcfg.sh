#!/usr/bin/expect

if { $argc < 2 } {
	puts "Usage: script 123 cfg ['+prefix'(only patch)]<cr> enter interact mode"
	puts "Usage: script 'telnet 192.168.1.123' cfg user passwd<cr> over and exit"
	puts "sample: boxcfg.sh 123 wad-tunnel-manual.cli '+test'"
	exit 1
}

# get config file
set cmdfile [lindex $argv 1]

# get patch prefix
set prefixcfg ""
if { $argc > 2 } {
	set prefixcfg [lindex $argv 2]
	set prefixcfg [string trim $prefixcfg]
}
set prefixcfglen [string length $prefixcfg]


if { [file exists $file_name] == 1} {
}

# Get the commands to run, one per line
set f [open "$cmdfile"]
set commands [split [read $f] "\n"]
close $f

set overexit 0
set box [lindex $argv 0]
set user "admin"
set passwd ""
if { [llength $box] <= 3 } {
	set box "172.16.80.$box"
} else {
	if { $argc < 4 } {
		puts "Usage: script 'telnet 192.168.1.123' cfg user passwd<cr> over and exit"
		exit 1
	}

	set overexit 1
	set user [lindex $argv 2]
	set passwd [lindex $argv 3]
}

if { [llength $box] <= 3 } {
	spawn /bin/sh -c "plink -telnet 172.16.80.$box | tee ~/tmp/log.$box"
} else {
	spawn /bin/sh -c "$box"
}

expect "login:"; send "$user\r";
expect -nocase "password:"; send "passwd\r";

# throw away all output Expect has seen so far
set timeout 1
send "\r"
set count 1;
while {$count > 0 } {
	expect {
	timeout {break}
	"#" {}
	}
}

set timeout 6
set lastiscomment 0
# Iterate over the hosts
foreach cmd $commands {
	set cmd [string trim $cmd]
	set length [string length $cmd]
	if {$length == 0} {
		continue;
	} elseif {[string equal -length 1 $cmd "#"] == 1} {  # comments
		set cmd [string trim $cmd "#"]
		set length [string length $cmd]
		if {$length > 0} {
			if {$lastiscomment == 0} {
				send_user "\n"
			}
			send_user "Comment:$cmd\n"
			set lastiscomment 1
		}
		continue
	} elseif {$prefixcfglen > 0} { # patch mode
		if {[string equal -length $prefixcfglen $cmd $prefixcfg] == 1} { # match patch
			set cmd [string trimleft $cmd $prefixcfg]
		} else { # if patch mode, skip all others
			continue
		}
	}

	set lastiscomment 0
	# trim and execute
	set cmd [string trim $cmd]
	set length [string length $cmd]
	if {$length == 0} {
		continue
	}
	send "$cmd\r"
	expect {
	timeout { send_user "\nTimeout, failed to continue.\n"; exit 1}
	eof { send_user "\nRemote disconnect, execute command failed.\n"; exit 1}
	" #" {
	}
	" (y/n)" {
		send "y"
		expect {
		" #" {
		}
		" (y/n)" {
			send "y"
		}
		}
	}
	}
}

## reponse info to user
#if {$prefixcfglen == 0} {
#	send_user "\n============================="
#	send_user "\n=++++++ config mode ========="
#	send_user "\n=============================\n"
#} else {
#	send_user "\n============================="
#	send_user "\n=++++++patch mode '$prefixcfg'===="
#	send_user "\n=============================\n"
#}

if {$overexit == 1} {
	send "exit\r"
	exit 0	# exit 0 to shell
} else {
	interact
}

