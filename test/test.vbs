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

Dim ReferencesCount
ReferencesCount = oTestClass.GetReferencesCount()
WScript.Echo "ReferencesCount", ReferencesCount

Dim oNewTestClass
Set oNewTestClass = oTestClass

ReferencesCount = oTestClass.GetReferencesCount()
WScript.Echo "ReferencesCount", ReferencesCount

Dim ObjectsCount
ObjectsCount = oTestClass.GetObjectsCount()
WScript.Echo "ObjectsCount", ObjectsCount 

Set oNewTestClass = Nothing
Set objCallBack = Nothing
Set oTestClass = Nothing

