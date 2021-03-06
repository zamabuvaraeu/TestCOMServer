#ifndef ITESTCOMSERVER_BI
#define ITESTCOMSERVER_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"

Extern IID_ITestComServer Alias "IID_ITestComServer" As Const IID

Type ITestCOMServer As ITestCOMServer_

Type LPTESTCOMSERVER As ITestCOMServer Ptr

Type ITestCOMServerVtbl
	
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
	Dim lpVtbl As ITestCOMServerVtbl Ptr
End Type

#define ITestCOMServer_ToIDispatch(this) (CPtr(IDispatch Ptr, (this)))
#define ITestCOMServer_ToIUnknown(this) (CPtr(IUnknown Ptr, (this)))

#define ITestCOMServer_QueryInterface(this, riid, ppvObject) (this)->lpVtbl->QueryInterface(this, riid, ppvObject)
#define ITestCOMServer_AddRef(this) (this)->lpVtbl->AddRef(this)
#define ITestCOMServer_Release(this) (this)->lpVtbl->Release(this)
#define ITestCOMServer_GetTypeInfoCount(this, pctinfo) (this)->lpVtbl->GetTypeInfoCount(this, pctinfo)
#define ITestCOMServer_GetTypeInfo(this, iTInfo, lcid, ppTInfo) (this)->lpVtbl->GetTypeInfo(this, iTInfo, lcid, ppTInfo)
#define ITestCOMServer_GetIDsOfNames(this, riid, rgszNames, cNames, lcid, rgDispId) (this)->lpVtbl->GetIDsOfNames(this, riid, rgszNames, cNames, lcid, rgDispId)
#define ITestCOMServer_Invoke(this, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr) (this)->lpVtbl->Invoke(this, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr)
#define ITestCOMServer_GetObjectsCount(this, pResult) (this)->lpVtbl->GetObjectsCount(this, pResult)
#define ITestCOMServer_GetReferencesCount(this, pResult) (this)->lpVtbl->GetReferencesCount(this, pResult)
#define ITestCOMServer_SetCallBack(this, CallBack, Param) (this)->lpVtbl->SetCallBack(this, CallBack, Param)
#define ITestCOMServer_InvokeCallBack(this, pResult) (this)->lpVtbl->InvokeCallBack(this, pResult)

#endif
