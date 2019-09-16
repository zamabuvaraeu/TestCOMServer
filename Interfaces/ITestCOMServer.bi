#ifndef ITESTCOMSERVER_BI
#define ITESTCOMSERVER_BI

#include "windows.bi"
#include "win\ocidl.bi"

' {9AC86F9F-4807-40F6-BBE0-1D7E905568AB}
Dim Shared IID_ITESTCOMSERVER As IID = Type(&h9ac86f9f, &h4807, &h40f6, _
	{&hbb, &he0, &h1d, &h7e, &h90, &h55, &h68, &hab} _
)

Type ITestCOMServer As ITestCOMServer_

Type LPITESTCOMSERVER As ITestCOMServer Ptr

Type ITestCOMServerVirtualTable
	
	Dim InheritedTable As IDispatchVtbl
	
	Dim ShowMessageBox As Function( _
		ByVal pITestCOMServer As ITestCOMServer Ptr, _
		ByVal Param As Long, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
End Type

Type ITestCOMServer_
	Dim pVirtualTable As ITestCOMServerVirtualTable Ptr
End Type

#define ITestCOMServer_ToIDispatch(this) (CPtr(IDispatch Ptr, (this)))
#define ITestCOMServer_ToIUnknown(this) (CPtr(IUnknown Ptr, (this)))

#define ITestCOMServer_QueryInterface(This, riid, ppvObject) (This)->lpVtbl->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, This), riid, ppvObject)
#define ITestCOMServer_AddRef(This) (This)->lpVtbl->InheritedTable.AddRef(CPtr(IUnknown Ptr, This))
#define ITestCOMServer_Release(This) (This)->lpVtbl->InheritedTable.Release(CPtr(IUnknown Ptr, This))
#define ITestCOMServer_GetTypeInfoCount(This, pctinfo) (This)->lpVtbl->InheritedTable.GetTypeInfoCount(CPtr(IDispatch Ptr, This), pctinfo)
#define ITestCOMServer_GetTypeInfo(This, iTInfo, lcid, ppTInfo) (This)->lpVtbl->InheritedTable.GetTypeInfo(CPtr(IDispatch Ptr, This), iTInfo, lcid, ppTInfo)
#define ITestCOMServer_GetIDsOfNames(This, riid, rgszNames, cNames, lcid, rgDispId) (This)->lpVtbl->InheritedTable.GetIDsOfNames(CPtr(IDispatch Ptr, This), riid, rgszNames, cNames, lcid, rgDispId)
#define ITestCOMServer_Invoke(This, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr) (This)->lpVtbl->InheritedTable.Invoke(CPtr(IDispatch Ptr, This), dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr)
#define ITestCOMServer_ShowMessageBox(This, Param, pResult) (This)->lpVtbl->ShowMessageBox(This, Param, pResult)


#endif
