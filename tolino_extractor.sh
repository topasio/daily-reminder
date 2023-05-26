#!/bin/sh

## Description:
# A small script that helps you extract the tolino content 

## Usage:
# Create a file that is called "notes.txt"
# If you are using MacOS get gsed: brew install gnu-sed

# The script will search for the author because tolino keeps everything in one file
author="Name"

# We just delete the overhead
line_del="Booktitle"

# Because I want to have the name of the author at the end of each line
line_add=" - Firstname Secondname"

# Delete anything that starts with "Markierung" or "Lesezeichen" - the [^:]* means that it stops after the first hit
# Delete anything that starts with "--", blank lines or spaces at the beginning
# Make bullets and put the author name at the end
# Delete all ugly quotation marks
grep -A 1 ${author} notes.txt | gsed -e "/${line_del}.*/d" \
-e "s/^Markierung[^:]*://g" \
-e "s/^Lesezeichen[^:]*://g" \
-e "/^--.*/d" \
-e "/^$/d" -e "s/\"//g" \
-e "s/^[[:space:]]*//" \
-e "/^$/d" \
-e "s/^/- /g" \
-e "s/[“”]/\"/g" \
-e "s/$/${line_add}/g"
