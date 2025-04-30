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
    cmp     edi, -1             ; while edi >= 0
    jl      .loop_iter_end

    ; calculate pointer to current event
    mov     ebx, edi
    imul    ebx, 36             ; ebx = offset = index * sizeof(event)
    add     ebx, esi            ; ebx = address of current event

    ; default valid = 1 (note: this might be a mistake — see comment below)
    mov     byte [ebx + 31], 1

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

    ; day ≥ 1
    movzx   eax, byte [ebx + 32]
    cmp     eax, 1
    jl      .next

    ; max days for month
    mov     eax, edx
    dec     eax
    movzx   eax, byte [days_in_month + eax]

    cmp     esi, eax
    jg      .next

    ; all valid → set valid = 1
    mov     byte [ebx + 31], 1
    jmp     .after_check

.next:
    mov     byte [ebx + 31], 0

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
