#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void imgAvgFilter(int* input_image, int* filtered_image, int image_size_x, int image_size_y, int sampling_window_size) {
    int i, j, k, l;
    for (i = 0; i < image_size_x; i++) {
        for (j = 0; j < image_size_y; j++) {
            // If the pixel is on the edge, copy the original value
            if (i == 0 || i == image_size_x - 1 || j == 0 || j == image_size_y - 1) {
                filtered_image[i * image_size_y + j] = input_image[i * image_size_y + j];
                continue;
            }

            // If the pixel is not on the edge, apply the average filter
            int sum = 0;
            int count = 0;
            for (k = -sampling_window_size; k <= sampling_window_size; k++) {
                for (l = -sampling_window_size; l <= sampling_window_size; l++) {
                    int x = i + k;
                    int y = j + l;
                    if (x >= 0 && x < image_size_x && y >= 0 && y < image_size_y) {
                        sum += input_image[x * image_size_y + y];
                        count++;
                    }
                }
            }
            // Use round to round the average to the nearest integer
            filtered_image[i * image_size_y + j] = round((double)sum / count);
        }
    }
}



void printImage(int* image, int image_size_x, int image_size_y) {
    int i, j;
    for (i = 0; i < image_size_x; i++) {
        for (j = 0; j < image_size_y; j++) {
            printf("%d ", image[i * image_size_y + j]);
        }
        printf("\n");
    }
}

int main(int argc, char** argv) {
    int image_size_x = 6;
    int image_size_y = 6;
    int sampling_window_size = 1;
    int* input_image = (int*)malloc(image_size_x * image_size_y * sizeof(int));
    int* filtered_image = (int*)malloc(image_size_x * image_size_y * sizeof(int));

    printf("Please enter the image data in one line:\n");
    int i, j;
    for (i = 0; i < image_size_x; i++) {
        for (j = 0; j < image_size_y; j++) {
            scanf("%d", &input_image[i * image_size_y + j]);
        }
    }

    imgAvgFilter(input_image, filtered_image, image_size_x, image_size_y, sampling_window_size);
    printImage(input_image, image_size_x, image_size_y);
    printf("\n");
    printImage(filtered_image, image_size_x, image_size_y);
    free(input_image);
    free(filtered_image);
    return 0;
}
