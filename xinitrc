urxvtd -q -f -o
xrdb -merge $XRESOURCES
xsetroot -cursor_name left_ptr &
xset -b
exec xmonad
