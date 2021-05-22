# TestCOMServer

The source code is used to demonstrate the creation of a CoClass in COM inproc-server.


## How to compile

For the COM class to work, you must have:

1. Type Library.
2. DLL containing CoClass.

### Compile Type Library

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
