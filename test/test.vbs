Option Explicit

Class CallBack
	
	Function CallBack(Param)
		WScript.Echo Param
		CallBack = 0
	End Function
	
End Class

Sub PrintObjectsCount(pObject)
	
	Dim ObjectsCount, ReferencesCount
	
	ObjectsCount = oTestClass.GetObjectsCount()
	ReferencesCount = oTestClass.GetReferencesCount()
	
	WScript.Echo "Количество объектов всего = " & CStr(ObjectsCount) & vbCrLf & "Количество ссылок на объект TestCOMServer = " & CStr(ReferencesCount)
	
End Sub

Dim oTestClass
'Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer", "TestClass_")
'Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer")
Set oTestClass = CreateObject("BatchedFiles.TestCOMServer")

PrintObjectsCount oTestClass

WScript.Echo "Создал CallBack, вызываю его"

Dim objCallBack
Set objCallBack = New CallBack

oTestClass.SetCallBack objCallBack, "Пользователь"

oTestClass.InvokeCallBack()

PrintObjectsCount oTestClass

Dim oNewTestClass
Set oNewTestClass = oTestClass

WScript.Echo "Присвоил TestCOMServer новой переменной"

PrintObjectsCount oTestClass

Set oNewTestClass = Nothing

WScript.Echo "Уничтожил новую переменную"

PrintObjectsCount oTestClass

Set objCallBack = Nothing
WScript.Echo "Уничтожил CallBack"

PrintObjectsCount oTestClass

Set oTestClass = Nothing

WScript.Echo "Уничтожил объект"
