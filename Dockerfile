FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    NOVNC_VERSION=1.4.0

# System packages: Xvnc (TigerVNC), nginx, openbox, browser
RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server \
    nginx \
    openbox \
    chromium-browser \
    wget \
    ca-certificates \
    gettext-base \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download & extract noVNC web client
RUN wget -q "https://github.com/novnc/noVNC/archive/refs/tags/v${NOVNC_VERSION}.tar.gz" -O /tmp/novnc.tar.gz \
    && tar -xzf /tmp/novnc.tar.gz -C /opt/ \
    && mv /opt/noVNC-${NOVNC_VERSION} /opt/novnc \
    && rm /tmp/novnc.tar.gz

# Nginx config template
COPY default.conf.template /etc/nginx/conf.d/default.conf.template

# Start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Chromium flags (non-root)
ENV CHROMIUM_FLAGS="--no-sandbox --disable-gpu --disable-features=RendererCodeIntegrity --start-maximized"

ENTRYPOINT ["/start.sh"]
