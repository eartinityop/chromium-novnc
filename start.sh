#!/bin/bash
# Render ka PORT lein, local test ke liye 8080
export PORT="${PORT:-8080}"

# Nginx config mein PORT inject karo
envsubst '$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Virtual framebuffer (X server) start karo
Xvfb :0 -screen 0 1280x720x24 &
sleep 1

# *** Yahan DISPLAY set karo, sabse pehle! ***
export DISPLAY=:0

# Ab openbox window manager (DISPLAY mil gaya)
openbox --replace &
sleep 1

# x11vnc (VNC server) – display :0 pe, port 5900
x11vnc -display :0 -forever -nopw -quiet &
sleep 1

# websockify – WebSocket bridge 5901 → 5900
websockify 5901 localhost:5900 &
sleep 1

# Google Chrome launch (ab DISPLAY pehle se hai, flag use karega)
google-chrome-stable $CHROME_FLAGS https://example.com &

# Nginx foreground (container alive)
nginx -g "daemon off;"
