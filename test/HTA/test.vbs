Option Explicit

Sub SetInnerText(idName, Text)
	Dim para
	Set para = document.getElementById(idName)
	para.innerText = Text
	Set para = Nothing
End Sub

Sub MyControl_OnStart(Param)
	MsgBox Param
End Sub

Sub MyControl_OnEnd(Param)
	MsgBox Param
End Sub

Sub cmdGetResult_onClick()
	SetInnerText "pObjectsCount", CStr(MyControl.GetObjectsCount())
	SetInnerText "pReferencesCount", CStr(MyControl.GetReferencesCount())
End Sub
