Option Explicit

Dim TestClass
Set TestClass = WScript.CreateObject("BatchedFiles.TestCOMServer", "TestClass_")
PrintObjectsCount TestClass
Set TestClass = Nothing

Sub TestClass_OnStart(Param)
	WScript.Echo "TestCOMServer_OnStart"
	WScript.Echo "Param.vt = " & CStr(VarType(Param))
	WScript.Echo "Длина = " & Len(Param)
	WScript.Echo "Параметр = " & Param
	Param = "Нет"
End Sub

Sub TestClass_OnEnd(Param)
	WScript.Echo 42
End Sub

Sub PrintObjectsCount(pObject)
	
	Dim ObjectsCount, ReferencesCount
	
	ObjectsCount = "Количество объектов всего = " & CStr(TestClass.GetObjectsCount())
	ReferencesCount = "Количество ссылок на объект TestCOMServer = " & CStr(TestClass.GetReferencesCount())
	
	WScript.Echo ObjectsCount & vbCrLf & ReferencesCount
	
End Sub

Class CallBack
	
	Function CallBack(Param)
		WScript.Echo Param
		CallBack = 0
	End Function
	
End Class
