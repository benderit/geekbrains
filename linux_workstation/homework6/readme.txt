Урок 6. Введение в скрипты bash. Планировщики задач crontab и at
1. Написать скрипт, который удаляет из текстового файла пустые строки и заменяет маленькие символы на большие. Воспользуйтесь tr или SED.
	#1.1 Создадим файл
	cat << EOF |sudo tee -a text.txt
	[Unit]
	Description=The Rocket.Chat server
	After=network.target remote-fs.target nss-lookup.target nginx.target mongod.target

	[Service]
	ExecStart=/usr/local/bin/node /opt/Rocket.Chat/main.js
	StandardOutput=syslog
	StandardError=syslog
	SyslogIdentifier=rocketchat
	User=rocketchat
	Environment=MONGO_URL=mongodb://localhost:27017/rocketchat?replicaSet=rs01 MONGO_OPLOG_URL=mongodb://localhost:27017/local?replicaSet=rs01 ROOT_URL=http://localhost:3000/ PORT=3000

	[Install]
	WantedBy=multi-user.target
	EOF

	#1.2 Удалим пустые строки.
	sed -i '/^$/d' text.txt

	#1.3 Сделаем upper case
	sed -i 's/[a-z]/\U&/g' text.txt

	#1.4 Посмотрим на результат
	cat text.txt
	
2. Создать однострочный скрипт, который создаст директории для нескольких годов (2010–2017), в них — поддиректории для месяцев (от 01 до 12), и в каждый из них запишет несколько файлов с произвольными записями. Например, 001.txt, содержащий текст «Файл 001», 002.txt с текстом «Файл 002» и т. д.
	mkdir -p {2010..2017}/{01..12}; for y in {2010..2017}; do for m in {01..12}; do for d in {01..05};do echo "File $d" > $y/$m/$d.txt;done;done;done;

3. * Использовать команду AWK на вывод длинного списка каталога, чтобы отобразить только права доступа к файлам. 
	Затем отправить в конвейере этот вывод на sort и uniq, чтобы отфильтровать все повторяющиеся строки.
	ll /etc | awk '{print $1}' | sort | uniq | grep -v total
	
4. Используя grep, проанализировать файл /var/log/syslog, отобрав события на своё усмотрение.
	grep error /var/log/syslog
	
5. Создать разовое задание на перезагрузку операционной системы, используя at.
	sudo apt-get install at
	sudo systemctl enable atd
	sudo systemctl start atd
	echo "init 6" | sudo at -m now +1 minute
	
6. * Написать скрипт, делающий архивную копию каталога etc, и прописать задание в crontab.
	sudo mkdir -p /backup/etc/
	sudo crontab -u root -l > /tmp/cron; echo -en "30 3 * * * tar -cpjf /backup/etc/etc_$(date +%d_%b).tar.bz2 /etc\n" >> /tmp/cron; cat /tmp/cron | sudo crontab -u root -;rm /tmp/cron
