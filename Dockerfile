FROM nicohvi/centos

# install ruby dependencies
RUN yum -y install zlib-devel openssl-devel \
    readline-devel ncurses-devel libffi-devel \
    libxml2-devel libxslt-devel libcurl-devel \
    libicu-devel libyaml-devel \
    yum clean all

# download ruby source
RUN curl --progress http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz | tar xz && \
    cd ruby-2.1.3 && \
    ./configure --disable-install-doc && \
    make -j2 && make install && \
    cd .. && rm -rf ruby-2.1.3*

# install gems without docs
RUN echo 'gem: --no-rdoc --no-ri' > ~/.gemrc && \
    gem update --system && \
    gem install bundler

