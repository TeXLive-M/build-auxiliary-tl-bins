#!/bin/sh

source versions.sh
if [ -f settings.sh ]; then
	source settings.sh
fi

download=true
extract=true
build=true

export ZIPS_DIR=${PWD}/zips
export BUILD_DIR=${PWD}/build

#---------
# download
#---------

if [ "$download" = true ]; then
	mkdir -p ${ZIPS_DIR}
	wget -P zips -c -N ${LZ_URL} 
	wget -P zips -c -N ${XZ_URL}
	wget -P zips -c -N ${WGET_URL}
fi

#--------
# extract
#--------

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

if [ "$extract" = true ]; then
	tar -xvzf ${ZIPS_DIR}/${LZ_FILE}
	tar -xvzf ${ZIPS_DIR}/${XZ_FILE}
	tar -xvzf ${ZIPS_DIR}/${WGET_FILE}
fi

#------
# build
#------

if [ "$build" = true ]; then
	cd $BUILD_DIR

	# lz4
	cd lz4-${LZ_VERSION}
	make
	strip lz4
	ls -l -h lz4
	cd $BUILD_DIR

	# xz
	cd xz-${XZ_VERSION}
	./configure \
		--disable-nls \
		--disable-shared \
		--disable-threads
	make
	strip src/xz/xz
	ls -l -h src/xz/xz
	cd $BUILD_DIR

	# wget
	cd wget-${WGET_VERSION}
	./configure \
		--enable-ipv6 \
		--disable-iri \
		--disable-nls \
		--disable-ntlm \
		--disable-pcre \
		--disable-pcre2 \
		--without-libiconv-prefix \
		--without-libintl-prefix \
		--without-libpsl \
		--without-libuuid \
		--without-ssl \
		--without-zlib
	make
	strip src/wget
	ls -l -h src/wget
	cd $BUILD_DIR
fi

