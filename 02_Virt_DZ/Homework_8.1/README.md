Царьков В.В.
Домашнее задание к занятию "08.01 Введение в Ansible"
Подготовка к выполнению

    Установите ansible версии 2.10 или выше.
```
root@vagrant:~# ansible --version
ansible [core 2.12.3]
```
    Создайте свой собственный публичный репозиторий на github с произвольным именем.

    Скачайте playbook из репозитория с домашним заданием и перенесите его в свой репозиторий.

Основная часть

    Попробуйте запустить playbook на окружении из test.yml, зафиксируйте какое значение имеет факт some_fact для указанного хоста при выполнении playbook'a.
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] *************************************************************************************

TASK [Gathering Facts] ************************************************************************************
ok: [localhost]

TASK [Print OS] *******************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
    Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# cat group_vars/all/examp.yml
---
  some_fact: 12
```
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# cat group_vars/all/examp.yml
---
  some_fact: 'all default fact'
```
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] *************************************************************************************

TASK [Gathering Facts] ************************************************************************************
ok: [localhost]

TASK [Print OS] *******************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
    Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.
```
docker-compose.yml

version: '3.5'
services:
  centos7:
    image: pycontribs/centos:7
    container_name: centos7
    restart: always
    command: /bin/sleep infinity
  ubuntu:
    image: pycontribs/ubuntu:latest
    container_name: ubuntu
    restart: always
    command: /bin/sleep infinity
```
```
root@vagrant:/vagrant/ansible/ansible_8.1# docker ps
CONTAINER ID   IMAGE                      COMMAND                 CREATED         STATUS         PORTS     NAMES
871c7a6199c9   pycontribs/centos:7        "/bin/sleep infinity"   5 minutes ago   Up 5 minutes             centos7
96dff2031c32   pycontribs/ubuntu:latest   "/bin/sleep infinity"   5 minutes ago   Up 5 minutes             ubuntu
```
    Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed host.
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# ansible-playbook -i inventory/prod.yml -v site.yml
Using /etc/ansible/ansible.cfg as config file

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
    Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились следующие значения: для deb - 'deb default fact', для el - 'el default fact'.
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# cat group_vars/deb/examp.yml && cat group_vars/el/examp.yml
---
  some_fact: "deb default fact"
---
  some_fact: "el default fact"

```
    Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
    При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# ansible-vault encrypt group_vars/deb/examp.yml group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful

root@vagrant:/vagrant/ansible/ansible_8.1/playboock# cat group_vars/deb/examp.yml && cat group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
39656464663332656566306362623739623766303731643033383830343633353263343764636165
3630653164396634303132643465326130333534366339360a313538396566666537326335616664
30346364636337613439386134666235616432333235633932343436633035336466643966643732
3835616365386463300a306331653866623938656438313463613538373830366563313734323935
39313437323630376532306337373066313664363430643462646335653064313264323265333264
3539316132663537336335323066346463636436333466346338
$ANSIBLE_VAULT;1.1;AES256
32643338313536343261653333613439623164343830373765343965663130336530336637653566
6638333636353864393634303633383331366663636661310a616135663766643539366135353031
34363132376634346562633433623361626330393864316166626138376666623161316361363535
6164656666343237610a336130376536383438653636323566626639383964666632373135636639
63376638363533356638393737366335663033346532383863653932396631343666636237633136
3537376439633165326361373632383535656634306638616139
```
    Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
    Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.
```
local                          execute on controller
```
    В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock/inventory# cat prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local

```
    Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь что факты some_fact для каждого из хостов определены из верных group_vars.
```
root@vagrant:/vagrant/ansible/ansible_8.1/playboock# ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
    Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым playbook и заполненным README.md.

