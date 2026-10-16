$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$env:ZIG_GLOBAL_CACHE_DIR = Join-Path $PSScriptRoot 'build\zig-cache'
$env:ZIG_LOCAL_CACHE_DIR = Join-Path $PSScriptRoot 'build\zig-local'
$cfiles = Get-ChildItem source\src\*.c | ForEach-Object FullName
Set-Content build\compile.log ''
$flags = @('cc','-target','x86_64-windows-gnu','-std=c99','-O2','-D_GNU_SOURCE=1','-DSDL_MAIN_HANDLED',
    '-Itools/SDL2-2.30.11/x86_64-w64-mingw32/include',
    '-Itools/SDL2-2.30.11/x86_64-w64-mingw32/include/SDL2',
    '-Itools/SDL2_image-2.8.4/x86_64-w64-mingw32/include',
    '-Ltools/SDL2-2.30.11/x86_64-w64-mingw32/lib',
    '-Ltools/SDL2_image-2.8.4/x86_64-w64-mingw32/lib')
& .\tools\zig-windows-x86_64-0.13.0\zig.exe @flags @cfiles 'tools/SDL2-2.30.11/x86_64-w64-mingw32/lib/libSDL2.dll.a' 'tools/SDL2_image-2.8.4/x86_64-w64-mingw32/lib/libSDL2_image.dll.a' -lm '-Wl,--subsystem,windows' -o build/prince.exe 2>&1 | Tee-Object build\compile.log
if ($LASTEXITCODE -ne 0) { throw "Compilation failed: $LASTEXITCODE" }
Add-Content build\compile.log 'Build succeeded: prince.exe (Windows x64)'
