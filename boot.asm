ResetSeg:
    org 0
    jmp Begin

Begin:
    mov ax, 0x07C0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, msg
    call PrintString

    jmp $

PrintCharacter:
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    ret

PrintString:
    next_character:
        lodsb
        or al, al
        jz done
        call PrintCharacter
        jmp next_character
    done:
        ret

msg db 'Hello, World!', 0

times 510-($-$$) db 0

dw 0xAA55