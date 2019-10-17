#include "EntryPoint.bi"
#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "ConsoleMain.bi"

#ifdef WINDOWS_SERVICE
#define MAIN_FUNCTION WindowsServiceMain()
#else
#define MAIN_FUNCTION ConsoleMain()
#endif

Function MainEntryPoint()As Integer
	
	Dim RetCode As Integer = MAIN_FUNCTION
	
	Return RetCode
	
End Function

#ifdef WITHOUT_RUNTIME

Sub EntryPoint Alias "EntryPoint"()
	
	ExitProcess(MainEntryPoint)
	
End Sub

#else

End(MainEntryPoint)

#endif
