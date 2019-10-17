Option Explicit

Class CallBack
	
	Function CallBack(Param)
		WScript.Echo Param
		CallBack = 0
	End Function
	
End Class

Dim oTestClass
'Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer", "TestClass_")
'Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer")
Set oTestClass = CreateObject("BatchedFiles.TestCOMServer")

WScript.Echo "TestCOMServer создан, количество объектов всего", oTestClass.GetObjectsCount()
WScript.Echo "Количество ссылок на объект TestCOMServer", oTestClass.GetReferencesCount()

WScript.Echo "Создал CallBack, вызываю его"

Dim objCallBack
Set objCallBack = New CallBack

oTestClass.SetCallBack objCallBack, "Пользователь"

oTestClass.InvokeCallBack()

WScript.Echo "Количество ссылок на объект TestCOMServer", oTestClass.GetReferencesCount()

Dim oNewTestClass
Set oNewTestClass = oTestClass

WScript.Echo "Присвоил TestCOMServer новой переменной"
WScript.Echo "ReferencesCount", oTestClass.GetReferencesCount()
WScript.Echo "Количество объектов всего", oTestClass.GetObjectsCount()

Set oNewTestClass = Nothing

WScript.Echo "Уничтожил новую переменную"
WScript.Echo "ReferencesCount", oTestClass.GetReferencesCount()
WScript.Echo "Количество объектов всего", oTestClass.GetObjectsCount()

Set objCallBack = Nothing
WScript.Echo "Уничтожил CallBack"
WScript.Echo "ReferencesCount", oTestClass.GetReferencesCount()
WScript.Echo "Количество объектов всего", oTestClass.GetObjectsCount()

Set oTestClass = Nothing

WScript.Echo "Уничтожил объект"
