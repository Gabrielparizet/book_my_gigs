FROM elixir:1.14.5

RUN apt update && apt install -y build-essential inotify-tools

RUN mkdir /book_my_gigs
COPY . /book_my_gigs
WORKDIR /book_my_gigs

RUN mix local.hex --force && \
    mix local.rebar --force

CMD mix deps.get && \
    mix ecto.create && \
    mix ecto.migrate && \
    mix phx.server