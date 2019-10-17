#include "ObjectsCounter.bi"

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000

Function CreateObjectsCounter( _
	)As ObjectsCounter Ptr
	
	Dim pObjectsCounter As ObjectsCounter Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(ObjectsCounter) _
	)
	
	If pObjectsCounter = NULL Then
		Return NULL
	End If
	
	pObjectsCounter->Counter = 0
	
	InitializeCriticalSectionAndSpinCount( _
		@pObjectsCounter->crSection, _
		MAX_CRITICAL_SECTION_SPIN_COUNT _
	)
	
	Return pObjectsCounter
	
End Function

Sub DestroyObjectsCounter( _
		ByVal pObjectsCounter As ObjectsCounter Ptr _
	)
	
	DeleteCriticalSection(@pObjectsCounter->crSection)
	
	HeapFree(GetProcessHeap(), 0, pObjectsCounter)
	
End Sub

Function ObjectsCounterIncrement( _
		ByVal pObjectsCounter As ObjectsCounter Ptr _
	)As Integer
	
	EnterCriticalSection(@pObjectsCounter->crSection)
	
	pObjectsCounter->Counter += 1
	
	LeaveCriticalSection(@pObjectsCounter->crSection)
	
	Return pObjectsCounter->Counter
	
End Function

Function ObjectsCounterDecrement( _
		ByVal pObjectsCounter As ObjectsCounter Ptr _
	)As Integer
	
	EnterCriticalSection(@pObjectsCounter->crSection)
	
	pObjectsCounter->Counter -= 1
	
	LeaveCriticalSection(@pObjectsCounter->crSection)
	
	Return pObjectsCounter->Counter
	
End Function
