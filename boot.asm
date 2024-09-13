; Bootloader
; 16-bit real mode
[bits 16]

; The BIOS loads the boot sector into memory at 0000:7C00h
[org 0x7C00]                

; Jump to the start of the bootloader
jmp Begin

Begin:
    mov si, msg                 ; Load the address of the message into SI
    call PrintString            ; Print the message

    jmp $                       ; Infinite loop    

PrintCharacter:
    mov ah, 0x0E                ; Function OEh Write Character in TTY Mode
    mov bh, 0x00                ; Page Number
    mov bl, 0x07                ; Text Attribute
    int 0x10                    ; Call Video Interrupt
    ret

PrintString:
    next_character:
        lodsb                   ; Load byte at address DS:SI into AL
        or al, al               ; Check if AL is zero
        jz done                 ; If zero, jump to done
        call PrintCharacter     ; Print the character in AL
        jmp next_character      ; Repeat for next character
    done:
        ret

msg db 'Hello, World!', 0x0D, 0x0A, 0

times 510-($-$$) db 0

dw 0xAA55