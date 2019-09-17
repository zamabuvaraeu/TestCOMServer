#include "DLLMain.bi"
#include "windows.bi"
#include "win\olectl.bi"
#include "win\psapi.bi"
#include "win\shlwapi.bi"
#include "InitializeVirtualTables.bi"
#include "Registry.bi"
#include "Resources.rh"
#include "TestCOMServer.bi"
#include "ClassFactory.bi"

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
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_ProgId].Section, SoftwareClassesRoot)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_ProgId].Section, ProgId)
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_ProgId].Value, ClassDescription)
	End Scope
	
	' SOFTWARE\Classes\{ProgId}\CLSID = ClsIds
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_ProgId_CLSID].Section, @pRegistryKeyTable[RegistryKeys.HKLM_Classes_ProgId].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_ProgId_CLSID].Section, "\CLSID")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_ProgId_CLSID].Value, ClsIds)
	End Scope
	
	' SOFTWARE\Classes\{VersionIndependentProgID} = ClassDescription
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId].Section, SoftwareClassesRoot)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId].Section, VersionIndependentProgID)
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId].Value, ClassDescription)
	End Scope
	
	' SOFTWARE\Classes\{VersionIndependentProgID}\CLSID = ClsIds
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId_CLSID].Section, @pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId_CLSID].Section, "\CLSID")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId_CLSID].Value, ClsIds)
	End Scope
	
	' SOFTWARE\Classes\{VersionIndependentProgID}\CurVer = CurrentProgId
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId_CurVer].Section, @pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId_CurVer].Section, "\CurVer")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_VersionIndependentProgId_CurVer].Value, CurrentProgId)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx} = ClassDescription
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID].Section, SoftwareClassesRoot)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID].Section, "CLSID\")
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID].Section, ClsIds)
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID].Value, ClassDescription)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\InprocServer32 = ModuleName
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_InprocServer32].Section, @pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_InprocServer32].Section, "\InprocServer32")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_InprocServer32].Value, ModuleName)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\ProgID = ProgId
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_ProgId].Section, @pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_ProgId].Section, "\ProgID")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_ProgId].Value, ProgId)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\TypeLib = TypeLibClsids
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_TypeLib].Section, @pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_TypeLib].Section, "\TypeLib")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_TypeLib].Value, TypeLibClsids)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\Version = CurrentClassVersion
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_Version].Section, @pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_Version].Section, "\Version")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_Version].Value, CurrentClassVersion)
	End Scope
	
	' SOFTWARE\Classes\CLSID\{xxx}\VersionIndependentProgID = VersionIndependentProgID
	Scope
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_VersionIndependentProgID].Section, @pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID].Section)
		lstrcatW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_VersionIndependentProgID].Section, "\VersionIndependentProgID")
		
		lstrcpyW(@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_VersionIndependentProgID].Value, VersionIndependentProgID)
	End Scope
	
End Sub
