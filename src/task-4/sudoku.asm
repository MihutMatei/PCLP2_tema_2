%include "../include/io.mac"

extern printf
global check_row
global check_column
global check_box
; you can declare any helper variables in .data or .bss

section .data
    frequency db 9 dup(0) ; frequency array for numbers 1-9

section .text


; int check_row(char* sudoku, int row);
check_row:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov     esi, [ebp + 8]  ; char* sudoku, pointer to 81-long char array
    mov     edx, [ebp + 12]  ; int row 
    ;; DO NOT MODIFY
   
    ;; Freestyle starts here
    xor ecx, ecx
    imul edx, 9 ; row * 9
    add esi, edx
.row_populate_loop:
    cmp ecx, 9
    jge .end_row_populate_loop
    movzx eax, byte [esi + ecx]
    cmp eax, 1
    jb .wrong
    cmp eax, 9
    ja .wrong
    dec eax
    inc byte [frequency + eax]
    inc ecx
    jmp .row_populate_loop    
.end_row_populate_loop:

    xor ecx, ecx
.row_check_loop:
    cmp ecx, 9
    jge .ok
    movzx eax, byte [frequency + ecx]
    cmp eax, 1
    jne .wrong
    inc ecx
    jmp .row_check_loop
.ok:
    mov eax, 1
    jmp .clear_frequency
.wrong:
    mov eax, 2

.clear_frequency:
    xor ecx, ecx
.clear_loop:
    cmp ecx, 9
    jge end_check_row
    mov byte [frequency + ecx], 0
    inc ecx
    jmp .clear_loop

    ;; MAKE SURE TO LEAVE YOUR RESULT IN EAX BY THE END OF THE FUNCTION
    ;; Remember: OK = 1, NOT_OKAY = 2
    ;; ex. if this row is okay, by this point eax should contain the value 1 

    ;; Freestyle ends here
end_check_row:
    ;; DO NOT MODIFY

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret
    
    ;; DO NOT MODIFY

; int check_column(char* sudoku, int column);
check_column:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov     esi, [ebp + 8]  ; char* sudoku, pointer to 81-long char array
    mov     edx, [ebp + 12]  ; int column 
    ;; DO NOT MODIFY
   
    ;; Freestyle starts here

    xor ecx, ecx
.col_populate_loop:
    cmp ecx, 9
    jge .end_col_populate_loop
    mov eax, ecx
    imul eax, 9
    add eax, edx
    add eax, esi
    movzx eax, byte [eax]
    cmp eax, 1
    jb .wrong
    cmp eax, 9
    ja .wrong
    dec eax
    inc byte [frequency + eax]
    inc ecx
    jmp .col_populate_loop    
.end_col_populate_loop:

    xor ecx, ecx
.col_check_loop:
    cmp ecx, 9
    jge .ok
    movzx eax, byte [frequency + ecx]
    cmp eax, 1
    jne .wrong
    inc ecx
    jmp .col_check_loop
.ok:
    mov eax, 1
    jmp .clear_frequency
.wrong:
    mov eax, 2

.clear_frequency:
    xor ecx, ecx
.clear_loop:
    cmp ecx, 9
    jge end_check_column
    mov byte [frequency + ecx], 0
    inc ecx
    jmp .clear_loop

    ;; MAKE SURE TO LEAVE YOUR RESULT IN EAX BY THE END OF THE FUNCTION
    ;; Remember: OK = 1, NOT_OKAY = 2
    ;; ex. if this column is okay, by this point eax should contain the value 1 

    ;; Freestyle ends here
end_check_column:
    ;; DO NOT MODIFY

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret
    
    ;; DO NOT MODIFY


; int check_box(char* sudoku, int box);
check_box:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov     esi, [ebp + 8]  ; char* sudoku, pointer to 81-long char array
    mov     edx, [ebp + 12]  ; int box 
    ;; DO NOT MODIFY
   
    ;; Freestyle starts here

    ; compute top-left index of box
    mov eax, edx
    xor edx, edx
    mov ebx, 3
    div ebx                ; eax = row group, edx = col group
    imul eax, 27           ; 3 rows * 9 cols = 27
    imul edx, 3
    add eax, edx
    mov ebx, eax           ; base index for box
    xor ecx, ecx
.box_populate_loop:
    cmp ecx, 9
    jge .end_box_populate_loop
    mov eax, ecx
    xor edx, edx
    mov edi, 3
    div edi                ; eax = row offset, edx = col offset
    imul eax, 9
    add eax, edx
    add eax, ebx
    add eax, esi
    movzx eax, byte [eax]
    cmp eax, 1
    jb .wrong
    cmp eax, 9
    ja .wrong
    dec eax
    inc byte [frequency + eax]
    inc ecx
    jmp .box_populate_loop
.end_box_populate_loop:

    xor ecx, ecx
.box_check_loop:
    cmp ecx, 9
    jge .ok
    movzx eax, byte [frequency + ecx]
    cmp eax, 1
    jne .wrong
    inc ecx
    jmp .box_check_loop
.ok:
    mov eax, 1
    jmp .clear_frequency
.wrong:
    mov eax, 2

.clear_frequency:
    xor ecx, ecx
.clear_loop:
    cmp ecx, 9
    jge end_check_box
    mov byte [frequency + ecx], 0
    inc ecx
    jmp .clear_loop

    ;; MAKE SURE TO LEAVE YOUR RESULT IN EAX BY THE END OF THE FUNCTION
    ;; Remember: OK = 1, NOT_OKAY = 2
    ;; ex. if this box is okay, by this point eax should contain the value 1 

    ;; Freestyle ends here
end_check_box:
    ;; DO NOT MODIFY

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret
    
    ;; DO NOT MODIFY
