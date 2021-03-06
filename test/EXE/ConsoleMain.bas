#include "ConsoleMain.bi"
#include "IntegerToWString.bi"
#include "ITestCOMServer.bi"

Extern IID_IClassFactory As Const IID
Const ProgID_TestCOMServer = "BatchedFiles.TestCOMServer"

#ifndef WINDOWS_SERVICE

Function ConsoleMain()As Integer
	
	Dim hr As HRESULT = CoInitializeEx(NULL, COINIT_MULTITHREADED)
	If FAILED(hr) Then
		Return 1
	End If
	
	Dim idclsid As CLSID
	Scope
		hr = CLSIDFromProgID(@ProgID_TestCOMServer, @idclsid)
		
		If FAILED(hr) Then
			
			MessageBoxW(NULL, "Не могу разрешить CLSID по ProgID", NULL, MB_OK)
			Return 1
			
		End If
	End Scope
	
	Dim pClassFactory As IClassFactory Ptr = NULL
	hr = CoGetClassObject(@idclsid, CLSCTX_INPROC, NULL, @IID_IClassFactory, @pClassFactory)
	
	If FAILED(hr) Then
		MessageBoxW(NULL, "Ошибка в CoGetClassObject", NULL, MB_OK)
		Return 1
	End If
	
	Dim pClient As ITestCOMServer Ptr = NULL
	
	Scope
		hr = pClassFactory->lpVtbl->CreateInstance(pClassFactory, NULL, @IID_ITestCOMServer, @pClient)
		
		If FAILED(hr) Then
			MessageBoxW(NULL, "Не могу создать TestCOMServer", NULL, MB_OK)
		Else
			Dim ObjectsCount As Long = Any
			pClient->lpVtbl->GetObjectsCount(pClient, @ObjectsCount)
			
			Dim wObjectsCount As WString * 128 = Any
			ltow(ObjectsCount, @wObjectsCount, 10)
			
			MessageBoxW(NULL, wObjectsCount, "Количество объектов", MB_OK)
			
			pClient->lpVtbl->Release(pClient)
		End If
		
	End Scope
	
	pClassFactory->lpVtbl->Release(pClassFactory)
	
	
	CoUnInitialize()
	
	Return 0
	
End Function

#endif
