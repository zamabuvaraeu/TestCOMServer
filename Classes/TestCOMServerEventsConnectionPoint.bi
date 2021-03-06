#ifndef TESTCOMSERVEREVENTSCONNECTIONPOINT_BI
#define TESTCOMSERVEREVENTSCONNECTIONPOINT_BI

#include "ITestCOMServerEvents.bi"
#include "DITestCOMServerEvents.bi"
#include "ITestCOMServerEventsConnectionPoint.bi"

Extern CLSID_CONNECTIONPOINT_DISPATCH Alias "CLSID_CONNECTIONPOINT_DISPATCH" As Const CLSID
Extern CLSID_CONNECTIONPOINT_VIRTUALTABLE Alias "CLSID_CONNECTIONPOINT_VIRTUALTABLE" As Const CLSID

Type TestCOMServerEventsConnectionPoint As _TestCOMServerEventsConnectionPoint

Declare Function CreateTestCOMServerEventsDispatchConnectionPoint( _
)As TestCOMServerEventsConnectionPoint Ptr

Declare Function CreateTestCOMServerEventsVirtualTableConnectionPoint( _
)As TestCOMServerEventsConnectionPoint Ptr

Declare Sub DestroyTestCOMServerEventsConnectionPoint( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr _
)

Declare Function TestCOMServerEventsConnectionPointQueryInterface( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal riid As REFIID, _
	ByVal ppvObject As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointAddRef( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr _
)As ULONG

Declare Function TestCOMServerEventsConnectionPointRelease( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr _
)As ULONG

Declare Function TestCOMServerEventsConnectionPointGetConnectionInterface( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal pIID As IID Ptr _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointGetConnectionPointContainer( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal ppCPC As IConnectionPointContainer Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointDispatchAdvise( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal pUnkSink As IUnknown Ptr, _
	ByVal pdwCookie As DWORD Ptr _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointVirtualTableAdvise( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal pUnkSink As IUnknown Ptr, _
	ByVal pdwCookie As DWORD Ptr _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointUnadvise( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal dwCookie As DWORD _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointEnumConnections( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal ppEnum As IEnumConnections Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointSetConnectionInterface( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal pIID As REFIID _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointFillConnectionPointContainer( _
	ByVal this As TestCOMServerEventsConnectionPoint ptr, _
	ByVal pCPC As IConnectionPointContainer Ptr _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointInvokeDispatchOnStart( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal Param As VARIANT _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointInvokeVirtualTableOnStart( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal Param As VARIANT _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointInvokeDispatchOnEnd( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal Param As VARIANT _
)As HRESULT

Declare Function TestCOMServerEventsConnectionPointInvokeVirtualTableOnEnd( _
	ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
	ByVal Param As VARIANT _
)As HRESULT

#endif
