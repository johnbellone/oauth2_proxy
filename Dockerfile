FROM golang:1.10-alpine3.7 AS build

ENV GOPATH="/go"
ENV PATH="$GOPATH/bin:$PATH"

# Build the latest version of oauth2_proxy from HEAD commit.
RUN apk add --no-cache git make
RUN go get github.com/golang/dep/cmd/dep
COPY Gopkg.lock Gopkg.toml /go/src/github.com/bitly/oauth2_proxy/
WORKDIR /go/src/github.com/bitly/oauth2_proxy
COPY . /go/src/github.com/bitly/oauth2_proxy
RUN dep ensure \
    && go build -ldflags="-s -w" .

FROM alpine:3.7

COPY --from=build /go/src/github.com/bitly/oauth2_proxy/oauth2_proxy /sbin/oauth2_proxy

ENTRYPOINT ["/sbin/oauth2_proxy"]
CMD ["--help"]
