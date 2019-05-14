python-black.el
===============

This is an Emacs package to make it easy to [reformat](https://github.com/purcell/reformatter.el) Python code using [black](https://github.com/python/black), the uncompromising Python code formatter.

As an optional extra, this package can also reformat partial buffers using [black-macchiato](https://github.com/wbolster/black-macchiato), which is a small wrapper around `black` which does just that.

Installation
------------

Install the [python-black Melpa package](https://melpa.org/#/python-black) using `M-x package-install`, or via [use-package](https://github.com/jwiegley/use-package):

``` elisp
(use-package python-black
  :demand t
  :after python)
```

Usage
-----

Use one of these commands via `M-x` or bind them to a key:

- `python-black-buffer`
- `python-black-region` (requires `black-macchiato`)
- `python-black-on-save-mode`

Configuration
-------------

This package deliberately has minimal configuration. Use `M-x customize-group RET python-black` or change these variables in your `init.el`:

- `python-black-command`
- `python-black-macchiato-command`
- `python-black-extra-args`

To configure `black` itself, use an [external configuration file](https://black.readthedocs.io/en/stable/pyproject_toml.html) for your project, which has the benefits that it can be per-project, and works outside Emacs as well.

License
-------

BSD-3-clause. Copyright © 2019 wouter bolsterlee.

Credits
-------

wouter bolsterlee. wbolster.

https://github.com/wbolster on github. star my repos. fork them. and so on.

https://twitter.com/wbolster on twitter. follow me. or say hi.
