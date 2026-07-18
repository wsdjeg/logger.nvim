# logger.nvim

`logger.nvim` is a simple runtime logger plugin for Neovim.

[![Run Tests](https://github.com/wsdjeg/logger.nvim/actions/workflows/test.yml/badge.svg)](https://github.com/wsdjeg/logger.nvim/actions/workflows/test.yml)
[![GitHub License](https://img.shields.io/github/license/wsdjeg/logger.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/logger.nvim)](https://github.com/wsdjeg/logger.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/logger.nvim)](https://github.com/wsdjeg/logger.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/logger.nvim)](https://github.com/wsdjeg/logger.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/logger.nvim)](https://luarocks.org/modules/wsdjeg/logger.nvim)

<!-- vim-markdown-toc GFM -->

- [Features](#features)
- [Installation](#installation)
- [Setup](#setup)
- [Usage](#usage)
    - [Basic Usage](#basic-usage)
    - [Plugin-specific Logger](#plugin-specific-logger)
    - [File Logging](#file-logging)
    - [Viewing Runtime Log](#viewing-runtime-log)
- [API Reference](#api-reference)
    - [Core Functions](#core-functions)
        - [`setup(options: table)`](#setupoptions-table)
        - [`derive(name: string): Logger`](#derivename-string-logger)
    - [Logging Methods](#logging-methods)
        - [`debug(msg: string)`](#debugmsg-string)
        - [`info(msg: string)`](#infomsg-string)
        - [`warn(msg: string, ...)`](#warnmsg-string-)
        - [`error(msg: string)`](#errormsg-string)
    - [Utility Functions](#utility-functions)
        - [`viewRuntimeLog()`](#viewruntimelog)
        - [`clearRuntimeLog()`](#clearruntimelog)
- [Logging Levels](#logging-levels)
- [Advanced Examples](#advanced-examples)
    - [Complete Plugin Integration](#complete-plugin-integration)
    - [Debugging Workflow with Dynamic Level Control](#debugging-workflow-with-dynamic-level-control)
    - [Multi-plugin Logging System](#multi-plugin-logging-system)
- [Self-Promotion](#self-promotion)
- [License](#license)

<!-- vim-markdown-toc -->

## Features

- **Four log levels**: Debug, Info, Warn, Error
- **Runtime log**: All log messages are stored in memory and can be viewed in a buffer
- **File logging**: Optionally write logs to a file (appended on each write)
- **Plugin-specific loggers**: Create named loggers via `derive()` for each plugin
- **Per-logger level control**: Each derived logger can have its own log level
- **Minimal dependencies**: Works with Neovim's built-in Lua, no external libraries needed

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

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'wsdjeg/logger.nvim',
  config = function()
    require('logger').setup({})
  end,
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'wsdjeg/logger.nvim',
  config = function()
    require('logger').setup({})
  end,
}
```

Using [luarocks](https://luarocks.org):

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
  -- when file is set, log messages are appended to this file
  file = '',        -- e.g. '~/.cache/nvim-log/log.txt'
  -- width of logger name in log output (for alignment)
  width = 12,
})
```

## Usage

### Basic Usage

```lua
local logger = require('logger')

logger.info('this is default log')
```

Output format:

```
[ 22:30:45:123 ] [ Info ] [ logger ] this is default log
```

### Plugin-specific Logger

Create a named logger for your plugin with `derive()`:

```lua
local logger = require('logger').derive('myplugin')

logger.warn('configuration missing')
```

Output:

```
[ 22:30:45:456 ] [ Warn ] [    myplugin ] configuration missing
```

The derived logger can have its own log level, independent of the global level:

```lua
local logger = require('logger').derive('myplugin')
logger.set_level(0) -- debug level for this plugin only
```

### File Logging

When `file` is set in `setup()`, every log message is appended to the file:

```lua
require('logger').setup({
  level = 1,
  file = vim.fn.stdpath('cache') .. '/myplugin.log',
})

require('logger').info('this will be written to the file')
```

Log messages are appended on each write, so the file persists across Neovim sessions. Each line in the file has the same format as the runtime log.

### Viewing Runtime Log

All log messages are stored in memory (runtime log). You can view them at any time:

```lua
require('logger').viewRuntimeLog()
```

This opens a new tab with all accumulated log messages. Press `q` to close.

To clear the runtime log:

```lua
require('logger').clearRuntimeLog()
```

## API Reference

### Core Functions

#### `setup(options: table)`

Initialize the logger with custom configuration.

**Parameters:**
- `options.level` (number, optional): Logging level (0-3), default is `1`
- `options.file` (string, optional): Log file path. When set, log messages are appended to this file
- `options.width` (number, optional): Width of logger name in output for alignment, default is `12`

**Example:**
```lua
require('logger').setup({
  level = 1,
  file = vim.fn.stdpath('cache') .. '/myapp.log',
  width = 20,
})
```

#### `derive(name: string): Logger`

Create a named logger instance for your plugin.

**Parameters:**
- `name` (string): Plugin or module name

**Returns:**
- `Logger` table with `info`, `warn`, `error`, `debug`, and `set_level` methods

**Example:**
```lua
local myLogger = require('logger').derive('treesitter')
myLogger.set_level(0) -- set debug level for this logger only
myLogger.debug('Parsing AST')
```

### Logging Methods

#### `debug(msg: string)`

Log debug-level message (visible when level = 0).

```lua
logger.debug('Variable value: ' .. tostring(value))
```

#### `info(msg: string)`

Log info-level message (visible when level ≤ 1).

```lua
logger.info('Plugin initialized successfully')
```

#### `warn(msg: string, ...)`

Log warning-level message (visible when level ≤ 2).

```lua
logger.warn('Deprecated function called')
```

#### `error(msg: string)`

Log error-level message (always visible).

```lua
logger.error('Failed to load configuration')
```

### Utility Functions

#### `viewRuntimeLog()`

Display the runtime log in a new tab. All accumulated log messages are shown. Press `q` to close the buffer.

```lua
require('logger').viewRuntimeLog()
```

#### `clearRuntimeLog()`

Clear all entries from the in-memory runtime log.

```lua
require('logger').clearRuntimeLog()
```

## Logging Levels

| Level | Value | Logs              |
|-------|-------|-------------------|
| Debug | 0     | debug, info, warn, error |
| Info  | 1     | info, warn, error |
| Warn  | 2     | warn, error       |
| Error | 3     | error             |

**Note:** `error` messages are always logged regardless of the level setting.

## Advanced Examples

### Complete Plugin Integration

```lua
local logger = require('logger').derive('myplugin')

local M = {}

function M.setup()
  logger.info('Plugin setup started')
  
  local success, err = pcall(function()
    -- Initialize components
  end)
  
  if not success then
    logger.error('Setup failed: ' .. err)
    return false
  end
  
  logger.debug('Configuration loaded')
  logger.info('Plugin setup completed successfully')
  return true
end

function M.processData(data)
  logger.debug('Processing data: ' .. #data .. ' bytes')
  
  if #data == 0 then
    logger.warn('Empty data received')
    return nil
  end
  
  -- Processing logic
  logger.info('Data processed successfully')
end

return M
```

### Debugging Workflow with Dynamic Level Control

```lua
local logger = require('logger').derive('debugger')

-- Set to debug level for detailed logging
logger.set_level(0)

function debugFunction()
  logger.debug('Entering debugFunction')
  
  local x = 42
  logger.debug('x = ' .. x)
  
  if x > 10 then
    logger.info('x is greater than 10')
  else
    logger.warn('x is less than or equal to 10')
  end
  
  logger.debug('Exiting debugFunction')
end

-- After debugging, reduce verbosity
logger.set_level(2)
```

### Multi-plugin Logging System

```lua
local mainLogger = require('logger').derive('main')
local dbLogger = require('logger').derive('database')
local uiLogger = require('logger').derive('ui')

function initializePlugin()
  mainLogger.info('Initializing plugin system')
  
  -- Database initialization
  dbLogger.debug('Connecting to database')
  dbLogger.info('Database connection established')
  
  -- UI initialization
  uiLogger.debug('Setting up UI components')
  uiLogger.info('UI initialized successfully')
  
  mainLogger.info('Plugin system ready')
end
```

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## License

This project is licensed under the GPL-3.0 License.

