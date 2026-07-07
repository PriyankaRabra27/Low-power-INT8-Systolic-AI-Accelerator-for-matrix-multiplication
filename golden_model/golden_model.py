class PEMacGolden:
    def __init__(self):
        self.a_out=0
        self.b_out=0
        self.acc_out=0
        self.valid_out=0
        
    def wrap32(self,x):
        x=x&0xFFFFFFFF
        if x>=2**31:
            x=x-2**32
        return x
    
    def step(self,clear,rst,enable,valid_in,a_in,b_in):
        if(rst):
            self.a_out=0
            self.b_out=0
            self.acc_out=0
            self.valid_out=0
        elif(clear):
            self.a_out=0
            self.b_out=0
            self.acc_out=0
            self.valid_out=0
        elif(enable):
            self.a_out=a_in
            self.b_out=b_in
            self.valid_out=valid_in

            active_mac=valid_in and (a_in!=0) and (b_in!=0)
            product=a_in*b_in
            if(active_mac):
                self.acc_out=self.wrap32(self.acc_out + product)
        return self.a_out, self.b_out, self.acc_out, self.valid_out          

class SystolicArray4x4Golden:
    def __init__(self):
        self.pe = [[PEMacGolden() for _ in range(4)] for _ in range(4)]
        self.prev_a_out = [[0 for _ in range(4)] for _ in range(4)]
        self.prev_b_out = [[0 for _ in range(4)] for _ in range(4)]
        self.prev_valid_out = [[0 for _ in range(4)] for _ in range(4)]


    def step(self,clear,rst,enable,valid_in,a_ext,b_ext):
        new_a_out = [[0 for _ in range(4)] for _ in range(4)]
        new_b_out = [[0 for _ in range(4)] for _ in range(4)]
        new_valid_out = [[0 for _ in range(4)] for _ in range(4)]
        c = [[0 for _ in range(4)] for _ in range(4)]
        new_a_out = [[0 for _ in range(4)] for _ in range(4)]
        new_b_out = [[0 for _ in range(4)] for _ in range(4)]
        new_valid_out = [[0 for _ in range(4)] for _ in range(4)]
        c = [[0 for _ in range(4)] for _ in range(4)]
        for i in range(4):
            for j in range(4):
                if j == 0:
                    a_in = a_ext[i]
                else:
                    a_in = self.prev_a_out[i][j-1]

                if i==0:
                    b_in = b_ext[j]
                else:
                    b_in = self.prev_b_out[i-1][j]
                
                if j>0:
                    pe_valid_in = self.prev_valid_out[i][j-1]
                elif i>0:
                    pe_valid_in = self.prev_valid_out[i-1][j]
                else:
                    pe_valid_in = valid_in

                a_o, b_o, acc_o, v_o = self.pe[i][j].step(clear, rst, enable, pe_valid_in, a_in, b_in)
                new_a_out[i][j] = a_o
                new_b_out[i][j] = b_o
                new_valid_out[i][j] = v_o
                c[i][j] = acc_o
        self.prev_a_out = new_a_out
        self.prev_b_out = new_b_out
        self.prev_valid_out = new_valid_out

        return c


    
        



             