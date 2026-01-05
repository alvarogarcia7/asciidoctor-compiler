FROM asciidoctor/docker-asciidoctor:latest

# Install additional dependencies for build and verification
RUN apk add --no-cache \
    grep \
    bash \
    make \
    inotify-tools \
    && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /documents

# Default command
CMD ["/bin/bash"]
