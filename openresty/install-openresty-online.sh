#!/usr/bin/env bash
#update:2022-08-02
# 增加google-perftools


OPENRESTY_URL="https://openresty.org/download/"
OPENRESTY_VER="1.21.4.1"
OPENSSL_VER="1.1.1l"
SOFTWARE_DIR="/data/software"
NGINX_PID=$(ps aux| grep nginx | grep master | awk '{print $5}')

#安装依赖
yum -y install epel-release gcc gcc-c++ gcc make wget  vim  lrzsz git readline-devel pcre-devel openssl-devel gcc postgresql-devel luajit luajit-devel libxml2libxml2-dev libxslt-devel gd-devel geoip geoip-devel


# 判断文件是否存在
file_exis(filename){
    

}


if [ ! -d $SOFTWARE_DIR ];then
   mkdir -p $SOFTWARE_DIR
fi

useradd www


# google-perftools
if [ -f  $SOFTWARE_DIR/libunwind-0.99.tar.gz  ];then
   tar zxvf libunwind-0.99.tar.gz &&  cd libunwind-0.99/  && CFLAGS=-fPIC ./configure --prefix=/usr && make CFLAGS=-fPIC &&  make CFLAGS=-fPIC  && ln -s /usr/lib/libunwind.so.7 /usr/lib64/libunwind.so.7
else
    cd $SOFTWARE_DIR && wget http://download.savannah.gnu.org/releases/libunwind/libunwind-0.99.tar.gz && tar zxvf libunwind-0.99.tar.gz &&  cd libunwind-0.99/  && CFLAGS=-fPIC ./configure --prefix=/usr && make CFLAGS=-fPIC &&  make CFLAGS=-fPIC  && ln -s /usr/lib/libunwind.so.7 /usr/lib64/libunwind.so.7
fi


if [ -f  $SOFTWARE_DIR/gperftools-2.7.tar.gz  ];then
  tar zxvf gperftools-2.7.tar.gz && cd gperftools-2.7 && ./configure --enable-frame-pointers && make && make install
else
    cd $SOFTWARE_DIR &&    wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.7/gperftools-2.7.tar.gz && tar zxvf gperftools-2.7.tar.gz && cd gperftools-2.7 && ./configure --enable-frame-pointers && make && make install
 
fi


# openssl
cd $SOFTWARE_DIR && wget --no-check-certificate https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz && tar -zxf openssl-$OPENSSL_VER.tar.gz

# brotli
cd $SOFTWARE_DIR && git clone https://github.com/google/ngx_brotli.git && cd ngx_brotli && git submodule update --init

# ngx_purge
cd $SOFTWARE_DIR && wget --no-check-certificate https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz && tar -zxf 2.3.tar.gz
# verynginx
cd /opt && git clone https://github.com/alexazhou/VeryNginx.git && mv VeryNginx verynginx && chmod 755 -R /opt/verynginx&& chown www.www -R /opt/verynginx

# install openresty
#cd $SOFTWARE_DIR && wget https://openresty.org/download/openresty-$OPENRESTY_VER.tar.gz && tar -zxf openresty-$OPENRESTY_VER.tar.gz && cd openresty-$OPENRESTY_VER && ./configure --user=www --group=www --prefix=/usr/local --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module --with-http_sub_module --with-stream --with-stream_ssl_module --with-http_geoip_module --with-openssl=/data/software/openssl-$OPENSSL_VER  --with-openssl-opt='enable-weak-ssl-ciphers' --add-module=/data/software/ngx_brotli --add-module=$SOFTWARE_DIR/ngx_cache_purge-2.3 && gmake && gmake install
cd $SOFTWARE_DIR &&  cd openresty-$OPENRESTY_VER && ./configure --user=www --group=www --prefix=/usr/local --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module --with-http_sub_module --with-stream --with-stream_ssl_module --with-http_geoip_module --with-openssl=/data/software/openssl-$OPENSSL_VER  --with-openssl-opt='enable-weak-ssl-ciphers' --add-module=/data/software/ngx_brotli --add-module=$SOFTWARE_DIR/ngx_cache_purge-2.3  --with-google_perftools_module && gmake && gmake install


