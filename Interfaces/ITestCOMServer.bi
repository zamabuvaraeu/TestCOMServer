#ifndef ITESTCOMSERVER_BI
#define ITESTCOMSERVER_BI

#ifndef unicode
#define unicode
#endif

#include "windows.bi"
#include "win\ole2.bi"

Const CLSIDS_IRCCLIENT = "{609FA596-1C4E-4BCB-A9D1-CA0DBBF3FC95}"

Const ProgID_IrcClient = "IRC.IrcClient"

Dim Shared IID_IIRCCLIENT As IID = Type(&h609fa596, &h1c4e, &h4bcb, _
	{&ha9, &hd1, &hca, &h0d, &hbb, &hf3, &hfc, &h95})

Dim Shared CLSID_IRCCLIENT As IID = Type(&h609fa596, &h1c4e, &h4bcb, _
	{&ha9, &hd1, &hca, &h0d, &hbb, &hf3, &hfc, &h95})

Type IIrcClient As IIrcClient_

Type LPIIRCCLIENT As IIrcClient Ptr

Type IIrcClientVirtualTable
	
	Dim InheritedTable As IDispatchVtbl
	
	Dim ShowMessageBox As Function( _
		ByVal This As IIrcClient Ptr, _
		ByVal Param As Long, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
End Type

Type IIrcClient_
	
	Dim pVirtualTable As IIrcClientVirtualTable Ptr
	
End Type

Const ShowMessageBoxParametersCount As Integer = 1
Const ShowMessageBoxDispatchIndex As DISPID = 8
Const ShowMessageBoxParamDispatchIndex As DISPID = 9

#endif
