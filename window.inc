IFNDEF __WINDOW__
__WINDOW__ equ <1>

include scnbuffer.inc

WINDOW struct
    Dims    COORD <>
    Off     COORD <>
    pScnBuf LPVOID ?
WINDOW ends

; =====================================================
; Pre:  pScnBuf != null && pWinOut != null
; Post: [pWinOut] will be filled with proper fields
WindowMake proto pWinOut: ptr WINDOW, pScnBuf: ptr SCN_BUFFER, xOff: WORD, yOff: WORD, xDim: WORD, yDim: WORD

; =====================================================
; Pre:  pParentWin != null && pWinOut != null
; Post: [pWinOut] will be filled with proper fields
WindowSubWindow proto pWinOut: ptr WINDOW, pParenWin: ptr WINDOW, xOff: WORD, yOff: WORD, xDim: WORD, yDim: WORD

; =====================================================
; Pre:  pWin != null, y < [pWin].Dims.y
; Post: eax will store the address of the row
WindowRowAt proto pWin: ptr WINDOW, yDim: WORD

; =====================================================
; Pre:  
; Post: eax will store the address of the element
WindowAt proto pWin: ptr WINDOW, xPos: WORD, yPos: WORD

; =====================================================
; Pre:  
; Post: 
WindowFill proto pWin: ptr WINDOW, char: WORD, attr: WORD

ENDIF