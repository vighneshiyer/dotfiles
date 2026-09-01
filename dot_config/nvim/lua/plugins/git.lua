-- Ownership split:
--   gitsigns  -> signcolumn (the only one that renders staged vs unstaged distinctly),
--                hunk verbs, hunk nav, blame
--   mini.diff -> the word-level overlay only; its own view and mappings are off
--   neogit    -> status buffer and every history-writing verb

local MINIDIFF_VIEW_HL = { "MiniDiffSignAdd", "MiniDiffSignChange", "MiniDiffSignDelete" }

-- delta's dark defaults, mirrored so neogit reads like the CLI pager
local DELTA = {
  minus = "#3f0001",
  minus_emph = "#901011",
  plus = "#002800",
  plus_emph = "#006000",
}

return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    event = "LazyFile",
    opts = {
      signcolumn = true,
      signs_staged_enable = true,
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

        map("n", "]h", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")

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
    opts = {
      -- 'number' emits no sign_text at all, leaving the signcolumn to gitsigns;
      -- the overlay lives in its own namespace and is unaffected
      view = { style = "number" },
      mappings = {
        apply = "", reset = "", textobject = "",
        goto_first = "", goto_prev = "", goto_next = "", goto_last = "",
      },
    },
    init = function()
      -- the 'number' style tints changed line numbers via these groups. Link them to
      -- LineNr rather than clearing: an empty group reads as undefined, so mini.diff's
      -- own default=true definition would immediately reapply.
      local function hide_view()
        for _, g in ipairs(MINIDIFF_VIEW_HL) do
          vim.api.nvim_set_hl(0, g, { link = "LineNr" })
        end
      end
      hide_view()
      -- LazyVim may apply the colorscheme before this spec's init runs, so the
      -- initial call can lose the race; VimEnter re-asserts after startup settles
      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, { callback = hide_view })

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.schedule(function()
            vim.keymap.set("n", "<leader>uG", function()
              require("mini.diff").toggle(0)
            end, { desc = "Toggle mini.diff" })
          end)
        end,
      })
    end,
  },

  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    opts = {
      disable_hint = true,
      graph_style = "unicode",
      integrations = { diffview = false, snacks = true },
    },
    init = function()
      local function delta_colors()
        local set = function(g, v)
          vim.api.nvim_set_hl(0, g, v)
        end

        -- tokyonight's neogit integration defines only the Highlight variants and
        -- neogit's own palette the rest, so a line's color shifts with the cursor's
        -- hunk context unless every variant is pinned together
        for _, sfx in ipairs({ "", "Highlight" }) do
          set("NeogitDiffAdd" .. sfx, { bg = DELTA.plus })
          set("NeogitDiffDelete" .. sfx, { bg = DELTA.minus })
        end
        set("NeogitDiffAddCursor", { bg = "#004000" })
        set("NeogitDiffDeleteCursor", { bg = "#650809" })

        -- bg only: the word-diff extmark outranks treesitter (priority 220 vs 210),
        -- so an explicit fg here would clobber syntax highlighting inside the span
        set("NeogitDiffAddInline", { bg = DELTA.plus_emph })
        set("NeogitDiffDeleteInline", { bg = DELTA.minus_emph })

        -- delta leaves unchanged lines on the terminal background. Link rather than
        -- bg = "NONE": that reads as an empty (undefined) group, so neogit's is_set()
        -- guard would reapply its own default -- same trap as MINIDIFF_VIEW_HL above
        set("NeogitDiffContext", { link = "Normal" })
        set("NeogitDiffContextHighlight", { bg = "#1e1f2a" })
      end

      delta_colors()
      -- same startup race as mini.diff above; neogit also re-runs its own hl.setup on
      -- ColorScheme, but its is_set() guard skips any group already defined here
      vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, { callback = delta_colors })
    end,
  },
}
