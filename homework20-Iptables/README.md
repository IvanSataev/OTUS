# Задача:
* Реализовать knocking port
* centralRouter может попасть на ssh inetrRouter через knock скрипт
* Добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост.
* Запустить nginx на centralServer.
* Пробросить 80й порт на inetRouter2 8080.
* Дефолт в инет оставить через inetRouter.

# Задача со звёздочкой:
* Реализовать проход на 80й порт без маскарадинга