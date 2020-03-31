# TestCOMServer

Тестовый COM сервер. Исхдный код используется для демонстрации создания COM‐сервера и тестирования.


## Компиляция


### Библиотека типов

Для начала необходимо скомпилировать библиотеку типов. Неободимо запустить среду Visual Studio и оттуда выполнить:

```BatchFile
midl BatchedFilesTestCOMServer.idl
```


### Компонент

Для компиляции компонента выполнить:

```BatchFile
call make.cmd dll release withoutruntime
```

Считается, что компилятор FreeBASIC установлен в папку `%ProgramFies%`. Если это не так, необходимо поправить путь в файле `make.cmd`.


## Регистрация

Регистрация компонента в системе осуществляется утилитой regsvr32:

```BatchFile
regsvr32 BatchedFilesTestCOMServer.dll
```
