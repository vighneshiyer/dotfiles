local function default_branch()
  local ref = vim.fn.systemlist({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })[1]
  if vim.v.shell_error == 0 and ref and ref ~= "" then
    return ref
  end
  for _, b in ipairs({ "origin/main", "origin/master" }) do
    vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", b })
    if vim.v.shell_error == 0 then
      return b
    end
  end
  return "HEAD"
end

local function diffview_toggle(rev)
  if require("diffview.lib").get_current_view() then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen " .. (rev or ""))
  end
end

return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    event = "LazyFile",
    opts = {
      -- mini.diff owns the signcolumn; gitsigns is loaded only for its git verbs
      signcolumn = false,
      numhl = false,
      linehl = false,
      word_diff = false,
      current_line_blame = true,
      current_line_blame_opts = { delay = 400, virt_text_pos = "eol" },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
        end

        -- ]h/[h deliberately unmapped: mini.diff already owns hunk navigation
        map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk (toggle)")
        map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghU", gs.reset_buffer_index, "Unstage Buffer")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghl", gs.toggle_current_line_blame, "Toggle Line Blame")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns Select Hunk")
      end,
    },
  },

  {
    "nvim-mini/mini.diff",
    init = function()
      -- gitsigns and mini.diff both claim <leader>uG at load time; bind it last
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.schedule(function()
            vim.keymap.set("n", "<leader>uG", function()
              require("mini.diff").toggle(0)
            end, { desc = "Toggle mini.diff Signs" })
          end)
        end,
      })
    end,
  },

  {
    "dlyongemallo/diffview-plus.nvim",
    version = "*",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewRefresh" },
    keys = {
      { "<leader>gv", function() diffview_toggle() end, desc = "Diffview: Working Tree" },
      { "<leader>gm", function() diffview_toggle(default_branch() .. "...HEAD") end, desc = "Diffview: vs Default Branch" },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: File History" },
      { "<leader>gv", "<Esc><cmd>'<,'>DiffviewFileHistory<cr>", mode = "x", desc = "Diffview: Selection History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = { layout = "diff3_mixed", disable_diagnostics = true },
      },
    },
  },
}
