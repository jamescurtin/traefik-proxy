#!/usr/bin/env bash

PASSWORD_LENGTH=50
# shellcheck disable=SC2207
DEFAULT_SECRETS_FILES=($(./bin/find-placeholder-secrets.sh))

for i in "${DEFAULT_SECRETS_FILES[@]}"; do
	randomly_generated_pass=$(head -c $PASSWORD_LENGTH /dev/random | base32)
	echo "${randomly_generated_pass:0:PASSWORD_LENGTH}" >"${i}"
	echo "Replacing password in ${i}"
done
