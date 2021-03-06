#ifndef ITESTCOMSERVEREVENTSCONNECTIONPOINT_BI
#define ITESTCOMSERVEREVENTSCONNECTIONPOINT_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\olectl.bi"

Extern IID_ITestComServerEventsConnectionPoint Alias "IID_ITestComServerEventsConnectionPoint" As Const IID

Type ITestCOMServerEventsConnectionPoint As ITestCOMServerEventsConnectionPoint_

Type LPTESTCOMSERVEREVENTSCONNECTIONPOINT As ITestCOMServerEventsConnectionPoint Ptr

Type ITestCOMServerEventsConnectionPointVirtualTable
	
	Dim QueryInterface As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal riid As const IID const Ptr, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim AddRef As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr _
	)As ULONG
	
	Dim Release As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr _
	)As ULONG
	
	Dim GetConnectionInterface As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal pIID As IID Ptr _
	)As HRESULT
	
	Dim GetConnectionPointContainer As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint ptr, _
		ByVal ppCPC As IConnectionPointContainer Ptr Ptr _
	)As HRESULT
	
	Dim Advise As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal pUnkSink As IUnknown Ptr, _
		ByVal pdwCookie As DWORD Ptr _
	)As HRESULT
	
	Dim Unadvise As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal dwCookie As DWORD _
	)As HRESULT
	
	Dim EnumConnections As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal ppEnum As IEnumConnections Ptr Ptr _
	)As HRESULT
	
	Dim SetConnectionInterface As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal pIID As REFIID _
	)As HRESULT
	
	Dim FillConnectionPointContainer As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint ptr, _
		ByVal pCPC As IConnectionPointContainer Ptr _
	)As HRESULT
	
	Dim InvokeOnStart As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	
	Dim InvokeOnEnd As Function( _
		ByVal this As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	
End Type

Type ITestCOMServerEventsConnectionPoint_
	Dim lpVtbl As ITestCOMServerEventsConnectionPointVirtualTable Ptr
End Type

#define ITestCOMServerEventsConnectionPoint_ToIUnknown(this) (CPtr(IUnknown Ptr, (this)))

#define ITestCOMServerEventsConnectionPoint_QueryInterface(this, riid, ppvObject) (this)->lpVtbl->QueryInterface(this, riid, ppvObject)
#define ITestCOMServerEventsConnectionPoint_AddRef(this) (this)->lpVtbl->AddRef(this)
#define ITestCOMServerEventsConnectionPoint_Release(this) (this)->lpVtbl->Release(this)
#define ITestCOMServerEventsConnectionPoint_GetConnectionInterface(this, pIID) (this)->lpVtbl->GetConnectionInterface(this, pIID)
#define ITestCOMServerEventsConnectionPoint_GetConnectionPointContainer(this, ppCPC) (this)->lpVtbl->GetConnectionPointContainer(this, ppCPC)
#define ITestCOMServerEventsConnectionPoint_Advise(this, pUnkSink, pdwCookie) (this)->lpVtbl->Advise(this, pUnkSink, pdwCookie)
#define ITestCOMServerEventsConnectionPoint_Unadvise(this, dwCookie) (this)->lpVtbl->Unadvise(this, dwCookie)
#define ITestCOMServerEventsConnectionPoint_EnumConnections(this, ppEnum) (this)->lpVtbl->EnumConnections(this, ppEnum)
#define ITestCOMServerEventsConnectionPoint_SetConnectionInterface(this, pIID) (this)->lpVtbl->SetConnectionInterface(this, pIID)
#define ITestCOMServerEventsConnectionPoint_FillConnectionPointContainer(this, pCPC) (this)->lpVtbl->FillConnectionPointContainer(this, pCPC)
#define ITestCOMServerEventsConnectionPoint_InvokeOnStart(this, Param) (this)->lpVtbl->InvokeOnStart(this, Param)
#define ITestCOMServerEventsConnectionPoint_InvokeOnEnd(this, Param) (this)->lpVtbl->InvokeOnEnd(this, Param)

#endif
