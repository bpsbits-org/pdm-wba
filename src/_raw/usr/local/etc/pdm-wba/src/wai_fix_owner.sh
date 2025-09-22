#!/bin/bash
# wai_fix_owner.sh

wai_fix_owner(){
    local file=$1
    chown wa:wa "${file}"
}