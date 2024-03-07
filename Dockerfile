# Dockerfile for the TALK-to-TEXT Telegram bot from github.com/matveynator/ChichaTeleBot.

# Choose the base image - Ubuntu 22.04
FROM ubuntu:22.04

# Set the environment variable ARCH based on the architecture of the system
RUN dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
        "amd64") ARCH="amd64" ;; \
        "arm64") ARCH="arm64" ;; \
        "armhf") ARCH="arm" ;; \
        "i386") ARCH="386" ;; \
        "mips64el") ARCH="mips64le" ;; \
        "mipsel") ARCH="mipsle" ;; \
        "ppc64el") ARCH="ppc64le" ;; \
        "s390x") ARCH="s390x" ;; \
        *) echo "Unknown architecture: $dpkgArch" && exit 1 ;; \
    esac \
    && echo "Architecture: $ARCH" \
    && echo "$ARCH" > /tmp/ARCH

# Download latest ChichaTeleBot and fast-cuda-whisper binaries
ADD http://files.matveynator.ru/ChichaTeleBot/latest/linux/$(cat /tmp/ARCH)/ChichaTeleBot /usr/local/bin/ChichaTeleBot
RUN chmod +x /usr/local/bin/ChichaTeleBot

ADD http://files.matveynator.ru/ChichaTeleBot/latest/linux/$(cat /tmp/ARCH)/fast-cuda-whisper /usr/local/bin/fast-cuda-whisper
RUN chmod +x /usr/local/bin/fast-cuda-whisper

# Set default runtime to NVIDIA and define GPU capabilities
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Install necessary dependencies
RUN apt-get update && apt-get -y install curl gnupg lsb-release

# Install necessary packages including Python, Pip, Git, Golang, FFmpeg, and Vim
RUN apt-get install -y python3 python3-pip python3-venv git golang-go ffmpeg vim;

# Clean up package manager cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ;

# Create a virtual environment
RUN python3 -m venv /venv

# Activate the virtual environment
ENV PATH="/venv/bin:/root/.local/bin:$PATH"

# Install pipx within the virtual environment
RUN /venv/bin/pip3 install --upgrade pip 

# Install CUDA NVIDIA Drivers
RUN /venv/bin/pip3 install nvidia-cublas-cu12 nvidia-cudnn-cu12

# Install faster-whisper library
RUN /venv/bin/pip3 install --force-reinstall "faster-whisper @ https://github.com/guillaumekln/faster-whisper/archive/refs/heads/master.tar.gz"

# Set LD_LIBRARY_PATH environment variable
ENV LD_LIBRARY_PATH=/venv/lib/python3.10/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH

# Prefetch model inside the Docker container
ADD https://github.com/matveynator/ChichaTeleBot/raw/main/test.ogg /tmp/test.ogg
RUN /usr/local/bin/fast-cuda-whisper /tmp/test.ogg 

# Run ChichaTeleBot as a daemon
CMD ["/usr/local/bin/ChichaTeleBot"]
