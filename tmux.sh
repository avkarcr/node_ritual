echo -e "\n\e[1m\e[34mПодготовка сервера: 1. Установка и настройка tmux...\e[0m\n"
sleep 2
tee <<EOF >> ~/.bashrc
PS1="\[\e[1;34m\]ritual:\w\\\\$\[\e[0m\] "
EOF
sudo apt update && sudo apt install tmux -y
sudo echo "alias on='tmux set-option -g mouse on'" >> /etc/profile
sudo echo "alias off='tmux set-option -g mouse off'" >> /etc/profile
instruction_text='''
Сессия tmux будет автоматически запускаться при входе на сервер.
Свернуть сессию можно комбинацией клавиш ctrl+b, d (сначала ctrl+b, а потом нажать d).

Для включения/отключения режима прокрутки экрана в сессии tmux используйте команды:
on - прокрутка разрешена,
off - прокрутка запрещена, разрешено выделение текста.

Чтобы выделить много текста, войдите в "режим выделения" с помощью комбинации клавиш ctrl+b, [.
Выход из режима выделения - ESC.
'''
echo -e "${instruction_text}\n"
echo -e "Эта инструкция будет сохранена в текстовом файле по адресу: ~/instruction.txt.\n"
read -n 1 -s -r -p "Нажмите любую клавишу для продолжения..."
if ! grep -q 'if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then' /etc/profile; then
sudo tee -a /etc/profile <<'EOF'
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
tmux attach -t main || tmux new -s main
fi
EOF
fi
tmux new -s main