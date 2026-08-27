local function find_root(path, marker)
  local hit = vim.fs.find(marker, { path = path or vim.fn.getcwd(), upward = true })[1]
  return hit and vim.fs.dirname(hit) or nil
end

local function pixi_env(root)
  local prefix = root .. "/.pixi/envs/default"
  return {
    PAXREPO = root,
    CONDA_PREFIX = prefix,
    LIBCLANG_PATH = prefix .. "/lib",
    CC = "clang",
    CXX = "clang++",
    PATH = prefix .. "/bin:" .. (vim.env.PATH or ""),
  }
end

return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        settings = function(project_root, default_settings)
          local settings = vim.deepcopy(default_settings)
          local ra = settings["rust-analyzer"]
          local pixi_root = find_root(project_root, "pixi.toml")
          if not pixi_root then
            return settings
          end
          ra.cargo.allFeatures = false
          ra.cargo.features = { "mock-fpga" }
          ra.cargo.extraEnv = pixi_env(pixi_root)
          return settings
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              buildScripts = { enable = true },
              loadOutDirsFromCheck = true,
              -- own target dir: never contend with CLI cargo's build lock
              targetDir = true,
            },
            check = {
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            checkOnSave = true,
            diagnostics = {
              enable = true,
              disabled = { "unlinked-file" },
            },
            files = {
              exclude = {
                ".direnv",
                ".git",
                ".jj",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
              watcher = "client",
            },
            procMacro = { enable = true },
          },
        },
      },
    },
  },
}
