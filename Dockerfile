FROM docker.io/library/alpine:edge AS ltex-ls-plus

ARG LTEX_LS_PLUS_RELEASE=18.6.1
ADD https://github.com/ltex-plus/ltex-ls-plus/releases/download/${LTEX_LS_PLUS_RELEASE}/ltex-ls-plus-${LTEX_LS_PLUS_RELEASE}.tar.gz /tmp/ltex-ls-plus.tgz
RUN tar -xzf /tmp/ltex-ls-plus.tgz -C /opt && mv /opt/ltex-ls-plus-${LTEX_LS_PLUS_RELEASE} /opt/ltex-ls-plus

FROM docker.io/library/alpine:edge AS devcontainer-required

RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=cache,target=/var/lib/apk \
    apk add \
        bash \
        findutils \
        sudo \
        openssh-client \
        git \
        zsh \
        libstdc++ \
        ;

RUN echo '#1000 ALL = NOPASSWD: ALL' > /etc/sudoers.d/vscode
RUN adduser -D -u 1000 -s /bin/bash vscode

FROM devcontainer-required

RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=cache,target=/var/lib/apk \
    apk add \
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
