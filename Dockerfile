FROM ruby:3.3 AS base
ARG UNAME=app
ARG UID=1000
ARG GID=1000

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends
RUN gem install bundler

FROM base AS production
ENV BUNDLE_PATH /gems
ENV APP_ENV production

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -d /usr/src/app -u $UID -g $GID -o -s /bin/bash $UNAME
RUN mkdir -p /gems && chown $UID:$GID /gems

USER $UNAME

COPY --chown=$UID:$GID Gemfile* /usr/src/app/
COPY --chown=$UID:$GID . /usr/src/app

WORKDIR /usr/src/app

RUN bundle install

CMD ["bundle", "exec", "rackup", "-p", "4567", "-o", "0.0.0.0"]
