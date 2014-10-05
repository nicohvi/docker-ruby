FROM centos:centos6
MAINTAINER Nicolay Hvidsten <nicohvi@gmail.com>

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
    gem install bundler && \
    gem install passenger 

# install passenger nginx-module
# RUN 'passenger-install-nginx-module --auto-download --auto --prefix=/etc/nginx'

# add the directory housing our ruby app
RUN mkdir -p /var/www/nplol/public
ADD index.html /var/www/nplol/public

# add the user running our apps
RUN adduser app
RUN chown -R app /var/www
run chgrp -R app /var/www

# setup the correct nginx.conf 
RUN rm -v /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/

# run nginx in the foreground
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

# ENTRYPOINT nginx
