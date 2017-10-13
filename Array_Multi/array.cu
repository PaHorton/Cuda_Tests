#include <stdio.h>

const int N = 16;
const int blocksize = 16;

__global__
void multi(int *a, int *b)
{
	a[threadIdx.x] *= b[threadIdx.x];
}

int main()
{
    int a[N] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
    int b[N] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};

    int *ad;
    int *bd;

    const int isize = N*sizeof(int);

    for(int i = 0; i < N; i++){
        printf("%d ",a[i]);
    }
    printf("\n");

    cudaMalloc( (void**)&ad, isize );
	cudaMalloc( (void**)&bd, isize );

    cudaMemcpy( ad, a, isize, cudaMemcpyHostToDevice );
    cudaMemcpy( bd, b, isize, cudaMemcpyHostToDevice );

    dim3 dimBlock( blocksize, 1 );
    dim3 dimGrid( 1, 1 );
    multi<<<dimGrid, dimBlock>>>(ad, bd);

    cudaMemcpy( a, ad, isize, cudaMemcpyDeviceToHost );
    cudaFree( ad );
    cudaFree( bd );

    for(int i = 0; i < N; i++){
        printf("%d ",a[i]);
    }
    printf("\n");
}
