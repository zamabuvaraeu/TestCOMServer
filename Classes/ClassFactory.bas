#include "ClassFactory.bi"
#include "ObjectsCounter.bi"
#include "TestCOMServer.bi"

Extern IID_IUnknown_WithoutMinGW As Const IID
Extern IID_IClassFactory_WithoutMinGW As Const IID

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
		ByVal pClassFactory As ClassFactory Ptr _
	)
	
	ObjectsCounterDecrement(PGlobalCounter)
	
	DeleteCriticalSection(@pClassFactory->crSection)
	
	HeapFree(GetProcessHeap(), 0, pClassFactory)
	
End Sub

Function ClassFactoryQueryInterface( _
		ByVal pClassFactory As ClassFactory Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	If IsEqualIID(@IID_IUnknown_WithoutMinGW, riid) Then
		*ppv = @pClassFactory->pVirtualTable
	End If
	
	If IsEqualIID(@IID_IClassFactory_WithoutMinGW, riid) Then
		*ppv = @pClassFactory->pVirtualTable
	End If
	
	If *ppv = NULL Then
		Return E_NOINTERFACE
	End If
	
	ClassFactoryAddRef(pClassFactory)
	
	Return S_OK
	
End Function

Function ClassFactoryAddRef( _
		ByVal pClassFactory As ClassFactory Ptr _
	)As ULONG
	
	EnterCriticalSection(@pClassFactory->crSection)
	Scope
		
		pClassFactory->ReferenceCounter += 1
		
	End Scope
	LeaveCriticalSection(@pClassFactory->crSection)
	
	Return pClassFactory->ReferenceCounter
	
End Function

Function ClassFactoryRelease( _
		ByVal pClassFactory As ClassFactory Ptr _
	)As ULONG
	
	EnterCriticalSection(@pClassFactory->crSection)
	Scope
		
		pClassFactory->ReferenceCounter -= 1
		
	End Scope
	LeaveCriticalSection(@pClassFactory->crSection)
	
	If pClassFactory->ReferenceCounter <> 0 Then
		Return pClassFactory->ReferenceCounter
	End If
	
	DestroyClassFactory(pClassFactory)
	
	Return 0
	
End Function

Function ClassFactoryCreateInstance( _
		ByVal pClassFactory As ClassFactory Ptr, _
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
		ByVal pClassFactory As ClassFactory Ptr, _
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
