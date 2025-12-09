#!/usr/bin/env bash

chown -R gmod:gmod /data

# run server file validation and install if needed

exec "/install_server.sh"

