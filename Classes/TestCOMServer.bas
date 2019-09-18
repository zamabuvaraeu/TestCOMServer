#include "TestCOMServer.bi"

#define TestCOMServer_OffsetOf_ITestCOMServer(pTestCOMServerTestCOMServer) CPtr(TestCOMServer Ptr, (pTestCOMServerTestCOMServer))
#define TestCOMServer_OffsetOf_IObjectWithSite(pTestCOMServerObjectWithSite) CPtr(TestCOMServer Ptr, (CUInt(pTestCOMServerObjectWithSite) - SizeOf(IObjectWithSiteVtbl Ptr)))

Common Shared GlobalObjectsCount As Long
Dim Shared GlobalTestCOMServerVirtualTable As ITestCOMServerVirtualTable
Dim Shared GlobalTestCOMServerIObjectWithSiteVirtualTable As IObjectWithSiteVtbl

Sub InitializeTestCOMServerVirtualTable()
	GlobalTestCOMServerVirtualTable.InheritedTable.QueryInterface = CPtr(Any Ptr, @TestCOMServerQueryInterface)
	GlobalTestCOMServerVirtualTable.InheritedTable.AddRef = CPtr(Any Ptr, @TestCOMServerAddRef)
	GlobalTestCOMServerVirtualTable.InheritedTable.Release = CPtr(Any Ptr, @TestCOMServerRelease)
	
	GlobalTestCOMServerVirtualTable.InheritedTable.GetTypeInfoCount = CPtr(Any Ptr, @TestCOMServerGetTypeInfoCount)
	GlobalTestCOMServerVirtualTable.InheritedTable.GetTypeInfo = CPtr(Any Ptr, @TestCOMServerGetTypeInfo)
	GlobalTestCOMServerVirtualTable.InheritedTable.GetIDsOfNames = CPtr(Any Ptr, @TestCOMServerGetIDsOfNames)
	GlobalTestCOMServerVirtualTable.InheritedTable.Invoke = CPtr(Any Ptr, @TestCOMServerInvoke)
	GlobalTestCOMServerVirtualTable.ShowMessageBox = CPtr(Any Ptr, @TestCOMServerShowMessageBox)
	
	GlobalTestCOMServerIObjectWithSiteVirtualTable.QueryInterface = CPtr(Any Ptr, @TestCOMServerObjectWithSiteQueryInterface)
	GlobalTestCOMServerIObjectWithSiteVirtualTable.AddRef = CPtr(Any Ptr, @TestCOMServerObjectWithSiteAddRef)
	GlobalTestCOMServerIObjectWithSiteVirtualTable.Release = CPtr(Any Ptr, @TestCOMServerObjectWithSiteRelease)
	GlobalTestCOMServerIObjectWithSiteVirtualTable.SetSite = CPtr(Any Ptr, @TestCOMServerObjectWithSiteSetSite)
	GlobalTestCOMServerIObjectWithSiteVirtualTable.GetSite = CPtr(Any Ptr, @TestCOMServerObjectWithSiteGetSite)
	
End sub

Function CreateTestCOMServer( _
		ByVal pIUnknownOuter As IUnknown Ptr _
	)As TestCOMServer Ptr
	
	Dim pTestCOMServer As TestCOMServer Ptr = HeapAlloc( _
		GetProcessHeap(), _
		0, _
		SizeOf(TestCOMServer) _
	)
	
	If pTestCOMServer = NULL Then
		Return NULL
	End If
	
	If pTestCOMServer->pIUnknownOuter <> NULL Then
		' Агрегирование
	End If
	
	pTestCOMServer->pIUnknownOuter = pIUnknownOuter
	
	pTestCOMServer->pVirtualTable = @GlobalTestCOMServerVirtualTable
	pTestCOMServer->pIObjectWithSiteVirtualTable = @GlobalTestCOMServerIObjectWithSiteVirtualTable
	pTestCOMServer->ReferenceCounter = 0
	pTestCOMServer->pUnkSite = NULL
	
	Return pTestCOMServer
	
End Function

Sub DestroyTestCOMServer( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)
	
	If pTestCOMServer->pIUnknownOuter <> NULL Then
		IUnknown_Release(pTestCOMServer->pIUnknownOuter)
	End If
	
	If pTestCOMServer->pUnkSite <> NULL Then
		IUnknown_Release(pTestCOMServer->pUnkSite)
	End If
	
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
	
	Const Caption = "TestCOMServer->QueryInterface"
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, @pTestCOMServer->pVirtualTable)
	End If
	
	If IsEqualIID(@IID_IDispatch, riid) Then
		*ppv = CPtr(IDispatch Ptr, @pTestCOMServer->pVirtualTable)
	End If
	
	If IsEqualIID(@IID_ITESTCOMSERVER, riid) Then
		*ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pVirtualTable)
	End If
	
	If IsEqualIID(@IID_IObjectWithSite, riid) Then
		*ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pIObjectWithSiteVirtualTable)
	End If
	
	If *ppv = NULL Then
		
		/'
		If IsEqualIID(@IID_IProvideMultipleClassInfo, riid) Then
			' *ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pVirtualTable)
			MessageBoxW(NULL, "IProvideMultipleClassInfo", Caption, MB_OK)
		Else
			If IsEqualIID(@IID_IProvideClassInfo, riid) Then
				' *ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pVirtualTable)
				MessageBoxW(NULL, "IProvideClassInfo", Caption, MB_OK)
			Else
				If IsEqualIID(@IID_IDispatchEx, riid) Then
					' *ppv = CPtr(ITestCOMServer Ptr, @pTestCOMServer->pVirtualTable)
					MessageBoxW(NULL, "IDispatchEx", Caption, MB_OK)
				Else
					Dim pstrIID_IFace As WString Ptr = Any
					StringFromIID(riid, @pstrIID_IFace)
					MessageBoxW(NULL, pstrIID_IFace, "TestCOMServer->QueryInterface", MB_OK)
				End If
			End If
		End If
		'/
		Return E_NOINTERFACE
	End If
	
	TestCOMServerAddRef(pTestCOMServer)
	
	Return S_OK
	
End Function

Function TestCOMServerAddRef( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)As ULONG
	
	' MessageBoxW(NULL, "AddRef", "TestCOMServer", MB_OK)
	
	' InterlockedIncrement(@GlobalObjectsCount)
	Return InterlockedIncrement(@pTestCOMServer->ReferenceCounter)
	
End Function

Function TestCOMServerRelease( _
		ByVal pTestCOMServer As TestCOMServer Ptr _
	)As ULONG
	
	' MessageBoxW(NULL, "Release", "TestCOMServer", MB_OK)
	
	InterlockedDecrement(@pTestCOMServer->ReferenceCounter)
	
	If pTestCOMServer->ReferenceCounter = 0 Then
		
		DestroyTestCOMServer(pTestCOMServer)
		' InterlockedDecrement(@GlobalObjectsCount)
		' MessageBoxW(NULL, "Объект уничтожен", "TestCOMServer", MB_OK)
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
			
			Dim oldParam As VARIANT = pDispParams->rgvarg[0]
			Dim newParam As VARIANT = Any
			VariantInit(@newParam)
			
			Dim hrChange As HRESULT = VariantChangeType(@newParam, @oldParam, 0, VT_I4)
			If FAILED(hrChange) Then
				Return hrChange
			End If
			
			Dim lVal As Long = Any
			
			Dim hr As HRESULT = TestCOMServerShowMessageBox( _
				pTestCOMServer, _
				newParam.lVal, _
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
	
	Select Case Param
		
		Case 0
			' MessageBoxW(0, "Это нулевое сообщение", "TestCOMServer COM Library", MB_OK)
			*pResult = 0
			
		Case 1
			' MessageBoxW(0, "Это первое сообщение", "TestCOMServer COM Library", MB_OK)
			*pResult = 1
			
		Case Else
			' MessageBoxW(0, "Это любое сообщение", "TestCOMServer COM Library", MB_OK)
			*pResult = 2
			
	End Select
	
	Return S_OK
	
End Function

Function TestCOMServerObjectWithSiteQueryInterface( _
		ByVal pTestCOMServerObjectWithSite As TestCOMServer Ptr, _
		ByVal riid As REFIID, _
		ByVal ppv As Any Ptr Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = TestCOMServer_OffsetOf_IObjectWithSite(pTestCOMServerObjectWithSite)
	
	Return TestCOMServerQueryInterface( _
		pTestCOMServer, _
		riid, _
		ppv _
	)
	
End Function

Function TestCOMServerObjectWithSiteAddRef( _
		ByVal pTestCOMServerObjectWithSite As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = TestCOMServer_OffsetOf_IObjectWithSite(pTestCOMServerObjectWithSite)
	
	Return TestCOMServerAddRef(pTestCOMServer)
	
End Function

Function TestCOMServerObjectWithSiteRelease( _
		ByVal pTestCOMServerObjectWithSite As TestCOMServer Ptr _
	)As ULONG
	
	Dim pTestCOMServer As TestCOMServer Ptr = TestCOMServer_OffsetOf_IObjectWithSite(pTestCOMServerObjectWithSite)
	
	Return TestCOMServerRelease(pTestCOMServer)
	
End Function

Function TestCOMServerObjectWithSiteSetSite( _
		ByVal pTestCOMServerObjectWithSite As TestCOMServer Ptr, _
		ByVal pUnkSite As IUnknown Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = TestCOMServer_OffsetOf_IObjectWithSite(pTestCOMServerObjectWithSite)
	
	If pTestCOMServer->pUnkSite <> NULL Then
		IUnknown_Release(pTestCOMServer->pUnkSite)
	End If
	
	If pUnkSite = NULL Then
		pTestCOMServer->pUnkSite = NULL
	Else
		pTestCOMServer->pUnkSite = pUnkSite
		IUnknown_AddRef(pTestCOMServer->pUnkSite)
	End If
	
	' MessageBoxW(NULL, "SetSite", "TestCOMServer", MB_OK)
	Return S_OK
	
End Function

Function TestCOMServerObjectWithSiteGetSite( _
		ByVal pTestCOMServerObjectWithSite As TestCOMServer Ptr, _
		byval riid As Const IID Const Ptr, _
		ByVal ppvSite As Any Ptr Ptr _
	)As HRESULT
	
	Dim pTestCOMServer As TestCOMServer Ptr = TestCOMServer_OffsetOf_IObjectWithSite(pTestCOMServerObjectWithSite)
	
	If pTestCOMServer->pUnkSite <> NULL Then
		IUnknown_AddRef(pTestCOMServer->pUnkSite)
	End If
	
	*ppvSite = pTestCOMServer->pUnkSite
	
	' MessageBoxW(NULL, "GetSite", "TestCOMServer", MB_OK)
	Return S_OK
	
End Function
