#This Dockerfile sets up an Nginx web server with SSL/TLS support and custom configuration. 
#It takes advantage of build arguments for customizing SSL certificate and Nginx configuration, allowing you 
#to pass values when building the Docker image.

FROM debian:oldstable

#These are build arguments declared at the beginning of the Dockerfile. Build arguments are used to pass values 
#into the Docker image during the build process, allowing you to customize the image.
ARG CERTS_
ARG CERTS_KEY
ARG WORDPRESS_URL

#This line updates the package index, upgrades installed packages, and installs the required packages: 
#Nginx, OpenSSL, and gettext-base. Nginx is the web server, OpenSSL is used for SSL/TLS certificate generation, 
#and gettext-base is used for environment variable substitution (envsubst).
RUN apt update -y && apt upgrade && apt install -y nginx openssl gettext-base

#This command generates a self-signed SSL/TLS certificate and private key using OpenSSL. 
#The values for the certificate and key file paths are provided by the CERTS_ and CERTS_KEY build arguments. 
#The generated certificate will be used to enable HTTPS for the Nginx server.
RUN openssl req -batch -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout $CERTS_KEY -out $CERTS_

#This line removes the default Nginx configuration file (default) from the /etc/nginx/sites-enabled/ directory. 
#This step is often done to replace it with a custom configuration.
RUN rm -f /etc/nginx/sites-enabled/default

#This command copies a custom Nginx configuration template (default.template) from the local filesystem into the 
#/etc/nginx/conf.d/ directory within the Docker image. This template likely contains Nginx configuration directives 
#that will be customized during the image build.
COPY ./conf/default.template /etc/nginx/conf.d/

#This line uses the envsubst tool to perform environment variable substitution in the custom Nginx configuration template 
#(default.template). It replaces placeholders in the template with actual values. 
#This allows you to inject dynamic values, like the WORDPRESS_URL build argument, into the Nginx configuration.
RUN envsubst < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf

#Finally, this command specifies the default command to run when a container is started from this image. 
#It starts the Nginx web server with the daemon off; option, which keeps Nginx running in the foreground and ensures 
#that the container doesn't exit immediately after starting. 
#This is a common practice for running Nginx in Docker containers.
CMD ["nginx", "-g", "daemon off;"]