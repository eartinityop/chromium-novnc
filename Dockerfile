FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    NOVNC_VERSION=1.4.0

# 1. Base packages + x11vnc + websockify + nginx + openbox
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    websockify \
    nginx \
    openbox \
    wget \
    ca-certificates \
    gnupg \
    gettext-base \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install Google Chrome (real browser, no snap)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. noVNC web client
RUN wget -q "https://github.com/novnc/noVNC/archive/refs/tags/v${NOVNC_VERSION}.tar.gz" -O /tmp/novnc.tar.gz \
    && tar -xzf /tmp/novnc.tar.gz -C /opt/ \
    && mv /opt/noVNC-${NOVNC_VERSION} /opt/novnc \
    && rm /tmp/novnc.tar.gz

# 4. Nginx config (Jlesage style)
COPY default.conf.template /etc/nginx/conf.d/default.conf.template

# 5. Startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Chrome flags for safe root run
ENV CHROME_FLAGS="--no-sandbox --disable-gpu --start-maximized --disable-features=RendererCodeIntegrity"

EXPOSE 8080
ENTRYPOINT ["/start.sh"]
