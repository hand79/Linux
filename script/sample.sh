#!/bin/sh
# Program :
# tar log, and clean the log
# History :

target_dir=$1
date_format=$2
date_long_ago=$3

if [[ -z "${target_dir}" ]] || [[ -z "${date_format}" ]] || [[ -z "${date_long_ago}" ]];then
	echo "param is empty"
	exit 0
else
	echo "param not empty, OK!"
fi

date_from=`date --date="-${date_long_ago} days" +"${date_format}"`
tar_datename=`echo "${date_from}" |  sed 's/-//g'`
tar_pwd=`echo "${target_dir}" |  sed 's/\/var\/log\/ssnd\///g'`
tar_name="${tar_pwd}_${tar_datename}.tgz"

clean(){
	local tar_name=$1
	local date_from=$2

	if [ -f "$tar_name" ]
	then
		echo "${tar_name} found."
		find *${date_from}* ! -name "*.tgz" -exec rm -f {} +
	else
		echo "${tar_name} not found."
		#find *$date_from* ! -name "*.tgz" -exec echo {} \;

	fi
}

#change dir
cd $target_dir

if [[ $? = 0 ]];then
	echo "change dir = ${target_dir} success!"
else
	echo "Could not change directory! Aborting." 1>&2
	exit 1
fi

#check file count num != 0
fileNum=`ls | grep -c ${date_from}`

if [[ ${fileNum} = 0 ]];then
	echo "no such as file"
	exit 0
else
	echo "have file, to do..."
fi

echo "-------------------------"
echo "target dir: ${target_dir}"
echo "date format: ${date_format}"
echo "date long ago: ${date_long_ago}"
echo "date from: ${date_from}"
echo "tar datename: ${tar_datename}"
echo "tar pwd: ${tar_pwd}"
echo "tar name: ${tar_name}"
echo "fileNum: ${fileNum}"
echo "-------------------------"

if [ -f "${tar_name}" ]
then
	echo "${tar_name} exist."
	exit 0
else
	echo "do tar and clean log"
	tar -zcvf ${tar_name} *$date_from*
	clean ${tar_name} ${date_from}
fi

