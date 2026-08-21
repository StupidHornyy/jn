; qcd.asm — an minimalist cd, uses asm btw(aura starts flowing)
section .text
    global _start

_start:
    ; Layout [rsp]=argc [rsp+8]=argv[0] [rsp+16]=argv[1]
    pop     rax                 ; rax = argc
    cmp     rax, 1
    je      .use_default        ; jn

    pop     rax                 ; descart argv[0]
    pop     rsi                 ; rsi = argv[1] 
    jmp     .validate

.use_default:
    mov     rsi, default_path

.validate:
    mov     rdi, rsi             ; rdi = caminho (1º arg de stat)
    sub     rsp, 144             ; buffer to struct stat
    mov     rsi, rsp             ; rsi = buffer (2º arg de stat)
    mov     rax, 4               ; syscall 4 = sys_stat
    syscall

    test    rax, rax            ; rax < 0 => erro (ex.: ENOENT)
    js      .exit_error

    mov     eax, [rsp + 24]      ; struct stat: st_mode fica no offset 24
    and     eax, 0xF000          ; mask S_IFMT
    cmp     eax, 0x4000          ; is S_IFDIR?
    jne     .exit_error          ; exists, but is not an directory -> error

    ; rdi
    mov     rbx, rdi
.count_loop:
    cmp     byte [rbx], 0
    je      .print
    inc     rbx
    jmp     .count_loop

.print:
    sub     rbx, rdi             ; rbx = string
    mov     rdx, rbx             ; rdx = count
    mov     rsi, rdi             ; rsi = ponteir string
    mov     rdi, 1               ; rdi = stdout
    mov     rax, 1               ; syscall 1 = sys_write
    syscall

.exit_clean:
    xor     edi, edi             ; status 0
    mov     rax, 60
    syscall

.exit_error:
    mov     edi, 1               ; status 1
    mov     rax, 60
    syscall

section .rodata
default_path:
    db "/", 0                    ; idk why is this there

; larp larp larp larp    
