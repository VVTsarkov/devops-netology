# Царьков В.В. 
# Домашнее задание к занятию "08.02 Работа с Playbook"

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
```
root@vagrant:/vagrant/ansible/ansible_8.2/playbook/inventory# cat prod.yml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 172.20.10.2

vector:
  hosts:
    vector-app:
      ansible_host: 172.20.10.2
```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
```
root@vagrant:/vagrant/ansible/ansible_8.2/playbook# cat site.yml
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - name: Install click
      block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
            mode: 0644
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib x86_64
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
            mode: 0644
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Flush handlers
      ansible.builtin.meta: flush_handlers
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
- name: Install Vector
  hosts: vector
  handlers:
    - name: Start vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: Download distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm"
        dest: "./vector-{{ vector_version }}.rpm"
        mode: 0644
    - name: Install Vector
      become: true
      ansible.builtin.yum:
        name: "vector-{{ vector_version }}.rpm"
      notify: Start vector service
```
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
root@vagrant:/vagrant/ansible/ansible_8.2/playbook# ansible-lint site.yml -vv
WARNING: PATH altered to include /usr/bin
DEBUG    Logging initialized to level 10
DEBUG    Options: Namespace(cache_dir='/root/.cache/ansible-lint/6ea18a', colored=True, config_file=None, configured=True, cwd=PosixPath('/vagrant/ansible/ansible_8.2/playbook'), display_relative_path=True, enable_list=[], exclude_paths=['.cache', '.git', '.hg', '.svn', '.tox'], extra_vars=None, format='rich', kinds=[{'jinja2': '**/*.j2'}, {'jinja2': '**/*.j2.*'}, {'inventory': '**/inventory/**.yml'}, {'requirements': '**/meta/requirements.yml'}, {'galaxy': '**/galaxy.yml'}, {'reno': '**/releasenotes/*/*.{yaml,yml}'}, {'playbook': '**/playbooks/*.{yml,yaml}'}, {'playbook': '**/*playbook*.{yml,yaml}'}, {'role': '**/roles/*/'}, {'tasks': '**/tasks/**/*.{yaml,yml}'}, {'handlers': '**/handlers/*.{yaml,yml}'}, {'vars': '**/{host_vars,group_vars,vars,defaults}/**/*.{yaml,yml}'}, {'meta': '**/meta/main.{yaml,yml}'}, {'yaml': '.config/molecule/config.{yaml,yml}'}, {'requirements': '**/molecule/*/{collections,requirements}.{yaml,yml}'}, {'yaml': '**/molecule/*/{base,molecule}.{yaml,yml}'}, {'requirements': '**/requirements.yml'}, {'playbook': '**/molecule/*/*.{yaml,yml}'}, {'yaml': '**/{.ansible-lint,.yamllint}'}, {'yaml': '**/*.{yaml,yml}'}, {'yaml': '**/.*.{yaml,yml}'}], lintables=['site.yml'], listrules=False, listtags=False, loop_var_prefix=None, mock_modules=[], mock_roles=[], offline=None, parseable=False, parseable_severity=False, progressive=False, project_dir='.', quiet=0, rules={}, rulesdir=[], rulesdirs=['/usr/local/lib/python3.8/dist-packages/ansiblelint/rules'], skip_action_validation=True, skip_list=[], tags=[], use_default_rules=False, var_naming_pattern=None, verbosity=2, version=False, warn_list=['experimental', 'role-name'])
DEBUG    /vagrant/ansible/ansible_8.2/playbook
DEBUG    Loading rules from /usr/local/lib/python3.8/dist-packages/ansiblelint/rules
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
INFO     Executing syntax check on site.yml (1.17s)
DEBUG    Examining site.yml of type playbook
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
root@vagrant:/vagrant/ansible/ansible_8.2/playbook# ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] *************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib x86_64] **************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] *****************************************************************************************************************

TASK [Create database] ****************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [vector-app]

TASK [Download distrib] ***************************************************************************************************************
ok: [vector-app]

TASK [Install Vector] *****************************************************************************************************************
ok: [vector-app]

PLAY RECAP ****************************************************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0
vector-app                 : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
root@vagrant:/vagrant/ansible/ansible_8.2/playbook# ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib x86_64] **************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] *****************************************************************************************************************

TASK [Create database] ****************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [vector-app]

TASK [Download distrib] ***************************************************************************************************************
ok: [vector-app]

TASK [Install Vector] *****************************************************************************************************************
ok: [vector-app]

PLAY RECAP ****************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-app                 : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
root@vagrant:/vagrant/ansible/ansible_8.2/playbook# ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib x86_64] **************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] *****************************************************************************************************************

TASK [Create database] ****************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [vector-app]

TASK [Download distrib] ***************************************************************************************************************
ok: [vector-app]

TASK [Install Vector] *****************************************************************************************************************
ok: [vector-app]

PLAY RECAP ****************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-app                 : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.


