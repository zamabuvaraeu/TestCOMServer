#include "TestCOMServer.bi"
#include "ContainerOf.bi"
#include "ObjectsCounter.bi"

Type _TestCOMServer
	
	Dim pVirtualTable As ITestCOMServerVirtualTable Ptr
	Dim pDelegatingVirtualTable As IUnknownVtbl Ptr
	Dim pIObjectWithSiteVirtualTable As IObjectWithSiteVtbl Ptr
	Dim pISupportErrorInfoVirtualTable As ISupportErrorInfoVtbl Ptr
	Dim pIProvideClassInfoVirtualTable As IProvideClassInfoVtbl Ptr
	
	Dim ReferenceCounter As ULONG
	Dim crSection As CRITICAL_SECTION
	Dim pIUnknownOuter As IUnknown Ptr
	Dim pUnkSite As IUnknown Ptr
	Dim pITestCOMServerTypeInfo As ITypeInfo Ptr
	Dim CallBack As IDispatch Ptr
	Dim UserName As BSTR
	
End Type

Extern IID_IUnknown_WithoutMinGW As Const IID
Extern IID_IDispatch_WithoutMinGW As Const IID
Extern IID_IDispatchEx_WithoutMinGW As Const IID
Extern IID_IObjectWithSite_WithoutMinGW As Const IID
Extern IID_ISupportErrorInfo_WithoutMinGW As Const IID
Extern IID_IProvideClassInfo_WithoutMinGW As Const IID
Extern IID_NULL_WithoutMinGW As Const IID
Extern IID_IProvideMultipleClassInfo_WithoutMinGW As Const IID

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000

Common Shared PGlobalCounter As ObjectsCounter Ptr

Dim Shared GlobalTestCOMServerVirtualTable As ITestCOMServerVirtualTable = Type( _
	@TestCOMServerQueryInterface, _
	@TestCOMServerAddRef, _
	@TestCOMServerRelease, _
	@TestCOMServerGetTypeInfoCount, _
	@TestCOMServerGetTypeInfo, _
	@TestCOMServerGetIDsOfNames, _
	@TestCOMServerInvoke, _
	@TestCOMServerGetObjectsCount, _
	@TestCOMServerGetReferencesCount, _
	@TestCOMServerSetCallBack, _
	@TestCOMServerInvokeCallBack _
)

Dim Shared GlobalTestCOMServerDelegatingVirtualTable As IUnknownVtbl = Type( _
	@TestCOMServerDelegatingQueryInterface, _
	@TestCOMServerDelegatingAddRef, _
	@TestCOMServerDelegatingRelease _
)

Dim Shared GlobalTestCOMServerIObjectWithSiteVirtualTable As IObjectWithSiteVtbl = Type( _
	@TestCOMServerObjectWithSiteQueryInterface, _
	@TestCOMServerObjectWithSiteAddRef, _
	@TestCOMServerObjectWithSiteRelease, _
	@TestCOMServerObjectWithSiteSetSite, _
	@TestCOMServerObjectWithSiteGetSite _
)

Dim Shared GlobalTestCOMServerISupportErrorInfoVirtualTable As ISupportErrorInfoVtbl = Type( _
	@TestCOMServerSupportErrorInfoQueryInterface, _
	@TestCOMServerSupportErrorInfoAddRef, _
	@TestCOMServerSupportErrorInfoRelease, _
	@TestCOMServerInterfaceSupportsErrorInfo _
)

Dim Shared GlobalTestCOMServerIProvideClassInfoVirtualTable As IProvideClassInfoVtbl = Type( _
	@TestCOMServerProvideClassInfoQueryInterface, _
	@TestCOMServerProvideClassInfoAddRef, _
	@TestCOMServerProvideClassInfoRelease, _
	@TestCOMServerGetClassInfo _
)

Function CreateTestCOMServer( _
		ByVal pIUnknownOuter As IUnknown Ptr _
	)As TestCOMServer Ptr
	
	Dim pTestCOMServer As TestCOMServer Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(TestCOMServer) _
	)
	
	If pTestCOMServer = NULL Then
		Return NULL
	End If
	
	pTestCOMServer->pVirtualTable = @GlobalTestCOMServerVirtualTable
	pTestCOMServer->pDelegatingVirtualTable = @GlobalTestCOMServerDelegatingVirtualTable
	pTestCOMServer->pIObjectWithSiteVirtualTable = @GlobalTestCOMServerIObjectWithSiteVirtualTable
	pTestCOMServer->pISupportErrorInfoVirtualTable = @GlobalTestCOMServerISupportErrorInfoVirtualTable
	pTestCOMServer->pIProvideClassInfoVirtualTable = @GlobalTestCOMServerIProvideClassInfoVirtualTable

	pTestCOMServer->ReferenceCounter = 0
	
	InitializeCriticalSectionAndSpinCount( _
		@pTestCOMServer->crSection, _
		MAX_CRITICAL_SECTION_SPIN_COUNT _
	)
	
	pTestCOMServer->pIUnknownOuter = NULL
	
	If pIUnknownOuter <> NULL Then
		' Агрегирование
	End If
	
	pTestCOMServer->pIUnknownOuter = pIUnknownOuter
	
	pTestCOMServer->pUnkSite = NULL
	pTestCOMServer->pITestCOMServerTypeInfo = NULL
	pTestCOMServer->CallBack = NULL
	pTestCOMServer->UserName = NULL
	
	Dim pITypeLib As ITypeLib Ptr = NULL
	Dim hr As HRESULT = LoadRegTypeLib(@LIBID_TESTCOMSERVER_10, 1, 0, 0, @pITypeLib)
	
	If FAILED(hr) Then
		
		DestroyTestCOMServer(pTestCOMServer)
		Return NULL
		
	End If
	
	hr = pITypeLib->lpVtbl->GetTypeInfoOfGuid( _
		pITypeLib, _
		@IID_ITestComServer, _
		@pTestCOMServer->pITestCOMServerTypeInfo _
	)
	
	IUnknown_Release(pITypeLib)
	
	If FAILED(hr) Then
		
		DestroyTestCOMServer(pTestCOMServer)
		Return NULL
		
	End If
	
	ObjectsCounterIncrement(PGlobalCounter)
	
	Return pTestCOMServer
	
End Function

Sub DestroyTestCOMServer( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)
	
	ObjectsCounterDecrement(PGlobalCounter)
	
	If pTestCOMServer->pIUnknownOuter <> NULL Then
		IUnknown_Release(pTestCOMServer->pIUnknownOuter)
	End If
	
	If pTestCOMServer->pUnkSite <> NULL Then
		IUnknown_Release(pTestCOMServer->pUnkSite)
	End If
	
	If pTestCOMServer->pITestCOMServerTypeInfo <> NULL Then
		IUnknown_Release(pTestCOMServer->pITestCOMServerTypeInfo)
	End If
	
	If pTestCOMServer->CallBack <> NULL Then
		IDispatch_Release(pTestCOMServer->CallBack)
	End If
	
	SysFreeString(pTestCOMServer->UserName)
	
	DeleteCriticalSection(@pTestCOMServer->crSection)
	
	HeapFree( _
		GetProcessHeap(), _
		0, _
		pTestCOMServer _
	)
	
End Sub

Function TestCOMServerQueryInterface( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	If IsEqualIID(@IID_IUnknown_WithoutMinGW, riid) Then
		
		If pTestCOMServer->pIUnknownOuter = NULL Then
			*ppv = @pTestCOMServer->pVirtualTable
		Else
			*ppv = @pTestCOMServer->pDelegatingVirtualTable
		End If
		
	End If
	
	If IsEqualIID(@IID_IDispatch_WithoutMinGW, riid) Then
		*ppv = @pTestCOMServer->pVirtualTable
	End If
	
	If IsEqualIID(@IID_ITestCOMServer, riid) Then
		*ppv = @pTestCOMServer->pVirtualTable
	End If
	
	If IsEqualIID(@IID_IObjectWithSite_WithoutMinGW, riid) Then
		*ppv = @pTestCOMServer->pIObjectWithSiteVirtualTable
	End If
	
	If IsEqualIID(@IID_ISupportErrorInfo_WithoutMinGW, riid) Then
		*ppv = @pTestCOMServer->pISupportErrorInfoVirtualTable
	End If
	
	If IsEqualIID(@IID_IProvideClassInfo_WithoutMinGW, riid) Then
		*ppv = @pTestCOMServer->pIProvideClassInfoVirtualTable
	End If
	
	If IsEqualIID(@IID_IDispatchEx_WithoutMinGW, riid) Then
		*ppv = NULL
	End If
	
	If IsEqualIID(@IID_IProvideMultipleClassInfo_WithoutMinGW, riid) Then
		*ppv = NULL
	End If
	
	If *ppv = NULL Then
		Return E_NOINTERFACE
	End If
	
	/'
		Const Caption = "TestCOMServer->QueryInterface"
		
				Dim pstrIID_IFace As WString Ptr = Any
				StringFromIID(riid, @pstrIID_IFace)
				MessageBoxW(NULL, pstrIID_IFace, "TestCOMServer->QueryInterface", MB_OK)
			End If
		End If
	'/
	
	TestCOMServerAddRef(pTestCOMServer)
	
	Return S_OK
	
End Function

Function TestCOMServerAddRef( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)As ULONG
	
	EnterCriticalSection(@pTestCOMServer->crSection)
	Scope
		
		pTestCOMServer->ReferenceCounter += 1
		
	End Scope
	LeaveCriticalSection(@pTestCOMServer->crSection)
	
	Return pTestCOMServer->ReferenceCounter
	
End Function

Function TestCOMServerRelease( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)As ULONG
	
	EnterCriticalSection(@pTestCOMServer->crSection)
	Scope
		
		pTestCOMServer->ReferenceCounter -= 1
		
	End Scope
	LeaveCriticalSection(@pTestCOMServer->crSection)
	
	If pTestCOMServer->ReferenceCounter = 0 Then
		
		DestroyTestCOMServer(pTestCOMServer)
		
		Return 0
		
	End If
	
	Return pTestCOMServer->ReferenceCounter
	
End Function

Function TestCOMServerGetTypeInfoCount( _
		ByVal this As TestCOMServer Ptr, _
		ByVal pctinfo As UINT Ptr _
	)As HRESULT
	
	*pctinfo = 1
	
	Return S_OK
	
End Function

Function TestCOMServerGetTypeInfo( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal iTInfo As UINT, _
		ByVal lcid As LCID, _
		ByVal ppTInfo As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	*ppTInfo = NULL
	
	If iTInfo <> 0 Then
		Return DISP_E_BADINDEX
	End If
	
	If pTestCOMServer->pITestCOMServerTypeInfo <> NULL Then
		IUnknown_AddRef(pTestCOMServer->pITestCOMServerTypeInfo)
	End If
	
	*ppTInfo = pTestCOMServer->pITestCOMServerTypeInfo
	
	Return S_OK
	
End Function

Function TestCOMServerGetIDsOfNames( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal riid As Const IID Const ptr, _
		ByVal rgszNames As LPOLESTR Ptr, _
		ByVal cNames As UINT, _
		ByVal lcid As LCID, _
		ByVal rgDispId As DISPID Ptr _
	)As HRESULT
	
	Return ITypeInfo_GetIDsOfNames( _
		pTestCOMServer->pITestCOMServerTypeInfo, _
		rgszNames, _
		cNames, _
		rgDispId _
	)
	
End Function

Function TestCOMServerInvoke( _
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
	
	If IsEqualIID(@IID_NULL_WithoutMinGW, riid) = False Then
		Return DISP_E_UNKNOWNINTERFACE
	End If
	
	SetErrorInfo(0, NULL)
	
	Return ITypeInfo_Invoke( _
		pTestCOMServer->pITestCOMServerTypeInfo, _
		pTestCOMServer, _
		dispIdMember, _
		wFlags, _
		pDispParams, _
		pVarResult, _
		pExcepInfo, _
		puArgErr _
	)
	
End Function

Function TestCOMServerGetObjectsCount( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
	*pResult = CLng(PGlobalCounter->Counter)
	
	Return S_OK
	
End Function

Function TestCOMServerGetReferencesCount( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
	*pResult = CLng(pTestCOMServer->ReferenceCounter)
	
	Return S_OK
	
End Function

Function TestCOMServerSetCallBack( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal CallBack As IDispatch Ptr, _
		ByVal UserName As BSTR _
	)As HRESULT
	
	If pTestCOMServer->CallBack <> NULL Then
		IDispatch_Release(pTestCOMServer->CallBack)
	End If
	
	pTestCOMServer->CallBack = CallBack
	
	If pTestCOMServer->CallBack <> NULL Then
		IDispatch_AddRef(pTestCOMServer->CallBack)
	End If
	
	/'
	Dim pIDispatchEx As IUnknown Ptr = Any
	Dim hr As HRESULT = IUnknown_QueryInterface( _
		pTestCOMServer->CallBack, _
		@IID_ISupportErrorInfo, _
		@pIDispatchEx _
	)
	If SUCCEEDED(hr) Then
		MessageBoxW(NULL, "Получил интерфейс IDispatchEx", "TestCOMServer", MB_OK)
		IUnknown_Release(pIDispatchEx)
	End If
	'/
	
	SysFreeString(pTestCOMServer->UserName)
	pTestCOMServer->UserName = SysAllocStringLen(UserName, SysStringLen(UserName))
	
	Return S_OK
	
End Function

Function TestCOMServerInvokeCallBack( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)As HRESULT
	
	If pTestCOMServer->CallBack = NULL Then
		Return E_POINTER
	End If
	
	Const cNames As UINT = 1
	Dim rgszNames(cNames - 1) As WString Ptr = {@"CallBack"}
	Dim rgDispId(cNames - 1) As DISPID = Any
	
	Dim hr As HRESULT = IDispatch_GetIDsOfNames( _
		pTestCOMServer->CallBack, _
		@IID_NULL_WithoutMinGW, _
		@rgszNames(0), _
		cNames, _
		GetUserDefaultLCID(), _
		@rgDispId(0) _
	)
	If FAILED(hr) Then
		MessageBoxW(NULL, "Не получил DISPID", NULL, MB_OK)
		Return E_FAIL
	End If
	
	Const ParamsCount As Integer = 1
	
	Dim varParam(ParamsCount - 1) As VARIANT = Any
	For i As Integer = 0 To ParamsCount - 1
		VariantInit(@varParam(i))
	Next
	
	Dim Greetings As BSTR = SysAllocString("Привет, ")
	Dim GreetingsUserName As BSTR = Any
	VarBstrCat(Greetings, pTestCOMServer->UserName, @GreetingsUserName)
	
	varParam(0).vt = VT_BSTR
	varParam(0).bstrVal = GreetingsUserName
	
	Dim Params(0) As DISPPARAMS = Any
	Params(0).rgvarg = @varParam(0)
	Params(0).cArgs = ParamsCount
	Params(0).rgdispidNamedArgs = NULL
	Params(0).cNamedArgs = 0
	
	Dim VarResult As VARIANT = Any
	Dim ExcepInfo As EXCEPINFO = Any
	Dim uArgErr As UINT = Any
	
	hr = IDispatch_Invoke( _
		pTestCOMServer->CallBack, _
		rgDispId(0), _
		@IID_NULL_WithoutMinGW, _
		GetUserDefaultLCID(), _
		DISPATCH_METHOD, _
		@Params(0), _
		@VarResult, _
		NULL, _
		NULL _
	)
	
	For i As Integer = 0 To ParamsCount - 1
		VariantClear(@varParam(i))
	Next
	
	SysFreeString(Greetings)
	
	Return S_OK
	
End Function

Function TestCOMServerDelegatingQueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pDelegatingVirtualTable)
	
	Return IUnknown_QueryInterface(pTestCOMServer->pIUnknownOuter, riid, ppv)
	
End Function

Function TestCOMServerDelegatingAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pDelegatingVirtualTable)
	
	Return IUnknown_AddRef(pTestCOMServer->pIUnknownOuter)
	
End Function

Function TestCOMServerDelegatingRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pDelegatingVirtualTable)
	
	Return IUnknown_Release(pTestCOMServer->pIUnknownOuter)
	
End Function

Function TestCOMServerObjectWithSiteQueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable)
	
	Return TestCOMServerQueryInterface( _
		pTestCOMServer, _
		riid, _
		ppv _
	)
	
End Function

Function TestCOMServerObjectWithSiteAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable)
	
	Return TestCOMServerAddRef(pTestCOMServer)
	
End Function

Function TestCOMServerObjectWithSiteRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable)
	
	Return TestCOMServerRelease(pTestCOMServer)
	
End Function

Function TestCOMServerObjectWithSiteSetSite( _
		ByVal this As TestCOMServer Ptr, _
		ByVal pUnkSite As IUnknown Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable)
	
	If pTestCOMServer->pUnkSite <> NULL Then
		IUnknown_Release(pTestCOMServer->pUnkSite)
	End If
	
	If pUnkSite = NULL Then
		pTestCOMServer->pUnkSite = NULL
	Else
		pTestCOMServer->pUnkSite = pUnkSite
		IUnknown_AddRef(pTestCOMServer->pUnkSite)
	End If
	
	Return S_OK
	
End Function

Function TestCOMServerObjectWithSiteGetSite( _
		ByVal this As TestCOMServer Ptr, _
		byval riid As Const IID Const Ptr, _
		ByVal ppvSite As Any Ptr Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable)
	
	If pTestCOMServer->pUnkSite <> NULL Then
		IUnknown_AddRef(pTestCOMServer->pUnkSite)
	End If
	
	*ppvSite = pTestCOMServer->pUnkSite
	
	Return S_OK
	
End Function

Function TestCOMServerSupportErrorInfoQueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pISupportErrorInfoVirtualTable)
	
	Return TestCOMServerQueryInterface( _
		pTestCOMServer, _
		riid, _
		ppv _
	)
	
End Function

Function TestCOMServerSupportErrorInfoAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pISupportErrorInfoVirtualTable)
	
	Return TestCOMServerAddRef(pTestCOMServer)
	
End Function

Function TestCOMServerSupportErrorInfoRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pISupportErrorInfoVirtualTable)
	
	Return TestCOMServerRelease(pTestCOMServer)
	
End Function

Function TestCOMServerInterfaceSupportsErrorInfo( _
		ByVal this As TestCOMServer Ptr, _
		ByVal pUnkSite As IUnknown Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pISupportErrorInfoVirtualTable)
	
	Return S_OK
	
End Function

Function TestCOMServerProvideClassInfoQueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pIProvideClassInfoVirtualTable)
	
	Return TestCOMServerQueryInterface( _
		pTestCOMServer, _
		riid, _
		ppv _
	)
	
End Function

Function TestCOMServerProvideClassInfoAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pIProvideClassInfoVirtualTable)
	
	Return TestCOMServerAddRef(pTestCOMServer)
	
End Function

Function TestCOMServerProvideClassInfoRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pIProvideClassInfoVirtualTable)
	
	Return TestCOMServerRelease(pTestCOMServer)
	
End Function

Function TestCOMServerGetClassInfo( _
		ByVal this As TestCOMServer Ptr, _
		ByVal ppTI As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = ContainerOf(this, TestCOMServer, pIProvideClassInfoVirtualTable)
	
	If pTestCOMServer->pITestCOMServerTypeInfo <> NULL Then
		IUnknown_AddRef(pTestCOMServer->pITestCOMServerTypeInfo)
	End If
	
	*ppTI = pTestCOMServer->pITestCOMServerTypeInfo
	
	Return S_OK
	
End Function
