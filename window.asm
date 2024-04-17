include window.inc

.code

; =====================================================

WindowMake proc uses eax ebx ecx, pWinOut: ptr WINDOW, pScnBuf: ptr SCN_BUFFER, xOff: WORD, yOff: WORD, xDim: WORD, yDim: WORD
    mov eax, pWinOut
    mov ebx, pScnBuf
    
    ; Set screen buffer pointer
    mov [eax].WINDOW.pScnBuf, ebx

    ; Set offset
    mov cx, xOff
    mov [eax].WINDOW.Off.x, cx
    mov cx, yOff
    mov [eax].WINDOW.Off.y, cx

    ; Set Dims
    mov cx, xDim
    mov [eax].WINDOW.Dims.x, cx
    mov cx, yDim
    mov [eax].WINDOW.Dims.y, cx

    ret
WindowMake endp

; =====================================================

WindowSubWindow proc uses eax ebx ecx edx, pWinOut: ptr WINDOW, pParenWin: ptr WINDOW, xOff: WORD, yOff: WORD, xDim: WORD, yDim: WORD
    mov eax, pWinOut
    mov ebx, pParenWin

    ; Set offset
    mov cx, xOff
    mov dx, yOff
    add cx, [ebx].WINDOW.Off.x
    add dx, [ebx].WINDOW.Off.y
    mov [eax].WINDOW.Off.x, cx
    mov [eax].WINDOW.Off.y, dx

    ; Set Dims
    mov cx, xDim
    mov dx, yDim
    mov [eax].WINDOW.Dims.x, cx
    mov [eax].WINDOW.Dims.y, dx

    ; Set screen buffer pointer
    mov ecx, [ebx].WINDOW.pScnBuf
    mov [eax].WINDOW.pScnBuf, ecx

    ret
WindowSubWindow endp

; =====================================================

WindowRowAt proc uses ebx ecx, pWin: ptr WINDOW, yDim: WORD
    mov eax, pWin
    mov ebx, [eax].WINDOW.pScnBuf

    mov cx, yDim
    add cx, [eax].WINDOW.Off.y

    invoke ScnBufferAt, ebx, [eax].WINDOW.Off.x, cx

    ret
WindowRowAt endp

; =====================================================

WindowAt proc uses ebx ecx edx, pWin: ptr WINDOW, xPos: WORD, yPos: WORD
    mov eax, pWin
    mov ebx, [eax].WINDOW.pScnBuf

    mov cx, [eax].WINDOW.Off.x
    mov dx, [eax].WINDOW.Off.y

    add xPos, cx
    add yPos, dx

    invoke ScnBufferAt, ebx, xPos, yPos

    ret
WindowAt endp

; =====================================================

WindowFill proc uses eax ebx edx ecx esi edi, pWin: ptr WINDOW, char: WORD, attr: WORD
    local yStep: DWORD
    local xStep: DWORD

    mov ebx, pWin

    ; xStep = sizeof CHAR_INFO
    mov eax, sizeof CHAR_INFO
    mov xStep, eax

    ; yStep = xStep * Scnbuf.dim.x
    mov eax, [ebx].WINDOW.pScnBuf
    movzx eax, [eax].SCN_BUFFER.Dims.x
    mov ecx, xStep
    mul ecx
    mov yStep, eax

    ; esi = arr[0][0]
    invoke WindowRowAt, pWin, 0
    mov esi, eax
    
    ; edi = arr[dim.y][0]
    invoke WindowRowAt, pWin, [ebx].WINDOW.Dims.y
    mov edi, esi

    ; iterate rows
    .while (esi < edi)

        push edi
        push esi

        movzx eax, [ebx].WINDOW.Dims.x
        lea edi, [esi + eax * sizeof CHAR_INFO]

        ; iterate columns
        .while (esi < edi)
            mov ax, char
            mov [esi].CHAR_INFO.Char.UnicodeChar, ax

            mov ax, attr
            mov [esi].CHAR_INFO.Attributes, ax

            add esi, xStep
        .endw
        
        pop esi
        pop edi

        add esi, yStep
    .endw

    ret
WindowFill endp

end