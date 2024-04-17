include global.inc

.code

; =====================================================

FatalError proc 
    local errCode: DWORD, pErrMsg: LPVOID

    ; Get error code
    invoke GetLastError
    mov errCode, eax

    ; Format error message
    mov pErrMsg, 0
    lea eax, pErrMsg
    invoke FormatMessage, (FORMAT_MESSAGE_ALLOCATE_BUFFER or \
            FORMAT_MESSAGE_FROM_SYSTEM or \
            FORMAT_MESSAGE_IGNORE_INSERTS), 0, errCode, 1024, eax, 0, 0

    .if (eax != 0)
        ; Print
        invoke StdOut, pErrMsg

        ; Free error message
        invoke LocalFree, pErrMsg
    .endif

    ; Exit
    invoke ExitProcess, errCode
    ret
FatalError endp

; =====================================================

CoordAdd proc c1: COORD, c2: COORD
    movzx eax, c1.x
    add ax, c2.x
    shl eax, 16
    mov ax, c1.y
    add ax, c2.y
    ret
CoordAdd endp

end