-- NOTE: Most of this is taken from `rust-tools.dap`
local M = {}

local rt = require("rust-tools")
local util = require("util")

local function get_cargo_args_from_runnables_args(runnable_args)
  local cargo_args = runnable_args.cargoArgs

  local message_json = "--message-format=json"
  if not rt.utils.contains(cargo_args, message_json) then
    table.insert(cargo_args, message_json)
  end

  for _, value in ipairs(runnable_args.cargoExtraArgs) do
    if not rt.utils.contains(cargo_args, value) then
      table.insert(cargo_args, value)
    end
  end

  return cargo_args
end

function M.build_and_run(args, callback)
  if not pcall(require, "dap") then
    util.scheduled_error("nvim-dap not found.")
    return
  end

  if not pcall(require, "plenary.job") then
    util.scheduled_error("plenary not found.")
    return
  end

  local Job = require("plenary.job")

  local cargo_args = get_cargo_args_from_runnables_args(args)

  vim.notify("Compiling a debug build for debugging. This might take some time...")

  Job
    :new({
      command = "cargo",
      args = cargo_args,
      cwd = args.workspaceRoot,
      on_exit = function(j, code)
        if code and code > 0 then
          util.scheduled_error("An error occurred while compiling. Please fix all compilation issues and try again.")
          return
        end

        vim.schedule(function()
          local executables = {}

          for _, value in pairs(j:result()) do
            local artifact = vim.fn.json_decode(value)

            -- only process artifact if it's valid json object and it is a compiler artifact
            if type(artifact) ~= "table" or artifact.reason ~= "compiler-artifact" then
              goto loop_end
            end

            local is_binary = rt.utils.contains(artifact.target.crate_types, "bin")
            local is_build_script = rt.utils.contains(artifact.target.kind, "custom-build")
            local is_test = ((artifact.profile.test == true) and (artifact.executable ~= nil))
              or rt.utils.contains(artifact.target.kind, "test")
            -- only add executable to the list if we want a binary debug and it is a binary
            -- or if we want a test debug and it is a test
            if
              (cargo_args[1] == "build" and is_binary and not is_build_script)
              or (cargo_args[1] == "test" and is_test)
            then
              table.insert(executables, artifact.executable)
            end

            ::loop_end::
          end

          -- only 1 executable is allowed for debugging - error out if zero or many were found
          if #executables <= 0 then
            util.scheduled_error("No compilation artifacts found.")
            return
          end
          if #executables > 1 then
            util.scheduled_error("Multiple compilation artifacts are not supported.")
            return
          end

          -- Call our function with the result of the compilation
          callback(executables[1])
        end)
      end,
    })
    :start()
end

local function get_params()
  return {
    textDocument = vim.lsp.util.make_text_document_params(),
    position = nil, -- get em all
  }
end

local function is_valid_test(args)
  local is_not_cargo_check = args.cargoArgs[1] ~= "check"
  return is_not_cargo_check
end

local function sanitize_results_for_debugging(result)
  local ret = {}

  ret = vim.tbl_filter(function(value)
    return is_valid_test(value.args)
  end, result)

  for _, value in ipairs(ret) do
    rt.utils.sanitize_command_for_debugging(value.args.cargoArgs)
  end

  return ret
end

local function handler(callback, _, result)
  -- TODO: Handle the results of the LSP request
  if result == nil then
    return
  end
  result = sanitize_results_for_debugging(result)
  callback(result)
end

function M.get_args(command, callback)
  local _callback = function(results)
    -- TODO: Find the requested result
    local result = results[1].args
    callback(result)
  end

  rt.utils.request(0, "experimental/runnables", get_params(), util.partial(handler, _callback))
end

return M
