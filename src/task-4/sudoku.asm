;;MIHUTMATEI311CA
%include "../include/io.mac"

extern printf
global check_row
global check_column
global check_box

section .data
	frequency db 9 dup(0) ; Frequency array to count occurrences of numbers 1-9

section .text

; Function: check_row
; Purpose: Checks if a given row in the Sudoku grid contains all numbers 1-9 exactly once.
; Arguments:
;   - char* sudoku: Pointer to the 81-character Sudoku grid
;   - int row: Row index to check
check_row:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx
	push esi
	push edi

	mov esi, [ebp + 8] ; Load pointer to Sudoku grid
	mov edx, [ebp + 12] ; Load row index
	;; DO NOT MODIFY

	;; Calculate the starting address of the row
	xor ecx, ecx
	imul edx, 9 ; row * 9
	add esi, edx

.row_populate_loop:
	cmp ecx, 9 ; Loop through all 9 cells in the row
	jge .end_row_populate_loop
	movzx eax, byte [esi + ecx] ; Load the current cell value
	cmp eax, 1 ; Check if value is >= 1
	jb .wrong
	cmp eax, 9 ; Check if value is <= 9
	ja .wrong
	dec eax ; Adjust value to 0-based index
	inc byte [frequency + eax] ; Increment frequency count
	inc ecx
	jmp .row_populate_loop

.end_row_populate_loop:
	xor ecx, ecx

.row_check_loop:
	cmp ecx, 9 ; Verify that each number appears exactly once
	jge .ok
	movzx eax, byte [frequency + ecx]
	cmp eax, 1
	jne .wrong
	inc ecx
	jmp .row_check_loop

.ok:
	mov eax, 1 ; Row is valid
	jmp .clear_frequency

.wrong:
	mov eax, 2 ; Row is invalid

.clear_frequency:
	xor ecx, ecx
.clear_loop:
	cmp ecx, 9 ; Reset frequency array
	jge end_check_row
	mov byte [frequency + ecx], 0
	inc ecx
	jmp .clear_loop

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

; Function: check_column
; Purpose: Checks if a given column in the Sudoku grid contains all numbers 1-9 exactly once.
; Arguments:
;   - char* sudoku: Pointer to the 81-character Sudoku grid
;   - int column: Column index to check
check_column:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx
	push esi
	push edi

	mov esi, [ebp + 8] ; Load pointer to Sudoku grid
	mov edx, [ebp + 12] ; Load column index
	;; DO NOT MODIFY

	;; Populate frequency array for the column
	xor ecx, ecx
.col_populate_loop:
	cmp ecx, 9 ; Loop through all 9 cells in the column
	jge .end_col_populate_loop
	mov eax, ecx
	imul eax, 9 ; Calculate offset for the current row
	add eax, edx
	add eax, esi
	movzx eax, byte [eax] ; Load the current cell value
	cmp eax, 1 ; Check if value is >= 1
	jb .wrong
	cmp eax, 9 ; Check if value is <= 9
	ja .wrong
	dec eax ; Adjust value to 0-based index
	inc byte [frequency + eax] ; Increment frequency count
	inc ecx
	jmp .col_populate_loop

.end_col_populate_loop:
	xor ecx, ecx

.col_check_loop:
	cmp ecx, 9 ; Verify that each number appears exactly once
	jge .ok
	movzx eax, byte [frequency + ecx]
	cmp eax, 1
	jne .wrong
	inc ecx
	jmp .col_check_loop

.ok:
	mov eax, 1 ; Column is valid
	jmp .clear_frequency

.wrong:
	mov eax, 2 ; Column is invalid

.clear_frequency:
	xor ecx, ecx
.clear_loop:
	cmp ecx, 9 ; Reset frequency array
	jge end_check_column
	mov byte [frequency + ecx], 0
	inc ecx
	jmp .clear_loop

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

; Function: check_box
; Purpose: Checks if a given 3x3 box in the Sudoku grid contains all numbers 1-9 exactly once.
; Arguments:
;   - char* sudoku: Pointer to the 81-character Sudoku grid
;   - int box: Box index (0-8) to check
check_box:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx
	push esi
	push edi

	mov esi, [ebp + 8] ; Load pointer to Sudoku grid
	mov edx, [ebp + 12] ; Load box index
	;; DO NOT MODIFY

	;; Calculate the top-left index of the box
	mov eax, edx
	xor edx, edx
	mov ebx, 3
	div ebx ; eax = row group, edx = col group
	imul eax, 27 ; 3 rows * 9 cols = 27
	imul edx, 3 ; 3 columns
	add eax, edx
	mov ebx, eax ; Base index for the box
	xor ecx, ecx

.box_populate_loop:
	cmp ecx, 9 ; Loop through all 9 cells in the box
	jge .end_box_populate_loop
	mov eax, ecx
	xor edx, edx
	mov edi, 3
	div edi ; eax = row offset, edx = col offset
	imul eax, 9 ; Calculate row offset
	add eax, edx ; Add column offset
	add eax, ebx ; Add base index
	add eax, esi
	movzx eax, byte [eax] ; Load the current cell value
	cmp eax, 1 ; Check if value is >= 1
	jb .wrong
	cmp eax, 9 ; Check if value is <= 9
	ja .wrong
	dec eax ; Adjust value to 0-based index
	inc byte [frequency + eax] ; Increment frequency count
	inc ecx
	jmp .box_populate_loop

.end_box_populate_loop:
	xor ecx, ecx

.box_check_loop:
	cmp ecx, 9 ; Verify that each number appears exactly once
	jge .ok
	movzx eax, byte [frequency + ecx]
	cmp eax, 1
	jne .wrong
	inc ecx
	jmp .box_check_loop

.ok:
	mov eax, 1 ; Box is valid
	jmp .clear_frequency

.wrong:
	mov eax, 2 ; Box is invalid

.clear_frequency:
	xor ecx, ecx
.clear_loop:
	cmp ecx, 9 ; Reset frequency array
	jge end_check_box
	mov byte [frequency + ecx], 0
	inc ecx
	jmp .clear_loop

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
