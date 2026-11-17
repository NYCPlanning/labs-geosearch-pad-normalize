#!/bin/bash
LATEST_PATH=planninglabs/geosearch-data/latest
VERSIONED_PATH=planninglabs/geosearch-data/$VERSION

function upload {
    rclone copyto --s3-acl public-read $1 spaces:$VERSIONED_PATH/$1
    rclone copyto --s3-acl public-read $1 spaces:$LATEST_PATH/$1
}

(
    cd data/nycpad
    sudo chown $USER:$USER *.csv

    upload labs-geosearch-pad-normalized.csv

    upload labs-geosearch-pad-normalized-sample-lg.csv

    upload labs-geosearch-pad-normalized-sample-md.csv

    upload labs-geosearch-pad-normalized-sample-sm.csv
)

echo "done"