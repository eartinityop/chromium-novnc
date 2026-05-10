#!/bin/bash
# Render ka PORT pakdo, local test ke liye 8080
export PORT="${PORT:-8080}"

# Nginx config mein PORT inject karo
envsubst '$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Virtual framebuffer (X server) start karo
Xvfb :0 -screen 0 1280x720x24 &
sleep 1

# Openbox window manager (UI behtar dikhega)
openbox --replace &
sleep 1

# x11vnc (VNC server) – :0 display, port 5900 pe
x11vnc -display :0 -forever -nopw -quiet &
sleep 1

# websockify – bridge from WS port 5901 to VNC port 5900
websockify 5901 localhost:5900 &
sleep 1

# Google Chrome launch (DISPLAY=:0)
export DISPLAY=:0
google-chrome-stable $CHROME_FLAGS https://example.com &

# Nginx foreground (isse container alive rahega)
nginx -g "daemon off;"
