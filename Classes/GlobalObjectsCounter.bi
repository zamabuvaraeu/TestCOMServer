#ifndef GLOBALOBJECTSCOUNTER_BI
#define GLOBALOBJECTSCOUNTER_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"

Type GlobalObjectsCounter
	Dim ObjectsCounter As Long
	Dim crSection As CRITICAL_SECTION
End Type

Declare Function CreateGlobalObjectsCounter( _
)As GlobalObjectsCounter Ptr

Declare Sub DestroyGlobalObjectsCounter( _
	ByVal pGlobalObjectsCounter As GlobalObjectsCounter Ptr _
)

Declare Function GlobalObjectsCounterIncrement( _
	ByVal pGlobalObjectsCounter As GlobalObjectsCounter Ptr _
)As Long

Declare Function GlobalObjectsCounterDecrement( _
	ByVal pGlobalObjectsCounter As GlobalObjectsCounter Ptr _
)As Long

#endif
