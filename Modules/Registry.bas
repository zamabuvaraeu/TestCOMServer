#include "Registry.bi"
#include "win\ole2.bi"

Type _CoClassRegistryKeyTableW
	Dim Section As WString * (MAX_PATH + 1)
	Dim Key As WString * (MAX_PATH + 1)
	Dim Value As WString * (MAX_PATH + 1)
End Type

Function CreateCoClassRegistryKeyTableW( _
	)As CoClassRegistryKeyTableW Ptr
	
	Dim pTable As CoClassRegistryKeyTableW Ptr = CoTaskMemAlloc(SizeOf(CoClassRegistryKeyTableW) * MAX_REGISTRYCOCLASSKEYS)
	
	Return pTable
	
End Function

Sub DestroyCoClassRegistryKeyTableW( _
		ByVal this As CoClassRegistryKeyTableW Ptr _
	)
	
	CoTaskMemFree(this)
	
End Sub

Function SetSettingsValueW( _
		ByVal Section As WString Ptr, _
		ByVal Key As WString Ptr, _
		ByVal Value As WString Ptr _
	)As HRESULT
	
	Dim reg As HKEY = Any
	Dim lpdwDisposition As DWORD = Any
	
	Dim res As LSTATUS = RegCreateKeyExW(HKEY_LOCAL_MACHINE, Section, 0, 0, 0, KEY_SET_VALUE, NULL, @reg, @lpdwDisposition)
	If res <> ERROR_SUCCESS Then
		Return HRESULT_FROM_WIN32(res)
	End If
	
	Dim WriteBytesCount As Integer = (lstrlenW(Value) + 1) * SizeOf(WString)
	
	res = RegSetValueExW(reg, Key, 0, REG_SZ, CPtr(Byte Ptr, Value), Cast(DWORD, WriteBytesCount))
	If res <> ERROR_SUCCESS Then
		
		RegCloseKey(reg)
		Return HRESULT_FROM_WIN32(res)
		
	End If
	
	RegCloseKey(reg)
	
	Return S_OK
	
End Function

Function RegisterCoClassW( _
		ByVal pRegistryKeyTable As CoClassRegistryKeyTableW Ptr _
	)As HRESULT
	
	Const DefaultKey As WString Ptr = NULL
	
	For i As Integer = 0 To MAX_REGISTRYCOCLASSKEYS - 1
		Dim hr As HRESULT = SetSettingsValueW( _
			@pRegistryKeyTable[i].Section, _
			DefaultKey, _
			@pRegistryKeyTable[i].Value _
		)
		If FAILED(hr) Then
			Return hr
		End If
	Next
	
	Dim hr As HRESULT = SetSettingsValueW( _
		@pRegistryKeyTable[RegistryKeys.HKLM_Classes_CLSID_InprocServer32].Section, _
		"ThreadingModel", _
		"Apartment" _
	)
	If FAILED(hr) Then
		Return hr
	End If
	
	Return S_OK
	
End Function

Function UnRegisterCoClassW( _
		ByVal pRegistryKeyTable As CoClassRegistryKeyTableW Ptr _
	)As HRESULT
	
	For i As Integer = MAX_REGISTRYCOCLASSKEYS - 1 To 0 Step - 1
		Dim res As LSTATUS = RegDeleteKeyW( _
			HKEY_LOCAL_MACHINE, _
			@pRegistryKeyTable[i].Section _
		)
		If res <> ERROR_SUCCESS Then
			Return HRESULT_FROM_WIN32(res)
		End If
	Next
	
	Return S_OK
	
End Function

Sub FillRegistryCoClassKeyTableW( _
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
