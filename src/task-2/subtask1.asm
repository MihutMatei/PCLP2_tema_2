%include "../include/io.mac"

; declare your structs here
struc event
    name:  resb 31
    valid: resb 1
    day:   resb 1
    month: resb 1
    year:  resw 1
endstruc

section .data
days_in_month db 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

section .text
    global check_events
    extern printf

check_events:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov     esi, [ebp + 8]      ; esi = events pointer
    mov     ecx, [ebp + 12]     ; ecx = number of events
    ;; DO NOT MODIFY

    ;; Your code starts here

    dec     ecx                 ; ecx was length → now index of last element
    mov     edi, ecx            ; edi = index (start from end)

.loop_iter_start:
    cmp     edi, -1
    jl      .loop_iter_end

    mov     ebx, edi
    imul    ebx, 36
    add     ebx, esi

    mov     byte [ebx + 31], 0     ; default: invalid

    ; year check
    movzx   eax, word [ebx + 34]
    cmp     eax, 1990
    jl      .next
    cmp     eax, 2030
    jg      .next

    ; month check
    movzx   edx, byte [ebx + 33]
    cmp     edx, 1
    jl      .next
    cmp     edx, 12
    jg      .next

    ; day check
    movzx   eax, byte [ebx + 32]   ; load day into eax
    cmp     eax, 1
    jl      .next
    mov     edx, eax               ; save the day into edx

    ; max days for month
    movzx   eax, byte [ebx + 33]   ; month
    dec     eax
    movzx   eax, byte [days_in_month + eax] ; max_day

    cmp     edx, eax               ; compare saved day with max_day
    jg      .next

    mov     byte [ebx + 31], 1     ; all checks passed → mark valid

.next:
    dec     edi
    jmp     .loop_iter_start

.after_check:
    dec     edi
    jmp     .loop_iter_start

.loop_iter_end:

    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
