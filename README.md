# Traefik-Proxy

One-step (secure) configuration for [Traefik](https://docs.traefik.io/) edge router using [Authelia](https://www.authelia.com/) for authentication.

## Features

Keeping in mind security first, this project ensures:

* The Docker daemon socket is never mounted to traefik or any container with external networking (See the [risks](https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface) of exposing the Docker daemon)
* HTTPS redirection is automatically configured for all routers
* TLS is always enabled, even locally (can confidently test new services locally without needing a dev config that differs significantly from prod)
* The Traefik dashboard is never launched in insecure mode

Other features include:

* Self-hosted SSO authentication ([Authelia](https://www.authelia.com/)), including support for security keys and one-time password generators
* User-friendly 4XX & 5XX status pages
* Pre-configured file provider (for shared routers and middleware) and Docker provider (for everything else)
* Centralized configuration via environment variables and Docker secrets

## Getting Started

### Quickstart

```console
$ git clone https://github.com/jamescurtin/traefik-proxy.git
$ cd traefik-proxy
$ make
```

Running `make` creates an `.env` file and the `authelia/secrets` directory. The
`.env` file should be updated to include hostnames for additional hosts that are
configured. The `authelia/secrets` directory contains secrets for configuring
all services. The default values should be changed before deploying.

There are additional configuration files that need to be customized. All places where
customization is necessary are marked with `CHANGEME` comments.

The command will also create the external docker network `traefik`. Other docker
services that you plan to expose via Traefik should be added to this network.

## Users

This is configured to use two-factor auth. When running the project out of the box (_i.e._ without having configured the SMTP notifier), you will have to check the file `authelia/notification.txt` to get the registration link for configuring 2FA.

Authelia users are defined in `authelia/users.yml`.

By default, this ships with two users (both have the password `insecure`).
One is a member of a group called `admin`, and the other has no group memberships.

### Creating a user

You will need to create a new user and add them to `authelia/users.yml`.
As a convenience, you can run the command

```bash
$ bin/create-new-user
Enter username:
...
```

which will prompt for the user's information, and add an entry to the user file
(with a hashed password).

**Make sure to remove the default users before deploying!**

**Note**: When run locally (_e.g._ on `localhost`), Traefik uses a self-signed SSL certificate. Therefore, web-browser security warnings are expected and can be safely bypassed.

To explore, navigate to:

* [https://whoami.docker.localhost](https://whoami.docker.localhost) ("Hello world" container provided by the creators of Traefik)
* [https://traefik.docker.localhost](https://traefik.docker.localhost) (Traefik configuration dashboard)
* [https://auth.docker.localhost](https://auth.docker.localhost) (SSO Auth service)
* [https://docker.localhost](https://docker.localhost) (Doesn't match any routing rule, so will display a user-friendly HTTP error code)

### Details

By running the `make` command, an external Docker network, `traefik`, will be created, which can be used to link any Docker container to Traefik. It also checks for the existence of `.env` and `acme/acme.json`, creating them if they do not exist.
