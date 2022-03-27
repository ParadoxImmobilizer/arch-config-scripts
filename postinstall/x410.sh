set -x
set -e
export DISPLAY=:0.0
socat -b65536 UNIX-LISTEN:/tmp/.X11-unix/X0,fork,mode=777 SOCKET-CONNECT:40:0:x0000x70170000x02000000x00000000 &
xfce4-panel --sm-client-disable --disable-wm-check &