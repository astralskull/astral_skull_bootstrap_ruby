#!/bin/bash

source ~/.rvm/scripts/rvm

# Install ruby
if ! rvm install $RUBY_VERSION; then
    echo "Could not install ruby $RUBY_VERSION" 1>&2;
    exit 1;
fi
