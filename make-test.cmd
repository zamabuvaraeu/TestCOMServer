set CompilerDirectory=%ProgramFiles%\FreeBASIC

set MainFile=test\EXE\EntryPoint.bas
set Classes=
set Modules=test\EXE\ConsoleMain.bas Modules\Guids.bas
set Resources=
set OutputFile=test\EXE\test.exe

set IncludeFilesPath=-i Classes -i Interfaces -i Modules
set IncludeLibraries=-l kernel32
set ExeTypeKind=console

set MaxErrorsCount=-maxerr 1
set MinWarningLevel=-w all
set OptimizationLevel=-O 3
set VectorizationLevel=-vec 0
REM set UseThreadSafeRuntime=-mt

REM set EnableShowIncludes=-showincludes
REM set EnableVerbose=-v
REM set EnableRuntimeErrorChecking=-e
REM set EnableFunctionProfiling=-profile

if "%2"=="debug" (
	set EnableDebug=debug
) else (
	set EnableDebug=release
)

if "%3"=="withoutruntime" (
	set WithoutRuntime=withoutruntime
	set GUIDS_WITHOUT_MINGW=-d GUIDS_WITHOUT_MINGW=1
) else (
	set WithoutRuntime=runtime
)

set CompilerParameters=%GUIDS_WITHOUT_MINGW% %MaxErrorsCount% %UseThreadSafeRuntime% %IncludeLibraries% %IncludeFilesPath% %OptimizationLevel% %VectorizationLevel% %MinWarningLevel% %EnableFunctionProfiling% %EnableShowIncludes% %EnableVerbose% %EnableRuntimeErrorChecking%

call translator.cmd "%MainFile% %Classes% %Modules% %Resources%" "%ExeTypeKind%" "%OutputFile%" "%CompilerDirectory%" "%CompilerParameters%" %EnableDebug% noprofile %WithoutRuntime%