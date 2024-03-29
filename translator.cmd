REM ���������� ������-������

REM �������� ����: *.bas
REM ���������� �����: *.bi
REM ����� ��������: *.rc

REM ���������:
REM 1. ��� ������������� *.bas � *.rc ����� (� ��������)
REM 2. ��� ������������ �����               [console | gui | lib | dll | native | driver]
REM 3. ��� ����������������� �����          [� ��������] = ��� ������� ����� + .exe
REM 4. ���������� �����������               [� ��������] %ProgramFiles%\FreeBASIC
REM 5. �������������� ��������� ����������  [� ��������]
REM 6. ���� �������                         [release   | debug]
REM 7. ���� ��������������                  [noprofile | profile]
REM 8. ���� �������� RTL                    [runtime   | withoutruntime]

REM ���� ����������� ������
REM lib     ���������� ������������ ����������  -
REM dll     ����������� ������������ ���������� console
REM console ���������� ����������               console
REM gui     ����������� ����������              gui
REM native  �������� ����������                 native
REM driver  �������                             native

set CompilerLogErrorFileName=_out.txt

set AllCompiledFiles=%~1
set ExeTypeKind=%~2
set OutputFileName=%~3
set Directory=%~4
set CompilerParameters=%~5
set DebugFlag=%~6
set ProfileFlag=%~7
set WithoutRuntimeLibraryesFlag=%~8


:CreateCompilerPath
	
	if "%Directory%"=="" (
		set FREEBASIC_COMPILER="%ProgramFiles%\FreeBASIC\fbc.exe"
		
		if "%PROCESSOR_ARCHITECTURE%"=="x86" (
			set GCC_COMPILER="%ProgramFiles%\FreeBASIC\bin\win32\gcc.exe"
			set GCC_ASSEMBLER="%ProgramFiles%\FreeBASIC\bin\win32\as.exe"
			set GCC_LINKER="%ProgramFiles%\FreeBASIC\bin\win32\ld.exe"
			set DLL_TOOL="%ProgramFiles%\FreeBASIC\bin\win32\dlltool.exe"
			set RESOURCE_COMPILER="%ProgramFiles%\FreeBASIC\bin\win32\GoRC.exe"
			set ARCHIVE_COMPILER="%ProgramFiles%\FreeBASIC\bin\win32\ar.exe"
			set COMPILER_LIB_PATH="%ProgramFiles%\FreeBASIC\lib\win32"
			set CodeGenerationBackend=gas
		) else (
			set GCC_COMPILER="%ProgramFiles%\FreeBASIC\bin\win64\gcc.exe"
			set GCC_ASSEMBLER="%ProgramFiles%\FreeBASIC\bin\win64\as.exe"
			set GCC_LINKER="%ProgramFiles%\FreeBASIC\bin\win64\ld.exe"
			set DLL_TOOL="%ProgramFiles%\FreeBASIC\bin\win64\dlltool.exe"
			set RESOURCE_COMPILER="%ProgramFiles%\FreeBASIC\bin\win64\GoRC.exe"
			set ARCHIVE_COMPILER="%ProgramFiles%\FreeBASIC\bin\win64\ar.exe"
			set COMPILER_LIB_PATH="%ProgramFiles%\FreeBASIC\lib\win64"
			set CodeGenerationBackend=gcc
		)
		
	) else (
		set FREEBASIC_COMPILER="%Directory%\fbc.exe"
		
		if "%PROCESSOR_ARCHITECTURE%"=="x86" (
			set GCC_COMPILER="%Directory%\bin\win32\gcc.exe"
			set GCC_ASSEMBLER="%Directory%\bin\win32\as.exe"
			set GCC_LINKER="%Directory%\bin\win32\ld.exe"
			set DLL_TOOL="%Directory%\bin\win32\dlltool.exe"
			set RESOURCE_COMPILER="%Directory%\bin\win32\GoRC.exe"
			set ARCHIVE_COMPILER="%Directory%\bin\win32\ar.exe"
			set COMPILER_LIB_PATH="%Directory%\lib\win32"
			set CodeGenerationBackend=gas
		) else (
			set GCC_COMPILER="%Directory%\bin\win64\gcc.exe"
			set GCC_ASSEMBLER="%Directory%\bin\win64\as.exe"
			set GCC_LINKER="%Directory%\bin\win64\ld.exe"
			set DLL_TOOL="%Directory%\bin\win64\dlltool.exe"
			set RESOURCE_COMPILER="%Directory%\bin\win64\GoRC.exe"
			set ARCHIVE_COMPILER="%Directory%\bin\win64\ar.exe"
			set COMPILER_LIB_PATH="%Directory%\lib\win64"
			set CodeGenerationBackend=gcc
		)
	)
	
	
:CreateCompilerExeTypeKind
	
	if "%ExeTypeKind%"=="dll" (
		if "%WithoutRuntimeLibraryesFlag%"=="withoutruntime" (
			set CompilerExeTypeKind=-lib
		) else (
			set CompilerExeTypeKind=-dll
		)
	) else (
		if "%WithoutRuntimeLibraryesFlag%"=="withoutruntime" (
			set CompilerExeTypeKind=-lib
		) else (
			if "%ExeTypeKind%"=="lib" (
				set CompilerExeTypeKind=-lib
			)
		)
	)
	
:CreateWin32Subsystem
	
	if "%ExeTypeKind%"=="lib" (
		set Win32Subsystem=console
	) else (
		if "%ExeTypeKind%"=="dll" (
			set Win32Subsystem=console
		) else (
			if "%ExeTypeKind%"=="console" (
				set Win32Subsystem=console
			) else (
				if "%ExeTypeKind%"=="gui" (
					if "%WithoutRuntimeLibraryesFlag%"=="withoutruntime" (
						set Win32Subsystem=windows
					) else (
						set Win32Subsystem=gui
					)
				) else (
					if "%ExeTypeKind%"=="native" (
						set Win32Subsystem=native
					) else (
						if "%ExeTypeKind%"=="driver" (
							set Win32Subsystem=native
						) else (
							set Win32Subsystem=console
						)
					)
				)
			)
		)
	)
	
:CreateCompilerOutputFileName
	
	if "%OutputFileName%"=="" (
		for /F "tokens=1" %%I in ("%AllCompiledFiles%") do (
			call :SetCompilerOutputFileName %%I
		)
	) else (
		set CompilerOutputFileName=%OutputFileName%
	)
	
	
:CreateCompilerDebugFlag
	
	if "%DebugFlag%"=="debug" (
		set CompilerDebugFlag=-g
	)
	
	
:CreateCompilerProfileFlag
	
	if "%ProfileFlag%"=="profile" (
		set CompilerProfileFlag=-profile
	)
	
	
:CreateWithoutRuntimeLibraryesFlag
	
	if "%WithoutRuntimeLibraryesFlag%"=="withoutruntime" (
		set WITHOUT_RUNTIME_DEFINED=-d WITHOUT_RUNTIME
		set WriteOutOnlyAsmFlag=-r
	)
	
:RuntimeCompilation
	
	%FREEBASIC_COMPILER% %WITHOUT_RUNTIME_DEFINED% -x %CompilerOutputFileName% %WriteOutOnlyAsmFlag% -s %Win32Subsystem% %CompilerExeTypeKind% -gen %CodeGenerationBackend% %CompilerDebugFlag% %CompilerProfileFlag% %CompilerParameters% %AllCompiledFiles% >%CompilerLogErrorFileName%
	
	if %errorlevel% GEQ 1 (
		exit /b %errorlevel%
	)
	
	if not "%WithoutRuntimeLibraryesFlag%"=="withoutruntime" (
		exit /b 0
	)
	
	
:WithoutRuntimeCompilation
	
	set AllFileWithExtensionC=
	set AllFileWithExtensionAsm=
	set AllObjectFiles=
	
	for %%I IN (%AllCompiledFiles%) do (
		if "%%~xI"==".bas" (
			call :GccCompier %%I
		)
	)
	for %%I IN (%AllCompiledFiles%) do (
		if "%%~xI"==".RC" (
			call :ResourceCompiler %%I
		)
	)
	
	call :GccLinker
	
	call :CleanUp
	
	exit /b 0
	
:CleanUp
	
	if %CodeGenerationBackend%==gcc (
		del %AllFileWithExtensionC% %AllFileWithExtensionAsm% %AllObjectFiles%
	) else (
		del %AllFileWithExtensionAsm% %AllObjectFiles%
	)
	exit /b 0
	
	
:GccLinker
	
	REM ������� � ��������
	REM "C:\Program Files\FreeBASIC\lib\win64\fbextra.x"
	REM "C:\Program Files\FreeBASIC\lib\win64\crt2.o"
	REM "C:\Program Files\FreeBASIC\lib\win64\crtbegin.o"
	REM "C:\Program Files\FreeBASIC\lib\win64\fbrt0.o"
	REM (����������)
	REM "C:\Program Files\FreeBASIC\lib\win64\crtend.o"
	
	REM �������������
	REM "C:\Program Files\FreeBASIC\lib\win64\fbextra.x"
	REM "C:\Program Files\FreeBASIC\lib\win64\crt2.o"
	REM "C:\Program Files\FreeBASIC\lib\win64\gcrt2.o"
	REM "C:\Program Files\FreeBASIC\lib\win64\crtbegin.o"
	REM "C:\Program Files\FreeBASIC\lib\win64\fbrt0.o"
	REM (����������)
	REM "C:\Program Files\FreeBASIC\lib\win64\crtend.o"
	
	set IncludeUuidObjectLibraries=-luuid
	set IncludeGMonitorObjectLibraries=-lgmon
	set IncludeGccObjectLibraries=-lmoldname -lgcc
	set IncludeWinApiObjectLibraries=-ladvapi32 -lcomctl32 -lcomdlg32 -lcrypt32 -lgdi32 -lgdiplus -limm32 -lkernel32 -lmsimg32 -lmsvcrt -lmswsock -lole32 -loleaut32 -lshell32 -lshlwapi -luser32 -lversion -lwinmm -lwinspool -lws2_32
	
	set IncludeAllObjectLibraries=%IncludeWinApiObjectLibraries% %IncludeGMonitorObjectLibraries% %IncludeGccObjectLibraries%
	
	set UseThreadSafeRuntime=
	
	set MajorImageVersion=--major-image-version 1
	set MinorImageVersion=--minor-image-version 0
	
	set OutputDefinitionFileName=%OutputFileName:~0,-3%def
	
	if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		
		if "%ExeTypeKind%"=="dll" (
			set EntryPoint=_DllMain@12 --dll --enable-stdcall-fixup --output-def %OutputDefinitionFileName%
		) else (
			set EntryPoint=_EntryPoint@0
		)
		
		set PEFileFormat=i386pe
		
	) else (
		
		if "%ExeTypeKind%"=="dll" (
			set EntryPoint=DllMain --dll --enable-stdcall-fixup --output-def %OutputDefinitionFileName%
		) else (
			set EntryPoint=EntryPoint
		)
		
		set PEFileFormat=i386pep
		
	)
	
	if "%DebugFlag%"=="debug" (
		set LinkerStripFlag=
	) else (
		set LinkerStripFlag=-s --gc-sections
	)
	%GCC_LINKER% -m %PEFileFormat% -o %CompilerOutputFileName% -subsystem %Win32Subsystem% -e %EntryPoint% --stack 1048576,1048576 %LinkerStripFlag% -L %COMPILER_LIB_PATH% -L "." "%COMPILER_LIB_PATH:~1,-1%\fbextra.x" %AllObjectFiles% %IncludeAllObjectLibraries%
	
	if "%ExeTypeKind%"=="dll" (
		%DLL_TOOL% --def %OutputDefinitionFileName% --dllname %CompilerOutputFileName% --output-lib lib%CompilerOutputFileName%.a
	)
	
	exit /b 0
	
	
:GccCompier
	
	set GCCWarning=-Werror -Wall -Wno-unused-label -Wno-unused-function -Wno-unused-variable -Wno-unused-but-set-variable -Wno-main
	set GCCNoInclude=-nostdlib -nostdinc
	if "%DebugFlag%"=="debug" (
		set OptimizationLevel=-O0
	) else (
		set OptimizationLevel=-O3
	)
	set GCCOptimizations=%OptimizationLevel% -fdata-sections -ffunction-sections -mno-stack-arg-probe -fno-stack-check -fno-stack-protector -fno-strict-aliasing -frounding-math -fno-math-errno -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-ident
	
	set FileWithExtensionBas=%1
	set FileWithoutExtension=%FileWithExtensionBas:~0,-3%
	set FileWithExtensionC=%FileWithoutExtension%c
	set FileWithExtensionAsm=%FileWithoutExtension%asm
	set FileWithExtensionObj=%FileWithoutExtension%o
	
	if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		set TargetAssemblerArch=--32
	) else (
		set TargetAssemblerArch=--64
		set GCCArchitecture=-m64 -march=x86-64
	)
	
	if "%CodeGenerationBackend%"=="gcc" (
		%GCC_COMPILER% %GCCWarning% %GCCNoInclude% %GCCOptimizations% %GCCArchitecture% %CompilerDebugFlag% -masm=intel -S %FileWithExtensionC% -o %FileWithExtensionAsm%
	)
	set AllFileWithExtensionC=%AllFileWithExtensionC% %FileWithExtensionC%
	set AllFileWithExtensionAsm=%AllFileWithExtensionAsm% %FileWithExtensionAsm%
	
	if "%DebugFlag%"=="debug" (
		set AssemblerStripFlag=
	) else (
		set AssemblerStripFlag=--strip-local-absolute
	)
	%GCC_ASSEMBLER% %TargetAssemblerArch% %AssemblerStripFlag% %FileWithExtensionAsm% -o %FileWithExtensionObj%
	set AllObjectFiles=%AllObjectFiles% %FileWithExtensionObj%
	
	
	exit /b 0
	
	
:ResourceCompiler
	
	set ResourceFileWithExtension=%1
	set ResourceFileWithoutExtension=%ResourceFileWithExtension:~0,-2%
	set ResourceFileWithExtensionObj=%ResourceFileWithoutExtension%obj
	
	if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		set ResourceCompilerBitFlag=/nw
	) else (
		set ResourceCompilerBitFlag=/machine X64
	)
	
	%RESOURCE_COMPILER% /ni %ResourceCompilerBitFlag% /o /fo %ResourceFileWithExtensionObj% %ResourceFileWithExtension%
	
	set AllObjectFiles=%AllObjectFiles% %ResourceFileWithExtensionObj%
	
	exit /b 0
	
	
:SetCompilerOutputFileName
	
	set CompilerOutputFileNameWithExtensionBas=%1
	set CompilerOutputFileNameWithouExtension=%CompilerOutputFileNameWithExtensionBas:~0,-3%
	
	if "%ExeTypeKind%"=="lib" (
		set CompilerOutputFileName=lib%CompilerOutputFileNameWithouExtension%.a
	) else (
		if "%ExeTypeKind%"=="dll" (
			set CompilerOutputFileName=%CompilerOutputFileNameWithouExtension%.dll
		) else (
			set CompilerOutputFileName=%CompilerOutputFileNameWithouExtension%.exe
		)
	)
	
	exit /b 0