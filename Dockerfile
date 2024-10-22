FROM debian:12-slim AS build
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    gcc \
    pkg-config \
    libev-dev \
    libx11-dev \
    libxi-dev \
    libc6-dev
COPY Makefile xmousepasteblock.c .
RUN make && make install

FROM scratch AS export
COPY --from=build /usr/bin/xmousepasteblock .

ENTRYPOINT []
