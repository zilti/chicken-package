Remove-Item -Recurse -Force "$(Get-ToolsLocation)\chicken"
Uninstall-ChocolateyEnvironmentVariable -VariableName "CHICKEN_PREFIX" -VariableType Machine
Update-SessionEnvironment
