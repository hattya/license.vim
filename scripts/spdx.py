#! /usr/bin/env python3
#
# spdx
#
#   Copyright (c) 2019-2021 Akinori Hattori <hattya@gmail.com>
#
#   SPDX-License-Identifier: MIT
#

import json
import operator
import os
from typing import Dict, Iterator
import urllib.request


def main() -> None:
    datadir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'license')
    if not os.path.exists(datadir):
        os.makedirs(datadir)
    # licenses
    with open(os.path.join(datadir, 'SPDX.licenses'), 'w') as fp:
        fsf_libre = set(load_fsf())
        for v in load_spdx('licenses.json', 'licenseId'):
            fp.write(v['licenseId'])
            if v.get('isDeprecatedLicenseId'):
                fp.write('\tdeprecated')
            if v['licenseId'] in fsf_libre:
                fp.write('\tfsf')
            if v.get('isOsiApproved'):
                fp.write('\tosi')
            fp.write('\n')
    # exceptions
    with open(os.path.join(datadir, 'SPDX.exceptions'), 'w') as fp:
        for v in load_spdx('exceptions.json', 'licenseExceptionId'):
            fp.write(v['licenseExceptionId'])
            if v.get('isDeprecatedLicenseId'):
                fp.write('\tdeprecated')
            fp.write('\n')


def load_spdx(name: str, key: str) -> Iterator[Dict[str, str]]:
    with urllib.request.urlopen('https://spdx.org/licenses/{}'.format(name)) as resp:
        if resp.getcode() == 200:
            yield from sorted(json.load(resp)[os.path.splitext(name)[0]], key=operator.itemgetter(key))


def load_fsf() -> Iterator[str]:
    with urllib.request.urlopen('https://wking.github.io/fsf-api/licenses-full.json') as resp:
        if resp.getcode() == 200:
            for k, v in json.load(resp)['licenses'].items():
                if 'libre' in v['tags']:
                    yield k
                    yield from v.get('identifiers', {}).get('spdx', [])


if __name__ == '__main__':
    main()
