-- Hey Emacs, this is -*- coding: utf-8 -*-

local wezterm = require('wezterm')
local act = wezterm.action

local config = wezterm.config_builder()

-- config.set_environment_variables = {
--   TERM_PROGRAM = 'WezTerm',
-- }

config.window_background_opacity = 0.93

-- config.window_decorations = "RESIZE"
-- config.window_decorations = "INTEGRATED_BUTTONS"

config.window_frame = {
  font = wezterm.font('Hack'),
  font_size = 11,
}

config.ui_key_cap_rendering = 'Emacs'
config.command_palette_font = wezterm.font('Hack')
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

-- config.leader = { key = 'z', mods = 'SUPER' }
-- config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
-- config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 30000 }
config.leader = { key = 'z', mods = 'SUPER', timeout_milliseconds = 30000 }
config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  {
    key = 'a',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'activate_pane',
      one_shot = false,
    },
  },

  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  {
    key = 'z',
    mods = 'LEADER|SUPER',
    action = act.SendKey { key = 'z', mods = 'SUPER' },
  },
}

config.key_tables = {
  -- Defines the keys that are active in our activate-pane mode.
  -- 'activate_pane' here corresponds to the name="activate_pane" in
  -- the key assignments above.
  activate_pane = {
    { key = 'LeftArrow', action = act.ActivatePaneDirection 'Left' },
    { key = 'h', action = act.ActivatePaneDirection 'Left' },

    { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
    { key = 'l', action = act.ActivatePaneDirection 'Right' },

    { key = 'UpArrow', action = act.ActivatePaneDirection 'Up' },
    { key = 'k', action = act.ActivatePaneDirection 'Up' },

    { key = 'DownArrow', action = act.ActivatePaneDirection 'Down' },
    { key = 'j', action = act.ActivatePaneDirection 'Down' },

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
