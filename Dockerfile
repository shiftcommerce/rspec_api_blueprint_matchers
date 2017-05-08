FROM ruby:2.4.1-slim
LABEL maintainer "team@shiftcommerce.com"

# Install essentials and cURL
RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential curl git libpq-dev python

# Install drafter for API Blueprint Parsing
RUN mkdir /tmp_build
RUN cd /tmp_build
RUN bash -c "git clone --recursive git://github.com/apiaryio/drafter.git; cd drafter; ./configure; make test; make drafter; make install"
RUN rm -rf /tmp_build


# Configure the main working directory
ENV app /app
RUN mkdir $app
WORKDIR $app

# Set the where to install gems
ENV GEM_HOME /rubygems
ENV BUNDLE_PATH /rubygems

# Link the whole application up
ADD . $app
