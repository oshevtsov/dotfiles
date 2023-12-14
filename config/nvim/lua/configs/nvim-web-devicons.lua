local M = {}

function M.config()
  local status_ok, nvim_web_devicons = pcall(require, "nvim-web-devicons")
  if status_ok then
    nvim_web_devicons.set_default_icon("", "#6d8086")
    nvim_web_devicons.set_icon({
      deb = { icon = "", name = "Deb" },
      lock = { icon = "", name = "Lock" },
      mp3 = { icon = "", name = "Mp3" },
      mp4 = { icon = "", name = "Mp4" },
      out = { icon = "", name = "Out" },
      toml = { icon = "", color = "#6d8086", cterm_color = "66", name = "Toml" },
      ["robots.txt"] = { icon = "ﮧ", name = "Robots" },
      ttf = { icon = "", name = "TrueTypeFont" },
      rpm = { icon = "", name = "Rpm" },
      woff = { icon = "", name = "WebOpenFontFormat" },
      woff2 = { icon = "", name = "WebOpenFontFormat2" },
      xz = { icon = "", name = "Xz" },
      zip = { icon = "", name = "Zip" },
    })
  end
end

return M
