#ifndef INVOKEDISPATCHFUNCTION_BI
#define INVOKEDISPATCHFUNCTION_BI

#include "windows.bi"
#include "win\ole2.bi"

Declare Function InvokeDispatchFunctionByName( _
	ByVal lpIDispatch As IDispatch Ptr, _
	ByVal wszFunctionName As WString Ptr, _
	ByVal varParams As VARIANT Ptr, _
	ByVal ParamsLength As Integer, _
	ByVal pVarResult As VARIANT Ptr _
)As HRESULT

Declare Function InvokeDispatchFunctionByDispid( _
	ByVal lpIDispatch As IDispatch Ptr, _
	ByVal diid As DISPID, _
	ByVal varParams As VARIANT Ptr, _
	ByVal ParamsLength As Integer, _
	ByVal pVarResult As VARIANT Ptr _
)As HRESULT

#endif
