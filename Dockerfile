# Multi-platform Dockerfile for kafka-lag-exporter
# This Dockerfile expects the application to be pre-built using sbt stage
# and the staged files to be in target/universal/stage directory

# Use non-alpine version for better multi-platform support (amd64 + arm64)
FROM eclipse-temurin:17-jre

# Bash is already included in this image

# Create non-root user (Ubuntu/Debian syntax)
RUN useradd --system --uid 1001 --create-home --shell /bin/bash kafkalagexporter

# Set working directory
WORKDIR /opt/docker

# Copy staged application files
# The target/universal/stage directory should be built before docker build
COPY --chown=1001:0 target/universal/stage /opt/docker/

# Set proper permissions for OpenShift compatibility
RUN chgrp -R 0 /opt/docker && chmod -R g=u /opt/docker

# Switch to non-root user
USER 1001

# Expose application port
EXPOSE 8000

# OCI Image Spec Annotations will be added via --label flags during build

# Run the application
CMD ["/opt/docker/bin/kafka-lag-exporter", "-Dconfig.file=/opt/docker/conf/application.conf", "-Dlogback.configurationFile=/opt/docker/conf/logback.xml"]
