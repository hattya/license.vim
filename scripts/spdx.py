#! /usr/bin/env python
#
# spdx
#
#   Copyright (c) 2019 Akinori Hattori <hattya@gmail.com>
#
#   SPDX-License-Identifier: MIT
#

import json
import operator
import os
try:
    from urllib.request import urlopen
except ImportError:
    from urllib2 import urlopen


def main():
    datadir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'license')
    if not os.path.exists(datadir):
        os.makedirs(datadir)
    # licenses
    with open(os.path.join(datadir, 'SPDX.licenses'), 'w') as fp:
        for v in load('licenses.json', 'licenseId'):
            fp.write(v['licenseId'])
            if v.get('isDeprecatedLicenseId'):
                fp.write('\tdeprecated')
            if v.get('isFsfLibre'):
                fp.write('\tfsf')
            if v.get('isOsiApproved'):
                fp.write('\tosi')
            fp.write('\n')
    # exceptions
    with open(os.path.join(datadir, 'SPDX.exceptions'), 'w') as fp:
        for v in load('exceptions.json', 'licenseExceptionId'):
            fp.write(v['licenseExceptionId'])
            if v.get('isDeprecatedLicenseId'):
                fp.write('\tdeprecated')
            fp.write('\n')


def load(name, key):
    resp = urlopen('https://spdx.org/licenses/{}'.format(name))
    if resp.getcode() == 200:
        for v in sorted(json.load(resp)[os.path.splitext(name)[0]], key=operator.itemgetter(key)):
            yield v


if __name__ == '__main__':
    main()
