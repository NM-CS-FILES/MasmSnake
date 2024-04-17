include console.inc

.data?
    ConsoleOutHdl       HANDLE ?
    ConsoleInHdl        HANDLE ?
    ConsoleScnBuffer    SCN_BUFFER <>

.code

; =====================================================

ConsoleSize proc uses ebx
    ; [==============EAX===============]
    ; [=======X=======][=======Y=======]
    local csbi: CONSOLE_SCREEN_BUFFER_INFO
    local dims: COORD

    invoke GetConsoleScreenBufferInfo, ConsoleOutHdl, addr csbi

    .if (eax == 0)
        invoke FatalError
    .endif

    movzx eax, csbi.srWindow.Bottom
    sub ax, csbi.srWindow.Top
    inc eax

    movzx ebx, csbi.srWindow.Right
    sub bx, csbi.srWindow.Left
    inc ebx

    mov dims.x, bx
    mov dims.y, ax

    mov eax, dims
    ret
ConsoleSize endp

; =====================================================

ConsoleInit proc uses eax ebx
    local dims: COORD

    ; Set output handle
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov ConsoleOutHdl, eax

    .if (eax == 0)
        invoke FatalError
    .endif

    ; Set input handle
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov ConsoleInHdl, eax

    .if (eax == 0)
        invoke FatalError
    .endif
    
    ; Init screen buffer
    invoke ConsoleSize
    mov dims, eax
    invoke ScnBufferMake, offset ConsoleScnBuffer, dims.x, dims.y

    ret
ConsoleInit endp

; =====================================================

ConsoleDeInit proc
    invoke ScnBufferClean, offset ConsoleScnBuffer
    ret
ConsoleDeInit endp

; =====================================================

ConsoleDrawBufferArea proc uses eax ebx ecx, xOff: WORD, yOff: WORD, xDim: WORD, yDim: WORD
    local writeRegion: SMALL_RECT

    mov ax, xOff
    mov writeRegion.Left, ax
    mov writeRegion.Right, ax

    mov ax, yOff
    mov writeRegion.Top, ax
    mov writeRegion.Bottom, ax

    mov ax, xDim
    dec ax
    add writeRegion.Right, ax

    mov ax, yDim
    dec ax
    add writeRegion.Bottom, ax

    mov ebx, ConsoleScnBuffer.Dims
    mov ecx, 0

    invoke WriteConsoleOutput, ConsoleOutHdl, ConsoleScnBuffer.pPixels, \
            ebx, ecx, addr writeRegion

    .if (eax == 0)
        invoke FatalError
    .endif

    ret
ConsoleDrawBufferArea endp

; =====================================================

ConsoleDrawBuffer proc
    local off: COORD
    xor eax, eax
    mov off, eax

    invoke ConsoleDrawBufferArea, off.x, off.y, \
            ConsoleScnBuffer.Dims.x, ConsoleScnBuffer.Dims.y 

    ret
ConsoleDrawBuffer endp

; =====================================================

ConsoleMakeWindow proc pWin: ptr WINDOW, xOff: WORD, yOff: WORD, xDim: WORD, yDim: WORD
    invoke WindowMake, pWin, offset ConsoleScnBuffer, xOff, yOff, xDim, yDim
    ret
ConsoleMakeWindow endp

; =====================================================

ConsoleDrawWindow proc uses eax pWin: ptr WINDOW
    mov eax, pWin

    invoke ConsoleDrawBufferArea, [eax].WINDOW.Off.x, [eax].WINDOW.Off.y, \
            [eax].WINDOW.Dims.x, [eax].WINDOW.Dims.y
    
    ret
ConsoleDrawWindow endp

; =====================================================

ConsoleHasKeyInput proc
    local inputRecord: INPUT_RECORD
    local read: DWORD

inputRecordReadBegin:
    invoke PeekConsoleInput, ConsoleInHdl, addr inputRecord, 1, addr read

    .if (eax == 0)
        invoke FatalError
    .endif 

    ; break if nothing was read
    mov eax, read
    .if (eax == 0)
        jmp inputRecordReadEnd
    .endif

    ; break if event is from keyboard
    movzx eax, inputRecord.EventType
    .if (eax == KEY_EVENT)
        jmp inputRecordReadEnd
    .endif

    ; read input and continue
    invoke ReadConsoleInput, ConsoleInHdl, addr inputRecord, 1, addr read

    jmp inputRecordReadBegin
inputRecordReadEnd:
    ret
ConsoleHasKeyInput endp

; =====================================================

ConsoleNextKeyInput proc uses eax ebx, pEvent: ptr INPUT_RECORD
    local read: DWORD
    mov ebx, pEvent

readNext:
    invoke ReadConsoleInput, ConsoleInHdl, ebx, 1, addr read
    .if (eax == 0)
        invoke FatalError
    .endif

    ; nothing was read, continue
    mov eax, read
    .if (eax == 0)
        jmp readNext
    .endif

    ; not key event, continue
    movzx eax, [ebx].INPUT_RECORD.EventType
    .if (eax != KEY_EVENT)
        jmp readNext
    .endif

    ; key was un-pressed, continue
    mov eax, [ebx].INPUT_RECORD.KeyEvent.bKeyDown
    .if (eax == 0)
        jmp readNext
    .endif

    ret
ConsoleNextKeyInput endp

end