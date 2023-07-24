# This default may be swapped for any compatible base image
ARG BASE_IMAGE=amd64/ubuntu:20.04@sha256:8c38f4ea0b178a98e4f9f831b29b7966d6654414c1dc008591c6ec77de3bf2c9

# This containerbase is used for tool intallation and user/directory setup
FROM ghcr.io/containerbase/base:9.0.8@sha256:e1fcdc062c5098a71b9b2d224f9e4e4740eed3316c8f1879bcaf8688f0862c6c AS containerbase

FROM ${BASE_IMAGE} as base

# The containerbase supports custom user but Renovate requires ubuntu
ARG USER_NAME=ubuntu
ARG USER_ID=1000
ARG APP_ROOT=/usr/src/app

# Set env and shell
ENV BASH_ENV=/usr/local/etc/env
SHELL ["/bin/bash" , "-c"]

# Set up containerbase
COPY --from=containerbase /usr/local/bin/ /usr/local/bin/
COPY --from=containerbase /usr/local/containerbase/ /usr/local/containerbase/
RUN install-containerbase

# --------------------------------------------------------------
# The following packages are mandatory for installs and runtime
# --------------------------------------------------------------

# renovate: datasource=github-tags depName=git packageName=git/git
ARG GIT_VERSION=v2.41.0
RUN install-tool git

# renovate: datasource=github-releases depName=node packageName=nodejs/node versioning=node
ARG NODE_VERSION=18.16.1
RUN install-tool node

# renovate: datasource=npm depName=npm versioning=npm
ARG NPM_VERSION=9.7.2
RUN install-tool npm

# renovate: datasource=npm depName=yarn versioning=npm
ARG YARN_VERSION=1.22.19
RUN install-tool yarn

# -------------------------------------------------------------------------------------
# Any of the below third-party tools may be commented out to save space and build time
# -------------------------------------------------------------------------------------

# renovate: datasource=adoptium-java depName=java
ARG JAVA_VERSION=11.0.19+7
RUN install-tool java

# renovate: datasource=gradle-version depName=gradle versioning=gradle
ARG GRADLE_VERSION=8.2
RUN install-tool gradle

# renovate: datasource=github-releases depName=erlang packageName=containerbase/erlang-prebuild versioning=docker
ARG ERLANG_VERSION=24.3.4.13
RUN install-tool erlang

# renovate: datasource=docker depName=elixir versioning=docker
ARG ELIXIR_VERSION=1.15.1
RUN install-tool elixir

# renovate: datasource=github-releases depName=php packageName=containerbase/php-prebuild
ARG PHP_VERSION=8.2.7
RUN install-tool php

# renovate: datasource=github-releases depName=composer packageName=composer/composer
ARG COMPOSER_VERSION=2.5.8
RUN install-tool composer

# renovate: datasource=docker depName=golang versioning=docker
ARG GOLANG_VERSION=1.20.5
RUN install-tool golang

# renovate: datasource=github-releases depName=python packageName=containerbase/python-prebuild
ARG PYTHON_VERSION=3.11.4
RUN install-tool python

# renovate: datasource=pypi depName=pipenv
ARG PIPENV_VERSION=2023.7.3
RUN install-tool pipenv

# renovate: datasource=github-releases depName=poetry packageName=python-poetry/poetry
ARG POETRY_VERSION=1.5.1
RUN install-tool poetry

# renovate: datasource=pypi depName=hashin
ARG HASHIN_VERSION=0.17.0
RUN install-tool hashin

# renovate: datasource=docker depName=rust versioning=docker
ARG RUST_VERSION=1.70.0
RUN install-tool rust

# renovate: datasource=github-releases depName=ruby packageName=containerbase/ruby-prebuild versioning=ruby
ARG RUBY_VERSION=3.2.2
RUN install-tool ruby

# renovate: datasource=rubygems depName=bundler
ARG BUNDLER_VERSION=2.4.15
RUN install-tool bundler

# renovate: datasource=rubygems depName=cocoapods versioning=ruby
ARG COCOAPODS_VERSION=1.12.1
RUN install-tool cocoapods

# renovate: datasource=npm depName=pnpm versioning=npm
ARG PNPM_VERSION=8.6.5
RUN install-tool pnpm

# renovate: datasource=docker depName=dotnet packageName=mcr.microsoft.com/dotnet/sdk
ARG DOTNET_VERSION=6.0.411
RUN install-tool dotnet

# renovate: datasource=npm depName=lerna versioning=npm
ARG LERNA_VERSION=7.1.0
RUN install-tool lerna

# renovate: datasource=github-releases depName=helm packageName=helm/helm
ARG HELM_VERSION=v3.12.1
RUN install-tool helm

# ---------------------------------------------
# Set up of custom server - do not modify
# ---------------------------------------------

WORKDIR ${APP_ROOT}

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

ARG SERVER_SRC=src/server.js
ARG SERVER_DST=src/server.js

COPY ${SERVER_SRC} ${SERVER_DST}

ARG WS_PLATFORM=enterprise
ENV WS_PLATFORM=${WS_PLATFORM}
ENV RENOVATE_X_MATCH_PACKAGE_NAMES_MORE=true

# This entry point ensures that dumb-init is run
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "node", "src/server.js" ]

EXPOSE 8080

# Override home for openshift and add user bin to path
ENV HOME=/home/$USER_NAME PATH=/home/$USER_NAME/bin:$PATH

ENV RENOVATE_BINARY_SOURCE=install

USER $USER_ID
