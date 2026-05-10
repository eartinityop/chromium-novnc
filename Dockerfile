FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Dependencies + Xvfb + VNC + noVNC + websockify + browser
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    chromium-browser \
    # Firefox ke liye ye line use kar (chromium ki jagah):
    # firefox \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# noVNC default port Render set karega
EXPOSE 8080

COPY start.sh /start.sh
RUN chmod +x /start.sh

# Chromium ko non-root chalane ke liye --no-sandbox dena hoga
ENV CHROMIUM_FLAGS="--no-sandbox --disable-gpu --start-maximized https://example.com"

ENTRYPOINT ["/start.sh"]
