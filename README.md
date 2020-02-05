# Traefik-Proxy

One-step (secure) configuration for [Traefik](https://docs.traefik.io/) edge router.

## Features

Keeping in mind security first, this project ensures:

* The Docker daemon socket is never mounted to traefik or any container with external networking
* HTTPS redirection is automatically configured for all routers
* TLS is always enabled, even locally (can confidently test new services locally without needing a dev config that differs significantly from prod)
* The Traefik dashboard is never launched in insecure mode

Other features include:

* User-friendly 4XX & 5XX status pages
* Pre-configured file provider (for shared routers and middleware) and Docker provider (for everything else)
* Centralized configuration via environment variables in `.env`.

## Getting Started

### Quickstart

```console
$ git clone https://github.com/jamescurtin/traefik-proxy.git
$ cd traefik-proxy
$ make
```

**Note**: When run locally (_e.g._ on `localhost`), Traefik uses a self-signed SSL certificate. Therefore, web-browser security warnings are expected and can be safely bypasssed.

To explore, navigate to:

* [https://whoami.docker.localhost](https://whoami.docker.localhost) ("Hello world" container provided by the creaters of Traefik)
* [https://dashboard.docker.localhost](https://dashboard.docker.localhost) (Traefik configuration dashboard)
* [https://localhost](https://localhost) (Doesn't match any routing rule, so will display a user-friendly HTTP error code)

### Details

By running the `make` command, an external Docker network, `traefik`, will be created, which can be used to link any Docker container to Traefik. It also checks for the existence of `.env` and `acme/acmme.json`, creating them if they do not exist.
