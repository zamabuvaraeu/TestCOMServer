#include "ConsoleMain.bi"
#include "ITestCOMServer.bi"

#ifndef WINDOWS_SERVICE

Function ConsoleMain()As Integer
	
	Dim hr As HRESULT = CoInitializeEx(NULL, COINIT_MULTITHREADED)
	If FAILED(hr) Then
		Return 1
	End If
	
	CoUnInitialize()
	
	Return 0
	
End Function

#endif
