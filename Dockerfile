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
    make

WORKDIR /build
RUN mkdir lib bin www && \
    cp /lib/ld-musl-* lib && \
    cp /mjpg-streamer-master/mjpg-streamer-experimental/www/* www && \
    cp /mjpg-streamer-master/mjpg-streamer-experimental/*.so lib && \
    cp /mjpg-streamer-master/mjpg-streamer-experimental/mjpg_streamer bin

FROM scratch
ENV LD_LIBRARY_PATH=/lib
COPY --from=build /build /
ENTRYPOINT ["/bin/mjpg_streamer"]
