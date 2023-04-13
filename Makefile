.PHONY: create-network
.create-network:
	@docker network create traefik 2> /dev/null && echo "Created network traefik" || echo "Network traefik already exists"

.PHONY: configure-local-settings
.configure-local-settings:
	@mkdir -p acme
	@touch -a acme/acme.json && chmod 600 acme/acme.json
	@cp -n .env.example .env || true
	@cp -n authelia/users.yml.example authelia/users.yml || true
	@cp -n -R authelia/secrets.example authelia/secrets && chmod 600 authelia/secrets/* || true

.PHONY: build
.build:
	@echo "Building docker images..." && docker compose build 2>&1 >/dev/null

.PHONY: up
.up:
	@echo "Starting service..." && docker compose up -d

.PHONY: down
.down:
	@docker compose down -v || true

.PHONY: target
target: .create-network .configure-local-settings .build .down .up

.PHONY: clean
clean:

	docker compose down -v || true
	rm -f acme/*
	rm -rf authelia/secrets
	rm -rf authelia/users.yml
	rm -f .env
