#!/bin/bash
set -e

# Define environment variables or default values
KEYCLOAK_HOME=${KEYCLOAK_HOME:-/opt/keycloak}
KEYCLOAK_CONFIG_FILE=${KEYCLOAK_CONFIG_FILE:-${KEYCLOAK_HOME}/conf/keycloak.conf}
LOG_FILE=${LOG_FILE:-${KEYCLOAK_HOME}/logs/keycloak.log}

# Ensure the Keycloak directory exists
if [ ! -d "$KEYCLOAK_HOME" ]; then
    echo "Error: Keycloak directory not found: $KEYCLOAK_HOME"
    exit 1
fi

# Ensure the configuration file exists
if [ ! -f "$KEYCLOAK_CONFIG_FILE" ]; then
    echo "Error: Keycloak configuration file not found: $KEYCLOAK_CONFIG_FILE"
    exit 1
fi

# Handle different commands
case "$1" in
    start)
        echo "Starting Keycloak..."
        exec "$KEYCLOAK_HOME/bin/kc.sh" start --optimized | tee -a "$LOG_FILE"
        ;;
    start-dev)
        echo "Starting Keycloak in development mode..."
        exec "$KEYCLOAK_HOME/bin/kc.sh" start-dev | tee -a "$LOG_FILE"
        ;;
    help)
        echo "Usage: $0 {start|start-dev|help}"
        ;;
    *)
        # If the command is not recognized, execute it as a fallback
        exec "$@"
        ;;
esac
