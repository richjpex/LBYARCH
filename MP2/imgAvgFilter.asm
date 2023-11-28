; Declare the function as global
global _imgAvgFilter

section .text
_imgAvgFilter:
    ; Function prologue: save the current base pointer and set a new base pointer
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

    ; Initialize loop counters and other variables
    mov dword [ebp-28], 0  ; i
    mov dword [ebp-24], 0  ; j
    mov dword [ebp-32], 0  ; k
    mov dword [ebp-36], 0  ; l

    ; Calculate the border for image processing
    mov eax, [ebp-4]
    mov ebx, 2
    div ebx
    dec eax
    mov [ebp-40], eax  ; border

image_row:
    ; Check if i >= image_size_x
    mov eax, [ebp-28]
    cmp eax, [ebp-12]
    jge end

    ; Reset j for a new row
    mov dword [ebp-24], 0  ; j

image_col:
    ; Check if j >= image_size_y
    mov eax, [ebp-24]
    cmp eax, [ebp-8]
    jge image_col_end

    ; Check if i is within the border
    mov eax, [ebp-28]
    cmp eax, [ebp-40]
    jle true

    ; Check if i > image_size_x - border
    mov ebx, [ebp-12]
    dec ebx
    sub ebx, [ebp-40]
    cmp eax, ebx
    jge true

    ; Check if j is within the border
    mov eax, [ebp-24]
    cmp eax, [ebp-40]
    jle true

    ; Check if j > image_size_y - border
    mov ebx, [ebp-8]
    dec ebx
    sub ebx, [ebp-40]
    cmp eax, ebx
    jge true

    jmp false

true:
    ; Calculate pixel offset in input_image and filtered_image
    mov eax, [ebp-28]
    mov ebx, [ebp-12]
    imul ebx
    add eax, [ebp-24]
    shl eax, 2
    mov esi, [ebp-20]
    add esi, eax

    mov edi, [ebp-16]
    add edi, eax

    ; Copy pixel value from input_image to filtered_image
    mov eax, [esi]
    mov [edi], eax
    jmp end_if_condition

false:
    ; Initialize variables for window sampling
    mov dword [ebp-44], 0  ; total
    mov dword [ebp-32], 0  ; k

image_row_sampling:
    ; Check if k >= sampling_window_size
    mov eax, [ebp-32]
    cmp eax, [ebp-4]
    jge image_row_sampling_end

    ; Initialize variables for window sampling in the column
    mov dword [ebp-36], 0  ; l

sample_window_col:
    ; Check if l >= sampling_window_size
    mov eax, [ebp-36]
    cmp eax, [ebp-4]
    jge sample_window_col_end

    ; Calculate the offset for window sampling in input_image
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

    ; Accumulate pixel values for window sampling
    mov eax, [ebp-44]  ; total
    add eax, [esi]
    mov [ebp-44], eax

    ; Increment l for the next column
    inc dword [ebp-36]
    jmp sample_window_col

sample_window_col_end:
    ; Increment k for the next row
    inc dword [ebp-32]
    jmp image_row_sampling

image_row_sampling_end:
    ; Calculate the average pixel value in the window
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

    ; Calculate the offset for updating the filtered_image
    mov ecx, eax
    mov eax, [ebp-28]
    mov ebx, [ebp-12]
    imul ebx
    add eax, [ebp-24]
    shl eax, 2
    mov edi, [ebp-16]  ; filtered_image_pointer
    add edi, eax

    ; Store the average pixel value in the filtered_image
    mov eax, ecx
    mov [edi], eax

end_if_condition:
    ; Increment j for the next column in the row
    mov eax, [ebp-24]
    inc eax
    mov [ebp-24], eax
    jmp image_col

image_col_end:
    ; Increment i for the next row
    mov eax, [ebp-28]
    inc eax
    mov [ebp-28], eax
    jmp image_row

end:
    mov esp, ebp
    pop ebp
    ret
