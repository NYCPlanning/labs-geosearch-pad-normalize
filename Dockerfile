FROM rocker/tidyverse:3.6.3

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.org'))" >> /usr/local/lib/R/etc/Rprofile.site

RUN install2.r --error \
    --deps TRUE \
    jsonlite \
    downloader

RUN mkdir -p /data/nycpad

COPY . /usr/local/src/scripts

WORKDIR /usr/local/src/scripts

ENTRYPOINT ["./bin/normalize"]