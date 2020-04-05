#include "ClassFactory.bi"
#include "ObjectsCounter.bi"
#include "TestCOMServer.bi"
#include "TestCOMServerEventsConnectionPoint.bi"

Extern GlobalClassFactoryTestComServerVirtualTable As Const IClassFactoryVtbl
Extern GlobalClassFactoryConnectionPointVirtualTable As Const IClassFactoryVtbl

Type ClassFactoryVirtualTable
	Dim rclsid As Const CLSID Ptr
	Dim lpVtbl As Const IClassFactoryVtbl Ptr
End Type

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000

Common Shared PGlobalCounter As ObjectsCounter Ptr

Const MAX_SUPPORTED_CLASSES As Integer = 2
Dim Shared ClassFactoryVirtualTables(MAX_SUPPORTED_CLASSES - 1) As ClassFactoryVirtualTable = { _
	Type(@CLSID_TESTCOMSERVER_10, @GlobalClassFactoryTestComServerVirtualTable), _
	Type(@CLSID_TESTCOMSERVERCONNECTIONPOINT,  @GlobalClassFactoryConnectionPointVirtualTable) _
}

Sub ClassFactoryInitialize( _
		ByVal this As ClassFactory Ptr, _
		ByVal lpVtbl As Const IClassFactoryVtbl Ptr _
	)
	
	this->pVirtualTable = lpVtbl
	this->ReferenceCounter = 0
	InitializeCriticalSectionAndSpinCount( _
		@this->crSection, _
		MAX_CRITICAL_SECTION_SPIN_COUNT _
	)
	
End Sub

Sub ClassFactoryUnInitialize( _
		ByVal this As ClassFactory Ptr _
	)
	DeleteCriticalSection(@this->crSection)
End Sub

Function GetClassFactoryVirtualTable( _
		ByVal rclsid As REFCLSID _
	)As Const IClassFactoryVtbl Ptr
	
	For i As Integer = 0 To MAX_SUPPORTED_CLASSES - 1
		If IsEqualCLSID(ClassFactoryVirtualTables(i).rclsid, rclsid) Then
			Return ClassFactoryVirtualTables(i).lpVtbl
		End If
	Next
	
	Return NULL
	
End Function

Function CreateClassFactoryInterface( _
		ByVal rclsid As REFCLSID, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	Dim lpVtbl As Const IClassFactoryVtbl Ptr = GetClassFactoryVirtualTable(rclsid)
	If lpVtbl = NULL Then
		Return CLASS_E_CLASSNOTAVAILABLE
	End If
	
	Dim pFactory As ClassFactory Ptr = CoTaskMemAlloc(SizeOf(ClassFactory))
	If pFactory = NULL Then
		*ppvObject = NULL
		Return E_OUTOFMEMORY
	End If
	
	ClassFactoryInitialize(pFactory, lpVtbl)
	
	ObjectsCounterIncrement(PGlobalCounter)
	
	Dim hr As HRESULT = ClassFactoryQueryInterface(pFactory, riid, ppvObject)
	If FAILED(hr) Then
		DestroyClassFactory(pFactory)
		Return hr
	End If
	
	Return S_OK
	
End Function

Sub DestroyClassFactory( _
		ByVal this As ClassFactory Ptr _
	)
	
	ObjectsCounterDecrement(PGlobalCounter)
	ClassFactoryUnInitialize(this)
	CoTaskMemFree(this)
	
End Sub

Function ClassFactoryQueryInterface( _
		ByVal this As ClassFactory Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	If IsEqualIID(@IID_IClassFactory, riid) Then
		*ppv = @this->pVirtualTable
	Else
		If IsEqualIID(@IID_IUnknown, riid) Then
			*ppv = @this->pVirtualTable
		Else
			*ppv = NULL
			Return E_NOINTERFACE
		End If
	End If
	
	ClassFactoryAddRef(this)
	
	Return S_OK
	
End Function

Function ClassFactoryAddRef( _
		ByVal this As ClassFactory Ptr _
	)As ULONG
	
	EnterCriticalSection(@this->crSection)
	Scope
		this->ReferenceCounter += 1
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	Return 1
	
End Function

Function ClassFactoryRelease( _
		ByVal this As ClassFactory Ptr _
	)As ULONG
	
	EnterCriticalSection(@this->crSection)
	Scope
		this->ReferenceCounter -= 1
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	If this->ReferenceCounter = 0 Then
		DestroyClassFactory(this)
		Return 0
	End If
	
	Return 1
	
End Function

Function ClassFactoryCreateInstanceTestComServer( _
		ByVal this As ClassFactory Ptr, _
		ByVal pUnknownOuter As IUnknown Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	Dim pTestCOMServer As TestCOMServer Ptr = CreateTestCOMServer(pUnknownOuter)
	If pTestCOMServer = NULL Then
		Return E_OUTOFMEMORY
	End If
	
	Dim hr As HRESULT = TestCOMServerQueryInterface(pTestCOMServer, riid, ppv)
	If FAILED(hr) Then
		DestroyTestCOMServer(pTestCOMServer)
		Return hr
	End If
	
	Return S_OK
	
End Function

Function ClassFactoryCreateInstanceConnectionPoint( _
		ByVal this As ClassFactory Ptr, _
		ByVal pUnknownOuter As IUnknown Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	If pUnknownOuter <> NULL Then
		Return CLASS_E_NOAGGREGATION
	End If
	
	Dim pPoint As TestCOMServerEventsConnectionPoint Ptr = CreateTestCOMServerEventsConnectionPoint()
	If pPoint = NULL Then
		Return E_OUTOFMEMORY
	End If
	
	Dim hr As HRESULT = TestCOMServerEventsConnectionPointQueryInterface(pPoint, riid, ppv)
	If FAILED(hr) Then
		DestroyTestCOMServerEventsConnectionPoint(pPoint)
		Return hr
	End If
	
	Return S_OK
	
End Function
	
Function ClassFactoryLockServer( _
		ByVal this As ClassFactory Ptr, _
		ByVal fLock As BOOL _
	)As HRESULT
	
	' Dim Delta As Long = Any
	
	If fLock Then
		ObjectsCounterIncrement(PGlobalCounter)
	Else
		ObjectsCounterDecrement(PGlobalCounter)
	End If
	
	Return S_OK
	
End Function
