#include "TestCOMServerEventsConnectionPoint.bi"
#include "InvokeDispatchFunction.bi"
#include "ObjectsCounter.bi"

Extern GlobalTestCOMServerEventsVirtualTableConnectionPointVirtualTable As Const ITestCOMServerEventsConnectionPointVirtualTable
Extern GlobalTestCOMServerEventsDispatchConnectionPointVirtualTable As Const ITestCOMServerEventsConnectionPointVirtualTable

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000

Common Shared PGlobalCounter As ObjectsCounter Ptr

Sub TestCOMServerEventsConnectionPointInitialize( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal UseDispatch As Boolean _
	)
	If UseDispatch Then
		this->pVirtualTable = @GlobalTestCOMServerEventsDispatchConnectionPointVirtualTable
	Else
		this->pVirtualTable = @GlobalTestCOMServerEventsVirtualTableConnectionPointVirtualTable
	End If
	this->ReferenceCounter = 0
	this->pIContainer = NULL
	
	InitializeCriticalSectionAndSpinCount( _
		@this->crSection, _
		MAX_CRITICAL_SECTION_SPIN_COUNT _
	)
	For i As Integer = 0 To MAX_CLIENTS_SINK - 1
		this->ClientSinks(i).Cookie = i + 1
		this->ClientSinks(i).pDispatchClient = NULL
		this->ClientSinks(i).pVtblClient = NULL
	Next
End Sub

Sub TestCOMServerEventsConnectionPointUnInitialize( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr _
	)
	
	For i As Integer = 0 To MAX_CLIENTS_SINK - 1
		If this->ClientSinks(i).pDispatchClient <> NULL Then
			DITestCOMServerEvents_Release(this->ClientSinks(i).pDispatchClient)
		End If
		If this->ClientSinks(i).pVtblClient <> NULL Then
			ITestCOMServerEvents_Release(this->ClientSinks(i).pVtblClient)
		End If
	Next
	
	DeleteCriticalSection(@this->crSection)
	
End Sub

Function CreateTestCOMServerEventsDispatchConnectionPoint( _
	)As TestCOMServerEventsConnectionPoint Ptr
	
	Dim pPoint As TestCOMServerEventsConnectionPoint Ptr = CoTaskMemAlloc(SizeOf(TestCOMServerEventsConnectionPoint))
	If pPoint = NULL Then
		Return NULL
	End If
	
	TestCOMServerEventsConnectionPointInitialize(pPoint, True)
	
	ObjectsCounterIncrement(PGlobalCounter)
	
	Return pPoint
	
End Function

Function CreateTestCOMServerEventsVirtualTableConnectionPoint( _
	)As TestCOMServerEventsConnectionPoint Ptr
	
	Dim pPoint As TestCOMServerEventsConnectionPoint Ptr = CoTaskMemAlloc(SizeOf(TestCOMServerEventsConnectionPoint))
	If pPoint = NULL Then
		Return NULL
	End If
	
	TestCOMServerEventsConnectionPointInitialize(pPoint, False)
	
	ObjectsCounterIncrement(PGlobalCounter)
	
	Return pPoint

End Function

Sub DestroyTestCOMServerEventsConnectionPoint( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr _
	)
	
	ObjectsCounterDecrement(PGlobalCounter)
	TestCOMServerEventsConnectionPointUnInitialize(this)
	CoTaskMemFree(this)
	
End Sub

Function TestCOMServerEventsConnectionPointQueryInterface( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	If IsEqualIID(@IID_ITestCOMServerEventsConnectionPoint, riid) Then
		*ppv = @this->pVirtualTable
	Else
		If IsEqualIID(@IID_IConnectionPoint, riid) Then
			*ppv = @this->pVirtualTable
		Else
			If IsEqualIID(@IID_IUnknown, riid) Then
				*ppv = @this->pVirtualTable
			Else
				*ppv = NULL
				Return E_NOINTERFACE
			End If
		End If
	End If
	
	TestCOMServerEventsConnectionPointAddRef(this)
	
	Return S_OK
	
End Function

Function TestCOMServerEventsConnectionPointAddRef( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr _
	)As ULONG
	
	EnterCriticalSection(@this->crSection)
	Scope
		this->ReferenceCounter += 1
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	Return 1
	
End Function

Function TestCOMServerEventsConnectionPointRelease( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr _
	)As ULONG
	
	EnterCriticalSection(@this->crSection)
	Scope
		this->ReferenceCounter -= 1
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	If this->ReferenceCounter = 0 Then
		DestroyTestCOMServerEventsConnectionPoint(this)
		Return 0
	End If
	
	Return 1
	
End Function

Function TestCOMServerEventsConnectionPointGetConnectionInterface( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal pIID As IID Ptr _
	)As HRESULT
	
	*pIID = this->IID_IID
	
	Return S_OK
	
End Function

Function TestCOMServerEventsConnectionPointGetConnectionPointContainer( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal ppCPC As IConnectionPointContainer Ptr Ptr _
	)As HRESULT
	
	If this->pIContainer <> NULL Then
		IConnectionPointContainer_AddRef(this->pIContainer)
	End If
	*ppCPC = this->pIContainer
	
	Return S_OK
	
End Function

Function TestCOMServerEventsConnectionPointDispatchAdvise( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal pUnkSink As IUnknown Ptr, _
		ByVal pdwCookie As DWORD Ptr _
	)As HRESULT
	
	Dim pIEvents As DITestCOMServerEvents Ptr = Any
	
	Dim hr As HRESULT = IUnknown_QueryInterface(pUnkSink, @DIID_ITestCOMServerEvents, @pIEvents)
	If FAILED(hr) Then
		Return CONNECT_E_CANNOTCONNECT
	End If
	
	For i As Integer = 0 To MAX_CLIENTS_SINK - 1
		If this->ClientSinks(i).pDispatchClient = NULL Then
			this->ClientSinks(i).pDispatchClient = pIEvents
			*pdwCookie = Cast(DWORD, this->ClientSinks(i).Cookie)
			Return S_OK
		End If
	Next
	
	Return CONNECT_E_ADVISELIMIT
	
End Function

Function TestCOMServerEventsConnectionPointVirtualTableAdvise( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal pUnkSink As IUnknown Ptr, _
		ByVal pdwCookie As DWORD Ptr _
	)As HRESULT
	
	Dim pIEvents As ITestComServerEvents Ptr = Any
	Dim hr As HRESULT = IUnknown_QueryInterface(pUnkSink, @IID_ITestComServerEvents, @pIEvents)
	If FAILED(hr) Then
		Return CONNECT_E_CANNOTCONNECT
	End If
	
	For i As Integer = 0 To MAX_CLIENTS_SINK - 1
		If this->ClientSinks(i).pVtblClient = NULL Then
			this->ClientSinks(i).pVtblClient = pIEvents
			*pdwCookie = Cast(DWORD, this->ClientSinks(i).Cookie)
			Return S_OK
		End If
	Next
	
	Return CONNECT_E_ADVISELIMIT
	
End Function

Function TestCOMServerEventsConnectionPointUnadvise( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal dwCookie As DWORD _
	)As HRESULT
	
	For i As Integer = 0 To MAX_CLIENTS_SINK - 1
		If Cast(DWORD, this->ClientSinks(i).Cookie) = dwCookie Then
			
			If this->ClientSinks(i).pVtblClient <> NULL Then
				ITestCOMServerEvents_Release(this->ClientSinks(i).pVtblClient)
			End If
			this->ClientSinks(i).pVtblClient = NULL
			
			If this->ClientSinks(i).pDispatchClient <> NULL Then
				DITestCOMServerEvents_Release(this->ClientSinks(i).pDispatchClient)
			End If
			this->ClientSinks(i).pDispatchClient = NULL
			
			Return S_OK
		End If
	Next
	
	Return E_POINTER
	
End Function

Function TestCOMServerEventsConnectionPointEnumConnections( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal ppEnum As IEnumConnections Ptr Ptr _
	)As HRESULT
	*ppEnum = NULL
	MessageBoxW(NULL, "Перечислитель клиентов в точке подключения", "Не реализовано", MB_OK)
	Return E_FAIL
End Function

Function TestCOMServerEventsConnectionPointSetConnectionInterface( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal pIID As REFIID _
	)As HRESULT
	
	this->IID_IID = *pIID
	
	Return S_OK
	
End Function

Function TestCOMServerEventsConnectionPointFillConnectionPointContainer( _
		ByVal this As TestCOMServerEventsConnectionPoint ptr, _
		ByVal pCPC As IConnectionPointContainer Ptr _
	)As HRESULT
	
	' Не делаем AddRef, чтобы избежать циклической зависимости
	this->pIContainer = pCPC
	
	Return S_OK
	
End Function

Function TestCOMServerEventsConnectionPointInvokeDispatchOnStart( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	
	For i As Integer = 0 To MAX_CLIENTS_SINK - 1
		If this->ClientSinks(i).pDispatchClient <> NULL Then
			' Dim hr As HRESULT = InvokeDispatchFunctionByDispid( _
				' this->ClientSinks(i).pDispatchClient, _
				' Cast(DISPID, 1), _
				' @varParam(0), _
				' PARAMS_LENGTH, _
				' @VarResult _
			' )
			Dim hr As HRESULT = InvokeDispatchFunctionByDispid( _
				CPtr(IDispatch Ptr, this->ClientSinks(i).pDispatchClient), _
				Cast(DISPID, 1), _
				@Param, _
				1, _
				NULL _
			)
			If FAILED(hr) Then
				Return hr
			End If
		End If
	Next
	
	Return S_OK
	
End Function

Function TestCOMServerEventsConnectionPointInvokeVirtualTableOnStart( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	
	For i As Integer = 0 To MAX_CLIENTS_SINK - 1
		If this->ClientSinks(i).pVtblClient <> NULL Then
			Dim hr As HRESULT = ITestCOMServerEvents_OnStart(this->ClientSinks(i).pVtblClient, Param)
			If FAILED(hr) Then
				Return hr
			End If
		End If
	Next
	
	Return S_OK
	
End Function

Function TestCOMServerEventsConnectionPointInvokeVirtualTableOnEnd( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	
	Return S_OK
	
End Function

Function TestCOMServerEventsConnectionPointInvokeDispatchOnEnd( _
		ByVal this As TestCOMServerEventsConnectionPoint Ptr, _
		ByVal Param As VARIANT _
	)As HRESULT
	
	Return S_OK
	
End Function
