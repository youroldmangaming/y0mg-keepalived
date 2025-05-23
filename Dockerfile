FROM alpine:3.19

# Install keepalived and required dependencies
RUN apk add --no-cache \
    keepalived \
    ipvsadm \
    iproute2 \
    iptables \
    tcpdump \
    curl \
    nano \
    && rm -rf /var/cache/apk/*

# Create keepalived user and group
RUN addgroup -g 1000 keepalived && \
    adduser -D -u 1000 -G keepalived keepalived

# Create necessary directories
RUN mkdir -p /etc/keepalived /var/log/keepalived /var/run/keepalived

# Create a default keepalived configuration
COPY keepalived.conf /etc/keepalived/keepalived.conf

# Set proper permissions
RUN chown -R keepalived:keepalived /etc/keepalived /var/log/keepalived /var/run/keepalived

# Expose VRRP multicast
EXPOSE 112

# Health check script
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD /usr/local/bin/healthcheck.sh

# Run keepalived in foreground
CMD ["keepalived", "--dont-fork", "--log-console", "--log-detail", "--dump-conf"]


