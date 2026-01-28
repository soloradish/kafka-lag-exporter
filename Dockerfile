# Multi-platform Dockerfile for kafka-lag-exporter
# This Dockerfile expects the application to be pre-built using sbt stage
# and the staged files to be in target/universal/stage directory

FROM eclipse-temurin:17-jre-alpine

# Install bash
RUN apk add --no-cache bash

# Create non-root user
RUN adduser -S -u 1001 kafkalagexporter

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
