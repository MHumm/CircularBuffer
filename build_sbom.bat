@echo off
where dxcomply.exe >nul 2>nul

:: errorlevel 0 bedeutet: Gefunden
if %errorlevel% == 0 (
    goto :found
) else (
    goto :missing
)

:found
  dxcomply --library --project=Ringpuffer.dproj --source-dir=.\ --version=1.1.0.0 --repo-url=https://github.com/MHumm/CircularBuffer --licence=Apache-2.0 --supplier="Markus Humm" --supplier-url=https://github.com/MHumm/CircularBuffer --sbom-creator=markus.humm@gmail.com --report=html
  goto :end

:missing
  ECHO dx.comply Delphi IDE plugin from Olaf Monien needed
  
:end