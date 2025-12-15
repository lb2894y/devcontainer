ARG ALPINE_RELEASE=3.23

FROM docker.io/library/alpine:${ALPINE_RELEASE}

RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=cache,target=/var/lib/apk \
    apk add merge-usr && merge-usr && apk del merge-usr

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
        java-jre-headless \
	;

RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=cache,target=/var/lib/apk \
    apk add \
        texlive \
        texlive-luatex \
        texlive-binextra \
        texlive-latexrecommended \
        texlive-latexextra \
        texlive-plaingeneric \
        ;

ARG LTEX_LS_PLUS_RELEASE=18.6.1
RUN (set -o pipefail; wget -qO- "https://github.com/ltex-plus/ltex-ls-plus/releases/download/${LTEX_LS_PLUS_RELEASE}/ltex-ls-plus-${LTEX_LS_PLUS_RELEASE}.tar.gz" | tar -xzC /opt) && mv /opt/ltex-ls-plus-${LTEX_LS_PLUS_RELEASE} /opt/ltex-ls-plus

RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=cache,target=/var/lib/apk \
    apk add util-linux-misc && \
        hardlink --respect-xattrs --ignore-time --mount /usr /opt && \
        apk del util-linux-misc

USER 1000
