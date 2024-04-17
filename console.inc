IFNDEF __CONSOLE__
__CONSOLE__ equ <1>

include window.inc

; =====================================================
; Pre:  
; Post: 
ConsoleSize proto

; =====================================================
; Pre:  
; Post: 
ConsoleInit proto

; =====================================================
; Pre:  
; Post: 
ConsoleDeInit proto

; =====================================================
; Pre:  
; Post: 
ConsoleDrawBufferArea proto xOff: WORD, yOff: WORD, xDim: WORD, yDim: WORD

; =====================================================
; Pre:  
; Post: 
ConsoleDrawBuffer proto

; =====================================================
; Pre:  
; Post: 
ConsoleMakeWindow proto pWin: ptr WINDOW, xOff: WORD, yOff: WORD, xDim: WORD, yDim: WORD

; =====================================================
; Pre:  
; Post: 
ConsoleDrawWindow proto pWin: ptr WINDOW

; =====================================================
; Pre:  
; Post: eax contains a boolean value 
ConsoleHasKeyInput proto

; =====================================================
; Pre:  
; Post: [pEvent] contains a key-down event
ConsoleNextKeyInput proto pEvent: ptr INPUT_RECORD

ENDIF