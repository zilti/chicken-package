Remove-Item -Recurse -Force "C:\tools\chicken"
Uninstall-ChocolateyEnvironmentVariable -VariableName "CHICKEN_PREFIX" -VariableType Machine
Update-SessionEnvironment
