#ifndef DLLMAIN_BI
#define DLLMAIN_BI

#include "windows.bi"

' Declare Function DllMain Alias "DllMain"( _
	' ByVal hinstDLL As HINSTANCE, _
	' ByVal fdwReason As DWORD, _
	' ByVal lpvReserved As LPVOID _
' )As Integer

' Declare Function DllGetClassObject Alias "DllGetClassObject"( _
	' ByVal rclsid As REFCLSID, _
	' ByVal riid As REFIID, _
	' ByVal ppv As Any Ptr Ptr _
' )As HRESULT

' Declare Function DllCanUnloadNow Alias "DllCanUnloadNow"( _
' )As HRESULT

' Declare Function DllRegisterServer Alias "DllRegisterServer"( _
' )As HRESULT

' Declare Function DllUnregisterServer Alias "DllUnregisterServer"( _
' )As HRESULT

#endif
