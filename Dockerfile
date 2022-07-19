FROM amazonlinux:latest
LABEL maintainer="midmlwhd@gmail.com"

ENV NginxVersion 1.20.2

# Install dependencies
RUN yum update -y && \
    yum install -y make gcc gcc-c++ openssl-devel wget git patch && \
    yum clean all

# Download nginx
WORKDIR /usr/local/src

RUN wget https://nginx.org/download/nginx-${NginxVersion}.tar.gz && \
    tar -zxvf nginx-${NginxVersion}.tar.gz

# Nginx Forward-proxy Module
WORKDIR /usr/local/src/nginx-${NginxVersion}

RUN git clone https://github.com/chobits/ngx_http_proxy_connect_module.git && \
patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_101504.patch

# Nginx Install
RUN mkdir /opt/nginx
WORKDIR /opt/nginx
RUN ./configure 
    --prefix=/opt/nginx \
    --with-http_ssl_module \
    --with-stream \
    --with-http_ssl_module \
    --with-http_v2_module \
    --without-http_empty_gif_module \
    --add-module=./ngx_http_proxy_connect_module && \
    make & make install
    
# Nginx conf
WORKDIR /opt/nginx/conf
RUN rm -rf nginx.conf && \
    

