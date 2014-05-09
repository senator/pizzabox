#!/bin/bash

#
# Run this from the top directory of the pizzabox source, like so:
#
# you@/path/to/source# extras/uninstall.sh
#
# This is certainly not a perfect uninstaller.
#

if [ ! -r setup.rb ]; then
    echo "Be in the top directory of the pizzabox source."
    exit 1
elif [ ! -r .config -o ! -r InstalledFiles ]; then
    echo "No configuration in current working directory for existing"
    echo "installation.  This probably won't work."
    echo
    echo "If you really want to try it, run 'ruby setup.rb config' first."
    exit 1
fi

if ! (grep -Eq '\b-f\b' <<< "$*"); then
    echo -n "This has to *install* before attempting uninstall. Proceed (y/n)? "
    read ans
    if [ "$ans" != "y" -a "$ans" != "Y" ]; then
        echo "Exiting without action."
        exit 2
    fi
fi

echo "Attempting uninstall..."
for f in `cat InstalledFiles`; do
    echo $f
    perl -e '$_ = <>; chomp; if (m:bin/pizzabox$:) { s:bin/pizzabox$:bin/pizzabox-config:; print "$_\n"; unlink; }' <<< $f
    rm -rf $f
done
