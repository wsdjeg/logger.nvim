# logger.nvim

`logger.nvim` is a simple runtime logger plugin for Neovim.

[![GitHub License](https://img.shields.io/github/license/wsdjeg/logger.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/logger.nvim)](https://github.com/wsdjeg/logger.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/logger.nvim)](https://github.com/wsdjeg/logger.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/logger.nvim)](https://github.com/wsdjeg/logger.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/logger.nvim)](https://luarocks.org/modules/wsdjeg/logger.nvim)

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Setup](#setup)
- [Usage](#usage)
- [Self-Promotion](#self-promotion)
- [License](#license)

<!-- vim-markdown-toc -->

## Installation

Using [nvim-plug](https://github.com/wsdjeg/nvim-plug):

```lua
require('plug').add({
  {
    'wsdjeg/logger.nvim',
    config = function()
      require('logger').setup({})
    end,
  },
})
```

Using [luarocks](https://luarocks.org/)

```
luarocks install logger.nvim
```

## Setup

```lua
require('logger').setup({
  -- the level only can be:
  -- 0 : log debug, info, warn, error messages
  -- 1 : log info, warn, error messages
  -- 2 : log warn, error messages
  -- 3 : log error messages
  level = 0,
  file = '~/.cache/nvim-log/log.txt',
})
```

## Usage

1. Use default logger:

```lua
local logger = require('logger')

logger.info('this is default log')
```

the output of `logger.viewRuntimeLog()`

```
[ logger ] [23:22:50:576] [ Info  ] hello world

```

2. derive a new logger with plugin name:

```lua
local logger = require('logger').derive('name')

logger.info('hello world')
```

the output of `logger.viewRuntimeLog()`

```
[   name ] [23:22:50:576] [ Info  ] hello world

```

3. clear runtime log

```lua
logger.clearRuntimeLog()
```

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## License

This project is licensed under the GPL-3.0 License.
