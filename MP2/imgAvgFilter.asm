section .data
    sum dd 0

section .bss
    input_image_pointer resd 1
    filtered_image_pointer resd 1
    image_size_x resd 1
    image_size_y resd 1
    sampling_window_size resd 1
    border resd 1
    i resd 1
    j resd 1
    k resd 1
    l resd 1

section .text
global _imgAvgFilter

_imgAvgFilter:
    push ebp
    mov ebp, esp

    mov esi, [ebp+8]   ; input_image
    mov dword [input_image_pointer], esi
    mov esi, [ebp+12]  ; filtered_image
    mov dword [filtered_image_pointer], esi
    mov esi, [ebp+16]  ; image_size_x
    mov dword [image_size_x], esi
    mov esi, [ebp+20]  ; image_size_y
    mov dword [image_size_y], esi
    mov esi, [ebp+24]  ; sampling_window_size
    mov dword [sampling_window_size], esi

    mov dword [i], 0
    mov dword [j], 0
    mov dword [border], 0

    mov eax, [sampling_window_size]
    mov ebx, 2
    div ebx
    dec eax
    mov [border], eax

for_row:
    mov eax, [i]
    cmp eax, [image_size_x]
    jge for_row_end

    mov dword [j], 0

for_col:
    mov eax, [j]
    cmp eax, [image_size_y]
    jge for_col_end

    mov eax, [i]
    cmp eax, [border]
    jle true_condition

    mov ebx, [image_size_x]
    dec ebx
    sub ebx, [border]
    cmp eax, ebx
    jge true_condition

    mov eax, [j]
    cmp eax, [border]
    jle true_condition

    mov ebx, [image_size_y]
    dec ebx
    sub ebx, [border]
    cmp eax, ebx
    jge true_condition

    jmp false_condition

    true_condition:
        mov eax, [i]
        mov ebx, [image_size_x]
        mul ebx
        add eax, [j]
        shl eax, 2
        mov esi, [input_image_pointer]
        add esi, eax

        mov edi, [filtered_image_pointer]
        add edi, eax

        mov eax, [esi]
        mov [edi], eax
        jmp end_if_condition

    false_condition:
        mov dword [sum], 0
        mov dword [k], 0 

for_row_sampling:
        mov eax, [k]
        cmp eax, [sampling_window_size]
        jge for_row_sampling_end

        mov dword [l], 0

for_col_sampling:
            mov eax, [l]
            cmp eax, [sampling_window_size]
            jge for_col_sampling_end

            mov eax, [i]
            mov ecx, [border]
            inc ecx
            sub eax, ecx
            add eax, [k]
            mov ebx, [image_size_x]
            mul ebx
            mov ebx, [j]
            sub ebx, ecx
            add ebx, [l]
            add eax, ebx
            shl eax, 2
            mov esi, [input_image_pointer]
            add esi, eax

            mov eax, [sum]
            add eax, [esi]
            mov [sum], eax

            inc dword [l]
            jmp for_col_sampling

for_col_sampling_end:
        inc dword [k]
        jmp for_row_sampling

for_row_sampling_end:
        mov eax, [sampling_window_size]
        mov ebx, [sampling_window_size]
        mul ebx
        mov ebx, eax
        mov eax, [sum]
        mov ecx, ebx
        shr ebx, 1
        add eax, ebx
        mov ebx, ecx
        div ebx

        mov ecx, eax
        mov eax, [i]
        mov ebx, [image_size_x]
        mul ebx
        add eax, [j]
        shl eax, 2
        mov edi, [filtered_image_pointer]
        add edi, eax

        mov eax, ecx
        mov [edi], eax

end_if_condition:
        mov eax, [j]
        inc eax
        mov [j], eax
        jmp for_col

for_col_end:
    mov eax, [i]
    inc eax
    mov [i], eax
    jmp for_row

for_row_end:
    mov esp, ebp
    pop ebp
    ret
