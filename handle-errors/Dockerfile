FROM golang:1.21-alpine AS builder

ENV USER=appuser
ENV UID=10001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

WORKDIR $GOPATH/src
COPY main.go go.mod ./

RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags='-w -s -extldflags "-static"' -a \
    -o /go/bin/serve .

FROM scratch

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /go/bin/serve /go/bin/serve

COPY status.html status.html

USER appuser:appuser
EXPOSE 8080

ENTRYPOINT ["/go/bin/serve"]
