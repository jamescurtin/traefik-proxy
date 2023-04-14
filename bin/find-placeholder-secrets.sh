#!/usr/bin/env bash
CURRENT_SCRIPT=$(basename "$0")

grep -HRl --exclude-dir="*/authelia/secrets.example" --exclude="*${CURRENT_SCRIPT}" "default-secret-to-be-replaced"
