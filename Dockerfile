FROM ubuntu

WORKDIR /app

RUN apt-get update
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa nano
RUN apt-get install -y \
    clang cmake git \
    ninja-build pkg-config \
    libgtk-3-dev liblzma-dev \
    libstdc++-12-dev
RUN git clone -b master https://github.com/flutter/flutter.git ../sdk
RUN echo 'export PATH="/sdk/bin/:$PATH"' >> ~/.bashrc
# RUN echo $PATH
# RUN flutter --version
RUN /sdk/bin/flutter doctor
COPY . .
RUN /sdk/bin/dart pub get
RUN /sdk/bin/dart test