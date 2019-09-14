#include "DLLMain.bi"
#include "windows.bi"
#include "win\olectl.bi"
#include "win\psapi.bi"
#include "win\shlwapi.bi"
#include "InitializeVirtualTables.bi"
#include "Registry.bi"
#include "Resources.rh"
#include "TestCOMServer.bi"
#include "TestCOMServerClassFactory.bi"

Declare Sub MakeRegistryCoClassKeyTableW( _
	ByVal pRegistryKeyTable As CoClassRegistryKeyTableW Ptr, _
	ByVal ProgId As WString Ptr, _
	ByVal ClassDescription As WString Ptr, _
	ByVal VersionIndependentProgID As WString Ptr, _
	ByVal CurrentProgId As WString Ptr, _
	ByVal CurrentClassVersion As WString Ptr, _
	ByVal ClsIds As WString Ptr, _
	ByVal TypeLibClsids As WString Ptr, _
	ByVal ModuleName As WString Ptr _
)

Common Shared GlobalObjectsCount As ULONG
Dim Shared DllModuleHandle As HMODULE

#ifndef WITHOUT_RUNTIME_DEFINED

Sub CTor()Constructor
	InitializeVirtualTables()
End Sub

Sub DTor()Destructor
	' MessageBox(NULL, "DLL unloaded", "DLL", MB_OK)
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
			InitializeVirtualTables()
			
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

Function DllGetClassObject Alias "DllGetClassObject"( _
		ByVal rclsid As REFCLSID, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT Export
	
	*ppv = NULL
	
	If IsEqualCLSID(@CLSID_TESTCOMSERVER_10, rclsid) = 0 Then
		Return CLASS_E_CLASSNOTAVAILABLE
	End If
	
	Dim pClassFactory As TestCOMServerClassFactory Ptr = CreateTestCOMServerClassFactory()
	
	If pClassFactory = NULL Then
		Return E_OUTOFMEMORY
	End If
	
	Dim hr As HRESULT = TestCOMServerClassFactoryQueryInterface(pClassFactory, riid, ppv)
	
	If FAILED(hr) Then
		DestroyTestCOMServerClassFactory(pClassFactory)
	End If
	
	Return hr
	
End Function

Function DllCanUnloadNow Alias "DllCanUnloadNow"( _
	)As HRESULT Export
	
	If GlobalObjectsCount = 0 Then
		Return S_OK
	End If
	
	Return S_FALSE
	
End Function

Function DllRegisterServer Alias "DllRegisterServer"( _
	)As HRESULT Export
	
	Const MaxModuleNameLength As Integer = MAX_PATH
	
	Dim ModuleName As WString * (MaxModuleNameLength + 1) = Any
	Dim dwResult As DWORD = GetModuleFileNameW( _
		DllModuleHandle, _
		@ModuleName, _
		MaxModuleNameLength _
	)
	
	Dim SoftwareClasses(MAX_REGISTRYCOCLASSKEYS - 1) As CoClassRegistryKeyTableW = Any
	
	MakeRegistryCoClassKeyTableW( _
		@SoftwareClasses(0), _
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
		@SoftwareClasses(0) _
	)
	
	Return hr
	
End Function

Function DllUnregisterServer Alias "DllUnregisterServer"( _
	)As HRESULT Export
	
	Const MaxModuleNameLength As Integer = MAX_PATH
	
	Dim ModuleName As WString * (MaxModuleNameLength + 1) = Any
	Dim dwResult As DWORD = GetModuleFileNameW( _
		DllModuleHandle, _
		@ModuleName, _
		MaxModuleNameLength _
	)
	
	Dim SoftwareClasses(MAX_REGISTRYCOCLASSKEYS - 1) As CoClassRegistryKeyTableW = Any
	
	MakeRegistryCoClassKeyTableW( _
		@SoftwareClasses(0), _
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
		@SoftwareClasses(0) _
	)
	
	Return hr
	
End Function

Sub MakeRegistryCoClassKeyTableW( _
		ByVal pRegistryKeyTable As CoClassRegistryKeyTableW Ptr, _
		ByVal ProgId As WString Ptr, _
		ByVal ClassDescription As WString Ptr, _
		ByVal VersionIndependentProgID As WString Ptr, _
		ByVal CurrentProgId As WString Ptr, _
		ByVal CurrentClassVersion As WString Ptr, _
		ByVal ClsIds As WString Ptr, _
		ByVal TypeLibClsids As WString Ptr, _
		ByVal ModuleName As WString Ptr _
	)
	
	Const SoftwareClassesRoot = "SOFTWARE\Classes\"
	
	' SOFTWARE\Classes\{ProgId} = ClassDescription
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.ProgId].Section, SoftwareClassesRoot)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.ProgId].Section, ProgId)
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.ProgId].Value, ClassDescription)
	End Scope
	
	' SOFTWARE\Classes\{ProgId}\CLSID = ClsIds
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.ProgIdClsId].Section, @pRegistryKeyTable[RegistryKeys.ProgId].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.ProgIdClsId].Section, "\CLSID")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.ProgIdClsId].Value, ClsIds)
	End Scope
	
	' SOFTWARE\Classes\{VersionIndependentProgID} = ClassDescription
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.VersionIndependentProgId].Section, SoftwareClassesRoot)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.VersionIndependentProgId].Section, VersionIndependentProgID)
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.VersionIndependentProgId].Value, ClassDescription)
	End Scope
	
	' SOFTWARE\Classes\{VersionIndependentProgID}\CLSID = ClsIds
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.VersionIndependentProgIdClsid].Section, @pRegistryKeyTable[RegistryKeys.VersionIndependentProgId].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.VersionIndependentProgIdClsid].Section, "\CLSID")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.VersionIndependentProgIdClsid].Value, ClsIds)
	End Scope
	
	' SOFTWARE\Classes\{VersionIndependentProgID}\CurVer = CurrentProgId
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.VersionIndependentProgIdCurVer].Section, @pRegistryKeyTable[RegistryKeys.VersionIndependentProgId].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.VersionIndependentProgIdCurVer].Section, "\CurVer")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.VersionIndependentProgIdCurVer].Value, CurrentProgId)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx} = ClassDescription
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSID].Section, SoftwareClassesRoot)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.CLSID].Section, "CLSID\")
		lstrcatW(@pRegistryKeyTable[RegistryKeys.CLSID].Section, ClsIds)
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSID].Value, ClassDescription)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\InprocServer32 = ModuleName
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDInprocServer32].Section, @pRegistryKeyTable[RegistryKeys.CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.CLSIDInprocServer32].Section, "\InprocServer32")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDInprocServer32].Value, ModuleName)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\ProgID = ProgId
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDProgId].Section, @pRegistryKeyTable[RegistryKeys.CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.CLSIDProgId].Section, "\ProgID")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDProgId].Value, ProgId)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\TypeLib = TypeLibClsids
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDTypeLib].Section, @pRegistryKeyTable[RegistryKeys.CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.CLSIDTypeLib].Section, "\TypeLib")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDTypeLib].Value, TypeLibClsids)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\Version = CurrentClassVersion
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDVersion].Section, @pRegistryKeyTable[RegistryKeys.CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.CLSIDVersion].Section, "\Version")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDVersion].Value, CurrentClassVersion)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\VersionIndependentProgID = VersionIndependentProgID
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDVersionIndependentProgID].Section, @pRegistryKeyTable[RegistryKeys.CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.CLSIDVersionIndependentProgID].Section, "\VersionIndependentProgID")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.CLSIDVersionIndependentProgID].Value, VersionIndependentProgID)
	End Scope
	
End Sub
