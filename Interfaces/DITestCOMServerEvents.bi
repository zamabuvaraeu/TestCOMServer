#ifndef DITESTCOMSERVEREVENTS_BI
#define DITESTCOMSERVEREVENTS_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"
#include "win\oaidl.bi"
#include "win\olectl.bi"
#include "win\wtypes.bi"

Extern DIID_ITestComServerEvents Alias "DIID_ITestComServerEvents" As Const IID

Type DITestCOMServerEvents As DITestCOMServerEvents_

Type LPDTESTCOMSERVEREVENTS As DITestCOMServerEvents Ptr

Type DITestCOMServerEventsVirtualTable
	
	Dim QueryInterface As Function( _
		ByVal this As DITestCOMServerEvents Ptr, _
		ByVal riid As const IID const Ptr, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim AddRef As Function( _
		ByVal this As DITestCOMServerEvents Ptr _
	)As ULONG
	
	Dim Release As Function( _
		ByVal this As DITestCOMServerEvents Ptr _
	)As ULONG
	
	Dim GetTypeInfoCount As Function( _
		ByVal this As DITestCOMServerEvents Ptr, _
		ByVal pctinfo As UINT Ptr _
	)As HRESULT
	
	Dim GetTypeInfo As Function( _
		ByVal this As DITestCOMServerEvents Ptr, _
		ByVal iTInfo As UINT, _
		ByVal lcid As LCID, _
		ByVal ppTInfo As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	Dim GetIDsOfNames As Function( _
		ByVal this As DITestCOMServerEvents Ptr, _
		ByVal riid As Const IID Const Ptr, _
		ByVal rgszNames As LPOLESTR Ptr, _
		ByVal cNames As UINT, _
		ByVal lcid As LCID, _
		ByVal rgDispId As DISPID Ptr _
	)As HRESULT
	
	Dim Invoke As Function( _
		ByVal this As DITestCOMServerEvents Ptr, _
		ByVal dispIdMember As DISPID, _
		ByVal riid As Const IID Const Ptr, _
		ByVal lcid As LCID, _
		ByVal wFlags As WORD, _
		ByVal pDispParams As DISPPARAMS Ptr, _
		ByVal pVarResult As VARIANT Ptr, _
		ByVal pExcepInfo As EXCEPINFO Ptr, _
		ByVal puArgErr As UINT Ptr _
	)As HRESULT
	
End Type

Type DITestCOMServerEvents_
	Dim lpVtbl As DITestCOMServerEventsVirtualTable Ptr
End Type

#define DITestCOMServerEvents_ToIUnknown(this) (CPtr(IUnknown Ptr, (this)))

#define DITestCOMServerEvents_QueryInterface(this, riid, ppvObject) (this)->lpVtbl->QueryInterface(this, riid, ppvObject)
#define DITestCOMServerEvents_AddRef(this) (this)->lpVtbl->AddRef(this)
#define DITestCOMServerEvents_Release(this) (this)->lpVtbl->Release(this)
#define DITestCOMServerEvents_GetTypeInfoCount(this, pctinfo) (this)->lpVtbl->GetTypeInfoCount(this, pctinfo)
#define DITestCOMServerEvents_GetTypeInfo(this, iTInfo, lcid, ppTInfo) (this)->lpVtbl->GetTypeInfo(this, iTInfo, lcid, ppTInfo)
#define DITestCOMServerEvents_GetIDsOfNames(this, riid, rgszNames, cNames, lcid, rgDispId) (this)->lpVtbl->GetIDsOfNames(this, riid, rgszNames, cNames, lcid, rgDispId)
#define DITestCOMServerEvents_Invoke(this, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr) (this)->lpVtbl->Invoke(this, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr)

#endif
