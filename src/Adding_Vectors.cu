#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define N 10


__global__ void add(int *a,int *b,int *c ) {

	int tid = blockIdx.x;
	printf("Executing on %d\n",tid);
	if(tid<N){
		c[tid] = a[tid] + b[tid];
	}
}

/**
 * Host function that prepares data array and passes it to the CUDA kernel.
 */
int main(void) {

	int a[N],b[N],c[N];
	int *ad,*bd,*cd;

	cudaMalloc((int **)&ad,N*sizeof(int));
	cudaMalloc((int **)&bd,N*sizeof(int));
	cudaMalloc((int **)&cd,N*sizeof(int));

	for (int i=0; i<N; i++) {
		a[i] = i * 2;
		b[i] = i * 3;
	}

	printf("[");
	for (int i=0; i<N; i++) {
		printf("%d,",a[i]);
	}
	printf("]\n");
	printf("[");
	for (int i=0; i<N; i++) {
		printf("%d,",b[i]);
	}
	printf("]\n");

	cudaMemcpy(ad,&a,N*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(bd,&b,N*sizeof(int),cudaMemcpyHostToDevice);

	add<<<N,1>>>(ad,bd,cd);

	cudaMemcpy(&c,cd,N*sizeof(int),cudaMemcpyDeviceToHost);

	printf("Addition:");
	printf("[");
	for (int i=0; i<N; i++) {
			printf("%d,",c[i]);
		}
	printf("]");

	cudaFree(ad);
	cudaFree(bd);
	cudaFree(cd);

	return 0;
}
