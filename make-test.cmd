set CompilerDirectory=%ProgramFiles%\FreeBASIC

set MainFile=test\EntryPoint.bas
set Classes=
set Modules=test\ConsoleMain.bas Modules\Guids.bas
set Resources=
set OutputFile=test.exe

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

set PROGRAM_VERSION_MAJOR=1
set PROGRAM_VERSION_MINOR=0
set PROGRAM_VERSION_BUILD=0
set PROGRAM_VERSION_REVISION=%RANDOM%

if "%2"=="debug" (
	set EnableDebug=debug
) else (
	set EnableDebug=release
)

if "%3"=="withoutruntime" (
	set WithoutRuntime=withoutruntime
) else (
	set WithoutRuntime=runtime
)

set CompilerParameters=-d PROGRAM_VERSION_MAJOR=%PROGRAM_VERSION_MAJOR% -d PROGRAM_VERSION_MINOR=%PROGRAM_VERSION_MINOR% -d PROGRAM_VERSION_BUILD=%PROGRAM_VERSION_BUILD% -d PROGRAM_VERSION_REVISION=%PROGRAM_VERSION_REVISION% %MaxErrorsCount% %UseThreadSafeRuntime% %IncludeLibraries% %IncludeFilesPath% %OptimizationLevel% %VectorizationLevel% %MinWarningLevel% %EnableFunctionProfiling% %EnableShowIncludes% %EnableVerbose% %EnableRuntimeErrorChecking%

call translator.cmd "%MainFile% %Classes% %Modules% %Resources%" "%ExeTypeKind%" "%OutputFile%" "%CompilerDirectory%" "%CompilerParameters%" %EnableDebug% noprofile %WithoutRuntime%