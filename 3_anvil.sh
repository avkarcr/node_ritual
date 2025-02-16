#!/bin/bash
tmux kill-server
cd ~
curl -L https://foundry.paradigm.xyz | bash
docker stop infernet-anvil
foundryup
