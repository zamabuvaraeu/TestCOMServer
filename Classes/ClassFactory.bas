#include "ClassFactory.bi"
#include "ObjectsCounter.bi"
#include "TestCOMServer.bi"

Type _ClassFactory
	
	Dim pVirtualTable As IClassFactoryVtbl Ptr
	Dim ReferenceCounter As ULONG
	Dim crSection As CRITICAL_SECTION
	
End Type

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000

Common Shared PGlobalCounter As ObjectsCounter Ptr
Dim Shared GlobalClassFactoryVirtualTable As IClassFactoryVtbl = Type( _
	@ClassFactoryQueryInterface, _
	@ClassFactoryAddRef, _
	@ClassFactoryRelease, _
	@ClassFactoryCreateInstance, _
	@ClassFactoryLockServer _
)

Function CreateClassFactory( _
	)As ClassFactory Ptr
	
	Dim pClassFactory As ClassFactory Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(ClassFactory) _
	)
	
	If pClassFactory = NULL Then
		Return NULL
	End If
	
	pClassFactory->pVirtualTable = @GlobalClassFactoryVirtualTable
	
	pClassFactory->ReferenceCounter = 0
	
	InitializeCriticalSectionAndSpinCount( _
		@pClassFactory->crSection, _
		MAX_CRITICAL_SECTION_SPIN_COUNT _
	)
	
	ObjectsCounterIncrement(PGlobalCounter)
	
	Return pClassFactory
	
End Function

Sub DestroyClassFactory( _
		ByVal this As ClassFactory Ptr _
	)
	
	ObjectsCounterDecrement(PGlobalCounter)
	
	DeleteCriticalSection(@this->crSection)
	
	HeapFree(GetProcessHeap(), 0, this)
	
End Sub

Function ClassFactoryQueryInterface( _
		ByVal this As ClassFactory Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = @this->pVirtualTable
	End If
	
	If IsEqualIID(@IID_IClassFactory, riid) Then
		*ppv = @this->pVirtualTable
	End If
	
	If *ppv = NULL Then
		Return E_NOINTERFACE
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
	
	Return this->ReferenceCounter
	
End Function

Function ClassFactoryRelease( _
		ByVal this As ClassFactory Ptr _
	)As ULONG
	
	EnterCriticalSection(@this->crSection)
	Scope
		
		this->ReferenceCounter -= 1
		
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	If this->ReferenceCounter <> 0 Then
		Return this->ReferenceCounter
	End If
	
	DestroyClassFactory(this)
	
	Return 0
	
End Function

Function ClassFactoryCreateInstance( _
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
	End If
	
	Return hr
	
End Function
	
Function ClassFactoryLockServer( _
		ByVal this As ClassFactory Ptr, _
		ByVal fLock As BOOL _
	)As HRESULT
	
	Dim Delta As Long = Any
	
	If fLock Then
		ObjectsCounterIncrement(PGlobalCounter)
	Else
		ObjectsCounterDecrement(PGlobalCounter)
	End If
	
	Return S_OK
	
End Function
