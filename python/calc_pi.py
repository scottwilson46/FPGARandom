from random import randint
from math import sqrt

from MyRandom import *

circle_count = 0
total_count  = 1000000

r_prbs = RandomPRBS(2)

for i in range(total_count):
    x_int = r_prbs.gen_rand()
    y_int = r_prbs.gen_rand()
    x = float(r_prbs.int_to_signed_int(x_int))/(2**(r_prbs.NUM_BITS-1))
    y = float(r_prbs.int_to_signed_int(y_int))/(2**(r_prbs.NUM_BITS-1))

    hyp = (x**2 + y**2)
    if (hyp<=1):
        circle_count+=1
       
approx = float(circle_count)/float(total_count)
print str(approx*4.0) + " " + str(circle_count)

circle_count = 0
total_count  = 1000000

r_prbs = RandomPython(2)

for i in range(total_count):
    x = float(r_prbs.int_to_signed_int(r_prbs.gen_rand()))/(2**(r_prbs.NUM_BITS-1))
    y = float(r_prbs.int_to_signed_int(r_prbs.gen_rand()))/(2**(r_prbs.NUM_BITS-1))

    hyp = (x**2 + y**2)
    if (hyp<=1):
        circle_count+=1


approx = float(circle_count)/float(total_count)
print str(approx*4.0) + " " + str(circle_count)


