#!/bin/bash
cd ~
curl -L https://foundry.paradigm.xyz | bash
docker stop infernet-anvil
foundryup
