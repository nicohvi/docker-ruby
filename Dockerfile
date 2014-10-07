FROM centos:centos6
MAINTAINER Nicolay Hvidsten <nicohvi@gmail.com>

RUN yum -y install sudo
RUN  sed -i "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    yum -y update && \
    yum -y groupinstall "Development Tools" && \
    yum -y install zlib-devel openssl-devel readline-devel ncurses-devel libffi-devel libxml2-devel libxslt-devel libcurl-devel libicu-devel libyaml-devel && \
    yum clean all

RUN curl --progress http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz | tar xz && \
    cd ruby-2.1.3 && \
    ./configure --disable-install-doc && \
    make -j2 && make install && \
    cd .. && rm -rf ruby-2.1.3*

RUN echo 'gem: --no-rdoc --no-ri' > ~/.gemrc && \
    gem update --system && \
    gem install bundler


    #gem install passenger 

## install passenger nginx-module
#RUN /bin/bash -l -c 'passenger-install-nginx-module --auto-download --auto --prefix=/etc/nginx'

## add nginx startup-script
#ADD nginx.sh /etc/init.d/nginx
#RUN chmod +x /etc/init.d/nginx

## add the log directory
#RUN mkdir -p /var/log/nginx

## add the directory housing our ruby app
#RUN mkdir -p /var/www/nplol/public
#ADD index.html /var/www/nplol/public/

## setup the correct nginx.conf 
#RUN useradd nginx
#ADD nginx.conf /etc/nginx/

## run nginx in the foreground
#RUN echo "daemon off;" >> /etc/nginx/nginx.conf

#EXPOSE 80

#ENTRYPOINT sudo /etc/init.d/nginx start
