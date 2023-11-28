section .text
global _imgAvgFilter

_imgAvgFilter:
    ; Parameter Initialization
    push ebp
    mov ebp, esp

    ; Input Image
    mov esi, [ebp + 8]
    mov dword [esp - 32], esi

    ; Output Image
    mov esi, [ebp + 12]
    mov dword [esp - 36], esi

    ; Image Dimensions
    mov esi, [ebp + 16]
    mov dword [esp - 40], esi

    ; Image Width
    mov esi, [ebp + 20]
    mov dword [esp - 44], esi

    ; Sample Window Size
    mov esi, [ebp + 24]
    mov dword [esp - 48], esi

    ; Precalculate half of sample window
    mov eax, [esp - 48]
    sar eax, 1
    mov [esp - 52], eax

    ; Clear eax
    xor eax, eax

    mov esi, 0
    main_row_loop:
        mov edi, 0
        main_col_loop:
            ; Reset Sum
            mov edx, 0

            ; Calculates offset for index
            mov ecx, [esp - 44]
            imul ecx, esi
            add ecx, edi
            sal ecx, 2

            mov eax, [esp - 32]
            add eax, ecx

            mov ebx, [esp - 36]
            add ebx, ecx

            ; eax and ebx contain an address pointer to the start of each image
            mov [esp - 56], eax
            mov [esp - 60], ebx

            check_if_in_border:
            ; if x <= border - 1
            mov eax, [esp - 52]
            dec eax
            cmp edi, eax
            jle not_in_border

            ; if x >= img_w - border 
            mov eax, [esp - 44]
            sub eax, [esp - 52]
            cmp edi, eax
            jge not_in_border

            ; if y <= border - 1
            mov eax, [esp - 52]
            dec eax
            cmp esi, eax
            jle not_in_border

            ; if y >= img_h - border
            mov eax, [esp - 40]
            sub eax, [esp - 52]
            cmp esi, eax
            jge not_in_border

            jmp in_border

            ; If true handles calculation of average within borders
            in_border:
                mov [esp - 64], edi
                mov [esp - 68], esi

                ; sample_window iteration
                mov ebx, [esp - 52]
                neg ebx
                mov esi, ebx ;sm_y
                inner_loop_col:
                    mov ebx, [esp - 52]
                    neg ebx
                    mov edi, ebx ; sm_x
                    inner_loop_row:
                        mov eax, [esp - 56]

                        ; input_image[(in_x + sm_x * 4) + (in_y + sm_y * img_w * 4)]

                        ; sm_x * 4
                        mov ebx, edi
                        imul ebx, 4
                        add eax, ebx

                        mov ebx, esi
                        imul ebx, [esp - 44]
                        imul ebx, 4
                        add eax, ebx

                        add edx, [eax]

                        inc edi
                        mov ebx, [esp - 48]
                        dec ebx
                        cmp edi, ebx
                        jl inner_loop_row

                    inner_loop_row_end:

                    inc esi
                    mov ebx, [esp - 48]
                    dec ebx
                    cmp esi, ebx
                    jl inner_loop_col

                inner_loop_col_end:

                mov edi, [esp - 64]
                mov esi, [esp - 68]

                xor eax, eax

                mov eax, edx
                xor edx, edx

                mov ebx, [esp - 48]
                imul ebx, ebx
                mov ecx, ebx
                sar ecx, 1

                add eax, ecx

                div ebx

                ; EAX has Averaged Value
                mov ebx, [esp - 60]
                mov [ebx], eax

                jmp end_in_border

            not_in_border:
                mov eax, [esp - 56]
                mov ecx, [eax]

                mov ebx, [esp - 60]
                mov [ebx], ecx

                ; Clear eax, ebx
                xor eax, eax
                xor ebx, ebx

                jmp end_in_border

            end_in_border:
                ; Increment in_x
                inc edi
                mov [esp - 64], edi

                mov ecx, [esp - 44]
                cmp edi, ecx
                jl m_col_loop

        main_row_loop_end:

        inc esi
        mov [esp - 68], esi

        mov ecx, [esp - 40]
        cmp esi, ecx
        jl m_row_loop

    main_col_loop_end:
        xor eax, eax
        pop ebp
        ret
