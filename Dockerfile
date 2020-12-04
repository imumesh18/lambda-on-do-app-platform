FROM golang:1.15.5-buster as go-builder
WORKDIR /lambda-on-do-app-platform
COPY . /lambda-on-do-app-platform/
ADD aws-lambda-rie /aws-lambda-rie
RUN mkdir -p /opt/extensions
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

FROM scratch
COPY --from=go-builder /opt/extensions /opt/extensions
COPY --from=go-builder /aws-lambda-rie /aws-lambda-rie
COPY --from=go-builder /lambda-on-do-app-platform/app /app
ENTRYPOINT ["/aws-lambda-rie","/app"]
