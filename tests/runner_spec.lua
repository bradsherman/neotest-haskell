local runner = require('neotest-haskell.runner')
local Path = require('plenary.path')

local simple_cabal_test_file = Path:new('tests/fixtures/hspec/cabal/simple/test/FirstSpec.hs')
local multi_package_cabal_test_file =
  Path:new('tests/fixtures/hspec/cabal/multi-package/subpackage1/test/Fix1/FixtureSpec.hs')
local simple_stack_test_file = Path:new('tests/fixtures/hspec/stack/simple/test/FirstSpec.hs')
local simple_stack_test_file_only_package_yaml =
  Path:new('tests/fixtures/hspec/stack/simple-package-yaml/test/FirstSpec.hs')
local multi_package_stack_test_file =
  Path:new('tests/fixtures/hspec/stack/multi-package/subpackage1/test/Fix1/FixtureSpec.hs')

describe('runner', function()
  describe('select_build_tool', function()
    describe('simple project without stack.yaml', function()
      it('uses cabal if it is in the list of build tools', function()
        local mk_command = runner.select_build_tool(simple_cabal_test_file.filename, { 'stack', 'cabal' })
        local command = mk_command()
        assert.equals(command[1], 'cabal')
      end)
      it('throws if only stack is specified', function()
        assert.errors(function()
          runner.select_build_tool(simple_cabal_test_file.filename, { 'stack' })
        end)
      end)
      it('throws if no build tool is specified', function()
        assert.errors(function()
          runner.select_build_tool(simple_cabal_test_file.filename, {})
        end)
      end)
    end)

    describe('multi-package project without stack.yaml', function()
      it('uses cabal if it is in the list of build tools', function()
        local mk_command = runner.select_build_tool(multi_package_cabal_test_file.filename, { 'stack', 'cabal' })
        local command = mk_command()
        assert.equals(command[1], 'cabal')
        assert.equals(command[3], 'subpackage1')
      end)
      it('throws if only stack is specified', function()
        assert.errors(function()
          runner.select_build_tool(multi_package_cabal_test_file.filename, { 'stack' })
        end)
      end)
      it('throws if no build tool is specified', function()
        assert.errors(function()
          runner.select_build_tool(multi_package_cabal_test_file.filename, {})
        end)
      end)
    end)

    describe('simple project with stack.yaml', function()
      it('uses stack if it is in the list of build tools before cabal', function()
        local mk_command = runner.select_build_tool(simple_stack_test_file.filename, { 'stack', 'cabal' })
        local command = mk_command()
        assert.equals(command[1], 'stack')
      end)
      it('uses stack if it is the only build tool', function()
        local mk_command = runner.select_build_tool(simple_stack_test_file.filename, { 'stack' })
        local command = mk_command()
        assert.equals(command[1], 'stack')
      end)
    end)
    it('throws if no build tool is specified', function()
      assert.errors(function()
        runner.select_build_tool('.', {})
      end)
    end)

    describe('simple project with stack.yaml, package.yaml and no *.cabal', function()
      it('uses stack if it is in the list of build tools before cabal', function()
        local mk_command =
          runner.select_build_tool(simple_stack_test_file_only_package_yaml.filename, { 'stack', 'cabal' })
        local command = mk_command()
        assert.equals(command[1], 'stack')
      end)
      it('uses stack if it is the only build tool', function()
        local mk_command = runner.select_build_tool(simple_stack_test_file_only_package_yaml.filename, { 'stack' })
        local command = mk_command()
        assert.equals(command[1], 'stack')
      end)
    end)
    it('throws if no build tool is specified', function()
      assert.errors(function()
        runner.select_build_tool('.', {})
      end)
    end)

    describe('multi-package project with stack.yaml', function()
      it('uses stack if it is in the list of build tools before cabal', function()
        local mk_command = runner.select_build_tool(multi_package_stack_test_file.filename, { 'stack', 'cabal' })
        local command = mk_command()
        assert.equals(command[1], 'stack')
        assert.equals(command[3], 'subpackage1')
      end)
      it('uses stack if it is the only build tool', function()
        local mk_command = runner.select_build_tool(multi_package_stack_test_file.filename, { 'stack' })
        local command = mk_command()
        assert.equals(command[1], 'stack')
      end)
    end)
    it('throws if no build tool is specified', function()
      assert.errors(function()
        runner.select_build_tool('.', {})
      end)
    end)
  end)
end)
