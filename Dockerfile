FROM asciidoctor/docker-asciidoctor:latest

# Install additional dependencies for build and verification
RUN apk add --no-cache \
    grep \
    bash \
    make \
    inotify-tools \
    graphviz \
    openjdk11-jre \
    wget \
    nodejs \
    npm \
    && rm -rf /var/cache/apk/*

# Install Chromium and dependencies for Puppeteer/mermaid-cli
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

# Set Puppeteer environment variables to use system Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install mermaid-cli globally
RUN npm install -g @mermaid-js/mermaid-cli

# Verify mmdc command is available
RUN mmdc --version

# Install syntax highlighter gems
RUN gem install rouge --version '~> 3.30'

# Install PlantUML
RUN wget -O /usr/local/bin/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2023.13/plantuml-1.2023.13.jar \
    && echo '#!/bin/sh' > /usr/local/bin/plantuml \
    && echo 'java -jar /usr/local/bin/plantuml.jar "$@"' >> /usr/local/bin/plantuml \
    && chmod +x /usr/local/bin/plantuml

# Set working directory
WORKDIR /documents

# Default command
CMD ["/bin/bash"]
