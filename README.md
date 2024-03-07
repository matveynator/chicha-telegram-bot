# ChichaTeleBot - your AI voice assistant on Telegram. 
## It saves your time! 
Powered by [SYSTRAN/faster-whisper](https://github.com/SYSTRAN/faster-whisper) transformer and [OpenAI/whisper-large-v2](https://huggingface.co/openai/whisper-large-v2) language model. Written in GO. Works in Docker.

ChichaTeleBot is a fantastic voice bot for Telegram that transforms spoken words into text, translates languages, and, most importantly, **keeps your messages private**. Named after Chicha, a cute pincher companion dog, this bot is here to assist you.


| <img src="https://github.com/matveynator/ChichaTeleBot/blob/main/apollo11.png?raw=true" width="100%">  <img src="https://github.com/matveynator/ChichaTeleBot/blob/main/chanelVoiceMemo.png?raw=true" width="100%"> | <img src="https://github.com/matveynator/ChichaTeleBot/blob/main/tom-yam.png?raw=true" width="100%" > |
| --- | --- |




🟢 **Live Telegram Demo:** [@ChichaTeleBot](https://t.me/ChichaTeleBot)

## Quick Installation via Docker:

```bash
docker pull matveynator/chichatelebot:latest
```

## Fast:
```bash
docker run -d --restart unless-stopped -e DEBUG="false" -e TELEGRAM_BOT_TOKEN="your_telegram_bot_token" --gpus all --name "your_telegram_bot_name" matveynator/chichatelebot:latest
```

## Slow:
```bash
docker run -d --restart unless-stopped -e DEBUG="false" -e TELEGRAM_BOT_TOKEN="your_telegram_bot_token" --name "your_telegram_bot_name" matveynator/chichatelebot:latest
```

## Privacy and 🔐 Security:
Please note: **CHICHA NEVER STORES YOUR TEXT OR VOICE MESSAGES.**
Allways set `DEBUG` to "false" to disable debugging, enhancing user data protection.

## System Requirements:
- ✅ Tested on UBUNTU Linux: [CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
- ✅ Tested NVIDIA graphics card: RTX 2070.
- 🚀 Recommended NVIDIA graphics card: RTX 4090.

## Building from Source:
Build ChichaTeleBot from the source code:

```bash
cd /usr/src
rm -rf /usr/src/ChichaTeleBot
git clone https://github.com/matveynator/ChichaTeleBot.git
cd ChichaTeleBot
docker build -t chichatelebot .
```

```bash
docker run -d --restart unless-stopped -e TELEGRAM_BOT_TOKEN="your_telegram_bot_token" -e DEBUG="false" --gpus all --name "your_telegram_bot_name" chichatelebot
```
Now you have a fully functional ChichaTeleBot, offering a seamless voice-to-text experience while ensuring privacy and security for your users.

## INSTALLING NVIDIA CUDA for Docker on Ubuntu:
```bash
echo "Installing CUDA Toolkit for Docker on Ubuntu..." && distribution=$(. /etc/os-release; echo $ID$VERSION_ID) && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list && apt-get update && apt-get -y install --reinstall nvidia-utils-535-server libnvidia-compute-535-server nvidia-dkms-535-server && apt-get install -y nvidia-container-toolkit && systemctl restart docker && echo "CUDA Toolkit installation completed."
```
