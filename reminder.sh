#!/bin/bash

# Config
EMAIL=user@example.org

# maybe you do not care to get quotes twice
IGNORE_HISTORY=0

# a quote you want to read everyi day like that i.e. you are a great person
MOTTO="Remember you are a great person ;-) but make sure you tell somebody else today"

# please just use a normal user for this
if [ $(id -u) -eq 0 ]; then
	echo "Please do not use root"
	exit 1
fi

# create tmp file
tmp=$(mktemp)

## files to use
# in this file you have all your quotes
# IMPORTANT: every line needs to start with -
reminder_base=~/daily-reminder.md

# that is what you will get via email including your motto
today_file=~/reminder2.txt
echo -e "${MOTTO}" > ${today_file}

# we do not like to get stuff twice
history_file=~/reminder_history2.txt
touch ${history_file}

# count how many lines we have
max_count=$(cat ${reminder_base} | grep "^-" | sed -e "s/- (.)//g" | wc -l)

# find a quote

# here you can start debugging
#echo "Searching (max ${max_count}) ..."
while true
do
	# I want it randomly
	random_quote=$(cat ${reminder_base} | grep "^-" | sed -e "s/- (.)//g" | shuf -n 1)

	# I had some trouble with double quotes and decided to just hash every quote to work around this 
	quote_md5=$(echo ${random_quote} | md5sum | awk '{print $1}')

	# Check if it is in the history_file and search as long you find a quote that is not in the history_file
	grep -q "${quote_md5}" ${history_file}
	grep_status=$?

	if [ ${grep_status} -eq 0 -a ${IGNORE_HISTORY:-0} -eq 0 ]; then
		echo "Skip (${count:-0}/${max_count}): ${random_quote}"

		count=$[ ${count:-0} + 1 ]
		echo "------ $count"
		if [ ${count} -gt ${max_count} ]; then
			# tell me when I finished and reset the history_file
			echo "We are done, you got all ${max_count} quotes ... or something went wrong ..." | tee -a ${today_file}
			> ${history_file}
			break
		else
			continue
		fi
	else
		# Finally, we have quote, put it in the history_file
		if [ ${IGNORE_HISTORY:-0} -eq 0 ]; then
			echo "${quote_md5};${random_quote}" >> ${history_file}
		fi

		# Make it tidy and put in in the today file
		echo ${random_quote} | sed -s "s/^- //" | tee -a ${today_file}
		break
	fi
done

# cleanup
rm -f ${tmp}

# Send me an email
cat ${today_file} | mail -s "Daily Reminder" ${EMAIL}
