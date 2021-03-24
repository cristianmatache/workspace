for /f "tokens=*" %%a in ('where git') do set GIT_BASH_DEFAULT_ROOT=%%~dpa..
if not defined GIT_BASH_ROOT set GIT_BASH_ROOT=%GIT_BASH_DEFAULT_ROOT%

SET USR_BIN=%GIT_BASH_ROOT%\usr\bin
SET MINGW_BIN=%GIT_BASH_ROOT%\mingw64\bin
SET PATH=%2;%USR_BIN%;%MINGW_BIN%;%PATH%

make fmt-py -j1 on="%1"
