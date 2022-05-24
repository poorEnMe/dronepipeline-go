#FROM golang:alpine AS build-env
#RUN mkdir /go/src/app && apk update && apk add git
#ADD main.go /go/src/app/
#WORKDIR /go/src/app
#RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o app .
#
#FROM scratch
#WORKDIR /app
#COPY --from=build-env /go/src/app/app .
#ENTRYPOINT [ "./app" ]


FROM golang:alpine as builder
WORKDIR /usr/src/app
#ENV GOPROXY=https://goproxy.cn
#COPY ./go.mod ./
#COPY ./go.sum ./
#RUN go mod download
COPY . .
RUN go build -ldflags "-s -w" -o server

FROM scratch as runner
COPY --from=builder /usr/src/app/server /opt/app/
CMD ["/opt/app/server"]
