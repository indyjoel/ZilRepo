@echo off
echo %1.zil

zilf %1.zil

if %ERRORLEVEL% EQU 0 (
	zapf %1.zap
	) ELSE (
echo ERROR 

)