#!/bin/bash

if [ $1 ]; then
    tar -xzvf very/$1 --absolute-names
else
    echo "Usage: ./restore.sh /absolute/path/to/backup.tar.gz"
fi