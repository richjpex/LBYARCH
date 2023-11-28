#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern void imgAvgFilter(int *input_image, int *filtered_image, int image_size_x, int image_size_y, int sampling_window_size);

void printMatrix(int *matrix, int rows, int cols) {
    int i, j;
    for (i = 0; i < rows; i++) {
        for (j = 0; j < cols; j++) {
            printf("%d ", matrix[i * cols + j]);
        }
        printf("\n");
    }
    printf("\n");
}

int main() {
    int image_size_x = 6, image_size_y = 6;
    int total_size = image_size_x * image_size_y;

    int original_image[image_size_x][image_size_y];
    int *input_image = (int *)original_image;
    int *filtered_image = malloc((image_size_x) * (image_size_y) * sizeof(int));

    printf("Enter %d values in one line separated by spaces (%d x %d):\n", total_size, image_size_x, image_size_y);

    // Read the input values in a single line
    int i;
    for (i = 0; i < total_size; i++) {
        scanf("%d", &original_image[0][i]);
    }

    // Print original image
    printf("Original Image:\n");
    printMatrix(input_image, image_size_x, image_size_y);

    imgAvgFilter(input_image, filtered_image, image_size_x, image_size_y, 3);

    // Print filtered image
    printf("Filtered Image:\n");
    printMatrix(filtered_image, image_size_x, image_size_y);

    free(input_image);
    free(filtered_image);

    return 0;
}