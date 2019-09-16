#include "Registry.bi"

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
