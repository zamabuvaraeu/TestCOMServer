#include "TestCOMServerEventsConnectionPointVtbl.bi"
#include "ContainerOf.bi"

Function ITestCOMServerEventsConnectionPointQueryInterface( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointQueryInterface(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), riid, ppvObject)
End Function

Function ITestCOMServerEventsConnectionPointAddRef( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr _
	)As ULONG
	Return TestCOMServerEventsConnectionPointAddRef(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable))
End Function

Function ITestCOMServerEventsConnectionPointRelease( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr _
	)As ULONG
	Return TestCOMServerEventsConnectionPointRelease(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable))
End Function

Function ITestCOMServerEventsConnectionPointGetConnectionInterface( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal pIID as IID Ptr _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointGetConnectionInterface(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), pIID)
End Function

Function ITestCOMServerEventsConnectionPointGetConnectionPointContainer( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal ppCPC As IConnectionPointContainer Ptr Ptr _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointGetConnectionPointContainer(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), ppCPC)
End Function

Function ITestCOMServerEventsConnectionPointDispatchAdvise( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal pUnkSink As IUnknown Ptr, _
		ByVal pdwCookie As DWORD Ptr _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointDispatchAdvise(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), pUnkSink, pdwCookie)
End Function

Function ITestCOMServerEventsConnectionPointVirtualTableAdvise( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal pUnkSink As IUnknown Ptr, _
		ByVal pdwCookie As DWORD Ptr _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointVirtualTableAdvise(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), pUnkSink, pdwCookie)
End Function

Function ITestCOMServerEventsConnectionPointUnadvise( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal dwCookie As DWORD _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointUnadvise(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), dwCookie)
End Function

Function ITestCOMServerEventsConnectionPointEnumConnections( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal ppEnum As IEnumConnections Ptr Ptr _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointEnumConnections(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), ppEnum)
End Function

Function ITestCOMServerEventsConnectionPointSetConnectionInterface( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal pIID As REFIID _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointSetConnectionInterface(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), pIID)
End Function

Function ITestCOMServerEventsConnectionPointFillConnectionPointContainer( _
		ByVal this As ITestCOMServerEventsConnectionPoint ptr, _
		ByVal pCPC As IConnectionPointContainer Ptr _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointFillConnectionPointContainer(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), pCPC)
End Function

Function ITestCOMServerEventsConnectionPointInvokeVirtualTableOnStart( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointInvokeVirtualTableOnStart(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), Param)
End Function

Function ITestCOMServerEventsConnectionPointInvokeDispatchOnStart( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointInvokeDispatchOnStart(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), Param)
End Function

Function ITestCOMServerEventsConnectionPointInvokeDispatchOnEnd( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointInvokeDispatchOnEnd(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), Param)
End Function

Function ITestCOMServerEventsConnectionPointInvokeVirtualTableOnEnd( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	Return TestCOMServerEventsConnectionPointInvokeVirtualTableOnEnd(ContainerOf(this, TestCOMServerEventsConnectionPoint, pVirtualTable), Param)
End Function

Extern GlobalTestCOMServerEventsDispatchConnectionPointVirtualTable As Const ITestCOMServerEventsConnectionPointVirtualTable
Dim GlobalTestCOMServerEventsDispatchConnectionPointVirtualTable As Const ITestCOMServerEventsConnectionPointVirtualTable = Type( _
	@ITestCOMServerEventsConnectionPointQueryInterface, _
	@ITestCOMServerEventsConnectionPointAddRef, _
	@ITestCOMServerEventsConnectionPointRelease, _
	@ITestCOMServerEventsConnectionPointGetConnectionInterface, _
	@ITestCOMServerEventsConnectionPointGetConnectionPointContainer, _
	@ITestCOMServerEventsConnectionPointDispatchAdvise, _
	@ITestCOMServerEventsConnectionPointUnadvise, _
	@ITestCOMServerEventsConnectionPointEnumConnections, _
	@ITestCOMServerEventsConnectionPointSetConnectionInterface, _
	@ITestCOMServerEventsConnectionPointFillConnectionPointContainer, _
	@ITestCOMServerEventsConnectionPointInvokeDispatchOnStart, _
	@ITestCOMServerEventsConnectionPointInvokeDispatchOnEnd _
)

Extern GlobalTestCOMServerEventsVirtualTableConnectionPointVirtualTable As Const ITestCOMServerEventsConnectionPointVirtualTable
Dim GlobalTestCOMServerEventsVirtualTableConnectionPointVirtualTable As Const ITestCOMServerEventsConnectionPointVirtualTable = Type( _
	@ITestCOMServerEventsConnectionPointQueryInterface, _
	@ITestCOMServerEventsConnectionPointAddRef, _
	@ITestCOMServerEventsConnectionPointRelease, _
	@ITestCOMServerEventsConnectionPointGetConnectionInterface, _
	@ITestCOMServerEventsConnectionPointGetConnectionPointContainer, _
	@ITestCOMServerEventsConnectionPointVirtualTableAdvise, _
	@ITestCOMServerEventsConnectionPointUnadvise, _
	@ITestCOMServerEventsConnectionPointEnumConnections, _
	@ITestCOMServerEventsConnectionPointSetConnectionInterface, _
	@ITestCOMServerEventsConnectionPointFillConnectionPointContainer, _
	@ITestCOMServerEventsConnectionPointInvokeVirtualTableOnStart, _
	@ITestCOMServerEventsConnectionPointInvokeVirtualTableOnEnd _
)
