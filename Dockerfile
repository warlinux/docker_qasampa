ARG RUBY_VERSION=2.6.3

#=========
#BASE IMAGE
#=========

FROM ruby:${RUBY_VERSION} as base-ruby
LABEL maintainer "Anderson Sant'Ana <andvsantana@gmail.com>"
# https://github.com/andersonVSA/docker-ruby-chrome-firefox

#=========
# CHROME-IMAGE, If team pass argument BROWSER=CHROME, then Install chrome browser
#=========

FROM base-ruby AS base-ruby-chrome

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install google-chrome-stable \
  && rm /etc/apt/sources.list.d/google-chrome.list

# Install webdrivers gem for chrome and firefox browsers
RUN gem install webdrivers

#=========
#YOUR TEST APP CONTAINERIZED, based in image builded by arguments
#=========

FROM base-ruby-chrome as base-ruby-final

# Creates Application root
RUN mkdir -p /apptest
WORKDIR /apptest

# Ensure gems are cached and only get updated when they change
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && \
    bundle install

# Copy aplication code from work station
#COPY . /apptest
