IFNDEF __SCN_BUFFER__
__SCN_BUFFER__ equ <1>

include global.inc

SCN_BUFFER struct
    Dims    COORD <>
    pPixels LPVOID ?
SCN_BUFFER ends


; =====================================================
; Pre:  pScnBuf != null
; Post: eax will store the length of the pixel array
ScnBufferPixelArrayLength proto pScnBuf: ptr SCN_BUFFER

; =====================================================
; Pre:  pScnBuf != null && dims.x != 0 && dims.y != 0
; Post: [pScnBuf] will be initialized
ScnBufferMake   proto pScnBuf: ptr SCN_BUFFER, xDim: WORD, yDim: WORD

; =====================================================
; Pre:  pScnBuf != null
; Post: [pScnBuf] will have it's dynamic elements freed
ScnBufferClean  proto pScnBuf: ptr SCN_BUFFER

; =====================================================
; Pre:  pScnBuf != null && y < [pScnBuf].Dims.y
; Post: eax will store address of the row's first elem
ScnBufferRowAt  proto pScnBuf: ptr SCN_BUFFER, yDim: WORD

; =====================================================
; Pre:  pScnBuf != null && pos < [pScnBuf].Dims
; Post: eax will store the address of the elem
ScnBufferAt     proto pScnBuf: ptr SCN_BUFFER, xDim: WORD, yDim: WORD

; =====================================================
; Pre:  pScnBuf != null
; Post: the buffer will be filled
ScnBufferFill   proto pScnBuf: ptr SCN_BUFFER, char: WORD, attr: WORD

ENDIF