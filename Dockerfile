FROM ubuntu:14.04

#install deps
RUN dpkg-reconfigure locales
RUN apt-get update -qq -y
RUN apt-get install -qq debhelper libglib2.0-dev libmagic-dev libxml2-dev libtext-template-perl librpm-dev subversion rpm libpcre3-dev libssl-dev
RUN apt-get install -qq php5-pgsql php-pear php5-cli
RUN apt-get install -qq apache2 libapache2-mod-php5
RUN apt-get install -qq binutils bzip2 cabextract cpio sleuthkit genisoimage poppler-utils rpm upx-ucl unrar-free unzip p7zip-full p7zip
RUN apt-get install -qq wget subversion
RUN apt-get install -qq libpq-dev postgresql
RUN apt-get install -qqy nodejs node-gyp npm git

#linux binary fix
RUN ln -s /usr/bin/nodejs /usr/bin/node

ENV IN_DOCKER_CONTAINER true

ADD . /srclib/srclib-nomos/

#make nomos binary
WORKDIR /srclib/srclib-nomos/nomos
RUN make CFLAGS=-I/usr/include/glib-2.0

WORKDIR /srclib/srclib-nomos
ENV PATH /srclib/srclib-nomos/.bin:$PATH

RUN npm install

RUN useradd -ms /bin/bash srclib
USER srclib

WORKDIR /src

ENTRYPOINT ["srclib-nomos"]