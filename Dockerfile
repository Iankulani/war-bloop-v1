# WAR-BLOOP-V1 - Alpine Linux Docker Image
# Author: Ian Carter Kulani
# Version: 1.0.0

FROM alpine:3.19

LABEL maintainer="Ian Carter Kulani"
LABEL description="WAR-BLOOP-V1 - Ultimate Cybersecurity Command & Control Platform"
LABEL version="1.0.0"

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    python3-dev \
    build-base \
    linux-headers \
    openssl-dev \
    libffi-dev \
    libpcap-dev \
    nmap \
    nmap-scripts \
    curl \
    wget \
    netcat-openbsd \
    bind-tools \
    traceroute \
    mtr \
    openssh-client \
    whois \
    git \
    bash \
    tini \
    chromium \
    chromium-chromedriver \
    ttf-freefont \
    freetype-dev \
    libpng-dev \
    jpeg-dev \
    zlib-dev \
    && rm -rf /var/cache/apk/*

# Create app directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir -r requirements.txt

# Copy application files
COPY war_bloop_v1.py .
COPY requirements-check.py .
COPY test-commands.py .
COPY setup.py .

# Create necessary directories
RUN mkdir -p /app/.war_bloop_v1/{payloads,scans,phishing_pages,captured_credentials,ssh_keys,traffic_logs,keylogs,keylog_screenshots,dos_logs,agents,c2_logs,modules,network_monitor,keylog_exfil,deployments,domain_hosting,cracking,docker_scans} && \
    mkdir -p /app/war_bloop_reports/{pdf_reports,graphics,charts}

# Create non-root user for security (optional, uncomment if needed)
# RUN adduser -D -s /bin/bash warb
# RUN chown -R warb:warb /app
# USER warb

# Expose ports
# 5000 - Web Dashboard
# 8080 - Phishing Server
EXPOSE 5000 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python3 -c "import sys; sys.exit(0)" || exit 1

# Use tini for proper signal handling
ENTRYPOINT ["/sbin/tini", "--"]

# Default command
CMD ["python3", "war_bloop_v1.py"]
