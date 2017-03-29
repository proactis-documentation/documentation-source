@echo off

if [%1]==[] goto usage

@echo on
docker run -it -v //C/proactis-documentation/documentation-source:/content -v //C/proactis-documentation/proactis-documentation.github.io:/proactis-documentation.github.io -p 8001:8000 proactis/mkdocs:1 build

@rem Push the generated site
PUSHD  C:\proactis-documentation\proactis-documentation.github.io
git add -A
git commit -m "%1"
git push
POPD

@rem Push the source code for the site
PUSHD  C:\proactis-documentation\documentation-source
git add -A
git commit -m "%1"
git push
POPD

goto :eof

:usage
@echo Usage: %0 CommitLabel
exit /B 1

:eof
exit /B 0