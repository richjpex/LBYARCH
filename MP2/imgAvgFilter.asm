;Cada, Pecson - S15 - G10
section .text
global _imgAvgFilter

_imgAvgFilter:
    ; Parameter Initialization
    push ebp
    mov ebp, esp

    ; Input Image
    MOV esi, [ebp + 8]
    MOV dword [esp - 32], esi

    ; Output Image
    MOV esi, [ebp + 12]
    MOV dword [esp - 36], esi

    ; Image Dimensions
    MOV esi, [ebp + 16]
    MOV dword [esp - 40], esi

    ; Image Width
    MOV esi, [ebp + 20]
    MOV dword [esp - 44], esi

    ; Sample Window Size
    MOV esi, [ebp + 24]
    MOV dword [esp - 48], esi

    ; Precalculate half of sample window
    MOV eax, [esp - 48]
    sar eax, 1
    MOV [esp - 52], eax

    ; Clear eax
    XOR eax, eax

    MOV esi, 0
    main_row_loop:
        MOV edi, 0
        main_col_loop:
            ; Reset Sum
            MOV edx, 0

            ; Calculates offset for index
            MOV ecx, [esp - 44]
            IMUL ecx, esi
            ADD ecx, edi
            SAL ecx, 2

            MOV eax, [esp - 32]
            ADD eax, ecx

            MOV ebx, [esp - 36]
            ADD ebx, ecx

            ; eax and ebx contain an ADDress pointer to the start of each image
            MOV [esp - 56], eax
            MOV [esp - 60], ebx

            check_if_in_border:
            ; if x <= border - 1
            MOV eax, [esp - 52]
            DEC eax
            CMP edi, eax
            JLE not_in_border

            ; if x >= img_w - border 
            MOV eax, [esp - 44]
            SUB eax, [esp - 52]
            CMP edi, eax
            JGE not_in_border

            ; if y <= border - 1
            MOV eax, [esp - 52]
            DEC eax
            CMP esi, eax
            JLE not_in_border

            ; if y >= img_h - border
            MOV eax, [esp - 40]
            SUB eax, [esp - 52]
            CMP esi, eax
            JGE not_in_border

            JMP in_border

            ; If true handles calculation of average within borders
            in_border:
                MOV [esp - 64], edi
                MOV [esp - 68], esi

                ; sample_window iteration
                MOV ebx, [esp - 52]
                NEG ebx
                MOV esi, ebx ;sm_y
                inner_loop_col:
                    MOV ebx, [esp - 52]
                    NEG ebx
                    MOV edi, ebx ; sm_x
                    inner_loop_row:
                        MOV eax, [esp - 56]

                        ; input_image[(in_x + sm_x * 4) + (in_y + sm_y * img_w * 4)]

                        ; sm_x * 4
                        MOV ebx, edi
                        IMUL ebx, 4
                        ADD eax, ebx

                        MOV ebx, esi
                        IMUL ebx, [esp - 44]
                        IMUL ebx, 4
                        ADD eax, ebx

                        ADD edx, [eax]

                        INC edi
                        MOV ebx, [esp - 48]
                        DEC ebx
                        CMP edi, ebx
                        JL inner_loop_row

                    inner_loop_row_end:

                    INC esi
                    MOV ebx, [esp - 48]
                    DEC ebx
                    CMP esi, ebx
                    JL inner_loop_col

                inner_loop_col_end:

                MOV edi, [esp - 64]
                MOV esi, [esp - 68]

                XOR eax, eax

                MOV eax, edx
                XOR edx, edx

                MOV ebx, [esp - 48]
                IMUL ebx, ebx
                MOV ecx, ebx
                sar ecx, 1

                ADD eax, ecx

                DIV ebx

                ; EAX has Averaged Value
                MOV ebx, [esp - 60]
                MOV [ebx], eax

                JMP end_in_border

            not_in_border:
                MOV eax, [esp - 56]
                MOV ecx, [eax]

                MOV ebx, [esp - 60]
                MOV [ebx], ecx

                ; Clear eax, ebx
                XOR eax, eax
                XOR ebx, ebx

                JMP end_in_border

            end_in_border:
                ; Increment in_x
                INC edi
                MOV [esp - 64], edi

                MOV ecx, [esp - 44]
                CMP edi, ecx
                JL m_col_loop

        main_row_loop_end:

        INC esi
        MOV [esp - 68], esi

        MOV ecx, [esp - 40]
        CMP esi, ecx
        JL m_row_loop

    main_col_loop_end:
        xor eax, eax
        pop ebp
        ret
