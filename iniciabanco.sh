#! /bin/sh

# chkconfig: 2345 98 02
# description: PostgreSQL RDBMS

# This is an example of a start/stop script for SysV-style init, such
# as is used on Linux systems.  You should edit some of the variables
# and maybe the 'echo' commands.
#
# Place this file at /etc/init.d/postgresql (or
# /etc/rc.d/init.d/postgresql) and make symlinks to
#   /etc/rc.d/rc0.d/K02postgresql
#   /etc/rc.d/rc1.d/K02postgresql
#   /etc/rc.d/rc2.d/K02postgresql
#   /etc/rc.d/rc3.d/S98postgresql
#   /etc/rc.d/rc4.d/S98postgresql
#   /etc/rc.d/rc5.d/S98postgresql
# Or, if you have chkconfig, simply:
# chkconfig --add postgresql
#
# Proper init scripts on Linux systems normally require setting lock
# and pid files under /var/run as well as reacting to network
# settings, so you should treat this with care.

# Original author:  Ryan Kirkpatrick <pgsql@rkirkpat.net>

# contrib/start-scripts/linux

## EDIT FROM HERE

# Installation prefix
prefix=/usr/local

# Data directory
PGDATA="/home/cucafresca/cuca/postgresql/12/data"

# Who to run the postmaster as, usually "postgres".  (NOT "root")
PGUSER=postgres

# Where to keep a log file
PGLOG="$PGDATA/serverlog"

# It's often a good idea to protect the postmaster from being killed by the
# OOM killer (which will tend to preferentially kill the postmaster because
# of the way it accounts for shared memory).  Setting the OOM_SCORE_ADJ value
# to -1000 will disable OOM kill altogether.  If you enable this, you probably
# want to compile PostgreSQL with "-DLINUX_OOM_SCORE_ADJ=0", so that
# individual backends can still be killed by the OOM killer.
#OOM_SCORE_ADJ=-1000
# Older Linux kernels may not have /proc/self/oom_score_adj, but instead
# /proc/self/oom_adj, which works similarly except the disable value is -17.
# For such a system, enable this and compile with "-DLINUX_OOM_ADJ=0".
#OOM_ADJ=-17

## STOP EDITING HERE

# The path that is to be used for the script
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# What to use to start up the postmaster.  (If you want the script to wait
# until the server has started, you could use "pg_ctl start -w" here.
# But without -w, pg_ctl adds no value.)
DAEMON="$prefix/bin/postmaster"

# What to use to shut down the postmaster
PGCTL="$prefix/bin/pg_ctl"

set -e

# Only start if we can find the postmaster.
test -x $DAEMON ||
{
	echo "$DAEMON not found"
	if [ "$1" = "stop" ]
	then exit 0
	else exit 5
	fi
}


# Parse command line parameters.
case $1 in
  start)
	echo -n "Starting PostgreSQL: "
	test x"$OOM_SCORE_ADJ" != x && echo "$OOM_SCORE_ADJ" > /proc/self/oom_score_adj
	test x"$OOM_ADJ" != x && echo "$OOM_ADJ" > /proc/self/oom_adj
	su - $PGUSER -c "$DAEMON -D '$PGDATA' &" >>$PGLOG 2>&1
	echo "ok"
	;;
  stop)
	echo -n "Stopping PostgreSQL: "
	su - $PGUSER -c "$PGCTL stop -D '$PGDATA' -s -m fast"
	echo "ok"
	;;
  restart)
	echo -n "Restarting PostgreSQL: "
	su - $PGUSER -c "$PGCTL stop -D '$PGDATA' -s -m fast -w"
	test x"$OOM_SCORE_ADJ" != x && echo "$OOM_SCORE_ADJ" > /proc/self/oom_score_adj
	test x"$OOM_ADJ" != x && echo "$OOM_ADJ" > /proc/self/oom_adj
	su - $PGUSER -c "$DAEMON -D '$PGDATA' &" >>$PGLOG 2>&1
	echo "ok"
	;;
  reload)
        echo -n "Reload PostgreSQL: "
        su - $PGUSER -c "$PGCTL reload -D '$PGDATA' -s"
        echo "ok"
        ;;
  status)
	su - $PGUSER -c "$PGCTL status -D '$PGDATA'"
	;;
  *)
	# Print help
	echo "Usage: $0 {start|stop|restart|reload|status}" 1>&2
	exit 1
	;;
esac

exit 0
