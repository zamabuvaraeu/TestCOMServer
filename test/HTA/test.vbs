Option Explicit

Sub cmdGetResult_onClick()
	Dim oTestClass
	Set oTestClass = CreateObject("BatchedFiles.TestCOMServer")
	
	Dim result
	result = oTestClass.GetObjectsCount()
	
	Dim para
	Set para = document.getElementById("pResult")
	
	para.innerHtml = CStr(result)
	
	Set oTestClass = Nothing
	
End Sub

