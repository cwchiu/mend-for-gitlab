# This default may be swapped for any compatible base image
ARG BASE_IMAGE=amd64/ubuntu:20.04@sha256:b795f8e0caaaacad9859a9a38fe1c78154f8301fdaf0872eaf1520d66d9c0b98

FROM curlimages/curl:latest AS downloader

RUN curl -O https://integrations.mend.io/release/Agent-for-GitLab-Enterprise/agent-4-gitlab-server.tar.gz
RUN tar zxf agent-4-gitlab-server.tar.gz

# This buildpack is used for tool installation and user/directory setup
FROM ghcr.io/containerbase/base:7.8.7 AS buildpack

FROM ${BASE_IMAGE} as base

# The buildpack supports custom user
ARG USER_NAME=wss-scanner
ARG USER_ID=1000
ARG USER_HOME=/home/${USER_NAME}
ARG APT_HTTP_PROXY

# Set env and shell
ENV BASH_ENV=/usr/local/etc/env
SHELL ["/bin/bash" , "-c"]

# Set up buildpack
COPY --from=buildpack /usr/local/bin/ /usr/local/bin/
COPY --from=buildpack /usr/local/buildpack/ /usr/local/buildpack/
RUN install-buildpack

# renovate: datasource=github-tags depName=git packageName=git/git
ARG GIT_VERSION=v2.39.1
RUN install-tool git

# renovate: datasource=docker depName=node versioning=node
ARG NODE_VERSION=18.14.2
RUN install-tool node

# renovate: datasource=npm depName=npm versioning=npm
ARG NPM_VERSION=9.5.1
RUN install-tool npm

# renovate: datasource=npm depName=yarn
ARG YARN_VERSION=1.22.19
RUN install-tool yarn

# renovate: datasource=npm depName=bower
ARG BOWER_VERSION=1.8.13
RUN install-npm bower

### provide permissions
RUN echo '{ "allow_root": true }' > ${USER_HOME}/.bowerrc && \
	chown -R ${USER_NAME}:${GROUP_NAME} ${USER_HOME}/.bowerrc

# renovate: datasource=docker depName=openjdk versioning=docker
ARG JAVA_VERSION=17.0.7+7
RUN install-tool java

ARG JAVA_VERSION=8.0.342+7
RUN install-tool java

### !!! Install this version after the other versions, so that it is the default !!! ###
# renovate: datasource=docker depName=openjdk versioning=docker
ARG JAVA_VERSION=11.0.19+7
RUN install-tool java

# renovate: datasource=gradle-version depName=gradle versioning=gradle
ARG GRADLE_VERSION=7.3
RUN install-tool gradle

### !!! Install this version after the other versions, so that it is the default !!! ###
# renovate: datasource=gradle-version depName=gradle versioning=gradle
ARG GRADLE_VERSION=6.9.3
RUN install-tool gradle

# renovate: datasource=docker depName=golang versioning=docker
#ARG GOLANG_VERSION=1.17.6
#RUN install-tool golang

#USER ${USER_ID}
## Install package managers
#RUN go install github.com/tools/godep@latest
#RUN go install github.com/LK4D4/vndr@latest
#RUN go install  github.com/kardianos/govendor@latest

#All Deparacted/archived go package managers
# RUN go install  github.com/gpmgo/gopm@latest
# RUN go install  github.com/golang/dep/cmd/dep@latest
# RUN go install github.com/Masterminds/glide@latest
# RUN curl https://glide.sh/get | sh
#USER 0
#RUN chgrp -R 0 /go && chmod -R g=u /go

# renovate: datasource=maven depName=maven packageName=org.apache.maven:maven
ARG MAVEN_VERSION=3.9.1
RUN install-tool maven

# renovate: datasource=github-releases depName=scala packageName=scala/scala
# ARG SCALA_VERSION=2.13.5
# RUN install-tool scala

# renovate: datasource=github-releases depName=sbt packageName=sbt/sbt
# ARG SBT_VERSION=1.5.7
# RUN install-tool sbt

# renovate: datasource=github-releases depName=python packageName=containerbase/python-prebuild
ARG PYTHON_VERSION=3.6.15
RUN install-tool python

# renovate: datasource=github-releases depName=python packageName=containerbase/python-prebuild
ARG PYTHON_VERSION=2.7.18
RUN install-tool python

# renovate: datasource=github-releases depName=python packageName=containerbase/python-prebuild
ARG PYTHON_VERSION=3.9.9
RUN install-tool python

#renovate: datasource=github-releases depName=python packageName=containerbase/python-prebuild
ARG PYTHON_VERSION=3.8.12
RUN install-tool python

# renovate: datasource=github-releases depName=python packageName=containerbase/python-prebuild
ARG PYTHON_VERSION=3.7.12
RUN install-tool python

#ARG PHP_VERSION=8.2.3
#RUN install-tool php

# renovate: datasource=github-releases depName=composer packageName=composer/composer
#ARG COMPOSER_VERSION=2.0.13
#RUN install-tool composer

#ARG DOTNET_VERSION=2.2.207
#RUN install-tool dotnet

#ARG DOTNET_VERSION=3.1.416
#RUN install-tool dotnet

#ARG DOTNET_VERSION=5.0.404
#RUN install-tool dotnet

#ARG DOTNET_VERSION=6.0.404
#RUN install-tool dotnet

ARG DOTNET_VERSION=7.0.100
RUN install-tool dotnet

#ARG RUST_VERSION=1.58.1
#RUN install-tool rust

# pip user install (so available for all python versions)
USER ${USER_ID}

## pipenv depends on virtualenv
# renovate: datasource=pypi depName=virtualenv
ARG VIRTUALENV_VERSION=20.13.0
RUN install-pip virtualenv

# renovate: datasource=pypi depName=pipenv
ARG PIPENV_VERSION=2023.4.20
RUN install-pip pipenv

# renovate: datasource=pypi depName=checkov
ARG CHECKOV_VERSION=2.3.298
RUN install-pip checkov

USER 0

# renovate: datasource=pypi
ARG POETRY_VERSION=1.4.2
RUN install-tool poetry

# renovate: datasource=github-releases depName=ruby packageName=containerbase/ruby-prebuild
# ARG RUBY_VERSION=2.7.7
# RUN install-tool ruby

# renovate: datasource=rubygems depName=bundler versioning=ruby
# ARG BUNDLER_VERSION=2.3.8
# RUN install-gem bundler

# renovate: datasource=rubygems depName=bundler versioning=ruby
# ARG BUNDLER_VERSION=1.17.3
# RUN install-gem bundler

#RUN install-tool erlang 24.3.3.0

#RUN install-tool elixir 1.13.4

#### Install rbenv and ruby-build
### or maybe be saved to /etc/profile instead of /etc/profile.d/
#RUN git clone https://github.com/sstephenson/rbenv.git ${USER_HOME}/.rbenv; \
#	git clone https://github.com/sstephenson/ruby-build.git ${USER_HOME}/.rbenv/plugins/ruby-build; \
#	${USER_HOME}/.rbenv/plugins/ruby-build/install.sh && \
#	echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
#	echo 'eval "$(rbenv init -)"' >> ${USER_HOME}/.bashrc && \
#	chown -R ${USER_NAME}:${GROUP_NAME} ${USER_HOME}/.rbenv ${USER_HOME}/.bashrc
#ENV PATH ${USER_HOME}/.rbenv/bin:$PATH

# renovate: datasource=rubygems depName=cocoapods versioning=ruby
# ARG COCOAPODS_VERSION=1.11.2
# RUN install-gem cocoapods
# RUN adduser cocoapods
# USER cocoapods
# RUN pod setup
# USER 0

#ARG HELM_VERSION=3.11.2
#RUN install-tool helm

## No renovate datasource exists yet
ARG HASKELL_GHC_VERSION=8.6.5

## No renovate datasource exists yet
ARG CABAL_VERSION=3.2

# Fix for npm engine-strict
ENV npm_config_engine_strict=false

ENV DEBIAN_FRONTEND noninteractive
ENV LANGUAGE	en_US.UTF-8
ENV LANG    	en_US.UTF-8
ENV LC_ALL  	en_US.UTF-8

### Install wget, curl, git, unzip, gnupg, locales
RUN apt-get update && \
	apt-get -y install wget curl git unzip gnupg locales && \
	locale-gen en_US.UTF-8 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*


#### Install Conda (python)
#USER ${USER_NAME}
#RUN cd ${USER_HOME} && \
#    wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh && \
#    bash Anaconda3-2021.05-Linux-x86_64.sh -b && \
#    rm Anaconda3-2021.05-Linux-x86_64.sh
#
#USER 0
#RUN echo '#!/usr/bin/env bash' >> /usr/bin/conda && \
#    echo 'source ${USER_HOME}/anaconda3/etc/profile.d/conda.sh' >> /usr/bin/conda && \
#    echo '${USER_HOME}/anaconda3/bin/conda "$@"' >> /usr/bin/conda && \
#    chmod +x /usr/bin/conda


#### Important note ###
#### uncomment for:
####    Scala
####    SBT
####    Mix/ Hex/ Erlang/ Elixir
####    dotnet/nuget cli's
#RUN apt-get update && \
#	apt-get install -y --force-yes build-essential software-properties-common && \
#	apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev && \
#	apt-get clean && \
#	rm -rf /var/lib/apt/lists/* && \
#	rm -rf /tmp/*

### Install PHP Plugins
#RUN apt-get update && \
#	apt-get install -y php7.4-mbstring && \
#	apt-get install -y php7.4-dom && \
#	apt-get clean && \
#	rm -rf /var/lib/apt/lists/* && \
#	rm -rf /tmp/*


#### Install R and Packrat
#RUN apt-get update && \
#	apt-get install -y r-base libopenblas-base r-base gdebi && \
#	wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2021.09.1-372-amd64.deb && \
#	gdebi rstudio-server-2021.09.1-372-amd64.deb && \
#	rm rstudio-server-2021.09.1-372-amd64.deb && \
#	R -e 'install.packages("packrat" , repos="http://cran.us.r-project.org");'  && \
#	apt-get clean && \
#	rm -rf /var/lib/apt/lists/* && \
#	rm -rf /tmp/*

#### Install Cabal
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 063DAB2BDC0B3F9FCEBC378BFF3AEACEF6F88286 && \
#	echo "deb http://ppa.launchpad.net/hvr/ghc/ubuntu bionic main " | tee /etc/apt/sources.list.d/ppa_hvr_ghc.list && \
#	apt-get update && \
#	apt-get install -y ghc-${HASKELL_GHC_VERSION} cabal-install-${CABAL_VERSION} && \
#	PATH="/opt/ghc/bin:${PATH}" && \
#	cabal update && \
#	apt-get clean && \
#	rm -rf /var/lib/apt/lists/* && \
#	rm -rf /tmp/*
#ENV PATH /opt/ghc/bin:$PATH

#### Install Mono
#RUN apt-get update && \
#    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
#    apt-get install -y --no-install-recommends apt-transport-https ca-certificates && \
#    echo "deb https://download.mono-project.com/repo/ubuntu bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
#    apt-get update && \
#    apt-get install -y mono-devel && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* && \
#    rm -rf /tmp/*
#
#### Install Nuget CLI
#RUN apt-get update && \
#    apt-get install nuget

## Install Paket
#ENV PAKET_HOME=${USER_HOME}/.dotnet/tools
#ENV PATH="${PATH}:${PAKET_HOME}"
#RUN dotnet tool install Paket --version 7.2.1 --tool-path ${PAKET_HOME}

## Install Bazel 6.1.1, 5.1.1 and set version 6.1.1 as default
#RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
#    curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
#    apt-get update && \
#    apt-get -y install bazel-6.1.1 && \
#    apt-get -y upgrade bazel-6.1.1 && \
#    apt-get -y install bazel-5.1.1 && \
#    apt-get -y upgrade bazel-5.1.1 && \
#    ln -s /usr/bin/bazel-6.1.1 /usr/local/bin/bazel


# Download the pre-scan builder and set it in $PATH, can be replaced by:
#--build-arg $PSB_URL=URL
ARG PSB_URL=https://downloads.mend.io/latest/linux_amd64/psb
RUN curl $PSB_URL --create-dirs -o /psb/bin/psb && chmod 0775 /psb/bin/psb
ENV PATH=$PATH:/psb/bin/

# Download the SAST CLI and set it in $PATH, can be replaced by:
#--build-arg SASTCLI=URL
ARG SASTCLI=https://downloads-sast.whitesourcesoftware.com/sast-cli/linux/wscli
RUN curl $SASTCLI --create-dirs -o /sast/bin/wscli && chmod 0775 /sast/bin/wscli
ENV PATH=$PATH:/sast/bin


### copy folder
#COPY docker-image/ /
#COPY --from=downloader /home/curl_user/agent-4-gitlab-server-23.6.2.1/wss-scanner/docker-image/ /
COPY --from=downloader /home/curl_user/agent-4-gitlab-server-23.6.2.1/wss-scanner/docker/docker-image/ /

RUN chmod 755 /start.sh
RUN chgrp -R 0 ${USER_HOME} && chmod -R g=u ${USER_HOME}

ENV SCM_SCANNER_HOME=/etc/usr/local/whitesource/scm-scanner
RUN chmod -R ugo+rw ${SCM_SCANNER_HOME}
ENV LOG4J_FORMAT_MSG_NO_LOOKUPS=true
### Switch User ###
ENV HOME ${USER_HOME}
WORKDIR ${USER_HOME}
USER ${USER_NAME}
ARG JAVA_OPTS
ENV JAVA_OPTS=${JAVA_OPTS}

EXPOSE 9393

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/start.sh"]
