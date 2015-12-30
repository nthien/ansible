FROM ubuntu:14.04
MAINTAINER HienNT

#ENV http_proxy http://10.30.15.68:8888
#ENV https_proxy http://10.30.15.68:8888

# Surpress Upstart errors/warning
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Update base image
# Add sources for latest nginx
# Install software requirements
RUN apt-get update && \
apt-get install -y software-properties-common && \
apt-get update && \
apt-get upgrade -y && \
BUILD_PACKAGES="wget libssl-dev libpcre3 libpcre3-dev libpng-dev zlib1g-dev build-essential curl telnet supervisor git" && \
apt-get -y install $BUILD_PACKAGES && \
apt-get remove --purge -y software-properties-common && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
echo -n > /var/lib/apt/extended_states && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_*


##compile nginx
RUN useradd nginx
RUN wget http://nginx.org/download/nginx-1.8.0.tar.gz -O /tmp/nginx.tar.gz
ADD ./ngx_cache_purge-master /tmp/ngx_cache_purge-master
ADD ./nginx-1.8.0 /tmp/nginx-1.8.0
RUN cd /tmp/nginx-* && ./configure --prefix=/proxy/nginx --user=nginx --group=nginx --add-module=/tmp/ngx_cache_purge-master --with-http_gzip_static_module --with-http_ssl_module --with-http_secure_link_module --with-http_realip_module --with-http_spdy_module --with-http_stub_status_module && make && make install
Run mkdir /var/log/nginx
RUN mkdir /proxy/nginx/conf/vhost/
RUN rm -f /proxy/nginx/conf/nginx.conf
ADD ./nginx/conf/nginx.conf /proxy/nginx/conf/nginx.conf
ADD ./nginx/conf/vhost /proxy/nginx/conf/vhost
RUN mkdir -p /dev/cached


###turning tcp
RUN rm -rf /etc/sysctl.conf
ADD ./sysctl.conf /etc/sysctl.conf
RUN echo 'session required pam_limits.so' >> /etc/pam.d/common-session

# Supervisor Config
ADD ./supervisord.conf /etc/supervisord.conf

# Start Supervisord
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# Setup Volume
VOLUME ["/data/www"]

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Expose Ports
EXPOSE 80 443
#EXPOSE 8080 8081

RUN echo Asia/Ho_Chi_Minh | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

CMD ["/bin/bash", "/start.sh"]
