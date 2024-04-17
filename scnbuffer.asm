include scnbuffer.inc

.code

; =====================================================
; Pre:  pScnBuf != null, pScnBuf is not empty
; Post: eax contains the length of the pixels array
ScnBufferPixelArrayLength proc uses ebx ecx edx, pScnBuf: ptr SCN_BUFFER
    mov ebx, pScnBuf
    movzx eax, [ebx].SCN_BUFFER.Dims.x
    movzx ecx, [ebx].SCN_BUFFER.Dims.y
    mul ecx
    ret
ScnBufferPixelArrayLength endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScnBufferMake proc uses eax ebx ecx, pScnBuf:ptr SCN_BUFFER, xDim: WORD, yDim: WORD
    mov ebx, pScnBuf

    ; Copy over passed dimensions to buffer
    mov ax, xDim
    mov [ebx].SCN_BUFFER.Dims.x, ax
    mov ax, yDim
    mov [ebx].SCN_BUFFER.Dims.y, ax

    ; Allocate pixel array
    invoke ScnBufferPixelArrayLength, pScnBuf
    mov ecx, eax    
    invoke crt_calloc, ecx, sizeof CHAR_INFO
    mov [ebx].SCN_BUFFER.pPixels, eax

    ret
ScnBufferMake endp

; =====================================================
; Pre:  
; Post: 
ScnBufferClean proc uses eax ebx, pScnBuf: ptr SCN_BUFFER
    mov ebx, pScnBuf

    ; Reset size
    mov [ebx].SCN_BUFFER.Dims.x, 0
    mov [ebx].SCN_BUFFER.Dims.y, 0

    ; Free memory
    invoke crt_free, [ebx].SCN_BUFFER.pPixels
    mov [ebx].SCN_BUFFER.pPixels, 0

    .if (eax == 0)
        invoke FatalError
    .endif

    ret
ScnBufferClean endp

; =====================================================
; Pre:  a
; Post: eax contains the address of row y
ScnBufferRowAt proc uses ebx ecx, pScnBuf: ptr SCN_BUFFER, yDim: WORD
    mov ecx, pScnBuf

    ; eax = sz.X * at.Y * sz(CHAR_INFO)
    movzx eax, [ecx].SCN_BUFFER.Dims.x
    movzx ebx, yDim
    mul ebx
    mov ebx, sizeof CHAR_INFO
    mul ebx 

    ; ebx = eax + pPixels
    add eax, [ecx].SCN_BUFFER.pPixels

    ret
ScnBufferRowAt endp

; =====================================================
; Pre:  a
; Post: eax contains the address of the pixel at pos
ScnBufferAt proc uses ebx ecx, pScnBuf: ptr SCN_BUFFER, xDim: WORD, yDim: WORD
    invoke ScnBufferRowAt, pScnBuf, yDim
    
    mov ebx, eax
    movzx eax, xDim
    mov ecx, sizeof CHAR_INFO
    mul ecx
    add eax, ebx

    ret
ScnBufferAt endp

; =====================================================
; Pre:  pScnBuf is not null and not empty
; Post: pScnBuf is filled with the CHAR_INFO { char, attr }  
ScnBufferFill proc uses eax ebx ecx edx, pScnBuf: ptr SCN_BUFFER, char: WORD, attr: WORD
    ; eax = sizeof pScnBuf->pPixels
    mov ecx, pScnBuf
    mov eax, sizeof CHAR_INFO
    movzx ebx, [ecx].SCN_BUFFER.Dims.x
    mul ebx
    movzx ebx, [ecx].SCN_BUFFER.Dims.y
    mul ebx

    mov ebx, [ecx].SCN_BUFFER.pPixels
    add eax, ebx

    ; eax = &arr[n]
    ; ebx = &arr[0]

    .while (ebx < eax)
        mov cx, attr
        mov [ebx].CHAR_INFO.Attributes, cx

        mov cx, char
        mov [ebx].CHAR_INFO.Char.UnicodeChar, cx

        add ebx, sizeof CHAR_INFO
    .endw

    ret
ScnBufferFill endp

end