#include "DLLMain.bi"
#include "ClassFactory.bi"
#include "ObjectsCounter.bi"
#include "Registry.bi"
#include "Resources.RH"
#include "TestCOMServer.bi"
#include "TypeLibrary.bi"
#include "win\shlwapi.bi"

#ifdef __FB_64BIT__
Const CurrentSYSKIND As SYSKIND = SYS_WIN64
#else
Const CurrentSYSKIND As SYSKIND = SYS_WIN32
'SYS_WIN16
'SYS_MAC 
#endif

Common Shared PGlobalCounter As ObjectsCounter Ptr

Dim Shared DllModuleHandle As HMODULE

Sub Init()
	
End Sub

Sub UnInit()
	DestroyObjectsCounter(PGlobalCounter)
End Sub

#ifndef WITHOUT_RUNTIME

Sub CTor()Constructor
	
	Init()
	
	PGlobalCounter = CreateObjectsCounter()
	
End Sub

Sub DTor()Destructor
	UnInit()
End Sub

#else

Function DllMain Alias "DllMain"( _
		ByVal hinstDLL As HINSTANCE, _
		ByVal fdwReason As DWORD, _
		ByVal lpvReserved As LPVOID _
	)As Integer
	
	Select Case fdwReason
		
		Case DLL_PROCESS_ATTACH
			DllModuleHandle = hinstDLL
			Init()
			
			PGlobalCounter = CreateObjectsCounter()
			If PGlobalCounter = NULL Then
				Return FALSE
			End If
			
		Case DLL_THREAD_ATTACH
			
		Case DLL_THREAD_DETACH
			
		Case DLL_PROCESS_DETACH
			UnInit()
			
	End Select
	
 	Return True
 	
End Function

#endif

Extern "Windows-MS"

Function WindowsMSDllGetClassObject Alias "DllGetClassObject"( _
		ByVal rclsid As REFCLSID, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT Export
	
	Dim hr As HRESULT = CreateClassFactoryInterface(rclsid, riid, ppv)
	
	Return hr
	
End Function

Function WindowsMSDllCanUnloadNow Alias "DllCanUnloadNow"( _
	)As HRESULT Export
	
	If ObjectsCounterGetCounterValue(PGlobalCounter) = 0 Then
		Return S_OK
	End If
	
	Return S_FALSE
	
End Function

Function WindowsMSDllRegisterServer Alias "DllRegisterServer"( _
	)As HRESULT Export
	
	Dim ModuleName As WString * (MAX_PATH + 1) = Any
	Dim dwResult As DWORD = GetModuleFileNameW( _
		DllModuleHandle, _
		@ModuleName, _
		MAX_PATH _
	)
	
	Dim pSoftwareClasses As CoClassRegistryKeyTableW Ptr = CreateCoClassRegistryKeyTableW()
	
	If pSoftwareClasses = NULL Then
		Return E_OUTOFMEMORY
	End If
	
	FillRegistryCoClassKeyTableW( _
		pSoftwareClasses, _
		ProgID_TestCOMServer_Version10, _
		RESOURCE_FILEDESCRIPTION, _
		ProgID_TestCOMServer_VersionIndependent, _
		ProgID_TestCOMServer_VersionCurrent, _
		TestCOMServer_CurrentVersion, _
		CLSIDS_TESTCOMSERVER_VERSION10, _
		LIBIDS_TESTCOMSERVER_10, _
		ModuleName _
	)
	
	Dim hr As HRESULT = RegisterCoClassW( _
		pSoftwareClasses _
	)
	If FAILED(hr) Then
		Return hr
	End If
	
	Scope
		Dim ExecutableDirectory As WString * (MAX_PATH + 1) = Any
		Dim TypeLibraryFullFilePath As WString * (MAX_PATH + 1) = Any
		
		lstrcpyW(ExecutableDirectory, ModuleName)
		PathRemoveFileSpecW(ExecutableDirectory)
		
		PathCombineW(@TypeLibraryFullFilePath, @ExecutableDirectory, @TypeLibraryFileName)
		
		Dim pITypeLib As ITypeLib Ptr = NULL
		hr = LoadTypeLib(@TypeLibraryFullFilePath, @pITypeLib)
		
		If FAILED(hr) Then
			Return hr
		End If
		
		hr = RegisterTypeLib(pITypeLib, @TypeLibraryFullFilePath, NULL)
		
		If FAILED(hr) Then
			Return hr
		End If
		
		IUnknown_Release(pITypeLib)
		
	End Scope
	
	Return S_OK
	
End Function

Function WindowsMSDllUnregisterServer Alias "DllUnregisterServer"( _
	)As HRESULT Export
	
	Dim hr As HRESULT = UnRegisterTypeLib( _
		@LIBID_TESTCOMSERVER_10, _
		TYPELIBRARY_VERSION_MAJOR, _
		TYPELIBRARY_VERSION_MINOR, _
		0, _
		CurrentSYSKIND _
	)
	If FAILED(hr) Then
		Return hr
	End If
	
	Dim ModuleName As WString * (MAX_PATH + 1) = Any
	Dim dwResult As DWORD = GetModuleFileNameW( _
		DllModuleHandle, _
		@ModuleName, _
		MAX_PATH _
	)
	
	Dim pSoftwareClasses As CoClassRegistryKeyTableW Ptr = CreateCoClassRegistryKeyTableW()
	
	If pSoftwareClasses = NULL Then
		Return E_OUTOFMEMORY
	End If
	
	FillRegistryCoClassKeyTableW( _
		pSoftwareClasses, _
		ProgID_TestCOMServer_Version10, _
		RESOURCE_FILEDESCRIPTION, _
		ProgID_TestCOMServer_VersionIndependent, _
		ProgID_TestCOMServer_VersionCurrent, _
		TestCOMServer_CurrentVersion, _
		CLSIDS_TESTCOMSERVER_VERSION10, _
		LIBIDS_TESTCOMSERVER_10, _
		ModuleName _
	)
	
	hr = UnRegisterCoClassW( _
		pSoftwareClasses _
	)
	
	Return hr
	
End Function

End Extern
