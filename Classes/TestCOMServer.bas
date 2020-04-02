#include "TestCOMServer.bi"
#include "ContainerOf.bi"
#include "ITestCOMServerEvents.bi"
#include "ObjectsCounter.bi"
#include "TypeLibrary.bi"

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000
Const CallBackFunctionName = "CallBack"
Const GreetingsW = "Привет, "

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
	Dim lpIDispatchCallBack As IDispatch Ptr
	Dim UserName As BSTR
	
End Type

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

Common Shared PGlobalCounter As ObjectsCounter Ptr

Dim Shared GlobalTestCOMServerVirtualTable As ITestCOMServerVirtualTable = Type( _
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

Dim Shared GlobalTestCOMServerDelegatingVirtualTable As IUnknownVtbl = Type( _
	@ITestCOMServerDelegatingQueryInterface, _
	@ITestCOMServerDelegatingAddRef, _
	@ITestCOMServerDelegatingRelease _
)

Dim Shared GlobalTestCOMServerIObjectWithSiteVirtualTable As IObjectWithSiteVtbl = Type( _
	@ITestCOMServerObjectWithSiteQueryInterface, _
	@ITestCOMServerObjectWithSiteAddRef, _
	@ITestCOMServerObjectWithSiteRelease, _
	@ITestCOMServerObjectWithSiteSetSite, _
	@ITestCOMServerObjectWithSiteGetSite _
)

Dim Shared GlobalTestCOMServerISupportErrorInfoVirtualTable As ISupportErrorInfoVtbl = Type( _
	@ITestCOMServerSupportErrorInfoQueryInterface, _
	@ITestCOMServerSupportErrorInfoAddRef, _
	@ITestCOMServerSupportErrorInfoRelease, _
	@ITestCOMServerInterfaceSupportsErrorInfo _
)

Dim Shared GlobalTestCOMServerIProvideClassInfoVirtualTable As IProvideClassInfoVtbl = Type( _
	@ITestCOMServerProvideClassInfoQueryInterface, _
	@ITestCOMServerProvideClassInfoAddRef, _
	@ITestCOMServerProvideClassInfoRelease, _
	@ITestCOMServerGetClassInfo _
)

' Dim Shared GlobalTestCOMServerEventsVirtualTable As ITestCOMServerEventsVirtualTable = Type( _
	' @TestCOMServerQueryInterface, _
	' @TestCOMServerAddRef, _
	' @TestCOMServerRelease, _
	' @TestCOMServerGetTypeInfoCount, _
	' @TestCOMServerGetTypeInfo, _
	' @TestCOMServerGetIDsOfNames, _
	' @TestCOMServerInvoke, _
	' @TestCOMServerGetObjectsCount, _
	' @TestCOMServerGetReferencesCount _
' )

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
	pTestCOMServer->lpIDispatchCallBack = NULL
	pTestCOMServer->UserName = NULL
	
	Dim pITypeLib As ITypeLib Ptr = NULL
	Dim hr As HRESULT = LoadRegTypeLib( _
		@LIBID_TESTCOMSERVER_10, _
		TYPELIBRARY_VERSION_MAJOR, _
		TYPELIBRARY_VERSION_MINOR, _
		0, _
		@pITypeLib _
	)
	
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
		ByVal this As TestCOMServer Ptr _
	)
	
	ObjectsCounterDecrement(PGlobalCounter)
	
	If this->pIUnknownOuter <> NULL Then
		IUnknown_Release(this->pIUnknownOuter)
	End If
	
	If this->pUnkSite <> NULL Then
		IUnknown_Release(this->pUnkSite)
	End If
	
	If this->pITestCOMServerTypeInfo <> NULL Then
		IUnknown_Release(this->pITestCOMServerTypeInfo)
	End If
	
	If this->lpIDispatchCallBack <> NULL Then
		IDispatch_Release(this->lpIDispatchCallBack)
	End If
	
	SysFreeString(this->UserName)
	
	DeleteCriticalSection(@this->crSection)
	
	HeapFree( _
		GetProcessHeap(), _
		0, _
		this _
	)
	
End Sub

Function TestCOMServerQueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	If IsEqualIID(@IID_ITestCOMServer, riid) Then
		*ppv = @this->pVirtualTable
	Else
		If IsEqualIID(@IID_IDispatch, riid) Then
			*ppv = @this->pVirtualTable
		Else
			If IsEqualIID(@IID_IUnknown, riid) Then
				If this->pIUnknownOuter = NULL Then
					*ppv = @this->pVirtualTable
				Else
					*ppv = @this->pDelegatingVirtualTable
				End If
			Else
				If IsEqualIID(@IID_IObjectWithSite, riid) Then
					*ppv = @this->pIObjectWithSiteVirtualTable
				Else
					If IsEqualIID(@IID_ISupportErrorInfo, riid) Then
						*ppv = @this->pISupportErrorInfoVirtualTable
					Else
						If IsEqualIID(@IID_IProvideClassInfo, riid) Then
							*ppv = @this->pIProvideClassInfoVirtualTable
						Else
							*ppv = NULL
							Return E_NOINTERFACE
						End If
					End If
				End If
			End If
		End If
	End If
	
	' If IsEqualIID(@IID_IProvideMultipleClassInfo, riid) Then
		' *ppv = NULL
	' End If
	' If IsEqualIID(@IID_IDispatchEx, riid) Then
		' *ppv = NULL
	' End If
	
	TestCOMServerAddRef(this)
	
	Return S_OK
	
End Function

Function TestCOMServerAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	EnterCriticalSection(@this->crSection)
	Scope
		
		this->ReferenceCounter += 1
		
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	Return this->ReferenceCounter
	
End Function

Function TestCOMServerRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	EnterCriticalSection(@this->crSection)
	Scope
		
		this->ReferenceCounter -= 1
		
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	If this->ReferenceCounter = 0 Then
		
		DestroyTestCOMServer(this)
		
		Return 0
		
	End If
	
	Return this->ReferenceCounter
	
End Function

Function TestCOMServerGetTypeInfoCount( _
		ByVal this As TestCOMServer Ptr, _
		ByVal pctinfo As UINT Ptr _
	)As HRESULT
	
	*pctinfo = 1
	
	Return S_OK
	
End Function

Function TestCOMServerGetTypeInfo( _
		ByVal this As TestCOMServer Ptr, _
		ByVal iTInfo As UINT, _
		ByVal lcid As LCID, _
		ByVal ppTInfo As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	*ppTInfo = NULL
	
	If iTInfo <> 0 Then
		Return DISP_E_BADINDEX
	End If
	
	If this->pITestCOMServerTypeInfo <> NULL Then
		IUnknown_AddRef(this->pITestCOMServerTypeInfo)
	End If
	
	*ppTInfo = this->pITestCOMServerTypeInfo
	
	Return S_OK
	
End Function

Function TestCOMServerGetIDsOfNames( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As Const IID Const ptr, _
		ByVal rgszNames As LPOLESTR Ptr, _
		ByVal cNames As UINT, _
		ByVal lcid As LCID, _
		ByVal rgDispId As DISPID Ptr _
	)As HRESULT
	
	Return ITypeInfo_GetIDsOfNames( _
		this->pITestCOMServerTypeInfo, _
		rgszNames, _
		cNames, _
		rgDispId _
	)
	
End Function

Function TestCOMServerInvoke( _
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
	
	If IsEqualIID(@IID_NULL, riid) = False Then
		Return DISP_E_UNKNOWNINTERFACE
	End If
	
	SetErrorInfo(0, NULL)
	
	Return ITypeInfo_Invoke( _
		this->pITestCOMServerTypeInfo, _
		this, _
		dispIdMember, _
		wFlags, _
		pDispParams, _
		pVarResult, _
		pExcepInfo, _
		puArgErr _
	)
	
End Function

Function TestCOMServerGetObjectsCount( _
		ByVal this As TestCOMServer Ptr, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
	*pResult = CLng(ObjectsCounterGetCounterValue(PGlobalCounter))
	
	Return S_OK
	
End Function

Function TestCOMServerGetReferencesCount( _
		ByVal this As TestCOMServer Ptr, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
	*pResult = CLng(this->ReferenceCounter)
	
	Return S_OK
	
End Function

Function TestCOMServerSetCallBack( _
		ByVal this As TestCOMServer Ptr, _
		ByVal CallBack As IDispatch Ptr, _
		ByVal UserName As BSTR _
	)As HRESULT
	
	If this->lpIDispatchCallBack <> NULL Then
		IDispatch_Release(this->lpIDispatchCallBack)
	End If
	
	this->lpIDispatchCallBack = CallBack
	
	If this->lpIDispatchCallBack <> NULL Then
		IDispatch_AddRef(this->lpIDispatchCallBack)
	End If
	
	/'
	Dim pIDispatchEx As IUnknown Ptr = Any
	Dim hr As HRESULT = IUnknown_QueryInterface( _
		this->lpIDispatchCallBack, _
		@IID_ISupportErrorInfo, _
		@pIDispatchEx _
	)
	If SUCCEEDED(hr) Then
		MessageBoxW(NULL, "Получил интерфейс IDispatchEx", "TestCOMServer", MB_OK)
		IUnknown_Release(pIDispatchEx)
	End If
	'/
	
	SysFreeString(this->UserName)
	this->UserName = SysAllocStringLen(UserName, SysStringLen(UserName))
	
	Return S_OK
	
End Function

Function TestCOMServerInvokeCallBack( _
		ByVal this As TestCOMServer Ptr _
	)As HRESULT
	
	If this->lpIDispatchCallBack = NULL Then
		Return E_POINTER
	End If
	
	Const NAMES_LENGTH As UINT = 1
	
	Dim rgszNames(NAMES_LENGTH - 1) As WString Ptr = {@CallBackFunctionName}
	Dim rgDispIds(NAMES_LENGTH - 1) As DISPID = Any
	
	Dim hr As HRESULT = IDispatch_GetIDsOfNames( _
		this->lpIDispatchCallBack, _
		@IID_NULL, _
		@rgszNames(0), _
		NAMES_LENGTH, _
		GetUserDefaultLCID(), _
		@rgDispIds(0) _
	)
	If FAILED(hr) Then
		Return E_FAIL
	End If
	
	Const PARAMS_LENGTH As Integer = 1
	
	Dim varParam(PARAMS_LENGTH - 1) As VARIANT = Any
	For i As Integer = 0 To PARAMS_LENGTH - 1
		VariantInit(@varParam(i))
	Next
	
	Dim Greetings As BSTR = SysAllocString(@GreetingsW)
	Dim GreetingsUserName As BSTR = Any
	VarBstrCat(Greetings, this->UserName, @GreetingsUserName)
	
	varParam(0).vt = VT_BSTR
	varParam(0).bstrVal = GreetingsUserName
	
	Dim Params(0) As DISPPARAMS = Any
	Params(0).rgvarg = @varParam(0)
	Params(0).cArgs = PARAMS_LENGTH
	Params(0).rgdispidNamedArgs = NULL
	Params(0).cNamedArgs = 0
	
	Dim VarResult As VARIANT = Any
	Dim ExcepInfo As EXCEPINFO = Any
	Dim uArgErr As UINT = Any
	
	hr = IDispatch_Invoke( _
		this->lpIDispatchCallBack, _
		rgDispIds(0), _
		@IID_NULL, _
		GetUserDefaultLCID(), _
		DISPATCH_METHOD, _
		@Params(0), _
		@VarResult, _
		NULL, _
		NULL _
	)
	
	For i As Integer = 0 To PARAMS_LENGTH - 1
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
	
	Return IUnknown_QueryInterface(this->pIUnknownOuter, riid, ppv)
	
End Function

Function TestCOMServerDelegatingAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return IUnknown_AddRef(this->pIUnknownOuter)
	
End Function

Function TestCOMServerDelegatingRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return IUnknown_Release(this->pIUnknownOuter)
	
End Function

Function TestCOMServerObjectWithSiteQueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	Return TestCOMServerQueryInterface(this, riid, ppv)
	
End Function

Function TestCOMServerObjectWithSiteAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerAddRef(this)
	
End Function

Function TestCOMServerObjectWithSiteRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerRelease(this)
	
End Function

Function TestCOMServerObjectWithSiteSetSite( _
		ByVal this As TestCOMServer Ptr, _
		ByVal pUnkSite As IUnknown Ptr _
	)As HRESULT
	
	If this->pUnkSite <> NULL Then
		IUnknown_Release(this->pUnkSite)
	End If
	
	If pUnkSite = NULL Then
		this->pUnkSite = NULL
	Else
		this->pUnkSite = pUnkSite
		IUnknown_AddRef(this->pUnkSite)
	End If
	
	Return S_OK
	
End Function

Function TestCOMServerObjectWithSiteGetSite( _
		ByVal this As TestCOMServer Ptr, _
		byval riid As Const IID Const Ptr, _
		ByVal ppvSite As Any Ptr Ptr _
	)As HRESULT
	
	If this->pUnkSite <> NULL Then
		IUnknown_AddRef(this->pUnkSite)
	End If
	
	*ppvSite = this->pUnkSite
	
	Return S_OK
	
End Function

Function TestCOMServerSupportErrorInfoQueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	Return TestCOMServerQueryInterface(this, riid, ppv)
	
End Function

Function TestCOMServerSupportErrorInfoAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerAddRef(this)
	
End Function

Function TestCOMServerSupportErrorInfoRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerRelease(this)
	
End Function

Function TestCOMServerInterfaceSupportsErrorInfo( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID _
	)As HRESULT
	
	Return S_OK
	
End Function

Function TestCOMServerProvideClassInfoQueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	Return TestCOMServerQueryInterface(this, riid, ppv)
	
End Function

Function TestCOMServerProvideClassInfoAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerAddRef(this)
	
End Function

Function TestCOMServerProvideClassInfoRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerRelease(this)
	
End Function

Function TestCOMServerGetClassInfo( _
		ByVal this As TestCOMServer Ptr, _
		ByVal ppTI As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	If this->pITestCOMServerTypeInfo <> NULL Then
		IUnknown_AddRef(this->pITestCOMServerTypeInfo)
	End If
	
	*ppTI = this->pITestCOMServerTypeInfo
	
	Return S_OK
	
End Function
