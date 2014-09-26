#!/bin/sh

# Define constants
RVM_TMP_RC="/tmp/rvm_tmp_rc_$(whoami)"
HOME_DIR="/home/$(whoami)/"
BASHRC="$HOME_DIR/.bashrc"
BASHRC_BACKUP="$BASHRC".bak.rvm.$(date +%F)
SCRIPT_DIR=$(dirname $0)
BASH_RUBY_INSTALL_SCRIPT="$SCRIPT_DIR/bootstrap_bash.sh"

# Process command line arguments
RUBY_VERSION=$1
if test -z $RUBY_VERSION; then
    echo "You must specify ruby version" 1>&2;
    exit 1;
fi

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

# Update bashrc
echo "if test -f ~/.rvm/scripts/rvm; then" > $RVM_TMP_RC
echo "    [ "$(type -t rvm)" = "function" ] || source ~/.rvm/scripts/rvm" >> $RVM_TMP_RC
echo "fi" >> $RVM_TMP_RC
echo "rvm use $RUBY_VERSION > /dev/null;" >> $RVM_TMP_RC
cat $BASHRC >> $RVM_TMP_RC
echo 
echo "Backing up $BASHRC to $BASHRC_BACKUP"
mv $BASHRC $BASHRC_BACKUP
echo "Updating $BASHRC from $RVM_TMP_RC..."
cp $RVM_TMP_RC $BASHRC

echo "Executing bash install script"
if ! $BASH_RUBY_INSTALL_SCRIPT $RUBY_VERSION; then
    echo "Bash install script failed" 1>&2
    exit 1
fi
