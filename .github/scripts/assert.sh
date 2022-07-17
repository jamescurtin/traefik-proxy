#!/usr/bin/env bash

host=$1
expected_text=$2

if [ -z "$3" ]; then
	header=""
else
	header="Proxy-Authorization: Basic $3"
fi

result=$(curl -skH "${header}" --resolve "${host}":443:127.0.0.1 https://"${host}")
if (echo "${result}" | grep -q "${expected_text}"); then
	echo "Pass"
else
	echo "Failed! Response:"
	echo
	echo "${result}"
	exit 1
fi
