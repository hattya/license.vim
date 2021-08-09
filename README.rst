license.vim
===========

license.vim is a Vim plugin to insert a license to the buffer, or replace the
specified range of the buffer by a license.

It can also insert an `SPDX ID`_ to the buffer.

.. image:: https://github.com/hattya/license.vim/actions/workflows/ci.yml/badge.svg
   :target: https://github.com/hattya/license.vim/actions/workflows/ci.yml

.. image:: https://semaphoreci.com/api/v1/hattya/license-vim/branches/master/badge.svg
   :target: https://semaphoreci.com/hattya/license-vim

.. image:: https://ci.appveyor.com/api/projects/status/qwqdt6wm9y03f9ar/branch/master?svg=true
   :target: https://ci.appveyor.com/project/hattya/license-vim

.. image:: https://codecov.io/gh/hattya/license.vim/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/hattya/license.vim

.. image:: https://img.shields.io/badge/powered_by-vital.vim-80273f.svg
   :target: https://github.com/vim-jp/vital.vim

.. image:: https://img.shields.io/badge/doc-:h%20license.txt-blue.svg
   :target: doc/license.txt

.. _SPDX ID: https://spdx.org/ids


Installation
------------

Vundle_

.. code:: vim

   Plugin 'hattya/license.vim'

vim-plug_

.. code:: vim

   Plug 'hattya/license.vim'

dein.vim_

.. code:: vim

   call dein#add('hattya/license.vim')

.. _Vundle: https://github.com/VundleVim/Vundle.vim
.. _vim-plug: https://github.com/junegunn/vim-plug
.. _dein.vim: https://github.com/Shougo/dein.vim


Requirements
------------

- Vim 8.0+


Usage
-----

.. code:: vim

   License MIT

or

.. code:: vim

   SPDXLicense MIT


Testing
-------

license.vim uses themis.vim_ for testing.

.. code:: console

   $ cd /path/to/license.vim
   $ git clone https://github.com/thinca/vim-themis
   $ ./vim-themis/bin/themis

.. _themis.vim: https://github.com/thinca/vim-themis


License
-------

license.vim is distributed under the terms of the MIT License.
