#include "ObjectsCounter.bi"

#include "windows.bi"
#include "win\ole2.bi"

Const MAX_CRITICAL_SECTION_SPIN_COUNT As DWORD = 4000

Type _ObjectsCounter
	Dim Counter As Integer
	Dim crSection As CRITICAL_SECTION
End Type

Function CreateObjectsCounter( _
	)As ObjectsCounter Ptr
	
	Dim pObjectsCounter As ObjectsCounter Ptr = CoTaskMemAlloc(SizeOf(ObjectsCounter))
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
	
	CoTaskMemFree(this)
	
End Sub

Function ObjectsCounterIncrement( _
		ByVal this As ObjectsCounter Ptr _
	)As Integer
	
	EnterCriticalSection(@this->crSection)
	Scope
		this->Counter += 1
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	Return this->Counter
	
End Function

Function ObjectsCounterDecrement( _
		ByVal this As ObjectsCounter Ptr _
	)As Integer
	
	EnterCriticalSection(@this->crSection)
	Scope
		this->Counter -= 1
	End Scope
	LeaveCriticalSection(@this->crSection)
	
	Return this->Counter
	
End Function

Function ObjectsCounterGetCounterValue( _
		ByVal this As ObjectsCounter Ptr _
	)As Integer
	
	Return this->Counter
	
End Function
