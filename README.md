# logger.nvim

`logger.nvim` is a simple runtime logger plugin for Neovim.

## Setup

```lua
require('logger').setup({
  -- the level only can be:
  -- 0 : log debug, info, warn, error messages
  -- 1 : log info, warn, error messages
  -- 2 : log warn, error messages
  -- 3 : log error messages
  level = 0,
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
