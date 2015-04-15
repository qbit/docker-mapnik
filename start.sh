#!/bin/sh

# Start services
/etc/init.d/supervisord start
service nginx start
service postgresql start
/usr/sbin/sshd -D
