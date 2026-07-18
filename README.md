# logger.nvim

`logger.nvim` is a simple runtime logger plugin for Neovim.
It provides four log levels, in-memory runtime log storage,
optional file logging, and per-plugin derived loggers.

[![Run Tests](https://github.com/wsdjeg/logger.nvim/actions/workflows/test.yml/badge.svg)](https://github.com/wsdjeg/logger.nvim/actions/workflows/test.yml)
[![GitHub License](https://img.shields.io/github/license/wsdjeg/logger.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/logger.nvim)](https://github.com/wsdjeg/logger.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/logger.nvim)](https://github.com/wsdjeg/logger.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/logger.nvim)](https://github.com/wsdjeg/logger.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/logger.nvim)](https://luarocks.org/modules/wsdjeg/logger.nvim)

<!-- vim-markdown-toc GFM -->

- [✨ Features](#-features)
- [📦 Installation](#-installation)
- [🔧 Configuration](#-configuration)
- [⚙️ Basic Usage](#️-basic-usage)
- [🔌 Derived Logger](#-derived-logger)
- [📝 File Logging](#-file-logging)
- [👁️ View Runtime Log](#️-view-runtime-log)
- [📚 API](#-api)
    - [setup(opts)](#setupopts)
    - [info(msg)](#infomsg)
    - [warn(msg)](#warnmsg)
    - [error(msg)](#errormsg)
    - [debug(msg)](#debugmsg)
    - [derive(name)](#derivename)
    - [viewRuntimeLog()](#viewruntimelog)
    - [clearRuntimeLog()](#clearruntimelog)
- [📊 Logging Levels](#-logging-levels)
- [📣 Self-Promotion](#-self-promotion)
- [📄 License](#-license)

<!-- /vim-markdown-toc -->

## ✨ Features

- Four log levels: Debug, Info, Warn, Error
- Runtime log stored in memory, viewable in a buffer
- Optional file logging with append mode
- Per-plugin derived loggers with independent level control
- Minimal dependencies — uses only Neovim's built-in Lua

## 📦 Installation

logger.nvim works with all major Neovim plugin managers.

- **Using [nvim-plug](https://github.com/wsdjeg/nvim-plug)**

  ```lua
  require('plug').add({
    {
      'wsdjeg/logger.nvim',
      config = function()
        require('logger').setup()
      end,
    },
  })
  ```

- **Using [lazy.nvim](https://github.com/folke/lazy.nvim)**

  ```lua
  {
    'wsdjeg/logger.nvim',
    config = function()
      require('logger').setup()
    end,
  }
  ```

- **Using [packer.nvim](https://github.com/wbthomason/packer.nvim)**

  ```lua
  use({
    'wsdjeg/logger.nvim',
    config = function()
      require('logger').setup()
    end,
  })
  ```

- **Using [luarocks](https://luarocks.org)**

  ```
  luarocks install logger.nvim
  ```

## 🔧 Configuration

```lua
require('logger').setup({
  level = 1,  -- 0:debug 1:info 2:warn 3:error (default: 1)
  file = '',  -- log file path, empty = runtime only (default: '')
})
```

## ⚙️ Basic Usage

```lua
local logger = require('logger')

logger.info('plugin initialized')
logger.warn('deprecated API called')
logger.error('failed to load config')
logger.debug('internal state: ' .. tostring(state))
```

Output format:

```
[ 22:30:45:123 ] [  Info ] [ logger ] plugin initialized
[ 22:30:45:124 ] [  Warn ] [ logger ] deprecated API called
[ 22:30:45:125 ] [ Error ] [ logger ] failed to load config
[ 22:30:45:126 ] [ Debug ] [ logger ] internal state: nil
```

## 🔌 Derived Logger

Create a named logger for your plugin with `derive()`:

```lua
local logger = require('logger').derive('myplugin')

logger.info('starting up')
logger.set_level(0)  -- debug level for this plugin only
```

The derived logger name is right-aligned to 12 characters:

```
[ 22:30:45:123 ] [  Info ] [    myplugin ] starting up
```

Each derived logger has its own `set_level`, independent of the global level.

## 📝 File Logging

When `file` is set in `setup()`, every log message is appended to the file:

```lua
require('logger').setup({
  level = 1,
  file = vim.fn.stdpath('cache') .. '/myplugin.log',
})

require('logger').info('this will be written to the file')
```

Each line in the file has the same format as the runtime log.
Messages are appended on each write, so the file persists across sessions.

## 👁️ View Runtime Log

All log messages are stored in memory. View them at any time:

```lua
require('logger').viewRuntimeLog()
```

Opens a new tab showing all accumulated logs. Press `q` to close.

To clear the runtime log:

```lua
require('logger').clearRuntimeLog()
```

## 📚 API

| function | description |
| -------- | ----------- |
| `setup(opts)` | Initialize with `level` and `file` options |
| `info(msg)` | Log info-level message |
| `warn(msg)` | Log warning-level message |
| `error(msg)` | Log error-level message |
| `debug(msg)` | Log debug-level message |
| `derive(name)` | Create plugin-specific logger |
| `viewRuntimeLog()` | View runtime log in a new tab |
| `clearRuntimeLog()` | Clear in-memory runtime log |

### setup(opts)

Initialize the logger with custom configuration.

| option | type | default | description |
| ------ | ---- | ------- | ----------- |
| `level` | `0\|1\|2\|3` | `1` | Logging level |
| `file` | `string` | `''` | Log file path, empty for runtime only |

```lua
require('logger').setup({
  level = 1,
  file = vim.fn.stdpath('cache') .. '/myapp.log',
})
```

### info(msg)

Log info-level message (visible when level ≤ 1).

```lua
logger.info('Plugin initialized successfully')
```

### warn(msg)

Log warning-level message (visible when level ≤ 2).

```lua
logger.warn('Deprecated function called')
```

### error(msg)

Log error-level message. Always logged regardless of level.

```lua
logger.error('Failed to load configuration')
```

### debug(msg)

Log debug-level message (visible when level = 0).

```lua
logger.debug('Variable value: ' .. tostring(value))
```

### derive(name)

Create a named logger instance for your plugin.

Returns a table with `info`, `warn`, `error`, `debug`, and `set_level` methods.

```lua
local myLogger = require('logger').derive('treesitter')
myLogger.set_level(0)  -- debug level for this logger only
myLogger.debug('Parsing AST')
```

### viewRuntimeLog()

Display the runtime log in a new tab. Press `q` to close the buffer.

```lua
require('logger').viewRuntimeLog()
```

### clearRuntimeLog()

Clear all entries from the in-memory runtime log.

```lua
require('logger').clearRuntimeLog()
```

## 📊 Logging Levels

| Level | Value | Logs |
| ----- | ----- | ---- |
| Debug | 0 | debug, info, warn, error |
| Info | 1 | info, warn, error |
| Warn | 2 | warn, error |
| Error | 3 | error |

`error` messages are always logged regardless of the level setting.

## 📣 Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## 📄 License

This project is licensed under the GPL-3.0 License.

