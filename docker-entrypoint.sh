#!/bin/sh

# Default if not set
API_URL=${REACT_APP_API_URL:-http://localhost:8000}
export BACKEND_ENDPOINT=${INTERNAL_BACKEND:-http://localhost:8000}

# Replace the value in runtime-config.js
cat <<EOF > /usr/share/nginx/html/runtime-config.js
window.RUNTIME_API_URL = "$API_URL";
EOF

envsubst '$BACKEND_ENDPOINT' < nginx.template.conf > /etc/nginx/conf.d/default.conf

exec "$@"
