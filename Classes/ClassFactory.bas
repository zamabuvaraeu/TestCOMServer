#include "ClassFactory.bi"
#include "TestCOMServer.bi"

Common Shared GlobalObjectsCount As Long
Dim Shared GlobalClassFactoryVirtualTable As IClassFactoryVtbl

Sub InitializeClassFactoryVirtualTable()
	GlobalClassFactoryVirtualTable.QueryInterface = CPtr(Any Ptr, @ClassFactoryQueryInterface)
	GlobalClassFactoryVirtualTable.AddRef = CPtr(Any Ptr, @ClassFactoryAddRef)
	GlobalClassFactoryVirtualTable.Release = CPtr(Any Ptr, @ClassFactoryRelease)
	GlobalClassFactoryVirtualTable.CreateInstance = CPtr(Any Ptr, @ClassFactoryCreateInstance)
	GlobalClassFactoryVirtualTable.LockServer = CPtr(Any Ptr, @ClassFactoryLockServer)
End Sub

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
	
	InterlockedIncrement(@GlobalObjectsCount)
	
	Return pClassFactory
	
End Function

Sub DestroyClassFactory( _
		ByVal pClassFactory As ClassFactory Ptr _
	)
	
End Sub

Function ClassFactoryQueryInterface( _
		ByVal pClassFactory As ClassFactory Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, @pClassFactory->pVirtualTable)
	End If
	
	If IsEqualIID(@IID_IClassFactory, riid) Then
		*ppv = CPtr(IClassFactory Ptr, @pClassFactory->pVirtualTable)
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
	
	Return InterlockedIncrement(@pClassFactory->ReferenceCounter)
	
End Function

Function ClassFactoryRelease( _
		ByVal pClassFactory As ClassFactory Ptr _
	)As ULONG
	
	If InterlockedDecrement(@pClassFactory->ReferenceCounter) = 0 Then
		
		DestroyClassFactory(pClassFactory)
		
		InterlockedDecrement(@GlobalObjectsCount)
		
		Return 0
		
	End If
	
	Return pClassFactory->ReferenceCounter
	
End Function

Function ClassFactoryCreateInstance( _
		ByVal pClassFactory As ClassFactory Ptr, _
		ByVal pUnknownOuter As IUnknown Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	' Агрегирование не поддерживается
	If pUnknownOuter <> NULL Then
		Return CLASS_E_NOAGGREGATION
	End If
	
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
	
	If fLock Then
		InterlockedIncrement(@GlobalObjectsCount) 
	Else
		InterlockedDecrement(@GlobalObjectsCount)
	End If
	
	Return S_OK
	
End Function
