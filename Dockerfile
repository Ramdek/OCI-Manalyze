ARG ALPINE_VERSION=3.23.3


FROM scratch AS scratch-labels

LABEL org.opencontainers.image.authors="0xRamdek@protonmail.com"
LABEL org.opencontainers.image.description="Manalyze wrapper image"
LABEL org.opencontainers.image.source = "https://github.com/Ramdek/OCI-Manalyze"

ENV VIRUS_TOTAL_API_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"


#
# Dev
#

FROM alpine:${ALPINE_VERSION} AS dev

COPY Manalyze /Manalyze
COPY build /build

RUN /build/global-install.sh

CMD ["/entrypoint"]


#
# Build
#

FROM dev AS build

RUN /build/global-install.sh distroless


#
# Final image
#

FROM scratch-labels AS final

COPY --from=build /distroless_fs /

CMD ["/entrypoint"]
