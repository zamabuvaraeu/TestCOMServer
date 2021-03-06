#ifndef ITESTCOMSERVEREVENTS_BI
#define ITESTCOMSERVEREVENTS_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"
#include "win\oaidl.bi"
#include "win\olectl.bi"
#include "win\wtypes.bi"

Extern IID_ITestComServerEvents Alias "IID_ITestComServerEvents" As Const IID

Type ITestCOMServerEvents As ITestCOMServerEvents_

Type LPTESTCOMSERVEREVENTS As ITestCOMServerEvents Ptr

Type ITestCOMServerEventsVirtualTable
	
	Dim QueryInterface As Function( _
		ByVal this As ITestCOMServerEvents Ptr, _
		ByVal riid As const IID const Ptr, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim AddRef As Function( _
		ByVal this As ITestCOMServerEvents Ptr _
	)As ULONG
	
	Dim Release As Function( _
		ByVal this As ITestCOMServerEvents Ptr _
	)As ULONG
	
	Dim GetTypeInfoCount As Function( _
		ByVal this As ITestCOMServerEvents Ptr, _
		ByVal pctinfo As UINT Ptr _
	)As HRESULT
	
	Dim GetTypeInfo As Function( _
		ByVal this As ITestCOMServerEvents Ptr, _
		ByVal iTInfo As UINT, _
		ByVal lcid As LCID, _
		ByVal ppTInfo As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	Dim GetIDsOfNames As Function( _
		ByVal this As ITestCOMServerEvents Ptr, _
		ByVal riid As Const IID Const Ptr, _
		ByVal rgszNames As LPOLESTR Ptr, _
		ByVal cNames As UINT, _
		ByVal lcid As LCID, _
		ByVal rgDispId As DISPID Ptr _
	)As HRESULT
	
	Dim Invoke As Function( _
		ByVal this As ITestCOMServerEvents Ptr, _
		ByVal dispIdMember As DISPID, _
		ByVal riid As Const IID Const Ptr, _
		ByVal lcid As LCID, _
		ByVal wFlags As WORD, _
		ByVal pDispParams As DISPPARAMS Ptr, _
		ByVal pVarResult As VARIANT Ptr, _
		ByVal pExcepInfo As EXCEPINFO Ptr, _
		ByVal puArgErr As UINT Ptr _
	)As HRESULT
	
	Dim OnStart As Function( _
		ByVal this As ITestCOMServerEvents Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	
	Dim OnEnd As Function( _
		ByVal this As ITestCOMServerEvents Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	
End Type

Type ITestCOMServerEvents_
	Dim lpVtbl As ITestCOMServerEventsVirtualTable Ptr
End Type

#define ITestCOMServerEvents_ToIDispatch(this) (CPtr(IDispatch Ptr, (this)))
#define ITestCOMServerEvents_ToIUnknown(this) (CPtr(IUnknown Ptr, (this)))

#define ITestCOMServerEvents_QueryInterface(this, riid, ppvObject) (this)->lpVtbl->QueryInterface(this, riid, ppvObject)
#define ITestCOMServerEvents_AddRef(this) (this)->lpVtbl->AddRef(this)
#define ITestCOMServerEvents_Release(this) (this)->lpVtbl->Release(this)
#define ITestCOMServerEvents_GetTypeInfoCount(this, pctinfo) (this)->lpVtbl->GetTypeInfoCount(this, pctinfo)
#define ITestCOMServerEvents_GetTypeInfo(this, iTInfo, lcid, ppTInfo) (this)->lpVtbl->GetTypeInfo(this, iTInfo, lcid, ppTInfo)
#define ITestCOMServerEvents_GetIDsOfNames(this, riid, rgszNames, cNames, lcid, rgDispId) (this)->lpVtbl->GetIDsOfNames(this, riid, rgszNames, cNames, lcid, rgDispId)
#define ITestCOMServerEvents_Invoke(this, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr) (this)->lpVtbl->Invoke(this, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr)
#define ITestCOMServerEvents_OnStart(this, Param) (this)->lpVtbl->OnStart(this, Param)
#define ITestCOMServerEvents_OnEnd(this, Param) (this)->lpVtbl->OnEnd(this, Param)

#endif
