#!/bin/bash

export INTERNAL_BACKEND="localhost"

envsubst < nginx.template.conf > /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'
