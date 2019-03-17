FROM golang:latest

COPY ./main.go /go/main.go

COPY ./assets/ /go/assets/

CMD ["go", "run", "/go/main.go"]

EXPOSE 8080