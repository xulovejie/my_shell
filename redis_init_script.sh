#!/bin/sh
#
#Simple Redis init.d script conceived to work on Linux systems
#as it does use of /proc filesystem

REDISPORT=6379
EXEC=/data/redis4/sbin/redis-server
CLIEXEC=/data/redis4/bin/redis-cli

PIDFILE=/var/run/redis_${REDISPORT}.pid
CONF=/etc/redis/${REDISPORT}.conf

case "$1" in
start)
    if [ -f $PIDFILE ];then
        echo "$PIDFILE exists,process is already running or crashed"
    else
        echo "Starting Redis server..."
        $EXEC $CONF
    fi
;;
stop)
    if [ !-f $PIDFILE ];then
        echo "$PIDFILE does not exists,process is not running"
    else
        PID=$(cat $PIDFILE)
        echo "Stopping..."
        $CLIEXEC -p $REDISPORT shutdown

        while [ -x /proc/$PID ]; do
            echo "Waiting for Redis to shutdown..."
            sleep 1
        done
        echo "Redis  stopped"
    fi
;;
*)
    echo "Please use start or stop as first argument"
;;
esac