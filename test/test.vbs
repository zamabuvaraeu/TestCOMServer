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

Dim objCallBack
Set objCallBack = New CallBack

oTestClass.SetCallBack objCallBack, "Пользователь"

oTestClass.InvokeCallBack()

WScript.Echo "ReferencesCount", oTestClass.GetReferencesCount()

Dim oNewTestClass
Set oNewTestClass = oTestClass

WScript.Echo "ReferencesCount", oTestClass.GetReferencesCount()

WScript.Echo "ObjectsCount", oTestClass.GetObjectsCount()

Set oNewTestClass = Nothing

Set objCallBack = Nothing
Set oTestClass = Nothing
