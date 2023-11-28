global _imgAvgFilter

section .text
_imgAvgFilter:
    push ebp
    MOV ebp, esp

    ; Initializing variables
    MOV esi, [ebp+8]   ; input_image
    MOV dword [ebp-20], esi  ; input_image_pointer

    MOV esi, [ebp+12]  ; filtered_image
    MOV dword [ebp-16], esi  ; filtered_image_pointer

    MOV esi, [ebp+16]  ; image_size_x
    MOV dword [ebp-12], esi  ; image_size_x

    MOV esi, [ebp+20]  ; image_size_y
    MOV dword [ebp-8], esi  ; image_size_y

    MOV esi, [ebp+24]  ; sampling_window_size
    MOV dword [ebp-4], esi  ; sampling_window_size

    ; Initialize loop counters and other variables
    MOV dword [ebp-28], 0  ; i
    MOV dword [ebp-24], 0  ; j
    MOV dword [ebp-32], 0  ; k
    MOV dword [ebp-36], 0  ; l

    ; Calculate the border for image processing
    MOV eax, [ebp-4]
    MOV ebx, 2
    div ebx
    DEC eax
    MOV [ebp-40], eax  ; border

image_row:
    ; Check if i >= image_size_x
    MOV eax, [ebp-28]
    CMP eax, [ebp-12]
    JGE end

    ; Reset j for a new row
    MOV dword [ebp-24], 0  ; j

image_col:
    ; Check if j >= image_size_y
    MOV eax, [ebp-24]
    CMP eax, [ebp-8]
    JGE image_col_end

    ; Check if i is within the border
    MOV eax, [ebp-28]
    CMP eax, [ebp-40]
    JLE true

    ; Check if i > image_size_x - border
    MOV ebx, [ebp-12]
    DEC ebx
    SUB ebx, [ebp-40]
    CMP eax, ebx
    JGE true

    ; Check if j is within the border
    MOV eax, [ebp-24]
    CMP eax, [ebp-40]
    JLE true

    ; Check if j > image_size_y - border
    MOV ebx, [ebp-8]
    DEC ebx
    SUB ebx, [ebp-40]
    CMP eax, ebx
    JGE true

    JMP false

true:
    ; Calculate pixel offset in input_image and filtered_image
    MOV eax, [ebp-28]
    MOV ebx, [ebp-12]
    IMUL ebx
    ADD eax, [ebp-24]
    SHL eax, 2
    MOV esi, [ebp-20]
    ADD esi, eax

    MOV edi, [ebp-16]
    ADD edi, eax

    ; Copy pixel value from input_image to filtered_image
    MOV eax, [esi]
    MOV [edi], eax
    JMP end_if_condition

false:
    ; Initialize variables for window sampling
    MOV dword [ebp-44], 0  ; total
    MOV dword [ebp-32], 0  ; k

image_row_sampling:
    ; Check if k >= sampling_window_size
    MOV eax, [ebp-32]
    CMP eax, [ebp-4]
    JGE image_row_sampling_end

    ; Initialize variables for window sampling in the column
    MOV dword [ebp-36], 0  ; l

sample_window_col:
    ; Check if l >= sampling_window_size
    MOV eax, [ebp-36]
    CMP eax, [ebp-4]
    JGE sample_window_col_end

    ; Calculate the offset for window sampling in input_image
    MOV eax, [ebp-28]
    MOV ecx, [ebp-40]
    INC ecx
    SUB eax, ecx
    ADD eax, [ebp-32]
    MOV ebx, [ebp-12]
    IMUL ebx
    MOV ebx, [ebp-24]
    SUB ebx, ecx
    ADD ebx, [ebp-36]
    ADD eax, ebx
    SHL eax, 2
    MOV esi, [ebp-20]  ; input_image_pointer
    ADD esi, eax

    ; Accumulate pixel values for window sampling
    MOV eax, [ebp-44]  ; total
    ADD eax, [esi]
    MOV [ebp-44], eax

    ; Increment l for the next column
    INC dword [ebp-36]
    JMP sample_window_col

sample_window_col_end:
    ; Increment k for the next row
    INC dword [ebp-32]
    JMP image_row_sampling

image_row_sampling_end:
    ; Calculate the average pixel value in the window
    MOV eax, [ebp-4]
    MOV ebx, [ebp-4]
    IMUL ebx
    MOV ebx, eax
    MOV eax, [ebp-44]  ; total
    MOV ecx, ebx
    shr ebx, 1
    ADD eax, ebx
    MOV ebx, ecx
    div ebx

    ; Calculate the offset for updating the filtered_image
    MOV ecx, eax
    MOV eax, [ebp-28]
    MOV ebx, [ebp-12]
    IMUL ebx
    ADD eax, [ebp-24]
    SHL eax, 2
    MOV edi, [ebp-16]  ; filtered_image_pointer
    ADD edi, eax

    ; Store the average pixel value in the filtered_image
    MOV eax, ecx
    MOV [edi], eax

end_if_condition:
    ; Increment j for the next column in the row
    MOV eax, [ebp-24]
    INC eax
    MOV [ebp-24], eax
    JMP image_col

image_col_end:
    ; Increment i for the next row
    MOV eax, [ebp-28]
    INC eax
    MOV [ebp-28], eax
    JMP image_row

end:
    MOV esp, ebp
    pop ebp
    ret
