#!/bin/bash
LATEST_PATH=spaces/planninglabs/geosearch-data/latest
VERSIONED_PATH=spaces/planninglabs/geosearch-data/$VERSION

function upload {
    mc cp --attr x-amz-acl=public-read $1 $VERSIONED_PATH/$1
    mc cp --attr x-amz-acl=public-read $1 $LATEST_PATH/$1
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