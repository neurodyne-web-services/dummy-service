FROM golang:1.21-alpine AS build
WORKDIR /go/src/github.com/neurodyne-web-services/dummy-service

COPY go.mod main.go ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app -ldflags="-s -w"

FROM scratch
COPY --from=build /go/src/github.com/neurodyne-web-services/dummy-service/app /bin/app
EXPOSE 8080
CMD ["/bin/app"]
