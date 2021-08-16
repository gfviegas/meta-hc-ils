# Use an official Elixir runtime as a parent image
FROM elixir:latest

# Database, C and Image manipulation library
RUN apt-get update
RUN apt-get install -y  ncurses-dev libc-dev openssh-server git gcc inotify-tools

# Install hex package manager
RUN mix local.hex --force
RUN mix local.rebar --force

# Create code directory and copy the Elixir projects into it
RUN mkdir /code
COPY . /code
WORKDIR /code

RUN mix deps.get
RUN mix deps.compile
RUN mix do compile

CMD ["/code/entrypoint.sh"]
