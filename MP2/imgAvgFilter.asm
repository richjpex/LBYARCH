global _imgAvgFilter

section .text
_imgAvgFilter:
    push ebp
    mov ebp, esp

    ; Initializing variables
    mov esi, [ebp+8]   ; input_image
    mov dword [ebp-20], esi  ; input_image_pointer

    mov esi, [ebp+12]  ; filtered_image
    mov dword [ebp-16], esi  ; filtered_image_pointer

    mov esi, [ebp+16]  ; image_size_x
    mov dword [ebp-12], esi  ; image_size_x

    mov esi, [ebp+20]  ; image_size_y
    mov dword [ebp-8], esi  ; image_size_y

    mov esi, [ebp+24]  ; sampling_window_size
    mov dword [ebp-4], esi  ; sampling_window_size

    mov dword [ebp-28], 0  ; i
    mov dword [ebp-24], 0  ; j
    mov dword [ebp-32], 0  ; k
    mov dword [ebp-36], 0  ; l

    mov eax, [ebp-4]
    mov ebx, 2
    div ebx
    dec eax
    mov [ebp-40], eax  ; window_size_border

image_row:
    mov eax, [ebp-28]
    cmp eax, [ebp-12]
    jge image_row_end

    mov dword [ebp-24], 0  ; j

image_col:
    mov eax, [ebp-24]
    cmp eax, [ebp-8]
    jge image_col_end

    mov eax, [ebp-28]
    cmp eax, [ebp-40]
    jle true

    mov ebx, [ebp-12]
    dec ebx
    sub ebx, [ebp-40]
    cmp eax, ebx
    jge true

    mov eax, [ebp-24]
    cmp eax, [ebp-40]
    jle true

    mov ebx, [ebp-8]
    dec ebx
    sub ebx, [ebp-40]
    cmp eax, ebx
    jge true

    jmp false

true:
    mov eax, [ebp-28]
    mov ebx, [ebp-12]
    imul ebx
    add eax, [ebp-24]
    shl eax, 2
    mov esi, [ebp-20]  ; input_image_pointer
    add esi, eax

    mov edi, [ebp-16]  ; filtered_image_pointer
    add edi, eax

    mov eax, [esi]
    mov [edi], eax
    jmp end_if_condition

false:
    mov dword [ebp-44], 0  ; total
    mov dword [ebp-32], 0  ; k

image_row_sampling:
    mov eax, [ebp-32]
    cmp eax, [ebp-4]
    jge image_row_sampling_end

    mov dword [ebp-36], 0  ; l

sample_window_col:
    mov eax, [ebp-36]
    cmp eax, [ebp-4]
    jge sample_window_col_end

    mov eax, [ebp-28]
    mov ecx, [ebp-40]
    inc ecx
    sub eax, ecx
    add eax, [ebp-32]
    mov ebx, [ebp-12]
    imul ebx
    mov ebx, [ebp-24]
    sub ebx, ecx
    add ebx, [ebp-36]
    add eax, ebx
    shl eax, 2
    mov esi, [ebp-20]  ; input_image_pointer
    add esi, eax

    mov eax, [ebp-44]  ; total
    add eax, [esi]
    mov [ebp-44], eax

    inc dword [ebp-36]
    jmp sample_window_col

sample_window_col_end:
    inc dword [ebp-32]
    jmp image_row_sampling

image_row_sampling_end:
    mov eax, [ebp-4]
    mov ebx, [ebp-4]
    imul ebx
    mov ebx, eax
    mov eax, [ebp-44]  ; total
    mov ecx, ebx
    shr ebx, 1
    add eax, ebx
    mov ebx, ecx
    div ebx

    mov ecx, eax
    mov eax, [ebp-28]
    mov ebx, [ebp-12]
    imul ebx
    add eax, [ebp-24]
    shl eax, 2
    mov edi, [ebp-16]  ; filtered_image_pointer
    add edi, eax

    mov eax, ecx
    mov [edi], eax

end_if_condition:
    mov eax, [ebp-24]
    inc eax
    mov [ebp-24], eax
    jmp image_col

image_col_end:
    mov eax, [ebp-28]
    inc eax
    mov [ebp-28], eax
    jmp image_row

image_row_end:
    mov esp, ebp
    pop ebp
    ret
