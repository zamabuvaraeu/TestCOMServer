Option Explicit

Sub SetInnerText(idName, Text)
	Dim para
	Set para = document.getElementById(idName)
	para.innerText = Text
	Set para = Nothing
End Sub

Sub MyControl_OnStart(Param)
	SetInnerText "pEventText", "123456"
End Sub

Sub MyControl_OnEnd(Param)
	SetInnerText "pEventText", "987654321"
End Sub

Sub cmdGetResult_onClick()
	SetInnerText "pObjectsCount", CStr(MyControl.GetObjectsCount())
	SetInnerText "pReferencesCount", CStr(MyControl.GetReferencesCount())
End Sub
