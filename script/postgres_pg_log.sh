#!/bin/sh
# Program :
#	tar log, and clean the log
# History : 2015/10/14		max 	First release
execution_date_start=`date +"%Y-%m-%d %H:%M:%S"`
tar_date_ago=`date +"%Y-%m-%d" -d'-3 day'`
tar_date_ago_ar_start=`date +"%Y-%m-%d" -d'-3 day'`
tar_date_ago_ar_end=`date +"%Y-%m-%d" -d'-2 day'`
echo "execution: ${execution_date_start}"
echo "execution: ${tar_date_ago}"
echo "execution: ${tar_date_ago_ar_start}"
echo "execution: ${tar_date_ago_ar_end}"
echo "step1 tar pg_log"
cd /pg_data/pg_log
tar -zcvf postgres_pg_log_$tar_date_ago.tgz postgresql-$tar_date_ago*.log
rm -rf postgresql-$tar_date_ago*.log
echo "step2 tar ar_log"
cd /pg_data/ar_log
find . ! -name '*.tgz' -newermt "$tar_date_ago_ar_start 00:00:00" ! -newermt "${tar_date_ago_ar_end} 00:00:00" -type f -print0 | xargs -0 tar -zcvf ar_log_$tar_date_ago_ar_start.tgz
find . ! -name '*.tgz' -newermt "$tar_date_ago_ar_start 00:00:00" ! -newermt "${tar_date_ago_ar_end} 00:00:00" -type f -print0 | xargs -0 rm -rf



