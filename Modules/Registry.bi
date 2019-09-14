#ifndef REGISTRY_BI
#define REGISTRY_BI

#include "windows.bi"

Const MAX_REGISTRYCOCLASSKEYS As Integer = 11

Enum RegistryKeys
	ProgId
	ProgIdClsId
	VersionIndependentProgID
	VersionIndependentProgIDClsId
	VersionIndependentProgIDCurVer
	CLSID
	CLSIDInprocServer32
	CLSIDProgId
	CLSIDTypeLib
	CLSIDVersion
	CLSIDVersionIndependentProgID
End Enum

Type _CoClassRegistryKeyTableW
	Dim Section As WString * (MAX_PATH + 1)
	' Dim Key As WString * (MAX_PATH + 1)
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
