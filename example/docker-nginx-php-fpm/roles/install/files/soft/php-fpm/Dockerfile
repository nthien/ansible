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
BUILD_PACKAGES="libssl-dev libpcre3 libpcre3-dev libpng-dev zlib1g-dev build-essential git curl vsftpd telnet libapache2-mod-php5 supervisor php5-fpm git php5-ldap php5-mysql php-apc php5-curl php5-gd php5-intl php5-mcrypt php5-memcache php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-pgsql php5-mongo php5-imagick pwgen" && \
apt-get -y install $BUILD_PACKAGES && \
apt-get remove --purge -y software-properties-common && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
echo -n > /var/lib/apt/extended_states && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_*


#####composer
RUN curl -sS https://getcomposer.org/installer | php && \ 
mv composer.phar /usr/local/bin/composer && \
composer self-update
RUN mkdir -p /data/www
#RUN /usr/local/bin/composer create-project laravel/laravel /data/www/ --prefer-dist

####bower
RUN curl -sL https://deb.nodesource.com/setup | bash -  && \
apt-get install -y nodejs  && \
apt-get remove --purge curl -y  && \
apt-get clean  && \
npm install -g bower

###vsftpd
RUN mkdir -p /var/run/vsftpd/empty
RUN echo 'www-data:Vng@1234' | chpasswd
RUN echo 'seccomp_sandbox=no' >> /etc/vsftpd.conf
RUN sed -i -e "s/pam_service_name=vsftpd/pam_service_name=ftp/g" /etc/vsftpd.conf && \
echo 'chroot_local_user=YES' >> /etc/vsftpd.conf

# tweak php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 10M/g" /etc/php5/fpm/php.ini && \
#sed -i -e "s/session.save_handler\s*=\s*files/session.save_handler = memcache/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/expose_php\s*=\s*On/expose_php = Off/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 10M/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf 
RUN rm -rf /etc/php5/fpm/pool.d/www.conf
ADD ./www.conf /etc/php5/fpm/pool.d/www.conf
#RUN echo 'session.save_path = "tcp://10.40.96.11:11211"' >> /etc/php5/fpm/php.ini

#### LDAPS
RUN echo 'TLS_REQCERT never' >> /etc/ldap/ldap.conf


# fix ownership of sock file for php-fpm
RUN sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php5/fpm/pool.d/www.conf && \
find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

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

#COPY ./entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]

# Expose Ports
EXPOSE 9000 
EXPOSE 21

CMD ["/bin/bash", "/start.sh"]

RUN echo Asia/Ho_Chi_Minh | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

#ENV http_proxy ""
#ENV https_proxy ""
