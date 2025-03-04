C:\tools\msys64\usr\bin\env MSYSTEM=MINGW64 /bin/bash -l -c 'pacman -S --needed --noconfirm pactoys patch'
C:\tools\msys64\usr\bin\env MSYSTEM=MINGW64 /bin/bash -l -c 'pacboy -Sy --needed --noconfirm binutils:x make:x gcc:x gettext:x readline:x'
New-Item $(Get-ToolsLocation) -ItemType Directory
Move-Item $(Get-ChocolateyPath -PathType 'PackagePath')\tools $(Get-ToolsLocation)\chicken -Force
Install-ChocolateyEnvironmentVariable -VariableName "CHICKEN_PREFIX" -VariableValue "$(Get-ToolsLocation)\chicken" -VariableType Machine
Install-ChocolateyPath -PathToInstall "$(Get-ToolsLocation)\chicken\bin" -PathType Machine
Install-ChocolateyPath -PathToInstall "$(Get-ToolsLocation)\msys64\mingw64\bin" -PathType Machine
Update-SessionEnvironment
