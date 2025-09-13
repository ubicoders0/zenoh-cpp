@echo off
setlocal enabledelayedexpansion

rem ===== Paths =====
set "ZENOH_C_INSTALL=C:\cmake_ext_libs\zenoh-c"
set "ZENOH_CPP_SRC=E:\local_projects\zenoh_projects\zenoh-cpp"
set "ZENOH_CPP_BUILD=%ZENOH_CPP_SRC%\build"
set "PREFIX=C:\cmake_ext_libs\zenoh-cpp"

rem ===== Sanity checks =====
if not exist "%ZENOH_C_INSTALL%\lib\cmake\zenohc\zenohcConfig.cmake" (
  echo [ERROR] Could not find zenohcConfig.cmake under:
  echo         %ZENOH_C_INSTALL%\lib\cmake\zenohc
  echo         Make sure zenoh-c was installed to %ZENOH_C_INSTALL%
  exit /b 1
)

rem ===== Clean stale cache (fixes wrong cached paths) =====
if exist "%ZENOH_CPP_BUILD%" rmdir /s /q "%ZENOH_CPP_BUILD%"

rem ===== Make zenoh-c discoverable (find_package) =====
rem 1) Best: tell CMake the prefix that contains lib\cmake\zenohc
set "CMAKE_PREFIX_PATH=%ZENOH_C_INSTALL%;%CMAKE_PREFIX_PATH%"
rem 2) Also pass zenohc_DIR explicitly as a belt-and-suspenders
set "ZENOHC_DIR=%ZENOH_C_INSTALL%\lib\cmake\zenohc"

rem ===== Configure =====
pushd "%ZENOH_CPP_SRC%"
cmake -S "%ZENOH_CPP_SRC%" -B "%ZENOH_CPP_BUILD%" ^
  -G "Visual Studio 17 2022" -A x64 ^
  -DCMAKE_INSTALL_PREFIX="%PREFIX%" ^
  -DCMAKE_PREFIX_PATH="%CMAKE_PREFIX_PATH%" ^
  -Dzenohc_DIR="%ZENOHC_DIR%" ^
  -DZENOHCXX_ZENOHC=ON ^
  -DZENOHCXX_ZENOHPICO=OFF ^
  -DZENOHCXX_ENABLE_TESTS=OFF ^
  -DZENOHCXX_ENABLE_EXAMPLES=ON

if errorlevel 1 (
  echo [ERROR] CMake configure failed.
  popd & exit /b 1
)

rem ===== Build (Release) =====
cmake --build "%ZENOH_CPP_BUILD%" --config Release
if errorlevel 1 (
  echo [ERROR] Build failed.
  popd & exit /b 1
)

rem ===== Install to PREFIX =====
cmake --install "%ZENOH_CPP_BUILD%" --config Release
if errorlevel 1 (
  echo [ERROR] Install failed.
  popd & exit /b 1
)
