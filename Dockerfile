FROM alpine:3.7 as build

RUN apk add --no-cache git make cmake g++ libgcrypt-dev yajl-dev yajl \
    boost-dev curl-dev expat-dev cppunit-dev binutils-dev \
	pkgconfig \
	&& git clone https://github.com/vitalif/grive2.git \
	&& mkdir grive2/build \
	&& cd grive2/build  \
	&& cmake ..  \
	&& make -j4  \
	&& make install \
    && cd ../.. \
	&& rm -rf grive2 \
	&& mkdir /drive

FROM alpine:3.7

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 /bin/dumb-init
RUN mkdir /drive \
	&& apk add --no-cache tzdata yajl-dev curl-dev libgcrypt \
	boost-program_options boost-regex libstdc++ boost-system boost-dev binutils-dev \
	&& apk add --no-cache boost-filesystem --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main
COPY --from=build /usr/local/bin/grive /bin/grive
COPY ./entrypoint.sh /root/entrypoint.sh 
COPY ./run.sh /root/run.sh  
RUN chmod 777 /root/entrypoint.sh /root/run.sh /bin/dumb-init /bin/grive
VOLUME /drive
WORKDIR /drive
ENTRYPOINT ["dumb-init", "--"]
CMD /root/entrypoint.sh | while IFS= read -r line; do printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$line"; done;
