FROM ruby:3.0.2-buster

EXPOSE 3000
WORKDIR /app
COPY package.json /app
COPY Gemfile /app
COPY Gemfile.lock /app
ARG RAILS_ENV
RUN bundle install
COPY . /app

ENTRYPOINT [ "/app/scripts/deploy.sh" ]
