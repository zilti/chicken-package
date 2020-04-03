# Building
choco new chicken --version $Env:version --maintainername="'Daniel Ziltener'"
Remove-Item -Recurse -Force chicken\tools\
Remove-Item -Force chicken\ReadMe.md

# Copying files
$bindir="chicken\tools\bin"
New-Item $bindir -ItemType Directory
Copy-Item chickenbuild\LICENSE chicken\LICENSE.txt
Copy-Item VERIFICATION.txt chicken\VERIFICATION.txt
Copy-Item chickenbuild\*.exe $bindir
Copy-Item chickenbuild\*.bat $bindir
Copy-Item chickenbuild\*.dll $bindir
$includedir="chicken\tools\include\chicken"
New-Item $includedir -ItemType Directory
Copy-Item chickenbuild\chicken.h $includedir
Copy-Item chickenbuild\chicken-config.h $includedir
$linkerlibdir="chicken\tools\lib"
New-Item $linkerlibdir -ItemType Directory
Copy-Item chickenbuild\libchicken.a $linkerlibdir
Copy-Item chickenbuild\libchicken.dll.a $linkerlibdir
$extbindir="chicken\tools\lib\chicken\9"
New-Item $extbindir -ItemType Directory
Copy-Item chickenbuild\*.so $extbindir
Copy-Item chickenbuild\*.db $extbindir
$docdir="chicken\tools\share\chicken\doc"
New-Item $docdir -ItemType Directory
Copy-Item chickenbuild\chicken.png $docdir
Copy-Item chickenbuild\feathers.tcl $docdir
Copy-Item chickenbuild\LICENSE $docdir
Copy-Item chickenbuild\README $docdir
Copy-Item chickenbuild\manual-html $docdir\manual-html -Recurse

$man1dir="chicken\tools\man1"
New-Item $man1dir -ItemType Directory
Copy-Item chickenbuild\*.1 $man1dir

Copy-Item chickenbuild\setup.defaults chicken\tools\share\chicken

Copy-Item chocolateyInstall.ps1 .\chicken\
Copy-Item chocolateyUninstall.ps1 .\chicken\

# Create ignorefiles to prevent creation of shims
$files = get-childitem "chicken" -include *.exe -recurse
cd chicken
foreach ($file in $files) {
  #generate an ignore file
  New-Item "$file.ignore" -type file -force | Out-Null
}
cd ..
# Cleanup and packaging
Remove-Item -Recurse -Force chickenbuild
(Get-Content chicken.nuspec).replace("CHICKEN_VERSION", "$Env:version-$Env:build") | Set-Content chicken\chicken.nuspec
cd chicken
choco pack
cd ..
mv .\chicken\chicken.$Env:version.nupkg .\
