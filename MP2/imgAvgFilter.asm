global _imgAvgFilter

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
    
section .data
    total dd 0

section .text
_imgAvgFilter:
    push ebp
    MOV ebp, esp

    ; Initializing variables
    MOV esi, [ebp+8]   ; input_image
    MOV dword [input_image_pointer], esi

    MOV esi, [ebp+12]  ; filtered_image
    MOV dword [filtered_image_pointer], esi

    MOV esi, [ebp+16]  ; image_size_x
    MOV dword [image_size_x], esi

    MOV esi, [ebp+20]  ; image_size_y
    MOV dword [image_size_y], esi

    MOV esi, [ebp+24]  ; sampling_window_size
    MOV dword [sampling_window_size], esi

    MOV dword [i], 0
    MOV dword [j], 0
    MOV dword [border], 0

    MOV eax, [sampling_window_size]
    MOV ebx, 2
    DIV ebx
    DEC eax
    MOV [border], eax

for_row:
    MOV eax, [i]
    CMP eax, [image_size_x]
    JGE for_row_end

    MOV dword [j], 0

for_col:
    MOV eax, [j]
    CMP eax, [image_size_y]
    JGE for_col_end

    MOV eax, [i]
    CMP eax, [border]
    JLE true_condition

    MOV ebx, [image_size_x]
    DEC ebx
    SUB ebx, [border]
    CMP eax, ebx
    JGE true_condition

    MOV eax, [j]
    CMP eax, [border]
    JLE true_condition

    MOV ebx, [image_size_y]
    DEC ebx
    SUB ebx, [border]
    CMP eax, ebx
    JGE true_condition

    JMP false_condition

    true_condition:
        MOV eax, [i]
        MOV ebx, [image_size_x]
        MUL ebx
        ADD eax, [j]
        SHL eax, 2
        MOV esi, [input_image_pointer]
        ADD esi, eax

        MOV edi, [filtered_image_pointer]
        ADD edi, eax

        MOV eax, [esi]
        MOV [edi], eax
        JMP end_if_condition

    false_condition:
        MOV dword [total], 0
        MOV dword [k], 0 

for_row_sampling:
        MOV eax, [k]
        CMP eax, [sampling_window_size]
        JGE for_row_sampling_end

        MOV dword [l], 0

for_col_sampling:
            MOV eax, [l]
            CMP eax, [sampling_window_size]
            JGE for_col_sampling_end

            MOV eax, [i]
            MOV ecx, [border]
            INC ecx
            SUB eax, ecx
            ADD eax, [k]
            MOV ebx, [image_size_x]
            MUL ebx
            MOV ebx, [j]
            SUB ebx, ecx
            ADD ebx, [l]
            ADD eax, ebx
            SHL eax, 2
            MOV esi, [input_image_pointer]
            ADD esi, eax

            MOV eax, [total]
            ADD eax, [esi]
            MOV [total], eax

            INC dword [l]
            JMP for_col_sampling

for_col_sampling_end:
        INC dword [k]
        JMP for_row_sampling

for_row_sampling_end:
        MOV eax, [sampling_window_size]
        MOV ebx, [sampling_window_size]
        MUL ebx
        MOV ebx, eax
        MOV eax, [total]
        MOV ecx, ebx
        shr ebx, 1
        ADD eax, ebx
        MOV ebx, ecx
        DIV ebx

        MOV ecx, eax
        MOV eax, [i]
        MOV ebx, [image_size_x]
        MUL ebx
        ADD eax, [j]
        SHL eax, 2
        MOV edi, [filtered_image_pointer]
        ADD edi, eax

        MOV eax, ecx
        MOV [edi], eax

end_if_condition:
        MOV eax, [j]
        INC eax
        MOV [j], eax
        JMP for_col

for_col_end:
    MOV eax, [i]
    INC eax
    MOV [i], eax
    JMP for_row

for_row_end:
    MOV esp, ebp
    pop ebp
    ret
