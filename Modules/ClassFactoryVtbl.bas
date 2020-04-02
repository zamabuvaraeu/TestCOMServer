#include "ClassFactoryVtbl.bi"
#include "ContainerOf.bi"

Function IClassFactoryQueryInterface( _
		ByVal this As IClassFactory Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return ClassFactoryQueryInterface(ContainerOf(this, ClassFactory, pVirtualTable), riid, ppv)
End Function

Function IClassFactoryAddRef( _
		ByVal this As IClassFactory Ptr _
	)As ULONG
	Return ClassFactoryAddRef(ContainerOf(this, ClassFactory, pVirtualTable))
End Function

Function IClassFactoryRelease( _
		ByVal this As IClassFactory Ptr _
	)As ULONG
	Return ClassFactoryRelease(ContainerOf(this, ClassFactory, pVirtualTable))
End Function

Function IClassFactoryCreateInstance( _
		ByVal this As IClassFactory Ptr, _
		ByVal pUnknownOuter As IUnknown Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return ClassFactoryCreateInstance(ContainerOf(this, ClassFactory, pVirtualTable), pUnknownOuter, riid, ppv)
End Function

Function IClassFactoryLockServer( _
		ByVal this As IClassFactory Ptr, _
		ByVal fLock As BOOL _
	)As HRESULT
	Return ClassFactoryLockServer(ContainerOf(this, ClassFactory, pVirtualTable), fLock)
End Function

Extern GlobalClassFactoryVirtualTable As Const IClassFactoryVtbl
Dim GlobalClassFactoryVirtualTable As Const IClassFactoryVtbl = Type( _
	@IClassFactoryQueryInterface, _
	@IClassFactoryAddRef, _
	@IClassFactoryRelease, _
	@IClassFactoryCreateInstance, _
	@IClassFactoryLockServer _
)
