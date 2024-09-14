; Bootloader
; 16-bit real mode
[bits 16]

; The BIOS loads the boot sector into memory at 0000:7C00h
[org 0x7C00]                

; Jump to the start of the bootloader
jmp 0000:Begin                  ; Far jump to the start of the bootloader

Begin:
    ; mov ax, 0x07C0              ; Set the data segment register to 07C0h
    ; mov ds, ax                  ; Set the data segment register
    ; mov ss, ax                  ; Set the stack segment register
    ; mov sp, 0x7C00              ; Set the stack pointer
    
    call GetSystemInfo          ; Get system information
    ; We are using Code Page 437
    
    mov si, strHello             ; Load the address of the message into SI
    call PrintString            ; Print the message

    call PrintCRLF              ; Print a new line

    mov si, strNums             ; Load the address of the numbers into SI
    call PrintString            ; Print the numbers

    call PrintCRLF              ; Print a new line



    mov si, strVideoMode    ; Load the address of the video mode message into SI
    call PrintString        ; Print the video mode message

    mov al, [videoMode]       ; Load the video mode into AL
    call DigiToAscii        ; Convert the video mode to ASCII
    call PrintCharacter     ; Print the video mode

    call PrintCRLF          ; Print a new line

    jmp $                       ; Infinite loop    

GetSystemInfo:
    call GetVideoMode           ; Get the current video mode
    mov [videoMode], al         ; Store the video mode in the videoMode variable
    ret

PrintCharacter:
    mov ah, 0x0E                ; Function OEh Write Character in TTY Mode
    mov bh, 0x00                ; Page Number
    mov bl, 0x07                ; Text Attribute
    int 0x10                    ; Call Video Interrupt
    ret

GetVideoMode:
    mov ah, 0x0F                ; Function 0Fh Get Video Mode
    int 0x10                    ; Call Video Interrupt
    ret

SetVideoMode:
    mov ah, 0x00                ; Function 00h Set Video Mode
    mov al, 0x04                ; Video Mode 03h
    int 0x10                    ; Call Video Interrupt
    ret

PrintCRLF:
    mov al, 0x0D                ; Carriage Return
    call PrintCharacter
    mov al, 0x0A                ; Line Feed
    call PrintCharacter
    ret

PrintCharacterWithStackSave:
    push ax
    push bx
    mov ah, 0x0E                ; Function OEh Write Character in TTY Mode
    mov bh, 0x00                ; Page Number
    mov bl, 0x07                ; Text Attribute
    int 0x10                    ; Call Video Interrupt
    pop bx
    pop ax
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

DigiToAscii:
    add al, 48                  ; Add 48 to convert to ASCII
    cmp al, 58                  ; Compare AL to 58
    jl skip                     ; Jump if less than 58
    add al, 7                   ; Add 7 to convert to letters A-F
    skip:
        ret 

PrintError:
    mov si, errSystemCall       ; Load the address of the error message into SI
    call PrintString            ; Print the error message
    jmp $                       ; Infinite loop
        
        
data:
    strHello db 'Hello, World!', 0

    strVideoMode db 'Current video mode: ', 0

    videoMode db 0

    errSystemCall db 'Error: System call failed', 0

    strNums db 48, 49, 50, 51, 52, 53, 54,  \
    55, 56, 57, 65, 66, 67, 68, 69, 70, 0
            
            
times 510-($-$$) db 0

dw 0xAA55