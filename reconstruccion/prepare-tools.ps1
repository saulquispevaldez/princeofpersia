$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force downloads,tools,build | Out-Null
$items = @(
    @('https://ziglang.org/download/0.13.0/zig-windows-x86_64-0.13.0.zip','zig-0.13.0.zip','D859994725EF9402381E557C60BB57497215682E355204D754EE3DF75EE3C158'),
    @('https://github.com/libsdl-org/SDL/releases/download/release-2.30.11/SDL2-devel-2.30.11-mingw.tar.gz','SDL2-devel-2.30.11-mingw.tar.gz','0590DB0A47B564AAB92499ED03EAA75DB9AEE17C371080CAA3B05DF9D49D9FF9'),
    @('https://github.com/libsdl-org/SDL_image/releases/download/release-2.8.4/SDL2_image-devel-2.8.4-mingw.tar.gz','SDL2_image-devel-2.8.4-mingw.tar.gz','7C0B437C54919EC3899F3EDF49F8F260F5F2703451EE32E61DA77ECCBC04F542')
)
foreach ($item in $items) {
    $archive = Join-Path 'downloads' $item[1]
    if (-not (Test-Path $archive)) {
        & curl.exe -fL --retry 2 $item[0] -o $archive
        if ($LASTEXITCODE -ne 0) { throw "Download failed: $($item[0])" }
    }
    if ((Get-FileHash $archive -Algorithm SHA256).Hash -ne $item[2]) { throw "SHA256 mismatch: $archive" }
    & tar -xf $archive -C tools
    if ($LASTEXITCODE -ne 0) { throw "Extraction failed: $archive" }
}
if (-not (Test-Path source\src\main.c)) {
    if (-not (Test-Path SDLPoP-source.zip)) { throw 'Missing SDLPoP-source.zip' }
    Expand-Archive SDLPoP-source.zip -DestinationPath . -Force
}
Write-Output 'Tools and source ready. Run .\build.ps1'
