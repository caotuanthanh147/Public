#!/bin/bash
cd
if [ -e "/data/data/com.termux/files/home/storage" ]; then
	rm -rf /data/data/com.termux/files/home/storage
fi
termux-setup-storage
yes | pkg update
. <(curl https://raw.githubusercontent.com/u400822/setup-termux/refs/heads/main/termux-change-repo.sh)
yes | pkg upgrade
yes | pkg i python
yes | pkg i python-pip
pip install requests prettytable pycryptodome asyncio pyjwt
export CFLAGS="-Wno-error=implicit-function-declaration"
pip install psutil
curl -Ls "https://cdn.quanghuynopro.com/store/main.py" -o /sdcard/Download/shouko.py
