font pango:DejaVu Sans Mono 6

client.focused #268bd2 #268bd2 #fdf6e3 #6c71c4
client.focused_inactive #839496 #839496 #fdf6e3 #839496
client.unfocused #839496 #839496 #fdf6e3 #839496
client.urgent #b58900 #b58900 #fdf6e3 #cb4b16

new_window pixel 2
new_float pixel 2

bar {
	status_command i3status
	modifier Mod4
	position top
	colors {
		background #002b36
		statusline #839496
		separator #073642
		focused_workspace #073642 #073642 #268bd2
		active_workspace #073642 #073642 #586e75
		inactive_workspace #073642 #073642 #586e75
		urgent_workspace #073642 #073642 #b58900
	}
}

floating_modifier Mod4

bindsym Mod4+d exec --no-startup-id i3-dmenu-desktop --dmenu='dmenu -i -h 30 -fn "DejaVu Sans Mono-6" -nb "#002b36" -nf "#839496" -sb "#073642" -sf "#268bd2"'
bindsym Mod4+Return exec urxvtc -sl 0 -sb -letsp -2 -fade 0 -e tmux

bindsym XF86AudioLowerVolume exec amixer sset Master 1dB-
bindsym XF86AudioRaiseVolume exec amixer sset Master 1dB+
bindsym XF86AudioMute exec amixer sset Master toggle

bindsym XF86MonBrightnessDown exec xbacklight -10
bindsym XF86MonBrightnessUp exec xbacklight +10
#bindsym XF86Display

bindsym Mod4+q kill
bindsym Mod4+o fullscreen

bindsym Mod4+t layout tabbed
bindsym Mod4+Shift+t layout toggle split

bindsym Mod4+s split h
bindsym Mod4+v split v

bindsym Mod4+p focus parent
bindsym Mod4+n focus child
bindsym Mod4+h focus left
bindsym Mod4+j focus down
bindsym Mod4+k focus up
bindsym Mod4+l focus right

bindsym Mod4+Shift+h move left
bindsym Mod4+Shift+j move down
bindsym Mod4+Shift+k move up
bindsym Mod4+Shift+l move right

bindsym Mod4+1 workspace 1
bindsym Mod4+2 workspace 2
bindsym Mod4+3 workspace 3
bindsym Mod4+4 workspace 4
bindsym Mod4+5 workspace 5
bindsym Mod4+6 workspace 6
bindsym Mod4+7 workspace 7
bindsym Mod4+8 workspace 8
bindsym Mod4+9 workspace 9
bindsym Mod4+0 workspace 10

bindsym Mod4+Shift+1 move container to workspace 1
bindsym Mod4+Shift+2 move container to workspace 2
bindsym Mod4+Shift+3 move container to workspace 3
bindsym Mod4+Shift+4 move container to workspace 4
bindsym Mod4+Shift+5 move container to workspace 5
bindsym Mod4+Shift+6 move container to workspace 6
bindsym Mod4+Shift+7 move container to workspace 7
bindsym Mod4+Shift+8 move container to workspace 8
bindsym Mod4+Shift+9 move container to workspace 9
bindsym Mod4+Shift+0 move container to workspace 10

bindsym Mod4+Shift+r restart
bindsym Mod4+Shift+q exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

mode resize {
	bindsym Mod4+h resize shrink width 10 px or 3 ppt
	bindsym Mod4+l resize grow width 10 px or 3 ppt
	bindsym Mod4+j resize grow height 10 px or 3 ppt
	bindsym Mod4+k resize shrink height 10 px or 3 ppt

	bindsym Escape mode "default"
}
bindsym Mod4+r mode resize

for_window [class="^mpv"] floating enable

exec --no-startup-id google-musicmanager
exec --no-startup-id insync start

# create/rename workspaces with automatic re-ordering
# i3-msg -t get_workspaces
# how expressive is exec?
# rename workspace 4 to 5; rename workspace 3 to 4; workspace 3: new name
# i3-input -F 'rename workspace to "%s"' -P 'enter new name: '
# i3-input -F 'workspace "%s"' -P 'enter new name: '

# move containers to other outputs
# move container to output <<left|right|up|down>>

# mark containers for quick focusing
# mark container-name
# [con_mark="container-name"] focus
# unmark container-name
# unmark

# command mode via Mod4+:
