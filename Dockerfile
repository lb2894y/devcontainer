ARG ALPINE_RELEASE=3.23

FROM docker.io/library/alpine:${ALPINE_RELEASE} AS ltex-ls-plus

ARG LTEX_LS_PLUS_RELEASE=18.6.1
ADD https://github.com/ltex-plus/ltex-ls-plus/releases/download/${LTEX_LS_PLUS_RELEASE}/ltex-ls-plus-${LTEX_LS_PLUS_RELEASE}.tar.gz /tmp/ltex-ls-plus.tgz
RUN tar -xzf /tmp/ltex-ls-plus.tgz -C /opt && mv /opt/ltex-ls-plus-${LTEX_LS_PLUS_RELEASE} /opt/ltex-ls-plus && rm /tmp/ltex-ls-plus.tgz

FROM docker.io/library/alpine:${ALPINE_RELEASE}

RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=cache,target=/var/lib/apk \
    apk add \
        sudo \
        bash \
        && adduser -D -u 1000 -s /bin/bash vscode \
        && echo '#1000 ALL = NOPASSWD: ALL' > /etc/sudoers.d/vscode

RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=cache,target=/var/lib/apk \
    apk add \
        findutils \
        openssh-client \
        git \
        zsh \
        libstdc++ \
        biber \
        texlive \
        texlive-luatex \
        texlive-binextra \
        texlive-latexrecommended \
        texlive-latexextra \
        texlive-plaingeneric \
        java-jre-headless \
        ;

COPY --from=ltex-ls-plus /opt/ltex-ls-plus /opt/ltex-ls-plus

USER 1000
