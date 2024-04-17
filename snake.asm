include console.inc

; =====================================================

SNAKE_GAME_STATE struct
    ApplePos    COORD <>
    SnakeLen    DWORD ?
    Snake       COORD 100 dup(<>)
    Direction   BYTE  ?
SNAKE_GAME_STATE ends

; =====================================================


.data?
    ConsoleWindow   WINDOW <>
    SnakeWindow     WINDOW <>
    SnakeState      SNAKE_GAME_STATE <>
.code

; =====================================================

Initialize proc
    local off: COORD
    local dims: COORD

    invoke ConsoleInit

    invoke ConsoleSize
    mov dims, eax

    invoke ConsoleMakeWindow, offset ConsoleWindow, off.x, off.y, dims.x, dims.y
    invoke ConsoleMakeWindow, offset SnakeWindow, 0, 0, 42, 15

    ret
Initialize endp

; =====================================================

Deinitialize proc
    invoke ConsoleDeInit
    ret
Deinitialize endp

; =====================================================

Render proc
    invoke WindowFill, offset SnakeWindow, 35, FOREGROUND_GREEN
    invoke ConsoleDrawWindow, offset SnakeWindow
    ret
Render endp

; =====================================================

PollInput proc
    ret
PollInput endp

; =====================================================

GameStep proc
    ret
GameStep endp

; =====================================================

start:
    call main
    exit

main proc
    local rec: INPUT_RECORD
    local char: DWORD

    invoke Initialize

    invoke Render

    invoke Deinitialize
    invoke FatalError
    ret

main endp

end start
