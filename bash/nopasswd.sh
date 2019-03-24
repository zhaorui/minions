#! /usr/bin/expect

# set cmd [lindex $argv 0]
# set e   [lindex $argv 1]
# set p   [lindex $argv 2]
# spawn $cmd
# expect $e
# send $p
# interact

spawn <Enter your ssh command here>
expect "password"
send <Enter your ssh server password here>
interact

# Now copy this script to /usr/local/bin
# You can access to your remote server w/o password now!
