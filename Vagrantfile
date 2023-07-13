# -*- mode: ruby -*-
# vi: set ft=ruby :

#Параметры указываются в цикле
Vagrant.configure("2") do |config|
  #Указываем, какую ОС мы будем использовать
  config.vm.box = "centos/7"
  #Можно указать конкретную версию сборки 
  #Номера сборок можно посмотреть в Vagrant Cloud
  config.vm.box_version = "2004.01"

  #Проброс порта с гостевой машины в хост
  #Порт 80 в созданной ВМ будет доступен нам на порту 8080 хоста
  config.vm.network "forwarded_port", guest: 80, host: 8080

  #Указываем настройки спецификации ВМ
  #Указывается в отдельном цикле
  config.vm.provider "virtualbox" do |vb|
     # Указываем количество ОЗУ и ядер процессора
     vb.memory = "512"
     vb.cpus = "1"
  end
  
  #Первоначальная настройка созданной ВМ
  #Установка и запуск Веб-сервера Apache2
  config.vm.provision "shell", inline: <<-SHELL
     sudo yum install -y httpd
     sudo systemctl start httpd
  SHELL
end
