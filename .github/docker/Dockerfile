# Use an official Ubuntu base image (you can change the version as needed)
FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && apt-get install -y \
    cmake \    
    clang \
    lld \
    libclang-rt-dev-wasm32 \
    git \
    make \
    nodejs \
    wget \
    jq \
    zstd \
  && rm -rf /var/lib/apt/lists/*

# Set the default command (optional)
CMD ["bash"]
