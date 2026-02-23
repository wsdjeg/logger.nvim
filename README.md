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
    - [Basic Usage](#basic-usage)
    - [Plugin-specific Logger](#plugin-specific-logger)
- [API Reference](#api-reference)
    - [Core Functions](#core-functions)
        - [`setup(options: table)`](#setupoptions-table)
        - [`derive(name: string): Logger`](#derivename-string-logger)
    - [Logging Methods](#logging-methods)
        - [`debug(msg: string)`](#debugmsg-string)
        - [`info(msg: string)`](#infomsg-string)
        - [`warn(msg: string, silent?: boolean)`](#warnmsg-string-silent-boolean)
        - [`error(msg: string)`](#errormsg-string)
    - [Advanced Functions](#advanced-functions)
        - [`set_level(level: number)`](#set_levellevel-number)
        - [`set_silent(silent: boolean)`](#set_silentsilent-boolean)
        - [`get_name(): string`](#get_name-string)
        - [`set_name(name: string)`](#set_namename-string)
    - [Utility Functions](#utility-functions)
        - [`clearRuntimeLog()`](#clearruntimelog)
        - [`viewRuntimeLog()`](#viewruntimelog)
- [Advanced Examples](#advanced-examples)
    - [Complete Plugin Integration](#complete-plugin-integration)
    - [Debugging Workflow with Dynamic Level Control](#debugging-workflow-with-dynamic-level-control)
    - [Error Handling with Silent Mode](#error-handling-with-silent-mode)
    - [Multi-plugin Logging System](#multi-plugin-logging-system)
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
  width = 12, -- width of logger name in log output
})
```

## Usage

### Basic Usage

```lua
local logger = require('logger')

logger.info('this is default log')
```

### Plugin-specific Logger

```lua
local logger = require('logger').derive('myplugin')

logger.warn('configuration missing')
```

## API Reference

### Core Functions

#### `setup(options: table)`

Initialize the logger with custom configuration.

**Parameters:**
- `options.level` (number, optional): Logging level (0-3)
- `options.file` (string, optional): Log file path
- `options.width` (number, optional): Width of logger name in output

**Example:**
```lua
require('logger').setup({
  level = 1,
  file = '~/.cache/myapp/log.txt',
  width = 20
})
```

#### `derive(name: string): Logger`

Create a named logger instance for your plugin.

**Parameters:**
- `name` (string): Plugin or module name

**Returns:**
- `Logger` instance with plugin-specific context

**Example:**
```lua
local myLogger = require('logger').derive('treesitter')
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

#### `warn(msg: string, silent?: boolean)`

Log warning-level message (visible when level ≤ 2).

```lua
logger.warn('Deprecated function called')
```

#### `error(msg: string)`

Log error-level message (always visible).

```lua
logger.error('Failed to load configuration')
```

### Advanced Functions

#### `set_level(level: number)`

Dynamically change logging level.

```lua
logger.set_level(2) -- Only show warnings and errors
```

#### `set_silent(silent: boolean)`

Control silent mode for logging.

```lua
logger.set_silent(true) -- Enable silent mode
```

#### `get_name(): string`

Get current logger name.

```lua
local name = logger.get_name()
```

#### `set_name(name: string)`

Set current logger name.

```lua
logger.set_name('newname')
```

### Utility Functions

#### `clearRuntimeLog()`

Clear all entries from the runtime log file.

```lua
require('logger').clearRuntimeLog()
```

#### `viewRuntimeLog()`

Display the runtime log in a new buffer with syntax highlighting.

```lua
require('logger').viewRuntimeLog()
```

## Advanced Examples

### Complete Plugin Integration

```lua
local logger = require('logger').derive('myplugin')

local M = {}

function M.setup()
  logger.info('Plugin setup started')
  
  -- Plugin initialization logic
  local success, err = pcall(function()
    -- Initialize components
  end)
  
  if not success then
    logger.error('Setup failed: ' .. err)
    return false
  end
  
  logger.debug('Configuration loaded: ' .. vim.inspect(config))
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

### Error Handling with Silent Mode

```lua
local logger = require('logger').derive('errorhandler')

function safeOperation()
  -- Temporarily enable silent mode for clean output
  local wasSilent = logger.silent
  logger.set_silent(true)
  
  local success, result = pcall(dangerousFunction)
  
  -- Restore original state
  logger.set_silent(wasSilent)
  
  if success then
    logger.info('Operation completed: ' .. result)
    return result
  else
    logger.error('Operation failed: ' .. result)
    -- Additional error handling
  end
end
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
  -- ... database logic
  dbLogger.info('Database connection established')
  
  -- UI initialization
  uiLogger.debug('Setting up UI components')
  -- ... UI logic
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
