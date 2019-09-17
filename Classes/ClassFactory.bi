#ifndef CLASSFACTORY_BI
#define CLASSFACTORY_BI

#include "windows.bi"
#include "win\objbase.bi"

Type ClassFactory
	
	Dim pVirtualTable As IClassFactoryVtbl Ptr
	Dim ReferenceCounter As ULONG
	
End Type

Declare Sub InitializeClassFactoryVirtualTable()

Declare Function CreateClassFactory( _
)As ClassFactory Ptr

Declare Sub DestroyClassFactory( _
	ByVal pClassFactory As ClassFactory Ptr _
)

Declare Function ClassFactoryQueryInterface( _
	ByVal pClassFactory As ClassFactory Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function ClassFactoryAddRef( _
	ByVal pClassFactory As ClassFactory Ptr _
)As ULONG

Declare Function ClassFactoryRelease( _
	ByVal pClassFactory As ClassFactory Ptr _
)As ULONG

Declare Function ClassFactoryCreateInstance( _
	ByVal pClassFactory As ClassFactory Ptr, _
	ByVal pUnknownOuter As IUnknown Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function ClassFactoryLockServer( _
	ByVal pClassFactory As ClassFactory Ptr, _
	ByVal fLock As BOOL _
)As HRESULT

#endif
