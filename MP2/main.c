#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern void imgAvgFilter(int* input_image, int* filtered_image, int image_size_x, int image_size_y, int sampling_window_size);

void printImage(int* image, int image_size_x, int image_size_y) {
    int i, j;
    for (i = 0; i < image_size_x; i++) {
        for (j = 0; j < image_size_y; j++) {
            printf("%d", image[i * image_size_y + j]);
            if (j < image_size_y - 1) {
                printf(" ");  // Print a space between values in the same row
            }
        }
        printf("\n");
    }
}

int main(int argc, char** argv) {
    int image_size_x, image_size_y;
    int sampling_window_size = 1;

    printf("Please enter the number of rows (image_size_x):\n");
    scanf("%d", &image_size_x);
    printf("Please enter the number of columns (image_size_y):\n");
    scanf("%d", &image_size_y);

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

    printf("Input Image:\n");
    printImage(input_image, image_size_x, image_size_y);
    printf("\nFiltered Image:\n");
    printImage(filtered_image, image_size_x, image_size_y);

    free(input_image);
    free(filtered_image);
    return 0;
}
