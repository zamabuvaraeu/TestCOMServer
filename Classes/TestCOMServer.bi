#ifndef TESTCOMSERVER_BI
#define TESTCOMSERVER_BI

#include "ITestCOMServer.bi"
#include "TestCOMServerEventsConnectionPoint.bi"

Extern CLSID_TESTCOMSERVER_VERSION10 Alias "CLSID_TESTCOMSERVER_VERSION10" As Const CLSID

Const ProgID_TestCOMServer_VersionIndependent = "BatchedFiles.TestCOMServer"
Const ProgID_TestCOMServer_Version10 = "BatchedFiles.TestCOMServer.1.0"
Const ProgID_TestCOMServer_VersionCurrent = ProgID_TestCOMServer_Version10
Const TestCOMServer_CurrentVersion = "1.0"

Const CLSIDS_TESTCOMSERVER_VERSION10 = "{8093BC4B-F7BD-4D4A-AF46-F0D094DF9AF8}"

Type TestCOMServer As _TestCOMServer

Declare Function CreateTestCOMServer( _
	ByVal pIUnknownOuter As IUnknown Ptr, _
	ByVal ppvObject As TestCOMServer Ptr Ptr _
)As HRESULT

Declare Sub DestroyTestCOMServer( _
	ByVal this As TestCOMServer Ptr _
)

Declare Function TestCOMServerQueryInterface( _
	ByVal this As TestCOMServer Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerAddRef( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerRelease( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerGetTypeInfoCount( _
	ByVal this As TestCOMServer Ptr, _
	ByVal pctinfo As UINT Ptr _
)As HRESULT

Declare Function TestCOMServerGetTypeInfo( _
	ByVal this As TestCOMServer Ptr, _
	ByVal iTInfo As UINT, _
	ByVal lcid As LCID, _
	ByVal ppTInfo As ITypeInfo Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerGetIDsOfNames( _
	ByVal this As TestCOMServer Ptr, _
	ByVal riid As Const IID Const ptr, _
	ByVal rgszNames As LPOLESTR Ptr, _
	ByVal cNames As UINT, _
	ByVal lcid As LCID, _
	ByVal rgDispId As DISPID Ptr _
)As HRESULT

Declare Function TestCOMServerInvoke( _
	ByVal this As TestCOMServer Ptr, _
	ByVal dispIdMember As DISPID, _
	ByVal riid As Const IID Const Ptr, _
	ByVal lcid As LCID, _
	ByVal wFlags As WORD, _
	ByVal pDispParams As DISPPARAMS Ptr, _
	ByVal pVarResult As VARIANT Ptr, _
	ByVal pExcepInfo As EXCEPINFO Ptr, _
	ByVal puArgErr As UINT Ptr _
)As HRESULT

Declare Function TestCOMServerGetObjectsCount( _
	ByVal this As TestCOMServer Ptr, _
	ByVal pResult As Long Ptr _
)As HRESULT

Declare Function TestCOMServerGetReferencesCount( _
	ByVal this As TestCOMServer Ptr, _
	ByVal pResult As Long Ptr _
)As HRESULT

Declare Function TestCOMServerSetCallBack( _
	ByVal this As TestCOMServer Ptr, _
	ByVal CallBack As IDispatch Ptr, _
	ByVal UserName As BSTR _
)As HRESULT

Declare Function TestCOMServerInvokeCallBack( _
	ByVal this As TestCOMServer Ptr _
)As HRESULT

Declare Function TestCOMServerDelegatingQueryInterface( _
	ByVal this As TestCOMServer Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerDelegatingAddRef( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerDelegatingRelease( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerObjectWithSiteQueryInterface( _
	ByVal this As TestCOMServer Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerObjectWithSiteAddRef( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerObjectWithSiteRelease( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerObjectWithSiteSetSite( _
	ByVal this As TestCOMServer Ptr, _
	ByVal pUnkSite As IUnknown Ptr _
)As HRESULT

Declare Function TestCOMServerObjectWithSiteGetSite( _
	ByVal this As TestCOMServer Ptr, _
	byval riid As Const IID Const Ptr, _
	ByVal ppvSite As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerSupportErrorInfoQueryInterface( _
	ByVal this As TestCOMServer Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerSupportErrorInfoAddRef( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerSupportErrorInfoRelease( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerInterfaceSupportsErrorInfo( _
	ByVal this As TestCOMServer Ptr, _
	ByVal riid As REFIID _
)As HRESULT

Declare Function TestCOMServerProvideClassInfo2QueryInterface( _
	ByVal this As TestCOMServer Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerProvideClassInfo2AddRef( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerProvideClassInfo2Release( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerProvideClassInfo2GetClassInfo( _
	ByVal this As TestCOMServer Ptr, _
	ByVal ppTI As ITypeInfo Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerProvideClassInfo2GetGUID( _
	ByVal this As TestCOMServer Ptr, _
	ByVal dwGuidKind As DWORD, _
	ByVal pGUID As GUID Ptr _
)As HRESULT

Declare Function TestCOMServerConnectionPointContainerQueryInterface( _
	ByVal this As TestCOMServer Ptr, _
	ByVal riid As REFIID, _
	ByVal ppvObject As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerConnectionPointContainerAddRef( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerConnectionPointContainerRelease( _
	ByVal this As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerConnectionPointContainerEnumConnectionPoints( _
	ByVal this As TestCOMServer Ptr, _
	ByVal ppEnum As IEnumConnectionPoints Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerConnectionPointContainerFindConnectionPoint( _
	ByVal this As TestCOMServer Ptr, _
	ByVal riid As REFIID, _
	ByVal ppCP As IConnectionPoint Ptr Ptr _
)As HRESULT

#endif
