#include "GlobalObjectsCounter.bi"

Function CreateGlobalObjectsCounter( _
	)As GlobalObjectsCounter Ptr
	
	Dim pGlobalObjectsCounter As GlobalObjectsCounter Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(GlobalObjectsCounter) _
	)
	
	If pGlobalObjectsCounter = NULL Then
		Return NULL
	End If
	
	pGlobalObjectsCounter->Counter = 0
	InitializeCriticalSection(@pGlobalObjectsCounter->crSection)
	
	Return pGlobalObjectsCounter
	
End Function

Sub DestroyGlobalObjectsCounter( _
		ByVal pGlobalObjectsCounter As GlobalObjectsCounter Ptr _
	)
	
	DeleteCriticalSection(@pGlobalObjectsCounter->crSection)
	
	HeapFree(GetProcessHeap(), 0, pGlobalObjectsCounter)
	
End Sub

Function GlobalObjectsCounterIncrement( _
		ByVal pGlobalObjectsCounter As GlobalObjectsCounter Ptr _
	)As Integer
	
	EnterCriticalSection(@pGlobalObjectsCounter->crSection)
	
	pGlobalObjectsCounter->Counter += 1
	
	LeaveCriticalSection(@pGlobalObjectsCounter->crSection)
	
	Return pGlobalObjectsCounter->Counter
	
End Function

Function GlobalObjectsCounterDecrement( _
		ByVal pGlobalObjectsCounter As GlobalObjectsCounter Ptr _
	)As Integer
	
	EnterCriticalSection(@pGlobalObjectsCounter->crSection)
	
	pGlobalObjectsCounter->Counter -= 1
	
	LeaveCriticalSection(@pGlobalObjectsCounter->crSection)
	
	Return pGlobalObjectsCounter->Counter
	
End Function
