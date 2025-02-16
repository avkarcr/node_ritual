#!/bin/bash
echo -e "\n\e[1m\e[34mПодготовка сервера: 2. Установка необходимых программ...\e[0m\n"
sleep 2
docker_install() {
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc;
  do sudo apt remove $pkg -y &>/dev/null;
  done

  sudo apt install -y ca-certificates gpg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  echo -e "\n\e[1;32m-----------------------------------------------------------------\e[0m"
  echo -e "\e[1;32mDocker Engine with Docker Compose has been succesfully installed!\e[0m"
  echo -e "\e[1;32m-----------------------------------------------------------------\e[0m"
  echo
  echo -e "\e[1;32mDocker version: \t \t \e[1;33mv$(docker version | grep Version | head -n 1 | awk '{print $2}')\e[0m"
  echo -e "\e[1;32mDocker Compose version: \t \e[1;33m$(docker compose version | awk '{print $4}')\e[0m"
  echo
  echo -e "\e[1;32mEnter command 'dps' to see concised listing of active containers.\e[0m\n"
  echo -e "\nIt is recommended that you reboot the server typing 'reboot'."
}

run_sed() {
    local search_pattern="$1"
    local file="$2"
    local grep_pattern=$(echo "$search_pattern" | sed 's/^\/\^\[\[\:space\:]]\*//' | sed 's/\/d$//')
    if grep -q "${grep_pattern}" "$file"; then
        sed -i "$search_pattern" "$file"
    else
        error_flag=true
    fi
}

sudo touch /var/log/auth.log
sudo apt update && sudo apt install iptables htop curl cron fail2ban -y

config_file_base="/etc/fail2ban/jail.conf"
config_file="/etc/fail2ban/jail.local"
error_flag=false
if [ -f "$config_file_base" ]; then
    cp $config_file_base $config_file
    run_sed '/^[[:space:]]*findtime  = 10m/d' "$config_file"
    run_sed '/^[[:space:]]*maxretry = 5/d' "$config_file"
    run_sed '/^[[:space:]]*bantime  = 10m/d' "$config_file"
    run_sed '/^[[:space:]]*bantime\.increment =/d' "$config_file"
    run_sed '/^[[:space:]]*bantime\.rndtime =/d' "$config_file"
    run_sed '/^[[:space:]]*bantime\.factor =/d' "$config_file"
    run_sed '/^[[:space:]]*bantime\.formula =/d' "$config_file"
    if [ "$error_flag" = true ]; then
      echo -e "\r\nВерсия fail2ban не соответствует версии, под которую написан скрипт."
      echo "Используем стандартные настройки."
      cp $config_file_base $config_file
    else
      sed -i '/^\[DEFAULT\]/a findtime = 30m\nmaxretry = 3\nbantime = 60m\nbantime.increment = true\nbantime.rndtime = 60\nbantime.factor = 2\nbantime.formula = ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)' "$config_file"
      systemctl restart fail2ban
    fi
else
    error_flag=true
    echo "Установка fail2ban выполнена с ошибками."
fi

echo "alias dps='docker ps -a --format \"table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\"'" >> ~/.bashrc
docker_install
