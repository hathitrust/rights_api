FROM ruby:3.4 AS base

ARG UNAME=app
ARG UID=1000
ARG GID=1000

WORKDIR /usr/src/app
#
ENV BUNDLE_PATH /gems
#
RUN gem install bundler

FROM base AS development

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends


FROM base AS production

ENV BUNDLE_PATH /gems

RUN groupadd -g $GID -o $UNAME
RUN useradd -m -d /usr/src/app -u $UID -g $GID -o -s /bin/bash $UNAME
RUN mkdir -p /gems && chown $UID:$GID /gems


COPY --chown=$UID:$GID Gemfile* /usr/src/app/

WORKDIR /usr/src/app

COPY --chown=$UID:$GID . /usr/src/app
RUN chown app:app /usr/src/app

USER $UNAME
RUN bundle install

CMD ["bundle", "exec", "puma", "-p", "4567", "config.ru"]
