# Написать скрипт для CRON, который раз в час будет формировать письмо и отправлять на заданную почту.
Необходимая информация в письме:

* Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
* Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
* Ошибки веб-сервера/приложения c момента последнего запуска;
* Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта.
* Скрипт должен предотвращать одновременный запуск нескольких копий, до его завершения.
* В письме должен быть прописан обрабатываемый временной диапазон.

Для работы скрипта в автоматическом режиме необходимо запусть скрипт /bash.sh . Так же для корректной отправки почты необходим почтовый клиент mutt, в cron строка добавляется автоматически, для блокировки выполнения исаользовал утилиту flock. Тестирование было проведено на ubuntu  20.04