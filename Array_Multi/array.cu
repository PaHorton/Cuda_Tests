#include <stdio.h>
#include <time.h>

const int N = 16;
const int blocksize = 16;

__global__
void GPU_multi(int *a, int *b) {
	a[threadIdx.x] *= b[threadIdx.x];
}

void CPU_multi(int *a, int*b) {
    for(i = 0; i<N; i++){
        a[i] *= b[i]
    }
}


int main() {
    int a[N];
    int b[N];

    int *ad;
    int *bd;

    time_t start;
    time_t stop;

    const int isize = N*sizeof(int);

    for(int i = 0; i < N; i++){
        a[i] = i;
        b[i] = i;
        printf("%d ",a[i]);
    }
    printf("\n")
    time(&start);
    cudaMalloc( (void**)&ad, isize );
	cudaMalloc( (void**)&bd, isize );

    cudaMemcpy( ad, a, isize, cudaMemcpyHostToDevice );
    cudaMemcpy( bd, b, isize, cudaMemcpyHostToDevice );

    dim3 dimBlock( blocksize, 1 );
    dim3 dimGrid( 1, 1 );
    GPU_multi<<<dimGrid, dimBlock>>>(ad, bd);

    cudaMemcpy( a, ad, isize, cudaMemcpyDeviceToHost );
    cudaFree( ad );
    cudaFree( bd );

    for(int i = 0; i < N; i++){
        printf("%d ",a[i]);
    }
    printf("\n")
    time(&stop);
    diff = timediff(stop,start);
    printf("Completed GPU multiplication of %d in %d seconds\n", N, diff);

    for(int i = 0; i < N; i++){
        a[i] = i;
        b[i] = i;
        printf("%d ",a[i]);
    }
    printf("\n")
    time(&start);
    CPU_multi(a,b);
    for(int i = 0; i < N; i++){
        printf("%d ",a[i]);
    }
    printf("\n");
    time(&stop);
    diff = timediff(stop,start);
    printf("Completed CPU multiplication of %d in %d seconds\n", N, diff);
    return EXIT_SUCCESS;
}
