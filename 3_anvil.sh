#!/bin/bash
cd ~
apt update && apt install build-essential tmux -y
curl -L https://foundry.paradigm.xyz | bash
docker stop infernet-anvil
echo 'export PATH="$PATH:/root/.foundry/bin"' >> /etc/profile
source ~/.bashrc
foundryup
