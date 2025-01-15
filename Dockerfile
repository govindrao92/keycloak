# Base image
FROM quay.io/centos/centos:stream9


# Install necessary packages and Java 21
RUN dnf -y update && \
    dnf -y install java-21-openjdk wget unzip && \
    dnf clean all

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-21.0.5.0.11-2.el9.x86_64\
    PATH=$JAVA_HOME/bin:$PATH \
    KEYCLOAK_HOME=/opt/keycloak

ENV PATH=$JAVA_HOME/bin:$KEYCLOAK_HOME/bin:$PATH

# Copy the CARoot.key certificate into the container
COPY ApolloWildCA.key /etc/pki/ca-trust/source/anchors/ApolloWildCA.key

# Update the CA store
RUN update-ca-trust

COPY ./keycloak-26.0.7 /opt/keycloak
# Expose Keycloak ports
EXPOSE 8080 5441

# Set working directory
WORKDIR $KEYCLOAK_HOME

# Add entrypoint script to start Keycloak
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Entry point
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command
CMD ["start"]

