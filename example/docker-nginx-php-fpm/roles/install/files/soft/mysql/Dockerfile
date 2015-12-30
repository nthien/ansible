from mysql:5.5

MAINTAINER HienNT

#ENV http_proxy http://10.30.15.68:8888
#ENV https_proxy http://10.30.15.68:8888


RUN apt-get update
RUN apt-get install -y vim telnet
###turning tcp
RUN rm -f /etc/sysctl.conf
ADD ./sysctl.conf /etc/sysctl.conf

###Config
RUN rm -f /etc/mysql/my.cnf
ADD ./my.cnf /etc/mysql/my.cnf

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

##set timezone 
RUN echo Asia/Ho_Chi_Minh | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

#ENV http_proxy ""
#ENV https_proxy ""

