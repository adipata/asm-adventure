section .data
    filename db 'testfile.txt', 0        ; Filename with null terminator
    mode db 'r', 0                       ; Mode for fopen (read mode)
    buffer times 10 db 0                 ; Buffer to store file contents

section .bss
    file_ptr resb 4                      ; Reserve space for file pointer

section .text
    global _start

    extern fopen
    extern fread
    extern fclose
    extern printf

_start:
    ; Open the file
    push dword mode                      ; Push mode ("r")
    push dword filename                  ; Push filename
    call fopen                           ; Call fopen
    add esp, 8                           ; Clean up the stack
    mov [file_ptr], eax                  ; Store the file pointer

    ; Read from the file
    push dword 10                        ; Number of bytes to read
    push dword 1                         ; Size of each element
    push dword buffer                    ; Buffer to store read data
    push dword [file_ptr]                ; File pointer
    call fread                           ; Call fread
    add esp, 16                          ; Clean up the stack

    ; Print the read content (for verification)
    push dword buffer                    ; Buffer to print
    call printf                          ; Call printf
    add esp, 4                           ; Clean up the stack

    ; Close the file
    push dword [file_ptr]                ; File pointer
    call fclose                          ; Call fclose
    add esp, 4                           ; Clean up the stack

    ; Exit the program
    mov eax, 1                           ; Syscall number (sys_exit)
    xor ebx, ebx                         ; Exit code 0
    int 0x80                             ; Call kernel
