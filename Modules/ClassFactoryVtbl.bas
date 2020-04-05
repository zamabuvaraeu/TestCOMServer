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

Function IClassFactoryCreateInstanceTestComServer( _
		ByVal this As IClassFactory Ptr, _
		ByVal pUnknownOuter As IUnknown Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return ClassFactoryCreateInstanceTestComServer(ContainerOf(this, ClassFactory, pVirtualTable), pUnknownOuter, riid, ppv)
End Function

Function IClassFactoryCreateInstanceConnectionPoint( _
		ByVal this As IClassFactory Ptr, _
		ByVal pUnknownOuter As IUnknown Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return ClassFactoryCreateInstanceTestComServer(ContainerOf(this, ClassFactory, pVirtualTable), pUnknownOuter, riid, ppv)
End Function

Function IClassFactoryLockServer( _
		ByVal this As IClassFactory Ptr, _
		ByVal fLock As BOOL _
	)As HRESULT
	Return ClassFactoryLockServer(ContainerOf(this, ClassFactory, pVirtualTable), fLock)
End Function

Extern GlobalClassFactoryTestComServerVirtualTable As Const IClassFactoryVtbl
Dim GlobalClassFactoryTestComServerVirtualTable As Const IClassFactoryVtbl = Type( _
	@IClassFactoryQueryInterface, _
	@IClassFactoryAddRef, _
	@IClassFactoryRelease, _
	@IClassFactoryCreateInstanceTestComServer, _
	@IClassFactoryLockServer _
)

Extern GlobalClassFactoryConnectionPointVirtualTable As Const IClassFactoryVtbl
Dim GlobalClassFactoryConnectionPointVirtualTable As Const IClassFactoryVtbl = Type( _
	@IClassFactoryQueryInterface, _
	@IClassFactoryAddRef, _
	@IClassFactoryRelease, _
	@IClassFactoryCreateInstanceConnectionPoint, _
	@IClassFactoryLockServer _
)
