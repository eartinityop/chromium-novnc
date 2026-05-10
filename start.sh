#!/bin/bash

# Render PORT environment variable ko pakdo (default 8080 for local testing)
PORT=${PORT:-8080}

# Virtual display start karo (screen :0, 1280x720)
Xvfb :0 -screen 0 1280x720x16 &
sleep 1

# VNC server start karo on display :0
x11vnc -display :0 -forever -nopw -quiet &
sleep 1

# noVNC ke through websockify – ye VNC ko WebSocket se bridge karega
# aur noVNC client bhi serve karega
websockify --web /usr/share/novnc $PORT localhost:5900 &

# Browser launch karo (Chromium)
chromium-browser --display=:0 $CHROMIUM_FLAGS &
# Firefox ke liye: firefox --display=:0 --kiosk https://example.com &

# Script ko alive rakhne ke liye wait karo
wait
