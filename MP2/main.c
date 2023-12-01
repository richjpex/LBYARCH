#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <windows.h>

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
    int image_size_x, image_size_y, sampling_window_size;
    
    printf("=========================================\n");
    printf("Louis's and Rich's Image Average Filter\n");
	printf("A Machine Project for LBYARCH S15\n");
	printf("=========================================\n");
	Sleep(2);
	
    printf("\nEnter the number of rows for the matrix: ");
    scanf("%d", &image_size_x);

    printf("\nEnter the number of columns for the matrix: ");
    scanf("%d", &image_size_y);
    
    printf("\nEnter the sampling window size: ");
    scanf("%d", &sampling_window_size);

    int total_size = image_size_x * image_size_y;

    int original_image[image_size_x][image_size_y];
    int *input_image = (int *)original_image;
    int *filtered_image = malloc(image_size_x * image_size_y * sizeof(int));

    printf("\nEnter %d values in one line separated by spaces (%d x %d):\n", total_size, image_size_x, image_size_y);

    // Read the input values per line
    int i, j;
    for (i = 0; i < image_size_x; i++) {
        for (j = 0; j < image_size_y; j++) {
            scanf("%d", &original_image[i][j]);
        }
    }

    // Print original image
    printf("\nOriginal Image:\n");
    printMatrix(input_image, image_size_x, image_size_y);

    imgAvgFilter(input_image, filtered_image, image_size_x, image_size_y, sampling_window_size);

    // Print filtered image
    printf("Filtered Image:\n");
    printMatrix(filtered_image, image_size_x, image_size_y);
    
    printf("=========================================\n");
	printf("Thank you for using! :)\n");
	printf("=========================================\n");

    free(filtered_image);

    return 0;
}
