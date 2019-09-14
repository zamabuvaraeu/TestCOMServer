#ifndef TESTCOMSERVER_BI
#define TESTCOMSERVER_BI

#include "ITestCOMServer.bi"

Const ShowMessageBoxParametersCount As Integer = 1
Const ShowMessageBoxDispatchIndex As DISPID = 8
Const ShowMessageBoxParamDispatchIndex As DISPID = 9

' <Program>.<Component>.<Version>
Const ProgID_TestCOMServer_10 = "BatchedFiles.TestCOMServer.1.0"
Const ProgID_TestCOMServer_CurrentProgId = ProgID_TestCOMServer_10
Const TestCOMServer_CurrentVersion = "1.0"

' <Program>.<Component>
Const VersionIndependentProgID_TestCOMServer = "BatchedFiles.TestCOMServer"

Const CLSIDS_TESTCOMSERVER_10 = "{8093BC4B-F7BD-4D4A-AF46-F0D094DF9AF8}"
Const LIBIDS_TESTCOMSERVER_10 = "{F727B565-4533-4705-BD7B-083B3DBB6D00}"

' {8093BC4B-F7BD-4D4A-AF46-F0D094DF9AF8}
Dim Shared CLSID_TESTCOMSERVER_10 As CLSID = Type(&h8093bc4b, &hf7bd, &h4d4a, _
	{&haf, &h46, &hf0, &hd0, &h94, &hdf, &h9a, &hf8} _
)

' {F727B565-4533-4705-BD7B-083B3DBB6D00}
Dim Shared LIBID_TESTCOMSERVER_10 As GUID = Type(&hf727b565, &h4533, &h4705, _
	{&hbd, &h7b, &h08, &h3b, &h3d, &hbb, &h6d, &h00} _
)

Type TestCOMServer
	
	Dim pVirtualTable As ITestCOMServerVirtualTable Ptr
	Dim ReferenceCounter As ULONG
	
End Type

Declare Sub InitializeTestCOMServerVirtualTable()

Declare Function CreateTestCOMServer( _
)As TestCOMServer Ptr

Declare Sub DestroyTestCOMServer( _
	ByVal pTestCOMServer As TestCOMServer Ptr _
)

Declare Function TestCOMServerQueryInterface( _
	ByVal pTestCOMServer As TestCOMServer Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerAddRef( _
	ByVal pTestCOMServer As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerRelease( _
	ByVal pTestCOMServer As TestCOMServer Ptr _
)As ULONG

Declare Function TestCOMServerGetTypeInfoCount( _
	ByVal pTestCOMServer As TestCOMServer Ptr, _
	ByVal pctinfo As UINT Ptr _
)As HRESULT

Declare Function TestCOMServerGetTypeInfo( _
	ByVal pTestCOMServer As TestCOMServer Ptr, _
	ByVal iTInfo As UINT, _
	ByVal lcid As LCID, _
	ByVal ppTInfo As ITypeInfo Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerGetIDsOfNames( _
	ByVal pTestCOMServer As TestCOMServer Ptr, _
	ByVal riid As Const IID Const ptr, _
	ByVal rgszNames As LPOLESTR Ptr, _
	ByVal cNames As UINT, _
	ByVal lcid As LCID, _
	ByVal rgDispId As DISPID Ptr _
)As HRESULT

Declare Function TestCOMServerInvoke( _
	ByVal pTestCOMServer As TestCOMServer Ptr, _
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
	ByVal pTestCOMServer As TestCOMServer Ptr, _
	ByVal Param As Long, _
	ByVal pResult As Long Ptr _
)As HRESULT

#endif
