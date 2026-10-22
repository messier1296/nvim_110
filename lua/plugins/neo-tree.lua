return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      -- `nvim <dir>` hijacks netrw with a "current" position tree. With the
      -- default window-local cwd, the tab cwd stays at the launch directory,
      -- so a later sidebar reveal prompts to change cwd and fails with E95.
      cwd_target = { sidebar = "tab", current = "tab" },
    },
  },
}
