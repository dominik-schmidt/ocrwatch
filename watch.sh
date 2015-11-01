DIR=/volume1/scans

inotifywait -m "$DIR" --format '%w%f' -e create |
	while read file; do
		extension="${file##*.}"
		filename="${file%.*}"
		
		if [ "$extension" == "jpg" ]; then
			echo starting tesseract for $file
			tesseract "$file" "$dir/$filename-ocr" -l deu /usr/local/share/tessdata/configs/pdf
			echo done
		else
			echo ignoring $file: not a JPG image
		fi
	done &
