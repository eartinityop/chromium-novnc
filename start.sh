#!/bin/bash
# Render se PORT variable le, local test ke liye 8080
export PORT="${PORT:-8080}"

# Nginx config mein port inject karo
envsubst '$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Xvnc: X server + VNC + WebSocket (:0 pe, websocket 5901)
Xvnc :0 -geometry 1280x720 -depth 24 -SecurityTypes None -websocket 5901 &
sleep 2

# Optional window manager for better Chrome UI
openbox --replace &
sleep 1

# Chromium launch
export DISPLAY=:0
chromium-browser $CHROMIUM_FLAGS &

# Nginx foreground
nginx -g "daemon off;"
