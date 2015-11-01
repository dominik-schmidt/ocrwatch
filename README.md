# ocrwatch
Shell script that waits for new images in a folder to convert them to searchable PDFs (using tesseract-OCR). Tested on a Synology DS213 NAS only.

Find more details in my [blog post](http://www.dominikschmidt.net/2015/11/scan-and-automatically-ocr-receipts-bills-letters-etc-without-turning-on-your-computer).

## Installation
* copy shell script and python date parser to /usr/local/bin
* configure paths at top of ocrwatch.sh
* create a link to ocrwath.sh in /usr/local/etc/rc.d (to run on startup)

## Usage

` ./ocrwatch.sh start`

` ./ocrwatch.sh stop`
