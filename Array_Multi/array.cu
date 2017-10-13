#include <stdio.h>
#include <time.h>
#include <math.h>

const long N = pow(2,30);
const int blocksize = 16;

__global__
void GPU_multi(long *a, long *b) {
	a[threadIdx.x] *= b[threadIdx.x];
}

void CPU_multi(long *a, long *b) {
    for(long i = 0; i<N; i++){
        a[i] *= b[i];
    }
}


int main() {
    const long isize = N*sizeof(long);
    long *a = (long*) malloc(N*sizeof(long));
    long *b = (long*) malloc(N*sizeof(long));
    long *ad;
    long *bd;

    double cdiff = 0.0;
    double gdiff = 0.0;
    double gmdiff = 0.0;
    clock_t mstart, mstop, start, stop;

    for(long i = 0; i < N; i++){
        a[i] = i;
        b[i] = i;
    //    printf("%d ",a[i]);
    }
    //printf("\n");
    mstart = clock();
    cudaMalloc( (void**)&ad, isize );
    cudaMalloc( (void**)&bd, isize );

    cudaMemcpy( ad, a, isize, cudaMemcpyHostToDevice );
    cudaMemcpy( bd, b, isize, cudaMemcpyHostToDevice );

    dim3 dimBlock( blocksize, 1 );
    dim3 dimGrid( 1, 1 );
    start = clock();
    GPU_multi<<<dimGrid, dimBlock>>>(ad, bd);
    stop = clock();
    cudaMemcpy( a, ad, isize, cudaMemcpyDeviceToHost );
    cudaFree( ad );
    cudaFree( bd );
    mstop = clock();
   // for(int i = 0; i < N; i++){
   //     printf("%d ",a[i]);
   // }
   // printf("\n");

    gdiff = (double) (stop - start)/CLOCKS_PER_SEC;
    gmdiff = (double) (mstop - mstart)/CLOCKS_PER_SEC ;
    for(long i = 0; i < N; i++){
        a[i] = i;
        b[i] = i;
    //    printf("%d ",a[i]);
    }
    // printf("\n");
    start = clock();
    CPU_multi(a,b);
    //for(int i = 0; i < N; i++){
    //    printf("%d ",a[i]);
    //}
    //printf("\n");
    stop = clock();
    cdiff = (double) (stop - start)/CLOCKS_PER_SEC;

    printf("Completed GPU multiplication of %ld in %.8f seconds\n", N, gdiff);
    printf("Completed CPU multiplication of %ld in %.8f seconds\n", N, cdiff);
    printf("GPU Memory moving time done in %.8f seconds\n", gmdiff);
    free(a);
    free(b);
    return EXIT_SUCCESS;
}
