#ifndef ITESTCOMSERVER_BI
#define ITESTCOMSERVER_BI

#include "windows.bi"
#include "win\ocidl.bi"

' {9AC86F9F-4807-40F6-BBE0-1D7E905568AB}
Dim Shared IID_ITESTCOMSERVER As IID = Type(&h9ac86f9f, &h4807, &h40f6, _
	{&hbb, &he0, &h1d, &h7e, &h90, &h55, &h68, &hab} _
)

Type ITestCOMServer As ITestCOMServer_

Type LPITESTCOMSERVER As ITestCOMServer Ptr

Type ITestCOMServerVirtualTable
	
	Dim InheritedTable As IDispatchVtbl
	
	Dim ShowMessageBox As Function( _
		ByVal pITestCOMServer As ITestCOMServer Ptr, _
		ByVal Param As Long, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
End Type

Type ITestCOMServer_
	Dim pVirtualTable As ITestCOMServerVirtualTable Ptr
End Type

#endif
