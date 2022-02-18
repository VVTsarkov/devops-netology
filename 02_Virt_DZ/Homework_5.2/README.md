Царьков В.В.
Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"
Задача 1

    Опишите своими словами основные преимущества применения на практике IaaC паттернов.
    Какой из принципов IaaC является основополагающим?


    Легкое масштабирование инфраструктуры
    Отслеживание изменений и откат к предыдущим версиям
    Удобный формат разработки приложений и отправка их в репозиторий/сервер(CI/CD)
    Создание однотипной среды, как для прода, так и для среды разработки и тестирования.

	Основополагающим IaaC принципом является получить понятный и предсказуемый, и легко повторяемый результат = Идемпотентность!


Задача 2

    Чем Ansible выгодно отличается от других систем управление конфигурациями?
    Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

	Нет неоходимости ставить Агента на хосты, плюс к этому написан на Python и YAML плейбуки, которые удобны для изучения.

Задача 3

Установить на личный компьютер:

    VirtualBox
	
	Графический интерфейс VirtualBox
	Версия 6.1.30 r148432 (Qt5.6.2)
	
    Vagrant
	
	D:\DZ\Vagrant>vagrant --version
	Vagrant 2.2.19
	
	Ansible
	
PS C:\WINDOWS\system32> wsl ansible --version
	ansible [core 2.12.2]
	config file = /etc/ansible/ansible.cfg
	configured module search path = ['/home/myhome/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
	ansible python module location = /usr/lib/python3/dist-packages/ansible
	ansible collection location = /home/myhome/.ansible/collections:/usr/share/ansible/collections
	executable location = /usr/bin/ansible
	python version = 3.8.10 (default, Jun  2 2021, 10:49:15) [GCC 9.4.0]
	jinja version = 2.10.1
	libyaml = True


Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.
Создать виртуальную машину.
	
MyHome@DESKTOP-OTUQDA4 MINGW64 /d/dz/Vagrant
$ vagrant up

Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Connection aborted. Retrying...
    server1.netology:
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology:
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => D:/DZ/Vagrant
==> server1.netology: Running provisioner: ansible...
Windows is not officially supported for the Ansible Control Machine.
Please check https://docs.ansible.com/intro_installation.html#control-machine-requirements
`playbook` does not exist on the host: D:/dz/ansible/provision.yml


Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды

MyHome@DESKTOP-OTUQDA4 MINGW64 /d/dz/Vagrant

$ vagrant ssh

Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 18 Feb 2022 09:30:35 AM UTC

  System load:  0.07               Processes:             109
  Usage of /:   11.8% of 30.88GB   Users logged in:       0
  Memory usage: 19%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1: 192.168.192.11

This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento

vagrant@server1:~$ cat /etc/*release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.3 LTS"
NAME="Ubuntu"
VERSION="20.04.3 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.3 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal

docker ps

Пока не разобрался как мне установить ВМ в автоматическом режиме с Docker. Работаю с ПК на Win10 и не совсем понимаю как состыковать эти процессы.
После установки Ansible на Win10 через PowerShell  и wsl запуская vagrant up ВМ создается но останавливается на процессе стыковки с Ansible.

