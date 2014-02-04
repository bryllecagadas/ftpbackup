#!/bin/sh
#
# Filename: ftpbackup.sh
# 
# Description:
# Will download FTP files into the current directory using wget, provided a file containing the details for the 
# credetials to access the FTP servers.
# 
# [File Format]
# host:port
# username:password
# directory
# 
# Author: Brylle Cagadas
# Contact: brylle@gemango.com
# 
# Usage:
# script <file>
#
# Options:
# <file> - The file containing the FTP credentials to be used in fetching the data
# 
# TODO:
# 
# Error-checking!
# Allow specifying destination directory.

PORT=20
FILE=$1

# Subroutines

do_wget() {
	echo "Backing up $HOST"
	wget -m "ftp://$USERPW@$HOST$DIR"
}

if [ ! $FILE ] 
then
	echo "No file specified."
	exit 1
fi

if [ -f $FILE ]
then
	echo "Parsing file..."
else
	echo "File not found"
	exit 1
fi

INDEX=0
HOST=false
USERPW=false
DIR=false
while read line;
do
	case $INDEX in
		0 )
			HOST=$line
			;;
		1 )
			USERPW=$line
			;;
		2 ) 
			DIR=$line
			;;
	esac
	INDEX=$[INDEX + 1]
	if [ $INDEX -eq 3 ]
	then
		INDEX=0
		do_wget
		HOST=false
		USERPW=false
		DIR=false
	fi
done < $FILE

exit 0;