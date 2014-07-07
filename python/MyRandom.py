from random import randint

class MyRandom:

    NUM_BITS = 32

    def __init__(self, seed):
        self.current_val  = seed

    def gen_rand(self):
        return(0)

    def int_to_signed_int(self, ip):
        return 0-((ip^(2**self.NUM_BITS-1))+1) if (ip&(2**(self.NUM_BITS-1))) else ip

class RandomPython(MyRandom):

    NUM_BITS = 31

    def gen_rand(self):
        self.current_val = randint(0,2**self.NUM_BITS)
        return(self.current_val)


class RandomPRBS(MyRandom):

    NUM_BITS = 31

    def gen_rand(self):
        new_sr = (((self.current_val>>30)&0x1) ^ ((self.current_val>>27)&0x1))
        self.current_val = (((self.current_val << 1) + new_sr)&(2**self.NUM_BITS-1))

        return(self.current_val)

 
