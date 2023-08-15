
Задание:
 Попасть в систему без пароля несколькими способами.
Установить систему с LVM, после чего переименовать VG.
Добавить модуль в initrd.
Для выполнения домашней работы использовал vagrant centos7 1804.02.
попасть в систему получилось 2 способами:
 init=/bin/sh
 rw init=/sysroot/bin/sh
 ![Uploading скрипт dracut .png…]()
![Uploading изменение volume group.png…]()
![изменения параметров загрузки](https://github.com/IvanSataev/OTUS/assets/17563920/6583add9-c08c-4a76-8ee5-c50b32d84b59)
![вывод скриптов загрузки](https://github.com/IvanSataev/OTUS/assets/17563920/7ac31830-f0ea-49fa-81fe-d2fd5bfcb2a5)
![Uploading rebuild dracut.png…]()
