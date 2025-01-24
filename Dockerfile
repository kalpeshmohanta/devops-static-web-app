# Nginx image for web server
FROM nginx:alpine

# Remove default Nginx configuration file
RUN rm -rf /usr/share/nginx/html/*

# Working directory
WORKDIR /usr/share/nginx/html

# Copy static files to nginx html directory
COPY . .

# Expose Container Port 80
EXPOSE 80

# Start Nginx Server
CMD ["nginx", "-g", "daemon off;"]

