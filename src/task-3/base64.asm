%include "../include/io.mac"

extern printf
global base64

section .data
	alphabet db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
	fmt db "%d", 10, 0

section .text

base64:
	;; DO NOT MODIFY

    push ebp
    mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; source array
	mov ebx, [ebp + 12] ; n
	mov edi, [ebp + 16] ; dest array
	mov edx, [ebp + 20] ; pointer to dest length

	;; DO NOT MODIFY


	; -- Your code starts here --
    xor ecx, ecx          ; input index
    push edx              ; save dest_len pointer

.loop:
    cmp ecx, ebx
    jge .done

    ; Correctly load 3 bytes into 24-bit eax
    movzx eax, byte [esi + ecx]        ; b1
    shl eax, 16

    movzx edx, byte [esi + ecx + 1]    ; b2
    shl edx, 8
    or eax, edx

    movzx edx, byte [esi + ecx + 2]    ; b3
    or eax, edx                        ; eax = b1<<16 | b2<<8 | b3

    ; 1st character
    mov edx, eax
    shr edx, 18
    and edx, 0x3F
    movzx edx, byte [alphabet + edx]
    mov [edi], dl
    inc edi

    ; 2nd character
    mov edx, eax
    shr edx, 12
    and edx, 0x3F
    movzx edx, byte [alphabet + edx]
    mov [edi], dl
    inc edi

    ; 3rd character
    mov edx, eax
    shr edx, 6
    and edx, 0x3F
    movzx edx, byte [alphabet + edx]
    mov [edi], dl
    inc edi

    ; 4th character
    mov edx, eax
    and edx, 0x3F
    movzx edx, byte [alphabet + edx]
    mov [edi], dl
    inc edi

    add ecx, 3
    jmp .loop

.done:
    pop edx                ; restore pointer to dest_len
    mov eax, edi
    sub eax, [ebp + 16]    ; dest_len = edi - dest
    mov [edx], eax
	; -- Your code ends here --


	;; DO NOT MODIFY

	popa
	leave
	ret

	;; DO NOT MODIFY