#include "TestCOMServer.bi"
#include "ClassFactory.bi"
#include "ITestCOMServerEvents.bi"
#include "ObjectsCounter.bi"
#include "TypeLibrary.bi"

Extern GlobalTestCOMServerVirtualTable As Const ITestCOMServerVtbl
Extern GlobalTestCOMServerDelegatingVirtualTable As Const IUnknownVtbl
Extern GlobalTestCOMServerIObjectWithSiteVirtualTable As Const IObjectWithSiteVtbl
Extern GlobalTestCOMServerISupportErrorInfoVirtualTable As Const ISupportErrorInfoVtbl
Extern GlobalTestCOMServerIProvideClassInfoVirtualTable As Const IProvideClassInfoVtbl
Extern GlobalTestCOMServerIConnectionPointContainerVirtualTable As Const IConnectionPointContainerVtbl

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000
Const CallBackFunctionName = "CallBack"
Const GreetingsW = "Привет, "

Common Shared PGlobalCounter As ObjectsCounter Ptr

Sub TestCOMServerInitialize( _
		ByVal this As TestCOMServer Ptr, _
		ByVal pIUnknownOuter As IUnknown Ptr, _
		ByVal pITestCOMServerTypeInfo As ITypeInfo Ptr, _
		ByVal pPointVtbl As ITestCOMServerEventsConnectionPoint Ptr, _
		ByVal pPointDispatch As ITestCOMServerEventsConnectionPoint Ptr _
	)
	this->pVirtualTable = @GlobalTestCOMServerVirtualTable
	this->pDelegatingVirtualTable = @GlobalTestCOMServerDelegatingVirtualTable
	this->pIObjectWithSiteVirtualTable = @GlobalTestCOMServerIObjectWithSiteVirtualTable
	this->pISupportErrorInfoVirtualTable = @GlobalTestCOMServerISupportErrorInfoVirtualTable
	this->pIProvideClassInfoVirtualTable = @GlobalTestCOMServerIProvideClassInfoVirtualTable
	this->pIConnectionPointContainerVirtualTable = @GlobalTestCOMServerIConnectionPointContainerVirtualTable
	
	this->ReferenceCounter = 0
	
	InitializeCriticalSectionAndSpinCount( _
		@this->crSection, _
		MAX_CRITICAL_SECTION_SPIN_COUNT _
	)
	
	If pIUnknownOuter = NULL Then
		this->pIUnknownOuter = NULL
	Else
		IUnknown_AddRef(pIUnknownOuter)
		this->pIUnknownOuter = pIUnknownOuter
	End If
	
	this->pUnkSite = NULL
	ITypeInfo_AddRef(pITestCOMServerTypeInfo)
	this->pITestCOMServerTypeInfo = pITestCOMServerTypeInfo
	this->lpIDispatchCallBack = NULL
	this->UserName = NULL
	
	ITestCOMServerEventsConnectionPoint_AddRef(pPointVtbl)
	this->pIPointVtbl = pPointVtbl
	ITestCOMServerEventsConnectionPoint_SetConnectionInterface(this->pIPointVtbl, @IID_ITestCOMServerEvents)
	ITestCOMServerEventsConnectionPoint_SetConnectionPointContainer(this->pIPointVtbl, CPtr(IConnectionPointContainer Ptr, @this->pIConnectionPointContainerVirtualTable))
	
	ITestCOMServerEventsConnectionPoint_AddRef(pPointDispatch)
	this->pIPointDispatch = pPointDispatch
	ITestCOMServerEventsConnectionPoint_SetConnectionInterface(this->pIPointDispatch, @IID_ITestCOMServerEvents)
	ITestCOMServerEventsConnectionPoint_SetConnectionPointContainer(this->pIPointDispatch, CPtr(IConnectionPointContainer Ptr, @this->pIConnectionPointContainerVirtualTable))
	
End Sub

Function TestCOMServerLoadTypeInfo( _
	)As ITypeInfo Ptr
	
	Dim pITypeLib As ITypeLib Ptr = NULL
	Dim hr As HRESULT = LoadRegTypeLib( _
		@LIBID_TESTCOMSERVER_10, _
		TYPELIBRARY_VERSION_MAJOR, _
		TYPELIBRARY_VERSION_MINOR, _
		0, _
		@pITypeLib _
	)
	If FAILED(hr) Then
		Return NULL
	End If
	
	Dim pITypeInfo As ITypeInfo Ptr = NULL
	hr = pITypeLib->lpVtbl->GetTypeInfoOfGuid( _
		pITypeLib, _
		@IID_ITestComServer, _
		@pITypeInfo _
	)
	IUnknown_Release(pITypeLib)
	If FAILED(hr) Then
		Return NULL
	End If
	
	Return pITypeInfo
	
End Function

Function CreateTestCOMServer( _
		ByVal pIUnknownOuter As IUnknown Ptr, _
		ByVal ppvObject As TestCOMServer Ptr Ptr _
	)As HRESULT
	
	*ppvObject = NULL
	Dim hr As HRESULT = E_OUTOFMEMORY
	
	Dim pITestCOMServerTypeInfo As ITypeInfo Ptr = TestCOMServerLoadTypeInfo()
	
	If pITestCOMServerTypeInfo <> NULL Then
		
		Dim pFactoryEventsDispatch As IClassFactory Ptr = Any
		hr = CreateClassFactoryInterface( _
			@CLSID_CONNECTIONPOINT_DISPATCH, _
			@IID_IClassFactory, _
			@pFactoryEventsDispatch _
		)
		
		If SUCCEEDED(hr) Then
			
			Dim pFactoryEventsVtbl As IClassFactory Ptr = Any
			hr = CreateClassFactoryInterface( _
				@CLSID_CONNECTIONPOINT_VIRTUALTABLE, _
				@IID_IClassFactory, _
				@pFactoryEventsVtbl _
			)
			
			If SUCCEEDED(hr) Then
				
				Dim pPointDispatch As ITestCOMServerEventsConnectionPoint Ptr = Any
				hr = IClassFactory_CreateInstance( _
					pFactoryEventsDispatch, _
					NULL, _
					@IID_ITestCOMServerEventsConnectionPoint, _
					@pPointDispatch _
				)
				
				If SUCCEEDED(hr) Then
					
					Dim pPointVtbl As ITestCOMServerEventsConnectionPoint Ptr = Any
					hr = IClassFactory_CreateInstance( _
						pFactoryEventsVtbl, _
						NULL, _
						@IID_ITestCOMServerEventsConnectionPoint, _
						@pPointVtbl _
					)
					
					If SUCCEEDED(hr) Then
						
						Dim pTestCOMServer As TestCOMServer Ptr = CoTaskMemAlloc(SizeOf(TestCOMServer))
						If pTestCOMServer = NULL Then
							hr = E_OUTOFMEMORY
						Else
							TestCOMServerInitialize(pTestCOMServer, pIUnknownOuter, pITestCOMServerTypeInfo, pPointVtbl, pPointDispatch)
							ObjectsCounterIncrement(PGlobalCounter)
							*ppvObject = pTestCOMServer
						End If
						
						ITestCOMServerEventsConnectionPoint_Release(pPointVtbl)
					End If
					
					ITestCOMServerEventsConnectionPoint_Release(pPointDispatch)
				End If
				
				
				IClassFactory_Release(pFactoryEventsVtbl)
			End If
			
			IClassFactory_Release(pFactoryEventsDispatch)
		End If
		
		IUnknown_Release(pITestCOMServerTypeInfo)
	End If
	
	Return hr
	
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
	
	If this->pIPointVtbl <> NULL Then
		ITestCOMServerEventsConnectionPoint_Release(this->pIPointVtbl)
	End If
	
	If this->pIPointDispatch <> NULL Then
		ITestCOMServerEventsConnectionPoint_Release(this->pIPointDispatch)
	End If
	
	SysFreeString(this->UserName)
	
	DeleteCriticalSection(@this->crSection)
	
	CoTaskMemFree(this)
	MessageBoxW(NULL, "Объект сервера уничтожен, память удалена", NULL, MB_OK)
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
							If IsEqualIID(@IID_IConnectionPointContainer, riid) Then
								*ppv = @this->pIConnectionPointContainerVirtualTable
							Else
								' MessageBoxW(NULL, "Неизвестный интерфейс", NULL, MB_OK)
								*ppv = NULL
								Return E_NOINTERFACE
							End If
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
	
	Return 1
	
End Function

Function TestCOMServerRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	MessageBoxW(NULL, "TestCOMServerRelease", NULL, MB_OK)
	EnterCriticalSection(@this->crSection)
	Scope
		this->ReferenceCounter -= 1
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	If this->ReferenceCounter = 0 Then
		DestroyTestCOMServer(this)
		Return 0
	End If
	
	Return 1
	
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

Function TestCOMServerConnectionPointContainerQueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Return TestCOMServerQueryInterface(this, riid, ppvObject)
	
End Function

Function TestCOMServerConnectionPointContainerAddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerAddRef(this)
	
End Function

Function TestCOMServerConnectionPointContainerRelease( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerRelease(this)
	
End Function

Function TestCOMServerConnectionPointContainerEnumConnectionPoints( _
		ByVal this As TestCOMServer Ptr, _
		ByVal ppEnum As IEnumConnectionPoints Ptr Ptr _
	)As HRESULT
	MessageBoxW(NULL, "Перечислитель точек подключения", "Не реализовано", MB_OK)
	Return E_FAIL
End Function

Function TestCOMServerConnectionPointContainerFindConnectionPoint( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppCP As IConnectionPoint Ptr Ptr _
	)As HRESULT
	
	Dim pPoint As TestCOMServerEventsConnectionPoint Ptr = Any
	
	If IsEqualIID(@IID_ITestComServerEvents, riid) Then
		IConnectionPoint_AddRef(this->pIPointVtbl)
		*ppCP = CPtr(IConnectionPoint Ptr, this->pIPointVtbl)
	Else
		If IsEqualIID(@IID_IDispatch, riid) Then
			IConnectionPoint_AddRef(this->pIPointDispatch)
			*ppCP = CPtr(IConnectionPoint Ptr, this->pIPointDispatch)
		Else
			*ppCP = NULL
			Return E_UNEXPECTED
		End If
	End If
	
	Return S_OK
	
End Function
