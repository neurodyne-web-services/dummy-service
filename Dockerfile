FROM golang:alpine3.21 AS build
WORKDIR /go/src/github.com/neurodyne-web-services/dummy-service

RUN go env -w GOCACHE=/go-cache && go env -w GOMODCACHE=/gomod-cache

COPY go.mod main.go ./
RUN --mount=type=cache,target=/go-cache \
  --mount=type=cache,target=/gomod-cache \
  go mod download -x

RUN --mount=type=cache,target=/go-cache \
  --mount=type=cache,target=/gomod-cache \
  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app -ldflags="-s -w"

FROM scratch
COPY --from=build /go/src/github.com/neurodyne-web-services/dummy-service/app /bin/app
EXPOSE 8080
CMD ["/bin/app"]
