set CompilerDirectory=%ProgramFiles%\FreeBASIC

set MainFile=Modules\DLLMain.bas
set Classes=Classes\ClassFactory.bas Classes\ObjectsCounter.bas Classes\TestCOMServer.bas Classes\TestCOMServerEventsConnectionPoint.bas
set Modules=Modules\Guids.bas Modules\InvokeDispatchFunction.bas Modules\Registry.bas
set Resources=Resources.RC
set OutputFile=BatchedFilesTestCOMServer.dll

set IncludeFilesPath=-i Classes -i Headers -i Interfaces -i Modules
set IncludeLibraries=-l kernel32
set ExeTypeKind=dll

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