-- Hey Emacs, this is -*- coding: utf-8 -*-

local wezterm = require('wezterm')

local is_windows = wezterm.target_triple:find('windows') ~= nil
local act = wezterm.action

local config = wezterm.config_builder()

local ssh_auth_sock = os.getenv("SSH_AUTH_SOCK")
if ssh_auth_sock then
  config.default_ssh_auth_sock = ssh_auth_sock
end

if is_windows then
  config.default_prog = { 'powershell.exe' }
  config.window_decorations = "INTEGRATED_BUTTONS"
else
  config.command_palette_font = wezterm.font('Hack')
  config.window_background_opacity = 0.93
end

config.ssh_domains = {
  {
    name = 'qt-dl1',
    remote_address = '10.140.10.44',
    username = 'rh',
    remote_wezterm_path = "/nix/var/nix/profiles/default/bin/wezterm"
  },
}

-- config.set_environment_variables = {
--   TERM_PROGRAM = 'WezTerm',
-- }

-- config.window_decorations = "RESIZE"

config.window_frame = {
  font = wezterm.font('Hack'),
  font_size = 11,
}

config.ui_key_cap_rendering = 'Emacs'
config.command_palette_font_size = 9

config.font_size = 9
config.font = wezterm.font('Hack')

wezterm.on('update-right-status', function(window, pane)
  local text = ''
  local key_table_name = window:active_key_table()

  if key_table_name then
    text = 'TABLE: ' .. key_table_name .. ' '
  elseif window:leader_is_active() then
    text = 'LEADER '
  end

  window:set_right_status(text)
end)

-- config.disable_default_key_bindings = true
-- config.enable_kitty_keyboard = true
-- config.enable_csi_u_key_encoding = true
-- config.send_composed_key_when_left_alt_is_pressed  = false
-- config.send_composed_key_when_right_alt_is_pressed = false

config.leader = { key = 'phys:Z', mods = 'SHIFT|CTRL', timeout_milliseconds = 30000 }
config.keys = {
  {
    key = 'Insert',
    mods = 'SHIFT',
    action = act.DisableDefaultAssignment,
  },
  {
    key = 'Insert',
    mods = 'CTRL',
    action = act.DisableDefaultAssignment,
  },

  {
    key = 'LeftArrow',
    mods = 'SHIFT|CTRL',
    action = act.DisableDefaultAssignment,
  },
  {
    key = 'RightArrow',
    mods = 'SHIFT|CTRL',
    action = act.DisableDefaultAssignment,
  },
  {
    key = 'UpArrow',
    mods = 'SHIFT|CTRL',
    action = act.DisableDefaultAssignment,
  },
  {
    key = 'DownArrow',
    mods = 'SHIFT|CTRL',
    action = act.DisableDefaultAssignment,
  },

  -- {
  --   key = 'Delete',
  --   mods = 'NONE',
  --   action = wezterm.action.SendString '\x1b[3~',
  -- },
  -- {
  --   key = 'Escape',
  --   mods = 'NONE',
  --   action = wezterm.action.SendString '\x1b[27u',
  -- },

  {
    key = 'LeftArrow',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },

  {
    key = 'w',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'windows',
      one_shot = false,
    },
  },

  -- Send "CTRL-META-Z" to the terminal when pressing CTRL-META-Z, CTRL-META-Z
  {
    key = 'z',
    mods = 'LEADER|SHIFT|CTRL',
    action = act.SendKey { key = 'z', mods = 'SHIFT|CTRL' },
  },
}

config.key_tables = {
  -- Defines the keys that are active in our activate-pane mode.
  -- 'windows' here corresponds to the name="windows" in
  -- the key assignments above.
  windows = {
    { key = 'LeftArrow', action = act.ActivatePaneDirection 'Left' },
    { key = 'h', action = act.ActivatePaneDirection 'Left' },

    { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
    { key = 'l', action = act.ActivatePaneDirection 'Right' },

    { key = 'UpArrow', action = act.ActivatePaneDirection 'Up' },
    { key = 'k', action = act.ActivatePaneDirection 'Up' },

    { key = 'DownArrow', action = act.ActivatePaneDirection 'Down' },
    { key = 'j', action = act.ActivatePaneDirection 'Down' },

    { key = 'z', action = act.TogglePaneZoomState },

    -- Cancel the mode by pressing escape
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

config.colors = {
    compose_cursor = 'orange',
}

-- config.key_tables = {
--   leader = {
--     -- Exit leader mode cleanly
--     { key = 'g', mods = 'CTRL', action = 'PopKeyTable' },

--     -- Double-tap leader → send literal C-/ to terminal AND exit mode
--     {
--       key = '/',
--       mods = 'CTRL',
--       action = act.Multiple {
--         act.PopKeyTable,
--         act.SendString '\x1f',   -- Ctrl + /
--       },
--     },

--     -- -- Emacs-style pane / window control --

--     -- Navigation
--     { key = 'o', mods = 'CTRL', action = act.PaneSelect },                     -- C-x o → like other-window (choose pane interactively)
--     { key = 'n', mods = 'CTRL', action = act.ActivatePaneDirection 'Next' },   -- C-x n → next pane (directional cycle)
--     { key = 'p', mods = 'CTRL', action = act.ActivatePaneDirection 'Prev' },   -- C-x p → previous pane

--     -- Splitting (horizontal = below, vertical = right — matches Emacs)
--     { key = '2', mods = 'CTRL', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },  -- C-x 2
--     { key = '3', mods = 'CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },  -- C-x 3  (note: WezTerm uses "Horizontal" for left/right split)

--     -- Closing / zooming
--     { key = '0', mods = 'CTRL', action = act.CloseCurrentPane { confirm = true } },  -- C-x 0  delete current
--     { key = '1', mods = 'CTRL', action = act.TogglePaneZoomState },                  -- C-x 1  zoom current (delete others visually)

--     -- Optional extras that fit Emacs feel
--     { key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection 'Up' },
--     { key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection 'Down' },
--     { key = 'h', mods = 'CTRL', action = act.ActivatePaneDirection 'Left' },
--     { key = 'l', mods = 'CTRL', action = act.ActivatePaneDirection 'Right' },

--     -- New tab (Emacs doesn't have direct analog, but useful)
--     { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
--   },
-- }

-- -- Highly recommended: visual indicator when leader is active
-- wezterm.on('update-status', function(window, _)
--   local right = window:active_tab():active_pane():title() or ''
--   if window:leader_is_active() then
--     right = right .. '  [LEADER]'
--   end
--   window:set_right_status(right)
-- end)

return config
