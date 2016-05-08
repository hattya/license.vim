license.vim
===========

license.vim is a Vim plugin to insert a license to the buffer, or replace the
specified range of the buffer by a license.

.. image:: https://drone.io/github.com/hattya/license.vim/status.png
   :target: https://drone.io/github.com/hattya/license.vim/latest

.. image:: https://ci.appveyor.com/api/projects/status/qwqdt6wm9y03f9ar?svg=true
   :target: https://ci.appveyor.com/project/hattya/license-vim

.. image:: https://img.shields.io/badge/powered_by-vital.vim-80273f.svg
   :target: https://github.com/vim-jp/vital.vim


Installation
------------

pathogen.vim_

.. code:: console

   $ cd ~/.vim/bundle
   $ git clone https://github.com/hattya/license.vim

Vundle_

.. code:: vim

   Plugin 'hattya/license.vim'

NeoBundle_

.. code:: vim

   NeoBundle 'hattya/license.vim'

vim-plug_

.. code:: vim

   Plug 'hattya/license.vim'

.. _pathogen.vim: https://github.com/tpope/vim-pathogen
.. _Vundle: https://github.com/VundleVim/Vundle.vim
.. _NeoBundle: https://github.com/Shougo/neobundle.vim
.. _vim-plug: https://github.com/junegunn/vim-plug


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
