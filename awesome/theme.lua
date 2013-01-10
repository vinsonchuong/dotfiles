local awful = require('awful')

local function asset(path)
  return awful.util.getdir('config') .. '/' .. path
end
local function widget_asset(name)
  return asset('widget_icons/' .. name)
end
local function layout_asset(name)
  return asset('layout_icons/' .. name)
end

local base03 = '#002b36'
local base02 = '#073642'
local base01 = '#586e75'
local base00 = '#657b83'
local base0 = '#839496'
local base1 = '#93a1a1'
local base2 = '#eee8d5'
local base3 = '#fdf6e3'
local yellow = '#b58900'
local orange = '#cb4b16'
local red = '#dc322f'
local magenta = '#d33682'
local violet = '#6c71c4'
local blue = '#268bd2'
local cyan = '#2aa198'
local green = '#859900'

return {
  wallpaper = asset('wallpaper.png'),

  font = 'DejaVu Sans 8',

  fg_normal = base0,
  fg_focus = base0,
  fg_urgent = yellow,
  bg_normal = base03,
  bg_focus = base02,
  bg_urgent = base03,
  border_width = '3',
  border_normal = base1,
  border_focus = blue,
  border_marked = blue,

  menu_height = 15,
  menu_width = 93,
  menu_border_width = 0,

  icon_archlinux = widget_asset('archlinux.png'),
  icon_arrow_down = widget_asset('arrow_down.png'),
  icon_arrow_up = widget_asset('arrow_up.png'),
  icon_battery_empty = widget_asset('battery_empty.png'),
  icon_battery_full = widget_asset('battery_full.png'),
  icon_battery_low = widget_asset('battery_low.png'),
  icon_bluetooth = widget_asset('bluetooth.png'),
  icon_bug = widget_asset('bug.png'),
  icon_clock = widget_asset('clock.png'),
  icon_cpu = widget_asset('cpu.png'),
  icon_disk_empty = widget_asset('disk_empty.png'),
  icon_disk_full = widget_asset('disk_full.png'),
  icon_disk_half = widget_asset('disk_half.png'),
  icon_drive_flash = widget_asset('drive_flash.png'),
  icon_drive_floppy = widget_asset('drive_floppy.png'),
  icon_email = widget_asset('email.png'),
  icon_headphones = widget_asset('headphones.png'),
  icon_media_forward = widget_asset('media_forward.png'),
  icon_media_next = widget_asset('media_next.png'),
  icon_media_pause = widget_asset('media_pause.png'),
  icon_media_play = widget_asset('media_play.png'),
  icon_media_previous = widget_asset('media_previous.png'),
  icon_media_rewind = widget_asset('media_rewind.png'),
  icon_media_stop = widget_asset('media_stop.png'),
  icon_memory = widget_asset('memory.png'),
  icon_mouse = widget_asset('mouse.png'),
  icon_musical_note = widget_asset('musical_note.png'),
  icon_pacman = widget_asset('pacman.png'),
  icon_plug_ethernet = widget_asset('plug_ethernet.png'),
  icon_plug_power = widget_asset('plug_power.png'),
  icon_speaker_max = widget_asset('speaker_max.png'),
  icon_speaker_mute = widget_asset('speaker_mute.png'),
  icon_temperature = widget_asset('temperature.png'),
  icon_usb = widget_asset('usb.png'),
  icon_wireless_satellite = widget_asset('wireless_satellite.png'),
  icon_wireless_wifi = widget_asset('wireless_wifi.png'),

  layout_tile = layout_asset('tile.png'),
  layout_tileleft = layout_asset('tileleft.png'),
  layout_tilebottom = layout_asset('tilebottom.png'),
  layout_tiletop = layout_asset('tiletop.png'),
  layout_fairv = layout_asset('fairv.png'),
  layout_fairh = layout_asset('fairh.png'),
  layout_spiral = layout_asset('spiral.png'),
  layout_dwindle = layout_asset('dwindle.png'),
  layout_max = layout_asset('max.png'),
  layout_fullscreen = layout_asset('fullscreen.png'),
  layout_magnifier = layout_asset('magnifier.png'),
  layout_floating = layout_asset('floating.png')
}
