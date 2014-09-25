#!/bin/sh

# Process command line arguments
RUBY_VERSION=$0
if ! test -z "$RUBY_VERSION"; then
    echo "You must specify ruby version" 1>&2;
    exit 1;
fi

# Set variables
TMP_RVM_RC=/tmp/rvm_rc

# Update repositories
echo "If needed, enter password to update repositories";
sudo apt-get update;

# Use curl progress bar
echo progress-bar >> ~/.curlrc

# Install stable RVM
if ! curl -sSL https://get.rvm.io | bash -s stable; then
   echo "Could not install RVM" 1>&2; 
   exit 1;
fi

if ! rvm install $RUBY_VERSION; then
    echo "Could not install ruby $RUBY_VERSION" 1>&2;
    exit 1;
fi
