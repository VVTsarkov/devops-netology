# devops-netology
new line

**/.terraform/* - #Исключаем директорию .terraform и все что в ней. Игнорируем все что до директории .terraform

*.tfstate	- #Исключаем все файлы с расширением .tfstate
*.tfstate.* - #Игнорируем файлы, которые имеют в своем назавании 	".tfstate."

crash.log  - #Игнорируем crash.log

*.tfvars - #Исключаем файлы с расширением .tfvars

override.tf - #Игнорируем override.tf
override.tf.json - #Игнорируем override.tf.json
*_override.tf - #Исключаем всефайлы с окончанием _override.tf
*_override.tf.json - #Исключаем всефайлы с окончанием _override.tf.json


# !example_override.tf #т.к. строка закоментирована будет проигнорирована

# example: *tfplan* #т.к. строка закоментирована будет проигнорирована

.terraformrc - #Игнорируем файл с раширением .terraformrc
terraform.rc - #Игнорируем файл terraform.rc
