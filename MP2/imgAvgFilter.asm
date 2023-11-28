global _imgAvgFilter

segment .data
    sum dd 0

segment .bss
    ; parameter variables
    input_image_pointer resd 1
    filtered_image_pointer resd 1
    image_size_x resd 1
    image_size_y resd 1
    sampling_window_size resd 1

    ; local variables
    border resd 1

    ; loop variables
    i resd 1
    j resd 1

    k resd 1
    l resd 1

segment .text
_imgAvgFilter:
    push ebp
    mov ebp, esp
    
    mov esi, [ebp+8] ; input_image
    mov dword [input_image_pointer], esi
    mov esi, [ebp+12] ; filtered_image
    mov dword [filtered_image_pointer], esi
    mov esi, [ebp+16] ; image_size_x
    mov dword [image_size_x], esi
    mov esi, [ebp+20] ; image_size_y
    mov dword [image_size_y], esi
    mov esi, [ebp+24] ; sampling_window_size
    mov dword [sampling_window_size], esi

    mov dword [i], 0 ; initialize i to 0
    mov dword [j], 0 ; initialize j to 0

    mov dword [border], 0 ; initialize border to 0
    mov eax, [sampling_window_size]
    mov ebx, 2
    div ebx
    dec eax
    mov [border], eax


for1:
    mov eax, [i]
    cmp eax, [image_size_x]
    jge for1_end

    mov dword [j], 0

    for2:
        mov eax, [j]
        cmp eax, [image_size_y]
        jge for2_end

        ; if conditions
        ; i <= 0
        mov eax, [i]
        cmp eax, [border]
        jle true

        ; i >= image_size_x - border - 1
        mov ebx, [image_size_x]
        dec ebx
        sub ebx, [border]
        cmp eax, ebx
        jge true

        ; j == 0
        mov eax, [j]
        cmp eax, [border]
        jle true

        ; j >= image_size_y - border - 1
        mov ebx, [image_size_y]
        dec ebx
        sub ebx, [border]
        cmp eax, ebx
        jge true

        jmp false
        ; if
        true:
            ; input_image[i * image_size_x + j]
            mov eax, [i]
            mov ebx, [image_size_x]
            mul ebx
            add eax, [j]
            shl eax, 2
            mov esi, [input_image_pointer]
            add esi, eax

            ; filtered_image[i * image_size_x + j]
            mov edi, [filtered_image_pointer]
            add edi, eax

            ; placing value of input_image into filtered
            mov eax, [esi]
            mov [edi], eax
            jmp end_if

        false:
            mov dword [sum], 0
            
            mov dword [k], 0 

            for3:
                mov eax, [k]
                cmp eax, [sampling_window_size]
                jge for3_end

                mov dword [l], 0

                for4:
                    mov eax, [l]
                    cmp eax, [sampling_window_size]
                    jge for4_end

                    ; input_image[(i-(border + 1) + k) * image_size_x + (j-(border + 1) + l)]
                    mov eax, [i] ; i
                    mov ecx, [border] ; border 
                    inc ecx ; + 1
                    sub eax, ecx ; i - (border + 1)
                    add eax, [k] ; + k
                    mov ebx, [image_size_x]
                    mul ebx ; * image_size_x
                    mov ebx, [j]
                    sub ebx, ecx ; j - (border + 1)
                    add ebx, [l]
                    add eax, ebx
                    shl eax, 2
                    mov esi, [input_image_pointer]
                    add esi, eax

                    ; sum += 
                    mov eax, [sum]
                    add eax, [esi]
                    mov [sum], eax

                    inc dword [l]
                    jmp for4

                for4_end:

                    inc dword [k]
                    jmp for3

            for3_end:
                ; sum / (sampling_window_size * sampling_window_size) with round to nearest, ties away from zero
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

                ; filtered_image[i * (image_size_x) + j]
                mov ecx, eax
                mov eax, [i]
                mov ebx, [image_size_x]
                mul ebx
                add eax, [j]
                shl eax, 2
                mov edi, [filtered_image_pointer]
                add edi, eax

                ; placing value of calculation into filtered_image
                mov eax, ecx
                mov [edi], eax
                jmp end_if

        end_if:
            mov eax, [j]
            inc eax
            mov [j], eax
            jmp for2

    for2_end:
        mov eax, [i]
        inc eax
        mov [i], eax
        jmp for1

for1_end:

    mov esp, ebp
    pop ebp
    ret
    

    