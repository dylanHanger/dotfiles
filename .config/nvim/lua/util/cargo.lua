-- https://github.com/mfussenegger/nvim-dap/discussions/671
local M = {}

local function parse_cargo_metadata(cargo_metadata)
  -- Iterate backwards through the metadata list since the binary
  -- we want will be near the end (usually second to last)
  for i = 1, #cargo_metadata do
    local json_table = cargo_metadata[#cargo_metadata + 1 - i]

    -- Some metadata lines may be blank, skip those
    if string.len(json_table) ~= 0 then
      -- Each metadata line is a JSON table
      -- parse it into a data structure we can work with
      json_table = vim.fn.json_decode(json_table)

      -- Our binary will be the compiler artifact with an executable defined
      if json_table["reason"] == "compiler-artifact" and json_table["executable"] ~= vim.NIL then
        return json_table["executable"]
      end
    end
  end

  return nil
end

-- TODO: Cleanup and rewrite my own version of this
function M.cargo_inspector(config)
  local lazyutil = require("lazy.util")

  local final_config = vim.deepcopy(config)

  -- Create a buffer to receive compiler progress messages
  local compiler_msg_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(compiler_msg_buf, "buftype", "nofile")

  -- And a floating window in the corner to display them
  -- TODO: Try make this look nicer with notify instead of a floating window
  -- Or alternatively, in the console used by DAP UI
  local float = lazyutil.float({
    buf = compiler_msg_buf,
    size = { width = 0.6, height = 0.6 },
    zindex = 1,
  })

  -- Let the user know what's going on
  vim.fn.appendbufline(compiler_msg_buf, "$", "Compiling: ")
  vim.fn.appendbufline(compiler_msg_buf, "$", final_config.name)
  vim.fn.appendbufline(compiler_msg_buf, "$", string.rep("=", vim.api.nvim_win_get_width(float.win) - 1))

  -- Instruct cargo to emit compiler metadata as JSON
  local message_format = "--message-format=json"
  if final_config.cargo.args ~= nil then
    table.insert(final_config.cargo.args, message_format)
  else
    final_config.cargo.args = { message_format }
  end

  -- Build final `cargo` command to be executed
  local cargo_cmd = { "cargo" }
  for _, value in pairs(final_config.cargo.args) do
    table.insert(cargo_cmd, value)
  end

  -- Run `cargo`, retaining buffered `stdout` for later processing
  -- and emitting compiler messages to a window
  -- TODO: This might be a job for plenary?
  local compiler_metadata = {}
  local cargo_job = vim.fn.jobstart(cargo_cmd, {
    clear_env = false,
    env = final_config.cargo.env,
    cwd = final_config.cwd,

    -- Cargo emits compiler metadata to `stdout`
    stdout_buffered = true,
    on_stdout = function(_, data)
      compiler_metadata = data
    end,

    -- Cargo emits compiler messages to `stderr`
    on_stderr = function(_, data)
      local complete_line = ""

      -- `data` might contain partial lines, glue data together until
      -- the stream indicates the line is complete with an empty string
      for _, partial_line in ipairs(data) do
        if string.len(partial_line) ~= 0 then
          complete_line = complete_line .. partial_line
        end
      end

      if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
        vim.fn.appendbufline(compiler_msg_buf, "$", complete_line)
        vim.api.nvim_win_set_cursor(float.win, { vim.api.nvim_buf_line_count(compiler_msg_buf), 1 })
        vim.cmd("redraw")
      end
    end,

    on_exit = function(_, exit_code)
      -- Cleanup the compile message window and buffer
      if vim.api.nvim_win_is_valid(float.win) then
        vim.api.nvim_win_close(float.win, true)
      end

      if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
        vim.api.nvim_buf_delete(compiler_msg_buf, { force = true })
      end

      -- If compiling succeeded, send the compile metadata off for processing
      -- and add the resulting executable name to the `program` field of the final config
      if exit_code == 0 then
        local executable_name = parse_cargo_metadata(compiler_metadata)
        if executable_name ~= nil and final_config.program == nil then
          final_config.program = executable_name
        else
          vim.notify(
            "Cargo could not find an executable for debug configuration:\n\n\t" .. final_config.name,
            vim.log.levels.ERROR
          )
        end
      else
        vim.notify("Cargo failed to compile debug configuration:\n\n\t" .. final_config.name, vim.log.levels.ERROR)
      end
    end,
  })

  -- Get the rust compiler's commit hash for the source map
  local rust_hash = ""
  local rust_hash_stdout = {}
  local rust_hash_job = vim.fn.jobstart({ "rustc", "--version", "--verbose" }, {
    clear_env = false,
    stdout_buffered = true,
    on_stdout = function(_, data)
      rust_hash_stdout = data
    end,
    on_exit = function()
      for _, line in pairs(rust_hash_stdout) do
        local start, finish = string.find(line, "commit-hash: ", 1, true)

        if start ~= nil then
          rust_hash = string.sub(line, finish + 1)
        end
      end
    end,
  })

  -- Get the location of the rust toolchain's source code for the source map
  local rust_source_path = ""
  local rust_source_job = vim.fn.jobstart({ "rustc", "--print", "sysroot" }, {
    clear_env = false,
    stdout_buffered = true,
    on_stdout = function(_, data)
      rust_source_path = data[1]
    end,
  })

  -- Wait until compiling and parsing are done
  -- FIXME: This blocks the UI
  vim.fn.jobwait({ cargo_job, rust_hash_job, rust_source_job })

  -- Enable visualisation of build in rust datatypes
  final_config.sourceLanguages = { "rust" }

  -- Build sourcemap to rust's source code so we can step into stdlib
  rust_hash = "/rustc/" .. rust_hash .. "/"
  rust_source_path = rust_source_path .. "/lib/rustlib/src/rust/"
  if final_config.sourceMap == nil then
    final_config["sourceMap"] = {}
  end
  final_config.sourceMap[rust_hash] = rust_source_path

  -- Cargo section is no longer needed
  final_config.cargo = nil

  return final_config
end

return M
