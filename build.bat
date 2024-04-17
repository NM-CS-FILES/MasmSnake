@echo off

    if exist "obj/*.obj" del "obj/*.obj"
    if exist "*.exe" del "*.exe"

    pushd obj
    \masm32\bin\ml /c /coff ../src/*.asm
    popd
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:console /ENTRY:start /OUT:snake.exe obj/*.obj
    if errorlevel 1 goto errlink
    dir "snake.*"
    goto TheEnd

  :errlink
    echo.
    echo Link error
    goto TheEnd

  :errasm
    echo.
    echo Assembly Error
    goto TheEnd
    
  :TheEnd
