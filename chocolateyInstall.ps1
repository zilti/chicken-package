C:\tools\msys64\usr\bin\env MSYSTEM=MINGW64 /bin/bash -l -c 'pacman -S --needed --noconfirm pactoys'
C:\tools\msys64\usr\bin\env MSYSTEM=MINGW64 /bin/bash -l -c 'pacboy -Sy --needed --noconfirm binutils:x make:x gcc:x gettext:x readline:x'
New-Item C:\tools -ItemType Directory
Move-Item $env:chocolateyPackageFolder\tools C:\tools\chicken -Force
Install-ChocolateyEnvironmentVariable -VariableName "CHICKEN_PREFIX" -VariableValue "C:\tools\chicken" -VariableType Machine
Install-ChocolateyPath -PathToInstall "C:\tools\chicken\bin" -PathType Machine
Install-ChocolateyPath -PathToInstall "C:\tools\msys64\mingw64\bin" -PathType Machine
Update-SessionEnvironment
