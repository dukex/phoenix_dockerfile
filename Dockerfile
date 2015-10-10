FROM phusion/baseimage:0.9.17

# deps
RUN apt-get update
RUN apt-get install wget
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install elixir build-essential erlang-dev -y

# nodejs
RUN apt-get install nodejs-legacy npm -y

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# app
RUN mkdir -p /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app

EXPOSE 4000

## app -> phoneix
RUN mix local.hex
RUN yes | mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v1.0.3/phoenix_new-1.0.3.ez


## app -> deps

RUN yes | mix deps.get
RUN yes | mix

## app -> npm
RUN npm install && node node_modules/brunch/bin/brunch build

CMD ["mix", "phoenix.server"]
