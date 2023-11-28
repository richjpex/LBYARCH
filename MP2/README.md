## How to compile program
```
nasm -f win32 imgAvgFilter.asm

gcc -c main.c -o main.obj -m32

gcc main.obj imgAvgFilter.obj -o main.exe -m32

main.exe```

## Pseudocode
```
function imgAvgFilter(input_image, filtered_image, image_size_x, image_size_y, sampling_window_size):
    border = (sampling_window_size - 1) / 2
    
    for i in range(image_size_x):
        for j in range(image_size_y):
            if border < i < (image_size_x - border - 1) and border < j < (image_size_y - border - 1):
                filtered_image[i, j] = input_image[i, j]
            else:
                sum = 0
                for k in range(sampling_window_size):
                    for l in range(sampling_window_size):
                        sum += input_image[i - (border + 1) + k, j - (border + 1) + l]
                
                average = round(sum / (sampling_window_size * sampling_window_size))
                filtered_image[i, j] = average

    return filtered_image```
