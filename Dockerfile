ARG ALPINE_VERSION=3.23.3


FROM scratch AS scratch-labels

LABEL org.opencontainers.image.authors="0xRamdek@protonmail.com"
LABEL org.opencontainers.image.description="Manalyze wrapper image"


#
# Build
#

FROM alpine:${ALPINE_VERSION} AS build

COPY Manalyze /Manalyze
COPY build /build

RUN /build/global-install.sh


#
# Final image
#

FROM scratch-labels

COPY --from=build /distroless_fs /

CMD ["/entrypoint"]
