#include "InvokeDispatchFunction.bi"

Function InvokeDispatchFunctionByName( _
		ByVal lpIDispatch As IDispatch Ptr, _
		ByVal wszFunctionName As WString Ptr, _
		ByVal varParams As VARIANT Ptr, _
		ByVal ParamsLength As Integer, _
		ByVal pVarResult As VARIANT Ptr _
	)As HRESULT
	
	Const NAMES_LENGTH As UINT = 1
	
	Dim rgszNames(NAMES_LENGTH - 1) As WString Ptr = {wszFunctionName}
	Dim rgDispIds(NAMES_LENGTH - 1) As DISPID = Any
	
	Dim hr As HRESULT = IDispatch_GetIDsOfNames( _
		lpIDispatch, _
		@IID_NULL, _
		@rgszNames(0), _
		NAMES_LENGTH, _
		GetUserDefaultLCID(), _
		@rgDispIds(0) _
	)
	If FAILED(hr) Then
		Return hr
	End If
	
	Return InvokeDispatchFunctionByDispid(lpIDispatch, rgDispIds(0), varParams, ParamsLength, pVarResult)
	
End Function

Function InvokeDispatchFunctionByDispid( _
		ByVal lpIDispatch As IDispatch Ptr, _
		ByVal diid As DISPID, _
		ByVal varParams As VARIANT Ptr, _
		ByVal ParamsLength As Integer, _
		ByVal pVarResult As VARIANT Ptr _
	)As HRESULT
	
	Dim Params(0) As DISPPARAMS = Any
	Params(0).rgvarg = varParams
	Params(0).rgdispidNamedArgs = NULL
	Params(0).cArgs = ParamsLength
	Params(0).cNamedArgs = 0
	
	Dim ExcepInfo As EXCEPINFO = Any
	Dim uArgErr As UINT = Any
	Dim hr As HRESULT = IDispatch_Invoke( _
		lpIDispatch, _
		diid, _
		@IID_NULL, _
		GetUserDefaultLCID(), _
		DISPATCH_METHOD, _
		@Params(0), _
		pVarResult, _
		@ExcepInfo, _
		@uArgErr _
	)
	
	Return hr
	
End Function
