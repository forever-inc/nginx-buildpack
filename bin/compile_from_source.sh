#!/usr/bin/env bash

# This script builds a custom version of Nginx with PCRE and HeadersMore included
# If the ENV var's are present, it will use those versions when building the binary
# otherwise it defaults to the ones marked here.


NGINX_VERSION=${NGINX_VERSION-1.13.0}
PCRE_VERSION=${PCRE_VERSION-8.40}
HEADERS_MORE_VERSION=${HEADERS_MORE_VERSION-0.32}

compile_log="$1/nginx_buildpack_compile_log.txt"
echo "NGINX_VERSION: ${NGINX_VERSION}" >> "$compile_log"
echo "PCRE_VERSION: ${PCRE_VERSION}" >> "$compile_log"
echo "HEADERS_MORE_VERSION: ${HEADERS_MORE_VERSION}" >> "$compile_log"

nginx_tarball_url=http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
pcre_tarball_url=http://downloads.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.bz2
headers_more_nginx_module_url=https://github.com/agentzh/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz

temp_dir=$(mktemp -d /tmp/nginx.XXXXXXXXXX)

cd $temp_dir
echo "Temp dir: $temp_dir"

echo "Downloading $nginx_tarball_url"
curl -L $nginx_tarball_url | tar xzv

echo "Downloading $pcre_tarball_url"
(cd nginx-${NGINX_VERSION} && curl -L $pcre_tarball_url | tar xvj )

echo "Downloading $headers_more_nginx_module_url"
(cd nginx-${NGINX_VERSION} && curl -L $headers_more_nginx_module_url | tar xvz )

(
	cd nginx-${NGINX_VERSION}
	./configure \
		--with-pcre=pcre-${PCRE_VERSION} \
		--prefix=/tmp/nginx \
		--add-module=/${temp_dir}/nginx-${NGINX_VERSION}/headers-more-nginx-module-${HEADERS_MORE_VERSION} \
        --with-http_v2_module \
        --with-http_ssl_module \
        --with-http_stub_status_module
	make install
)
