#include "TestCOMServer.bi"
#include "ClassFactory.bi"
#include "ContainerOf.bi"
#include "DITestCOMServerEvents.bi"
#include "IntegerToWString.bi"
#include "ITestCOMServerEvents.bi"
#include "ObjectsCounter.bi"
#include "TypeLibrary.bi"

Extern IID_IDispatchEx Alias "IID_IDispatchEx" As Const IID

Extern GlobalTestCOMServerVirtualTable As Const ITestCOMServerVtbl
Extern GlobalTestCOMServerDelegatingVirtualTable As Const IUnknownVtbl
Extern GlobalTestCOMServerIObjectWithSiteVirtualTable As Const IObjectWithSiteVtbl
Extern GlobalTestCOMServerISupportErrorInfoVirtualTable As Const ISupportErrorInfoVtbl
Extern GlobalTestCOMServerIProvideClassInfo2VirtualTable As Const IProvideClassInfo2Vtbl
Extern GlobalTestCOMServerIConnectionPointContainerVirtualTable As Const IConnectionPointContainerVtbl

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000
Const CallBackFunctionName = "CallBack"
Const GreetingsW = "Привет, "

Common Shared PGlobalCounter As ObjectsCounter Ptr

Type _TestCOMServer
	
	Dim pVirtualTable As Const ITestCOMServerVtbl Ptr
	Dim pDelegatingVirtualTable As Const IUnknownVtbl Ptr
	Dim pIObjectWithSiteVirtualTable As Const IObjectWithSiteVtbl Ptr
	Dim pISupportErrorInfoVirtualTable As Const ISupportErrorInfoVtbl Ptr
	Dim pIProvideClassInfo2VirtualTable As Const IProvideClassInfo2Vtbl Ptr
	Dim pIConnectionPointContainerVirtualTable As Const IConnectionPointContainerVtbl Ptr
	Dim ReferenceCounter As Integer
	Dim crSection As CRITICAL_SECTION
	Dim pIUnknownOuter As IUnknown Ptr
	Dim pSiteObject As IUnknown Ptr
	Dim pITestCOMServerTypeInfo As ITypeInfo Ptr
	Dim lpIDispatchCallBack As IDispatch Ptr
	Dim UserName As BSTR
	Dim pIVtblPoint As ITestCOMServerEventsConnectionPoint Ptr
	Dim pIDispatchPoint As ITestCOMServerEventsConnectionPoint Ptr
	
End Type

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
	this->pIProvideClassInfo2VirtualTable = @GlobalTestCOMServerIProvideClassInfo2VirtualTable
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
	
	this->pSiteObject = NULL
	ITypeInfo_AddRef(pITestCOMServerTypeInfo)
	this->pITestCOMServerTypeInfo = pITestCOMServerTypeInfo
	this->lpIDispatchCallBack = NULL
	this->UserName = NULL
	
	ITestCOMServerEventsConnectionPoint_AddRef(pPointVtbl)
	this->pIVtblPoint = pPointVtbl
	ITestCOMServerEventsConnectionPoint_SetConnectionInterface(this->pIVtblPoint, @IID_ITestCOMServerEvents)
	ITestCOMServerEventsConnectionPoint_FillConnectionPointContainer(this->pIVtblPoint, CPtr(IConnectionPointContainer Ptr, @this->pIConnectionPointContainerVirtualTable))
	
	ITestCOMServerEventsConnectionPoint_AddRef(pPointDispatch)
	this->pIDispatchPoint = pPointDispatch
	ITestCOMServerEventsConnectionPoint_SetConnectionInterface(this->pIDispatchPoint, @DIID_ITestCOMServerEvents)
	ITestCOMServerEventsConnectionPoint_FillConnectionPointContainer(this->pIDispatchPoint, CPtr(IConnectionPointContainer Ptr, @this->pIConnectionPointContainerVirtualTable))
	
End Sub

Sub TestCOMServerUnInitialize( _
		ByVal this As TestCOMServer Ptr _
	)
	
	If this->pIUnknownOuter <> NULL Then
		IUnknown_Release(this->pIUnknownOuter)
	End If
	
	If this->pSiteObject <> NULL Then
		IUnknown_Release(this->pSiteObject)
	End If
	
	If this->pITestCOMServerTypeInfo <> NULL Then
		IUnknown_Release(this->pITestCOMServerTypeInfo)
	End If
	
	If this->lpIDispatchCallBack <> NULL Then
		IDispatch_Release(this->lpIDispatchCallBack)
	End If
	
	If this->pIVtblPoint <> NULL Then
		ITestCOMServerEventsConnectionPoint_Release(this->pIVtblPoint)
	End If
	
	If this->pIDispatchPoint <> NULL Then
		ITestCOMServerEventsConnectionPoint_Release(this->pIDispatchPoint)
	End If
	
	SysFreeString(this->UserName)
	
	DeleteCriticalSection(@this->crSection)
	
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
	TestCOMServerUnInitialize(this)
	CoTaskMemFree(this)
	
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
						If IsEqualIID(@IID_IProvideClassInfo2, riid) Then
							*ppv = @this->pIProvideClassInfo2VirtualTable
						Else
							If IsEqualIID(@IID_IProvideClassInfo, riid) Then
								*ppv = @this->pIProvideClassInfo2VirtualTable
							Else
								If IsEqualIID(@IID_IConnectionPointContainer, riid) Then
									*ppv = @this->pIConnectionPointContainerVirtualTable
								Else
									Dim lpszIID As WString Ptr = Any
									StringFromIID(riid, @lpszIID)
									' MessageBoxW(NULL, lpszIID, "Неизвестный интерфейс", MB_OK)
									Dim dwNumberOfCharsWritten As DWORD = Any
									If IsEqualIID(@IID_IDispatchEx, riid) Then
										Const wszIID_IDispatchEx = "IID_IDispatchEx"
										WriteConsoleW(GetStdHandle(STD_OUTPUT_HANDLE), @wszIID_IDispatchEx, lstrlen(@wszIID_IDispatchEx), @dwNumberOfCharsWritten, 0)
									Else
										WriteConsoleW(GetStdHandle(STD_OUTPUT_HANDLE), lpszIID, lstrlen(lpszIID), @dwNumberOfCharsWritten, 0)
									End If
									Const CrLf = !"\r\n"
									WriteConsoleW(GetStdHandle(STD_OUTPUT_HANDLE), @CrLf, 2, @dwNumberOfCharsWritten, 0)
									*ppv = NULL
									Return E_NOINTERFACE
								End If
							End If
						End If
					End If
				End If
			End If
		End If
	End If
	
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

Type ValueBSTR
	Dim BytesCount As Long
	Dim Data As WString * (511 + 1)
End Type

Function TestCOMServerGetObjectsCount( _
		ByVal this As TestCOMServer Ptr, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
	*pResult = CLng(ObjectsCounterGetCounterValue(PGlobalCounter))
	MessageBoxW(NULL, @"Start TestCOMServerGetObjectsCount", NULL, MB_OK)
	Const PARAMS_LENGTH As Integer = 1
	Dim varParam(PARAMS_LENGTH - 1) As VARIANT = Any
	For i As Integer = 0 To PARAMS_LENGTH - 1
		VariantInit(@varParam(i))
	Next
	Const Value = "Я ем пельмени"
	Dim VB As ValueBSTR = Any
	lstrcpy(VB.Data, Value)
	VB.BytesCount = lstrlen(Value) * SizeOf(WString)
	For i As Integer = 0 To PARAMS_LENGTH - 1
		varParam(i).vt = VT_BSTR
		' varParam(i).bstrVal = SysAllocString(@"Я ем пельмени!")
		varParam(i).bstrVal = @VB.Data
		
		' varParam(i).vt = VT_I8
		' varParam(i).llVal = 265
	Next
	Dim VarResult As VARIANT = Any
	VariantInit(@VarResult)
	
	Scope
		Dim hr As HRESULT = ITestCOMServerEventsConnectionPoint_InvokeOnStart(this->pIVtblPoint, varParam(0))
		If FAILED(hr) Then
			Dim src As WString * 100 = Any
			ltow(hr, @src, 16)
			MessageBoxW(NULL, @src, "InvokeOnStart FAILED", MB_OK)
		End If
	End Scope
	
	Scope
		Dim hr As HRESULT = ITestCOMServerEventsConnectionPoint_InvokeOnStart(this->pIDispatchPoint, varParam(0))
		If FAILED(hr) Then
			Dim src As WString * 100 = Any
			ltow(hr, @src, 16)
			MessageBoxW(NULL, @src, "InvokeOnStart FAILED", MB_OK)
		End If
	End Scope
	MessageBoxW(NULL, varParam(0).bstrVal, "varParam(0).bstrVal", MB_OK)
	' For i As Integer = 0 To PARAMS_LENGTH - 1
		' VariantClear(@varParam(i))
	' Next
	VariantClear(@VarResult)
	MessageBoxW(NULL, @"End TestCOMServerGetObjectsCount", NULL, MB_OK)
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
		ByVal pSiteObject As IUnknown Ptr _
	)As HRESULT
	
	If this->pSiteObject <> NULL Then
		IUnknown_Release(this->pSiteObject)
	End If
	
	If pSiteObject = NULL Then
		this->pSiteObject = NULL
	Else
		this->pSiteObject = pSiteObject
		IUnknown_AddRef(this->pSiteObject)
	End If
	
	Return S_OK
	
End Function

Function TestCOMServerObjectWithSiteGetSite( _
		ByVal this As TestCOMServer Ptr, _
		byval riid As Const IID Const Ptr, _
		ByVal ppvSite As Any Ptr Ptr _
	)As HRESULT
	
	If this->pSiteObject <> NULL Then
		IUnknown_AddRef(this->pSiteObject)
	End If
	
	*ppvSite = this->pSiteObject
	
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

Function TestCOMServerProvideClassInfo2QueryInterface( _
		ByVal this As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	Return TestCOMServerQueryInterface(this, riid, ppv)
	
End Function

Function TestCOMServerProvideClassInfo2AddRef( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerAddRef(this)
	
End Function

Function TestCOMServerProvideClassInfo2Release( _
		ByVal this As TestCOMServer Ptr _
	)As ULONG
	
	Return TestCOMServerRelease(this)
	
End Function

Function TestCOMServerProvideClassInfo2GetClassInfo( _
		ByVal this As TestCOMServer Ptr, _
		ByVal ppTI As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	If this->pITestCOMServerTypeInfo <> NULL Then
		IUnknown_AddRef(this->pITestCOMServerTypeInfo)
	End If
	*ppTI = this->pITestCOMServerTypeInfo
	
	Return S_OK
	
End Function

Function TestCOMServerProvideClassInfo2GetGUID( _
		ByVal this As TestCOMServer Ptr, _
		ByVal dwGuidKind As DWORD, _
		ByVal pGUID As GUID Ptr _
	)As HRESULT
	
	*pGUID = DIID_ITestCOMServerEvents
	
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
	
	If IsEqualIID(@IID_ITestComServerEvents, riid) Then
		IConnectionPoint_AddRef(this->pIVtblPoint)
		*ppCP = CPtr(IConnectionPoint Ptr, this->pIVtblPoint)
	Else
		If IsEqualIID(@DIID_ITestComServerEvents, riid) Then
			IConnectionPoint_AddRef(this->pIDispatchPoint)
			*ppCP = CPtr(IConnectionPoint Ptr, this->pIDispatchPoint)
		Else
			If IsEqualIID(@IID_IDispatch, riid) Then
				IConnectionPoint_AddRef(this->pIDispatchPoint)
				*ppCP = CPtr(IConnectionPoint Ptr, this->pIDispatchPoint)
			Else
				*ppCP = NULL
				Return E_UNEXPECTED
			End If
		End If
	End If
	
	Return S_OK
	
End Function


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
		ByVal pSiteObject As IUnknown Ptr _
	)As HRESULT
	Return TestCOMServerObjectWithSiteSetSite(ContainerOf(this, TestCOMServer, pIObjectWithSiteVirtualTable), pSiteObject)
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

Function ITestCOMServerProvideClassInfo2QueryInterface( _
		ByVal this As IProvideClassInfo2 Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	Return TestCOMServerProvideClassInfo2QueryInterface(ContainerOf(this, TestCOMServer, pIProvideClassInfo2VirtualTable), riid, ppv)
End Function

Function ITestCOMServerProvideClassInfo2AddRef( _
		ByVal this As IProvideClassInfo2 Ptr _
	)As ULONG
	Return TestCOMServerProvideClassInfo2AddRef(ContainerOf(this, TestCOMServer, pIProvideClassInfo2VirtualTable))
End Function

Function ITestCOMServerProvideClassInfo2Release( _
		ByVal this As IProvideClassInfo2 Ptr _
	)As ULONG
	Return TestCOMServerProvideClassInfo2Release(ContainerOf(this, TestCOMServer, pIProvideClassInfo2VirtualTable))
End Function

Function ITestCOMServerProvideClassInfo2GetClassInfo( _
		ByVal this As IProvideClassInfo2 Ptr, _
		ByVal ppTI As ITypeInfo Ptr Ptr _
	)As HRESULT
	Return TestCOMServerProvideClassInfo2GetClassInfo(ContainerOf(this, TestCOMServer, pIProvideClassInfo2VirtualTable), ppTI)
End Function

Function ITestCOMServerProvideClassInfo2GetGUID( _
		ByVal this As IProvideClassInfo2 Ptr, _
		ByVal dwGuidKind As DWORD, _
		ByVal pGUID As GUID Ptr _
	)As HRESULT
	Return TestCOMServerProvideClassInfo2GetGUID(ContainerOf(this, TestCOMServer, pIProvideClassInfo2VirtualTable), dwGuidKind, pGUID)
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

Dim GlobalTestCOMServerDelegatingVirtualTable As Const IUnknownVtbl = Type( _
	@ITestCOMServerDelegatingQueryInterface, _
	@ITestCOMServerDelegatingAddRef, _
	@ITestCOMServerDelegatingRelease _
)

Dim GlobalTestCOMServerIObjectWithSiteVirtualTable As Const IObjectWithSiteVtbl = Type( _
	@ITestCOMServerObjectWithSiteQueryInterface, _
	@ITestCOMServerObjectWithSiteAddRef, _
	@ITestCOMServerObjectWithSiteRelease, _
	@ITestCOMServerObjectWithSiteSetSite, _
	@ITestCOMServerObjectWithSiteGetSite _
)

Dim GlobalTestCOMServerISupportErrorInfoVirtualTable As Const ISupportErrorInfoVtbl = Type( _
	@ITestCOMServerSupportErrorInfoQueryInterface, _
	@ITestCOMServerSupportErrorInfoAddRef, _
	@ITestCOMServerSupportErrorInfoRelease, _
	@ITestCOMServerInterfaceSupportsErrorInfo _
)

Dim GlobalTestCOMServerIProvideClassInfo2VirtualTable As Const IProvideClassInfo2Vtbl = Type( _
	@ITestCOMServerProvideClassInfo2QueryInterface, _
	@ITestCOMServerProvideClassInfo2AddRef, _
	@ITestCOMServerProvideClassInfo2Release, _
	@ITestCOMServerProvideClassInfo2GetClassInfo, _
	@ITestCOMServerProvideClassInfo2GetGUID _
)

Dim GlobalTestCOMServerIConnectionPointContainerVirtualTable As Const IConnectionPointContainerVtbl = Type( _
	@ITestCOMServerConnectionPointContainerQueryInterface, _
	@ITestCOMServerConnectionPointContainerAddRef, _
	@ITestCOMServerConnectionPointContainerRelease, _
	@ITestCOMServerConnectionPointContainerEnumConnectionPoints, _
	@ITestCOMServerConnectionPointContainerFindConnectionPoint _
)
