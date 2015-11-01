#!/usr/bin/env python

import datetime
import fileinput
import re

date_re = re.compile('(?P<day>0?[1-9]|[12][0-9]|3[01])[\.:; ]' +
                     '(?P<month>0?[1-9]|1[0-2])[\.:; ]' +
                     '(?P<year>20[01][0-9])')

for line in fileinput.input():
    match = date_re.search(line)
    if match:
        date_string = '%02d%02d%d' % (int(match.group('day')),
                                      int(match.group('month')),
                                      int(match.group('year')))
        date = datetime.datetime.strptime(date_string, '%d%M%Y')
        print date.strftime('%Y-%M-%d')
        break
