#include "TestCOMServer.bi"

Common Shared GlobalObjectsCount As Long
Dim Shared GlobalTestCOMServerVirtualTable As ITestCOMServerVirtualTable

Sub InitializeTestCOMServerVirtualTable()
	GlobalTestCOMServerVirtualTable.InheritedTable.QueryInterface = CPtr(Any Ptr, @TestCOMServerQueryInterface)
	GlobalTestCOMServerVirtualTable.InheritedTable.AddRef = CPtr(Any Ptr, @TestCOMServerAddRef)
	GlobalTestCOMServerVirtualTable.InheritedTable.Release = CPtr(Any Ptr, @TestCOMServerRelease)
	GlobalTestCOMServerVirtualTable.InheritedTable.GetTypeInfoCount = CPtr(Any Ptr, @TestCOMServerGetTypeInfoCount)
	GlobalTestCOMServerVirtualTable.InheritedTable.GetTypeInfo = CPtr(Any Ptr, @TestCOMServerGetTypeInfo)
	GlobalTestCOMServerVirtualTable.InheritedTable.GetIDsOfNames = CPtr(Any Ptr, @TestCOMServerGetIDsOfNames)
	GlobalTestCOMServerVirtualTable.InheritedTable.Invoke = CPtr(Any Ptr, @TestCOMServerInvoke)
	GlobalTestCOMServerVirtualTable.ShowMessageBox = CPtr(Any Ptr, @TestCOMServerShowMessageBox)
End sub

Function CreateTestCOMServer( _
	)As TestCOMServer Ptr
	
	Dim pTestCOMServer As TestCOMServer Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(TestCOMServer) _
	)
	
	If pTestCOMServer = NULL Then
		Return NULL
	End If
	
	pTestCOMServer->pVirtualTable = @GlobalTestCOMServerVirtualTable
	pTestCOMServer->ReferenceCounter = 0
	
	Return pTestCOMServer
	
End Function

Sub DestroyTestCOMServer( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)
	
	HeapFree( _
		GetProcessHeap(), _
		0, _
		pTestCOMServer _
	)
	
End Sub

Function TestCOMServerQueryInterface( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	*ppv = NULL
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, @pTestCOMServer->pVirtualTable)
		MessageBoxW(NULL, "IID_IUnknown", "TestCOMServerQueryInterface", MB_OK)
	End If
	
	If IsEqualIID(@IID_IDispatch, riid) Then
		*ppv = CPtr(IDispatch Ptr, @pTestCOMServer->pVirtualTable)
		MessageBoxW(NULL, "IID_IDispatch", "TestCOMServerQueryInterface", MB_OK)
	End If
	
	If IsEqualIID(@IID_ITESTCOMSERVER, riid) Then
		*ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pVirtualTable)
		MessageBoxW(NULL, "IID_ITESTCOMSERVER", "TestCOMServerQueryInterface", MB_OK)
	End If
	
	If *ppv = NULL Then
		Dim pstrIID_IFace As WString Ptr = Any
		StringFromIID(riid, @pstrIID_IFace)
		MessageBoxW(NULL, pstrIID_IFace, "TestCOMServerQueryInterface", MB_OK)
		Return E_NOINTERFACE
	End If
	
	TestCOMServerAddRef(pTestCOMServer)
	
	Return S_OK
	
End Function

Function TestCOMServerAddRef( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)As ULONG
	
	' InterlockedIncrement(@GlobalObjectsCount)
	Return InterlockedIncrement(@pTestCOMServer->ReferenceCounter)
	
End Function

Function TestCOMServerRelease( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)As ULONG
	
	InterlockedDecrement(@pTestCOMServer->ReferenceCounter)
	
	If pTestCOMServer->ReferenceCounter = 0 Then
		
		DestroyTestCOMServer(pTestCOMServer)
		' InterlockedDecrement(@GlobalObjectsCount)
		Return 0
		
	End If
	
	Return pTestCOMServer->ReferenceCounter
	
End Function

Function TestCOMServerGetTypeInfoCount( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal pctinfo As UINT Ptr _
	)As HRESULT
	
	*pctinfo = 0
	
	Return S_OK
	
End Function

Function TestCOMServerGetTypeInfo( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal iTInfo As UINT, _
		ByVal lcid As LCID, _
		ByVal ppTInfo As ITypeInfo Ptr Ptr _
	)As HRESULT
	
	*ppTInfo = NULL
	
	If iTInfo <> 0 Then
		Return DISP_E_BADINDEX
	End If
	
	Return S_OK
	
End Function

Function TestCOMServerGetIDsOfNames( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal riid As Const IID Const ptr, _
		ByVal rgszNames As LPOLESTR Ptr, _
		ByVal cNames As UINT, _
		ByVal lcid As LCID, _
		ByVal rgDispId As DISPID Ptr _
	)As HRESULT
	
	Dim SuccessFlag As Boolean = True
	
	If lstrcmpiW(rgszNames[0], "ShowMessageBox") = 0 Then
		rgDispId[0] = ShowMessageBoxDispatchIndex
		
		For i As Integer = 1 To cNames - 1
			
			If lstrcmpiW(rgszNames[i], "Param") = 0 Then
				rgDispId[i] = ShowMessageBoxParamDispatchIndex
			Else
				SuccessFlag = False
				rgDispId[i] = DISPID_UNKNOWN
			End If
		Next
	Else
		SuccessFlag = False
		rgDispId[0] = DISPID_UNKNOWN
	End If
	
	If SuccessFlag = False Then
		Return DISP_E_UNKNOWNNAME
	End If
	
	Return S_OK
	
End Function

Function TestCOMServerInvoke( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal dispIdMember As DISPID, _
		ByVal riid As Const IID Const Ptr, _
		ByVal lcid As LCID, _
		ByVal wFlags As WORD, _
		ByVal pDispParams As DISPPARAMS Ptr, _
		ByVal pVarResult As VARIANT Ptr, _
		ByVal pExcepInfo As EXCEPINFO Ptr, _
		ByVal puArgErr As UINT Ptr _
	)As HRESULT
	
	If IsEqualIID(@IID_NULL, riid) = False Then
		Return DISP_E_UNKNOWNINTERFACE
	End If
	
	Select Case dispIdMember
		
		Case ShowMessageBoxDispatchIndex
			
			If pDispParams->cArgs + pDispParams->cNamedArgs <> ShowMessageBoxParametersCount Then
				Return DISP_E_BADPARAMCOUNT
			End If
			
			Dim lVal As Long = Any
			
			Dim hr As HRESULT = TestCOMServerShowMessageBox( _
				pTestCOMServer, _
				pDispParams->rgvarg[0].lVal, _
				@lVal _
			)
			
			pVarResult->vt = VT_I4
			pVarResult->lVal = lVal
			
			Return hr
			
	End Select
	
	Return DISP_E_MEMBERNOTFOUND
	
End Function

Function TestCOMServerShowMessageBox( _
		ByVal pTestCOMServer As TestCOMServer Ptr, _
		ByVal Param As Long, _
		ByVal pResult As Long Ptr _
	)As HRESULT
	
	If pResult = 0 Then
		Return E_INVALIDARG
	End If
	
	Select Case Param
		
		Case 0
			MessageBoxW(0, "Это нулевое сообщение", "TestCOMServer COM Library", MB_OK)
			*pResult = 0
			
		Case 1
			MessageBoxW(0, "Это первое сообщение", "TestCOMServer COM Library", MB_OK)
			*pResult = 1
			
		Case Else
			MessageBoxW(0, "Это любое сообщение", "TestCOMServer COM Library", MB_OK)
			*pResult = 2
			
	End Select
	
	Return S_OK
	
End Function
