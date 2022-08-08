Царьков В.В.
Домашнее задание к занятию "7.5. Основы golang"

С golang в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. Но рекомендуем ознакомиться с GoLand.
Задача 1. Установите golang.

    Воспользуйтесь инструкций с официального сайта: https://golang.org/.
    Так же для тестирования кода можно использовать песочницу: https://play.golang.org/.
```
root@vagrant:~# go version
go version go1.13.8 linux/amd64
```

Задача 2. Знакомство с gotour.

У Golang есть обучающая интерактивная консоль https://tour.golang.org/. Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.
Задача 3. Написание кода.

Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода на своем компьютере, либо использовать песочницу: https://play.golang.org/.

    Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные у пользователя, а можно статически задать в коде. Для взаимодействия с пользователем можно использовать функцию Scanf:

    package main

    import "fmt"

    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)

        output := input * 2

        fmt.Println(output)    
    }
```
package main

import "fmt"

func MtoF(m float64)(f float64) {
    f = m * 3.281
    return
}

func main() {
    fmt.Print("Введите длину в метрах (для перевода в футы): ")
    var input float64
    fmt.Scanf("%f", &input)

    output := MtoF(input)

    fmt.Printf("В метрах %v, а в футах это %v\n", input, output)
}
```
```
root@vagrant:~/golang# go run conv_meter_to_foot.go
Input length in meters: 5
Footage: 16.405

```
    Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:

    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
```
package main

import "fmt"
import "sort"

func GetMin (toSort []int)(minNum int) {
	sort.Ints(toSort)
	minNum = toSort[0]
	return
}

func main() {
	x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
	y := GetMin(x)
	fmt.Printf("Наименьшее число в списке: %v\n", y)
}
```
```
root@vagrant:~/golang# go run search_min_num.go
The smallest number in the list: 9
```
    Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть (3, 6, 9, …).
```
package main

import "fmt"

func FilterList ()(devidedWithNoReminder []int) {
	for i := 1;  i <= 100; i ++ {
		if	i % 3 == 0 { 
			devidedWithNoReminder = append(devidedWithNoReminder, i)
		}
	}	
	return
}

func main() {
	toPrint := FilterList()
	fmt.Printf("Числа от 1 до 100, которые делятся на 3 без остатка: %v\n", toPrint)
}
```
```
root@vagrant:~/golang# go run divid__num_3.go
Числа от 1 до 100, которые делятся на 3 без остатка: [3 6 9 12 15 18 21 24 27 30                                 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99]
```
