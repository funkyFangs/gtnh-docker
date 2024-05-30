#!/bin/bash

KEY=$1
VALUE=$2
TARGET=$3

# Source: https://superuser.com/a/976712
sed "/^${KEY}=/{h;s/=.*/=${VALUE}/};\${x;/^\${s//${KEY}=${VALUE}/;H};x}" $TARGET
