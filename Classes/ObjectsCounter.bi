#ifndef OBJECTSCOUNTER_BI
#define OBJECTSCOUNTER_BI

Type ObjectsCounter As _ObjectsCounter

Type PObjectsCounter As ObjectsCounter Ptr

Declare Function CreateObjectsCounter( _
)As ObjectsCounter Ptr

Declare Sub DestroyObjectsCounter( _
	ByVal this As ObjectsCounter Ptr _
)

Declare Function ObjectsCounterIncrement( _
	ByVal this As ObjectsCounter Ptr _
)As Integer

Declare Function ObjectsCounterDecrement( _
	ByVal this As ObjectsCounter Ptr _
)As Integer

Declare Function ObjectsCounterGetCounterValue( _
	ByVal this As ObjectsCounter Ptr _
)As Integer

#endif
