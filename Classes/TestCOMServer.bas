#include "TestCOMServer.bi"

#define ContainerOf(pObject, ObjectName, FieldName) CPtr(ObjectName Ptr, (CInt(pObject) - OffsetOf(ObjectName, FieldName)))

Common Shared GlobalObjectsCount As Long

Dim Shared GlobalTestCOMServerVirtualTable As ITestCOMServerVirtualTable
Dim Shared GlobalTestCOMServerDelegatingVirtualTable As IUnknownVtbl
Dim Shared GlobalTestCOMServerIObjectWithSiteVirtualTable As IObjectWithSiteVtbl
Dim Shared GlobalTestCOMServerISupportErrorInfoVirtualTable As ISupportErrorInfoVtbl

Sub InitializeTestCOMServerVirtualTable()
	
	GlobalTestCOMServerVirtualTable.InheritedTable.QueryInterface = CPtr(Any Ptr, @TestCOMServerQueryInterface)
	GlobalTestCOMServerVirtualTable.InheritedTable.AddRef = CPtr(Any Ptr, @TestCOMServerAddRef)
	GlobalTestCOMServerVirtualTable.InheritedTable.Release = CPtr(Any Ptr, @TestCOMServerRelease)
	
	GlobalTestCOMServerVirtualTable.InheritedTable.GetTypeInfoCount = CPtr(Any Ptr, @TestCOMServerGetTypeInfoCount)
	GlobalTestCOMServerVirtualTable.InheritedTable.GetTypeInfo = CPtr(Any Ptr, @TestCOMServerGetTypeInfo)
	GlobalTestCOMServerVirtualTable.InheritedTable.GetIDsOfNames = CPtr(Any Ptr, @TestCOMServerGetIDsOfNames)
	GlobalTestCOMServerVirtualTable.InheritedTable.Invoke = CPtr(Any Ptr, @TestCOMServerInvoke)
	GlobalTestCOMServerVirtualTable.GetObjectsCount = CPtr(Any Ptr, @TestCOMServerGetObjectsCount)
	GlobalTestCOMServerVirtualTable.GetReferencesCount = CPtr(Any Ptr, @TestCOMServerGetReferencesCount)
	GlobalTestCOMServerVirtualTable.SetCallBack = CPtr(Any Ptr, @TestCOMServerSetCallBack)
	GlobalTestCOMServerVirtualTable.InvokeCallBack = CPtr(Any Ptr, @TestCOMServerInvokeCallBack)
	
	GlobalTestCOMServerDelegatingVirtualTable.QueryInterface = CPtr(Any Ptr, @TestCOMServerDelegatingQueryInterface)
	GlobalTestCOMServerDelegatingVirtualTable.AddRef = CPtr(Any Ptr, @TestCOMServerDelegatingAddRef)
	GlobalTestCOMServerDelegatingVirtualTable.Release = CPtr(Any Ptr, @TestCOMServerDelegatingRelease)
	
	GlobalTestCOMServerIObjectWithSiteVirtualTable.QueryInterface = CPtr(Any Ptr, @TestCOMServerObjectWithSiteQueryInterface)
	GlobalTestCOMServerIObjectWithSiteVirtualTable.AddRef = CPtr(Any Ptr, @TestCOMServerObjectWithSiteAddRef)
	GlobalTestCOMServerIObjectWithSiteVirtualTable.Release = CPtr(Any Ptr, @TestCOMServerObjectWithSiteRelease)
	GlobalTestCOMServerIObjectWithSiteVirtualTable.SetSite = CPtr(Any Ptr, @TestCOMServerObjectWithSiteSetSite)
	GlobalTestCOMServerIObjectWithSiteVirtualTable.GetSite = CPtr(Any Ptr, @TestCOMServerObjectWithSiteGetSite)
	
	GlobalTestCOMServerISupportErrorInfoVirtualTable.QueryInterface = CPtr(Any Ptr, 0)
	GlobalTestCOMServerISupportErrorInfoVirtualTable.AddRef = CPtr(Any Ptr, 0)
	GlobalTestCOMServerISupportErrorInfoVirtualTable.Release = CPtr(Any Ptr, 0)
	GlobalTestCOMServerISupportErrorInfoVirtualTable.InterfaceSupportsErrorInfo = CPtr(Any Ptr, 0)
	
End sub

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
	
	If pTestCOMServer->pIUnknownOuter <> NULL Then
		' Агрегирование
	End If
	
	pTestCOMServer->pIUnknownOuter = pIUnknownOuter
	
	pTestCOMServer->pVirtualTable = @GlobalTestCOMServerVirtualTable
	pTestCOMServer->pDelegatingVirtualTable = @GlobalTestCOMServerDelegatingVirtualTable
	pTestCOMServer->pIObjectWithSiteVirtualTable = @GlobalTestCOMServerIObjectWithSiteVirtualTable
	pTestCOMServer->pISupportErrorInfoVirtualTable = @GlobalTestCOMServerISupportErrorInfoVirtualTable
	
	pTestCOMServer->ReferenceCounter = 0
	pTestCOMServer->pUnkSite = NULL
	pTestCOMServer->pITestCOMServerTypeInfo = NULL
	pTestCOMServer->CallBack = NULL
	pTestCOMServer->UserName = NULL
	
	Dim pITypeLib As ITypeLib Ptr = NULL
	Dim hr As HRESULT = LoadRegTypeLib(@LIBID_TESTCOMSERVER_10, 1, 0, 0, @pITypeLib)
	
	If FAILED(hr) Then
		
		MessageBoxW(0, "LoadRegTypeLib", NULL, MB_OK)
		Return pTestCOMServer
		
	End If
	
	hr = pITypeLib->lpVtbl->GetTypeInfoOfGuid(pITypeLib, @IID_ITestComServer, @pTestCOMServer->pITestCOMServerTypeInfo)
	IUnknown_Release(pITypeLib)
	
	If FAILED(hr) Then
		
		MessageBoxW(0, "GetTypeInfoOfGuid", NULL, MB_OK)
		Return pTestCOMServer
		
	End If
	
	InterlockedIncrement(@GlobalObjectsCount)
	
	Return pTestCOMServer
	
End Function

Sub DestroyTestCOMServer( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)
	
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
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		
		If pTestCOMServer->pIUnknownOuter = NULL Then
			*ppv = CPtr(IUnknown Ptr, @pTestCOMServer->pVirtualTable)
		Else
			*ppv = CPtr(IUnknown Ptr, @pTestCOMServer->pDelegatingVirtualTable)
		End If
		
	End If
	
	If IsEqualIID(@IID_IDispatch, riid) Then
		*ppv = CPtr(IDispatch Ptr, @pTestCOMServer->pVirtualTable)
	End If
	
	If IsEqualIID(@IID_ITESTCOMSERVER, riid) Then
		*ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pVirtualTable)
	End If
	
	If IsEqualIID(@IID_IObjectWithSite, riid) Then
		*ppv = CPtr(IObjectWithSite Ptr, @pTestCOMServer->pIObjectWithSiteVirtualTable)
	End If
	
	If IsEqualIID(@IID_ISupportErrorInfo, riid) Then
		*ppv = CPtr(ISupportErrorInfo Ptr, @pTestCOMServer->pISupportErrorInfoVirtualTable)
	End If
	
	If *ppv = NULL Then
		
		/'
		Const Caption = "TestCOMServer->QueryInterface"
		
		If IsEqualIID(@IID_IProvideMultipleClassInfo, riid) Then
			' *ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pVirtualTable)
			MessageBoxW(NULL, "IProvideMultipleClassInfo", Caption, MB_OK)
		Else
			If IsEqualIID(@IID_IProvideClassInfo, riid) Then
				' *ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pVirtualTable)
				MessageBoxW(NULL, "IProvideClassInfo", Caption, MB_OK)
			Else
				If IsEqualIID(@IID_IDispatchEx, riid) Then
					' *ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pVirtualTable)
					MessageBoxW(NULL, "IDispatchEx", Caption, MB_OK)
				Else
					Dim pstrIID_IFace As WString Ptr = Any
					StringFromIID(riid, @pstrIID_IFace)
					MessageBoxW(NULL, pstrIID_IFace, "TestCOMServer->QueryInterface", MB_OK)
				End If
			End If
		End If
		'/
		Return E_NOINTERFACE
	End If
	
	TestCOMServerAddRef(pTestCOMServer)
	
	Return S_OK
	
End Function

Function TestCOMServerAddRef( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)As ULONG
	
	Return InterlockedIncrement(@pTestCOMServer->ReferenceCounter)
	
End Function

Function TestCOMServerRelease( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)As ULONG
	
	InterlockedDecrement(@pTestCOMServer->ReferenceCounter)
	
	If pTestCOMServer->ReferenceCounter = 0 Then
		
		DestroyTestCOMServer(pTestCOMServer)
		MessageBoxW(NULL, "Объект уничтожен", "TestCOMServer", MB_OK)
		
		InterlockedDecrement(@GlobalObjectsCount)
		
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
	
	If IsEqualIID(@IID_NULL, riid) = False Then
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
	
	*pResult = GlobalObjectsCount
	
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
		@IID_NULL, _
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
		@IID_NULL, _
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
