FROM gcc:latest

MAINTAINER OlaRonning ronning@protonmail.com

WORKDIR /
ENV CMDSTAN_URL "https://api.github.com/repos/stan-dev/cmdstan/releases/latest"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl jq

RUN curl --silent $CMDSTAN_URL | \
    jq .assets[0].browser_download_url | xargs curl -L --output cmdstan.tar.gz --silent --url; \
    tar -xf cmdstan.tar.gz; \
    rm cmdstan.tar.gz; \
    mv "cmdstan-$(curl --silent $CMDSTAN_URL | jq .name | tr -d v | tr -d \")" cmdstan

WORKDIR /cmdstan
RUN make build -j$(nproc --all)

WORKDIR /cmdstan/bin
RUN mv diagnose /bin/; mv print /bin/; mv stanc /bin/; mv stansummary /bin/

WORKDIR /
RUN rm -r cmdstan
