#!/bin/sh

### Dynamic inject the API URL for the frontend

# if $REACT_APP_API_URL not set
if [ -z "$REACT_APP_API_URL" ]; then
  # try to get the public-hostname from the EC2 metadata
  EC2_HOST_IP=$(curl http://169.254.169.254/latest/meta-data/public-hostname --connect-timeout 5)

  if [ -z "$EC2_HOST_IP" ]; then
    # Docker-compose setup
    API_URL="http://localhost:3000"
    echo "REACT_APP_API_URL is not set, using localhost: $API_URL"
  else
    # ECS EC2 launch type setup
    API_URL="http://$EC2_HOST_IP:80"
    echo "REACT_APP_API_URL is not set, using public-hostname: $API_URL"
  fi

else
  # if $REACT_APP_API_URL set (ELB endpoint / Domain name)
  API_URL=${REACT_APP_API_URL}
fi

# Replace the value in runtime-config.js
cat <<EOF > /usr/share/nginx/html/runtime-config.js
window.RUNTIME_API_URL = "$API_URL";
EOF

### Dynamic set the backend endpoint for nginx  
export BACKEND_ENDPOINT=${INTERNAL_BACKEND:-http://localhost:8000}
envsubst '$BACKEND_ENDPOINT' < nginx.template.conf > /etc/nginx/conf.d/default.conf

exec "$@"
