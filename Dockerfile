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
    && rm -rf /var/cache/apk/*

# Install PlantUML
RUN wget -O /usr/local/bin/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2023.13/plantuml-1.2023.13.jar \
    && echo '#!/bin/sh' > /usr/local/bin/plantuml \
    && echo 'java -jar /usr/local/bin/plantuml.jar "$@"' >> /usr/local/bin/plantuml \
    && chmod +x /usr/local/bin/plantuml

# Set working directory
WORKDIR /documents

# Default command
CMD ["/bin/bash"]
