#ifndef REGISTRY_BI
#define REGISTRY_BI

#include "windows.bi"

Const MAX_REGISTRYCOCLASSKEYS As Integer = 11

Enum RegistryKeys
	HKLM_Classes_ProgId
	HKLM_Classes_ProgId_CLSID
	HKLM_Classes_VersionIndependentProgID
	HKLM_Classes_VersionIndependentProgID_CLSID
	HKLM_Classes_VersionIndependentProgID_CurVer
	HKLM_Classes_CLSID
	HKLM_Classes_CLSID_InprocServer32
	HKLM_Classes_CLSID_ProgId
	HKLM_Classes_CLSID_TypeLib
	HKLM_Classes_CLSID_Version
	HKLM_Classes_CLSID_VersionIndependentProgID
End Enum

Type _CoClassRegistryKeyTableW
	Dim Section As WString * (MAX_PATH + 1)
	Dim Key As WString * (MAX_PATH + 1)
	Dim Value As WString * (MAX_PATH + 1)
End Type

Type CoClassRegistryKeyTableW As _CoClassRegistryKeyTableW

Declare Function SetSettingsValueW( _
	ByVal Section As WString Ptr, _
	ByVal Key As WString Ptr, _
	ByVal Value As WString Ptr _
)As HRESULT

Declare Function RegisterCoClassW( _
	ByVal pRegistryKeyTable As CoClassRegistryKeyTableW Ptr _
)As HRESULT

Declare Function UnRegisterCoClassW( _
	ByVal pRegistryKeyTable As CoClassRegistryKeyTableW Ptr _
)As HRESULT

#endif
