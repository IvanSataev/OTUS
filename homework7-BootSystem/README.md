#Задание:
* Попасть в систему без пароля несколькими способами.
* Установить систему с LVM, после чего переименовать VG.
* Добавить модуль в initrd.

Для выполнения домашней работы использовал vagrant centos7 1804.02.

Попасть в систему получилось 2 способами:
 * init=/bin/sh
 * rw init=/sysroot/bin/sh
![изменения параметров загрузки](https://github.com/IvanSataev/OTUS/assets/17563920/6583add9-c08c-4a76-8ee5-c50b32d84b59)

изменение имени VG root:

![изменение volume group](https://github.com/IvanSataev/OTUS/assets/17563920/d9153bdc-43ad-4b44-9838-b4fd1ebf3a74)

Скрипт для dracut:

![скрипт dracut ](https://github.com/IvanSataev/OTUS/assets/17563920/dd4aa98b-087e-40cd-9f3b-e2a4fd7d51e2)

Ребилд dracut: 

![rebuild dracut](https://github.com/IvanSataev/OTUS/assets/17563920/066e6ec5-a7f3-4ee9-bde2-b59a3e9ca271)

Вывод скриптов загрузки:

![вывод скриптов загрузки](https://github.com/IvanSataev/OTUS/assets/17563920/e632eaf0-384a-42f6-b6ed-720342729085)
