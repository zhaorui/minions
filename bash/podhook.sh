#!/bin/bash

/usr/bin/env pod $@

function postInitAction {
    touch Podfile.new
    echo "
ali_source 'alibaba-specs' #集团内部仓库
ali_source 'alibaba-specs-mirror' #官方镜像仓库
#include_official_source! #强制使用官方源
" >> Podfile.new
# include_official_source! #强制使用官方源
    cat Podfile >> Podfile.new
    rm -f Podfile
    mv Podfile.new Podfile
}

case $1 in
init) postInitAction;;
esac