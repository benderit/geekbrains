Урок 7. Управление пакетами и репозиториями.Основы сетевой безопасности
1. Подключить репозиторий с nginx любым удобным способом, установить nginx и потом удалить nginx, используя утилиту dpkg.
	sudo apt-add-repository ppa:nginx/stable -y
	sudo apt update
	sudo apt install -y nginx
	sudo dpkg -r nginx

2. Установить пакет на свой выбор, используя snap.
	sudo apt install snap
	sudo snap install minio

3. Настроить iptables: разрешить подключения только на 22-й и 80-й порты.
	sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
	sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
	sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
	sudo iptables -P INPUT DROP

4. * Настроить проброс портов локально с порта 80 на порт 8080.
	sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
