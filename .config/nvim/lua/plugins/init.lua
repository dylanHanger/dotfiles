return {
  -- Preview colors
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      -- Attach to all buffers
      "*",
    },
  },
}
