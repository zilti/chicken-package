#Set-Variable -Name "version" -Value "4.12.0"
#$version = '5.2.0'
#$binaryversion=11

# Fetching and unpacking remote files
Install-Module -Name 7Zip4Powershell -Force -Scope CurrentUser
choco install -y msys2
Invoke-WebRequest -UseBasicParsing -Uri "https://code.call-cc.org/releases/$version/chicken-$version.tar.gz" -OutFile '.\chicken.tar.gz'
#Expand-7Zip chicken.tar.gz -TargetPath '.\'
#Expand-7Zip chicken.tar -TargetPath '.\'
7z x chicken.tar.gz
7z x chicken.tar
Remove-Item -Force chicken.tar.gz
Remove-Item -Force chicken.tar
mv chicken-* chickenbuild

# Building
C:\tools\msys64\usr\bin\bash.exe --login -c 'pacboy -Sy --needed --noconfirm binutils:x make:x gcc:x gettext:x readline:x'
$env:Path+=";C:\tools\msys64\mingw64\bin"
mingw32-make.exe -C chickenbuild PLATFORM=mingw ARCH=x86-64 PREFIX=C:/tools/chicken
choco new chicken --version $version --maintainername="'Daniel Ziltener'"
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
(Get-Content chicken.nuspec).replace("CHICKEN_VERSION", "$version") | Set-Content chicken\chicken.nuspec
cd chicken
choco pack
cd ..
mv .\chicken\chicken.$version.nupkg .\
