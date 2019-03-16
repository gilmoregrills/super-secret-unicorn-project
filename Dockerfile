FROM golang:latest

COPY main.go assets/ .

ENTRYPOINT go run .

EXPOSE 8080