#ifndef ITESTCOMSERVER_BI
#define ITESTCOMSERVER_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ocidl.bi"

Extern IID_ITestComServer Alias "IID_ITestComServer" As Const IID

Type ITestCOMServer As ITestCOMServer_

Type LPTESTCOMSERVER As ITestCOMServer Ptr

Type ITestCOMServerVirtualTable
	
	Dim QueryInterface As Function( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal riid As const IID const Ptr, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim AddRef As Function( _
		ByVal this As ITestCOMServer Ptr _
	)As ULONG
	
	Dim Release As Function( _
		ByVal this As ITestCOMServer Ptr _
	)As ULONG
	
	Dim GetTypeInfoCount As Function( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal pctinfo As UINT Ptr _
	)As HRESULT
	
	Dim GetTypeInfo As Function( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal iTInfo As UINT, _
		ByVal lcid As LCID, _
		ByVal ppTInfo As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	Dim GetIDsOfNames As Function( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal riid As Const IID Const Ptr, _
		ByVal rgszNames As LPOLESTR Ptr, _
		ByVal cNames As UINT, _
		ByVal lcid As LCID, _
		ByVal rgDispId As DISPID Ptr _
	)As HRESULT
	
	Dim Invoke As Function( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal dispIdMember As DISPID, _
		ByVal riid As Const IID Const Ptr, _
		ByVal lcid As LCID, _
		ByVal wFlags As WORD, _
		ByVal pDispParams As DISPPARAMS Ptr, _
		ByVal pVarResult As VARIANT Ptr, _
		ByVal pExcepInfo As EXCEPINFO Ptr, _
		ByVal puArgErr As UINT Ptr _
	)As HRESULT
	
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
	Dim lpVtbl As ITestCOMServerVirtualTable Ptr
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
