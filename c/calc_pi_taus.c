#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <time.h>

#define NUM_BITS 31

uint32_t S0 = 0xffffffff;
uint32_t S1 = 0xcccccccc;
uint32_t S2 = 0x00ff00ff;

uint32_t gen_rand() {
    uint32_t b1, b2, b3, next_S0, next_S1, next_S2, random_out;

    b1      = (((S0 << 13) ^ S0) >> 19);
    next_S0 = (((S0 & 0xfffffffe) << 12) ^ b1);
    b2      = (((S1 << 2 ) ^ S1) >> 25);
    next_S1 = (((S1 & 0xfffffff8) << 4 ) ^ b2);
    b3      = (((S2 << 3 ) ^ S2) >> 11);
    next_S2 = (((S2 & 0xfffffff0) << 17) ^ b3);

    random_out = S0 ^ S1 ^ S2;

    S0 = next_S0;
    S1 = next_S1;
    S2 = next_S2;

    return((random_out>>1)&0x7fffffff);
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
