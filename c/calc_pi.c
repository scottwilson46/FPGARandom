#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <time.h>

#define NUM_BITS 31

uint32_t current_val = 2;

uint32_t gen_rand() {
    uint32_t new_sr;
    new_sr = (((current_val>>30)&0x1) ^ ((current_val>>27)&0x1));
    current_val = (((current_val << 1) + new_sr)&((2<<(NUM_BITS-1))-1));
    return(current_val);
}

int32_t int_to_signed_int(ip) {
    uint32_t new_val;
    new_val = ((ip & (1<<(NUM_BITS-1)))<<1) + ip;
    return new_val;
}

int main() {
    int32_t x,y;
    int64_t x_sq, y_sq;
    int32_t add_coord;
    uint32_t i;
    uint32_t ans;
    float pi;
    int lt_count;
    clock_t begin, end;
    double time_spent;
    begin = clock();

    for (i=0; i<1000000; i++) {
        x = int_to_signed_int(gen_rand());
        y = int_to_signed_int(gen_rand());

        x_sq = (((int64_t)x*(int64_t)x)>>NUM_BITS);
        y_sq = (((int64_t)y*(int64_t)y)>>NUM_BITS);
        
        add_coord = x_sq + y_sq;
        ans       = (add_coord>>(NUM_BITS-2))&0x1;
        if (ans==0)
            lt_count++;
    }

    pi = ((float)lt_count*(float)4)/(float)1000000;
    end = clock();
    time_spent = (double)(end-begin)/CLOCKS_PER_SEC;

    printf("time = %f, ans = %f\n", time_spent, pi);

    

    return 0;
}
