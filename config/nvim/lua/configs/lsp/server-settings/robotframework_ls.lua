return {
  settings = {
    robot = {
      ["language-server"] = {
        python = ".venv/bin/python"
      },
      -- python = {
      --   executable = ".venv/bin/python",
      -- },
      pythonpath = {
        ".venv/lib/python3.11/site-packages/",
        ".venv/lib64/python3.11/site-packages/",
      },
    },
  },
}
