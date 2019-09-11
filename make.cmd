set CompilerDirectory=%ProgramFiles%\FreeBASIC
if %PROCESSOR_ARCHITECTURE%=="x86" (
	set CompilerBinDirectory=%CompilerDirectory%\bin\win32
	set CompilerLibDirectory=%CompilerDirectory%\lib\win32
	set CodeGenerationBackend=gas
) else (
	set CompilerBinDirectory=%CompilerDirectory%\bin\win64
	set CompilerLibDirectory=%CompilerDirectory%\lib\win64
	set CodeGenerationBackend=gcc
)

set IncludeFilesPath=-i Classes -i Interfaces -i Modules
set IncludeLibraries=-l kernel32
set MaxErrorsCount=-maxerr 1
set MinWarningLevel=-w all
set OptimizationLevel=-O 3
set VectorizationLevel=-vec 0
REM set EnableVerbose=-v
REM set EnableRuntimeErrorChecking=-e
REM set EnableDebug=-g
REM set EnableFunctionProfiling=-profile
REM set EnableShowIncludes=-showincludes

set MainFile=Modules\DLLMain.bas
set Classes=
set Modules=
set Resources=

if "%1"=="lib" (
	set DYNAMICLIBRARY_DEFINED=
	set Win32Subsystem=console
	set OutputFileName=libTestCOMServer.a
	set TypeKindLibrary=-lib
) else (
	set DYNAMICLIBRARY_DEFINED=
	set Win32Subsystem=console
	set OutputFileName=TestCOMServer.dll
	set OutputDefinitionFileName=TestCOMServer.def
	set TypeKindLibrary=-dll
)

if "%2"=="withoutruntime" (
	set WITHOUT_RUNTIME_DEFINED=-d withoutruntime
	set UseThreadSafeRuntime=
	set WriteOutOnlyAsm=-r
	set TypeKindLibrary=-lib
	set IncludeObjectLibraries=-lkernel32 -lgdi32 -lmsimg32 -luser32 -lversion -ladvapi32 -limm32 -loleaut32 -lole32 -luuid -lpsapi -lshlwapi -lshell32 -lcomctl32 -lfbmt -lgcc -lmsvcrt -lmingw32 -lmingwex -lmoldname -lgcc_eh
	set GCCWarning=-Werror -Wall -Wno-unused-label -Wno-unused-function -Wno-unused-variable -Wno-unused-but-set-variable -Wno-main
	set GCCNoInclude=-nostdlib -nostdinc
	set GCCArchitecture=-m64 -march=x86-64
	set GCCOptimizations=-O3 -mno-stack-arg-probe -fno-stack-check -fno-stack-protector -fno-strict-aliasing -frounding-math -fno-math-errno -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-ident
) else (
	set WITHOUT_RUNTIME_DEFINED=
	set UseThreadSafeRuntime=-mt
)

:FreeBASICCompile

"%CompilerDirectory%\fbc.exe" %MaxErrorsCount% %UseThreadSafeRuntime% -x %OutputFileName% %IncludeLibraries% %IncludeFilesPath% %OptimizationLevel% -s %Win32Subsystem% %VectorizationLevel% -gen %CodeGenerationBackend% %MinWarningLevel% %EnableDebug% %EnableFunctionProfiling% %WriteOutOnlyAsm% %TypeKindLibrary% %EnableShowIncludes% %EnableVerbose% %DYNAMICLIBRARY_DEFINED% %WITHOUT_RUNTIME_DEFINED% %MainFile% %Classes% %Modules% %Resources% >_out.txt

if %errorlevel% GEQ 1 (
	goto :endoffile
)

if not "%2"=="withoutruntime" (
	goto :endoffile
)

set AllCompiledFiles=%MainFile% %Classes% %Modules%
set AllObjectFiles=

for %%I IN (%AllCompiledFiles%) do (
	call :gcccompile %%I
)

if %PROCESSOR_ARCHITECTURE%=="x86" (
	set EntryPoint=_DllMain@12
	set PEFileFormat=i386pe
) else (
	set EntryPoint=DllMain
	set PEFileFormat=i386pep
)

"%CompilerBinDirectory%\ld.exe" -m %PEFileFormat% -subsystem console --dll --enable-stdcall-fixup -e %EntryPoint% -s --stack 1048576,1048576 --output-def %OutputDefinitionFileName% -L "%CompilerLibDirectory%" -L "." %AllObjectFiles% -o %OutputFileName% -( %IncludeObjectLibraries% -)

"%CompilerBinDirectory%\dlltool.exe" --def %OutputDefinitionFileName% --dllname %OutputFileName% --output-lib lib%OutputFileName%.a

goto :endoffile


:gcccompile

set FileWithExtension=%1
set FileWithoutExtension=%FileWithExtension:~0,-3%

set FileWithExtensionC=%FileWithoutExtension%c
set FileWithExtensionAsm=%FileWithoutExtension%asm
set FileWithExtensionObj=%FileWithoutExtension%obj

if %PROCESSOR_ARCHITECTURE%=="x86" (
	set TargetAssemblerArch=--32
) else (
	set TargetAssemblerArch=--64
	"%CompilerBinDirectory%\gcc.exe" %GCCWarning% %GCCNoInclude% %GCCOptimizations% %GCCArchitecture% -masm=intel -S %FileWithExtensionC% -o %FileWithExtensionAsm%
)

"%CompilerBinDirectory%\as.exe" %TargetAssemblerArch% --strip-local-absolute %FileWithExtensionAsm% -o %FileWithExtensionObj%

set AllObjectFiles=%AllObjectFiles% %FileWithExtensionObj%

exit /b

:endoffile