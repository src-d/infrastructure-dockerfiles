FROM golang:1.12-alpine as build

RUN apk add --no-cache git

RUN mkdir -p /go/src/github.com/wrouesnel/postgres_exporter
WORKDIR /go/src/github.com/wrouesnel/postgres_exporter

RUN git clone https://github.com/wrouesnel/postgres_exporter.git  ./
RUN git checkout 734dc50972d94925437180b51b91efe9d109df52

ENV VERSION_SHORT=dev

RUN go run mage.go binary

FROM scratch

COPY --from=build /go/src/github.com/wrouesnel/postgres_exporter/bin/postgres_exporter_dev_linux-amd64/postgres_exporter /postgres_exporter

EXPOSE 9187

ENTRYPOINT [ "/postgres_exporter" ]
