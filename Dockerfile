from golang:1.17 as builder

RUN apt update && apt install clang -y

COPY . /go/podcast

# install source of target
RUN mkdir ~/gopath && \
    export GOPATH="$HOME/gopath" && \
    export PATH="$PATH:$GOPATH/bin" && \
    cd podcast && \
    go install -tags production github.com/eduncan911/podcast && \
    go get github.com/dvyukov/go-fuzz/go-fuzz github.com/dvyukov/go-fuzz/go-fuzz-build && \
    go-fuzz-build -libfuzzer --func FuzzPodcastEncode -o fuzz_podcast_encoder.a . && \
    clang -fsanitize=fuzzer fuzz_podcast_encoder.a  -o fuzz_podcast_encoder && \
    cp fuzz_podcast_encoder /fuzz_podcast_encoder

# chain to builder
FROM golang:1.23
COPY --from=builder /fuzz_podcast_encoder /
