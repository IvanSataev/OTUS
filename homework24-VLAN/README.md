# Задача:
* в Office1 в тестовой подсети появляется сервера с доп интерфесами и адресами в internal сети testLAN:
   * testClient1 - 10.10.10.254
   * testClient2 - 10.10.10.254
   * testServer1- 10.10.10.1
   * testServer2- 10.10.10.1
  
* Развести вланами:
   * testClient1 <-> testServer1
   * testClient2 <-> testServer2
  
* Между centralRouter и inetRouter:  
    * "пробросить" 2 линка (общая inernal сеть) и объединить их в бонд
    * проверить работу c отключением интерфейсов

![central](https://github.com/IvanSataev/OTUS/assets/17563920/7fa8acd5-3edb-4a0f-a461-87e2a2c307b6)
![inet](https://github.com/IvanSataev/OTUS/assets/17563920/581627fd-55bb-4f7b-a310-da748ffebb87)
