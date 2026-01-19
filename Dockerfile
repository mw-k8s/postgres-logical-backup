FROM ubuntu:24.04
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update     \
    && apt-get install --no-install-recommends -y \
        apt-utils \
        ca-certificates \
        lsb-release \
        pigz \
        python3-pip \
        python3-setuptools \
        curl \
        jq \
        gnupg \
        gcc \
        libffi-dev \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && pip3 install --no-cache-dir awscli --upgrade --break-system-packages \
    && pip3 install --no-cache-dir gsutil --upgrade --break-system-packages \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && cat /etc/apt/sources.list.d/pgdg.list \
    && curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg \
    && apt-get update \
    && apt-get install --no-install-recommends -y  \
        postgresql-client-18  \
        postgresql-client-17  \
        postgresql-client-16  \
        postgresql-client-15  \
    && apt-get clean \
    && apt-get purge -y --auto-remove gcc gnupg curl apt-utils libffi-dev \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/*

COPY dump.sh ./
ENV PG_DIR=/usr/lib/postgresql
ENTRYPOINT ["/dump.sh"]
