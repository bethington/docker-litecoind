# Run to build docker image mainnet:
#   docker build --build-arg VERSION=v0.17.1 -t bethington/litecoind:v0.17.1 .
# Run to build docker image testnet:
#   docker build --build-arg VERSION=v0.17.1 --build-arg PARAMS=-testnet -t bethington/litecoind:v0.17.1-testnet .
FROM ubuntu:18.04
MAINTAINER Ben Ethington <benaminde@gmail.com>

# Install necessary tools and libraries
RUN apt-get update
RUN apt-get -y install git nano curl wget net-tools
RUN apt-get -y install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 \
 && apt-get clean
RUN apt-get -y install libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev \
                       libboost-chrono-dev libboost-test-dev libboost-thread-dev \
 && apt-get clean

# Install BerkeleyDB 4.8 to maintain binary wallet compatibility
RUN cd ~ \
 && wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz \
 && tar -xvf db-4.8.30.NC.tar.gz \
 && cd db-4.8.30.NC/build_unix \
 && mkdir -p build \
 && ../dist/configure --disable-shared --enable-cxx --with-pic --prefix=/root/build \
 && make install \
 && cd ~ \
 && rm -R db-4.8.30.NC \
 && rm db-4.8.30.NC.tar.gz
 
# Block and Transaction Broadcasting with ZeroMQ
RUN apt-get -y install libzmq3-dev \
 && apt-get clean

ARG VERSION
ENV VERSION ${VERSION}

# Compile download and litecoind
RUN cd ~ \
 && git clone https://github.com/litecoin-project/litecoin.git --branch ${VERSION} --single-branch \
 && cd litecoin \
 && ./autogen.sh \
 && ./configure CPPFLAGS="-I/root/build/include/ -O2" LDFLAGS="-L/root/build/lib/" --with-gui=no \
 && make \
 && make install \
 && cd ~ \
 && rm -R build \
 && rm -R litecoin

VOLUME /litecoin

EXPOSE 9332 9333

WORKDIR /litecoin

ARG PARAMS
ENV PARAMS ${PARAMS}

CMD litecoind -datadir=/litecoin -server=1 -rest=1 -rpcallowip==172.31.0.* -rpcuser=user -rpcpassword=pass ${PARAMS}
