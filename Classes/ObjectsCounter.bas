#include "ObjectsCounter.bi"

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000

Type _ObjectsCounter
	Dim Counter As Integer
	Dim crSection As CRITICAL_SECTION
End Type

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
		ByVal this As ObjectsCounter Ptr _
	)
	
	DeleteCriticalSection(@this->crSection)
	
	HeapFree(GetProcessHeap(), 0, this)
	
End Sub

Function ObjectsCounterIncrement( _
		ByVal this As ObjectsCounter Ptr _
	)As Integer
	
	EnterCriticalSection(@this->crSection)
	
	this->Counter += 1
	
	LeaveCriticalSection(@this->crSection)
	
	Return this->Counter
	
End Function

Function ObjectsCounterDecrement( _
		ByVal this As ObjectsCounter Ptr _
	)As Integer
	
	EnterCriticalSection(@this->crSection)
	
	this->Counter -= 1
	
	LeaveCriticalSection(@this->crSection)
	
	Return this->Counter
	
End Function

Function ObjectsCounterGetCounterValue( _
		ByVal this As ObjectsCounter Ptr _
	)As Integer
	
	Return this->Counter
	
End Function
