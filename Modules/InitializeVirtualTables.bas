#include "InitializeVirtualTables.bi"
#include "TestCOMServer.bi"
#include "ClassFactory.bi"

Sub InitializeVirtualTables()
	
	InitializeTestCOMServerVirtualTable()
	InitializeClassFactoryVirtualTable()
	
End Sub
