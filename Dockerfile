FROM mcr.microsoft.com/dotnet/sdk:8.0 AS base

# Install Swift dependencies
RUN apt-get update && apt-get install -y \
    binutils \
    git \
    libc6-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgcc-9-dev \
    libpython3.8 \
    libsqlite3-0 \
    libstdc++-9-dev \
    libxml2-dev \
    libz3-dev \
    pkg-config \
    tzdata \
    unzip \
    zlib1g-dev \
    wget \
    gnupg2 \
    bc \
    && rm -rf /var/lib/apt/lists/*

# Install Swift
ARG SWIFT_VERSION=5.9.2
ARG SWIFT_PLATFORM=ubuntu20.04
ARG SWIFT_BRANCH=swift-${SWIFT_VERSION}-release
ARG SWIFT_TAG=swift-${SWIFT_VERSION}-RELEASE

WORKDIR /tmp
RUN wget https://download.swift.org/${SWIFT_BRANCH}/${SWIFT_PLATFORM}/${SWIFT_TAG}/${SWIFT_TAG}-${SWIFT_PLATFORM}.tar.gz
RUN tar xzf ${SWIFT_TAG}-${SWIFT_PLATFORM}.tar.gz -C /usr/local --strip-components=1
RUN rm -rf ${SWIFT_TAG}-${SWIFT_PLATFORM}.tar.gz

# Check Swift installation
RUN swift --version

# Set working directory
WORKDIR /app

# Copy the source code
COPY . .

# Make the script executable
RUN chmod +x scripts/run_benchmarks.sh

# Command to run benchmarks
ENTRYPOINT ["./scripts/run_benchmarks.sh"]