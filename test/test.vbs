Option Explicit

Dim oTestClass
'Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer", "TestClass_")
'Set oTestClass = WScript.CreateObject("BatchedFiles.TestCOMServer")
Set oTestClass = CreateObject("BatchedFiles.TestCOMServer")

Dim result

result = oTestClass.ShowMessageBox(0)
WScript.Echo result

result = oTestClass.ShowMessageBox(1)
WScript.Echo result

result = oTestClass.ShowMessageBox(2)
WScript.Echo result

result = oTestClass.ShowMessageBox("0")
WScript.Echo result

result = oTestClass.ShowMessageBox("1")
WScript.Echo result

result = oTestClass.ShowMessageBox("2")
WScript.Echo result

result = oTestClass.ShowMessageBox(True)
WScript.Echo result

result = oTestClass.ShowMessageBox(False)
WScript.Echo result

Set oTestClass = Nothing
