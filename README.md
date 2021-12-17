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
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim))
```

Usage
-----

Use one of these commands via `M-x` or bind them to a key:

- `python-black-on-save-mode`

  Minor mode to automatically reformat the buffer on save.

- `python-black-on-save-mode-enable-dwim`

  Enable `python-black-on-save-mode` if this project is using Black. (Useful in hooks; see example above.)

- `python-black-buffer`

  Reformat the current buffer.

- `python-black-region`

  Reformat the current region. (Requires `black-macchiato`.)

- `python-black-statement`

  Reformat the current statement. (Requires `black-macchiato`.)

- `python-black-partial-dwim`

  Reformat the active region or the current statement, depending on whether the region is currently active. (Requires `black-macchiato`.)

Configuration
-------------

This package deliberately has minimal configuration. Use `M-x customize-group RET python-black` or change these variables in your `init.el`:

- `python-black-command`
- `python-black-macchiato-command`
- `python-black-extra-args`

To configure `black` itself, use an [external configuration file](https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file) for your project, which has the benefits that it can be per-project, and works outside Emacs as well.

History
-------

- next release (already available via melpa unstable)

  - `python-black-on-save-mode-enable-dwim` now ignores files in
    `site-packages/` directories

- 1.1.0 (2021-05-11)

  - Add `python-black-on-save-mode-enable-dwim` for use in hooks
  - Don't break when there's no newline at the end of the buffer (#4)

- 1.0.0 (2019-08-17)

  - Initial release

License
-------

BSD-3-clause. Copyright © 2019 wouter bolsterlee.

Credits
-------

wouter bolsterlee. wbolster.

https://github.com/wbolster on github. star my repos. fork them. and so on.

https://twitter.com/wbolster on twitter. follow me. or say hi.
