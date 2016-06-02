font pango:DejaVu Sans Mono 6

set $dark_red #9d0006
set $red #cc241d
set $bright_red #fb4934

set $dark_green #79740e
set $green #98971a
set $bright_green #b8bb26

set $dark_yellow #b57614
set $yellow #d79921
set $bright_yellow #fabd2f

set $dark_blue #076678
set $blue #458588
set $bright_blue #83a598

set $dark_purple #8f3f71
set $purple #b16286
set $bright_purple #d3869b

set $dark_aqua #427b58
set $aqua #689d6a
set $bright_aqua #8ec07c

set $dark_orange #af3a03
set $orange #d65d0e
set $bright_orange #fe8019

set $black0_h #1d2021
set $black0 #282828
set $black0_s #32302f
set $black1 #3c3836
set $black2 #504945
set $black3 #665c54
set $black4 #7c6f64
set $gray #928374
set $white4 #a89984
set $white3 #bdae93
set $white2 #d5c4a1
set $white1 #ebdbb2
set $white0_s #f2e5bc
set $white0 #fbf1c7
set $white0_h #f9f5d7

# Dark
# set $fg $white1
# set $bg $black0
# Bright means lighter

# Light
# set $fg $black1
# set $bg $white0
# Bright means darker

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

bindsym XF86AudioLowerVolume exec --no-startup-id amixer sset Master 1dB-
bindsym XF86AudioRaiseVolume exec --no-startup-id amixer sset Master 1dB+
bindsym XF86AudioMute exec --no-startup-id amixer sset Master toggle

bindsym XF86MonBrightnessDown exec --no-startup-id xbacklight -10
bindsym XF86MonBrightnessUp exec --no-startup-id xbacklight +10
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
