#ifndef ITESTCOMSERVER_BI
#define ITESTCOMSERVER_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ocidl.bi"

Extern IID_ITestComServer Alias "IID_ITestComServer" As Const IID

Type ITestCOMServer As ITestCOMServer_

Type LPITESTCOMSERVER As ITestCOMServer Ptr

Type ITestCOMServerVirtualTable
	
	Dim InheritedTable As IDispatchVtbl
	
	Dim GetObjectsCount As Function( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
	Dim GetReferencesCount As Function( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
	Dim SetCallBack As Function( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal CallBack As IDispatch Ptr, _
		ByVal UserName As BSTR _
	)As HRESULT
	
	Dim InvokeCallBack As Function( _
		ByVal this As ITestCOMServer Ptr _
	)As HRESULT
	
End Type

Type ITestCOMServer_
	Dim pVirtualTable As ITestCOMServerVirtualTable Ptr
End Type

#define ITestCOMServer_ToIDispatch(this) (CPtr(IDispatch Ptr, (this)))
#define ITestCOMServer_ToIUnknown(this) (CPtr(IUnknown Ptr, (this)))

#define ITestCOMServer_QueryInterface(this, riid, ppvObject) (this)->lpVtbl->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, this), riid, ppvObject)
#define ITestCOMServer_AddRef(this) (this)->lpVtbl->InheritedTable.AddRef(CPtr(IUnknown Ptr, this))
#define ITestCOMServer_Release(this) (this)->lpVtbl->InheritedTable.Release(CPtr(IUnknown Ptr, this))
#define ITestCOMServer_GetTypeInfoCount(this, pctinfo) (this)->lpVtbl->InheritedTable.GetTypeInfoCount(CPtr(IDispatch Ptr, this), pctinfo)
#define ITestCOMServer_GetTypeInfo(this, iTInfo, lcid, ppTInfo) (this)->lpVtbl->InheritedTable.GetTypeInfo(CPtr(IDispatch Ptr, this), iTInfo, lcid, ppTInfo)
#define ITestCOMServer_GetIDsOfNames(this, riid, rgszNames, cNames, lcid, rgDispId) (this)->lpVtbl->InheritedTable.GetIDsOfNames(CPtr(IDispatch Ptr, this), riid, rgszNames, cNames, lcid, rgDispId)
#define ITestCOMServer_Invoke(this, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr) (this)->lpVtbl->InheritedTable.Invoke(CPtr(IDispatch Ptr, this), dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr)
#define ITestCOMServer_SetCallBack(this, CallBack, Param) (this)->lpVtbl->SetCallBack(this, CallBack, Param)
#define ITestCOMServer_InvokeCallBack(this, pResult) (this)->lpVtbl->InvokeCallBack(this, pResult)


#endif
