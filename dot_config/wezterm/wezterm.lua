-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_padding = {
  left = 5,
  right = 5,
  top = 0,
  bottom = 15,
}

config.ssh_domains = require("domains.mtt")

config.color_scheme = "tokyonight"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  { family = "Symbols Nerd Font Mono", scale = 0.75 },
})

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.use_cap_height_to_scale_fallback_fonts = true
config.font_size = 10.0

config.initial_rows = 30
config.initial_cols = 100

-- config.colors = {
--   tab_bar = {
--     active_tab = {
--       fg_color = '#16161e',
--       bg_color = '#7aa2f7',
--     },
--     new_tab_hover = {
--       fg_color = '#16161e',
--       bg_color = '#ffb86c',
--     }
--   }
-- }

-- p10k like status bar
wezterm.on("update-right-status", function(window, _)
  local date = wezterm.strftime("%H:%M:%S %d-%m-%Y")
  local hostname = " " .. wezterm.hostname() .. " "

  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#7aa2f7" } },
    { Background = { Color = "#191b28" } },
    { Text = "" },
    { Foreground = { Color = "#16161e" } },
    { Background = { Color = "#7aa2f7" } },
    { Text = date },
    { Foreground = { Color = "#191b28" } },
    { Background = { Color = "#7aa2f7" } },
    { Text = "" },
    { Foreground = { Color = "#f8f8f2" } },
    { Background = { Color = "#191b28" } },
    { Text = hostname },
  }))
end)

config.set_environment_variables = {
    PATH = os.getenv('PATH'),
}

wezterm.on("update-status", function(window, _)
  local ok, stdout, stderr = wezterm.run_child_process { "git", "rev-parse", "--abbrev-ref", "HEAD" }
  local ok, stdout, stderr = wezterm.run_child_process { "eza" }
  window:set_left_status(wezterm.format({
    { Foreground = { Color = "#f8f8f2" } },
    { Background = { Color = "#191b28" } },
    { Text = window:active_workspace():gsub("^.*\\", "")},
  }))
end)

config.default_prog = { "powershell.exe" }

local w = require("wezterm")

local function is_nvim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
  -- reverse lookup
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "CTRL|ALT" or "CTRL",
    action = w.action_callback(function(win, pane)
      if is_nvim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "CTRL|ALT" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

local function split_screen(direction, key)
  return {
    key = key,
    mods = "ALT",
    action = w.action_callback(function(win, pane)
      if is_nvim(pane) then
        win:perform_action(
          { SplitPane = { direction = direction, size = { Percent = 20 }, domain = "CurrentPaneDomain" } },
          pane
        )
      else
        win:perform_action(
          { SplitPane = { direction = direction, size = { Percent = 50 }, domain = "CurrentPaneDomain" } },
          pane
        )
      end
    end),
  }
end

config.keys = {
  -- Pane Sections
  -- Pane Creation
  split_screen("Down", "\\"),
  split_screen("Right", "/"),
  { key = "z", mods = "ALT", action = "TogglePaneZoomState" },
  { key = "d", mods = "ALT", action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
  { key = "w", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES|DOMAINS" }) },

  -- TAB Section
  -- Rename TAB
  {
    key = "R",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, _, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  -- TAB Creation
  { key = "c", mods = "CTRL|ALT", action = wezterm.action.SpawnCommandInNewTab({  }) },

  -- TAB Navigation
  -- { key = "n", mods = "ALT",      action = wezterm.action({ ActivateTabRelative = 1 }) },
  -- { key = "m", mods = "ALT",      action = wezterm.action({ ActivateTabRelative = -1 }) },
  { key = "t", mods = "ALT|CTRL", action = wezterm.action.ShowTabNavigator },
  { key = "Tab", mods = "CTRL", action = wezterm.action.SendKey {key='F13'} },

  -- Fullscreen
  { key = "f", mods = "ALT|CTRL", action = "ToggleFullScreen" },
  { key = "n", mods = "ALT|CTRL", action = "SpawnWindow" },

  -- Workspaces

  -- { key = 'w', mods = 'ALT|CTRL', action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES|DOMAINS" } },
  -- {
  --   key = "s",
  --   mods = "ALT",
  --   action = workspace_switcher.workspace_switcher(function(label)
  --     return wezterm.format({
  --       -- { Attribute = { Italic = true } },
  --       -- { Foreground = { Color = "green" } },
  --       -- { Background = { Color = "black" } },
  --       { Text = "󱂬: " .. label },
  --     })
  --   end),
  -- },

  -- Move Between Panes With Navigator.nvim
  -- move between split panes
  split_nav("move", "h"),
  split_nav("move", "j"),
  split_nav("move", "k"),
  split_nav("move", "l"),
  -- resize panes
  split_nav("resize", "h"),
  split_nav("resize", "j"),
  split_nav("resize", "k"),
  split_nav("resize", "l"),
  { key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }) },
}

-- Navigate through tabs with 1-9 keybinds
for i = 1, 9 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = "ALT",
    action = wezterm.action.ActivateTab(i - 1),
  })
end

require("tabs").setup(config)

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.set_zoxide_path("C:\\Users\\mrtem\\scoop\\shims\\zoxide.exe")
workspace_switcher.apply_to_config(config)
workspace_switcher.set_workspace_formatter(function(label)
  return wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = "#7AA2F7" } },
    { Text = ": " .. label },
  })
end)

return config
-- vim: ts=2 sts=2 sw=2 et
