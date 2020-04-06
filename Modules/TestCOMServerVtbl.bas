#include "TestCOMServerVtbl.bi"
#include "ContainerOf.bi"

Function ITestCOMServerQueryInterface( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return TestCOMServerQueryInterface(ContainerOf(this, TestCOMServer, pVirtualTable), riid, ppv)
End Function

Function ITestCOMServerAddRef( _
		ByVal this As ITestCOMServer Ptr _
	)As ULONG
	Return TestCOMServerAddRef(ContainerOf(this, TestCOMServer, pVirtualTable))
End Function

Function ITestCOMServerRelease( _
		ByVal this As ITestCOMServer Ptr _
	)As ULONG
	Return TestCOMServerRelease(ContainerOf(this, TestCOMServer, pVirtualTable))
End Function

Function ITestCOMServerGetTypeInfoCount( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal pctinfo As UINT Ptr _
	)As HRESULT
	Return TestCOMServerGetTypeInfoCount(ContainerOf(this, TestCOMServer, pVirtualTable), pctinfo)
End Function

Function ITestCOMServerGetTypeInfo( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal iTInfo As UINT, _
		ByVal lcid As LCID, _
		ByVal ppTInfo As ITypeInfo Ptr Ptr _
	)As HRESULT
	Return TestCOMServerGetTypeInfo(ContainerOf(this, TestCOMServer, pVirtualTable), iTInfo, lcid, ppTInfo)
End Function

Function ITestCOMServerGetIDsOfNames( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal riid As Const IID Const ptr, _
		ByVal rgszNames As LPOLESTR Ptr, _
		ByVal cNames As UINT, _
		ByVal lcid As LCID, _
		ByVal rgDispId As DISPID Ptr _
	)As HRESULT
	Return TestCOMServerGetIDsOfNames(ContainerOf(this, TestCOMServer, pVirtualTable), riid, rgszNames, cNames, lcid, rgDispId)
End Function

Function ITestCOMServerInvoke( _
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
	Return TestCOMServerInvoke(ContainerOf(this, TestCOMServer, pVirtualTable), dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr)
End Function

Function ITestCOMServerGetObjectsCount( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	Return TestCOMServerGetObjectsCount(ContainerOf(this, TestCOMServer, pVirtualTable), pResult)
End Function

Function ITestCOMServerGetReferencesCount( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	Return TestCOMServerGetReferencesCount(ContainerOf(this, TestCOMServer, pVirtualTable), pResult)
End Function

Function ITestCOMServerSetCallBack( _
		ByVal this As ITestCOMServer Ptr, _
		ByVal CallBack As IDispatch Ptr, _
		ByVal UserName As BSTR _
	)As HRESULT
	Return TestCOMServerSetCallBack(ContainerOf(this, TestCOMServer, pVirtualTable), CallBack, UserName)
End Function

Function ITestCOMServerInvokeCallBack( _
		ByVal this As ITestCOMServer Ptr _
	)As HRESULT
	Return TestCOMServerInvokeCallBack(ContainerOf(this, TestCOMServer, pVirtualTable))
End Function

Function ITestCOMServerDelegatingQueryInterface( _
		ByVal this As IUnknown Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return TestCOMServerDelegatingQueryInterface(ContainerOf(this, TestCOMServer, pDelegatingVirtualTable), riid, ppv)
End Function

Function ITestCOMServerDelegatingAddRef( _
		ByVal this As IUnknown Ptr _
	)As ULONG
	Return TestCOMServerDelegatingAddRef(ContainerOf(this, TestCOMServer, pDelegatingVirtualTable))
End Function

Function ITestCOMServerDelegatingRelease( _
		ByVal this As IUnknown Ptr _
	)As ULONG
	Return TestCOMServerDelegatingRelease(ContainerOf(this, TestCOMServer, pDelegatingVirtualTable))
End Function

Function ITestCOMServerObjectWithSiteQueryInterface( _
		ByVal this As IObjectWithSite Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return TestCOMServerObjectWithSiteQueryInterface(ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable), riid, ppv)
End Function

Function ITestCOMServerObjectWithSiteAddRef( _
		ByVal this As IObjectWithSite Ptr _
	)As ULONG
	Return TestCOMServerObjectWithSiteAddRef(ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable))
End Function

Function ITestCOMServerObjectWithSiteRelease( _
		ByVal this As IObjectWithSite Ptr _
	)As ULONG
	Return TestCOMServerObjectWithSiteRelease(ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable))
End Function

Function ITestCOMServerObjectWithSiteSetSite( _
		ByVal this As IObjectWithSite Ptr, _
		ByVal pUnkSite As IUnknown Ptr _
	)As HRESULT
	Return TestCOMServerObjectWithSiteSetSite(ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable), pUnkSite)
End Function

Function ITestCOMServerObjectWithSiteGetSite( _
		ByVal this As IObjectWithSite Ptr, _
		byval riid As Const IID Const Ptr, _
		ByVal ppvSite As Any Ptr Ptr _
	)As HRESULT
	Return TestCOMServerObjectWithSiteGetSite(ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable), riid, ppvSite)
End Function

Function ITestCOMServerSupportErrorInfoQueryInterface( _
		ByVal this As ISupportErrorInfo Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return TestCOMServerSupportErrorInfoQueryInterface(ContainerOf(this, TestCOMServer, pISupportErrorInfoVirtualTable), riid, ppv)
End Function

Function ITestCOMServerSupportErrorInfoAddRef( _
		ByVal this As ISupportErrorInfo Ptr _
	)As ULONG
	Return TestCOMServerSupportErrorInfoAddRef(ContainerOf(this, TestCOMServer, pISupportErrorInfoVirtualTable))
End Function

Function ITestCOMServerSupportErrorInfoRelease( _
		ByVal this As ISupportErrorInfo Ptr _
	)As ULONG
	Return TestCOMServerSupportErrorInfoRelease(ContainerOf(this, TestCOMServer, pISupportErrorInfoVirtualTable))
End Function

Function ITestCOMServerInterfaceSupportsErrorInfo( _
		ByVal this As ISupportErrorInfo Ptr, _
		ByVal riid As REFIID _
	)As HRESULT
	Return TestCOMServerInterfaceSupportsErrorInfo(ContainerOf(this, TestCOMServer, pISupportErrorInfoVirtualTable), riid)
End Function

Function ITestCOMServerProvideClassInfoQueryInterface( _
		ByVal this As IProvideClassInfo Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return TestCOMServerProvideClassInfoQueryInterface(ContainerOf(this, TestCOMServer, pIProvideClassInfoVirtualTable), riid, ppv)
End Function

Function ITestCOMServerProvideClassInfoAddRef( _
		ByVal this As IProvideClassInfo Ptr _
	)As ULONG
	Return TestCOMServerProvideClassInfoAddRef(ContainerOf(this, TestCOMServer, pIProvideClassInfoVirtualTable))
End Function

Function ITestCOMServerProvideClassInfoRelease( _
		ByVal this As IProvideClassInfo Ptr _
	)As ULONG
	Return TestCOMServerProvideClassInfoRelease(ContainerOf(this, TestCOMServer, pIProvideClassInfoVirtualTable))
End Function

Function ITestCOMServerGetClassInfo( _
		ByVal this As IProvideClassInfo Ptr, _
		ByVal ppTI As ITypeInfo Ptr Ptr _
	)As HRESULT
	Return TestCOMServerGetClassInfo(ContainerOf(this, TestCOMServer, pIProvideClassInfoVirtualTable), ppTI)
End Function

Function ITestCOMServerConnectionPointContainerQueryInterface( _
		ByVal this As IConnectionPointContainer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	Return TestCOMServerConnectionPointContainerQueryInterface(ContainerOf(this, TestCOMServer, pIConnectionPointContainerVirtualTable), riid, ppvObject)
End Function

Function ITestCOMServerConnectionPointContainerAddRef( _
		ByVal this As IConnectionPointContainer Ptr _
	)As ULONG
	Return TestCOMServerConnectionPointContainerAddRef(ContainerOf(this, TestCOMServer, pIConnectionPointContainerVirtualTable))
End Function

Function ITestCOMServerConnectionPointContainerRelease( _
		ByVal this As IConnectionPointContainer Ptr _
	)As ULONG
	Return TestCOMServerConnectionPointContainerRelease(ContainerOf(this, TestCOMServer, pIConnectionPointContainerVirtualTable))
End Function

Function ITestCOMServerConnectionPointContainerEnumConnectionPoints( _
		ByVal this As IConnectionPointContainer Ptr, _
		ByVal ppEnum As IEnumConnectionPoints Ptr Ptr _
	)As HRESULT
	Return TestCOMServerConnectionPointContainerEnumConnectionPoints(ContainerOf(this, TestCOMServer, pIConnectionPointContainerVirtualTable), ppEnum)
End Function

Function ITestCOMServerConnectionPointContainerFindConnectionPoint( _
		ByVal this As IConnectionPointContainer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppCP As IConnectionPoint Ptr Ptr _
	)As HRESULT
	Return TestCOMServerConnectionPointContainerFindConnectionPoint(ContainerOf(this, TestCOMServer, pIConnectionPointContainerVirtualTable), riid, ppCP)
End Function

Extern GlobalTestCOMServerVirtualTable As Const ITestCOMServerVtbl
Dim GlobalTestCOMServerVirtualTable As Const ITestCOMServerVtbl = Type( _
	@ITestCOMServerQueryInterface, _
	@ITestCOMServerAddRef, _
	@ITestCOMServerRelease, _
	@ITestCOMServerGetTypeInfoCount, _
	@ITestCOMServerGetTypeInfo, _
	@ITestCOMServerGetIDsOfNames, _
	@ITestCOMServerInvoke, _
	@ITestCOMServerGetObjectsCount, _
	@ITestCOMServerGetReferencesCount, _
	@ITestCOMServerSetCallBack, _
	@ITestCOMServerInvokeCallBack _
)

Extern GlobalTestCOMServerDelegatingVirtualTable As Const IUnknownVtbl
Dim GlobalTestCOMServerDelegatingVirtualTable As Const IUnknownVtbl = Type( _
	@ITestCOMServerDelegatingQueryInterface, _
	@ITestCOMServerDelegatingAddRef, _
	@ITestCOMServerDelegatingRelease _
)

Extern GlobalTestCOMServerIObjectWithSiteVirtualTable As Const IObjectWithSiteVtbl
Dim GlobalTestCOMServerIObjectWithSiteVirtualTable As Const IObjectWithSiteVtbl = Type( _
	@ITestCOMServerObjectWithSiteQueryInterface, _
	@ITestCOMServerObjectWithSiteAddRef, _
	@ITestCOMServerObjectWithSiteRelease, _
	@ITestCOMServerObjectWithSiteSetSite, _
	@ITestCOMServerObjectWithSiteGetSite _
)

Extern GlobalTestCOMServerISupportErrorInfoVirtualTable As Const ISupportErrorInfoVtbl
Dim GlobalTestCOMServerISupportErrorInfoVirtualTable As Const ISupportErrorInfoVtbl = Type( _
	@ITestCOMServerSupportErrorInfoQueryInterface, _
	@ITestCOMServerSupportErrorInfoAddRef, _
	@ITestCOMServerSupportErrorInfoRelease, _
	@ITestCOMServerInterfaceSupportsErrorInfo _
)

Extern GlobalTestCOMServerIProvideClassInfoVirtualTable As Const IProvideClassInfoVtbl
Dim GlobalTestCOMServerIProvideClassInfoVirtualTable As Const IProvideClassInfoVtbl = Type( _
	@ITestCOMServerProvideClassInfoQueryInterface, _
	@ITestCOMServerProvideClassInfoAddRef, _
	@ITestCOMServerProvideClassInfoRelease, _
	@ITestCOMServerGetClassInfo _
)

Extern GlobalTestCOMServerIConnectionPointContainerVirtualTable As Const IConnectionPointContainerVtbl
Dim GlobalTestCOMServerIConnectionPointContainerVirtualTable As Const IConnectionPointContainerVtbl = Type( _
	@ITestCOMServerConnectionPointContainerQueryInterface, _
	@ITestCOMServerConnectionPointContainerAddRef, _
	@ITestCOMServerConnectionPointContainerRelease, _
	@ITestCOMServerConnectionPointContainerEnumConnectionPoints, _
	@ITestCOMServerConnectionPointContainerFindConnectionPoint _
)
