#    Srclib-Nomos, a toolchain for Srclib to scan files w/ Nomos License Scanner
#    Copyright (C) 2014 Fossa Inc.

#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

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