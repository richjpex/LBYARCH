#include <stdio.h>
#include <stdlib.h>

extern void imgAvgFilter(int* input_image, int* filtered_image, int image_size_x, int image_size_y, int sampling_window_size) {
    for (int i = 0; i < image_size_x; i++) {
        for (int j = 0; j < image_size_y; j++) {
            int sum = 0;
            int count = 0;
            for (int k = -sampling_window_size; k <= sampling_window_size; k++) {
                for (int l = -sampling_window_size; l <= sampling_window_size; l++) {
                    int x = i + k;
                    int y = j + l;
                    if (x >= 0 && x < image_size_x && y >= 0 && y < image_size_y) {
                        sum += input_image[x * image_size_y + y];
                        count++;
                    }
                }
            }
            filtered_image[i * image_size_y + j] = sum / count;
        }
    }
}

void printImage(int* image, int image_size_x, int image_size_y) {
    for (int i = 0; i < image_size_x; i++) {
        for (int j = 0; j < image_size_y; j++) {
            printf("%d ", image[i * image_size_y + j]);
        }
        printf("\n");
    }
}
