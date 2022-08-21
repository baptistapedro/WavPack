FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake zlib1g zlib1g-dev pkg-config openssl libssl-dev curl libcurl4-openssl-dev
RUN git clone https://github.com/dbry/WavPack
WORKDIR /WavPack
RUN mkdir /wavpackCorpus
COPY multi:1187271e0587cfe7209f1071c877bf84784c80c4f7c932276d6bfdbfa9bb06a8 in /wavpackCorpus/ 
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang -DBUILD_SHARED_LIBS=true .
RUN make
RUN make install


ENTRYPOINT  ["afl-fuzz", "-i", "/wavpackCorpus", "-o", "/wavpackOut"]
CMD ["WavPack/wavpack", "@@", "out.wv"]
