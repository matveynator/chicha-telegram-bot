# Dockerfile of github.com/matveynator/ChichaTeleBot TALK-to-TEXT telegram bot.
#FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
FROM ubuntu:22.04

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

RUN curl -sl http://files.matveynator.ru/ChichaTeleBot/latest/linux/amd64/ChichaTeleBot > /usr/local/bin/ChichaTeleBot
RUN chmod +x /usr/local/bin/ChichaTeleBot

RUN curl -sl http://files.matveynator.ru/ChichaTeleBot/latest/linux/amd64/fast-cuda-whisper > /usr/local/bin/fast-cuda-whisper
RUN chmod +x /usr/local/bin/fast-cuda-whisper

# Задаем переменную окружения
ENV LD_LIBRARY_PATH=/venv/lib/python3.10/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH

# Prefetch model inside docker container:
RUN /usr/local/bin/fast-cuda-whisper /app/ChichaTeleBot/test.ogg 


# Run ChichaTeleBot as a daemon
CMD ["/usr/local/bin/ChichaTeleBot"]
