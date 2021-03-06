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

Type CoClassRegistryKeyTableW As _CoClassRegistryKeyTableW

Type PCoClassRegistryKeyTableW As CoClassRegistryKeyTableW Ptr

Declare Function CreateCoClassRegistryKeyTableW( _
)As CoClassRegistryKeyTableW Ptr

Declare Sub DestroyCoClassRegistryKeyTableW( _
	ByVal this As CoClassRegistryKeyTableW Ptr _
)

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

Declare Sub FillRegistryCoClassKeyTableW( _
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

#endif
