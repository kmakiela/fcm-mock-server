FROM debian:stretch as builder

ARG ERLANG_VERSION=1:22.0.7-1
ARG ELIXIR_VERSION=1.9.1-1
ARG MIX_ENV=prod

ENV ERLANG_VERSION ${ERLANG_VERSION}
ENV ELIXIR_VERSION ${ELIXIR_VERSION}
ENV MIX_ENV ${MIX_ENV}

SHELL ["/bin/bash", "-c"]

# Locales
RUN apt-get update && \
        apt-get install --yes locales && \
        sed -i '/^#.* en_US.UTF-8 /s/^#//' /etc/locale.gen && \
        locale-gen

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en"

# Install build utils
RUN apt-get install --yes \
        wget \
        unzip \
        build-essential \
        apt-transport-https \
        git

# Install Erlang & Elixir
RUN echo "deb https://packages.erlang-solutions.com/debian stretch contrib" >> /etc/apt/sources.list && \
        cat /etc/apt/sources.list && \
        wget --quiet -O - https://packages.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add - && \
        apt-get update && \
        apt-get install --yes \
        esl-erlang=$ERLANG_VERSION \
        elixir=$ELIXIR_VERSION

WORKDIR /build

COPY mix.exs mix.lock ./

RUN mix local.hex --force && \
        mix local.rebar --force && \
        mix deps.get && \
        mix deps.compile

COPY config config/
COPY lib lib/
COPY rel rel/
COPY priv priv/

RUN mix compile && \
        mix distillery.release --no-tar && \
        mkdir /release && \
        cp -R _build/prod/rel/fcm_mock/* /release


FROM debian:stretch-slim

ENV MOCK_HOSTNAME localhost
ENV MOCK_PORT 4000
ENV HOME /app

# Locales
RUN apt-get update && \
        apt-get install --yes locales && \
        sed -i '/^#.* en_US.UTF-8 /s/^#//' /etc/locale.gen && \
        locale-gen

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en"

# Curl for healthcheck and ssl
RUN apt-get install --yes \
        libssl1.1 \
        curl

WORKDIR /app

COPY --from=builder /release/ .

RUN groupadd -r app && useradd -r -g app app
RUN chown -R app /app
USER app

# API
EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
        CMD curl --silent --fail -k https://localhost:4000/healthcheck

CMD trap 'exit' INT; /app/bin/fcm_mock foreground