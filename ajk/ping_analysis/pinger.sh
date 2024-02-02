#!/usr/bin/bash

# list of servers to be pinged
SERVERS=(google.com facebook.com kompas.com detik.com)

# loop through the list of servers
for server in $SERVERS
do
    # ping the server and save to file
    ping -4 -D -c 500 -s 256 $server | tee -a $server.log
done
