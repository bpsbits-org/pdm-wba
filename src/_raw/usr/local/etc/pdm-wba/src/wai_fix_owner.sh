#!/bin/bash
# wai_fix_owner.sh
# /usr/local/etc/pdm-wba/src

# Changes the ownership of the specified file to the wa user
wai_fix_owner(){
    local file=$1
    chown wa:wa "${file}"
}