FROM elixir:1.9.0-alpine AS builder

RUN mix local.hex --force && \
        mix local.rebar --force

WORKDIR /opt/app

COPY config ./config
COPY lib ./lib
COPY rel ./rel
COPY mix.exs .
COPY mix.lock .

ENV MIX_ENV=prod

RUN mix deps.get && \
        mix deps.compile && \
        mix release

FROM elixir:1.9.0-alpine AS app

WORKDIR /opt/app

COPY --from=builder /opt/app/_build .

EXPOSE 4000
ENV PORT=4000
ENV PACKAGES=""
ENV PACAKGE_DIR=/opt/app/hex

CMD ["./prod/rel/mini_repo/bin/mini_repo", "start"]
