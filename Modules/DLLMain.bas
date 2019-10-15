#include "DLLMain.bi"
#include "windows.bi"
#include "win\ole2.bi"
#include "win\shlwapi.bi"
#include "InitializeVirtualTables.bi"
#include "GlobalObjectsCounter.bi"
#include "Registry.bi"
#include "Resources.rh"
#include "TestCOMServer.bi"
#include "ClassFactory.bi"

Common Shared PGlobalCounter As GlobalObjectsCounter Ptr

Dim Shared DllModuleHandle As HMODULE

Sub Init()
	InitializeVirtualTables()
	PGlobalCounter = CreateGlobalObjectsCounter()
End Sub

Sub UnInit()
	DestroyGlobalObjectsCounter(PGlobalCounter)
End Sub

#ifndef WITHOUT_RUNTIME

Sub CTor()Constructor
	Init()
End Sub

Sub DTor()Destructor
	UnInit()
End Sub

#else

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
			Init()
			
		Case DLL_THREAD_ATTACH
			' Do thread-specific initialization.
			
		Case DLL_THREAD_DETACH
			' Do thread-specific cleanup.
			
		Case DLL_PROCESS_DETACH
			' Perform any necessary cleanup.
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
	
	*ppv = NULL
	
	If IsEqualCLSID(@CLSID_TESTCOMSERVER_10, rclsid) = 0 Then
		Return CLASS_E_CLASSNOTAVAILABLE
	End If
	
	Dim pClassFactory As ClassFactory Ptr = CreateClassFactory()
	
	If pClassFactory = NULL Then
		Return E_OUTOFMEMORY
	End If
	
	Dim hr As HRESULT = ClassFactoryQueryInterface(pClassFactory, riid, ppv)
	
	If FAILED(hr) Then
		DestroyClassFactory(pClassFactory)
	End If
	
	Return hr
	
End Function

Function WindowsMSDllCanUnloadNow Alias "DllCanUnloadNow"( _
	)As HRESULT Export
	
	If PGlobalCounter->ObjectsCounter = 0 Then
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
	
	Dim pSoftwareClasses As CoClassRegistryKeyTableW Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(CoClassRegistryKeyTableW) * MAX_REGISTRYCOCLASSKEYS _
	)
	
	If pSoftwareClasses = NULL Then
		Return E_OUTOFMEMORY
	End If
	
	MakeRegistryCoClassKeyTableW( _
		pSoftwareClasses, _
		ProgID_TestCOMServer_10, _
		RESOURCE_FILEDESCRIPTION, _
		VersionIndependentProgID_TestCOMServer, _
		ProgID_TestCOMServer_CurrentProgId, _
		TestCOMServer_CurrentVersion, _
		CLSIDS_TESTCOMSERVER_10, _
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
		Dim TypeLibraryFileName As WString * (MAX_PATH + 1) = Any
		
		lstrcpyW(ExecutableDirectory, ModuleName)
		PathRemoveFileSpecW(ExecutableDirectory)
		
		PathCombineW(TypeLibraryFileName, ExecutableDirectory, "BatchedFilesTestCOMServer.tlb")
		
		Dim pITypeLib As ITypeLib Ptr = NULL
		hr = LoadTypeLib(TypeLibraryFileName, @pITypeLib)
		
		If FAILED(hr) Then
			MessageBoxW(0, "LoadTypeLib", NULL, MB_OK)
			Return hr
		End If
		
		hr = RegisterTypeLib(pITypeLib, TypeLibraryFileName, NULL)
		
		If FAILED(hr) Then
			MessageBoxW(0, "RegisterTypeLib", NULL, MB_OK)
			Return hr
		End If
		
		IUnknown_Release(pITypeLib)
		
	End Scope
	
	Return S_OK
	
End Function

Function WindowsMSDllUnregisterServer Alias "DllUnregisterServer"( _
	)As HRESULT Export
	
	Dim ModuleName As WString * (MAX_PATH + 1) = Any
	Dim dwResult As DWORD = GetModuleFileNameW( _
		DllModuleHandle, _
		@ModuleName, _
		MAX_PATH _
	)
	
	Dim pSoftwareClasses As CoClassRegistryKeyTableW Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(CoClassRegistryKeyTableW) * MAX_REGISTRYCOCLASSKEYS _
	)
	
	If pSoftwareClasses = NULL Then
		Return E_OUTOFMEMORY
	End If
	
	MakeRegistryCoClassKeyTableW( _
		pSoftwareClasses, _
		ProgID_TestCOMServer_10, _
		RESOURCE_FILEDESCRIPTION, _
		VersionIndependentProgID_TestCOMServer, _
		ProgID_TestCOMServer_CurrentProgId, _
		TestCOMServer_CurrentVersion, _
		CLSIDS_TESTCOMSERVER_10, _
		LIBIDS_TESTCOMSERVER_10, _
		ModuleName _
	)
	
	Dim hr As HRESULT = UnRegisterCoClassW( _
		pSoftwareClasses _
	)
	
	Return hr
	
End Function

End Extern
