# syntax=docker/dockerfile:latest

FROM alpine:latest AS build
WORKDIR /work

RUN apk update && apk upgrade && apk add go

COPY main.go ./
RUN go build -o ./app ./main.go


FROM alpine:latest
WORKDIR /work
COPY --from=build /work/app ./
RUN <<EOS
  echo hello
EOS
ENTRYPOINT ["/work/app"]
