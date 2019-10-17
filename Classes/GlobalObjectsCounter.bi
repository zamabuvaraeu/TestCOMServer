#ifndef GLOBALOBJECTSCOUNTER_BI
#define GLOBALOBJECTSCOUNTER_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"

Type ObjectsCounter
	Dim Counter As Integer
	Dim crSection As CRITICAL_SECTION
End Type

Declare Function CreateObjectsCounter( _
)As ObjectsCounter Ptr

Declare Sub DestroyObjectsCounter( _
	ByVal pObjectsCounter As ObjectsCounter Ptr _
)

Declare Function ObjectsCounterIncrement( _
	ByVal pObjectsCounter As ObjectsCounter Ptr _
)As Integer

Declare Function ObjectsCounterDecrement( _
	ByVal pObjectsCounter As ObjectsCounter Ptr _
)As Integer

#endif
