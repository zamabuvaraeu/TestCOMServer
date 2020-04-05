#include "ClassFactory.bi"
#include "ObjectsCounter.bi"
#include "TestCOMServer.bi"
#include "TestCOMServerEventsConnectionPoint.bi"

Extern GlobalClassFactoryVirtualTable As Const IClassFactoryVtbl

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000

Common Shared PGlobalCounter As ObjectsCounter Ptr

Sub ClassFactoryInitialize( _
		ByVal this As ClassFactory Ptr, _
		ByVal rclsid As REFCLSID _
	)
	
	this->pVirtualTable = @GlobalClassFactoryVirtualTable
	this->ReferenceCounter = 0
	InitializeCriticalSectionAndSpinCount( _
		@this->crSection, _
		MAX_CRITICAL_SECTION_SPIN_COUNT _
	)
	memcpy(@this->clsid, rclsid, SizeOf(CLSID))
	
End Sub

Sub ClassFactoryUnInitialize( _
		ByVal this As ClassFactory Ptr _
	)
	DeleteCriticalSection(@this->crSection)
End Sub

Function CreateClassFactoryInterface( _
		ByVal rclsid As REFCLSID, _
		ByVal riid As REFIID, _
		ByVal ppvObject As Any Ptr Ptr _
	)As HRESULT
	
	If IsEqualCLSID(@CLSID_TESTCOMSERVER_10, rclsid) = 0 Then
		Return CLASS_E_CLASSNOTAVAILABLE
	Else
		If IsEqualCLSID(@CLSID_TESTCOMSERVERCONNECTIONPOINT, rclsid) = 0 Then
			Return CLASS_E_CLASSNOTAVAILABLE
		End If
	End If
	
	Dim pFactory As ClassFactory Ptr = CoTaskMemAlloc(SizeOf(ClassFactory))
	If pFactory = NULL Then
		*ppvObject = NULL
		Return E_OUTOFMEMORY
	End If
	
	ClassFactoryInitialize(pFactory, rclsid)
	
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

Function ClassFactoryCreateInstance( _
		ByVal this As ClassFactory Ptr, _
		ByVal pUnknownOuter As IUnknown Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	If IsEqualCLSID(@CLSID_TESTCOMSERVER_10, @this->clsid) Then
		Dim pTestCOMServer As TestCOMServer Ptr = CreateTestCOMServer(pUnknownOuter)
		If pTestCOMServer = NULL Then
			Return E_OUTOFMEMORY
		End If
		
		Dim hr As HRESULT = TestCOMServerQueryInterface(pTestCOMServer, riid, ppv)
		If FAILED(hr) Then
			DestroyTestCOMServer(pTestCOMServer)
			Return hr
		End If
	End If
	
	If IsEqualCLSID(@CLSID_TESTCOMSERVERCONNECTIONPOINT, @this->clsid) Then
		Dim pPoint As TestCOMServerEventsConnectionPoint Ptr = CreateTestCOMServerEventsConnectionPoint(pUnknownOuter)
		If pPoint = NULL Then
			Return E_OUTOFMEMORY
		End If
		
		Dim hr As HRESULT = TestCOMServerEventsConnectionPointQueryInterface(pPoint, riid, ppv)
		If FAILED(hr) Then
			DestroyTestCOMServerEventsConnectionPoint(pPoint)
			Return hr
		End If
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
