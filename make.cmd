set CompilerDirectory=%ProgramFiles%\FreeBASIC

set MainFile=Modules\DLLMain.bas
set Classes=Classes\TestCOMServer.bas Classes\ClassFactory.bas
set Modules=Modules\InitializeVirtualTables.bas Modules\Registry.bas
set Resources=Resources.rc
set OutputFile=BatchedFilesTestCOMServer.dll

set IncludeFilesPath=-i Classes -i Interfaces -i Modules
set IncludeLibraries=-l kernel32
set Subsystem=console
set ExeTypeKind=dll

set MaxErrorsCount=-maxerr 1
set MinWarningLevel=-w all
set OptimizationLevel=-O 3
set VectorizationLevel=-vec 0
REM set UseThreadSafeRuntime=-mt

REM set EnableShowIncludes=-showincludes
REM set EnableVerbose=-v
REM set EnableRuntimeErrorChecking=-e
REM set EnableDebug=-g
REM set EnableFunctionProfiling=-profile


if "%2"=="withoutruntime" (
	set WithoutRuntime=withoutruntime
) else (
	set WithoutRuntime=runtime
)

set CompilerParameters=%MaxErrorsCount% %UseThreadSafeRuntime% %IncludeLibraries% %IncludeFilesPath% %OptimizationLevel% %VectorizationLevel% %MinWarningLevel% %EnableDebug% %EnableFunctionProfiling% %EnableShowIncludes% %EnableVerbose% %EnableRuntimeErrorChecking%

call translator.cmd "%CompilerDirectory%" "%MainFile% %Classes% %Modules%" "%Resources%" "%CompilerParameters%" "%OutputFile%" %Subsystem% %ExeTypeKind% %WithoutRuntime%



