#send "\r";
expect "#"; send "get system status | grep Version\r";
expect {
	" v5.0"  {
		expect " #"; send "diag test app wad_diskd 3\r";
	}
	" v5.2" {
		expect " #"; send "diag test app wad 2200\r";
		expect "wanopt"; expect "#"; send "diag test app wad 7\r";
		expect {
		" enable"  {expect " #"; send "diag test app wad 7\r";}
		" disable" {send "\r";}
		}
	}
}
expect " #"; send "diag debug app wad -1\r";
expect " #"; send "diag debug enable\r";

