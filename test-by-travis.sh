#!/bin/bash

set -ev

if [ ${DOTNETCORE} -eq 1 ]
then
  dotnet restore ./GrEmit.sln --verbosity m
  dotnet tool restore
  dotnet build --configuration Release --framework netstandard2.0 ./GrEmit/GrEmit.csproj
  dotnet build --configuration Release --framework netcoreapp3.1 ./GrEmit.Tests/GrEmit.Tests.csproj
  dotnet jb cleanupcode GrEmit.sln --profile=CatalogueCleanup --verbosity=WARN
  git diff --exit-code
  dotnet test --no-build --configuration Release --framework netcoreapp3.1 ./GrEmit.Tests/GrEmit.Tests.csproj
else
  nuget install NUnit.ConsoleRunner -Version 3.9.0 -OutputDirectory testrunner
  msbuild /t:Restore ./GrEmit.sln
  msbuild /t:Build /p:Configuration=Release /p:TargetFramework=net45 ./GrEmit.sln
  mono ./testrunner/NUnit.ConsoleRunner.3.9.0/tools/nunit3-console.exe ./GrEmit.Tests/bin/Release/net45/GrEmit.Tests.dll
fi
