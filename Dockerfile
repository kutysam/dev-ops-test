FROM ruby:3.0.2-buster

WORKDIR /app
COPY . /app

EXPOSE 3000
ARG RAILS_ENV
RUN bundle install
ENTRYPOINT [ "/app/scripts/deploy.sh" ]
