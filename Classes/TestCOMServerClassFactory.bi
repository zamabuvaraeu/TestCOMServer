#ifndef TESTCOMSERVERCLASSFACTORY_BI
#define TESTCOMSERVERCLASSFACTORY_BI

#include "windows.bi"
#include "win\objbase.bi"

Type TestCOMServerClassFactory
	
	Dim pVirtualTable As IClassFactoryVtbl Ptr
	Dim ReferenceCounter As ULONG
	
End Type

Declare Sub InitializeTestCOMServerClassFactoryVirtualTable()

Declare Function CreateTestCOMServerClassFactory( _
)As TestCOMServerClassFactory Ptr

Declare Sub DestroyTestCOMServerClassFactory( _
	ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr _
)

Declare Function TestCOMServerClassFactoryQueryInterface( _
	ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerClassFactoryAddRef( _
	ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr _
)As ULONG

Declare Function TestCOMServerClassFactoryRelease( _
	ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr _
)As ULONG

Declare Function TestCOMServerClassFactoryCreateInstance( _
	ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr, _
	ByVal pUnknownOuter As IUnknown Ptr, _
	ByVal riid As REFIID, _
	ByVal ppv As Any Ptr Ptr _
)As HRESULT

Declare Function TestCOMServerClassFactoryLockServer( _
	ByVal pTestCOMServerClassFactory As TestCOMServerClassFactory Ptr, _
	ByVal fLock As BOOL _
)As HRESULT

#endif
