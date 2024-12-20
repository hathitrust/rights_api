FROM ruby:3.3 AS base
ARG UNAME=app
ARG UID=1000
ARG GID=1000

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends
RUN gem install bundler

FROM base AS production
COPY --chown=$UID:$GID Gemfile* /usr/src/app/

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -d /usr/src/app -u $UID -g $GID -o -s /bin/bash $UNAME

RUN mkdir -p /gems && chown $UID:$GID /gems
USER $UNAME
WORKDIR /usr/src/app
ENV BUNDLE_PATH /gems
ENV APP_ENV production
RUN bundle install
COPY --chown=$UID:$GID . /usr/src/app

CMD ["bundle", "exec", "rackup", "-p", "4567", "-o", "0.0.0.0"]