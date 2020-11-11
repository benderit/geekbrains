Урок 5. Устройство файловой системы Linux. Понятие Файла и каталога
1. Создать файл file1 и наполнить его произвольным содержимым.
	dd if=/dev/urandom of=./file1 bs=4K count=10
		10+0 records in
		10+0 records out
		40960 bytes (41 kB, 40 KiB) copied, 0,000357012 s, 115 MB/s

Скопировать его в file2
	cp file1 file2

Создать символическую ссылку file3 на file1
	ln -s $PWD/file1 ./file3

Создать жёсткую ссылку file4 на file1
	ln $PWD/file1 ./file4

Посмотреть, какие inode у файлов.
	ls -li
		total 122
		102261 -rw-r--r-- 2 user root 40960 ноя 12 00:15 file1
		102262 -rw-r--r-- 1 user root 40960 ноя 12 00:15 file2
		102263 lrwxrwxrwx 1 user root    18 ноя 12 00:15 file3 -> /home/user/file1
		102261 -rw-r--r-- 2 user root 40960 ноя 12 00:15 file4

Удалить file1.
	rm file1
	
Что стало с остальными созданными файлами?
	символьная ссылка осталась, но стала битая, так как не существует file1, хотя его inode еще существует.
	жесткая ссылка осталась и это логично.
	ls -li
		total 82
		102262 -rw-r--r-- 1 user root 40960 ноя 12 00:15 file2
		102263 lrwxrwxrwx 1 user root    18 ноя 12 00:15 file3 -> /home/user/file1
		102261 -rw-r--r-- 1 user root 40960 ноя 12 00:15 file4	
	
Попробовать вывести их на экран.	
	cat: file1: No such file or directory
	cat: file3: No such file or directory

2. Дать созданным файлам другие, произвольные имена. Создать новую символическую ссылку. 
	dd if=/dev/urandom of=./newfile1 bs=4K count=10
	cp newfile1 newfile2
	ln -s $PWD/newfile1 ./newfile3
	ln $PWD/newfile1 ./newfile4
	mkdir new

Переместить ссылки в другую директорию
	mv newfile3 newfile4 new
	
	ls -li -R
		.:
		total 82
		102268 drwxr-xr-x 2 user root     4 ноя 12 00:28 new
		102265 -rw-r--r-- 2 user root 40960 ноя 12 00:27 newfile1
		102266 -rw-r--r-- 1 user root 40960 ноя 12 00:27 newfile2

		./new:
		total 41
		102267 lrwxrwxrwx 1 user root    21 ноя 12 00:27 newfile3 -> /home/user/newfile1
		102265 -rw-r--r-- 2 user root 40960 ноя 12 00:27 newfile4

3. Создать два произвольных файла. 
	touch 1
	touch 2
	
Первому присвоить права на чтение и запись для владельца и группы, только на чтение — для всех. 
	chmod 664 1
	chmod u=rw,g=rw,o=r 1
	
Второму присвоить права на чтение и запись только для владельца. Сделать это в численном и символьном виде.
	chmod 600 2
	chmod u=rw,g=,o= 2
	
4. Создать пользователя, обладающего возможностью выполнять действия от имени суперпользователя.
	PASSWORD='Df4@#$1f443'
	useradd -c hiro3 -m -s /bin/bash -G sudo -p $(openssl passwd -1 "${PASSWORD}") hiro3
	
5. * Создать группу developer и нескольких пользователей, входящих в неё. Создать директорию для совместной работы. 
	PASSWORD='Df4@#$1f443'
	useradd -c hiro1 -m -s /bin/bash -G sudo -p $(openssl passwd -1 "${PASSWORD}") hiro1
	useradd -c hiro2 -m -s /bin/bash -G sudo -p $(openssl passwd -1 "${PASSWORD}") hiro2
	useradd -c hiro3 -m -s /bin/bash -G sudo -p $(openssl passwd -1 "${PASSWORD}") hiro3

	groupadd hiro
	adduser hiro1 hiro (или gpasswd -a hiro1 hiro)
	adduser hiro2 hiro
	adduser hiro3 hiro
Сделать так, чтобы созданные одними пользователями файлы могли изменять другие пользователи этой группы.
	mkdir /devops
	chmod 770 /devops
	chgrp hiro /devops
	chmod g+s /devops
	
6. * Создать в директории для совместной работы поддиректорию для обмена файлами, но чтобы удалять файлы могли только их создатели.
	mkdir /devops/ownerparty
	chmod 770 /devops/ownerparty
	chmod +t /devops/ownerparty
	
7. * Создать директорию, в которой есть несколько файлов. Сделать так, чтобы открыть файлы можно было, только зная имя файла, а через ls список файлов посмотреть было нельзя.
	mkdir test
	echo "Secret place" > ./test/file1
	chmod -r test
	cd test
	ls
		ls: cannot open directory '.': Permission denied
	cat file1
		Secret place
