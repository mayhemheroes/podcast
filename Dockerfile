FROM golang:1.20 AS builder

COPY . /go/src/podcast
WORKDIR /go/src/podcast

RUN go test -tags gofuzz -c -fuzz . -o /fuzz_podcast_encoder

FROM golang:1.20
COPY --from=builder /fuzz_podcast_encoder /
CMD ["/fuzz_podcast_encoder", "-test.fuzz=FuzzPodcastEncodeNative", "-test.fuzzcachedir=/tmp/fuzz"]
