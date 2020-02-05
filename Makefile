.PHONY: create-network
.create-network:
	@docker network create traefik 2> /dev/null && echo "Created network traefik" || echo "Network traefik already exists"

.PHONY: configure-local-settings
.configure-local-settings:
	@touch -a acme/acme.json && chmod 600 acme/acme.json
	@cp -n .env.example .env || true

.PHONY: build
.build:
	@echo "Building docker images..." && docker-compose build 2>&1 >/dev/null

.PHONY: up
.up:
	@echo "Starting service..." && source .env && docker-compose up -d

.PHONY: clean
.clean:
	docker-compose down

.PHONY: target
target: .create-network .configure-local-settings .build .clean .up
