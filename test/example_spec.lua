-- test/example_spec.lua
-- Example test file for logger.nvim

local lu = require('luaunit')
local logger = require('logger')
local base = require('logger.base')

TestLoggerSetup = {}

function TestLoggerSetup:setUp()
  -- Reset to default state before each test
  base.set_level(1)
  base.set_name('logger')
  base.clear()
end

function TestLoggerSetup:tearDown()
  base.clear()
end

function TestLoggerSetup:test_setup_sets_level()
  require('logger').setup({ level = 2 })
  lu.assertEquals(base.level, 2)
end

function TestLoggerSetup:test_setup_sets_file()
  require('logger').setup({ file = '/tmp/test.log' })
  lu.assertEquals(base.file, '/tmp/test.log')
end

TestLoggerLevels = {}

function TestLoggerLevels:setUp()
  base.set_level(0) -- Debug: log everything
  base.set_name('logger')
  base.clear()
end

function TestLoggerLevels:tearDown()
  base.clear()
end

function TestLoggerLevels:test_info_logging()
  logger.info('test info message')
  local logs = base.view_all()
  lu.assertTrue(logs:find('test info message') ~= nil)
  lu.assertTrue(logs:find('Info') ~= nil)
end

function TestLoggerLevels:test_warn_logging()
  logger.warn('test warn message')
  local logs = base.view_all()
  lu.assertTrue(logs:find('test warn message') ~= nil)
  lu.assertTrue(logs:find('Warn') ~= nil)
end

function TestLoggerLevels:test_error_logging()
  logger.error('test error message')
  local logs = base.view_all()
  lu.assertTrue(logs:find('test error message') ~= nil)
  lu.assertTrue(logs:find('Error') ~= nil)
end

function TestLoggerLevels:test_debug_logging()
  logger.debug('test debug message')
  local logs = base.view_all()
  lu.assertTrue(logs:find('test debug message') ~= nil)
  lu.assertTrue(logs:find('Debug') ~= nil)
end

TestLoggerLevelFiltering = {}

function TestLoggerLevelFiltering:setUp()
  base.set_name('logger')
  base.clear()
end

function TestLoggerLevelFiltering:tearDown()
  base.clear()
  base.set_level(1) -- Reset to default
end

function TestLoggerLevelFiltering:test_level_1_filters_debug()
  base.set_level(1)
  logger.debug('should not appear')
  local logs = base.view_all()
  lu.assertTrue(logs:find('should not appear') == nil)
end

function TestLoggerLevelFiltering:test_level_2_filters_info()
  base.set_level(2)
  logger.info('should not appear')
  local logs = base.view_all()
  lu.assertTrue(logs:find('should not appear') == nil)
end

function TestLoggerLevelFiltering:test_level_3_filters_warn()
  base.set_level(3)
  logger.warn('should not appear')
  local logs = base.view_all()
  lu.assertTrue(logs:find('should not appear') == nil)
end

function TestLoggerLevelFiltering:test_error_always_logged()
  base.set_level(3)
  logger.error('should appear')
  local logs = base.view_all()
  lu.assertTrue(logs:find('should appear') ~= nil)
end

TestLoggerDerive = {}

function TestLoggerDerive:setUp()
  base.set_level(0)
  base.set_name('logger')
  base.clear()
end

function TestLoggerDerive:tearDown()
  base.clear()
end

function TestLoggerDerive:test_derive_returns_table()
  local derived = logger.derive('myplugin')
  lu.assertNotNil(derived)
  lu.assertEquals(type(derived.info), 'function')
  lu.assertEquals(type(derived.warn), 'function')
  lu.assertEquals(type(derived.error), 'function')
  lu.assertEquals(type(derived.debug), 'function')
end

function TestLoggerDerive:test_derive_info_logging()
  local derived = logger.derive('myplugin')
  derived.info('derived info')
  local logs = base.view_all()
  lu.assertTrue(logs:find('derived info') ~= nil)
  lu.assertTrue(logs:find('myplugin') ~= nil)
end

TestLoggerClearRuntimeLog = {}

function TestLoggerClearRuntimeLog:setUp()
  base.set_level(0)
  base.set_name('logger')
end

function TestLoggerClearRuntimeLog:tearDown()
  base.clear()
end

function TestLoggerClearRuntimeLog:test_clear_runtime_log()
  logger.info('message before clear')
  base.clear()
  local logs = base.view_all()
  lu.assertEquals(logs, '')
end

return TestLoggerSetup

