set CompilerLogErrorFileName=_out.txt

set CompilerDirectory=%~1
set AllCompiledFiles=%~2
set AllResourceFiles=%~3
set CompilerParameters=%~4
set OutputFileName=%~5
set Win32Subsystem=%6
REM set TypeKindLibrary=%7
set WithoutRuntimeLibraryesFlag=%8

if "%PROCESSOR_ARCHITECTURE%"=="x86" (
	set CompilerBinDirectory=%CompilerDirectory%\bin\win32
	set CompilerLibDirectory=%CompilerDirectory%\lib\win32
	set CodeGenerationBackend=gas
) else (
	set CompilerBinDirectory=%CompilerDirectory%\bin\win64
	set CompilerLibDirectory=%CompilerDirectory%\lib\win64
	set CodeGenerationBackend=gcc
)

if "%7"=="dll" (
	set DYNAMIC_LIBRARY_DEFINED=-d DYNAMIC_LIBRARY_DEFINED
	if not "%WithoutRuntimeLibraryesFlag%"=="withoutruntime" (
		set TypeKindLibrary=-dll
	) else (
		set TypeKindLibrary=-lib
	)
) else (
	set DYNAMIC_LIBRARY_DEFINED=
	if not "%WithoutRuntimeLibraryesFlag%"=="withoutruntime" (
		set TypeKindLibrary=
	) else (
		set TypeKindLibrary=-lib
	)
)

if "%WithoutRuntimeLibraryesFlag%"=="withoutruntime" (
	set WITHOUT_RUNTIME_DEFINED=-d WITHOUT_RUNTIME_DEFINED
	set UseThreadSafeRuntime=
	set WriteOutOnlyAsm=-r
	set IncludeObjectLibraries=-lkernel32 -lgdi32 -lmsimg32 -luser32 -lversion -ladvapi32 -limm32 -luuid -loleaut32 -lole32 -lpsapi -lshlwapi -lshell32 -lcomctl32 -lmsvcrt
	set GCCWarning=-Werror -Wall -Wno-unused-label -Wno-unused-function -Wno-unused-variable -Wno-unused-but-set-variable -Wno-main
	set GCCNoInclude=-nostdlib -nostdinc
	set GCCOptimizations=-O3 -mno-stack-arg-probe -fno-stack-check -fno-stack-protector -fno-strict-aliasing -frounding-math -fno-math-errno -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-ident
	set OutputDefinitionFileName=%OutputFileName:~0,-3%def
)


:FreeBASICCompiler


"%CompilerDirectory%\fbc.exe" %DYNAMIC_LIBRARY_DEFINED% %WITHOUT_RUNTIME_DEFINED% %AllCompiledFiles% %AllResourceFiles% -x %OutputFileName% %WriteOutOnlyAsm% -s %Win32Subsystem% %TypeKindLibrary% -gen %CodeGenerationBackend% %CompilerParameters% >%CompilerLogErrorFileName%

if %errorlevel% GEQ 1 (
	exit /b 1
)

if not "%WithoutRuntimeLibraryesFlag%"=="withoutruntime" (
	exit /b 0
)


:WithOutRuntimeCompilation

set AllObjectFiles=

for %%I IN (%AllCompiledFiles%) do (
	call :GccCompier %%I
)
for %%I IN (%AllResourceFiles%) do (
	call :ResourceCompiler %%I
)

REM set MajorImageVersion=--major-image-version 1
REM set MinorImageVersion=--minor-image-version 0

if "%PROCESSOR_ARCHITECTURE%"=="x86" (
	if "%7"=="dll" (
		set EntryPoint=_DllMain@12 --dll --enable-stdcall-fixup --output-def %OutputDefinitionFileName%
	) else (
		set EntryPoint=_EntryPoint@12
	)
	set PEFileFormat=i386pe
) else (
	if "%7"=="dll" (
		set EntryPoint=DllMain --dll --enable-stdcall-fixup --output-def %OutputDefinitionFileName%
	) else (
		set EntryPoint=EntryPoint
	)
	set PEFileFormat=i386pep
)


:GccLinker

"%CompilerBinDirectory%\ld.exe" -m %PEFileFormat% -subsystem %Win32Subsystem% -e %EntryPoint% -s --stack 1048576,1048576 -L "%CompilerLibDirectory%" -L "." %AllObjectFiles% -o %OutputFileName% -( %IncludeObjectLibraries% -)
del %AllObjectFiles%

if "%7"=="dll" (
	"%CompilerBinDirectory%\dlltool.exe" --def %OutputDefinitionFileName% --dllname %OutputFileName% --output-lib lib%OutputFileName%.a
)

exit /b 0


:GccCompier

set FileWithExtensionBas=%1
set FileWithoutExtension=%FileWithExtensionBas:~0,-3%
set FileWithExtensionC=%FileWithoutExtension%c
set FileWithExtensionAsm=%FileWithoutExtension%asm
set FileWithExtensionObj=%FileWithoutExtension%obj

if "%PROCESSOR_ARCHITECTURE%"=="x86" (
	set TargetAssemblerArch=--32
) else (
	set TargetAssemblerArch=--64
	set GCCArchitecture=-m64 -march=x86-64
	"%CompilerBinDirectory%\gcc.exe" %GCCWarning% %GCCNoInclude% %GCCOptimizations% %GCCArchitecture% -masm=intel -S %FileWithExtensionC% -o %FileWithExtensionAsm%
	del %FileWithExtensionC%
)

"%CompilerBinDirectory%\as.exe" %TargetAssemblerArch% --strip-local-absolute %FileWithExtensionAsm% -o %FileWithExtensionObj%
del %FileWithExtensionAsm%

set AllObjectFiles=%AllObjectFiles% %FileWithExtensionObj%

exit /b 0


:ResourceCompiler

set ResourceFileWithExtension=%1
set ResourceFileWithoutExtension=%ResourceFileWithExtension:~0,-2%
set ResourceFileWithExtensionObj=%ResourceFileWithoutExtension%obj

if "%PROCESSOR_ARCHITECTURE%"=="x86" (
	"%CompilerBinDirectory%\gorc" /ni /nw /o /fo %ResourceFileWithExtensionObj% %ResourceFileWithExtension%
) else (
	"%CompilerBinDirectory%\gorc" /ni /machine X64 /o /fo %ResourceFileWithExtensionObj% %ResourceFileWithExtension%
)

set AllObjectFiles=%AllObjectFiles% %ResourceFileWithExtensionObj%

exit /b 0