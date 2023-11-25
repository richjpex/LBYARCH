section .text
global imgAvgFilter

imgAvgFilter:
    ; Function prologue
    push ebp
    mov ebp, esp

    ; Parameters
    ; [ebp + 8]  : input_image
    ; [ebp + 12] : filtered_image
    ; [ebp + 16] : image_size_x
    ; [ebp + 20] : image_size_y
    ; [ebp + 24] : sampling_window_size

    mov eax, [ebp + 16]      ; image_size_x
    mov ebx, [ebp + 20]      ; image_size_y
    mov ecx, [ebp + 24]      ; sampling_window_size
    mov esi, [ebp + 8]       ; input_image
    mov edi, [ebp + 12]      ; filtered_image

    ; Loop through each pixel
    xor edx, edx             ; Initialize outer loop counter

    outer_loop:
        xor ecx, ecx         ; Initialize inner loop counter

        inner_loop:
            mov ebp, 0       ; Clear sum accumulator

            ; Loop through the sampling window
            mov edi, ecx
            sampling_window_loop:
                mov esi, edx
                add esi, [ebp + 16]  ; image_size_x

                add esi, [ebp + 8]   ; input_image + (i + k) * image_size_y

                mov eax, [esi]       ; input_image[i + k][j + l]
                add ebp, eax         ; sum += input_image[i + k][j + l]

                inc edi
                cmp edi, [ebp + 24]  ; Compare with sampling_window_size
                jle sampling_window_loop

            ; Calculate average and store in filtered_image[i][j]
            mov eax, [ebp + 24]  ; sampling_window_size
            imul eax, eax        ; square the window size
            idiv eax             ; divide sum by window size squared

            mov [edi + edx], al  ; store result in filtered_image[i * image_size_y + j]

            inc ecx
            cmp ecx, ebx         ; Compare with image_size_y
            jle inner_loop

        inc edx
        cmp edx, eax         ; Compare with image_size_x
        jle outer_loop

    ; Function epilogue
    pop ebp
    ret
