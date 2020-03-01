New-Item C:\tools -ItemType Directory
Move-Item $env:chocolateyPackageFolder\tools C:\tools\chicken -Force
Install-ChocolateyEnvironmentVariable -VariableName "CHICKEN_PREFIX" -VariableValue "C:\tools\chicken" -VariableType Machine
Install-ChocolateyPath -PathToInstall "C:\tools\chicken\bin" -PathType Machine
Update-SessionEnvironment
