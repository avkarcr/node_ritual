#!/bin/bash
mkdir ritual && cd ritual

sudo ln -s $(which python3) /usr/bin/python
apt install python3.10-venv
python -m venv venv && source ./venv/bin/activate && pip install --upgrade pip
sudo tee -a ~/.bahsrc <<'EOF'
if [[ -n "$TMUX" && -z "$VIRTUAL_ENV" ]]; then
cd ~/ritual > /dev/null 2>&1
source ./venv/bin/activate > /dev/null 2>&1
fi
EOF

pip install infernet-cli
pip install infernet-client
infernet-cli config other --skip
infernet-cli add-service hello-world --skip
infernet-cli start
