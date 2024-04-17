IFNDEF __GLOBAL__
__GLOBAL__ equ <1>

include \masm32\include\masm32rt.inc

; =====================================================
; Pre:  none
; Post: The error message will be displayed to Stdout
;       and the program will exit
FatalError  proto

; =====================================================
; Pre:  none
; Post: eax contains the summed COORD
CoordAdd proto c1: COORD, c2: COORD

ENDIF