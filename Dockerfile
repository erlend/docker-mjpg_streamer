FROM alpine AS build

RUN apk add --no-cache \
      curl \
      cmake \
      build-base \
      linux-headers \
      libjpeg-turbo-dev \
      v4l-utils-dev

RUN curl -L https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz \
    | tar zx && \
    cd mjpg-streamer-master/mjpg-streamer-experimental && \
    make && \
    make install

FROM scratch
COPY --from=build /usr/local/bin/mjpg_streamer /usr/local/bin/mjpg_streamer
COPY --from=build /usr/local/share/mjpg-streamer /usr/local/share/mjpg-streamer
COPY --from=build /usr/local/lib/mjpg-streamer /usr/local/lib/mjpg-streamer
COPY --from=build /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
ENTRYPOINT ["/usr/local/bin/mjpg_streamer"]
