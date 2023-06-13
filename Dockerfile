# Set versions
ARG ALPINE_VERSION=3.18
ARG GOLANG_VERSION=1.20.5

# First stage to build
FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} as builder

RUN cd / && \
    apk update && \
    apk add --no-cache git ca-certificates make tzdata && \
    git clone https://github.com/inCaller/prometheus_bot && \
    cd /prometheus_bot && \
    go get -d -v && \
    CGO_ENABLED=0 GOOS=linux go build -v -a -installsuffix cgo -o prometheus_bot

# Second stage to run
FROM alpine:${ALPINE_VERSION}

COPY --from=builder /prometheus_bot/prometheus_bot /

RUN apk add --no-cache ca-certificates tzdata

EXPOSE 9087

CMD "/prometheus_bot"
