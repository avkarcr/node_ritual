# Установка ноды Ritual

## Требования к железу
- **Минимальные требования: 1/1/20 с ОС Ubuntu 20/22**
- **Рекомендуемые требования: 4/16/500 с ОС Ubuntu 20/22**
- **Мой выбор: 2/4/60 с ОС Ubuntu 20/22**

## Первоначальная настройка сервера

### 1. **Подготовка к установке**
  ```bash
  source <(wget -qO- 'https://raw.githubusercontent.com/avkarcr/node_ritual/refs/heads/main/tmux.sh')
  ```

### 2. **Настройка сервера**
  ```bash
  source <(wget -qO- 'https://raw.githubusercontent.com/avkarcr/node_ritual/refs/heads/main/prepare.sh')
  ```

### 3. **Установка окружения Python**
  ```bash
  source <(wget -qO- 'https://raw.githubusercontent.com/avkarcr/node_ritual/refs/heads/main/1_python.sh')
  ```

### 4. **Запуск off-chain ноды (контейнер Hello World)**
  ```bash
  source <(wget -qO- 'https://raw.githubusercontent.com/avkarcr/node_ritual/refs/heads/main/2_hello_world.sh')
  ```

### 5. **Запуск on-chain ноды (контейнер Anvil)**
  ```bash
  source <(wget -qO- 'https://raw.githubusercontent.com/avkarcr/node_ritual/refs/heads/main/3_anvil.sh')
  ```
