FROM golang:1.19 as build-env

ENV CGO_ENABLED=0

WORKDIR /tmp/github.com/petethepig/revive-action-tmp
RUN go mod init github.com/petethepig/revive-action-tmp
RUN go mod edit -replace=github.com/mgechev/revive=github.com/pyroscope-io/revive@v1.0.6-0.20210330033039-4a71146f9dc1
RUN go install -v github.com/mgechev/revive@v1.0.6

WORKDIR /tmp/github.com/morphy2k/revive-action
COPY . .

RUN go install

FROM alpine:3.13.5

LABEL repository="https://github.com/morphy2k/revive-action"
LABEL homepage="https://github.com/morphy2k/revive-action"
LABEL maintainer="Markus Wiegand <mail@morphy2k.dev>"

LABEL com.github.actions.name="Revive Action"
LABEL com.github.actions.description="Lint your Go code with Revive"
LABEL com.github.actions.icon="code"
LABEL com.github.actions.color="blue"

COPY --from=build-env ["/go/bin/revive", "/go/bin/revive-action", "/bin/"]
COPY --from=build-env /tmp/github.com/morphy2k/revive-action/entrypoint.sh /

RUN apk add --no-cache bash

ENTRYPOINT ["/entrypoint.sh"]
