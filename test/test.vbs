Option Explicit

Dim oTestClass
'Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer", "TestClass_")
Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer")

Dim result
result = oTestClass.ShowMessageBox(5)

WScript.Echo result

Set oTestClass = Nothing
