;;MIHUTMATEI311CA
%include "../include/io.mac"

; declare your structs here
struc date
    .day:    resb 1
    .month:  resb 1
    .year:   resw 1
endstruc
struc event
    .name:   resb 31
    .valid:  resb 1
    .date:  resb 4
endstruc

section .text
    global sort_events
    extern printf

sort_events:
    ;; DO NOT MODIFY
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]      ; events
    mov ecx, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
    xor esi, esi              ; i = 0

.outer_loop:
    mov eax, [ebp + 12]       ; length
    dec eax
    cmp esi, eax
    jge .end_sort

    mov edi, esi
    inc edi                   ; j = i + 1

.inner_loop:
    mov eax, [ebp + 12]
    cmp edi, eax
    jge .next_outer

    mov ebx, [ebp + 8]        ; events base pointer

    ; edx = &events[i]
    mov eax, esi
    imul eax, 36
    add eax, ebx
    mov edx, eax              ; edx = addr_i

    ; ecx = &events[j]
    mov eax, edi
    imul eax, 36
    add eax, ebx
    mov ecx, eax              ; ecx = addr_j

    ; compare valid flags
    mov al, [edx + 31]        ; valid flag of events[i]
    mov bl, [ecx + 31]        ; valid flag of events[j]
    cmp al, bl
    jl .do_swap               ; swap if valid[i] < valid[j]
    jg .next_compare          ; skip if valid[i] > valid[j]

    ; compare years
    movzx eax, word [edx + 34] ; year of events[i]
    movzx ebx, word [ecx + 34] ; year of events[j]
    cmp eax, ebx
    jg .do_swap               ; swap if year[i] < year[j]
    jl .next_compare          ; skip if year[i] > year[j]

    ; compare months
    movzx eax, byte [edx + 33] ; month of events[i]
    movzx ebx, byte [ecx + 33] ; month of events[j]
    cmp eax, ebx
    jg .do_swap               ; swap if month[i] < month[j]
    jl .next_compare          ; skip if month[i] > month[j]

    ; compare days
    movzx eax, byte [edx + 32] ; day of events[i]
    movzx ebx, byte [ecx + 32] ; day of events[j]
    cmp eax, ebx
    jg .do_swap               ; swap if day[i] < day[j]
    jl .next_compare          ; skip if day[i] > day[j]

    ; compare names
    xor eax, eax
.name_loop:
    mov dl, [edx + eax]       ; char from name[i]
    mov bl, [ecx + eax]       ; char from name[j]

    cmp dl, 0
    jne .check_bl
    cmp bl, 0
    je .next_compare          ; both end → equal → no swap
    jmp .do_swap              ; i ends first → i < j → do not swap

.check_bl:
    cmp bl, 0
    je .next_compare          ; j ends first → j < i → don't swap

    cmp dl, bl
    jl .next_compare
    jg .do_swap

    inc eax
    jmp .name_loop

.do_swap:
    push esi
    push edi
    push ecx
    push edx

    mov esi, edx      ; esi = addr_i
    mov edi, ecx      ; edi = addr_j
    mov ecx, 36       ; swap 36 bytes

.swap_loop:
    mov al, [esi]
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jnz .swap_loop

    pop edx
    pop ecx
    pop edi
    pop esi


.next_compare:
    inc edi
    jmp .inner_loop

.next_outer:
    inc esi
    jmp .outer_loop

.end_sort:
    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
