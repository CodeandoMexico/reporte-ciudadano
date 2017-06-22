FROM ruby:2.2.5-slim

###############
#   Runtime   #
###############
ENV APP_HOME=/usr/src/app \
    LANG=C.UTF-8 \
    PATH=/usr/src/app/bin:$PATH \
    TERM='xterm-256color' \
    RAILS_ENV=development

WORKDIR $APP_HOME

EXPOSE 3000

RUN set -ex \
    && apt-get update -qq \
    && apt-get install -y \
      build-essential \
      libpq-dev \
      nodejs \
      git

############
#   Gems   #
############
COPY Gemfile* $APP_HOME/

RUN bundle install --without test development --jobs 4 --retry 3

###########
#   App   #
###########
COPY . $APP_HOME
RUN mkdir log tmp \
    && mv docker/database.yml config/database.yml \
    && rake assets:precompile \
    && chown -R nobody:nogroup $APP_HOME

USER nobody
CMD ["rails", "server", "-b", "0.0.0.0"]
