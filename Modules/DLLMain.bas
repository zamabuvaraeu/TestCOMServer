#include "DLLMain.bi"
#include "win\olectl.bi"
#include "win\psapi.bi"
#include "win\shlwapi.bi"
#include "ITestCOMServer.bi"
' #include "ClassFactory.bi"
' #include "IrcClient.bi"

Declare Function SetSettingsValue( _
	ByVal RegSection As WString Ptr, _
	ByVal Key As WString Ptr, _
	ByVal Value As WString Ptr _
)As Boolean

Common Shared GlobalObjectsCount As ULONG

#ifndef withoutruntime

Sub CTor()Constructor
    ' MessageBox(NULL, "DLL loaded", "DLL", MB_OK)
End Sub

Sub DTor()Destructor
	' MessageBox(NULL, "DLL unloaded", "DLL", MB_OK)
End Sub

#else

Dim Shared DllModuleHandle As HMODULE

Function DllMain Alias "DllMain"( _
		ByVal hinstDLL As HINSTANCE, _
		ByVal fdwReason As DWORD, _
		ByVal lpvReserved As LPVOID _
	)As Integer Export
	
	Select Case fdwReason
		
		Case DLL_PROCESS_ATTACH
			' Initialize once for each new process.
			' Return FALSE to fail DLL load.
			DllModuleHandle = hinstDLL
			
			' MakeIClassFactoryVtbl()
			' MakeIIrcClientVirtualTable()
			
		Case DLL_THREAD_ATTACH
			' Do thread-specific initialization.
			
		Case DLL_THREAD_DETACH
			' Do thread-specific cleanup.
			
		Case DLL_PROCESS_DETACH
			' Perform any necessary cleanup.
			
	End Select
	
 	Return True
 	
End Function

#endif

/'
Function DllGetClassObject Alias "DllGetClassObject"( _
		ByVal rclsid As REFCLSID, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT Export
	
	' *ppv = NULL
	
	' If IsEqualIID(@IID_IIrcClient, rclsid) = 0 Then
		' Return CLASS_E_CLASSNOTAVAILABLE
	' End If
	
	' Dim pClassFactory As ClassFactory Ptr = ConstructorClassFactory()
	' If pClassFactory = 0 Then
		' Return E_OUTOFMEMORY
	' End If
	
	' Dim hr As HRESULT = ClassFactoryQueryInterface(pClassFactory, riid, ppv)
	
	' If FAILED(hr) Then
		' DestructorClassFactory(pClassFactory)
	' End If
	
	' Return hr
	
End Function
'/

Function DllCanUnloadNow Alias "DllCanUnloadNow"( _
	)As HRESULT Export
	
	If GlobalObjectsCount = 0 Then
		Return S_OK
	End If
	
	Return S_FALSE
	
End Function

/'
Function DllRegisterServer Alias "DllRegisterServer"( _
	)As HRESULT Export
	
	Const MaxModuleNameLength As Integer = MAX_PATH - 1
	Dim ModuleName As WString * (MaxModuleNameLength + 1) = Any
	Dim dwResult As DWORD = GetModuleFileName(DllModuleHandle, @ModuleName, MaxModuleNameLength)
	
	Scope
		Dim SoftwareClassesIrcClient As WString * (MAX_PATH + 1) = Any
		
		' SOFTWARE\Classes\IRC.IrcClient
		lstrcpy(@SoftwareClassesIrcClient, @"SOFTWARE\Classes\")
		lstrcat(@SoftwareClassesIrcClient, @ProgID_IrcClient)
		
		If SetSettingsValue(@SoftwareClassesIrcClient, NULL, @"Client COM clacc for IRC") = False Then
			Return S_FALSE
		End If
		
		Dim SoftwareClassesIrcClientClsid As WString * (MAX_PATH + 1) = Any
		
		' SOFTWARE\Classes\IRC.IrcClient\CLSID
		lstrcpy(@SoftwareClassesIrcClientClsid, SoftwareClassesIrcClient)
		lstrcat(@SoftwareClassesIrcClientClsid, "\CLSID")
		
		If SetSettingsValue(@SoftwareClassesIrcClientClsid, NULL, @CLSIDS_IRCCLIENT) = False Then
			Return S_FALSE
		End If
	End Scope
	
	Scope
		Dim SoftwareClassesClsid As WString * (MAX_PATH + 1) = Any
		
		' SOFTWARE\Classes\CLSID\{609FA596-1C4E-4BCB-A9D1-CA0DBBF3FC95}
		lstrcpy(@SoftwareClassesClsid, "SOFTWARE\Classes\CLSID\")
		lstrcat(@SoftwareClassesClsid, @CLSIDS_IRCCLIENT)
		
		If SetSettingsValue(SoftwareClassesClsid, NULL, "Client COM clacc for IRC") = False Then
			Return S_FALSE
		End If
		
		Scope
			Dim SoftwareClassesClsidInProc As WString * (MAX_PATH + 1) = Any
			
			' SOFTWARE\Classes\CLSID\{609FA596-1C4E-4BCB-A9D1-CA0DBBF3FC95}\InprocServer32
			lstrcpy(SoftwareClassesClsidInProc, SoftwareClassesClsid)
			lstrcat(SoftwareClassesClsidInProc, "\InprocServer32")
			
			If SetSettingsValue(SoftwareClassesClsidInProc, NULL, @ModuleName) = False Then
				Return S_FALSE
			End If
			If SetSettingsValue(SoftwareClassesClsidInProc, "ThreadingModel", "Both") = False Then
				Return S_FALSE
			End If
		End Scope
		
		Scope
			Dim SoftwareClassesClsidProgID As WString * (MAX_PATH + 1) = Any
			
			' SOFTWARE\Classes\CLSID\{609FA596-1C4E-4BCB-A9D1-CA0DBBF3FC95}\ProgID
			lstrcpy(SoftwareClassesClsidProgID, SoftwareClassesClsid)
			lstrcat(SoftwareClassesClsidProgID, "\ProgID")
			
			If SetSettingsValue(SoftwareClassesClsidProgID, NULL, ProgID_IrcClient) = False Then
				Return S_FALSE
			End If
		End Scope
	End Scope
	
	Return S_OK
End Function
'/

/'
Function DllUnregisterServer Alias "DllUnregisterServer"( _
	)As HRESULT Export
	
	Scope
		Dim SoftwareClassesIrcClient As WString * (MAX_PATH + 1) = Any
		
		' SOFTWARE\Classes\IRC.IrcClient
		lstrcpy(@SoftwareClassesIrcClient, @"SOFTWARE\Classes\")
		lstrcat(@SoftwareClassesIrcClient, @ProgID_IrcClient)
		
		Scope
			Dim SoftwareClassesIrcClientClsid As WString * (MAX_PATH + 1) = Any
			
			' SOFTWARE\Classes\IRC.IrcClient\CLSID
			lstrcpy(@SoftwareClassesIrcClientClsid, SoftwareClassesIrcClient)
			lstrcat(@SoftwareClassesIrcClientClsid, "\CLSID")
			
			If RegDeleteKey(HKEY_LOCAL_MACHINE, @SoftwareClassesIrcClientClsid) <> 0 Then
				Return S_FALSE
			End If
		End Scope
		
		If RegDeleteKey(HKEY_LOCAL_MACHINE, @SoftwareClassesIrcClient) <> 0 Then
			Return S_FALSE
		End If
	End Scope
	
	Scope
		Dim SoftwareClassesClsid As WString * (MAX_PATH + 1) = Any
		
		' SOFTWARE\Classes\CLSID\{609FA596-1C4E-4BCB-A9D1-CA0DBBF3FC95}
		lstrcpy(@SoftwareClassesClsid, "SOFTWARE\Classes\CLSID\")
		lstrcat(@SoftwareClassesClsid, @CLSIDS_IRCCLIENT)
		
		Scope
			Dim SoftwareClassesClsidInProc As WString * (MAX_PATH + 1) = Any
			
			' SOFTWARE\Classes\CLSID\{609FA596-1C4E-4BCB-A9D1-CA0DBBF3FC95}\InprocServer32
			lstrcpy(SoftwareClassesClsidInProc, SoftwareClassesClsid)
			lstrcat(SoftwareClassesClsidInProc, "\InprocServer32")
			
			If RegDeleteKey(HKEY_LOCAL_MACHINE, @SoftwareClassesClsidInProc) <> 0 Then
				Return S_FALSE
			End If
		End Scope
		
		Scope
			Dim SoftwareClassesClsidProgID As WString * (MAX_PATH + 1) = Any
			
			' SOFTWARE\Classes\CLSID\{609FA596-1C4E-4BCB-A9D1-CA0DBBF3FC95}\ProgID
			lstrcpy(SoftwareClassesClsidProgID, SoftwareClassesClsid)
			lstrcat(SoftwareClassesClsidProgID, "\ProgID")
			
			If RegDeleteKey(HKEY_LOCAL_MACHINE, @SoftwareClassesClsidProgID) <> 0 Then
				Return S_FALSE
			End If
		End Scope
		
		If RegDeleteKey(HKEY_LOCAL_MACHINE, @SoftwareClassesClsid) <> 0 Then
			Return S_FALSE
		End If
	End Scope
	
	Return S_OK
	
End Function
'/

Function SetSettingsValueW( _
		ByVal RegSection As WString Ptr, _
		ByVal Key As WString Ptr, _
		ByVal Value As WString Ptr _
	)As Boolean
	
	Dim reg As HKEY = Any
	Dim lpdwDisposition As DWORD = Any
	Dim hr As Long = RegCreateKeyExW(HKEY_LOCAL_MACHINE, RegSection, 0, 0, 0, KEY_SET_VALUE, NULL, @reg, @lpdwDisposition)
	
	If hr <> ERROR_SUCCESS Then
		' Print "hr", hr
		Return False
	End If
	
	hr = RegSetValueExW(reg, Key, 0, REG_SZ, CPtr(Byte Ptr, Value), (lstrlenW(Value) + 1) * SizeOf(WString))
	If hr <> ERROR_SUCCESS Then
		' Print "hr", hr
		RegCloseKey(reg)
		Return False
	End If
	
	RegCloseKey(reg)
	
	Return True
	
End Function
