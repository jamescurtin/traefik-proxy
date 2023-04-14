#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# shellcheck disable=SC2207
DEFAULT_SECRETS_FILES=($("${SCRIPT_DIR}"/../../bin/find-placeholder-secrets.sh))

if [ ${#DEFAULT_SECRETS_FILES[@]} -eq 0 ]; then
	exit 0
else
	echo "FAIL: Placeholder secrets detected..."
	exit 1
fi
