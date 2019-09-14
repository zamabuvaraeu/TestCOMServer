#include "TestCOMServerClassFactory.bi"
#include "TestCOMServer.bi"

Common Shared GlobalObjectsCount As Long
Dim Shared GlobalTestCOMServerClassFactoryVirtualTable As IClassFactoryVtbl

Sub InitializeTestCOMServerClassFactoryVirtualTable()
	GlobalTestCOMServerClassFactoryVirtualTable.QueryInterface = CPtr(Any Ptr, @TestCOMServerClassFactoryQueryInterface)
	GlobalTestCOMServerClassFactoryVirtualTable.AddRef = CPtr(Any Ptr, @TestCOMServerClassFactoryAddRef)
	GlobalTestCOMServerClassFactoryVirtualTable.Release = CPtr(Any Ptr, @TestCOMServerClassFactoryRelease)
	GlobalTestCOMServerClassFactoryVirtualTable.CreateInstance = CPtr(Any Ptr, @TestCOMServerClassFactoryCreateInstance)
	GlobalTestCOMServerClassFactoryVirtualTable.LockServer = CPtr(Any Ptr, @TestCOMServerClassFactoryLockServer)
End Sub

Function CreateTestCOMServerClassFactory( _
	)As TestCOMServerClassFactory Ptr
	
	Dim pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(TestCOMServerClassFactory) _
	)
	
	If pTestCOMServerClassFactory = NULL Then
		Return NULL
	End If
	
	pTestCOMServerClassFactory->pVirtualTable = @GlobalTestCOMServerClassFactoryVirtualTable
	pTestCOMServerClassFactory->ReferenceCounter = 0
	
	Return pTestCOMServerClassFactory
	
End Function

Sub DestroyTestCOMServerClassFactory( _
		ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr _
	)
	
End Sub

Function TestCOMServerClassFactoryQueryInterface( _
		ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, @pTestCOMServerClassFactory->pVirtualTable)
	End If
	
	If InlineIsEqualGUID(@IID_IClassFactory, riid) Then
		*ppv = CPtr(IClassFactory Ptr, @pTestCOMServerClassFactory->pVirtualTable)
	End If
	
	If *ppv = NULL Then
		Return E_NOINTERFACE
	End If
	
	TestCOMServerClassFactoryAddRef(pTestCOMServerClassFactory)
	
	Return S_OK
	
End Function

Function TestCOMServerClassFactoryAddRef( _
		ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr _
	)As ULONG
	
	Return InterlockedIncrement(@pTestCOMServerClassFactory->ReferenceCounter)
	
End Function

Function TestCOMServerClassFactoryRelease( _
		ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr _
	)As ULONG
	
	If InterlockedDecrement(@pTestCOMServerClassFactory->ReferenceCounter) = 0 Then
		
		DestroyTestCOMServerClassFactory(pTestCOMServerClassFactory)
		Return 0
		
	End If
	
	Return pTestCOMServerClassFactory->ReferenceCounter
	
End Function

Function TestCOMServerClassFactoryCreateInstance( _
		ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr, _
		ByVal pUnknownOuter As IUnknown Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	' Агрегирование не поддерживается
	If pUnknownOuter <> NULL Then
		Return CLASS_E_NOAGGREGATION
	End If
	
	Dim pTestCOMServer As TestCOMServer Ptr = CreateTestCOMServer()
	
	If pTestCOMServer = NULL Then
		Return E_OUTOFMEMORY
	End If
	
	Dim hr As HRESULT = TestCOMServerQueryInterface(pTestCOMServer, riid, ppv)
	
	If FAILED(hr) Then
		DestroyTestCOMServer(pTestCOMServer)
	End If
	
	Return hr
	
End Function
	
Function TestCOMServerClassFactoryLockServer( _
		ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr, _
		ByVal fLock As BOOL _
	)As HRESULT
	
	If fLock Then
		InterlockedIncrement(@GlobalObjectsCount) 
	Else
		InterlockedDecrement(@GlobalObjectsCount)
	End If
	
	Return S_OK
	
End Function
