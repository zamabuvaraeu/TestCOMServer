#include "InitializeVirtualTables.bi"
#include "TestCOMServer.bi"
#include "TestCOMServerClassFactory.bi"

Sub InitializeVirtualTables()
	
	InitializeTestCOMServerVirtualTable()
	InitializeTestCOMServerClassFactoryVirtualTable()
	
End Sub
