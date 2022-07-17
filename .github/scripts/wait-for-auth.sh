#!/usr/bin/env bash

wait_for_it() {
	status_code=$(curl -sk --output /dev/null --write-out "%{http_code}" --resolve auth.docker.localhost:443:127.0.0.1 https://auth.docker.localhost)
	if ((status_code != 200)); then
		return 0
	else
		return 1
	fi
}

counter=15
while wait_for_it; do
	if ((counter == 0)); then
		echo "Timeout! Authelia didn't start in time"
		exit 1
	fi
	echo "Waiting for authelia to start up... ($counter more tries remaining)"
	sleep 5
	((counter -= 1))
done

echo "Authelia is up!"
