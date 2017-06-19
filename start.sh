#!/bin/bash

exit_handler() {
    echo "Shutdown signal received"
    echo "Exiting via shutdown signal . . ."
    exit
}

trap 'exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM

FACTORIO_PATH="/factorio"
FACTORIO_BIN="${FACTORIO_PATH}/bin/x64/factorio"
FACTORIO_DATA="${FACTORIO_PATH}/data"
FACTORIO_SETTINGS="${FACTORIO_DATA}/server-settings.json"
FACTORIO_SAVES="${FACTORIO_PATH}/saves"
FACTORIO_LEVEL="${FACTORIO_SAVES}/${WORLD_NAME}.zip"
FACTORIO_RCON_PASSWORD=${FACTORIO_RCON_PASSWORD:-admin}

if [ ! -f ${FACTORIO_SETTINGS} ]; then
    cp ${FACTORIO_DATA}/server-settings.example.json ${FACTORIO_SETTINGS}
fi

if [ ! -f ${FACTORIO_LEVEL} ]; then
    OPTS="--create ${FACTORIO_LEVEL}"
    OPTS="${OPTS} --server-settings ${FACTORIO_SETTINGS}"
    ${FACTORIO_BIN} ${OPTS}
fi

OPTS="--start-server ${FACTORIO_LEVEL}"
OPTS="${OPTS} --server-settings ${FACTORIO_SETTINGS}"
OPTS="${OPTS} --port 34197 --bind 0.0.0.0"
OPTS="${OPTS} --rcon-port 34198 --rcon-password ${FACTORIO_RCON_PASSWORD}"

exec ${FACTORIO_BIN} ${OPTS}
