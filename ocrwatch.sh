#!/bin/sh

# TODOS
# * set folder for extract_date.py 
# * prefix date (for this, split FILENAME into path and filename)
# * delete text file?

WATCH_DIR=/volume1/scans
PID_FILE=/var/run/ocrwatch.pid
LOG_FILE=/var/log/ocrwatch.log

case "$1" in
start)
	if [ -f "$PID_FILE" ]; then
		echo "$(date): $0 is already running ($PID_FILE exists)"
		exit 1
	fi

	echo $(date): $0 started
	(inotifywait -m "$WATCH_DIR" --format '%w%f' -e create & echo "$!" > "$PID_FILE") | \
		while read FILE; do
			EXTENSION="${FILE##*.}"
			FILENAME="${FILE%.*}"
		
			if [ "$EXTENSION" == "jpg" ]; then
				echo $(date): "starting tesseract for $FILE, output to $FILENAME-ocr"
				tesseract "$FILE" "$FILENAME-ocr" -l deu /usr/local/share/tessdata/configs/pdf >> "$LOG_FILE" 2>&1
				echo $(date): "done processing $FILE"

				echo $(date): "extracting date for $FILENAME-ocr.txt"
				DOC_DATE=$(/opt/bin/python /usr/local/bin/extract_date.py < "$FILENAME-ocr.txt")
				if [ -z $DOC_DATE ]; then
					DOC_DATE="NO_DATE"	
				fi
				echo $(date): "date is $DOC_DATE"
				mv "$FILENAME-ocr.pdf" "$FILENAME-ocr-$DOC_DATE.pdf"
			else
				echo $(date): "ignoring $FILE: not a JPG image"
			fi
		done >> "$LOG_FILE" 2>&1 &
	echo "$0 started"
	;;
stop)
	if [ -f "$PID_FILE" ]; then
		kill $(cat "$PID_FILE")
		rm "$PID_FILE"
		echo $(date): $0 stopped
	else
		echo $(date): $0 is not running
		exit 1
	fi
	;;
esac

exit 0
