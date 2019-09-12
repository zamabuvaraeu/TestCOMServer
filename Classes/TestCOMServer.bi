#ifndef TESTCOMSERVER_BI
#define TESTCOMSERVER_BI

#include "ITestCOMServer.bi"

Const ProgID_TestCOMServer = "BatchedFiles.TestCOMServer.1"
Const VersionIndependentProgID_TestCOMServer = "BatchedFiles.TestCOMServer"

' {8093BC4B-F7BD-4D4A-AF46-F0D094DF9AF8}
Dim Shared CLSID_TESTCOMSERVER As CLSID = Type(&h8093bc4b, &hf7bd, &h4d4a, _
	{&haf, &h46, &hf0, &hd0, &h94, &hdf, &h9a, &hf8} _
)

Const CLSIDS_TESTCOMSERVER = "{8093BC4B-F7BD-4D4A-AF46-F0D094DF9AF8}"

Type TestCOMServer
	Dim pVirtualTable As ITestCOMServerVirtualTable Ptr
	Dim ReferenceCounter As ULONG
	Dim ExistsInStack As Boolean
End Type

Declare Sub InitializeTestCOMServerVirtualTable()

Declare Function CreateTestCOMServerOfITestCOMServer( _
)As ITestCOMServer Ptr

Declare Function TestCOMServerQueryInterface( _
	ByVal This As TestCOMServer Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerAddRef( _
	ByVal This As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerRelease( _
	ByVal This As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerGetTypeInfoCount( _
	ByVal This As TestCOMServer Ptr, _
	ByVal pctinfo As UINT Ptr _
)As HRESULT

Declare Function TestCOMServerGetTypeInfo( _
	ByVal This As TestCOMServer Ptr, _
	ByVal iTInfo As UINT, _
	ByVal lcid As LCID, _
	ByVal ppTInfo As ITypeInfo Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerGetIDsOfNames( _
	ByVal This As TestCOMServer Ptr, _
	ByVal riid As Const IID Const ptr, _
	ByVal rgszNames As LPOLESTR Ptr, _
	ByVal cNames As UINT, _
	ByVal lcid As LCID, _
	ByVal rgDispId As DISPID Ptr _
)As HRESULT

Declare Function TestCOMServerInvoke( _
	ByVal This As TestCOMServer Ptr, _
	ByVal dispIdMember As DISPID, _
	ByVal riid As Const IID Const Ptr, _
	ByVal lcid As LCID, _
	ByVal wFlags As WORD, _
	ByVal pDispParams As DISPPARAMS Ptr, _
	ByVal pVarResult As VARIANT Ptr, _
	ByVal pExcepInfo As EXCEPINFO Ptr, _
	ByVal puArgErr As UINT Ptr _
)As HRESULT

Declare Function TestCOMServerShowMessageBox( _
	ByVal This As TestCOMServer Ptr, _
	ByVal Param As Long, _
	ByVal pResult As Long Ptr _
)As HRESULT

#endif
