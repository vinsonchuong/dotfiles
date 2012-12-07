require('awful')
require('awful.autofocus')
require('awful.rules')
require('beautiful')
require('naughty')
vicious = require('vicious')

local function clone(table)
  local result = {}
    for key, value in pairs(table) do
      result[key] = value
    end
  return result
end

local function range(start, stop)
  local result = {}
  for item = start, stop do
    table.insert(result, item)
  end
  return result
end
local function each(list, f)
  for i = 1, #list do
    f(list[i])
  end
end
local function reverse(list)
  local result = clone(list)
  for i = 1, #list do
    result[#list + 1 - i] = list[i]
  end
  return result
end
local function map(list, f)
  local result = {}
  each(list, function(item)
    table.insert(result, f(item))
  end)
  return result
end
local function reduce(list, initial, f)
  local result = initial
  each(list, function(item)
    result = f(result, item)
  end)
  return result
end
local function max(list)
  return reduce(list, -1 / 0, function(memo, item)
    return math.max(memo, item)
  end)
end

local function terminal(options)
  if not options then
    options = {}
  end
  result = 'urxvt'

  if options.scrollbars == true then
    result = result .. ' -sb'
  else
    result = result .. ' +sb'
  end

  if options.command then
    result = result .. ' -e ' .. options.command
  end

  return result
end

spawn_callbacks = {}
local spawn_callback_id = 1
function spawn(command, callback)
  local callback_id = spawn_callback_id
  spawn_callbacks[callback_id] = callback
  spawn_callback_id = spawn_callback_id + 1

  awful.util.spawn(
    'sh -c \'' ..
      command .. ';' ..
      'echo "spawn_callbacks[' .. callback_id .. ']()" | awesome-client' ..
    '\'',
    false
  )
end

local keys = {}
function map_keys(scope, mappings)
  local result = reduce(mappings, {}, function(memo, mapping)
    return awful.util.table.join(
      memo,
      awful.key(mapping[1], mapping[2], mapping[3], mapping[4])
    )
  end)

  if scope == keys then
    keys = awful.util.table.join(keys, result)
  end

  return result
end

local buttons = {}
function map_buttons(scope, mappings)
  local result = reduce(mappings, {}, function(memo, mapping)
    return awful.util.table.join(
      memo,
      awful.button(mapping[1], mapping[2], mapping[3], mapping[4])
    )
  end)

  if scope == buttons then
    buttons = awful.util.table.join(buttons, result)
  elseif scope ~= nil then
    scope:buttons(result)
  end

  return result
end

beautiful.init('/home/vinsonchuong/.config/awesome/theme.lua')
local screens = range(1, screen.count())
local layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.fair,
  awful.layout.suit.max,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier
}

local menu = awful.menu({
  items = {
    {'Terminal', terminal()},
    {'Editor', terminal({command = 'vim'})},
    {'File Manager', terminal({command = 'ranger ~'})},
    {'―――――――', nil, nil},
    {'Lock', terminal({command = 'slimlock'})},
    {'Reload', awesome.restart},
    {'Logout', awesome.quit},
    {'Reboot', 'reboot'},
    {'Shutdown', 'shutdown'}
  }
})
map_buttons(buttons, {
  {{}, 3, function()
    menu:toggle()
  end}
})

local launcher = awful.widget.launcher({
  image = image(beautiful.icon_archlinux),
  menu = menu
})
awful.widget.layout.margins[launcher] = {right = 8}

local prompt_box = map(screens, function(s)
  return awful.widget.prompt({prompt = '> '})
end)
map_keys(keys, {
  {{'Mod4'}, 'space', function()
    prompt_box[mouse.screen]:run()
  end}
})

local tags = map(screens, function(s)
  return awful.tag({'Work', 'Planning', 'Media'}, s, layouts[1])
end)
local tag_list = map(screens, function(s)
  return awful.widget.taglist(
    s,
    awful.widget.taglist.label.all,
    map_buttons(nil, {
      {{}, 1, awful.tag.viewonly},
      {{}, 3, awful.tag.viewtoggle},
      {{}, 4, awful.tag.viewnext},
      {{}, 5, awful.tag.viewprev}
    })
  )
end)
for i = 1, 3 do
  local key = tostring(i)
  map_keys(keys, {
    {{'Mod4'}, key, function()
      local screen = mouse.screen
      if tags[screen][i] then
        awful.tag.viewonly(tags[screen][i])
      end
    end},
    {{'Mod4', 'Shift'}, key, function()
    local screen = mouse.screen
      if tags[screen][i] then
        awful.tag.viewtoggle(tags[screen][i])
      end
    end}
  })
end
map_keys(keys, {
  {{'Mod4'}, 'h', awful.tag.viewprev},
  {{'Mod4'}, 'l', awful.tag.viewnext},
})

local task_list = map(screens, function(s)
  local result = awful.widget.tasklist(
    function(c)
      return awful.widget.tasklist.label.currenttags(c, s)
    end,
    map_buttons(nil, {
      {{}, 1, function(c)
        if c == client.focus then
          c.minimized = true
        else
          if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
          end
          client.focus = c
          c:raise()
        end
      end},
      {{}, 4, function()
        awful.client.focus.byidx(1)
        if client.focus then
          client.focus:raise()
        end
      end},
      {{}, 5, function()
        awful.client.focus.byidx(-1)
        if client.focus then
          client.focus:raise()
        end
      end}
    })
  )
  awful.widget.layout.margins[result] = {left = 13}
  return result
end)
map_keys(keys, {
  {{'Mod4'}, 'j', function()
    awful.client.focus.byidx(1)
    if client.focus then
      client.focus:raise()
    end
  end},
  {{'Mod4'}, 'k', function()
    awful.client.focus.byidx(-1)
    if client.focus then
      client.focus:raise()
    end
  end}
})

local system_tray = widget({type = 'systray'})

function image_widget(icon_name)
  local result = widget({type = 'imagebox'})
  result.image = image(beautiful['icon_' .. icon_name])
  awful.widget.layout.margins[result] = {left = 8}
  return result
end
function usage_widget(type, icon_name, format, text_width)
  local icon = image_widget(icon_name)
  local textbox = widget({type = 'textbox'})
  if text_width then
    textbox.width = text_width
  end
  vicious.register(textbox, vicious.widgets[type], format, 1)
  return reverse({
    layout = awful.widget.layout.horizontal.rightleft,
    icon,
    textbox
  })
end
local cpu_usage = usage_widget('cpu', 'cpu', '$1%', 31)
local memory_usage = usage_widget('mem', 'memory', '$1%', 31)
local download_usage = usage_widget('net', 'arrow_down', '${eth0 down_mb}MB')
local upload_usage = usage_widget('net', 'arrow_up', '${eth0 up_mb}MB')

local volume_icon = image_widget('speaker_max')
local volume_control = widget({type = 'textbox'})
volume_control.width = 31
vicious.register(volume_control, vicious.widgets.volume, function(widget, args)
  if args[2] == "♫" then
    volume_icon.image = image(beautiful['icon_speaker_max'])
  else
    volume_icon.image = image(beautiful['icon_speaker_mute'])
  end
  return args[1] ..'%'
end, 5, 'Master')
each({volume_icon, volume_control}, function(item)
  map_buttons(item, {
    {{}, 1, function()
      spawn('amixer -q sset Master toggle', function()
        vicious.force({volume_control})
      end)
    end},
    {{}, 3, function()
      spawn(terminal({command = 'alsamixer'}), function()
        vicious.force({volume_control})
      end)
    end},
    {{}, 4, function()
      spawn('amixer -q sset Master 1dB+', function()
        vicious.force({volume_control})
      end)
    end},
    {{}, 5, function()
      spawn('amixer -q sset Master 1dB-', function()
        vicious.force({volume_control})
      end)
    end}
  })
end)

local clock_icon = image_widget('clock')
local clock = awful.widget.textclock({align = 'right'}, '%a %I:%M %p', 1)
awful.widget.layout.margins[clock] = {right = 8}

local function change_layout_callback(offset)
  return function()
    awful.layout.inc(layouts, offset)
  end
end
local layout_toggle = map(screens, function(s)
  local result = awful.widget.layoutbox(s)
  map_buttons(result, {
    {{}, 1, change_layout_callback(1)},
    {{}, 3, change_layout_callback(-1)},
    {{}, 4, change_layout_callback(1)},
    {{}, 5, change_layout_callback(-1)}
  })
  return result
end)
map_keys(keys, {
  {{'Mod4'}, 'n', function()
    awful.layout.inc(layouts,  1)
  end},
  {{'Mod4'}, 'p', function()
    awful.layout.inc(layouts, -1)
  end},

  {{'Mod4'}, '+', function()
    awful.tag.incmwfact(0.05)
  end},
  {{'Mod4'}, '-', function()
    awful.tag.incmwfact(-0.05)
  end},

  {{'Mod4', 'Control'}, '+', function()
    awful.tag.incnmaster(1)
  end},
  {{'Mod4', 'Control'}, '-', function()
    awful.tag.incnmaster(-1)
  end}
})

each(screens, function(s)
  local taskbar = awful.wibox({
    position = 'top',
    screen = s,
    widgets = {
      layout = awful.widget.layout.horizontal.leftright,
      {
        layout = awful.widget.layout.horizontal.leftright,
        launcher,
        prompt_box[s],
        tag_list[s]
      },
      reverse({
        layout = awful.widget.layout.horizontal.rightleft,
        task_list[s],
        system_tray,
        cpu_usage,
        memory_usage,
        download_usage,
        upload_usage,
        volume_icon,
        volume_control,
        clock_icon,
        clock,
        layout_toggle[s]
      })
    }
  })
end)

awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = true,
      keys = map_keys(nil, {
        {{'Mod4'}, 'c', function(c)
          c:kill()
        end},
        {{'Mod4'}, 'z', function(c)
          c.minimized = true
        end},
        {{'Mod4'}, 'o', function(c)
          c.fullscreen = not c.fullscreen
        end}
      }),
      buttons = map_buttons(nil, {
        {{}, 1, function(c)
          client.focus = c
          c:raise()
        end},
        {{'Mod4'}, 1, awful.mouse.client.move},
        {{'Mod4'}, 3, awful.mouse.client.resize}
      })
    }
  },
  {
    rule = {class = 'MPlayer'},
    properties = {floating = true}
  },
  {
    rule = {class = 'pinentry'},
    properties = {floating = true}
  },
  {
    rule = {class = 'gimp'},
    properties = {floating = true}
  },
}
client.add_signal('manage', function(c, startup)
  if not startup and not c.size_hints.user_position and not c.size_hints.program_position then
    awful.placement.no_overlap(c)
    awful.placement.no_offscreen(c)
  end
end)
client.add_signal('focus', function(c)
  c.border_color = beautiful.border_focus
end)
client.add_signal('unfocus', function(c)
  c.border_color = beautiful.border_normal
end)

root.buttons(buttons)
root.keys(keys)
