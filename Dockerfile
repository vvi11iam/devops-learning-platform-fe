# Build stage
FROM node:20-alpine as build

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies and the missing tailwind forms plugin
RUN npm install
RUN npm install @tailwindcss/forms

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy built assets from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.template.conf .

# Add a simple entrypoint script to replace API URL
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
# CMD ["/bin/sh" , "-c" , "envsubst '$INTERNAL_BACKEND' < nginx.template.conf > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"]
