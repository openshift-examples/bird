#!/usr/bin/env bash

set -euo pipefail
set -x 

echo "==== Render /bird/bird.conf.template"
envsubst < /bird/bird.conf.template > /bird/bird.conf

echo "===== Final bird.conf"
cat /bird/bird.conf

echo "===== Start bird"
/opt/bird-1.6.8/sbin/bird -f -c /bird/bird.conf