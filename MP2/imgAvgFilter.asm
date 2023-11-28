section .text
    global _imgAvgFilter

_imgAvgFilter:
    push ebp
    mov ebp, esp

    ; Function Parameters
    mov eax, [ebp + 8]        ; input_image
    mov ebx, [ebp + 12]       ; filtered_image
    mov ecx, [ebp + 16]       ; image_size_x
    mov edx, [ebp + 20]       ; image_size_y
    mov esi, [ebp + 24]       ; sampling_window_size

    ; Variables
    mov edi, 0                ; edi will be used for indexing

row_loop:
    ; Check if we have reached the end of rows
    cmp edi, ecx
    jge end_function

    ; Column loop
    mov esi, 0                ; reset esi for column indexing

column_loop:
    ; Check if we have reached the end of columns
    cmp esi, edx
    jge next_row

    ; Calculate the average value for the current pixel
    push eax                  ; save input_image pointer
    push ebx                  ; save filtered_image pointer
    push ecx                  ; save image_size_x
    push edx                  ; save image_size_y
    push esi                  ; save sampling_window_size

    ; Call a helper function to calculate the average
    call calculateAverage

    add esp, 20               ; cleanup stack

    ; Move to the next column
    inc esi
    jmp column_loop

next_row:
    ; Move to the next row
    inc edi
    jmp row_loop

end_function:
    pop ebp
    ret

calculateAverage:
    ; Function Parameters
    mov eax, [esp + 4]        ; input_image
    mov ebx, [esp + 8]        ; filtered_image
    mov ecx, [esp + 12]       ; image_size_x
    mov edx, [esp + 16]       ; image_size_y
    mov esi, [esp + 20]       ; sampling_window_size

    ; Variables
    mov edi, 0                ; sum of pixel values
    mov ebp, 0                ; count of pixels

    ; Loop through the sampling window
    mov esi, 0               ; start from the row above the current pixel
window_row_loop:
    cmp esi, 1
    jg window_end

    mov ecx, esi              ; set ecx to the current row offset

    mov edx, 0               ; start from the column left of the current pixel
window_col_loop:
    cmp edx, 1
    jg next_window_row

    ; Calculate the index of the current pixel in the input image
    mov eax, [esp + 4]        ; input_image
    mov ebx, [esp + 8]        ; filtered_image
    mov edi, [esp + 12]       ; image_size_x
    mov ebp, [esp + 16]       ; image_size_y
    mov esi, [esp + 20]       ; sampling_window_size
    imul ecx, edi
    add edx, ecx
    add edx, eax
    mov eax, edx   ; input_image[row_offset + col_offset]

    ; Add the pixel value to the sum
    add edi, eax

    ; Move to the next column in the window
    inc edx
    jmp window_col_loop

next_window_row:
    ; Move to the next row in the window
    inc esi
    jmp window_row_loop

window_end:
    ; Calculate the average value
    mov eax, edi
    cdq                      ; sign extend eax into edx:eax
    idiv ebp                 ; divide the sum by the count

    ; Store the average value in the filtered image
    mov [ebx], eax
    add ebx, 4               ; move to the next element in filtered_image

    ret
