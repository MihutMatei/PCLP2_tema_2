%include "../include/io.mac"

extern printf
global remove_numbers

section .data
    fmt db "%d", 10, 0

section .text

; function signature: 
; void remove_numbers(int *a, int n, int *target, int *ptr_len);

remove_numbers:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     esi, [ebp + 8]    ; source array pointer
    mov     ebx, [ebp + 12]   ; n
    mov     edi, [ebp + 16]   ; destination array pointer
    mov     ecx, [ebp + 20]   ; pointer to dest length (store in ecx to preserve it)

    ;; DO NOT MODIFY
    ;; Your code starts here
    
    ; First pass: filter out odd numbers
    xor     edx, edx          ; edx := i = 0
    xor     eax, eax          ; eax := j = 0

filter_loop:
    cmp     edx, ebx          ; if i >= n, exit first loop
    jge     filter_done

    mov     ebp, [esi + edx*4] ; ebp := a[i]
    test    ebp, 1             ; test oddness
    jnz     skip_filter_copy

    mov     [edi + eax*4], ebp ; target[j] := a[i]
    inc     eax                ; j++

skip_filter_copy:
    inc     edx                ; i++
    jmp     filter_loop

filter_done:
    mov     [ecx], eax         ; *ptr_len = j

    ; Prepare for second pass
    mov     ebx, eax           ; ebx := length of filtered list
    xor     edx, edx           ; edx := i = 0
    xor     esi, esi           ; esi := k = 0

    ; Second pass: remove powers of two
remove_check:
    cmp     edx, ebx           ; if i >= filtered count, done
    jge     remove_end

    mov     ebp, [edi + edx*4] ; ebp := target[i]
    test    ebp, ebp           ; if ebp == 0
    jz      do_copy            ; zero is not a power of two, keep it

    mov     eax, ebp
    dec     eax                ; eax := ebp - 1
    and     eax, ebp           ; compute (ebp & (ebp - 1))
    jnz     do_copy            ; if nonzero, not a power of two, keep it

    ; it's a power of two—skip it
    inc     edx                ; i++
    jmp     remove_check

do_copy:
    mov     [edi + esi*4], ebp ; target[k] := target[i]
    inc     esi                ; k++
    inc     edx                ; i++
    jmp     remove_check

remove_end:
    mov     eax, esi           ; eax := k
    mov     [ecx], eax         ; *ptr_len = k
	;; Your code ends here
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
