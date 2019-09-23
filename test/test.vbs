Option Explicit

Class FunctionCallBack
	
	Function CallBack(Param)
		
		WScript.Echo Param
		
		CallBack = 0
		
	End Function
	
End Class

Dim oTestClass
'Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer", "TestClass_")
'Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer")
Set oTestClass = CreateObject("BatchedFiles.TestCOMServer")

Dim objFunctionCallBack
Set objFunctionCallBack = New FunctionCallBack

Dim result
result = oTestClass.SetFunctionReference(objFunctionCallBack)
WScript.Echo result

result = oTestClass.ShowMessageBox(0)
WScript.Echo result

Set objFunctionCallBack = Nothing
Set oTestClass = Nothing

