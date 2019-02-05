#!/bin/sh -ex
/sbin/syslogd -O /proc/1/fd/1
# Tried with -W too but doesn't work as expected, process is just killed, it doesn respawn properly
/usr/local/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg -db
