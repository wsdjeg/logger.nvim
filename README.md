# logger.nvim

Neovim runtime logger

## Setup

```lua
require('logger').setup({
    notify = vim.notify,
})
```

## Usage


```lua
local logger = require('logger').derive('name')

logger.info('hello world')
```

```
[   name ] [23:22:50:576] [ Info  ] hello world

```
