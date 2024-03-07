# Dockerfile of github.com/matveynator/ChichaTeleBot TALK-to-TEXT telegram bot.
#FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
FROM ubuntu:22.04

# Получаем архитектуру и устанавливаем соответствующую переменную TARGET_ARCH
RUN ARCHITECTURE=$(uname -m) \
    && case $ARCHITECTURE in \
        "i386") TARGET_ARCH="386" ;; \
        "x86_64" | "amd64") TARGET_ARCH="amd64" ;; \
        "armv6l" | "armv7l") TARGET_ARCH="arm" ;; \
        "aarch64") TARGET_ARCH="arm64" ;; \
        "mips") TARGET_ARCH="mips" ;; \
        "mips64") TARGET_ARCH="mips64" ;; \
        "mips64le") TARGET_ARCH="mips64le" ;; \
        "mipsle") TARGET_ARCH="mipsle" ;; \
        "ppc64") TARGET_ARCH="ppc64" ;; \
        "ppc64le") TARGET_ARCH="ppc64le" ;; \
        "riscv64") TARGET_ARCH="riscv64" ;; \
        "s390x") TARGET_ARCH="s390x" ;; \
        *) echo "Неизвестная архитектура: $ARCHITECTURE" && exit 1 ;; \
    esac \
    && echo "Архитектура: $TARGET_ARCH"

# Set the default runtime to NVIDIA
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Install necessary dependencies
RUN apt-get update && apt-get -y install curl gnupg lsb-release

# Install necessary packages
RUN apt-get install -y python3 python3-pip python3-venv git golang-go ffmpeg vim;

# Clean up the package manager cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ;

# Create a virtual environment
RUN python3 -m venv /venv

# Activate the virtual environment
ENV PATH="/venv/bin:/root/.local/bin:$PATH"

# Install pipx within the virtual environment
RUN /venv/bin/pip3 install --upgrade pip 

# CUDA NVIDIA Drivers:
RUN /venv/bin/pip3 install nvidia-cublas-cu12 nvidia-cudnn-cu12

# Install faster-whisper
RUN /venv/bin/pip3 install --force-reinstall "faster-whisper @ https://github.com/guillaumekln/faster-whisper/archive/refs/heads/master.tar.gz"

# Get latest ChichaTeleBot and fast-cuda-whisper

ADD http://files.matveynator.ru/ChichaTeleBot/latest/linux/$TARGET_ARCH/ChichaTeleBot /usr/local/bin/ChichaTeleBot
RUN chmod +x /usr/local/bin/ChichaTeleBot

ADD http://files.matveynator.ru/ChichaTeleBot/latest/linux/$TARGET_ARCH/fast-cuda-whisper /usr/local/bin/fast-cuda-whisper
RUN chmod +x /usr/local/bin/fast-cuda-whisper

# Задаем переменную окружения
ENV LD_LIBRARY_PATH=/venv/lib/python3.10/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH

# Prefetch model inside docker container:
ADD https://github.com/matveynator/ChichaTeleBot/raw/main/test.ogg /tmp/test.ogg
RUN /usr/local/bin/fast-cuda-whisper /tmp/test.ogg 


# Run ChichaTeleBot as a daemon
CMD ["/usr/local/bin/ChichaTeleBot"]
