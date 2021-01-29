#!/bin/bash
LATEST_PATH=spaces/planninglabs/geosearch-data/latest
VERSIONED_PATH=spaces/planninglabs/geosearch-data/$VERSION

function upload {
    mc cp --attr x-amz-acl=public-read $1 $VERSIONED_PATH/$1
    mc cp --attr x-amz-acl=public-read $1 $LATEST_PATH/$1
}

(
    cd data
    zip labs-geosearch-pad-normalized.zip labs-geosearch-pad-normalized.csv 
    upload labs-geosearch-pad-normalized.zip

    zip labs-geosearch-pad-normalized-sample-lg.zip labs-geosearch-pad-normalized-sample-lg.csv
    upload labs-geosearch-pad-normalized-sample-lg.zip

    zip labs-geosearch-pad-normalized-sample-md.zip labs-geosearch-pad-normalized-sample-md.csv
    upload labs-geosearch-pad-normalized-sample-md.zip

    zip labs-geosearch-pad-normalized-sample-sm.zip labs-geosearch-pad-normalized-sample-sm.csv
    upload labs-geosearch-pad-normalized-sample-sm.zip
)

echo "done"